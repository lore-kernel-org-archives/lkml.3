Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbbA2JHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:07:23 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44889 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760350AbbA2JHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:07:20 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 111/176] USB: keyspan: fix null-deref at probe
Date: Wed, 28 Jan 2015 15:29:01 +0100
Message-Id: <55b48ffa43d65d598f16f05170be70154f14bea6.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b5122236bba8d7ef62153da5b55cc65d0944c61e upstream.

Fix null-pointer dereference during probe if the interface-status
completion handler is called before the individual ports have been set
up.

Fixes: f79b2d0fe81e ("USB: keyspan: fix NULL-pointer dereferences and
memory leaks")
Reported-by: Richard <richjunk@pacbell.net>
Tested-by: Richard <richjunk@pacbell.net>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/keyspan.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index dc3a77c8cd83..e58e21b46ef0 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -422,6 +422,8 @@ static void	usa26_instat_callback(struct urb *urb)
 	}
 	port = serial->port[msg->port];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -432,7 +434,7 @@ static void	usa26_instat_callback(struct urb *urb)
 
 	if (old_dcd_state != p_priv->dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -542,6 +544,8 @@ static void	usa28_instat_callback(struct urb *urb)
 	}
 	port = serial->port[msg->port];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -552,7 +556,7 @@ static void	usa28_instat_callback(struct urb *urb)
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 		/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -625,6 +629,8 @@ static void	usa49_instat_callback(struct urb *urb)
 	}
 	port = serial->port[msg->portNumber];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -635,7 +641,7 @@ static void	usa49_instat_callback(struct urb *urb)
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -873,6 +879,8 @@ static void	usa90_instat_callback(struct urb *urb)
 
 	port = serial->port[0];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -883,7 +891,7 @@ static void	usa90_instat_callback(struct urb *urb)
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
@@ -944,6 +952,8 @@ static void	usa67_instat_callback(struct urb *urb)
 
 	port = serial->port[msg->port];
 	p_priv = usb_get_serial_port_data(port);
+	if (!p_priv)
+		goto resubmit;
 
 	/* Update handshaking pin state information */
 	old_dcd_state = p_priv->dcd_state;
@@ -952,7 +962,7 @@ static void	usa67_instat_callback(struct urb *urb)
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
 		tty_port_tty_hangup(&port->port, true);
-
+resubmit:
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err != 0)
-- 
2.2.2

