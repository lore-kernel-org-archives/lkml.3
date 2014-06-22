Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaFVIxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:53:43 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50004 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbaFVIxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:53:40 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 42/42] staging: rtl8188eu: Replace _cancel_timer() with del_timer_sync()
Date: Sun, 22 Jun 2014 14:21:46 +0530
Message-Id: <1403427107-12744-14-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
References: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c          |    3 +--
 drivers/staging/rtl8188eu/core/rtw_mlme.c         |    8 ++------
 drivers/staging/rtl8188eu/core/rtw_p2p.c          |    4 +---
 drivers/staging/rtl8188eu/include/osdep_service.h |    6 ------
 4 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 556d17d..aeaa873 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -2084,7 +2084,6 @@ void rtw_joinbss_cmd_callback(struct adapter *padapter,  struct cmd_obj *pcmd)
 
 void rtw_createbss_cmd_callback(struct adapter *padapter, struct cmd_obj *pcmd)
 {
-	u8 timer_cancelled;
 	struct sta_info *psta = NULL;
 	struct wlan_network *pwlan = NULL;
 	struct	mlme_priv *pmlmepriv = &padapter->mlmepriv;
@@ -2097,7 +2096,7 @@ void rtw_createbss_cmd_callback(struct adapter *padapter, struct cmd_obj *pcmd)
 		_set_timer(&pmlmepriv->assoc_timer, 1);
 	}
 
-	_cancel_timer(&pmlmepriv->assoc_timer, &timer_cancelled);
+	del_timer_sync(&pmlmepriv->assoc_timer);
 
 	spin_lock_bh(&pmlmepriv->lock);
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index c03442d..0cb9e15 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -725,10 +725,7 @@ void rtw_surveydone_event_callback(struct adapter	*adapter, u8 *pbuf)
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_, ("rtw_surveydone_event_callback: fw_state:%x\n\n", get_fwstate(pmlmepriv)));
 
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY)) {
-		u8 timer_cancelled;
-
-		_cancel_timer(&pmlmepriv->scan_to_timer, &timer_cancelled);
-
+		del_timer_sync(&pmlmepriv->scan_to_timer);
 		_clr_fwstate_(pmlmepriv, _FW_UNDER_SURVEY);
 	} else {
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_, ("nic status=%x, survey done event comes too late!\n", get_fwstate(pmlmepriv)));
@@ -1103,7 +1100,6 @@ static void rtw_joinbss_update_network(struct adapter *padapter, struct wlan_net
 
 void rtw_joinbss_event_prehandle(struct adapter *adapter, u8 *pbuf)
 {
-	u8 timer_cancelled;
 	struct sta_info *ptarget_sta = NULL, *pcur_sta = NULL;
 	struct	sta_priv *pstapriv = &adapter->stapriv;
 	struct	mlme_priv	*pmlmepriv = &(adapter->mlmepriv);
@@ -1196,7 +1192,7 @@ void rtw_joinbss_event_prehandle(struct adapter *adapter, u8 *pbuf)
 				}
 
 			/* s5. Cancle assoc_timer */
-			_cancel_timer(&pmlmepriv->assoc_timer, &timer_cancelled);
+			del_timer_sync(&pmlmepriv->assoc_timer);
 
 			RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_, ("Cancle assoc_timer\n"));
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_p2p.c b/drivers/staging/rtl8188eu/core/rtw_p2p.c
index 6023a85..e1fd198 100644
--- a/drivers/staging/rtl8188eu/core/rtw_p2p.c
+++ b/drivers/staging/rtl8188eu/core/rtw_p2p.c
@@ -1404,9 +1404,7 @@ u8 process_p2p_group_negotation_confirm(struct wifidirect_info *pwdinfo, u8 *pfr
 			result = attr_content;
 
 			if (attr_content == P2P_STATUS_SUCCESS) {
-				u8	bcancelled = 0;
-
-				_cancel_timer(&pwdinfo->restore_p2p_state_timer, &bcancelled);
+				del_timer_sync(&pwdinfo->restore_p2p_state_timer);
 
 				/*	Commented by Albert 20100911 */
 				/*	Todo: Need to handle the case which both Intents are the same. */
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 2d07dea..95131fe 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -90,12 +90,6 @@ static inline void _set_timer(struct timer_list *ptimer, u32 delay_time)
 	mod_timer(ptimer , (jiffies+(delay_time*HZ/1000)));
 }
 
-static inline void _cancel_timer(struct timer_list *ptimer, u8 *bcancelled)
-{
-	del_timer_sync(ptimer);
-	*bcancelled = true;/* true ==1; false==0 */
-}
-
 #define RTW_TIMER_HDL_ARGS void *FunctionContext
 #define RTW_TIMER_HDL_NAME(name) rtw_##name##_timer_hdl
 #define RTW_DECLARE_TIMER_HDL(name) \
-- 
1.7.10.4

