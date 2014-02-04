Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaBDKGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:06:37 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:41540 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaBDKG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:06:28 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] spi: rspi: Only enable interrupts when there's a need to wait
Date: Tue,  4 Feb 2014 11:06:24 +0100
Message-Id: <1391508384-5013-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

rspi_wait_for_interrupt() unconditionally enables interrupts, even when the
wait condition is already satisfied. This causes a high interrupt load (2
interrupts/byte for full-duplex Single SPI transfers, 1 interrupt/byte for
RSPI with TX Only mode, or QSPI in unidirectional Dual or Quad Transfer
mode).

Change this to return immediately when the wait condition is satisfied.
This dramatically reduces the interrupt load, especially in high-speed
Quad Transfer mode, and increases transfer speed, as no interrupts need to
be handled when there's space available in the output FIFO, or data
available in the input FIFO.

Benchmark results for QSPI on r8a7791 while reading 1 MiB from 30 MHz SPI
FLASH on the Koelsch development board:

Before:
                        Single SPI      Dual SPI        Quad SPI
    Interrupts:         2096856         1048592         1048594
    Mbps:               0.9             1.6             1.6

After:

                        Single SPI      Dual SPI        Quad SPI
    Interrupts:         1048569         21295           8
    Mbps:               0.7             10.8            12.9

I don't know why Single SPI slowed down a bit.

I've also verified functionality for RSPI-RZ on r7s72100, but don't have
benchmark results as there's no SPI FLASH connected to RSPI on the Genmai
development board. Unlike RSPI and QSPI, RSPI-RZ has separate interrupts
for RX and TX, which shows that Single SPI transfers now generate (mostly)
RX interrupts, as expected.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi-rspi.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index df637184f6f0..c76f718a3a45 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -393,6 +393,9 @@ static int rspi_wait_for_interrupt(struct rspi_data *rspi, u8 wait_mask,
 	int ret;
 
 	rspi->spsr = rspi_read8(rspi, RSPI_SPSR);
+	if (rspi->spsr & wait_mask)
+		return 0;
+
 	rspi_enable_irq(rspi, enable_bit);
 	ret = wait_event_timeout(rspi->wait, rspi->spsr & wait_mask, HZ);
 	if (ret == 0 && !(rspi->spsr & wait_mask))
-- 
1.7.9.5

