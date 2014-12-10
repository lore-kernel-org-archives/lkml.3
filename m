Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbaLJPwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:52:33 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60985 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877AbaLJPtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:49:06 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-87-54886b713c53
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
Subject: [RFC 06/15] gpio: add restrack support
Date: Wed, 10 Dec 2014 16:48:24 +0100
Message-id: <1418226513-14105-7-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xy7qF2R0hBtM2CVncWneO1eLAi4Us
	FlMfPmGzmH8EyL3y9T2bxblXj1gsDvzZwWjRvHg9m8Wk+xNYLC487WGz+Halg8liyp/lTBab
	Hl9jtdg8/w+jxeVdc9gsZpzfx2Rx+zKvxdojd9ktnk64yGbRuvcIu8XPXfNYHEQ9Wpp72Dye
	bLrI6LFz1l12j02rOtk87lzbw+axf+4ado/73ceZPDYvqffo27KK0eP4je1MHp83yQVwR3HZ
	pKTmZJalFunbJXBlTJy/mq1gnVLFneZvrA2Mt2S6GDk4JARMJCbt4exi5AQyxSQu3FvP1sXI
	xSEksJRRonHyFUYIp49J4sz5BkaQKjYBTYm/m2+ygdgiAjoS13u6mUGKmAU2sEusm74PLCEs
	oC+xadMzJhCbRUBV4vqaF2DNvALOEidufWCFWCcncfLYZDCbU8BF4u/zvWA1QkA1S7a9Z53A
	yLuAkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkhsfN3BuPSY1SFGAQ5GJR7eHYptIUKs
	iWXFlbmHGCU4mJVEeBcmd4QI8aYkVlalFuXHF5XmpBYfYmTi4JRqYNS5ypAhMTv97CVltgtn
	n9st/qLcE+QWLWF6tt+vPO/DAS+PgK1RE/abps2I/Tr7wA1dbkN3HWPnoLmtDgwfVZV1LEy2
	h2aHvJKRVTn9Qy+1o6Pq/WS9t4Vzvq48OiOzrm/zh96dJt2JfWH7rn5fGfB6wSGxq4fvBrV2
	frlQ8v3FfOWCk9MP7VViKc5INNRiLipOBADpOWoyawIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO supports different methods of lookup.
The patch adds restrack support only to DT based GPIOs.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpio/gpiolib.c        | 81 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/gpio/consumer.h |  4 +++
 include/linux/restrack.h      |  1 +
 3 files changed, 86 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 78fcec9..5d85e20 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -15,6 +15,7 @@
 #include <linux/acpi.h>
 #include <linux/gpio/driver.h>
 #include <linux/gpio/machine.h>
+#include <linux/restrack.h>
 
 #include "gpiolib.h"
 
@@ -278,6 +279,8 @@ int gpiochip_add(struct gpio_chip *chip)
 	if (status)
 		goto fail;
 
+	restrack_up(RESTRACK_TYPE_GPIO, chip->of_node, chip);
+
 	status = gpiochip_export(chip);
 	if (status)
 		goto fail;
@@ -313,6 +316,7 @@ void gpiochip_remove(struct gpio_chip *chip)
 	unsigned long	flags;
 	unsigned	id;
 
+	restrack_down(RESTRACK_TYPE_GPIO, chip->of_node, chip);
 	acpi_gpiochip_remove(chip);
 
 	spin_lock_irqsave(&gpio_lock, flags);
@@ -1770,6 +1774,83 @@ void gpiod_put(struct gpio_desc *desc)
 }
 EXPORT_SYMBOL_GPL(gpiod_put);
 
+struct gpiod_restrack_desc {
+	struct gpio_desc **ptr;
+	const char *name;
+	enum gpiod_flags flags;
+	struct of_phandle_args spec;
+	struct restrack_desc desc;
+};
+
+static int gpiod_restrack_init(struct device *dev, struct restrack_desc *desc)
+{
+	struct gpiod_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+	int ret;
+
+	ret = of_get_gpiod_spec(dev, rd->name, 0, &rd->spec);
+	if (!ret)
+		desc->if_id = rd->spec.np;
+	return ret;
+}
+
+static void gpiod_restrack_destroy(struct device *dev,
+		struct restrack_desc *desc)
+{
+	struct gpiod_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+
+	of_node_put(desc->if_id);
+	kfree(rd);
+}
+
+static int gpiod_restrack_ifup(struct device *dev, struct restrack_desc *desc,
+		void *data)
+{
+	struct gpiod_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+
+	*rd->ptr = gpiod_get(dev, rd->name, rd->flags);
+	return PTR_ERR_OR_ZERO(*rd->ptr);
+}
+
+static void gpiod_restrack_ifdown(struct device *dev,
+		struct restrack_desc *desc, void *data)
+{
+	struct gpiod_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+
+	gpiod_put(*rd->ptr);
+	*rd->ptr = ERR_PTR(-EPROBE_DEFER);
+}
+
+static const struct restrack_ops gpiod_restrack_ops = {
+	.if_type = RESTRACK_TYPE_GPIO,
+	.init = gpiod_restrack_init,
+	.destroy = gpiod_restrack_destroy,
+	.if_up = gpiod_restrack_ifup,
+	.if_down = gpiod_restrack_ifdown,
+};
+
+/**
+ * gpiod_restrack_desc - gpio resource descriptor allocator
+ * @gpiod: pointer to variable which will be set to gpiod handle
+ * @name: name of gpio
+ * @flags: gpiod flags
+ *
+ * The function creates resource description for gpio, which shall be used
+ * by *restrack_register functions.
+ */
+struct restrack_desc *gpiod_restrack_desc(struct gpio_desc **gpiod,
+		const char *con_id, enum gpiod_flags flags)
+{
+	struct gpiod_restrack_desc *rd;
+
+	RESTRACK_DESC_ALLOC(rd, gpiod_restrack_ops, gpiod, con_id);
+	if (!rd)
+		return ERR_PTR(-ENOMEM);
+
+	rd->flags = flags;
+	return &rd->desc;
+}
+EXPORT_SYMBOL_GPL(gpiod_restrack_desc);
+
 #ifdef CONFIG_DEBUG_FS
 
 static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 12f146f..55f2e4e 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -94,6 +94,10 @@ int gpiod_to_irq(const struct gpio_desc *desc);
 struct gpio_desc *gpio_to_desc(unsigned gpio);
 int desc_to_gpio(const struct gpio_desc *desc);
 
+struct restrack_desc;
+struct restrack_desc *gpiod_restrack_desc(struct gpio_desc **gpiod,
+		const char *con_id, enum gpiod_flags flags);
+
 #else /* CONFIG_GPIOLIB */
 
 static inline struct gpio_desc *__must_check __gpiod_get(struct device *dev,
diff --git a/include/linux/restrack.h b/include/linux/restrack.h
index 4e4eec6..e1aded0 100644
--- a/include/linux/restrack.h
+++ b/include/linux/restrack.h
@@ -5,6 +5,7 @@
 
 #define RESTRACK_TYPE_DRM_PANEL 1
 #define RESTRACK_TYPE_REGULATOR 2
+#define RESTRACK_TYPE_GPIO 3
 
 struct device;
 struct restrack_ctx;
-- 
1.9.1

