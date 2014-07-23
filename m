Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbaGWRgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:36:33 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56353 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaGWRgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:36:31 -0400
Date: Wed, 23 Jul 2014 10:36:27 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Alessandro GARDICH <gremlin@gremlin.it>,
        Dmitry Artamonow <mad_soft@inbox.ru>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: ipaq-micro-ts - introduce open/close
Message-ID: <20140723173625.GA38489@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wire up open/close so we do not try to send events until someone uses them;
this also allows us to remove micro_ts_remove() and rely fully on managed
resources.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/ipaq-micro-ts.c | 88 ++++++++++++++++++++-----------
 1 file changed, 56 insertions(+), 32 deletions(-)

diff --git a/drivers/input/touchscreen/ipaq-micro-ts.c b/drivers/input/touchscreen/ipaq-micro-ts.c
index 53fa5c3..62c8976 100644
--- a/drivers/input/touchscreen/ipaq-micro-ts.c
+++ b/drivers/input/touchscreen/ipaq-micro-ts.c
@@ -46,17 +46,50 @@ static void micro_ts_receive(void *data, int len, unsigned char *msg)
 	}
 }
 
+static void micro_ts_toggle_receive(struct touchscreen_data *ts, bool enable)
+{
+	struct ipaq_micro *micro = ts->micro;
+
+	spin_lock_irq(&micro->lock);
+
+	if (enable) {
+		micro->ts = micro_ts_receive;
+		micro->ts_data = ts;
+	} else {
+		micro->ts = NULL;
+		micro->ts_data = NULL;
+	}
+
+	spin_unlock_irq(&ts->micro->lock);
+}
+
+static int micro_ts_open(struct input_dev *input)
+{
+	struct touchscreen_data *ts = input_get_drvdata(input);
+
+	micro_ts_toggle_receive(ts, true);
+
+	return 0;
+}
+
+static void micro_ts_close(struct input_dev *input)
+{
+	struct touchscreen_data *ts = input_get_drvdata(input);
+
+	micro_ts_toggle_receive(ts, false);
+}
+
 static int micro_ts_probe(struct platform_device *pdev)
 {
+	struct ipaq_micro *micro = dev_get_drvdata(pdev->dev.parent);
 	struct touchscreen_data *ts;
-	int ret;
+	int error;
 
 	ts = devm_kzalloc(&pdev->dev, sizeof(*ts), GFP_KERNEL);
 	if (!ts)
 		return -ENOMEM;
-	ts->micro = dev_get_drvdata(pdev->dev.parent);
 
-	platform_set_drvdata(pdev, ts);
+	ts->micro = micro;
 
 	ts->input = devm_input_allocate_device(&pdev->dev);
 	if (!ts->input) {
@@ -64,37 +97,27 @@ static int micro_ts_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	ts->input->name = "ipaq micro ts";
+	ts->input->open = micro_ts_open;
+	ts->input->close = micro_ts_close;
+
+	input_set_drvdata(ts->input, ts);
+
 	input_set_capability(ts->input, EV_KEY, BTN_TOUCH);
 	input_set_capability(ts->input, EV_ABS, ABS_X);
 	input_set_capability(ts->input, EV_ABS, ABS_Y);
 	input_set_abs_params(ts->input, ABS_X, 0, 1023, 0, 0);
 	input_set_abs_params(ts->input, ABS_Y, 0, 1023, 0, 0);
 
-	ts->input->name = "ipaq micro ts";
-
-	ret = input_register_device(ts->input);
-	if (ret) {
+	error = input_register_device(ts->input);
+	if (error) {
 		dev_err(&pdev->dev, "error registering touch input\n");
-		return ret;
+		return error;
 	}
 
-	spin_lock_irq(&ts->micro->lock);
-	ts->micro->ts = micro_ts_receive;
-	ts->micro->ts_data = ts;
-	spin_unlock_irq(&ts->micro->lock);
+	platform_set_drvdata(pdev, ts);
 
 	dev_info(&pdev->dev, "iPAQ micro touchscreen\n");
-	return 0;
-}
-
-static int micro_ts_remove(struct platform_device *pdev)
-{
-	struct touchscreen_data *ts = platform_get_drvdata(pdev);
-
-	spin_lock_irq(&ts->micro->lock);
-	ts->micro->ts = NULL;
-	ts->micro->ts_data = NULL;
-	spin_unlock_irq(&ts->micro->lock);
 
 	return 0;
 }
@@ -104,21 +127,23 @@ static int micro_ts_suspend(struct device *dev)
 {
 	struct touchscreen_data *ts = dev_get_drvdata(dev);
 
-	spin_lock_irq(&ts->micro->lock);
-	ts->micro->ts = NULL;
-	ts->micro->ts_data = NULL;
-	spin_unlock_irq(&ts->micro->lock);
+	micro_ts_toggle_receive(ts, false);
+
 	return 0;
 }
 
 static int micro_ts_resume(struct device *dev)
 {
 	struct touchscreen_data *ts = dev_get_drvdata(dev);
+	struct input_dev *input = ts->input;
+
+	mutex_lock(&input->mutex);
+
+	if (input->users)
+		micro_ts_toggle_receive(ts, true);
+
+	mutex_unlock(&input->mutex);
 
-	spin_lock_irq(&ts->micro->lock);
-	ts->micro->ts = micro_ts_receive;
-	ts->micro->ts_data = ts;
-	spin_unlock_irq(&ts->micro->lock);
 	return 0;
 }
 #endif
@@ -133,7 +158,6 @@ static struct platform_driver micro_ts_device_driver = {
 		.pm	= &micro_ts_dev_pm_ops,
 	},
 	.probe	= micro_ts_probe,
-	.remove	= micro_ts_remove,
 };
 module_platform_driver(micro_ts_device_driver);
 
-- 
2.0.0.526.g5318336


-- 
Dmitry
