Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab3CGMOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:14:53 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49736 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3CGMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/16] crisv10: use close delays from tty_port
Date: Thu,  7 Mar 2013 13:12:38 +0100
Message-Id: <1362658360-26629-14-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same as flags, convert to using close delays from tty_port.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/crisv10.c | 20 +++++++++-----------
 drivers/tty/serial/crisv10.h |  2 --
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index ec2dcc7..0e75ec33 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -3392,8 +3392,8 @@ get_serial_info(struct e100_serial * info,
 	tmp.irq = info->irq;
 	tmp.flags = info->port.flags;
 	tmp.baud_base = info->baud_base;
-	tmp.close_delay = info->close_delay;
-	tmp.closing_wait = info->closing_wait;
+	tmp.close_delay = info->port.close_delay;
+	tmp.closing_wait = info->port.closing_wait;
 	tmp.custom_divisor = info->custom_divisor;
 	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
 		return -EFAULT;
@@ -3415,7 +3415,7 @@ set_serial_info(struct e100_serial *info,
 
 	if (!capable(CAP_SYS_ADMIN)) {
 		if ((new_serial.type != info->type) ||
-		    (new_serial.close_delay != info->close_delay) ||
+		    (new_serial.close_delay != info->port.close_delay) ||
 		    ((new_serial.flags & ~ASYNC_USR_MASK) !=
 		     (info->port.flags & ~ASYNC_USR_MASK)))
 			return -EPERM;
@@ -3437,8 +3437,8 @@ set_serial_info(struct e100_serial *info,
 		       (new_serial.flags & ASYNC_FLAGS));
 	info->custom_divisor = new_serial.custom_divisor;
 	info->type = new_serial.type;
-	info->close_delay = new_serial.close_delay;
-	info->closing_wait = new_serial.closing_wait;
+	info->port.close_delay = new_serial.close_delay;
+	info->port.closing_wait = new_serial.closing_wait;
 	info->port.low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
  check_and_exit:
@@ -3794,8 +3794,8 @@ rs_close(struct tty_struct *tty, struct file * filp)
 	 * the line discipline to only process XON/XOFF characters.
 	 */
 	tty->closing = 1;
-	if (info->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, info->closing_wait);
+	if (info->port.closing_wait != ASYNC_CLOSING_WAIT_NONE)
+		tty_wait_until_sent(tty, info->port.closing_wait);
 	/*
 	 * At this point we stop accepting input.  To do this, we
 	 * disable the serial receiver and the DMA receive interrupt.
@@ -3825,8 +3825,8 @@ rs_close(struct tty_struct *tty, struct file * filp)
 	info->event = 0;
 	info->port.tty = NULL;
 	if (info->blocked_open) {
-		if (info->close_delay)
-			schedule_timeout_interruptible(info->close_delay);
+		if (info->port.close_delay)
+			schedule_timeout_interruptible(info->port.close_delay);
 		wake_up_interruptible(&info->open_wait);
 	}
 	info->port.flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
@@ -4440,8 +4440,6 @@ static int __init rs_init(void)
 		info->forced_eop = 0;
 		info->baud_base = DEF_BAUD_BASE;
 		info->custom_divisor = 0;
-		info->close_delay = 5*HZ/10;
-		info->closing_wait = 30*HZ;
 		info->x_char = 0;
 		info->event = 0;
 		info->count = 0;
diff --git a/drivers/tty/serial/crisv10.h b/drivers/tty/serial/crisv10.h
index 59f70c4..a05c36b 100644
--- a/drivers/tty/serial/crisv10.h
+++ b/drivers/tty/serial/crisv10.h
@@ -87,8 +87,6 @@ struct e100_serial {
 	volatile int		tr_running; /* 1 if output is running */
 
 	int			x_char;	/* xon/xoff character */
-	int			close_delay;
-	unsigned short		closing_wait;
 	unsigned long		event;
 	int			line;
 	int			type;  /* PORT_ETRAX */
-- 
1.8.1.4


