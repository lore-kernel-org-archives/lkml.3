Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaGBQyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:54:20 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55730 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680AbaGBQyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:54:17 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 39/48] staging: rtl8188eu: Remove function rtw_setdatarate_cmd()
Date: Wed,  2 Jul 2014 22:17:35 +0530
Message-Id: <1404319664-8327-39-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_setdatarate_cmd() enqueue _SetDataRate command but there is not
handler mapped in wlancmds[] to handle this command.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c       |   31 ------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h    |    2 --
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c |    7 ------
 3 files changed, 40 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 3e82ba4..be50d84 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -344,37 +344,6 @@ u8 rtw_sitesurvey_cmd(struct adapter  *padapter, struct ndis_802_11_ssid *ssid,
 	return res;
 }
 
-u8 rtw_setdatarate_cmd(struct adapter *padapter, u8 *rateset)
-{
-	struct cmd_obj *ph2c;
-	struct setdatarate_parm *pbsetdataratepara;
-	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
-	u8	res = _SUCCESS;
-
-
-	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (ph2c == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-
-	pbsetdataratepara = kzalloc(sizeof(struct setdatarate_parm), GFP_KERNEL);
-	if (pbsetdataratepara == NULL) {
-		kfree(ph2c);
-		res = _FAIL;
-		goto exit;
-	}
-
-	init_h2fwcmd_w_parm_no_rsp(ph2c, pbsetdataratepara, GEN_CMD_CODE(_SetDataRate));
-	pbsetdataratepara->mac_id = 5;
-	memcpy(pbsetdataratepara->datarates, rateset, NumRates);
-	res = rtw_enqueue_cmd(pcmdpriv, ph2c);
-exit:
-
-
-	return res;
-}
-
 void rtw_readtssi_cmdrsp_callback(struct adapter *padapter,  struct cmd_obj *pcmd)
 {
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 3f3f257..47fdef1 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -468,8 +468,6 @@ u8 rtw_disassoc_cmd(struct adapter *padapter, u32 deauth_timeout_ms,
 		    bool enqueue);
 u8 rtw_setopmode_cmd(struct adapter *padapter,
 		     enum ndis_802_11_network_infra networktype);
-u8 rtw_setdatarate_cmd(struct adapter *padapter, u8 *rateset);
-
 u8 rtw_addbareq_cmd(struct adapter *padapter, u8 tid, u8 *addr);
 
 u8 rtw_dynamic_chk_wk_cmd(struct adapter *adapter);
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 1f46ade..d9cee8c 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -1417,7 +1417,6 @@ static int rtw_wx_set_rate(struct net_device *dev,
 			      union iwreq_data *wrqu, char *extra)
 {
 	int i, ret = 0;
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	u8 datarates[NumRates];
 	u32	target_rate = wrqu->bitrate.value;
 	u32	fixed = wrqu->bitrate.fixed;
@@ -1490,12 +1489,6 @@ set_rate:
 		RT_TRACE(_module_rtl871x_ioctl_os_c, _drv_info_, ("datarate_inx =%d\n", datarates[i]));
 	}
 
-	if (rtw_setdatarate_cmd(padapter, datarates) != _SUCCESS) {
-		RT_TRACE(_module_rtl871x_ioctl_os_c, _drv_err_, ("rtw_wx_set_rate Fail!!!\n"));
-		ret = -1;
-	}
-
-
 	return ret;
 }
 
-- 
1.7.10.4

