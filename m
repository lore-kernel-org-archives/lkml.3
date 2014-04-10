Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935449AbaDJEGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:06:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934819AbaDJDWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 062/134] USB: io_edgeport: fix use-after-free in TIOCMIWAIT
Date: Wed,  9 Apr 2014 20:22:58 -0700
Message-Id: <20140410032308.045542104@linuxfoundation.org>
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

commit 333576255d4cfc53efd056aad438568184b36af6 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
@@ -884,7 +883,6 @@ static int edge_open(struct tty_struct *
 	/* initialize our wait queues */
 	init_waitqueue_head(&edge_port->wait_open);
 	init_waitqueue_head(&edge_port->wait_chase);
-	init_waitqueue_head(&edge_port->delta_msr_wait);
 	init_waitqueue_head(&edge_port->wait_command);
 
 	/* initialize our icount structure */
@@ -1701,13 +1699,17 @@ static int edge_ioctl(struct tty_struct
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
@@ -2088,7 +2090,7 @@ static void handle_new_msr(struct edgepo
 			icount->dcd++;
 		if (newMsr & EDGEPORT_MSR_DELTA_RI)
 			icount->rng++;
-		wake_up_interruptible(&edge_port->delta_msr_wait);
+		wake_up_interruptible(&edge_port->port->delta_msr_wait);
 	}
 
 	/* Save the new modem status */


