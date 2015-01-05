Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbbAEJww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:52:52 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35691 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbbAEJwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:52:49 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-4b-54aa5ef046a4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] clk: Add clk_unregister_{divider,gate,mux} to close memory
 leak
Date: Mon, 05 Jan 2015 10:52:40 +0100
Message-id: <1420451561-12360-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAJMWRmVeSWpSXmKPExsVy+t/xK7of4laFGHw8rWzx+oWhRf/j18wW
	mx5fY7W4vGsOm8WM8/uYLJ5OuMhmcfhNO6vFjzPdLBardv1hdOD0uNzXy+Sxc9Zddo9NqzrZ
	PO5c28PmsXlJvUffllWMHp83yQWwR3HZpKTmZJalFunbJXBlLLj4n6ngoXTFvb7HTA2M08S7
	GDk5JARMJDbOfc0CYYtJXLi3nq2LkYtDSGApo8SfhUtZIJw+JokNDx6zglSxCRhLbF6+BKxK
	RGAjk0TPvgXsIAlmAUOJn+/+ANkcHMICYRJzX+WBhFkEVCW2fO0F28Ar4C7xdflXNohtchIn
	j01mncDIvYCRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSCh93cG49JjVIUYBDkYlHl6P
	EytDhFgTy4orcw8xSnAwK4nwrrsFFOJNSaysSi3Kjy8qzUktPsTIxMEp1cB4myvUhPnzhtA7
	LySn33578f6hOJO300MvHP23ceUjmUlW02T6DuxMi4j0Z3eeJnLmU0P9zOlnv1Q+vqekx/fv
	eOMDfme/9hzdi6s1b4h9j3tw5nPhqoCIs75TF/Yv3vLW9Ufe/NZ7c/6kzo/hi5OSW3LfdNti
	9nd6DOtF2ZwXTAmb333wRWZhkxJLcUaioRZzUXEiAFiXHrsDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common clk_register_{divider,gate,mux} functions allocated memory
for internal data which wasn't freed anywhere. Drivers using these
helpers could only unregister clocks but the memory would still leak.

Add corresponding unregister functions which will release all resources.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/clk-divider.c    | 16 ++++++++++++++++
 drivers/clk/clk-gate.c       | 16 ++++++++++++++++
 drivers/clk/clk-mux.c        | 16 ++++++++++++++++
 include/linux/clk-provider.h |  4 ++++
 4 files changed, 52 insertions(+)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index c0a842b335c5..c2bb9f679ec6 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -463,3 +463,19 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
 			width, clk_divider_flags, table, lock);
 }
 EXPORT_SYMBOL_GPL(clk_register_divider_table);
+
+void clk_unregister_divider(struct clk *clk)
+{
+	struct clk_divider *div;
+	struct clk_hw *hw;
+
+	hw = __clk_get_hw(clk);
+	if (!hw)
+		return;
+
+	div = to_clk_divider(hw);
+
+	clk_unregister(clk);
+	kfree(div);
+}
+EXPORT_SYMBOL_GPL(clk_unregister_divider);
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index 51fd87fb7ba6..186b96efeebf 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -162,3 +162,19 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 	return clk;
 }
 EXPORT_SYMBOL_GPL(clk_register_gate);
+
+void clk_unregister_gate(struct clk *clk)
+{
+	struct clk_gate *gate;
+	struct clk_hw *hw;
+
+	hw = __clk_get_hw(clk);
+	if (!hw)
+		return;
+
+	gate = to_clk_gate(hw);
+
+	clk_unregister(clk);
+	kfree(gate);
+}
+EXPORT_SYMBOL_GPL(clk_unregister_gate);
diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 6e1ecf94bf58..69a094c3783d 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -177,3 +177,19 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 				      NULL, lock);
 }
 EXPORT_SYMBOL_GPL(clk_register_mux);
+
+void clk_unregister_mux(struct clk *clk)
+{
+	struct clk_mux *mux;
+	struct clk_hw *hw;
+
+	hw = __clk_get_hw(clk);
+	if (!hw)
+		return;
+
+	mux = to_clk_mux(hw);
+
+	clk_unregister(clk);
+	kfree(mux);
+}
+EXPORT_SYMBOL_GPL(clk_unregister_mux);
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index d936409520f8..ebb7055a6d84 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -294,6 +294,7 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 bit_idx,
 		u8 clk_gate_flags, spinlock_t *lock);
+void clk_unregister_gate(struct clk *clk);
 
 struct clk_div_table {
 	unsigned int	val;
@@ -361,6 +362,7 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_divider_flags, const struct clk_div_table *table,
 		spinlock_t *lock);
+void clk_unregister_divider(struct clk *clk);
 
 /**
  * struct clk_mux - multiplexer clock
@@ -411,6 +413,8 @@ struct clk *clk_register_mux_table(struct device *dev, const char *name,
 		void __iomem *reg, u8 shift, u32 mask,
 		u8 clk_mux_flags, u32 *table, spinlock_t *lock);
 
+void clk_unregister_mux(struct clk *clk);
+
 void of_fixed_factor_clk_setup(struct device_node *node);
 
 /**
-- 
1.9.1

