Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab3ARMxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:53:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33717 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab3ARMxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:53:01 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <linux-input@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        NeilBrown <neilb@suse.de>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [RFC PATCH] Input: gpio_keys: Fix suspend/resume press event lost
Date: Fri, 18 Jan 2013 14:51:59 +0200
Message-ID: <1358513519-8258-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During suspend/resume the key press can be lost if time of resume
sequence is significant.

If press event cannot be remembered then the driver can read the
current button state only in time of interrupt handling. But in some
cases when time between IRQ and IRQ handler is significant we can
read incorrect state. As a particular case, when device is in suspend
we press wakupable key and up it back in a jiffy, the interrupt
handler read the state of up but the interrupt source is press indeed.
As a result, in a OS like android, we resume then suspend right away
because the key state is not changed.

This patch add to gpio_keys framework opportunity to recover lost of
press key event at resuming. The variable "key_pressed" from
gpio_button_data structure is not used for gpio keys, it is only used
for gpio irq keys, so it is logically used to remember press lost
while resuming.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/input/keyboard/gpio_keys.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 62bfce4..aa49aef 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -46,6 +46,7 @@ struct gpio_keys_drvdata {
 	struct input_dev *input;
 	struct mutex disable_lock;
 	unsigned int n_buttons;
+	int suspended;
 	int (*enable)(struct device *dev);
 	void (*disable)(struct device *dev);
 	struct gpio_button_data data[0];
@@ -328,14 +329,40 @@ static void gpio_keys_gpio_report_event(struct gpio_button_data *bdata)
 {
 	const struct gpio_keys_button *button = bdata->button;
 	struct input_dev *input = bdata->input;
+	struct gpio_keys_drvdata *ddata = input_get_drvdata(input);
 	unsigned int type = button->type ?: EV_KEY;
 	int state = (gpio_get_value_cansleep(button->gpio) ? 1 : 0) ^ button->active_low;
 
+	/*
+	 * Don't generate input event while resuming,
+	 * it will be generated at gpio_keys_resume function
+	*/
+	if (ddata->suspended) {
+		/*
+		 * missed press event while resuming so set
+		 * key_pressed flag to generate press and up events
+		 * while gpio_keys_resume function.
+		 */
+		if (button->wakeup && state == 0)
+			bdata->key_pressed = 1;
+		return;
+	}
+
 	if (type == EV_ABS) {
 		if (state)
 			input_event(input, type, button->code, button->value);
 	} else {
-		input_event(input, type, button->code, !!state);
+		/*
+		 * missed press key, so generate press event then up event
+		 */
+		if (bdata->key_pressed) {
+			input_event(bdata->input, EV_KEY, button->code, 1);
+			input_sync(bdata->input);
+			input_event(bdata->input, EV_KEY, button->code, 0);
+			bdata->key_pressed = 0;
+		} else {
+			input_event(input, type, button->code, !!state);
+		}
 	}
 	input_sync(input);
 }
@@ -792,6 +819,7 @@ static int gpio_keys_suspend(struct device *dev)
 		}
 	}
 
+	ddata->suspended = 1;
 	return 0;
 }
 
@@ -800,6 +828,7 @@ static int gpio_keys_resume(struct device *dev)
 	struct gpio_keys_drvdata *ddata = dev_get_drvdata(dev);
 	int i;
 
+	ddata->suspended = 0;
 	for (i = 0; i < ddata->n_buttons; i++) {
 		struct gpio_button_data *bdata = &ddata->data[i];
 		if (bdata->button->wakeup && device_may_wakeup(dev))
-- 
1.7.9.5

