Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762901Ab3JQVIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:08:54 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44095 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762886Ab3JQVIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:08:50 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, John Linn <john.linn@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 06/10] tty: xuartps: Force enable the UART in xuartps_console_write
Date: Thu, 17 Oct 2013 14:08:09 -0700
Message-Id: <1382044093-29905-7-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

It is possible that under certain circumstances xuartps_console_write is entered
while the UART disabled. When this happens the code will busy loop in
xuartps_console_putchar, since the character is never written and the TXEMPTY
flag is never set. The result is a system lockup. This patch force enables the
UART for the duration of xuartps_console_write to avoid this.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: John Linn <john.linn@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
Squashed from these original patches:
	tty: xuartps: Force enable the UART in xuartps_console_write

	It is possible that under certain circumstances xuartps_console_write is entered
	while the UART disabled. When this happens the code will busy loop in
	xuartps_console_putchar, since the character is never written and the TXEMPTY
	flag is never set. The result is a system lockup. This patch force enables the
	UART for the duration of xuartps_console_write to avoid this.

	Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

and

	tty: xuartps: Fix bad register write in console_write

	The commit:
	serial: xilinx_uartps: Force enable the UART in xuartps_console_write
	(sha1: d21aec67c1c782314d20b3d619e76cf8aae593dc)
	caused  a new bug as the write to the control register had
	the offset and the value to write reversed.

	Reported-by: Jason Andrews <jasona@cadence.com>
	Signed-off-by: John Linn <john.linn@xilinx.com>
	Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/tty/serial/xilinx_uartps.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 6e8ec6e9d5a2..fdc739b55eb3 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -953,7 +953,7 @@ static void xuartps_console_write(struct console *co, const char *s,
 {
 	struct uart_port *port = &xuartps_port[co->index];
 	unsigned long flags;
-	unsigned int imr;
+	unsigned int imr, ctrl;
 	int locked = 1;
 
 	if (oops_in_progress)
@@ -965,9 +965,19 @@ static void xuartps_console_write(struct console *co, const char *s,
 	imr = xuartps_readl(XUARTPS_IMR_OFFSET);
 	xuartps_writel(imr, XUARTPS_IDR_OFFSET);
 
+	/*
+	 * Make sure that the tx part is enabled. Set the TX enable bit and
+	 * clear the TX disable bit to enable the transmitter.
+	 */
+	ctrl = xuartps_readl(XUARTPS_CR_OFFSET);
+	xuartps_writel((ctrl & ~XUARTPS_CR_TX_DIS) | XUARTPS_CR_TX_EN,
+		XUARTPS_CR_OFFSET);
+
 	uart_console_write(port, s, count, xuartps_console_putchar);
 	xuartps_console_wait_tx(port);
 
+	xuartps_writel(ctrl, XUARTPS_CR_OFFSET);
+
 	/* restore interrupt state, it seems like there may be a h/w bug
 	 * in that the interrupt enable register should not need to be
 	 * written based on the data sheet
-- 
1.8.4.1

