Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaBUM3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:29:01 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52946 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbaBUM0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:26:14 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-92-530745e39c67
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
Subject: [PATCH v5 04/11] drivers: of: add support for custom reserved memory
 drivers
Date: Fri, 21 Feb 2014 13:25:20 +0100
Message-id: <1392985527-6260-5-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
References: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyXRe0hTYRgGcL+zc5mjwWmZHKSWDQRJvFXQR0gNwvpACGFBFkEuXWo4XVuT
	LKHhjbmmznnFu03NhrpYpU6s3BoqlpZ4mVBqc6E4l2ZKUE7J6X8/nveB54+XzeLp8CB2WsYD
	iTxDnC4gOfjH3eHpcFcsJYryzEO4ox+i4K/cAhZcb9cC2GQfJ2Cpp4WAg94+AD3FahxautcA
	HMv1ULC3qIaCW1NODJpdMwRsKWzF4WR/PQm77HMUfLlixWCbYwKDzcP5BPRW8+GoY5OEnXYD
	BXXVXTgseGun4E6vGYduayEOTTWrODT2ewFc2RjBhcdQZ2MnQNv/9ACtlusAmiwpxpCldo5C
	Wk8+gczGIhJ9mxkg0avWJ+jrrouFpkZyCdTtdWOodCcKNfSXAFTy2gjQppkff/gmJyZZkp6W
	JZFHXkjkpH5w1uIye8hDq+UNpgImvgb4sxn6LLPbU0UeOJD5Mm/aN49uA8z0iuzATzHGVCPw
	maSjGc1PzX4ngG4BzGYjrgEcNoteIBn1hBbzHY7Q15k+QzXwGadDmC3PCOEzl77CFC993zN7
	byyYqdfH+GJ/GjGfBpcpX8zbq3Sr7+kAtxn4GcFRiTJJpriTIo2OUIilCmVGSkRSptQMDr64
	1QcMQ+dtgGYDwSGujCFFPEKcpciW2gDDZgkCuNZISsTjJouzH0nkmbflynSJwgYwtn+QCmiD
	hapnsXnyi++XF3vWLTa/z3GG+7aOUFZRXcPvtccF4dcaxtpPuOPr6tRhCVdfVD2fSBLOnibc
	o6IzfFw/61RJXWHnqhor+PGLdkdCYhN2d/sdGWhOy7u1s1FZXrZMLnXEJt/4c/zkXwcR6kwZ
	HxAqf5QtVIKKnMv2nEthcQJckSqOPsWSK8T/AR5uRaKjAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for custom reserved memory drivers. Call their init() function
for each reserved region and prepare for using operations provided by them
with by the reserved_mem->ops array.

Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c      |   29 +++++++++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h |   11 +++++++++++
 include/linux/of_reserved_mem.h   |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index c7ca6a4a42d1..97de6f882f85 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -170,6 +170,33 @@ static int __init __reserved_mem_alloc_size(unsigned long node,
 	return 0;
 }
 
+static const struct of_device_id __rmem_of_table_sentinel
+	__used __section(__reservedmem_of_table_end);
+
+/**
+ * res_mem_init_node() - call region specific reserved memory init code
+ */
+static int __init __reserved_mem_init_node(struct reserved_mem *rmem)
+{
+	extern const struct of_device_id __reservedmem_of_table[];
+	const struct of_device_id *i;
+
+	for (i = __reservedmem_of_table; i < &__rmem_of_table_sentinel; i++) {
+		reservedmem_of_init_fn initfn = i->data;
+		const char *compat = i->compatible;
+
+		if (!of_flat_dt_is_compatible(rmem->fdt_node, compat))
+			continue;
+
+		if (initfn(rmem, rmem->fdt_node, rmem->name) == 0) {
+			pr_info("Reserved memory: initialized node %s, compatible id %s\n",
+				rmem->name, compat);
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
 /**
  * fdt_init_reserved_mem - allocate and init all saved reserved memory regions
  */
@@ -184,5 +211,7 @@ void __init fdt_init_reserved_mem(void)
 		if (rmem->size == 0)
 			err = __reserved_mem_alloc_size(node, rmem->name,
 						 &rmem->base, &rmem->size);
+		if (err == 0)
+			__reserved_mem_init_node(rmem);
 	}
 }
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bc2121fa9132..f10f64fcc815 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -167,6 +167,16 @@
 #define CLK_OF_TABLES()
 #endif
 
+#ifdef CONFIG_OF_RESERVED_MEM
+#define RESERVEDMEM_OF_TABLES()				\
+	. = ALIGN(8);					\
+	VMLINUX_SYMBOL(__reservedmem_of_table) = .;	\
+	*(__reservedmem_of_table)			\
+	*(__reservedmem_of_table_end)
+#else
+#define RESERVEDMEM_OF_TABLES()
+#endif
+
 #define KERNEL_DTB()							\
 	STRUCT_ALIGN();							\
 	VMLINUX_SYMBOL(__dtb_start) = .;				\
@@ -490,6 +500,7 @@
 	TRACE_SYSCALLS()						\
 	MEM_DISCARD(init.rodata)					\
 	CLK_OF_TABLES()							\
+	RESERVEDMEM_OF_TABLES()						\
 	CLKSRC_OF_TABLES()						\
 	KERNEL_DTB()							\
 	IRQCHIP_OF_MATCH_TABLE()
diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index 89226ed7d954..f707176619a3 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -1,21 +1,54 @@
 #ifndef __OF_RESERVED_MEM_H
 #define __OF_RESERVED_MEM_H
 
+struct device;
+struct of_phandle_args;
+struct reserved_mem_ops;
+
 struct reserved_mem {
 	const char			*name;
 	unsigned long			fdt_node;
+	const struct reserved_mem_ops	*ops;
 	phys_addr_t			base;
 	phys_addr_t			size;
+	void				*priv;
+};
+
+struct reserved_mem_ops {
+	void	(*device_init)(struct reserved_mem *rmem,
+			       struct device *dev,
+			       struct of_phandle_args *args);
+	void	(*device_release)(struct reserved_mem *rmem,
+				  struct device *dev);
 };
 
+typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem,
+				      unsigned long node, const char *uname);
+
 #ifdef CONFIG_OF_RESERVED_MEM
 void fdt_init_reserved_mem(void);
 void fdt_reserved_mem_save_node(unsigned long node, const char *uname,
 			       phys_addr_t base, phys_addr_t size);
+
+#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
+	static const struct of_device_id __reservedmem_of_table_##name	\
+		__used __section(__reservedmem_of_table)		\
+		 = { .compatible = compat,				\
+		     .data = (init == (reservedmem_of_init_fn)NULL) ?	\
+				init : init }
+
 #else
 static inline void fdt_init_reserved_mem(void) { }
 static inline void fdt_reserved_mem_save_node(unsigned long node,
 		const char *uname, phys_addr_t base, phys_addr_t size) { }
+
+#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
+	static const struct of_device_id __reservedmem_of_table_##name	\
+		__attribute__((unused))					\
+		 = { .compatible = compat,				\
+		     .data = (init == (reservedmem_of_init_fn)NULL) ?	\
+				init : init }
+
 #endif
 
 #endif /* __OF_RESERVED_MEM_H */
-- 
1.7.9.5

