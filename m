Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab3HVQjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:39:14 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:23559 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab3HVQjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:39:13 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 1/4] ozwpan: staging: Fix crash for race condition.
Date: Thu, 22 Aug 2013 17:38:48 +0100
Message-ID: <1377189531-24950-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not allocate a port to new device or process URB when its status is
yet to be read. This avoids race condition when USB core read hub
status a bit late, while new device tries to acquire port.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 2b67107..4682d78 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -685,7 +685,7 @@ struct oz_port *oz_hcd_pd_arrived(void *hpd)
 		struct oz_port *port = &ozhcd->ports[i];
 
 		spin_lock(&port->port_lock);
-		if (!(port->flags & OZ_PORT_F_PRESENT)) {
+		if (!(port->flags & (OZ_PORT_F_PRESENT | OZ_PORT_F_CHANGED))) {
 			oz_acquire_port(port, hpd);
 			spin_unlock(&port->port_lock);
 			break;
@@ -1818,7 +1818,8 @@ static int oz_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	port =  &ozhcd->ports[port_ix];
 	if (port == NULL)
 		return -EPIPE;
-	if ((port->flags & OZ_PORT_F_PRESENT) == 0) {
+	if (!(port->flags & OZ_PORT_F_PRESENT) ||
+				(port->flags & OZ_PORT_F_CHANGED)) {
 		oz_dbg(ON, "Refusing URB port_ix = %d devnum = %d\n",
 		       port_ix, urb->dev->devnum);
 		return -EPIPE;
-- 
1.7.9.5

