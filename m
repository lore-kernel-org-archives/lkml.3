Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab3C0XfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:35:10 -0400
Received: from mail-qc0-f201.google.com ([209.85.216.201]:55486 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3C0Xew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:34:52 -0400
From: Michael Spang <spang@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org, Michael Spang <spang@chromium.org>
Subject: [PATCH 2/2] serial: samsung: Avoid waiting forever for TX ready
Date: Wed, 27 Mar 2013 19:34:25 -0400
Message-Id: <1364427265-5304-2-git-send-email-spang@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364427265-5304-1-git-send-email-spang@chromium.org>
References: <1364427265-5304-1-git-send-email-spang@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The no_console_suspend option allows the console to write to the UART
during early resume, before the serial port itself is resumed. Such
writes hang indefinitely waiting for TX ready.

This adds a check to the console putchar function to drop characters
instead of hanging if the port hasn't been initialized. That way, we
can use no_console_suspend without risk of hanging.

Signed-off-by: Michael Spang <spang@chromium.org>
---
 drivers/tty/serial/samsung.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 161a7a0..ca04901 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1363,6 +1363,13 @@ s3c24xx_serial_console_txrdy(struct uart_port *port, unsigned int ufcon)
 	return (utrstat & S3C2410_UTRSTAT_TXE) ? 1 : 0;
 }
 
+static bool
+s3c24xx_port_configured(unsigned int ucon)
+{
+	/* consider the serial port configured if the tx/rx mode set */
+	return (ucon & 0xf) != 0;
+}
+
 #ifdef CONFIG_CONSOLE_POLL
 /*
  * Console polling routines for writing and reading from the uart while
@@ -1385,6 +1392,11 @@ static void s3c24xx_serial_put_poll_char(struct uart_port *port,
 		unsigned char c)
 {
 	unsigned int ufcon = rd_regl(cons_uart, S3C2410_UFCON);
+	unsigned int ucon = rd_regl(cons_uart, S3C2410_UCON);
+
+	/* not possible to xmit on unconfigured port */
+	if (!s3c24xx_port_configured(ucon))
+		return;
 
 	while (!s3c24xx_serial_console_txrdy(port, ufcon))
 		cpu_relax();
@@ -1397,6 +1409,12 @@ static void
 s3c24xx_serial_console_putchar(struct uart_port *port, int ch)
 {
 	unsigned int ufcon = rd_regl(cons_uart, S3C2410_UFCON);
+	unsigned int ucon = rd_regl(cons_uart, S3C2410_UCON);
+
+	/* not possible to xmit on unconfigured port */
+	if (!s3c24xx_port_configured(ucon))
+		return;
+
 	while (!s3c24xx_serial_console_txrdy(port, ufcon))
 		barrier();
 	wr_regb(cons_uart, S3C2410_UTXH, ch);
@@ -1429,9 +1447,7 @@ s3c24xx_serial_get_options(struct uart_port *port, int *baud,
 	    "registers: ulcon=%08x, ucon=%08x, ubdriv=%08x\n",
 	    port, ulcon, ucon, ubrdiv);
 
-	if ((ucon & 0xf) != 0) {
-		/* consider the serial port configured if the tx/rx mode set */
-
+	if (s3c24xx_port_configured(ucon)) {
 		switch (ulcon & S3C2410_LCON_CSMASK) {
 		case S3C2410_LCON_CS5:
 			*bits = 5;
-- 
1.8.1.3

