Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762509Ab3DCIsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:48:25 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:48774 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762461Ab3DCIsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:48:19 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Patrice Chotard <patrice.chotard@st.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 10/12] usb: phy: ab8500-usb: adopt pinctrl support
Date: Wed,  3 Apr 2013 10:45:11 +0200
Message-Id: <1364978713-19612-11-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

Amend the ab8500-usb driver to optionally take a pin control handle and
set the state of the pins to "default" on ab8500_usb_phy_enable and to
"sleep" on ab8500_usb_phy_disable.

The pinctrl handle is released on ab8500_usb_phy_disable because USB
pins are shared with ab8505_micro_usb_iddet driver.

Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index ff27058..0875e2b 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -33,6 +33,7 @@
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/usb/musb-ux500.h>
 #include <linux/regulator/consumer.h>
+#include <linux/pinctrl/consumer.h>
 
 /* Bank AB8500_SYS_CTRL2_BLOCK */
 #define AB8500_MAIN_WD_CTRL_REG 0x01
@@ -132,6 +133,8 @@ struct ab8500_usb {
 	struct regulator *v_ulpi;
 	int saved_v_ulpi;
 	int previous_link_status_state;
+	struct pinctrl *pinctrl;
+	struct pinctrl_state *pins_sleep;
 };
 
 static inline struct ab8500_usb *phy_to_ab(struct usb_phy *x)
@@ -240,6 +243,11 @@ static void ab8500_usb_phy_enable(struct ab8500_usb *ab, bool sel_host)
 	bit = sel_host ? AB8500_BIT_PHY_CTRL_HOST_EN :
 		AB8500_BIT_PHY_CTRL_DEVICE_EN;
 
+	/* mux and configure USB pins to DEFAULT state */
+	ab->pinctrl = pinctrl_get_select(ab->dev, PINCTRL_STATE_DEFAULT);
+	if (IS_ERR(ab->pinctrl))
+		dev_err(ab->dev, "could not get/set default pinstate\n");
+
 	ab8500_usb_regulator_enable(ab);
 
 	abx500_mask_and_set_register_interruptible(ab->dev,
@@ -263,6 +271,22 @@ static void ab8500_usb_phy_disable(struct ab8500_usb *ab, bool sel_host)
 	ab8500_usb_wd_workaround(ab);
 
 	ab8500_usb_regulator_disable(ab);
+
+	if (!IS_ERR(ab->pinctrl)) {
+		/* configure USB pins to SLEEP state */
+		ab->pins_sleep = pinctrl_lookup_state(ab->pinctrl,
+				PINCTRL_STATE_SLEEP);
+
+		if (IS_ERR(ab->pins_sleep))
+			dev_dbg(ab->dev, "could not get sleep pinstate\n");
+		else if (pinctrl_select_state(ab->pinctrl, ab->pins_sleep))
+			dev_err(ab->dev, "could not set pins to sleep state\n");
+
+		/* as USB pins are shared with idddet, release them to allow
+		 * iddet to request them
+		 */
+		pinctrl_put(ab->pinctrl);
+	}
 }
 
 #define ab8500_usb_host_phy_en(ab)	ab8500_usb_phy_enable(ab, true)
-- 
1.8.1.3

