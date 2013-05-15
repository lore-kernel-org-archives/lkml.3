Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab3EOMBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:01:19 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58076 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab3EOMBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:01:17 -0400
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
Subject: [PATCH 3/6] media: i2c: ths7303: remove unnecessary function ths7303_setup()
Date: Wed, 15 May 2013 17:27:19 +0530
Message-Id: <1368619042-28252-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

the ths7303_setup() was doing the same thing as ths7303_setval()
except that ths7303_setval() sets it to some particular mode.
This patch removes ths7303_setup() function and calls ths7303_setval()
in the probe setting the device to 480I_576I filter mode in the probe.

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
 drivers/media/i2c/ths7303.c |   31 ++++---------------------------
 1 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index 8cddcd0..af06187c 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -349,30 +349,6 @@ static const struct v4l2_subdev_ops ths7303_ops = {
 	.video 	= &ths7303_video_ops,
 };
 
-static int ths7303_setup(struct v4l2_subdev *sd)
-{
-	struct ths7303_state *state = to_state(sd);
-	struct ths7303_platform_data *pdata = &state->pdata;
-	int ret;
-	u8 mask;
-
-	mask = 0xf8;
-
-	ret = ths7303_write(sd, THS7303_CHANNEL_1, pdata->ch_1 & mask);
-	if (ret)
-		return ret;
-
-	ret = ths7303_write(sd, THS7303_CHANNEL_2, pdata->ch_2 & mask);
-	if (ret)
-		return ret;
-
-	ret = ths7303_write(sd, THS7303_CHANNEL_3, pdata->ch_3 & mask);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
 static int ths7303_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -402,9 +378,10 @@ static int ths7303_probe(struct i2c_client *client,
 	/* store the driver data to differntiate the chip */
 	state->driver_data = (int)id->driver_data;
 
-	if (ths7303_setup(sd) < 0) {
-		v4l_err(client, "init failed\n");
-		return -EIO;
+	/* set to default 480I_576I filter mode */
+	if (ths7303_setval(sd, THS7303_FILTER_MODE_480I_576I) < 0) {
+		v4l_err(client, "Setting to 480I_576I filter mode failed!\n");
+		return -EINVAL;
 	}
 
 	return 0;
-- 
1.7.4.1

