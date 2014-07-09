Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbaGITLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:11:09 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:38932 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbaGITLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:11:07 -0400
From: James A Shackleford <shack@linux.com>
To: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 1/3] staging: rtl8712: remove wrapper function _init_workitem()
Date: Wed,  9 Jul 2014 15:10:45 -0400
Message-Id: <1404933047-23071-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inline function _init_workitem() is just a wrapper around INIT_WORK().
Oddly, this wrapper accepts 3 parameters while INIT_WORK() only accepts 2.
The third parameter is unused.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/osdep_service.h   | 5 -----
 drivers/staging/rtl8712/rtl8712_led.c     | 2 +-
 drivers/staging/rtl8712/rtl871x_pwrctrl.c | 6 ++----
 drivers/staging/rtl8712/rtl871x_xmit.c    | 2 +-
 4 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 67c53d5..2cf9a02 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -81,11 +81,6 @@ static inline void _cancel_timer(struct timer_list *ptimer, u8 *bcancelled)
 	*bcancelled = true; /*true ==1; false==0*/
 }
 
-static inline void _init_workitem(_workitem *pwork, void *pfunc, void *cntx)
-{
-	INIT_WORK(pwork, pfunc);
-}
-
 static inline void _set_workitem(_workitem *pwork)
 {
 	schedule_work(pwork);
diff --git a/drivers/staging/rtl8712/rtl8712_led.c b/drivers/staging/rtl8712/rtl8712_led.c
index 6cb1a0af5..a84ae2f 100644
--- a/drivers/staging/rtl8712/rtl8712_led.c
+++ b/drivers/staging/rtl8712/rtl8712_led.c
@@ -98,7 +98,7 @@ static void InitLed871x(struct _adapter *padapter, struct LED_871x *pLed,
 	pLed->BlinkTimes = 0;
 	pLed->BlinkingLedState = LED_UNKNOWN;
 	_init_timer(&(pLed->BlinkTimer), nic, BlinkTimerCallback, pLed);
-	_init_workitem(&(pLed->BlinkWorkItem), BlinkWorkItemCallback, pLed);
+	INIT_WORK(&pLed->BlinkWorkItem, BlinkWorkItemCallback);
 }
 
 /*
diff --git a/drivers/staging/rtl8712/rtl871x_pwrctrl.c b/drivers/staging/rtl8712/rtl871x_pwrctrl.c
index 9fd2ec7..6cf051f 100644
--- a/drivers/staging/rtl8712/rtl871x_pwrctrl.c
+++ b/drivers/staging/rtl8712/rtl871x_pwrctrl.c
@@ -184,10 +184,8 @@ void r8712_init_pwrctrl_priv(struct _adapter *padapter)
 	pwrctrlpriv->tog = 0x80;
 /* clear RPWM to ensure driver and fw back to initial state. */
 	r8712_write8(padapter, 0x1025FE58, 0);
-	_init_workitem(&(pwrctrlpriv->SetPSModeWorkItem),
-		       SetPSModeWorkItemCallback, padapter);
-	_init_workitem(&(pwrctrlpriv->rpwm_workitem),
-		       rpwm_workitem_callback, padapter);
+	INIT_WORK(&pwrctrlpriv->SetPSModeWorkItem, SetPSModeWorkItemCallback);
+	INIT_WORK(&pwrctrlpriv->rpwm_workitem, rpwm_workitem_callback);
 	_init_timer(&(pwrctrlpriv->rpwm_check_timer),
 		    padapter->pnetdev, rpwm_check_handler, (u8 *)padapter);
 }
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index a104b77..b985edc 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -148,7 +148,7 @@ sint _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv,
 		pxmitbuf++;
 	}
 	pxmitpriv->free_xmitbuf_cnt = NR_XMITBUFF;
-	_init_workitem(&padapter->wkFilterRxFF0, r8712_SetFilter, padapter);
+	INIT_WORK(&padapter->wkFilterRxFF0, r8712_SetFilter);
 	alloc_hwxmits(padapter);
 	init_hwxmits(pxmitpriv->hwxmits, pxmitpriv->hwxmit_entry);
 	tasklet_init(&pxmitpriv->xmit_tasklet,
-- 
1.9.1

