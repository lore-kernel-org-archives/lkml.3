Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3ENGsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 02:48:07 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:32812 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab3ENGsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 02:48:03 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH RFC v3 2/4] media: i2c: tvp514x: add support for asynchronous probing
Date: Tue, 14 May 2013 12:17:34 +0530
Message-Id: <1368514056-28859-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368514056-28859-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368514056-28859-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Both synchronous and asynchronous tvp514x subdevice probing is supported by
this patch.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/i2c/tvp514x.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index ab8f3fe..887bd93 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -36,6 +36,7 @@
 #include <linux/module.h>
 #include <linux/v4l2-mediabus.h>
 
+#include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-mediabus.h>
@@ -1109,9 +1110,9 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	/* Register with V4L2 layer as slave device */
 	sd = &decoder->sd;
 	v4l2_i2c_subdev_init(sd, client, &tvp514x_ops);
-	strlcpy(sd->name, TVP514X_MODULE_NAME, sizeof(sd->name));
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
+	strlcpy(sd->name, TVP514X_MODULE_NAME, sizeof(sd->name));
 	decoder->pad.flags = MEDIA_PAD_FL_SOURCE;
 	decoder->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	decoder->sd.entity.flags |= MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
@@ -1138,16 +1139,23 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	sd->ctrl_handler = &decoder->hdl;
 	if (decoder->hdl.error) {
 		ret = decoder->hdl.error;
-
-		v4l2_ctrl_handler_free(&decoder->hdl);
-		return ret;
+		goto done;
 	}
 	v4l2_ctrl_handler_setup(&decoder->hdl);
 
-	v4l2_info(sd, "%s decoder driver registered !!\n", sd->name);
-
-	return 0;
+	decoder->sd.dev = &client->dev;
+	ret = v4l2_async_register_subdev(&decoder->sd);
+	if (!ret)
+		v4l2_info(sd, "%s decoder driver registered !!\n", sd->name);
 
+done:
+	if (ret < 0) {
+		v4l2_ctrl_handler_free(&decoder->hdl);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		media_entity_cleanup(&decoder->sd.entity);
+#endif
+	}
+	return ret;
 }
 
 /**
@@ -1162,6 +1170,7 @@ static int tvp514x_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct tvp514x_decoder *decoder = to_decoder(sd);
 
+	v4l2_async_unregister_subdev(&decoder->sd);
 	v4l2_device_unregister_subdev(sd);
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&decoder->sd.entity);
-- 
1.7.4.1

