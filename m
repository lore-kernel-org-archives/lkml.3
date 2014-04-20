Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaDTIso (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:48:44 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:42686 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaDTIsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:48:35 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 03/10] staging: rtl8188eu: Remove _ReadLEDSetting() function.
Date: Sun, 20 Apr 2014 14:17:11 +0530
Message-Id: <1397983638-10752-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
References: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_ReadLEDSetting() doesn't read led settings this function actually
initialize  member variables of struct led_priv, we should do that
inside rtl8188eu_InitSwLeds().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188eu_led.c |    4 ++++
 drivers/staging/rtl8188eu/hal/usb_halinit.c   |   12 ------------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
index 08dfd94..01eeb70 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
@@ -92,8 +92,12 @@ exit:
 void rtl8188eu_InitSwLeds(struct adapter *padapter)
 {
 	struct led_priv *pledpriv = &(padapter->ledpriv);
+	struct hal_data_8188e   *haldata = GET_HAL_DATA(padapter);
 
+	pledpriv->bRegUseLed = true;
+	pledpriv->LedStrategy = SW_LED_MODE1;
 	pledpriv->LedControlHandler = LedControl8188eu;
+	haldata->bLedOpenDrain = true;
 
 	InitLed871x(padapter, &(pledpriv->SwLed0), LED_PIN_LED0);
 
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index c92067f..0dfd62b 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -1129,16 +1129,6 @@ static unsigned int rtl8188eu_inirp_deinit(struct adapter *Adapter)
 /*	EEPROM/EFUSE Content Parsing */
 /*  */
 /*  */
-static void _ReadLEDSetting(struct adapter *Adapter, u8 *PROMContent, bool AutoloadFail)
-{
-	struct led_priv *pledpriv = &(Adapter->ledpriv);
-	struct hal_data_8188e	*haldata = GET_HAL_DATA(Adapter);
-
-	pledpriv->bRegUseLed = true;
-	pledpriv->LedStrategy = SW_LED_MODE1;
-	haldata->bLedOpenDrain = true;/*  Support Open-drain arrangement for controlling the LED. */
-}
-
 static void Hal_EfuseParsePIDVID_8188EU(struct adapter *adapt, u8 *hwinfo, bool AutoLoadFail)
 {
 	struct hal_data_8188e	*haldata = GET_HAL_DATA(adapt);
@@ -1215,8 +1205,6 @@ readAdapterInfo_8188EU(
 	/*  */
 	Hal_InitChannelPlan(adapt);
 	Hal_CustomizeByCustomerID_8188EU(adapt);
-
-	_ReadLEDSetting(adapt, eeprom->efuse_eeprom_data, eeprom->bautoload_fail_flag);
 }
 
 static void _ReadPROMContent(
-- 
1.7.10.4

