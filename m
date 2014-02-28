Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaB1Nn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:43:26 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29553 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaB1NnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:43:15 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-13-531092719565
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
Subject: [PATCH v6 05/11] drivers: of: add automated assignment of reserved
 regions to client devices
Date: Fri, 28 Feb 2014 14:42:50 +0100
Message-id: <1393594976-16728-6-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
References: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRXUhTYQCG+845O+dstDwtrQ8rsZkQSuZK5ENEgkA+oQvBiyKKWjr8yant
	pGmQzaFic9O1opnZUtTCtfkzBX8o0rFULKXhzy6cmlmR/5ZeWM1Vw7vnfXjuXpaUPKCC2cyc
	WwpVjjxbSouo976hyZM3jVxKdK0nFu0YBxm0oSkj0foLHUDPnWMCVL3SIED93h6AVvQVFOpt
	XQNoVLPCoO77NQzampgnkH1hSoAaypsoNN5XRyObc4ZB7YsDBGp2uwhUP1QqQF5TCBpxb9LI
	6mxkkMFko1DZGyeDdrrtFFoaKKdQW80yhSx9XoAWfwxTZ49gq9kK8J/fRoCXHxoAHq/SE7i3
	dobBupVSAbZb7tPYM/Waxp1N9/C0b4HEE8MaAW71LhG4eicaP+urAriqywLwpj0kef8lUXya
	IjuzQKE6lXBNlPHu5SMmz3mscM6uJ9TAdVgLhCzkYqBxrYPZ5YPw42wbrQUiVsI1A2iqV5O7
	o5KAHT01wF/RnAxqV7W0nwO5BgA3zZQ/Irk5Gla4dIQWsOwBLh1O+6AfKS4clqwr/bmYw7Cl
	fYL0a8iFwjpjvF8LuSSoNs0J/Cz5n0xvu4EBiOvBHgsIUuSn5vHX05WyKF6u5PNz0qNSc5V2
	sHvjVg9oHIxzAI4F0r1iQ1JAikQgL+CLlA4AWVIaKP6i4VIk4jR50R2FKveqKj9bwTsAwQqD
	1UC26vrbn+oJo1WTl5vMvS1yEzh9NPx85VZJ3Mh43NqGLfJJ15jPErb9SnK3JHS0sDmw+Kmo
	IPGKKHbA/cnzGDPucyckWb/OGDvhoWGdXch81x9PcHy7GKbcCHibHBF/IYYvnpcqgryVXz+w
	VnPiz8jZrM/GG3iS32ey3eZVUorPkMsiSBUv/wcU+RLqpAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code for automated assignment of reserved memory regions
to struct device. reserved_mem->ops->device_init()/device_cleanup()
callbacks are called to perform reserved memory driver specific
initialization and cleanup

Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c    |   70 +++++++++++++++++++++++++++++++++++++++
 include/linux/of_reserved_mem.h |    7 ++++
 2 files changed, 77 insertions(+)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index daaaf935911d..5c45016efd31 100644
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
@@ -215,3 +223,65 @@ void __init fdt_init_reserved_mem(void)
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
+	struct reserved_mem *rmem;
+	struct device_node *np;
+
+	np = of_parse_phandle(dev->of_node, "memory-region", 0);
+	if (!np)
+		return;
+
+	rmem = __find_rmem(np);
+	of_node_put(np);
+
+	if (!rmem || !rmem->ops || !rmem->ops->device_init)
+		return;
+
+	rmem->ops->device_init(rmem, dev);
+	dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
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
+	struct reserved_mem *rmem;
+	struct device_node *np;
+
+	np = of_parse_phandle(dev->of_node, "memory-region", 0);
+	if (!np)
+		return;
+
+	rmem = __find_rmem(np);
+	of_node_put(np);
+
+	if (!rmem || !rmem->ops || !rmem->ops->device_release)
+		return;
+
+	rmem->ops->device_release(rmem, dev);
+}
diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index 9b1fbb7f29fc..6a54e6565b89 100644
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
@@ -25,6 +26,9 @@ typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem,
 				      unsigned long node, const char *uname);
 
 #ifdef CONFIG_OF_RESERVED_MEM
+void of_reserved_mem_device_init(struct device *dev);
+void of_reserved_mem_device_release(struct device *dev);
+
 void fdt_init_reserved_mem(void);
 void fdt_reserved_mem_save_node(unsigned long node, const char *uname,
 			       phys_addr_t base, phys_addr_t size);
@@ -37,6 +41,9 @@ void fdt_reserved_mem_save_node(unsigned long node, const char *uname,
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

