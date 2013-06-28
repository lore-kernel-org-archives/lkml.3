Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3F1TIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:08:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41822 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3F1S4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:56:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 044/105] USB: pl2303: fix device initialisation at open
Date: Fri, 28 Jun 2013 11:51:06 -0700
Message-Id: <1372445527-24414-45-git-send-email-kamal@canonical.com>
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

commit 2d8f4447b58bba5f8cb895c07690434c02307eaf upstream.

Do not use uninitialised termios data to determine when to configure the
device at open.

This also prevents stack data from leaking to userspace in the OOM error
path.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/pl2303.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index bb056a1..a16d378 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -283,7 +283,7 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	   serial settings even to the same values as before. Thus
 	   we actually need to filter in this specific case */
 
-	if (!tty_termios_hw_change(&tty->termios, old_termios))
+	if (old_termios && !tty_termios_hw_change(&tty->termios, old_termios))
 		return;
 
 	cflag = tty->termios.c_cflag;
@@ -292,7 +292,8 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	if (!buf) {
 		dev_err(&port->dev, "%s - out of memory.\n", __func__);
 		/* Report back no change occurred */
-		tty->termios = *old_termios;
+		if (old_termios)
+			tty->termios = *old_termios;
 		return;
 	}
 
@@ -432,7 +433,7 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	control = priv->line_control;
 	if ((cflag & CBAUD) == B0)
 		priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
-	else if ((old_termios->c_cflag & CBAUD) == B0)
+	else if (old_termios && (old_termios->c_cflag & CBAUD) == B0)
 		priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
 	if (control != priv->line_control) {
 		control = priv->line_control;
@@ -491,7 +492,6 @@ static void pl2303_close(struct usb_serial_port *port)
 
 static int pl2303_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
 	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
 	int result;
@@ -507,7 +507,7 @@ static int pl2303_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	/* Setup termios */
 	if (tty)
-		pl2303_set_termios(tty, port, &tmp_termios);
+		pl2303_set_termios(tty, port, NULL);
 
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
 	if (result) {
-- 
1.8.1.2

