Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab3HMRa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:30:59 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:25330 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab3HMRa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:30:58 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 10/10] staging: ozwpan: Separate success & failure case for oz_hcd_pd_arrived()
Date: Tue, 13 Aug 2013 18:29:26 +0100
Message-ID: <1376414966-23525-6-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376414966-23525-1-git-send-email-rupesh.gujare@atmel.com>
References: <1376414966-23525-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

This patch separates success & failure block along with fixing
following issues:-

1. The way oz_hcd_pd_arrived() looks now it's easy to think we free "ep" but
actually we do this spaghetti thing of setting it to NULL on success.

2. It is hard to read it because there are unlocks scattered throughout.

3. Currently we set "ep" to NULL on the success path and then test it and or
free it. In current code you have to scroll to the start of the function
to read code.

Original patch was submitted by Dan here :-
http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2013-August/040113.html

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |   54 ++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 0b21c9f..4cd08da 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -668,50 +668,50 @@ struct oz_port *oz_hcd_pd_arrived(void *hpd)
 	struct oz_endpoint *ep;
 
 	ozhcd = oz_hcd_claim();
-	if (ozhcd == NULL)
+	if (!ozhcd)
 		return NULL;
 	/* Allocate an endpoint object in advance (before holding hcd lock) to
 	 * use for out endpoint 0.
 	 */
 	ep = oz_ep_alloc(0, GFP_ATOMIC);
+	if (!ep)
+		goto err_put;
+
 	spin_lock_bh(&ozhcd->hcd_lock);
-	if (ozhcd->conn_port >= 0) {
-		spin_unlock_bh(&ozhcd->hcd_lock);
-		oz_dbg(ON, "conn_port >= 0\n");
-		goto out;
-	}
+	if (ozhcd->conn_port >= 0)
+		goto err_unlock;
+
 	for (i = 0; i < OZ_NB_PORTS; i++) {
 		struct oz_port *port = &ozhcd->ports[i];
+
 		spin_lock(&port->port_lock);
-		if ((port->flags & OZ_PORT_F_PRESENT) == 0) {
+		if (!(port->flags & OZ_PORT_F_PRESENT)) {
 			oz_acquire_port(port, hpd);
 			spin_unlock(&port->port_lock);
 			break;
 		}
 		spin_unlock(&port->port_lock);
 	}
-	if (i < OZ_NB_PORTS) {
-		oz_dbg(ON, "Setting conn_port = %d\n", i);
-		ozhcd->conn_port = i;
-		/* Attach out endpoint 0.
-		 */
-		ozhcd->ports[i].out_ep[0] = ep;
-		ep = NULL;
-		hport = &ozhcd->ports[i];
-		spin_unlock_bh(&ozhcd->hcd_lock);
-		if (ozhcd->flags & OZ_HDC_F_SUSPENDED) {
-			oz_dbg(ON, "Resuming root hub\n");
-			usb_hcd_resume_root_hub(ozhcd->hcd);
-		}
-		usb_hcd_poll_rh_status(ozhcd->hcd);
-	} else {
-		spin_unlock_bh(&ozhcd->hcd_lock);
-	}
-out:
-	if (ep) /* ep is non-null if not used. */
-		oz_ep_free(NULL, ep);
+	if (i == OZ_NB_PORTS)
+		goto err_unlock;
+
+	ozhcd->conn_port = i;
+	hport = &ozhcd->ports[i];
+	hport->out_ep[0] = ep;
+	spin_unlock_bh(&ozhcd->hcd_lock);
+	if (ozhcd->flags & OZ_HDC_F_SUSPENDED)
+		usb_hcd_resume_root_hub(ozhcd->hcd);
+	usb_hcd_poll_rh_status(ozhcd->hcd);
 	oz_hcd_put(ozhcd);
+
 	return hport;
+
+err_unlock:
+	spin_unlock_bh(&ozhcd->hcd_lock);
+	oz_ep_free(NULL, ep);
+err_put:
+	oz_hcd_put(ozhcd);
+	return NULL;
 }
 
 /*------------------------------------------------------------------------------
-- 
1.7.9.5

