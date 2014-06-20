Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966649AbaFTKRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:17:19 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:58685 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966402AbaFTKQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:16:30 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mark Brown <broonie@kernel.org>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 3/5] spi: sh-msiof: Improve transfer error handling
Date: Fri, 20 Jun 2014 12:16:18 +0200
Message-Id: <1403259380-13634-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403259380-13634-1-git-send-email-geert+renesas@glider.be>
References: <1403259380-13634-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Add a timeout when waiting for the transfer complete interrupt,
  - If sh_msiof_spi_stop() fails, there's no need to clear IER, as the
    interrupt handler has already done that,
  - Propagate transfer failures in sh_msiof_transfer_one().

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/spi/spi-sh-msiof.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 8bfa97e03502..29dee0436a9a 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -575,11 +575,16 @@ static int sh_msiof_spi_txrx_once(struct sh_msiof_spi_priv *p,
 	ret = sh_msiof_spi_start(p, rx_buf);
 	if (ret) {
 		dev_err(&p->pdev->dev, "failed to start hardware\n");
-		goto err;
+		goto stop_ier;
 	}
 
 	/* wait for tx fifo to be emptied / rx fifo to be filled */
-	wait_for_completion(&p->done);
+	ret = wait_for_completion_timeout(&p->done, HZ);
+	if (!ret) {
+		dev_err(&p->pdev->dev, "PIO timeout\n");
+		ret = -ETIMEDOUT;
+		goto stop_reset;
+	}
 
 	/* read rx fifo */
 	if (rx_buf)
@@ -591,12 +596,15 @@ static int sh_msiof_spi_txrx_once(struct sh_msiof_spi_priv *p,
 	ret = sh_msiof_spi_stop(p, rx_buf);
 	if (ret) {
 		dev_err(&p->pdev->dev, "failed to shut down hardware\n");
-		goto err;
+		return ret;
 	}
 
 	return words;
 
- err:
+stop_reset:
+	sh_msiof_reset_str(p);
+	sh_msiof_spi_stop(p, rx_buf);
+stop_ier:
 	sh_msiof_write(p, IER, 0);
 	return ret;
 }
@@ -679,7 +687,7 @@ static int sh_msiof_transfer_one(struct spi_master *master,
 					   rx_buf,
 					   words, bits);
 		if (n < 0)
-			break;
+			return n;
 
 		bytes_done += n * bytes_per_word;
 		words -= n;
-- 
1.9.1

