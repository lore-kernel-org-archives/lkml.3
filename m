Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3LOMHd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 07:07:33 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54499 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab3LOMHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 07:07:31 -0500
Date: Sun, 15 Dec 2013 04:07:25 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Stephen Boyd <sboyd@codeaurora.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: pmic8xxx-pwrkey - switch to using managed resources
Message-ID: <20131215120723.GA375@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies error handling and device removal paths.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/pmic8xxx-pwrkey.c | 74 ++++++++++++------------------------
 1 file changed, 25 insertions(+), 49 deletions(-)

diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
index ef93840..aaf3325 100644
--- a/drivers/input/misc/pmic8xxx-pwrkey.c
+++ b/drivers/input/misc/pmic8xxx-pwrkey.c
@@ -32,7 +32,6 @@
  * @key_press_irq: key press irq number
  */
 struct pmic8xxx_pwrkey {
-	struct input_dev *pwr;
 	int key_press_irq;
 };
 
@@ -110,22 +109,22 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	pwrkey = kzalloc(sizeof(*pwrkey), GFP_KERNEL);
+	pwrkey = devm_kzalloc(&pdev->dev, sizeof(*pwrkey), GFP_KERNEL);
 	if (!pwrkey)
 		return -ENOMEM;
 
-	pwr = input_allocate_device();
+	pwrkey->key_press_irq = key_press_irq;
+
+	pwr = devm_input_allocate_device(&pdev->dev);
 	if (!pwr) {
 		dev_dbg(&pdev->dev, "Can't allocate power button\n");
-		err = -ENOMEM;
-		goto free_pwrkey;
+		return -ENOMEM;
 	}
 
 	input_set_capability(pwr, EV_KEY, KEY_POWER);
 
 	pwr->name = "pmic8xxx_pwrkey";
 	pwr->phys = "pmic8xxx_pwrkey/input0";
-	pwr->dev.parent = &pdev->dev;
 
 	delay = (pdata->kpd_trigger_delay_us << 10) / USEC_PER_SEC;
 	delay = 1 + ilog2(delay);
@@ -133,7 +132,7 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 	err = regmap_read(regmap, PON_CNTL_1, &pon_cntl);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed reading PON_CNTL_1 err=%d\n", err);
-		goto free_input_dev;
+		return err;
 	}
 
 	pon_cntl &= ~PON_CNTL_TRIG_DELAY_MASK;
@@ -146,66 +145,43 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 	err = regmap_write(regmap, PON_CNTL_1, pon_cntl);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed writing PON_CNTL_1 err=%d\n", err);
-		goto free_input_dev;
+		return err;
 	}
 
-	err = input_register_device(pwr);
+	err = devm_request_irq(&pdev->dev, key_press_irq, pwrkey_press_irq,
+			       IRQF_TRIGGER_RISING,
+			       "pmic8xxx_pwrkey_press", pwr);
 	if (err) {
-		dev_dbg(&pdev->dev, "Can't register power key: %d\n", err);
-		goto free_input_dev;
+		dev_err(&pdev->dev, "Can't get %d IRQ for pwrkey: %d\n",
+			key_press_irq, err);
+		return err;
 	}
 
-	pwrkey->key_press_irq = key_press_irq;
-	pwrkey->pwr = pwr;
-
-	platform_set_drvdata(pdev, pwrkey);
-
-	err = request_irq(key_press_irq, pwrkey_press_irq,
-		IRQF_TRIGGER_RISING, "pmic8xxx_pwrkey_press", pwr);
-	if (err < 0) {
-		dev_dbg(&pdev->dev, "Can't get %d IRQ for pwrkey: %d\n",
-				 key_press_irq, err);
-		goto unreg_input_dev;
+	err = devm_request_irq(&pdev->dev, key_release_irq, pwrkey_release_irq,
+			       IRQF_TRIGGER_RISING,
+			       "pmic8xxx_pwrkey_release", pwr);
+	if (err) {
+		dev_err(&pdev->dev, "Can't get %d IRQ for pwrkey: %d\n",
+			key_release_irq, err);
+		return err;
 	}
 
-	err = request_irq(key_release_irq, pwrkey_release_irq,
-		 IRQF_TRIGGER_RISING, "pmic8xxx_pwrkey_release", pwr);
-	if (err < 0) {
-		dev_dbg(&pdev->dev, "Can't get %d IRQ for pwrkey: %d\n",
-				 key_release_irq, err);
-
-		goto free_press_irq;
+	err = input_register_device(pwr);
+	if (err) {
+		dev_err(&pdev->dev, "Can't register power key: %d\n", err);
+		return err;
 	}
 
+	platform_set_drvdata(pdev, pwrkey);
 	device_init_wakeup(&pdev->dev, pdata->wakeup);
 
 	return 0;
-
-free_press_irq:
-	free_irq(key_press_irq, pwrkey);
-unreg_input_dev:
-	input_unregister_device(pwr);
-	pwr = NULL;
-free_input_dev:
-	input_free_device(pwr);
-free_pwrkey:
-	kfree(pwrkey);
-	return err;
 }
 
 static int pmic8xxx_pwrkey_remove(struct platform_device *pdev)
 {
-	struct pmic8xxx_pwrkey *pwrkey = platform_get_drvdata(pdev);
-	int key_release_irq = platform_get_irq(pdev, 0);
-	int key_press_irq = platform_get_irq(pdev, 1);
-
 	device_init_wakeup(&pdev->dev, 0);
 
-	free_irq(key_press_irq, pwrkey->pwr);
-	free_irq(key_release_irq, pwrkey->pwr);
-	input_unregister_device(pwrkey->pwr);
-	kfree(pwrkey);
-
 	return 0;
 }
 
-- 
1.8.3.1


-- 
Dmitry
