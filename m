Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3H3MCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:02:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34611 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab3H3MCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:02:17 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-6a-522089c7e154
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: m.chehab@samsung.com
Cc: kyungmin.park@samsung.com, t.stanislaws@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v4 1/2] media: s5p-tv: Replace mxr_ macro by default dev_
Date: Fri, 30 Aug 2013 14:02:00 +0200
Message-id: <1377864121-19587-2-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377864121-19587-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377864121-19587-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e+xgO7xToUgg9t/LSzONr1ht9j0+Bqr
	xeVdc9gsejZsZbW4uE7e4vSaU8wW89pfsjqwe2xeUu9x8N0eJo++LasYPT5vkgtgieKySUnN
	ySxLLdK3S+DK+HOmlb1g2mHGindX+lkbGPcsZOxi5OSQEDCRmDn1KJQtJnHh3nq2LkYuDiGB
	RYwSu7o3sUA47UwSj//PYQGpYhMwl5j4bBOYLSIgIXF/9TM2EJtZ4DyjxLlL8SC2sICnxKeH
	Z9lBbBYBVYkl69eBbeAV8JNY9HcKK8Q2BYmfl0+A9XIK+Esc+b0LLC4EVLN28Ve2CYy8CxgZ
	VjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEB9Mz6R2MqxosDjEKcDAq8fA2TJUPEmJNLCuu
	zD3EKMHBrCTCW5GqECTEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFM
	lomDU6qBkbn6vYmczY9DwafS9z1y2xxvcvlxmuuDt5ZT7cwP+DwWO/3sr9rRI8s2Tt/e9Xrn
	MZEkxSnBXfXOk/fseH+fw0l3U8Kd97sez0n75Ht71bUo9sBXk8pTfHyZLO0nCCpX/FLbLhkg
	vkqXc21t1aXk1rjwu68SDt7o8X3Rd6Ys8Mu30nijk1HMf5VYijMSDbWYi4oTAZ0M+FMiAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace mxr_dbg, mxr_info and mxr_warn by generic solution.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 drivers/media/platform/s5p-tv/mixer.h           |  12 ---
 drivers/media/platform/s5p-tv/mixer_drv.c       |  47 ++++++-----
 drivers/media/platform/s5p-tv/mixer_grp_layer.c |   2 +-
 drivers/media/platform/s5p-tv/mixer_reg.c       |   6 +-
 drivers/media/platform/s5p-tv/mixer_video.c     | 100 ++++++++++++------------
 drivers/media/platform/s5p-tv/mixer_vp_layer.c  |   2 +-
 6 files changed, 78 insertions(+), 91 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer.h b/drivers/media/platform/s5p-tv/mixer.h
index 04e6490..c054106 100644
--- a/drivers/media/platform/s5p-tv/mixer.h
+++ b/drivers/media/platform/s5p-tv/mixer.h
@@ -327,18 +327,6 @@ void mxr_streamer_put(struct mxr_device *mdev);
 void mxr_get_mbus_fmt(struct mxr_device *mdev,
 	struct v4l2_mbus_framefmt *mbus_fmt);
 
-/* Debug */
-
-#define mxr_err(mdev, fmt, ...)  dev_err(mdev->dev, fmt, ##__VA_ARGS__)
-#define mxr_warn(mdev, fmt, ...) dev_warn(mdev->dev, fmt, ##__VA_ARGS__)
-#define mxr_info(mdev, fmt, ...) dev_info(mdev->dev, fmt, ##__VA_ARGS__)
-
-#ifdef CONFIG_VIDEO_SAMSUNG_S5P_MIXER_DEBUG
-	#define mxr_dbg(mdev, fmt, ...)  dev_dbg(mdev->dev, fmt, ##__VA_ARGS__)
-#else
-	#define mxr_dbg(mdev, fmt, ...)  do { (void) mdev; } while (0)
-#endif
-
 /* accessing Mixer's and Video Processor's registers */
 
 void mxr_vsync_set_update(struct mxr_device *mdev, int en);
diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index 51805a5..8ce7c3e 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -59,7 +59,7 @@ void mxr_streamer_get(struct mxr_device *mdev)
 {
 	mutex_lock(&mdev->mutex);
 	++mdev->n_streamer;
-	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_streamer);
+	dev_dbg(mdev->dev, "%s(%d)\n", __func__, mdev->n_streamer);
 	if (mdev->n_streamer == 1) {
 		struct v4l2_subdev *sd = to_outsd(mdev);
 		struct v4l2_mbus_framefmt mbus_fmt;
@@ -91,7 +91,7 @@ void mxr_streamer_put(struct mxr_device *mdev)
 {
 	mutex_lock(&mdev->mutex);
 	--mdev->n_streamer;
-	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_streamer);
+	dev_dbg(mdev->dev, "%s(%d)\n", __func__, mdev->n_streamer);
 	if (mdev->n_streamer == 0) {
 		int ret;
 		struct v4l2_subdev *sd = to_outsd(mdev);
@@ -113,7 +113,7 @@ void mxr_output_get(struct mxr_device *mdev)
 {
 	mutex_lock(&mdev->mutex);
 	++mdev->n_output;
-	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_output);
+	dev_dbg(mdev->dev, "%s(%d)\n", __func__, mdev->n_output);
 	/* turn on auxiliary driver */
 	if (mdev->n_output == 1)
 		v4l2_subdev_call(to_outsd(mdev), core, s_power, 1);
@@ -124,7 +124,7 @@ void mxr_output_put(struct mxr_device *mdev)
 {
 	mutex_lock(&mdev->mutex);
 	--mdev->n_output;
-	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_output);
+	dev_dbg(mdev->dev, "%s(%d)\n", __func__, mdev->n_output);
 	/* turn on auxiliary driver */
 	if (mdev->n_output == 0)
 		v4l2_subdev_call(to_outsd(mdev), core, s_power, 0);
@@ -159,42 +159,42 @@ static int mxr_acquire_plat_resources(struct mxr_device *mdev,
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mxr");
 	if (res == NULL) {
-		mxr_err(mdev, "get memory resource failed.\n");
+		dev_err(mdev->dev, "get memory resource failed.\n");
 		ret = -ENXIO;
 		goto fail;
 	}
 
 	mdev->res.mxr_regs = ioremap(res->start, resource_size(res));
 	if (mdev->res.mxr_regs == NULL) {
-		mxr_err(mdev, "register mapping failed.\n");
+		dev_err(mdev->dev, "register mapping failed.\n");
 		ret = -ENXIO;
 		goto fail;
 	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vp");
 	if (res == NULL) {
-		mxr_err(mdev, "get memory resource failed.\n");
+		dev_err(mdev->dev, "get memory resource failed.\n");
 		ret = -ENXIO;
 		goto fail_mxr_regs;
 	}
 
 	mdev->res.vp_regs = ioremap(res->start, resource_size(res));
 	if (mdev->res.vp_regs == NULL) {
-		mxr_err(mdev, "register mapping failed.\n");
+		dev_err(mdev->dev, "register mapping failed.\n");
 		ret = -ENXIO;
 		goto fail_mxr_regs;
 	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "irq");
 	if (res == NULL) {
-		mxr_err(mdev, "get interrupt resource failed.\n");
+		dev_err(mdev->dev, "get interrupt resource failed.\n");
 		ret = -ENXIO;
 		goto fail_vp_regs;
 	}
 
 	ret = request_irq(res->start, mxr_irq_handler, 0, "s5p-mixer", mdev);
 	if (ret) {
-		mxr_err(mdev, "request interrupt failed.\n");
+		dev_err(mdev->dev, "request interrupt failed.\n");
 		goto fail_vp_regs;
 	}
 	mdev->res.irq = res->start;
@@ -252,27 +252,27 @@ static int mxr_acquire_clocks(struct mxr_device *mdev)
 
 	res->mixer = clk_get(dev, "mixer");
 	if (IS_ERR(res->mixer)) {
-		mxr_err(mdev, "failed to get clock 'mixer'\n");
+		dev_err(mdev->dev, "failed to get clock 'mixer'\n");
 		goto fail;
 	}
 	res->vp = clk_get(dev, "vp");
 	if (IS_ERR(res->vp)) {
-		mxr_err(mdev, "failed to get clock 'vp'\n");
+		dev_err(mdev->dev, "failed to get clock 'vp'\n");
 		goto fail;
 	}
 	res->sclk_mixer = clk_get(dev, "sclk_mixer");
 	if (IS_ERR(res->sclk_mixer)) {
-		mxr_err(mdev, "failed to get clock 'sclk_mixer'\n");
+		dev_err(mdev->dev, "failed to get clock 'sclk_mixer'\n");
 		goto fail;
 	}
 	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
 	if (IS_ERR(res->sclk_hdmi)) {
-		mxr_err(mdev, "failed to get clock 'sclk_hdmi'\n");
+		dev_err(mdev->dev, "failed to get clock 'sclk_hdmi'\n");
 		goto fail;
 	}
 	res->sclk_dac = clk_get(dev, "sclk_dac");
 	if (IS_ERR(res->sclk_dac)) {
-		mxr_err(mdev, "failed to get clock 'sclk_dac'\n");
+		dev_err(mdev->dev, "failed to get clock 'sclk_dac'\n");
 		goto fail;
 	}
 
@@ -295,13 +295,13 @@ static int mxr_acquire_resources(struct mxr_device *mdev,
 	if (ret)
 		goto fail_plat;
 
-	mxr_info(mdev, "resources acquired\n");
+	dev_info(mdev->dev, "resources acquired\n");
 	return 0;
 
 fail_plat:
 	mxr_release_plat_resources(mdev);
 fail:
-	mxr_err(mdev, "resources acquire failed\n");
+	dev_err(mdev->dev, "resources acquire failed\n");
 	return ret;
 }
 
@@ -330,7 +330,7 @@ static int mxr_acquire_layers(struct mxr_device *mdev,
 	mdev->layer[2] = mxr_vp_layer_create(mdev, 0);
 
 	if (!mdev->layer[0] || !mdev->layer[1] || !mdev->layer[2]) {
-		mxr_err(mdev, "failed to acquire layers\n");
+		dev_err(mdev->dev, "failed to acquire layers\n");
 		goto fail;
 	}
 
@@ -348,7 +348,7 @@ static int mxr_runtime_resume(struct device *dev)
 	struct mxr_device *mdev = to_mdev(dev);
 	struct mxr_resources *res = &mdev->res;
 
-	mxr_dbg(mdev, "resume - start\n");
+	dev_dbg(mdev->dev, "resume - start\n");
 	mutex_lock(&mdev->mutex);
 	/* turn clocks on */
 	clk_enable(res->mixer);
@@ -356,7 +356,7 @@ static int mxr_runtime_resume(struct device *dev)
 	clk_enable(res->sclk_mixer);
 	/* apply default configuration */
 	mxr_reg_reset(mdev);
-	mxr_dbg(mdev, "resume - finished\n");
+	dev_dbg(mdev->dev, "resume - finished\n");
 
 	mutex_unlock(&mdev->mutex);
 	return 0;
@@ -366,14 +366,14 @@ static int mxr_runtime_suspend(struct device *dev)
 {
 	struct mxr_device *mdev = to_mdev(dev);
 	struct mxr_resources *res = &mdev->res;
-	mxr_dbg(mdev, "suspend - start\n");
+	dev_dbg(mdev->dev, "suspend - start\n");
 	mutex_lock(&mdev->mutex);
 	/* turn clocks off */
 	clk_disable(res->sclk_mixer);
 	clk_disable(res->vp);
 	clk_disable(res->mixer);
 	mutex_unlock(&mdev->mutex);
-	mxr_dbg(mdev, "suspend - finished\n");
+	dev_dbg(mdev->dev, "suspend - finished\n");
 	return 0;
 }
 
@@ -391,7 +391,6 @@ static int mxr_probe(struct platform_device *pdev)
 	struct mxr_device *mdev;
 	int ret;
 
-	/* mdev does not exist yet so no mxr_dbg is used */
 	dev_info(dev, "probe start\n");
 
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
@@ -426,7 +425,7 @@ static int mxr_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	mxr_info(mdev, "probe successful\n");
+	dev_info(mdev->dev, "probe successful\n");
 	return 0;
 
 fail_video:
diff --git a/drivers/media/platform/s5p-tv/mixer_grp_layer.c b/drivers/media/platform/s5p-tv/mixer_grp_layer.c
index b93a21f..24a2355 100644
--- a/drivers/media/platform/s5p-tv/mixer_grp_layer.c
+++ b/drivers/media/platform/s5p-tv/mixer_grp_layer.c
@@ -248,7 +248,7 @@ struct mxr_layer *mxr_graph_layer_create(struct mxr_device *mdev, int idx)
 
 	layer = mxr_base_layer_create(mdev, idx, name, &ops);
 	if (layer == NULL) {
-		mxr_err(mdev, "failed to initialize layer(%d) base\n", idx);
+		dev_err(mdev->dev, "failed to initialize layer(%d) base\n", idx);
 		goto fail;
 	}
 
diff --git a/drivers/media/platform/s5p-tv/mixer_reg.c b/drivers/media/platform/s5p-tv/mixer_reg.c
index b713403..37b0221 100644
--- a/drivers/media/platform/s5p-tv/mixer_reg.c
+++ b/drivers/media/platform/s5p-tv/mixer_reg.c
@@ -368,7 +368,7 @@ int mxr_reg_wait4vsync(struct mxr_device *mdev)
 		return 0;
 	if (ret < 0)
 		return ret;
-	mxr_warn(mdev, "no vsync detected - timeout\n");
+	dev_warn(mdev->dev, "no vsync detected - timeout\n");
 	return -ETIME;
 }
 
@@ -481,7 +481,7 @@ static void mxr_reg_mxr_dump(struct mxr_device *mdev)
 {
 #define DUMPREG(reg_id) \
 do { \
-	mxr_dbg(mdev, #reg_id " = %08x\n", \
+	dev_dbg(mdev->dev, #reg_id " = %08x\n", \
 		(u32)readl(mdev->res.mxr_regs + reg_id)); \
 } while (0)
 
@@ -513,7 +513,7 @@ static void mxr_reg_vp_dump(struct mxr_device *mdev)
 {
 #define DUMPREG(reg_id) \
 do { \
-	mxr_dbg(mdev, #reg_id " = %08x\n", \
+	dev_dbg(mdev->dev, #reg_id " = %08x\n", \
 		(u32) readl(mdev->res.vp_regs + reg_id)); \
 } while (0)
 
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 641b1f0..726bdcb 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -42,20 +42,20 @@ static struct v4l2_subdev *find_and_register_subdev(
 	/* TODO: add waiting until probe is finished */
 	drv = driver_find(module_name, &platform_bus_type);
 	if (!drv) {
-		mxr_warn(mdev, "module %s is missing\n", module_name);
+		dev_warn(mdev->dev, "module %s is missing\n", module_name);
 		return NULL;
 	}
 	/* driver refcnt is increased, it is safe to iterate over devices */
 	ret = driver_for_each_device(drv, NULL, &sd, find_reg_callback);
 	/* ret == 0 means that find_reg_callback was never executed */
 	if (sd == NULL) {
-		mxr_warn(mdev, "module %s provides no subdev!\n", module_name);
+		dev_warn(mdev->dev, "module %s provides no subdev!\n", module_name);
 		goto done;
 	}
 	/* v4l2_device_register_subdev detects if sd is NULL */
 	ret = v4l2_device_register_subdev(&mdev->v4l2_dev, sd);
 	if (ret) {
-		mxr_warn(mdev, "failed to register subdev %s\n", sd->name);
+		dev_warn(mdev->dev, "failed to register subdev %s\n", sd->name);
 		sd = NULL;
 	}
 
@@ -76,13 +76,13 @@ int mxr_acquire_video(struct mxr_device *mdev,
 	/* prepare context for V4L2 device */
 	ret = v4l2_device_register(dev, v4l2_dev);
 	if (ret) {
-		mxr_err(mdev, "could not register v4l2 device.\n");
+		dev_err(mdev->dev, "could not register v4l2 device.\n");
 		goto fail;
 	}
 
 	mdev->alloc_ctx = vb2_dma_contig_init_ctx(mdev->dev);
 	if (IS_ERR(mdev->alloc_ctx)) {
-		mxr_err(mdev, "could not acquire vb2 allocator\n");
+		dev_err(mdev->dev, "could not acquire vb2 allocator\n");
 		ret = PTR_ERR(mdev->alloc_ctx);
 		goto fail_v4l2_dev;
 	}
@@ -99,7 +99,7 @@ int mxr_acquire_video(struct mxr_device *mdev,
 			continue;
 		out = kzalloc(sizeof(*out), GFP_KERNEL);
 		if (out == NULL) {
-			mxr_err(mdev, "no memory for '%s'\n",
+			dev_err(mdev->dev, "no memory for '%s'\n",
 				conf->output_name);
 			ret = -ENOMEM;
 			/* registered subdevs are removed in fail_v4l2_dev */
@@ -109,7 +109,7 @@ int mxr_acquire_video(struct mxr_device *mdev,
 		out->sd = sd;
 		out->cookie = conf->cookie;
 		mdev->output[mdev->output_cnt++] = out;
-		mxr_info(mdev, "added output '%s' from module '%s'\n",
+		dev_info(mdev->dev, "added output '%s' from module '%s'\n",
 			conf->output_name, conf->module_name);
 		/* checking if maximal number of outputs is reached */
 		if (mdev->output_cnt >= MXR_MAX_OUTPUTS)
@@ -117,7 +117,7 @@ int mxr_acquire_video(struct mxr_device *mdev,
 	}
 
 	if (mdev->output_cnt == 0) {
-		mxr_err(mdev, "failed to register any output\n");
+		dev_err(mdev->dev, "failed to register any output\n");
 		ret = -ENODEV;
 		/* skipping fail_output because there is nothing to free */
 		goto fail_vb2_allocator;
@@ -160,7 +160,7 @@ static int mxr_querycap(struct file *file, void *priv,
 {
 	struct mxr_layer *layer = video_drvdata(file);
 
-	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	dev_dbg(layer->mdev->dev, "%s:%d\n", __func__, __LINE__);
 
 	strlcpy(cap->driver, MXR_DRIVER_NAME, sizeof(cap->driver));
 	strlcpy(cap->card, layer->vfd.name, sizeof(cap->card));
@@ -173,19 +173,19 @@ static int mxr_querycap(struct file *file, void *priv,
 
 static void mxr_geometry_dump(struct mxr_device *mdev, struct mxr_geometry *geo)
 {
-	mxr_dbg(mdev, "src.full_size = (%u, %u)\n",
+	dev_dbg(mdev->dev, "src.full_size = (%u, %u)\n",
 		geo->src.full_width, geo->src.full_height);
-	mxr_dbg(mdev, "src.size = (%u, %u)\n",
+	dev_dbg(mdev->dev, "src.size = (%u, %u)\n",
 		geo->src.width, geo->src.height);
-	mxr_dbg(mdev, "src.offset = (%u, %u)\n",
+	dev_dbg(mdev->dev, "src.offset = (%u, %u)\n",
 		geo->src.x_offset, geo->src.y_offset);
-	mxr_dbg(mdev, "dst.full_size = (%u, %u)\n",
+	dev_dbg(mdev->dev, "dst.full_size = (%u, %u)\n",
 		geo->dst.full_width, geo->dst.full_height);
-	mxr_dbg(mdev, "dst.size = (%u, %u)\n",
+	dev_dbg(mdev->dev, "dst.size = (%u, %u)\n",
 		geo->dst.width, geo->dst.height);
-	mxr_dbg(mdev, "dst.offset = (%u, %u)\n",
+	dev_dbg(mdev->dev, "dst.offset = (%u, %u)\n",
 		geo->dst.x_offset, geo->dst.y_offset);
-	mxr_dbg(mdev, "ratio = (%u, %u)\n",
+	dev_dbg(mdev->dev, "ratio = (%u, %u)\n",
 		geo->x_ratio, geo->y_ratio);
 }
 
@@ -245,7 +245,7 @@ static int mxr_enum_fmt(struct file *file, void  *priv,
 	struct mxr_device *mdev = layer->mdev;
 	const struct mxr_format *fmt;
 
-	mxr_dbg(mdev, "%s\n", __func__);
+	dev_dbg(mdev->dev, "%s\n", __func__);
 	fmt = find_format_by_index(layer, f->index);
 	if (fmt == NULL)
 		return -EINVAL;
@@ -300,7 +300,7 @@ static int mxr_g_fmt(struct file *file, void *priv,
 	struct mxr_layer *layer = video_drvdata(file);
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
 
-	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	dev_dbg(layer->mdev->dev, "%s:%d\n", __func__, __LINE__);
 
 	pix->width = layer->geo.src.full_width;
 	pix->height = layer->geo.src.full_height;
@@ -321,12 +321,12 @@ static int mxr_s_fmt(struct file *file, void *priv,
 	struct mxr_device *mdev = layer->mdev;
 	struct mxr_geometry *geo = &layer->geo;
 
-	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+	dev_dbg(mdev->dev, "%s:%d\n", __func__, __LINE__);
 
 	pix = &f->fmt.pix_mp;
 	fmt = find_format_by_fourcc(layer, pix->pixelformat);
 	if (fmt == NULL) {
-		mxr_warn(mdev, "not recognized fourcc: %08x\n",
+		dev_warn(mdev->dev, "not recognized fourcc: %08x\n",
 			pix->pixelformat);
 		return -EINVAL;
 	}
@@ -362,7 +362,7 @@ static int mxr_g_selection(struct file *file, void *fh,
 	struct mxr_layer *layer = video_drvdata(file);
 	struct mxr_geometry *geo = &layer->geo;
 
-	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	dev_dbg(layer->mdev->dev, "%s:%d\n", __func__, __LINE__);
 
 	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
 		s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
@@ -429,7 +429,7 @@ static int mxr_s_selection(struct file *file, void *fh,
 
 	memset(&res, 0, sizeof(res));
 
-	mxr_dbg(layer->mdev, "%s: rect: %dx%d@%d,%d\n", __func__,
+	dev_dbg(layer->mdev->dev, "%s: rect: %dx%d@%d,%d\n", __func__,
 		s->r.width, s->r.height, s->r.left, s->r.top);
 
 	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
@@ -664,7 +664,7 @@ static int mxr_s_output(struct file *file, void *fh, unsigned int i)
 	/* update layers geometry */
 	mxr_layer_update_output(layer);
 
-	mxr_dbg(mdev, "tvnorms = %08llx\n", vfd->tvnorms);
+	dev_dbg(mdev->dev, "tvnorms = %08llx\n", vfd->tvnorms);
 
 	return 0;
 }
@@ -686,7 +686,7 @@ static int mxr_reqbufs(struct file *file, void *priv,
 {
 	struct mxr_layer *layer = video_drvdata(file);
 
-	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	dev_dbg(layer->mdev->dev, "%s:%d\n", __func__, __LINE__);
 	return vb2_reqbufs(&layer->vb_queue, p);
 }
 
@@ -694,7 +694,7 @@ static int mxr_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
 	struct mxr_layer *layer = video_drvdata(file);
 
-	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	dev_dbg(layer->mdev->dev, "%s:%d\n", __func__, __LINE__);
 	return vb2_querybuf(&layer->vb_queue, p);
 }
 
@@ -702,7 +702,7 @@ static int mxr_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
 	struct mxr_layer *layer = video_drvdata(file);
 
-	mxr_dbg(layer->mdev, "%s:%d(%d)\n", __func__, __LINE__, p->index);
+	dev_dbg(layer->mdev->dev, "%s:%d(%d)\n", __func__, __LINE__, p->index);
 	return vb2_qbuf(&layer->vb_queue, p);
 }
 
@@ -710,7 +710,7 @@ static int mxr_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
 	struct mxr_layer *layer = video_drvdata(file);
 
-	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	dev_dbg(layer->mdev->dev, "%s:%d\n", __func__, __LINE__);
 	return vb2_dqbuf(&layer->vb_queue, p, file->f_flags & O_NONBLOCK);
 }
 
@@ -719,7 +719,7 @@ static int mxr_expbuf(struct file *file, void *priv,
 {
 	struct mxr_layer *layer = video_drvdata(file);
 
-	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	dev_dbg(layer->mdev->dev, "%s:%d\n", __func__, __LINE__);
 	return vb2_expbuf(&layer->vb_queue, eb);
 }
 
@@ -727,7 +727,7 @@ static int mxr_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct mxr_layer *layer = video_drvdata(file);
 
-	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	dev_dbg(layer->mdev->dev, "%s:%d\n", __func__, __LINE__);
 	return vb2_streamon(&layer->vb_queue, i);
 }
 
@@ -735,7 +735,7 @@ static int mxr_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct mxr_layer *layer = video_drvdata(file);
 
-	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	dev_dbg(layer->mdev->dev, "%s:%d\n", __func__, __LINE__);
 	return vb2_streamoff(&layer->vb_queue, i);
 }
 
@@ -777,7 +777,7 @@ static int mxr_video_open(struct file *file)
 	struct mxr_device *mdev = layer->mdev;
 	int ret = 0;
 
-	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+	dev_dbg(mdev->dev, "%s:%d\n", __func__, __LINE__);
 	if (mutex_lock_interruptible(&layer->mutex))
 		return -ERESTARTSYS;
 	/* assure device probe is finished */
@@ -785,7 +785,7 @@ static int mxr_video_open(struct file *file)
 	/* creating context for file descriptor */
 	ret = v4l2_fh_open(file);
 	if (ret) {
-		mxr_err(mdev, "v4l2_fh_open failed\n");
+		dev_err(mdev->dev, "v4l2_fh_open failed\n");
 		goto unlock;
 	}
 
@@ -796,13 +796,13 @@ static int mxr_video_open(struct file *file)
 	/* FIXME: should power be enabled on open? */
 	ret = mxr_power_get(mdev);
 	if (ret) {
-		mxr_err(mdev, "power on failed\n");
+		dev_err(mdev->dev, "power on failed\n");
 		goto fail_fh_open;
 	}
 
 	ret = vb2_queue_init(&layer->vb_queue);
 	if (ret != 0) {
-		mxr_err(mdev, "failed to initialize vb2 queue\n");
+		dev_err(mdev->dev, "failed to initialize vb2 queue\n");
 		goto fail_power;
 	}
 	/* set default format, first on the list */
@@ -831,7 +831,7 @@ mxr_video_poll(struct file *file, struct poll_table_struct *wait)
 	struct mxr_layer *layer = video_drvdata(file);
 	unsigned int res;
 
-	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	dev_dbg(layer->mdev->dev, "%s:%d\n", __func__, __LINE__);
 
 	mutex_lock(&layer->mutex);
 	res = vb2_poll(&layer->vb_queue, file, wait);
@@ -844,7 +844,7 @@ static int mxr_video_mmap(struct file *file, struct vm_area_struct *vma)
 	struct mxr_layer *layer = video_drvdata(file);
 	int ret;
 
-	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	dev_dbg(layer->mdev->dev, "%s:%d\n", __func__, __LINE__);
 
 	if (mutex_lock_interruptible(&layer->mutex))
 		return -ERESTARTSYS;
@@ -857,7 +857,7 @@ static int mxr_video_release(struct file *file)
 {
 	struct mxr_layer *layer = video_drvdata(file);
 
-	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	dev_dbg(layer->mdev->dev, "%s:%d\n", __func__, __LINE__);
 	mutex_lock(&layer->mutex);
 	if (v4l2_fh_is_singular_file(file)) {
 		vb2_queue_release(&layer->vb_queue);
@@ -887,11 +887,11 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	struct mxr_device *mdev = layer->mdev;
 	struct v4l2_plane_pix_format planes[3];
 
-	mxr_dbg(mdev, "%s\n", __func__);
+	dev_dbg(mdev->dev, "%s\n", __func__);
 	/* checking if format was configured */
 	if (fmt == NULL)
 		return -EINVAL;
-	mxr_dbg(mdev, "fmt = %s\n", fmt->name);
+	dev_dbg(mdev->dev, "fmt = %s\n", fmt->name);
 	mxr_mplane_fill(planes, fmt, layer->geo.src.full_width,
 		layer->geo.src.full_height);
 
@@ -899,7 +899,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	for (i = 0; i < fmt->num_subframes; ++i) {
 		alloc_ctxs[i] = layer->mdev->alloc_ctx;
 		sizes[i] = planes[i].sizeimage;
-		mxr_dbg(mdev, "size[%d] = %08x\n", i, sizes[i]);
+		dev_dbg(mdev->dev, "size[%d] = %08x\n", i, sizes[i]);
 	}
 
 	if (*nbuffers == 0)
@@ -919,14 +919,14 @@ static void buf_queue(struct vb2_buffer *vb)
 	list_add_tail(&buffer->list, &layer->enq_list);
 	spin_unlock_irqrestore(&layer->enq_slock, flags);
 
-	mxr_dbg(mdev, "queuing buffer\n");
+	dev_dbg(mdev->dev, "queuing buffer\n");
 }
 
 static void wait_lock(struct vb2_queue *vq)
 {
 	struct mxr_layer *layer = vb2_get_drv_priv(vq);
 
-	mxr_dbg(layer->mdev, "%s\n", __func__);
+	dev_dbg(layer->mdev->dev, "%s\n", __func__);
 	mutex_lock(&layer->mutex);
 }
 
@@ -934,7 +934,7 @@ static void wait_unlock(struct vb2_queue *vq)
 {
 	struct mxr_layer *layer = vb2_get_drv_priv(vq);
 
-	mxr_dbg(layer->mdev, "%s\n", __func__);
+	dev_dbg(layer->mdev->dev, "%s\n", __func__);
 	mutex_unlock(&layer->mutex);
 }
 
@@ -944,10 +944,10 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct mxr_device *mdev = layer->mdev;
 	unsigned long flags;
 
-	mxr_dbg(mdev, "%s\n", __func__);
+	dev_dbg(mdev->dev, "%s\n", __func__);
 
 	if (count == 0) {
-		mxr_dbg(mdev, "no output buffers queued\n");
+		dev_dbg(mdev->dev, "no output buffers queued\n");
 		return -EINVAL;
 	}
 
@@ -973,7 +973,7 @@ static void mxr_watchdog(unsigned long arg)
 	struct mxr_device *mdev = layer->mdev;
 	unsigned long flags;
 
-	mxr_err(mdev, "watchdog fired for layer %s\n", layer->vfd.name);
+	dev_err(mdev->dev, "watchdog fired for layer %s\n", layer->vfd.name);
 
 	spin_lock_irqsave(&layer->enq_slock, flags);
 
@@ -998,7 +998,7 @@ static int stop_streaming(struct vb2_queue *vq)
 	struct timer_list watchdog;
 	struct mxr_buffer *buf, *buf_tmp;
 
-	mxr_dbg(mdev, "%s\n", __func__);
+	dev_dbg(mdev->dev, "%s\n", __func__);
 
 	spin_lock_irqsave(&layer->enq_slock, flags);
 
@@ -1056,9 +1056,9 @@ int mxr_base_layer_register(struct mxr_layer *layer)
 
 	ret = video_register_device(&layer->vfd, VFL_TYPE_GRABBER, -1);
 	if (ret)
-		mxr_err(mdev, "failed to register video device\n");
+		dev_err(mdev->dev, "failed to register video device\n");
 	else
-		mxr_info(mdev, "registered layer %s as /dev/video%d\n",
+		dev_info(mdev->dev, "registered layer %s as /dev/video%d\n",
 			layer->vfd.name, layer->vfd.num);
 	return ret;
 }
@@ -1091,7 +1091,7 @@ struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
 
 	layer = kzalloc(sizeof(*layer), GFP_KERNEL);
 	if (layer == NULL) {
-		mxr_err(mdev, "not enough memory for layer.\n");
+		dev_err(mdev->dev, "not enough memory for layer.\n");
 		goto fail;
 	}
 
diff --git a/drivers/media/platform/s5p-tv/mixer_vp_layer.c b/drivers/media/platform/s5p-tv/mixer_vp_layer.c
index 3d13a63..38b216e 100644
--- a/drivers/media/platform/s5p-tv/mixer_vp_layer.c
+++ b/drivers/media/platform/s5p-tv/mixer_vp_layer.c
@@ -219,7 +219,7 @@ struct mxr_layer *mxr_vp_layer_create(struct mxr_device *mdev, int idx)
 
 	layer = mxr_base_layer_create(mdev, idx, name, &ops);
 	if (layer == NULL) {
-		mxr_err(mdev, "failed to initialize layer(%d) base\n", idx);
+		dev_err(mdev->dev, "failed to initialize layer(%d) base\n", idx);
 		goto fail;
 	}
 
-- 
1.8.1.2

