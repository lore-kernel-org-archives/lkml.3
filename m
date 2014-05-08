Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbaEHRgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:36:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58321 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbaEHRgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:36:09 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-2c-536bc088e43e
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH V2 2/4] exynos4-is: Move firmware request to subdev open()
Date: Thu, 08 May 2014 19:35:16 +0200
Message-id: <1399570516-29782-2-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399570516-29782-1-git-send-email-s.nawrocki@samsung.com>
References: <1399570516-29782-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e+xgG7Hgexgg1XHpCzmHznHanG26Q27
	xabH11gtLu+aw2bRs2Erq8XhN+2sDmwem5fUe/RtWcXo8XmTXABzFJdNSmpOZllqkb5dAldG
	y4czzAVztSq+r+tkbWCcodzFyMkhIWAi8eHBZhYIW0ziwr31bF2MXBxCAosYJdbe2cAI4XQw
	STxYvgusik3AUKL3aB8jiC0iIC/xpPcGWAezwDpGiV/z+plBEsICXhLbf/9hA7FZBFQlLq/t
	ZgexeQXcJC4tmQEU5wBapyAxZ5INiMkp4C4xY2YiSIUQUMXa+2fYJjDyLmBkWMUomlqQXFCc
	lJ5rqFecmFtcmpeul5yfu4kRHDTPpHYwrmywOMQowMGoxMP7Ykp2sBBrYllxZe4hRgkOZiUR
	3hfLgEK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoYzbas
	nlR9RmTWea69qj8Nyn6ItTE7hO51unZX7JrFoX0ypWKJd3i5v080EpKfNe/IstTq436RkjsD
	VecLxxocU4jzXnrr7LHLhbe9m/YsX7dg5qJF+8tPWz348EZQoyFaXWNl3KkbeyMXO3t8XX7e
	7o5af2hefZ6v97R3rt94SxczbprEsen6ASWW4oxEQy3mouJEAOiTRpYWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the firmware request to the FIMC-IS-ISP subdev open callback
so we can avoid crashed on error paths in probe and deferred probing,
when firmware request was sheduled and is in progress while the
fimc-is device is being unregistered and its driver detached.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c  |   31 ++++++++------------------
 drivers/media/platform/exynos4-is/fimc-is.h  |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp.c |   10 ++++++++-
 3 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 5476dce..6bbb6ca 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -374,22 +374,22 @@ static void fimc_is_free_cpu_memory(struct fimc_is *is)
 			  is->memory.paddr);
 }
 
-static void fimc_is_load_firmware(const struct firmware *fw, void *context)
+int fimc_is_request_firmware(struct fimc_is *is, const char *fw_name)
 {
-	struct fimc_is *is = context;
+	const struct firmware *fw;
 	struct device *dev = &is->pdev->dev;
 	void *buf;
 	int ret;
 
-	if (fw == NULL) {
+	ret = request_firmware(&fw, fw_name, &is->pdev->dev);
+	if (ret < 0) {
 		dev_err(dev, "firmware request failed\n");
-		return;
+		return ret;
 	}
-	mutex_lock(&is->lock);
 
 	if (fw->size < FIMC_IS_FW_SIZE_MIN || fw->size > FIMC_IS_FW_SIZE_MAX) {
 		dev_err(dev, "wrong firmware size: %d\n", fw->size);
-		goto done;
+		return -EINVAL;
 	}
 
 	is->fw.size = fw->size;
@@ -397,7 +397,7 @@ static void fimc_is_load_firmware(const struct firmware *fw, void *context)
 	ret = fimc_is_alloc_cpu_memory(is);
 	if (ret < 0) {
 		dev_err(dev, "failed to allocate FIMC-IS CPU memory\n");
-		goto done;
+		return -ENOMEM;
 	}
 
 	memcpy(is->memory.vaddr, fw->data, fw->size);
@@ -430,16 +430,9 @@ static void fimc_is_load_firmware(const struct firmware *fw, void *context)
 	 */
 	if (is->fw.f_w)
 		release_firmware(is->fw.f_w);
-	is->fw.f_w = fw;
-done:
-	mutex_unlock(&is->lock);
-}
 
-static int fimc_is_request_firmware(struct fimc_is *is, const char *fw_name)
-{
-	return request_firmware_nowait(THIS_MODULE,
-				FW_ACTION_HOTPLUG, fw_name, &is->pdev->dev,
-				GFP_KERNEL, is, fimc_is_load_firmware);
+	is->fw.f_w = fw;
+	return 0;
 }
 
 /* General IS interrupt handler */
@@ -795,7 +788,6 @@ static int fimc_is_probe(struct platform_device *pdev)
 
 	init_waitqueue_head(&is->irq_queue);
 	spin_lock_init(&is->slock);
-	mutex_init(&is->lock);
 
 	ret = of_address_to_resource(dev->of_node, 0, &res);
 	if (ret < 0)
@@ -859,17 +851,12 @@ static int fimc_is_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_sd;
 
-	ret = fimc_is_request_firmware(is, FIMC_IS_FW_FILENAME);
-	if (ret < 0)
-		goto err_dfs;
 
 	pm_runtime_put_sync(dev);
 
 	dev_dbg(dev, "FIMC-IS registered successfully\n");
 	return 0;
 
-err_dfs:
-	fimc_is_debugfs_remove(is);
 err_sd:
 	fimc_is_unregister_subdevs(is);
 err_vb:
diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
index e0be691..16afd9c 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.h
+++ b/drivers/media/platform/exynos4-is/fimc-is.h
@@ -234,7 +234,6 @@ struct chain_config {
  * @pctrl: pointer to pinctrl structure for this device
  * @v4l2_dev: pointer to top the level v4l2_device
  * @alloc_ctx: videobuf2 memory allocator context
- * @lock: mutex serializing video device and the subdev operations
  * @slock: spinlock protecting this data structure and the hw registers
  * @clocks: FIMC-LITE gate clock
  * @regs: MCUCTL mmapped registers region
@@ -336,6 +335,7 @@ static inline u32 pmuisp_read(struct fimc_is *is, unsigned int offset)
 
 int fimc_is_wait_event(struct fimc_is *is, unsigned long bit,
 		       unsigned int state, unsigned int timeout);
+int fimc_is_request_firmware(struct fimc_is *is, const char *fw_name);
 int fimc_is_cpu_set_power(struct fimc_is *is, int on);
 int fimc_is_start_firmware(struct fimc_is *is);
 int fimc_is_hw_initialize(struct fimc_is *is);
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index be62d6b..915c46b 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -366,8 +366,11 @@ static int fimc_isp_subdev_s_power(struct v4l2_subdev *sd, int on)
 static int fimc_isp_subdev_open(struct v4l2_subdev *sd,
 				struct v4l2_subdev_fh *fh)
 {
+	struct fimc_isp *isp = v4l2_get_subdevdata(sd);
+	struct fimc_is *is = fimc_isp_to_is(isp);
 	struct v4l2_mbus_framefmt fmt;
 	struct v4l2_mbus_framefmt *format;
+	int ret;
 
 	format = v4l2_subdev_get_try_format(fh, FIMC_ISP_SD_PAD_SINK);
 
@@ -386,7 +389,12 @@ static int fimc_isp_subdev_open(struct v4l2_subdev *sd,
 	format = v4l2_subdev_get_try_format(fh, FIMC_ISP_SD_PAD_SRC_DMA);
 	*format = fmt;
 
-	return 0;
+	mutex_lock(&isp->subdev_lock);
+	if (is->fw.f_w == NULL)
+		ret = fimc_is_request_firmware(is, FIMC_IS_FW_FILENAME);
+
+	mutex_unlock(&isp->subdev_lock);
+	return ret;
 }
 
 static int fimc_isp_subdev_registered(struct v4l2_subdev *sd)
-- 
1.7.9.5

