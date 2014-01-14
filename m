Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaANLhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:37:07 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:43346 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaANLhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:37:05 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH/RFC] spi: core: Fix logic mismatch in spi_master.set_cs()
Date: Tue, 14 Jan 2014 12:36:51 +0100
Message-Id: <1389699411-29135-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

The documentation for spi_master.set_cs() says:

    assert or deassert chip select, true to assert

i.e. its "enable" parameter uses assertion-level logic.

This does not match the implementation of spi_set_cs(), which calls
spi_master.set_cs() with the wanted logical value of the chip select line,
i.e. "false" to assert an active low chip select, and "true" to assert an
active high chip select.

Correct the implementation to use assertion-level logic.

For GPIO-based chip selects, active high chip selects are still handled in
spi_set_cs(), as this is a direct GPIO level.
For SPI controller-based chip selects, active high chip selects must be
handled by the SPI master driver, if supported (some SPI controllers have
configurable chip select polarity).

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index a86569e1f178..eb20169e84e8 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -561,13 +561,12 @@ int spi_register_board_info(struct spi_board_info const *info, unsigned n)
 
 static void spi_set_cs(struct spi_device *spi, bool enable)
 {
-	if (spi->mode & SPI_CS_HIGH)
-		enable = !enable;
-
-	if (spi->cs_gpio >= 0)
+	if (spi->cs_gpio >= 0) {
+		if (spi->mode & SPI_CS_HIGH)
+			enable = !enable;
 		gpio_set_value(spi->cs_gpio, !enable);
-	else if (spi->master->set_cs)
-		spi->master->set_cs(spi, !enable);
+	} else if (spi->master->set_cs)
+		spi->master->set_cs(spi, enable);
 }
 
 /*
-- 
1.7.9.5

