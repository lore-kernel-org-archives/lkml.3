Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965459Ab3CZPjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:39:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54000 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965245Ab3CZPXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 103/150] USB: ftdi_sio: fix use-after-free in TIOCMIWAIT
Date: Tue, 26 Mar 2013 15:20:02 +0000
Message-Id: <1364311249-14454-104-git-send-email-luis.henriques@canonical.com>
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

commit 71ccb9b01981fabae27d3c98260ea4613207618e upstream.

Use the port wait queue and make sure to check the serial disconnected
flag before accessing private port data after waking up.

This is is needed as the private port data (including the wait queue
itself) can be gone when waking up after a disconnect.

When switching to tty ports, some lifetime assumptions were changed.
Specifically, close can now be called before the final tty reference is
dropped as part of hangup at device disconnect. Even with the ftdi
private-data refcounting this means that the port private data can be
freed while a process is sleeping on modem-status changes and thus
cannot be relied on to detect disconnects when woken up.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 1f939cb..b2f4001 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -74,9 +74,7 @@ struct ftdi_private {
 	int flags;		/* some ASYNC_xxxx flags are supported */
 	unsigned long last_dtr_rts;	/* saved modem control outputs */
 	struct async_icount	icount;
-	wait_queue_head_t delta_msr_wait; /* Used for TIOCMIWAIT */
 	char prev_status;        /* Used for TIOCMIWAIT */
-	bool dev_gone;        /* Used to abort TIOCMIWAIT */
 	char transmit_empty;	/* If transmitter is empty or not */
 	struct usb_serial_port *port;
 	__u16 interface;	/* FT2232C, FT2232H or FT4232H port interface
@@ -1694,10 +1692,8 @@ static int ftdi_sio_port_probe(struct usb_serial_port *port)
 	kref_init(&priv->kref);
 	mutex_init(&priv->cfg_lock);
 	memset(&priv->icount, 0x00, sizeof(priv->icount));
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	priv->flags = ASYNC_LOW_LATENCY;
-	priv->dev_gone = false;
 
 	if (quirk && quirk->port_probe)
 		quirk->port_probe(priv);
@@ -1844,8 +1840,7 @@ static int ftdi_sio_port_remove(struct usb_serial_port *port)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 
-	priv->dev_gone = true;
-	wake_up_interruptible_all(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	remove_sysfs_attrs(port);
 
@@ -1994,7 +1989,7 @@ static int ftdi_process_packet(struct tty_struct *tty,
 		if (diff_status & FTDI_RS0_RLSD)
 			priv->icount.dcd++;
 
-		wake_up_interruptible_all(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 		priv->prev_status = status;
 	}
 
@@ -2393,11 +2388,15 @@ static int ftdi_ioctl(struct tty_struct *tty,
 	 */
 	case TIOCMIWAIT:
 		cprev = priv->icount;
-		while (!priv->dev_gone) {
-			interruptible_sleep_on(&priv->delta_msr_wait);
+		for (;;) {
+			interruptible_sleep_on(&port->delta_msr_wait);
 			/* see if a signal did it */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+
+			if (port->serial->disconnected)
+				return -EIO;
+
 			cnow = priv->icount;
 			if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
 			    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
@@ -2407,8 +2406,6 @@ static int ftdi_ioctl(struct tty_struct *tty,
 			}
 			cprev = cnow;
 		}
-		return -EIO;
-		break;
 	case TIOCSERGETLSR:
 		return get_lsr_info(port, (struct serial_struct __user *)arg);
 		break;
-- 
1.8.1.2

