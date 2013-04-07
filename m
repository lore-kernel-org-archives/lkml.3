Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934916Ab3DGXcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:32:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46810 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934673Ab3DGXcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:32:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "nikolay@redhat.com" <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 07 Apr 2013 23:45:43 +0100
Message-ID: <lsq.1365374743.527783752@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [61/74] bonding: fix disabling of arp_interval and miimon
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "nikolay@redhat.com" <nikolay@redhat.com>

[ Upstream commit 1bc7db16782c2a581fb4d53ca853631050f31611 ]

Currently if either arp_interval or miimon is disabled, they both get
disabled, and upon disabling they get executed once more which is not
the proper behaviour. Also when doing a no-op and disabling an already
disabled one, the other again gets disabled.
Also fix the error messages with the proper valid ranges, and a small
typo fix in the up delay error message (outputting "down delay", instead
of "up delay").

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_sysfs.c | 92 +++++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 44 deletions(-)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 8d923d3..8ed48c2 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -528,7 +528,7 @@ static ssize_t bonding_store_arp_interval(struct device *d,
 		goto out;
 	}
 	if (new_value < 0) {
-		pr_err("%s: Invalid arp_interval value %d not in range 1-%d; rejected.\n",
+		pr_err("%s: Invalid arp_interval value %d not in range 0-%d; rejected.\n",
 		       bond->dev->name, new_value, INT_MAX);
 		ret = -EINVAL;
 		goto out;
@@ -543,14 +543,15 @@ static ssize_t bonding_store_arp_interval(struct device *d,
 	pr_info("%s: Setting ARP monitoring interval to %d.\n",
 		bond->dev->name, new_value);
 	bond->params.arp_interval = new_value;
-	if (bond->params.miimon) {
-		pr_info("%s: ARP monitoring cannot be used with MII monitoring. %s Disabling MII monitoring.\n",
-			bond->dev->name, bond->dev->name);
-		bond->params.miimon = 0;
-	}
-	if (!bond->params.arp_targets[0]) {
-		pr_info("%s: ARP monitoring has been set up, but no ARP targets have been specified.\n",
-			bond->dev->name);
+	if (new_value) {
+		if (bond->params.miimon) {
+			pr_info("%s: ARP monitoring cannot be used with MII monitoring. %s Disabling MII monitoring.\n",
+				bond->dev->name, bond->dev->name);
+			bond->params.miimon = 0;
+		}
+		if (!bond->params.arp_targets[0])
+			pr_info("%s: ARP monitoring has been set up, but no ARP targets have been specified.\n",
+				bond->dev->name);
 	}
 	if (bond->dev->flags & IFF_UP) {
 		/* If the interface is up, we may need to fire off
@@ -558,10 +559,13 @@ static ssize_t bonding_store_arp_interval(struct device *d,
 		 * timer will get fired off when the open function
 		 * is called.
 		 */
-		cancel_delayed_work_sync(&bond->mii_work);
-		queue_delayed_work(bond->wq, &bond->arp_work, 0);
+		if (!new_value) {
+			cancel_delayed_work_sync(&bond->arp_work);
+		} else {
+			cancel_delayed_work_sync(&bond->mii_work);
+			queue_delayed_work(bond->wq, &bond->arp_work, 0);
+		}
 	}
-
 out:
 	rtnl_unlock();
 	return ret;
@@ -703,7 +707,7 @@ static ssize_t bonding_store_downdelay(struct device *d,
 	}
 	if (new_value < 0) {
 		pr_err("%s: Invalid down delay value %d not in range %d-%d; rejected.\n",
-		       bond->dev->name, new_value, 1, INT_MAX);
+		       bond->dev->name, new_value, 0, INT_MAX);
 		ret = -EINVAL;
 		goto out;
 	} else {
@@ -758,8 +762,8 @@ static ssize_t bonding_store_updelay(struct device *d,
 		goto out;
 	}
 	if (new_value < 0) {
-		pr_err("%s: Invalid down delay value %d not in range %d-%d; rejected.\n",
-		       bond->dev->name, new_value, 1, INT_MAX);
+		pr_err("%s: Invalid up delay value %d not in range %d-%d; rejected.\n",
+		       bond->dev->name, new_value, 0, INT_MAX);
 		ret = -EINVAL;
 		goto out;
 	} else {
@@ -969,37 +973,37 @@ static ssize_t bonding_store_miimon(struct device *d,
 	}
 	if (new_value < 0) {
 		pr_err("%s: Invalid miimon value %d not in range %d-%d; rejected.\n",
-		       bond->dev->name, new_value, 1, INT_MAX);
+		       bond->dev->name, new_value, 0, INT_MAX);
 		ret = -EINVAL;
 		goto out;
-	} else {
-		pr_info("%s: Setting MII monitoring interval to %d.\n",
-			bond->dev->name, new_value);
-		bond->params.miimon = new_value;
-		if (bond->params.updelay)
-			pr_info("%s: Note: Updating updelay (to %d) since it is a multiple of the miimon value.\n",
-				bond->dev->name,
-				bond->params.updelay * bond->params.miimon);
-		if (bond->params.downdelay)
-			pr_info("%s: Note: Updating downdelay (to %d) since it is a multiple of the miimon value.\n",
-				bond->dev->name,
-				bond->params.downdelay * bond->params.miimon);
-		if (bond->params.arp_interval) {
-			pr_info("%s: MII monitoring cannot be used with ARP monitoring. Disabling ARP monitoring...\n",
-				bond->dev->name);
-			bond->params.arp_interval = 0;
-			if (bond->params.arp_validate) {
-				bond->params.arp_validate =
-					BOND_ARP_VALIDATE_NONE;
-			}
-		}
-
-		if (bond->dev->flags & IFF_UP) {
-			/* If the interface is up, we may need to fire off
-			 * the MII timer. If the interface is down, the
-			 * timer will get fired off when the open function
-			 * is called.
-			 */
+	}
+	pr_info("%s: Setting MII monitoring interval to %d.\n",
+		bond->dev->name, new_value);
+	bond->params.miimon = new_value;
+	if (bond->params.updelay)
+		pr_info("%s: Note: Updating updelay (to %d) since it is a multiple of the miimon value.\n",
+			bond->dev->name,
+			bond->params.updelay * bond->params.miimon);
+	if (bond->params.downdelay)
+		pr_info("%s: Note: Updating downdelay (to %d) since it is a multiple of the miimon value.\n",
+			bond->dev->name,
+			bond->params.downdelay * bond->params.miimon);
+	if (new_value && bond->params.arp_interval) {
+		pr_info("%s: MII monitoring cannot be used with ARP monitoring. Disabling ARP monitoring...\n",
+			bond->dev->name);
+		bond->params.arp_interval = 0;
+		if (bond->params.arp_validate)
+			bond->params.arp_validate = BOND_ARP_VALIDATE_NONE;
+	}
+	if (bond->dev->flags & IFF_UP) {
+		/* If the interface is up, we may need to fire off
+		 * the MII timer. If the interface is down, the
+		 * timer will get fired off when the open function
+		 * is called.
+		 */
+		if (!new_value) {
+			cancel_delayed_work_sync(&bond->mii_work);
+		} else {
 			cancel_delayed_work_sync(&bond->arp_work);
 			queue_delayed_work(bond->wq, &bond->mii_work, 0);
 		}

