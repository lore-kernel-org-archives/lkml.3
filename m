Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab3CGMOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:14:47 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49743 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab3CGMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/16] crisv10: use counts from tty_port
Date: Thu,  7 Mar 2013 13:12:40 +0100
Message-Id: <1362658360-26629-16-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same as flags, convert to using open/close counts from tty_port.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/crisv10.c | 48 +++++++++++++++++++++-----------------------
 drivers/tty/serial/crisv10.h |  2 --
 2 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index ef5bca1..477f22f 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -3424,7 +3424,7 @@ set_serial_info(struct e100_serial *info,
 		goto check_and_exit;
 	}
 
-	if (info->count > 1)
+	if (info->port.count > 1)
 		return -EBUSY;
 
 	/*
@@ -3760,7 +3760,7 @@ rs_close(struct tty_struct *tty, struct file * filp)
 	printk("[%d] rs_close ttyS%d, count = %d\n", current->pid,
 	       info->line, info->count);
 #endif
-	if ((tty->count == 1) && (info->count != 1)) {
+	if ((tty->count == 1) && (info->port.count != 1)) {
 		/*
 		 * Uh, oh.  tty->count is 1, which means that the tty
 		 * structure will be freed.  Info->count should always
@@ -3770,15 +3770,15 @@ rs_close(struct tty_struct *tty, struct file * filp)
 		 */
 		printk(KERN_ERR
 		       "rs_close: bad serial port count; tty->count is 1, "
-		       "info->count is %d\n", info->count);
-		info->count = 1;
+		       "info->count is %d\n", info->port.count);
+		info->port.count = 1;
 	}
-	if (--info->count < 0) {
+	if (--info->port.count < 0) {
 		printk(KERN_ERR "rs_close: bad serial port count for ttyS%d: %d\n",
-		       info->line, info->count);
-		info->count = 0;
+		       info->line, info->port.count);
+		info->port.count = 0;
 	}
-	if (info->count) {
+	if (info->port.count) {
 		local_irq_restore(flags);
 		return;
 	}
@@ -3824,7 +3824,7 @@ rs_close(struct tty_struct *tty, struct file * filp)
 	tty->closing = 0;
 	info->event = 0;
 	info->port.tty = NULL;
-	if (info->blocked_open) {
+	if (info->port.blocked_open) {
 		if (info->port.close_delay)
 			schedule_timeout_interruptible(info->port.close_delay);
 		wake_up_interruptible(&info->port.open_wait);
@@ -3923,7 +3923,7 @@ rs_hangup(struct tty_struct *tty)
 	rs_flush_buffer(tty);
 	shutdown(info);
 	info->event = 0;
-	info->count = 0;
+	info->port.count = 0;
 	info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->port.tty = NULL;
 	wake_up_interruptible(&info->port.open_wait);
@@ -3978,7 +3978,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	/*
 	 * Block waiting for the carrier detect and the line to become
 	 * free (i.e., not in use by the callout).  While we are in
-	 * this loop, info->count is dropped by one, so that
+	 * this loop, info->port.count is dropped by one, so that
 	 * rs_close() knows when to free things.  We restore it upon
 	 * exit, either normal or abnormal.
 	 */
@@ -3986,15 +3986,15 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	add_wait_queue(&info->port.open_wait, &wait);
 #ifdef SERIAL_DEBUG_OPEN
 	printk("block_til_ready before block: ttyS%d, count = %d\n",
-	       info->line, info->count);
+	       info->line, info->port.count);
 #endif
 	local_irq_save(flags);
 	if (!tty_hung_up_p(filp)) {
 		extra_count++;
-		info->count--;
+		info->port.count--;
 	}
 	local_irq_restore(flags);
-	info->blocked_open++;
+	info->port.blocked_open++;
 	while (1) {
 		local_irq_save(flags);
 		/* assert RTS and DTR */
@@ -4023,7 +4023,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 		}
 #ifdef SERIAL_DEBUG_OPEN
 		printk("block_til_ready blocking: ttyS%d, count = %d\n",
-		       info->line, info->count);
+		       info->line, info->port.count);
 #endif
 		tty_unlock(tty);
 		schedule();
@@ -4032,11 +4032,11 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->port.open_wait, &wait);
 	if (extra_count)
-		info->count++;
-	info->blocked_open--;
+		info->port.count++;
+	info->port.blocked_open--;
 #ifdef SERIAL_DEBUG_OPEN
 	printk("block_til_ready after blocking: ttyS%d, count = %d\n",
-	       info->line, info->count);
+	       info->line, info->port.count);
 #endif
 	if (retval)
 		return retval;
@@ -4074,10 +4074,10 @@ rs_open(struct tty_struct *tty, struct file * filp)
 
 #ifdef SERIAL_DEBUG_OPEN
         printk("[%d] rs_open %s, count = %d\n", current->pid, tty->name,
- 	       info->count);
+ 	       info->port.count);
 #endif
 
-	info->count++;
+	info->port.count++;
 	tty->driver_data = info;
 	info->port.tty = tty;
 
@@ -4101,7 +4101,7 @@ rs_open(struct tty_struct *tty, struct file * filp)
 	/*
 	 * If DMA is enabled try to allocate the irq's.
 	 */
-	if (info->count == 1) {
+	if (info->port.count == 1) {
 		allocated_resources = 1;
 		if (info->dma_in_enabled) {
 			if (request_irq(info->dma_in_irq_nbr,
@@ -4174,7 +4174,7 @@ rs_open(struct tty_struct *tty, struct file * filp)
 		if (allocated_resources)
 			deinit_port(info);
 
-		/* FIXME Decrease count info->count here too? */
+		/* FIXME Decrease count info->port.count here too? */
 		return retval;
 	}
 
@@ -4191,7 +4191,7 @@ rs_open(struct tty_struct *tty, struct file * filp)
 		return retval;
 	}
 
-	if ((info->count == 1) && (info->port.flags & ASYNC_SPLIT_TERMIOS)) {
+	if ((info->port.count == 1) && (info->port.flags & ASYNC_SPLIT_TERMIOS)) {
 		tty->termios = info->normal_termios;
 		change_speed(info);
 	}
@@ -4442,8 +4442,6 @@ static int __init rs_init(void)
 		info->custom_divisor = 0;
 		info->x_char = 0;
 		info->event = 0;
-		info->count = 0;
-		info->blocked_open = 0;
 		info->normal_termios = driver->init_termios;
 		info->xmit.buf = NULL;
 		info->xmit.tail = info->xmit.head = 0;
diff --git a/drivers/tty/serial/crisv10.h b/drivers/tty/serial/crisv10.h
index 1cd2299..7599014 100644
--- a/drivers/tty/serial/crisv10.h
+++ b/drivers/tty/serial/crisv10.h
@@ -90,8 +90,6 @@ struct e100_serial {
 	unsigned long		event;
 	int			line;
 	int			type;  /* PORT_ETRAX */
-	int			count;	    /* # of fd on device */
-	int			blocked_open; /* # of blocked opens */
 	struct circ_buf		xmit;
 	struct etrax_recv_buffer *first_recv_buffer;
 	struct etrax_recv_buffer *last_recv_buffer;
-- 
1.8.1.4


