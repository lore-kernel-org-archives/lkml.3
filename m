Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab3CYBgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:36:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33859 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755641Ab3CYBPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:22 -0400
Message-Id: <20130325010533.545129349@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:57 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 093/104] USB: mos7840: fix use-after-free in TIOCMIWAIT
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

commit a14430db686b8e459e1cf070a6ecf391515c9ab9 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/mos7840.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -240,7 +240,6 @@ struct moschip_port {
 	char open;
 	char open_ports;
 	wait_queue_head_t wait_chase;	/* for handling sleeping while waiting for chase to finish */
-	wait_queue_head_t delta_msr_wait;	/* for handling sleeping while waiting for msr change to happen */
 	int delta_msr_cond;
 	struct async_icount icount;
 	struct usb_serial_port *port;	/* loop back to the owner of this object */
@@ -455,7 +454,7 @@ static void mos7840_handle_new_msr(struc
 		}
 
 		mos7840_port->delta_msr_cond = 1;
-		wake_up_interruptible(&mos7840_port->delta_msr_wait);
+		wake_up_interruptible(&port->port->delta_msr_wait);
 	}
 }
 
@@ -1118,7 +1117,6 @@ static int mos7840_open(struct tty_struc
 
 	/* initialize our wait queues */
 	init_waitqueue_head(&mos7840_port->wait_chase);
-	init_waitqueue_head(&mos7840_port->delta_msr_wait);
 
 	/* initialize our icount structure */
 	memset(&(mos7840_port->icount), 0x00, sizeof(mos7840_port->icount));
@@ -2285,13 +2283,18 @@ static int mos7840_ioctl(struct tty_stru
 		while (1) {
 			/* interruptible_sleep_on(&mos7840_port->delta_msr_wait); */
 			mos7840_port->delta_msr_cond = 0;
-			wait_event_interruptible(mos7840_port->delta_msr_wait,
-						 (mos7840_port->
+			wait_event_interruptible(port->delta_msr_wait,
+						 (port->serial->disconnected ||
+						  mos7840_port->
 						  delta_msr_cond == 1));
 
 			/* see if a signal did it */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+
+			if (port->serial->disconnected)
+				return -EIO;
+
 			cnow = mos7840_port->icount;
 			smp_rmb();
 			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&


