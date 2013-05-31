Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab3EaKMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:12:02 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33836 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab3EaKLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:11:48 -0400
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <khilman@linaro.org>, <grant.likely@linaro.org>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <vaibhav.bedia@ti.com>,
        <sudhakar.raj@ti.com>, <gururaja.hebbar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-input@vger.kernel.org>
Subject: [PATCH 03/11] Input: gpio_keys: Adopt pinctrl support
Date: Fri, 31 May 2013 15:43:03 +0530
Message-ID: <1369995191-20855-4-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amend gpio-keys driver to optionally take a pin control handle and set
the state of the pins to:

- "default" on boot, resume
- "sleep" on suspend()

By Optionally putting the pins into sleep state in the suspend callback
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
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
---
:100644 100644 b29ca65... ca615a4... M	drivers/input/keyboard/gpio_keys.c
 drivers/input/keyboard/gpio_keys.c |   47 ++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index b29ca65..ca615a4 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -28,6 +28,7 @@
 #include <linux/gpio.h>
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/spinlock.h>
 
 struct gpio_button_data {
@@ -47,6 +48,10 @@ struct gpio_keys_drvdata {
 	struct input_dev *input;
 	struct mutex disable_lock;
 	struct gpio_button_data data[0];
+	/* Two optional pin states - default & sleep */
+	struct pinctrl		*pinctrl;
+	struct pinctrl_state	*pins_default;
+	struct pinctrl_state	*pins_sleep;
 };
 
 /*
@@ -709,6 +714,35 @@ static int gpio_keys_probe(struct platform_device *pdev)
 		goto fail1;
 	}
 
+	ddata->pinctrl = devm_pinctrl_get(dev);
+	if (!IS_ERR(ddata->pinctrl)) {
+		ddata->pins_default = pinctrl_lookup_state(ddata->pinctrl,
+						PINCTRL_STATE_DEFAULT);
+		/* enable pins to be muxed in and configured */
+		if (IS_ERR(ddata->pins_default))
+			dev_dbg(dev, "could not get default pinstate\n");
+		else
+			if (pinctrl_select_state(ddata->pinctrl,
+						 ddata->pins_default))
+				dev_err(dev,
+					"could not set default pinstate\n");
+
+		ddata->pins_sleep = pinctrl_lookup_state(ddata->pinctrl,
+						PINCTRL_STATE_SLEEP);
+		if (IS_ERR(ddata->pins_sleep))
+			dev_dbg(dev, "could not get sleep pinstate\n");
+	} else {
+		/*
+		* Since we continue even when pinctrl node is not found,
+		* Invalidate pins as not available. This is to make sure that
+		* IS_ERR(pins_xxx) results in failure when used.
+		*/
+		ddata->pins_default = ERR_PTR(-ENODATA);
+		ddata->pins_sleep = ERR_PTR(-ENODATA);
+
+		dev_dbg(dev, "pins are not configured from the driver\n");
+	}
+
 	ddata->pdata = pdata;
 	ddata->input = input;
 	mutex_init(&ddata->disable_lock);
@@ -816,6 +850,13 @@ static int gpio_keys_suspend(struct device *dev)
 				enable_irq_wake(bdata->irq);
 		}
 	} else {
+		/* Optionally let pins go into sleep states */
+		if (!IS_ERR(ddata->pins_sleep))
+			if (pinctrl_select_state(ddata->pinctrl,
+						 ddata->pins_sleep))
+				dev_err(dev,
+					"could not set pins to sleep state\n");
+
 		mutex_lock(&input->mutex);
 		if (input->users)
 			gpio_keys_close(input);
@@ -839,6 +880,12 @@ static int gpio_keys_resume(struct device *dev)
 				disable_irq_wake(bdata->irq);
 		}
 	} else {
+		/* Optionaly enable pins to be muxed in and configured */
+		if (!IS_ERR(ddata->pins_default))
+			if (pinctrl_select_state(ddata->pinctrl,
+						 ddata->pins_default))
+				dev_err(dev, "could not set default pins\n");
+
 		mutex_lock(&input->mutex);
 		if (input->users)
 			error = gpio_keys_open(input);
-- 
1.7.9.5

