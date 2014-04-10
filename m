Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965123AbaDJEHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:07:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934637AbaDJDWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 071/134] USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT
Date: Wed,  9 Apr 2014 20:23:07 -0700
Message-Id: <20140410032309.206141365@linuxfoundation.org>
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

commit 3668b9c17765cacf411effc4fc6e44099ac30800 upstream.

commit fc98ab873aa3dbe783ce56a2ffdbbe7c7609521a upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ti_usb_3410_5052.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -75,7 +75,6 @@ struct ti_port {
 	int			tp_flags;
 	int			tp_closing_wait;/* in .01 secs */
 	struct async_icount	tp_icount;
-	wait_queue_head_t	tp_msr_wait;	/* wait for msr change */
 	wait_queue_head_t	tp_write_wait;
 	struct ti_device	*tp_tdev;
 	struct usb_serial_port	*tp_port;
@@ -430,7 +429,6 @@ static int ti_startup(struct usb_serial
 		tport->tp_uart_base_addr = (i == 0 ?
 				TI_UART1_BASE_ADDR : TI_UART2_BASE_ADDR);
 		tport->tp_closing_wait = closing_wait;
-		init_waitqueue_head(&tport->tp_msr_wait);
 		init_waitqueue_head(&tport->tp_write_wait);
 		if (kfifo_alloc(&tport->write_fifo, TI_WRITE_BUF_SIZE,
 								GFP_KERNEL)) {
@@ -827,9 +825,13 @@ static int ti_ioctl(struct tty_struct *t
 		dbg("%s - (%d) TIOCMIWAIT", __func__, port->number);
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
@@ -1458,7 +1460,7 @@ static void ti_handle_new_msr(struct ti_
 			icount->dcd++;
 		if (msr & TI_MSR_DELTA_RI)
 			icount->rng++;
-		wake_up_interruptible(&tport->tp_msr_wait);
+		wake_up_interruptible(&tport->tp_port->delta_msr_wait);
 		spin_unlock_irqrestore(&tport->tp_lock, flags);
 	}
 


