Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab3FVKIF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 06:08:05 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35645 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab3FVKID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 06:08:03 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hverkuil@xs4all.nl>, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] media: i2c: adv7343: add support for asynchronous probing
Date: Sat, 22 Jun 2013 15:37:37 +0530
Message-Id: <1371895657-2898-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Both synchronous and asynchronous adv7343 subdevice probing is supported by
this patch.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/i2c/adv7343.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index 7606218..8080c2c 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 
 #include <media/adv7343.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 
@@ -445,16 +446,21 @@ static int adv7343_probe(struct i2c_client *client,
 				       ADV7343_GAIN_DEF);
 	state->sd.ctrl_handler = &state->hdl;
 	if (state->hdl.error) {
-		int err = state->hdl.error;
-
-		v4l2_ctrl_handler_free(&state->hdl);
-		return err;
+		err = state->hdl.error;
+		goto done;
 	}
 	v4l2_ctrl_handler_setup(&state->hdl);
 
 	err = adv7343_initialize(&state->sd);
 	if (err)
+		goto done;
+
+	err = v4l2_async_register_subdev(&state->sd);
+
+done:
+	if (err < 0)
 		v4l2_ctrl_handler_free(&state->hdl);
+
 	return err;
 }
 
@@ -463,6 +469,7 @@ static int adv7343_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct adv7343_state *state = to_state(sd);
 
+	v4l2_async_unregister_subdev(&state->sd);
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&state->hdl);
 
-- 
1.7.9.5

