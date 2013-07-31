Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001Ab3GaN3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:29:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47044 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759809Ab3GaN0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chen Weilong" <chenweilong@huawei.com>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        "dingtianhong" <dingtianhong@huawei.com>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Amerigo Wang" <amwang@redhat.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.986549793@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [10/84] ipv6,mcast: always hold idev->lock before mca_lock
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Amerigo Wang <amwang@redhat.com>

[ Upstream commit 8965779d2c0e6ab246c82a405236b1fb2adae6b2, with
  some bits from commit b7b1bfce0bb68bd8f6e62a28295922785cc63781
  ("ipv6: split duplicate address detection and router solicitation timer")
  to get the __ipv6_get_lladdr() used by this patch. ]

dingtianhong reported the following deadlock detected by lockdep:

 ======================================================
 [ INFO: possible circular locking dependency detected ]
 3.4.24.05-0.1-default #1 Not tainted
 -------------------------------------------------------
 ksoftirqd/0/3 is trying to acquire lock:
  (&ndev->lock){+.+...}, at: [<ffffffff8147f804>] ipv6_get_lladdr+0x74/0x120

 but task is already holding lock:
  (&mc->mca_lock){+.+...}, at: [<ffffffff8149d130>] mld_send_report+0x40/0x150

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (&mc->mca_lock){+.+...}:
        [<ffffffff810a8027>] validate_chain+0x637/0x730
        [<ffffffff810a8417>] __lock_acquire+0x2f7/0x500
        [<ffffffff810a8734>] lock_acquire+0x114/0x150
        [<ffffffff814f691a>] rt_spin_lock+0x4a/0x60
        [<ffffffff8149e4bb>] igmp6_group_added+0x3b/0x120
        [<ffffffff8149e5d8>] ipv6_mc_up+0x38/0x60
        [<ffffffff81480a4d>] ipv6_find_idev+0x3d/0x80
        [<ffffffff81483175>] addrconf_notify+0x3d5/0x4b0
        [<ffffffff814fae3f>] notifier_call_chain+0x3f/0x80
        [<ffffffff81073471>] raw_notifier_call_chain+0x11/0x20
        [<ffffffff813d8722>] call_netdevice_notifiers+0x32/0x60
        [<ffffffff813d92d4>] __dev_notify_flags+0x34/0x80
        [<ffffffff813d9360>] dev_change_flags+0x40/0x70
        [<ffffffff813ea627>] do_setlink+0x237/0x8a0
        [<ffffffff813ebb6c>] rtnl_newlink+0x3ec/0x600
        [<ffffffff813eb4d0>] rtnetlink_rcv_msg+0x160/0x310
        [<ffffffff814040b9>] netlink_rcv_skb+0x89/0xb0
        [<ffffffff813eb357>] rtnetlink_rcv+0x27/0x40
        [<ffffffff81403e20>] netlink_unicast+0x140/0x180
        [<ffffffff81404a9e>] netlink_sendmsg+0x33e/0x380
        [<ffffffff813c4252>] sock_sendmsg+0x112/0x130
        [<ffffffff813c537e>] __sys_sendmsg+0x44e/0x460
        [<ffffffff813c5544>] sys_sendmsg+0x44/0x70
        [<ffffffff814feab9>] system_call_fastpath+0x16/0x1b

 -> #0 (&ndev->lock){+.+...}:
        [<ffffffff810a798e>] check_prev_add+0x3de/0x440
        [<ffffffff810a8027>] validate_chain+0x637/0x730
        [<ffffffff810a8417>] __lock_acquire+0x2f7/0x500
        [<ffffffff810a8734>] lock_acquire+0x114/0x150
        [<ffffffff814f6c82>] rt_read_lock+0x42/0x60
        [<ffffffff8147f804>] ipv6_get_lladdr+0x74/0x120
        [<ffffffff8149b036>] mld_newpack+0xb6/0x160
        [<ffffffff8149b18b>] add_grhead+0xab/0xc0
        [<ffffffff8149d03b>] add_grec+0x3ab/0x460
        [<ffffffff8149d14a>] mld_send_report+0x5a/0x150
        [<ffffffff8149f99e>] igmp6_timer_handler+0x4e/0xb0
        [<ffffffff8105705a>] call_timer_fn+0xca/0x1d0
        [<ffffffff81057b9f>] run_timer_softirq+0x1df/0x2e0
        [<ffffffff8104e8c7>] handle_pending_softirqs+0xf7/0x1f0
        [<ffffffff8104ea3b>] __do_softirq_common+0x7b/0xf0
        [<ffffffff8104f07f>] __thread_do_softirq+0x1af/0x210
        [<ffffffff8104f1c1>] run_ksoftirqd+0xe1/0x1f0
        [<ffffffff8106c7de>] kthread+0xae/0xc0
        [<ffffffff814fff74>] kernel_thread_helper+0x4/0x10

actually we can just hold idev->lock before taking pmc->mca_lock,
and avoid taking idev->lock again when iterating idev->addr_list,
since the upper callers of mld_newpack() already take
read_lock_bh(&idev->lock).

Reported-by: dingtianhong <dingtianhong@huawei.com>
Cc: dingtianhong <dingtianhong@huawei.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Tested-by: Ding Tianhong <dingtianhong@huawei.com>
Tested-by: Chen Weilong <chenweilong@huawei.com>
Signed-off-by: Cong Wang <amwang@redhat.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/addrconf.h |  3 +++
 net/ipv6/addrconf.c    | 28 ++++++++++++++++++----------
 net/ipv6/mcast.c       | 18 ++++++++++--------
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index cbc6bb0..44b1110 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -81,6 +81,9 @@ extern int			ipv6_dev_get_saddr(struct net *net,
 					       const struct in6_addr *daddr,
 					       unsigned int srcprefs,
 					       struct in6_addr *saddr);
+extern int			__ipv6_get_lladdr(struct inet6_dev *idev,
+						  struct in6_addr *addr,
+						  unsigned char banned_flags);
 extern int			ipv6_get_lladdr(struct net_device *dev,
 						struct in6_addr *addr,
 						unsigned char banned_flags);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index a7fe50f..314bda2 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1236,6 +1236,23 @@ try_nextdev:
 }
 EXPORT_SYMBOL(ipv6_dev_get_saddr);
 
+int __ipv6_get_lladdr(struct inet6_dev *idev, struct in6_addr *addr,
+		      unsigned char banned_flags)
+{
+	struct inet6_ifaddr *ifp;
+	int err = -EADDRNOTAVAIL;
+
+	list_for_each_entry(ifp, &idev->addr_list, if_list) {
+		if (ifp->scope == IFA_LINK &&
+		    !(ifp->flags & banned_flags)) {
+			ipv6_addr_copy(addr, &ifp->addr);
+			err = 0;
+			break;
+		}
+	}
+	return err;
+}
+
 int ipv6_get_lladdr(struct net_device *dev, struct in6_addr *addr,
 		    unsigned char banned_flags)
 {
@@ -1245,17 +1262,8 @@ int ipv6_get_lladdr(struct net_device *dev, struct in6_addr *addr,
 	rcu_read_lock();
 	idev = __in6_dev_get(dev);
 	if (idev) {
-		struct inet6_ifaddr *ifp;
-
 		read_lock_bh(&idev->lock);
-		list_for_each_entry(ifp, &idev->addr_list, if_list) {
-			if (ifp->scope == IFA_LINK &&
-			    !(ifp->flags & banned_flags)) {
-				ipv6_addr_copy(addr, &ifp->addr);
-				err = 0;
-				break;
-			}
-		}
+		err = __ipv6_get_lladdr(idev, addr, banned_flags);
 		read_unlock_bh(&idev->lock);
 	}
 	rcu_read_unlock();
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index f2d74ea..c7ec4bb 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1334,8 +1334,9 @@ mld_scount(struct ifmcaddr6 *pmc, int type, int gdeleted, int sdeleted)
 	return scount;
 }
 
-static struct sk_buff *mld_newpack(struct net_device *dev, int size)
+static struct sk_buff *mld_newpack(struct inet6_dev *idev, int size)
 {
+	struct net_device *dev = idev->dev;
 	struct net *net = dev_net(dev);
 	struct sock *sk = net->ipv6.igmp_sk;
 	struct sk_buff *skb;
@@ -1358,7 +1359,7 @@ static struct sk_buff *mld_newpack(struct net_device *dev, int size)
 
 	skb_reserve(skb, LL_RESERVED_SPACE(dev));
 
-	if (ipv6_get_lladdr(dev, &addr_buf, IFA_F_TENTATIVE)) {
+	if (__ipv6_get_lladdr(idev, &addr_buf, IFA_F_TENTATIVE)) {
 		/* <draft-ietf-magma-mld-source-05.txt>:
 		 * use unspecified address as the source address
 		 * when a valid link-local address is not available.
@@ -1461,7 +1462,7 @@ static struct sk_buff *add_grhead(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 	struct mld2_grec *pgr;
 
 	if (!skb)
-		skb = mld_newpack(dev, dev->mtu);
+		skb = mld_newpack(pmc->idev, dev->mtu);
 	if (!skb)
 		return NULL;
 	pgr = (struct mld2_grec *)skb_put(skb, sizeof(struct mld2_grec));
@@ -1481,7 +1482,8 @@ static struct sk_buff *add_grhead(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 	int type, int gdeleted, int sdeleted)
 {
-	struct net_device *dev = pmc->idev->dev;
+	struct inet6_dev *idev = pmc->idev;
+	struct net_device *dev = idev->dev;
 	struct mld2_report *pmr;
 	struct mld2_grec *pgr = NULL;
 	struct ip6_sf_list *psf, *psf_next, *psf_prev, **psf_list;
@@ -1510,7 +1512,7 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 		    AVAILABLE(skb) < grec_size(pmc, type, gdeleted, sdeleted)) {
 			if (skb)
 				mld_sendpack(skb);
-			skb = mld_newpack(dev, dev->mtu);
+			skb = mld_newpack(idev, dev->mtu);
 		}
 	}
 	first = 1;
@@ -1537,7 +1539,7 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 				pgr->grec_nsrcs = htons(scount);
 			if (skb)
 				mld_sendpack(skb);
-			skb = mld_newpack(dev, dev->mtu);
+			skb = mld_newpack(idev, dev->mtu);
 			first = 1;
 			scount = 0;
 		}
@@ -1592,8 +1594,8 @@ static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *pmc)
 	struct sk_buff *skb = NULL;
 	int type;
 
+	read_lock_bh(&idev->lock);
 	if (!pmc) {
-		read_lock_bh(&idev->lock);
 		for (pmc=idev->mc_list; pmc; pmc=pmc->next) {
 			if (pmc->mca_flags & MAF_NOREPORT)
 				continue;
@@ -1605,7 +1607,6 @@ static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *pmc)
 			skb = add_grec(skb, pmc, type, 0, 0);
 			spin_unlock_bh(&pmc->mca_lock);
 		}
-		read_unlock_bh(&idev->lock);
 	} else {
 		spin_lock_bh(&pmc->mca_lock);
 		if (pmc->mca_sfcount[MCAST_EXCLUDE])
@@ -1615,6 +1616,7 @@ static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *pmc)
 		skb = add_grec(skb, pmc, type, 0, 0);
 		spin_unlock_bh(&pmc->mca_lock);
 	}
+	read_unlock_bh(&idev->lock);
 	if (skb)
 		mld_sendpack(skb);
 }

