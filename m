Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaDUQl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:41:28 -0400
Received: from mail-vc0-f201.google.com ([209.85.220.201]:61526 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbaDUQkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:40:40 -0400
From: Doug Anderson <dianders@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-samsung-soc@vger.kernel.org
Cc: olof@lixom.net, Doug Anderson <dianders@chromium.org>, jslaby@suse.cz,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] serial: samsung: Use the passed in "port", fixing kgdb w/ no console
Date: Mon, 21 Apr 2014 09:40:34 -0700
Message-Id: <1398098436-31895-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two functions in the samsung serial driver used for writing
characters out to the port were inconsistent about whether they used
the passed in "port" or the global "cons_uart".  There was no reason
to use the global and the use of the global in
s3c24xx_serial_put_poll_char() caused a crash in the case where you
used the serial port for kgdboc but not for console.

Fix it so we used the passed in variable.

Note that this doesn't fix all problems with the samsung serial
driver.  Specifically:
* s3c24xx_serial_console_putchar() is still 99% identical to
  s3c24xx_serial_put_poll_char() (the function signature is different,
  but that's about it).  A future patch will make them slightly less
  identical and judging by other serial drivers we may need yet more
  differences eventually.
* The samsung serial driver still doesn't allow you to have more than
  one console port since it still uses the global cons_uart in
  s3c24xx_serial_console_write().

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/tty/serial/samsung.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 23f4596..a8e8b79 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1446,8 +1446,8 @@ static int s3c24xx_serial_get_poll_char(struct uart_port *port)
 static void s3c24xx_serial_put_poll_char(struct uart_port *port,
 		unsigned char c)
 {
-	unsigned int ufcon = rd_regl(cons_uart, S3C2410_UFCON);
-	unsigned int ucon = rd_regl(cons_uart, S3C2410_UCON);
+	unsigned int ufcon = rd_regl(port, S3C2410_UFCON);
+	unsigned int ucon = rd_regl(port, S3C2410_UCON);
 
 	/* not possible to xmit on unconfigured port */
 	if (!s3c24xx_port_configured(ucon))
@@ -1455,7 +1455,7 @@ static void s3c24xx_serial_put_poll_char(struct uart_port *port,
 
 	while (!s3c24xx_serial_console_txrdy(port, ufcon))
 		cpu_relax();
-	wr_regb(cons_uart, S3C2410_UTXH, c);
+	wr_regb(port, S3C2410_UTXH, c);
 }
 
 #endif /* CONFIG_CONSOLE_POLL */
@@ -1463,8 +1463,8 @@ static void s3c24xx_serial_put_poll_char(struct uart_port *port,
 static void
 s3c24xx_serial_console_putchar(struct uart_port *port, int ch)
 {
-	unsigned int ufcon = rd_regl(cons_uart, S3C2410_UFCON);
-	unsigned int ucon = rd_regl(cons_uart, S3C2410_UCON);
+	unsigned int ufcon = rd_regl(port, S3C2410_UFCON);
+	unsigned int ucon = rd_regl(port, S3C2410_UCON);
 
 	/* not possible to xmit on unconfigured port */
 	if (!s3c24xx_port_configured(ucon))
@@ -1472,7 +1472,7 @@ s3c24xx_serial_console_putchar(struct uart_port *port, int ch)
 
 	while (!s3c24xx_serial_console_txrdy(port, ufcon))
 		barrier();
-	wr_regb(cons_uart, S3C2410_UTXH, ch);
+	wr_regb(port, S3C2410_UTXH, ch);
 }
 
 static void
-- 
1.9.1.423.g4596e3a

