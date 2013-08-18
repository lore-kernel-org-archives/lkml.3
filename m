Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3HRCnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:43:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52862 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab3HRCnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:43:40 -0400
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
Subject: [PATCH v2 13/14] crypto: omap-aes: Convert request_irq to devm_request_irq
Date: Sat, 17 Aug 2013 21:42:34 -0500
Message-ID: <1376793755-30478-14-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376793755-30478-1-git-send-email-joelf@ti.com>
References: <1376793755-30478-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keeps request_irq exit/error code paths simpler.

Suggested-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 6a4ac4a..ab449b5 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1197,7 +1197,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 			goto err_irq;
 		}
 
-		err = request_irq(irq, omap_aes_irq, 0,
+		err = devm_request_irq(dev, irq, omap_aes_irq, 0,
 				dev_name(dev), dd);
 		if (err) {
 			dev_err(dev, "Unable to grab omap-aes IRQ\n");
@@ -1232,9 +1232,7 @@ err_algs:
 		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
 			crypto_unregister_alg(
 					&dd->pdata->algs_info[i].algs_list[j]);
-	if (dd->pio_only)
-		free_irq(irq, dd);
-	else
+	if (!dd->pio_only)
 		omap_aes_dma_cleanup(dd);
 err_irq:
 	tasklet_kill(&dd->done_task);
-- 
1.7.9.5

