Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbaJIVRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:17:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926AbaJIVLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Qipan Li <Qipan.Li@csr.com>, Barry Song <Baohua.Song@csr.com>,
        Mark Brown <broonie@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 084/163] spi: sirf: enable RX_IO_DMA_INT interrupt
Date: Thu,  9 Oct 2014 14:01:49 -0700
Message-Id: <1412888588-26755-85-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qipan Li <Qipan.Li@csr.com>

commit f2a08b404691ef3e7be6ce81c185335cfc68b6db upstream.

in spi interrupt handler, we need check RX_IO_DMA status to ensure
rx fifo have received the specify count data.

if not set, the while statement in spi isr function will keep loop,
at last, make the kernel hang.

[The code is actually there in the interrupt handler but apparently it
needs the interrupt unmasking so the handler sees the status -- broonie]

Signed-off-by: Qipan Li <Qipan.Li@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
[ kamal: backport to 3.13-stable: applied to spi_sirfsoc_transfer's pio path. ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/spi/spi-sirf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sirf.c b/drivers/spi/spi-sirf.c
index ed5e501..10bd831 100644
--- a/drivers/spi/spi-sirf.c
+++ b/drivers/spi/spi-sirf.c
@@ -366,7 +366,9 @@ static int spi_sirfsoc_transfer(struct spi_device *spi, struct spi_transfer *t)
 		writel(SIRFSOC_SPI_RX_OFLOW_INT_EN | SIRFSOC_SPI_TX_UFLOW_INT_EN |
 			SIRFSOC_SPI_RXFIFO_THD_INT_EN | SIRFSOC_SPI_TXFIFO_THD_INT_EN |
 			SIRFSOC_SPI_FRM_END_INT_EN | SIRFSOC_SPI_RXFIFO_FULL_INT_EN |
-			SIRFSOC_SPI_TXFIFO_EMPTY_INT_EN, sspi->base + SIRFSOC_SPI_INT_EN);
+			SIRFSOC_SPI_TXFIFO_EMPTY_INT_EN |
+			SIRFSOC_SPI_RX_IO_DMA_INT_EN,
+			sspi->base + SIRFSOC_SPI_INT_EN);
 	}
 
 	writel(SIRFSOC_SPI_RX_EN | SIRFSOC_SPI_TX_EN, sspi->base + SIRFSOC_SPI_TX_RX_EN);
-- 
1.9.1

