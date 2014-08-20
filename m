Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaHTNnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:43:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25550 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaHTNnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:43:33 -0400
X-AuditID: cbfee61a-f79e46d00000134f-82-53f4a6034a87
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v5 3/3] exynos4-is: Add support for v4l2-flash subdevs
Date: Wed, 20 Aug 2014 15:43:11 +0200
Message-id: <1408542191-335-4-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542191-335-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542191-335-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkluLIzCtJLcpLzFFi42I5/e+xgC7zsi/BBvOuaVhsnLGe1WL+kXOs
	Fr1XnzNanG16w25xedccNoutb9YxWvRs2MpqcfhNO6sDh0ffllWMHp83yQUwRXHZpKTmZJal
	FunbJXBlrP+kUHBEteLe9luMDYxL5LsYOTkkBEwkbjQ0sEPYYhIX7q1n62Lk4hASWMQoMe3W
	MSinnUli6ZMnjCBVbAKGEj9fvGYCsUUEyiV63j8DK2IWmMoo0b/mGhtIQljAS+LI/PnMIDaL
	gKrEvYuNYCt4Bdwkvh7/DmRzAK1TkJgzyQYkzCngLrH93HywEiGgkn0T25gmMPIuYGRYxSia
	WpBcUJyUnmuoV5yYW1yal66XnJ+7iREcQM+kdjCubLA4xCjAwajEw9uw4EuwEGtiWXFl7iFG
	CQ5mJRHe9k6gEG9KYmVValF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6p
	BkaH9DR7L5bzzFUfZnkKLsz/L7uQrZCVRWLagg8RCYzr3T0Vwzeqvapa+zEmw+J1trXfsUnp
	C5wv33sgcLQ7evku+YSiAKkrLG8fc0z7vDf6xQUlnkkv5OdOrNrI8ch1r5+v5KT/Jw9M1A33
	sN/x8ytbg4S9+2WOMAPd5z+mM1tdNVt7zM1KLU+JpTgj0VCLuag4EQD1WhKdHAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds suppport for external v4l2-flash devices.
The support includes parsing camera-flash DT property
and asynchronous subdevice registration.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |   37 +++++++++++++++++++++++--
 drivers/media/platform/exynos4-is/media-dev.h |   13 ++++++++-
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 344718d..ecb929c 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -451,6 +451,26 @@ rpm_put:
 	return ret;
 }
 
+static void fimc_md_register_flash_entities(struct fimc_md *fmd)
+{
+	struct device_node *parent = fmd->pdev->dev.of_node;
+	struct device_node *np;
+	int i = 0;
+
+	do {
+		np = of_parse_phandle(parent, "flashes", i);
+		if (np) {
+			pr_info("found flash\n");
+			fmd->flash[fmd->num_flashes].asd.match_type =
+							V4L2_ASYNC_MATCH_OF;
+			fmd->flash[fmd->num_flashes].asd.match.of.node = np;
+			fmd->num_flashes++;
+			fmd->async_subdevs[fmd->num_sensors + i] =
+						&fmd->flash[i].asd;
+		}
+	} while (np && (++i < FIMC_MAX_FLASHES));
+}
+
 static int __of_get_csis_id(struct device_node *np)
 {
 	u32 reg = 0;
@@ -1273,6 +1293,15 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
 	struct fimc_sensor_info *si = NULL;
 	int i;
 
+	/* Register flash subdev if detected any */
+	for (i = 0; i < ARRAY_SIZE(fmd->flash); i++) {
+		if (fmd->flash[i].asd.match.of.node == subdev->dev->of_node) {
+			fmd->flash[i].subdev = subdev;
+			fmd->num_flashes++;
+			return 0;
+		}
+	}
+
 	/* Find platform data for this sensor subdev */
 	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
 		if (fmd->sensor[i].asd.match.of.node == subdev->dev->of_node)
@@ -1383,6 +1412,8 @@ static int fimc_md_probe(struct platform_device *pdev)
 		goto err_m_ent;
 	}
 
+	fimc_md_register_flash_entities(fmd);
+
 	mutex_unlock(&fmd->media_dev.graph_mutex);
 
 	ret = device_create_file(&pdev->dev, &dev_attr_subdev_conf_mode);
@@ -1399,12 +1430,14 @@ static int fimc_md_probe(struct platform_device *pdev)
 		goto err_attr;
 	}
 
-	if (fmd->num_sensors > 0) {
+	if (fmd->num_sensors > 0 || fmd->num_flashes > 0) {
 		fmd->subdev_notifier.subdevs = fmd->async_subdevs;
-		fmd->subdev_notifier.num_subdevs = fmd->num_sensors;
+		fmd->subdev_notifier.num_subdevs = fmd->num_sensors +
+							fmd->num_flashes;
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

