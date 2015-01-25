Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbbAYSKC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:10:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbbAYSIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:08:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard <richjunk@pacbell.net>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.10 31/50] USB: keyspan: fix null-deref at probe
Date: Sun, 25 Jan 2015 10:07:21 -0800
Message-Id: <20150125180704.420389429@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180702.521559311@linuxfoundation.org>
References: <20150125180702.521559311@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit b5122236bba8d7ef62153da5b55cc65d0944c61e upstream.

Fix null-pointer dereference during probe if the interface-status
completion handler is called before the individual ports have been set
up.

Fixes: f79b2d0fe81e ("USB: keyspan: fix NULL-pointer dereferences and
memory leaks")
Reported-by: Richard <richjunk@pacbell.net>
Tested-by: Richard <richjunk@pacbell.net>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/keyspan.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -418,6 +418,8 @@ static void	usa26_instat_callback(struct
 	}
 	port = serial->port[msg->port];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -428,7 +430,7 @@ static void	usa26_instat_callback(struct
 
 	if (old_dcd_state != p_priv->dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -543,6 +545,8 @@ static void	usa28_instat_callback(struct
 	}
 	port = serial->port[msg->port];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -553,7 +557,7 @@ static void	usa28_instat_callback(struct
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 		/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -630,6 +634,8 @@ static void	usa49_instat_callback(struct
 	}
 	port = serial->port[msg->portNumber];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -640,7 +646,7 @@ static void	usa49_instat_callback(struct
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -878,6 +884,8 @@ static void	usa90_instat_callback(struct
 
 	port = serial->port[0];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -888,7 +896,7 @@ static void	usa90_instat_callback(struct
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -949,6 +957,8 @@ static void	usa67_instat_callback(struct
 
 	port = serial->port[msg->port];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -957,7 +967,7 @@ static void	usa67_instat_callback(struct
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)


