Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab3B1Orp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:47:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42071 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab3B1Orf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 044/139] USB: serial: fix null-pointer dereferences on disconnect
Date: Thu, 28 Feb 2013 14:43:14 +0000
Message-Id: <1362062689-2567-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit b2ca699076573c94fee9a73cb0d8645383b602a0 upstream.

Make sure serial-driver dtr_rts is called with disc_mutex held after
checking the disconnected flag.

Due to a bug in the tty layer, dtr_rts may get called after a device has
been disconnected and the tty-device unregistered. Some drivers have had
individual checks for disconnect to make sure the disconnected interface
was not accessed, but this should really be handled in usb-serial core
(at least until the long-standing tty-bug has been fixed).

Note that the problem has been made more acute with commit 0998d0631001
("device-core: Ensure drvdata = NULL when no driver is bound") as the
port data is now also NULL when dtr_rts is called resulting in further
oopses.

Reported-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c   | 20 +++++++++-----------
 drivers/usb/serial/mct_u232.c   | 22 +++++++++-------------
 drivers/usb/serial/quatech2.c   | 18 ++++++++----------
 drivers/usb/serial/sierra.c     |  8 +-------
 drivers/usb/serial/ssu100.c     | 19 ++++++++-----------
 drivers/usb/serial/usb-serial.c | 14 ++++++++++++--
 drivers/usb/serial/usb_wwan.c   |  8 +++-----
 7 files changed, 50 insertions(+), 59 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 4c1fa24..1f939cb 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1890,24 +1890,22 @@ static void ftdi_dtr_rts(struct usb_serial_port *port, int on)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 
-	mutex_lock(&port->serial->disc_mutex);
-	if (!port->serial->disconnected) {
-		/* Disable flow control */
-		if (!on && usb_control_msg(port->serial->dev,
+	/* Disable flow control */
+	if (!on) {
+		if (usb_control_msg(port->serial->dev,
 			    usb_sndctrlpipe(port->serial->dev, 0),
 			    FTDI_SIO_SET_FLOW_CTRL_REQUEST,
 			    FTDI_SIO_SET_FLOW_CTRL_REQUEST_TYPE,
 			    0, priv->interface, NULL, 0,
 			    WDR_TIMEOUT) < 0) {
-			    dev_err(&port->dev, "error from flowcontrol urb\n");
+			dev_err(&port->dev, "error from flowcontrol urb\n");
 		}
-		/* drop RTS and DTR */
-		if (on)
-			set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
-		else
-			clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 	}
-	mutex_unlock(&port->serial->disc_mutex);
+	/* drop RTS and DTR */
+	if (on)
+		set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
+	else
+		clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 }
 
 /*
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index d06130d..66b91d5 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -502,19 +502,15 @@ static void mct_u232_dtr_rts(struct usb_serial_port *port, int on)
 	unsigned int control_state;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
 
-	mutex_lock(&port->serial->disc_mutex);
-	if (!port->serial->disconnected) {
-		/* drop DTR and RTS */
-		spin_lock_irq(&priv->lock);
-		if (on)
-			priv->control_state |= TIOCM_DTR | TIOCM_RTS;
-		else
-			priv->control_state &= ~(TIOCM_DTR | TIOCM_RTS);
-		control_state = priv->control_state;
-		spin_unlock_irq(&priv->lock);
-		mct_u232_set_modem_ctrl(port->serial, control_state);
-	}
-	mutex_unlock(&port->serial->disc_mutex);
+	spin_lock_irq(&priv->lock);
+	if (on)
+		priv->control_state |= TIOCM_DTR | TIOCM_RTS;
+	else
+		priv->control_state &= ~(TIOCM_DTR | TIOCM_RTS);
+	control_state = priv->control_state;
+	spin_unlock_irq(&priv->lock);
+
+	mct_u232_set_modem_ctrl(port, control_state);
 }
 
 static void mct_u232_close(struct usb_serial_port *port)
diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index 09d736a..e1065f8 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -976,19 +976,17 @@ static void qt2_dtr_rts(struct usb_serial_port *port, int on)
 	struct usb_device *dev = port->serial->dev;
 	struct qt2_port_private *port_priv = usb_get_serial_port_data(port);
 
-	mutex_lock(&port->serial->disc_mutex);
-	if (!port->serial->disconnected) {
-		/* Disable flow control */
-		if (!on && qt2_setregister(dev, port_priv->device_port,
+	/* Disable flow control */
+	if (!on) {
+		if (qt2_setregister(dev, port_priv->device_port,
 					   UART_MCR, 0) < 0)
 			dev_warn(&port->dev, "error from flowcontrol urb\n");
-		/* drop RTS and DTR */
-		if (on)
-			update_mctrl(port_priv, TIOCM_DTR | TIOCM_RTS, 0);
-		else
-			update_mctrl(port_priv, 0, TIOCM_DTR | TIOCM_RTS);
 	}
-	mutex_unlock(&port->serial->disc_mutex);
+	/* drop RTS and DTR */
+	if (on)
+		update_mctrl(port_priv, TIOCM_DTR | TIOCM_RTS, 0);
+	else
+		update_mctrl(port_priv, 0, TIOCM_DTR | TIOCM_RTS);
 }
 
 static void qt2_update_msr(struct usb_serial_port *port, unsigned char *ch)
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 6aeddcd..defe6ee 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -866,19 +866,13 @@ static int sierra_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 static void sierra_dtr_rts(struct usb_serial_port *port, int on)
 {
-	struct usb_serial *serial = port->serial;
 	struct sierra_port_private *portdata;
 
 	portdata = usb_get_serial_port_data(port);
 	portdata->rts_state = on;
 	portdata->dtr_state = on;
 
-	if (serial->dev) {
-		mutex_lock(&serial->disc_mutex);
-		if (!serial->disconnected)
-			sierra_send_setup(port);
-		mutex_unlock(&serial->disc_mutex);
-	}
+	sierra_send_setup(port);
 }
 
 static int sierra_startup(struct usb_serial *serial)
diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index 3fee23b..c4409b1 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -505,19 +505,16 @@ static void ssu100_dtr_rts(struct usb_serial_port *port, int on)
 {
 	struct usb_device *dev = port->serial->dev;
 
-	mutex_lock(&port->serial->disc_mutex);
-	if (!port->serial->disconnected) {
-		/* Disable flow control */
-		if (!on &&
-		    ssu100_setregister(dev, 0, UART_MCR, 0) < 0)
+	/* Disable flow control */
+	if (!on) {
+		if (ssu100_setregister(dev, 0, UART_MCR, 0) < 0)
 			dev_err(&port->dev, "error from flowcontrol urb\n");
-		/* drop RTS and DTR */
-		if (on)
-			set_mctrl(dev, TIOCM_DTR | TIOCM_RTS);
-		else
-			clear_mctrl(dev, TIOCM_DTR | TIOCM_RTS);
 	}
-	mutex_unlock(&port->serial->disc_mutex);
+	/* drop RTS and DTR */
+	if (on)
+		set_mctrl(dev, TIOCM_DTR | TIOCM_RTS);
+	else
+		clear_mctrl(dev, TIOCM_DTR | TIOCM_RTS);
 }
 
 static void ssu100_update_msr(struct usb_serial_port *port, u8 msr)
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 667c39c..771adbd 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -688,10 +688,20 @@ static int serial_carrier_raised(struct tty_port *port)
 static void serial_dtr_rts(struct tty_port *port, int on)
 {
 	struct usb_serial_port *p = container_of(port, struct usb_serial_port, port);
-	struct usb_serial_driver *drv = p->serial->type;
+	struct usb_serial *serial = p->serial;
+	struct usb_serial_driver *drv = serial->type;
 
-	if (drv->dtr_rts)
+	if (!drv->dtr_rts)
+		return;
+	/*
+	 * Work-around bug in the tty-layer which can result in dtr_rts
+	 * being called after a disconnect (and tty_unregister_device
+	 * has returned). Remove once bug has been squashed.
+	 */
+	mutex_lock(&serial->disc_mutex);
+	if (!serial->disconnected)
 		drv->dtr_rts(p, on);
+	mutex_unlock(&serial->disc_mutex);
 }
 
 static const struct tty_port_operations serial_port_ops = {
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index da28535..25c8ee9 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -41,7 +41,6 @@ static bool debug;
 
 void usb_wwan_dtr_rts(struct usb_serial_port *port, int on)
 {
-	struct usb_serial *serial = port->serial;
 	struct usb_wwan_port_private *portdata;
 	struct usb_wwan_intf_private *intfdata;
 
@@ -51,12 +50,11 @@ void usb_wwan_dtr_rts(struct usb_serial_port *port, int on)
 		return;
 
 	portdata = usb_get_serial_port_data(port);
-	mutex_lock(&serial->disc_mutex);
+	/* FIXME: locking */
 	portdata->rts_state = on;
 	portdata->dtr_state = on;
-	if (serial->dev)
-		intfdata->send_setup(port);
-	mutex_unlock(&serial->disc_mutex);
+
+	intfdata->send_setup(port);
 }
 EXPORT_SYMBOL(usb_wwan_dtr_rts);
 
-- 
1.8.1.2

