Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935301AbaDJEDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:03:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933353AbaDJDW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 077/134] USB: pl2303: fix device initialisation at open
Date: Wed,  9 Apr 2014 20:23:13 -0700
Message-Id: <20140410032309.849950262@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 2d8f4447b58bba5f8cb895c07690434c02307eaf upstream.

Do not use uninitialised termios data to determine when to configure the
device at open.

This also prevents stack data from leaking to userspace in the OOM error
path.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
[bwh: Backported to 3.2: tty_struct::termios is a pointer, not a struct]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/pl2303.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -269,7 +269,7 @@ static void pl2303_set_termios(struct tt
 	   serial settings even to the same values as before. Thus
 	   we actually need to filter in this specific case */
 
-	if (!tty_termios_hw_change(tty->termios, old_termios))
+	if (old_termios && !tty_termios_hw_change(tty->termios, old_termios))
 		return;
 
 	cflag = tty->termios->c_cflag;
@@ -278,7 +278,8 @@ static void pl2303_set_termios(struct tt
 	if (!buf) {
 		dev_err(&port->dev, "%s - out of memory.\n", __func__);
 		/* Report back no change occurred */
-		*tty->termios = *old_termios;
+		if (old_termios)
+			*tty->termios = *old_termios;
 		return;
 	}
 
@@ -416,7 +417,7 @@ static void pl2303_set_termios(struct tt
 	control = priv->line_control;
 	if ((cflag & CBAUD) == B0)
 		priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
-	else if ((old_termios->c_cflag & CBAUD) == B0)
+	else if (old_termios && (old_termios->c_cflag & CBAUD) == B0)
 		priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
 	if (control != priv->line_control) {
 		control = priv->line_control;
@@ -477,7 +478,6 @@ static void pl2303_close(struct usb_seri
 
 static int pl2303_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	int result;
@@ -495,7 +495,7 @@ static int pl2303_open(struct tty_struct
 
 	/* Setup termios */
 	if (tty)
-		pl2303_set_termios(tty, port, &tmp_termios);
+		pl2303_set_termios(tty, port, NULL);
 
 	dbg("%s - submitting interrupt urb", __func__);
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);


