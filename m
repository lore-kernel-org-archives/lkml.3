Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaBTOof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:44:35 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:46205 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbaBTOnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:43:25 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 09/10] spi: sh-msiof: Convert to let spi core validate xfer->bits_per_word
Date: Thu, 20 Feb 2014 15:43:08 +0100
Message-Id: <1392907389-21798-10-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Set bits_per_word_mask so the spi core will reject transfers that attempt
to use an unsupported bits_per_word value.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi-sh-msiof.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 7add4be37987..bd300fcb7116 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -441,22 +441,6 @@ static u32 sh_msiof_spi_hz(struct spi_device *spi, struct spi_transfer *t)
 	return hz;
 }
 
-static int sh_msiof_spi_setup_transfer(struct spi_device *spi,
-				       struct spi_transfer *t)
-{
-	int bits;
-
-	/* noting to check hz values against since parent clock is disabled */
-
-	bits = sh_msiof_spi_bits(spi, t);
-	if (bits < 8)
-		return -EINVAL;
-	if (bits > 32)
-		return -EINVAL;
-
-	return spi_bitbang_setup_transfer(spi, t);
-}
-
 static int sh_msiof_spi_setup(struct spi_device *spi)
 {
 	struct device_node	*np = spi->master->dev.of_node;
@@ -822,10 +806,11 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
 	master->cleanup = spi_bitbang_cleanup;
 	master->prepare_message = sh_msiof_prepare_message;
 	master->unprepare_message = sh_msiof_unprepare_message;
+	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(8, 32);
 
 	p->bitbang.master = master;
 	p->bitbang.chipselect = sh_msiof_spi_chipselect;
-	p->bitbang.setup_transfer = sh_msiof_spi_setup_transfer;
+	p->bitbang.setup_transfer = spi_bitbang_setup_transfer;
 	p->bitbang.txrx_bufs = sh_msiof_spi_txrx;
 	p->bitbang.txrx_word[SPI_MODE_0] = sh_msiof_spi_txrx_word;
 	p->bitbang.txrx_word[SPI_MODE_1] = sh_msiof_spi_txrx_word;
-- 
1.7.9.5

