Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab3CGO5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:57:30 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:55591 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3CGO5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:57:04 -0500
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 4/6] TTY: fix DTR not being dropped on hang up
Date: Thu,  7 Mar 2013 15:55:51 +0100
Message-Id: <1362668153-10972-5-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1362668153-10972-1-git-send-email-jhovold@gmail.com>
References: <51361724.4050107@suse.cz>
 <1362668153-10972-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move HUPCL handling to port shutdown so that DTR is dropped also on hang
up (tty_port_close is a noop for hung-up ports).

Also do not try to drop DTR for uninitialised ports where it has never
been raised (e.g. after a failed open).

Note that this is also the current behaviour of serial-core.

Nine drivers currently call tty_port_close_start directly (rather than
through tty_port_close) and seven of them lower DTR as part of their
close (if the port has been initialised). Fixup the remaining two
drivers so that it continues to be lowered also on normal (non-HUP)
close. [ Note that most of those other seven drivers did not expect DTR
to have been dropped by tty_port_close_start in the first place. ]

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/tty/mxser.c    |  4 ++++
 drivers/tty/n_gsm.c    |  4 ++++
 drivers/tty/tty_port.c | 27 +++++++++++++++------------
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 484b6a3..d996038 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -1084,6 +1084,10 @@ static void mxser_close(struct tty_struct *tty, struct file *filp)
 	mutex_lock(&port->mutex);
 	mxser_close_port(port);
 	mxser_flush_buffer(tty);
+	if (test_bit(ASYNCB_INITIALIZED, &port->flags)) {
+		if (C_HUPCL(tty))
+			tty_port_lower_dtr_rts(port);
+	}
 	mxser_shutdown_port(port);
 	clear_bit(ASYNCB_INITIALIZED, &port->flags);
 	mutex_unlock(&port->mutex);
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 4a43ef5d7..a43b01f 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2968,6 +2968,10 @@ static void gsmtty_close(struct tty_struct *tty, struct file *filp)
 	if (tty_port_close_start(&dlci->port, tty, filp) == 0)
 		goto out;
 	gsm_dlci_begin_close(dlci);
+	if (test_bit(ASYNCB_INITIALIZED, &dlci->port.flags)) {
+		if (C_HUPCL(tty))
+			tty_port_lower_dtr_rts(&dlci->port);
+	}
 	tty_port_close_end(&dlci->port, tty);
 	tty_port_tty_set(&dlci->port, NULL);
 out:
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 52f1066..cd65f7e 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -196,13 +196,20 @@ void tty_port_tty_set(struct tty_port *port, struct tty_struct *tty)
 }
 EXPORT_SYMBOL(tty_port_tty_set);
 
-static void tty_port_shutdown(struct tty_port *port)
+static void tty_port_shutdown(struct tty_port *port, struct tty_struct *tty)
 {
 	mutex_lock(&port->mutex);
 	if (port->console)
 		goto out;
 
 	if (test_and_clear_bit(ASYNCB_INITIALIZED, &port->flags)) {
+		/*
+		 * Drop DTR/RTS if HUPCL is set. This causes any attached
+		 * modem to hang up the line.
+		 */
+		if (tty && C_HUPCL(tty))
+			tty_port_lower_dtr_rts(port);
+
 		if (port->ops->shutdown)
 			port->ops->shutdown(port);
 	}
@@ -220,18 +227,19 @@ out:
 
 void tty_port_hangup(struct tty_port *port)
 {
+	struct tty_struct *tty;
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
 	port->count = 0;
 	port->flags &= ~ASYNC_NORMAL_ACTIVE;
-	if (port->tty) {
-		set_bit(TTY_IO_ERROR, &port->tty->flags);
-		tty_kref_put(port->tty);
-	}
+	tty = port->tty;
+	if (tty)
+		set_bit(TTY_IO_ERROR, &tty->flags);
 	port->tty = NULL;
 	spin_unlock_irqrestore(&port->lock, flags);
-	tty_port_shutdown(port);
+	tty_port_shutdown(port, tty);
+	tty_kref_put(tty);
 	wake_up_interruptible(&port->open_wait);
 	wake_up_interruptible(&port->delta_msr_wait);
 }
@@ -452,11 +460,6 @@ int tty_port_close_start(struct tty_port *port,
 	/* Flush the ldisc buffering */
 	tty_ldisc_flush(tty);
 
-	/* Drop DTR/RTS if HUPCL is set. This causes any attached modem to
-	   hang up the line */
-	if (tty->termios.c_cflag & HUPCL)
-		tty_port_lower_dtr_rts(port);
-
 	/* Don't call port->drop for the last reference. Callers will want
 	   to drop the last active reference in ->shutdown() or the tty
 	   shutdown path */
@@ -491,7 +494,7 @@ void tty_port_close(struct tty_port *port, struct tty_struct *tty,
 {
 	if (tty_port_close_start(port, tty, filp) == 0)
 		return;
-	tty_port_shutdown(port);
+	tty_port_shutdown(port, tty);
 	set_bit(TTY_IO_ERROR, &tty->flags);
 	tty_port_close_end(port, tty);
 	tty_port_tty_set(port, NULL);
-- 
1.8.1.1

