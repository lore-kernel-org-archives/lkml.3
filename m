Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaDYMWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:22:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:48862 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbaDYMW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:22:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,926,1389772800"; 
   d="scan'208";a="527274715"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mike Turquette <mturquette@linaro.org>
Cc: Len Brown <lenb@kernel.org>, Mika Westerberg <mika.westerberg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Loic Poulain <loic.poulain@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] clk: new basic clk type for fractional divider
Date: Fri, 25 Apr 2014 15:22:20 +0300
Message-Id: <1398428541-912-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc0
In-Reply-To: <1398428541-912-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1398428541-912-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fractional divider clocks are fairly common. This adds basic
type for them.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/clk/Makefile                 |   1 +
 drivers/clk/clk-fractional-divider.c | 132 +++++++++++++++++++++++++++++++++++
 include/linux/clk-provider.h         |  31 ++++++++
 3 files changed, 164 insertions(+)
 create mode 100644 drivers/clk/clk-fractional-divider.c

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 5f8a287..0745059 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-fixed-rate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-gate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-mux.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
+obj-$(CONFIG_COMMON_CLK)	+= clk-fractional-divider.o
 
 # hardware specific clock types
 # please keep this section sorted lexicographically by file/directory path name
diff --git a/drivers/clk/clk-fractional-divider.c b/drivers/clk/clk-fractional-divider.c
new file mode 100644
index 0000000..a4dd873
--- /dev/null
+++ b/drivers/clk/clk-fractional-divider.c
@@ -0,0 +1,132 @@
+/*
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Adjustable fractional divider clock implementation.
+ * Output rate = (m / n) * parent_rate.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/gcd.h>
+
+#define to_clk_fd(_hw) container_of(_hw, struct clk_fractional_divider, hw)
+
+static unsigned long clk_fd_recalc_rate(struct clk_hw *hw,
+					unsigned long parent_rate)
+{
+	struct clk_fractional_divider *fd = to_clk_fd(hw);
+	unsigned long flags = 0;
+	unsigned n, m;
+	u32 val;
+
+	if (fd->lock)
+		spin_lock_irqsave(fd->lock, flags);
+
+	val = clk_readl(fd->reg);
+
+	if (fd->lock)
+		spin_unlock_irqrestore(fd->lock, flags);
+
+	m = (val & fd->mmask) >> fd->mshift;
+	n = (val & fd->nmask) >> fd->nshift;
+
+	return parent_rate / n * m;
+}
+
+static long clk_fd_round_rate(struct clk_hw *hw, unsigned long rate,
+			      unsigned long *prate)
+{
+	struct clk_fractional_divider *fd = to_clk_fd(hw);
+	unsigned maxdiv = (fd->nmask >> fd->nshift) + 1;
+	unsigned div;
+
+	if (!rate || rate > *prate)
+		return *prate;
+
+	div = gcd(*prate, rate);
+
+	while ((*prate / div) > maxdiv) {
+		div <<= 1;
+		rate <<= 1;
+	}
+
+	return rate;
+}
+
+static int clk_fd_set_rate(struct clk_hw *hw, unsigned long rate,
+			   unsigned long parent_rate)
+{
+	struct clk_fractional_divider *fd = to_clk_fd(hw);
+	unsigned long flags = 0;
+	unsigned long div;
+	unsigned n, m;
+	u32 val;
+
+	div = gcd(parent_rate, rate);
+	m = rate / div;
+	n = parent_rate / div;
+
+	if (fd->lock)
+		spin_lock_irqsave(fd->lock, flags);
+
+	val = clk_readl(fd->reg);
+	val &= ~(fd->mmask | fd->nmask);
+	val |= (m << fd->mshift) | (n << fd->nshift);
+	clk_writel(val, fd->reg);
+
+	if (fd->lock)
+		spin_unlock_irqrestore(fd->lock, flags);
+
+	return 0;
+}
+
+const struct clk_ops clk_fractional_divider_ops = {
+	.recalc_rate = clk_fd_recalc_rate,
+	.round_rate = clk_fd_round_rate,
+	.set_rate = clk_fd_set_rate,
+};
+EXPORT_SYMBOL_GPL(clk_fractional_divider_ops);
+
+struct clk *clk_register_fractional_divider(struct device *dev,
+		const char *name, const char *parent_name, unsigned long flags,
+		void __iomem *reg, u8 mshift, u8 mwidth, u8 nshift, u8 nwidth,
+		u8 clk_divider_flags, spinlock_t *lock)
+{
+	struct clk_fractional_divider *fd;
+	struct clk_init_data init;
+	struct clk *clk;
+
+	fd = kzalloc(sizeof(*fd), GFP_KERNEL);
+	if (!fd) {
+		pr_err("%s: could not allocate fractional divider clk\n",
+		       __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	init.name = name;
+	init.ops = &clk_fractional_divider_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	fd->reg = reg;
+	fd->mshift = mshift;
+	fd->mmask = (BIT(mwidth) - 1) << mshift;
+	fd->nshift = nshift;
+	fd->nmask = (BIT(nwidth) - 1) << nshift;
+	fd->flags = clk_divider_flags;
+	fd->lock = lock;
+	fd->hw.init = &init;
+
+	clk = clk_register(dev, &fd->hw);
+	if (IS_ERR(clk))
+		kfree(fd);
+
+	return clk;
+}
+EXPORT_SYMBOL_GPL(clk_register_fractional_divider);
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 5119174..fb4eca6 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -413,6 +413,37 @@ struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned int mult, unsigned int div);
 
+/**
+ * struct clk_fractional_divider - adjustable fractional divider clock
+ *
+ * @hw:		handle between common and hardware-specific interfaces
+ * @reg:	register containing the divider
+ * @mshift:	shift to the numerator bit field
+ * @mwidth:	width of the numerator bit field
+ * @nshift:	shift to the denominator bit field
+ * @nwidth:	width of the denominator bit field
+ * @lock:	register lock
+ *
+ * Clock with adjustable fractional divider affecting its output frequency.
+ */
+
+struct clk_fractional_divider {
+	struct clk_hw	hw;
+	void __iomem	*reg;
+	u8		mshift;
+	u32		mmask;
+	u8		nshift;
+	u32		nmask;
+	u8		flags;
+	spinlock_t	*lock;
+};
+
+extern const struct clk_ops clk_fractional_divider_ops;
+struct clk *clk_register_fractional_divider(struct device *dev,
+		const char *name, const char *parent_name, unsigned long flags,
+		void __iomem *reg, u8 mshift, u8 mwidth, u8 nshift, u8 nwidth,
+		u8 clk_divider_flags, spinlock_t *lock);
+
 /***
  * struct clk_composite - aggregate clock of mux, divider and gate clocks
  *
-- 
2.0.0.rc0

