Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab3LDRNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:13:48 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:55794 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab3LDRNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:13:43 -0500
X-AuditID: cbfee61b-b7f006d000003e1f-82-529f62c5eeb4
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiada_wang@mentor.com,
        laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RESEND PATCH v7 4/5] clk: Add common __clk_get(),
 __clk_put() implementations
Date: Wed, 04 Dec 2013 18:12:06 +0100
Message-id: <1386177127-2894-5-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386177127-2894-1-git-send-email-s.nawrocki@samsung.com>
References: <1386177127-2894-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jAd1jSfODDDa9ZrPo+VNpcbbpDbtF
	58Ql7BabHl9jtbi8aw5QfMNWVovbl3ktnk64yGZx+E07qwOnR0tzD5vH7I6ZrB53ru1h89i8
	pN5j99cmRo++LasYPT5vkgtgj+KySUnNySxLLdK3S+DKOHFoJlPBPK2Kxg9L2RsY9yp1MXJw
	SAiYSOzdEtXFyAlkiklcuLeerYuRi0NIYBGjxM/XzxkhnA4miRkd/5hAqtgEDCV6j/Yxgtgi
	AvYS7S0vwDqYBe4ySjw/9xAsISwQKbHi6yVmEJtFQFXi0ZpGdpBtvAKuEj9PeEAsVpCYM8kG
	pIJTwE1i34wtLCC2EFDF+Z2P2Scw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERx0
	z6R3MK5qsDjEKMDBqMTD+yJxfpAQa2JZcWXuIUYJDmYlEd7JgUAh3pTEyqrUovz4otKc1OJD
	jNIcLErivAdbrQOFBNITS1KzU1MLUotgskwcnFINjBsUJC1EhVOniMxik37RoLyGPeaQAYvM
	sSlvOG++q3riHL1ju0eM05/vy8Kyn3xeKTk5ekqk/bR1FjIfz8m9/xAXuvLyb4Nbh7+YJ/Hb
	HNcwaIyrrjvgXqzHfcvQ51bHaq/FbwPvTN7n02bw84ZEXuuL/xMD+wvV1BrTHvvL3WGbNKOC
	Qah+jhJLcUaioRZzUXEiACH9vts2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds common __clk_get(), __clk_put() clkdev helpers that
replace their platform specific counterparts when the common clock
API is used.

The owner module pointer field is added to struct clk so a reference
to the clock supplier module can be taken by the clock consumers.

The owner module is assigned while the clock is being registered,
in functions _clk_register() and __clk_register().

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
Changes since v6:
 - squashed into this one the patch assigning module owner
   to struct clk.

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
 drivers/clk/clk.c                  |   26 ++++++++++++++++++++++++++
 include/linux/clk-private.h        |    3 +++
 include/linux/clkdev.h             |    5 +++++
 7 files changed, 42 insertions(+)

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
index c687dc8..baa2f66 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1813,6 +1813,10 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
 	clk->flags = hw->init->flags;
 	clk->parent_names = hw->init->parent_names;
 	clk->num_parents = hw->init->num_parents;
+	if (dev && dev->driver)
+		clk->owner = dev->driver->owner;
+	else
+		clk->owner = NULL;
 
 	ret = __clk_init(dev, clk);
 	if (ret)
@@ -1833,6 +1837,8 @@ static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
 		goto fail_name;
 	}
 	clk->ops = hw->init->ops;
+	if (dev && dev->driver)
+		clk->owner = dev->driver->owner;
 	clk->hw = hw;
 	clk->flags = hw->init->flags;
 	clk->num_parents = hw->init->num_parents;
@@ -1973,6 +1979,26 @@ void devm_clk_unregister(struct device *dev, struct clk *clk)
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
1.7.9.5

