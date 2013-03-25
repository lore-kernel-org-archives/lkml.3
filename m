Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab3CYBP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:15:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33871 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755661Ab3CYBPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:24 -0400
Message-Id: <20130325010533.226506900@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:54 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 090/104] USB: io_ti: fix use-after-free in TIOCMIWAIT
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

commit 7b2459690584f239650a365f3411ba2ec1c6d1e0 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/io_ti.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -98,9 +98,6 @@ struct edgeport_port {
 	int close_pending;
 	int lsr_event;
 	struct async_icount	icount;
-	wait_queue_head_t	delta_msr_wait;	/* for handling sleeping while
-						   waiting for msr change to
-						   happen */
 	struct edgeport_serial	*edge_serial;
 	struct usb_serial_port	*port;
 	__u8 bUartMode;		/* Port type, 0: RS232, etc. */
@@ -1557,7 +1554,7 @@ static void handle_new_msr(struct edgepo
 			icount->dcd++;
 		if (msr & EDGEPORT_MSR_DELTA_RI)
 			icount->rng++;
-		wake_up_interruptible(&edge_port->delta_msr_wait);
+		wake_up_interruptible(&edge_port->port->delta_msr_wait);
 	}
 
 	/* Save the new modem status */
@@ -1876,7 +1873,6 @@ static int edge_open(struct tty_struct *
 	dev = port->serial->dev;
 
 	memset(&(edge_port->icount), 0x00, sizeof(edge_port->icount));
-	init_waitqueue_head(&edge_port->delta_msr_wait);
 
 	/* turn off loopback */
 	status = ti_do_config(edge_port, UMPC_SET_CLR_LOOPBACK, 0);
@@ -2574,10 +2570,14 @@ static int edge_ioctl(struct tty_struct
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


