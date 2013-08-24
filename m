Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3HXS2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 14:28:40 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:61187 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab3HXS2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 14:28:38 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mturquette@linaro.org, jiada_wang@mentor.com,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v5 3/5] clk: Add common __clk_get(), __clk_put() implementations
Date: Sat, 24 Aug 2013 20:27:03 +0200
Message-Id: <1377368825-30715-4-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1377368825-30715-1-git-send-email-s.nawrocki@samsung.com>
References: <1377368825-30715-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds common __clk_get(), __clk_put() clkdev helpers which
replace their platform specific counterparts when the common clock
API is enabled.

The owner module pointer field is added to struct clk so a reference
to the clock supplier module can be taken by the clock consumers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v4:
 - dropped unnecessary struct module forward declaration from
   clk-provider.h

Changes since v3:
 - dropped exporting of __clk_get(), __clk_put().

Changes since v2:
 - fixed handling of NULL clock pointers in __clk_get(), __clk_put();
---
 arch/arm/include/asm/clkdev.h      |    2 ++
 arch/blackfin/include/asm/clkdev.h |    2 ++
 arch/mips/include/asm/clkdev.h     |    2 ++
 arch/sh/include/asm/clkdev.h       |    2 ++
 drivers/clk/clk.c                  |   20 ++++++++++++++++++++
 include/linux/clk-private.h        |    3 +++
 include/linux/clkdev.h             |    5 +++++
 7 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/clkdev.h b/arch/arm/include/asm/clkdev.h
index 80751c1..4e8a4b2 100644
--- a/arch/arm/include/asm/clkdev.h
+++ b/arch/arm/include/asm/clkdev.h
@@ -14,12 +14,14 @@
 
 #include <linux/slab.h>
 
+#ifndef CONFIG_COMMON_CLK
 #ifdef CONFIG_HAVE_MACH_CLKDEV
 #include <mach/clkdev.h>
 #else
 #define __clk_get(clk)	({ 1; })
 #define __clk_put(clk)	do { } while (0)
 #endif
+#endif
 
 static inline struct clk_lookup_alloc *__clkdev_alloc(size_t size)
 {
diff --git a/arch/blackfin/include/asm/clkdev.h b/arch/blackfin/include/asm/clkdev.h
index 9053bed..7ac2436 100644
--- a/arch/blackfin/include/asm/clkdev.h
+++ b/arch/blackfin/include/asm/clkdev.h
@@ -8,7 +8,9 @@ static inline struct clk_lookup_alloc *__clkdev_alloc(size_t size)
 	return kzalloc(size, GFP_KERNEL);
 }
 
+#ifndef CONFIG_COMMON_CLK
 #define __clk_put(clk)
 #define __clk_get(clk) ({ 1; })
+#endif
 
 #endif
diff --git a/arch/mips/include/asm/clkdev.h b/arch/mips/include/asm/clkdev.h
index 2624754..1b3ad7b 100644
--- a/arch/mips/include/asm/clkdev.h
+++ b/arch/mips/include/asm/clkdev.h
@@ -14,8 +14,10 @@
 
 #include <linux/slab.h>
 
+#ifndef CONFIG_COMMON_CLK
 #define __clk_get(clk)	({ 1; })
 #define __clk_put(clk)	do { } while (0)
+#endif
 
 static inline struct clk_lookup_alloc *__clkdev_alloc(size_t size)
 {
diff --git a/arch/sh/include/asm/clkdev.h b/arch/sh/include/asm/clkdev.h
index 6ba9186..c419014 100644
--- a/arch/sh/include/asm/clkdev.h
+++ b/arch/sh/include/asm/clkdev.h
@@ -25,7 +25,9 @@ static inline struct clk_lookup_alloc *__clkdev_alloc(size_t size)
 		return kzalloc(size, GFP_KERNEL);
 }
 
+#ifndef CONFIG_COMMON_CLK
 #define __clk_put(clk)
 #define __clk_get(clk) ({ 1; })
+#endif
 
 #endif /* __CLKDEV_H__ */
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index f46444f..8ccc1cd 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1959,6 +1959,26 @@ void devm_clk_unregister(struct device *dev, struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(devm_clk_unregister);
 
+/*
+ * clkdev helpers
+ */
+int __clk_get(struct clk *clk)
+{
+	if (clk && !try_module_get(clk->owner))
+		return 0;
+
+	return 1;
+}
+
+void __clk_put(struct clk *clk)
+{
+	if (WARN_ON_ONCE(IS_ERR(clk)))
+		return;
+
+	if (clk)
+		module_put(clk->owner);
+}
+
 /***        clk rate change notifiers        ***/
 
 /**
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 8138c94..8cb1865 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -25,10 +25,13 @@
 
 #ifdef CONFIG_COMMON_CLK
 
+struct module;
+
 struct clk {
 	const char		*name;
 	const struct clk_ops	*ops;
 	struct clk_hw		*hw;
+	struct module		*owner;
 	struct clk		*parent;
 	const char		**parent_names;
 	struct clk		**parents;
diff --git a/include/linux/clkdev.h b/include/linux/clkdev.h
index a6a6f60..94bad77 100644
--- a/include/linux/clkdev.h
+++ b/include/linux/clkdev.h
@@ -43,4 +43,9 @@ int clk_add_alias(const char *, const char *, char *, struct device *);
 int clk_register_clkdev(struct clk *, const char *, const char *, ...);
 int clk_register_clkdevs(struct clk *, struct clk_lookup *, size_t);
 
+#ifdef CONFIG_COMMON_CLK
+int __clk_get(struct clk *clk);
+void __clk_put(struct clk *clk);
+#endif
+
 #endif
-- 
1.7.4.1

