Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161079Ab3DKVOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:14:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935285Ab3DKUtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:01 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=hR3n3DlAe28A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=jLr3qM_lNTkA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=lJZ25d0EtmPCNKnz:21 a=2pvLEvEE8YnsrPsF:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202608.131942887@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 133/171 ] USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0133-USB-ti_usb_3410_5052-fix-use-after-free-in-TIOCMIWAI.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit fc98ab873aa3dbe783ce56a2ffdbbe7c7609521a ]

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/ti_usb_3410_5052.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 33537bb..722069c 100644
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
@@ -442,7 +441,6 @@ static int ti_port_probe(struct usb_serial_port *port)
 	else
 		tport->tp_uart_base_addr = TI_UART2_BASE_ADDR;
 	tport->tp_closing_wait = closing_wait;
-	init_waitqueue_head(&tport->tp_msr_wait);
 	init_waitqueue_head(&tport->tp_write_wait);
 	if (kfifo_alloc(&tport->write_fifo, TI_WRITE_BUF_SIZE, GFP_KERNEL)) {
 		kfree(tport);
@@ -798,9 +796,13 @@ static int ti_ioctl(struct tty_struct *tty,
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
@@ -1412,7 +1414,7 @@ static void ti_handle_new_msr(struct ti_port *tport, __u8 msr)
 			icount->dcd++;
 		if (msr & TI_MSR_DELTA_RI)
 			icount->rng++;
-		wake_up_interruptible(&tport->tp_msr_wait);
+		wake_up_interruptible(&tport->tp_port->delta_msr_wait);
 		spin_unlock_irqrestore(&tport->tp_lock, flags);
 	}
 
-- 
1.7.10.4


