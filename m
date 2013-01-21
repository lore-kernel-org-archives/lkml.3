Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3AUMLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:11:22 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49552 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3AUMEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:25 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru,
        =?UTF-8?q?Henrik=20S=C3=B6lver?= <henrik.solver@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/24] ab8500-charger: AB workaround for invalid charger
Date: Mon, 21 Jan 2013 12:03:38 +0000
Message-Id: <1358769840-4763-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Sölver <henrik.solver@stericsson.com>

AB8500 refuses to start charging when some types of non standard
chargers are connected. This change force the AB to start charging.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Henrik Sölver <henrik.solver@stericsson.com>
Reviewed-by: Yvan FILLION <yvan.fillion@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Yvan FILLION <yvan.fillion@stericsson.com>
---
 drivers/power/ab8500_charger.c |   59 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 43ec82b..4c66172 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -207,6 +207,7 @@ struct ab8500_charger_usb_state {
  * @usb_device_is_unrecognised	USB device is unrecognised by the hardware
  * @autopower		Indicate if we should have automatic pwron after pwrloss
  * @autopower_cfg	platform specific power config support for "pwron after pwrloss"
+ * @invalid_charger_detect_state State when forcing AB to use invalid charger
  * @parent:		Pointer to the struct ab8500
  * @gpadc:		Pointer to the struct gpadc
  * @bm:           	Platform specific battery management information
@@ -251,6 +252,7 @@ struct ab8500_charger {
 	bool usb_device_is_unrecognised;
 	bool autopower;
 	bool autopower_cfg;
+	int invalid_charger_detect_state;
 	struct ab8500 *parent;
 	struct ab8500_gpadc *gpadc;
 	struct abx500_bm_data *bm;
@@ -659,7 +661,6 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 			break;
 		}
 	case USB_STAT_HM_IDGND:
-	case USB_STAT_NOT_VALID_LINK:
 		dev_err(di->dev, "USB Type - Charging not allowed\n");
 		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P05;
 		ret = -ENXIO;
@@ -688,6 +689,9 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
 		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
 				di->max_usb_in_curr);
+	case USB_STAT_NOT_VALID_LINK:
+		dev_err(di->dev, "USB Type invalid - try charging anyway\n");
+		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
 		break;
 
 	default:
@@ -1957,7 +1961,9 @@ static void ab8500_charger_usb_link_attach_work(struct work_struct *work)
  */
 static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 {
+	int detected_chargers;
 	int ret;
+	u8 val;
 
 	struct ab8500_charger *di = container_of(work,
 		struct ab8500_charger, usb_link_status_work);
@@ -1967,11 +1973,55 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 	 * synchronously, we have the check if  is
 	 * connected by reading the status register
 	 */
-	ret = ab8500_charger_detect_chargers(di);
-	if (ret < 0)
+	detected_chargers = ab8500_charger_detect_chargers(di);
+	if (detected_chargers < 0)
 		return;
 
-	if (!(ret & USB_PW_CONN)) {
+	/*
+	 * Some chargers that breaks the USB spec is
+	 * identified as invalid by AB8500 and it refuse
+	 * to start the charging process. but by jumping
+	 * thru a few hoops it can be forced to start.
+	 */
+	ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
+			AB8500_USB_LINE_STAT_REG, &val);
+	if (ret >= 0)
+		dev_dbg(di->dev, "UsbLineStatus register = 0x%02x\n", val);
+	else
+		dev_dbg(di->dev, "Error reading USB link status\n");
+
+	if (detected_chargers & USB_PW_CONN) {
+		if (((val & AB8500_USB_LINK_STATUS) >> 3) == USB_STAT_NOT_VALID_LINK &&
+				di->invalid_charger_detect_state == 0) {
+			dev_dbg(di->dev, "Invalid charger detected, state= 0\n");
+			/*Enable charger*/
+			abx500_mask_and_set_register_interruptible(di->dev,
+					AB8500_CHARGER, AB8500_USBCH_CTRL1_REG, 0x01, 0x01);
+			/*Enable charger detection*/
+			abx500_mask_and_set_register_interruptible(di->dev, AB8500_USB,
+					AB8500_MCH_IPT_CURLVL_REG, 0x01, 0x01);
+			di->invalid_charger_detect_state = 1;
+			/*exit and wait for new link status interrupt.*/
+			return;
+
+		}
+		if (di->invalid_charger_detect_state == 1) {
+			dev_dbg(di->dev, "Invalid charger detected, state= 1\n");
+			/*Stop charger detection*/
+			abx500_mask_and_set_register_interruptible(di->dev, AB8500_USB,
+					AB8500_MCH_IPT_CURLVL_REG, 0x01, 0x00);
+			/*Check link status*/
+			ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
+					AB8500_USB_LINE_STAT_REG, &val);
+			dev_dbg(di->dev, "USB link status= 0x%02x\n",
+					(val & AB8500_USB_LINK_STATUS) >> 3);
+			di->invalid_charger_detect_state = 2;
+		}
+	} else {
+		di->invalid_charger_detect_state = 0;
+	}
+
+	if (!(detected_chargers & USB_PW_CONN)) {
 		di->vbus_detected = 0;
 		ab8500_charger_set_usb_connected(di, false);
 		ab8500_power_supply_changed(di, &di->usb_chg.psy);
@@ -2884,6 +2934,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	spin_lock_init(&di->usb_state.usb_lock);
 
 	di->autopower = false;
+	di->invalid_charger_detect_state = 0;
 
 	/* AC supply */
 	/* power_supply base class */
-- 
1.7.9.5

