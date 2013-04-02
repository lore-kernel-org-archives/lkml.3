Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab3DBWMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:12:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268Ab3DBWMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 067/124] USB: mos7840: fix use-after-free in TIOCMIWAIT
Date: Tue,  2 Apr 2013 15:10:49 -0700
Message-Id: <20130402221111.983810025@linuxfoundation.org>
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

commit a14430db686b8e459e1cf070a6ecf391515c9ab9 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -219,7 +219,6 @@ struct moschip_port {
 	char open;
 	char open_ports;
 	wait_queue_head_t wait_chase;	/* for handling sleeping while waiting for chase to finish */
-	wait_queue_head_t delta_msr_wait;	/* for handling sleeping while waiting for msr change to happen */
 	int delta_msr_cond;
 	struct async_icount icount;
 	struct usb_serial_port *port;	/* loop back to the owner of this object */
@@ -425,7 +424,7 @@ static void mos7840_handle_new_msr(struc
 		}
 
 		mos7840_port->delta_msr_cond = 1;
-		wake_up_interruptible(&mos7840_port->delta_msr_wait);
+		wake_up_interruptible(&port->port->delta_msr_wait);
 	}
 }
 
@@ -1134,7 +1133,6 @@ static int mos7840_open(struct tty_struc
 
 	/* initialize our wait queues */
 	init_waitqueue_head(&mos7840_port->wait_chase);
-	init_waitqueue_head(&mos7840_port->delta_msr_wait);
 
 	/* initialize our icount structure */
 	memset(&(mos7840_port->icount), 0x00, sizeof(mos7840_port->icount));
@@ -2224,13 +2222,18 @@ static int mos7840_ioctl(struct tty_stru
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


