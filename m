Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaLTRHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 12:07:33 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:37579 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbaLTRH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 12:07:27 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: core: rtw_cmd.c:  Remove some unused functions
Date: Sat, 20 Dec 2014 18:10:13 +0100
Message-Id: <1419095413-10163-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
rtw_set_ch_cmd23a() rtw_cmd_clr_isr23a()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8723au/core/rtw_cmd.c    |   61 ---------------------------
 drivers/staging/rtl8723au/include/rtw_cmd.h |    2 -
 2 files changed, 63 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index 4eaa502..a69e9bd 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -245,11 +245,6 @@ exit:
 	return res;
 }
 
-void rtw_cmd_clr_isr23a(struct	cmd_priv *pcmdpriv)
-{
-	pcmdpriv->cmd_done_cnt++;
-}
-
 void rtw_free_cmd_obj23a(struct cmd_obj *pcmd)
 {
 
@@ -855,62 +850,6 @@ exit:
 	return res;
 }
 
-/*
- * This is only ever called from on_action_spct23a_ch_switch () which isn't
- * called from anywhere itself
- */
-int rtw_set_ch_cmd23a(struct rtw_adapter*padapter, u8 ch, u8 bw, u8 ch_offset,
-		      u8 enqueue)
-{
-	struct cmd_obj *pcmdobj;
-	struct set_ch_parm *set_ch_parm;
-	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
-	int res = _SUCCESS;
-
-	DBG_8723A("%s(%s): ch:%u, bw:%u, ch_offset:%u\n", __func__,
-		  padapter->pnetdev->name, ch, bw, ch_offset);
-
-	/* check input parameter */
-
-	/* prepare cmd parameter */
-	set_ch_parm = kzalloc(sizeof(*set_ch_parm), GFP_KERNEL);
-	if (!set_ch_parm) {
-		res = _FAIL;
-		goto exit;
-	}
-	set_ch_parm->ch = ch;
-	set_ch_parm->bw = bw;
-	set_ch_parm->ch_offset = ch_offset;
-
-	if (enqueue) {
-		/* need enqueue, prepare cmd_obj and enqueue */
-		pcmdobj = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-		if (!pcmdobj) {
-			kfree(set_ch_parm);
-			res = _FAIL;
-			goto exit;
-		}
-
-		init_h2fwcmd_w_parm_no_rsp(pcmdobj, set_ch_parm,
-					   GEN_CMD_CODE(_SetChannel));
-		res = rtw_enqueue_cmd23a(pcmdpriv, pcmdobj);
-	} else {
-		/* no need to enqueue, do the cmd hdl directly and
-		   free cmd parameter */
-		if (H2C_SUCCESS != set_ch_hdl23a(padapter, (u8 *)set_ch_parm))
-			res = _FAIL;
-
-		kfree(set_ch_parm);
-	}
-
-	/* do something based on res... */
-exit:
-
-	DBG_8723A("%s(%s): res:%u\n", __func__, padapter->pnetdev->name, res);
-
-	return res;
-}
-
 static void traffic_status_watchdog(struct rtw_adapter *padapter)
 {
 	u8 bEnterPS;
diff --git a/drivers/staging/rtl8723au/include/rtw_cmd.h b/drivers/staging/rtl8723au/include/rtw_cmd.h
index ef67068..2322b27 100644
--- a/drivers/staging/rtl8723au/include/rtw_cmd.h
+++ b/drivers/staging/rtl8723au/include/rtw_cmd.h
@@ -100,7 +100,6 @@ int rtw_init_cmd_priv23a(struct cmd_priv *pcmdpriv);
 
 u32 rtw_init_evt_priv23a (struct evt_priv *pevtpriv);
 void rtw_free_evt_priv23a (struct evt_priv *pevtpriv);
-void rtw_cmd_clr_isr23a(struct cmd_priv *pcmdpriv);
 void rtw_evt_notify_isr(struct evt_priv *pevtpriv);
 
 enum rtw_drvextra_cmd_id
@@ -715,7 +714,6 @@ int rtw_ps_cmd23a(struct rtw_adapter*padapter);
 int rtw_chk_hi_queue_cmd23a(struct rtw_adapter*padapter);
 #endif
 
-int rtw_set_ch_cmd23a(struct rtw_adapter*padapter, u8 ch, u8 bw, u8 ch_offset, u8 enqueue);
 int rtw_set_chplan_cmd(struct rtw_adapter*padapter, u8 chplan, u8 enqueue);
 int rtw_led_blink_cmd(struct rtw_adapter*padapter, struct led_8723a *pLed);
 int rtw_set_csa_cmd(struct rtw_adapter*padapter, u8 new_ch_no);
-- 
1.7.10.4

