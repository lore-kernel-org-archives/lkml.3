Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968170Ab3HISbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:31:40 -0400
Received: from smtp191.dfw.emailsrvr.com ([67.192.241.191]:42537 "EHLO
	smtp191.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968019Ab3HISbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:31:38 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Aug 2013 14:31:38 EDT
From: Philippe De Swert <philippe.deswert@jollamobile.com>
To: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        linux-kernel@vger.kernel.org
Cc: Philippe De Swert <philippe.deswert@jollamobile.com>
Subject: [PATCH] usb: gadget/composite : Avoid crash with bad gadget drivers
Date: Fri,  9 Aug 2013 21:23:08 +0300
Message-Id: <1376072588-2881-1-git-send-email-philippe.deswert@jollamobile.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bad gadget drivers do not check the return status of usb_add_config.
Thus they get a not correctly initialized config and when this gadget gets
deactivated the whole kernel crashes. Since on initialization failure cdev
is set to NULL it can be used to detect this problem situation. It can be
argued that the faulty gadget driver should be fixed, but imho it is better
to avoid crashing the kernel and letting the gadget developer know he/she
is making a mistake. And have the developer of said gadget driver then fix
the problem of course.

Signed-off-by: Philippe De Swert <philippe.deswert@jollamobile.com>
---
 drivers/usb/gadget/composite.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 55f4df6..e019bb5 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -848,12 +848,18 @@ void usb_remove_config(struct usb_composite_dev *cdev,
 {
 	unsigned long flags;
 
+	if (config->cdev == NULL) {
+		pr_warn("Calling usb_remove_config without a matching usb_add_config!\n");
+		goto end;
+	}
+
 	spin_lock_irqsave(&cdev->lock, flags);
 
 	if (cdev->config == config)
 		reset_config(cdev);
 
 	spin_unlock_irqrestore(&cdev->lock, flags);
+end:
 
 	remove_config(cdev, config);
 }
-- 
1.8.1.2

