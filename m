Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632Ab3CHC1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:27:42 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:57473 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933614Ab3CHC1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:27:38 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v2 4/5] usb: otg: ab8500-usb: drop support for ab8500 pre v2.0
Date: Fri,  8 Mar 2013 10:27:08 +0800
Message-Id: <1362709629-27238-5-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362709629-27238-1-git-send-email-fabio.baltieri@linaro.org>
References: <1362709629-27238-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AB8500 versions preceding 2.0 were only used internally by ST-Ericsson
and are not supported anymore.  This patch drops all v1.0 and v1.1
support code.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/otg/ab8500-usb.c | 139 ++++---------------------------------------
 1 file changed, 11 insertions(+), 128 deletions(-)

diff --git a/drivers/usb/otg/ab8500-usb.c b/drivers/usb/otg/ab8500-usb.c
index 2d86f26..9f5e0e4 100644
--- a/drivers/usb/otg/ab8500-usb.c
+++ b/drivers/usb/otg/ab8500-usb.c
@@ -42,10 +42,8 @@
 #define AB8500_BIT_WD_CTRL_ENABLE (1 << 0)
 #define AB8500_BIT_WD_CTRL_KICK (1 << 1)
 
-#define AB8500_V1x_LINK_STAT_WAIT (HZ/10)
 #define AB8500_WD_KICK_DELAY_US 100 /* usec */
 #define AB8500_WD_V11_DISABLE_DELAY_US 100 /* usec */
-#define AB8500_WD_V10_DISABLE_DELAY_MS 100 /* ms */
 
 /* Usb line status register */
 enum ab8500_usb_link_status {
@@ -70,16 +68,12 @@ enum ab8500_usb_link_status {
 struct ab8500_usb {
 	struct usb_phy phy;
 	struct device *dev;
-	int irq_num_id_rise;
-	int irq_num_id_fall;
-	int irq_num_vbus_rise;
-	int irq_num_vbus_fall;
+	struct ab8500 *ab8500;
 	int irq_num_link_status;
 	unsigned vbus_draw;
 	struct delayed_work dwork;
 	struct work_struct phy_dis_work;
 	unsigned long link_status_wait;
-	int rev;
 };
 
 static inline struct ab8500_usb *phy_to_ab(struct usb_phy *x)
@@ -102,10 +96,7 @@ static void ab8500_usb_wd_workaround(struct ab8500_usb *ab)
 		(AB8500_BIT_WD_CTRL_ENABLE
 		| AB8500_BIT_WD_CTRL_KICK));
 
-	if (ab->rev > 0x10) /* v1.1 v2.0 */
-		udelay(AB8500_WD_V11_DISABLE_DELAY_US);
-	else /* v1.0 */
-		msleep(AB8500_WD_V10_DISABLE_DELAY_MS);
+	udelay(AB8500_WD_V11_DISABLE_DELAY_US);
 
 	abx500_set_register_interruptible(ab->dev,
 		AB8500_SYS_CTRL2_BLOCK,
@@ -225,29 +216,6 @@ static void ab8500_usb_delayed_work(struct work_struct *work)
 	ab8500_usb_link_status_update(ab);
 }
 
-static irqreturn_t ab8500_usb_v1x_common_irq(int irq, void *data)
-{
-	struct ab8500_usb *ab = (struct ab8500_usb *) data;
-
-	/* Wait for link status to become stable. */
-	schedule_delayed_work(&ab->dwork, ab->link_status_wait);
-
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t ab8500_usb_v1x_vbus_fall_irq(int irq, void *data)
-{
-	struct ab8500_usb *ab = (struct ab8500_usb *) data;
-
-	/* Link status will not be updated till phy is disabled. */
-	ab8500_usb_peri_phy_dis(ab);
-
-	/* Wait for link status to become stable. */
-	schedule_delayed_work(&ab->dwork, ab->link_status_wait);
-
-	return IRQ_HANDLED;
-}
-
 static irqreturn_t ab8500_usb_v20_irq(int irq, void *data)
 {
 	struct ab8500_usb *ab = (struct ab8500_usb *) data;
@@ -361,86 +329,7 @@ static int ab8500_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
 
 static void ab8500_usb_irq_free(struct ab8500_usb *ab)
 {
-	if (ab->rev < 0x20) {
-		free_irq(ab->irq_num_id_rise, ab);
-		free_irq(ab->irq_num_id_fall, ab);
-		free_irq(ab->irq_num_vbus_rise, ab);
-		free_irq(ab->irq_num_vbus_fall, ab);
-	} else {
-		free_irq(ab->irq_num_link_status, ab);
-	}
-}
-
-static int ab8500_usb_v1x_res_setup(struct platform_device *pdev,
-				struct ab8500_usb *ab)
-{
-	int err;
-
-	ab->irq_num_id_rise = platform_get_irq_byname(pdev, "ID_WAKEUP_R");
-	if (ab->irq_num_id_rise < 0) {
-		dev_err(&pdev->dev, "ID rise irq not found\n");
-		return ab->irq_num_id_rise;
-	}
-	err = request_threaded_irq(ab->irq_num_id_rise, NULL,
-		ab8500_usb_v1x_common_irq,
-		IRQF_NO_SUSPEND | IRQF_SHARED,
-		"usb-id-rise", ab);
-	if (err < 0) {
-		dev_err(ab->dev, "request_irq failed for ID rise irq\n");
-		goto fail0;
-	}
-
-	ab->irq_num_id_fall = platform_get_irq_byname(pdev, "ID_WAKEUP_F");
-	if (ab->irq_num_id_fall < 0) {
-		dev_err(&pdev->dev, "ID fall irq not found\n");
-		return ab->irq_num_id_fall;
-	}
-	err = request_threaded_irq(ab->irq_num_id_fall, NULL,
-		ab8500_usb_v1x_common_irq,
-		IRQF_NO_SUSPEND | IRQF_SHARED,
-		"usb-id-fall", ab);
-	if (err < 0) {
-		dev_err(ab->dev, "request_irq failed for ID fall irq\n");
-		goto fail1;
-	}
-
-	ab->irq_num_vbus_rise = platform_get_irq_byname(pdev, "VBUS_DET_R");
-	if (ab->irq_num_vbus_rise < 0) {
-		dev_err(&pdev->dev, "VBUS rise irq not found\n");
-		return ab->irq_num_vbus_rise;
-	}
-	err = request_threaded_irq(ab->irq_num_vbus_rise, NULL,
-		ab8500_usb_v1x_common_irq,
-		IRQF_NO_SUSPEND | IRQF_SHARED,
-		"usb-vbus-rise", ab);
-	if (err < 0) {
-		dev_err(ab->dev, "request_irq failed for Vbus rise irq\n");
-		goto fail2;
-	}
-
-	ab->irq_num_vbus_fall = platform_get_irq_byname(pdev, "VBUS_DET_F");
-	if (ab->irq_num_vbus_fall < 0) {
-		dev_err(&pdev->dev, "VBUS fall irq not found\n");
-		return ab->irq_num_vbus_fall;
-	}
-	err = request_threaded_irq(ab->irq_num_vbus_fall, NULL,
-		ab8500_usb_v1x_vbus_fall_irq,
-		IRQF_NO_SUSPEND | IRQF_SHARED,
-		"usb-vbus-fall", ab);
-	if (err < 0) {
-		dev_err(ab->dev, "request_irq failed for Vbus fall irq\n");
-		goto fail3;
-	}
-
-	return 0;
-fail3:
-	free_irq(ab->irq_num_vbus_rise, ab);
-fail2:
-	free_irq(ab->irq_num_id_fall, ab);
-fail1:
-	free_irq(ab->irq_num_id_rise, ab);
-fail0:
-	return err;
+	free_irq(ab->irq_num_link_status, ab);
 }
 
 static int ab8500_usb_v2_res_setup(struct platform_device *pdev,
@@ -471,16 +360,16 @@ static int ab8500_usb_v2_res_setup(struct platform_device *pdev,
 static int ab8500_usb_probe(struct platform_device *pdev)
 {
 	struct ab8500_usb	*ab;
+	struct ab8500		*ab8500;
 	struct usb_otg		*otg;
 	int err;
 	int rev;
 
+	ab8500 = dev_get_drvdata(pdev->dev.parent);
 	rev = abx500_get_chip_id(&pdev->dev);
-	if (rev < 0) {
-		dev_err(&pdev->dev, "Chip id read failed\n");
-		return rev;
-	} else if (rev < 0x10) {
-		dev_err(&pdev->dev, "Unsupported AB8500 chip\n");
+
+	if (is_ab8500_1p1_or_earlier(ab8500)) {
+		dev_err(&pdev->dev, "Unsupported AB8500 chip rev=%d\n", rev);
 		return -ENODEV;
 	}
 
@@ -495,7 +384,7 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 	}
 
 	ab->dev			= &pdev->dev;
-	ab->rev			= rev;
+	ab->ab8500		= ab8500;
 	ab->phy.dev		= ab->dev;
 	ab->phy.otg		= otg;
 	ab->phy.label		= "ab8500";
@@ -519,13 +408,7 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 	/* all: Disable phy when called from set_host and set_peripheral */
 	INIT_WORK(&ab->phy_dis_work, ab8500_usb_phy_disable_work);
 
-	if (ab->rev < 0x20) {
-		err = ab8500_usb_v1x_res_setup(pdev, ab);
-		ab->link_status_wait = AB8500_V1x_LINK_STAT_WAIT;
-	} else {
-		err = ab8500_usb_v2_res_setup(pdev, ab);
-	}
-
+	err = ab8500_usb_v2_res_setup(pdev, ab);
 	if (err < 0)
 		goto fail0;
 
@@ -535,7 +418,7 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 		goto fail1;
 	}
 
-	dev_info(&pdev->dev, "AB8500 usb driver initialized\n");
+	dev_info(&pdev->dev, "revision 0x%2x driver initialized\n", rev);
 
 	return 0;
 fail1:
-- 
1.8.1.3

