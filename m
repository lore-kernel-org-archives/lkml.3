Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab3CYBPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:15:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33879 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755671Ab3CYBP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:26 -0400
Message-Id: <20130325010533.008501507@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:52 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 088/104] USB: ftdi_sio: fix use-after-free in TIOCMIWAIT
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

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
@@ -1707,10 +1705,8 @@ static int ftdi_sio_port_probe(struct us
 	kref_init(&priv->kref);
 	mutex_init(&priv->cfg_lock);
 	memset(&priv->icount, 0x00, sizeof(priv->icount));
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	priv->flags = ASYNC_LOW_LATENCY;
-	priv->dev_gone = false;
 
 	if (quirk && quirk->port_probe)
 		quirk->port_probe(priv);
@@ -1868,8 +1864,7 @@ static int ftdi_sio_port_remove(struct u
 
 	dbg("%s", __func__);
 
-	priv->dev_gone = true;
-	wake_up_interruptible_all(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	remove_sysfs_attrs(port);
 
@@ -2024,7 +2019,7 @@ static int ftdi_process_packet(struct tt
 		if (diff_status & FTDI_RS0_RLSD)
 			priv->icount.dcd++;
 
-		wake_up_interruptible_all(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 		priv->prev_status = status;
 	}
 
@@ -2423,11 +2418,15 @@ static int ftdi_ioctl(struct tty_struct
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
@@ -2437,8 +2436,6 @@ static int ftdi_ioctl(struct tty_struct
 			}
 			cprev = cnow;
 		}
-		return -EIO;
-		break;
 	case TIOCSERGETLSR:
 		return get_lsr_info(port, (struct serial_struct __user *)arg);
 		break;


