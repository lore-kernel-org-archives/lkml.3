Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3HERk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:40:29 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:59023 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab3HERk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:40:26 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 2/4] staging: ozwpan: Increment port number for new device.
Date: Mon, 5 Aug 2013 18:40:13 +0100
Message-ID: <1375724415-10801-3-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes crash issue when there is quick cycle of
de-enumeration & enumeration due to loss of wireless link.

It is found that sometimes new device (or coming back device)
returns very fast, even before USB core read out hub status,
resulting in allocation of same port, which results in unstable
system & crash.

Above issue is resolved by making sure that we always assign
new port to new device, making sure that USB core reads correct
hub status.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index d313a63..a739986 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -127,6 +127,7 @@ struct oz_hcd {
 	struct list_head urb_cancel_list;
 	struct list_head orphanage;
 	int conn_port; /* Port that is currently connecting, -1 if none.*/
+	int last_port;
 	struct oz_port ports[OZ_NB_PORTS];
 	uint flags;
 	struct usb_hcd *hcd;
@@ -645,7 +646,9 @@ void *oz_hcd_pd_arrived(void *hpd)
 		goto out;
 	}
 	for (i = 0; i < OZ_NB_PORTS; i++) {
-		struct oz_port *port = &ozhcd->ports[i];
+		struct oz_port *port = &ozhcd->ports[ozhcd->last_port++];
+		if (ozhcd->last_port >= OZ_NB_PORTS)
+			ozhcd->last_port = 0;
 		spin_lock(&port->port_lock);
 		if ((port->flags & OZ_PORT_F_PRESENT) == 0) {
 			oz_acquire_port(port, hpd);
@@ -655,13 +658,16 @@ void *oz_hcd_pd_arrived(void *hpd)
 		spin_unlock(&port->port_lock);
 	}
 	if (i < OZ_NB_PORTS) {
-		oz_dbg(ON, "Setting conn_port = %d\n", i);
-		ozhcd->conn_port = i;
+		if (!ozhcd->last_port)
+			ozhcd->conn_port = OZ_NB_PORTS - 1;
+		else
+			ozhcd->conn_port = ozhcd->last_port - 1;
+		oz_dbg(ON, "Setting conn_port = %d\n", ozhcd->conn_port);
 		/* Attach out endpoint 0.
 		 */
-		ozhcd->ports[i].out_ep[0] = ep;
+		ozhcd->ports[ozhcd->conn_port].out_ep[0] = ep;
 		ep = NULL;
-		hport = &ozhcd->ports[i];
+		hport = &ozhcd->ports[ozhcd->conn_port];
 		spin_unlock_bh(&ozhcd->hcd_lock);
 		if (ozhcd->flags & OZ_HDC_F_SUSPENDED) {
 			oz_dbg(ON, "Resuming root hub\n");
-- 
1.7.9.5

