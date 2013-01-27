Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3A0Ghk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 01:37:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60593 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755896Ab3A0Ghi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 01:37:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] spi: Ensure memory used for spi_write_then_read() is DMA safe
Date: Sun, 27 Jan 2013 14:35:04 +0800
Message-Id: <1359268504-24937-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use GFP_DMA in order to ensure that the memory we allocate for transfers
in spi_write_then_read() can be DMAed. On most platforms this will have
no effect.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/spi/spi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 19ee901..14d0fba 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1656,7 +1656,8 @@ int spi_write_then_read(struct spi_device *spi,
 	 * using the pre-allocated buffer or the transfer is too large.
 	 */
 	if ((n_tx + n_rx) > SPI_BUFSIZ || !mutex_trylock(&lock)) {
-		local_buf = kmalloc(max((unsigned)SPI_BUFSIZ, n_tx + n_rx), GFP_KERNEL);
+		local_buf = kmalloc(max((unsigned)SPI_BUFSIZ, n_tx + n_rx),
+				    GFP_KERNEL | GFP_DMA);
 		if (!local_buf)
 			return -ENOMEM;
 	} else {
-- 
1.7.10.4

