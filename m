Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab3A0UEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 15:04:46 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37472 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755445Ab3A0UEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 15:04:41 -0500
Message-ID: <1359317078.14406.12.camel@joe-AO722>
Subject: Re: [patch] TTY: synclink, small cleanup in dtr_rts()
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Sun, 27 Jan 2013 12:04:38 -0800
In-Reply-To: <20130127194039.GA18787@elgon.mountain>
References: <20130127194039.GA18787@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-27 at 22:40 +0300, Dan Carpenter wrote:
> There is a kind of precedence problem here, but it doesn't affect how
> the code works because ->serial_signals is unsigned char.  We want to
> clear two flags here.
> 
> #define SerialSignal_RTS            0x20     /* Request to Send */
> #define SerialSignal_DTR            0x80     /* Data Terminal Ready */
> 
> Without the parenthesis then it does:
> 
> 	info->serial_signals &= 0x5f;
> 
> With the parenthesis it does:
> 
> 	info->serial_signals &= 0xffffff5f;
> 
> info->serial_signals is an unsigned char so the two statements are
> equivalent, but it's cleaner to add the parenthesis.  In other dtr_rts()
> functions the parenthesis are there so this makes it more consistent.


Wouldn't it be clearer still to use | instead of +

> diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
[]
> @@ -2466,7 +2466,7 @@ static void dtr_rts(struct tty_port *port, int onoff)
>  	if (onoff)
>  		info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
>  	else
> -		info->serial_signals &= ~SerialSignal_RTS + SerialSignal_DTR;
> +		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);

 drivers/tty/synclink.c    | 16 ++++++++--------
 drivers/tty/synclink_gt.c | 18 +++++++++---------
 drivers/tty/synclinkmp.c  | 18 +++++++++---------
 3 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 555fdc0..636ef3e 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -1850,7 +1850,7 @@ static void shutdown(struct mgsl_struct * info)
 	usc_OutReg(info, PCR, (u16)((usc_InReg(info, PCR) | BIT13) | BIT12));
 
 	if (!info->port.tty || info->port.tty->termios.c_cflag & HUPCL) {
- 		info->serial_signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
+		info->serial_signals &= ~(SerialSignal_DTR | SerialSignal_RTS);
 		usc_set_serial_signals(info);
 	}
 
@@ -1918,9 +1918,9 @@ static void mgsl_change_params(struct mgsl_struct *info)
 	/* if B0 rate (hangup) specified then negate DTR and RTS */
 	/* otherwise assert DTR and RTS */
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
@@ -6240,7 +6240,7 @@ static void usc_get_serial_signals( struct mgsl_struct *info )
 	u16 status;
 
 	/* clear all serial signals except DTR and RTS */
-	info->serial_signals &= SerialSignal_DTR + SerialSignal_RTS;
+	info->serial_signals &= SerialSignal_DTR | SerialSignal_RTS;
 
 	/* Read the Misc Interrupt status Register (MISR) to get */
 	/* the V24 status signals. */
@@ -7780,7 +7780,7 @@ static int hdlcdev_open(struct net_device *dev)
 	}
 
 	/* assert DTR and RTS, apply hardware settings */
-	info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
+	info->serial_signals |= SerialSignal_RTS | SerialSignal_DTR;
 	mgsl_program_hw(info);
 
 	/* enable network layer transmit */
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index ac8599a..a66539c 100644
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
@@ -1561,7 +1561,7 @@ static int hdlcdev_open(struct net_device *dev)
 	}
 
 	/* assert DTR and RTS, apply hardware settings */
-	info->signals |= SerialSignal_RTS + SerialSignal_DTR;
+	info->signals |= SerialSignal_RTS | SerialSignal_DTR;
 	program_hw(info);
 
 	/* enable network layer transmit */
@@ -2488,7 +2488,7 @@ static void shutdown(struct slgt_info *info)
 	slgt_irq_off(info, IRQ_ALL | IRQ_MASTER);
 
  	if (!info->port.tty || info->port.tty->termios.c_cflag & HUPCL) {
- 		info->signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
+		info->signals &= ~(SerialSignal_DTR | SerialSignal_RTS);
 		set_signals(info);
 	}
 
@@ -2551,9 +2551,9 @@ static void change_params(struct slgt_info *info)
 	/* if B0 rate (hangup) specified then negate DTR and RTS */
 	/* otherwise assert DTR and RTS */
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
+	info->signals &= ~(SerialSignal_DTR | SerialSignal_RTS);
 	set_signals(info);
 
 	slgt_irq_off(info, IRQ_ALL | IRQ_MASTER);
@@ -4547,7 +4547,7 @@ static void get_signals(struct slgt_info *info)
 	unsigned short status = rd_reg16(info, SSR);
 
 	/* clear all serial signals except DTR and RTS */
-	info->signals &= SerialSignal_DTR + SerialSignal_RTS;
+	info->signals &= SerialSignal_DTR | SerialSignal_RTS;
 
 	if (status & BIT3)
 		info->signals |= SerialSignal_DSR;
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index 5454025..620b1da 100644
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
@@ -1677,7 +1677,7 @@ static int hdlcdev_open(struct net_device *dev)
 	}
 
 	/* assert DTR and RTS, apply hardware settings */
-	info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
+	info->serial_signals |= SerialSignal_RTS | SerialSignal_DTR;
 	program_hw(info);
 
 	/* enable network layer transmit */
@@ -2706,7 +2706,7 @@ static void shutdown(SLMP_INFO * info)
 	reset_port(info);
 
  	if (!info->port.tty || info->port.tty->termios.c_cflag & HUPCL) {
- 		info->serial_signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
+		info->serial_signals &= ~(SerialSignal_DTR | SerialSignal_RTS);
 		set_signals(info);
 	}
 
@@ -2771,9 +2771,9 @@ static void change_params(SLMP_INFO *info)
 	/* if B0 rate (hangup) specified then negate DTR and RTS */
 	/* otherwise assert DTR and RTS */
  	if (cflag & CBAUD)
-		info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
+		info->serial_signals |= SerialSignal_RTS | SerialSignal_DTR;
 	else
-		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
+		info->serial_signals &= ~(SerialSignal_RTS | SerialSignal_DTR);
 
 	/* byte size and parity */
 
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
+		info->serial_signals &= ~(SerialSignal_DTR | SerialSignal_RTS);
 		set_signals(info);
 
 		/* disable all port interrupts */
@@ -4751,7 +4751,7 @@ static void get_signals(SLMP_INFO *info)
 	u16 testbit;
 
 	/* clear all serial signals except DTR and RTS */
-	info->serial_signals &= SerialSignal_DTR + SerialSignal_RTS;
+	info->serial_signals &= SerialSignal_DTR | SerialSignal_RTS;
 
 	/* set serial signal bits to reflect MISR */
 


