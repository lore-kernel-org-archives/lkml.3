Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaJUPID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:08:03 -0400
Received: from ring0.de ([5.45.105.125]:54047 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbaJUPH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:07:58 -0400
X-Spam-Report: =?ISO-8859-1?Q?
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: nokia.com]
	* -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	*  1.0 UNWANTED_LANGUAGE_BODY BODY: Nachrichtentext in unerw=fcnschter
	*      Sprache
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers?=
From: Sebastian Reichel <sre@kernel.org>
To: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [RFCv2 5/8] [media] si4713: add device tree support
Date: Tue, 21 Oct 2014 17:07:04 +0200
Message-Id: <1413904027-16767-6-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413904027-16767-1-git-send-email-sre@kernel.org>
References: <1413904027-16767-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support by changing the device registration order.
In the device tree the si4713 node is a normal I2C device, which
will be probed as such. Thus the V4L device must be probed from
the I2C device and not the other way around.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/media/radio/si4713/radio-platform-si4713.c | 28 ++++--------------
 drivers/media/radio/si4713/si4713.c                | 34 ++++++++++++++++++++--
 drivers/media/radio/si4713/si4713.h                |  6 ++++
 include/media/radio-si4713.h                       | 30 -------------------
 include/media/si4713.h                             |  1 +
 5 files changed, 45 insertions(+), 54 deletions(-)
 delete mode 100644 include/media/radio-si4713.h

diff --git a/drivers/media/radio/si4713/radio-platform-si4713.c b/drivers/media/radio/si4713/radio-platform-si4713.c
index a47502a..2de5439 100644
--- a/drivers/media/radio/si4713/radio-platform-si4713.c
+++ b/drivers/media/radio/si4713/radio-platform-si4713.c
@@ -34,7 +34,7 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
-#include <media/radio-si4713.h>
+#include "si4713.h"
 
 /* module parameters */
 static int radio_nr = -1;	/* radio device minor (-1 ==> auto assign) */
@@ -153,7 +153,6 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 {
 	struct radio_si4713_platform_data *pdata = pdev->dev.platform_data;
 	struct radio_si4713_device *rsdev;
-	struct i2c_adapter *adapter;
 	struct v4l2_subdev *sd;
 	int rval = 0;
 
@@ -177,20 +176,11 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 		goto exit;
 	}
 
-	adapter = i2c_get_adapter(pdata->i2c_bus);
-	if (!adapter) {
-		dev_err(&pdev->dev, "Cannot get i2c adapter %d\n",
-			pdata->i2c_bus);
-		rval = -ENODEV;
-		goto unregister_v4l2_dev;
-	}
-
-	sd = v4l2_i2c_new_subdev_board(&rsdev->v4l2_dev, adapter,
-				       pdata->subdev_board_info, NULL);
-	if (!sd) {
+	sd = i2c_get_clientdata(pdata->subdev);
+	rval = v4l2_device_register_subdev(&rsdev->v4l2_dev, sd);
+	if (rval) {
 		dev_err(&pdev->dev, "Cannot get v4l2 subdevice\n");
-		rval = -ENODEV;
-		goto put_adapter;
+		goto unregister_v4l2_dev;
 	}
 
 	rsdev->radio_dev = radio_si4713_vdev_template;
@@ -202,14 +192,12 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 	if (video_register_device(&rsdev->radio_dev, VFL_TYPE_RADIO, radio_nr)) {
 		dev_err(&pdev->dev, "Could not register video device.\n");
 		rval = -EIO;
-		goto put_adapter;
+		goto unregister_v4l2_dev;
 	}
 	dev_info(&pdev->dev, "New device successfully probed\n");
 
 	goto exit;
 
-put_adapter:
-	i2c_put_adapter(adapter);
 unregister_v4l2_dev:
 	v4l2_device_unregister(&rsdev->v4l2_dev);
 exit:
@@ -220,14 +208,10 @@ exit:
 static int radio_si4713_pdriver_remove(struct platform_device *pdev)
 {
 	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
-	struct v4l2_subdev *sd = list_entry(v4l2_dev->subdevs.next,
-					    struct v4l2_subdev, list);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct radio_si4713_device *rsdev;
 
 	rsdev = container_of(v4l2_dev, struct radio_si4713_device, v4l2_dev);
 	video_unregister_device(&rsdev->radio_dev);
-	i2c_put_adapter(client->adapter);
 	v4l2_device_unregister(&rsdev->v4l2_dev);
 
 	return 0;
diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index ebec16d..94fe3c6 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -1446,9 +1446,13 @@ static int si4713_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
 	struct si4713_device *sdev;
-	struct si4713_platform_data *pdata = client->dev.platform_data;
 	struct v4l2_ctrl_handler *hdl;
-	int rval, i;
+	struct si4713_platform_data *pdata = client->dev.platform_data;
+	struct device_node *np = client->dev.of_node;
+	int rval;
+
+	struct radio_si4713_platform_data si4713_pdev_pdata;
+	struct platform_device *si4713_pdev;
 
 	sdev = devm_kzalloc(&client->dev, sizeof(*sdev), GFP_KERNEL);
 	if (!sdev) {
@@ -1608,8 +1612,31 @@ static int si4713_probe(struct i2c_client *client,
 		goto free_ctrls;
 	}
 
+	if ((pdata && pdata->is_platform_device) || np) {
+		si4713_pdev = platform_device_alloc("radio-si4713", -1);
+		if (!si4713_pdev)
+			goto put_main_pdev;
+
+		si4713_pdev_pdata.subdev = client;
+		rval = platform_device_add_data(si4713_pdev, &si4713_pdev_pdata,
+						sizeof(si4713_pdev_pdata));
+		if (rval)
+			goto put_main_pdev;
+
+		rval = platform_device_add(si4713_pdev);
+		if (rval)
+			goto put_main_pdev;
+
+		sdev->pd = si4713_pdev;
+	} else {
+		sdev->pd = NULL;
+	}
+
 	return 0;
 
+put_main_pdev:
+	platform_device_put(si4713_pdev);
+	v4l2_device_unregister_subdev(&sdev->sd);
 free_ctrls:
 	v4l2_ctrl_handler_free(hdl);
 exit:
@@ -1622,6 +1649,9 @@ static int si4713_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct si4713_device *sdev = to_si4713_device(sd);
 
+	if (sdev->pd)
+		platform_device_unregister(sdev->pd);
+
 	if (sdev->power_state)
 		si4713_set_power_state(sdev, POWER_DOWN);
 
diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
index 7c2479f..8a376e1 100644
--- a/drivers/media/radio/si4713/si4713.h
+++ b/drivers/media/radio/si4713/si4713.h
@@ -15,6 +15,7 @@
 #ifndef SI4713_I2C_H
 #define SI4713_I2C_H
 
+#include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/gpio/consumer.h>
 #include <media/v4l2-subdev.h>
@@ -238,6 +239,7 @@ struct si4713_device {
 	struct regulator *vdd;
 	struct regulator *vio;
 	struct gpio_desc *gpio_reset;
+	struct platform_device *pd;
 	u32 power_state;
 	u32 rds_enabled;
 	u32 frequency;
@@ -245,4 +247,8 @@ struct si4713_device {
 	u32 stereo;
 	u32 tune_rnl;
 };
+
+struct radio_si4713_platform_data {
+	struct i2c_client *subdev;
+};
 #endif /* ifndef SI4713_I2C_H */
diff --git a/include/media/radio-si4713.h b/include/media/radio-si4713.h
deleted file mode 100644
index f6aae29..0000000
--- a/include/media/radio-si4713.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * include/media/radio-si4713.h
- *
- * Board related data definitions for Si4713 radio transmitter chip.
- *
- * Copyright (c) 2009 Nokia Corporation
- * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
- *
- * This file is licensed under the terms of the GNU General Public License
- * version 2. This program is licensed "as is" without any warranty of any
- * kind, whether express or implied.
- *
- */
-
-#ifndef RADIO_SI4713_H
-#define RADIO_SI4713_H
-
-#include <linux/i2c.h>
-
-#define SI4713_NAME "radio-si4713"
-
-/*
- * Platform dependent definition
- */
-struct radio_si4713_platform_data {
-	int i2c_bus;
-	struct i2c_board_info *subdev_board_info;
-};
-
-#endif /* ifndef RADIO_SI4713_H*/
diff --git a/include/media/si4713.h b/include/media/si4713.h
index f98a0a7..343b8fb5 100644
--- a/include/media/si4713.h
+++ b/include/media/si4713.h
@@ -26,6 +26,7 @@ struct si4713_platform_data {
 	const char * const *supply_names;
 	unsigned supplies;
 	int gpio_reset; /* < 0 if not used */
+	bool is_platform_device;
 };
 
 /*
-- 
2.1.1

