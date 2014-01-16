Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaAPII6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 03:08:58 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:57306 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaAPIIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 03:08:55 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCHv2 2/2] pwm: imx: support polarity inversion
Date: Thu, 16 Jan 2014 09:06:25 +0100
Message-Id: <1389859585-14006-3-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1389859585-14006-1-git-send-email-LW@KARO-electronics.de>
References: <1389859585-14006-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i.MX PWM controller supports inverting the polarity of the PWM
output. Make this feature available in the pxm-imx driver.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 Documentation/devicetree/bindings/pwm/imx-pwm.txt |    5 +-
 drivers/pwm/pwm-imx.c                             |   42 +++++++++++++++++++++
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/imx-pwm.txt b/Documentation/devicetree/bindings/pwm/imx-pwm.txt
index b50d7a6d..d0b04b5 100644
--- a/Documentation/devicetree/bindings/pwm/imx-pwm.txt
+++ b/Documentation/devicetree/bindings/pwm/imx-pwm.txt
@@ -3,8 +3,9 @@ Freescale i.MX PWM controller
 Required properties:
 - compatible: should be "fsl,<soc>-pwm"
 - reg: physical base address and length of the controller's registers
-- #pwm-cells: should be 2. See pwm.txt in this directory for a description of
-  the cells format.
+- #pwm-cells: may be 2 for backwards compatibility or 3 to support
+  switching the output polarity. See pwm.txt in this directory for a
+  description of the cells format.
 - interrupts: The interrupt for the pwm controller
 
 Example:
diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 3b00a82..05461bb 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -36,6 +36,7 @@
 #define MX3_PWMCR_DOZEEN		(1 << 24)
 #define MX3_PWMCR_WAITEN		(1 << 23)
 #define MX3_PWMCR_DBGEN			(1 << 22)
+#define MX3_PWMCR_POUTC			(1 << 18)
 #define MX3_PWMCR_CLKSRC_IPG_HIGH	(2 << 16)
 #define MX3_PWMCR_CLKSRC_IPG		(1 << 16)
 #define MX3_PWMCR_EN			(1 << 0)
@@ -138,6 +139,9 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
 	if (test_bit(PWMF_ENABLED, &pwm->flags))
 		cr |= MX3_PWMCR_EN;
 
+	if (pwm->polarity == PWM_POLARITY_INVERSED)
+		cr |= MX3_PWMCR_POUTC;
+
 	writel(cr, imx->mmio_base + MX3_PWMCR);
 
 	return 0;
@@ -155,6 +159,11 @@ static void imx_pwm_set_enable_v2(struct pwm_chip *chip, bool enable)
 	else
 		val &= ~MX3_PWMCR_EN;
 
+	if (chip->pwms[0].polarity == PWM_POLARITY_INVERSED)
+		val |= MX3_PWMCR_POUTC;
+	else
+		val &= ~MX3_PWMCR_POUTC;
+
 	writel(val, imx->mmio_base + MX3_PWMCR);
 }
 
@@ -198,6 +207,17 @@ static void imx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	clk_disable_unprepare(imx->clk_per);
 }
 
+static int imx_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
+				enum pwm_polarity polarity)
+{
+	struct imx_chip *imx = to_imx_chip(chip);
+
+	dev_dbg(imx->chip.dev, "%s: polarity set to %s\n", __func__,
+		polarity == PWM_POLARITY_INVERSED ? "inverted" : "normal");
+
+	return 0;
+}
+
 static struct pwm_ops imx_pwm_ops = {
 	.enable = imx_pwm_enable,
 	.disable = imx_pwm_disable,
@@ -209,6 +229,7 @@ struct imx_pwm_data {
 	int (*config)(struct pwm_chip *chip,
 		struct pwm_device *pwm, int duty_ns, int period_ns);
 	void (*set_enable)(struct pwm_chip *chip, bool enable);
+	unsigned output_polarity:1;
 };
 
 static struct imx_pwm_data imx_pwm_data_v1 = {
@@ -219,6 +240,7 @@ static struct imx_pwm_data imx_pwm_data_v1 = {
 static struct imx_pwm_data imx_pwm_data_v2 = {
 	.config = imx_pwm_config_v2,
 	.set_enable = imx_pwm_set_enable_v2,
+	.output_polarity = 1,
 };
 
 static const struct of_device_id imx_pwm_dt_ids[] = {
@@ -271,6 +293,26 @@ static int imx_pwm_probe(struct platform_device *pdev)
 		return PTR_ERR(imx->mmio_base);
 
 	data = of_id->data;
+	if (data->output_polarity) {
+		const struct device_node *np = pdev->dev.of_node;
+		u32 num_cells;
+
+		dev_dbg(&pdev->dev, "PWM supports output inversion\n");
+		ret = of_property_read_u32(np, "#pwm-cells", &num_cells);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "missing property '#pwm-cells'\n");
+			return ret;
+		}
+		if (num_cells == 3) {
+			imx_pwm_ops.set_polarity = imx_pwm_set_polarity;
+			imx->chip.of_xlate = of_pwm_xlate_with_flags;
+		} else if (num_cells != 2) {
+			dev_err(&pdev->dev, "'#pwm-cells' must be <2> or <3>\n");
+			return -EINVAL;
+		}
+		imx->chip.of_pwm_n_cells = num_cells;
+	}
+
 	imx->config = data->config;
 	imx->set_enable = data->set_enable;
 
-- 
1.7.2.5

