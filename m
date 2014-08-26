Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750716AbaHZEkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:40:05 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15025 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752889AbaHZEhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:37:41 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <haojian.zhuang@linaro.org>,
        <mturquette@linaro.org>, <chao.xie@marvell.com>,
        <xiechao_mail@163.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/12] clk: mmp: add basic support functions for DT support
Date: Tue, 26 Aug 2014 12:38:19 +0800
Message-ID: <1409027904-21859-8-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
References: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-26_02:2014-08-25,2014-08-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408260059
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

In order to support DT for mmp SOC clocks, it defines
some basic APIs which are shared by all mmp SOC clock
units.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/clk/mmp/Makefile |   2 +-
 drivers/clk/mmp/clk.c    | 192 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/mmp/clk.h    | 106 +++++++++++++++++++++++++-
 3 files changed, 298 insertions(+), 2 deletions(-)
 create mode 100644 drivers/clk/mmp/clk.c

diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
index 2855f7b..32b5b90 100644
--- a/drivers/clk/mmp/Makefile
+++ b/drivers/clk/mmp/Makefile
@@ -2,7 +2,7 @@
 # Makefile for mmp specific clk
 #
 
-obj-y += clk-apbc.o clk-apmu.o clk-frac.o clk-mix.o clk-gate.o
+obj-y += clk-apbc.o clk-apmu.o clk-frac.o clk-mix.o clk-gate.o clk.o
 
 obj-$(CONFIG_CPU_PXA168) += clk-pxa168.o
 obj-$(CONFIG_CPU_PXA910) += clk-pxa910.o
diff --git a/drivers/clk/mmp/clk.c b/drivers/clk/mmp/clk.c
new file mode 100644
index 0000000..cf038ef
--- /dev/null
+++ b/drivers/clk/mmp/clk.c
@@ -0,0 +1,192 @@
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+#include "clk.h"
+
+void mmp_clk_init(struct device_node *np, struct mmp_clk_unit *unit,
+		int nr_clks)
+{
+	static struct clk **clk_table;
+
+	clk_table = kcalloc(nr_clks, sizeof(struct clk *), GFP_KERNEL);
+	if (!clk_table)
+		return;
+
+	unit->clk_table = clk_table;
+	unit->nr_clks = nr_clks;
+	unit->clk_data.clks = clk_table;
+	unit->clk_data.clk_num = nr_clks;
+	of_clk_add_provider(np, of_clk_src_onecell_get, &unit->clk_data);
+}
+
+void mmp_register_fixed_rate_clks(struct mmp_clk_unit *unit,
+				struct mmp_param_fixed_rate_clk *clks,
+				int size)
+{
+	int i;
+	struct clk *clk;
+
+	for (i = 0; i < size; i++) {
+		clk = clk_register_fixed_rate(NULL, clks[i].name,
+					clks[i].parent_name,
+					clks[i].flags,
+					clks[i].fixed_rate);
+		if (IS_ERR(clk)) {
+			pr_err("%s: failed to register clock %s\n",
+			       __func__, clks[i].name);
+			continue;
+		}
+		if (clks[i].id)
+			unit->clk_table[clks[i].id] = clk;
+	}
+}
+
+void mmp_register_fixed_factor_clks(struct mmp_clk_unit *unit,
+				struct mmp_param_fixed_factor_clk *clks,
+				int size)
+{
+	struct clk *clk;
+	int i;
+
+	for (i = 0; i < size; i++) {
+		clk = clk_register_fixed_factor(NULL, clks[i].name,
+						clks[i].parent_name,
+						clks[i].flags, clks[i].mult,
+						clks[i].div);
+		if (IS_ERR(clk)) {
+			pr_err("%s: failed to register clock %s\n",
+			       __func__, clks[i].name);
+			continue;
+		}
+		if (clks[i].id)
+			unit->clk_table[clks[i].id] = clk;
+	}
+}
+
+void mmp_register_general_gate_clks(struct mmp_clk_unit *unit,
+				struct mmp_param_general_gate_clk *clks,
+				void __iomem *base, int size)
+{
+	struct clk *clk;
+	int i;
+
+	for (i = 0; i < size; i++) {
+		clk = clk_register_gate(NULL, clks[i].name,
+					clks[i].parent_name,
+					clks[i].flags,
+					base + clks[i].offset,
+					clks[i].bit_idx,
+					clks[i].gate_flags,
+					clks[i].lock);
+
+		if (IS_ERR(clk)) {
+			pr_err("%s: failed to register clock %s\n",
+			       __func__, clks[i].name);
+			continue;
+		}
+		if (clks[i].id)
+			unit->clk_table[clks[i].id] = clk;
+	}
+}
+
+void mmp_register_gate_clks(struct mmp_clk_unit *unit,
+			struct mmp_param_gate_clk *clks,
+			void __iomem *base, int size)
+{
+	struct clk *clk;
+	int i;
+
+	for (i = 0; i < size; i++) {
+		clk = mmp_clk_register_gate(NULL, clks[i].name,
+					clks[i].parent_name,
+					clks[i].flags,
+					base + clks[i].offset,
+					clks[i].mask,
+					clks[i].val_enable,
+					clks[i].val_disable,
+					clks[i].gate_flags,
+					clks[i].lock);
+
+		if (IS_ERR(clk)) {
+			pr_err("%s: failed to register clock %s\n",
+			       __func__, clks[i].name);
+			continue;
+		}
+		if (clks[i].id)
+			unit->clk_table[clks[i].id] = clk;
+	}
+}
+
+void mmp_register_mux_clks(struct mmp_clk_unit *unit,
+			struct mmp_param_mux_clk *clks,
+			void __iomem *base, int size)
+{
+	struct clk *clk;
+	int i;
+
+	for (i = 0; i < size; i++) {
+		clk = clk_register_mux(NULL, clks[i].name,
+					clks[i].parent_name,
+					clks[i].num_parents,
+					clks[i].flags,
+					base + clks[i].offset,
+					clks[i].shift,
+					clks[i].width,
+					clks[i].mux_flags,
+					clks[i].lock);
+
+		if (IS_ERR(clk)) {
+			pr_err("%s: failed to register clock %s\n",
+			       __func__, clks[i].name);
+			continue;
+		}
+		if (clks[i].id)
+			unit->clk_table[clks[i].id] = clk;
+	}
+}
+
+void mmp_register_div_clks(struct mmp_clk_unit *unit,
+			struct mmp_param_div_clk *clks,
+			void __iomem *base, int size)
+{
+	struct clk *clk;
+	int i;
+
+	for (i = 0; i < size; i++) {
+		clk = clk_register_divider(NULL, clks[i].name,
+					clks[i].parent_name,
+					clks[i].flags,
+					base + clks[i].offset,
+					clks[i].shift,
+					clks[i].width,
+					clks[i].div_flags,
+					clks[i].lock);
+
+		if (IS_ERR(clk)) {
+			pr_err("%s: failed to register clock %s\n",
+			       __func__, clks[i].name);
+			continue;
+		}
+		if (clks[i].id)
+			unit->clk_table[clks[i].id] = clk;
+	}
+}
+
+void mmp_clk_add(struct mmp_clk_unit *unit, unsigned int id,
+			struct clk *clk)
+{
+	if (IS_ERR_OR_NULL(clk)) {
+		pr_err("CLK %d has invalid pointer %p\n", id, clk);
+		return;
+	}
+	if (id > unit->nr_clks) {
+		pr_err("CLK %d is invalid\n", id);
+		return;
+	}
+
+	unit->clk_table[id] = clk;
+}
diff --git a/drivers/clk/mmp/clk.h b/drivers/clk/mmp/clk.h
index 2337106..adf9b71 100644
--- a/drivers/clk/mmp/clk.h
+++ b/drivers/clk/mmp/clk.h
@@ -96,8 +96,8 @@ struct mmp_clk_mix {
 extern const struct clk_ops mmp_clk_mix_ops;
 extern struct clk *mmp_clk_register_mix(struct device *dev,
 					const char *name,
-					u8 num_parents,
 					const char **parent_names,
+					u8 num_parents,
 					unsigned long flags,
 					struct mmp_clk_mix_config *config,
 					spinlock_t *lock);
@@ -132,4 +132,108 @@ extern struct clk *mmp_clk_register_apbc(const char *name,
 extern struct clk *mmp_clk_register_apmu(const char *name,
 		const char *parent_name, void __iomem *base, u32 enable_mask,
 		spinlock_t *lock);
+
+struct mmp_clk_unit {
+	unsigned int nr_clks;
+	struct clk **clk_table;
+	struct clk_onecell_data clk_data;
+};
+
+struct mmp_param_fixed_rate_clk {
+	unsigned int id;
+	char *name;
+	const char *parent_name;
+	unsigned long flags;
+	unsigned long fixed_rate;
+};
+void mmp_register_fixed_rate_clks(struct mmp_clk_unit *unit,
+				struct mmp_param_fixed_rate_clk *clks,
+				int size);
+
+struct mmp_param_fixed_factor_clk {
+	unsigned int id;
+	char *name;
+	const char *parent_name;
+	unsigned long mult;
+	unsigned long div;
+	unsigned long flags;
+};
+void mmp_register_fixed_factor_clks(struct mmp_clk_unit *unit,
+				struct mmp_param_fixed_factor_clk *clks,
+				int size);
+
+struct mmp_param_general_gate_clk {
+	unsigned int id;
+	const char *name;
+	const char *parent_name;
+	unsigned long flags;
+	unsigned long offset;
+	u8 bit_idx;
+	u8 gate_flags;
+	spinlock_t *lock;
+};
+void mmp_register_general_gate_clks(struct mmp_clk_unit *unit,
+				struct mmp_param_general_gate_clk *clks,
+				void __iomem *base, int size);
+
+struct mmp_param_gate_clk {
+	unsigned int id;
+	char *name;
+	const char *parent_name;
+	unsigned long flags;
+	unsigned long offset;
+	u32 mask;
+	u32 val_enable;
+	u32 val_disable;
+	unsigned int gate_flags;
+	spinlock_t *lock;
+};
+void mmp_register_gate_clks(struct mmp_clk_unit *unit,
+			struct mmp_param_gate_clk *clks,
+			void __iomem *base, int size);
+
+struct mmp_param_mux_clk {
+	unsigned int id;
+	char *name;
+	const char **parent_name;
+	u8 num_parents;
+	unsigned long flags;
+	unsigned long offset;
+	u8 shift;
+	u8 width;
+	u8 mux_flags;
+	spinlock_t *lock;
+};
+void mmp_register_mux_clks(struct mmp_clk_unit *unit,
+			struct mmp_param_mux_clk *clks,
+			void __iomem *base, int size);
+
+struct mmp_param_div_clk {
+	unsigned int id;
+	char *name;
+	const char *parent_name;
+	unsigned long flags;
+	unsigned long offset;
+	u8 shift;
+	u8 width;
+	u8 div_flags;
+	spinlock_t *lock;
+};
+void mmp_register_div_clks(struct mmp_clk_unit *unit,
+			struct mmp_param_div_clk *clks,
+			void __iomem *base, int size);
+
+#define DEFINE_MIX_REG_INFO(w_d, s_d, w_m, s_m, fc)	\
+{							\
+	.width_div = (w_d),				\
+	.shift_div = (s_d),				\
+	.width_mux = (w_m),				\
+	.shift_mux = (s_m),				\
+	.bit_fc = (fc),					\
+}
+
+void mmp_clk_init(struct device_node *np, struct mmp_clk_unit *unit,
+		int nr_clks);
+void mmp_clk_add(struct mmp_clk_unit *unit, unsigned int id,
+		struct clk *clk);
 #endif
-- 
1.8.3.2

