Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbaABMMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:12:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49514 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaABMIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH, RFC 15/30] usbserial: stop using interruptible_sleep_on
Date: Thu,  2 Jan 2014 13:07:39 +0100
Message-Id: <1388664474-1710039-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:zVJEfAWxF1GqPoFV8IsEFY/IpSne/VkHbYufZkYreXW
 V3qymDPM8QBoxzhGheoOUMfBmZT0DGlOknSnSyQWJXj4W3PnA7
 bUEo5VwR18Xi6lW+DwkVXTCRwIzcv8Z+HkBzCYLykKNCcZNx8H
 4amxt/hqP3H33qcIfoBs9NyJaOhHkn7RvKGf4e7vt4ilDGsR3h
 nMk73aFywBNN/sUDJ84DPM7XfbScIS/9rzrfqxnnxya9Msz1XH
 2w91tHzhAyClkcKbuKWZ9S2550PQfMgdY0v/aAtrbUP78vH+o+
 8W9l6ogGVIMVXSW7V+u77sQSXFGJ4XuvSTfSsvJE9b6NQ6UA65
 tMQchDyt8PvU17tlaNbbXvAlLVeyCdDM0woovcCsV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We really want to kill off interruptible_sleep_on, which is defined
in a way that is always racy. There are four usb-serial drivers using
it to implement their tiocmiwait() functions, which is defined in
a way that always has a race when called from user space.

This patch changes the four drivers in the same way to use an open-coded
prepare_to_wait/finish_wait loop to get rid of the deprecated function
call, but it does not address the fundamental race.

This particular method of implementing it was chosen because it is
least invasive, a better but more invasive alternative would be
to use usb_serial_generic_tiocmiwait, which is something I did not
dare try without access to hardware.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/serial/ch341.c      | 29 ++++++++++++++++--------
 drivers/usb/serial/cypress_m8.c | 49 ++++++++++++++++++++++++++---------------
 drivers/usb/serial/f81232.c     | 29 ++++++++++++++++--------
 drivers/usb/serial/pl2303.c     | 29 ++++++++++++++++--------
 4 files changed, 91 insertions(+), 45 deletions(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index c2a4171..f5e0eea 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -508,20 +508,22 @@ static int ch341_tiocmiwait(struct tty_struct *tty, unsigned long arg)
 	u8 status;
 	u8 changed;
 	u8 multi_change = 0;
+	DEFINE_WAIT(wait);
+	int ret;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	prevstatus = priv->line_status;
 	priv->multi_status_change = 0;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	ret = 0;
 	while (!multi_change) {
-		interruptible_sleep_on(&port->port.delta_msr_wait);
-		/* see if a signal did it */
-		if (signal_pending(current))
-			return -ERESTARTSYS;
+		prepare_to_wait(&port->port.delta_msr_wait, &wait, TASK_INTERRUPTIBLE);
 
-		if (port->serial->disconnected)
-			return -EIO;
+		if (port->serial->disconnected) {
+			ret = -EIO;
+			break;
+		}
 
 		spin_lock_irqsave(&priv->lock, flags);
 		status = priv->line_status;
@@ -534,12 +536,21 @@ static int ch341_tiocmiwait(struct tty_struct *tty, unsigned long arg)
 		    ((arg & TIOCM_DSR) && (changed & CH341_BIT_DSR)) ||
 		    ((arg & TIOCM_CD)  && (changed & CH341_BIT_DCD)) ||
 		    ((arg & TIOCM_CTS) && (changed & CH341_BIT_CTS))) {
-			return 0;
+			break;
 		}
+
+		schedule();
+
+		/* see if a signal did it */
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+
 		prevstatus = status;
 	}
-
-	return 0;
+	finish_wait(&port->port.delta_msr_wait, &wait);
+	return ret;
 }
 
 static int ch341_tiocmget(struct tty_struct *tty)
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 558605d..e05c9c6 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -869,38 +869,51 @@ static int cypress_tiocmiwait(struct tty_struct *tty, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
-	char diff;
+	char changed;
+	DEFINE_WAIT(wait);
+	int ret;
 
-	for (;;) {
-		interruptible_sleep_on(&port->port.delta_msr_wait);
-		/* see if a signal did it */
-		if (signal_pending(current))
-			return -ERESTARTSYS;
+	while (1) {
+		prepare_to_wait(&port->port.delta_msr_wait, &wait, TASK_INTERRUPTIBLE);
 
-		if (port->serial->disconnected)
-			return -EIO;
+		if (port->serial->disconnected) {
+			ret = -EIO;
+			break;
+		}
 
-		diff = priv->diff_status;
-		if (diff == 0)
-			return -EIO; /* no change => error */
+		changed = priv->diff_status;
+		if (changed == 0) {
+			ret = -EIO; /* no change => error */
+			break;
+		}
 
 		/* consume all events */
 		priv->diff_status = 0;
 
 		/* return 0 if caller wanted to know about
 		   these bits */
-		if (((arg & TIOCM_RNG) && (diff & UART_RI))  ||
-			((arg & TIOCM_DSR) && (diff & UART_DSR)) ||
-			((arg & TIOCM_CD)  && (diff & UART_CD))  ||
-			((arg & TIOCM_CTS) && (diff & UART_CTS)))
-			return 0;
+		if (((arg & TIOCM_RNG) && (changed & UART_RI))  ||
+		    ((arg & TIOCM_DSR) && (changed & UART_DSR)) ||
+		    ((arg & TIOCM_CD)  && (changed & UART_CD))  ||
+		    ((arg & TIOCM_CTS) && (changed & UART_CTS))) {
+			ret = 0;
+			break;
+		}
+
+		schedule();
+
+		/* see if a signal did it */
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
 		/* otherwise caller can't care less about what
 		 * happened, and so we continue to wait for
 		 * more events.
 		 */
 	}
-
-	return 0;
+	finish_wait(&port->port.delta_msr_wait, &wait);
+	return ret;
 }
 
 static void cypress_set_termios(struct tty_struct *tty,
diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index 639a18f..935f2e5 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -249,19 +249,20 @@ static int f81232_tiocmiwait(struct tty_struct *tty, unsigned long arg)
 	unsigned int prevstatus;
 	unsigned int status;
 	unsigned int changed;
+	DEFINE_WAIT(wait);
+	int ret;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	prevstatus = priv->line_status;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (1) {
-		interruptible_sleep_on(&port->port.delta_msr_wait);
-		/* see if a signal did it */
-		if (signal_pending(current))
-			return -ERESTARTSYS;
+		prepare_to_wait(&port->port.delta_msr_wait, &wait, TASK_INTERRUPTIBLE);
 
-		if (port->serial->disconnected)
-			return -EIO;
+		if (port->serial->disconnected) {
+			ret = -EIO;
+			break;
+		}
 
 		spin_lock_irqsave(&priv->lock, flags);
 		status = priv->line_status;
@@ -273,12 +274,22 @@ static int f81232_tiocmiwait(struct tty_struct *tty, unsigned long arg)
 		    ((arg & TIOCM_DSR) && (changed & UART_DSR)) ||
 		    ((arg & TIOCM_CD)  && (changed & UART_DCD)) ||
 		    ((arg & TIOCM_CTS) && (changed & UART_CTS))) {
-			return 0;
+			ret = 0;
+			break;
+		}
+
+		schedule();
+
+		/* see if a signal did it */
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
 		}
+
 		prevstatus = status;
 	}
-	/* NOTREACHED */
-	return 0;
+	finish_wait(&port->port.delta_msr_wait, &wait);
+	return ret;
 }
 
 static int f81232_ioctl(struct tty_struct *tty,
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 1e3318d..e8f30bc 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -594,19 +594,20 @@ static int pl2303_tiocmiwait(struct tty_struct *tty, unsigned long arg)
 	unsigned int prevstatus;
 	unsigned int status;
 	unsigned int changed;
+	DEFINE_WAIT(wait);
+	int ret;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	prevstatus = priv->line_status;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (1) {
-		interruptible_sleep_on(&port->port.delta_msr_wait);
-		/* see if a signal did it */
-		if (signal_pending(current))
-			return -ERESTARTSYS;
+		prepare_to_wait(&port->port.delta_msr_wait, &wait, TASK_INTERRUPTIBLE);
 
-		if (port->serial->disconnected)
-			return -EIO;
+		if (port->serial->disconnected) {
+			ret = -EIO;
+			break;
+		}
 
 		spin_lock_irqsave(&priv->lock, flags);
 		status = priv->line_status;
@@ -618,12 +619,22 @@ static int pl2303_tiocmiwait(struct tty_struct *tty, unsigned long arg)
 		    ((arg & TIOCM_DSR) && (changed & UART_DSR)) ||
 		    ((arg & TIOCM_CD)  && (changed & UART_DCD)) ||
 		    ((arg & TIOCM_CTS) && (changed & UART_CTS))) {
-			return 0;
+			ret = 0;
+			break;
+		}
+
+		schedule();
+
+		/* see if a signal did it */
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
 		}
+
 		prevstatus = status;
 	}
-	/* NOTREACHED */
-	return 0;
+	finish_wait(&port->port.delta_msr_wait, &wait);
+	return ret;
 }
 
 static int pl2303_ioctl(struct tty_struct *tty,
-- 
1.8.3.2

