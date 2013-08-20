Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3HTRfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:35:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43087 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3HTRfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:35:43 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-d9-5213a8ed325a
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mturquette@linaro.org, jiada_wang@mentor.com,
        robherring2@gmail.com, grant.likely@linaro.org, broonie@kernel.org,
        vapier@gentoo.org, ralf@linux-mips.org, kyungmin.park@samsung.com,
        shawn.guo@linaro.org, sebastian.hesselbarth@gmail.com,
        LW@KARO-electronics.de, t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 1/4] clk: add common __clk_get(), __clk_put() implementations
Date: Tue, 20 Aug 2013 19:34:20 +0200
Message-id: <1377020063-30213-2-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377020063-30213-1-git-send-email-s.nawrocki@samsung.com>
References: <1377020063-30213-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t9jQd13K4SDDA5eYLSY+vAJm8X7jfOY
	LA782cFo0fOn0uJs0xt2i86JS9gtNj2+xmpxedccNosJUyexW8z5M4XZ4vZlXosDT5azWTyd
	cJHN4tIeFYvv376xWRx+085q8f6no8XTdUuYLdbPeM1isbDhC7vFzQk/mB1EPVqae9g8Vk73
	9rj8/Q2zx85Zd9k9PnyM85jdMZPVY/70R8wem1Z1snncubaHzePoyrVMHpuX1Hvs/trE6NG3
	ZRWjx+dNcgF8UVw2Kak5mWWpRfp2CVwZSz8fZCvYq1hx5e8JxgbGA9JdjBwcEgImEnt+1Hcx
	cgKZYhIX7q1n62Lk4hASmM4oMX/pS1YIp4NJ4sSFpUwgVWwChhK9R/sYQWwRAQ2JKV2P2UGK
	mAUWs0hs27yIGSQhLBAg8ebObBYQm0VAVeL952tgDbwCbhLX2h6wQ2xWkJgzyQYkzCngLjHh
	5A5WEFsIqOTRhHmsExh5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjpZn0jsYVzVY
	HGIU4GBU4uHdUCgcJMSaWFZcmXuIUYKDWUmEd1sGUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjv
	wVbrQCGB9MSS1OzU1ILUIpgsEwenVAOj/5+YapWLmv+3if1sPBfNuuA264bZ+wo08himv2Kb
	/od/9vrUjJOftHQ2HxDaqPD3yaRFhuZTPJR+bLQpkmiJMJVjVF94fHVB7J7E77VdDhX6Rr6N
	tzz1z6x91NmZ/6FcxrtJdMfJJabnlyqZ3GmbnmFdcnJbxabjazIjTt5S0H2o/3ljUcI2JZbi
	jERDLeai4kQAVGcSp5ICAAA=
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

No changes since previous version.

 arch/arm/include/asm/clkdev.h      |    2 ++
 arch/blackfin/include/asm/clkdev.h |    2 ++
 arch/mips/include/asm/clkdev.h     |    2 ++
 arch/sh/include/asm/clkdev.h       |    2 ++
 drivers/clk/clk.c                  |   24 ++++++++++++++++++++++++
 include/linux/clk-private.h        |    3 +++
 include/linux/clkdev.h             |    5 +++++
 7 files changed, 40 insertions(+)

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
index 56a00db..0e0eb31 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1851,6 +1851,30 @@ void devm_clk_unregister(struct device *dev, struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(devm_clk_unregister);

+/*
+ * clkdev helpers
+ */
+int __clk_get(struct clk *clk)
+{
+	if (WARN_ON((!clk)))
+		return 0;
+
+	if (!try_module_get(clk->owner))
+		return 0;
+
+	return 1;
+}
+EXPORT_SYMBOL(__clk_get);
+
+void __clk_put(struct clk *clk)
+{
+	if (!clk || IS_ERR(clk))
+		return;
+
+	module_put(clk->owner);
+}
+EXPORT_SYMBOL(__clk_put);
+
 /***        clk rate change notifiers        ***/

 /**
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index dd7adff..b7c0b58 100644
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

