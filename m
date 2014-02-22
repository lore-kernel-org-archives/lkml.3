Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaBVMcN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 07:32:13 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:36105 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaBVMcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 07:32:11 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Beat Bolli <bbolli@ewanet.ch>, Pavel Roskin <proski@gnu.org>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        David Sterba <dsterba@suse.cz>, Felipe Balbi <balbi@ti.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Grant Edwards <grant.b.edwards@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, <stable@vger.kernel.org>
Subject: [PATCH] tty: Fix low_latency BUG
Date: Sat, 22 Feb 2014 07:31:21 -0500
Message-Id: <1393072281-5814-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user-settable knob, low_latency, has been the source of
several BUG reports which stem from flush_to_ldisc() running
in interrupt context. Since 3.12, which added several sleeping
locks (termios_rwsem and buf->lock) to the input processing path,
the frequency of these BUG reports has increased.

Note that changes in 3.12 did not introduce this regression;
sleeping locks were first added to the input processing path
with the removal of the BKL from N_TTY in commit
a88a69c91256418c5907c2f1f8a0ec0a36f9e6cc,
'n_tty: Fix loss of echoed characters and remove bkl from n_tty'
and later in commit 38db89799bdf11625a831c5af33938dcb11908b6,
'tty: throttling race fix'. Since those changes, executing
flush_to_ldisc() in interrupt_context (ie, low_latency set), is unsafe.

However, since most devices do not validate if the low_latency
setting is appropriate for the context (process or interrupt) in
which they receive data, some reports are due to misconfiguration.
Further, serial dma devices for which dma fails, resort to
interrupt receiving as a backup without resetting low_latency.

Historically, low_latency was used to force wake-up the reading
process rather than wait for the next scheduler tick. The
effect was to trim multiple milliseconds of latency from
when the process would receive new data.

Recent tests [1] have shown that the reading process now receives
data with only 10's of microseconds latency without low_latency set.

Remove the low_latency rx steering from tty_flip_buffer_push();
however, leave the knob as an optional hint to drivers that can
tune their rx fifos and such like. Cleanup stale code comments
regarding low_latency.

[1] https://lkml.org/lkml/2014/2/20/434

Reported-by: Beat Bolli <bbolli@ewanet.ch>
Reported-by: Pavel Roskin <proski@gnu.org>
Cc: Grant Edwards <grant.b.edwards@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: <stable@vger.kernel.org> # 3.12.x+
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/ipwireless/tty.c  |  3 ---
 drivers/tty/tty_buffer.c      | 20 ++++----------------
 drivers/usb/gadget/u_serial.c |  4 ++--
 include/linux/tty.h           |  2 +-
 4 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index ebd5bff..17ee3bf 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -176,9 +176,6 @@ void ipwireless_tty_received(struct ipw_tty *tty, unsigned char *data,
 				": %d chars not inserted to flip buffer!\n",
 				length - work);
 
-	/*
-	 * This may sleep if ->low_latency is set
-	 */
 	if (work)
 		tty_flip_buffer_push(&tty->port);
 }
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 765125d..8ebd9f8 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -351,14 +351,11 @@ EXPORT_SYMBOL(tty_insert_flip_string_flags);
  *	Takes any pending buffers and transfers their ownership to the
  *	ldisc side of the queue. It then schedules those characters for
  *	processing by the line discipline.
- *	Note that this function can only be used when the low_latency flag
- *	is unset. Otherwise the workqueue won't be flushed.
  */
 
 void tty_schedule_flip(struct tty_port *port)
 {
 	struct tty_bufhead *buf = &port->buf;
-	WARN_ON(port->low_latency);
 
 	buf->tail->commit = buf->tail->used;
 	schedule_work(&buf->work);
@@ -482,17 +479,15 @@ static void flush_to_ldisc(struct work_struct *work)
  */
 void tty_flush_to_ldisc(struct tty_struct *tty)
 {
-	if (!tty->port->low_latency)
-		flush_work(&tty->port->buf.work);
+	flush_work(&tty->port->buf.work);
 }
 
 /**
  *	tty_flip_buffer_push	-	terminal
  *	@port: tty port to push
  *
- *	Queue a push of the terminal flip buffers to the line discipline. This
- *	function must not be called from IRQ context if port->low_latency is
- *	set.
+ *	Queue a push of the terminal flip buffers to the line discipline.
+ *	Can be called from IRQ/atomic context.
  *
  *	In the event of the queue being busy for flipping the work will be
  *	held off and retried later.
@@ -500,14 +495,7 @@ void tty_flush_to_ldisc(struct tty_struct *tty)
 
 void tty_flip_buffer_push(struct tty_port *port)
 {
-	struct tty_bufhead *buf = &port->buf;
-
-	buf->tail->commit = buf->tail->used;
-
-	if (port->low_latency)
-		flush_to_ldisc(&buf->work);
-	else
-		schedule_work(&buf->work);
+	tty_schedule_flip(port);
 }
 EXPORT_SYMBOL(tty_flip_buffer_push);
 
diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index b369292..ad0aca8 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -549,8 +549,8 @@ static void gs_rx_push(unsigned long _port)
 		port->read_started--;
 	}
 
-	/* Push from tty to ldisc; without low_latency set this is handled by
-	 * a workqueue, so we won't get callbacks and can hold port_lock
+	/* Push from tty to ldisc; this is handled by a workqueue,
+	 * so we won't get callbacks and can hold port_lock
 	 */
 	if (do_push)
 		tty_flip_buffer_push(&port->port);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 4781d7b..1c3316a 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -208,7 +208,7 @@ struct tty_port {
 	wait_queue_head_t	delta_msr_wait;	/* Modem status change */
 	unsigned long		flags;		/* TTY flags ASY_*/
 	unsigned char		console:1,	/* port is a console */
-				low_latency:1;	/* direct buffer flush */
+				low_latency:1;	/* optional: tune for latency */
 	struct mutex		mutex;		/* Locking */
 	struct mutex		buf_mutex;	/* Buffer alloc lock */
 	unsigned char		*xmit_buf;	/* Optional buffer */
-- 
1.8.1.2

