Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab3CYBf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:35:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33868 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755651Ab3CYBPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:23 -0400
Message-Id: <20130325010533.123640791@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:53 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 089/104] USB: io_edgeport: fix use-after-free in TIOCMIWAIT
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

commit 333576255d4cfc53efd056aad438568184b36af6 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/io_edgeport.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -114,7 +114,6 @@ struct edgeport_port {
 	wait_queue_head_t	wait_chase;		/* for handling sleeping while waiting for chase to finish */
 	wait_queue_head_t	wait_open;		/* for handling sleeping while waiting for open to finish */
 	wait_queue_head_t	wait_command;		/* for handling sleeping while waiting for command to finish */
-	wait_queue_head_t	delta_msr_wait;		/* for handling sleeping while waiting for msr change to happen */
 
 	struct async_icount	icount;
 	struct usb_serial_port	*port;			/* loop back to the owner of this object */
@@ -885,7 +884,6 @@ static int edge_open(struct tty_struct *
 	/* initialize our wait queues */
 	init_waitqueue_head(&edge_port->wait_open);
 	init_waitqueue_head(&edge_port->wait_chase);
-	init_waitqueue_head(&edge_port->delta_msr_wait);
 	init_waitqueue_head(&edge_port->wait_command);
 
 	/* initialize our icount structure */
@@ -1703,13 +1701,17 @@ static int edge_ioctl(struct tty_struct
 		dbg("%s (%d) TIOCMIWAIT", __func__,  port->number);
 		cprev = edge_port->icount;
 		while (1) {
-			prepare_to_wait(&edge_port->delta_msr_wait,
+			prepare_to_wait(&port->delta_msr_wait,
 						&wait, TASK_INTERRUPTIBLE);
 			schedule();
-			finish_wait(&edge_port->delta_msr_wait, &wait);
+			finish_wait(&port->delta_msr_wait, &wait);
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
@@ -2090,7 +2092,7 @@ static void handle_new_msr(struct edgepo
 			icount->dcd++;
 		if (newMsr & EDGEPORT_MSR_DELTA_RI)
 			icount->rng++;
-		wake_up_interruptible(&edge_port->delta_msr_wait);
+		wake_up_interruptible(&edge_port->port->delta_msr_wait);
 	}
 
 	/* Save the new modem status */


