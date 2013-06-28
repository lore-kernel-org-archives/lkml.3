Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3F1TIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:08:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3F1S4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:56:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 043/105] USB: spcp8x5: fix device initialisation at open
Date: Fri, 28 Jun 2013 11:51:05 -0700
Message-Id: <1372445527-24414-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5e4211f1c47560c36a8b3d4544dfd866dcf7ccd0 upstream.

Do not use uninitialised termios data to determine when to configure the
device at open.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/spcp8x5.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 85de44d..76f11d0 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -314,7 +314,6 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	unsigned int cflag = tty->termios.c_cflag;
-	unsigned int old_cflag = old_termios->c_cflag;
 	unsigned short uartdata;
 	unsigned char buf[2] = {0, 0};
 	int baud;
@@ -323,15 +322,15 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 
 
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
@@ -421,7 +420,6 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
  * status of the device. */
 static int spcp8x5_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	int ret;
@@ -442,7 +440,7 @@ static int spcp8x5_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	/* Setup termios */
 	if (tty)
-		spcp8x5_set_termios(tty, port, &tmp_termios);
+		spcp8x5_set_termios(tty, port, NULL);
 
 	spcp8x5_get_msr(serial->dev, &status, priv->type);
 
-- 
1.8.1.2

