Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773Ab3B1P1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:27:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab3B1Opy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:45:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 004/139] v4l: Reset subdev v4l2_dev field to NULL if registration fails
Date: Thu, 28 Feb 2013 14:42:34 +0000
Message-Id: <1362062689-2567-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 317efce991620adc589b3005b9baed433dcb2a56 upstream.

When subdev registration fails the subdev v4l2_dev field is left to a
non-NULL value. Later calls to v4l2_device_unregister_subdev() will
consider the subdev as registered and will module_put() the subdev
module without any matching module_get().
Fix this by setting the subdev v4l2_dev field to NULL in
v4l2_device_register_subdev() when the function fails.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/video/v4l2-device.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 1f203b8..683ae99 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -159,31 +159,21 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	sd->v4l2_dev = v4l2_dev;
 	if (sd->internal_ops && sd->internal_ops->registered) {
 		err = sd->internal_ops->registered(sd);
-		if (err) {
-			module_put(sd->owner);
-			return err;
-		}
+		if (err)
+			goto error_module;
 	}
 
 	/* This just returns 0 if either of the two args is NULL */
 	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler);
-	if (err) {
-		if (sd->internal_ops && sd->internal_ops->unregistered)
-			sd->internal_ops->unregistered(sd);
-		module_put(sd->owner);
-		return err;
-	}
+	if (err)
+		goto error_unregister;
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	/* Register the entity. */
 	if (v4l2_dev->mdev) {
 		err = media_device_register_entity(v4l2_dev->mdev, entity);
-		if (err < 0) {
-			if (sd->internal_ops && sd->internal_ops->unregistered)
-				sd->internal_ops->unregistered(sd);
-			module_put(sd->owner);
-			return err;
-		}
+		if (err < 0)
+			goto error_unregister;
 	}
 #endif
 
@@ -192,6 +182,14 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	spin_unlock(&v4l2_dev->lock);
 
 	return 0;
+
+error_unregister:
+	if (sd->internal_ops && sd->internal_ops->unregistered)
+		sd->internal_ops->unregistered(sd);
+error_module:
+	module_put(sd->owner);
+	sd->v4l2_dev = NULL;
+	return err;
 }
 EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
 
-- 
1.8.1.2

