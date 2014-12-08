Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaLHHVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:21:32 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:61206 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaLHHVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:21:30 -0500
Date: Sun, 7 Dec 2014 23:21:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Laxman Dewangan <ldewangan@nvidia.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Input: gpio_keys - replace timer and workqueue with
 delayed workqueue
Message-ID: <20141208072124.GA21031@dtor-ws>
References: <20141208071930.GA20802@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208071930.GA20802@dtor-ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not need to roll our own implementation of delayed work now that we
have proper implementation of mod_delayed_work.

For interrupt-only driven buttons we retain the timer, but we rename
it to release_timer to better reflect its purpose.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/keyboard/gpio_keys.c |   65 +++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 34 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index a5ece3f..eefd976 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -35,9 +35,13 @@
 struct gpio_button_data {
 	const struct gpio_keys_button *button;
 	struct input_dev *input;
-	struct timer_list timer;
-	struct work_struct work;
-	unsigned int timer_debounce;	/* in msecs */
+
+	struct timer_list release_timer;
+	unsigned int release_delay;	/* in msecs, for IRQ-only buttons */
+
+	struct delayed_work work;
+	unsigned int software_debounce;	/* in msecs, for GPIO-driven buttons */
+
 	unsigned int irq;
 	spinlock_t lock;
 	bool disabled;
@@ -116,11 +120,14 @@ static void gpio_keys_disable_button(struct gpio_button_data *bdata)
 {
 	if (!bdata->disabled) {
 		/*
-		 * Disable IRQ and possible debouncing timer.
+		 * Disable IRQ and associated timer/work structure.
 		 */
 		disable_irq(bdata->irq);
-		if (bdata->timer_debounce)
-			del_timer_sync(&bdata->timer);
+
+		if (gpio_is_valid(bdata->button->gpio))
+			cancel_delayed_work_sync(&bdata->work);
+		else
+			del_timer_sync(&bdata->release_timer);
 
 		bdata->disabled = true;
 	}
@@ -343,7 +350,7 @@ static void gpio_keys_gpio_report_event(struct gpio_button_data *bdata)
 static void gpio_keys_gpio_work_func(struct work_struct *work)
 {
 	struct gpio_button_data *bdata =
-		container_of(work, struct gpio_button_data, work);
+		container_of(work, struct gpio_button_data, work.work);
 
 	gpio_keys_gpio_report_event(bdata);
 
@@ -351,13 +358,6 @@ static void gpio_keys_gpio_work_func(struct work_struct *work)
 		pm_relax(bdata->input->dev.parent);
 }
 
-static void gpio_keys_gpio_timer(unsigned long _data)
-{
-	struct gpio_button_data *bdata = (struct gpio_button_data *)_data;
-
-	schedule_work(&bdata->work);
-}
-
 static irqreturn_t gpio_keys_gpio_isr(int irq, void *dev_id)
 {
 	struct gpio_button_data *bdata = dev_id;
@@ -366,11 +366,10 @@ static irqreturn_t gpio_keys_gpio_isr(int irq, void *dev_id)
 
 	if (bdata->button->wakeup)
 		pm_stay_awake(bdata->input->dev.parent);
-	if (bdata->timer_debounce)
-		mod_timer(&bdata->timer,
-			jiffies + msecs_to_jiffies(bdata->timer_debounce));
-	else
-		schedule_work(&bdata->work);
+
+	mod_delayed_work(system_wq,
+			 &bdata->work,
+			 msecs_to_jiffies(bdata->software_debounce));
 
 	return IRQ_HANDLED;
 }
@@ -408,7 +407,7 @@ static irqreturn_t gpio_keys_irq_isr(int irq, void *dev_id)
 		input_event(input, EV_KEY, button->code, 1);
 		input_sync(input);
 
-		if (!bdata->timer_debounce) {
+		if (!bdata->release_delay) {
 			input_event(input, EV_KEY, button->code, 0);
 			input_sync(input);
 			goto out;
@@ -417,9 +416,9 @@ static irqreturn_t gpio_keys_irq_isr(int irq, void *dev_id)
 		bdata->key_pressed = true;
 	}
 
-	if (bdata->timer_debounce)
-		mod_timer(&bdata->timer,
-			jiffies + msecs_to_jiffies(bdata->timer_debounce));
+	if (bdata->release_delay)
+		mod_timer(&bdata->release_timer,
+			jiffies + msecs_to_jiffies(bdata->release_delay));
 out:
 	spin_unlock_irqrestore(&bdata->lock, flags);
 	return IRQ_HANDLED;
@@ -429,10 +428,10 @@ static void gpio_keys_quiesce_key(void *data)
 {
 	struct gpio_button_data *bdata = data;
 
-	if (bdata->timer_debounce)
-		del_timer_sync(&bdata->timer);
-
-	cancel_work_sync(&bdata->work);
+	if (gpio_is_valid(bdata->button->gpio))
+		cancel_delayed_work_sync(&bdata->work);
+	else
+		del_timer_sync(&bdata->release_timer);
 }
 
 static int gpio_keys_setup_key(struct platform_device *pdev,
@@ -466,7 +465,7 @@ static int gpio_keys_setup_key(struct platform_device *pdev,
 					button->debounce_interval * 1000);
 			/* use timer if gpiolib doesn't provide debounce */
 			if (error < 0)
-				bdata->timer_debounce =
+				bdata->software_debounce =
 						button->debounce_interval;
 		}
 
@@ -484,9 +483,7 @@ static int gpio_keys_setup_key(struct platform_device *pdev,
 			bdata->irq = irq;
 		}
 
-		INIT_WORK(&bdata->work, gpio_keys_gpio_work_func);
-		setup_timer(&bdata->timer,
-			    gpio_keys_gpio_timer, (unsigned long)bdata);
+		INIT_DELAYED_WORK(&bdata->work, gpio_keys_gpio_work_func);
 
 		isr = gpio_keys_gpio_isr;
 		irqflags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING;
@@ -503,8 +500,8 @@ static int gpio_keys_setup_key(struct platform_device *pdev,
 			return -EINVAL;
 		}
 
-		bdata->timer_debounce = button->debounce_interval;
-		setup_timer(&bdata->timer,
+		bdata->release_delay = button->debounce_interval;
+		setup_timer(&bdata->release_timer,
 			    gpio_keys_irq_timer, (unsigned long)bdata);
 
 		isr = gpio_keys_irq_isr;
@@ -514,7 +511,7 @@ static int gpio_keys_setup_key(struct platform_device *pdev,
 	input_set_capability(input, button->type ?: EV_KEY, button->code);
 
 	/*
-	 * Install custom action to cancel debounce timer and
+	 * Install custom action to cancel release timer and
 	 * workqueue item.
 	 */
 	error = devm_add_action(&pdev->dev, gpio_keys_quiesce_key, bdata);

-- 
Dmitry
