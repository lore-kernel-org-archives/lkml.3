Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab3CGO6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:58:19 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:50342 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab3CGO5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:57:03 -0500
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 5/6] TTY: clean up port drain-delay handling
Date: Thu,  7 Mar 2013 15:55:52 +0100
Message-Id: <1362668153-10972-6-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1362668153-10972-1-git-send-email-jhovold@gmail.com>
References: <51361724.4050107@suse.cz>
 <1362668153-10972-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move port drain-delay handling to a separate function.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/tty/tty_port.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index cd65f7e..048cc85 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -408,6 +408,20 @@ int tty_port_block_til_ready(struct tty_port *port,
 }
 EXPORT_SYMBOL(tty_port_block_til_ready);
 
+static void tty_port_drain_delay(struct tty_port *port, struct tty_struct *tty)
+{
+	unsigned int bps = tty_get_baud_rate(tty);
+	long timeout;
+
+	if (bps > 1200) {
+		timeout = (HZ * 10 * port->drain_delay) / bps;
+		timeout = max_t(long, timeout, HZ / 10);
+	} else {
+		timeout = 2 * HZ;
+	}
+	schedule_timeout_interruptible(timeout);
+}
+
 int tty_port_close_start(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp)
 {
@@ -446,17 +460,8 @@ int tty_port_close_start(struct tty_port *port,
 	if (test_bit(ASYNCB_INITIALIZED, &port->flags) &&
 			port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
 		tty_wait_until_sent_from_close(tty, port->closing_wait);
-	if (port->drain_delay) {
-		unsigned int bps = tty_get_baud_rate(tty);
-		long timeout;
-
-		if (bps > 1200)
-			timeout = max_t(long,
-				(HZ * 10 * port->drain_delay) / bps, HZ / 10);
-		else
-			timeout = 2 * HZ;
-		schedule_timeout_interruptible(timeout);
-	}
+	if (port->drain_delay)
+		tty_port_drain_delay(port, tty);
 	/* Flush the ldisc buffering */
 	tty_ldisc_flush(tty);
 
-- 
1.8.1.1

