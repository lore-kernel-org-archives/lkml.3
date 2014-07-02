Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbaGBQs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:48:58 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41290 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbaGBQs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:48:57 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/48] staging: rtl8188eu: Remove struct evt_priv and its uses
Date: Wed,  2 Jul 2014 22:16:57 +0530
Message-Id: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c2h_wk (work_struct) is naver scheduled to handle events,
so no use of keeping event data.
And also function rtw_hal_c2h_handler() responsible for handling c2h events,
is a dummy function.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c      |   86 -------------------------
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c |    4 --
 drivers/staging/rtl8188eu/include/cmd_osdep.h |    1 -
 drivers/staging/rtl8188eu/include/drv_types.h |    1 -
 drivers/staging/rtl8188eu/include/rtw_cmd.h   |   14 ----
 drivers/staging/rtl8188eu/os_dep/os_intfs.c   |    8 ---
 6 files changed, 114 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 310e916..293fda4 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -72,43 +72,6 @@ exit:
 	return res;
 }
 
-static void c2h_wk_callback(struct work_struct *work);
-
-int _rtw_init_evt_priv(struct evt_priv *pevtpriv)
-{
-	int res = _SUCCESS;
-
-
-	/* allocate DMA-able/Non-Page memory for cmd_buf and rsp_buf */
-	atomic_set(&pevtpriv->event_seq, 0);
-	pevtpriv->evt_done_cnt = 0;
-
-	INIT_WORK(&pevtpriv->c2h_wk, c2h_wk_callback);
-	pevtpriv->c2h_wk_alive = false;
-	pevtpriv->c2h_queue = rtw_cbuf_alloc(C2H_QUEUE_MAX_LEN+1);
-
-
-	return res;
-}
-
-void rtw_free_evt_priv(struct evt_priv *pevtpriv)
-{
-
-	RT_TRACE(_module_rtl871x_cmd_c_, _drv_info_, ("+rtw_free_evt_priv\n"));
-
-	cancel_work_sync(&pevtpriv->c2h_wk);
-	while (pevtpriv->c2h_wk_alive)
-		msleep(10);
-
-	while (!rtw_cbuf_empty(pevtpriv->c2h_queue)) {
-		void *c2h = rtw_cbuf_pop(pevtpriv->c2h_queue);
-		if (c2h != NULL && c2h != (void *)pevtpriv)
-			kfree(c2h);
-	}
-	RT_TRACE(_module_rtl871x_cmd_c_, _drv_info_, ("-rtw_free_evt_priv\n"));
-
-}
-
 void _rtw_free_cmd_priv(struct cmd_priv *pcmdpriv)
 {
 
@@ -175,13 +138,6 @@ u32 rtw_init_cmd_priv(struct cmd_priv *pcmdpriv)
 	return res;
 }
 
-u32 rtw_init_evt_priv(struct evt_priv *pevtpriv)
-{
-	int res;
-	res = _rtw_init_evt_priv(pevtpriv);
-	return res;
-}
-
 void rtw_free_cmd_priv(struct cmd_priv *pcmdpriv)
 {
 	RT_TRACE(_module_rtl871x_cmd_c_, _drv_info_, ("rtw_free_cmd_priv\n"));
@@ -1877,48 +1833,6 @@ exit:
 	return ret;
 }
 
-static void c2h_wk_callback(struct work_struct *work)
-{
-	struct evt_priv *evtpriv = container_of(work, struct evt_priv, c2h_wk);
-	struct adapter *adapter = container_of(evtpriv, struct adapter, evtpriv);
-	struct c2h_evt_hdr *c2h_evt;
-	c2h_id_filter ccx_id_filter = rtw_hal_c2h_id_filter_ccx(adapter);
-
-	evtpriv->c2h_wk_alive = true;
-
-	while (!rtw_cbuf_empty(evtpriv->c2h_queue)) {
-		c2h_evt = (struct c2h_evt_hdr *)
-			rtw_cbuf_pop(evtpriv->c2h_queue);
-		if (c2h_evt != NULL)
-			/* This C2H event is read, clear it */
-			c2h_evt_clear(adapter);
-		else {
-			c2h_evt = (struct c2h_evt_hdr *)rtw_malloc(16);
-			/* This C2H event is not read, read & clear now */
-			if (c2h_evt != NULL &&
-			    c2h_evt_read(adapter, (u8 *)c2h_evt) != _SUCCESS)
-				continue;
-		}
-
-		/* Special pointer to trigger c2h_evt_clear only */
-		if ((void *)c2h_evt == (void *)evtpriv)
-			continue;
-
-		if (!c2h_evt_exist(c2h_evt)) {
-			kfree(c2h_evt);
-			continue;
-		}
-
-		if (ccx_id_filter(c2h_evt->id) == true) {
-			/* Handle CCX report here */
-			rtw_hal_c2h_handler(adapter, c2h_evt);
-			kfree(c2h_evt);
-		}
-	}
-
-	evtpriv->c2h_wk_alive = false;
-}
-
 u8 rtw_drvextra_cmd_hdl(struct adapter *padapter, unsigned char *pbuf)
 {
 	struct drvextra_cmd_parm *pdrvextra_cmd;
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index c42d9fd..c4888b1 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -5461,7 +5461,6 @@ u8 mlme_evt_hdl(struct adapter *padapter, unsigned char *pbuf)
 	u16 evt_sz;
 	uint	*peventbuf;
 	void (*event_callback)(struct adapter *dev, u8 *pbuf);
-	struct evt_priv *pevt_priv = &(padapter->evtpriv);
 
 	peventbuf = (uint *)pbuf;
 	evt_sz = (u16)(*peventbuf&0xffff);
@@ -5482,15 +5481,12 @@ u8 mlme_evt_hdl(struct adapter *padapter, unsigned char *pbuf)
 		goto _abort_event_;
 	}
 
-	atomic_inc(&pevt_priv->event_seq);
-
 	peventbuf += 2;
 
 	if (peventbuf) {
 		event_callback = wlanevents[evt_code].event_callback;
 		event_callback(padapter, (u8 *)peventbuf);
 
-		pevt_priv->evt_done_cnt++;
 	}
 
 _abort_event_:
diff --git a/drivers/staging/rtl8188eu/include/cmd_osdep.h b/drivers/staging/rtl8188eu/include/cmd_osdep.h
index 5a8465e..7a93e1d 100644
--- a/drivers/staging/rtl8188eu/include/cmd_osdep.h
+++ b/drivers/staging/rtl8188eu/include/cmd_osdep.h
@@ -24,7 +24,6 @@
 #include <drv_types.h>
 
 extern int _rtw_init_cmd_priv(struct cmd_priv *pcmdpriv);
-extern int _rtw_init_evt_priv(struct evt_priv *pevtpriv);
 extern void _rtw_free_cmd_priv(struct cmd_priv *pcmdpriv);
 extern int _rtw_enqueue_cmd(struct __queue *queue, struct cmd_obj *obj);
 extern struct cmd_obj	*_rtw_dequeue_cmd(struct __queue *queue);
diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index fdf2c79..8f42d48 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -189,7 +189,6 @@ struct adapter {
 	struct	mlme_priv mlmepriv;
 	struct	mlme_ext_priv mlmeextpriv;
 	struct	cmd_priv	cmdpriv;
-	struct	evt_priv	evtpriv;
 	struct	xmit_priv	xmitpriv;
 	struct	recv_priv	recvpriv;
 	struct	sta_priv	stapriv;
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index d7fbff2..7a70f02 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -64,17 +64,6 @@ struct cmd_priv {
 	struct adapter *padapter;
 };
 
-struct	evt_priv {
-	struct work_struct c2h_wk;
-	bool c2h_wk_alive;
-	struct rtw_cbuf *c2h_queue;
-	#define C2H_QUEUE_MAX_LEN 10
-	atomic_t event_seq;
-	u8	*evt_buf;	/* shall be non-paged, and 4 bytes aligned */
-	u8	*evt_allocated_buf;
-	u32	evt_done_cnt;
-};
-
 #define init_h2fwcmd_w_parm_no_rsp(pcmd, pparm, code) \
 do {\
 	INIT_LIST_HEAD(&pcmd->list);\
@@ -103,10 +92,7 @@ int rtw_cmd_thread(void *context);
 u32 rtw_init_cmd_priv(struct cmd_priv *pcmdpriv);
 void rtw_free_cmd_priv(struct cmd_priv *pcmdpriv);
 
-u32 rtw_init_evt_priv(struct evt_priv *pevtpriv);
-void rtw_free_evt_priv(struct evt_priv *pevtpriv);
 void rtw_cmd_clr_isr(struct cmd_priv *pcmdpriv);
-void rtw_evt_notify_isr(struct evt_priv *pevtpriv);
 
 enum rtw_drvextra_cmd_id {
 	NONE_WK_CID,
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index aac9473..f331aae 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -852,12 +852,6 @@ u8 rtw_init_drv_sw(struct adapter *padapter)
 
 	padapter->cmdpriv.padapter = padapter;
 
-	if ((rtw_init_evt_priv(&padapter->evtpriv)) == _FAIL) {
-		RT_TRACE(_module_os_intfs_c_, _drv_err_, ("\n Can't init evt_priv\n"));
-		ret8 = _FAIL;
-		goto exit;
-	}
-
 	if (rtw_init_mlme_priv(padapter) == _FAIL) {
 		RT_TRACE(_module_os_intfs_c_, _drv_err_, ("\n Can't init mlme_priv\n"));
 		ret8 = _FAIL;
@@ -940,8 +934,6 @@ u8 rtw_free_drv_sw(struct adapter *padapter)
 
 	rtw_free_cmd_priv(&padapter->cmdpriv);
 
-	rtw_free_evt_priv(&padapter->evtpriv);
-
 	rtw_free_mlme_priv(&padapter->mlmepriv);
 	_rtw_free_xmit_priv(&padapter->xmitpriv);
 
-- 
1.7.10.4

