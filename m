Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab3APP6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:58:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35650 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304Ab3APP6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:58:04 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 010/222] usb: gadget: uvc: fix error path in uvc_function_bind()
Date: Wed, 16 Jan 2013 13:53:30 -0200
Message-Id: <1358351822-7675-11-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 0f9df939385527049c8062a099fbfa1479fe7ce0 upstream.

The "video->minor = -1" assigment is done in V4L2 by
video_register_device() so it is removed here.
Now. uvc_function_bind() calls in error case uvc_function_unbind() for
cleanup. The problem is that uvc_function_unbind() frees the uvc struct
and uvc_bind_config() does as well in error case of usb_add_function().
Removing kfree() in usb_add_function() would make the patch smaller but
it would look odd because the new allocated memory is not cleaned up.
However it is not guaranteed that if we call usb_add_function() we also
get to the bind function.
Therefore the patch extracts the conditional cleanup from
uvc_function_unbind() applies to uvc_function_bind().
uvc_function_unbind() now contains only the complete cleanup which is
required once everything has been registrated.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Bhupesh Sharma <bhupesh.sharma@st.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/gadget/f_uvc.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
index 2022fe49..a0abc65 100644
--- a/drivers/usb/gadget/f_uvc.c
+++ b/drivers/usb/gadget/f_uvc.c
@@ -335,7 +335,6 @@ uvc_register_video(struct uvc_device *uvc)
 		return -ENOMEM;
 
 	video->parent = &cdev->gadget->dev;
-	video->minor = -1;
 	video->fops = &uvc_v4l2_fops;
 	video->release = video_device_release;
 	strncpy(video->name, cdev->gadget->name, sizeof(video->name));
@@ -462,23 +461,12 @@ uvc_function_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	INFO(cdev, "uvc_function_unbind\n");
 
-	if (uvc->vdev) {
-		if (uvc->vdev->minor == -1)
-			video_device_release(uvc->vdev);
-		else
-			video_unregister_device(uvc->vdev);
-		uvc->vdev = NULL;
-	}
-
-	if (uvc->control_ep)
-		uvc->control_ep->driver_data = NULL;
-	if (uvc->video.ep)
-		uvc->video.ep->driver_data = NULL;
+	video_unregister_device(uvc->vdev);
+	uvc->control_ep->driver_data = NULL;
+	uvc->video.ep->driver_data = NULL;
 
-	if (uvc->control_req) {
-		usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
-		kfree(uvc->control_buf);
-	}
+	usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
+	kfree(uvc->control_buf);
 
 	kfree(f->descriptors);
 	kfree(f->hs_descriptors);
@@ -563,7 +551,22 @@ uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
 	return 0;
 
 error:
-	uvc_function_unbind(c, f);
+	if (uvc->vdev)
+		video_device_release(uvc->vdev);
+
+	if (uvc->control_ep)
+		uvc->control_ep->driver_data = NULL;
+	if (uvc->video.ep)
+		uvc->video.ep->driver_data = NULL;
+
+	if (uvc->control_req) {
+		usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
+		kfree(uvc->control_buf);
+	}
+
+	kfree(f->descriptors);
+	kfree(f->hs_descriptors);
+	kfree(f->ss_descriptors);
 	return ret;
 }
 
-- 
1.7.9.5

