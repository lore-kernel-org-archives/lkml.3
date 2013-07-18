Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab3GRPyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:54:39 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:58780 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab3GRPyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:54:36 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4] media: i2c: tvp7002: add OF support
Date: Thu, 18 Jul 2013 21:24:26 +0530
Message-Id: <1374162866-14981-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

add OF support for the tvp7002 driver.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 This patch depends on https://patchwork.kernel.org/patch/2828800/
 
 Changes for v4:
 1: Improved descrition of end point properties.

 Changes for v3:
 1: Fixed review comments pointed by Sylwester.

 .../devicetree/bindings/media/i2c/tvp7002.txt      |   53 ++++++++++++++++
 drivers/media/i2c/tvp7002.c                        |   67 ++++++++++++++++++--
 2 files changed, 113 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/tvp7002.txt b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
new file mode 100644
index 0000000..1d00935
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
@@ -0,0 +1,53 @@
+* Texas Instruments TV7002 video decoder
+
+The TVP7002 device supports digitizing of video and graphics signal in RGB and
+YPbPr color space.
+
+Required Properties :
+- compatible : Must be "ti,tvp7002"
+
+Optional Properties:
+- hsync-active: HSYNC Polarity configuration for the bus. Default value when
+  this property is not specified is <0>.
+
+- vsync-active: VSYNC Polarity configuration for the bus. Default value when
+  this property is not specified is <0>.
+
+- pclk-sample: Clock polarity of the bus. Default value when this property is
+  not specified is <0>.
+
+- sync-on-green-active: Active state of Sync-on-green signal property of the
+  endpoint.
+  0 = Normal Operation (Default)
+  1 = Inverted operation
+
+- field-even-active: Active-high Field ID output polarity control of the bus.
+  Under normal operation, the field ID output is set to logic 1 for an odd field
+  (field 1)and set to logic 0 for an even field (field 0).
+  0 = Normal operation (default)
+  1 = FID output polarity inverted
+
+For further reading of port node refer Documentation/devicetree/bindings/media/
+video-interfaces.txt.
+
+Example:
+
+	i2c0@1c22000 {
+		...
+		...
+		tvp7002@5c {
+			compatible = "ti,tvp7002";
+			reg = <0x5c>;
+
+			port {
+				tvp7002_1: endpoint {
+					hsync-active = <1>;
+					vsync-active = <1>;
+					pclk-sample = <0>;
+					sync-on-green-active = <1>;
+					field-even-active = <0>;
+				};
+			};
+		};
+		...
+	};
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index f6b1f3f..24a08fa 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -35,6 +35,8 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-of.h>
+
 #include "tvp7002_reg.h"
 
 MODULE_DESCRIPTION("TI TVP7002 Video and Graphics Digitizer driver");
@@ -943,6 +945,48 @@ static const struct v4l2_subdev_ops tvp7002_ops = {
 	.pad = &tvp7002_pad_ops,
 };
 
+static struct tvp7002_config *
+tvp7002_get_pdata(struct i2c_client *client)
+{
+	struct v4l2_of_endpoint bus_cfg;
+	struct tvp7002_config *pdata;
+	struct device_node *endpoint;
+	unsigned int flags;
+
+	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
+		return client->dev.platform_data;
+
+	endpoint = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
+	if (!endpoint)
+		return NULL;
+
+	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		goto done;
+
+	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
+	flags = bus_cfg.bus.parallel.flags;
+
+	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
+		pdata->hs_polarity = 1;
+
+	if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
+		pdata->vs_polarity = 1;
+
+	if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
+		pdata->clk_polarity = 1;
+
+	if (flags & V4L2_MBUS_FIELD_EVEN_HIGH)
+		pdata->fid_polarity = 1;
+
+	if (flags & V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH)
+		pdata->sog_polarity = 1;
+
+done:
+	of_node_put(endpoint);
+	return pdata;
+}
+
 /*
  * tvp7002_probe - Probe a TVP7002 device
  * @c: ptr to i2c_client struct
@@ -954,32 +998,32 @@ static const struct v4l2_subdev_ops tvp7002_ops = {
  */
 static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 {
+	struct tvp7002_config *pdata = tvp7002_get_pdata(c);
 	struct v4l2_subdev *sd;
 	struct tvp7002 *device;
 	struct v4l2_dv_timings timings;
 	int polarity_a;
 	int polarity_b;
 	u8 revision;
-
 	int error;
 
+	if (pdata == NULL) {
+		dev_err(&c->dev, "No platform data\n");
+		return -EINVAL;
+	}
+
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(c->adapter,
 		I2C_FUNC_SMBUS_READ_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
 		return -EIO;
 
-	if (!c->dev.platform_data) {
-		v4l_err(c, "No platform data!!\n");
-		return -ENODEV;
-	}
-
 	device = devm_kzalloc(&c->dev, sizeof(struct tvp7002), GFP_KERNEL);
 
 	if (!device)
 		return -ENOMEM;
 
 	sd = &device->sd;
-	device->pdata = c->dev.platform_data;
+	device->pdata = pdata;
 	device->current_timings = tvp7002_timings;
 
 	/* Tell v4l2 the device is ready */
@@ -1084,9 +1128,18 @@ static const struct i2c_device_id tvp7002_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, tvp7002_id);
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id tvp7002_of_match[] = {
+	{ .compatible = "ti,tvp7002", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, tvp7002_of_match);
+#endif
+
 /* I2C driver data */
 static struct i2c_driver tvp7002_driver = {
 	.driver = {
+		.of_match_table = of_match_ptr(tvp7002_of_match),
 		.owner = THIS_MODULE,
 		.name = TVP7002_MODULE_NAME,
 	},
-- 
1.7.9.5

