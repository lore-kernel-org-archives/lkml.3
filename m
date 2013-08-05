Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab3HEUeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:34:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40339 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab3HEUeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:34:03 -0400
Date: Mon, 5 Aug 2013 23:33:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/4] staging: ozwpan: Increment port number for new
 device.
Message-ID: <20130805203340.GP5051@mwanda>
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
 <1375724415-10801-3-git-send-email-rupesh.gujare@atmel.com>
 <20130805175302.GJ5051@mwanda>
 <51FFF244.9000604@atmel.com>
 <20130805202338.GO5051@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805202338.GO5051@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is what oz_hcd_pd_arrived() looks like after my changes:

These lines:
-       if (ozhcd == NULL)
+       if (!ozhcd)
were personal preference and not official kernel style guidelines.
Either way is fine for pointers.

oz_ep_alloc() can return NULL.  There was no check for failure in
the original code.

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index f81a0c5..6b9fc02 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -620,58 +621,59 @@ static inline void oz_hcd_put(struct oz_hcd *ozhcd)
  * probably very rare indeed.
  * Context: softirq
  */
-void *oz_hcd_pd_arrived(void *hpd)
+struct oz_port *oz_hcd_pd_arrived(void *hpd)
 {
-	int i;
-	void *hport = NULL;
-	struct oz_hcd *ozhcd = NULL;
+	struct oz_port *hport = NULL;
+	struct oz_hcd *ozhcd;
 	struct oz_endpoint *ep;
+	int i;
+
 	ozhcd = oz_hcd_claim();
-	if (ozhcd == NULL)
+	if (!ozhcd)
 		return NULL;
-	/* Allocate an endpoint object in advance (before holding hcd lock) to
-	 * use for out endpoint 0.
-	 */
+
+	/* Allocate an endpoint object to use for out endpoint 0. */
 	ep = oz_ep_alloc(GFP_ATOMIC, 0);
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
+
 /*------------------------------------------------------------------------------
  * This is called by the protocol handler to notify that the PD has gone away.
  * We need to deallocate all resources and then request that the root hub is
