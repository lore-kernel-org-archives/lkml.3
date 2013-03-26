Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965302Ab3CZPXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:23:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54026 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965267Ab3CZPX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 108/150] USB: mos7840: fix use-after-free in TIOCMIWAIT
Date: Tue, 26 Mar 2013 15:20:07 +0000
Message-Id: <1364311249-14454-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit a14430db686b8e459e1cf070a6ecf391515c9ab9 upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/mos7840.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index be5f09b..2727955 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -224,7 +224,6 @@ struct moschip_port {
 	char open;
 	char open_ports;
 	wait_queue_head_t wait_chase;	/* for handling sleeping while waiting for chase to finish */
-	wait_queue_head_t delta_msr_wait;	/* for handling sleeping while waiting for msr change to happen */
 	int delta_msr_cond;
 	struct async_icount icount;
 	struct usb_serial_port *port;	/* loop back to the owner of this object */
@@ -444,7 +443,7 @@ static void mos7840_handle_new_msr(struct moschip_port *port, __u8 new_msr)
 		}
 
 		mos7840_port->delta_msr_cond = 1;
-		wake_up_interruptible(&mos7840_port->delta_msr_wait);
+		wake_up_interruptible(&port->port->delta_msr_wait);
 	}
 }
 
@@ -1166,7 +1165,6 @@ static int mos7840_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	/* initialize our wait queues */
 	init_waitqueue_head(&mos7840_port->wait_chase);
-	init_waitqueue_head(&mos7840_port->delta_msr_wait);
 
 	/* initialize our icount structure */
 	memset(&(mos7840_port->icount), 0x00, sizeof(mos7840_port->icount));
@@ -2307,13 +2305,18 @@ static int mos7840_ioctl(struct tty_struct *tty,
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
-- 
1.8.1.2

