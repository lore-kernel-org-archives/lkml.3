Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3EZN4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 09:56:10 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36681 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3EZN4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 09:56:07 -0400
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
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: [PATCH] media: i2c: ths7303: add OF support
Date: Sun, 26 May 2013 19:25:33 +0530
Message-Id: <1369576533-11277-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

add OF support for the ths7303 driver.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
---
 .../devicetree/bindings/media/i2c/ths73x3.txt      |   50 ++++++++++++++++++++
 drivers/media/i2c/ths7303.c                        |   40 +++++++++++++++-
 2 files changed, 89 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ths73x3.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ths73x3.txt b/Documentation/devicetree/bindings/media/i2c/ths73x3.txt
new file mode 100644
index 0000000..62f63e8
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ths73x3.txt
@@ -0,0 +1,50 @@
+* Texas Instruments THS7303/THS7353 video amplifier
+
+The THS7303/THS7353 device is a low power 3-channel integrated video buffer
+which can be configured individually via i2c for all the functions which makes
+it flexible for any application. It incorporates a selectable fifth-order
+Butterworth filter to eliminate data converter images.
+
+Required Properties :
+- compatible : value should be either one among the following
+	(a) "ti,ths7303" for ths7303 video amplifier.
+	(b) "ti,ths7353" for ths7353 video amplifier.
+
+- ti,ths73x3-ch1-bias: Bias value for channel 1.
+
+- ti,ths73x3-ch2-bias: Bias value for channel 2.
+
+- ti,ths73x3-ch3-bias: Bias value for channel 3.
+
+Bias values for channel-1/2/3 can be following (values default to zero):-
+ - 0: Disable Channel - Conserves Power
+ - 1: Channel On - Mute Function - No Output
+ - 2: Channel On - DC Bias Select
+ - 3: Channel On - DC Bias + 250 mV Offset Select
+ - 4: Channel On - AC Bias Select
+ - 5: Channel On - Sync Tip Clam with low bias
+ - 6: Channel On - Sync Tip Clam with mid bias
+ - 7: Channel On - Sync Tip Clam with high bias
+
+For further reading of port node refer Documentation/devicetree/bindings/media/
+video-interfaces.txt.
+
+Example:
+
+	i2c0@1c22000 {
+		...
+		...
+		ths7303@2c {
+			compatible = "ti,ths7303";
+			reg = <0x2c>;
+
+			port {
+				ths7303_1: endpoint {
+					ti,ths73x3-ch1-bias = <3>;
+					ti,ths73x3-ch2-bias = <3>;
+					ti,ths73x3-ch3-bias = <3>;
+				};
+			};
+		};
+		...
+	};
diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index b954195..b218b0f 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -28,6 +28,7 @@
 #include <media/ths7303.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
 
 #define THS7303_CHANNEL_1	1
 #define THS7303_CHANNEL_2	2
@@ -349,10 +350,37 @@ static const struct v4l2_subdev_ops ths7303_ops = {
 	.video 	= &ths7303_video_ops,
 };
 
+static struct ths7303_platform_data *
+ths7303_get_pdata(struct i2c_client *client)
+{
+	struct ths7303_platform_data *pdata;
+	struct device_node *endpoint;
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
+	of_property_read_u8(endpoint, "ti,ths73x3-ch1-bias", &pdata->ch_1);
+	of_property_read_u8(endpoint, "ti,ths73x3-ch2-bias", &pdata->ch_2);
+	of_property_read_u8(endpoint, "ti,ths73x3-ch3-bias", &pdata->ch_3);
+
+done:
+	of_node_put(endpoint);
+
+	return pdata;
+}
+
 static int ths7303_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct ths7303_platform_data *pdata = client->dev.platform_data;
+	struct ths7303_platform_data *pdata = ths7303_get_pdata(client);
 	struct ths7303_state *state;
 	struct v4l2_subdev *sd;
 
@@ -405,8 +433,18 @@ static const struct i2c_device_id ths7303_id[] = {
 
 MODULE_DEVICE_TABLE(i2c, ths7303_id);
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id ths73x3_of_match[] = {
+	{ .compatible = "ti,ths7303", },
+	{ .compatible = "ti,ths7353", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, ths73x3_of_match);
+#endif
+
 static struct i2c_driver ths7303_driver = {
 	.driver = {
+		.of_match_table = of_match_ptr(ths73x3_of_match),
 		.owner	= THIS_MODULE,
 		.name	= "ths73x3",
 	},
-- 
1.7.0.4

