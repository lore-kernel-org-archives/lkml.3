Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaF1Rqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:46:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaF1Rqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:46:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Christopher R. Baker" <cbaker@rec.ri.cmu.edu>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.4 01/43] can: peak_pci: prevent use after free at netdev removal
Date: Sat, 28 Jun 2014 10:45:52 -0700
Message-Id: <20140628174449.870397959@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174449.788784511@linuxfoundation.org>
References: <20140628174449.788784511@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/sja1000/peak_pci.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/net/can/sja1000/peak_pci.c
+++ b/drivers/net/can/sja1000/peak_pci.c
@@ -547,7 +547,7 @@ static int __devinit peak_pci_probe(stru
 {
 	struct sja1000_priv *priv;
 	struct peak_pci_chan *chan;
-	struct net_device *dev;
+	struct net_device *dev, *prev_dev;
 	void __iomem *cfg_base, *reg_base;
 	u16 sub_sys_id, icr;
 	int i, err, channels;
@@ -681,11 +681,13 @@ failure_remove_channels:
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
@@ -719,10 +721,12 @@ static void __devexit peak_pci_remove(st
 
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


