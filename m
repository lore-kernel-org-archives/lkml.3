Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3JWQrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:47:47 -0400
Received: from ring0.de ([91.143.88.219]:42469 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab3JWQr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 12:47:29 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sebastian Reichel <sre@debian.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCHv3 1/3] Input: twl4030-pwrbutton - add device tree support
Date: Wed, 23 Oct 2013 18:47:13 +0200
Message-Id: <1382546835-20212-2-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382546835-20212-1-git-send-email-sre@debian.org>
References: <1382546835-20212-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support for twl4030 power button driver.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 .../devicetree/bindings/input/twl4030-pwrbutton.txt      | 13 +++++++++++++
 drivers/input/misc/twl4030-pwrbutton.c                   | 16 ++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt

diff --git a/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt b/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
new file mode 100644
index 0000000..945ec74
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
@@ -0,0 +1,13 @@
+* TWL4030's pwrbutton device tree bindings
+
+Required SoC Specific Properties:
+- compatible: should be one of the following
+   - "ti,twl4030-pwrbutton": For controllers compatible with twl4030
+- interrupt: should be one of the following
+   - <8>: For controllers compatible with twl4030
+
+Example:
+	twl_pwrbutton: pwrbutton {
+		compatible = "ti,twl4030-pwrbutton";
+		interrupts = <8>;
+	};
diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
index b9a05fd..a3a0fe3 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -52,7 +52,7 @@ static irqreturn_t powerbutton_irq(int irq, void *_pwr)
 	return IRQ_HANDLED;
 }
 
-static int __init twl4030_pwrbutton_probe(struct platform_device *pdev)
+static int twl4030_pwrbutton_probe(struct platform_device *pdev)
 {
 	struct input_dev *pwr;
 	int irq = platform_get_irq(pdev, 0);
@@ -106,16 +106,24 @@ static int __exit twl4030_pwrbutton_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id twl4030_pwrbutton_dt_match_table[] = {
+       { .compatible = "ti,twl4030-pwrbutton" },
+       {},
+};
+MODULE_DEVICE_TABLE(of, twl4030_pwrbutton_dt_match_table);
+#endif
+
 static struct platform_driver twl4030_pwrbutton_driver = {
+	.probe		= twl4030_pwrbutton_probe,
 	.remove		= __exit_p(twl4030_pwrbutton_remove),
 	.driver		= {
 		.name	= "twl4030_pwrbutton",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(twl4030_pwrbutton_dt_match_table),
 	},
 };
-
-module_platform_driver_probe(twl4030_pwrbutton_driver,
-			twl4030_pwrbutton_probe);
+module_platform_driver(twl4030_pwrbutton_driver);
 
 MODULE_ALIAS("platform:twl4030_pwrbutton");
 MODULE_DESCRIPTION("Triton2 Power Button");
-- 
1.8.4.rc3

