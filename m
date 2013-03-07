Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab3CGMOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:14:02 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49746 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab3CGMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] crisv10: use flags from tty_port
Date: Thu,  7 Mar 2013 13:12:36 +0100
Message-Id: <1362658360-26629-12-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, remove STD_FLAGS as the value, or its subvalues
(ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST) is not tested anywhere --
there is no point to initialize flags to that. Second, use flags
member from tty_port when we have it now. So that we do not waste
space.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/crisv10.c | 64 ++++++++++++++++++++------------------------
 drivers/tty/serial/crisv10.h |  2 --
 2 files changed, 29 insertions(+), 37 deletions(-)

diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 1ace22c..ec2dcc7 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -169,7 +169,6 @@ static int get_lsr_info(struct e100_serial *info, unsigned int *value);
 
 
 #define DEF_BAUD 115200   /* 115.2 kbit/s */
-#define STD_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
 #define DEF_RX 0x20  /* or SERIAL_CTRL_W >> 8 */
 /* Default value of tx_ctrl register: has txd(bit 7)=1 (idle) as default */
 #define DEF_TX 0x80  /* or SERIAL_CTRL_B */
@@ -246,7 +245,6 @@ static struct e100_serial rs_table[] = {
 	  .ifirstadr   = R_DMA_CH7_FIRST,
 	  .icmdadr     = R_DMA_CH7_CMD,
 	  .idescradr   = R_DMA_CH7_DESCR,
-	  .flags       = STD_FLAGS,
 	  .rx_ctrl     = DEF_RX,
 	  .tx_ctrl     = DEF_TX,
 	  .iseteop     = 2,
@@ -300,7 +298,6 @@ static struct e100_serial rs_table[] = {
 	  .ifirstadr   = R_DMA_CH9_FIRST,
 	  .icmdadr     = R_DMA_CH9_CMD,
 	  .idescradr   = R_DMA_CH9_DESCR,
-	  .flags       = STD_FLAGS,
 	  .rx_ctrl     = DEF_RX,
 	  .tx_ctrl     = DEF_TX,
 	  .iseteop     = 3,
@@ -356,7 +353,6 @@ static struct e100_serial rs_table[] = {
 	  .ifirstadr   = R_DMA_CH3_FIRST,
 	  .icmdadr     = R_DMA_CH3_CMD,
 	  .idescradr   = R_DMA_CH3_DESCR,
-	  .flags       = STD_FLAGS,
 	  .rx_ctrl     = DEF_RX,
 	  .tx_ctrl     = DEF_TX,
 	  .iseteop     = 0,
@@ -410,7 +406,6 @@ static struct e100_serial rs_table[] = {
 	  .ifirstadr   = R_DMA_CH5_FIRST,
 	  .icmdadr     = R_DMA_CH5_CMD,
 	  .idescradr   = R_DMA_CH5_DESCR,
-	  .flags       = STD_FLAGS,
 	  .rx_ctrl     = DEF_RX,
 	  .tx_ctrl     = DEF_TX,
 	  .iseteop     = 1,
@@ -2719,7 +2714,7 @@ startup(struct e100_serial * info)
 
 	/* if it was already initialized, skip this */
 
-	if (info->flags & ASYNC_INITIALIZED) {
+	if (info->port.flags & ASYNC_INITIALIZED) {
 		local_irq_restore(flags);
 		free_page(xmit_page);
 		return 0;
@@ -2844,7 +2839,7 @@ startup(struct e100_serial * info)
 
 #endif /* CONFIG_SVINTO_SIM */
 
-	info->flags |= ASYNC_INITIALIZED;
+	info->port.flags |= ASYNC_INITIALIZED;
 
 	local_irq_restore(flags);
 	return 0;
@@ -2889,7 +2884,7 @@ shutdown(struct e100_serial * info)
 
 #endif /* CONFIG_SVINTO_SIM */
 
-	if (!(info->flags & ASYNC_INITIALIZED))
+	if (!(info->port.flags & ASYNC_INITIALIZED))
 		return;
 
 #ifdef SERIAL_DEBUG_OPEN
@@ -2920,7 +2915,7 @@ shutdown(struct e100_serial * info)
 	if (info->port.tty)
 		set_bit(TTY_IO_ERROR, &info->port.tty->flags);
 
-	info->flags &= ~ASYNC_INITIALIZED;
+	info->port.flags &= ~ASYNC_INITIALIZED;
 	local_irq_restore(flags);
 }
 
@@ -2945,7 +2940,7 @@ change_speed(struct e100_serial *info)
 	/* possibly, the tx/rx should be disabled first to do this safely */
 
 	/* change baud-rate and write it to the hardware */
-	if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST) {
+	if ((info->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST) {
 		/* Special baudrate */
 		u32 mask = 0xFF << (info->line*8); /* Each port has 8 bits */
 		unsigned long alt_source =
@@ -3395,7 +3390,7 @@ get_serial_info(struct e100_serial * info,
 	tmp.line = info->line;
 	tmp.port = (int)info->ioport;
 	tmp.irq = info->irq;
-	tmp.flags = info->flags;
+	tmp.flags = info->port.flags;
 	tmp.baud_base = info->baud_base;
 	tmp.close_delay = info->close_delay;
 	tmp.closing_wait = info->closing_wait;
@@ -3422,9 +3417,9 @@ set_serial_info(struct e100_serial *info,
 		if ((new_serial.type != info->type) ||
 		    (new_serial.close_delay != info->close_delay) ||
 		    ((new_serial.flags & ~ASYNC_USR_MASK) !=
-		     (info->flags & ~ASYNC_USR_MASK)))
+		     (info->port.flags & ~ASYNC_USR_MASK)))
 			return -EPERM;
-		info->flags = ((info->flags & ~ASYNC_USR_MASK) |
+		info->port.flags = ((info->port.flags & ~ASYNC_USR_MASK) |
 			       (new_serial.flags & ASYNC_USR_MASK));
 		goto check_and_exit;
 	}
@@ -3438,16 +3433,16 @@ set_serial_info(struct e100_serial *info,
 	 */
 
 	info->baud_base = new_serial.baud_base;
-	info->flags = ((info->flags & ~ASYNC_FLAGS) |
+	info->port.flags = ((info->port.flags & ~ASYNC_FLAGS) |
 		       (new_serial.flags & ASYNC_FLAGS));
 	info->custom_divisor = new_serial.custom_divisor;
 	info->type = new_serial.type;
 	info->close_delay = new_serial.close_delay;
 	info->closing_wait = new_serial.closing_wait;
-	info->port.low_latency = (info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	info->port.low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
  check_and_exit:
-	if (info->flags & ASYNC_INITIALIZED) {
+	if (info->port.flags & ASYNC_INITIALIZED) {
 		change_speed(info);
 	} else
 		retval = startup(info);
@@ -3787,12 +3782,12 @@ rs_close(struct tty_struct *tty, struct file * filp)
 		local_irq_restore(flags);
 		return;
 	}
-	info->flags |= ASYNC_CLOSING;
+	info->port.flags |= ASYNC_CLOSING;
 	/*
 	 * Save the termios structure, since this port may have
 	 * separate termios for callout and dialin.
 	 */
-	if (info->flags & ASYNC_NORMAL_ACTIVE)
+	if (info->port.flags & ASYNC_NORMAL_ACTIVE)
 		info->normal_termios = tty->termios;
 	/*
 	 * Now we wait for the transmit buffer to clear; and we notify
@@ -3813,7 +3808,7 @@ rs_close(struct tty_struct *tty, struct file * filp)
 	e100_disable_rx(info);
 	e100_disable_rx_irq(info);
 
-	if (info->flags & ASYNC_INITIALIZED) {
+	if (info->port.flags & ASYNC_INITIALIZED) {
 		/*
 		 * Before we drop DTR, make sure the UART transmitter
 		 * has completely drained; this is especially
@@ -3834,7 +3829,7 @@ rs_close(struct tty_struct *tty, struct file * filp)
 			schedule_timeout_interruptible(info->close_delay);
 		wake_up_interruptible(&info->open_wait);
 	}
-	info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
+	info->port.flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
 	wake_up_interruptible(&info->close_wait);
 	local_irq_restore(flags);
 
@@ -3929,7 +3924,7 @@ rs_hangup(struct tty_struct *tty)
 	shutdown(info);
 	info->event = 0;
 	info->count = 0;
-	info->flags &= ~ASYNC_NORMAL_ACTIVE;
+	info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->port.tty = NULL;
 	wake_up_interruptible(&info->open_wait);
 }
@@ -3953,11 +3948,11 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	 * until it's done, and then try again.
 	 */
 	if (tty_hung_up_p(filp) ||
-	    (info->flags & ASYNC_CLOSING)) {
+	    (info->port.flags & ASYNC_CLOSING)) {
 		wait_event_interruptible_tty(tty, info->close_wait,
-			!(info->flags & ASYNC_CLOSING));
+			!(info->port.flags & ASYNC_CLOSING));
 #ifdef SERIAL_DO_RESTART
-		if (info->flags & ASYNC_HUP_NOTIFY)
+		if (info->port.flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
 		else
 			return -ERESTARTSYS;
@@ -3972,7 +3967,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	 */
 	if ((filp->f_flags & O_NONBLOCK) ||
 	    (tty->flags & (1 << TTY_IO_ERROR))) {
-		info->flags |= ASYNC_NORMAL_ACTIVE;
+		info->port.flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
 
@@ -4008,9 +4003,9 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 		local_irq_restore(flags);
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
-		    !(info->flags & ASYNC_INITIALIZED)) {
+		    !(info->port.flags & ASYNC_INITIALIZED)) {
 #ifdef SERIAL_DO_RESTART
-			if (info->flags & ASYNC_HUP_NOTIFY)
+			if (info->port.flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
 				retval = -ERESTARTSYS;
@@ -4019,7 +4014,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 #endif
 			break;
 		}
-		if (!(info->flags & ASYNC_CLOSING) && do_clocal)
+		if (!(info->port.flags & ASYNC_CLOSING) && do_clocal)
 			/* && (do_clocal || DCD_IS_ASSERTED) */
 			break;
 		if (signal_pending(current)) {
@@ -4045,7 +4040,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 #endif
 	if (retval)
 		return retval;
-	info->flags |= ASYNC_NORMAL_ACTIVE;
+	info->port.flags |= ASYNC_NORMAL_ACTIVE;
 	return 0;
 }
 
@@ -4086,17 +4081,17 @@ rs_open(struct tty_struct *tty, struct file * filp)
 	tty->driver_data = info;
 	info->port.tty = tty;
 
-	info->port.low_latency = !!(info->flags & ASYNC_LOW_LATENCY);
+	info->port.low_latency = !!(info->port.flags & ASYNC_LOW_LATENCY);
 
 	/*
 	 * If the port is in the middle of closing, bail out now
 	 */
 	if (tty_hung_up_p(filp) ||
-	    (info->flags & ASYNC_CLOSING)) {
+	    (info->port.flags & ASYNC_CLOSING)) {
 		wait_event_interruptible_tty(tty, info->close_wait,
-			!(info->flags & ASYNC_CLOSING));
+			!(info->port.flags & ASYNC_CLOSING));
 #ifdef SERIAL_DO_RESTART
-		return ((info->flags & ASYNC_HUP_NOTIFY) ?
+		return ((info->port.flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 #else
 		return -EAGAIN;
@@ -4196,7 +4191,7 @@ rs_open(struct tty_struct *tty, struct file * filp)
 		return retval;
 	}
 
-	if ((info->count == 1) && (info->flags & ASYNC_SPLIT_TERMIOS)) {
+	if ((info->count == 1) && (info->port.flags & ASYNC_SPLIT_TERMIOS)) {
 		tty->termios = info->normal_termios;
 		change_speed(info);
 	}
@@ -4445,7 +4440,6 @@ static int __init rs_init(void)
 		info->forced_eop = 0;
 		info->baud_base = DEF_BAUD_BASE;
 		info->custom_divisor = 0;
-		info->flags = 0;
 		info->close_delay = 5*HZ/10;
 		info->closing_wait = 30*HZ;
 		info->x_char = 0;
diff --git a/drivers/tty/serial/crisv10.h b/drivers/tty/serial/crisv10.h
index ea0beb4..7146ed2 100644
--- a/drivers/tty/serial/crisv10.h
+++ b/drivers/tty/serial/crisv10.h
@@ -53,8 +53,6 @@ struct e100_serial {
 	volatile u8 *icmdadr;		/* adr to R_DMA_CHx_CMD */
 	volatile u32 *idescradr;	/* adr to R_DMA_CHx_DESCR */
 
-	int flags;	/* defined in tty.h */
-
 	u8 rx_ctrl;	/* shadow for R_SERIALx_REC_CTRL */
 	u8 tx_ctrl;	/* shadow for R_SERIALx_TR_CTRL */
 	u8 iseteop;	/* bit number for R_SET_EOP for the input dma */
-- 
1.8.1.4


