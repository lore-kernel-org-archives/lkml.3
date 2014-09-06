Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaIFRWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 13:22:35 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34150 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaIFRWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 13:22:32 -0400
From: Alexey Charkov <alchark@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Prisk <linux@prisktech.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Cc: Alexey Charkov <alchark@gmail.com>
Subject: [PATCH 4/4] tty: vt8500_serial: add polled console functions
Date: Sat,  6 Sep 2014 21:21:15 +0400
Message-Id: <1410024075-1354-5-git-send-email-alchark@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1410024075-1354-1-git-send-email-alchark@gmail.com>
References: <1410024075-1354-1-git-send-email-alchark@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds simple polling functions for single-character transmit
and receive, as used by kgdb.

Signed-off-by: Alexey Charkov <alchark@gmail.com>
---
 drivers/tty/serial/vt8500_serial.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index bfcebfd..b2bc9e8 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -566,6 +566,33 @@ static struct console vt8500_console = {
 #define VT8500_CONSOLE	NULL
 #endif
 
+#ifdef CONFIG_CONSOLE_POLL
+static int vt8500_get_poll_char(struct uart_port *port)
+{
+	unsigned int status = vt8500_read(port, VT8500_URFIDX);
+
+	if (!(status & 0x1f00))
+		return NO_POLL_CHAR;
+
+	return vt8500_read(port, VT8500_RXFIFO) & 0xff;
+}
+
+static void vt8500_put_poll_char(struct uart_port *port, unsigned char c)
+{
+	unsigned int status, tmout = 10000;
+
+	do {
+		status = vt8500_read(port, VT8500_URFIDX);
+
+		if (--tmout == 0)
+			break;
+		udelay(1);
+	} while (status & 0x10);
+
+	vt8500_write(port, c, VT8500_TXFIFO);
+}
+#endif
+
 static struct uart_ops vt8500_uart_pops = {
 	.tx_empty	= vt8500_tx_empty,
 	.set_mctrl	= vt8500_set_mctrl,
@@ -583,6 +610,10 @@ static struct uart_ops vt8500_uart_pops = {
 	.request_port	= vt8500_request_port,
 	.config_port	= vt8500_config_port,
 	.verify_port	= vt8500_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char	= vt8500_get_poll_char,
+	.poll_put_char	= vt8500_put_poll_char,
+#endif
 };
 
 static struct uart_driver vt8500_uart_driver = {
-- 
2.0.0

