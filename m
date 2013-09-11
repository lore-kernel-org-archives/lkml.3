Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab3ILFkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:40:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab3ILFkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:40:43 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=C70u90mh_SoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=e2z-69I-nTsA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=5vZtGwkbL8j9K41bnocA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042906.946578685@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [088/251] USB: mos7840: fix memory leak in open
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0088-USB-mos7840-fix-memory-leak-in-open.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 5f8a2e68b679b41cc8e9b642f2f5aa45dd678641 ]

Allocated urbs and buffers were never freed on errors in open.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/mos7840.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 3193d25..15cc47d 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -972,20 +972,20 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 	status = mos7840_get_reg_sync(port, mos7840_port->SpRegOffset, &Data);
 	if (status < 0) {
 		dbg("Reading Spreg failed");
-		return -1;
+		goto err;
 	}
 	Data |= 0x80;
 	status = mos7840_set_reg_sync(port, mos7840_port->SpRegOffset, Data);
 	if (status < 0) {
 		dbg("writing Spreg failed");
-		return -1;
+		goto err;
 	}
 
 	Data &= ~0x80;
 	status = mos7840_set_reg_sync(port, mos7840_port->SpRegOffset, Data);
 	if (status < 0) {
 		dbg("writing Spreg failed");
-		return -1;
+		goto err;
 	}
 	/* End of block to be checked */
 
@@ -994,7 +994,7 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 									&Data);
 	if (status < 0) {
 		dbg("Reading Controlreg failed");
-		return -1;
+		goto err;
 	}
 	Data |= 0x08;		/* Driver done bit */
 	Data |= 0x20;		/* rx_disable */
@@ -1002,7 +1002,7 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 				mos7840_port->ControlRegOffset, Data);
 	if (status < 0) {
 		dbg("writing Controlreg failed");
-		return -1;
+		goto err;
 	}
 	/* do register settings here */
 	/* Set all regs to the device default values. */
@@ -1013,21 +1013,21 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 	status = mos7840_set_uart_reg(port, INTERRUPT_ENABLE_REGISTER, Data);
 	if (status < 0) {
 		dbg("disabling interrupts failed");
-		return -1;
+		goto err;
 	}
 	/* Set FIFO_CONTROL_REGISTER to the default value */
 	Data = 0x00;
 	status = mos7840_set_uart_reg(port, FIFO_CONTROL_REGISTER, Data);
 	if (status < 0) {
 		dbg("Writing FIFO_CONTROL_REGISTER  failed");
-		return -1;
+		goto err;
 	}
 
 	Data = 0xcf;
 	status = mos7840_set_uart_reg(port, FIFO_CONTROL_REGISTER, Data);
 	if (status < 0) {
 		dbg("Writing FIFO_CONTROL_REGISTER  failed");
-		return -1;
+		goto err;
 	}
 
 	Data = 0x03;
@@ -1181,6 +1181,15 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 				serial, mos7840_port, port);
 
 	return 0;
+err:
+	for (j = 0; j < NUM_URBS; ++j) {
+		urb = mos7840_port->write_urb_pool[j];
+		if (!urb)
+			continue;
+		kfree(urb->transfer_buffer);
+		usb_free_urb(urb);
+	}
+	return status;
 }
 
 /*****************************************************************************
-- 
1.7.10.4


