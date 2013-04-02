Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3DBWt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:49:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933308Ab3DBWMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 063/124] USB: io_ti: fix use-after-free in TIOCMIWAIT
Date: Tue,  2 Apr 2013 15:10:45 -0700
Message-Id: <20130402221111.491694957@linuxfoundation.org>
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

commit 7b2459690584f239650a365f3411ba2ec1c6d1e0 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/io_ti.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -87,9 +87,6 @@ struct edgeport_port {
 	int close_pending;
 	int lsr_event;
 	struct async_icount	icount;
-	wait_queue_head_t	delta_msr_wait;	/* for handling sleeping while
-						   waiting for msr change to
-						   happen */
 	struct edgeport_serial	*edge_serial;
 	struct usb_serial_port	*port;
 	__u8 bUartMode;		/* Port type, 0: RS232, etc. */
@@ -1518,7 +1515,7 @@ static void handle_new_msr(struct edgepo
 			icount->dcd++;
 		if (msr & EDGEPORT_MSR_DELTA_RI)
 			icount->rng++;
-		wake_up_interruptible(&edge_port->delta_msr_wait);
+		wake_up_interruptible(&edge_port->port->delta_msr_wait);
 	}
 
 	/* Save the new modem status */
@@ -1821,7 +1818,6 @@ static int edge_open(struct tty_struct *
 	dev = port->serial->dev;
 
 	memset(&(edge_port->icount), 0x00, sizeof(edge_port->icount));
-	init_waitqueue_head(&edge_port->delta_msr_wait);
 
 	/* turn off loopback */
 	status = ti_do_config(edge_port, UMPC_SET_CLR_LOOPBACK, 0);
@@ -2488,10 +2484,14 @@ static int edge_ioctl(struct tty_struct
 		dev_dbg(&port->dev, "%s - TIOCMIWAIT\n", __func__);
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


