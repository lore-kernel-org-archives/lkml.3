Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaKJAcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 19:32:52 -0500
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:34311 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751268AbaKJAcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 19:32:50 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:966:968:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1544:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:2898:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:4250:4321:4385:4605:5007:6119:6261:10004:10394:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12555:12679:13972:14093:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: salt62_52c471f67be5b
X-Filterd-Recvd-Size: 4833
Message-ID: <1415579566.23530.47.camel@perches.com>
Subject: [PATCH net-next] dsa: Use netdev_<level> instead of printk
From: Joe Perches <joe@perches.com>
To: netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Date: Sun, 09 Nov 2014 16:32:46 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neaten and standardize the logging output.

Other miscellanea:

o Use pr_notice_once instead of a guard flag.
o Convert existing pr_<level> uses too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/dsa/dsa.c   | 28 ++++++++++++----------------
 net/dsa/slave.c | 10 +++++-----
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index dd646a8..4648f12 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -192,12 +192,12 @@ dsa_switch_setup(struct dsa_switch_tree *dst, int index,
 	 */
 	drv = dsa_switch_probe(host_dev, pd->sw_addr, &name);
 	if (drv == NULL) {
-		printk(KERN_ERR "%s[%d]: could not detect attached switch\n",
-		       dst->master_netdev->name, index);
+		netdev_err(dst->master_netdev, "[%d]: could not detect attached switch\n",
+			   index);
 		return ERR_PTR(-EINVAL);
 	}
-	printk(KERN_INFO "%s[%d]: detected a %s switch\n",
-		dst->master_netdev->name, index, name);
+	netdev_info(dst->master_netdev, "[%d]: detected a %s switch\n",
+		    index, name);
 
 
 	/*
@@ -225,7 +225,8 @@ dsa_switch_setup(struct dsa_switch_tree *dst, int index,
 
 		if (!strcmp(name, "cpu")) {
 			if (dst->cpu_switch != -1) {
-				printk(KERN_ERR "multiple cpu ports?!\n");
+				netdev_err(dst->master_netdev,
+					   "multiple cpu ports?!\n");
 				ret = -EINVAL;
 				goto out;
 			}
@@ -320,10 +321,8 @@ dsa_switch_setup(struct dsa_switch_tree *dst, int index,
 
 		slave_dev = dsa_slave_create(ds, parent, i, pd->port_names[i]);
 		if (slave_dev == NULL) {
-			printk(KERN_ERR "%s[%d]: can't create dsa "
-			       "slave device for port %d(%s)\n",
-			       dst->master_netdev->name,
-			       index, i, pd->port_names[i]);
+			netdev_err(dst->master_netdev, "[%d]: can't create dsa slave device for port %d(%s)\n",
+				   index, i, pd->port_names[i]);
 			continue;
 		}
 
@@ -701,15 +700,13 @@ static inline void dsa_of_remove(struct platform_device *pdev)
 
 static int dsa_probe(struct platform_device *pdev)
 {
-	static int dsa_version_printed;
 	struct dsa_platform_data *pd = pdev->dev.platform_data;
 	struct net_device *dev;
 	struct dsa_switch_tree *dst;
 	int i, ret;
 
-	if (!dsa_version_printed++)
-		printk(KERN_NOTICE "Distributed Switch Architecture "
-			"driver version %s\n", dsa_driver_version);
+	pr_notice_once("Distributed Switch Architecture driver version %s\n",
+		       dsa_driver_version);
 
 	if (pdev->dev.of_node) {
 		ret = dsa_of_probe(pdev);
@@ -753,9 +750,8 @@ static int dsa_probe(struct platform_device *pdev)
 
 		ds = dsa_switch_setup(dst, i, &pdev->dev, pd->chip[i].host_dev);
 		if (IS_ERR(ds)) {
-			printk(KERN_ERR "%s[%d]: couldn't create dsa switch "
-				"instance (error %ld)\n", dev->name, i,
-				PTR_ERR(ds));
+			netdev_err(dev, "[%d]: couldn't create dsa switch instance (error %ld)\n",
+				   i, PTR_ERR(ds));
 			continue;
 		}
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 0ea466d..528380a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -532,7 +532,7 @@ static void dsa_slave_phy_setup(struct dsa_slave_priv *p,
 		 */
 		ret = of_phy_register_fixed_link(port_dn);
 		if (ret) {
-			pr_err("failed to register fixed PHY\n");
+			netdev_err(slave_dev, "failed to register fixed PHY\n");
 			return;
 		}
 		phy_is_fixed = true;
@@ -558,8 +558,8 @@ static void dsa_slave_phy_setup(struct dsa_slave_priv *p,
 		phy_connect_direct(slave_dev, p->phy, dsa_slave_adjust_link,
 				   p->phy_interface);
 	} else {
-		pr_info("attached PHY at address %d [%s]\n",
-			p->phy->addr, p->phy->drv->name);
+		netdev_info(slave_dev, "attached PHY at address %d [%s]\n",
+			    p->phy->addr, p->phy->drv->name);
 	}
 }
 
@@ -657,8 +657,8 @@ dsa_slave_create(struct dsa_switch *ds, struct device *parent,
 
 	ret = register_netdev(slave_dev);
 	if (ret) {
-		printk(KERN_ERR "%s: error %d registering interface %s\n",
-				master->name, ret, slave_dev->name);
+		netdev_err(master, "error %d registering interface %s\n",
+			   ret, slave_dev->name);
 		free_netdev(slave_dev);
 		return NULL;
 	}


