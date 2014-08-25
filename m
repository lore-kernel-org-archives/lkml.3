Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbaHYXFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 19:05:34 -0400
Received: from mail-oi0-f74.google.com ([209.85.218.74]:33765 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaHYXFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 19:05:32 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Caesar Wang <caesar.wang@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, olof@lixom.net,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 1/3] pwm: rockchip: Allow polarity invert on rk3288
Date: Mon, 25 Aug 2014 15:59:25 -0700
Message-Id: <1409007567-23523-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409007567-23523-1-git-send-email-dianders@chromium.org>
References: <1409007567-23523-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rk3288 has the ability to invert the polarity of the PWM.  Let's
enable that ability.  Note that this increases pwm_cells to 3 for
rk3288.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Caesar Wang <caesar.wang@rock-chips.com>
---
Changes in v5: None
Changes in v4:
- Updated comment not to add caveats about pwm_cells 3.
- rockchip_pwm_set_polarity() is now static.
- Separate pwm_ops for v1 and v2; no set_polarity() in v1.
- Added a blank line.

Changes in v3:
- Don't store a private copy of polarity.
- Use true instead of 1.
- Cleanup init order with "has_invert".

 .../devicetree/bindings/pwm/pwm-rockchip.txt       |  4 +-
 drivers/pwm/pwm-rockchip.c                         | 57 ++++++++++++++++++----
 2 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
index d47d15a..b8be3d0 100644
--- a/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
+++ b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
@@ -7,8 +7,8 @@ Required properties:
    "rockchip,vop-pwm": found integrated in VOP on RK3288 SoC
  - reg: physical base address and length of the controller's registers
  - clocks: phandle and clock specifier of the PWM reference clock
- - #pwm-cells: should be 2. See pwm.txt in this directory for a
-   description of the cell format.
+ - #pwm-cells: must be 2 (rk2928) or 3 (rk3288). See pwm.txt in this directory
+   for a description of the cell format.
 
 Example:
 
diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
index bdd8644..9442df2 100644
--- a/drivers/pwm/pwm-rockchip.c
+++ b/drivers/pwm/pwm-rockchip.c
@@ -24,7 +24,9 @@
 #define PWM_ENABLE		(1 << 0)
 #define PWM_CONTINUOUS		(1 << 1)
 #define PWM_DUTY_POSITIVE	(1 << 3)
+#define PWM_DUTY_NEGATIVE	(0 << 3)
 #define PWM_INACTIVE_NEGATIVE	(0 << 4)
+#define PWM_INACTIVE_POSITIVE	(1 << 4)
 #define PWM_OUTPUT_LEFT		(0 << 5)
 #define PWM_LP_DISABLE		(0 << 8)
 
@@ -45,8 +47,10 @@ struct rockchip_pwm_regs {
 struct rockchip_pwm_data {
 	struct rockchip_pwm_regs regs;
 	unsigned int prescaler;
+	const struct pwm_ops *ops;
 
-	void (*set_enable)(struct pwm_chip *chip, bool enable);
+	void (*set_enable)(struct pwm_chip *chip,
+			   struct pwm_device *pwm, bool enable);
 };
 
 static inline struct rockchip_pwm_chip *to_rockchip_pwm_chip(struct pwm_chip *c)
@@ -54,7 +58,8 @@ static inline struct rockchip_pwm_chip *to_rockchip_pwm_chip(struct pwm_chip *c)
 	return container_of(c, struct rockchip_pwm_chip, chip);
 }
 
-static void rockchip_pwm_set_enable_v1(struct pwm_chip *chip, bool enable)
+static void rockchip_pwm_set_enable_v1(struct pwm_chip *chip,
+				       struct pwm_device *pwm, bool enable)
 {
 	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
 	u32 enable_conf = PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN;
@@ -70,14 +75,19 @@ static void rockchip_pwm_set_enable_v1(struct pwm_chip *chip, bool enable)
 	writel_relaxed(val, pc->base + pc->data->regs.ctrl);
 }
 
-static void rockchip_pwm_set_enable_v2(struct pwm_chip *chip, bool enable)
+static void rockchip_pwm_set_enable_v2(struct pwm_chip *chip,
+				       struct pwm_device *pwm, bool enable)
 {
 	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
 	u32 enable_conf = PWM_OUTPUT_LEFT | PWM_LP_DISABLE | PWM_ENABLE |
-			  PWM_CONTINUOUS | PWM_DUTY_POSITIVE |
-			  PWM_INACTIVE_NEGATIVE;
+			  PWM_CONTINUOUS;
 	u32 val;
 
+	if (pwm->polarity == PWM_POLARITY_INVERSED)
+		enable_conf |= PWM_DUTY_NEGATIVE | PWM_INACTIVE_POSITIVE;
+	else
+		enable_conf |= PWM_DUTY_POSITIVE | PWM_INACTIVE_NEGATIVE;
+
 	val = readl_relaxed(pc->base + pc->data->regs.ctrl);
 
 	if (enable)
@@ -124,6 +134,19 @@ static int rockchip_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	return 0;
 }
 
+static int rockchip_pwm_set_polarity(struct pwm_chip *chip,
+				     struct pwm_device *pwm,
+				     enum pwm_polarity polarity)
+{
+	/*
+	 * No action needed here because pwm->polarity will be set by the core
+	 * and the core will only change polarity when the PWM is not enabled.
+	 * We'll handle things in set_enable().
+	 */
+
+	return 0;
+}
+
 static int rockchip_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
@@ -133,7 +156,7 @@ static int rockchip_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	if (ret)
 		return ret;
 
-	pc->data->set_enable(chip, true);
+	pc->data->set_enable(chip, pwm, true);
 
 	return 0;
 }
@@ -142,18 +165,26 @@ static void rockchip_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
 
-	pc->data->set_enable(chip, false);
+	pc->data->set_enable(chip, pwm, false);
 
 	clk_disable(pc->clk);
 }
 
-static const struct pwm_ops rockchip_pwm_ops = {
+static const struct pwm_ops rockchip_pwm_ops_v1 = {
 	.config = rockchip_pwm_config,
 	.enable = rockchip_pwm_enable,
 	.disable = rockchip_pwm_disable,
 	.owner = THIS_MODULE,
 };
 
+static const struct pwm_ops rockchip_pwm_ops_v2 = {
+	.config = rockchip_pwm_config,
+	.set_polarity = rockchip_pwm_set_polarity,
+	.enable = rockchip_pwm_enable,
+	.disable = rockchip_pwm_disable,
+	.owner = THIS_MODULE,
+};
+
 static const struct rockchip_pwm_data pwm_data_v1 = {
 	.regs = {
 		.duty = 0x04,
@@ -162,6 +193,7 @@ static const struct rockchip_pwm_data pwm_data_v1 = {
 		.ctrl = 0x0c,
 	},
 	.prescaler = 2,
+	.ops = &rockchip_pwm_ops_v1,
 	.set_enable = rockchip_pwm_set_enable_v1,
 };
 
@@ -173,6 +205,7 @@ static const struct rockchip_pwm_data pwm_data_v2 = {
 		.ctrl = 0x0c,
 	},
 	.prescaler = 1,
+	.ops = &rockchip_pwm_ops_v2,
 	.set_enable = rockchip_pwm_set_enable_v2,
 };
 
@@ -184,6 +217,7 @@ static const struct rockchip_pwm_data pwm_data_vop = {
 		.ctrl = 0x00,
 	},
 	.prescaler = 1,
+	.ops = &rockchip_pwm_ops_v2,
 	.set_enable = rockchip_pwm_set_enable_v2,
 };
 
@@ -227,10 +261,15 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 
 	pc->data = id->data;
 	pc->chip.dev = &pdev->dev;
-	pc->chip.ops = &rockchip_pwm_ops;
+	pc->chip.ops = pc->data->ops;
 	pc->chip.base = -1;
 	pc->chip.npwm = 1;
 
+	if (pc->data->ops->set_polarity) {
+		pc->chip.of_xlate = of_pwm_xlate_with_flags;
+		pc->chip.of_pwm_n_cells = 3;
+	}
+
 	ret = pwmchip_add(&pc->chip);
 	if (ret < 0) {
 		clk_unprepare(pc->clk);
-- 
2.1.0.rc2.206.gedb03e5

