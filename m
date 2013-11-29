Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab3K2RNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:13:00 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:43723 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3K2RMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:12:54 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Laxman Dewangan <ldewangan@nvidia.com>, Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] spi: tegra: avoid unsigned->signed->unsigned promotion
Date: Fri, 29 Nov 2013 18:12:44 +0100
Message-Id: <1385745164-10534-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

u8 type, which is unsigned, is promoted to int, which is singned, when
doing a binary shift.  Then, on 64-bit machines, it is further promoted
to unsigned long which may lead to more significant half of the value
to be all ones.  To avoid this, explicitly promote to an unsigned type.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/spi/spi-tegra114.c      | 4 ++--
 drivers/spi/spi-tegra20-slink.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index aaecfb3..2dadc3f 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -315,7 +315,7 @@ static unsigned tegra_spi_fill_tx_fifo_from_client_txbuf(
 		for (count = 0; count < max_n_32bit; count++) {
 			x = 0;
 			for (i = 0; (i < 4) && nbytes; i++, nbytes--)
-				x |= (*tx_buf++) << (i*8);
+				x |= (unsigned)(*tx_buf++) << (i*8);
 			tegra_spi_writel(tspi, x, SPI_TX_FIFO);
 		}
 	} else {
@@ -326,7 +326,7 @@ static unsigned tegra_spi_fill_tx_fifo_from_client_txbuf(
 			x = 0;
 			for (i = 0; nbytes && (i < tspi->bytes_per_word);
 							i++, nbytes--)
-				x |= ((*tx_buf++) << i*8);
+				x |= (unsigned)(*tx_buf++) << (i*8);
 			tegra_spi_writel(tspi, x, SPI_TX_FIFO);
 		}
 	}
diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index e66715b..0fc4f7d 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -331,7 +331,7 @@ static unsigned tegra_slink_fill_tx_fifo_from_client_txbuf(
 		for (count = 0; count < max_n_32bit; count++) {
 			x = 0;
 			for (i = 0; (i < 4) && nbytes; i++, nbytes--)
-				x |= (*tx_buf++) << (i*8);
+				x |= (unsigned)(*tx_buf++) << (i*8);
 			tegra_slink_writel(tspi, x, SLINK_TX_FIFO);
 		}
 	} else {
@@ -342,7 +342,7 @@ static unsigned tegra_slink_fill_tx_fifo_from_client_txbuf(
 			x = 0;
 			for (i = 0; nbytes && (i < tspi->bytes_per_word);
 							i++, nbytes--)
-				x |= ((*tx_buf++) << i*8);
+				x |= (unsigned)(*tx_buf++) << (i*8);
 			tegra_slink_writel(tspi, x, SLINK_TX_FIFO);
 		}
 	}
-- 
1.8.4.1

