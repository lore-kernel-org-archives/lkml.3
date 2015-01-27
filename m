Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbbA0Mcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:32:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35279 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbbA0MTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 083/126] USB: keyspan: fix null-deref at probe
Date: Tue, 27 Jan 2015 12:16:28 +0000
Message-Id: <1422361031-19364-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.4

