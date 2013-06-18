Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3FRLtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:49:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56294 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab3FRLpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:45:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 84/93] USB: spcp8x5: fix device initialisation at open
Date: Tue, 18 Jun 2013 12:43:32 +0100
Message-Id: <1371555821-12820-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5e4211f1c47560c36a8b3d4544dfd866dcf7ccd0 upstream.

Do not use uninitialised termios data to determine when to configure the
device at open.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5:
  - adjusted context
  - termios is a pointer, not a struct ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/spcp8x5.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 66a4871..10760f2 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -329,7 +329,6 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	unsigned int cflag = tty->termios->c_cflag;
-	unsigned int old_cflag = old_termios->c_cflag;
 	unsigned short uartdata;
 	unsigned char buf[2] = {0, 0};
 	int baud;
@@ -338,15 +337,15 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 
 
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
@@ -436,7 +435,6 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
  * status of the device. */
 static int spcp8x5_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	int ret;
@@ -457,7 +455,7 @@ static int spcp8x5_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	/* Setup termios */
 	if (tty)
-		spcp8x5_set_termios(tty, port, &tmp_termios);
+		spcp8x5_set_termios(tty, port, NULL);
 
 	spcp8x5_get_msr(serial->dev, &status, priv->type);
 
-- 
1.8.1.2

