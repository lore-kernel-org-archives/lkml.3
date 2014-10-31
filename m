Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422887AbaJaCOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:14:37 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28609 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161690AbaJaCMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:12:15 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <haojian.zhuang@linaro.org>,
        <mturquette@linaro.org>, <chao.xie@marvell.com>,
        <xiechao_mail@163.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 08/13] clk: mmp: add reset support
Date: Fri, 31 Oct 2014 10:13:48 +0800
Message-ID: <1414721633-29508-9-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414721633-29508-1-git-send-email-chao.xie@marvell.com>
References: <1414721633-29508-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-31_02:2014-10-30,2014-10-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410310021
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

Some clock control regsiter has bit to reset the cotroller.
So before enable the clock, we need deassert the reset pin.
Make use of reset controller framework to export reset interface
for device drivers, then device driver can control the reset action.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/clk/mmp/Makefile |  2 +
 drivers/clk/mmp/reset.c  | 99 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/mmp/reset.h  | 31 +++++++++++++++
 3 files changed, 132 insertions(+)
 create mode 100644 drivers/clk/mmp/reset.c
 create mode 100644 drivers/clk/mmp/reset.h

diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
index 32b5b90..2573d7c 100644
--- a/drivers/clk/mmp/Makefile
+++ b/drivers/clk/mmp/Makefile
@@ -4,6 +4,8 @@
 
 obj-y += clk-apbc.o clk-apmu.o clk-frac.o clk-mix.o clk-gate.o clk.o
 
+obj-$(CONFIG_RESET_CONTROLLER) += reset.o
+
 obj-$(CONFIG_CPU_PXA168) += clk-pxa168.o
 obj-$(CONFIG_CPU_PXA910) += clk-pxa910.o
 obj-$(CONFIG_CPU_MMP2) += clk-mmp2.o
diff --git a/drivers/clk/mmp/reset.c b/drivers/clk/mmp/reset.c
new file mode 100644
index 0000000..b54da1f
--- /dev/null
+++ b/drivers/clk/mmp/reset.c
@@ -0,0 +1,99 @@
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/reset-controller.h>
+
+#include "reset.h"
+
+#define rcdev_to_unit(rcdev) container_of(rcdev, struct mmp_clk_reset_unit, rcdev)
+
+static int mmp_of_reset_xlate(struct reset_controller_dev *rcdev,
+			  const struct of_phandle_args *reset_spec)
+{
+	struct mmp_clk_reset_unit *unit = rcdev_to_unit(rcdev);
+	struct mmp_clk_reset_cell *cell;
+	int i;
+
+	if (WARN_ON(reset_spec->args_count != rcdev->of_reset_n_cells))
+		return -EINVAL;
+
+	for (i = 0; i < rcdev->nr_resets; i++) {
+		cell = &unit->cells[i];
+		if (cell->clk_id == reset_spec->args[0])
+			break;
+	}
+
+	if (i == rcdev->nr_resets)
+		return -EINVAL;
+
+	return i;
+}
+
+static int mmp_clk_reset_assert(struct reset_controller_dev *rcdev,
+				unsigned long id)
+{
+	struct mmp_clk_reset_unit *unit = rcdev_to_unit(rcdev);
+	struct mmp_clk_reset_cell *cell;
+	unsigned long flags = 0;
+	u32 val;
+
+	cell = &unit->cells[id];
+	if (cell->lock)
+		spin_lock_irqsave(cell->lock, flags);
+
+	val = readl(cell->reg);
+	val |= cell->bits;
+	writel(val, cell->reg);
+
+	if (cell->lock)
+		spin_unlock_irqrestore(cell->lock, flags);
+
+	return 0;
+}
+
+static int mmp_clk_reset_deassert(struct reset_controller_dev *rcdev,
+				unsigned long id)
+{
+	struct mmp_clk_reset_unit *unit = rcdev_to_unit(rcdev);
+	struct mmp_clk_reset_cell *cell;
+	unsigned long flags = 0;
+	u32 val;
+
+	cell = &unit->cells[id];
+	if (cell->lock)
+		spin_lock_irqsave(cell->lock, flags);
+
+	val = readl(cell->reg);
+	val &= ~cell->bits;
+	writel(val, cell->reg);
+
+	if (cell->lock)
+		spin_unlock_irqrestore(cell->lock, flags);
+
+	return 0;
+}
+
+static struct reset_control_ops mmp_clk_reset_ops = {
+	.assert		= mmp_clk_reset_assert,
+	.deassert	= mmp_clk_reset_deassert,
+};
+
+void mmp_clk_reset_register(struct device_node *np,
+			struct mmp_clk_reset_cell *cells, int nr_resets)
+{
+	struct mmp_clk_reset_unit *unit;
+
+	unit = kzalloc(sizeof(*unit), GFP_KERNEL);
+	if (!unit)
+		return;
+
+	unit->cells = cells;
+	unit->rcdev.of_reset_n_cells = 1;
+	unit->rcdev.nr_resets = nr_resets;
+	unit->rcdev.ops = &mmp_clk_reset_ops;
+	unit->rcdev.of_node = np;
+	unit->rcdev.of_xlate = mmp_of_reset_xlate;
+
+	reset_controller_register(&unit->rcdev);
+}
diff --git a/drivers/clk/mmp/reset.h b/drivers/clk/mmp/reset.h
new file mode 100644
index 0000000..be8b1a7
--- /dev/null
+++ b/drivers/clk/mmp/reset.h
@@ -0,0 +1,31 @@
+#ifndef __MACH_MMP_CLK_RESET_H
+#define __MACH_MMP_CLK_RESET_H
+
+#include <linux/reset-controller.h>
+
+#define MMP_RESET_INVERT	1
+
+struct mmp_clk_reset_cell {
+	unsigned int clk_id;
+	void __iomem *reg;
+	u32 bits;
+	unsigned int flags;
+	spinlock_t *lock;
+};
+
+struct mmp_clk_reset_unit {
+	struct reset_controller_dev rcdev;
+	struct mmp_clk_reset_cell *cells;
+};
+
+#ifdef CONFIG_RESET_CONTROLLER
+void mmp_clk_reset_register(struct device_node *np,
+			struct mmp_clk_reset_cell *cells, int nr_resets);
+#else
+static inline void mmp_clk_reset_register(struct device_node *np,
+			struct mmp_clk_reset_cell *cells, int nr_resets)
+{
+}
+#endif
+
+#endif
-- 
1.8.3.2

