Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaJOLBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 07:01:53 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59929 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaJOLBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 07:01:52 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-82-543e541d2cfa
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH v4] drivers: of: add return value to of_reserved_mem_device_init
Date: Wed, 15 Oct 2014 13:01:42 +0200
Message-id: <1413370902-28187-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <13963062.ORRNOhrvYD@wuerfel>
References: <13963062.ORRNOhrvYD@wuerfel>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t/xa7qyIXYhBktnSFjMWb+GzeLvpGPs
	Fgf+7GC0WNndzGaxc907RouzTW/YLbZ3zmC3+HLlIZPFpsfXWC0u75rDZrH2yF12iwXHW1gt
	Nn94yWaxde9Vdgc+j5bmHjaP378mMXo03rjB5nG5r5fJo+vtFSaPO9f2sHmcmPGbxWPzknqP
	2/8eM3us+/OKyaNvyypGj8+b5AJ4orhsUlJzMstSi/TtErgyli9/yF4wTbbiwOS6BsZTEl2M
	nBwSAiYSc9YdZYOwxSQu3FsPZHNxCAksZZTY9OUJM4TTxySxdNtSRpAqNgFDia63XWAdIgJu
	Ev/WHQLrYBZ4wyyx+sB/IIeDQ1ggQGLlZR+QGhYBVYmDS9+B9fIKeEgcnn+OCWKbnMT/lyvA
	bE4BLYmFm0+BzRQS0JSYc/YN4wRG3gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQsL7
	6w7GpcesDjEKcDAq8fByHLANEWJNLCuuzD3EKMHBrCTCm+hvFyLEm5JYWZValB9fVJqTWnyI
	kYmDU6qBke3ZLOlmG+7u9hBOs52XFZ63HV3ouVRtL9OJ94r7+KruVaXvuXSN0Ty7pXm6sWOk
	2wmt/J9rd5rpMZaHneEyFf4RmN9c8GHfsTW8PvpHD07/EPujZk/rOubWiNSqQPcDp9iNGcue
	Hrg+x9bgwgXd3PiAkg11BT3f92Y6uj5r+84rXW5XMDVPiaU4I9FQi7moOBEAq/TeBE0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver calling of_reserved_mem_device_init() might be interested if the
initialization has been successful or not, so add support for returning
error code.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
This patch fixes build warining caused by commit
7bfa5ab6fa1b18f53fb94f922e107e6fbdc5e485 ("drivers: dma-coherent: add
initialization from device tree"), which has been merged without this
change and without fixing function return value.
---
 drivers/base/dma-contiguous.c   |  3 ++-
 drivers/of/of_reserved_mem.c    | 14 +++++++++-----
 include/linux/of_reserved_mem.h |  9 ++++++---
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 473ff4892401..950fff9ce453 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -223,9 +223,10 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 #undef pr_fmt
 #define pr_fmt(fmt) fmt
 
-static void rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
+static int rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
 {
 	dev_set_cma_area(dev, rmem->priv);
+	return 0;
 }
 
 static void rmem_cma_device_release(struct reserved_mem *rmem,
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 59fb12e84e6b..dc566b38645f 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -243,23 +243,27 @@ static inline struct reserved_mem *__find_rmem(struct device_node *node)
  * This function assign memory region pointed by "memory-region" device tree
  * property to the given device.
  */
-void of_reserved_mem_device_init(struct device *dev)
+int of_reserved_mem_device_init(struct device *dev)
 {
 	struct reserved_mem *rmem;
 	struct device_node *np;
+	int ret;
 
 	np = of_parse_phandle(dev->of_node, "memory-region", 0);
 	if (!np)
-		return;
+		return -ENODEV;
 
 	rmem = __find_rmem(np);
 	of_node_put(np);
 
 	if (!rmem || !rmem->ops || !rmem->ops->device_init)
-		return;
+		return -EINVAL;
+
+	ret = rmem->ops->device_init(rmem, dev);
+	if (ret == 0)
+		dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
 
-	rmem->ops->device_init(rmem, dev);
-	dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
+	return ret;
 }
 
 /**
diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index 5b5efae09135..ad2f67054372 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -16,7 +16,7 @@ struct reserved_mem {
 };
 
 struct reserved_mem_ops {
-	void	(*device_init)(struct reserved_mem *rmem,
+	int	(*device_init)(struct reserved_mem *rmem,
 			       struct device *dev);
 	void	(*device_release)(struct reserved_mem *rmem,
 				  struct device *dev);
@@ -28,14 +28,17 @@ typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem);
 	_OF_DECLARE(reservedmem, name, compat, init, reservedmem_of_init_fn)
 
 #ifdef CONFIG_OF_RESERVED_MEM
-void of_reserved_mem_device_init(struct device *dev);
+int of_reserved_mem_device_init(struct device *dev);
 void of_reserved_mem_device_release(struct device *dev);
 
 void fdt_init_reserved_mem(void);
 void fdt_reserved_mem_save_node(unsigned long node, const char *uname,
 			       phys_addr_t base, phys_addr_t size);
 #else
-static inline void of_reserved_mem_device_init(struct device *dev) { }
+static inline int of_reserved_mem_device_init(struct device *dev)
+{
+	return -ENOSYS;
+}
 static inline void of_reserved_mem_device_release(struct device *pdev) { }
 
 static inline void fdt_init_reserved_mem(void) { }
-- 
1.9.2

