Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3ENGsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 02:48:03 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:45702 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3ENGr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 02:47:57 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH RFC v3 1/4] media: i2c: adv7343: add support for asynchronous probing
Date: Tue, 14 May 2013 12:17:33 +0530
Message-Id: <1368514056-28859-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368514056-28859-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368514056-28859-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Both synchronous and asynchronous adv7343 subdevice probing is supported by
this patch.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/i2c/adv7343.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index 9fc2b98..469e262 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 
 #include <media/adv7343.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
@@ -455,16 +456,22 @@ static int adv7343_probe(struct i2c_client *client,
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
+	state->sd.dev = &client->dev;
+	err = v4l2_async_register_subdev(&state->sd);
+
+done:
+	if (err < 0)
 		v4l2_ctrl_handler_free(&state->hdl);
+
 	return err;
 }
 
@@ -473,6 +480,7 @@ static int adv7343_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct adv7343_state *state = to_state(sd);
 
+	v4l2_async_unregister_subdev(&state->sd);
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&state->hdl);
 
-- 
1.7.4.1

