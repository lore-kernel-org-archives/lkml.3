Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbbAYSWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:22:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbbAYSKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard <richjunk@pacbell.net>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.18 146/183] USB: keyspan: fix null-deref at probe
Date: Sun, 25 Jan 2015 10:07:48 -0800
Message-Id: <20150125180816.512020732@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -410,6 +410,8 @@ static void	usa26_instat_callback(struct
 	}
 	port = serial->port[msg->port];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -420,7 +422,7 @@ static void	usa26_instat_callback(struct
 
 	if (old_dcd_state != p_priv->dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -527,6 +529,8 @@ static void	usa28_instat_callback(struct
 	}
 	port = serial->port[msg->port];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -537,7 +541,7 @@ static void	usa28_instat_callback(struct
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 		/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -607,6 +611,8 @@ static void	usa49_instat_callback(struct
 	}
 	port = serial->port[msg->portNumber];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -617,7 +623,7 @@ static void	usa49_instat_callback(struct
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -855,6 +861,8 @@ static void	usa90_instat_callback(struct
 
 	port = serial->port[0];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -865,7 +873,7 @@ static void	usa90_instat_callback(struct
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -926,6 +934,8 @@ static void	usa67_instat_callback(struct
 
 	port = serial->port[msg->port];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -934,7 +944,7 @@ static void	usa67_instat_callback(struct
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)


