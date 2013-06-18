Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab3FRQSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:18:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271Ab3FRQSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:20 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 44/48] USB: pl2303: fix device initialisation at open
Date: Tue, 18 Jun 2013 09:18:10 -0700
Message-Id: <20130618161732.336015317@linuxfoundation.org>
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

commit 2d8f4447b58bba5f8cb895c07690434c02307eaf upstream.

Do not use uninitialised termios data to determine when to configure the
device at open.

This also prevents stack data from leaking to userspace in the OOM error
path.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/pl2303.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -283,7 +283,7 @@ static void pl2303_set_termios(struct tt
 	   serial settings even to the same values as before. Thus
 	   we actually need to filter in this specific case */
 
-	if (!tty_termios_hw_change(&tty->termios, old_termios))
+	if (old_termios && !tty_termios_hw_change(&tty->termios, old_termios))
 		return;
 
 	cflag = tty->termios.c_cflag;
@@ -292,7 +292,8 @@ static void pl2303_set_termios(struct tt
 	if (!buf) {
 		dev_err(&port->dev, "%s - out of memory.\n", __func__);
 		/* Report back no change occurred */
-		tty->termios = *old_termios;
+		if (old_termios)
+			tty->termios = *old_termios;
 		return;
 	}
 
@@ -432,7 +433,7 @@ static void pl2303_set_termios(struct tt
 	control = priv->line_control;
 	if ((cflag & CBAUD) == B0)
 		priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
-	else if ((old_termios->c_cflag & CBAUD) == B0)
+	else if (old_termios && (old_termios->c_cflag & CBAUD) == B0)
 		priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
 	if (control != priv->line_control) {
 		control = priv->line_control;
@@ -491,7 +492,6 @@ static void pl2303_close(struct usb_seri
 
 static int pl2303_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
 	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
 	int result;
@@ -507,7 +507,7 @@ static int pl2303_open(struct tty_struct
 
 	/* Setup termios */
 	if (tty)
-		pl2303_set_termios(tty, port, &tmp_termios);
+		pl2303_set_termios(tty, port, NULL);
 
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
 	if (result) {


