Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3AUNQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:16:33 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35137 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3AUNQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:16:31 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-input@vger.kernel.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        NeilBrown <neilb@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [RFC PATCH] Input: gpio_keys: Fix suspend/resume press event lost
Date: Mon, 21 Jan 2013 15:15:14 +0200
Message-ID: <1358774114-8281-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rebased on linux_omap/master.

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
index b29ca65..33ac8c5 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -45,6 +45,7 @@ struct gpio_button_data {
 struct gpio_keys_drvdata {
 	const struct gpio_keys_platform_data *pdata;
 	struct input_dev *input;
+	int suspended;
 	struct mutex disable_lock;
 	struct gpio_button_data data[0];
 };
@@ -326,14 +327,40 @@ static void gpio_keys_gpio_report_event(struct gpio_button_data *bdata)
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
@@ -822,6 +849,7 @@ static int gpio_keys_suspend(struct device *dev)
 		mutex_unlock(&input->mutex);
 	}
 
+	ddata->suspended = 1;
 	return 0;
 }
 
@@ -832,6 +860,7 @@ static int gpio_keys_resume(struct device *dev)
 	int error = 0;
 	int i;
 
+	ddata->suspended = 0;
 	if (device_may_wakeup(dev)) {
 		for (i = 0; i < ddata->pdata->nbuttons; i++) {
 			struct gpio_button_data *bdata = &ddata->data[i];
-- 
1.7.9.5

