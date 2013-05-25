Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab3EYRkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 13:40:45 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58952 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab3EYRkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 13:40:40 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH v2 4/4] media: i2c: ths7303: make the pdata as a constant pointer
Date: Sat, 25 May 2013 23:09:36 +0530
Message-Id: <1369503576-22271-5-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

generally the pdata needs to be a constant pointer in the device
state structure. This patch makes the pdata as a constant pointer
and alongside returns -EINVAL when pdata is NULL.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
---
 drivers/media/i2c/ths7303.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index af06187..b954195 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -35,7 +35,7 @@
 
 struct ths7303_state {
 	struct v4l2_subdev		sd;
-	struct ths7303_platform_data	pdata;
+	const struct ths7303_platform_data *pdata;
 	struct v4l2_bt_timings		bt;
 	int std_id;
 	int stream_on;
@@ -89,7 +89,7 @@ int ths7303_setval(struct v4l2_subdev *sd, enum ths7303_filter_mode mode)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ths7303_state *state = to_state(sd);
-	struct ths7303_platform_data *pdata = &state->pdata;
+	const struct ths7303_platform_data *pdata = state->pdata;
 	u8 val, sel = 0;
 	int err, disable = 0;
 
@@ -356,6 +356,11 @@ static int ths7303_probe(struct i2c_client *client,
 	struct ths7303_state *state;
 	struct v4l2_subdev *sd;
 
+	if (pdata == NULL) {
+		dev_err(&client->dev, "No platform data\n");
+		return -EINVAL;
+	}
+
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
 
@@ -367,11 +372,7 @@ static int ths7303_probe(struct i2c_client *client,
 	if (!state)
 		return -ENOMEM;
 
-	if (!pdata)
-		v4l_warn(client, "No platform data, using default data!\n");
-	else
-		state->pdata = *pdata;
-
+	state->pdata = pdata;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &ths7303_ops);
 
-- 
1.7.0.4

