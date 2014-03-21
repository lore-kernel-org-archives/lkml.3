Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965205AbaCUAEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:04:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36667 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965019AbaCUAEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 082/149] spi: fsl-dspi: Fix getting correct address for master
Date: Thu, 20 Mar 2014 17:04:05 -0700
Message-Id: <20140321000439.802021395@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 017145fef567430789e40f6a22a90ce2a766370b upstream.

Current code set platform drvdata to dspi. However, the code in dspi_suspend()
and dspi_resume() assumes the drvdata is the address of master.
Fix it by setting platform drvdata to master.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-fsl-dspi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -421,7 +421,6 @@ static int dspi_suspend(struct device *d
 
 static int dspi_resume(struct device *dev)
 {
-
 	struct spi_master *master = dev_get_drvdata(dev);
 	struct fsl_dspi *dspi = spi_master_get_devdata(master);
 
@@ -505,7 +504,7 @@ static int dspi_probe(struct platform_de
 	clk_prepare_enable(dspi->clk);
 
 	init_waitqueue_head(&dspi->waitq);
-	platform_set_drvdata(pdev, dspi);
+	platform_set_drvdata(pdev, master);
 
 	ret = spi_bitbang_start(&dspi->bitbang);
 	if (ret != 0) {
@@ -526,7 +525,8 @@ out_master_put:
 
 static int dspi_remove(struct platform_device *pdev)
 {
-	struct fsl_dspi *dspi = platform_get_drvdata(pdev);
+	struct spi_master *master = platform_get_drvdata(pdev);
+	struct fsl_dspi *dspi = spi_master_get_devdata(master);
 
 	/* Disconnect from the SPI framework */
 	spi_bitbang_stop(&dspi->bitbang);


