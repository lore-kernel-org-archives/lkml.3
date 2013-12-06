Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162190Ab3LFNTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:19:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44607 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161941Ab3LFNE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Mack <zonque@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 221/272] usb: musb: call musb_start() only once in OTG mode
Date: Fri,  6 Dec 2013 12:58:30 +0000
Message-Id: <1386334761-25517-222-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/musb/musb_virthub.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_virthub.c b/drivers/usb/musb/musb_virthub.c
index d1d6b83..9af6bba 100644
--- a/drivers/usb/musb/musb_virthub.c
+++ b/drivers/usb/musb/musb_virthub.c
@@ -220,6 +220,23 @@ int musb_hub_status_data(struct usb_hcd *hcd, char *buf)
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
-- 
1.8.3.2

