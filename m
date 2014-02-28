Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaB1NnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:43:24 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23513 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbaB1NnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:43:15 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-09-53109270798e
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
Subject: [PATCH v6 04/11] drivers: of: add support for custom reserved memory
 drivers
Date: Fri, 28 Feb 2014 14:42:49 +0100
Message-id: <1393594976-16728-5-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
References: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t/xq7oFkwSCDeZd17D4O+kYu8WHplZm
	i/fLehgt5h85x2rR/2Yhq8WBPzsYLd70drBY7Fz3jtHibNMbdovtnTPYLb5cechksenxNVaL
	hW1LWCwu75rDZrH2yF12iw0vDzJZLL1+kcliwfEWVos/0+UsTl3/zGax5shidosJ09eyWLTu
	PcJu8Xf7JhaLVwfbWCzWz3jNYrFq1x9Gi5cfT7A4yHismbeG0eP3r0mMHq8nT2D0uNzXy+Sx
	c9Zddo+eNy2sHptWdbJ53Lm2h81j85J6j9v/HjN7XDnRxOqx7s8rJo/+vwYec3f1MXr0bVnF
	6PF5k1yAYBSXTUpqTmZZapG+XQJXxuNPe5gKZqpW/O/eytbAOEmui5GTQ0LAROL/qjYmCFtM
	4sK99WxdjFwcQgJLGSWmN31hh3C6mSQeHDzJAlLFJmAo0fW2iw3EFhFYyCjxeR4LSBGzwH02
	iY6LPWCjhAXCJa5dvg9mswioSrz+sJMZxOYV8JD42X8PKM4BtE5BYs4kG5Awp4CnRMP0+6wg
	thBQye0f1xknMPIuYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESkV92MC4+ZnWIUYCD
	UYmHd4Inf7AQa2JZcWXuIUYJDmYlEd4nTQLBQrwpiZVVqUX58UWlOanFhxiZODilGhiDc76p
	7J2mVn3sZtml5cq9Dyw1tJ5pX+DnuGEb+mLfmy7H1G//+bZFV32c28G3JTH54qw2LclXj+83
	PZz9kjnnf8nRCS36zPqmpwS3bWhfN9XtZkvAb1Ehadn8+DXyZS4Gvw84H+0LXLRnyzcmR3H9
	eDZ/K56JPClz1Z9sMuB5X7SwKypdrUCJpTgj0VCLuag4EQC2wbFSpgIAAA==
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
 include/linux/of_reserved_mem.h   |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 69b811779585..daaaf935911d 100644
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
index 89226ed7d954..9b1fbb7f29fc 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -1,21 +1,53 @@
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
+			       struct device *dev);
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

