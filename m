Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3DVO3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:29:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51369 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064Ab3DVO3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.464968237@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [07/75] USB: io_edgeport: fix use-after-free in TIOCMIWAIT
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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

