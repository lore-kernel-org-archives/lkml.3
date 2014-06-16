Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaFPNWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:22:20 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43754 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbaFPNWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:22:16 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        Samuel Ortiz <samuel@sortiz.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH tty-next 17/22] tty: Remove ASYNC_CLOSING
Date: Mon, 16 Jun 2014 09:17:14 -0400
Message-Id: <1402924639-5164-18-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since at least before 2.6.30, tty drivers that do not drop the tty lock
while closing cannot observe ASYNC_CLOSING set while holding the
tty lock; this includes the tty driver's open() and hangup() methods,
since the tty core calls these methods holding the tty lock.

For these drivers, waiting for ASYNC_CLOSING to clear while opening
is not required, since this condition cannot occur. Similarly, even
when the open() method drops and reacquires the tty lock after
blocking, ASYNC_CLOSING cannot be set (again, for drivers that
do not drop the tty lock while closing).

Now that tty port drivers no longer drop the tty lock while closing
(since 'tty: Remove tty_wait_until_sent_from_close()'), the same
conditions apply: waiting for ASYNC_CLOSING to clear while opening
is not required, nor is re-checking ASYNC_CLOSING after dropping and
reacquiring the tty lock while blocking (eg., in *_block_til_ready()).

Since ASYNC_CLOSING is not tested elsewhere, it is safe to remove
the flag.

CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-s390@vger.kernel.org
CC: Mikael Starvik <starvik@axis.com>
CC: Jesper Nilsson <jesper.nilsson@axis.com>
CC: linux-cris-kernel@axis.com
CC: Samuel Ortiz <samuel@sortiz.org>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/char/pcmcia/synclink_cs.c |  9 ---------
 drivers/s390/char/con3215.c       |  3 +--
 drivers/tty/cyclades.c            |  9 ---------
 drivers/tty/rocket.c              | 14 +-------------
 drivers/tty/serial/68328serial.c  |  2 --
 drivers/tty/serial/crisv10.c      | 36 ++----------------------------------
 drivers/tty/serial/serial_core.c  |  1 -
 drivers/tty/synclink.c            | 18 ++++--------------
 drivers/tty/synclink_gt.c         | 14 ++------------
 drivers/tty/synclinkmp.c          | 14 ++------------
 drivers/tty/tty_port.c            | 16 ++--------------
 include/uapi/linux/tty_flags.h    |  2 --
 net/irda/ircomm/ircomm_tty.c      | 35 +----------------------------------
 13 files changed, 15 insertions(+), 158 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 0ea9986..ca18543f 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2507,15 +2507,6 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 		printk("%s(%d):mgslpc_open(%s), old ref count = %d\n",
 			 __FILE__, __LINE__, tty->driver->name, port->count);
 
-	/* If port is closing, signal caller to try again */
-	if (port->flags & ASYNC_CLOSING){
-		wait_event_interruptible_tty(tty, port->close_wait,
-					     !(port->flags & ASYNC_CLOSING));
-		retval = ((port->flags & ASYNC_HUP_NOTIFY) ?
-			-EAGAIN : -ERESTARTSYS);
-		goto cleanup;
-	}
-
 	port->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	spin_lock_irqsave(&info->netlock, flags);
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 5af7f0b..2fba207 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -641,7 +641,6 @@ static void raw3215_shutdown(struct raw3215_info *raw)
 	if ((raw->flags & RAW3215_WORKING) ||
 	    raw->queued_write != NULL ||
 	    raw->queued_read != NULL) {
-		raw->port.flags |= ASYNC_CLOSING;
 		add_wait_queue(&raw->empty_wait, &wait);
 		set_current_state(TASK_INTERRUPTIBLE);
 		spin_unlock_irqrestore(get_ccwdev_lock(raw->cdev), flags);
@@ -649,7 +648,7 @@ static void raw3215_shutdown(struct raw3215_info *raw)
 		spin_lock_irqsave(get_ccwdev_lock(raw->cdev), flags);
 		remove_wait_queue(&raw->empty_wait, &wait);
 		set_current_state(TASK_RUNNING);
-		raw->port.flags &= ~(ASYNC_INITIALIZED | ASYNC_CLOSING);
+		raw->port.flags &= ~ASYNC_INITIALIZED;
 	}
 	spin_unlock_irqrestore(get_ccwdev_lock(raw->cdev), flags);
 }
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index fd66f57..2666421 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -1577,15 +1577,6 @@ static int cy_open(struct tty_struct *tty, struct file *filp)
 #endif
 
 	/*
-	 * If the port is the middle of closing, bail out now
-	 */
-	if (info->port.flags & ASYNC_CLOSING) {
-		wait_event_interruptible_tty(tty, info->port.close_wait,
-				!(info->port.flags & ASYNC_CLOSING));
-		return (info->port.flags & ASYNC_HUP_NOTIFY) ? -EAGAIN: -ERESTARTSYS;
-	}
-
-	/*
 	 * Start up serial port
 	 */
 	retval = cy_startup(info, tty);
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index 383c4c7..882750d 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -895,14 +895,6 @@ static int rp_open(struct tty_struct *tty, struct file *filp)
 	if (!page)
 		return -ENOMEM;
 
-	if (port->flags & ASYNC_CLOSING) {
-		retval = wait_for_completion_interruptible(&info->close_wait);
-		free_page(page);
-		if (retval)
-			return retval;
-		return ((port->flags & ASYNC_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
-	}
-
 	/*
 	 * We must not sleep from here until the port is marked fully in use.
 	 */
@@ -1051,7 +1043,7 @@ static void rp_close(struct tty_struct *tty, struct file *filp)
 		}
 	}
 	spin_lock_irq(&port->lock);
-	info->port.flags &= ~(ASYNC_INITIALIZED | ASYNC_CLOSING | ASYNC_NORMAL_ACTIVE);
+	info->port.flags &= ~(ASYNC_INITIALIZED | ASYNC_NORMAL_ACTIVE);
 	tty->closing = 0;
 	spin_unlock_irq(&port->lock);
 	mutex_unlock(&port->mutex);
@@ -1511,10 +1503,6 @@ static void rp_hangup(struct tty_struct *tty)
 #endif
 	rp_flush_buffer(tty);
 	spin_lock_irqsave(&info->port.lock, flags);
-	if (info->port.flags & ASYNC_CLOSING) {
-		spin_unlock_irqrestore(&info->port.lock, flags);
-		return;
-	}
 	if (info->port.count)
 		atomic_dec(&rp_num_ports_open);
 	clear_bit((info->aiop * 8) + info->chan, (void *) &xmit_flags[info->board]);
diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index 5dc9c4b..b438ea5 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -1029,7 +1029,6 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		local_irq_restore(flags);
 		return;
 	}
-	port->flags |= ASYNC_CLOSING;
 	/*
 	 * Now we wait for the transmit buffer to clear; and we notify 
 	 * the line discipline to only process XON/XOFF characters.
@@ -1069,7 +1068,6 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 			msleep_interruptible(jiffies_to_msecs(port->close_delay));
 		wake_up_interruptible(&port->open_wait);
 	}
-	port->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
 	wake_up_interruptible(&port->close_wait);
 	local_irq_restore(flags);
 }
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 58e6f61..6989d7d 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -3674,7 +3674,6 @@ rs_close(struct tty_struct *tty, struct file * filp)
 		local_irq_restore(flags);
 		return;
 	}
-	info->port.flags |= ASYNC_CLOSING;
 	/*
 	 * Save the termios structure, since this port may have
 	 * separate termios for callout and dialin.
@@ -3719,7 +3718,7 @@ rs_close(struct tty_struct *tty, struct file * filp)
 			schedule_timeout_interruptible(info->port.close_delay);
 		wake_up_interruptible(&info->port.open_wait);
 	}
-	info->port.flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
+	info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 	wake_up_interruptible(&info->port.close_wait);
 	local_irq_restore(flags);
 
@@ -3834,23 +3833,6 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	int		do_clocal = 0;
 
 	/*
-	 * If the device is in the middle of being closed, then block
-	 * until it's done, and then try again.
-	 */
-	if (info->port.flags & ASYNC_CLOSING) {
-		wait_event_interruptible_tty(tty, info->port.close_wait,
-			!(info->port.flags & ASYNC_CLOSING));
-#ifdef SERIAL_DO_RESTART
-		if (info->port.flags & ASYNC_HUP_NOTIFY)
-			return -EAGAIN;
-		else
-			return -ERESTARTSYS;
-#else
-		return -EAGAIN;
-#endif
-	}
-
-	/*
 	 * If non-blocking mode is set, or the port is not enabled,
 	 * then make the check up front and then exit.
 	 */
@@ -3900,7 +3882,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 #endif
 			break;
 		}
-		if (!(info->port.flags & ASYNC_CLOSING) && do_clocal)
+		if (do_clocal)
 			/* && (do_clocal || DCD_IS_ASSERTED) */
 			break;
 		if (signal_pending(current)) {
@@ -3970,20 +3952,6 @@ rs_open(struct tty_struct *tty, struct file * filp)
 	info->port.low_latency = !!(info->port.flags & ASYNC_LOW_LATENCY);
 
 	/*
-	 * If the port is in the middle of closing, bail out now
-	 */
-	if (info->port.flags & ASYNC_CLOSING) {
-		wait_event_interruptible_tty(tty, info->port.close_wait,
-			!(info->port.flags & ASYNC_CLOSING));
-#ifdef SERIAL_DO_RESTART
-		return ((info->port.flags & ASYNC_HUP_NOTIFY) ?
-			-EAGAIN : -ERESTARTSYS);
-#else
-		return -EAGAIN;
-#endif
-	}
-
-	/*
 	 * If DMA is enabled try to allocate the irq's.
 	 */
 	if (info->port.count == 1) {
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index f64cf45..e97653e 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1376,7 +1376,6 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	 * Wake up anyone trying to open this port.
 	 */
 	clear_bit(ASYNCB_NORMAL_ACTIVE, &port->flags);
-	clear_bit(ASYNCB_CLOSING, &port->flags);
 	spin_unlock_irqrestore(&port->lock, flags);
 	wake_up_interruptible(&port->open_wait);
 	wake_up_interruptible(&port->close_wait);
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index b799170..86c2a8d 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -3314,12 +3314,11 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 					-EAGAIN : -ERESTARTSYS;
 			break;
 		}
-		
+
 		dcd = tty_port_carrier_raised(&info->port);
-		
- 		if (!(port->flags & ASYNC_CLOSING) && (do_clocal || dcd))
- 			break;
-			
+		if (do_clocal || dcd)
+			break;
+
 		if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
 			break;
@@ -3398,15 +3397,6 @@ static int mgsl_open(struct tty_struct *tty, struct file * filp)
 		printk("%s(%d):mgsl_open(%s), old ref count = %d\n",
 			 __FILE__,__LINE__,tty->driver->name, info->port.count);
 
-	/* If port is closing, signal caller to try again */
-	if (info->port.flags & ASYNC_CLOSING){
-		wait_event_interruptible_tty(tty, info->port.close_wait,
-				     !(info->port.flags & ASYNC_CLOSING));
-		retval = ((info->port.flags & ASYNC_HUP_NOTIFY) ?
-			-EAGAIN : -ERESTARTSYS);
-		goto cleanup;
-	}
-	
 	info->port.low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	spin_lock_irqsave(&info->netlock, flags);
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index ba1dbcd..2a798b9 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -672,15 +672,6 @@ static int open(struct tty_struct *tty, struct file *filp)
 
 	DBGINFO(("%s open, old ref count = %d\n", info->device_name, info->port.count));
 
-	/* If port is closing, signal caller to try again */
-	if (info->port.flags & ASYNC_CLOSING){
-		wait_event_interruptible_tty(tty, info->port.close_wait,
-					     !(info->port.flags & ASYNC_CLOSING));
-		retval = ((info->port.flags & ASYNC_HUP_NOTIFY) ?
-			-EAGAIN : -ERESTARTSYS);
-		goto cleanup;
-	}
-
 	mutex_lock(&info->port.mutex);
 	info->port.low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
@@ -3316,9 +3307,8 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 		}
 
 		cd = tty_port_carrier_raised(port);
-
- 		if (!(port->flags & ASYNC_CLOSING) && (do_clocal || cd ))
- 			break;
+		if (do_clocal || cd )
+			break;
 
 		if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index c3f9091..050f611 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -752,15 +752,6 @@ static int open(struct tty_struct *tty, struct file *filp)
 		printk("%s(%d):%s open(), old ref count = %d\n",
 			 __FILE__,__LINE__,tty->driver->name, info->port.count);
 
-	/* If port is closing, signal caller to try again */
-	if (info->port.flags & ASYNC_CLOSING){
-		wait_event_interruptible_tty(tty, info->port.close_wait,
-					     !(info->port.flags & ASYNC_CLOSING));
-		retval = ((info->port.flags & ASYNC_HUP_NOTIFY) ?
-			-EAGAIN : -ERESTARTSYS);
-		goto cleanup;
-	}
-
 	info->port.low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	spin_lock_irqsave(&info->netlock, flags);
@@ -3338,9 +3329,8 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 		}
 
 		cd = tty_port_carrier_raised(port);
-
- 		if (!(port->flags & ASYNC_CLOSING) && (do_clocal || cd))
- 			break;
+		if (do_clocal || cd)
+			break;
 
 		if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 6b6214b..896eebf 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -364,16 +364,6 @@ int tty_port_block_til_ready(struct tty_port *port,
 	unsigned long flags;
 	DEFINE_WAIT(wait);
 
-	/* block if port is in the process of being closed */
-	if (port->flags & ASYNC_CLOSING) {
-		wait_event_interruptible_tty(tty, port->close_wait,
-				!(port->flags & ASYNC_CLOSING));
-		if (port->flags & ASYNC_HUP_NOTIFY)
-			return -EAGAIN;
-		else
-			return -ERESTARTSYS;
-	}
-
 	/* if non-blocking mode is set we can pass directly to open unless
 	   the port has just hung up or is in another error state */
 	if (tty->flags & (1 << TTY_IO_ERROR)) {
@@ -424,8 +414,7 @@ int tty_port_block_til_ready(struct tty_port *port,
 		 * Never ask drivers if CLOCAL is set, this causes troubles
 		 * on some hardware.
 		 */
-		if (!(port->flags & ASYNC_CLOSING) &&
-				(do_clocal || tty_port_carrier_raised(port)))
+		if (do_clocal || tty_port_carrier_raised(port))
 			break;
 		if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
@@ -492,7 +481,6 @@ int tty_port_close_start(struct tty_port *port,
 		spin_unlock_irqrestore(&port->lock, flags);
 		return 0;
 	}
-	set_bit(ASYNCB_CLOSING, &port->flags);
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	tty->closing = 1;
@@ -532,7 +520,7 @@ void tty_port_close_end(struct tty_port *port, struct tty_struct *tty)
 		spin_lock_irqsave(&port->lock, flags);
 		wake_up_interruptible(&port->open_wait);
 	}
-	port->flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
+	port->flags &= ~ASYNC_NORMAL_ACTIVE;
 	wake_up_interruptible(&port->close_wait);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
diff --git a/include/uapi/linux/tty_flags.h b/include/uapi/linux/tty_flags.h
index eefcb48..4d78f3e 100644
--- a/include/uapi/linux/tty_flags.h
+++ b/include/uapi/linux/tty_flags.h
@@ -33,7 +33,6 @@
 #define ASYNCB_SUSPENDED	30 /* Serial port is suspended */
 #define ASYNCB_NORMAL_ACTIVE	29 /* Normal device is active */
 #define ASYNCB_BOOT_AUTOCONF	28 /* Autoconfigure port on bootup */
-#define ASYNCB_CLOSING		27 /* Serial port is closing */
 #define ASYNCB_CTS_FLOW		26 /* Do CTS flow control */
 #define ASYNCB_CHECK_CD		25 /* i.e., CLOCAL */
 #define ASYNCB_SHARE_IRQ	24 /* for multifunction cards, no longer used */
@@ -68,7 +67,6 @@
 #define ASYNC_INITIALIZED	(1U << ASYNCB_INITIALIZED)
 #define ASYNC_NORMAL_ACTIVE	(1U << ASYNCB_NORMAL_ACTIVE)
 #define ASYNC_BOOT_AUTOCONF	(1U << ASYNCB_BOOT_AUTOCONF)
-#define ASYNC_CLOSING		(1U << ASYNCB_CLOSING)
 #define ASYNC_CTS_FLOW		(1U << ASYNCB_CTS_FLOW)
 #define ASYNC_CHECK_CD		(1U << ASYNCB_CHECK_CD)
 #define ASYNC_SHARE_IRQ		(1U << ASYNCB_SHARE_IRQ)
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 61ceb4c..88a0116 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -342,8 +342,7 @@ static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,
 		 * specified, we cannot return before the IrCOMM link is
 		 * ready
 		 */
-		if (!test_bit(ASYNCB_CLOSING, &port->flags) &&
-		    (do_clocal || tty_port_carrier_raised(port)) &&
+		if ((do_clocal || tty_port_carrier_raised(port)) &&
 		    self->state == IRCOMM_TTY_READY)
 		{
 			break;
@@ -454,34 +453,6 @@ static int ircomm_tty_open(struct tty_struct *tty, struct file *filp)
 	/* Not really used by us, but lets do it anyway */
 	self->port.low_latency = (self->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
-	/*
-	 * If the port is the middle of closing, bail out now
-	 */
-	if (test_bit(ASYNCB_CLOSING, &self->port.flags)) {
-
-		/* Hm, why are we blocking on ASYNC_CLOSING if we
-		 * do return -EAGAIN/-ERESTARTSYS below anyway?
-		 * IMHO it's either not needed in the first place
-		 * or for some reason we need to make sure the async
-		 * closing has been finished - if so, wouldn't we
-		 * probably better sleep uninterruptible?
-		 */
-
-		if (wait_event_interruptible(self->port.close_wait,
-				!test_bit(ASYNCB_CLOSING, &self->port.flags))) {
-			IRDA_WARNING("%s - got signal while blocking on ASYNC_CLOSING!\n",
-				     __func__);
-			return -ERESTARTSYS;
-		}
-
-#ifdef SERIAL_DO_RESTART
-		return (self->port.flags & ASYNC_HUP_NOTIFY) ?
-			-EAGAIN : -ERESTARTSYS;
-#else
-		return -EAGAIN;
-#endif
-	}
-
 	/* Check if this is a "normal" ircomm device, or an irlpt device */
 	if (self->line < 0x10) {
 		self->service_type = IRCOMM_3_WIRE | IRCOMM_9_WIRE;
@@ -1331,10 +1302,6 @@ static void ircomm_tty_line_info(struct ircomm_tty_cb *self, struct seq_file *m)
 		seq_printf(m, "%cASYNC_LOW_LATENCY", sep);
 		sep = '|';
 	}
-	if (self->port.flags & ASYNC_CLOSING) {
-		seq_printf(m, "%cASYNC_CLOSING", sep);
-		sep = '|';
-	}
 	if (self->port.flags & ASYNC_NORMAL_ACTIVE) {
 		seq_printf(m, "%cASYNC_NORMAL_ACTIVE", sep);
 		sep = '|';
-- 
2.0.0

