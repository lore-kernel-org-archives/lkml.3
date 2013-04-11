Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422780Ab3DKVKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:10:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935649Ab3DKUtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:08 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3nuACCRSuPwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=QyT9fnqFq5gA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=ieGINseiFvU_EMyHzVgA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202605.986554425@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 120/171 ] USB: io_ti: fix use-after-free in TIOCMIWAIT
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0120-USB-io_ti-fix-use-after-free-in-TIOCMIWAIT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 7b2459690584f239650a365f3411ba2ec1c6d1e0 ]

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/io_ti.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index a943c06..d2b6008 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -91,9 +91,6 @@ struct edgeport_port {
 	int close_pending;
 	int lsr_event;
 	struct async_icount	icount;
-	wait_queue_head_t	delta_msr_wait;	/* for handling sleeping while
-						   waiting for msr change to
-						   happen */
 	struct edgeport_serial	*edge_serial;
 	struct usb_serial_port	*port;
 	__u8 bUartMode;		/* Port type, 0: RS232, etc. */
@@ -1539,7 +1536,7 @@ static void handle_new_msr(struct edgeport_port *edge_port, __u8 msr)
 			icount->dcd++;
 		if (msr & EDGEPORT_MSR_DELTA_RI)
 			icount->rng++;
-		wake_up_interruptible(&edge_port->delta_msr_wait);
+		wake_up_interruptible(&edge_port->port->delta_msr_wait);
 	}
 
 	/* Save the new modem status */
@@ -1857,7 +1854,6 @@ static int edge_open(struct tty_struct *tty, struct usb_serial_port *port)
 	dev = port->serial->dev;
 
 	memset(&(edge_port->icount), 0x00, sizeof(edge_port->icount));
-	init_waitqueue_head(&edge_port->delta_msr_wait);
 
 	/* turn off loopback */
 	status = ti_do_config(edge_port, UMPC_SET_CLR_LOOPBACK, 0);
@@ -2549,10 +2545,14 @@ static int edge_ioctl(struct tty_struct *tty,
 		dbg("%s - (%d) TIOCMIWAIT", __func__, port->number);
 		cprev = edge_port->icount;
 		while (1) {
-			interruptible_sleep_on(&edge_port->delta_msr_wait);
+			interruptible_sleep_on(&port->delta_msr_wait);
 			/* see if a signal did it */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+
+			if (port->serial->disconnected)
+				return -EIO;
+
 			cnow = edge_port->icount;
 			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
 			    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
-- 
1.7.10.4


