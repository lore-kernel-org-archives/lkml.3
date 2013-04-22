Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3DVO3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:29:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51354 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989Ab3DVO3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:14 -0400
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
Message-ID: <lsq.1366640759.901612923@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [06/75] USB: ftdi_sio: fix use-after-free in TIOCMIWAIT
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
@@ -1708,10 +1706,8 @@ static int ftdi_sio_port_probe(struct us
 	kref_init(&priv->kref);
 	mutex_init(&priv->cfg_lock);
 	memset(&priv->icount, 0x00, sizeof(priv->icount));
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	priv->flags = ASYNC_LOW_LATENCY;
-	priv->dev_gone = false;
 
 	if (quirk && quirk->port_probe)
 		quirk->port_probe(priv);
@@ -1869,8 +1865,7 @@ static int ftdi_sio_port_remove(struct u
 
 	dbg("%s", __func__);
 
-	priv->dev_gone = true;
-	wake_up_interruptible_all(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	remove_sysfs_attrs(port);
 
@@ -2025,7 +2020,7 @@ static int ftdi_process_packet(struct tt
 		if (diff_status & FTDI_RS0_RLSD)
 			priv->icount.dcd++;
 
-		wake_up_interruptible_all(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 		priv->prev_status = status;
 	}
 
@@ -2424,11 +2419,15 @@ static int ftdi_ioctl(struct tty_struct
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
@@ -2438,8 +2437,6 @@ static int ftdi_ioctl(struct tty_struct
 			}
 			cprev = cnow;
 		}
-		return -EIO;
-		break;
 	case TIOCSERGETLSR:
 		return get_lsr_info(port, (struct serial_struct __user *)arg);
 		break;

