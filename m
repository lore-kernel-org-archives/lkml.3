Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3CAUSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:18:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab3CATpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 45/77] media: v4l: Reset subdev v4l2_dev field to NULL if registration fails
Date: Fri,  1 Mar 2013 11:44:30 -0800
Message-Id: <20130301194356.738888001@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/v4l2-device.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -159,31 +159,21 @@ int v4l2_device_register_subdev(struct v
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
 	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler, NULL);
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
 
@@ -192,6 +182,14 @@ int v4l2_device_register_subdev(struct v
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
 


