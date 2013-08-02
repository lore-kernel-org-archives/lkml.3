Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab3HBKvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:51:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382Ab3HBKJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:09:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 26/99] USB: mos7840: fix memory leak in open
Date: Fri,  2 Aug 2013 18:07:39 +0800
Message-Id: <20130802100229.704290109@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5f8a2e68b679b41cc8e9b642f2f5aa45dd678641 upstream.

Allocated urbs and buffers were never freed on errors in open.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -914,20 +914,20 @@ static int mos7840_open(struct tty_struc
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
 
@@ -936,7 +936,7 @@ static int mos7840_open(struct tty_struc
 									&Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Reading Controlreg failed\n");
-		return -1;
+		goto err;
 	}
 	Data |= 0x08;		/* Driver done bit */
 	Data |= 0x20;		/* rx_disable */
@@ -944,7 +944,7 @@ static int mos7840_open(struct tty_struc
 				mos7840_port->ControlRegOffset, Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "writing Controlreg failed\n");
-		return -1;
+		goto err;
 	}
 	/* do register settings here */
 	/* Set all regs to the device default values. */
@@ -955,21 +955,21 @@ static int mos7840_open(struct tty_struc
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
@@ -1114,6 +1114,15 @@ static int mos7840_open(struct tty_struc
 	/* mos7840_change_port_settings(mos7840_port,old_termios); */
 
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


