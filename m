Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3APNpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:45:18 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37065 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab3APNpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:45:16 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] TTY: ip22zilog, fix tty_flip_buffer_push call
Date: Wed, 16 Jan 2013 14:45:06 +0100
Message-Id: <1358343907-28142-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one was omitted by the "TTY: switch tty_flip_buffer_push" patch
because I did not compile-test mips driver. Now I do.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/ip22zilog.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/serial/ip22zilog.c b/drivers/tty/serial/ip22zilog.c
index 7b1cda5..cb3c81e 100644
--- a/drivers/tty/serial/ip22zilog.c
+++ b/drivers/tty/serial/ip22zilog.c
@@ -248,17 +248,12 @@ static void ip22zilog_maybe_update_regs(struct uart_ip22zilog_port *up,
 #define Rx_BRK 0x0100                   /* BREAK event software flag.  */
 #define Rx_SYS 0x0200                   /* SysRq event software flag.  */
 
-static struct tty_struct *ip22zilog_receive_chars(struct uart_ip22zilog_port *up,
+static bool ip22zilog_receive_chars(struct uart_ip22zilog_port *up,
 						  struct zilog_channel *channel)
 {
-	struct tty_struct *tty;
 	unsigned char ch, flag;
 	unsigned int r1;
-
-	tty = NULL;
-	if (up->port.state != NULL &&
-	    up->port.state->port.tty != NULL)
-		tty = up->port.state->port.tty;
+	bool push = up->port.state != NULL;
 
 	for (;;) {
 		ch = readb(&channel->control);
@@ -312,10 +307,10 @@ static struct tty_struct *ip22zilog_receive_chars(struct uart_ip22zilog_port *up
 		if (uart_handle_sysrq_char(&up->port, ch))
 			continue;
 
-		if (tty)
+		if (push)
 			uart_insert_char(&up->port, r1, Rx_OVR, ch, flag);
 	}
-	return tty;
+	return push;
 }
 
 static void ip22zilog_status_handle(struct uart_ip22zilog_port *up,
@@ -438,21 +433,20 @@ static irqreturn_t ip22zilog_interrupt(int irq, void *dev_id)
 	while (up) {
 		struct zilog_channel *channel
 			= ZILOG_CHANNEL_FROM_PORT(&up->port);
-		struct tty_struct *tty;
 		unsigned char r3;
+		bool push = false;
 
 		spin_lock(&up->port.lock);
 		r3 = read_zsreg(channel, R3);
 
 		/* Channel A */
-		tty = NULL;
 		if (r3 & (CHAEXT | CHATxIP | CHARxIP)) {
 			writeb(RES_H_IUS, &channel->control);
 			ZSDELAY();
 			ZS_WSYNC(channel);
 
 			if (r3 & CHARxIP)
-				tty = ip22zilog_receive_chars(up, channel);
+				push = ip22zilog_receive_chars(up, channel);
 			if (r3 & CHAEXT)
 				ip22zilog_status_handle(up, channel);
 			if (r3 & CHATxIP)
@@ -460,22 +454,22 @@ static irqreturn_t ip22zilog_interrupt(int irq, void *dev_id)
 		}
 		spin_unlock(&up->port.lock);
 
-		if (tty)
-			tty_flip_buffer_push(tty);
+		if (push)
+			tty_flip_buffer_push(&up->port.state->port);
 
 		/* Channel B */
 		up = up->next;
 		channel = ZILOG_CHANNEL_FROM_PORT(&up->port);
+		push = false;
 
 		spin_lock(&up->port.lock);
-		tty = NULL;
 		if (r3 & (CHBEXT | CHBTxIP | CHBRxIP)) {
 			writeb(RES_H_IUS, &channel->control);
 			ZSDELAY();
 			ZS_WSYNC(channel);
 
 			if (r3 & CHBRxIP)
-				tty = ip22zilog_receive_chars(up, channel);
+				push = ip22zilog_receive_chars(up, channel);
 			if (r3 & CHBEXT)
 				ip22zilog_status_handle(up, channel);
 			if (r3 & CHBTxIP)
@@ -483,8 +477,8 @@ static irqreturn_t ip22zilog_interrupt(int irq, void *dev_id)
 		}
 		spin_unlock(&up->port.lock);
 
-		if (tty)
-			tty_flip_buffer_push(tty);
+		if (push)
+			tty_flip_buffer_push(&up->port.state->port);
 
 		up = up->next;
 	}
-- 
1.8.1


