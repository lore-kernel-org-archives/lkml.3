Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaIXUoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:44:19 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:34629 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaIXUoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:44:16 -0400
From: Michal Sojka <sojka@merica.cz>
To: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Bryan Wu <cooloney@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz,
        Michal Sojka <sojka@merica.cz>
Subject: [PATCH v6 1/4] usb: gadget: Introduce usb_gadget_giveback_request()
Date: Wed, 24 Sep 2014 22:43:18 +0200
Message-Id: <1411591401-5874-2-git-send-email-sojka@merica.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411591401-5874-1-git-send-email-sojka@merica.cz>
References: <Pine.LNX.4.44L0.1409241106100.1580-100000@iolanthe.rowland.org>
 <1411591401-5874-1-git-send-email-sojka@merica.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All USB peripheral controller drivers call completion routines directly.
This patch adds usb_gadget_giveback_request() which will be used instead
of direct invocation in the next patch. The goal here is to have a place
where common functionality can be added.

Signed-off-by: Michal Sojka <sojka@merica.cz>
---
 drivers/usb/gadget/udc/udc-core.c | 16 ++++++++++++++++
 include/linux/usb/gadget.h        |  8 ++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/udc-core.c
index b0d9817..f7b3151 100644
--- a/drivers/usb/gadget/udc/udc-core.c
+++ b/drivers/usb/gadget/udc/udc-core.c
@@ -106,6 +106,22 @@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
 
 /* ------------------------------------------------------------------------- */
 
+/**
+ * usb_gadget_giveback_request - give the request back to the gadget layer
+ * Context: in_interrupt()
+ *
+ * This is called by device controller drivers in order to return the
+ * completed request back to the gadget layer.
+ */
+void usb_gadget_giveback_request(struct usb_ep *ep,
+		struct usb_request *req)
+{
+	req->complete(ep, req);
+}
+EXPORT_SYMBOL_GPL(usb_gadget_giveback_request);
+
+/* ------------------------------------------------------------------------- */
+
 static void usb_gadget_state_work(struct work_struct *work)
 {
 	struct usb_gadget	*gadget = work_to_gadget(work);
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index c3a6185..f795e95 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -1013,6 +1013,14 @@ extern void usb_gadget_set_state(struct usb_gadget *gadget,
 
 /*-------------------------------------------------------------------------*/
 
+/* utility to give requests back to the gadget layer */
+
+extern void usb_gadget_giveback_request(struct usb_ep *ep,
+		struct usb_request *req);
+
+
+/*-------------------------------------------------------------------------*/
+
 /* utility wrapping a simple endpoint selection policy */
 
 extern struct usb_ep *usb_ep_autoconfig(struct usb_gadget *,
-- 
2.1.0

