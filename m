Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197AbaE2Rxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:53:31 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40167 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993AbaE2Rx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:53:29 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/18] staging: rtl8188eu: Remove unused function rtl8188e_sreset_xmit_status_check()
Date: Thu, 29 May 2014 23:20:48 +0530
Message-Id: <1401385858-28722-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove rtl8188e_sreset_xmit_status_check() and function pointer
->sreset_xmit_status_check pointing to it.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  |    1 -
 drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c    |   35 --------------------
 drivers/staging/rtl8188eu/include/hal_intf.h       |    1 -
 .../staging/rtl8188eu/include/rtl8188e_sreset.h    |    1 -
 4 files changed, 38 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 070b43c..55eaf57 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1873,7 +1873,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 
 	pHalFunc->sreset_init_value = &sreset_init_value;
 	pHalFunc->silentreset = &rtl8188e_silentreset_for_specific_platform;
-	pHalFunc->sreset_xmit_status_check = &rtl8188e_sreset_xmit_status_check;
 	pHalFunc->sreset_linked_status_check  = &rtl8188e_sreset_linked_status_check;
 	pHalFunc->sreset_get_wifi_status  = &sreset_get_wifi_status;
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c b/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c
index 047b534..fd114c1 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c
@@ -26,41 +26,6 @@ void rtl8188e_silentreset_for_specific_platform(struct adapter *padapter)
 {
 }
 
-void rtl8188e_sreset_xmit_status_check(struct adapter *padapter)
-{
-	struct hal_data_8188e	*pHalData = GET_HAL_DATA(padapter);
-	struct sreset_priv *psrtpriv = &pHalData->srestpriv;
-
-	unsigned long current_time;
-	struct xmit_priv	*pxmitpriv = &padapter->xmitpriv;
-	unsigned int diff_time;
-	u32 txdma_status;
-
-	txdma_status = rtw_read32(padapter, REG_TXDMA_STATUS);
-	if (txdma_status != 0x00) {
-		DBG_88E("%s REG_TXDMA_STATUS:0x%08x\n", __func__, txdma_status);
-		rtw_write32(padapter, REG_TXDMA_STATUS, txdma_status);
-		rtl8188e_silentreset_for_specific_platform(padapter);
-	}
-	/* total xmit irp = 4 */
-	current_time = jiffies;
-	if (0 == pxmitpriv->free_xmitbuf_cnt) {
-		diff_time = jiffies_to_msecs(current_time - psrtpriv->last_tx_time);
-
-		if (diff_time > 2000) {
-			if (psrtpriv->last_tx_complete_time == 0) {
-				psrtpriv->last_tx_complete_time = current_time;
-			} else {
-				diff_time = jiffies_to_msecs(current_time - psrtpriv->last_tx_complete_time);
-				if (diff_time > 4000) {
-					DBG_88E("%s tx hang\n", __func__);
-					rtl8188e_silentreset_for_specific_platform(padapter);
-				}
-			}
-		}
-	}
-}
-
 void rtl8188e_sreset_linked_status_check(struct adapter *padapter)
 {
 	u32 rx_dma_status = 0;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index eb7df0e..85fd521 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -253,7 +253,6 @@ struct hal_ops {
 
 	void (*sreset_init_value)(struct adapter *padapter);
 	void (*silentreset)(struct adapter *padapter);
-	void (*sreset_xmit_status_check)(struct adapter *padapter);
 	void (*sreset_linked_status_check) (struct adapter *padapter);
 	u8 (*sreset_get_wifi_status)(struct adapter *padapter);
 
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h b/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h
index a29e695..d4f0d72 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h
@@ -25,7 +25,6 @@
 #include <rtw_sreset.h>
 
 void rtl8188e_silentreset_for_specific_platform(struct adapter *padapter);
-void rtl8188e_sreset_xmit_status_check(struct adapter *padapter);
 void rtl8188e_sreset_linked_status_check(struct adapter *padapter);
 
 #endif
-- 
1.7.10.4

