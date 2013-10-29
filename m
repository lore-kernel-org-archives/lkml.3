Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3J2TxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:53:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21683 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab3J2TxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:53:15 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-a4-5270122a33f2
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org
Cc: linux@arm.linux.org.uk, jiada_wang@mentor.com, kyungmin.park@samsung.com,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v7 4/5] clk: Add common __clk_get(), __clk_put() implementations
Date: Tue, 29 Oct 2013 20:51:07 +0100
Message-id: <1383076268-8984-5-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com>
References: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jAV0toYIgg9kf5S16/lRanG16w27R
	OXEJu8Wmx9dYLS7vmsNmMWHqJHaLOX+mMFvcvsxr8XTCRTaLw2/aWS0WNnxhd+D2aGnuYfNY
	Od3bY3bHTFaPO9f2sHkcXbmWyWPzknqP3V+bGD36tqxi9Pi8SS6AM4rLJiU1J7MstUjfLoEr
	496Vq6wFLzQr1s37wdzA2KPUxcjJISFgIrHz/XtGCFtM4sK99WxdjFwcQgKLGCUaz+1ghXA6
	mCQuPdjKDlLFJmAo0Xu0D6xDRMBe4seElywgRcwC85gk5nw4wAaSEBYIkOh7Mgmom4ODRUBV
	4v7UMpAwr4CrRM/eiYwgYQkBBYk5k2xATE4BN4n9i0VBKoSAKk7dusw8gZF3ASPDKkbR1ILk
	guKk9FxDveLE3OLSvHS95PzcTYzg0HwmtYNxZYPFIUYBDkYlHl6DB/lBQqyJZcWVuYcYJTiY
	lUR4px8HCvGmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2aWpBaBJNl4uCUamAM
	7juzqDem+GqHr8Gieivhv05766s2FbuujLknVrahi+WGheGjMrXMgrU5Jx7enLf+4/LYlNac
	Nys8J5W2GHY7XxL6+6F2mhrrblUnlZ+mvRL7ikL+X02cXPefdWP00nvHZUyCJ1+vSbHP7Zbm
	0Hz7wHiTQURBS0WN7CtVltZzTz696zI8rqTEUpyRaKjFXFScCABkOLQ3SQIAAA==
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
index 6ab6781..25b249c 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1812,6 +1812,10 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
 	clk->flags = hw->init->flags;
 	clk->parent_names = hw->init->parent_names;
 	clk->num_parents = hw->init->num_parents;
+	if (dev && dev->driver)
+		clk->owner = dev->driver->owner;
+	else
+		clk->owner = NULL;
 
 	ret = __clk_init(dev, clk);
 	if (ret)
@@ -1832,6 +1836,8 @@ static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
 		goto fail_name;
 	}
 	clk->ops = hw->init->ops;
+	if (dev && dev->driver)
+		clk->owner = dev->driver->owner;
 	clk->hw = hw;
 	clk->flags = hw->init->flags;
 	clk->num_parents = hw->init->num_parents;
@@ -1972,6 +1978,26 @@ void devm_clk_unregister(struct device *dev, struct clk *clk)
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

