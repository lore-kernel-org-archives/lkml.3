Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaHEKxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:53:24 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52885 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbaHEKtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:02 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-c1-53e0b69c058c
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 13/29] temporary: media: s5p-mfc: remove DT hacks &
 initialization custom memory init code
Date: Tue, 05 Aug 2014 12:47:41 +0200
Message-id: <1407235677-26324-14-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7pztj0INvjVKGzxd9IxdovmxevZ
	LCbdn8BisWC/tUXn7A3sFr0LrrJZnG16w27ROXEJu8WXKw+ZLDY9vsZqcXnXHDaLGef3MVms
	PXKX3eLU9c9sFv96DzJanDl9idXi/54d7BaH37SzWhx5uJvdYtWuP4wWt3/zOYh6PDk4j8nj
	969JjB47Z91l95jdMZPVY9OqTjaP/XPXsHtsXlLvcfvfY2aPyTeWM3pcOdHE6tHb/I7NY8vV
	dhaPvi2rGD0+b5IL4IvisklJzcksSy3St0vgyji9YzZrwRbpiobtExkbGJ+IdTFyckgImEic
	/D6RGcIWk7hwbz1bFyMXh5DAUkaJqf8fs0I4fUwSl7d9ZAGpYhMwlOh62wVWJSLQyyjR3/SD
	CcRhFljHKrG/9zpYlbBAjsSHfU1gc1kEVCX27D4EZvMKeErc+zGHDWKfnMT/lyuYQGxOoPjh
	mwdYQWwhAQ+JnxvWsE9g5F3AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyR2vuxgXHzM
	6hCjAAejEg+vwem7wUKsiWXFlbmHGCU4mJVEeCXWPAgW4k1JrKxKLcqPLyrNSS0+xMjEwSnV
	wFh5Sf4Sy4lEVU5bg+ibmjo+3Fb/nJUNNZs6eL5NPGq+ar+CTvjb6mlN0/YZNDikci07fb+0
	/ord/+j2r8FCgZyLKxIcVzNPMAh9N+ujpeqzOe/cFhi84pxxbFH7MZl1qzZNnRC0VYf79Mnu
	vIem8q7iP9eLOiekr5NbKX0gVztNkWm2b9v8SCWW4oxEQy3mouJEAEoc1uV7AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes custom initialization of reserved memory regions from
s5p-mfc driver. Driver will use main device pointer for all memory allocations.

This patch is temporary, do not merge it yet.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 73 +-------------------------------
 1 file changed, 2 insertions(+), 71 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index d35b041..77b99ae 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -996,55 +996,8 @@ static const struct v4l2_file_operations s5p_mfc_fops = {
 	.mmap = s5p_mfc_mmap,
 };
 
-static int match_child(struct device *dev, void *data)
-{
-	if (!dev_name(dev))
-		return 0;
-	return !strcmp(dev_name(dev), (char *)data);
-}
-
 static void *mfc_get_drv_data(struct platform_device *pdev);
 
-static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
-{
-	unsigned int mem_info[2] = { };
-
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
-	}
-
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
-}
-
 /* MFC probe function */
 static int s5p_mfc_probe(struct platform_device *pdev)
 {
@@ -1096,26 +1049,8 @@ static int s5p_mfc_probe(struct platform_device *pdev)
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
+	dev->mem_dev_l = &dev->plat_dev->dev;
+	dev->mem_dev_r = &dev->plat_dev->dev;
 
 	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l);
 	if (IS_ERR(dev->alloc_ctx[0])) {
@@ -1246,10 +1181,6 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 	s5p_mfc_release_firmware(dev);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
-	if (pdev->dev.of_node) {
-		put_device(dev->mem_dev_l);
-		put_device(dev->mem_dev_r);
-	}
 
 	s5p_mfc_final_pm(dev);
 	return 0;
-- 
1.9.2

