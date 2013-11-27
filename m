Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3K0Mra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:47:30 -0500
Received: from 2.mo6.mail-out.ovh.net ([46.105.76.65]:32835 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751749Ab3K0Mr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:47:28 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 2/2] clk: add accuracy support for fixed clock
Date: Wed, 27 Nov 2013 13:44:45 +0100
Message-Id: <1385556285-19180-3-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385556285-19180-1-git-send-email-b.brezillon@overkiz.com>
References: <1385556285-19180-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 16840366381702805604
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for accuracy retrieval on fixed clocks.
It also adds a new dt property called 'clock-accuracy' to define the clock
accuracy.

This can be usefull for oscillator (RC, crystal, ...) definitions which are
always given an accuracy characteristic.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 .../devicetree/bindings/clock/fixed-clock.txt      |    3 ++
 drivers/clk/clk-fixed-rate.c                       |   43 +++++++++++++++++---
 include/linux/clk-provider.h                       |    4 ++
 3 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/fixed-clock.txt b/Documentation/devicetree/bindings/clock/fixed-clock.txt
index 0b1fe78..48ea0ad 100644
--- a/Documentation/devicetree/bindings/clock/fixed-clock.txt
+++ b/Documentation/devicetree/bindings/clock/fixed-clock.txt
@@ -10,6 +10,8 @@ Required properties:
 - clock-frequency : frequency of clock in Hz. Should be a single cell.
 
 Optional properties:
+- clock-accuracy : accuracy of clock in ppb (parts per billion).
+		   Should be a single cell.
 - gpios : From common gpio binding; gpio connection to clock enable pin.
 - clock-output-names : From common clock binding.
 
@@ -18,4 +20,5 @@ Example:
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <1000000000>;
+		clock-accuracy = <100>;
 	};
diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index 1ed591a..0fc56ab 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -34,22 +34,31 @@ static unsigned long clk_fixed_rate_recalc_rate(struct clk_hw *hw,
 	return to_clk_fixed_rate(hw)->fixed_rate;
 }
 
+static unsigned long clk_fixed_rate_recalc_accuracy(struct clk_hw *hw,
+		unsigned long parent_accuracy)
+{
+	return to_clk_fixed_rate(hw)->fixed_accuracy;
+}
+
 const struct clk_ops clk_fixed_rate_ops = {
 	.recalc_rate = clk_fixed_rate_recalc_rate,
+	.recalc_accuracy = clk_fixed_rate_recalc_accuracy,
 };
 EXPORT_SYMBOL_GPL(clk_fixed_rate_ops);
 
 /**
- * clk_register_fixed_rate - register fixed-rate clock with the clock framework
+ * clk_register_fixed_rate_with_accuracy - register fixed-rate clock with the
+ *					   clock framework
  * @dev: device that is registering this clock
  * @name: name of this clock
  * @parent_name: name of clock's parent
  * @flags: framework-specific flags
  * @fixed_rate: non-adjustable clock rate
+ * @fixed_accuracy: non-adjustable clock rate
  */
-struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
-		const char *parent_name, unsigned long flags,
-		unsigned long fixed_rate)
+struct clk *clk_register_fixed_rate_with_accuracy(struct device *dev,
+		const char *name, const char *parent_name, unsigned long flags,
+		unsigned long fixed_rate, unsigned long fixed_accuracy)
 {
 	struct clk_fixed_rate *fixed;
 	struct clk *clk;
@@ -70,16 +79,33 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 
 	/* struct clk_fixed_rate assignments */
 	fixed->fixed_rate = fixed_rate;
+	fixed->fixed_accuracy = fixed_accuracy;
 	fixed->hw.init = &init;
 
 	/* register the clock */
 	clk = clk_register(dev, &fixed->hw);
-
 	if (IS_ERR(clk))
 		kfree(fixed);
 
 	return clk;
 }
+EXPORT_SYMBOL_GPL(clk_register_fixed_rate_with_accuracy);
+
+/**
+ * clk_register_fixed_rate - register fixed-rate clock with the clock framework
+ * @dev: device that is registering this clock
+ * @name: name of this clock
+ * @parent_name: name of clock's parent
+ * @flags: framework-specific flags
+ * @fixed_rate: non-adjustable clock rate
+ */
+struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		unsigned long fixed_rate)
+{
+	return clk_register_fixed_rate_with_accuracy(dev, name, parent_name,
+						     flags, fixed_rate, 0);
+}
 EXPORT_SYMBOL_GPL(clk_register_fixed_rate);
 
 #ifdef CONFIG_OF
@@ -91,13 +117,18 @@ void of_fixed_clk_setup(struct device_node *node)
 	struct clk *clk;
 	const char *clk_name = node->name;
 	u32 rate;
+	u32 accuracy = 0;
 
 	if (of_property_read_u32(node, "clock-frequency", &rate))
 		return;
 
+	of_property_read_u32(node, "clock-accuracy", &accuracy);
+
 	of_property_read_string(node, "clock-output-names", &clk_name);
 
-	clk = clk_register_fixed_rate(NULL, clk_name, NULL, CLK_IS_ROOT, rate);
+	clk = clk_register_fixed_rate_with_accuracy(NULL, clk_name, NULL,
+						    CLK_IS_ROOT, rate,
+						    accuracy);
 	if (!IS_ERR(clk))
 		of_clk_add_provider(node, of_clk_src_simple_get, clk);
 }
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 16d182c..5429f5d 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -204,6 +204,7 @@ struct clk_hw {
 struct clk_fixed_rate {
 	struct		clk_hw hw;
 	unsigned long	fixed_rate;
+	unsigned long	fixed_accuracy;
 	u8		flags;
 };
 
@@ -211,6 +212,9 @@ extern const struct clk_ops clk_fixed_rate_ops;
 struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned long fixed_rate);
+struct clk *clk_register_fixed_rate_with_accuracy(struct device *dev,
+		const char *name, const char *parent_name, unsigned long flags,
+		unsigned long fixed_rate, unsigned long fixed_accuracy);
 
 void of_fixed_clk_setup(struct device_node *np);
 
-- 
1.7.9.5

