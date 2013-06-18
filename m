Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab3FRQSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:18:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374Ab3FRQS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:27 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 46/48] USB: spcp8x5: fix device initialisation at open
Date: Tue, 18 Jun 2013 09:18:12 -0700
Message-Id: <20130618161732.619095214@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5e4211f1c47560c36a8b3d4544dfd866dcf7ccd0 upstream.

Do not use uninitialised termios data to determine when to configure the
device at open.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/spcp8x5.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -314,7 +314,6 @@ static void spcp8x5_set_termios(struct t
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	unsigned int cflag = tty->termios.c_cflag;
-	unsigned int old_cflag = old_termios->c_cflag;
 	unsigned short uartdata;
 	unsigned char buf[2] = {0, 0};
 	int baud;
@@ -323,15 +322,15 @@ static void spcp8x5_set_termios(struct t
 
 
 	/* check that they really want us to change something */
-	if (!tty_termios_hw_change(&tty->termios, old_termios))
+	if (old_termios && !tty_termios_hw_change(&tty->termios, old_termios))
 		return;
 
 	/* set DTR/RTS active */
 	spin_lock_irqsave(&priv->lock, flags);
 	control = priv->line_control;
-	if ((old_cflag & CBAUD) == B0) {
+	if (old_termios && (old_termios->c_cflag & CBAUD) == B0) {
 		priv->line_control |= MCR_DTR;
-		if (!(old_cflag & CRTSCTS))
+		if (!(old_termios->c_cflag & CRTSCTS))
 			priv->line_control |= MCR_RTS;
 	}
 	if (control != priv->line_control) {
@@ -421,7 +420,6 @@ static void spcp8x5_set_termios(struct t
  * status of the device. */
 static int spcp8x5_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	int ret;
@@ -442,7 +440,7 @@ static int spcp8x5_open(struct tty_struc
 
 	/* Setup termios */
 	if (tty)
-		spcp8x5_set_termios(tty, port, &tmp_termios);
+		spcp8x5_set_termios(tty, port, NULL);
 
 	spcp8x5_get_msr(serial->dev, &status, priv->type);
 


