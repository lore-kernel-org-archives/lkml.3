Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaGNHeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:34:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50335 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbaGNHdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:33:32 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-6d-53c387c825e3
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Jon Medhurst <tixy@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V." <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 3/4] drivers: dma-coherent: add initialization from device
 tree
Date: Mon, 14 Jul 2014 09:12:45 +0200
Message-id: <1405321966-28184-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1405321966-28184-1-git-send-email-m.szyprowski@samsung.com>
References: <1405321966-28184-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t/xq7on2g8HGxy6r2UxZ/0aNovHr+ex
	WPyddIzd4kNTK7PF+2U9jBbzj5xjtTjwZwejxcruZjaLneveMVqcbXrDbrG9cwa7xZcrD5ks
	Nj2+xmpxedccNou1R+6yW2x4eZDJYsHxFlaLP9PlLNYcWcxu8Xf7JhaL9TNes1gsnH+f3eLl
	xxMsDuIea+atYfT4/WsSo8flvl4mj52z7rJ79LxpYfXoenuFyePOtT1sHidm/GbxeHBoM4vH
	5iX1Hrf/PWb2WPfnFZNH/18Dj7m7+hg9+rasYvT4vEkuQCCKyyYlNSezLLVI3y6BK+PQnG7G
	gmV8FZu3L2NrYJzB08XIySEhYCKxo3EfG4QtJnHh3nogm4tDSGApo8TOjiVQTh+TxPSTy1lA
	qtgEDCW63naBdYgIuEn8W3cIrIhZYAGbxNH/PxhBEsICIRJT9n8CK2IRUJVY9fgcUxcjBwev
	gIfEgkv2ENvkJP6/XMEEYnMKeEpsnPyNFcQWAio5vG8P4wRG3gWMDKsYRVNLkwuKk9JzjfSK
	E3OLS/PS9ZLzczcxQuLr6w7GpcesDjEKcDAq8fAW8B8OFmJNLCuuzD3EKMHBrCTCG+4GFOJN
	SaysSi3Kjy8qzUktPsTIxMEp1cDoOO2+77zl/vNlPdq0WD/meK67y6T1a4+S+Z2ZRi9rDlo4
	Pfbo0JWs2uop2n3vdZnNqTAlRs8wWY2OzSnRb++v+vFEL0q4Kina2nrJrmPHV/67IpI/tbH6
	yDKV0HVMLjsyV2uL7vW7vetqw2vDuN3798y/oXjJaaV89QqlOX+a/UQ0GioL8jmUWIozEg21
	mIuKEwGDqAOxjQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for handling 'shared-dma-pool' reserved-memory device tree
nodes.

Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/base/dma-coherent.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/base/dma-coherent.c b/drivers/base/dma-coherent.c
index 7d6e84a51424..b20cbe095d86 100644
--- a/drivers/base/dma-coherent.c
+++ b/drivers/base/dma-coherent.c
@@ -218,3 +218,43 @@ int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
 	return 0;
 }
 EXPORT_SYMBOL(dma_mmap_from_coherent);
+
+/*
+ * Support for reserved memory regions defined in device tree
+ */
+#ifdef CONFIG_OF_RESERVED_MEM
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_reserved_mem.h>
+
+static void rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
+{
+	dma_declare_coherent_memory(dev, rmem->base, rmem->base,
+		rmem->size, DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
+}
+
+static void rmem_dma_device_release(struct reserved_mem *rmem,
+				    struct device *dev)
+{
+	dma_release_declared_memory(dev);
+}
+
+static const struct reserved_mem_ops rmem_dma_ops = {
+	.device_init	= rmem_dma_device_init,
+	.device_release	= rmem_dma_device_release,
+};
+
+static int __init rmem_dma_setup(struct reserved_mem *rmem)
+{
+	unsigned long node = rmem->fdt_node;
+
+	if (of_get_flat_dt_prop(node, "reusable", NULL))
+		return -EINVAL;
+
+	rmem->ops = &rmem_dma_ops;
+	pr_info("Reserved memory: created DMA memory pool at %pa, size %ld MiB\n",
+		&rmem->base, (unsigned long)rmem->size / SZ_1M);
+	return 0;
+}
+RESERVEDMEM_OF_DECLARE(dma, "shared-dma-pool", rmem_dma_setup);
+#endif
-- 
1.9.2

