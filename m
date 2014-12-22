Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbaLVRxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:53:05 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:47342 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbaLVRxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:53:03 -0500
Date: Mon, 22 Dec 2014 18:53:01 +0100
From: Johan Hovold <johan@kernel.org>
To: Richard <richjunk@pacbell.net>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Kernel 3.17.x Attaching Keyspan 4-Port Serial to USB Adapter
 Causes Kernel Panic
Message-ID: <20141222175301.GF30375@localhost>
References: <54960F74.1050608@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54960F74.1050608@pacbell.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+CC: linux-usb ]

On Sat, Dec 20, 2014 at 04:08:20PM -0800, Richard wrote:
> On a new Gentoo based system with Kernel.org Kernels 3.17.4 to 3.17.7
> when I physically plug the Keyspan 4-Port Serial to USB adapter into a
> usb port my system freezes with a "unable to handle kernel NULL pointer
> deference" message.
> 
> My old system (also Gentoo based with Kernel.org 3.17.4) does not have
> this issue.  Both systems are using the USB_SERIAL_KEYSPAN_USA49W
> driver module.

So the same kernel is used (3.17.4), but only the new system oopses?

> I tried booting into single user mode, using modprobe to load
> USB_SERIAL_KEYSPAN_USA49W.  lsmod shows the driver.  When I pluged the
> device in I receive the system freeze.  Below is what I copied off the
> console ...
> 
> BUG:  Unable to handle kernel NULL pointer deference at 000...8c
> IP: [<ffffffffa006fbdd>] usa49_instat_callback+0x4d/0xb0[keyspan]
> PGD 1037faa067 PUD 1038301067 PMD 0
> Oops: 0002 [#1] SMP
> Modules linked in: keyspan ezusb usbserial hid_generic ...

This driver is a bit of a mess. Could you try the patch below and see if
it fixes the problem?

Thanks,
Johan


>From 3e98e15094be174d08dc31daab5c7b7791228515 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 22 Dec 2014 18:39:39 +0100
Subject: [PATCH] USB: keyspan: fix null-deref at probe

Fix null-pointer dereference during probe if the interface-status
completion handler is called before the individual ports have been set
up.

Reported-by: Richard <richjunk@pacbell.net>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/keyspan.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 077c714f1285..e07b15ed5814 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -410,6 +410,8 @@ static void	usa26_instat_callback(struct urb *urb)
 	}
 	port = serial->port[msg->port];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -420,7 +422,7 @@ static void	usa26_instat_callback(struct urb *urb)
 
 	if (old_dcd_state != p_priv->dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -527,6 +529,8 @@ static void	usa28_instat_callback(struct urb *urb)
 	}
 	port = serial->port[msg->port];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -537,7 +541,7 @@ static void	usa28_instat_callback(struct urb *urb)
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 		/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -607,6 +611,8 @@ static void	usa49_instat_callback(struct urb *urb)
 	}
 	port = serial->port[msg->portNumber];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -617,7 +623,7 @@ static void	usa49_instat_callback(struct urb *urb)
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -855,6 +861,8 @@ static void	usa90_instat_callback(struct urb *urb)
 
 	port = serial->port[0];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -865,7 +873,7 @@ static void	usa90_instat_callback(struct urb *urb)
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -926,6 +934,8 @@ static void	usa67_instat_callback(struct urb *urb)
 
 	port = serial->port[msg->port];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -934,7 +944,7 @@ static void	usa67_instat_callback(struct urb *urb)
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
-- 
2.0.5

