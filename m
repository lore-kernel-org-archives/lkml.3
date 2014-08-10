Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaHJOtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:49:18 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:61689 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaHJOr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:47:58 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 18/22] staging:rtl8188eu: Remove rtl8188e_IOL_exec_cmds_sync() and its wrapper function
Date: Sun, 10 Aug 2014 20:14:31 +0530
Message-Id: <1407681875-2611-18-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtl8188e_IOL_exec_cmds_sync() is a unused function.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/hal_intf.c          |   10 -------
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   32 ---------------------
 drivers/staging/rtl8188eu/include/hal_intf.h      |    7 -----
 3 files changed, 49 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index 2faa690..bc89e99 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -354,16 +354,6 @@ u8   rtw_hal_sreset_get_wifi_status(struct adapter *adapt)
 	return status;
 }
 
-int rtw_hal_iol_cmd(struct adapter  *adapter, struct xmit_frame *xmit_frame,
-		    u32 max_wating_ms, u32 bndy_cnt)
-{
-	if (adapter->HalFunc.IOL_exec_cmds_sync)
-		return adapter->HalFunc.IOL_exec_cmds_sync(adapter, xmit_frame,
-							   max_wating_ms,
-							   bndy_cnt);
-	return _FAIL;
-}
-
 void rtw_hal_notch_filter(struct adapter *adapter, bool enable)
 {
 	if (adapter->HalFunc.hal_notch_filter)
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index ea2ce8b..16525b0 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -108,36 +108,6 @@ static s32 iol_ioconfig(struct adapter *padapter, u8 iocfg_bndy)
 	return rst;
 }
 
-static int rtl8188e_IOL_exec_cmds_sync(struct adapter *adapter, struct xmit_frame *xmit_frame, u32 max_wating_ms, u32 bndy_cnt)
-{
-	struct pkt_attrib *pattrib = &xmit_frame->attrib;
-	u8 i;
-	int ret = _FAIL;
-
-	if (rtw_IOL_append_END_cmd(xmit_frame) != _SUCCESS)
-		goto exit;
-	if (rtw_usb_bulk_size_boundary(adapter, TXDESC_SIZE+pattrib->last_txcmdsz)) {
-		if (rtw_IOL_append_END_cmd(xmit_frame) != _SUCCESS)
-			goto exit;
-	}
-
-	dump_mgntframe_and_wait(adapter, xmit_frame, max_wating_ms);
-
-	iol_mode_enable(adapter, 1);
-	for (i = 0; i < bndy_cnt; i++) {
-		u8 page_no = 0;
-		page_no = i*2;
-		ret = iol_ioconfig(adapter, page_no);
-		if (ret != _SUCCESS)
-			break;
-	}
-	iol_mode_enable(adapter, 0);
-exit:
-	/* restore BCN_HEAD */
-	usb_write8(adapter, REG_TDECTRL+1, 0);
-	return ret;
-}
-
 #define MAX_REG_BOLCK_SIZE	196
 
 void _8051Reset88E(struct adapter *padapter)
@@ -279,8 +249,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 
 	pHalFunc->SetHalODMVarHandler = &rtl8188e_SetHalODMVar;
 
-	pHalFunc->IOL_exec_cmds_sync = &rtl8188e_IOL_exec_cmds_sync;
-
 	pHalFunc->hal_notch_filter = &hal_notch_filter_8188e;
 }
 
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index 56d5c50..1c5303e 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -228,10 +228,6 @@ struct hal_ops {
 	void (*sreset_init_value)(struct adapter *padapter);
 	u8 (*sreset_get_wifi_status)(struct adapter *padapter);
 
-	int (*IOL_exec_cmds_sync)(struct adapter *padapter,
-				  struct xmit_frame *frame, u32 max_wait,
-				  u32 bndy_cnt);
-
 	void (*hal_notch_filter)(struct adapter *adapter, bool enable);
 	void (*hal_reset_security_engine)(struct adapter *adapter);
 };
@@ -331,9 +327,6 @@ void	rtw_hal_antdiv_rssi_compared(struct adapter *padapter,
 void rtw_hal_sreset_init(struct adapter *padapter);
 u8   rtw_hal_sreset_get_wifi_status(struct adapter *padapter);
 
-int rtw_hal_iol_cmd(struct adapter  *adapter, struct xmit_frame *xmit_frame,
-		    u32 max_wating_ms, u32 bndy_cnt);
-
 void rtw_hal_notch_filter(struct adapter *adapter, bool enable);
 void rtw_hal_reset_security_engine(struct adapter *adapter);
 
-- 
1.7.10.4

