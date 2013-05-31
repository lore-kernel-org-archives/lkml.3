Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3EaKOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:14:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57257 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab3EaKME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:12:04 -0400
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <khilman@linaro.org>, <grant.likely@linaro.org>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <vaibhav.bedia@ti.com>,
        <sudhakar.raj@ti.com>, <gururaja.hebbar@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>
Subject: [PATCH 10/11] video: da8xx-fb: adopt pinctrl support
Date: Fri, 31 May 2013 15:43:10 +0530
Message-ID: <1369995191-20855-11-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amend the da8xx-fb controller to optionally take a pin control handle
and set the state of the pins to:

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
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org
---
:100644 100644 0810939... 10c8036... M	drivers/video/da8xx-fb.c
 drivers/video/da8xx-fb.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 0810939..10c8036 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -36,6 +36,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/lcm.h>
+#include <linux/pinctrl/consumer.h>
 #include <video/da8xx-fb.h>
 #include <asm/div64.h>
 
@@ -182,6 +183,11 @@ struct da8xx_fb_par {
 #endif
 	void (*panel_power_ctrl)(int);
 	u32 pseudo_palette[16];
+
+	/* two pin states - default, sleep */
+	struct pinctrl			*pinctrl;
+	struct pinctrl_state		*pins_default;
+	struct pinctrl_state		*pins_sleep;
 };
 
 /* Variable Screen Information */
@@ -1306,6 +1312,36 @@ static int fb_probe(struct platform_device *device)
 	par->lcd_fck_rate = clk_get_rate(fb_clk);
 #endif
 	par->pxl_clk = lcdc_info->pixclock;
+
+	par->pinctrl = devm_pinctrl_get(&device->dev);
+	if (!IS_ERR(par->pinctrl)) {
+		par->pins_default = pinctrl_lookup_state(par->pinctrl,
+							 PINCTRL_STATE_DEFAULT);
+		if (IS_ERR(par->pins_default))
+			dev_dbg(&device->dev, "could not get default pinstate\n");
+		else
+			if (pinctrl_select_state(par->pinctrl,
+						 par->pins_default))
+				dev_err(&device->dev,
+					"could not set default pinstate\n");
+
+		par->pins_sleep = pinctrl_lookup_state(par->pinctrl,
+						       PINCTRL_STATE_SLEEP);
+		if (IS_ERR(par->pins_sleep))
+			dev_dbg(&device->dev, "could not get sleep pinstate\n");
+	} else {
+		/*
+		* Since we continue even when pinctrl node is not found,
+		* Invalidate pins as not available. This is to make sure that
+		* IS_ERR(pins_xxx) results in failure when used.
+		*/
+		par->pins_default = ERR_PTR(-ENODATA);
+		par->pins_sleep = ERR_PTR(-ENODATA);
+
+		dev_dbg(&device->dev, "did not get pins for lcd error: %li\n",
+			PTR_ERR(par->pinctrl));
+	}
+
 	if (fb_pdata->panel_power_ctrl) {
 		par->panel_power_ctrl = fb_pdata->panel_power_ctrl;
 		par->panel_power_ctrl(1);
@@ -1551,6 +1587,12 @@ static int fb_suspend(struct platform_device *dev, pm_message_t state)
 	pm_runtime_put_sync(&dev->dev);
 	console_unlock();
 
+	/* Optionally let pins go into sleep states */
+	if (!IS_ERR(par->pins_sleep))
+		if (pinctrl_select_state(par->pinctrl, par->pins_sleep))
+			dev_err(&dev->dev,
+				"could not set pins to sleep state\n");
+
 	return 0;
 }
 static int fb_resume(struct platform_device *dev)
@@ -1560,6 +1602,12 @@ static int fb_resume(struct platform_device *dev)
 
 	console_lock();
 	pm_runtime_get_sync(&dev->dev);
+
+	/* Optionaly enable pins to be muxed in and configured */
+	if (!IS_ERR(par->pins_default))
+		if (pinctrl_select_state(par->pinctrl, par->pins_default))
+			dev_err(&dev->dev, "could not set default pins\n");
+
 	lcd_context_restore();
 	if (par->blank == FB_BLANK_UNBLANK) {
 		lcd_enable_raster();
-- 
1.7.9.5

