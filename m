Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaKGLVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:21:07 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45164 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaKGLVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:21:01 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: rtl8188eu: unneeded NULL check
Date: Fri,  7 Nov 2014 16:50:46 +0530
Message-Id: <1415359246-18212-2-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1415359246-18212-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1415359246-18212-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

before these NULL checks we are already checking it for NULL, and if
it is NULL then we are jumping to the error label and handling
the error before returning.
So we can reach this part of the code only if the variable is known
to be not NULL, and if we already know that it is not NULL, then no
need to check it again.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

hi,
struct mlme_priv *pmlmepriv and bLinked was moved to the beginning of
the function, otherwise it was giving warning about mixed code while
compiling.

 drivers/staging/rtl8188eu/core/rtw_xmit.c   |  4 +---
 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c | 30 ++++++++++++++---------------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index a0bbf90..7a71df1 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -1025,8 +1025,7 @@ s32 rtw_xmitframe_coalesce(struct adapter *padapter, struct sk_buff *pkt, struct
 
 		/* adding icv, if necessary... */
 		if (pattrib->iv_len) {
-			if (psta != NULL) {
-				switch (pattrib->encrypt) {
+			switch (pattrib->encrypt) {
 				case _WEP40_:
 				case _WEP104_:
 					WEP_IV(pattrib->iv, psta->dot11txpn, pattrib->key_idx);
@@ -1043,7 +1042,6 @@ s32 rtw_xmitframe_coalesce(struct adapter *padapter, struct sk_buff *pkt, struct
 					else
 						AES_IV(pattrib->iv, psta->dot11txpn, 0);
 					break;
-				}
 			}
 
 			memcpy(pframe, pattrib->iv, pattrib->iv_len);
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c b/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
index dab4c33..0156621 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
@@ -155,6 +155,8 @@ void rtl8188e_HalDmWatchDog(struct adapter *Adapter)
 	bool fw_ps_awake = true;
 	u8 hw_init_completed = false;
 	struct hal_data_8188e *hal_data = GET_HAL_DATA(Adapter);
+	struct mlme_priv *pmlmepriv = NULL;
+	u8 bLinked = false;
 
 	hw_init_completed = Adapter->hw_init_completed;
 
@@ -170,22 +172,20 @@ void rtl8188e_HalDmWatchDog(struct adapter *Adapter)
 		fw_ps_awake = false;
 
 	/* ODM */
-	if (hw_init_completed) {
-		struct mlme_priv *pmlmepriv = &Adapter->mlmepriv;
-		u8 bLinked = false;
-
-		if ((check_fwstate(pmlmepriv, WIFI_AP_STATE)) ||
-		    (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE | WIFI_ADHOC_MASTER_STATE))) {
-			if (Adapter->stapriv.asoc_sta_count > 2)
-				bLinked = true;
-		} else {/* Station mode */
-			if (check_fwstate(pmlmepriv, _FW_LINKED))
-				bLinked = true;
-		}
-
-		ODM_CmnInfoUpdate(&hal_data->odmpriv, ODM_CMNINFO_LINK, bLinked);
-		ODM_DMWatchdog(&hal_data->odmpriv);
+	pmlmepriv = &Adapter->mlmepriv;
+
+	if ((check_fwstate(pmlmepriv, WIFI_AP_STATE)) ||
+	    (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE |
+			   WIFI_ADHOC_MASTER_STATE))) {
+		if (Adapter->stapriv.asoc_sta_count > 2)
+			bLinked = true;
+	} else {/* Station mode */
+		if (check_fwstate(pmlmepriv, _FW_LINKED))
+			bLinked = true;
 	}
+
+	ODM_CmnInfoUpdate(&hal_data->odmpriv, ODM_CMNINFO_LINK, bLinked);
+	ODM_DMWatchdog(&hal_data->odmpriv);
 skip_dm:
 	/*  Check GPIO to determine current RF on/off and Pbc status. */
 	/*  Check Hardware Radio ON/OFF or not */
-- 
1.8.1.2

