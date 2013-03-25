Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3CYBPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:15:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33845 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755626Ab3CYBPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:20 -0400
Message-Id: <20130325010534.035098724@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:07:02 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 098/104] USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit fc98ab873aa3dbe783ce56a2ffdbbe7c7609521a upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
@@ -447,7 +446,6 @@ static int ti_startup(struct usb_serial
 		tport->tp_uart_base_addr = (i == 0 ?
 				TI_UART1_BASE_ADDR : TI_UART2_BASE_ADDR);
 		tport->tp_closing_wait = closing_wait;
-		init_waitqueue_head(&tport->tp_msr_wait);
 		init_waitqueue_head(&tport->tp_write_wait);
 		if (kfifo_alloc(&tport->write_fifo, TI_WRITE_BUF_SIZE,
 								GFP_KERNEL)) {
@@ -848,9 +846,13 @@ static int ti_ioctl(struct tty_struct *t
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
@@ -1481,7 +1483,7 @@ static void ti_handle_new_msr(struct ti_
 			icount->dcd++;
 		if (msr & TI_MSR_DELTA_RI)
 			icount->rng++;
-		wake_up_interruptible(&tport->tp_msr_wait);
+		wake_up_interruptible(&tport->tp_port->delta_msr_wait);
 		spin_unlock_irqrestore(&tport->tp_lock, flags);
 	}
 


