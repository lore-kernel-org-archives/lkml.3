Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab3A1CVF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 21:21:05 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54122 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750811Ab3A1CVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 21:21:03 -0500
Message-ID: <1359339660.14406.44.camel@joe-AO722>
Subject: [PATCH] TTY: synclink: Convert + to | for bit operations
From: Joe Perches <joe@perches.com>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sun, 27 Jan 2013 18:21:00 -0800
In-Reply-To: <C8AFB2C4-4974-4265-A41C-A56C71784F39@microgate.com>
References: <20130127194039.GA18787@elgon.mountain>
	 <1359317078.14406.12.camel@joe-AO722> <20130127201947.GO16282@mwanda>
	 <1359320401.14406.16.camel@joe-AO722>
	 <C8AFB2C4-4974-4265-A41C-A56C71784F39@microgate.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter noticed a missing set of parentheses
around a multiple field addition.

https://lkml.org/lkml/2013/1/27/166

His original commit message:

There is a kind of precedence problem here, but it doesn't affect how
the code works because ->serial_signals is unsigned char.  We want to
clear two flags here.

#define SerialSignal_RTS            0x20     /* Request to Send */
#define SerialSignal_DTR            0x80     /* Data Terminal Ready */

Without the parenthesis then it does:

	info->serial_signals &= 0x5f;

With the parenthesis it does:

	info->serial_signals &= 0xffffff5f;

info->serial_signals is an unsigned char so the two statements are
equivalent, but it's cleaner to add the parenthesis.  In other dtr_rts()
functions the parenthesis are there so this makes it more consistent.

Other changes:

Convert all + uses to | for these bit operations.

Reorder the multiple fields for consistency.
Update the comments too.

cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/pcmcia/synclink_cs.c | 26 ++++++++++++-------------
 drivers/tty/synclink.c            | 26 ++++++++++++-------------
 drivers/tty/synclink_gt.c         | 26 ++++++++++++-------------
 drivers/tty/synclinkmp.c          | 40 +++++++++++++++++++--------------------
 4 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 34e52ed..d0c9852 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -1343,7 +1343,7 @@ static void shutdown(MGSLPC_INFO * info, struct tty_struct *tty)
 	reset_device(info);
 
  	if (!tty || tty->termios.c_cflag & HUPCL) {
- 		info->serial_signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
+		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 		set_signals(info);
 	}
 
@@ -1405,12 +1405,12 @@ static void mgslpc_change_params(MGSLPC_INFO *info, struct tty_struct *tty)
 
 	cflag = tty->termios.c_cflag;
 
-	/* if B0 rate (hangup) specified then negate DTR and RTS */
-	/* otherwise assert DTR and RTS */
+	/* if B0 rate (hangup) specified then negate RTS and DTR */
+	/* otherwise assert RTS and DTR */
  	if (cflag & CBAUD)
-		info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
+		info->serial_signals |= SerialSignal_RTS | SerialSignal_DTR;
 	else
-		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
+		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 
 	/* byte size and parity */
 
@@ -2301,7 +2301,7 @@ static void mgslpc_set_termios(struct tty_struct *tty, struct ktermios *old_term
 	/* Handle transition to B0 status */
 	if (old_termios->c_cflag & CBAUD &&
 	    !(tty->termios.c_cflag & CBAUD)) {
-		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
+		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 		spin_lock_irqsave(&info->lock,flags);
 	 	set_signals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
@@ -2464,9 +2464,9 @@ static void dtr_rts(struct tty_port *port, int onoff)
 
 	spin_lock_irqsave(&info->lock,flags);
 	if (onoff)
-		info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
+		info->serial_signals |= SerialSignal_RTS | SerialSignal_DTR;
 	else
-		info->serial_signals &= ~SerialSignal_RTS + SerialSignal_DTR;
+		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 	set_signals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 }
@@ -3575,8 +3575,8 @@ static void get_signals(MGSLPC_INFO *info)
 {
 	unsigned char status = 0;
 
-	/* preserve DTR and RTS */
-	info->serial_signals &= SerialSignal_DTR + SerialSignal_RTS;
+	/* preserve RTS and DTR */
+	info->serial_signals &= SerialSignal_RTS | SerialSignal_DTR;
 
 	if (read_reg(info, CHB + VSTR) & BIT7)
 		info->serial_signals |= SerialSignal_DCD;
@@ -3590,7 +3590,7 @@ static void get_signals(MGSLPC_INFO *info)
 		info->serial_signals |= SerialSignal_DSR;
 }
 
-/* Set the state of DTR and RTS based on contents of
+/* Set the state of RTS and DTR based on contents of
  * serial_signals member of device extension.
  */
 static void set_signals(MGSLPC_INFO *info)
@@ -4009,8 +4009,8 @@ static int hdlcdev_open(struct net_device *dev)
 		spin_unlock_irqrestore(&info->netlock, flags);
 		return rc;
 	}
-	/* assert DTR and RTS, apply hardware settings */
-	info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
+	/* assert RTS and DTR, apply hardware settings */
+	info->serial_signals |= SerialSignal_RTS | SerialSignal_DTR;
 	mgslpc_program_hw(info, tty);
 	tty_kref_put(tty);
 
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 555fdc0..8983276 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -1850,7 +1850,7 @@ static void shutdown(struct mgsl_struct * info)
 	usc_OutReg(info, PCR, (u16)((usc_InReg(info, PCR) | BIT13) | BIT12));
 
 	if (!info->port.tty || info->port.tty->termios.c_cflag & HUPCL) {
- 		info->serial_signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
+		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 		usc_set_serial_signals(info);
 	}
 
@@ -1915,12 +1915,12 @@ static void mgsl_change_params(struct mgsl_struct *info)
 			 
 	cflag = info->port.tty->termios.c_cflag;
 
-	/* if B0 rate (hangup) specified then negate DTR and RTS */
-	/* otherwise assert DTR and RTS */
+	/* if B0 rate (hangup) specified then negate RTS and DTR */
+	/* otherwise assert RTS and DTR */
  	if (cflag & CBAUD)
-		info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
+		info->serial_signals |= SerialSignal_RTS | SerialSignal_DTR;
 	else
-		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
+		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 	
 	/* byte size and parity */
 	
@@ -3044,7 +3044,7 @@ static void mgsl_set_termios(struct tty_struct *tty, struct ktermios *old_termio
 	/* Handle transition to B0 status */
 	if (old_termios->c_cflag & CBAUD &&
 	    !(tty->termios.c_cflag & CBAUD)) {
-		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
+		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 		spin_lock_irqsave(&info->irq_spinlock,flags);
 	 	usc_set_serial_signals(info);
 		spin_unlock_irqrestore(&info->irq_spinlock,flags);
@@ -3243,9 +3243,9 @@ static void dtr_rts(struct tty_port *port, int on)
 
 	spin_lock_irqsave(&info->irq_spinlock,flags);
 	if (on)
-		info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
+		info->serial_signals |= SerialSignal_RTS | SerialSignal_DTR;
 	else
-		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
+		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
  	usc_set_serial_signals(info);
 	spin_unlock_irqrestore(&info->irq_spinlock,flags);
 }
@@ -6239,8 +6239,8 @@ static void usc_get_serial_signals( struct mgsl_struct *info )
 {
 	u16 status;
 
-	/* clear all serial signals except DTR and RTS */
-	info->serial_signals &= SerialSignal_DTR + SerialSignal_RTS;
+	/* clear all serial signals except RTS and DTR */
+	info->serial_signals &= SerialSignal_RTS | SerialSignal_DTR;
 
 	/* Read the Misc Interrupt status Register (MISR) to get */
 	/* the V24 status signals. */
@@ -6265,7 +6265,7 @@ static void usc_get_serial_signals( struct mgsl_struct *info )
 
 /* usc_set_serial_signals()
  *
- *	Set the state of DTR and RTS based on contents of
+ *	Set the state of RTS and DTR based on contents of
  *	serial_signals member of device extension.
  *	
  * Arguments:		info	pointer to device instance data
@@ -7779,8 +7779,8 @@ static int hdlcdev_open(struct net_device *dev)
 		return rc;
 	}
 
-	/* assert DTR and RTS, apply hardware settings */
-	info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
+	/* assert RTS and DTR, apply hardware settings */
+	info->serial_signals |= SerialSignal_RTS | SerialSignal_DTR;
 	mgsl_program_hw(info);
 
 	/* enable network layer transmit */
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index ac8599a..aa9eece 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -785,7 +785,7 @@ static void set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 	/* Handle transition to B0 status */
 	if (old_termios->c_cflag & CBAUD &&
 	    !(tty->termios.c_cflag & CBAUD)) {
-		info->signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
+		info->signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 		spin_lock_irqsave(&info->lock,flags);
 		set_signals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
@@ -1560,8 +1560,8 @@ static int hdlcdev_open(struct net_device *dev)
 		return rc;
 	}
 
-	/* assert DTR and RTS, apply hardware settings */
-	info->signals |= SerialSignal_RTS + SerialSignal_DTR;
+	/* assert RTS and DTR, apply hardware settings */
+	info->signals |= SerialSignal_RTS | SerialSignal_DTR;
 	program_hw(info);
 
 	/* enable network layer transmit */
@@ -2488,7 +2488,7 @@ static void shutdown(struct slgt_info *info)
 	slgt_irq_off(info, IRQ_ALL | IRQ_MASTER);
 
  	if (!info->port.tty || info->port.tty->termios.c_cflag & HUPCL) {
- 		info->signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
+		info->signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 		set_signals(info);
 	}
 
@@ -2548,12 +2548,12 @@ static void change_params(struct slgt_info *info)
 
 	cflag = info->port.tty->termios.c_cflag;
 
-	/* if B0 rate (hangup) specified then negate DTR and RTS */
-	/* otherwise assert DTR and RTS */
+	/* if B0 rate (hangup) specified then negate RTS and DTR */
+	/* otherwise assert RTS and DTR */
  	if (cflag & CBAUD)
-		info->signals |= SerialSignal_RTS + SerialSignal_DTR;
+		info->signals |= SerialSignal_RTS | SerialSignal_DTR;
 	else
-		info->signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
+		info->signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 
 	/* byte size and parity */
 
@@ -3256,9 +3256,9 @@ static void dtr_rts(struct tty_port *port, int on)
 
 	spin_lock_irqsave(&info->lock,flags);
 	if (on)
-		info->signals |= SerialSignal_RTS + SerialSignal_DTR;
+		info->signals |= SerialSignal_RTS | SerialSignal_DTR;
 	else
-		info->signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
+		info->signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
  	set_signals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 }
@@ -4119,7 +4119,7 @@ static void reset_port(struct slgt_info *info)
 	tx_stop(info);
 	rx_stop(info);
 
-	info->signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
+	info->signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 	set_signals(info);
 
 	slgt_irq_off(info, IRQ_ALL | IRQ_MASTER);
@@ -4546,8 +4546,8 @@ static void get_signals(struct slgt_info *info)
 {
 	unsigned short status = rd_reg16(info, SSR);
 
-	/* clear all serial signals except DTR and RTS */
-	info->signals &= SerialSignal_DTR + SerialSignal_RTS;
+	/* clear all serial signals except RTS and DTR */
+	info->signals &= SerialSignal_RTS | SerialSignal_DTR;
 
 	if (status & BIT3)
 		info->signals |= SerialSignal_DSR;
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index 5454025..6d5780c 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -882,7 +882,7 @@ static void set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 	/* Handle transition to B0 status */
 	if (old_termios->c_cflag & CBAUD &&
 	    !(tty->termios.c_cflag & CBAUD)) {
-		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
+		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 		spin_lock_irqsave(&info->lock,flags);
 	 	set_signals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
@@ -1676,8 +1676,8 @@ static int hdlcdev_open(struct net_device *dev)
 		return rc;
 	}
 
-	/* assert DTR and RTS, apply hardware settings */
-	info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
+	/* assert RTS and DTR, apply hardware settings */
+	info->serial_signals |= SerialSignal_RTS | SerialSignal_DTR;
 	program_hw(info);
 
 	/* enable network layer transmit */
@@ -2706,7 +2706,7 @@ static void shutdown(SLMP_INFO * info)
 	reset_port(info);
 
  	if (!info->port.tty || info->port.tty->termios.c_cflag & HUPCL) {
- 		info->serial_signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
+		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 		set_signals(info);
 	}
 
@@ -2768,12 +2768,12 @@ static void change_params(SLMP_INFO *info)
 
 	cflag = info->port.tty->termios.c_cflag;
 
-	/* if B0 rate (hangup) specified then negate DTR and RTS */
-	/* otherwise assert DTR and RTS */
+	/* if B0 rate (hangup) specified then negate RTS and DTR */
+	/* otherwise assert RTS and DTR */
  	if (cflag & CBAUD)
-		info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
+		info->serial_signals |= SerialSignal_RTS | SerialSignal_DTR;
 	else
-		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
+		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 
 	/* byte size and parity */
 
@@ -3212,12 +3212,12 @@ static int tiocmget(struct tty_struct *tty)
  	get_signals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 
-	result = ((info->serial_signals & SerialSignal_RTS) ? TIOCM_RTS:0) +
-		((info->serial_signals & SerialSignal_DTR) ? TIOCM_DTR:0) +
-		((info->serial_signals & SerialSignal_DCD) ? TIOCM_CAR:0) +
-		((info->serial_signals & SerialSignal_RI)  ? TIOCM_RNG:0) +
-		((info->serial_signals & SerialSignal_DSR) ? TIOCM_DSR:0) +
-		((info->serial_signals & SerialSignal_CTS) ? TIOCM_CTS:0);
+	result = ((info->serial_signals & SerialSignal_RTS) ? TIOCM_RTS : 0) |
+		 ((info->serial_signals & SerialSignal_DTR) ? TIOCM_DTR : 0) |
+		 ((info->serial_signals & SerialSignal_DCD) ? TIOCM_CAR : 0) |
+		 ((info->serial_signals & SerialSignal_RI)  ? TIOCM_RNG : 0) |
+		 ((info->serial_signals & SerialSignal_DSR) ? TIOCM_DSR : 0) |
+		 ((info->serial_signals & SerialSignal_CTS) ? TIOCM_CTS : 0);
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s tiocmget() value=%08X\n",
@@ -3272,9 +3272,9 @@ static void dtr_rts(struct tty_port *port, int on)
 
 	spin_lock_irqsave(&info->lock,flags);
 	if (on)
-		info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
+		info->serial_signals |= SerialSignal_RTS | SerialSignal_DTR;
 	else
-		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
+		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
  	set_signals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 }
@@ -4354,7 +4354,7 @@ static void reset_port(SLMP_INFO *info)
 		tx_stop(info);
 		rx_stop(info);
 
-		info->serial_signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
+		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 		set_signals(info);
 
 		/* disable all port interrupts */
@@ -4750,8 +4750,8 @@ static void get_signals(SLMP_INFO *info)
 	u16 gpstatus = read_status_reg(info);
 	u16 testbit;
 
-	/* clear all serial signals except DTR and RTS */
-	info->serial_signals &= SerialSignal_DTR + SerialSignal_RTS;
+	/* clear all serial signals except RTS and DTR */
+	info->serial_signals &= SerialSignal_RTS | SerialSignal_DTR;
 
 	/* set serial signal bits to reflect MISR */
 
@@ -4770,7 +4770,7 @@ static void get_signals(SLMP_INFO *info)
 		info->serial_signals |= SerialSignal_DSR;
 }
 
-/* Set the state of DTR and RTS based on contents of
+/* Set the state of RTS and DTR based on contents of
  * serial_signals member of device context.
  */
 static void set_signals(SLMP_INFO *info)


