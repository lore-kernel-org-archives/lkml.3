Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaK1JUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:20:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:44513 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaK1JUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:20:01 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-a5-54783e3f94d8
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v8 07/14] exynos4-is: Add support for v4l2-flash subdevs
Date: Fri, 28 Nov 2014 10:17:59 +0100
Message-id: <1417166286-27685-8-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t9jQV17u4oQg337hCw2zljPanF050Qm
	i96rzxktzja9Ybe4vGsOm8XWN+sYLXo2bGW1uHvqKJvF7l1PWS0Ov2lntTizfyWbA7fHzll3
	2T0Of13I4rFn/g9Wj74tqxg9Vqz+zu7xeZNcAFsUl01Kak5mWWqRvl0CV8b/ZZMYCz5qV1x6
	PIG9gfGQShcjJ4eEgInE4dnzmCBsMYkL99azdTFycQgJTGeUOLL5FjuE084k8bjhPDtIFZuA
	ocTPF6+BOjg4RASiJS4dqwepYRY4xSixbuZqRpAaYQEficbDF8CmsgioShxomMoGYvMKeEgc
	3jCZBaRXQkBBYs4kG5Awp4CnxNzPa8HCQkAli16lTGDkXcDIsIpRNLUguaA4KT3XSK84Mbe4
	NC9dLzk/dxMjOAifSe9gXNVgcYhRgINRiYf357/yECHWxLLiytxDjBIczEoivKe+AoV4UxIr
	q1KL8uOLSnNSiw8xSnOwKInz3riZGyIkkJ5YkpqdmlqQWgSTZeLglGpg7GO8YmptmHCTwf/B
	4fS9dVftnWe+vGHSyiG8Jz3yiXzIMpb5wV+P/TmyT12866ed1v4NOiGnZN5Pbf86r8rba3ve
	ZynDyjIN3hWXTTrbXhwVkG5bq1HL9rJsoa+3+qS8HT99m9PU7JiStRUqp+Q80NrZFprwZ58Y
	u9rZTbfk+vwSrt38xCulxFKckWioxVxUnAgA/J4vNT4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds suppport for external v4l2-flash devices.
The support includes parsing "flashes" Device Tree property
and asynchronous subdevice registration.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |   65 ++++++++++++++++++++++++-
 drivers/media/platform/exynos4-is/media-dev.h |   13 ++++-
 2 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index f315ef9..8807730 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -451,6 +451,47 @@ rpm_put:
 	return ret;
 }
 
+static bool match_subdev_name(struct v4l2_subdev *sd,
+			      struct v4l2_async_subdev *asd)
+{
+	return !strcmp(sd->name, (char *) asd->match.custom.priv);
+}
+
+static int fimc_md_register_flash_entities(struct fimc_md *fmd)
+{
+	struct device_node *parent = fmd->pdev->dev.of_node;
+	const char *flash_names[FIMC_MAX_FLASHES];
+	int ret, i;
+
+	ret = of_property_count_strings(parent, "flashes");
+	if (ret < 0) {
+		/* the property may not exist - this is valid state */
+		if (ret == -EINVAL)
+			return 0;
+		v4l2_err(&fmd->v4l2_dev, "Failed to retrieve flashes\n");
+		return -EINVAL;
+	}
+
+	fmd->num_flashes = ret;
+
+	if (fmd->num_flashes > FIMC_MAX_FLASHES) {
+		v4l2_err(&fmd->v4l2_dev, "Too many flash leds declared.\n");
+		return -EINVAL;
+	}
+
+	of_property_read_string_array(parent, "flashes", flash_names,
+					fmd->num_flashes);
+
+	for (i = 0; i < fmd->num_flashes; ++i) {
+		fmd->flash[i].asd.match_type = V4L2_ASYNC_MATCH_CUSTOM;
+		fmd->flash[i].asd.match.custom.match = match_subdev_name;
+		fmd->flash[i].asd.match.custom.priv = (void *) flash_names[i];
+		fmd->async_subdevs[fmd->num_sensors + i] = &fmd->flash[i].asd;
+	}
+
+	return 0;
+}
+
 static int __of_get_csis_id(struct device_node *np)
 {
 	u32 reg = 0;
@@ -1275,6 +1316,18 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
 	struct fimc_sensor_info *si = NULL;
 	int i;
 
+	/* Register flash subdev if detected any */
+	for (i = 0; i < ARRAY_SIZE(fmd->flash); i++) {
+		if (!fmd->flash[i].asd.match.custom.priv)
+			continue;
+		if (!strcmp(fmd->flash[i].asd.match.custom.priv,
+				subdev->name)) {
+			fmd->flash[i].subdev = subdev;
+			fmd->num_flashes++;
+			return 0;
+		}
+	}
+
 	/* Find platform data for this sensor subdev */
 	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
 		if (fmd->sensor[i].asd.match.of.node == subdev->dev->of_node)
@@ -1385,6 +1438,12 @@ static int fimc_md_probe(struct platform_device *pdev)
 		goto err_m_ent;
 	}
 
+	ret = fimc_md_register_flash_entities(fmd);
+	if (ret < 0) {
+		mutex_unlock(&fmd->media_dev.graph_mutex);
+		goto err_m_ent;
+	}
+
 	mutex_unlock(&fmd->media_dev.graph_mutex);
 
 	ret = device_create_file(&pdev->dev, &dev_attr_subdev_conf_mode);
@@ -1401,12 +1460,14 @@ static int fimc_md_probe(struct platform_device *pdev)
 		goto err_attr;
 	}
 
-	if (fmd->num_sensors > 0) {
+	if (fmd->num_sensors > 0 || fmd->num_flashes > 0) {
 		fmd->subdev_notifier.subdevs = fmd->async_subdevs;
-		fmd->subdev_notifier.num_subdevs = fmd->num_sensors;
+		fmd->subdev_notifier.num_subdevs = fmd->num_sensors +
+						   fmd->num_flashes;
 		fmd->subdev_notifier.bound = subdev_notifier_bound;
 		fmd->subdev_notifier.complete = subdev_notifier_complete;
 		fmd->num_sensors = 0;
+		fmd->num_flashes = 0;
 
 		ret = v4l2_async_notifier_register(&fmd->v4l2_dev,
 						&fmd->subdev_notifier);
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 0321454..feff9c8 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -34,6 +34,8 @@
 
 #define FIMC_MAX_SENSORS	4
 #define FIMC_MAX_CAMCLKS	2
+#define FIMC_MAX_FLASHES	2
+#define FIMC_MAX_ASYNC_SUBDEVS (FIMC_MAX_SENSORS + FIMC_MAX_FLASHES)
 #define DEFAULT_SENSOR_CLK_FREQ	24000000U
 
 /* LCD/ISP Writeback clocks (PIXELASYNCMx) */
@@ -93,6 +95,11 @@ struct fimc_sensor_info {
 	struct fimc_dev *host;
 };
 
+struct fimc_flash_info {
+	struct v4l2_subdev *subdev;
+	struct v4l2_async_subdev asd;
+};
+
 struct cam_clk {
 	struct clk_hw hw;
 	struct fimc_md *fmd;
@@ -104,6 +111,8 @@ struct cam_clk {
  * @csis: MIPI CSIS subdevs data
  * @sensor: array of registered sensor subdevs
  * @num_sensors: actual number of registered sensors
+ * @flash: array of registered flash subdevs
+ * @num_flashes: actual number of registered flashes
  * @camclk: external sensor clock information
  * @fimc: array of registered fimc devices
  * @fimc_is: fimc-is data structure
@@ -123,6 +132,8 @@ struct fimc_md {
 	struct fimc_csis_info csis[CSIS_MAX_ENTITIES];
 	struct fimc_sensor_info sensor[FIMC_MAX_SENSORS];
 	int num_sensors;
+	struct fimc_flash_info flash[FIMC_MAX_FLASHES];
+	int num_flashes;
 	struct fimc_camclk_info camclk[FIMC_MAX_CAMCLKS];
 	struct clk *wbclk[FIMC_MAX_WBCLKS];
 	struct fimc_lite *fimc_lite[FIMC_LITE_MAX_DEVS];
@@ -149,7 +160,7 @@ struct fimc_md {
 	} clk_provider;
 
 	struct v4l2_async_notifier subdev_notifier;
-	struct v4l2_async_subdev *async_subdevs[FIMC_MAX_SENSORS];
+	struct v4l2_async_subdev *async_subdevs[FIMC_MAX_ASYNC_SUBDEVS];
 
 	bool user_subdev_api;
 	spinlock_t slock;
-- 
1.7.9.5

