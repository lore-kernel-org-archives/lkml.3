Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab3EOMCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:02:39 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58943 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125Ab3EOMCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:02:38 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 5/6] media: i2c: ths7303: add support for asynchronous probing
Date: Wed, 15 May 2013 17:27:21 +0530
Message-Id: <1368619042-28252-6-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Both synchronous and asynchronous ths7303 subdevice probing is supported by
this patch.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
---
 drivers/media/i2c/ths7303.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index b954195..4f772a2 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 
 #include <media/ths7303.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-device.h>
 
@@ -355,6 +356,7 @@ static int ths7303_probe(struct i2c_client *client,
 	struct ths7303_platform_data *pdata = client->dev.platform_data;
 	struct ths7303_state *state;
 	struct v4l2_subdev *sd;
+	int ret;
 
 	if (pdata == NULL) {
 		dev_err(&client->dev, "No platform data\n");
@@ -385,13 +387,20 @@ static int ths7303_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
+	state->sd.dev = &client->dev;
+	ret = v4l2_async_register_subdev(&state->sd);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
 static int ths7303_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ths7303_state *ths7303 = to_state(sd);
 
+	v4l2_async_unregister_subdev(&ths7303->sd);
 	v4l2_device_unregister_subdev(sd);
 
 	return 0;
-- 
1.7.4.1

