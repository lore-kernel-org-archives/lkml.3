Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936429Ab3DKVVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:21:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935439Ab3DKUsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:50 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=apWo1XQ7HtUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=viec5kISxvoA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=J1Y8HTJGAAAA:8 a=hBYl8KMBYEmI18Co6pgA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202611.832419254@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nikolay Aleksandrov <nikolay@redhat.com>, Jay Vosburgh <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 156/171 ] bonding: fix miimon and arp_interval delayed work race conditions
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0156-bonding-fix-miimon-and-arp_interval-delayed-work-rac.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "nikolay@redhat.com" <nikolay@redhat.com>

[ Upstream commit fbb0c41b814d497c656fc7be9e35456f139cb2fb ]

First I would give three observations which will be used later.
Observation 1: if (delayed_work_pending(wq)) cancel_delayed_work(wq)
 This usage is wrong because the pending bit is cleared just before the
 work's fn is executed and if the function re-arms itself we might end up
 with the work still running. It's safe to call cancel_delayed_work_sync()
 even if the work is not queued at all.
Observation 2: Use of INIT_DELAYED_WORK()
 Work needs to be initialized only once prior to (de/en)queueing.
Observation 3: IFF_UP is set only after ndo_open is called

Related race conditions:
1. Race between bonding_store_miimon() and bonding_store_arp_interval()
 Because of Obs.1 we can end up having both works enqueued.
2. Multiple races with INIT_DELAYED_WORK()
 Since the works are not protected by anything between INIT_DELAYED_WORK()
 and calls to (en/de)queue it is possible for races between the following
 functions:
 (races are also possible between the calls to INIT_DELAYED_WORK()
  and workqueue code)
 bonding_store_miimon() - bonding_store_arp_interval(), bond_close(),
			  bond_open(), enqueued functions
 bonding_store_arp_interval() - bonding_store_miimon(), bond_close(),
				bond_open(), enqueued functions
3. By Obs.1 we need to change bond_cancel_all()

Bugs 1 and 2 are fixed by moving all work initializations in bond_open
which by Obs. 2 and Obs. 3 and the fact that we make sure that all works
are cancelled in bond_close(), is guaranteed not to have any work
enqueued.
Also RTNL lock is now acquired in bonding_store_miimon/arp_interval so
they can't race with bond_close and bond_open. The opposing work is
cancelled only if the IFF_UP flag is set and it is cancelled
unconditionally. The opposing work is already cancelled if the interface
is down so no need to cancel it again. This way we don't need new
synchronizations for the bonding workqueue. These bugs (and fixes) are
tied together and belong in the same patch.
Note: I have left 1 line intentionally over 80 characters (84) because I
      didn't like how it looks broken down. If you'd prefer it otherwise,
      then simply break it.

 v2: Make description text < 75 columns

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/bonding/bond_main.c  |   88 +++++++++++---------------------------
 drivers/net/bonding/bond_sysfs.c |   34 +++++----------
 2 files changed, 36 insertions(+), 86 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 704d0ad..a9a07ce 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3411,6 +3411,28 @@ static int bond_xmit_hash_policy_l2(struct sk_buff *skb, int count)
 
 /*-------------------------- Device entry points ----------------------------*/
 
+static void bond_work_init_all(struct bonding *bond)
+{
+	INIT_DELAYED_WORK(&bond->mcast_work,
+			  bond_resend_igmp_join_requests_delayed);
+	INIT_DELAYED_WORK(&bond->alb_work, bond_alb_monitor);
+	INIT_DELAYED_WORK(&bond->mii_work, bond_mii_monitor);
+	if (bond->params.mode == BOND_MODE_ACTIVEBACKUP)
+		INIT_DELAYED_WORK(&bond->arp_work, bond_activebackup_arp_mon);
+	else
+		INIT_DELAYED_WORK(&bond->arp_work, bond_loadbalance_arp_mon);
+	INIT_DELAYED_WORK(&bond->ad_work, bond_3ad_state_machine_handler);
+}
+
+static void bond_work_cancel_all(struct bonding *bond)
+{
+	cancel_delayed_work_sync(&bond->mii_work);
+	cancel_delayed_work_sync(&bond->arp_work);
+	cancel_delayed_work_sync(&bond->alb_work);
+	cancel_delayed_work_sync(&bond->ad_work);
+	cancel_delayed_work_sync(&bond->mcast_work);
+}
+
 static int bond_open(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
@@ -3433,41 +3455,27 @@ static int bond_open(struct net_device *bond_dev)
 	}
 	read_unlock(&bond->lock);
 
-	INIT_DELAYED_WORK(&bond->mcast_work, bond_resend_igmp_join_requests_delayed);
+	bond_work_init_all(bond);
 
 	if (bond_is_lb(bond)) {
 		/* bond_alb_initialize must be called before the timer
 		 * is started.
 		 */
-		if (bond_alb_initialize(bond, (bond->params.mode == BOND_MODE_ALB))) {
-			/* something went wrong - fail the open operation */
+		if (bond_alb_initialize(bond, (bond->params.mode == BOND_MODE_ALB)))
 			return -ENOMEM;
-		}
-
-		INIT_DELAYED_WORK(&bond->alb_work, bond_alb_monitor);
 		queue_delayed_work(bond->wq, &bond->alb_work, 0);
 	}
 
-	if (bond->params.miimon) {  /* link check interval, in milliseconds. */
-		INIT_DELAYED_WORK(&bond->mii_work, bond_mii_monitor);
+	if (bond->params.miimon)  /* link check interval, in milliseconds. */
 		queue_delayed_work(bond->wq, &bond->mii_work, 0);
-	}
 
 	if (bond->params.arp_interval) {  /* arp interval, in milliseconds. */
-		if (bond->params.mode == BOND_MODE_ACTIVEBACKUP)
-			INIT_DELAYED_WORK(&bond->arp_work,
-					  bond_activebackup_arp_mon);
-		else
-			INIT_DELAYED_WORK(&bond->arp_work,
-					  bond_loadbalance_arp_mon);
-
 		queue_delayed_work(bond->wq, &bond->arp_work, 0);
 		if (bond->params.arp_validate)
 			bond->recv_probe = bond_arp_rcv;
 	}
 
 	if (bond->params.mode == BOND_MODE_8023AD) {
-		INIT_DELAYED_WORK(&bond->ad_work, bond_3ad_state_machine_handler);
 		queue_delayed_work(bond->wq, &bond->ad_work, 0);
 		/* register to receive LACPDUs */
 		bond->recv_probe = bond_3ad_lacpdu_recv;
@@ -3482,34 +3490,10 @@ static int bond_close(struct net_device *bond_dev)
 	struct bonding *bond = netdev_priv(bond_dev);
 
 	write_lock_bh(&bond->lock);
-
 	bond->send_peer_notif = 0;
-
 	write_unlock_bh(&bond->lock);
 
-	if (bond->params.miimon) {  /* link check interval, in milliseconds. */
-		cancel_delayed_work_sync(&bond->mii_work);
-	}
-
-	if (bond->params.arp_interval) {  /* arp interval, in milliseconds. */
-		cancel_delayed_work_sync(&bond->arp_work);
-	}
-
-	switch (bond->params.mode) {
-	case BOND_MODE_8023AD:
-		cancel_delayed_work_sync(&bond->ad_work);
-		break;
-	case BOND_MODE_TLB:
-	case BOND_MODE_ALB:
-		cancel_delayed_work_sync(&bond->alb_work);
-		break;
-	default:
-		break;
-	}
-
-	if (delayed_work_pending(&bond->mcast_work))
-		cancel_delayed_work_sync(&bond->mcast_work);
-
+	bond_work_cancel_all(bond);
 	if (bond_is_lb(bond)) {
 		/* Must be called only after all
 		 * slaves have been released
@@ -4388,26 +4372,6 @@ static void bond_setup(struct net_device *bond_dev)
 	bond_dev->features |= bond_dev->hw_features;
 }
 
-static void bond_work_cancel_all(struct bonding *bond)
-{
-	if (bond->params.miimon && delayed_work_pending(&bond->mii_work))
-		cancel_delayed_work_sync(&bond->mii_work);
-
-	if (bond->params.arp_interval && delayed_work_pending(&bond->arp_work))
-		cancel_delayed_work_sync(&bond->arp_work);
-
-	if (bond->params.mode == BOND_MODE_ALB &&
-	    delayed_work_pending(&bond->alb_work))
-		cancel_delayed_work_sync(&bond->alb_work);
-
-	if (bond->params.mode == BOND_MODE_8023AD &&
-	    delayed_work_pending(&bond->ad_work))
-		cancel_delayed_work_sync(&bond->ad_work);
-
-	if (delayed_work_pending(&bond->mcast_work))
-		cancel_delayed_work_sync(&bond->mcast_work);
-}
-
 /*
 * Destroy a bonding device.
 * Must be under rtnl_lock when this function is called.
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index ecd47a3..13e37cc 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -518,6 +518,8 @@ static ssize_t bonding_store_arp_interval(struct device *d,
 	int new_value, ret = count;
 	struct bonding *bond = to_bond(d);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
 	if (sscanf(buf, "%d", &new_value) != 1) {
 		pr_err("%s: no arp_interval value specified.\n",
 		       bond->dev->name);
@@ -544,10 +546,6 @@ static ssize_t bonding_store_arp_interval(struct device *d,
 		pr_info("%s: ARP monitoring cannot be used with MII monitoring. %s Disabling MII monitoring.\n",
 			bond->dev->name, bond->dev->name);
 		bond->params.miimon = 0;
-		if (delayed_work_pending(&bond->mii_work)) {
-			cancel_delayed_work(&bond->mii_work);
-			flush_workqueue(bond->wq);
-		}
 	}
 	if (!bond->params.arp_targets[0]) {
 		pr_info("%s: ARP monitoring has been set up, but no ARP targets have been specified.\n",
@@ -559,19 +557,12 @@ static ssize_t bonding_store_arp_interval(struct device *d,
 		 * timer will get fired off when the open function
 		 * is called.
 		 */
-		if (!delayed_work_pending(&bond->arp_work)) {
-			if (bond->params.mode == BOND_MODE_ACTIVEBACKUP)
-				INIT_DELAYED_WORK(&bond->arp_work,
-						  bond_activebackup_arp_mon);
-			else
-				INIT_DELAYED_WORK(&bond->arp_work,
-						  bond_loadbalance_arp_mon);
-
-			queue_delayed_work(bond->wq, &bond->arp_work, 0);
-		}
+		cancel_delayed_work_sync(&bond->mii_work);
+		queue_delayed_work(bond->wq, &bond->arp_work, 0);
 	}
 
 out:
+	rtnl_unlock();
 	return ret;
 }
 static DEVICE_ATTR(arp_interval, S_IRUGO | S_IWUSR,
@@ -967,6 +958,8 @@ static ssize_t bonding_store_miimon(struct device *d,
 	int new_value, ret = count;
 	struct bonding *bond = to_bond(d);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
 	if (sscanf(buf, "%d", &new_value) != 1) {
 		pr_err("%s: no miimon value specified.\n",
 		       bond->dev->name);
@@ -998,10 +991,6 @@ static ssize_t bonding_store_miimon(struct device *d,
 				bond->params.arp_validate =
 					BOND_ARP_VALIDATE_NONE;
 			}
-			if (delayed_work_pending(&bond->arp_work)) {
-				cancel_delayed_work(&bond->arp_work);
-				flush_workqueue(bond->wq);
-			}
 		}
 
 		if (bond->dev->flags & IFF_UP) {
@@ -1010,15 +999,12 @@ static ssize_t bonding_store_miimon(struct device *d,
 			 * timer will get fired off when the open function
 			 * is called.
 			 */
-			if (!delayed_work_pending(&bond->mii_work)) {
-				INIT_DELAYED_WORK(&bond->mii_work,
-						  bond_mii_monitor);
-				queue_delayed_work(bond->wq,
-						   &bond->mii_work, 0);
-			}
+			cancel_delayed_work_sync(&bond->arp_work);
+			queue_delayed_work(bond->wq, &bond->mii_work, 0);
 		}
 	}
 out:
+	rtnl_unlock();
 	return ret;
 }
 static DEVICE_ATTR(miimon, S_IRUGO | S_IWUSR,
-- 
1.7.10.4


