Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab3EaKMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:12:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57251 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab3EaKMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:12:02 -0400
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <khilman@linaro.org>, <grant.likely@linaro.org>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <vaibhav.bedia@ti.com>,
        <sudhakar.raj@ti.com>, <gururaja.hebbar@ti.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH 06/11] usb: musb: dsps: Adopt pinctrl support
Date: Fri, 31 May 2013 15:43:06 +0530
Message-ID: <1369995191-20855-7-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amend the musb controller to optionally take a pin control handle and
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
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
:100644 100644 e1b661d... a9580fe... M	drivers/usb/musb/musb_dsps.c
 drivers/usb/musb/musb_dsps.c |   46 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index e1b661d..a9580fe 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -39,6 +39,7 @@
 #include <linux/usb/nop-usb-xceiv.h>
 #include <linux/platform_data/usb-omap.h>
 #include <linux/sizes.h>
+#include <linux/pinctrl/consumer.h>
 
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -124,6 +125,11 @@ struct dsps_glue {
 	struct timer_list timer[2];	/* otg_workaround timer */
 	unsigned long last_timer[2];    /* last timer data for each instance */
 	u32 __iomem *usb_ctrl[2];
+
+	/* two pin states - default, sleep */
+	struct pinctrl			*pinctrl;
+	struct pinctrl_state		*pins_default;
+	struct pinctrl_state		*pins_sleep;
 };
 
 #define	DSPS_AM33XX_CONTROL_MODULE_PHYS_0	0x44e10620
@@ -636,6 +642,36 @@ static int dsps_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto err1;
 	}
+
+	glue->pinctrl = devm_pinctrl_get(&pdev->dev);
+	if (!IS_ERR(glue->pinctrl)) {
+		glue->pins_default = pinctrl_lookup_state(glue->pinctrl,
+							 PINCTRL_STATE_DEFAULT);
+		if (IS_ERR(glue->pins_default))
+			dev_dbg(&pdev->dev, "could not get default pinstate\n");
+		else
+			if (pinctrl_select_state(glue->pinctrl,
+						 glue->pins_default))
+				dev_err(&pdev->dev,
+					"could not set default pinstate\n");
+
+		glue->pins_sleep = pinctrl_lookup_state(glue->pinctrl,
+						       PINCTRL_STATE_SLEEP);
+		if (IS_ERR(glue->pins_sleep))
+			dev_dbg(&pdev->dev, "could not get sleep pinstate\n");
+	} else {
+		/*
+		* Since we continue even when pinctrl node is not found,
+		* Invalidate pins as not available. This is to make sure that
+		* IS_ERR(pins_xxx) results in failure when used.
+		*/
+		glue->pins_default = ERR_PTR(-ENODATA);
+		glue->pins_sleep = ERR_PTR(-ENODATA);
+
+		dev_dbg(&pdev->dev, "did not get pins for i2c error: %li\n",
+			PTR_ERR(glue->pinctrl));
+	}
+
 	platform_set_drvdata(pdev, glue);
 
 	/* enable the usbss clocks */
@@ -700,6 +736,11 @@ static int dsps_suspend(struct device *dev)
 	for (i = 0; i < wrp->instances; i++)
 		musb_dsps_phy_control(glue, i, 0);
 
+	/* Optionally let pins go into sleep states */
+	if (!IS_ERR(glue->pins_sleep))
+		if (pinctrl_select_state(glue->pinctrl, glue->pins_sleep))
+			dev_err(dev, "could not set pins to sleep state\n");
+
 	return 0;
 }
 
@@ -710,6 +751,11 @@ static int dsps_resume(struct device *dev)
 	const struct dsps_musb_wrapper *wrp = glue->wrp;
 	int i;
 
+	/* Optionaly enable pins to be muxed in and configured */
+	if (!IS_ERR(glue->pins_default))
+		if (pinctrl_select_state(glue->pinctrl, glue->pins_default))
+			dev_err(dev, "could not set default pins\n");
+
 	for (i = 0; i < wrp->instances; i++)
 		musb_dsps_phy_control(glue, i, 1);
 
-- 
1.7.9.5

