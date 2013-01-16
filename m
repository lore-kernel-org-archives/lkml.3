Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab3APNpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:45:19 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37067 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3APNpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:45:16 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] TTY: mn10300-serial, fix build breakage
Date: Wed, 16 Jan 2013 14:45:07 +0100
Message-Id: <1358343907-28142-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1358343907-28142-1-git-send-email-jslaby@suse.cz>
References: <1358343907-28142-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the recent `switch flipping' patches we introduced a build failure
in the driver:
mn10300-serial.c:527:19: error: 'port' redeclared as different kind of symbol

I did not notice because I did not even find a compiler for that new
architecture. Hopefully everything is all right now as I cannot test
it.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/mn10300/kernel/mn10300-serial.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index 1dd20db..bf6e949 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -524,7 +524,7 @@ static int mask_test_and_clear(volatile u8 *ptr, u8 mask)
 static void mn10300_serial_receive_interrupt(struct mn10300_serial_port *port)
 {
 	struct uart_icount *icount = &port->uart.icount;
-	struct tty_port *port = &port->uart.state->port;
+	struct tty_port *tport = &port->uart.state->port;
 	unsigned ix;
 	int count;
 	u8 st, ch, push, status, overrun;
@@ -534,10 +534,10 @@ static void mn10300_serial_receive_interrupt(struct mn10300_serial_port *port)
 	push = 0;
 
 	count = CIRC_CNT(port->rx_inp, port->rx_outp, MNSC_BUFFER_SIZE);
-	count = tty_buffer_request_room(port, count);
+	count = tty_buffer_request_room(tport, count);
 	if (count == 0) {
-		if (!port->low_latency)
-			tty_flip_buffer_push(port);
+		if (!tport->low_latency)
+			tty_flip_buffer_push(tport);
 		return;
 	}
 
@@ -545,8 +545,8 @@ try_again:
 	/* pull chars out of the hat */
 	ix = ACCESS_ONCE(port->rx_outp);
 	if (CIRC_CNT(port->rx_inp, ix, MNSC_BUFFER_SIZE) == 0) {
-		if (push && !port->low_latency)
-			tty_flip_buffer_push(port);
+		if (push && !tport->low_latency)
+			tty_flip_buffer_push(tport);
 		return;
 	}
 
@@ -666,19 +666,19 @@ insert:
 		else
 			flag = TTY_NORMAL;
 
-		tty_insert_flip_char(port, ch, flag);
+		tty_insert_flip_char(tport, ch, flag);
 	}
 
 	/* overrun is special, since it's reported immediately, and doesn't
 	 * affect the current character
 	 */
 	if (overrun)
-		tty_insert_flip_char(port, 0, TTY_OVERRUN);
+		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
 
 	count--;
 	if (count <= 0) {
-		if (!port->low_latency)
-			tty_flip_buffer_push(port);
+		if (!tport->low_latency)
+			tty_flip_buffer_push(tport);
 		return;
 	}
 
-- 
1.8.1


