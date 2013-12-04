Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3LDARH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:17:07 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:37624 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3LDARB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:17:01 -0500
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] usb: core: Abort deauthorization if unsetting configuration fails
Date: Tue,  3 Dec 2013 16:16:41 -0800
Message-Id: <1386116201-22131-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_deauthorize_device() tries to unset the configuration of a USB
device and then unconditionally blows away the configuration descriptors
with usb_destroy_configuration(). This is bad if the
usb_set_configuration() call failed before the configuration could be
correctly unset, since pointers like udev->actconfig can keep pointing
to the now invalid memory. We have encountered hard to reproduce crashes
from devices disconnected during suspend due to this, where khubd's
disconnect handling races with userspace tools that change authorization
on resume.

This patch ensures that usb_deauthorize_device() aborts when
usb_set_configuration() fails, and the underlying status code (such as
ENODEV) is returned to userspace.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/core/hub.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index a7c04e2..ade315f 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2420,13 +2420,17 @@ fail:
  */
 int usb_deauthorize_device(struct usb_device *usb_dev)
 {
+	int result = 0;
+
 	usb_lock_device(usb_dev);
 	if (usb_dev->authorized == 0)
 		goto out_unauthorized;
 
-	usb_dev->authorized = 0;
-	usb_set_configuration(usb_dev, -1);
+	result = usb_set_configuration(usb_dev, -1);
+	if (result)
+		goto error_deconfigure;
 
+	usb_dev->authorized = 0;
 	kfree(usb_dev->product);
 	usb_dev->product = kstrdup("n/a (unauthorized)", GFP_KERNEL);
 	kfree(usb_dev->manufacturer);
@@ -2437,9 +2441,10 @@ int usb_deauthorize_device(struct usb_device *usb_dev)
 	usb_destroy_configuration(usb_dev);
 	usb_dev->descriptor.bNumConfigurations = 0;
 
+error_deconfigure:
 out_unauthorized:
 	usb_unlock_device(usb_dev);
-	return 0;
+	return result;
 }
 
 
-- 
1.7.12.4

