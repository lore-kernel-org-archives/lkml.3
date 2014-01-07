Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaAGKqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:46:48 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:40557 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaAGKqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:46:46 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: Leilei Zhao <leilei.zhao@atmel.com>, <mark.roszko@gmail.com>,
        <mdeneen@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <stable@vger.kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 4/4] tty/serial: at91: reset rx_ring when port is shutdown
Date: Tue, 7 Jan 2014 11:45:09 +0100
Message-ID: <ea90a2a581290cb8065ec1ca2ba4242b2adb39c2.1389090437.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1389090437.git.nicolas.ferre@atmel.com>
References: <cover.1389090437.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Deneen <mdeneen@gmail.com>

When using RX DMA, the driver won't pass any data to the uart layer
until the buffer is flipped. When the port is shutdown, the dma buffers
are unmapped, but the head and tail of the ring buffer are not reseted.
Since the serial console will keep the port open, this will only
present itself when the uart is not shared.

To reproduce the issue, with an unpatched driver, run a getty on /dev/ttyS0
with no serial console and exit. Getty will exit, and when the new one returns
you will be unable to log in.  If you hold down a key long enough to fill the
DMA buffer and flip it, you can then log in.

Signed-off-by: Mark Deneen <mdeneen@gmail.com>
Acked-by: Leilei Zhao <leilei.zhao@atmel.com>
[nicolas.ferre@atmel.com: adapt to mainline kernel, handle !DMA case]
Cc: <stable@vger.kernel.org> # v3.12
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/tty/serial/atmel_serial.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 6e68486c83cb..2d925455c1ec 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1681,6 +1681,12 @@ static void atmel_shutdown(struct uart_port *port)
 		atmel_port->release_tx(port);
 
 	/*
+	 * Reset ring buffer pointers
+	 */
+	atmel_port->rx_ring.head = 0;
+	atmel_port->rx_ring.tail = 0;
+
+	/*
 	 * Free the interrupt
 	 */
 	free_irq(port->irq, port);
-- 
1.8.2.2

