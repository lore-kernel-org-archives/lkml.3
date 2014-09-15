Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaIOKoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:44:06 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:19902 "EHLO
	vsp-authed-04-02.binero.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753329AbaIOKoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:44:04 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, software@gaisler.com
Subject: [PATCH] usb: gadget: udc_core: Use right kobj when calling sysfs_notify
Date: Mon, 15 Sep 2014 12:42:27 +0200
Message-Id: <1410777748-28090-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The state attribute is connected to the kobj of the udc, not the gadget.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 drivers/usb/gadget/udc/udc-core.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/udc-core.c
index b0d9817..37c129a 100644
--- a/drivers/usb/gadget/udc/udc-core.c
+++ b/drivers/usb/gadget/udc/udc-core.c
@@ -109,8 +109,20 @@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
 static void usb_gadget_state_work(struct work_struct *work)
 {
 	struct usb_gadget	*gadget = work_to_gadget(work);
+	struct usb_udc		*udc = NULL;
+
+	mutex_lock(&udc_lock);
+	list_for_each_entry(udc, &udc_list, list)
+		if (udc->gadget == gadget)
+			goto found;
+	mutex_unlock(&udc_lock);
+
+	return;
+
+found:
+	mutex_unlock(&udc_lock);
 
-	sysfs_notify(&gadget->dev.kobj, NULL, "state");
+	sysfs_notify(&udc->dev.kobj, NULL, "state");
 }
 
 void usb_gadget_set_state(struct usb_gadget *gadget,
-- 
1.7.10.4

