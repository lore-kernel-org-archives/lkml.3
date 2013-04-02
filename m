Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab3DBWrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:47:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268Ab3DBWMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 076/124] USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT
Date: Tue,  2 Apr 2013 15:10:58 -0700
Message-Id: <20130402221112.992921424@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit fc98ab873aa3dbe783ce56a2ffdbbe7c7609521a upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ti_usb_3410_5052.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -74,7 +74,6 @@ struct ti_port {
 	int			tp_flags;
 	int			tp_closing_wait;/* in .01 secs */
 	struct async_icount	tp_icount;
-	wait_queue_head_t	tp_msr_wait;	/* wait for msr change */
 	wait_queue_head_t	tp_write_wait;
 	struct ti_device	*tp_tdev;
 	struct usb_serial_port	*tp_port;
@@ -432,7 +431,6 @@ static int ti_port_probe(struct usb_seri
 	else
 		tport->tp_uart_base_addr = TI_UART2_BASE_ADDR;
 	tport->tp_closing_wait = closing_wait;
-	init_waitqueue_head(&tport->tp_msr_wait);
 	init_waitqueue_head(&tport->tp_write_wait);
 	if (kfifo_alloc(&tport->write_fifo, TI_WRITE_BUF_SIZE, GFP_KERNEL)) {
 		kfree(tport);
@@ -784,9 +782,13 @@ static int ti_ioctl(struct tty_struct *t
 		dev_dbg(&port->dev, "%s - TIOCMIWAIT\n", __func__);
 		cprev = tport->tp_icount;
 		while (1) {
-			interruptible_sleep_on(&tport->tp_msr_wait);
+			interruptible_sleep_on(&port->delta_msr_wait);
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+
+			if (port->serial->disconnected)
+				return -EIO;
+
 			cnow = tport->tp_icount;
 			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
 			    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
@@ -1400,7 +1402,7 @@ static void ti_handle_new_msr(struct ti_
 			icount->dcd++;
 		if (msr & TI_MSR_DELTA_RI)
 			icount->rng++;
-		wake_up_interruptible(&tport->tp_msr_wait);
+		wake_up_interruptible(&tport->tp_port->delta_msr_wait);
 		spin_unlock_irqrestore(&tport->tp_lock, flags);
 	}
 


