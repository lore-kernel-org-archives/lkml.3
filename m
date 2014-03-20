Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaCTJHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:07:21 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:34512 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750743AbaCTJHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:07:18 -0400
From: Josh Wu <josh.wu@atmel.com>
CC: <g.liakhovetski@gmx.de>, <m.chehab@samsung.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sylvester.nawrocki@gmail.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v2] [media] ov2640: add support for async device registration
Date: Thu, 20 Mar 2014 17:01:49 +0800
Message-ID: <1395306109-11016-1-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the the v4l2_clk_get() may return a EPROBE_DEFER during async
probing. So move the v4l2_clk_get() to the beginning of the
probe(). Only when we get mclk successfully we continue the probe.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
v1 -> v2:
  just return PTR_ERR(clk) as it can be -EPROBE_DEFER.
  refined the commit message

 drivers/media/i2c/soc_camera/ov2640.c |   43 +++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 6c6b1c3..7c77a15 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -22,6 +22,7 @@
 #include <linux/videodev2.h>
 
 #include <media/soc_camera.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
@@ -1069,6 +1070,7 @@ static int ov2640_probe(struct i2c_client *client,
 	struct ov2640_priv	*priv;
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
+	struct v4l2_clk		*clk;
 	int			ret;
 
 	if (!ssdd) {
@@ -1083,13 +1085,20 @@ static int ov2640_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
+	clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
 	priv = devm_kzalloc(&client->dev, sizeof(struct ov2640_priv), GFP_KERNEL);
 	if (!priv) {
 		dev_err(&adapter->dev,
 			"Failed to allocate memory for private data!\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_kzalloc;
 	}
 
+	priv->clk = clk;
+
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 2);
 	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
@@ -1097,23 +1106,26 @@ static int ov2640_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
 			V4L2_CID_HFLIP, 0, 1, 1, 0);
 	priv->subdev.ctrl_handler = &priv->hdl;
-	if (priv->hdl.error)
-		return priv->hdl.error;
-
-	priv->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(priv->clk)) {
-		ret = PTR_ERR(priv->clk);
-		goto eclkget;
+	if (priv->hdl.error) {
+		ret = priv->hdl.error;
+		goto err_kzalloc;
 	}
 
 	ret = ov2640_video_probe(client);
-	if (ret) {
-		v4l2_clk_put(priv->clk);
-eclkget:
-		v4l2_ctrl_handler_free(&priv->hdl);
-	} else {
-		dev_info(&adapter->dev, "OV2640 Probed\n");
-	}
+	if (ret)
+		goto err_probe;
+
+	ret = v4l2_async_register_subdev(&priv->subdev);
+	if (ret)
+		goto err_probe;
+
+	dev_info(&adapter->dev, "OV2640 Probed\n");
+	return 0;
+
+err_probe:
+	v4l2_ctrl_handler_free(&priv->hdl);
+err_kzalloc:
+	v4l2_clk_put(clk);
 
 	return ret;
 }
@@ -1122,6 +1134,7 @@ static int ov2640_remove(struct i2c_client *client)
 {
 	struct ov2640_priv       *priv = to_ov2640(client);
 
+	v4l2_async_unregister_subdev(&priv->subdev);
 	v4l2_clk_put(priv->clk);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
-- 
1.7.9.5

