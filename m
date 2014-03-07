Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaCGOoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:44:08 -0500
Received: from eu1sys200aog125.obsmtp.com ([207.126.144.159]:46820 "EHLO
	eu1sys200aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532AbaCGOm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:42:58 -0500
X-Greylist: delayed 17966 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Mar 2014 09:42:57 EST
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <maxime.coquelin@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Cc: lee.jones@linaro.org
Subject: [PATCH v3 2/5] pinctrl: st: Enhance the controller to manage unavailable registers
Date: Fri,  7 Mar 2014 15:40:48 +0100
Message-Id: <1394203251-25361-3-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394203251-25361-1-git-send-email-maxime.coquelin@st.com>
References: <1394203251-25361-1-git-send-email-maxime.coquelin@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giuseppe Cavallaro <peppe.cavallaro@st.com>

This patch adds a new logic inside the st pinctrl to manage
an unsupported scenario: some sysconfig are not available!

This is the case of STiH407 where, although documented, the
following registers from SYSCFG_FLASH have been removed from the SoC.

SYSTEM_CONFIG3040
   Output Enable pad control for all PIO Alternate Functions
and
SYSTEM_ CONFIG3050
   Pull Up pad control for all PIO Alternate Functions

Without managing this condition an imprecise external abort
will be detect.

To do this the patch also reviews the st_parse_syscfgs
and other routines to manipulate the registers only if
actually available.
In any case, for example the st_parse_syscfgs detected
an error condition but no action was made in the
st_pctl_probe_dt.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 drivers/pinctrl/pinctrl-st.c | 106 +++++++++++++++++++++++++------------------
 1 file changed, 61 insertions(+), 45 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 9fb66aa..1721611 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -410,25 +410,27 @@ static void st_pinconf_set_config(struct st_pio_control *pc,
 	unsigned int oe_value, pu_value, od_value;
 	unsigned long mask = BIT(pin);
 
-	regmap_field_read(output_enable, &oe_value);
-	regmap_field_read(pull_up, &pu_value);
-	regmap_field_read(open_drain, &od_value);
-
-	/* Clear old values */
-	oe_value &= ~mask;
-	pu_value &= ~mask;
-	od_value &= ~mask;
-
-	if (config & ST_PINCONF_OE)
-		oe_value |= mask;
-	if (config & ST_PINCONF_PU)
-		pu_value |= mask;
-	if (config & ST_PINCONF_OD)
-		od_value |= mask;
-
-	regmap_field_write(output_enable, oe_value);
-	regmap_field_write(pull_up, pu_value);
-	regmap_field_write(open_drain, od_value);
+	if (output_enable) {
+		regmap_field_read(output_enable, &oe_value);
+		oe_value &= ~mask;
+		if (config & ST_PINCONF_OE)
+			oe_value |= mask;
+		regmap_field_write(output_enable, oe_value);
+	}
+	if (pull_up) {
+		regmap_field_read(pull_up, &pu_value);
+		pu_value &= ~mask;
+		if (config & ST_PINCONF_PU)
+			pu_value |= mask;
+		regmap_field_write(pull_up, pu_value);
+	}
+	if (open_drain) {
+		regmap_field_read(open_drain, &od_value);
+		od_value &= ~mask;
+		if (config & ST_PINCONF_OD)
+			od_value |= mask;
+		regmap_field_write(open_drain, od_value);
+	}
 }
 
 static void st_pctl_set_function(struct st_pio_control *pc,
@@ -439,6 +441,9 @@ static void st_pctl_set_function(struct st_pio_control *pc,
 	int pin = st_gpio_pin(pin_id);
 	int offset = pin * 4;
 
+	if (!alt)
+		return;
+
 	regmap_field_read(alt, &val);
 	val &= ~(0xf << offset);
 	val |= function << offset;
@@ -571,22 +576,28 @@ static void st_pinconf_set_retime_dedicated(struct st_pinctrl *info,
 	regmap_field_write(rt_d->rt[pin], retime_config);
 }
 
-static void st_pinconf_get_direction(struct st_pio_control *pc,
-	int pin, unsigned long *config)
+static void st_pinconf_get_direction(struct st_pio_control *pc, int pin,
+				     unsigned long *config)
 {
 	unsigned int oe_value, pu_value, od_value;
 
-	regmap_field_read(pc->oe, &oe_value);
-	regmap_field_read(pc->pu, &pu_value);
-	regmap_field_read(pc->od, &od_value);
+	if (pc->oe) {
+		regmap_field_read(pc->oe, &oe_value);
+		if (oe_value & BIT(pin))
+			ST_PINCONF_PACK_OE(*config);
+	}
 
-	if (oe_value & BIT(pin))
-		ST_PINCONF_PACK_OE(*config);
-	if (pu_value & BIT(pin))
-		ST_PINCONF_PACK_PU(*config);
-	if (od_value & BIT(pin))
-		ST_PINCONF_PACK_OD(*config);
+	if (pc->pu) {
+		regmap_field_read(pc->pu, &pu_value);
+		if (pu_value & BIT(pin))
+			ST_PINCONF_PACK_PU(*config);
+	}
 
+	if (pc->od) {
+		regmap_field_read(pc->od, &od_value);
+		if (od_value & BIT(pin))
+			ST_PINCONF_PACK_OD(*config);
+	}
 }
 
 static int st_pinconf_get_retime_packed(struct st_pinctrl *info,
@@ -1105,8 +1116,21 @@ static int st_pctl_dt_setup_retime(struct st_pinctrl *info,
 	return -EINVAL;
 }
 
-static int st_parse_syscfgs(struct st_pinctrl *info,
-		int bank, struct device_node *np)
+
+static struct regmap_field *st_pc_get_value(struct device *dev,
+					    struct regmap *regmap, int bank,
+					    int data, int lsb, int msb)
+{
+	struct reg_field reg = REG_FIELD((data + bank) * 4, lsb, msb);
+
+	if (data < 0)
+		return NULL;
+
+	return devm_regmap_field_alloc(dev, regmap, reg);
+}
+
+static void st_parse_syscfgs(struct st_pinctrl *info, int bank,
+			     struct device_node *np)
 {
 	const struct st_pctl_data *data = info->data;
 	/**
@@ -1116,29 +1140,21 @@ static int st_parse_syscfgs(struct st_pinctrl *info,
 	 */
 	int lsb = (bank%4) * ST_GPIO_PINS_PER_BANK;
 	int msb = lsb + ST_GPIO_PINS_PER_BANK - 1;
-	struct reg_field alt_reg = REG_FIELD((data->alt + bank) * 4, 0, 31);
-	struct reg_field oe_reg = REG_FIELD((data->oe + bank/4) * 4, lsb, msb);
-	struct reg_field pu_reg = REG_FIELD((data->pu + bank/4) * 4, lsb, msb);
-	struct reg_field od_reg = REG_FIELD((data->od + bank/4) * 4, lsb, msb);
 	struct st_pio_control *pc = &info->banks[bank].pc;
 	struct device *dev = info->dev;
 	struct regmap *regmap  = info->regmap;
 
-	pc->alt = devm_regmap_field_alloc(dev, regmap, alt_reg);
-	pc->oe = devm_regmap_field_alloc(dev, regmap, oe_reg);
-	pc->pu = devm_regmap_field_alloc(dev, regmap, pu_reg);
-	pc->od = devm_regmap_field_alloc(dev, regmap, od_reg);
-
-	if (IS_ERR(pc->alt) || IS_ERR(pc->oe) ||
-			IS_ERR(pc->pu) || IS_ERR(pc->od))
-		return -EINVAL;
+	pc->alt = st_pc_get_value(dev, regmap, bank, data->alt, 0, 31);
+	pc->oe = st_pc_get_value(dev, regmap, bank/4, data->oe, lsb, msb);
+	pc->pu = st_pc_get_value(dev, regmap, bank/4, data->pu, lsb, msb);
+	pc->od = st_pc_get_value(dev, regmap, bank/4, data->od, lsb, msb);
 
 	/* retime avaiable for all pins by default */
 	pc->rt_pin_mask = 0xff;
 	of_property_read_u32(np, "st,retime-pin-mask", &pc->rt_pin_mask);
 	st_pctl_dt_setup_retime(info, bank, pc);
 
-	return 0;
+	return;
 }
 
 /*
-- 
1.9.0

