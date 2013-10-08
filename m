Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab3JHKp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:45:27 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:61758 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab3JHKoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:44:38 -0400
MIME-Version: 1.0
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 8 Oct 2013 12:44:16 +0200
Message-ID: <CACQ1gAhNFTdG_2OCTnsOCaBozHnGb9EwAGHT5+f=cARRpC_WBg@mail.gmail.com>
Subject: [BUG] spi/spi-atmel: DMA rx buffer corruption with SPI_IOC_MESSAGE
To: Nicolas Ferre <nicolas.ferre@atmel.com>, Mark Brown <broonie@kernel.org>,
        Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I finally found the bug I saw months ago, before "[PATCH v8 3/8]
spi/spi-atmel: add dmaengine support" was merged.

Here it is:

When the ioctl SPI_IOC_MESSAGE is used with small and big buffers,
the big RX buffer is corrupted with bytes from the big TX buffer.
(Small means size < DMA_MIN_BYTES, Big means size > DMA_MIN_BYTES)

I'm attaching the test software that I used ( ./spi_test /dev/spidevx.x )

It fills 3 TX buffers with 0xAA pattern: a small, a big and a small again.
It reads in return 3 RX buffers.
The MISO pin has to be on 3.3v.

It checks if the received buffers are filled with 0xFF (they should
be, as MISO is high).
And I've got a lot of buffers filled partially with 0xAA bytes.

BUT, if you apply this patch:
---8<----
diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 83cf609..cde42a4 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -187,7 +187,7 @@
 /* use PIO for small transfers, avoiding DMA setup/teardown overhead and
  * cache operations; better heuristics consider wordsize and bitrate.
  */
-#define DMA_MIN_BYTES  16
+#define DMA_MIN_BYTES  0

 struct atmel_spi_dma {
        struct dma_chan                 *chan_rx;
---8<----
There's no error any more.
So there's something wrong happening when switching from/to pio
transfer to/from DMA.

We didn't saw that at the time of the merge because we did the test
with a loop on MISO/MOSI,
so the RX buffer was corrupted with identical bytes.

Best regards,
Richard.
