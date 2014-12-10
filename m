Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbaLJPw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:52:56 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:8751 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967AbaLJPtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:49:02 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-a3-54886b6ce4fd
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
Subject: [RFC 04/15] regulator: add restrack support
Date: Wed, 10 Dec 2014 16:48:22 +0100
Message-id: <1418226513-14105-5-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xy7o52R0hBtOWylvcWneO1eLAi4Us
	FlMfPmGzmH8EyL3y9T2bxblXj1gsDvzZwWjRvHg9m8Wk+xNYLC487WGz+Halg8liyp/lTBab
	Hl9jtdg8/w+jxeVdc9gsZpzfx2Rx+zKvxdojd9ktnk64yGbRuvcIu8XPXfNYHEQ9Wpp72Dye
	bLrI6LFz1l12j02rOtk87lzbw+axf+4ado/73ceZPDYvqffo27KK0eP4je1MHp83yQVwR3HZ
	pKTmZJalFunbJXBlXPxxgb2gW7li37TFrA2MJ2W7GDk5JARMJPadf88CYYtJXLi3nq2LkYtD
	SGApo8ScW2ugnD4miRXvFzCBVLEJaEr83XyTDcQWEdCRuN7TzQxSxCywgV1i3fR9YAlhoLFr
	p79nBLFZBFQlendPB1rBzsEr4CxxQAZimZzEyWOTWUFsTgEXib/P94JVCwFVLNn2nnUCI+8C
	RoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCGR8WUH4+JjVocYBTgYlXh4zRVbQ4RYE8uK
	K3MPMUpwMCuJ8C5M7ggR4k1JrKxKLcqPLyrNSS0+xMjEwSnVwKh2UCvhznEvm+8xZz9/ZX98
	XeGTwVuDB48L1gtGbrWJrKgrDd/h/YTn/cfJh6Ufxx5J1Ft2p4vv0Mm9SoqGFZOUegstZTR8
	9A/edm3p4zReOq9XSrfQlPOqPJ9g/IE5WdXTbl95uEM0Xya84IMVy7rmvcEK4o7pJiv3uFy+
	c8CPweR1Z+Tk00osxRmJhlrMRcWJAAPLpV1qAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulators supports various methods of lookup.
The patch adds restrack support only to DT based regulators.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/regulator/core.c           | 77 ++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h | 10 +++++
 include/linux/restrack.h           |  1 +
 3 files changed, 88 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cd87c0c..5641e85 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -32,6 +32,7 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/module.h>
+#include <linux/restrack.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/regulator.h>
@@ -3733,6 +3734,10 @@ add_dev:
 	rdev_init_debugfs(rdev);
 out:
 	mutex_unlock(&regulator_list_mutex);
+
+	if (rdev->dev.of_node)
+		restrack_up(RESTRACK_TYPE_REGULATOR, rdev->dev.of_node, rdev);
+
 	return rdev;
 
 unset_supplies:
@@ -3767,6 +3772,9 @@ void regulator_unregister(struct regulator_dev *rdev)
 	if (rdev == NULL)
 		return;
 
+	if (rdev->dev.of_node)
+		restrack_down(RESTRACK_TYPE_REGULATOR, rdev->dev.of_node, rdev);
+
 	if (rdev->supply) {
 		while (rdev->use_count--)
 			regulator_disable(rdev->supply);
@@ -3971,6 +3979,75 @@ static const struct file_operations supply_map_fops = {
 #endif
 };
 
+struct regulator_restrack_desc {
+	struct regulator **ptr;
+	const char *name;
+	struct restrack_desc desc;
+};
+
+static int regulator_restrack_init(struct device *dev,
+		struct restrack_desc *desc)
+{
+	struct regulator_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+
+	desc->if_id = of_get_regulator(dev, rd->name);
+	return PTR_ERR_OR_ZERO(desc->if_id);
+}
+
+static void regulator_restrack_destroy(struct device *dev,
+		struct restrack_desc *desc)
+{
+	struct regulator_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+
+	of_node_put(desc->if_id);
+	kfree(rd);
+}
+
+static int regulator_restrack_ifup(struct device *dev,
+		struct restrack_desc *desc, void *data)
+{
+	struct regulator_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+
+	*rd->ptr = regulator_get(dev, rd->name);
+	return PTR_ERR_OR_ZERO(*rd->ptr);
+}
+
+static void regulator_restrack_ifdown(struct device *dev,
+		struct restrack_desc *desc, void *data)
+{
+	struct regulator_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+
+	regulator_put(*rd->ptr);
+	*rd->ptr = ERR_PTR(-EPROBE_DEFER);
+}
+
+static const struct restrack_ops regulator_restrack_ops = {
+	.if_type = RESTRACK_TYPE_REGULATOR,
+	.init = regulator_restrack_init,
+	.destroy = regulator_restrack_destroy,
+	.if_up = regulator_restrack_ifup,
+	.if_down = regulator_restrack_ifdown,
+};
+
+/**
+ * regulator_restrack_desc - regulator resource descriptor allocator
+ * @regulator: pointer to variable which will be set to regulator handle
+ * @name: name of regulator
+ *
+ * The function creates resource description for regulator, which shall be used
+ * by *restrack_register functions.
+ */
+struct restrack_desc *regulator_restrack_desc(struct regulator **regulator,
+		const char *name)
+{
+	struct regulator_restrack_desc *rd;
+
+	RESTRACK_DESC_ALLOC(rd, regulator_restrack_ops, regulator, name);
+
+	return rd ? &rd->desc : ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL_GPL(regulator_restrack_desc);
+
 static int __init regulator_init(void)
 {
 	int ret;
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index f540b14..69e71ebb 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -551,4 +551,14 @@ static inline int regulator_is_supported_voltage_tol(struct regulator *regulator
 					      target_uV + tol_uV);
 }
 
+struct restrack_desc;
+struct restrack_desc *regulator_restrack_desc(struct regulator **regulator,
+		const char *supply);
+
+static inline struct restrack_desc *
+regulator_bulk_restrack_desc(struct regulator_bulk_data *data)
+{
+	return regulator_restrack_desc(&data->consumer, data->supply);
+}
+
 #endif
diff --git a/include/linux/restrack.h b/include/linux/restrack.h
index af5b617..4e4eec6 100644
--- a/include/linux/restrack.h
+++ b/include/linux/restrack.h
@@ -4,6 +4,7 @@
 #include <linux/track.h>
 
 #define RESTRACK_TYPE_DRM_PANEL 1
+#define RESTRACK_TYPE_REGULATOR 2
 
 struct device;
 struct restrack_ctx;
-- 
1.9.1

