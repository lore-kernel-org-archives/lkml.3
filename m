Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaG1Rma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:42:30 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48188 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaG1RmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:42:22 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 4/9] staging: rtl8188eu: Remove wrapper function _dynamic_check_timer_handlder()
Date: Mon, 28 Jul 2014 23:11:25 +0530
Message-Id: <1406569290-19943-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406569290-19943-1-git-send-email-navin.patidar@gmail.com>
References: <1406569290-19943-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c     |   13 ++++++++-----
 drivers/staging/rtl8188eu/include/rtw_mlme.h  |    2 +-
 drivers/staging/rtl8188eu/os_dep/mlme_linux.c |   12 +-----------
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index d5b2f51..149c271 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -1431,24 +1431,27 @@ static void rtw_auto_scan_handler(struct adapter *padapter)
 	}
 }
 
-void rtw_dynamic_check_timer_handlder(struct adapter *adapter)
+void rtw_dynamic_check_timer_handlder(void *function_context)
 {
+	struct adapter *adapter = (struct adapter *)function_context;
 	struct registry_priv *pregistrypriv = &adapter->registrypriv;
 
 	if (!adapter)
-		return;
+		goto exit;
 	if (!adapter->hw_init_completed)
-		return;
+		goto exit;
 	if ((adapter->bDriverStopped) || (adapter->bSurpriseRemoved))
-		return;
+		goto exit;
 	if (adapter->net_closed)
-		return;
+		goto exit;
 	rtw_dynamic_chk_wk_cmd(adapter);
 
 	if (pregistrypriv->wifi_spec == 1) {
 		/* auto site survey */
 		rtw_auto_scan_handler(adapter);
 	}
+exit:
+	_set_timer(&adapter->mlmepriv.dynamic_chk_timer, 2000);
 }
 
 #define RTW_SCAN_RESULT_EXPIRE 2000
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme.h b/drivers/staging/rtl8188eu/include/rtw_mlme.h
index 8f5457b..8d83f7c 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme.h
@@ -554,7 +554,7 @@ void rtw_get_encrypt_decrypt_from_registrypriv(struct adapter *adapter);
 void _rtw_join_timeout_handler(void *function_context);
 void rtw_scan_timeout_handler(void *function_context);
 
-void rtw_dynamic_check_timer_handlder(struct adapter *adapter);
+void rtw_dynamic_check_timer_handlder(void *function_context);
 #define rtw_is_scan_deny(adapter) false
 #define rtw_clear_scan_deny(adapter) do {} while (0)
 #define rtw_set_scan_deny_timer_hdl(adapter) do {} while (0)
diff --git a/drivers/staging/rtl8188eu/os_dep/mlme_linux.c b/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
index 0bfaa78..82b71fa 100644
--- a/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
@@ -25,23 +25,13 @@
 #include <drv_types.h>
 #include <mlme_osdep.h>
 
-static void _dynamic_check_timer_handlder(void *FunctionContext)
-{
-	struct adapter *adapter = (struct adapter *)FunctionContext;
-
-	if (adapter->registrypriv.mp_mode == 1)
-		return;
-	rtw_dynamic_check_timer_handlder(adapter);
-	_set_timer(&adapter->mlmepriv.dynamic_chk_timer, 2000);
-}
-
 void rtw_init_mlme_timer(struct adapter *padapter)
 {
 	struct	mlme_priv *pmlmepriv = &padapter->mlmepriv;
 
 	_init_timer(&(pmlmepriv->assoc_timer), padapter->pnetdev, _rtw_join_timeout_handler, padapter);
 	_init_timer(&(pmlmepriv->scan_to_timer), padapter->pnetdev, rtw_scan_timeout_handler, padapter);
-	_init_timer(&(pmlmepriv->dynamic_chk_timer), padapter->pnetdev, _dynamic_check_timer_handlder, padapter);
+	_init_timer(&(pmlmepriv->dynamic_chk_timer), padapter->pnetdev, rtw_dynamic_check_timer_handlder, padapter);
 }
 
 void rtw_os_indicate_connect(struct adapter *adapter)
-- 
1.7.10.4

