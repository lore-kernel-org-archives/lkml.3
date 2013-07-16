Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab3GPPQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:16:30 -0400
Received: from 14.mo1.mail-out.ovh.net ([178.32.97.215]:43796 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932580Ab3GPPQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:16:28 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v3 5/7] spi: atmel: prepare clk before calling enable
Date: Tue, 16 Jul 2013 17:16:22 +0200
Message-Id: <1373987782-24463-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373986995-23899-1-git-send-email-b.brezillon@overkiz.com>
References: <1373986995-23899-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 7182678456438192236
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
avoid common clk framework warnings.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/spi/spi-atmel.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index ea1ec00..4c6c455 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1579,7 +1579,9 @@ static int atmel_spi_probe(struct platform_device *pdev)
 		goto out_unmap_regs;
 
 	/* Initialize the hardware */
-	clk_enable(clk);
+	ret = clk_prepare_enable(clk);
+	if (ret)
+		goto out_unmap_regs;
 	spi_writel(as, CR, SPI_BIT(SWRST));
 	spi_writel(as, CR, SPI_BIT(SWRST)); /* AT91SAM9263 Rev B workaround */
 	if (as->caps.has_wdrbt) {
@@ -1609,7 +1611,7 @@ out_free_dma:
 
 	spi_writel(as, CR, SPI_BIT(SWRST));
 	spi_writel(as, CR, SPI_BIT(SWRST)); /* AT91SAM9263 Rev B workaround */
-	clk_disable(clk);
+	clk_disable_unprepare(clk);
 	free_irq(irq, master);
 out_unmap_regs:
 	iounmap(as->regs);
@@ -1661,7 +1663,7 @@ static int atmel_spi_remove(struct platform_device *pdev)
 	dma_free_coherent(&pdev->dev, BUFFER_SIZE, as->buffer,
 			as->buffer_dma);
 
-	clk_disable(as->clk);
+	clk_disable_unprepare(as->clk);
 	clk_put(as->clk);
 	free_irq(as->irq, master);
 	iounmap(as->regs);
@@ -1678,7 +1680,7 @@ static int atmel_spi_suspend(struct platform_device *pdev, pm_message_t mesg)
 	struct spi_master	*master = platform_get_drvdata(pdev);
 	struct atmel_spi	*as = spi_master_get_devdata(master);
 
-	clk_disable(as->clk);
+	clk_disable_unprepare(as->clk);
 	return 0;
 }
 
@@ -1687,7 +1689,7 @@ static int atmel_spi_resume(struct platform_device *pdev)
 	struct spi_master	*master = platform_get_drvdata(pdev);
 	struct atmel_spi	*as = spi_master_get_devdata(master);
 
-	clk_enable(as->clk);
+	return clk_prepare_enable(as->clk);
 	return 0;
 }
 
-- 
1.7.9.5

