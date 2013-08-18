Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3HRCpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:45:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52863 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab3HRCnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:43:45 -0400
From: Joel Fernandes <joelf@ti.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH v2 10/14] crypto: omap-aes: Switch to PIO mode during probe
Date: Sat, 17 Aug 2013 21:42:31 -0500
Message-ID: <1376793755-30478-11-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376793755-30478-1-git-send-email-joelf@ti.com>
References: <1376793755-30478-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cases where requesting for DMA channels fails for some reason, or channel
numbers are not provided in DT or platform data, we switch to PIO-only mode
also checking if platform provides IRQ numbers and interrupt register offsets
in DT and platform data. All dma-only paths are avoided in this mode.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 62b3260..d214dbf 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1064,7 +1064,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 	struct omap_aes_dev *dd;
 	struct crypto_alg *algp;
 	struct resource res;
-	int err = -ENOMEM, i, j;
+	int err = -ENOMEM, i, j, irq = -1;
 	u32 reg;
 
 	dd = kzalloc(sizeof(struct omap_aes_dev), GFP_KERNEL);
@@ -1108,8 +1108,23 @@ static int omap_aes_probe(struct platform_device *pdev)
 	tasklet_init(&dd->queue_task, omap_aes_queue_task, (unsigned long)dd);
 
 	err = omap_aes_dma_init(dd);
-	if (err)
-		goto err_dma;
+	if (err && AES_REG_IRQ_STATUS(dd) && AES_REG_IRQ_ENABLE(dd)) {
+		dd->pio_only = 1;
+
+		irq = platform_get_irq(pdev, 0);
+		if (irq < 0) {
+			dev_err(dev, "can't get IRQ resource\n");
+			goto err_irq;
+		}
+
+		err = request_irq(irq, omap_aes_irq, 0,
+				dev_name(dev), dd);
+		if (err) {
+			dev_err(dev, "Unable to grab omap-aes IRQ\n");
+			goto err_irq;
+		}
+	}
+
 
 	INIT_LIST_HEAD(&dd->list);
 	spin_lock(&list_lock);
@@ -1137,8 +1152,11 @@ err_algs:
 		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
 			crypto_unregister_alg(
 					&dd->pdata->algs_info[i].algs_list[j]);
-	omap_aes_dma_cleanup(dd);
-err_dma:
+	if (dd->pio_only)
+		free_irq(irq, dd);
+	else
+		omap_aes_dma_cleanup(dd);
+err_irq:
 	tasklet_kill(&dd->done_task);
 	tasklet_kill(&dd->queue_task);
 	pm_runtime_disable(dev);
-- 
1.7.9.5

