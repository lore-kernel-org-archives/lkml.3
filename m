Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3EaKMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:12:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57215 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab3EaKL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:11:56 -0400
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
Subject: [PATCH 04/11] Input: matrix-keypad: Adopt pinctrl support
Date: Fri, 31 May 2013 15:43:04 +0530
Message-ID: <1369995191-20855-5-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amend matrix-keypad driver to optionally take a pin control handle and
set the state of the pins to:

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
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
---
:100644 100644 71d7719... aed43fb... M	drivers/input/keyboard/matrix_keypad.c
 drivers/input/keyboard/matrix_keypad.c |   48 ++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index 71d7719..aed43fb 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -26,6 +26,7 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/of_platform.h>
+#include <linux/pinctrl/consumer.h>
 
 struct matrix_keypad {
 	const struct matrix_keypad_platform_data *pdata;
@@ -40,6 +41,10 @@ struct matrix_keypad {
 	bool scan_pending;
 	bool stopped;
 	bool gpio_all_disabled;
+	/* Two optional pin states - default & sleep */
+	struct pinctrl		*pinctrl;
+	struct pinctrl_state	*pins_default;
+	struct pinctrl_state	*pins_sleep;
 };
 
 /*
@@ -280,6 +285,13 @@ static int matrix_keypad_suspend(struct device *dev)
 
 	if (device_may_wakeup(&pdev->dev))
 		matrix_keypad_enable_wakeup(keypad);
+	else
+		/* Optionally let pins go into sleep states */
+		if (!IS_ERR(keypad->pins_sleep))
+			if (pinctrl_select_state(keypad->pinctrl,
+						 keypad->pins_sleep))
+				dev_err(dev,
+					"could not set pins to sleep state\n");
 
 	return 0;
 }
@@ -291,6 +303,12 @@ static int matrix_keypad_resume(struct device *dev)
 
 	if (device_may_wakeup(&pdev->dev))
 		matrix_keypad_disable_wakeup(keypad);
+	else
+		/* Optionaly enable pins to be muxed in and configured */
+		if (!IS_ERR(keypad->pins_default))
+			if (pinctrl_select_state(keypad->pinctrl,
+						 keypad->pins_default))
+				dev_err(dev, "could not set default pins\n");
 
 	matrix_keypad_start(keypad->input_dev);
 
@@ -491,6 +509,36 @@ static int matrix_keypad_probe(struct platform_device *pdev)
 		goto err_free_mem;
 	}
 
+	keypad->pinctrl = devm_pinctrl_get(&pdev->dev);
+	if (!IS_ERR(keypad->pinctrl)) {
+		keypad->pins_default = pinctrl_lookup_state(keypad->pinctrl,
+						PINCTRL_STATE_DEFAULT);
+		/* enable pins to be muxed in and configured */
+		if (IS_ERR(keypad->pins_default))
+			dev_dbg(&pdev->dev, "could not get default pinstate\n");
+		else
+			if (pinctrl_select_state(keypad->pinctrl,
+						 keypad->pins_default))
+				dev_err(&pdev->dev,
+					"could not set default pins\n");
+
+		keypad->pins_sleep = pinctrl_lookup_state(keypad->pinctrl,
+						PINCTRL_STATE_SLEEP);
+		if (IS_ERR(keypad->pins_sleep))
+			dev_dbg(&pdev->dev, "could not get sleep pinstate\n");
+	} else {
+		/*
+		* Since we continue even when pinctrl node is not found,
+		* Invalidate pins as not available. This is to make sure that
+		* IS_ERR(pins_xxx) results in failure when used.
+		*/
+		keypad->pins_default = ERR_PTR(-ENODATA);
+		keypad->pins_sleep = ERR_PTR(-ENODATA);
+
+		dev_dbg(&pdev->dev,
+			"pins are not configured from the driver\n");
+	}
+
 	keypad->input_dev = input_dev;
 	keypad->pdata = pdata;
 	keypad->row_shift = get_count_order(pdata->num_col_gpios);
-- 
1.7.9.5

