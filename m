Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3EaKM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:12:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56784 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3EaKME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:12:04 -0400
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <khilman@linaro.org>, <grant.likely@linaro.org>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <vaibhav.bedia@ti.com>,
        <sudhakar.raj@ti.com>, <gururaja.hebbar@ti.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 08/11] pwm: pwm-tiecap: enhance pinctrl support
Date: Fri, 31 May 2013 15:43:08 +0530
Message-ID: <1369995191-20855-9-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amend TI ecap controller to optionally take a pin control handle and
set the state of the pins to:

- "default" on boot, resume
- "sleep" on suspend()

By optionally putting the pins into sleep state in the suspend callback
we can accomplish two things.
- One is to minimize current leakage from pins and thus save power,
- second, we can prevent the IP from driving pins output in an
uncontrolled manner, which may happen if the power domain drops the
domain regulator.

If any of the above pin states are missing in dt, a warning message
about the missing state is displayed.
If certain pin-states are not available, to remove this warning message
pass respective state name with null phandler.

Todo:
        - if an idle state is available for pins, add support for it.

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 72ca42d... d02769d... M	drivers/pwm/pwm-tiecap.c
 drivers/pwm/pwm-tiecap.c |   48 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 72ca42d..d02769d 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -52,6 +52,11 @@ struct ecap_pwm_chip {
 	unsigned int	clk_rate;
 	void __iomem	*mmio_base;
 	struct ecap_context ctx;
+
+	/* two pin states - default, sleep */
+	struct pinctrl			*pinctrl;
+	struct pinctrl_state		*pins_default;
+	struct pinctrl_state		*pins_sleep;
 };
 
 static inline struct ecap_pwm_chip *to_ecap_pwm_chip(struct pwm_chip *chip)
@@ -208,11 +213,6 @@ static int ecap_pwm_probe(struct platform_device *pdev)
 	struct clk *clk;
 	struct ecap_pwm_chip *pc;
 	u16 status;
-	struct pinctrl *pinctrl;
-
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "unable to select pin group\n");
 
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc) {
@@ -220,6 +220,34 @@ static int ecap_pwm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	pc->pinctrl = devm_pinctrl_get(&pdev->dev);
+	if (!IS_ERR(pc->pinctrl)) {
+		pc->pins_default = pinctrl_lookup_state(pc->pinctrl,
+							 PINCTRL_STATE_DEFAULT);
+		if (IS_ERR(pc->pins_default))
+			dev_dbg(&pdev->dev, "could not get default pinstate\n");
+		else
+			if (pinctrl_select_state(pc->pinctrl, pc->pins_default))
+				dev_err(&pdev->dev,
+					"could not set default pinstate\n");
+
+		pc->pins_sleep = pinctrl_lookup_state(pc->pinctrl,
+						       PINCTRL_STATE_SLEEP);
+		if (IS_ERR(pc->pins_sleep))
+			dev_dbg(&pdev->dev, "could not get sleep pinstate\n");
+	} else {
+		/*
+		* Since we continue even when pinctrl node is not found,
+		* Invalidate pins as not available. This is to make sure that
+		* IS_ERR(pins_xxx) results in failure when used.
+		*/
+		pc->pins_default = ERR_PTR(-ENODATA);
+		pc->pins_sleep = ERR_PTR(-ENODATA);
+
+		dev_dbg(&pdev->dev, "did not get pins for i2c error: %li\n",
+			PTR_ERR(pc->pinctrl));
+	}
+
 	clk = devm_clk_get(&pdev->dev, "fck");
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
@@ -318,6 +346,11 @@ static int ecap_pwm_suspend(struct device *dev)
 	if (test_bit(PWMF_ENABLED, &pwm->flags))
 		pm_runtime_put_sync(dev);
 
+	/* Optionally let pins go into sleep states */
+	if (!IS_ERR(pc->pins_sleep))
+		if (pinctrl_select_state(pc->pinctrl, pc->pins_sleep))
+			dev_err(dev, "could not set pins to sleep state\n");
+
 	return 0;
 }
 
@@ -326,6 +359,11 @@ static int ecap_pwm_resume(struct device *dev)
 	struct ecap_pwm_chip *pc = dev_get_drvdata(dev);
 	struct pwm_device *pwm = pc->chip.pwms;
 
+	/* Optionaly enable pins to be muxed in and configured */
+	if (!IS_ERR(pc->pins_default))
+		if (pinctrl_select_state(pc->pinctrl, pc->pins_default))
+			dev_err(dev, "could not set default pins\n");
+
 	/* Enable explicitly if PWM was running */
 	if (test_bit(PWMF_ENABLED, &pwm->flags))
 		pm_runtime_get_sync(dev);
-- 
1.7.9.5

