Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965477Ab3GCTTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:19:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933124Ab3GCTAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:07 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=dGFm2J3KOH4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zAHf6aQoh_IA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=kmED-bSZlIp3iGByi80A:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184110.183087350@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:41:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [141/141] USB: spcp8x5: fix device initialisation at open
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0141-USB-spcp8x5-fix-device-initialisation-at-open.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 5e4211f1c47560c36a8b3d4544dfd866dcf7ccd0 ]

Do not use uninitialised termios data to determine when to configure the
device at open.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/spcp8x5.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 0822a10..cc35b13 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -319,7 +319,6 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	unsigned int cflag = tty->termios->c_cflag;
-	unsigned int old_cflag = old_termios->c_cflag;
 	unsigned short uartdata;
 	unsigned char buf[2] = {0, 0};
 	int baud;
@@ -328,15 +327,15 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 
 
 	/* check that they really want us to change something */
-	if (!tty_termios_hw_change(tty->termios, old_termios))
+	if (old_termios && !tty_termios_hw_change(tty->termios, old_termios))
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
@@ -426,7 +425,6 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
  * status of the device. */
 static int spcp8x5_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	int ret;
@@ -447,7 +445,7 @@ static int spcp8x5_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	/* Setup termios */
 	if (tty)
-		spcp8x5_set_termios(tty, port, &tmp_termios);
+		spcp8x5_set_termios(tty, port, NULL);
 
 	spcp8x5_get_msr(serial->dev, &status, priv->type);
 
-- 
1.7.10.4


