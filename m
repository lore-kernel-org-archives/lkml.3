Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab3LJXnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:43:24 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38959 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3LJXnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:43:18 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: [PATCH 1/7] Input: pmic8xxx-pwrkey - Pass input device directly to interrupt
Date: Tue, 10 Dec 2013 15:43:10 -0800
Message-Id: <1386718996-3733-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
In-Reply-To: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
References: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of passing the pointer to the container structure just
pass the input device here. This saves a dereference in the fast
path.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/input/misc/pmic8xxx-pwrkey.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
index ce3c426..233b216 100644
--- a/drivers/input/misc/pmic8xxx-pwrkey.c
+++ b/drivers/input/misc/pmic8xxx-pwrkey.c
@@ -32,26 +32,21 @@
  * @key_press_irq: key press irq number
  */
 struct pmic8xxx_pwrkey {
-	struct input_dev *pwr;
 	int key_press_irq;
 };
 
-static irqreturn_t pwrkey_press_irq(int irq, void *_pwrkey)
+static irqreturn_t pwrkey_press_irq(int irq, void *pwr)
 {
-	struct pmic8xxx_pwrkey *pwrkey = _pwrkey;
-
-	input_report_key(pwrkey->pwr, KEY_POWER, 1);
-	input_sync(pwrkey->pwr);
+	input_report_key(pwr, KEY_POWER, 1);
+	input_sync(pwr);
 
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t pwrkey_release_irq(int irq, void *_pwrkey)
+static irqreturn_t pwrkey_release_irq(int irq, void *pwr)
 {
-	struct pmic8xxx_pwrkey *pwrkey = _pwrkey;
-
-	input_report_key(pwrkey->pwr, KEY_POWER, 0);
-	input_sync(pwrkey->pwr);
+	input_report_key(pwr, KEY_POWER, 0);
+	input_sync(pwr);
 
 	return IRQ_HANDLED;
 }
@@ -147,12 +142,11 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 	}
 
 	pwrkey->key_press_irq = key_press_irq;
-	pwrkey->pwr = pwr;
 
 	platform_set_drvdata(pdev, pwrkey);
 
 	err = devm_request_irq(&pdev->dev, key_press_irq, pwrkey_press_irq,
-		IRQF_TRIGGER_RISING, "pmic8xxx_pwrkey_press", pwrkey);
+		IRQF_TRIGGER_RISING, "pmic8xxx_pwrkey_press", pwr);
 	if (err < 0) {
 		dev_dbg(&pdev->dev, "Can't get %d IRQ for pwrkey: %d\n",
 				 key_press_irq, err);
@@ -160,7 +154,7 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 	}
 
 	err = devm_request_irq(&pdev->dev, key_release_irq, pwrkey_release_irq,
-		 IRQF_TRIGGER_RISING, "pmic8xxx_pwrkey_release", pwrkey);
+		 IRQF_TRIGGER_RISING, "pmic8xxx_pwrkey_release", pwr);
 	if (err < 0) {
 		dev_dbg(&pdev->dev, "Can't get %d IRQ for pwrkey: %d\n",
 				 key_release_irq, err);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

