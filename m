Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab3DBWMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:12:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab3DBWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 065/124] USB: ftdi_sio: fix use-after-free in TIOCMIWAIT
Date: Tue,  2 Apr 2013 15:10:47 -0700
Message-Id: <20130402221111.731677558@linuxfoundation.org>
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

---
 drivers/usb/serial/ftdi_sio.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -69,9 +69,7 @@ struct ftdi_private {
 	int flags;		/* some ASYNC_xxxx flags are supported */
 	unsigned long last_dtr_rts;	/* saved modem control outputs */
 	struct async_icount	icount;
-	wait_queue_head_t delta_msr_wait; /* Used for TIOCMIWAIT */
 	char prev_status;        /* Used for TIOCMIWAIT */
-	bool dev_gone;        /* Used to abort TIOCMIWAIT */
 	char transmit_empty;	/* If transmitter is empty or not */
 	__u16 interface;	/* FT2232C, FT2232H or FT4232H port interface
 				   (0 for FT232/245) */
@@ -1692,10 +1690,8 @@ static int ftdi_sio_port_probe(struct us
 
 	kref_init(&priv->kref);
 	mutex_init(&priv->cfg_lock);
-	init_waitqueue_head(&priv->delta_msr_wait);
 
 	priv->flags = ASYNC_LOW_LATENCY;
-	priv->dev_gone = false;
 
 	if (quirk && quirk->port_probe)
 		quirk->port_probe(priv);
@@ -1841,8 +1837,7 @@ static int ftdi_sio_port_remove(struct u
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 
-	priv->dev_gone = true;
-	wake_up_interruptible_all(&priv->delta_msr_wait);
+	wake_up_interruptible(&port->delta_msr_wait);
 
 	remove_sysfs_attrs(port);
 
@@ -1991,7 +1986,7 @@ static int ftdi_process_packet(struct tt
 		if (diff_status & FTDI_RS0_RLSD)
 			priv->icount.dcd++;
 
-		wake_up_interruptible_all(&priv->delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 		priv->prev_status = status;
 	}
 
@@ -2448,11 +2443,15 @@ static int ftdi_ioctl(struct tty_struct
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
@@ -2462,8 +2461,6 @@ static int ftdi_ioctl(struct tty_struct
 			}
 			cprev = cnow;
 		}
-		return -EIO;
-		break;
 	case TIOCSERGETLSR:
 		return get_lsr_info(port, (struct serial_struct __user *)arg);
 		break;


