Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993AbaGPI0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:26:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60587 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756715AbaGPI0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:26:10 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/12] reset: add the Berlin reset controller driver
Date: Wed, 16 Jul 2014 10:25:55 +0200
Message-Id: <1405499166-6726-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a reset controller for Marvell Berlin SoCs which is used by the
USB PHYs drivers (for now).

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
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
index 000000000000..7b894047a81d
--- /dev/null
+++ b/drivers/reset/reset-berlin.c
@@ -0,0 +1,131 @@
+/*
+ * Copyright (C) 2014 Marvell Technology Group Ltd.
+ *
+ * Antoine Ténart <antoine.tenart@free-electrons.com>
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
+	int mask = BIT(id & 0xff);
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

