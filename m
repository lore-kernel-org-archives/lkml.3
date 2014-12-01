Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaLAHie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 02:38:34 -0500
Received: from regular1.263xmail.com ([211.150.99.137]:39195 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaLAHic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 02:38:32 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jay.xu@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <b5b84d07bd1f52faeb2322689f64ae23>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun Xu <jay.xu@rock-chips.com>
To: heiko@sntech.de, linux@arm.linux.org.uk, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH 2/2] rockchip: efuse: add efuse driver for rk3288 efuse
Date: Mon,  1 Dec 2014 15:34:41 +0800
Message-Id: <1417419281-9243-3-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417419281-9243-1-git-send-email-jay.xu@rock-chips.com>
References: <1417419281-9243-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add driver for efuse found on rk3288 board based on rk3288 SoC.
Driver will read fuse information of chip at the boot stage of
kernel, this information new is for further usage.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
 arch/arm/mach-rockchip/efuse.c | 165 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-rockchip/efuse.h |  15 ++++
 2 files changed, 180 insertions(+)
 create mode 100644 arch/arm/mach-rockchip/efuse.c
 create mode 100644 arch/arm/mach-rockchip/efuse.h

diff --git a/arch/arm/mach-rockchip/efuse.c b/arch/arm/mach-rockchip/efuse.c
new file mode 100644
index 0000000..326d81e
--- /dev/null
+++ b/arch/arm/mach-rockchip/efuse.c
@@ -0,0 +1,165 @@
+/* mach-rockchip/efuse.c
+ *
+ * Copyright (c) 2014 Rockchip Electronics Co. Ltd.
+ * Author: Jianqun Xu <jay.xu@rock-chips.com>
+ *
+ * Tmis program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * Tmis program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * tmis program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Tme full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+
+#include "efuse.h"
+
+#define EFUSE_BUF_SIZE	(32)
+#define EFUSE_BUF_LKG_CPU	(23)
+#define EFUSE_BUF_LKG_GPU	(24)
+#define EFUSE_BUF_LKG_LOG	(25)
+
+struct rk_efuse_info {
+	/* Platform device */
+	struct device *dev;
+
+	/* Hardware resources */
+	void __iomem *regs;
+
+	/* buffer to store registers' values */
+	unsigned int buf[EFUSE_BUF_SIZE];
+};
+
+static void efuse_writel(struct rk_efuse_info *efuse,
+			 unsigned int value,
+			 unsigned int offset)
+{
+	writel_relaxed(value, efuse->regs + offset);
+}
+
+static unsigned int efuse_readl(struct rk_efuse_info *efuse,
+				unsigned int offset)
+{
+	return readl_relaxed(efuse->regs + offset);
+}
+
+static unsigned int rockchip_efuse_leakage(struct rk_efuse_info *efuse,
+					 int channel)
+{
+	switch (channel) {
+	case EFUSE_BUF_LKG_CPU:
+	case EFUSE_BUF_LKG_GPU:
+	case EFUSE_BUF_LKG_LOG:
+		return efuse->buf[channel];
+	default:
+		dev_err(efuse->dev, "unknown channel\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void rockchip_efuse_info(struct rk_efuse_info *efuse)
+{
+	dev_info(efuse->dev, "leakage (%d %d %d)\n",
+		 rockchip_efuse_leakage(efuse, EFUSE_BUF_LKG_CPU),
+		 rockchip_efuse_leakage(efuse, EFUSE_BUF_LKG_GPU),
+		 rockchip_efuse_leakage(efuse, EFUSE_BUF_LKG_LOG));
+}
+
+static int rockchip_efuse_init(struct rk_efuse_info *efuse)
+{
+	int start = 0;
+	int ret = 0;
+
+	efuse_writel(efuse, EFUSE_CSB, REG_EFUSE_CTRL);
+	efuse_writel(efuse, EFUSE_LOAD | EFUSE_PGENB, REG_EFUSE_CTRL);
+	udelay(2);
+
+	for (start = 0; start <= EFUSE_BUF_SIZE; start++) {
+		efuse_writel(efuse, efuse_readl(efuse, REG_EFUSE_CTRL) &
+			     (~(EFUSE_A_MASK << EFUSE_A_SHIFT)),
+			     REG_EFUSE_CTRL);
+		efuse_writel(efuse, efuse_readl(efuse, REG_EFUSE_CTRL) |
+			     ((start & EFUSE_A_MASK) << EFUSE_A_SHIFT),
+			     REG_EFUSE_CTRL);
+		udelay(2);
+		efuse_writel(efuse, efuse_readl(efuse, REG_EFUSE_CTRL) |
+			     EFUSE_STROBE, REG_EFUSE_CTRL);
+		udelay(2);
+
+		efuse->buf[start] = efuse_readl(efuse, REG_EFUSE_DOUT);
+
+		efuse_writel(efuse, efuse_readl(efuse, REG_EFUSE_CTRL) &
+			     (~EFUSE_STROBE), REG_EFUSE_CTRL);
+		udelay(2);
+	}
+
+	udelay(2);
+	efuse_writel(efuse, efuse_readl(efuse, REG_EFUSE_CTRL) |
+		     EFUSE_CSB, REG_EFUSE_CTRL);
+	udelay(2);
+
+	return ret;
+}
+
+static int rockchip_efuse_probe(struct platform_device *pdev)
+{
+	struct rk_efuse_info *efuse;
+	struct resource *mem;
+	int ret = 0;
+
+	efuse = devm_kzalloc(&pdev->dev, sizeof(*efuse), GFP_KERNEL);
+	if (!efuse)
+		return -ENOMEM;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	efuse->regs = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(efuse->regs))
+		return PTR_ERR(efuse->regs);
+
+	platform_set_drvdata(pdev, efuse);
+	efuse->dev = &pdev->dev;
+
+	ret = rockchip_efuse_init(efuse);
+	if (!ret)
+		rockchip_efuse_info(efuse);
+
+	return ret;
+}
+
+static const struct of_device_id rockchip_efuse_match[] = {
+	{ .compatible = "rockchip,rk3288-efuse", },
+	{},
+};
+
+static struct platform_driver rockchip_efuse_driver = {
+	.probe = rockchip_efuse_probe,
+	.driver = {
+		.name = "rk3288-efuse",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(rockchip_efuse_match),
+	},
+};
+
+module_platform_driver(rockchip_efuse_driver);
+
+MODULE_DESCRIPTION("Rockchip eFuse Driver");
+MODULE_AUTHOR("Jianqun Xu <jay.xu@rock-chips.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/arch/arm/mach-rockchip/efuse.h b/arch/arm/mach-rockchip/efuse.h
new file mode 100644
index 0000000..3fdcf6d
--- /dev/null
+++ b/arch/arm/mach-rockchip/efuse.h
@@ -0,0 +1,15 @@
+#ifndef _ARCH_ROCKCHIP_EFUSE_H_
+#define _ARCH_ROCKCHIP_EFUSE_H_
+
+/* Rockchip eFuse controller register */
+#define EFUSE_A_SHIFT		(6)
+#define EFUSE_A_MASK		(0x3FF)
+#define EFUSE_PGENB		(1 << 3)
+#define EFUSE_LOAD		(1 << 2)
+#define EFUSE_STROBE		(1 << 1)
+#define EFUSE_CSB		(1 << 0)
+
+#define REG_EFUSE_CTRL		(0x0000)
+#define REG_EFUSE_DOUT		(0x0004)
+
+#endif /* _ARCH_ROCKCHIP_EFUSE_H_ */
-- 
1.9.1


