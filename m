Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaB1Nq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:46:26 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29568 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbaB1NnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:43:18 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-22-53109274c7c4
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH v6 07/11] drivers: dma-coherent: add initialization from device
 tree
Date: Fri, 28 Feb 2014 14:42:52 +0100
Message-id: <1393594976-16728-8-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
References: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRa0hTYRzGe8/OzjlOl6e17CChsYjA0LT68FJm0adXiSgEBbvY0uEkN2Xz
	klI5hopO5+YUNHW2eYOGOpuSFwxyzEtauTXdimVSBjFdligVNSWn334P/9/zfPlTLF4dHk5l
	S/NFMqkwR0Bw8NntqYXofB2dHKuYOwy3dJMk/KksZ8Ef3TUAPrG9ZUONz8iGL/3DAPrUlTgc
	6VsD8I3SR8KhqiYSbs5/xqBl2cWGxopOHDpHWwnYa1skYb93HINdbgcGDVNlbOhvjIAz7g0C
	9tg6SKht7MVh+QsbCbeGLDhcGa/AoblpFYemUT+A3vVp/NIR1NPWA9C/vzqAVuu1ADlr1Rga
	aV4kUY2vjI0spioCfXSNEWigsxR5tpdZaH5ayUZ9/hUMabZikX60FqDaQRNAG5aIawfSOPGZ
	opzsQpHsVMIdjthZGZw3uP+++v0sSwFaQlQgiGLos4zj+Ttyj8MY+yczoQIcikd3AUZhnsD2
	QjXG2N16ImARdByj+q7aZT5tBMxGGx6QWPQSwVQ6arDA4SCdwixo9LuzOH2cWVOu7xQoiksj
	ZsAjDCBDH2VadfEBI4hOZBSNS+wA83YMzx830AKuAewzgUOigow8+d0sSVyMXCiRF0izYjJy
	JRaw98bNYdAxec4KaAoIQrjaxNBkHltYKC+WWAFDsQR87lclnczjZgqLS0Sy3HRZQY5IbgUY
	FRSuAFhqSvR5Q9k387F2sXHu+pg305qmiz1pSX2myW2fKSdkYn6kp+HK1awhWtBtn2oWO2/U
	q1eyb9u40pYPkbeCTY9CS+ZeraZ3vC7Sz7rW7EmP7+X/OjH221H61Js00dB/GY/ZNjTU6S+0
	Vp/2bhZdhA9unqkodIUxugT+wyjbFwEuFwvjolgyufA/3h44QqQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for handling 'shared-dma-pool' reserved-memory device tree
nodes.

Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/base/dma-coherent.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/base/dma-coherent.c b/drivers/base/dma-coherent.c
index bc256b641027..0a5fc7f3d03e 100644
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
+static int __init rmem_dma_setup(struct reserved_mem *rmem,
+				 unsigned long node,
+				 const char *uname)
+{
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
1.7.9.5

