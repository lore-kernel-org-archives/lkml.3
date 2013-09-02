Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab3IBJyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:54:55 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:11964
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755133Ab3IBJy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:54:28 -0400
X-IronPort-AV: E=Sophos;i="4.89,1006,1367964000"; 
   d="scan'208";a="25430803"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mark Brown <broonie@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] spi: delete premature free_irq
Date: Mon,  2 Sep 2013 11:54:20 +0200
Message-Id: <1378115661-5371-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1378115661-5371-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1378115661-5371-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Free_irq is not needed if there has been no request_irq.  Free_irq is
removed from both the probe and remove functions.  The correct request_irq
and free_irq appear to be in the add_host and remove_host functions in
spi-dw.c.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@

*e = platform_get_irq(...);
... when != request_irq(e,...)
*free_irq(e,...)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/spi/spi-dw-mmio.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/spi/spi-dw-mmio.c b/drivers/spi/spi-dw-mmio.c
index 4aa8be8..168c620 100644
--- a/drivers/spi/spi-dw-mmio.c
+++ b/drivers/spi/spi-dw-mmio.c
@@ -74,7 +74,7 @@ static int dw_spi_mmio_probe(struct platform_device *pdev)
 	dwsmmio->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dwsmmio->clk)) {
 		ret = PTR_ERR(dwsmmio->clk);
-		goto err_irq;
+		goto err_unmap;
 	}
 	clk_enable(dwsmmio->clk);
 
@@ -94,8 +94,6 @@ err_clk:
 	clk_disable(dwsmmio->clk);
 	clk_put(dwsmmio->clk);
 	dwsmmio->clk = NULL;
-err_irq:
-	free_irq(dws->irq, dws);
 err_unmap:
 	iounmap(dws->regs);
 err_release_reg:
@@ -115,7 +113,6 @@ static int dw_spi_mmio_remove(struct platform_device *pdev)
 	clk_put(dwsmmio->clk);
 	dwsmmio->clk = NULL;
 
-	free_irq(dwsmmio->dws.irq, &dwsmmio->dws);
 	dw_spi_remove_host(&dwsmmio->dws);
 	iounmap(dwsmmio->dws.regs);
 	kfree(dwsmmio);

