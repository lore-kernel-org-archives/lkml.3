Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3HWPFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:05:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23690 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab3HWPFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:05:08 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-b8-52177a234a75
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mturquette@linaro.org, jiada_wang@mentor.com,
        broonie@kernel.org, vapier@gentoo.org, ralf@linux-mips.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        shawn.guo@linaro.org, sebastian.hesselbarth@gmail.com,
        LW@KARO-electronics.de, t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 3/5] clk: Add common __clk_get(), __clk_put() implementations
Date: Fri, 23 Aug 2013 17:03:45 +0200
Message-id: <1377270227-1030-4-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377270227-1030-1-git-send-email-s.nawrocki@samsung.com>
References: <1377270227-1030-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t9jAV3lKvEgg2u7lS2mPnzCZvF+4zwm
	i54/lRZnm96wW3ROXMJusenxNVaLy7vmsFlMmDqJ3WLOnynMFrcv81oceLKczeLphItsFrcb
	V7BZXNqjYnH4TTurxfufjhZP1y1htlg/4zWLxcKGL+wWNyf8YHYQ8Whp7mHzWDnd2+Py9zfM
	Hjtn3WX3+PAxzmN2x0xWj/nTHzF7bFrVyeZx59oeNo+jK9cyeWxeUu+x+2sTo0ffllWMHp83
	yQXwRXHZpKTmZJalFunbJXBlLD/TxlJwTbXi9MtvzA2Mb+S6GDk5JARMJNqfTGOEsMUkLtxb
	z9bFyMUhJLCIUeL/1lYmCKeDSWLFv+8sIFVsAoYSvUf7wDpEBDQkpnQ9ZgcpYhboZZGYMvkm
	WJGwQIBE/+rLYEUsAqoS/+duYwWxeQVcJfa/fg80lQNonYLEnEk2IGFOATeJ5jVnwcJCQCV/
	t2hOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Rp5J72Bc1WBxiFGAg1GJh3eC
	s1iQEGtiWXFl7iFGCQ5mJRHenXniQUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeW
	pGanphakFsFkmTg4pRoY5e04t0/6mSE3N+Pjhg0HS/co3lU4+udH273u3WJ7z0xRdK82nqO1
	Vn1KdFTR7x6WxNU+i6ft/mkTf+DqvOXM4j6Jq8L2hN9pVim6kxMX8+9Hc9SJJd9Lf9xfu0l0
	lUHx17T9jDanpq1+OPOnrumRZNtr/4TOft1wrefe+ZdbdSsk36/6yPtJr1OJpTgj0VCLuag4
	EQAz0QgxjQIAAA==
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
Changes since v2:
 - fixed handling of NULL clock pointers in __clk_get(), __clk_put();
---
 arch/arm/include/asm/clkdev.h      |    2 ++
 arch/blackfin/include/asm/clkdev.h |    2 ++
 arch/mips/include/asm/clkdev.h     |    2 ++
 arch/sh/include/asm/clkdev.h       |    2 ++
 drivers/clk/clk.c                  |   22 ++++++++++++++++++++++
 include/linux/clk-private.h        |    3 +++
 include/linux/clk-provider.h       |    2 ++
 include/linux/clkdev.h             |    5 +++++
 8 files changed, 40 insertions(+)

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
index eb3207e..c173f30 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1852,6 +1852,28 @@ void devm_clk_unregister(struct device *dev, struct clk *clk)
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
+EXPORT_SYMBOL(__clk_get);
+
+void __clk_put(struct clk *clk)
+{
+	if (WARN_ON_ONCE(IS_ERR(clk)))
+		return;
+
+	if (clk)
+		module_put(clk->owner);
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
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 1ec14a7..2c42fde 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -133,6 +133,8 @@ struct clk_ops {
 	void		(*init)(struct clk_hw *hw);
 };
 
+struct module;
+
 /**
  * struct clk_init_data - holds init data that's common to all clocks and is
  * shared between the clock provider and the common clock framework.
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

