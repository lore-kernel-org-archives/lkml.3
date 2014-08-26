Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbaHZMOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:14:02 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33892 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbaHZMN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:13:56 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-08-53fc7a019520
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 5/7] media: s5p-mfc: replace custom reserved memory init code
 with generic one
Date: Tue, 26 Aug 2014 14:09:46 +0200
Message-id: <1409054988-32758-6-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
References: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xa7qMVX+CDX7+Yrf4O+kYu8WBPzsY
	LVZ2N7NZ7Fz3jtHibNMbdovtnTPYLb5cechksenxNVaLy7vmsFn0bNjKajHj/D4mi7VH7rJb
	LDjewmqxfsZrFgc+j9+/JjF6XO7rZfLoenuFyePOtT1sHpuX1Hvc/veY2WPdn1dMHn1bVjF6
	fN4kF8AZxWWTkpqTWZZapG+XwJUxc2VowTu1iidHdrA3MB5W6GLk5JAQMJE43jiPEcIWk7hw
	bz1bFyMXh5DAUkaJxf0PoJw+JolNN0+DVbEJGEp0ve1iA7FFBLIlfnybzAJiMwssZZaYN0sK
	xBYWSJC4OKWVFcRmEVCVWHG8kQnE5hXwkDiz5BIzxDY5if8vVwDFOTg4BTwlzk2pBgkLAZVs
	nP6eZQIj7wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIeH7dQfj0mNWhxgFOBiVeHgf
	pP0OFmJNLCuuzD3EKMHBrCTC+yPpT7AQb0piZVVqUX58UWlOavEhRiYOTqkGxvPbnYL+ilmx
	LZ5sXhEovs9/iZHnu7MJn659172+4FXl5GNf1p35YdL2W0r/V7rUssTa+JyFldGflS6U/Wt1
	eHZ+5cT7K/6cOsP98+LWM7/9xOoe7bQU4Zg2e+26WxuOy6eLNOptenhwj1Nky+1JrAZ9c8t/
	R3I/jVzzumXLfG0mnfLey5zfVOKVWIozEg21mIuKEwH3avdHPQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes custom initialization of reserved memory regions from
s5p-mfc driver and adds a new code for handling reserved memory with
generic named reserved memory regions read from device tree.

s5p-mfc driver now handles two reserved memory regions: "left" and
"right", defined by generic reserved memory bindings. Support for non-dt
platform has been removed, because all supported platforms have been
converted to device tree.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 102 +++++++++++--------------------
 1 file changed, 35 insertions(+), 67 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index d35b0418ab37..668e82247a3f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -22,6 +22,7 @@
 #include <media/v4l2-event.h>
 #include <linux/workqueue.h>
 #include <linux/of.h>
+#include <linux/of_reserved_mem.h>
 #include <media/videobuf2-core.h>
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_ctrl.h"
@@ -996,55 +997,40 @@ static const struct v4l2_file_operations s5p_mfc_fops = {
 	.mmap = s5p_mfc_mmap,
 };
 
-static int match_child(struct device *dev, void *data)
+static struct device *s5p_mfc_alloc_memdev(struct device *dev, const char *name)
 {
-	if (!dev_name(dev))
-		return 0;
-	return !strcmp(dev_name(dev), (char *)data);
-}
-
-static void *mfc_get_drv_data(struct platform_device *pdev);
-
-static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
-{
-	unsigned int mem_info[2] = { };
+	struct device *child;
+	int ret;
 
-	dev->mem_dev_l = devm_kzalloc(&dev->plat_dev->dev,
-			sizeof(struct device), GFP_KERNEL);
-	if (!dev->mem_dev_l) {
-		mfc_err("Not enough memory\n");
-		return -ENOMEM;
-	}
-	device_initialize(dev->mem_dev_l);
-	of_property_read_u32_array(dev->plat_dev->dev.of_node,
-			"samsung,mfc-l", mem_info, 2);
-	if (dma_declare_coherent_memory(dev->mem_dev_l, mem_info[0],
-				mem_info[0], mem_info[1],
-				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0) {
-		mfc_err("Failed to declare coherent memory for\n"
-		"MFC device\n");
-		return -ENOMEM;
+	child = devm_kzalloc(dev, sizeof(struct device), GFP_KERNEL);
+	if (!child)
+		return NULL;
+
+	device_initialize(child);
+	dev_set_name(child, "%s:%s", dev_name(dev), name);
+	child->parent = dev;
+	child->bus = dev->bus;
+	child->coherent_dma_mask = dev->coherent_dma_mask;
+	child->dma_mask = dev->dma_mask;
+
+	if (device_add(child) == 0) {
+		ret = of_reserved_mem_device_init(child);
+		if (ret == 0)
+			return child;
 	}
 
-	dev->mem_dev_r = devm_kzalloc(&dev->plat_dev->dev,
-			sizeof(struct device), GFP_KERNEL);
-	if (!dev->mem_dev_r) {
-		mfc_err("Not enough memory\n");
-		return -ENOMEM;
-	}
-	device_initialize(dev->mem_dev_r);
-	of_property_read_u32_array(dev->plat_dev->dev.of_node,
-			"samsung,mfc-r", mem_info, 2);
-	if (dma_declare_coherent_memory(dev->mem_dev_r, mem_info[0],
-				mem_info[0], mem_info[1],
-				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0) {
-		pr_err("Failed to declare coherent memory for\n"
-		"MFC device\n");
-		return -ENOMEM;
-	}
-	return 0;
+	put_device(child);
+	return NULL;
 }
 
+void s5p_mfc_free_memdev(struct device *dev)
+{
+	of_reserved_mem_device_release(dev);
+	put_device(dev);
+}
+
+static void *mfc_get_drv_data(struct platform_device *pdev);
+
 /* MFC probe function */
 static int s5p_mfc_probe(struct platform_device *pdev)
 {
@@ -1096,26 +1082,8 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		goto err_res;
 	}
 
-	if (pdev->dev.of_node) {
-		ret = s5p_mfc_alloc_memdevs(dev);
-		if (ret < 0)
-			goto err_res;
-	} else {
-		dev->mem_dev_l = device_find_child(&dev->plat_dev->dev,
-				"s5p-mfc-l", match_child);
-		if (!dev->mem_dev_l) {
-			mfc_err("Mem child (L) device get failed\n");
-			ret = -ENODEV;
-			goto err_res;
-		}
-		dev->mem_dev_r = device_find_child(&dev->plat_dev->dev,
-				"s5p-mfc-r", match_child);
-		if (!dev->mem_dev_r) {
-			mfc_err("Mem child (R) device get failed\n");
-			ret = -ENODEV;
-			goto err_res;
-		}
-	}
+	dev->mem_dev_l = s5p_mfc_alloc_memdev(&dev->plat_dev->dev, "left");
+	dev->mem_dev_r = s5p_mfc_alloc_memdev(&dev->plat_dev->dev, "right");
 
 	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l);
 	if (IS_ERR(dev->alloc_ctx[0])) {
@@ -1246,10 +1214,10 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 	s5p_mfc_release_firmware(dev);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
-	if (pdev->dev.of_node) {
-		put_device(dev->mem_dev_l);
-		put_device(dev->mem_dev_r);
-	}
+	if (dev->mem_dev_l)
+		s5p_mfc_free_memdev(dev->mem_dev_l);
+	if (dev->mem_dev_r)
+		s5p_mfc_free_memdev(dev->mem_dev_r);
 
 	s5p_mfc_final_pm(dev);
 	return 0;
-- 
1.9.2

