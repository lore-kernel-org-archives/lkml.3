Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaHRRal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:30:41 -0400
Received: from mail-pd0-f201.google.com ([209.85.192.201]:35957 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaHRR3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:29:47 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Caesar Wang <caesar.wang@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, olof@lixom.net,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 2/4] pwm: rockchip: Allow polarity invert on rk3288
Date: Mon, 18 Aug 2014 10:29:40 -0700
Message-Id: <1408382982-2077-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1408382982-2077-1-git-send-email-dianders@chromium.org>
References: <1408382982-2077-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rk3288 has the ability to invert the polarity of the PWM.  Let's
enable that ability.

To do this we increase the number of pwm_cells to 3 to allow using the
PWM_POLARITY_INVERTED flag.  Since the PWM driver on rk3288 is very
new, I thought this was OK.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2: None

 .../devicetree/bindings/pwm/pwm-rockchip.txt       |  4 +--
 drivers/pwm/pwm-rockchip.c                         | 32 ++++++++++++++++++++--
 2 files changed, 32 insertions(+), 4 deletions(-)

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
index bdd8644..27f20d6 100644
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
 
@@ -32,6 +34,7 @@ struct rockchip_pwm_chip {
 	struct pwm_chip chip;
 	struct clk *clk;
 	const struct rockchip_pwm_data *data;
+	enum pwm_polarity polarity;
 	void __iomem *base;
 };
 
@@ -45,6 +48,7 @@ struct rockchip_pwm_regs {
 struct rockchip_pwm_data {
 	struct rockchip_pwm_regs regs;
 	unsigned int prescaler;
+	bool has_invert;
 
 	void (*set_enable)(struct pwm_chip *chip, bool enable);
 };
@@ -74,10 +78,14 @@ static void rockchip_pwm_set_enable_v2(struct pwm_chip *chip, bool enable)
 {
 	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
 	u32 enable_conf = PWM_OUTPUT_LEFT | PWM_LP_DISABLE | PWM_ENABLE |
-			  PWM_CONTINUOUS | PWM_DUTY_POSITIVE |
-			  PWM_INACTIVE_NEGATIVE;
+			  PWM_CONTINUOUS;
 	u32 val;
 
+	if (pc->polarity == PWM_POLARITY_INVERSED)
+		enable_conf |= PWM_DUTY_NEGATIVE | PWM_INACTIVE_POSITIVE;
+	else
+		enable_conf |= PWM_DUTY_POSITIVE | PWM_INACTIVE_NEGATIVE;
+
 	val = readl_relaxed(pc->base + pc->data->regs.ctrl);
 
 	if (enable)
@@ -124,6 +132,19 @@ static int rockchip_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	return 0;
 }
 
+int rockchip_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
+			      enum pwm_polarity polarity)
+{
+	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
+
+	if (!pc->data->has_invert)
+		return -ENOSYS;
+
+	pc->polarity = polarity;
+
+	return 0;
+}
+
 static int rockchip_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
@@ -149,6 +170,7 @@ static void rockchip_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 static const struct pwm_ops rockchip_pwm_ops = {
 	.config = rockchip_pwm_config,
+	.set_polarity = rockchip_pwm_set_polarity,
 	.enable = rockchip_pwm_enable,
 	.disable = rockchip_pwm_disable,
 	.owner = THIS_MODULE,
@@ -173,6 +195,7 @@ static const struct rockchip_pwm_data pwm_data_v2 = {
 		.ctrl = 0x0c,
 	},
 	.prescaler = 1,
+	.has_invert = 1,
 	.set_enable = rockchip_pwm_set_enable_v2,
 };
 
@@ -184,6 +207,7 @@ static const struct rockchip_pwm_data pwm_data_vop = {
 		.ctrl = 0x00,
 	},
 	.prescaler = 1,
+	.has_invert = 1,
 	.set_enable = rockchip_pwm_set_enable_v2,
 };
 
@@ -228,6 +252,10 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 	pc->data = id->data;
 	pc->chip.dev = &pdev->dev;
 	pc->chip.ops = &rockchip_pwm_ops;
+	if (pc->data->has_invert) {
+		pc->chip.of_xlate = of_pwm_xlate_with_flags;
+		pc->chip.of_pwm_n_cells = 3;
+	}
 	pc->chip.base = -1;
 	pc->chip.npwm = 1;
 
-- 
2.1.0.rc2.206.gedb03e5

