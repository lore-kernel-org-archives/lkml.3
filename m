Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab3CGMOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:14:03 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49744 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757343Ab3CGMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] crisv10: use *_wait from tty_port
Date: Thu,  7 Mar 2013 13:12:39 +0100
Message-Id: <1362658360-26629-15-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same as flags, convert to using *_wait queues from tty_port.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/crisv10.c | 16 +++++++---------
 drivers/tty/serial/crisv10.h |  2 --
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 0e75ec33..ef5bca1 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -3827,10 +3827,10 @@ rs_close(struct tty_struct *tty, struct file * filp)
 	if (info->blocked_open) {
 		if (info->port.close_delay)
 			schedule_timeout_interruptible(info->port.close_delay);
-		wake_up_interruptible(&info->open_wait);
+		wake_up_interruptible(&info->port.open_wait);
 	}
 	info->port.flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
-	wake_up_interruptible(&info->close_wait);
+	wake_up_interruptible(&info->port.close_wait);
 	local_irq_restore(flags);
 
 	/* port closed */
@@ -3926,7 +3926,7 @@ rs_hangup(struct tty_struct *tty)
 	info->count = 0;
 	info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->port.tty = NULL;
-	wake_up_interruptible(&info->open_wait);
+	wake_up_interruptible(&info->port.open_wait);
 }
 
 /*
@@ -3949,7 +3949,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	 */
 	if (tty_hung_up_p(filp) ||
 	    (info->port.flags & ASYNC_CLOSING)) {
-		wait_event_interruptible_tty(tty, info->close_wait,
+		wait_event_interruptible_tty(tty, info->port.close_wait,
 			!(info->port.flags & ASYNC_CLOSING));
 #ifdef SERIAL_DO_RESTART
 		if (info->port.flags & ASYNC_HUP_NOTIFY)
@@ -3983,7 +3983,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	 * exit, either normal or abnormal.
 	 */
 	retval = 0;
-	add_wait_queue(&info->open_wait, &wait);
+	add_wait_queue(&info->port.open_wait, &wait);
 #ifdef SERIAL_DEBUG_OPEN
 	printk("block_til_ready before block: ttyS%d, count = %d\n",
 	       info->line, info->count);
@@ -4030,7 +4030,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 		tty_lock(tty);
 	}
 	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&info->open_wait, &wait);
+	remove_wait_queue(&info->port.open_wait, &wait);
 	if (extra_count)
 		info->count++;
 	info->blocked_open--;
@@ -4088,7 +4088,7 @@ rs_open(struct tty_struct *tty, struct file * filp)
 	 */
 	if (tty_hung_up_p(filp) ||
 	    (info->port.flags & ASYNC_CLOSING)) {
-		wait_event_interruptible_tty(tty, info->close_wait,
+		wait_event_interruptible_tty(tty, info->port.close_wait,
 			!(info->port.flags & ASYNC_CLOSING));
 #ifdef SERIAL_DO_RESTART
 		return ((info->port.flags & ASYNC_HUP_NOTIFY) ?
@@ -4445,8 +4445,6 @@ static int __init rs_init(void)
 		info->count = 0;
 		info->blocked_open = 0;
 		info->normal_termios = driver->init_termios;
-		init_waitqueue_head(&info->open_wait);
-		init_waitqueue_head(&info->close_wait);
 		info->xmit.buf = NULL;
 		info->xmit.tail = info->xmit.head = 0;
 		info->first_recv_buffer = info->last_recv_buffer = NULL;
diff --git a/drivers/tty/serial/crisv10.h b/drivers/tty/serial/crisv10.h
index a05c36b..1cd2299 100644
--- a/drivers/tty/serial/crisv10.h
+++ b/drivers/tty/serial/crisv10.h
@@ -101,8 +101,6 @@ struct e100_serial {
 	struct work_struct	work;
 	struct async_icount	icount;   /* error-statistics etc.*/
 	struct ktermios		normal_termios;
-	wait_queue_head_t	open_wait;
-	wait_queue_head_t	close_wait;
 
 	unsigned long char_time_usec;       /* The time for 1 char, in usecs */
 	unsigned long flush_time_usec;      /* How often we should flush */
-- 
1.8.1.4


