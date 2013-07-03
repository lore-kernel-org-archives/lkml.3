Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab3GCKlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 06:41:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50653 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3GCKlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 06:41:10 -0400
From: Alexander Savchenko <oleksandr.savchenko@ti.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <matts@commtech-fastcom.com>, <paulmck@linux.vnet.ibm.com>,
        <santosh.shilimkar@ti.com>, <dhowells@redhat.com>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ti-linux-patch-review@globallogic.com>
Subject: [PATCH] OMAP: UART: Keep the TX fifo full when possible
Date: Wed, 3 Jul 2013 13:40:21 +0300
Message-ID: <1372848021-7800-1-git-send-email-oleksandr.savchenko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Fink <finik@ti.com>

Current logic results in interrupt storm since the fifo
is constantly below the threshold level. Change the logic
to fill all the available spaces in the fifo as long as
we have data to minimize the possibilty of underflow and
elimiate excessive interrupts.

Signed-off-by: Dmitry Fink <finik@ti.com>
Signed-off-by: Alexander Savchenko <oleksandr.savchenko@ti.com>
---
[rebased according to 3.10]
 drivers/tty/serial/omap-serial.c |    3 ++-
 include/uapi/linux/serial_reg.h  |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index fe50375..6a07a9b 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -316,7 +316,8 @@ static void transmit_chars(struct uart_omap_port *up, unsigned int lsr)
 		serial_omap_stop_tx(&up->port);
 		return;
 	}
-	count = up->port.fifosize / 4;
+	count = up->port.fifosize -
+		(serial_in(up, UART_OMAP_TXFIFO_LVL) & 0xFF);
 	do {
 		serial_out(up, UART_TX, xmit->buf[xmit->tail]);
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
diff --git a/include/uapi/linux/serial_reg.h b/include/uapi/linux/serial_reg.h
index e632260..97c26be 100644
--- a/include/uapi/linux/serial_reg.h
+++ b/include/uapi/linux/serial_reg.h
@@ -366,6 +366,7 @@
 #define UART_OMAP_MDR1_FIR_MODE		0x05	/* FIR mode */
 #define UART_OMAP_MDR1_CIR_MODE		0x06	/* CIR mode */
 #define UART_OMAP_MDR1_DISABLE		0x07	/* Disable (default state) */
+#define UART_OMAP_TXFIFO_LVL		0x1A	/* TX FIFO fullness */
 
 /*
  * These are definitions for the Exar XR17V35X and XR17(C|D)15X
-- 
1.7.9.5

