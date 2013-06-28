Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3F1TbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:31:20 -0400
Received: from mxout1.idt.com ([157.165.5.25]:42267 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab3F1TbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:31:13 -0400
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jun 2013 15:30:57 EDT
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andre van Herk <andre.van.herk@Prodrive.nl>,
        Micha Nelissen <micha.nelissen@Prodrive.nl>,
        Stef van Os <stef.van.os@Prodrive.nl>, Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 2/7] rapidio/rionet: rework driver initialization and removal
Date: Fri, 28 Jun 2013 15:18:51 -0400
Message-Id: <1372447136-5751-3-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1372447136-5751-1-git-send-email-alexandre.bounine@idt.com>
References: <1372447136-5751-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework probe/remove routines to prevent rionet driver from monopolizing
target RapidIO devices. Fix conflict with modular RapidIO switch drivers.

Using one of RapidIO messaging channels rionet driver provides a service layer
common to all endpoint devices in a system's RapidIO network. These devices may
also require their own specific device driver which will be blocked from
attaching to the target device by rionet (or block rionet if loaded earlier).
To avoid conflict with device-specific drivers, the rionet driver is reworked
to be registered as a subsystem interface on the RapidIO bus.

The reworked rio_remove_dev() and rionet_exit() routines also include handling
of individual rionet peer device removal which was not supported before.    

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Cc: Stef van Os <stef.van.os@Prodrive.nl>
Cc: Jean Delvare <jdelvare@suse.de>
---
 drivers/net/rionet.c |  103 +++++++++++++++++++++++++++++++++++++------------
 1 files changed, 78 insertions(+), 25 deletions(-)

diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index f433b59..6d1f6ed 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -208,6 +208,17 @@ static int rionet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		if (nets[rnet->mport->id].active[destid])
 			rionet_queue_tx_msg(skb, ndev,
 					nets[rnet->mport->id].active[destid]);
+		else {
+			/*
+			 * If the target device was removed from the list of
+			 * active peers but we still have TX packets targeting
+			 * it just report sending a packet to the target
+			 * (without actual packet transfer).
+			 */
+			dev_kfree_skb_any(skb);
+			ndev->stats.tx_packets++;
+			ndev->stats.tx_bytes += skb->len;
+		}
 	}
 
 	spin_unlock_irqrestore(&rnet->tx_lock, flags);
@@ -385,24 +396,28 @@ static int rionet_close(struct net_device *ndev)
 	return 0;
 }
 
-static void rionet_remove(struct rio_dev *rdev)
+static int rionet_remove_dev(struct device *dev, struct subsys_interface *sif)
 {
-	struct net_device *ndev = rio_get_drvdata(rdev);
+	struct rio_dev *rdev = to_rio_dev(dev);
 	unsigned char netid = rdev->net->hport->id;
 	struct rionet_peer *peer, *tmp;
 
-	unregister_netdev(ndev);
-
-	free_pages((unsigned long)nets[netid].active, get_order(sizeof(void *) *
-			RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size)));
-	nets[netid].active = NULL;
+	if (dev_rionet_capable(rdev)) {
+		list_for_each_entry_safe(peer, tmp, &nets[netid].peers, node) {
+			if (peer->rdev == rdev) {
+				if (nets[netid].active[rdev->destid]) {
+					nets[netid].active[rdev->destid] = NULL;
+					nets[netid].nact--;
+				}
 
-	list_for_each_entry_safe(peer, tmp, &nets[netid].peers, node) {
-		list_del(&peer->node);
-		kfree(peer);
+				list_del(&peer->node);
+				kfree(peer);
+				break;
+			}
+		}
 	}
 
-	free_netdev(ndev);
+	return 0;
 }
 
 static void rionet_get_drvinfo(struct net_device *ndev,
@@ -503,12 +518,13 @@ static int rionet_setup_netdev(struct rio_mport *mport, struct net_device *ndev)
 
 static unsigned long net_table[RIONET_MAX_NETS/sizeof(unsigned long) + 1];
 
-static int rionet_probe(struct rio_dev *rdev, const struct rio_device_id *id)
+static int rionet_add_dev(struct device *dev, struct subsys_interface *sif)
 {
 	int rc = -ENODEV;
 	u32 lsrc_ops, ldst_ops;
 	struct rionet_peer *peer;
 	struct net_device *ndev = NULL;
+	struct rio_dev *rdev = to_rio_dev(dev);
 	unsigned char netid = rdev->net->hport->id;
 	int oldnet;
 
@@ -518,8 +534,9 @@ static int rionet_probe(struct rio_dev *rdev, const struct rio_device_id *id)
 	oldnet = test_and_set_bit(netid, net_table);
 
 	/*
-	 * First time through, make sure local device is rionet
-	 * capable, setup netdev (will be skipped on later probes)
+	 * If first time through this net, make sure local device is rionet
+	 * capable and setup netdev (this step will be skipped in later probes
+	 * on the same net).
 	 */
 	if (!oldnet) {
 		rio_local_read_config_32(rdev->net->hport, RIO_SRC_OPS_CAR,
@@ -541,6 +558,12 @@ static int rionet_probe(struct rio_dev *rdev, const struct rio_device_id *id)
 		}
 		nets[netid].ndev = ndev;
 		rc = rionet_setup_netdev(rdev->net->hport, ndev);
+		if (rc) {
+			printk(KERN_ERR "%s: failed to setup netdev (rc=%d)\n",
+			       DRV_NAME, rc);
+			goto out;
+		}
+
 		INIT_LIST_HEAD(&nets[netid].peers);
 		nets[netid].nact = 0;
 	} else if (nets[netid].ndev == NULL)
@@ -559,31 +582,61 @@ static int rionet_probe(struct rio_dev *rdev, const struct rio_device_id *id)
 		list_add_tail(&peer->node, &nets[netid].peers);
 	}
 
-	rio_set_drvdata(rdev, nets[netid].ndev);
-
-      out:
+	return 0;
+out:
 	return rc;
 }
 
+#ifdef MODULE
 static struct rio_device_id rionet_id_table[] = {
-	{RIO_DEVICE(RIO_ANY_ID, RIO_ANY_ID)}
+	{RIO_DEVICE(RIO_ANY_ID, RIO_ANY_ID)},
+	{ 0, }	/* terminate list */
 };
 
-static struct rio_driver rionet_driver = {
-	.name = "rionet",
-	.id_table = rionet_id_table,
-	.probe = rionet_probe,
-	.remove = rionet_remove,
+MODULE_DEVICE_TABLE(rapidio, rionet_id_table);
+#endif
+
+static struct subsys_interface rionet_interface = {
+	.name		= "rionet",
+	.subsys		= &rio_bus_type,
+	.add_dev	= rionet_add_dev,
+	.remove_dev	= rionet_remove_dev,
 };
 
 static int __init rionet_init(void)
 {
-	return rio_register_driver(&rionet_driver);
+	return subsys_interface_register(&rionet_interface);
 }
 
 static void __exit rionet_exit(void)
 {
-	rio_unregister_driver(&rionet_driver);
+	struct rionet_private *rnet;
+	struct net_device *ndev;
+	struct rionet_peer *peer, *tmp;
+	int i;
+
+	for (i = 0; i < RIONET_MAX_NETS; i++) {
+		if (nets[i].ndev != NULL) {
+			ndev = nets[i].ndev;
+			rnet = netdev_priv(ndev);
+			unregister_netdev(ndev);
+
+			list_for_each_entry_safe(peer,
+						 tmp, &nets[i].peers, node) {
+				list_del(&peer->node);
+				kfree(peer);
+			}
+
+			free_pages((unsigned long)nets[i].active,
+				 get_order(sizeof(void *) *
+				 RIO_MAX_ROUTE_ENTRIES(rnet->mport->sys_size)));
+			nets[i].active = NULL;
+
+			free_netdev(ndev);
+		}
+	}
+
+	subsys_interface_unregister(&rionet_interface);
 }
 
 late_initcall(rionet_init);
-- 
1.7.8.4

