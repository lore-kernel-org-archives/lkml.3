Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab3EOMFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:05:20 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:55434 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338Ab3EOMFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:05:15 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 08/10] usb: phy: ab8500-usb: add flag bits to control driver features
Date: Wed, 15 May 2013 14:03:31 +0200
Message-Id: <1368619413-24647-9-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
References: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a "flags" field in "struct ab8500_usb" to allow controlling
driver features and quirks depending on ab8500 chip variant and
revision.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 109 ++++++++++++++++++++++++++-------------
 1 file changed, 73 insertions(+), 36 deletions(-)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 9b9a975..4591698 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -121,6 +121,17 @@ enum ab8500_usb_mode {
 	USB_DEDICATED_CHG
 };
 
+/* Register USB_LINK_STATUS interrupt */
+#define AB8500_USB_FLAG_USE_LINK_STATUS_IRQ	(1 << 0)
+/* Register ID_WAKEUP_F interrupt */
+#define AB8500_USB_FLAG_USE_ID_WAKEUP_IRQ	(1 << 1)
+/* Register VBUS_DET_F interrupt */
+#define AB8500_USB_FLAG_USE_VBUS_DET_IRQ	(1 << 2)
+/* Driver is using the ab-iddet driver*/
+#define AB8500_USB_FLAG_USE_AB_IDDET		(1 << 3)
+/* Enable setting regulators voltage */
+#define AB8500_USB_FLAG_REGULATOR_SET_VOLTAGE	(1 << 4)
+
 struct ab8500_usb {
 	struct usb_phy phy;
 	struct device *dev;
@@ -136,6 +147,7 @@ struct ab8500_usb {
 	int previous_link_status_state;
 	struct pinctrl *pinctrl;
 	struct pinctrl_state *pins_sleep;
+	unsigned int flags;
 };
 
 static inline struct ab8500_usb *phy_to_ab(struct usb_phy *x)
@@ -174,7 +186,7 @@ static void ab8500_usb_regulator_enable(struct ab8500_usb *ab)
 	if (ret)
 		dev_err(ab->dev, "Failed to enable v-ape\n");
 
-	if (!is_ab8500_2p0_or_earlier(ab->ab8500)) {
+	if (ab->flags & AB8500_USB_FLAG_REGULATOR_SET_VOLTAGE) {
 		ab->saved_v_ulpi = regulator_get_voltage(ab->v_ulpi);
 		if (ab->saved_v_ulpi < 0)
 			dev_err(ab->dev, "Failed to get v_ulpi voltage\n");
@@ -194,7 +206,7 @@ static void ab8500_usb_regulator_enable(struct ab8500_usb *ab)
 	if (ret)
 		dev_err(ab->dev, "Failed to enable vddulpivio18\n");
 
-	if (!is_ab8500_2p0_or_earlier(ab->ab8500)) {
+	if (ab->flags & AB8500_USB_FLAG_REGULATOR_SET_VOLTAGE) {
 		volt = regulator_get_voltage(ab->v_ulpi);
 		if ((volt != 1300000) && (volt != 1350000))
 			dev_err(ab->dev, "Vintcore is not set to 1.3V volt=%d\n",
@@ -215,7 +227,7 @@ static void ab8500_usb_regulator_disable(struct ab8500_usb *ab)
 	regulator_disable(ab->v_ulpi);
 
 	/* USB is not the only consumer of Vintcore, restore old settings */
-	if (!is_ab8500_2p0_or_earlier(ab->ab8500)) {
+	if (ab->flags & AB8500_USB_FLAG_REGULATOR_SET_VOLTAGE) {
 		if (ab->saved_v_ulpi > 0) {
 			ret = regulator_set_voltage(ab->v_ulpi,
 					ab->saved_v_ulpi, ab->saved_v_ulpi);
@@ -729,43 +741,52 @@ static int ab8500_usb_irq_setup(struct platform_device *pdev,
 	int err;
 	int irq;
 
-	irq = platform_get_irq_byname(pdev, "USB_LINK_STATUS");
-	if (irq < 0) {
-		dev_err(&pdev->dev, "Link status irq not found\n");
-		return irq;
-	}
-	err = devm_request_threaded_irq(&pdev->dev, irq, NULL,
-			ab8500_usb_link_status_irq,
-			IRQF_NO_SUSPEND | IRQF_SHARED, "usb-link-status", ab);
-	if (err < 0) {
-		dev_err(ab->dev, "request_irq failed for link status irq\n");
-		return err;
+	if (ab->flags & AB8500_USB_FLAG_USE_LINK_STATUS_IRQ) {
+		irq = platform_get_irq_byname(pdev, "USB_LINK_STATUS");
+		if (irq < 0) {
+			dev_err(&pdev->dev, "Link status irq not found\n");
+			return irq;
+		}
+		err = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+				ab8500_usb_link_status_irq,
+				IRQF_NO_SUSPEND | IRQF_SHARED,
+				"usb-link-status", ab);
+		if (err < 0) {
+			dev_err(ab->dev, "request_irq failed for link status irq\n");
+			return err;
+		}
 	}
 
-	irq = platform_get_irq_byname(pdev, "ID_WAKEUP_F");
-	if (irq < 0) {
-		dev_err(&pdev->dev, "ID fall irq not found\n");
-		return irq;
-	}
-	err = devm_request_threaded_irq(&pdev->dev, irq, NULL,
-			ab8500_usb_disconnect_irq,
-			IRQF_NO_SUSPEND | IRQF_SHARED, "usb-id-fall", ab);
-	if (err < 0) {
-		dev_err(ab->dev, "request_irq failed for ID fall irq\n");
-		return err;
+	if (ab->flags & AB8500_USB_FLAG_USE_ID_WAKEUP_IRQ) {
+		irq = platform_get_irq_byname(pdev, "ID_WAKEUP_F");
+		if (irq < 0) {
+			dev_err(&pdev->dev, "ID fall irq not found\n");
+			return irq;
+		}
+		err = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+				ab8500_usb_disconnect_irq,
+				IRQF_NO_SUSPEND | IRQF_SHARED,
+				"usb-id-fall", ab);
+		if (err < 0) {
+			dev_err(ab->dev, "request_irq failed for ID fall irq\n");
+			return err;
+		}
 	}
 
-	irq = platform_get_irq_byname(pdev, "VBUS_DET_F");
-	if (irq < 0) {
-		dev_err(&pdev->dev, "VBUS fall irq not found\n");
-		return irq;
-	}
-	err = devm_request_threaded_irq(&pdev->dev, irq, NULL,
-			ab8500_usb_disconnect_irq,
-			IRQF_NO_SUSPEND | IRQF_SHARED, "usb-vbus-fall", ab);
-	if (err < 0) {
-		dev_err(ab->dev, "request_irq failed for Vbus fall irq\n");
-		return err;
+	if (ab->flags & AB8500_USB_FLAG_USE_VBUS_DET_IRQ) {
+		irq = platform_get_irq_byname(pdev, "VBUS_DET_F");
+		if (irq < 0) {
+			dev_err(&pdev->dev, "VBUS fall irq not found\n");
+			return irq;
+		}
+		err = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+				ab8500_usb_disconnect_irq,
+				IRQF_NO_SUSPEND | IRQF_SHARED,
+				"usb-vbus-fall", ab);
+		if (err < 0) {
+			dev_err(ab->dev, "request_irq failed for Vbus fall irq\n");
+			return err;
+		}
 	}
 
 	return 0;
@@ -888,6 +909,22 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 	otg->set_host		= ab8500_usb_set_host;
 	otg->set_peripheral	= ab8500_usb_set_peripheral;
 
+	if (is_ab8500(ab->ab8500)) {
+		ab->flags |= AB8500_USB_FLAG_USE_LINK_STATUS_IRQ |
+			AB8500_USB_FLAG_USE_ID_WAKEUP_IRQ |
+			AB8500_USB_FLAG_USE_VBUS_DET_IRQ |
+			AB8500_USB_FLAG_REGULATOR_SET_VOLTAGE;
+	} else if (is_ab8505(ab->ab8500)) {
+		ab->flags |= AB8500_USB_FLAG_USE_LINK_STATUS_IRQ |
+			AB8500_USB_FLAG_USE_ID_WAKEUP_IRQ |
+			AB8500_USB_FLAG_USE_VBUS_DET_IRQ |
+			AB8500_USB_FLAG_REGULATOR_SET_VOLTAGE;
+	}
+
+	/* Disable regulator voltage setting for AB8500 <= v2.0 */
+	if (is_ab8500_2p0_or_earlier(ab->ab8500))
+		ab->flags &= ~AB8500_USB_FLAG_REGULATOR_SET_VOLTAGE;
+
 	platform_set_drvdata(pdev, ab);
 
 	ATOMIC_INIT_NOTIFIER_HEAD(&ab->phy.notifier);
-- 
1.8.2

