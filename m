Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaDUQkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:40:45 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:33905 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaDUQkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:40:40 -0400
From: Doug Anderson <dianders@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-samsung-soc@vger.kernel.org
Cc: olof@lixom.net, Doug Anderson <dianders@chromium.org>, jslaby@suse.cz,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] serial: samsung: don't check config for every character
Date: Mon, 21 Apr 2014 09:40:35 -0700
Message-Id: <1398098436-31895-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1398098436-31895-1-git-send-email-dianders@chromium.org>
References: <1398098436-31895-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The s3c24xx_serial_console_putchar() is _only_ ever used by
s3c24xx_serial_console_write() and is called in a loop (indirectly
through uart_console_write()).  There's no reason to call
s3c24xx_port_configured() for every iteration through the loop.  Move
it outside the loop.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/tty/serial/samsung.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index a8e8b79..12442748 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1464,11 +1464,6 @@ static void
 s3c24xx_serial_console_putchar(struct uart_port *port, int ch)
 {
 	unsigned int ufcon = rd_regl(port, S3C2410_UFCON);
-	unsigned int ucon = rd_regl(port, S3C2410_UCON);
-
-	/* not possible to xmit on unconfigured port */
-	if (!s3c24xx_port_configured(ucon))
-		return;
 
 	while (!s3c24xx_serial_console_txrdy(port, ufcon))
 		barrier();
@@ -1479,6 +1474,12 @@ static void
 s3c24xx_serial_console_write(struct console *co, const char *s,
 			     unsigned int count)
 {
+	unsigned int ucon = rd_regl(cons_uart, S3C2410_UCON);
+
+	/* not possible to xmit on unconfigured port */
+	if (!s3c24xx_port_configured(ucon))
+		return;
+
 	uart_console_write(cons_uart, s, count, s3c24xx_serial_console_putchar);
 }
 
-- 
1.9.1.423.g4596e3a

