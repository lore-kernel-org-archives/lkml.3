Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbaBUM2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:28:45 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63436 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbaBUM0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:26:15 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-98-530745e5c814
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
Subject: [PATCH v5 05/11] drivers: of: add automated assignment of reserved
 regions to client devices
Date: Fri, 21 Feb 2014 13:25:21 +0100
Message-id: <1392985527-6260-6-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
References: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRW0iTYRyHfb99+75vo8XnMn01sxrZReRhFfQiGtkB34siwTsvsqljKk7X
	ppKKZGuaztPSCyXUFF3FUicr8ICFk6WSFpnmKs+Ymbp5aKKVc9T07uH5P7+rP8MR6kg/Jjkt
	Q6pMk6SKKD455Br4HLRwjY4J1agFaLeyn0br6gIOWntaCtATywcuqrA1clGvsxMgW1kRibra
	VgF6r7bRqKO4hkabY3MEMs2Pc1FjYTOJRrtrKdRqmaJR+5KZQHrrCIEaBjRc5KwOQO+sDgq1
	WJpopKtuJVHBawuNdjtMJFo2F5LIWLNCIkO3E6CljUHykj9uqW8BeOdvJcArVTqAR8vLCNz1
	eIrGpTYNF5sMxRSeHO+h8Mvme3jCNc/BY4NqLm5zLhO4YjcU13WXA1z+ygCwwxQQ7RnLD0+U
	piZnSZUhF2/zk/TPOymF8eTdtw+KyHxgP6oFPAay5+Hc5Cy9z97w47SR0gI+I2T1AH7f+Eq5
	D0K2hIBrcyluplgx1Nq1e96LbQTQUU+6Bxx2hoJFI6WEFjDMIVYGnRNh7oZkA+HsMz1ws4CN
	gt+2Jmh3AtnjsLYy3K15LIbDvYt7Wvg/aStK0QFBA/AwgMPSzASFKl4mFwerJHJVZposOCFd
	bgL7X9zsBE39YX2AZYDogEABqRghV5Klypb3AchwRF4CcwgdIxQkSrJzpMr0OGVmqlTVBwiG
	55cPeH+mtl9w0NU3846ZBaNVbFrPk3HbDUEzPfZP+oexIhzVMf7jzrnMkvtVeUOrG1fih73O
	Rvgf3F7STn/Z8unPFdx0WRXiyAvXI4+dWfQ+RdYZq0XLq5aMW11xLs9e+095Tq7y96NAY1y0
	OXErIn7nxCw84vvLw+h7g9AEOi77iEhVkkR8mqNUSf4BM+ug66MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code for automated assignment of reserved memory regions
to struct device. reserved_mem->ops->device_init()/device_cleanup()
callbacks are called to perform reserved memory driver specific
initialization and cleanup. The code looks for 'memory-region' property
in the client device node and assigns region pointed by the found
phandle.

Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c    |   74 +++++++++++++++++++++++++++++++++++++++
 include/linux/of_reserved_mem.h |    7 ++++
 2 files changed, 81 insertions(+)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 97de6f882f85..b02a7f0a54c8 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -206,8 +206,16 @@ void __init fdt_init_reserved_mem(void)
 	for (i = 0; i < reserved_mem_count; i++) {
 		struct reserved_mem *rmem = &reserved_mem[i];
 		unsigned long node = rmem->fdt_node;
+		unsigned long len;
+		__be32 *prop;
 		int err = 0;
 
+		prop = of_get_flat_dt_prop(node, "phandle", &len);
+		if (!prop)
+			prop = of_get_flat_dt_prop(node, "linux,phandle", &len);
+		if (prop)
+			rmem->phandle = of_read_number(prop, len/4);
+
 		if (rmem->size == 0)
 			err = __reserved_mem_alloc_size(node, rmem->name,
 						 &rmem->base, &rmem->size);
@@ -215,3 +223,69 @@ void __init fdt_init_reserved_mem(void)
 			__reserved_mem_init_node(rmem);
 	}
 }
+
+static inline struct reserved_mem *__find_rmem(struct device_node *node)
+{
+	unsigned int i;
+
+	if (!node->phandle)
+		return NULL;
+
+	for (i = 0; i < reserved_mem_count; i++)
+		if (reserved_mem[i].phandle == node->phandle)
+			return &reserved_mem[i];
+	return NULL;
+}
+
+/**
+ * of_reserved_mem_device_init() - assign reserved memory region to given device
+ *
+ * This function assign memory region pointed by "memory-region" device tree
+ * property to the given device.
+ */
+void of_reserved_mem_device_init(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct reserved_mem *rmem;
+	struct of_phandle_args s;
+	unsigned int i;
+
+	for (i = 0; of_parse_phandle_with_args(np, "memory-region",
+				"#memory-region-cells", i, &s) == 0; i++) {
+
+		rmem = __find_rmem(s.np);
+		if (!rmem || !rmem->ops || !rmem->ops->device_init) {
+			of_node_put(s.np);
+			continue;
+		}
+
+		rmem->ops->device_init(rmem, dev, &s);
+		dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
+		of_node_put(s.np);
+		break;
+	}
+}
+
+/**
+ * of_reserved_mem_device_release() - release reserved memory device structures
+ *
+ * This function releases structures allocated for memory region handling for
+ * the given device.
+ */
+void of_reserved_mem_device_release(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct reserved_mem *rmem;
+	struct of_phandle_args s;
+	unsigned int i;
+
+	for (i = 0; of_parse_phandle_with_args(np, "memory-region",
+				"#memory-region-cells", i, &s) == 0; i++) {
+
+		rmem = __find_rmem(s.np);
+		if (rmem && rmem->ops && rmem->ops->device_release)
+			rmem->ops->device_release(rmem, dev);
+
+		of_node_put(s.np);
+	}
+}
diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index f707176619a3..a2a25de297de 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -8,6 +8,7 @@ struct reserved_mem_ops;
 struct reserved_mem {
 	const char			*name;
 	unsigned long			fdt_node;
+	unsigned long			phandle;
 	const struct reserved_mem_ops	*ops;
 	phys_addr_t			base;
 	phys_addr_t			size;
@@ -26,6 +27,9 @@ typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem,
 				      unsigned long node, const char *uname);
 
 #ifdef CONFIG_OF_RESERVED_MEM
+void of_reserved_mem_device_init(struct device *dev);
+void of_reserved_mem_device_release(struct device *dev);
+
 void fdt_init_reserved_mem(void);
 void fdt_reserved_mem_save_node(unsigned long node, const char *uname,
 			       phys_addr_t base, phys_addr_t size);
@@ -38,6 +42,9 @@ void fdt_reserved_mem_save_node(unsigned long node, const char *uname,
 				init : init }
 
 #else
+static inline void of_reserved_mem_device_init(struct device *dev) { }
+static inline void of_reserved_mem_device_release(struct device *pdev) { }
+
 static inline void fdt_init_reserved_mem(void) { }
 static inline void fdt_reserved_mem_save_node(unsigned long node,
 		const char *uname, phys_addr_t base, phys_addr_t size) { }
-- 
1.7.9.5

