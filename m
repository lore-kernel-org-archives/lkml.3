Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab3HQAJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:09:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51671 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675Ab3HPWjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 040/133] USB: mos7840: fix memory leak in open
Date: Fri, 16 Aug 2013 15:33:02 -0700
Message-Id: <1376692475-28413-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5f8a2e68b679b41cc8e9b642f2f5aa45dd678641 upstream.

Allocated urbs and buffers were never freed on errors in open.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/mos7840.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 54f23f0..06ca54a 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -942,20 +942,20 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 	status = mos7840_get_reg_sync(port, mos7840_port->SpRegOffset, &Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Reading Spreg failed\n");
-		return -1;
+		goto err;
 	}
 	Data |= 0x80;
 	status = mos7840_set_reg_sync(port, mos7840_port->SpRegOffset, Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "writing Spreg failed\n");
-		return -1;
+		goto err;
 	}
 
 	Data &= ~0x80;
 	status = mos7840_set_reg_sync(port, mos7840_port->SpRegOffset, Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "writing Spreg failed\n");
-		return -1;
+		goto err;
 	}
 	/* End of block to be checked */
 
@@ -964,7 +964,7 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 									&Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Reading Controlreg failed\n");
-		return -1;
+		goto err;
 	}
 	Data |= 0x08;		/* Driver done bit */
 	Data |= 0x20;		/* rx_disable */
@@ -972,7 +972,7 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 				mos7840_port->ControlRegOffset, Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "writing Controlreg failed\n");
-		return -1;
+		goto err;
 	}
 	/* do register settings here */
 	/* Set all regs to the device default values. */
@@ -983,21 +983,21 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 	status = mos7840_set_uart_reg(port, INTERRUPT_ENABLE_REGISTER, Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "disabling interrupts failed\n");
-		return -1;
+		goto err;
 	}
 	/* Set FIFO_CONTROL_REGISTER to the default value */
 	Data = 0x00;
 	status = mos7840_set_uart_reg(port, FIFO_CONTROL_REGISTER, Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Writing FIFO_CONTROL_REGISTER  failed\n");
-		return -1;
+		goto err;
 	}
 
 	Data = 0xcf;
 	status = mos7840_set_uart_reg(port, FIFO_CONTROL_REGISTER, Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Writing FIFO_CONTROL_REGISTER  failed\n");
-		return -1;
+		goto err;
 	}
 
 	Data = 0x03;
@@ -1147,6 +1147,15 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 	mos7840_port->icount.rx = 0;
 
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
1.8.1.2

