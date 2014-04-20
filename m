Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964820AbaDTItq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:49:46 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50354 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964786AbaDTIt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:49:28 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/10] staging: rtl8188eu: refactor led related structures.
Date: Sun, 20 Apr 2014 14:17:15 +0530
Message-Id: <1397983638-10752-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
References: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct led_priv contains two variables SwLed0 and SwLed1 but only
SwLed0 is being used by SwLedControlModel1() function.

SwLedControlModel1() function performs led operations.

This patch removes SwLed1 and code which uses SwLed1.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_led.c      |    3 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_led.c |   40 ++++++-------------------
 drivers/staging/rtl8188eu/include/rtw_led.h   |   14 +--------
 3 files changed, 11 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_led.c b/drivers/staging/rtl8188eu/core/rtw_led.c
index c42e176..87d6f06 100644
--- a/drivers/staging/rtl8188eu/core/rtw_led.c
+++ b/drivers/staging/rtl8188eu/core/rtw_led.c
@@ -70,10 +70,9 @@ void ResetLedStatus(struct LED_871x *pLed)
 
 /*Description: */
 /*		Initialize an LED_871x object. */
-void InitLed871x(struct adapter *padapter, struct LED_871x *pLed, enum LED_PIN_871x LedPin)
+void InitLed871x(struct adapter *padapter, struct LED_871x *pLed)
 {
 	pLed->padapter = padapter;
-	pLed->LedPin = LedPin;
 
 	ResetLedStatus(pLed);
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
index e3c86f7..77dce58 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
@@ -35,16 +35,7 @@ void SwLedOn(struct adapter *padapter, struct LED_871x *pLed)
 	if (padapter->bSurpriseRemoved || padapter->bDriverStopped)
 		return;
 	LedCfg = rtw_read8(padapter, REG_LEDCFG2);
-	switch (pLed->LedPin) {
-	case LED_PIN_LED0:
-		rtw_write8(padapter, REG_LEDCFG2, (LedCfg&0xf0)|BIT5|BIT6); /*  SW control led0 on. */
-		break;
-	case LED_PIN_LED1:
-		rtw_write8(padapter, REG_LEDCFG2, (LedCfg&0x0f)|BIT5); /*  SW control led1 on. */
-		break;
-	default:
-		break;
-	}
+	rtw_write8(padapter, REG_LEDCFG2, (LedCfg&0xf0)|BIT5|BIT6); /*  SW control led0 on. */
 	pLed->bLedOn = true;
 }
 
@@ -60,25 +51,15 @@ void SwLedOff(struct adapter *padapter, struct LED_871x *pLed)
 
 	LedCfg = rtw_read8(padapter, REG_LEDCFG2);/* 0x4E */
 
-	switch (pLed->LedPin) {
-	case LED_PIN_LED0:
-		if (pHalData->bLedOpenDrain) {
+	if (pHalData->bLedOpenDrain) {
 			/*  Open-drain arrangement for controlling the LED) */
-			LedCfg &= 0x90; /*  Set to software control. */
-			rtw_write8(padapter, REG_LEDCFG2, (LedCfg|BIT3));
-			LedCfg = rtw_read8(padapter, REG_MAC_PINMUX_CFG);
-			LedCfg &= 0xFE;
-			rtw_write8(padapter, REG_MAC_PINMUX_CFG, LedCfg);
-		} else {
-			rtw_write8(padapter, REG_LEDCFG2, (LedCfg|BIT3|BIT5|BIT6));
-		}
-		break;
-	case LED_PIN_LED1:
-		LedCfg &= 0x0f; /*  Set to software control. */
+		LedCfg &= 0x90; /*  Set to software control. */
 		rtw_write8(padapter, REG_LEDCFG2, (LedCfg|BIT3));
-		break;
-	default:
-		break;
+		LedCfg = rtw_read8(padapter, REG_MAC_PINMUX_CFG);
+		LedCfg &= 0xFE;
+		rtw_write8(padapter, REG_MAC_PINMUX_CFG, LedCfg);
+	} else {
+		rtw_write8(padapter, REG_LEDCFG2, (LedCfg|BIT3|BIT5|BIT6));
 	}
 exit:
 	pLed->bLedOn = false;
@@ -98,9 +79,7 @@ void rtl8188eu_InitSwLeds(struct adapter *padapter)
 	pledpriv->LedControlHandler = LedControl8188eu;
 	haldata->bLedOpenDrain = true;
 
-	InitLed871x(padapter, &(pledpriv->SwLed0), LED_PIN_LED0);
-
-	InitLed871x(padapter, &(pledpriv->SwLed1), LED_PIN_LED1);
+	InitLed871x(padapter, &(pledpriv->SwLed0));
 }
 
 /*	Description: */
@@ -110,5 +89,4 @@ void rtl8188eu_DeInitSwLeds(struct adapter *padapter)
 	struct led_priv	*ledpriv = &(padapter->ledpriv);
 
 	DeInitLed871x(&(ledpriv->SwLed0));
-	DeInitLed871x(&(ledpriv->SwLed1));
 }
diff --git a/drivers/staging/rtl8188eu/include/rtw_led.h b/drivers/staging/rtl8188eu/include/rtw_led.h
index 690c82a..ed1c687 100644
--- a/drivers/staging/rtl8188eu/include/rtw_led.h
+++ b/drivers/staging/rtl8188eu/include/rtw_led.h
@@ -96,19 +96,9 @@ enum LED_STATE_871x {
 	LED_BLINK_ALWAYS_ON = 16,
 };
 
-enum LED_PIN_871x {
-	LED_PIN_NULL = 0,
-	LED_PIN_LED0 = 1,
-	LED_PIN_LED1 = 2,
-	LED_PIN_LED2 = 3,
-	LED_PIN_GPIO0 = 4,
-};
-
 struct LED_871x {
 	struct adapter *padapter;
 
-	enum LED_PIN_871x	LedPin;	/* Identify how to implement this
-					 * SW led. */
 	enum LED_STATE_871x	CurrLedState; /*  Current LED state. */
 	enum LED_STATE_871x	BlinkingLedState; /*  Next state for blinking,
 				   * either RTW_LED_ON or RTW_LED_OFF are. */
@@ -148,7 +138,6 @@ void LedControl8188eu(struct adapter *padapter, enum LED_CTL_MODE	LedAction);
 struct led_priv{
 	/* add for led control */
 	struct LED_871x			SwLed0;
-	struct LED_871x			SwLed1;
 	u8	bRegUseLed;
 	void (*LedControlHandler)(struct adapter *padapter,
 				  enum LED_CTL_MODE LedAction);
@@ -166,8 +155,7 @@ void BlinkWorkItemCallback(struct work_struct *work);
 
 void ResetLedStatus(struct LED_871x *pLed);
 
-void InitLed871x(struct adapter *padapter, struct LED_871x *pLed,
-		 enum LED_PIN_871x LedPin);
+void InitLed871x(struct adapter *padapter, struct LED_871x *pLed);
 
 void DeInitLed871x(struct LED_871x *pLed);
 
-- 
1.7.10.4

