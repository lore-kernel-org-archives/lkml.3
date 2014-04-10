Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965652AbaDJJgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:36:10 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:45996 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934852AbaDJJgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:36:07 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Apr 2014 05:36:06 EDT
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat4jNPvwo0=
X-RZG-CLASS-ID: mo00
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] gpio_keys, twl4030-pwrbutton: stay awake for 1sec on resume
Date: Thu, 10 Apr 2014 11:29:55 +0200
Message-Id: <D594AE85-E3C0-42A3-831D-1A7CD212207B@goldelico.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, Sebastian Reichel <sre@debian.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Kumar Gala <galak@codeaurora.org>, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>,
        Lukas Maerdian <lukas@goldelico.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gives the userspace (e.g. Replicant) a chance to fully handle the
pm_wakeup_event, before autosleep suspends the system alltogether
again.

This fixes suspend/resume on the OpenPhoenux GTA04, in combination with
the Replicant 4.2.2 userspace, which needs to execute this to stay
awake: 'echo on > /sys/power/state'

Signed-off-by: Lukas M√§rdian <lukas@goldelico.com>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/input/keyboard/gpio_keys.c     | 7 ++-----
 drivers/input/misc/twl4030-pwrbutton.c | 2 +-
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 2db1324..be8c62e 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -345,9 +345,6 @@ static void gpio_keys_gpio_work_func(struct work_struct *work)
 		container_of(work, struct gpio_button_data, work);
 
 	gpio_keys_gpio_report_event(bdata);
-
-	if (bdata->button->wakeup)
-		pm_relax(bdata->input->dev.parent);
 }
 
 static void gpio_keys_gpio_timer(unsigned long _data)
@@ -364,7 +361,7 @@ static irqreturn_t gpio_keys_gpio_isr(int irq, void *dev_id)
 	BUG_ON(irq != bdata->irq);
 
 	if (bdata->button->wakeup)
-		pm_stay_awake(bdata->input->dev.parent);
+		pm_wakeup_event(bdata->input->dev.parent, 1000);
 	if (bdata->timer_debounce)
 		mod_timer(&bdata->timer,
 			jiffies + msecs_to_jiffies(bdata->timer_debounce));
@@ -402,7 +399,7 @@ static irqreturn_t gpio_keys_irq_isr(int irq, void *dev_id)
 
 	if (!bdata->key_pressed) {
 		if (bdata->button->wakeup)
-			pm_wakeup_event(bdata->input->dev.parent, 0);
+			pm_wakeup_event(bdata->input->dev.parent, 1000);
 
 		input_event(input, EV_KEY, button->code, 1);
 		input_sync(input);
diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
index fb3b63b..8622e43 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -41,7 +41,7 @@ static irqreturn_t powerbutton_irq(int irq, void *_pwr)
 
 	err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &value, STS_HW_CONDITIONS);
 	if (!err)  {
-		pm_wakeup_event(pwr->dev.parent, 0);
+		pm_wakeup_event(pwr->dev.parent, 1000);
 		input_report_key(pwr, KEY_POWER, value & PWR_PWRON_IRQ);
 		input_sync(pwr);
 	} else {
-- 
1.9.1


