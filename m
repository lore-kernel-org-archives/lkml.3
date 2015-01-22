Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbbAVR0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:26:38 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:47126 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbbAVRY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:24:56 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3/7] serial: 8250: Refactor LCR computation
Date: Thu, 22 Jan 2015 12:24:27 -0500
Message-Id: <1421947471-6396-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421947471-6396-1-git-send-email-peter@hurleysoftware.com>
References: <1421947471-6396-1-git-send-email-peter@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the computation of the LCR register value from termios c_cflag
into a new local function, serial8250_compute_lcr().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_core.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index fa40982..77afa5f 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2417,16 +2417,12 @@ static unsigned int serial8250_get_divisor(struct uart_8250_port *up, unsigned i
 	return quot;
 }
 
-void
-serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
-		          struct ktermios *old)
+static unsigned char serial8250_compute_lcr(struct uart_8250_port *up,
+					    tcflag_t c_cflag)
 {
-	struct uart_8250_port *up = up_to_u8250p(port);
 	unsigned char cval;
-	unsigned long flags;
-	unsigned int baud, quot;
 
-	switch (termios->c_cflag & CSIZE) {
+	switch (c_cflag & CSIZE) {
 	case CS5:
 		cval = UART_LCR_WLEN5;
 		break;
@@ -2442,20 +2438,34 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 		break;
 	}
 
-	if (termios->c_cflag & CSTOPB)
+	if (c_cflag & CSTOPB)
 		cval |= UART_LCR_STOP;
-	if (termios->c_cflag & PARENB) {
+	if (c_cflag & PARENB) {
 		cval |= UART_LCR_PARITY;
 		if (up->bugs & UART_BUG_PARITY)
 			up->fifo_bug = true;
 	}
-	if (!(termios->c_cflag & PARODD))
+	if (!(c_cflag & PARODD))
 		cval |= UART_LCR_EPAR;
 #ifdef CMSPAR
-	if (termios->c_cflag & CMSPAR)
+	if (c_cflag & CMSPAR)
 		cval |= UART_LCR_SPAR;
 #endif
 
+	return cval;
+}
+
+void
+serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
+		          struct ktermios *old)
+{
+	struct uart_8250_port *up = up_to_u8250p(port);
+	unsigned char cval;
+	unsigned long flags;
+	unsigned int baud, quot;
+
+	cval = serial8250_compute_lcr(up, termios->c_cflag);
+
 	/*
 	 * Ask the core to calculate the divisor for us.
 	 */
-- 
2.2.2

