Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab3K0BA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:00:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758825Ab3K0A7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.12 107/116] usb: musb: call musb_start() only once in OTG mode
Date: Tue, 26 Nov 2013 16:58:00 -0800
Message-Id: <20131127005744.300495659@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit ae44df2e21b50f9fff28ac75c57e399c04df812c upstream.

In commit 001dd84 ("usb: musb: start musb on the udc side, too") it was
ensured that the state engine is started also in OTG mode after a
removal / insertion of the gadget.
Unfortunately this change also introduced a bug: If the device is
configured as OTG and it connected with a remote host _without_ loading
a gadget then we bug() later (because musb->otg->gadget is not
initialized).
Initially I assumed it might be nice to have the host part of musb in
OTG mode working without having a gadget loaded. This bug and fact that
it wasn't working like this before the host/gadget split made me realize
that this was a silly idea.
This patch now introduces back the old behavior where in OTG mode the
host mode is only working after the gadget has been loaded.

Cc: Daniel Mack <zonque@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_virthub.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/musb_virthub.c
+++ b/drivers/usb/musb/musb_virthub.c
@@ -220,6 +220,23 @@ int musb_hub_status_data(struct usb_hcd
 	return retval;
 }
 
+static int musb_has_gadget(struct musb *musb)
+{
+	/*
+	 * In host-only mode we start a connection right away. In OTG mode
+	 * we have to wait until we loaded a gadget. We don't really need a
+	 * gadget if we operate as a host but we should not start a session
+	 * as a device without a gadget or else we explode.
+	 */
+#ifdef CONFIG_USB_MUSB_HOST
+	return 1;
+#else
+	if (musb->port_mode == MUSB_PORT_MODE_HOST)
+		return 1;
+	return musb->g.dev.driver != NULL;
+#endif
+}
+
 int musb_hub_control(
 	struct usb_hcd	*hcd,
 	u16		typeReq,
@@ -362,7 +379,7 @@ int musb_hub_control(
 			 * initialization logic, e.g. for OTG, or change any
 			 * logic relating to VBUS power-up.
 			 */
-			if (!hcd->self.is_b_host)
+			if (!hcd->self.is_b_host && musb_has_gadget(musb))
 				musb_start(musb);
 			break;
 		case USB_PORT_FEAT_RESET:


