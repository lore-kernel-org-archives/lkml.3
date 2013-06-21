Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab3FUGOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:14:42 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53951 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289Ab3FUGOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:14:39 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Matt Sealey <neko@bakuhatsu.net>, Stephen Boyd <sboyd@codeaurora.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Tero Kristo <t-kristo@ti.com>, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v3 5/5] clk: dt: binding for basic gate clock
Date: Thu, 20 Jun 2013 23:14:16 -0700
Message-Id: <1371795256-16703-6-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371795256-16703-1-git-send-email-mturquette@linaro.org>
References: <1371795256-16703-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device Tree binding for the basic clock gate, plus the setup function to
register the clock.  Based on the existing fixed-clock binding.

A different approach to this was proposed in 2012[1] and a similar
binding was proposed more recently[2] if anyone wants some extra
reading.

[1] http://article.gmane.org/gmane.linux.documentation/5679
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2012-December/137878.html

Tero Kristo contributed helpful bug fixes to this patch.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
Changes since v2:
* added hiword-mask property to the binding
* changed bit-shift property from u8 to u32 in the dt binding

 .../devicetree/bindings/clock/gate-clock.txt       | 36 ++++++++++++++++++
 drivers/clk/clk-gate.c                             | 43 ++++++++++++++++++++++
 include/linux/clk-provider.h                       |  2 +
 3 files changed, 81 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/gate-clock.txt

diff --git a/Documentation/devicetree/bindings/clock/gate-clock.txt b/Documentation/devicetree/bindings/clock/gate-clock.txt
new file mode 100644
index 0000000..1c0d4d5
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/gate-clock.txt
@@ -0,0 +1,36 @@
+Binding for simple gate clock.
+
+This binding uses the common clock binding[1].  It assumes a
+register-mapped clock gate controlled by a single bit that has only one
+input clock or parent.  By default setting the specified bit gates the
+clock signal and clearing the bit ungates it.
+
+The binding must provide the register to control the gate and the bit
+shift for the corresponding gate control bit. Some clocks set the bit to
+gate the clock signal, and clear it to ungate the clock signal. The
+optional "set-bit-to-disable" specifies this behavior.
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible : shall be "gate-clock".
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : link to phandle of parent clock
+- reg : base address for register controlling adjustable gate
+- bit-shift : bit shift for programming the clock gate
+
+Optional properties:
+- clock-output-names : from common clock binding.
+- set-bit-to-disable : inverts default gate programming. Setting the bit
+  gates the clock and clearing the bit ungates the clock.
+- hiword-mask : lower half of the register controls the gate, upper half
+  of the register indicates bits that were updated in the lower half
+
+Examples:
+	clock_foo: clock_foo@4a008100 {
+		compatible = "gate-clock";
+		#clock-cells = <0>;
+		clocks = <&clock_bar>;
+		reg = <0x4a008100 0x4>
+		bit-shift = <3>
+	};
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index 790306e..cd595ec 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -15,6 +15,8 @@
 #include <linux/io.h>
 #include <linux/err.h>
 #include <linux/string.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 
 /**
  * DOC: basic gatable clock which can gate and ungate it's ouput
@@ -161,3 +163,44 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 
 	return clk;
 }
+
+#ifdef CONFIG_OF
+/**
+ * of_gate_clk_setup() - Setup function for simple gate rate clock
+ */
+void of_gate_clk_setup(struct device_node *node)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	void __iomem *reg;
+	const char *parent_name;
+	u8 clk_gate_flags = 0;
+	u32 bit_idx = 0;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	parent_name = of_clk_get_parent_name(node, 0);
+
+	reg = of_iomap(node, 0);
+
+	if (of_property_read_u32(node, "bit-shift", &bit_idx)) {
+		pr_err("%s: missing bit-shift property for %s\n",
+				__func__, node->name);
+		return;
+	}
+
+	if (of_property_read_bool(node, "set-bit-to-disable"))
+		clk_gate_flags |= CLK_GATE_SET_TO_DISABLE;
+
+	if (of_property_read_bool(node, "hiword-mask"))
+		clk_gate_flags |= CLK_GATE_HIWORD_MASK;
+
+	clk = clk_register_gate(NULL, clk_name, parent_name, 0, reg, (u8) bit_idx,
+			clk_gate_flags, NULL);
+
+	if (!IS_ERR(clk))
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+EXPORT_SYMBOL_GPL(of_gate_clk_setup);
+CLK_OF_DECLARE(gate_clk, "gate-clock", of_gate_clk_setup);
+#endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 723ce69..4aeaedb 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -232,6 +232,8 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 		void __iomem *reg, u8 bit_idx,
 		u8 clk_gate_flags, spinlock_t *lock);
 
+void of_gate_clk_setup(struct device_node *node);
+
 struct clk_div_table {
 	unsigned int	val;
 	unsigned int	div;
-- 
1.8.1.2

