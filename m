Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3FBXk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 19:40:26 -0400
Received: from gloria.sntech.de ([95.129.55.99]:40457 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab3FBXjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 19:39:46 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 03/10] clk: flag to use upper half of the register as change indicator
Date: Mon, 3 Jun 2013 00:57:15 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
References: <201306030055.15413.heiko@sntech.de>
In-Reply-To: <201306030055.15413.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306030057.15989.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There exist platforms, namely at least all Rockchip Cortex-A9 based ones,
that don't use the paradigm of reading-changing-writing the register contents,
but instead only write the changes to the register with a mask that indicates
the changed bits.

This patch adds flags and code to support the case where the lower 16 bit of
hold the information and the upper 16 bit are used as mask to indicate the
written changes.

As hardware-specific flags should not be added to the common clk flags, the
flags are added to gate, mux and divider clocks individually.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/clk/clk-divider.c    |   15 +++++++++++++--
 drivers/clk/clk-gate.c       |   24 ++++++++++++++++++------
 drivers/clk/clk-mux.c        |   15 +++++++++++++--
 include/linux/clk-provider.h |   16 ++++++++++++++++
 4 files changed, 60 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 6d96741..e37c48a 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -217,8 +217,12 @@ static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 	if (divider->lock)
 		spin_lock_irqsave(divider->lock, flags);
 
-	val = readl(divider->reg);
-	val &= ~(div_mask(divider) << divider->shift);
+	if (divider->flags & CLK_DIVIDER_MASK_UPPER_HALF) {
+		val = div_mask(divider) << (divider->shift + 16);
+	} else {
+		val = readl(divider->reg);
+		val &= ~(div_mask(divider) << divider->shift);
+	}
 	val |= value << divider->shift;
 	writel(val, divider->reg);
 
@@ -245,6 +249,13 @@ static struct clk *_register_divider(struct device *dev, const char *name,
 	struct clk *clk;
 	struct clk_init_data init;
 
+	if ((clk_divider_flags & CLK_DIVIDER_MASK_UPPER_HALF) &&
+	    (shift + width > 15)) {
+		pr_err("%s: shift %d + width %d invalid\n", __func__,
+		       shift, width);
+		return ERR_PTR(-EINVAL);
+	}
+
 	/* allocate the divider */
 	div = kzalloc(sizeof(struct clk_divider), GFP_KERNEL);
 	if (!div) {
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index 15114fe..e553fa7 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -53,12 +53,19 @@ static void clk_gate_endisable(struct clk_hw *hw, int enable)
 	if (gate->lock)
 		spin_lock_irqsave(gate->lock, flags);
 
-	reg = readl(gate->reg);
-
-	if (set)
-		reg |= BIT(gate->bit_idx);
-	else
-		reg &= ~BIT(gate->bit_idx);
+	if (gate->flags & CLK_GATE_MASK_UPPER_HALF) {
+		reg = BIT(gate->bit_idx + 16);
+
+		if (set)
+			reg |= BIT(gate->bit_idx);
+	} else {
+		reg = readl(gate->reg);
+
+		if (set)
+			reg |= BIT(gate->bit_idx);
+		else
+			reg &= ~BIT(gate->bit_idx);
+	}
 
 	writel(reg, gate->reg);
 
@@ -121,6 +128,11 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 	struct clk *clk;
 	struct clk_init_data init;
 
+	if ((clk_gate_flags & CLK_GATE_MASK_UPPER_HALF) && bit_idx > 15) {
+		pr_err("%s: bit_idx %d invalid\n", __func__, bit_idx);
+		return ERR_PTR(-EINVAL);
+	}
+
 	/* allocate the gate */
 	gate = kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
 	if (!gate) {
diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 25b1734..fce26f5 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -86,8 +86,12 @@ static int clk_mux_set_parent(struct clk_hw *hw, u8 index)
 	if (mux->lock)
 		spin_lock_irqsave(mux->lock, flags);
 
-	val = readl(mux->reg);
-	val &= ~(mux->mask << mux->shift);
+	if (mux->flags & CLK_MUX_MASK_UPPER_HALF) {
+		val = mux->mask << (mux->shift + 16);
+	} else {
+		val = readl(mux->reg);
+		val &= ~(mux->mask << mux->shift);
+	}
 	val |= index << mux->shift;
 	writel(val, mux->reg);
 
@@ -112,6 +116,13 @@ struct clk *clk_register_mux_table(struct device *dev, const char *name,
 	struct clk *clk;
 	struct clk_init_data init;
 
+	if (!mask || ((clk_mux_flags & CLK_MUX_MASK_UPPER_HALF) &&
+		      (__fls(mask << shift) > 15))) {
+		pr_err("%s: shift %d + mask %d invalid\n", __func__,
+		       shift, mask);
+		return ERR_PTR(-EINVAL);
+	}
+
 	/* allocate the mux */
 	mux = kzalloc(sizeof(struct clk_mux), GFP_KERNEL);
 	if (!mux) {
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 265f384..420a187 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -210,6 +210,11 @@ void of_fixed_clk_setup(struct device_node *np);
  * CLK_GATE_SET_TO_DISABLE - by default this clock sets the bit at bit_idx to
  * 	enable the clock.  Setting this flag does the opposite: setting the bit
  * 	disable the clock and clearing it enables the clock
+ * CLK_GATE_MASK_UPPER_HALF - this clock only uses the lower 16 bit of the
+ *	register to hold the gate bits, while using the upper 16 bit to
+ *	indicate the bits that get changed during a write. So gating the
+ *	clock in bit 2 would write BIT(18) | BIT(2) to the register, while
+ *	ungating this clock would write only BIT(18) to the register.
  */
 struct clk_gate {
 	struct clk_hw hw;
@@ -220,6 +225,7 @@ struct clk_gate {
 };
 
 #define CLK_GATE_SET_TO_DISABLE		BIT(0)
+#define CLK_GATE_MASK_UPPER_HALF	BIT(1)
 
 extern const struct clk_ops clk_gate_ops;
 struct clk *clk_register_gate(struct device *dev, const char *name,
@@ -257,6 +263,11 @@ struct clk_div_table {
  *	Some hardware implementations gracefully handle this case and allow a
  *	zero divisor by not modifying their input clock
  *	(divide by one / bypass).
+ * CLK_DIVIDER_MASK_UPPER_HALF - this clock only uses the lower 16 bit of the
+ *	register to hold the divider bits, while using the upper 16 bit to
+ *	indicate the bits that get changed during a write. So for a clock with
+ *	shift 0 and width 2, setting the divider to 2 would result in a write
+ *	of (3 << 16) | (2 << 0).
  */
 struct clk_divider {
 	struct clk_hw	hw;
@@ -271,6 +282,7 @@ struct clk_divider {
 #define CLK_DIVIDER_ONE_BASED		BIT(0)
 #define CLK_DIVIDER_POWER_OF_TWO	BIT(1)
 #define CLK_DIVIDER_ALLOW_ZERO		BIT(2)
+#define CLK_DIVIDER_MASK_UPPER_HALF	BIT(3)
 
 extern const struct clk_ops clk_divider_ops;
 struct clk *clk_register_divider(struct device *dev, const char *name,
@@ -299,6 +311,9 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
  * Flags:
  * CLK_MUX_INDEX_ONE - register index starts at 1, not 0
  * CLK_MUX_INDEX_BIT - register index is a single bit (power of two)
+ * CLK_MUX_MASK_UPPER_HALF - this clock only uses the lower 16 bit of the
+ *	register to hold the mux bits, while using the upper 16 bit to
+ *	indicate the bits that get changed during a write.
  */
 struct clk_mux {
 	struct clk_hw	hw;
@@ -312,6 +327,7 @@ struct clk_mux {
 
 #define CLK_MUX_INDEX_ONE		BIT(0)
 #define CLK_MUX_INDEX_BIT		BIT(1)
+#define CLK_MUX_MASK_UPPER_HALF		BIT(3)
 
 extern const struct clk_ops clk_mux_ops;
 
-- 
1.7.2.3

