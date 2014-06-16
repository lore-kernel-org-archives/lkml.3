Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaFPNV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:21:57 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:55936 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750953AbaFPNVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:21:53 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>,
        Sonic Zhang <sonic.zhang@analog.com>,
        adi-buildroot-devel@lists.sourceforge.net
Subject: [PATCH tty-next 13/22] serial: blackfin: Fix CTS flow control
Date: Mon, 16 Jun 2014 09:17:10 -0400
Message-Id: <1402924639-5164-14-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blackfin uart port drivers mistakenly set the struct uart_port
flags bit UPF_BUG_THRE (which only has meaning to the 8250 core)
while trying to set ASYNC_CTS_FLOW.

Uart port drivers can override termios settings based on actual
hardware support in their .set_termios method; the serial core
sets the appropriate port flags based on the overrides.
Overriding only the initial termios settings is accomplished
by only perform those overrides if the old termios parameter is
NULL.

CC: Sonic Zhang <sonic.zhang@analog.com>
CC: adi-buildroot-devel@lists.sourceforge.net
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/bfin_sport_uart.c | 11 ++++++++---
 drivers/tty/serial/bfin_uart.c       | 13 ++++++++-----
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/bfin_sport_uart.c b/drivers/tty/serial/bfin_sport_uart.c
index 4f22970..5a1342e 100644
--- a/drivers/tty/serial/bfin_sport_uart.c
+++ b/drivers/tty/serial/bfin_sport_uart.c
@@ -500,6 +500,13 @@ static void sport_set_termios(struct uart_port *port,
 
 	pr_debug("%s enter, c_cflag:%08x\n", __func__, termios->c_cflag);
 
+#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+	if (old == NULL && up->cts_pin != -1)
+		termios->c_cflag |= CRTSCTS;
+	else if (up->cts_pin == -1)
+		termios->c_cflag &= ~CRTSCTS;
+#endif
+
 	switch (termios->c_cflag & CSIZE) {
 	case CS8:
 		up->csize = 8;
@@ -813,10 +820,8 @@ static int sport_uart_probe(struct platform_device *pdev)
 		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 		if (res == NULL)
 			sport->cts_pin = -1;
-		else {
+		else
 			sport->cts_pin = res->start;
-			sport->port.flags |= ASYNC_CTS_FLOW;
-		}
 
 		res = platform_get_resource(pdev, IORESOURCE_IO, 1);
 		if (res == NULL)
diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index 869ceba..c641064 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -793,6 +793,13 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 	unsigned int ier, lcr = 0;
 	unsigned long timeout;
 
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	if (old == NULL && uart->cts_pin != -1)
+		termios->c_cflag |= CRTSCTS;
+	else if (uart->cts_pin == -1)
+		termios->c_cflag &= ~CRTSCTS;
+#endif
+
 	switch (termios->c_cflag & CSIZE) {
 	case CS8:
 		lcr = WLS(8);
@@ -1325,12 +1332,8 @@ static int bfin_serial_probe(struct platform_device *pdev)
 		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 		if (res == NULL)
 			uart->cts_pin = -1;
-		else {
+		else
 			uart->cts_pin = res->start;
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-			uart->port.flags |= ASYNC_CTS_FLOW;
-#endif
-		}
 
 		res = platform_get_resource(pdev, IORESOURCE_IO, 1);
 		if (res == NULL)
-- 
2.0.0

