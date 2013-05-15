Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab3EOMEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:04:24 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:33837 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758926Ab3EOMEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:04:22 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 03/10] usb: phy: ab8500-usb: add transceiver clock control
Date: Wed, 15 May 2013 14:03:26 +0200
Message-Id: <1368619413-24647-4-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
References: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>

Add common clock support code for the ab8500-usb phy driver.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index b043faa..cc0d7e5 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -29,6 +29,8 @@
 #include <linux/notifier.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/clk.h>
+#include <linux/err.h>
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/usb/musb-ux500.h>
@@ -126,6 +128,7 @@ struct ab8500_usb {
 	unsigned vbus_draw;
 	struct work_struct phy_dis_work;
 	enum ab8500_usb_mode mode;
+	struct clk *sysclk;
 	struct regulator *v_ape;
 	struct regulator *v_musb;
 	struct regulator *v_ulpi;
@@ -252,6 +255,9 @@ static void ab8500_usb_phy_enable(struct ab8500_usb *ab, bool sel_host)
 	if (IS_ERR(ab->pinctrl))
 		dev_err(ab->dev, "could not get/set default pinstate\n");
 
+	if (clk_prepare_enable(ab->sysclk))
+		dev_err(ab->dev, "can't prepare/enable clock\n");
+
 	ab8500_usb_regulator_enable(ab);
 
 	abx500_mask_and_set_register_interruptible(ab->dev,
@@ -274,6 +280,8 @@ static void ab8500_usb_phy_disable(struct ab8500_usb *ab, bool sel_host)
 	/* Needed to disable the phy.*/
 	ab8500_usb_wd_workaround(ab);
 
+	clk_disable_unprepare(ab->sysclk);
+
 	ab8500_usb_regulator_disable(ab);
 
 	if (!IS_ERR(ab->pinctrl)) {
@@ -784,6 +792,12 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	ab->sysclk = devm_clk_get(ab->dev, "sysclk");
+	if (IS_ERR(ab->sysclk)) {
+		dev_err(ab->dev, "Could not get sysclk.\n");
+		return PTR_ERR(ab->sysclk);
+	}
+
 	err = ab8500_usb_irq_setup(pdev, ab);
 	if (err < 0)
 		return err;
-- 
1.8.2

