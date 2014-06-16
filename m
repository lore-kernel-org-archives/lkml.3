Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaFPNSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:18:01 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:58974 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750775AbaFPNR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:17:59 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Samuel Ortiz <samuel@sortiz.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH tty-next 09/22] tty: Remove tty_hung_up_p() tests from tty drivers' open()
Date: Mon, 16 Jun 2014 09:17:06 -0400
Message-Id: <1402924639-5164-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since at least before 2.6.30, it has not been possible to observe
a hung up file pointer in a tty driver's open() method unless/until
the driver open() releases the tty_lock() (eg., before blocking).

This is because tty_open() adds the file pointer while holding
the tty_lock() _and_ doesn't release the lock until after calling
the tty driver's open() method. [ Before tty_lock(), this was
lock_kernel(). ]

Since __tty_hangup() first waits on the tty_lock() before
enumerating and hanging up the open file pointers, either
__tty_hangup() will wait for the tty_lock() or tty_open() will
not yet have added the file pointer. For example,

CPU 0                          |  CPU 1
                               |
tty_open                       |  __tty_hangup
  ..                           |    ..
  tty_lock                     |    ..
  tty_reopen                   |    tty_lock  / blocks
  ..                           |
  tty_add_file(tty, filp)      |
  ..                           |
  tty->ops->open(tty, filp)    |
    tty_port_open              |
      tty_port_block_til_ready |
        ..                     |
        while (1)              |
          ..                   |
          tty_unlock           |    / unblocks
          schedule             |    for each filp on tty->tty_files
                               |      f_ops = tty_hung_up_fops;
                               |    ..
                               |    tty_unlock
          tty_lock             |
  ..                           |
  tty_unlock                   |

Note that since tty_port_block_til_ready() and similar drop
the tty_lock while blocking, when woken, the file pointer
must then be tested for having been hung up.

Also, fix bit-rotted drivers that used extra_count to track the
port->count bump.

CC: Mikael Starvik <starvik@axis.com>
CC: Jesper Nilsson <jesper.nilsson@axis.com>
CC: Samuel Ortiz <samuel@sortiz.org>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/char/pcmcia/synclink_cs.c |  2 +-
 drivers/staging/dgrp/dgrp_tty.c   | 10 ----------
 drivers/tty/cyclades.c            |  2 +-
 drivers/tty/serial/crisv10.c      | 15 +++++----------
 drivers/tty/serial/serial_core.c  |  8 --------
 drivers/tty/synclink.c            | 10 +++-------
 drivers/tty/synclink_gt.c         | 10 +++-------
 drivers/tty/synclinkmp.c          | 11 +++--------
 drivers/tty/tty_port.c            |  8 +++-----
 net/irda/ircomm/ircomm_tty.c      |  6 ++----
 10 files changed, 21 insertions(+), 61 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 8320abd..a63970f 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2510,7 +2510,7 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 			 __FILE__, __LINE__, tty->driver->name, port->count);
 
 	/* If port is closing, signal caller to try again */
-	if (tty_hung_up_p(filp) || port->flags & ASYNC_CLOSING){
+	if (port->flags & ASYNC_CLOSING){
 		wait_event_interruptible_tty(tty, port->close_wait,
 					     !(port->flags & ASYNC_CLOSING));
 		retval = ((port->flags & ASYNC_HUP_NOTIFY) ?
diff --git a/drivers/staging/dgrp/dgrp_tty.c b/drivers/staging/dgrp/dgrp_tty.c
index 30d2602..cdd1a69 100644
--- a/drivers/staging/dgrp/dgrp_tty.c
+++ b/drivers/staging/dgrp/dgrp_tty.c
@@ -632,16 +632,6 @@ static int dgrp_tty_open(struct tty_struct *tty, struct file *file)
 	tty->driver_data = un;
 
 	/*
-	 * If we are in the middle of hanging up,
-	 * then return an error
-	 */
-	if (tty_hung_up_p(file)) {
-		retval = ((un->un_flag & UN_HUP_NOTIFY) ?
-			   -EAGAIN : -ERESTARTSYS);
-		goto done;
-	}
-
-	/*
 	 * If the port is in the middle of closing, then block
 	 * until it is done, then try again.
 	 */
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index a57bb5a..fd66f57 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -1579,7 +1579,7 @@ static int cy_open(struct tty_struct *tty, struct file *filp)
 	/*
 	 * If the port is the middle of closing, bail out now
 	 */
-	if (tty_hung_up_p(filp) || (info->port.flags & ASYNC_CLOSING)) {
+	if (info->port.flags & ASYNC_CLOSING) {
 		wait_event_interruptible_tty(tty, info->port.close_wait,
 				!(info->port.flags & ASYNC_CLOSING));
 		return (info->port.flags & ASYNC_HUP_NOTIFY) ? -EAGAIN: -ERESTARTSYS;
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index d567ac5..58e6f61 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -3831,14 +3831,13 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	DECLARE_WAITQUEUE(wait, current);
 	unsigned long	flags;
 	int		retval;
-	int		do_clocal = 0, extra_count = 0;
+	int		do_clocal = 0;
 
 	/*
 	 * If the device is in the middle of being closed, then block
 	 * until it's done, and then try again.
 	 */
-	if (tty_hung_up_p(filp) ||
-	    (info->port.flags & ASYNC_CLOSING)) {
+	if (info->port.flags & ASYNC_CLOSING) {
 		wait_event_interruptible_tty(tty, info->port.close_wait,
 			!(info->port.flags & ASYNC_CLOSING));
 #ifdef SERIAL_DO_RESTART
@@ -3879,10 +3878,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	       info->line, info->port.count);
 #endif
 	local_irq_save(flags);
-	if (!tty_hung_up_p(filp)) {
-		extra_count++;
-		info->port.count--;
-	}
+	info->port.count--;
 	local_irq_restore(flags);
 	info->port.blocked_open++;
 	while (1) {
@@ -3921,7 +3917,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	}
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->port.open_wait, &wait);
-	if (extra_count)
+	if (!tty_hung_up_p(filp))
 		info->port.count++;
 	info->port.blocked_open--;
 #ifdef SERIAL_DEBUG_OPEN
@@ -3976,8 +3972,7 @@ rs_open(struct tty_struct *tty, struct file * filp)
 	/*
 	 * If the port is in the middle of closing, bail out now
 	 */
-	if (tty_hung_up_p(filp) ||
-	    (info->port.flags & ASYNC_CLOSING)) {
+	if (info->port.flags & ASYNC_CLOSING) {
 		wait_event_interruptible_tty(tty, info->port.close_wait,
 			!(info->port.flags & ASYNC_CLOSING));
 #ifdef SERIAL_DO_RESTART
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index f2febb4..c8879ce 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1572,14 +1572,6 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	tty_port_tty_set(port, tty);
 
 	/*
-	 * If the port is in the middle of closing, bail out now.
-	 */
-	if (tty_hung_up_p(filp)) {
-		retval = -EAGAIN;
-		goto err_dec_count;
-	}
-
-	/*
 	 * Start up the serial port.
 	 */
 	retval = uart_startup(tty, state, 0);
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index d48e040..b799170 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -3267,7 +3267,6 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	DECLARE_WAITQUEUE(wait, current);
 	int		retval;
 	bool		do_clocal = false;
-	bool		extra_count = false;
 	unsigned long	flags;
 	int		dcd;
 	struct tty_port *port = &info->port;
@@ -3300,10 +3299,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 			 __FILE__,__LINE__, tty->driver->name, port->count );
 
 	spin_lock_irqsave(&info->irq_spinlock, flags);
-	if (!tty_hung_up_p(filp)) {
-		extra_count = true;
-		port->count--;
-	}
+	port->count--;
 	spin_unlock_irqrestore(&info->irq_spinlock, flags);
 	port->blocked_open++;
 	
@@ -3342,7 +3338,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	remove_wait_queue(&port->open_wait, &wait);
 	
 	/* FIXME: Racy on hangup during close wait */
-	if (extra_count)
+	if (!tty_hung_up_p(filp))
 		port->count++;
 	port->blocked_open--;
 	
@@ -3403,7 +3399,7 @@ static int mgsl_open(struct tty_struct *tty, struct file * filp)
 			 __FILE__,__LINE__,tty->driver->name, info->port.count);
 
 	/* If port is closing, signal caller to try again */
-	if (tty_hung_up_p(filp) || info->port.flags & ASYNC_CLOSING){
+	if (info->port.flags & ASYNC_CLOSING){
 		wait_event_interruptible_tty(tty, info->port.close_wait,
 				     !(info->port.flags & ASYNC_CLOSING));
 		retval = ((info->port.flags & ASYNC_HUP_NOTIFY) ?
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index c359a91..ba1dbcd 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -673,7 +673,7 @@ static int open(struct tty_struct *tty, struct file *filp)
 	DBGINFO(("%s open, old ref count = %d\n", info->device_name, info->port.count));
 
 	/* If port is closing, signal caller to try again */
-	if (tty_hung_up_p(filp) || info->port.flags & ASYNC_CLOSING){
+	if (info->port.flags & ASYNC_CLOSING){
 		wait_event_interruptible_tty(tty, info->port.close_wait,
 					     !(info->port.flags & ASYNC_CLOSING));
 		retval = ((info->port.flags & ASYNC_HUP_NOTIFY) ?
@@ -3273,7 +3273,6 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	DECLARE_WAITQUEUE(wait, current);
 	int		retval;
 	bool		do_clocal = false;
-	bool		extra_count = false;
 	unsigned long	flags;
 	int		cd;
 	struct tty_port *port = &info->port;
@@ -3300,10 +3299,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	add_wait_queue(&port->open_wait, &wait);
 
 	spin_lock_irqsave(&info->lock, flags);
-	if (!tty_hung_up_p(filp)) {
-		extra_count = true;
-		port->count--;
-	}
+	port->count--;
 	spin_unlock_irqrestore(&info->lock, flags);
 	port->blocked_open++;
 
@@ -3338,7 +3334,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&port->open_wait, &wait);
 
-	if (extra_count)
+	if (!tty_hung_up_p(filp))
 		port->count++;
 	port->blocked_open--;
 
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index 53ba853..c3f9091 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -753,7 +753,7 @@ static int open(struct tty_struct *tty, struct file *filp)
 			 __FILE__,__LINE__,tty->driver->name, info->port.count);
 
 	/* If port is closing, signal caller to try again */
-	if (tty_hung_up_p(filp) || info->port.flags & ASYNC_CLOSING){
+	if (info->port.flags & ASYNC_CLOSING){
 		wait_event_interruptible_tty(tty, info->port.close_wait,
 					     !(info->port.flags & ASYNC_CLOSING));
 		retval = ((info->port.flags & ASYNC_HUP_NOTIFY) ?
@@ -3288,7 +3288,6 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	DECLARE_WAITQUEUE(wait, current);
 	int		retval;
 	bool		do_clocal = false;
-	bool		extra_count = false;
 	unsigned long	flags;
 	int		cd;
 	struct tty_port *port = &info->port;
@@ -3322,10 +3321,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 			 __FILE__,__LINE__, tty->driver->name, port->count );
 
 	spin_lock_irqsave(&info->lock, flags);
-	if (!tty_hung_up_p(filp)) {
-		extra_count = true;
-		port->count--;
-	}
+	port->count--;
 	spin_unlock_irqrestore(&info->lock, flags);
 	port->blocked_open++;
 
@@ -3362,8 +3358,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&port->open_wait, &wait);
-
-	if (extra_count)
+	if (!tty_hung_up_p(filp))
 		port->count++;
 	port->blocked_open--;
 
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 9209d63..1b93357 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -365,7 +365,7 @@ int tty_port_block_til_ready(struct tty_port *port,
 	DEFINE_WAIT(wait);
 
 	/* block if port is in the process of being closed */
-	if (tty_hung_up_p(filp) || port->flags & ASYNC_CLOSING) {
+	if (port->flags & ASYNC_CLOSING) {
 		wait_event_interruptible_tty(tty, port->close_wait,
 				!(port->flags & ASYNC_CLOSING));
 		if (port->flags & ASYNC_HUP_NOTIFY)
@@ -399,8 +399,7 @@ int tty_port_block_til_ready(struct tty_port *port,
 
 	/* The port lock protects the port counts */
 	spin_lock_irqsave(&port->lock, flags);
-	if (!tty_hung_up_p(filp))
-		port->count--;
+	port->count--;
 	port->blocked_open++;
 	spin_unlock_irqrestore(&port->lock, flags);
 
@@ -593,8 +592,7 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 							struct file *filp)
 {
 	spin_lock_irq(&port->lock);
-	if (!tty_hung_up_p(filp))
-		++port->count;
+	++port->count;
 	spin_unlock_irq(&port->lock);
 	tty_port_tty_set(port, tty);
 
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 2ba8b97..61ceb4c 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -320,8 +320,7 @@ static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,
 	      __FILE__, __LINE__, tty->driver->name, port->count);
 
 	spin_lock_irqsave(&port->lock, flags);
-	if (!tty_hung_up_p(filp))
-		port->count--;
+	port->count--;
 	port->blocked_open++;
 	spin_unlock_irqrestore(&port->lock, flags);
 
@@ -458,8 +457,7 @@ static int ircomm_tty_open(struct tty_struct *tty, struct file *filp)
 	/*
 	 * If the port is the middle of closing, bail out now
 	 */
-	if (tty_hung_up_p(filp) ||
-	    test_bit(ASYNCB_CLOSING, &self->port.flags)) {
+	if (test_bit(ASYNCB_CLOSING, &self->port.flags)) {
 
 		/* Hm, why are we blocking on ASYNC_CLOSING if we
 		 * do return -EAGAIN/-ERESTARTSYS below anyway?
-- 
2.0.0

