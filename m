Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbaLJPtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:49:16 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56602 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003AbaLJPtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:49:10 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-94-54886b751833
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/CLKDEV SUPPORT),
        linux-gpio@vger.kernel.org (open list:GPIO SUBSYSTEM),
        dri-devel@lists.freedesktop.org (open list:DRM PANEL DRIVERS),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        boris.brezillon@free-electrons.com
Subject: [RFC 08/15] clk: add restrack support
Date: Wed, 10 Dec 2014 16:48:26 +0100
Message-id: <1418226513-14105-9-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xy7ql2R0hBhf2sFjcWneO1eLAi4Us
	FlMfPmGzmH8EyL3y9T2bxblXj1gsDvzZwWjRvHg9m8Wk+xNYLC487WGz+Halg8liyp/lTBab
	Hl9jtdg8/w+jxeVdc9gsZpzfx2Rx+zKvxdojd9ktnk64yGbRuvcIu8XPXfNYHEQ9Wpp72Dye
	bLrI6LFz1l12j02rOtk87lzbw+axf+4ado/73ceZPDYvqffo27KK0eP4je1MHp83yQVwR3HZ
	pKTmZJalFunbJXBlHP14jrngjHLF9+/b2BoYz8p2MXJySAiYSKy++ZcVwhaTuHBvPVsXIxeH
	kMBSRokJfQugnD4miSNTDrGBVLEJaEr83XwTzBYR0JG43tPNDFLELLCBXWLd9H1gCWEBPYnp
	rzcCjeXgYBFQlfjcFQUS5hVwlpg55SALxDY5iZPHJoNt5hRwkfj7fC8jiC0EVLNk23vWCYy8
	CxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKExMbXHYxLj1kdYhTgYFTi4d2h2BYixJpY
	VlyZe4hRgoNZSYR3YXJHiBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGgRkrQpMvzAnRfr4g5vKE
	l6b8Z/Z6M+2c51cZ8Ou/rXl6roX31bOb3kqXCjdk6+tnXLmxKMvlTX4+s96HrR93vQ0/ltG2
	soKHRf+sp/zBKHkN6fLCg4ZfUp6yb44/eszm9ISc1ZknLNPtW7aWWXY8XXn2lOGfN///3Fns
	8l9a/n9zVoju35tMSizFGYmGWsxFxYkAvDqRp2sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clocks supports different methods of lookup.
The patch adds restrack support only to DT based clocks.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/clk/clk.c        |  6 ++++
 drivers/clk/clkdev.c     | 74 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk.h      |  3 ++
 include/linux/restrack.h |  1 +
 4 files changed, 84 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 4896ae9..2c50204 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -16,6 +16,7 @@
 #include <linux/spinlock.h>
 #include <linux/err.h>
 #include <linux/list.h>
+#include <linux/restrack.h>
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/device.h>
@@ -2476,6 +2477,9 @@ int of_clk_add_provider(struct device_node *np,
 	ret = of_clk_set_defaults(np, true);
 	if (ret < 0)
 		of_clk_del_provider(np);
+	else
+		restrack_up(RESTRACK_TYPE_CLOCK, cp->node, cp);
+
 
 	return ret;
 }
@@ -2489,6 +2493,8 @@ void of_clk_del_provider(struct device_node *np)
 {
 	struct of_clk_provider *cp;
 
+	restrack_down(RESTRACK_TYPE_CLOCK, np, NULL);
+
 	mutex_lock(&of_clk_mutex);
 	list_for_each_entry(cp, &of_clk_providers, link) {
 		if (cp->node == np) {
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index bd22750..2532ea1 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -20,6 +20,7 @@
 #include <linux/clk.h>
 #include <linux/clkdev.h>
 #include <linux/of.h>
+#include <linux/restrack.h>
 
 #include "clk.h"
 
@@ -143,6 +144,79 @@ static int of_get_clock_spec(struct device *dev, const char *name,
 
 	return -ENOENT;
 }
+
+struct clk_restrack_desc {
+	struct clk **ptr;
+	const char *name;
+	struct of_phandle_args spec;
+	struct restrack_desc desc;
+};
+
+static int clk_restrack_init(struct device *dev,
+		struct restrack_desc *desc)
+{
+	struct clk_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+	int ret;
+
+	ret = of_get_clock_spec(dev, rd->name, &rd->spec);
+	if (!ret)
+		desc->if_id = rd->spec.np;
+	return ret;
+}
+
+static void clk_restrack_destroy(struct device *dev,
+		struct restrack_desc *desc)
+{
+	struct clk_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+
+	of_node_put(desc->if_id);
+	kfree(rd);
+}
+
+static int clk_restrack_ifup(struct device *dev,
+		struct restrack_desc *desc, void *data)
+{
+	struct clk_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+
+	*rd->ptr = of_clk_get_by_clkspec(&rd->spec);
+	return PTR_ERR_OR_ZERO(*rd->ptr);
+}
+
+static void clk_restrack_ifdown(struct device *dev,
+		struct restrack_desc *desc, void *data)
+{
+	struct clk_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+
+	clk_put(*rd->ptr);
+	*rd->ptr = ERR_PTR(-EPROBE_DEFER);
+}
+
+static const struct restrack_ops clk_restrack_ops = {
+	.if_type = RESTRACK_TYPE_CLOCK,
+	.init = clk_restrack_init,
+	.destroy = clk_restrack_destroy,
+	.if_up = clk_restrack_ifup,
+	.if_down = clk_restrack_ifdown,
+};
+
+/**
+ * clk_restrack_desc - clock resource descriptor allocator
+ * @clk: pointer to variable which will be set to clock handle
+ * @name: name of clock
+ *
+ * The function creates resource description for clock, which shall be used
+ * by *restrack_register functions.
+ */
+struct restrack_desc *clk_restrack_desc(struct clk **clock, const char *name)
+{
+	struct clk_restrack_desc *rd;
+
+	RESTRACK_DESC_ALLOC(rd, clk_restrack_ops, clock, name);
+
+	return rd ? &rd->desc : ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL_GPL(clk_restrack_desc);
+
 #endif
 
 /*
diff --git a/include/linux/clk.h b/include/linux/clk.h
index c7f258a..28bad95 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -428,6 +428,9 @@ struct of_phandle_args;
 struct clk *of_clk_get(struct device_node *np, int index);
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
 struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
+
+struct restrack_desc;
+struct restrack_desc *clk_restrack_desc(struct clk **clock, const char *name);
 #else
 static inline struct clk *of_clk_get(struct device_node *np, int index)
 {
diff --git a/include/linux/restrack.h b/include/linux/restrack.h
index e1aded0..6707dce 100644
--- a/include/linux/restrack.h
+++ b/include/linux/restrack.h
@@ -6,6 +6,7 @@
 #define RESTRACK_TYPE_DRM_PANEL 1
 #define RESTRACK_TYPE_REGULATOR 2
 #define RESTRACK_TYPE_GPIO 3
+#define RESTRACK_TYPE_CLOCK 4
 
 struct device;
 struct restrack_ctx;
-- 
1.9.1

