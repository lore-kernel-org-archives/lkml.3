Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab3EaKO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:14:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57241 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab3EaKMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:12:00 -0400
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
Subject: [PATCH 07/11] pwm: pwm-tiehrpwm: enhance pinctrl support
Date: Fri, 31 May 2013 15:43:07 +0530
Message-ID: <1369995191-20855-8-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amend the ti ehrpwm controller to optionally take a pin control handle
and set the state of the pins to:

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
:100644 100644 48a485c... ed55460ae. M	drivers/pwm/pwm-tiehrpwm.c
 drivers/pwm/pwm-tiehrpwm.c |   49 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 48a485c..ed55460ae 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -132,6 +132,11 @@ struct ehrpwm_pwm_chip {
 	enum pwm_polarity polarity[NUM_PWM_CHANNEL];
 	struct	clk	*tbclk;
 	struct ehrpwm_context ctx;
+
+	/* two pin states - default, sleep */
+	struct pinctrl			*pinctrl;
+	struct pinctrl_state		*pins_default;
+	struct pinctrl_state		*pins_sleep;
 };
 
 static inline struct ehrpwm_pwm_chip *to_ehrpwm_pwm_chip(struct pwm_chip *chip)
@@ -439,11 +444,6 @@ static int ehrpwm_pwm_probe(struct platform_device *pdev)
 	struct clk *clk;
 	struct ehrpwm_pwm_chip *pc;
 	u16 status;
-	struct pinctrl *pinctrl;
-
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "unable to select pin group\n");
 
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc) {
@@ -451,6 +451,34 @@ static int ehrpwm_pwm_probe(struct platform_device *pdev)
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
@@ -570,6 +598,12 @@ static int ehrpwm_pwm_suspend(struct device *dev)
 		/* Disable explicitly if PWM is running */
 		pm_runtime_put_sync(dev);
 	}
+
+	/* Optionally let pins go into sleep states */
+	if (!IS_ERR(pc->pins_sleep))
+		if (pinctrl_select_state(pc->pinctrl, pc->pins_sleep))
+			dev_err(dev, "could not set pins to sleep state\n");
+
 	return 0;
 }
 
@@ -578,6 +612,11 @@ static int ehrpwm_pwm_resume(struct device *dev)
 	struct ehrpwm_pwm_chip *pc = dev_get_drvdata(dev);
 	int i;
 
+	/* Optionaly enable pins to be muxed in and configured */
+	if (!IS_ERR(pc->pins_default))
+		if (pinctrl_select_state(pc->pinctrl, pc->pins_default))
+			dev_err(dev, "could not set default pins\n");
+
 	for (i = 0; i < pc->chip.npwm; i++) {
 		struct pwm_device *pwm = &pc->chip.pwms[i];
 
-- 
1.7.9.5

