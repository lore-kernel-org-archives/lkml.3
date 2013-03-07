Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab3CGMOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:14:00 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49747 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757374Ab3CGMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/16] TTY: cleanup tty->hw_stopped uses
Date: Thu,  7 Mar 2013 13:12:34 +0100
Message-Id: <1362658360-26629-10-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty->hw_stopped is set only by drivers to remember HW state. If it is
never set to 1 in a particular driver, there is no need to check it in
the driver at all. Remove such checks.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/ia64/hp/sim/simserial.c     | 16 +++-------------
 drivers/isdn/i4l/isdn_tty.c      |  3 ---
 drivers/net/caif/caif_serial.c   |  1 -
 drivers/tty/rocket.c             | 19 ++++++++-----------
 drivers/tty/serial/68328serial.c |  9 +++------
 drivers/tty/serial/arc_uart.c    |  2 +-
 drivers/tty/serial/crisv10.c     | 12 ++----------
 7 files changed, 17 insertions(+), 45 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index da2f319..e70cade 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -142,8 +142,7 @@ static void transmit_chars(struct tty_struct *tty, struct serial_state *info,
 		goto out;
 	}
 
-	if (info->xmit.head == info->xmit.tail || tty->stopped ||
-			tty->hw_stopped) {
+	if (info->xmit.head == info->xmit.tail || tty->stopped) {
 #ifdef SIMSERIAL_DEBUG
 		printk("transmit_chars: head=%d, tail=%d, stopped=%d\n",
 		       info->xmit.head, info->xmit.tail, tty->stopped);
@@ -181,7 +180,7 @@ static void rs_flush_chars(struct tty_struct *tty)
 	struct serial_state *info = tty->driver_data;
 
 	if (info->xmit.head == info->xmit.tail || tty->stopped ||
-			tty->hw_stopped || !info->xmit.buf)
+			!info->xmit.buf)
 		return;
 
 	transmit_chars(tty, info, NULL);
@@ -217,7 +216,7 @@ static int rs_write(struct tty_struct * tty,
 	 * Hey, we transmit directly from here in our case
 	 */
 	if (CIRC_CNT(info->xmit.head, info->xmit.tail, SERIAL_XMIT_SIZE) &&
-			!tty->stopped && !tty->hw_stopped)
+			!tty->stopped)
 		transmit_chars(tty, info, NULL);
 
 	return ret;
@@ -325,14 +324,6 @@ static int rs_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 
 #define RELEVANT_IFLAG(iflag) (iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
 
-static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
-{
-	/* Handle turning off CRTSCTS */
-	if ((old_termios->c_cflag & CRTSCTS) &&
-	    !(tty->termios.c_cflag & CRTSCTS)) {
-		tty->hw_stopped = 0;
-	}
-}
 /*
  * This routine will shutdown a serial port; interrupts are disabled, and
  * DTR is dropped if the hangup on close termio flag is on.
@@ -481,7 +472,6 @@ static const struct tty_operations hp_ops = {
 	.throttle = rs_throttle,
 	.unthrottle = rs_unthrottle,
 	.send_xchar = rs_send_xchar,
-	.set_termios = rs_set_termios,
 	.hangup = rs_hangup,
 	.proc_fops = &rs_proc_fops,
 };
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index d8a7d83..2210766 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1470,9 +1470,6 @@ isdn_tty_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 		    tty->termios.c_ospeed == old_termios->c_ospeed)
 			return;
 		isdn_tty_change_speed(info);
-		if ((old_termios->c_cflag & CRTSCTS) &&
-		    !(tty->termios.c_cflag & CRTSCTS))
-			tty->hw_stopped = 0;
 	}
 }
 
diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 666891a..d1bf0ff 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -88,7 +88,6 @@ static inline void update_tty_status(struct ser_device *ser)
 {
 	ser->tty_status =
 		ser->tty->stopped << 5 |
-		ser->tty->hw_stopped << 4 |
 		ser->tty->flow_stopped << 3 |
 		ser->tty->packet << 2 |
 		ser->tty->port->low_latency << 1 |
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index bbffd7a..f5abc28 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -449,7 +449,7 @@ static void rp_do_transmit(struct r_port *info)
 
 	/*  Loop sending data to FIFO until done or FIFO full */
 	while (1) {
-		if (tty->stopped || tty->hw_stopped)
+		if (tty->stopped)
 			break;
 		c = min(info->xmit_fifo_room, info->xmit_cnt);
 		c = min(c, XMIT_BUF_SIZE - info->xmit_tail);
@@ -1106,15 +1106,12 @@ static void rp_set_termios(struct tty_struct *tty,
 
 	/* Handle transition away from B0 status */
 	if (!(old_termios->c_cflag & CBAUD) && (tty->termios.c_cflag & CBAUD)) {
-		if (!tty->hw_stopped || !(tty->termios.c_cflag & CRTSCTS))
-			sSetRTS(cp);
+		sSetRTS(cp);
 		sSetDTR(cp);
 	}
 
-	if ((old_termios->c_cflag & CRTSCTS) && !(tty->termios.c_cflag & CRTSCTS)) {
-		tty->hw_stopped = 0;
+	if ((old_termios->c_cflag & CRTSCTS) && !(tty->termios.c_cflag & CRTSCTS))
 		rp_start(tty);
-	}
 }
 
 static int rp_break(struct tty_struct *tty, int break_state)
@@ -1570,10 +1567,10 @@ static int rp_put_char(struct tty_struct *tty, unsigned char ch)
 	spin_lock_irqsave(&info->slock, flags);
 	cp = &info->channel;
 
-	if (!tty->stopped && !tty->hw_stopped && info->xmit_fifo_room == 0)
+	if (!tty->stopped && info->xmit_fifo_room == 0)
 		info->xmit_fifo_room = TXFIFO_SIZE - sGetTxCnt(cp);
 
-	if (tty->stopped || tty->hw_stopped || info->xmit_fifo_room == 0 || info->xmit_cnt != 0) {
+	if (tty->stopped || info->xmit_fifo_room == 0 || info->xmit_cnt != 0) {
 		info->xmit_buf[info->xmit_head++] = ch;
 		info->xmit_head &= XMIT_BUF_SIZE - 1;
 		info->xmit_cnt++;
@@ -1614,14 +1611,14 @@ static int rp_write(struct tty_struct *tty,
 #endif
 	cp = &info->channel;
 
-	if (!tty->stopped && !tty->hw_stopped && info->xmit_fifo_room < count)
+	if (!tty->stopped && info->xmit_fifo_room < count)
 		info->xmit_fifo_room = TXFIFO_SIZE - sGetTxCnt(cp);
 
         /*
 	 *  If the write queue for the port is empty, and there is FIFO space, stuff bytes 
 	 *  into FIFO.  Use the write queue for temp storage.
          */
-	if (!tty->stopped && !tty->hw_stopped && info->xmit_cnt == 0 && info->xmit_fifo_room > 0) {
+	if (!tty->stopped && info->xmit_cnt == 0 && info->xmit_fifo_room > 0) {
 		c = min(count, info->xmit_fifo_room);
 		b = buf;
 
@@ -1669,7 +1666,7 @@ static int rp_write(struct tty_struct *tty,
 		retval += c;
 	}
 
-	if ((retval > 0) && !tty->stopped && !tty->hw_stopped)
+	if ((retval > 0) && !tty->stopped)
 		set_bit((info->aiop * 8) + info->chan, (void *) &xmit_flags[info->board]);
 	
 end:
diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index 4939947..ef2e08e 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -630,8 +630,7 @@ static void rs_flush_chars(struct tty_struct *tty)
 	/* Enable transmitter */
 	local_irq_save(flags);
 
-	if (info->xmit_cnt <= 0 || tty->stopped || tty->hw_stopped ||
-			!info->xmit_buf) {
+	if (info->xmit_cnt <= 0 || tty->stopped || !info->xmit_buf) {
 		local_irq_restore(flags);
 		return;
 	}
@@ -697,7 +696,7 @@ static int rs_write(struct tty_struct * tty,
 		total += c;
 	}
 
-	if (info->xmit_cnt && !tty->stopped && !tty->hw_stopped) {
+	if (info->xmit_cnt && !tty->stopped) {
 		/* Enable transmitter */
 		local_irq_disable();		
 #ifndef USE_INTS
@@ -978,10 +977,8 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 	change_speed(info, tty);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
-	    !(tty->termios.c_cflag & CRTSCTS)) {
-		tty->hw_stopped = 0;
+	    !(tty->termios.c_cflag & CRTSCTS))
 		rs_start(tty);
-	}
 	
 }
 
diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index d97e194..cbf1d15 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -162,7 +162,7 @@ static unsigned int arc_serial_tx_empty(struct uart_port *port)
 /*
  * Driver internal routine, used by both tty(serial core) as well as tx-isr
  *  -Called under spinlock in either cases
- *  -also tty->stopped / tty->hw_stopped has already been checked
+ *  -also tty->stopped has already been checked
  *     = by uart_start( ) before calling us
  *     = tx_ist checks that too before calling
  */
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 5f37c31..50f56f3 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -2534,8 +2534,7 @@ static void handle_ser_tx_interrupt(struct e100_serial *info)
 	}
 	/* Normal char-by-char interrupt */
 	if (info->xmit.head == info->xmit.tail
-	    || info->port.tty->stopped
-	    || info->port.tty->hw_stopped) {
+	    || info->port.tty->stopped) {
 		DFLOW(DEBUG_LOG(info->line, "tx_int: stopped %i\n",
 				info->port.tty->stopped));
 		e100_disable_serial_tx_ready_irq(info);
@@ -3098,7 +3097,6 @@ rs_flush_chars(struct tty_struct *tty)
 	if (info->tr_running ||
 	    info->xmit.head == info->xmit.tail ||
 	    tty->stopped ||
-	    tty->hw_stopped ||
 	    !info->xmit.buf)
 		return;
 
@@ -3176,7 +3174,6 @@ static int rs_raw_write(struct tty_struct *tty,
 
 	if (info->xmit.head != info->xmit.tail &&
 	    !tty->stopped &&
-	    !tty->hw_stopped &&
 	    !info->tr_running) {
 		start_transmit(info);
 	}
@@ -3733,10 +3730,8 @@ rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 
 	/* Handle turning off CRTSCTS */
 	if ((old_termios->c_cflag & CRTSCTS) &&
-	    !(tty->termios.c_cflag & CRTSCTS)) {
-		tty->hw_stopped = 0;
+	    !(tty->termios.c_cflag & CRTSCTS))
 		rs_start(tty);
-	}
 
 }
 
@@ -4256,9 +4251,6 @@ static void seq_line_info(struct seq_file *m, struct e100_serial *info)
 		if (info->port.tty->stopped)
 			seq_printf(m, " stopped:%i",
 				   (int)info->port.tty->stopped);
-		if (info->port.tty->hw_stopped)
-			seq_printf(m, " hw_stopped:%i",
-				   (int)info->port.tty->hw_stopped);
 	}
 
 	{
-- 
1.8.1.4


