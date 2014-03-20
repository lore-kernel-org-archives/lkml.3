Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922AbaCTOxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:53:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29167 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933546AbaCTOvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:51:49 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-fd-532b0084c1e4
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC 5/8] media: exynos4-is: Add support for v4l2-flash subdevs
Date: Thu, 20 Mar 2014 15:51:07 +0100
Message-id: <1395327070-20215-6-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgluLIzCtJLcpLzFFi42I5/e+xoG4Lg3awwY6p/Ba31p1jtZh/BEj0
	Xn3OaHG26Q27xeVdc9gstr5Zx2jRs2Erq8XhN+2sDhwefVtWMXp83iQXwBTFZZOSmpNZllqk
	b5fAlTG3eSJrwTqdio6rE9kbGD+qdDFyckgImEi8fdPPCGGLSVy4t56ti5GLQ0hgOqPE6uXf
	GCGcTiaJLZOesYJUsQkYSvx88ZoJxBYRKJeYNvURmM0sUCnx+eoeNhBbWMBP4sP77SwgNouA
	qsTWx1/BbF4BD4n/R3cA1XAAbVOQmDPJBiTMKeApsXRpFzNIWAio5OzEiAmMvAsYGVYxiqYW
	JBcUJ6XnGukVJ+YWl+al6yXn525iBIfPM+kdjKsaLA4xCnAwKvHwrtijGSzEmlhWXJl7iFGC
	g1lJhNfuuVawEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6p
	BsZZhv9O7rqovXCPXXuqQN16sdPsMecd9stWH/V48n9W1rTNl32UXx5gYORTZeIyl7CXTbR3
	ik0496xo06WZNWumFbheOPxzr4JbmJtxzf6NT17ys0f/s11tUvXu723/wBleZqszpOeuMQpf
	xLnCvt7H461LW+uED5fK2I14dp30Pxpwdt9p/itKLMUZiYZazEXFiQBYbULNGwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds suppport for external v4l2-flash devices.
The support includes parsing camera-flash DT property
and asynchronous subdevice registration.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |   34 ++++++++++++++++++++++---
 drivers/media/platform/exynos4-is/media-dev.h |   14 +++++++++-
 2 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index e62211a..0f80210 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -28,6 +28,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <media/v4l2-async.h>
+#include <media/v4l2-flash.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-of.h>
 #include <media/media-device.h>
@@ -400,7 +401,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 				   struct device_node *port,
 				   unsigned int index)
 {
-	struct device_node *rem, *ep, *np;
+	struct device_node *rem, *ep, *np, *fn;
 	struct fimc_source_info *pd;
 	struct v4l2_of_endpoint endpoint;
 	u32 val;
@@ -440,6 +441,14 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 		return -EINVAL;
 	}
 
+	fn = of_parse_phandle(rem, "camera-flash", 0);
+	if (fn) {
+		fmd->flash[fmd->num_flashes].asd.match_type =
+							V4L2_ASYNC_MATCH_OF;
+		fmd->flash[fmd->num_flashes].asd.match.of.node = fn;
+		fmd->num_flashes++;
+	}
+
 	if (fimc_input_is_parallel(endpoint.base.port)) {
 		if (endpoint.bus_type == V4L2_MBUS_PARALLEL)
 			pd->sensor_bus_type = FIMC_BUS_TYPE_ITU_601;
@@ -1531,6 +1540,15 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
 	struct fimc_sensor_info *si = NULL;
 	int i;
 
+	/* Register flash subdev if detected any */
+	for (i = 0; i < ARRAY_SIZE(fmd->flash); i++) {
+		if (fmd->flash[i].asd.match.of.node == subdev->dev->of_node) {
+			fmd->flash[i].v4l2_flash = subdev_to_flash(subdev);
+			fmd->num_flashes++;
+			return 0;
+		}
+	}
+
 	/* Find platform data for this sensor subdev */
 	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
 		if (fmd->sensor[i].asd.match.of.node == subdev->dev->of_node)
@@ -1578,7 +1596,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct v4l2_device *v4l2_dev;
 	struct fimc_md *fmd;
-	int ret;
+	int i, ret;
 
 	fmd = devm_kzalloc(dev, sizeof(*fmd), GFP_KERNEL);
 	if (!fmd)
@@ -1646,6 +1664,12 @@ static int fimc_md_probe(struct platform_device *pdev)
 			mutex_unlock(&fmd->media_dev.graph_mutex);
 			goto err_m_ent;
 		}
+
+		if (dev->of_node) {
+			for (i = 0; i < fmd->num_flashes; ++i)
+				fmd->async_subdevs[fmd->num_sensors + i] =
+						&fmd->flash[i].asd;
+		}
 	}
 
 	mutex_unlock(&fmd->media_dev.graph_mutex);
@@ -1664,12 +1688,14 @@ static int fimc_md_probe(struct platform_device *pdev)
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
index ee1e251..9af9de8 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -18,6 +18,7 @@
 #include <media/media-device.h>
 #include <media/media-entity.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-flash.h>
 #include <media/v4l2-subdev.h>
 #include <media/s5p_fimc.h>
 
@@ -33,6 +34,8 @@
 #define PINCTRL_STATE_IDLE	"idle"
 
 #define FIMC_MAX_SENSORS	4
+#define FIMC_MAX_FLASHES	1
+#define FIMC_MAX_ASYNC_SUBDEVS	(FIMC_MAX_SENSORS + FIMC_MAX_FLASHES)
 #define FIMC_MAX_CAMCLKS	2
 #define DEFAULT_SENSOR_CLK_FREQ	24000000U
 
@@ -93,6 +96,11 @@ struct fimc_sensor_info {
 	struct fimc_dev *host;
 };
 
+struct fimc_flash_info {
+	struct v4l2_flash *v4l2_flash;
+	struct v4l2_async_subdev asd;
+};
+
 struct cam_clk {
 	struct clk_hw hw;
 	struct fimc_md *fmd;
@@ -104,6 +112,8 @@ struct cam_clk {
  * @csis: MIPI CSIS subdevs data
  * @sensor: array of registered sensor subdevs
  * @num_sensors: actual number of registered sensors
+ * @flash: array of registered flash subdevs
+ * @num_flashes: actual number of registered flashes
  * @camclk: external sensor clock information
  * @fimc: array of registered fimc devices
  * @fimc_is: fimc-is data structure
@@ -123,6 +133,8 @@ struct fimc_md {
 	struct fimc_csis_info csis[CSIS_MAX_ENTITIES];
 	struct fimc_sensor_info sensor[FIMC_MAX_SENSORS];
 	int num_sensors;
+	struct fimc_flash_info flash[FIMC_MAX_FLASHES];
+	int num_flashes;
 	struct fimc_camclk_info camclk[FIMC_MAX_CAMCLKS];
 	struct clk *wbclk[FIMC_MAX_WBCLKS];
 	struct fimc_lite *fimc_lite[FIMC_LITE_MAX_DEVS];
@@ -149,7 +161,7 @@ struct fimc_md {
 	} clk_provider;
 
 	struct v4l2_async_notifier subdev_notifier;
-	struct v4l2_async_subdev *async_subdevs[FIMC_MAX_SENSORS];
+	struct v4l2_async_subdev *async_subdevs[FIMC_MAX_ASYNC_SUBDEVS];
 
 	bool user_subdev_api;
 	spinlock_t slock;
-- 
1.7.9.5

