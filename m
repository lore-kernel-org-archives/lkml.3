Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761573AbbA1F6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:58:45 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:53390 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761483AbbA1F6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 00:58:43 -0500
From: Peter Hung <hpeter@gmail.com>
X-Google-Original-From: Peter Hung <hpeter+linux_kernel@gmail.com>
To: johan@kernel.org
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom_tsai@fintek.com.tw,
        peter_hong@fintek.com.tw, Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: [PATCH v3 5/5] usb: serial: implement CMSPAR for F81232
Date: Wed, 28 Jan 2015 13:58:32 +0800
Message-Id: <1422424712-7561-1-git-send-email-hpeter+linux_kernel@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement CMSPAR in set_termios,
and fix some warnning from checkpatch.pl

Signed-off-by: Peter Hung <hpeter+linux_kernel@gmail.com>
---
 drivers/usb/serial/f81232.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index 11a236b..79592d6 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -175,7 +175,7 @@ static void f81232_read_msr(struct f81232_private *priv)
 
 
 static inline int update_mctrl(struct f81232_private *port_priv,
-					   unsigned int set, unsigned int clear)
+		unsigned int set, unsigned int clear)
 {
 	struct usb_device *dev = port_priv->port->serial->dev;
 	u8 urb_value;
@@ -361,12 +361,21 @@ static void f81232_set_termios(struct tty_struct *tty,
 
 
 	if (cflag & PARENB) {
-		if (cflag & PARODD)
-			new_lcr |= UART_LCR_PARITY; /* odd */
-		else
-			new_lcr |= SERIAL_EVEN_PARITY; /* even */
+		if (cflag & CMSPAR) {
+			if (cflag & PARODD)
+				new_lcr |= (UART_LCR_PARITY | UART_LCR_SPAR);
+			else
+				new_lcr |= (SERIAL_EVEN_PARITY
+							| UART_LCR_SPAR);
+		} else {
+			if (cflag & PARODD)
+				new_lcr |= UART_LCR_PARITY; /* odd */
+			else
+				new_lcr |= SERIAL_EVEN_PARITY; /* even */
+		}
 	}
 
+
 	if (cflag & CSTOPB)
 		new_lcr |= UART_LCR_STOP;
 	else
@@ -445,7 +454,7 @@ static int f81232_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
 	if (result) {
-		dev_err(&port->dev, "failed submitting interrupt urb, error %d\n",
+		dev_err(&port->dev, "failed submitting urb, error %d\n",
 			result);
 		return result;
 	}
-- 
1.9.1

