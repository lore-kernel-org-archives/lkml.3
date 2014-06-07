Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaFGBrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:47:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35950 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Stephane Grosjean" <s.grosjean@peak-system.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.465829339@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 80/92] can: peak_pci: Fix the way channels are linked
 together
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Grosjean <s.grosjean@peak-system.com>

commit 29830406415c227a54af429d7b300aabd4754237 upstream.

Change the way channels objects are linked together by peak_pci_probe()
avoiding any kernel oops when driver is removed. Side effect is that
the list is now browsed from last to first channel.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/sja1000/peak_pci.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/can/sja1000/peak_pci.c b/drivers/net/can/sja1000/peak_pci.c
index 2c7f503..2147959 100644
--- a/drivers/net/can/sja1000/peak_pci.c
+++ b/drivers/net/can/sja1000/peak_pci.c
@@ -39,9 +39,9 @@ MODULE_LICENSE("GPL v2");
 #define DRV_NAME  "peak_pci"
 
 struct peak_pci_chan {
-	void __iomem *cfg_base;	     /* Common for all channels */
-	struct net_device *next_dev; /* Chain of network devices */
-	u16 icr_mask;		     /* Interrupt mask for fast ack */
+	void __iomem *cfg_base;		/* Common for all channels */
+	struct net_device *prev_dev;	/* Chain of network devices */
+	u16 icr_mask;			/* Interrupt mask for fast ack */
 };
 
 #define PEAK_PCI_CAN_CLOCK	(16000000 / 2)
@@ -98,7 +98,7 @@ static int __devinit peak_pci_probe(struct pci_dev *pdev,
 {
 	struct sja1000_priv *priv;
 	struct peak_pci_chan *chan;
-	struct net_device *dev, *dev0 = NULL;
+	struct net_device *dev;
 	void __iomem *cfg_base, *reg_base;
 	u16 sub_sys_id, icr;
 	int i, err, channels;
@@ -196,18 +196,14 @@ static int __devinit peak_pci_probe(struct pci_dev *pdev,
 		}
 
 		/* Create chain of SJA1000 devices */
-		if (i == 0)
-			dev0 = dev;
-		else
-			chan->next_dev = dev;
+		chan->prev_dev = pci_get_drvdata(pdev);
+		pci_set_drvdata(pdev, dev);
 
 		dev_info(&pdev->dev,
 			 "%s at reg_base=0x%p cfg_base=0x%p irq=%d\n",
 			 dev->name, priv->reg_base, chan->cfg_base, dev->irq);
 	}
 
-	pci_set_drvdata(pdev, dev0);
-
 	/* Enable interrupts */
 	writew(icr, cfg_base + PITA_ICR + 2);
 
@@ -217,12 +213,11 @@ failure_remove_channels:
 	/* Disable interrupts */
 	writew(0x0, cfg_base + PITA_ICR + 2);
 
-	for (dev = dev0; dev; dev = chan->next_dev) {
+	for (dev = pci_get_drvdata(pdev); dev; dev = chan->prev_dev) {
 		unregister_sja1000dev(dev);
 		free_sja1000dev(dev);
 		priv = netdev_priv(dev);
 		chan = priv->priv;
-		dev = chan->next_dev;
 	}
 
 	pci_iounmap(pdev, reg_base);
@@ -241,7 +236,7 @@ failure_disable_pci:
 
 static void __devexit peak_pci_remove(struct pci_dev *pdev)
 {
-	struct net_device *dev = pci_get_drvdata(pdev); /* First device */
+	struct net_device *dev = pci_get_drvdata(pdev); /* Last device */
 	struct sja1000_priv *priv = netdev_priv(dev);
 	struct peak_pci_chan *chan = priv->priv;
 	void __iomem *cfg_base = chan->cfg_base;
@@ -255,7 +250,7 @@ static void __devexit peak_pci_remove(struct pci_dev *pdev)
 		dev_info(&pdev->dev, "removing device %s\n", dev->name);
 		unregister_sja1000dev(dev);
 		free_sja1000dev(dev);
-		dev = chan->next_dev;
+		dev = chan->prev_dev;
 		if (!dev)
 			break;
 		priv = netdev_priv(dev);

