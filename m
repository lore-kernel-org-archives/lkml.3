Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936251Ab3DHKGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:06:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42911 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935805Ab3DHJwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 068/102] bonding: fix disabling of arp_interval and miimon
Date: Mon,  8 Apr 2013 10:50:23 +0100
Message-Id: <1365414657-29191-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "nikolay@redhat.com" <nikolay@redhat.com>

commit 1bc7db16782c2a581fb4d53ca853631050f31611 upstream.

Currently if either arp_interval or miimon is disabled, they both get
disabled, and upon disabling they get executed once more which is not
the proper behaviour. Also when doing a no-op and disabling an already
disabled one, the other again gets disabled.
Also fix the error messages with the proper valid ranges, and a small
typo fix in the up delay error message (outputting "down delay", instead
of "up delay").

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/bonding/bond_sysfs.c | 92 +++++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 44 deletions(-)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 1e2ad41..ed4f9e5 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -527,7 +527,7 @@ static ssize_t bonding_store_arp_interval(struct device *d,
 		goto out;
 	}
 	if (new_value < 0) {
-		pr_err("%s: Invalid arp_interval value %d not in range 1-%d; rejected.\n",
+		pr_err("%s: Invalid arp_interval value %d not in range 0-%d; rejected.\n",
 		       bond->dev->name, new_value, INT_MAX);
 		ret = -EINVAL;
 		goto out;
@@ -542,14 +542,15 @@ static ssize_t bonding_store_arp_interval(struct device *d,
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
@@ -557,10 +558,13 @@ static ssize_t bonding_store_arp_interval(struct device *d,
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
@@ -702,7 +706,7 @@ static ssize_t bonding_store_downdelay(struct device *d,
 	}
 	if (new_value < 0) {
 		pr_err("%s: Invalid down delay value %d not in range %d-%d; rejected.\n",
-		       bond->dev->name, new_value, 1, INT_MAX);
+		       bond->dev->name, new_value, 0, INT_MAX);
 		ret = -EINVAL;
 		goto out;
 	} else {
@@ -757,8 +761,8 @@ static ssize_t bonding_store_updelay(struct device *d,
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
@@ -968,37 +972,37 @@ static ssize_t bonding_store_miimon(struct device *d,
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
-- 
1.8.1.2

