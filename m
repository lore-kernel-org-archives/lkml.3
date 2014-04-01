Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaDALcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:32:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbaDALSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Riesch <christian.riesch@omicron.at>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 118/144] net: davinci_emac: Replace devm_request_irq with request_irq
Date: Tue,  1 Apr 2014 12:15:22 +0100
Message-Id: <1396350948-29910-119-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Riesch <christian.riesch@omicron.at>

commit 33b7107f59a61236d94ecd6b45e20283cd5abcc8 upstream.

In commit 6892b41d9701283085b655c6086fb57a5d63fa47

Author: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Date:   Tue Jun 25 21:24:51 2013 +0530
net: davinci: emac: Convert to devm_* api

the call of request_irq is replaced by devm_request_irq and the call
of free_irq is removed. But since interrupts are requested in
emac_dev_open, doing ifconfig up/down on the board requests the
interrupts again each time, causing devm_request_irq to fail. The
interface is dead until the device is rebooted.

This patch reverts said commit partially: It changes the driver back
to use request_irq instead of devm_request_irq, puts free_irq back in
place, but keeps the remaining changes of the original patch.

Reported-by: Jon Ringle <jon@ringle.org>
Signed-off-by: Christian Riesch <christian.riesch@omicron.at>
Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/ti/davinci_emac.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 45c167f..b5a36315 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1531,7 +1531,7 @@ static int emac_dev_open(struct net_device *ndev)
 	struct device *emac_dev = &ndev->dev;
 	u32 cnt;
 	struct resource *res;
-	int ret;
+	int q, m, ret;
 	int i = 0;
 	int k = 0;
 	struct emac_priv *priv = netdev_priv(ndev);
@@ -1566,8 +1566,7 @@ static int emac_dev_open(struct net_device *ndev)
 
 	while ((res = platform_get_resource(priv->pdev, IORESOURCE_IRQ, k))) {
 		for (i = res->start; i <= res->end; i++) {
-			if (devm_request_irq(&priv->pdev->dev, i, emac_irq,
-					     0, ndev->name, ndev))
+			if (request_irq(i, emac_irq, 0, ndev->name, ndev))
 				goto rollback;
 		}
 		k++;
@@ -1640,7 +1639,15 @@ static int emac_dev_open(struct net_device *ndev)
 
 rollback:
 
-	dev_err(emac_dev, "DaVinci EMAC: devm_request_irq() failed");
+	dev_err(emac_dev, "DaVinci EMAC: request_irq() failed");
+
+	for (q = k; k >= 0; k--) {
+		for (m = i; m >= res->start; m--)
+			free_irq(m, ndev);
+		res = platform_get_resource(priv->pdev, IORESOURCE_IRQ, k-1);
+		m = res->end;
+	}
+
 	ret = -EBUSY;
 err:
 	pm_runtime_put(&priv->pdev->dev);
@@ -1658,6 +1665,9 @@ err:
  */
 static int emac_dev_stop(struct net_device *ndev)
 {
+	struct resource *res;
+	int i = 0;
+	int irq_num;
 	struct emac_priv *priv = netdev_priv(ndev);
 	struct device *emac_dev = &ndev->dev;
 
@@ -1673,6 +1683,13 @@ static int emac_dev_stop(struct net_device *ndev)
 	if (priv->phydev)
 		phy_disconnect(priv->phydev);
 
+	/* Free IRQ */
+	while ((res = platform_get_resource(priv->pdev, IORESOURCE_IRQ, i))) {
+		for (irq_num = res->start; irq_num <= res->end; irq_num++)
+			free_irq(irq_num, priv->ndev);
+		i++;
+	}
+
 	if (netif_msg_drv(priv))
 		dev_notice(emac_dev, "DaVinci EMAC: %s stopped\n", ndev->name);
 
-- 
1.9.1

