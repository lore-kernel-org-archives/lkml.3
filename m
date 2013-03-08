Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176Ab3CHNst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:48:49 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9538 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058Ab3CHNsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:48:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 08 Mar 2013 05:42:08 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <airlied@linux.ie>, <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv6 1/9] gpu: host1x: Add host1x driver
Date: Fri, 8 Mar 2013 15:46:53 +0200
Message-ID: <1362750421-18080-2-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362750421-18080-1-git-send-email-tbergstrom@nvidia.com>
References: <1362750421-18080-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add host1x, the driver for host1x and its client unit 2D. The Tegra
host1x module is the DMA engine for register access to Tegra's
graphics- and multimedia-related modules. The modules served by
host1x are referred to as clients. host1x includes some other
functionality, such as synchronization.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/Makefile                      |    1 +
 drivers/gpu/host1x/Kconfig                |    9 ++
 drivers/gpu/host1x/Makefile               |    8 ++
 drivers/gpu/host1x/dev.c                  |  155 +++++++++++++++++++++
 drivers/gpu/host1x/dev.h                  |  104 ++++++++++++++
 drivers/gpu/host1x/hw/Makefile            |    6 +
 drivers/gpu/host1x/hw/host1x01.c          |   33 +++++
 drivers/gpu/host1x/hw/host1x01.h          |   25 ++++
 drivers/gpu/host1x/hw/host1x01_hardware.h |   27 ++++
 drivers/gpu/host1x/hw/hw_host1x01_sync.h  |   74 ++++++++++
 drivers/gpu/host1x/hw/syncpt_hw.c         |  102 ++++++++++++++
 drivers/gpu/host1x/syncpt.c               |  212 +++++++++++++++++++++++++++++
 drivers/gpu/host1x/syncpt.h               |  147 ++++++++++++++++++++
 drivers/video/Kconfig                     |    2 +
 include/trace/events/host1x.h             |   61 +++++++++
 15 files changed, 966 insertions(+)
 create mode 100644 drivers/gpu/host1x/Kconfig
 create mode 100644 drivers/gpu/host1x/Makefile
 create mode 100644 drivers/gpu/host1x/dev.c
 create mode 100644 drivers/gpu/host1x/dev.h
 create mode 100644 drivers/gpu/host1x/hw/Makefile
 create mode 100644 drivers/gpu/host1x/hw/host1x01.c
 create mode 100644 drivers/gpu/host1x/hw/host1x01.h
 create mode 100644 drivers/gpu/host1x/hw/host1x01_hardware.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_sync.h
 create mode 100644 drivers/gpu/host1x/hw/syncpt_hw.c
 create mode 100644 drivers/gpu/host1x/syncpt.c
 create mode 100644 drivers/gpu/host1x/syncpt.h
 create mode 100644 include/trace/events/host1x.h

diff --git a/drivers/gpu/Makefile b/drivers/gpu/Makefile
index 30879df..d8a22c2 100644
--- a/drivers/gpu/Makefile
+++ b/drivers/gpu/Makefile
@@ -1 +1,2 @@
 obj-y			+= drm/ vga/
+obj-$(CONFIG_TEGRA_HOST1X)	+= host1x/
diff --git a/drivers/gpu/host1x/Kconfig b/drivers/gpu/host1x/Kconfig
new file mode 100644
index 0000000..c01c450
--- /dev/null
+++ b/drivers/gpu/host1x/Kconfig
@@ -0,0 +1,9 @@
+config TEGRA_HOST1X
+	tristate "NVIDIA Tegra host1x driver"
+	help
+	  Driver for the NVIDIA Tegra host1x hardware.
+
+	  The Tegra host1x module is the DMA engine for register access to
+	  Tegra's graphics- and multimedia-related modules. The modules served
+	  by host1x are referred to as clients. host1x includes some other
+	  functionality, such as synchronization.
diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
new file mode 100644
index 0000000..363e6ab
--- /dev/null
+++ b/drivers/gpu/host1x/Makefile
@@ -0,0 +1,8 @@
+ccflags-y = -Idrivers/gpu/host1x
+
+host1x-y = \
+	syncpt.o \
+	dev.o \
+	hw/host1x01.o
+
+obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
new file mode 100644
index 0000000..d95a9b2
--- /dev/null
+++ b/drivers/gpu/host1x/dev.c
@@ -0,0 +1,155 @@
+/*
+ * Tegra host1x driver
+ *
+ * Copyright (c) 2010-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/host1x.h>
+
+#include "dev.h"
+#include "hw/host1x01.h"
+
+void host1x_sync_writel(struct host1x *host1x, u32 v, u32 r)
+{
+	void __iomem *sync_regs = host1x->regs + host1x->info->sync_offset;
+
+	writel(v, sync_regs + r);
+}
+
+u32 host1x_sync_readl(struct host1x *host1x, u32 r)
+{
+	void __iomem *sync_regs = host1x->regs + host1x->info->sync_offset;
+
+	return readl(sync_regs + r);
+}
+
+static const struct host1x_info host1x01_info = {
+	.nb_channels	= 8,
+	.nb_pts		= 32,
+	.nb_mlocks	= 16,
+	.nb_bases	= 8,
+	.init		= host1x01_init,
+	.sync_offset	= 0x3000,
+};
+
+static struct of_device_id host1x_match[] = {
+	{ .compatible = "nvidia,tegra30-host1x", .data = &host1x01_info, },
+	{ .compatible = "nvidia,tegra20-host1x", .data = &host1x01_info, },
+	{ },
+};
+
+static int host1x_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct host1x *host;
+	struct resource *regs;
+	int syncpt_irq;
+	int err;
+	const struct of_device_id *devid =
+		of_match_device(host1x_match, dev);
+
+	if (!devid)
+		return -EINVAL;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		dev_err(dev, "missing regs\n");
+		return -ENXIO;
+	}
+
+	syncpt_irq = platform_get_irq(pdev, 0);
+	if (syncpt_irq < 0) {
+		dev_err(dev, "missing irq\n");
+		return -ENXIO;
+	}
+
+	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
+	if (!host) {
+		dev_err(dev, "failed to alloc host1x\n");
+		return -ENOMEM;
+	}
+
+	host->dev = dev;
+	host->info = devid->data;
+
+	/* set common host1x device data */
+	dev_set_drvdata(dev, host);
+
+	host->regs = devm_ioremap_resource(&pdev->dev, regs);
+	if (IS_ERR(host->regs)) {
+		dev_err(dev, "failed to remap host registers\n");
+		return PTR_ERR(host->regs);
+	}
+
+	if (host->info->init) {
+		err = host->info->init(host);
+		if (err)
+			return err;
+	}
+
+	host->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(host->clk)) {
+		dev_err(dev, "failed to get clock\n");
+		err = PTR_ERR(host->clk);
+		return err;
+	}
+
+	err = clk_prepare_enable(host->clk);
+	if (err < 0) {
+		dev_err(dev, "failed to enable clock\n");
+		return err;
+	}
+
+	err = host1x_syncpt_init(host);
+	if (err) {
+		dev_err(dev, "failed to init syncpts");
+		return err;
+	}
+
+	return 0;
+}
+
+static int __exit host1x_remove(struct platform_device *pdev)
+{
+	struct host1x *host = platform_get_drvdata(pdev);
+	host1x_syncpt_deinit(host);
+	clk_disable_unprepare(host->clk);
+	return 0;
+}
+
+static struct platform_driver platform_driver = {
+	.probe = host1x_probe,
+	.remove = __exit_p(host1x_remove),
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "tegra-host1x",
+		.of_match_table = host1x_match,
+	},
+};
+
+module_platform_driver(platform_driver);
+
+MODULE_AUTHOR("Terje Bergstrom <tbergstrom@nvidia.com>");
+MODULE_DESCRIPTION("Host1x driver for Tegra products");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
new file mode 100644
index 0000000..750daa3
--- /dev/null
+++ b/drivers/gpu/host1x/dev.h
@@ -0,0 +1,104 @@
+/*
+ * Copyright (c) 2012-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef HOST1X_DEV_H
+#define HOST1X_DEV_H
+
+#include <linux/platform_device.h>
+#include <linux/device.h>
+
+#include "syncpt.h"
+
+struct host1x_syncpt;
+
+struct host1x_syncpt_ops {
+	void (*restore)(struct host1x_syncpt *syncpt);
+	void (*restore_wait_base)(struct host1x_syncpt *syncpt);
+	void (*load_wait_base)(struct host1x_syncpt *syncpt);
+	u32 (*load)(struct host1x_syncpt *syncpt);
+	void (*cpu_incr)(struct host1x_syncpt *syncpt);
+	int (*patch_wait)(struct host1x_syncpt *syncpt, void *patch_addr);
+};
+
+struct host1x_info {
+	int	nb_channels;		/* host1x: num channels supported */
+	int	nb_pts;			/* host1x: num syncpoints supported */
+	int	nb_bases;		/* host1x: num syncpoints supported */
+	int	nb_mlocks;		/* host1x: number of mlocks */
+	int	(*init)(struct host1x *); /* initialize per SoC ops */
+	int	sync_offset;
+};
+
+struct host1x {
+	const struct host1x_info *info;
+
+	void __iomem *regs;
+	struct host1x_syncpt *syncpt;
+	struct device *dev;
+	struct clk *clk;
+
+	const struct host1x_syncpt_ops *syncpt_op;
+};
+
+static inline struct host1x *host1x_get_host(struct device *dev)
+{
+	if (dev->parent && dev->parent != &platform_bus)
+		return dev_get_drvdata(dev->parent);
+	else
+		return dev_get_drvdata(dev);
+}
+
+void host1x_sync_writel(struct host1x *host1x, u32 r, u32 v);
+u32 host1x_sync_readl(struct host1x *host1x, u32 r);
+
+static inline void host1x_hw_syncpt_restore(struct host1x *host,
+					    struct host1x_syncpt *sp)
+{
+	host->syncpt_op->restore(sp);
+}
+
+static inline void host1x_hw_syncpt_restore_wait_base(struct host1x *host,
+						      struct host1x_syncpt *sp)
+{
+	host->syncpt_op->restore_wait_base(sp);
+}
+
+static inline void host1x_hw_syncpt_load_wait_base(struct host1x *host,
+						   struct host1x_syncpt *sp)
+{
+	host->syncpt_op->load_wait_base(sp);
+}
+
+static inline u32 host1x_hw_syncpt_load(struct host1x *host,
+					struct host1x_syncpt *sp)
+{
+	return host->syncpt_op->load(sp);
+}
+
+static inline void host1x_hw_syncpt_cpu_incr(struct host1x *host,
+					     struct host1x_syncpt *sp)
+{
+	host->syncpt_op->cpu_incr(sp);
+}
+
+static inline int host1x_hw_syncpt_patch_wait(struct host1x *host,
+					      struct host1x_syncpt *sp,
+					      void *patch_addr)
+{
+	return host->syncpt_op->patch_wait(sp, patch_addr);
+}
+
+#endif
diff --git a/drivers/gpu/host1x/hw/Makefile b/drivers/gpu/host1x/hw/Makefile
new file mode 100644
index 0000000..9b50863
--- /dev/null
+++ b/drivers/gpu/host1x/hw/Makefile
@@ -0,0 +1,6 @@
+ccflags-y = -Idrivers/gpu/host1x
+
+host1x-hw-objs  = \
+	host1x01.o
+
+obj-$(CONFIG_TEGRA_HOST1X) += host1x-hw.o
diff --git a/drivers/gpu/host1x/hw/host1x01.c b/drivers/gpu/host1x/hw/host1x01.c
new file mode 100644
index 0000000..612b457
--- /dev/null
+++ b/drivers/gpu/host1x/hw/host1x01.c
@@ -0,0 +1,33 @@
+/*
+ * Host1x init for T20 and T30 Architecture Chips
+ *
+ * Copyright (c) 2011-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+/* include hw specification */
+#include "hw/host1x01.h"
+#include "hw/host1x01_hardware.h"
+
+/* include code */
+#include "hw/syncpt_hw.c"
+
+#include "dev.h"
+
+int host1x01_init(struct host1x *host)
+{
+	host->syncpt_op = &host1x_syncpt_ops;
+
+	return 0;
+}
diff --git a/drivers/gpu/host1x/hw/host1x01.h b/drivers/gpu/host1x/hw/host1x01.h
new file mode 100644
index 0000000..2706b67
--- /dev/null
+++ b/drivers/gpu/host1x/hw/host1x01.h
@@ -0,0 +1,25 @@
+/*
+ * Host1x init for T20 and T30 Architecture Chips
+ *
+ * Copyright (c) 2011-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef HOST1X_HOST1X01_H
+#define HOST1X_HOST1X01_H
+
+struct host1x;
+
+int host1x01_init(struct host1x *host);
+
+#endif /* HOST1X_HOST1X01_H_ */
diff --git a/drivers/gpu/host1x/hw/host1x01_hardware.h b/drivers/gpu/host1x/hw/host1x01_hardware.h
new file mode 100644
index 0000000..8cecbee
--- /dev/null
+++ b/drivers/gpu/host1x/hw/host1x01_hardware.h
@@ -0,0 +1,27 @@
+/*
+ * Tegra host1x Register Offsets for Tegra20 and Tegra30
+ *
+ * Copyright (c) 2010-2013 NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __HOST1X_HOST1X01_HARDWARE_H
+#define __HOST1X_HOST1X01_HARDWARE_H
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+
+#include "hw_host1x01_sync.h"
+
+#endif
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_sync.h b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
new file mode 100644
index 0000000..3af258b
--- /dev/null
+++ b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
@@ -0,0 +1,74 @@
+/*
+ * Copyright (c) 2012-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+ /*
+  * Function naming determines intended use:
+  *
+  *     <x>_r(void) : Returns the offset for register <x>.
+  *
+  *     <x>_w(void) : Returns the word offset for word (4 byte) element <x>.
+  *
+  *     <x>_<y>_s(void) : Returns size of field <y> of register <x> in bits.
+  *
+  *     <x>_<y>_f(u32 v) : Returns a value based on 'v' which has been shifted
+  *         and masked to place it at field <y> of register <x>.  This value
+  *         can be |'d with others to produce a full register value for
+  *         register <x>.
+  *
+  *     <x>_<y>_m(void) : Returns a mask for field <y> of register <x>.  This
+  *         value can be ~'d and then &'d to clear the value of field <y> for
+  *         register <x>.
+  *
+  *     <x>_<y>_<z>_f(void) : Returns the constant value <z> after being shifted
+  *         to place it at field <y> of register <x>.  This value can be |'d
+  *         with others to produce a full register value for <x>.
+  *
+  *     <x>_<y>_v(u32 r) : Returns the value of field <y> from a full register
+  *         <x> value 'r' after being shifted to place its LSB at bit 0.
+  *         This value is suitable for direct comparison with other unshifted
+  *         values appropriate for use in field <y> of register <x>.
+  *
+  *     <x>_<y>_<z>_v(void) : Returns the constant value for <z> defined for
+  *         field <y> of register <x>.  This value is suitable for direct
+  *         comparison with unshifted values appropriate for use in field <y>
+  *         of register <x>.
+  */
+
+#ifndef __hw_host1x01_sync_h__
+#define __hw_host1x01_sync_h__
+
+#define REGISTER_STRIDE	4
+
+static inline u32 host1x_sync_syncpt_r(unsigned int id)
+{
+	return 0x400 + id * REGISTER_STRIDE;
+}
+#define HOST1X_SYNC_SYNCPT(id) \
+	host1x_sync_syncpt_r(id)
+static inline u32 host1x_sync_syncpt_base_r(unsigned int id)
+{
+	return 0x600 + id * REGISTER_STRIDE;
+}
+#define HOST1X_SYNC_SYNCPT_BASE(id) \
+	host1x_sync_syncpt_base_r(id)
+static inline u32 host1x_sync_syncpt_cpu_incr_r(unsigned int id)
+{
+	return 0x700 + id * REGISTER_STRIDE;
+}
+#define HOST1X_SYNC_SYNCPT_CPU_INCR(id) \
+	host1x_sync_syncpt_cpu_incr_r(id)
+#endif /* __hw_host1x01_sync_h__ */
diff --git a/drivers/gpu/host1x/hw/syncpt_hw.c b/drivers/gpu/host1x/hw/syncpt_hw.c
new file mode 100644
index 0000000..885b257
--- /dev/null
+++ b/drivers/gpu/host1x/hw/syncpt_hw.c
@@ -0,0 +1,102 @@
+/*
+ * Tegra host1x Syncpoints
+ *
+ * Copyright (c) 2010-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/io.h>
+
+#include "dev.h"
+#include "syncpt.h"
+
+/*
+ * Write the current syncpoint value back to hw.
+ */
+static void syncpt_restore(struct host1x_syncpt *sp)
+{
+	struct host1x *host = sp->host;
+	int min = host1x_syncpt_read_min(sp);
+	host1x_sync_writel(host, min, HOST1X_SYNC_SYNCPT(sp->id));
+}
+
+/*
+ * Write the current waitbase value back to hw.
+ */
+static void syncpt_restore_wait_base(struct host1x_syncpt *sp)
+{
+	struct host1x *host = sp->host;
+	host1x_sync_writel(host, sp->base_val,
+			   HOST1X_SYNC_SYNCPT_BASE(sp->id));
+}
+
+/*
+ * Read waitbase value from hw.
+ */
+static void syncpt_read_wait_base(struct host1x_syncpt *sp)
+{
+	struct host1x *host = sp->host;
+	sp->base_val =
+		host1x_sync_readl(host, HOST1X_SYNC_SYNCPT_BASE(sp->id));
+}
+
+/*
+ * Updates the last value read from hardware.
+ */
+static u32 syncpt_load(struct host1x_syncpt *sp)
+{
+	struct host1x *host = sp->host;
+	u32 old, live;
+
+	/* Loop in case there's a race writing to min_val */
+	do {
+		old = host1x_syncpt_read_min(sp);
+		live = host1x_sync_readl(host, HOST1X_SYNC_SYNCPT(sp->id));
+	} while ((u32)atomic_cmpxchg(&sp->min_val, old, live) != old);
+
+	if (!host1x_syncpt_check_max(sp, live))
+		dev_err(host->dev, "%s failed: id=%u, min=%d, max=%d\n",
+			__func__, sp->id, host1x_syncpt_read_min(sp),
+			host1x_syncpt_read_max(sp));
+
+	return live;
+}
+
+/*
+ * Write a cpu syncpoint increment to the hardware, without touching
+ * the cache.
+ */
+static void syncpt_cpu_incr(struct host1x_syncpt *sp)
+{
+	struct host1x *host = sp->host;
+	u32 reg_offset = sp->id / 32;
+
+	if (!host1x_syncpt_client_managed(sp) &&
+	    host1x_syncpt_idle(sp)) {
+		dev_err(host->dev, "Trying to increment syncpoint id %d beyond max\n",
+			sp->id);
+		return;
+	}
+	host1x_sync_writel(host, BIT_MASK(sp->id),
+			   HOST1X_SYNC_SYNCPT_CPU_INCR(reg_offset));
+	wmb();
+}
+
+static const struct host1x_syncpt_ops host1x_syncpt_ops = {
+	.restore = syncpt_restore,
+	.restore_wait_base = syncpt_restore_wait_base,
+	.load_wait_base = syncpt_read_wait_base,
+	.load = syncpt_load,
+	.cpu_incr = syncpt_cpu_incr,
+};
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
new file mode 100644
index 0000000..9df962c
--- /dev/null
+++ b/drivers/gpu/host1x/syncpt.c
@@ -0,0 +1,212 @@
+/*
+ * Tegra host1x Syncpoints
+ *
+ * Copyright (c) 2010-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+
+#include <trace/events/host1x.h>
+
+#include "syncpt.h"
+#include "dev.h"
+
+static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
+						  struct device *dev,
+						  int client_managed)
+{
+	int i;
+	struct host1x_syncpt *sp = host->syncpt;
+	char *name;
+
+	for (i = 0; i < host->info->nb_pts && sp->name; i++, sp++)
+		;
+	if (sp->dev)
+		return NULL;
+
+	name = kasprintf(GFP_KERNEL, "%02d-%s", sp->id,
+			dev ? dev_name(dev) : NULL);
+	if (!name)
+		return NULL;
+
+	sp->dev = dev;
+	sp->name = name;
+	sp->client_managed = client_managed;
+
+	return sp;
+}
+
+u32 host1x_syncpt_id(struct host1x_syncpt *sp)
+{
+	return sp->id;
+}
+
+/*
+ * Updates the value sent to hardware.
+ */
+u32 host1x_syncpt_incr_max(struct host1x_syncpt *sp, u32 incrs)
+{
+	return (u32)atomic_add_return(incrs, &sp->max_val);
+}
+
+ /*
+ * Write cached syncpoint and waitbase values to hardware.
+ */
+void host1x_syncpt_restore(struct host1x *host)
+{
+	struct host1x_syncpt *sp_base = host->syncpt;
+	u32 i;
+
+	for (i = 0; i < host1x_syncpt_nb_pts(host); i++)
+		host1x_hw_syncpt_restore(host, sp_base + i);
+	for (i = 0; i < host1x_syncpt_nb_bases(host); i++)
+		host1x_hw_syncpt_restore_wait_base(host, sp_base + i);
+	wmb();
+}
+
+/*
+ * Update the cached syncpoint and waitbase values by reading them
+ * from the registers.
+  */
+void host1x_syncpt_save(struct host1x *host)
+{
+	struct host1x_syncpt *sp_base = host->syncpt;
+	u32 i;
+
+	for (i = 0; i < host1x_syncpt_nb_pts(host); i++) {
+		if (host1x_syncpt_client_managed(sp_base + i))
+			host1x_hw_syncpt_load(host, sp_base + i);
+		else
+			WARN_ON(!host1x_syncpt_idle(sp_base + i));
+	}
+
+	for (i = 0; i < host1x_syncpt_nb_bases(host); i++)
+		host1x_hw_syncpt_load_wait_base(host, sp_base + i);
+}
+
+/*
+ * Updates the cached syncpoint value by reading a new value from the hardware
+ * register
+ */
+u32 host1x_syncpt_load(struct host1x_syncpt *sp)
+{
+	u32 val;
+	val = host1x_hw_syncpt_load(sp->host, sp);
+	trace_host1x_syncpt_load_min(sp->id, val);
+
+	return val;
+}
+
+/*
+ * Get the current syncpoint base
+ */
+u32 host1x_syncpt_load_wait_base(struct host1x_syncpt *sp)
+{
+	u32 val;
+	host1x_hw_syncpt_load_wait_base(sp->host, sp);
+	val = sp->base_val;
+	return val;
+}
+
+/*
+ * Write a cpu syncpoint increment to the hardware, without touching
+ * the cache. Caller is responsible for host being powered.
+ */
+void host1x_syncpt_cpu_incr(struct host1x_syncpt *sp)
+{
+	host1x_hw_syncpt_cpu_incr(sp->host, sp);
+}
+
+/*
+ * Increment syncpoint value from cpu, updating cache
+ */
+void host1x_syncpt_incr(struct host1x_syncpt *sp)
+{
+	if (host1x_syncpt_client_managed(sp))
+		host1x_syncpt_incr_max(sp, 1);
+	host1x_syncpt_cpu_incr(sp);
+}
+
+int host1x_syncpt_init(struct host1x *host)
+{
+	struct host1x_syncpt *syncpt;
+	int i;
+
+	syncpt = devm_kzalloc(host->dev, sizeof(*syncpt) * host->info->nb_pts,
+		GFP_KERNEL);
+	if (!syncpt)
+		return -ENOMEM;
+
+	for (i = 0; i < host->info->nb_pts; ++i) {
+		syncpt[i].id = i;
+		syncpt[i].host = host;
+	}
+
+	host->syncpt = syncpt;
+
+	host1x_syncpt_restore(host);
+
+	return 0;
+}
+
+struct host1x_syncpt *host1x_syncpt_request(struct device *dev,
+					    int client_managed)
+{
+	struct host1x *host = host1x_get_host(dev);
+	return _host1x_syncpt_alloc(host, dev, client_managed);
+}
+
+void host1x_syncpt_free(struct host1x_syncpt *sp)
+{
+	if (!sp)
+		return;
+
+	kfree(sp->name);
+	sp->dev = NULL;
+	sp->name = NULL;
+	sp->client_managed = 0;
+}
+
+void host1x_syncpt_deinit(struct host1x *host)
+{
+	int i;
+	struct host1x_syncpt *sp = host->syncpt;
+	for (i = 0; i < host->info->nb_pts; i++, sp++)
+		kfree(sp->name);
+}
+
+int host1x_syncpt_nb_pts(struct host1x *host)
+{
+	return host->info->nb_pts;
+}
+
+int host1x_syncpt_nb_bases(struct host1x *host)
+{
+	return host->info->nb_bases;
+}
+
+int host1x_syncpt_nb_mlocks(struct host1x *host)
+{
+	return host->info->nb_mlocks;
+}
+
+struct host1x_syncpt *host1x_syncpt_get(struct host1x *host, u32 id)
+{
+	if (host->info->nb_pts < id)
+		return NULL;
+	return host->syncpt + id;
+}
diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
new file mode 100644
index 0000000..119ccd5
--- /dev/null
+++ b/drivers/gpu/host1x/syncpt.h
@@ -0,0 +1,147 @@
+/*
+ * Tegra host1x Syncpoints
+ *
+ * Copyright (c) 2010-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __HOST1X_SYNCPT_H
+#define __HOST1X_SYNCPT_H
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/atomic.h>
+
+struct host1x;
+
+struct host1x_syncpt {
+	int id;
+	atomic_t min_val;
+	atomic_t max_val;
+	u32 base_val;
+	const char *name;
+	int client_managed;
+	struct host1x *host;
+	struct device *dev;
+};
+
+/* Initialize sync point array  */
+int host1x_syncpt_init(struct host1x *host);
+
+/*  Free sync point array */
+void host1x_syncpt_deinit(struct host1x *host);
+
+/*
+ * Read max. It indicates how many operations there are in queue, either in
+ * channel or in a software thread.
+ * */
+static inline u32 host1x_syncpt_read_max(struct host1x_syncpt *sp)
+{
+	smp_rmb();
+	return (u32)atomic_read(&sp->max_val);
+}
+
+/*
+ * Read min, which is a shadow of the current sync point value in hardware.
+ */
+static inline u32 host1x_syncpt_read_min(struct host1x_syncpt *sp)
+{
+	smp_rmb();
+	return (u32)atomic_read(&sp->min_val);
+}
+
+/* Return number of sync point supported. */
+int host1x_syncpt_nb_pts(struct host1x *host);
+
+/* Return number of wait bases supported. */
+int host1x_syncpt_nb_bases(struct host1x *host);
+
+/* Return number of mlocks supported. */
+int host1x_syncpt_nb_mlocks(struct host1x *host);
+
+/*
+ * Check sync point sanity. If max is larger than min, there have too many
+ * sync point increments.
+ *
+ * Client managed sync point are not tracked.
+ * */
+static inline bool host1x_syncpt_check_max(struct host1x_syncpt *sp, u32 real)
+{
+	u32 max;
+	if (sp->client_managed)
+		return true;
+	max = host1x_syncpt_read_max(sp);
+	return (s32)(max - real) >= 0;
+}
+
+/* Return true if sync point is client managed. */
+static inline int host1x_syncpt_client_managed(struct host1x_syncpt *sp)
+{
+	return sp->client_managed;
+}
+
+/*
+ * Returns true if syncpoint min == max, which means that there are no
+ * outstanding operations.
+ */
+static inline bool host1x_syncpt_idle(struct host1x_syncpt *sp)
+{
+	int min, max;
+	smp_rmb();
+	min = atomic_read(&sp->min_val);
+	max = atomic_read(&sp->max_val);
+	return (min == max);
+}
+
+/* Return pointer to struct denoting sync point id. */
+struct host1x_syncpt *host1x_syncpt_get(struct host1x *host, u32 id);
+
+/* Request incrementing a sync point. */
+void host1x_syncpt_cpu_incr(struct host1x_syncpt *sp);
+
+/* Load current value from hardware to the shadow register. */
+u32 host1x_syncpt_load(struct host1x_syncpt *sp);
+
+/* Save host1x sync point state into shadow registers. */
+void host1x_syncpt_save(struct host1x *host);
+
+/* Reset host1x sync point state from shadow registers. */
+void host1x_syncpt_restore(struct host1x *host);
+
+/* Read current wait base value into shadow register and return it. */
+u32 host1x_syncpt_load_wait_base(struct host1x_syncpt *sp);
+
+/* Increment sync point and its max. */
+void host1x_syncpt_incr(struct host1x_syncpt *sp);
+
+/* Indicate future operations by incrementing the sync point max. */
+u32 host1x_syncpt_incr_max(struct host1x_syncpt *sp, u32 incrs);
+
+/* Check if sync point id is valid. */
+static inline int host1x_syncpt_is_valid(struct host1x_syncpt *sp)
+{
+	return sp->id < host1x_syncpt_nb_pts(sp->host);
+}
+
+/* Return id of the sync point */
+u32 host1x_syncpt_id(struct host1x_syncpt *sp);
+
+/* Allocate a sync point for a device. */
+struct host1x_syncpt *host1x_syncpt_request(struct device *dev,
+		int client_managed);
+
+/* Free a sync point. */
+void host1x_syncpt_free(struct host1x_syncpt *sp);
+
+#endif
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 4c1546f..3e0e3f0 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -21,6 +21,8 @@ source "drivers/gpu/vga/Kconfig"
 
 source "drivers/gpu/drm/Kconfig"
 
+source "drivers/gpu/host1x/Kconfig"
+
 config VGASTATE
        tristate
        default n
diff --git a/include/trace/events/host1x.h b/include/trace/events/host1x.h
new file mode 100644
index 0000000..3c14cac
--- /dev/null
+++ b/include/trace/events/host1x.h
@@ -0,0 +1,61 @@
+/*
+ * include/trace/events/host1x.h
+ *
+ * Nvhost event logging to ftrace.
+ *
+ * Copyright (c) 2010-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM host1x
+
+#if !defined(_TRACE_HOST1X_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_HOST1X_H
+
+#include <linux/ktime.h>
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(host1x,
+	TP_PROTO(const char *name),
+	TP_ARGS(name),
+	TP_STRUCT__entry(__field(const char *, name)),
+	TP_fast_assign(__entry->name = name;),
+	TP_printk("name=%s", __entry->name)
+);
+
+TRACE_EVENT(host1x_syncpt_load_min,
+	TP_PROTO(u32 id, u32 val),
+
+	TP_ARGS(id, val),
+
+	TP_STRUCT__entry(
+		__field(u32, id)
+		__field(u32, val)
+	),
+
+	TP_fast_assign(
+		__entry->id = id;
+		__entry->val = val;
+	),
+
+	TP_printk("id=%d, val=%d", __entry->id, __entry->val)
+);
+
+#endif /*  _TRACE_HOST1X_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.9.5

