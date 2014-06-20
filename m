Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966696AbaFTKRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:17:22 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:58689 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966332AbaFTKQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:16:30 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mark Brown <broonie@kernel.org>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/5] spi: sh-msiof: Extract sh_msiof_spi_{start,stop}() helpers
Date: Fri, 20 Jun 2014 12:16:17 +0200
Message-Id: <1403259380-13634-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403259380-13634-1-git-send-email-geert+renesas@glider.be>
References: <1403259380-13634-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on an old patch by Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/spi/spi-sh-msiof.c | 51 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 7e5b15b48c04..8bfa97e03502 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -509,6 +509,40 @@ static int sh_msiof_prepare_message(struct spi_master *master,
 	return 0;
 }
 
+static int sh_msiof_spi_start(struct sh_msiof_spi_priv *p, void *rx_buf)
+{
+	int ret;
+
+	/* setup clock and rx/tx signals */
+	ret = sh_msiof_modify_ctr_wait(p, 0, CTR_TSCKE);
+	if (rx_buf && !ret)
+		ret = sh_msiof_modify_ctr_wait(p, 0, CTR_RXE);
+	if (!ret)
+		ret = sh_msiof_modify_ctr_wait(p, 0, CTR_TXE);
+
+	/* start by setting frame bit */
+	if (!ret)
+		ret = sh_msiof_modify_ctr_wait(p, 0, CTR_TFSE);
+
+	return ret;
+}
+
+static int sh_msiof_spi_stop(struct sh_msiof_spi_priv *p, void *rx_buf)
+{
+	int ret;
+
+	/* shut down frame, rx/tx and clock signals */
+	ret = sh_msiof_modify_ctr_wait(p, CTR_TFSE, 0);
+	if (!ret)
+		ret = sh_msiof_modify_ctr_wait(p, CTR_TXE, 0);
+	if (rx_buf && !ret)
+		ret = sh_msiof_modify_ctr_wait(p, CTR_RXE, 0);
+	if (!ret)
+		ret = sh_msiof_modify_ctr_wait(p, CTR_TSCKE, 0);
+
+	return ret;
+}
+
 static int sh_msiof_spi_txrx_once(struct sh_msiof_spi_priv *p,
 				  void (*tx_fifo)(struct sh_msiof_spi_priv *,
 						  const void *, int, int),
@@ -536,15 +570,9 @@ static int sh_msiof_spi_txrx_once(struct sh_msiof_spi_priv *p,
 	if (tx_buf)
 		tx_fifo(p, tx_buf, words, fifo_shift);
 
-	/* setup clock and rx/tx signals */
-	ret = sh_msiof_modify_ctr_wait(p, 0, CTR_TSCKE);
-	if (rx_buf)
-		ret = ret ? ret : sh_msiof_modify_ctr_wait(p, 0, CTR_RXE);
-	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, 0, CTR_TXE);
-
-	/* start by setting frame bit */
 	reinit_completion(&p->done);
-	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, 0, CTR_TFSE);
+
+	ret = sh_msiof_spi_start(p, rx_buf);
 	if (ret) {
 		dev_err(&p->pdev->dev, "failed to start hardware\n");
 		goto err;
@@ -560,12 +588,7 @@ static int sh_msiof_spi_txrx_once(struct sh_msiof_spi_priv *p,
 	/* clear status bits */
 	sh_msiof_reset_str(p);
 
-	/* shut down frame, rx/tx and clock signals */
-	ret = sh_msiof_modify_ctr_wait(p, CTR_TFSE, 0);
-	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, CTR_TXE, 0);
-	if (rx_buf)
-		ret = ret ? ret : sh_msiof_modify_ctr_wait(p, CTR_RXE, 0);
-	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, CTR_TSCKE, 0);
+	ret = sh_msiof_spi_stop(p, rx_buf);
 	if (ret) {
 		dev_err(&p->pdev->dev, "failed to shut down hardware\n");
 		goto err;
-- 
1.9.1

