Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3FXPvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:51:53 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:49506 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3FXPvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:51:52 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hverkuil@xs4all.nl>, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2] media: i2c: tvp514x: add support for asynchronous probing
Date: Mon, 24 Jun 2013 21:21:39 +0530
Message-Id: <1372089099-26438-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Both synchronous and asynchronous tvp514x subdevice probing
is supported by this patch.
This patch also fixes the error path by calling
media_entity_cleanup() on failure in probe when
CONFIG_MEDIA_CONTROLLER is enabled.

Signed-off-by: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Changes for v2:
 1: Fixed review comments pointed by Hans and Guennadi.
 
 drivers/media/i2c/tvp514x.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 6578976..b9e621b 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -36,6 +36,7 @@
 #include <linux/module.h>
 #include <linux/v4l2-mediabus.h>
 
+#include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-mediabus.h>
@@ -1175,16 +1176,22 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
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
@@ -1199,6 +1206,7 @@ static int tvp514x_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct tvp514x_decoder *decoder = to_decoder(sd);
 
+	v4l2_async_unregister_subdev(&decoder->sd);
 	v4l2_device_unregister_subdev(sd);
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&decoder->sd.entity);
-- 
1.7.9.5

