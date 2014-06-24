Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbaFXUde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:33:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47832 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbaFXUdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:33:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 35/65] can: peak_pci: prevent use after free at netdev removal
Date: Tue, 24 Jun 2014 13:29:55 -0700
Message-Id: <1403641825-12825-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Grosjean <s.grosjean@peak-system.com>

commit 0b5a958cf4df3a5cd578b861471e62138f55c85e upstream.

As remarked by Christopher R. Baker in his post at

http://marc.info/?l=linux-can&m=139707295706465&w=2

there's a possibility for an use after free condition at device removal.

This simplified patch introduces an additional variable to prevent the issue.
Thanks for catching this.

Reported-by: Christopher R. Baker <cbaker@rec.ri.cmu.edu>
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/sja1000/peak_pci.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/sja1000/peak_pci.c b/drivers/net/can/sja1000/peak_pci.c
index d84888f..1a18a0c 100644
--- a/drivers/net/can/sja1000/peak_pci.c
+++ b/drivers/net/can/sja1000/peak_pci.c
@@ -555,7 +555,7 @@ static int peak_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct sja1000_priv *priv;
 	struct peak_pci_chan *chan;
-	struct net_device *dev;
+	struct net_device *dev, *prev_dev;
 	void __iomem *cfg_base, *reg_base;
 	u16 sub_sys_id, icr;
 	int i, err, channels;
@@ -691,11 +691,13 @@ failure_remove_channels:
 	writew(0x0, cfg_base + PITA_ICR + 2);
 
 	chan = NULL;
-	for (dev = pci_get_drvdata(pdev); dev; dev = chan->prev_dev) {
-		unregister_sja1000dev(dev);
-		free_sja1000dev(dev);
+	for (dev = pci_get_drvdata(pdev); dev; dev = prev_dev) {
 		priv = netdev_priv(dev);
 		chan = priv->priv;
+		prev_dev = chan->prev_dev;
+
+		unregister_sja1000dev(dev);
+		free_sja1000dev(dev);
 	}
 
 	/* free any PCIeC resources too */
@@ -729,10 +731,12 @@ static void peak_pci_remove(struct pci_dev *pdev)
 
 	/* Loop over all registered devices */
 	while (1) {
+		struct net_device *prev_dev = chan->prev_dev;
+
 		dev_info(&pdev->dev, "removing device %s\n", dev->name);
 		unregister_sja1000dev(dev);
 		free_sja1000dev(dev);
-		dev = chan->prev_dev;
+		dev = prev_dev;
 
 		if (!dev) {
 			/* do that only for first channel */
-- 
1.9.1

