Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaLCQJC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:09:02 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:65437 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaLCQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:08:56 -0500
X-AuditID: cbfee61a-f79c06d000004e71-c6-547f35969ef8
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v9 16/19] exynos4-is: Add support for v4l2-flash subdevs
Date: Wed, 03 Dec 2014 17:06:51 +0100
Message-id: <1417622814-10845-17-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t9jQd1ppvUhBjMvCVpsnLGe1eLozolM
	Fv1vFrJanHu1ktGi9+pzRouzTW/YLS7vmsNmsfXNOkaLng1bWS2WXr/IZHH31FE2iwnT17JY
	tO49wm6xe9dTVovDb9pZLc7sX8nmIOCxZt4aRo/Lfb1MHjtn3WX3WLn8C5vH4a8LWTw2repk
	89gz/werR9+WVYweK1Z/Z/f4vEkugCuKyyYlNSezLLVI3y6BK+Nbq3tBo3pF24rJLA2MGxW6
	GDk5JARMJDZ/Pc0GYYtJXLi3Hsjm4hASmM4osfjfVWYIp51J4uL23awgVWwChhI/X7xm6mLk
	4BARiJa4dKweJMwscJBJ4tbjchBbWMBH4syXR4wgJSwCqhJ3b8eAhHkFPCXOH7zFDBKWEFCQ
	mDPJBiTMCRR++uM+O0hYSMBD4uBE/wmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525i
	BAf2M6kdjCsbLA4xCnAwKvHwWsTVhQixJpYVV+YeYpTgYFYS4X32DSjEm5JYWZValB9fVJqT
	WnyIUZqDRUmc98bN3BAhgfTEktTs1NSC1CKYLBMHp1QDo2XzuY0rg078jJ22mW/z4T2pm05t
	mXD7RuhM7ogTWp0vnb553CzvOmd6bW6pOc/nK55tzV8nHmrh//9T+eo6K/7Fk+we/LK4aOpb
	E7l497z8b07p1Z25zhut76Q3rZVQu5Z84Fli/KQT7bErvztvvDpVMeuezL/3nCecjZl/3d+k
	4HtO1+OoR4USS3FGoqEWc1FxIgBqdfZqaAIAAA==
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
 drivers/media/platform/exynos4-is/media-dev.c |   42 +++++++++++++++++++++++--
 drivers/media/platform/exynos4-is/media-dev.h |   13 +++++++-
 2 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index f315ef9..b422d2e 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -451,6 +451,25 @@ rpm_put:
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
+			fmd->flash[fmd->num_flashes].asd.match_type =
+							V4L2_ASYNC_MATCH_CUSTOM_OF;
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
@@ -1272,9 +1291,24 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
 				 struct v4l2_async_subdev *asd)
 {
 	struct fimc_md *fmd = notifier_to_fimc_md(notifier);
+	struct device_node *node;
 	struct fimc_sensor_info *si = NULL;
 	int i;
 
+	node = v4l2_async_get_of_node_by_subdev(subdev);
+	if (node) {
+		/* Register flash subdev if detected any */
+		for (i = 0; i < ARRAY_SIZE(fmd->flash); i++) {
+			if (fmd->flash[i].asd.match.of.node == node) {
+				fmd->flash[i].subdev = subdev;
+				fmd->num_flashes++;
+				return 0;
+			}
+		}
+
+		return -EINVAL;
+	}
+
 	/* Find platform data for this sensor subdev */
 	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
 		if (fmd->sensor[i].asd.match.of.node == subdev->dev->of_node)
@@ -1385,6 +1419,8 @@ static int fimc_md_probe(struct platform_device *pdev)
 		goto err_m_ent;
 	}
 
+	fimc_md_register_flash_entities(fmd);
+
 	mutex_unlock(&fmd->media_dev.graph_mutex);
 
 	ret = device_create_file(&pdev->dev, &dev_attr_subdev_conf_mode);
@@ -1401,12 +1437,14 @@ static int fimc_md_probe(struct platform_device *pdev)
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

