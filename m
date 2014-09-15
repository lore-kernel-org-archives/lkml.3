Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbaIOKk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:40:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36903 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753754AbaIOKgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:36:22 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 01/12] reset: add the Berlin reset controller driver
Date: Mon, 15 Sep 2014 12:36:07 +0200
Message-Id: <1410777378-12726-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410777378-12726-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1410777378-12726-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a reset controller for Marvell Berlin SoCs which is used by the
USB PHYs drivers (for now).

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/reset/Makefile       |   1 +
 drivers/reset/reset-berlin.c | 131 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 132 insertions(+)
 create mode 100644 drivers/reset/reset-berlin.c

diff --git a/drivers/reset/Makefile b/drivers/reset/Makefile
index 60fed3d7820b..157d421f755b 100644
--- a/drivers/reset/Makefile
+++ b/drivers/reset/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_RESET_CONTROLLER) += core.o
 obj-$(CONFIG_ARCH_SOCFPGA) += reset-socfpga.o
+obj-$(CONFIG_ARCH_BERLIN) += reset-berlin.o
 obj-$(CONFIG_ARCH_SUNXI) += reset-sunxi.o
 obj-$(CONFIG_ARCH_STI) += sti/
diff --git a/drivers/reset/reset-berlin.c b/drivers/reset/reset-berlin.c
new file mode 100644
index 000000000000..f8b48a13cf0b
--- /dev/null
+++ b/drivers/reset/reset-berlin.c
@@ -0,0 +1,131 @@
+/*
+ * Copyright (C) 2014 Marvell Technology Group Ltd.
+ *
+ * Antoine Tenart <antoine.tenart@free-electrons.com>
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/reset-controller.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#define BERLIN_MAX_RESETS	32
+
+#define to_berlin_reset_priv(p)		\
+	container_of((p), struct berlin_reset_priv, rcdev)
+
+struct berlin_reset_priv {
+	void __iomem			*base;
+	unsigned int			size;
+	struct reset_controller_dev	rcdev;
+};
+
+static int berlin_reset_reset(struct reset_controller_dev *rcdev,
+			      unsigned long id)
+{
+	struct berlin_reset_priv *priv = to_berlin_reset_priv(rcdev);
+	int offset = id >> 8;
+	int mask = BIT(id & 0x1f);
+
+	writel(mask, priv->base + offset);
+
+	/* let the reset be effective */
+	udelay(10);
+
+	return 0;
+}
+
+static struct reset_control_ops berlin_reset_ops = {
+	.reset	= berlin_reset_reset,
+};
+
+static int berlin_reset_xlate(struct reset_controller_dev *rcdev,
+			      const struct of_phandle_args *reset_spec)
+{
+	struct berlin_reset_priv *priv = to_berlin_reset_priv(rcdev);
+	unsigned offset, bit;
+
+	if (WARN_ON(reset_spec->args_count != rcdev->of_reset_n_cells))
+		return -EINVAL;
+
+	offset = reset_spec->args[0];
+	bit = reset_spec->args[1];
+
+	if (offset >= priv->size)
+		return -EINVAL;
+
+	if (bit >= BERLIN_MAX_RESETS)
+		return -EINVAL;
+
+	return (offset << 8) | bit;
+}
+
+static int __berlin_reset_init(struct device_node *np)
+{
+	struct berlin_reset_priv *priv;
+	struct resource res;
+	resource_size_t size;
+	int ret;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	ret = of_address_to_resource(np, 0, &res);
+	if (ret)
+		goto err;
+
+	size = resource_size(&res);
+	priv->base = ioremap(res.start, size);
+	if (!priv->base) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	priv->size = size;
+
+	priv->rcdev.owner = THIS_MODULE;
+	priv->rcdev.ops = &berlin_reset_ops;
+	priv->rcdev.of_node = np;
+	priv->rcdev.of_reset_n_cells = 2;
+	priv->rcdev.of_xlate = berlin_reset_xlate;
+
+	reset_controller_register(&priv->rcdev);
+
+	return 0;
+
+err:
+	kfree(priv);
+	return ret;
+}
+
+static const struct of_device_id berlin_reset_of_match[] __initconst = {
+	{ .compatible = "marvell,berlin2-chip-ctrl" },
+	{ .compatible = "marvell,berlin2cd-chip-ctrl" },
+	{ .compatible = "marvell,berlin2q-chip-ctrl" },
+	{ },
+};
+
+static int __init berlin_reset_init(void)
+{
+	struct device_node *np;
+	int ret;
+
+	for_each_matching_node(np, berlin_reset_of_match) {
+		ret = __berlin_reset_init(np);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+arch_initcall(berlin_reset_init);
-- 
1.9.1

