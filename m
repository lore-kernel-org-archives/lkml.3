Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410AbaGARGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:06:19 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:58139 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347AbaGARGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:06:11 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 5/5] staging: rtl8188eu: Remove P2P support
Date: Tue,  1 Jul 2014 22:35:13 +0530
Message-Id: <1404234313-21634-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404234313-21634-1-git-send-email-navin.patidar@gmail.com>
References: <1404234313-21634-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/Makefile               |    1 -
 drivers/staging/rtl8188eu/core/rtw_ap.c          |    8 -
 drivers/staging/rtl8188eu/core/rtw_cmd.c         |   61 -
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c   |  206 --
 drivers/staging/rtl8188eu/core/rtw_mlme.c        |   17 +-
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c    | 3157 ++--------------------
 drivers/staging/rtl8188eu/core/rtw_p2p.c         | 2015 --------------
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c     |   36 +-
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c   |    9 -
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c     |   72 -
 drivers/staging/rtl8188eu/hal/usb_halinit.c      |    8 -
 drivers/staging/rtl8188eu/include/drv_types.h    |    6 -
 drivers/staging/rtl8188eu/include/ieee80211.h    |   13 -
 drivers/staging/rtl8188eu/include/rtl8188e_cmd.h |    4 -
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h |    4 -
 drivers/staging/rtl8188eu/include/rtw_cmd.h      |    3 -
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h |   12 -
 drivers/staging/rtl8188eu/include/rtw_p2p.h      |  135 -
 drivers/staging/rtl8188eu/include/sta_info.h     |   15 -
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c   |   72 +-
 drivers/staging/rtl8188eu/os_dep/os_intfs.c      |   28 -
 drivers/staging/rtl8188eu/os_dep/usb_intf.c      |    4 -
 22 files changed, 162 insertions(+), 5724 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/core/rtw_p2p.c
 delete mode 100644 drivers/staging/rtl8188eu/include/rtw_p2p.h

diff --git a/drivers/staging/rtl8188eu/Makefile b/drivers/staging/rtl8188eu/Makefile
index 227dcdbe..aeebf93 100644
--- a/drivers/staging/rtl8188eu/Makefile
+++ b/drivers/staging/rtl8188eu/Makefile
@@ -10,7 +10,6 @@ r8188eu-y :=				\
 		core/rtw_mlme.o		\
 		core/rtw_mlme_ext.o	\
 		core/rtw_pwrctrl.o	\
-		core/rtw_p2p.o		\
 		core/rtw_recv.o		\
 		core/rtw_rf.o		\
 		core/rtw_security.o	\
diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8188eu/core/rtw_ap.c
index 768a359..9224e02 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -723,9 +723,6 @@ static void start_bss_network(struct adapter *padapter, u8 *pbuf)
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 	struct wlan_bssid_ex *pnetwork_mlmeext = &(pmlmeinfo->network);
 	struct HT_info_element *pht_info = NULL;
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-#endif /* CONFIG_88EU_P2P */
 
 	bcn_interval = (u16)pnetwork->Configuration.BeaconPeriod;
 	cur_channel = pnetwork->Configuration.DSConfig;
@@ -827,11 +824,6 @@ static void start_bss_network(struct adapter *padapter, u8 *pbuf)
 	/* let pnetwork_mlmeext == pnetwork_mlme. */
 	memcpy(pnetwork_mlmeext, pnetwork, pnetwork->Length);
 
-#ifdef CONFIG_88EU_P2P
-	memcpy(pwdinfo->p2p_group_ssid, pnetwork->Ssid.Ssid, pnetwork->Ssid.SsidLength);
-	pwdinfo->p2p_group_ssid_len = pnetwork->Ssid.SsidLength;
-#endif /* CONFIG_88EU_P2P */
-
 	if (pmlmeext->bstart_bss) {
 		update_beacon(padapter, _TIM_IE_, NULL, false);
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 82eb481..310e916 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -434,9 +434,6 @@ u8 rtw_sitesurvey_cmd(struct adapter  *padapter, struct ndis_802_11_ssid *ssid,
 	if (check_fwstate(pmlmepriv, _FW_LINKED) == true)
 		rtw_lps_ctrl_wk_cmd(padapter, LPS_CTRL_SCAN, 1);
 
-	if (check_fwstate(pmlmepriv, _FW_LINKED) == true)
-		p2p_ps_wk_cmd(padapter, P2P_PS_SCAN, 1);
-
 	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL)
 		return _FAIL;
@@ -1715,47 +1712,6 @@ static void power_saving_wk_hdl(struct adapter *padapter, u8 *pbuf, int sz)
 	 rtw_ps_processor(padapter);
 }
 
-#ifdef CONFIG_88EU_P2P
-u8 p2p_protocol_wk_cmd(struct adapter *padapter, int intCmdType)
-{
-	struct cmd_obj	*ph2c;
-	struct drvextra_cmd_parm	*pdrvextra_cmd_parm;
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
-	u8	res = _SUCCESS;
-
-
-	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
-		return res;
-
-	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (ph2c == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-
-	pdrvextra_cmd_parm = kzalloc(sizeof(struct drvextra_cmd_parm), GFP_KERNEL);
-	if (pdrvextra_cmd_parm == NULL) {
-		kfree(ph2c);
-		res = _FAIL;
-		goto exit;
-	}
-
-	pdrvextra_cmd_parm->ec_id = P2P_PROTO_WK_CID;
-	pdrvextra_cmd_parm->type_size = intCmdType; /* As the command tppe. */
-	pdrvextra_cmd_parm->pbuf = NULL;	    /* Must be NULL here */
-
-	init_h2fwcmd_w_parm_no_rsp(ph2c, pdrvextra_cmd_parm, GEN_CMD_CODE(_Set_Drv_Extra));
-
-	res = rtw_enqueue_cmd(pcmdpriv, ph2c);
-
-exit:
-
-
-	return res;
-}
-#endif /* CONFIG_88EU_P2P */
-
 u8 rtw_ps_cmd(struct adapter *padapter)
 {
 	struct cmd_obj		*ppscmd;
@@ -1957,11 +1913,6 @@ static void c2h_wk_callback(struct work_struct *work)
 			/* Handle CCX report here */
 			rtw_hal_c2h_handler(adapter, c2h_evt);
 			kfree(c2h_evt);
-		} else {
-#ifdef CONFIG_88EU_P2P
-			/* Enqueue into cmd_thread for others */
-			rtw_c2h_wk_cmd(adapter, (u8 *)c2h_evt);
-#endif
 		}
 	}
 
@@ -1993,18 +1944,6 @@ u8 rtw_drvextra_cmd_hdl(struct adapter *padapter, unsigned char *pbuf)
 	case ANT_SELECT_WK_CID:
 		antenna_select_wk_hdl(padapter, pdrvextra_cmd->type_size);
 		break;
-#ifdef CONFIG_88EU_P2P
-	case P2P_PS_WK_CID:
-		p2p_ps_wk_hdl(padapter, pdrvextra_cmd->type_size);
-		break;
-	case P2P_PROTO_WK_CID:
-		/*
-		 * Commented by Albert 2011/07/01
-		 * I used the type_size as the type command
-		 */
-		p2p_protocol_wk_hdl(padapter, pdrvextra_cmd->type_size);
-		break;
-#endif
 #ifdef CONFIG_88EU_AP_MODE
 	case CHECK_HIQ_WK_CID:
 		rtw_chk_hi_queue_hdl(padapter);
diff --git a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
index 24665d6..755d3ef 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
@@ -1110,9 +1110,6 @@ void dump_ies(u8 *buf, u32 buf_len)
 		len = *(pos+1);
 
 		DBG_88E("%s ID:%u, LEN:%u\n", __func__, id, len);
-		#ifdef CONFIG_88EU_P2P
-		dump_p2p_ie(pos, len);
-		#endif
 		dump_wps_ie(pos, len);
 
 		pos += (2 + len);
@@ -1140,209 +1137,6 @@ void dump_wps_ie(u8 *ie, u32 ie_len)
 	}
 }
 
-#ifdef CONFIG_88EU_P2P
-void dump_p2p_ie(u8 *ie, u32 ie_len)
-{
-	u8 *pos = (u8 *)ie;
-	u8 id;
-	u16 len;
-	u8 *p2p_ie;
-	uint p2p_ielen;
-
-	p2p_ie = rtw_get_p2p_ie(ie, ie_len, NULL, &p2p_ielen);
-	if (p2p_ie != ie || p2p_ielen == 0)
-		return;
-
-	pos += 6;
-	while (pos-ie < ie_len) {
-		id = *pos;
-		len = get_unaligned_le16(pos+1);
-		DBG_88E("%s ID:%u, LEN:%u\n", __func__, id, len);
-		pos += (3+len);
-	}
-}
-
-/**
- * rtw_get_p2p_ie - Search P2P IE from a series of IEs
- * @in_ie: Address of IEs to search
- * @in_len: Length limit from in_ie
- * @p2p_ie: If not NULL and P2P IE is found, P2P IE will be copied to the buf starting from p2p_ie
- * @p2p_ielen: If not NULL and P2P IE is found, will set to the length of the entire P2P IE
- *
- * Returns: The address of the P2P IE found, or NULL
- */
-u8 *rtw_get_p2p_ie(u8 *in_ie, int in_len, u8 *p2p_ie, uint *p2p_ielen)
-{
-	uint cnt = 0;
-	u8 *p2p_ie_ptr;
-	u8 eid, p2p_oui[4] = {0x50, 0x6F, 0x9A, 0x09};
-
-	if (p2p_ielen != NULL)
-		*p2p_ielen = 0;
-
-	while (cnt < in_len) {
-		eid = in_ie[cnt];
-		if ((in_len < 0) || (cnt > MAX_IE_SZ)) {
-			dump_stack();
-			return NULL;
-		}
-		if ((eid == _VENDOR_SPECIFIC_IE_) && (!memcmp(&in_ie[cnt+2], p2p_oui, 4))) {
-			p2p_ie_ptr = in_ie + cnt;
-
-			if (p2p_ie != NULL)
-				memcpy(p2p_ie, &in_ie[cnt], in_ie[cnt + 1] + 2);
-			if (p2p_ielen != NULL)
-				*p2p_ielen = in_ie[cnt + 1] + 2;
-			return p2p_ie_ptr;
-		} else {
-			cnt += in_ie[cnt + 1] + 2; /* goto next */
-		}
-	}
-	return NULL;
-}
-
-/**
- * rtw_get_p2p_attr - Search a specific P2P attribute from a given P2P IE
- * @p2p_ie: Address of P2P IE to search
- * @p2p_ielen: Length limit from p2p_ie
- * @target_attr_id: The attribute ID of P2P attribute to search
- * @buf_attr: If not NULL and the P2P attribute is found, P2P attribute will be copied to the buf starting from buf_attr
- * @len_attr: If not NULL and the P2P attribute is found, will set to the length of the entire P2P attribute
- *
- * Returns: the address of the specific WPS attribute found, or NULL
- */
-u8 *rtw_get_p2p_attr(u8 *p2p_ie, uint p2p_ielen, u8 target_attr_id , u8 *buf_attr, u32 *len_attr)
-{
-	u8 *attr_ptr = NULL;
-	u8 *target_attr_ptr = NULL;
-	u8 p2p_oui[4] = {0x50, 0x6F, 0x9A, 0x09};
-
-	if (len_attr)
-		*len_attr = 0;
-
-	if (!p2p_ie || (p2p_ie[0] != _VENDOR_SPECIFIC_IE_) ||
-	    (memcmp(p2p_ie + 2, p2p_oui , 4)))
-		return attr_ptr;
-
-	/*  6 = 1(Element ID) + 1(Length) + 3 (OUI) + 1(OUI Type) */
-	attr_ptr = p2p_ie + 6; /* goto first attr */
-
-	while (attr_ptr - p2p_ie < p2p_ielen) {
-		/*  3 = 1(Attribute ID) + 2(Length) */
-		u8 attr_id = *attr_ptr;
-		u16 attr_data_len = get_unaligned_le16(attr_ptr + 1);
-		u16 attr_len = attr_data_len + 3;
-
-		if (attr_id == target_attr_id) {
-			target_attr_ptr = attr_ptr;
-
-			if (buf_attr)
-				memcpy(buf_attr, attr_ptr, attr_len);
-			if (len_attr)
-				*len_attr = attr_len;
-			break;
-		} else {
-			attr_ptr += attr_len; /* goto next */
-		}
-	}
-	return target_attr_ptr;
-}
-
-/**
- * rtw_get_p2p_attr_content - Search a specific P2P attribute content from a given P2P IE
- * @p2p_ie: Address of P2P IE to search
- * @p2p_ielen: Length limit from p2p_ie
- * @target_attr_id: The attribute ID of P2P attribute to search
- * @buf_content: If not NULL and the P2P attribute is found, P2P attribute content will be copied to the buf starting from buf_content
- * @len_content: If not NULL and the P2P attribute is found, will set to the length of the P2P attribute content
- *
- * Returns: the address of the specific P2P attribute content found, or NULL
- */
-u8 *rtw_get_p2p_attr_content(u8 *p2p_ie, uint p2p_ielen, u8 target_attr_id , u8 *buf_content, uint *len_content)
-{
-	u8 *attr_ptr;
-	u32 attr_len;
-
-	if (len_content)
-		*len_content = 0;
-
-	attr_ptr = rtw_get_p2p_attr(p2p_ie, p2p_ielen, target_attr_id, NULL, &attr_len);
-
-	if (attr_ptr && attr_len) {
-		if (buf_content)
-			memcpy(buf_content, attr_ptr+3, attr_len-3);
-
-		if (len_content)
-			*len_content = attr_len-3;
-
-		return attr_ptr+3;
-	}
-
-	return NULL;
-}
-
-u32 rtw_set_p2p_attr_content(u8 *pbuf, u8 attr_id, u16 attr_len, u8 *pdata_attr)
-{
-	u32 a_len;
-
-	*pbuf = attr_id;
-
-	*(u16 *)(pbuf + 1) = cpu_to_le16(attr_len);
-
-	if (pdata_attr)
-		memcpy(pbuf + 3, pdata_attr, attr_len);
-
-	a_len = attr_len + 3;
-
-	return a_len;
-}
-
-static uint rtw_p2p_attr_remove(u8 *ie, uint ielen_ori, u8 attr_id)
-{
-	u8 *target_attr;
-	u32 target_attr_len;
-	uint ielen = ielen_ori;
-
-	while (1) {
-		target_attr = rtw_get_p2p_attr(ie, ielen, attr_id, NULL, &target_attr_len);
-		if (target_attr && target_attr_len) {
-			u8 *next_attr = target_attr+target_attr_len;
-			uint remain_len = ielen-(next_attr-ie);
-
-			memset(target_attr, 0, target_attr_len);
-			memcpy(target_attr, next_attr, remain_len);
-			memset(target_attr+remain_len, 0, target_attr_len);
-			*(ie+1) -= target_attr_len;
-			ielen -= target_attr_len;
-		} else {
-			break;
-		}
-	}
-	return ielen;
-}
-
-void rtw_wlan_bssid_ex_remove_p2p_attr(struct wlan_bssid_ex *bss_ex, u8 attr_id)
-{
-	u8 *p2p_ie;
-	uint p2p_ielen, p2p_ielen_ori;
-
-	p2p_ie = rtw_get_p2p_ie(bss_ex->IEs+_FIXED_IE_LENGTH_, bss_ex->IELength-_FIXED_IE_LENGTH_, NULL, &p2p_ielen_ori);
-	if (p2p_ie) {
-		p2p_ielen = rtw_p2p_attr_remove(p2p_ie, p2p_ielen_ori, attr_id);
-		if (p2p_ielen != p2p_ielen_ori) {
-			u8 *next_ie_ori = p2p_ie+p2p_ielen_ori;
-			u8 *next_ie = p2p_ie+p2p_ielen;
-			uint remain_len = bss_ex->IELength-(next_ie_ori-bss_ex->IEs);
-
-			memcpy(next_ie, next_ie_ori, remain_len);
-			memset(next_ie+remain_len, 0, p2p_ielen_ori-p2p_ielen);
-			bss_ex->IELength -= p2p_ielen_ori-p2p_ielen;
-		}
-	}
-}
-
-#endif /* CONFIG_88EU_P2P */
-
 /* Baron adds to avoid FreeBSD warning */
 int ieee80211_is_empty_essid(const char *essid, int essid_len)
 {
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 45e2739..1eef47d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -597,9 +597,6 @@ exit:
 static void rtw_add_network(struct adapter *adapter,
 			    struct wlan_bssid_ex *pnetwork)
 {
-#if defined(CONFIG_88EU_P2P)
-	rtw_wlan_bssid_ex_remove_p2p_attr(pnetwork, P2P_ATTR_GROUP_INFO);
-#endif
 	update_current_network(adapter, pnetwork);
 	rtw_update_scanned_network(adapter, pnetwork);
 }
@@ -791,9 +788,6 @@ void rtw_surveydone_event_callback(struct adapter	*adapter, u8 *pbuf)
 
 	spin_unlock_bh(&pmlmepriv->lock);
 
-	if (check_fwstate(pmlmepriv, _FW_LINKED) == true)
-		p2p_ps_wk_cmd(adapter, P2P_PS_SCAN_DONE, 0);
-
 	rtw_os_xmit_schedule(adapter);
 
 	pmlmeext = &adapter->mlmeextpriv;
@@ -936,7 +930,6 @@ void rtw_indicate_disconnect(struct adapter *padapter)
 		rtw_led_control(padapter, LED_CTL_NO_LINK);
 		rtw_clear_scan_deny(padapter);
 	}
-	p2p_ps_wk_cmd(padapter, P2P_PS_DISABLE, 1);
 
 	rtw_lps_ctrl_wk_cmd(padapter, LPS_CTRL_DISCONNECT, 1);
 }
@@ -1521,14 +1514,8 @@ void rtw_dynamic_check_timer_handlder(struct adapter *adapter)
 	rtw_dynamic_chk_wk_cmd(adapter);
 
 	if (pregistrypriv->wifi_spec == 1) {
-#ifdef CONFIG_88EU_P2P
-		struct wifidirect_info *pwdinfo = &adapter->wdinfo;
-		if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
-#endif
-		{
-			/* auto site survey */
-			rtw_auto_scan_handler(adapter);
-		}
+		/* auto site survey */
+		rtw_auto_scan_handler(adapter);
 	}
 }
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index dc194324..c42d9fd 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -508,23 +508,6 @@ void mgt_dispatcher(struct adapter *padapter, struct recv_frame *precv_frame)
 #endif
 }
 
-#ifdef CONFIG_88EU_P2P
-static u32 p2p_listen_state_process(struct adapter *padapter, unsigned char *da)
-{
-	bool response = true;
-
-	/*	do nothing if the device name is empty */
-	if (!padapter->wdinfo.device_name_len)
-		response = false;
-
-	if (response)
-		issue_probersp_p2p(padapter, da);
-
-	return _SUCCESS;
-}
-#endif /* CONFIG_88EU_P2P */
-
-
 /****************************************************************************
 
 Following are the callback functions for each subtype of the management frames
@@ -543,43 +526,6 @@ unsigned int OnProbeReq(struct adapter *padapter, struct recv_frame *precv_frame
 	uint len = precv_frame->len;
 	u8 is_valid_p2p_probereq = false;
 
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-	u8 wifi_test_chk_rate = 1;
-
-	if (!rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE) &&
-	    !rtw_p2p_chk_state(pwdinfo, P2P_STATE_IDLE) &&
-	    !rtw_p2p_chk_role(pwdinfo, P2P_ROLE_CLIENT) &&
-	    !rtw_p2p_chk_state(pwdinfo, P2P_STATE_FIND_PHASE_SEARCH) &&
-	    !rtw_p2p_chk_state(pwdinfo, P2P_STATE_SCAN)) {
-		/*	mcs_rate = 0 -> CCK 1M rate */
-		/*	mcs_rate = 1 -> CCK 2M rate */
-		/*	mcs_rate = 2 -> CCK 5.5M rate */
-		/*	mcs_rate = 3 -> CCK 11M rate */
-		/*	In the P2P mode, the driver should not support the CCK rate */
-
-		/*	Commented by Kurt 2012/10/16 */
-		/*	IOT issue: Google Nexus7 use 1M rate to send p2p_probe_req after GO nego completed and Nexus7 is client */
-		if (wifi_test_chk_rate == 1) {
-			is_valid_p2p_probereq = process_probe_req_p2p_ie(pwdinfo, pframe, len);
-			if (is_valid_p2p_probereq) {
-				if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_DEVICE)) {
-					/*  FIXME */
-					report_survey_event(padapter, precv_frame);
-					p2p_listen_state_process(padapter,  get_sa(pframe));
-
-					return _SUCCESS;
-				}
-
-				if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO))
-					goto _continue;
-			}
-		}
-	}
-
-_continue:
-#endif /* CONFIG_88EU_P2P */
-
 	if (check_fwstate(pmlmepriv, WIFI_STATION_STATE))
 		return _SUCCESS;
 
@@ -611,48 +557,6 @@ _issue_probersp:
 unsigned int OnProbeRsp(struct adapter *padapter, struct recv_frame *precv_frame)
 {
 	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info	*pwdinfo = &padapter->wdinfo;
-	u8 *pframe = precv_frame->rx_data;
-#endif
-
-#ifdef CONFIG_88EU_P2P
-	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_TX_PROVISION_DIS_REQ)) {
-		if (pwdinfo->tx_prov_disc_info.benable) {
-			if (!memcmp(pwdinfo->tx_prov_disc_info.peerIFAddr, GetAddr2Ptr(pframe), ETH_ALEN)) {
-				if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_CLIENT)) {
-					pwdinfo->tx_prov_disc_info.benable = false;
-					issue_p2p_provision_request(padapter,
-								    pwdinfo->tx_prov_disc_info.ssid.Ssid,
-								    pwdinfo->tx_prov_disc_info.ssid.SsidLength,
-								    pwdinfo->tx_prov_disc_info.peerDevAddr);
-				} else if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_DEVICE) || rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO)) {
-					pwdinfo->tx_prov_disc_info.benable = false;
-					issue_p2p_provision_request(padapter, NULL, 0,
-								    pwdinfo->tx_prov_disc_info.peerDevAddr);
-				}
-			}
-		}
-		return _SUCCESS;
-	} else if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_GONEGO_ING)) {
-		if (pwdinfo->nego_req_info.benable) {
-			DBG_88E("[%s] P2P State is GONEGO ING!\n", __func__);
-			if (!memcmp(pwdinfo->nego_req_info.peerDevAddr, GetAddr2Ptr(pframe), ETH_ALEN)) {
-				pwdinfo->nego_req_info.benable = false;
-				issue_p2p_GO_request(padapter, pwdinfo->nego_req_info.peerDevAddr);
-			}
-		}
-	} else if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_TX_INVITE_REQ)) {
-		if (pwdinfo->invitereq_info.benable) {
-			DBG_88E("[%s] P2P_STATE_TX_INVITE_REQ!\n", __func__);
-			if (!memcmp(pwdinfo->invitereq_info.peer_macaddr, GetAddr2Ptr(pframe), ETH_ALEN)) {
-				pwdinfo->invitereq_info.benable = false;
-				issue_p2p_invitation_request(padapter, pwdinfo->invitereq_info.peer_macaddr);
-			}
-		}
-	}
-#endif
-
 
 	if (pmlmeext->sitesurvey_res.state == SCAN_PROCESS) {
 		report_survey_event(padapter, precv_frame);
@@ -717,7 +621,6 @@ unsigned int OnBeacon(struct adapter *padapter, struct recv_frame *precv_frame)
 				/* todo: the timer is used instead of the number of the beacon received */
 				if ((sta_rx_pkts(psta) & 0xf) == 0)
 					update_beacon_info(padapter, pframe, len, psta);
-				process_p2p_ps_ie(padapter, (pframe + WLAN_HDR_A3_LEN), (len - WLAN_HDR_A3_LEN));
 			}
 		} else if ((pmlmeinfo->state&0x03) == WIFI_FW_ADHOC_STATE) {
 			psta = rtw_get_stainfo(pstapriv, GetAddr2Ptr(pframe));
@@ -1021,12 +924,6 @@ unsigned int OnAssocReq(struct adapter *padapter, struct recv_frame *precv_frame
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	u8 *pframe = precv_frame->rx_data;
 	uint pkt_len = precv_frame->len;
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-	u8 p2p_status_code = P2P_STATUS_SUCCESS;
-	u8 *p2pie;
-	u32 p2pielen = 0;
-#endif /* CONFIG_88EU_P2P */
 
 	if ((pmlmeinfo->state&0x03) != WIFI_FW_AP_STATE)
 		return _FAIL;
@@ -1356,23 +1253,6 @@ unsigned int OnAssocReq(struct adapter *padapter, struct recv_frame *precv_frame
 	if (status != _STATS_SUCCESSFUL_)
 		goto OnAssocReqFail;
 
-#ifdef CONFIG_88EU_P2P
-	pstat->is_p2p_device = false;
-	if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO)) {
-		p2pie = rtw_get_p2p_ie(pframe + WLAN_HDR_A3_LEN + ie_offset , pkt_len - WLAN_HDR_A3_LEN - ie_offset , NULL, &p2pielen);
-		if (p2pie) {
-			pstat->is_p2p_device = true;
-			p2p_status_code = (u8)process_assoc_req_p2p_ie(pwdinfo, pframe, pkt_len, pstat);
-			if (p2p_status_code > 0) {
-				pstat->p2p_status_code = p2p_status_code;
-				status = _STATS_CAP_FAIL_;
-				goto OnAssocReqFail;
-			}
-		}
-	}
-	pstat->p2p_status_code = p2p_status_code;
-#endif /* CONFIG_88EU_P2P */
-
 	/* TODO: identify_proprietary_vendor_ie(); */
 	/*  Realtek proprietary IE */
 	/*  identify if this is Broadcom sta */
@@ -1566,22 +1446,12 @@ unsigned int OnDeAuth(struct adapter *padapter, struct recv_frame *precv_frame)
 	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 	u8 *pframe = precv_frame->rx_data;
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
-#endif /* CONFIG_88EU_P2P */
 
 	/* check A3 */
 	if (memcmp(GetAddr3Ptr(pframe), get_my_bssid(&pmlmeinfo->network),
 		   ETH_ALEN))
 		return _SUCCESS;
 
-#ifdef CONFIG_88EU_P2P
-	if (pwdinfo->rx_invitereq_info.scan_op_ch_only) {
-		del_timer_sync(&pwdinfo->reset_ch_sitesurvey);
-		_set_timer(&pwdinfo->reset_ch_sitesurvey, 10);
-	}
-#endif /* CONFIG_88EU_P2P */
-
 	reason = le16_to_cpu(*(__le16 *)(pframe + WLAN_HDR_A3_LEN));
 
 	DBG_88E("%s Reason code(%d)\n", __func__, reason);
@@ -1630,22 +1500,12 @@ unsigned int OnDisassoc(struct adapter *padapter, struct recv_frame *precv_frame
 	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 	u8 *pframe = precv_frame->rx_data;
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
-#endif /* CONFIG_88EU_P2P */
 
 	/* check A3 */
 	if (memcmp(GetAddr3Ptr(pframe), get_my_bssid(&pmlmeinfo->network),
 		   ETH_ALEN))
 		return _SUCCESS;
 
-#ifdef CONFIG_88EU_P2P
-	if (pwdinfo->rx_invitereq_info.scan_op_ch_only) {
-		del_timer_sync(&pwdinfo->reset_ch_sitesurvey);
-		_set_timer(&pwdinfo->reset_ch_sitesurvey, 10);
-	}
-#endif /* CONFIG_88EU_P2P */
-
 	reason = le16_to_cpu(*(__le16 *)(pframe + WLAN_HDR_A3_LEN));
 
 	DBG_88E("%s Reason code(%d)\n", __func__, reason);
@@ -1723,2139 +1583,102 @@ unsigned int on_action_spct(struct adapter *padapter, struct recv_frame *precv_f
 	case RTW_WLAN_ACTION_SPCT_CHL_SWITCH:
 		break;
 	default:
-		break;
-	}
-
-exit:
-	return ret;
-}
-
-unsigned int OnAction_qos(struct adapter *padapter, struct recv_frame *precv_frame)
-{
-	return _SUCCESS;
-}
-
-unsigned int OnAction_dls(struct adapter *padapter, struct recv_frame *precv_frame)
-{
-	return _SUCCESS;
-}
-
-unsigned int OnAction_back(struct adapter *padapter, struct recv_frame *precv_frame)
-{
-	u8 *addr;
-	struct sta_info *psta = NULL;
-	struct recv_reorder_ctrl *preorder_ctrl;
-	unsigned char		*frame_body;
-	unsigned char		category, action;
-	unsigned short	tid, status, reason_code = 0;
-	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
-	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
-	u8 *pframe = precv_frame->rx_data;
-	struct sta_priv *pstapriv = &padapter->stapriv;
-	/* check RA matches or not */
-	if (memcmp(myid(&(padapter->eeprompriv)), GetAddr1Ptr(pframe),
-		   ETH_ALEN))/* for if1, sta/ap mode */
-		return _SUCCESS;
-
-	DBG_88E("%s\n", __func__);
-
-	if ((pmlmeinfo->state&0x03) != WIFI_FW_AP_STATE)
-		if (!(pmlmeinfo->state & WIFI_FW_ASSOC_SUCCESS))
-			return _SUCCESS;
-
-	addr = GetAddr2Ptr(pframe);
-	psta = rtw_get_stainfo(pstapriv, addr);
-
-	if (psta == NULL)
-		return _SUCCESS;
-
-	frame_body = (unsigned char *)(pframe + sizeof(struct rtw_ieee80211_hdr_3addr));
-
-	category = frame_body[0];
-	if (category == RTW_WLAN_CATEGORY_BACK) { /*  representing Block Ack */
-		if (!pmlmeinfo->HT_enable)
-			return _SUCCESS;
-		action = frame_body[1];
-		DBG_88E("%s, action=%d\n", __func__, action);
-		switch (action) {
-		case RTW_WLAN_ACTION_ADDBA_REQ: /* ADDBA request */
-			memcpy(&(pmlmeinfo->ADDBA_req), &(frame_body[2]), sizeof(struct ADDBA_request));
-			process_addba_req(padapter, (u8 *)&(pmlmeinfo->ADDBA_req), addr);
-
-			if (pmlmeinfo->bAcceptAddbaReq)
-				issue_action_BA(padapter, addr, RTW_WLAN_ACTION_ADDBA_RESP, 0);
-			else
-				issue_action_BA(padapter, addr, RTW_WLAN_ACTION_ADDBA_RESP, 37);/* reject ADDBA Req */
-			break;
-		case RTW_WLAN_ACTION_ADDBA_RESP: /* ADDBA response */
-			status = get_unaligned_le16(&frame_body[3]);
-			tid = ((frame_body[5] >> 2) & 0x7);
-			if (status == 0) {	/* successful */
-				DBG_88E("agg_enable for TID=%d\n", tid);
-				psta->htpriv.agg_enable_bitmap |= 1 << tid;
-				psta->htpriv.candidate_tid_bitmap &= ~BIT(tid);
-			} else {
-				psta->htpriv.agg_enable_bitmap &= ~BIT(tid);
-			}
-			break;
-		case RTW_WLAN_ACTION_DELBA: /* DELBA */
-			if ((frame_body[3] & BIT(3)) == 0) {
-				psta->htpriv.agg_enable_bitmap &= ~(1 << ((frame_body[3] >> 4) & 0xf));
-				psta->htpriv.candidate_tid_bitmap &= ~(1 << ((frame_body[3] >> 4) & 0xf));
-				reason_code = get_unaligned_le16(&frame_body[4]);
-			} else if ((frame_body[3] & BIT(3)) == BIT(3)) {
-				tid = (frame_body[3] >> 4) & 0x0F;
-				preorder_ctrl =  &psta->recvreorder_ctrl[tid];
-				preorder_ctrl->enable = false;
-				preorder_ctrl->indicate_seq = 0xffff;
-			}
-			DBG_88E("%s(): DELBA: %x(%x)\n", __func__, pmlmeinfo->agg_enable_bitmap, reason_code);
-			/* todo: how to notify the host while receiving DELETE BA */
-			break;
-		default:
-			break;
-		}
-	}
-	return _SUCCESS;
-}
-
-#ifdef CONFIG_88EU_P2P
-
-static int get_reg_classes_full_count(struct p2p_channels *channel_list)
-{
-	int cnt = 0;
-	int i;
-
-	for (i = 0; i < channel_list->reg_classes; i++) {
-		cnt += channel_list->reg_class[i].channels;
-	}
-
-	return cnt;
-}
-
-void issue_p2p_GO_request(struct adapter *padapter, u8 *raddr)
-{
-	unsigned char category = RTW_WLAN_CATEGORY_PUBLIC;
-	u8 action = P2P_PUB_ACTION_ACTION;
-	__be32 p2poui = cpu_to_be32(P2POUI);
-	u8 oui_subtype = P2P_GO_NEGO_REQ;
-	u8 wpsie[255] = { 0x00 }, p2pie[255] = { 0x00 };
-	u8 wpsielen = 0, p2pielen = 0;
-	u16 len_channellist_attr = 0;
-	struct xmit_frame *pmgntframe;
-	struct pkt_attrib *pattrib;
-	unsigned char *pframe;
-	struct rtw_ieee80211_hdr	*pwlanhdr;
-	__le16 *fctrl;
-	struct xmit_priv *pxmitpriv = &(padapter->xmitpriv);
-	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-
-	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
-		return;
-
-	DBG_88E("[%s] In\n", __func__);
-	/* update attribute */
-	pattrib = &pmgntframe->attrib;
-	update_mgntframe_attrib(padapter, pattrib);
-
-	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
-
-	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
-	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
-
-	fctrl = &(pwlanhdr->frame_ctl);
-	*(fctrl) = 0;
-
-	memcpy(pwlanhdr->addr1, raddr, ETH_ALEN);
-	memcpy(pwlanhdr->addr2, myid(&(padapter->eeprompriv)), ETH_ALEN);
-	memcpy(pwlanhdr->addr3, myid(&(padapter->eeprompriv)), ETH_ALEN);
-
-	SetSeqNum(pwlanhdr, pmlmeext->mgnt_seq);
-	pmlmeext->mgnt_seq++;
-	SetFrameSubType(pframe, WIFI_ACTION);
-
-	pframe += sizeof(struct rtw_ieee80211_hdr_3addr);
-	pattrib->pktlen = sizeof(struct rtw_ieee80211_hdr_3addr);
-
-	pframe = rtw_set_fixed_ie(pframe, 1, &(category), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(action), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 4, (unsigned char *)&(p2poui), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(oui_subtype), &(pattrib->pktlen));
-	pwdinfo->negotiation_dialog_token = 1;	/*	Initialize the dialog value */
-	pframe = rtw_set_fixed_ie(pframe, 1, &pwdinfo->negotiation_dialog_token, &(pattrib->pktlen));
-
-
-
-	/*	WPS Section */
-	wpsielen = 0;
-	/*	WPS OUI */
-	*(__be32 *)(wpsie) = cpu_to_be32(WPSOUI);
-	wpsielen += 4;
-
-	/*	WPS version */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_VER1);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0001);
-	wpsielen += 2;
-
-	/*	Value: */
-	wpsie[wpsielen++] = WPS_VERSION_1;	/*	Version 1.0 */
-
-	/*	Device Password ID */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_DEVICE_PWID);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0002);
-	wpsielen += 2;
-
-	/*	Value: */
-
-	if (pwdinfo->ui_got_wps_info == P2P_GOT_WPSINFO_PEER_DISPLAY_PIN)
-		*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_DPID_USER_SPEC);
-	else if (pwdinfo->ui_got_wps_info == P2P_GOT_WPSINFO_SELF_DISPLAY_PIN)
-		*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_DPID_REGISTRAR_SPEC);
-	else if (pwdinfo->ui_got_wps_info == P2P_GOT_WPSINFO_PBC)
-		*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_DPID_PBC);
-
-	wpsielen += 2;
-
-	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, wpsielen, (unsigned char *)wpsie, &pattrib->pktlen);
-
-
-	/*	P2P IE Section. */
-
-	/*	P2P OUI */
-	p2pielen = 0;
-	p2pie[p2pielen++] = 0x50;
-	p2pie[p2pielen++] = 0x6F;
-	p2pie[p2pielen++] = 0x9A;
-	p2pie[p2pielen++] = 0x09;	/*	WFA P2P v1.0 */
-
-	/*	Commented by Albert 20110306 */
-	/*	According to the P2P Specification, the group negotiation request frame should contain 9 P2P attributes */
-	/*	1. P2P Capability */
-	/*	2. Group Owner Intent */
-	/*	3. Configuration Timeout */
-	/*	4. Listen Channel */
-	/*	5. Extended Listen Timing */
-	/*	6. Intended P2P Interface Address */
-	/*	7. Channel List */
-	/*	8. P2P Device Info */
-	/*	9. Operating Channel */
-
-
-	/*	P2P Capability */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_CAPABILITY;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0002);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Device Capability Bitmap, 1 byte */
-	p2pie[p2pielen++] = DMP_P2P_DEVCAP_SUPPORT;
-
-	/*	Group Capability Bitmap, 1 byte */
-	if (pwdinfo->persistent_supported)
-		p2pie[p2pielen++] = P2P_GRPCAP_CROSS_CONN | P2P_GRPCAP_PERSISTENT_GROUP;
-	else
-		p2pie[p2pielen++] = P2P_GRPCAP_CROSS_CONN;
-
-	/*	Group Owner Intent */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_GO_INTENT;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0001);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Todo the tie breaker bit. */
-	p2pie[p2pielen++] = ((pwdinfo->intent << 1) | BIT(0));
-
-	/*	Configuration Timeout */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_CONF_TIMEOUT;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0002);
-	p2pielen += 2;
-
-	/*	Value: */
-	p2pie[p2pielen++] = 200;	/*	2 seconds needed to be the P2P GO */
-	p2pie[p2pielen++] = 200;	/*	2 seconds needed to be the P2P Client */
-
-
-	/*	Listen Channel */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_LISTEN_CH;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0005);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Country String */
-	p2pie[p2pielen++] = 'X';
-	p2pie[p2pielen++] = 'X';
-
-	/*	The third byte should be set to 0x04. */
-	/*	Described in the "Operating Channel Attribute" section. */
-	p2pie[p2pielen++] = 0x04;
-
-	/*	Operating Class */
-	p2pie[p2pielen++] = 0x51;	/*	Copy from SD7 */
-
-	/*	Channel Number */
-	p2pie[p2pielen++] = pwdinfo->listen_channel;	/*	listening channel number */
-
-
-	/*	Extended Listen Timing ATTR */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_EX_LISTEN_TIMING;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0004);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Availability Period */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0xFFFF);
-	p2pielen += 2;
-
-	/*	Availability Interval */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0xFFFF);
-	p2pielen += 2;
-
-
-	/*	Intended P2P Interface Address */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_INTENTED_IF_ADDR;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(ETH_ALEN);
-	p2pielen += 2;
-
-	/*	Value: */
-	memcpy(p2pie + p2pielen, myid(&padapter->eeprompriv), ETH_ALEN);
-	p2pielen += ETH_ALEN;
-
-
-	/*	Channel List */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_CH_LIST;
-
-	/*  Length: */
-	/*  Country String(3) */
-	/*  + (Operating Class (1) + Number of Channels(1)) * Operation Classes (?) */
-	/*  + number of channels in all classes */
-	len_channellist_attr = 3
-	   + (1 + 1) * (u16)(pmlmeext->channel_list.reg_classes)
-	   + get_reg_classes_full_count(&pmlmeext->channel_list);
-
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(len_channellist_attr);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Country String */
-	p2pie[p2pielen++] = 'X';
-	p2pie[p2pielen++] = 'X';
-
-	/*	The third byte should be set to 0x04. */
-	/*	Described in the "Operating Channel Attribute" section. */
-	p2pie[p2pielen++] = 0x04;
-
-	/*	Channel Entry List */
-
-	{
-		int i, j;
-		for (j = 0; j < pmlmeext->channel_list.reg_classes; j++) {
-			/*	Operating Class */
-			p2pie[p2pielen++] = pmlmeext->channel_list.reg_class[j].reg_class;
-
-			/*	Number of Channels */
-			p2pie[p2pielen++] = pmlmeext->channel_list.reg_class[j].channels;
-
-			/*	Channel List */
-			for (i = 0; i < pmlmeext->channel_list.reg_class[j].channels; i++) {
-				p2pie[p2pielen++] = pmlmeext->channel_list.reg_class[j].channel[i];
-			}
-		}
-	}
-
-	/*	Device Info */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_DEVICE_INFO;
-
-	/*	Length: */
-	/*	21 -> P2P Device Address (6bytes) + Config Methods (2bytes) + Primary Device Type (8bytes) */
-	/*	+ NumofSecondDevType (1byte) + WPS Device Name ID field (2bytes) + WPS Device Name Len field (2bytes) */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(21 + pwdinfo->device_name_len);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	P2P Device Address */
-	memcpy(p2pie + p2pielen, myid(&padapter->eeprompriv), ETH_ALEN);
-	p2pielen += ETH_ALEN;
-
-	/*	Config Method */
-	/*	This field should be big endian. Noted by P2P specification. */
-
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(pwdinfo->supported_wps_cm);
-
-	p2pielen += 2;
-
-	/*	Primary Device Type */
-	/*	Category ID */
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_PDT_CID_MULIT_MEDIA);
-	p2pielen += 2;
-
-	/*	OUI */
-	*(__be32 *)(p2pie + p2pielen) = cpu_to_be32(WPSOUI);
-	p2pielen += 4;
-
-	/*	Sub Category ID */
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_PDT_SCID_MEDIA_SERVER);
-	p2pielen += 2;
-
-	/*	Number of Secondary Device Types */
-	p2pie[p2pielen++] = 0x00;	/*	No Secondary Device Type List */
-
-	/*	Device Name */
-	/*	Type: */
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_ATTR_DEVICE_NAME);
-	p2pielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(pwdinfo->device_name_len);
-	p2pielen += 2;
-
-	/*	Value: */
-	memcpy(p2pie + p2pielen, pwdinfo->device_name , pwdinfo->device_name_len);
-	p2pielen += pwdinfo->device_name_len;
-
-
-	/*	Operating Channel */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_OPERATING_CH;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0005);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Country String */
-	p2pie[p2pielen++] = 'X';
-	p2pie[p2pielen++] = 'X';
-
-	/*	The third byte should be set to 0x04. */
-	/*	Described in the "Operating Channel Attribute" section. */
-	p2pie[p2pielen++] = 0x04;
-
-	/*	Operating Class */
-	p2pie[p2pielen++] = 0x51;
-
-	/*	Channel Number */
-	p2pie[p2pielen++] = pwdinfo->operating_channel;	/*	operating channel number */
-
-	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, p2pielen, (unsigned char *)p2pie, &pattrib->pktlen);
-
-	pattrib->last_txcmdsz = pattrib->pktlen;
-
-	dump_mgntframe(padapter, pmgntframe);
-
-	return;
-}
-
-static void issue_p2p_GO_response(struct adapter *padapter, u8 *raddr, u8 *frame_body, uint len, u8 result)
-{
-	unsigned char category = RTW_WLAN_CATEGORY_PUBLIC;
-	u8 action = P2P_PUB_ACTION_ACTION;
-	__be32			p2poui = cpu_to_be32(P2POUI);
-	u8 oui_subtype = P2P_GO_NEGO_RESP;
-	u8 wpsie[255] = { 0x00 }, p2pie[255] = { 0x00 };
-	u8 p2pielen = 0;
-	uint			wpsielen = 0;
-	u16 wps_devicepassword_id = 0x0000;
-	__be16			be_tmp;
-	uint			wps_devicepassword_id_len = 0;
-	u16 len_channellist_attr = 0;
-
-	struct xmit_frame			*pmgntframe;
-	struct pkt_attrib			*pattrib;
-	unsigned char					*pframe;
-	struct rtw_ieee80211_hdr	*pwlanhdr;
-	__le16 *fctrl;
-	struct xmit_priv			*pxmitpriv = &(padapter->xmitpriv);
-	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-
-	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
-		return;
-
-	DBG_88E("[%s] In, result=%d\n", __func__,  result);
-	/* update attribute */
-	pattrib = &pmgntframe->attrib;
-	update_mgntframe_attrib(padapter, pattrib);
-
-	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
-
-	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
-	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
-
-	fctrl = &(pwlanhdr->frame_ctl);
-	*(fctrl) = 0;
-
-	memcpy(pwlanhdr->addr1, raddr, ETH_ALEN);
-	memcpy(pwlanhdr->addr2, myid(&(padapter->eeprompriv)), ETH_ALEN);
-	memcpy(pwlanhdr->addr3, myid(&(padapter->eeprompriv)), ETH_ALEN);
-
-	SetSeqNum(pwlanhdr, pmlmeext->mgnt_seq);
-	pmlmeext->mgnt_seq++;
-	SetFrameSubType(pframe, WIFI_ACTION);
-
-	pframe += sizeof(struct rtw_ieee80211_hdr_3addr);
-	pattrib->pktlen = sizeof(struct rtw_ieee80211_hdr_3addr);
-
-	pframe = rtw_set_fixed_ie(pframe, 1, &(category), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(action), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 4, (unsigned char *)&(p2poui), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(oui_subtype), &(pattrib->pktlen));
-	pwdinfo->negotiation_dialog_token = frame_body[7];	/*	The Dialog Token of provisioning discovery request frame. */
-	pframe = rtw_set_fixed_ie(pframe, 1, &(pwdinfo->negotiation_dialog_token), &(pattrib->pktlen));
-
-	/*	Commented by Albert 20110328 */
-	/*	Try to get the device password ID from the WPS IE of group negotiation request frame */
-	/*	WiFi Direct test plan 5.1.15 */
-	rtw_get_wps_ie(frame_body + _PUBLIC_ACTION_IE_OFFSET_, len - _PUBLIC_ACTION_IE_OFFSET_, wpsie, &wpsielen);
-	rtw_get_wps_attr_content(wpsie, wpsielen, WPS_ATTR_DEVICE_PWID, (u8 *)&be_tmp, &wps_devicepassword_id_len);
-	wps_devicepassword_id = be16_to_cpu(be_tmp);
-
-	memset(wpsie, 0x00, 255);
-	wpsielen = 0;
-
-	/*	WPS Section */
-	wpsielen = 0;
-	/*	WPS OUI */
-	*(__be32 *)(wpsie) = cpu_to_be32(WPSOUI);
-	wpsielen += 4;
-
-	/*	WPS version */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_VER1);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0001);
-	wpsielen += 2;
-
-	/*	Value: */
-	wpsie[wpsielen++] = WPS_VERSION_1;	/*	Version 1.0 */
-
-	/*	Device Password ID */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_DEVICE_PWID);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0002);
-	wpsielen += 2;
-
-	/*	Value: */
-	if (wps_devicepassword_id == WPS_DPID_USER_SPEC)
-		*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_DPID_REGISTRAR_SPEC);
-	else if (wps_devicepassword_id == WPS_DPID_REGISTRAR_SPEC)
-		*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_DPID_USER_SPEC);
-	else
-		*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_DPID_PBC);
-	wpsielen += 2;
-
-	/*	Commented by Kurt 20120113 */
-	/*	If some device wants to do p2p handshake without sending prov_disc_req */
-	/*	We have to get peer_req_cm from here. */
-	if (!memcmp(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, "000", 3)) {
-		if (wps_devicepassword_id == WPS_DPID_USER_SPEC)
-			memcpy(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, "dis", 3);
-		else if (wps_devicepassword_id == WPS_DPID_REGISTRAR_SPEC)
-			memcpy(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, "pad", 3);
-		else
-			memcpy(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, "pbc", 3);
-	}
-
-	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, wpsielen, (unsigned char *)wpsie, &pattrib->pktlen);
-
-
-	/*	P2P IE Section. */
-
-	/*	P2P OUI */
-	p2pielen = 0;
-	p2pie[p2pielen++] = 0x50;
-	p2pie[p2pielen++] = 0x6F;
-	p2pie[p2pielen++] = 0x9A;
-	p2pie[p2pielen++] = 0x09;	/*	WFA P2P v1.0 */
-
-	/*	Commented by Albert 20100908 */
-	/*	According to the P2P Specification, the group negotiation response frame should contain 9 P2P attributes */
-	/*	1. Status */
-	/*	2. P2P Capability */
-	/*	3. Group Owner Intent */
-	/*	4. Configuration Timeout */
-	/*	5. Operating Channel */
-	/*	6. Intended P2P Interface Address */
-	/*	7. Channel List */
-	/*	8. Device Info */
-	/*	9. Group ID	(Only GO) */
-
-
-	/*	ToDo: */
-
-	/*	P2P Status */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_STATUS;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0001);
-	p2pielen += 2;
-
-	/*	Value: */
-	p2pie[p2pielen++] = result;
-
-	/*	P2P Capability */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_CAPABILITY;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0002);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Device Capability Bitmap, 1 byte */
-
-	if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_CLIENT)) {
-		/*	Commented by Albert 2011/03/08 */
-		/*	According to the P2P specification */
-		/*	if the sending device will be client, the P2P Capability should be reserved of group negotiation response frame */
-		p2pie[p2pielen++] = 0;
-	} else {
-		/*	Be group owner or meet the error case */
-		p2pie[p2pielen++] = DMP_P2P_DEVCAP_SUPPORT;
-	}
-
-	/*	Group Capability Bitmap, 1 byte */
-	if (pwdinfo->persistent_supported) {
-		p2pie[p2pielen++] = P2P_GRPCAP_CROSS_CONN | P2P_GRPCAP_PERSISTENT_GROUP;
-	} else {
-		p2pie[p2pielen++] = P2P_GRPCAP_CROSS_CONN;
-	}
-
-	/*	Group Owner Intent */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_GO_INTENT;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0001);
-	p2pielen += 2;
-
-	/*	Value: */
-	if (pwdinfo->peer_intent & 0x01) {
-		/*	Peer's tie breaker bit is 1, our tie breaker bit should be 0 */
-		p2pie[p2pielen++] = (pwdinfo->intent << 1);
-	} else {
-		/*	Peer's tie breaker bit is 0, our tie breaker bit should be 1 */
-		p2pie[p2pielen++] = ((pwdinfo->intent << 1) | BIT(0));
-	}
-
-
-	/*	Configuration Timeout */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_CONF_TIMEOUT;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0002);
-	p2pielen += 2;
-
-	/*	Value: */
-	p2pie[p2pielen++] = 200;	/*	2 seconds needed to be the P2P GO */
-	p2pie[p2pielen++] = 200;	/*	2 seconds needed to be the P2P Client */
-
-	/*	Operating Channel */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_OPERATING_CH;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0005);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Country String */
-	p2pie[p2pielen++] = 'X';
-	p2pie[p2pielen++] = 'X';
-
-	/*	The third byte should be set to 0x04. */
-	/*	Described in the "Operating Channel Attribute" section. */
-	p2pie[p2pielen++] = 0x04;
-
-	/*	Operating Class */
-	p2pie[p2pielen++] = 0x51;
-
-	/*	Channel Number */
-	p2pie[p2pielen++] = pwdinfo->operating_channel;	/*	operating channel number */
-
-	/*	Intended P2P Interface Address */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_INTENTED_IF_ADDR;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(ETH_ALEN);
-	p2pielen += 2;
-
-	/*	Value: */
-	memcpy(p2pie + p2pielen, myid(&padapter->eeprompriv), ETH_ALEN);
-	p2pielen += ETH_ALEN;
-
-	/*	Channel List */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_CH_LIST;
-
-	/*  Country String(3) */
-	/*  + (Operating Class (1) + Number of Channels(1)) * Operation Classes (?) */
-	/*  + number of channels in all classes */
-	len_channellist_attr = 3
-	   + (1 + 1) * (u16)pmlmeext->channel_list.reg_classes
-	   + get_reg_classes_full_count(&pmlmeext->channel_list);
-
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(len_channellist_attr);
-
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Country String */
-	p2pie[p2pielen++] = 'X';
-	p2pie[p2pielen++] = 'X';
-
-	/*	The third byte should be set to 0x04. */
-	/*	Described in the "Operating Channel Attribute" section. */
-	p2pie[p2pielen++] = 0x04;
-
-	/*	Channel Entry List */
-
-	{
-		int i, j;
-		for (j = 0; j < pmlmeext->channel_list.reg_classes; j++) {
-			/*	Operating Class */
-			p2pie[p2pielen++] = pmlmeext->channel_list.reg_class[j].reg_class;
-
-			/*	Number of Channels */
-			p2pie[p2pielen++] = pmlmeext->channel_list.reg_class[j].channels;
-
-			/*	Channel List */
-			for (i = 0; i < pmlmeext->channel_list.reg_class[j].channels; i++) {
-				p2pie[p2pielen++] = pmlmeext->channel_list.reg_class[j].channel[i];
-			}
-		}
-	}
-
-	/*	Device Info */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_DEVICE_INFO;
-
-	/*	Length: */
-	/*	21 -> P2P Device Address (6bytes) + Config Methods (2bytes) + Primary Device Type (8bytes) */
-	/*	+ NumofSecondDevType (1byte) + WPS Device Name ID field (2bytes) + WPS Device Name Len field (2bytes) */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(21 + pwdinfo->device_name_len);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	P2P Device Address */
-	memcpy(p2pie + p2pielen, myid(&padapter->eeprompriv), ETH_ALEN);
-	p2pielen += ETH_ALEN;
-
-	/*	Config Method */
-	/*	This field should be big endian. Noted by P2P specification. */
-
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(pwdinfo->supported_wps_cm);
-
-	p2pielen += 2;
-
-	/*	Primary Device Type */
-	/*	Category ID */
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_PDT_CID_MULIT_MEDIA);
-	p2pielen += 2;
-
-	/*	OUI */
-	*(__be32 *)(p2pie + p2pielen) = cpu_to_be32(WPSOUI);
-	p2pielen += 4;
-
-	/*	Sub Category ID */
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_PDT_SCID_MEDIA_SERVER);
-	p2pielen += 2;
-
-	/*	Number of Secondary Device Types */
-	p2pie[p2pielen++] = 0x00;	/*	No Secondary Device Type List */
-
-	/*	Device Name */
-	/*	Type: */
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_ATTR_DEVICE_NAME);
-	p2pielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(pwdinfo->device_name_len);
-	p2pielen += 2;
-
-	/*	Value: */
-	memcpy(p2pie + p2pielen, pwdinfo->device_name , pwdinfo->device_name_len);
-	p2pielen += pwdinfo->device_name_len;
-
-	if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO)) {
-		/*	Group ID Attribute */
-		/*	Type: */
-		p2pie[p2pielen++] = P2P_ATTR_GROUP_ID;
-
-		/*	Length: */
-		*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(ETH_ALEN + pwdinfo->nego_ssidlen);
-		p2pielen += 2;
-
-		/*	Value: */
-		/*	p2P Device Address */
-		memcpy(p2pie + p2pielen , pwdinfo->device_addr, ETH_ALEN);
-		p2pielen += ETH_ALEN;
-
-		/*	SSID */
-		memcpy(p2pie + p2pielen, pwdinfo->nego_ssid, pwdinfo->nego_ssidlen);
-		p2pielen += pwdinfo->nego_ssidlen;
-	}
-
-	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, p2pielen, (unsigned char *)p2pie, &pattrib->pktlen);
-
-	pattrib->last_txcmdsz = pattrib->pktlen;
-
-	dump_mgntframe(padapter, pmgntframe);
-	return;
-}
-
-static void issue_p2p_GO_confirm(struct adapter *padapter, u8 *raddr, u8 result)
-{
-	unsigned char category = RTW_WLAN_CATEGORY_PUBLIC;
-	u8 action = P2P_PUB_ACTION_ACTION;
-	__be32			p2poui = cpu_to_be32(P2POUI);
-	u8 oui_subtype = P2P_GO_NEGO_CONF;
-	u8 p2pie[255] = { 0x00 };
-	u8 p2pielen = 0;
-
-	struct xmit_frame			*pmgntframe;
-	struct pkt_attrib			*pattrib;
-	unsigned char					*pframe;
-	struct rtw_ieee80211_hdr	*pwlanhdr;
-	__le16 *fctrl;
-	struct xmit_priv			*pxmitpriv = &(padapter->xmitpriv);
-	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-
-	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
-		return;
-
-	DBG_88E("[%s] In\n", __func__);
-	/* update attribute */
-	pattrib = &pmgntframe->attrib;
-	update_mgntframe_attrib(padapter, pattrib);
-
-	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
-
-	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
-	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
-
-	fctrl = &(pwlanhdr->frame_ctl);
-	*(fctrl) = 0;
-
-	memcpy(pwlanhdr->addr1, raddr, ETH_ALEN);
-	memcpy(pwlanhdr->addr2, myid(&(padapter->eeprompriv)), ETH_ALEN);
-	memcpy(pwlanhdr->addr3, myid(&(padapter->eeprompriv)), ETH_ALEN);
-
-	SetSeqNum(pwlanhdr, pmlmeext->mgnt_seq);
-	pmlmeext->mgnt_seq++;
-	SetFrameSubType(pframe, WIFI_ACTION);
-
-	pframe += sizeof(struct rtw_ieee80211_hdr_3addr);
-	pattrib->pktlen = sizeof(struct rtw_ieee80211_hdr_3addr);
-
-	pframe = rtw_set_fixed_ie(pframe, 1, &(category), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(action), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 4, (unsigned char *)&(p2poui), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(oui_subtype), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(pwdinfo->negotiation_dialog_token), &(pattrib->pktlen));
-
-
-
-	/*	P2P IE Section. */
-
-	/*	P2P OUI */
-	p2pielen = 0;
-	p2pie[p2pielen++] = 0x50;
-	p2pie[p2pielen++] = 0x6F;
-	p2pie[p2pielen++] = 0x9A;
-	p2pie[p2pielen++] = 0x09;	/*	WFA P2P v1.0 */
-
-	/*	Commented by Albert 20110306 */
-	/*	According to the P2P Specification, the group negotiation request frame should contain 5 P2P attributes */
-	/*	1. Status */
-	/*	2. P2P Capability */
-	/*	3. Operating Channel */
-	/*	4. Channel List */
-	/*	5. Group ID	(if this WiFi is GO) */
-
-	/*	P2P Status */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_STATUS;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0001);
-	p2pielen += 2;
-
-	/*	Value: */
-	p2pie[p2pielen++] = result;
-
-	/*	P2P Capability */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_CAPABILITY;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0002);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Device Capability Bitmap, 1 byte */
-	p2pie[p2pielen++] = DMP_P2P_DEVCAP_SUPPORT;
-
-	/*	Group Capability Bitmap, 1 byte */
-	if (pwdinfo->persistent_supported)
-		p2pie[p2pielen++] = P2P_GRPCAP_CROSS_CONN | P2P_GRPCAP_PERSISTENT_GROUP;
-	else
-		p2pie[p2pielen++] = P2P_GRPCAP_CROSS_CONN;
-
-	/*	Operating Channel */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_OPERATING_CH;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0005);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Country String */
-	p2pie[p2pielen++] = 'X';
-	p2pie[p2pielen++] = 'X';
-
-	/*	The third byte should be set to 0x04. */
-	/*	Described in the "Operating Channel Attribute" section. */
-	p2pie[p2pielen++] = 0x04;
-
-
-	if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_CLIENT)) {
-		/*	Operating Class */
-		p2pie[p2pielen++] = 0x51;
-		p2pie[p2pielen++] = pwdinfo->peer_operating_ch;
-	} else {
-		/*	Operating Class */
-		p2pie[p2pielen++] = 0x51;
-
-		/*	Channel Number */
-		p2pie[p2pielen++] = pwdinfo->operating_channel;		/*	Use the listen channel as the operating channel */
-	}
-
-
-	/*	Channel List */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_CH_LIST;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(pwdinfo->channel_list_attr_len);
-	p2pielen += 2;
-
-	/*	Value: */
-	memcpy(p2pie + p2pielen, pwdinfo->channel_list_attr, pwdinfo->channel_list_attr_len);
-	p2pielen += pwdinfo->channel_list_attr_len;
-
-	if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO)) {
-		/*	Group ID Attribute */
-		/*	Type: */
-		p2pie[p2pielen++] = P2P_ATTR_GROUP_ID;
-
-		/*	Length: */
-		*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(ETH_ALEN + pwdinfo->nego_ssidlen);
-		p2pielen += 2;
-
-		/*	Value: */
-		/*	p2P Device Address */
-		memcpy(p2pie + p2pielen , pwdinfo->device_addr, ETH_ALEN);
-		p2pielen += ETH_ALEN;
-
-		/*	SSID */
-		memcpy(p2pie + p2pielen, pwdinfo->nego_ssid, pwdinfo->nego_ssidlen);
-		p2pielen += pwdinfo->nego_ssidlen;
-	}
-	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, p2pielen, (unsigned char *)p2pie, &pattrib->pktlen);
-	pattrib->last_txcmdsz = pattrib->pktlen;
-	dump_mgntframe(padapter, pmgntframe);
-	return;
-}
-
-void issue_p2p_invitation_request(struct adapter *padapter, u8 *raddr)
-{
-	unsigned char category = RTW_WLAN_CATEGORY_PUBLIC;
-	u8 action = P2P_PUB_ACTION_ACTION;
-	__be32			p2poui = cpu_to_be32(P2POUI);
-	u8 oui_subtype = P2P_INVIT_REQ;
-	u8 p2pie[255] = { 0x00 };
-	u8 p2pielen = 0;
-	u8 dialogToken = 3;
-	u16 len_channellist_attr = 0;
-	struct xmit_frame			*pmgntframe;
-	struct pkt_attrib			*pattrib;
-	unsigned char					*pframe;
-	struct rtw_ieee80211_hdr	*pwlanhdr;
-	__le16 *fctrl;
-	struct xmit_priv			*pxmitpriv = &(padapter->xmitpriv);
-	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-
-	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
-		return;
-
-	/* update attribute */
-	pattrib = &pmgntframe->attrib;
-	update_mgntframe_attrib(padapter, pattrib);
-
-	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
-
-	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
-	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
-
-	fctrl = &(pwlanhdr->frame_ctl);
-	*(fctrl) = 0;
-
-	memcpy(pwlanhdr->addr1, raddr, ETH_ALEN);
-	memcpy(pwlanhdr->addr2, myid(&(padapter->eeprompriv)), ETH_ALEN);
-	memcpy(pwlanhdr->addr3, raddr,  ETH_ALEN);
-
-	SetSeqNum(pwlanhdr, pmlmeext->mgnt_seq);
-	pmlmeext->mgnt_seq++;
-	SetFrameSubType(pframe, WIFI_ACTION);
-
-	pframe += sizeof(struct rtw_ieee80211_hdr_3addr);
-	pattrib->pktlen = sizeof(struct rtw_ieee80211_hdr_3addr);
-
-	pframe = rtw_set_fixed_ie(pframe, 1, &(category), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(action), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 4, (unsigned char *)&(p2poui), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(oui_subtype), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(dialogToken), &(pattrib->pktlen));
-
-	/*	P2P IE Section. */
-
-	/*	P2P OUI */
-	p2pielen = 0;
-	p2pie[p2pielen++] = 0x50;
-	p2pie[p2pielen++] = 0x6F;
-	p2pie[p2pielen++] = 0x9A;
-	p2pie[p2pielen++] = 0x09;	/*	WFA P2P v1.0 */
-
-	/*	Commented by Albert 20101011 */
-	/*	According to the P2P Specification, the P2P Invitation request frame should contain 7 P2P attributes */
-	/*	1. Configuration Timeout */
-	/*	2. Invitation Flags */
-	/*	3. Operating Channel	(Only GO) */
-	/*	4. P2P Group BSSID	(Should be included if I am the GO) */
-	/*	5. Channel List */
-	/*	6. P2P Group ID */
-	/*	7. P2P Device Info */
-
-	/*	Configuration Timeout */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_CONF_TIMEOUT;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0002);
-	p2pielen += 2;
-
-	/*	Value: */
-	p2pie[p2pielen++] = 200;	/*	2 seconds needed to be the P2P GO */
-	p2pie[p2pielen++] = 200;	/*	2 seconds needed to be the P2P Client */
-
-	/*	Invitation Flags */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_INVITATION_FLAGS;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0001);
-	p2pielen += 2;
-
-	/*	Value: */
-	p2pie[p2pielen++] = P2P_INVITATION_FLAGS_PERSISTENT;
-
-
-	/*	Operating Channel */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_OPERATING_CH;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0005);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Country String */
-	p2pie[p2pielen++] = 'X';
-	p2pie[p2pielen++] = 'X';
-
-	/*	The third byte should be set to 0x04. */
-	/*	Described in the "Operating Channel Attribute" section. */
-	p2pie[p2pielen++] = 0x04;
-
-	/*	Operating Class */
-	p2pie[p2pielen++] = 0x51;
-
-	/*	Channel Number */
-	p2pie[p2pielen++] = pwdinfo->invitereq_info.operating_ch;	/*	operating channel number */
-
-	if (!memcmp(myid(&padapter->eeprompriv),
-		    pwdinfo->invitereq_info.go_bssid, ETH_ALEN)) {
-		/*	P2P Group BSSID */
-		/*	Type: */
-		p2pie[p2pielen++] = P2P_ATTR_GROUP_BSSID;
-
-		/*	Length: */
-		*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(ETH_ALEN);
-		p2pielen += 2;
-
-		/*	Value: */
-		/*	P2P Device Address for GO */
-		memcpy(p2pie + p2pielen, pwdinfo->invitereq_info.go_bssid, ETH_ALEN);
-		p2pielen += ETH_ALEN;
-	}
-
-	/*	Channel List */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_CH_LIST;
-
-
-	/*	Length: */
-	/*  Country String(3) */
-	/*  + (Operating Class (1) + Number of Channels(1)) * Operation Classes (?) */
-	/*  + number of channels in all classes */
-	len_channellist_attr = 3
-	   + (1 + 1) * (u16)pmlmeext->channel_list.reg_classes
-	   + get_reg_classes_full_count(&pmlmeext->channel_list);
-
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(len_channellist_attr);
-
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Country String */
-	p2pie[p2pielen++] = 'X';
-	p2pie[p2pielen++] = 'X';
-
-	/*	The third byte should be set to 0x04. */
-	/*	Described in the "Operating Channel Attribute" section. */
-	p2pie[p2pielen++] = 0x04;
-
-	/*	Channel Entry List */
-	{
-		int i, j;
-		for (j = 0; j < pmlmeext->channel_list.reg_classes; j++) {
-			/*	Operating Class */
-			p2pie[p2pielen++] = pmlmeext->channel_list.reg_class[j].reg_class;
-
-			/*	Number of Channels */
-			p2pie[p2pielen++] = pmlmeext->channel_list.reg_class[j].channels;
-
-			/*	Channel List */
-			for (i = 0; i < pmlmeext->channel_list.reg_class[j].channels; i++) {
-				p2pie[p2pielen++] = pmlmeext->channel_list.reg_class[j].channel[i];
-			}
-		}
-	}
-
-
-	/*	P2P Group ID */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_GROUP_ID;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(6 + pwdinfo->invitereq_info.ssidlen);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	P2P Device Address for GO */
-	memcpy(p2pie + p2pielen, pwdinfo->invitereq_info.go_bssid, ETH_ALEN);
-	p2pielen += ETH_ALEN;
-
-	/*	SSID */
-	memcpy(p2pie + p2pielen, pwdinfo->invitereq_info.go_ssid, pwdinfo->invitereq_info.ssidlen);
-	p2pielen += pwdinfo->invitereq_info.ssidlen;
-
-
-	/*	Device Info */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_DEVICE_INFO;
-
-	/*	Length: */
-	/*	21 -> P2P Device Address (6bytes) + Config Methods (2bytes) + Primary Device Type (8bytes) */
-	/*	+ NumofSecondDevType (1byte) + WPS Device Name ID field (2bytes) + WPS Device Name Len field (2bytes) */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(21 + pwdinfo->device_name_len);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	P2P Device Address */
-	memcpy(p2pie + p2pielen, myid(&padapter->eeprompriv), ETH_ALEN);
-	p2pielen += ETH_ALEN;
-
-	/*	Config Method */
-	/*	This field should be big endian. Noted by P2P specification. */
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_CONFIG_METHOD_DISPLAY);
-	p2pielen += 2;
-
-	/*	Primary Device Type */
-	/*	Category ID */
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_PDT_CID_MULIT_MEDIA);
-	p2pielen += 2;
-
-	/*	OUI */
-	*(__be32 *)(p2pie + p2pielen) = cpu_to_be32(WPSOUI);
-	p2pielen  += 4;
-
-	/*	Sub Category ID */
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_PDT_SCID_MEDIA_SERVER);
-	p2pielen += 2;
-
-	/*	Number of Secondary Device Types */
-	p2pie[p2pielen++] = 0x00;	/*	No Secondary Device Type List */
-
-	/*	Device Name */
-	/*	Type: */
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_ATTR_DEVICE_NAME);
-	p2pielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(pwdinfo->device_name_len);
-	p2pielen += 2;
-
-	/*	Value: */
-	memcpy(p2pie + p2pielen, pwdinfo->device_name, pwdinfo->device_name_len);
-	p2pielen += pwdinfo->device_name_len;
-
-	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, p2pielen, (unsigned char *)p2pie, &pattrib->pktlen);
-
-	pattrib->last_txcmdsz = pattrib->pktlen;
-
-	dump_mgntframe(padapter, pmgntframe);
-
-	return;
-}
-
-void issue_p2p_invitation_response(struct adapter *padapter, u8 *raddr, u8 dialogToken, u8 status_code)
-{
-	unsigned char category = RTW_WLAN_CATEGORY_PUBLIC;
-	u8 action = P2P_PUB_ACTION_ACTION;
-	__be32			p2poui = cpu_to_be32(P2POUI);
-	u8 oui_subtype = P2P_INVIT_RESP;
-	u8 p2pie[255] = { 0x00 };
-	u8 p2pielen = 0;
-	u16 len_channellist_attr = 0;
-	struct xmit_frame			*pmgntframe;
-	struct pkt_attrib			*pattrib;
-	unsigned char					*pframe;
-	struct rtw_ieee80211_hdr	*pwlanhdr;
-	__le16 *fctrl;
-	struct xmit_priv			*pxmitpriv = &(padapter->xmitpriv);
-	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-
-	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
-		return;
-
-	/* update attribute */
-	pattrib = &pmgntframe->attrib;
-	update_mgntframe_attrib(padapter, pattrib);
-
-	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
-
-	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
-	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
-
-	fctrl = &(pwlanhdr->frame_ctl);
-	*(fctrl) = 0;
-
-	memcpy(pwlanhdr->addr1, raddr, ETH_ALEN);
-	memcpy(pwlanhdr->addr2, myid(&(padapter->eeprompriv)), ETH_ALEN);
-	memcpy(pwlanhdr->addr3, raddr,  ETH_ALEN);
-
-	SetSeqNum(pwlanhdr, pmlmeext->mgnt_seq);
-	pmlmeext->mgnt_seq++;
-	SetFrameSubType(pframe, WIFI_ACTION);
-
-	pframe += sizeof(struct rtw_ieee80211_hdr_3addr);
-	pattrib->pktlen = sizeof(struct rtw_ieee80211_hdr_3addr);
-
-	pframe = rtw_set_fixed_ie(pframe, 1, &(category), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(action), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 4, (unsigned char *)&(p2poui), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(oui_subtype), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(dialogToken), &(pattrib->pktlen));
-
-	/*	P2P IE Section. */
-
-	/*	P2P OUI */
-	p2pielen = 0;
-	p2pie[p2pielen++] = 0x50;
-	p2pie[p2pielen++] = 0x6F;
-	p2pie[p2pielen++] = 0x9A;
-	p2pie[p2pielen++] = 0x09;	/*	WFA P2P v1.0 */
-
-	/*	Commented by Albert 20101005 */
-	/*	According to the P2P Specification, the P2P Invitation response frame should contain 5 P2P attributes */
-	/*	1. Status */
-	/*	2. Configuration Timeout */
-	/*	3. Operating Channel	(Only GO) */
-	/*	4. P2P Group BSSID	(Only GO) */
-	/*	5. Channel List */
-
-	/*	P2P Status */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_STATUS;
-
-	/*	Length: */
-	*(__le16  *)(p2pie + p2pielen) = cpu_to_le16(0x0001);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	When status code is P2P_STATUS_FAIL_INFO_UNAVAILABLE. */
-	/*	Sent the event receiving the P2P Invitation Req frame to DMP UI. */
-	/*	DMP had to compare the MAC address to find out the profile. */
-	/*	So, the WiFi driver will send the P2P_STATUS_FAIL_INFO_UNAVAILABLE to NB. */
-	/*	If the UI found the corresponding profile, the WiFi driver sends the P2P Invitation Req */
-	/*	to NB to rebuild the persistent group. */
-	p2pie[p2pielen++] = status_code;
-
-	/*	Configuration Timeout */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_CONF_TIMEOUT;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0002);
-	p2pielen += 2;
-
-	/*	Value: */
-	p2pie[p2pielen++] = 200;	/*	2 seconds needed to be the P2P GO */
-	p2pie[p2pielen++] = 200;	/*	2 seconds needed to be the P2P Client */
-
-	if (status_code == P2P_STATUS_SUCCESS) {
-		if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO)) {
-			/*	The P2P Invitation request frame asks this Wi-Fi device to be the P2P GO */
-			/*	In this case, the P2P Invitation response frame should carry the two more P2P attributes. */
-			/*	First one is operating channel attribute. */
-			/*	Second one is P2P Group BSSID attribute. */
-
-			/*	Operating Channel */
-			/*	Type: */
-			p2pie[p2pielen++] = P2P_ATTR_OPERATING_CH;
-
-			/*	Length: */
-			*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0005);
-			p2pielen += 2;
-
-			/*	Value: */
-			/*	Country String */
-			p2pie[p2pielen++] = 'X';
-			p2pie[p2pielen++] = 'X';
-
-			/*	The third byte should be set to 0x04. */
-			/*	Described in the "Operating Channel Attribute" section. */
-			p2pie[p2pielen++] = 0x04;
-
-			/*	Operating Class */
-			p2pie[p2pielen++] = 0x51;	/*	Copy from SD7 */
-
-			/*	Channel Number */
-			p2pie[p2pielen++] = pwdinfo->operating_channel;	/*	operating channel number */
-
-
-			/*	P2P Group BSSID */
-			/*	Type: */
-			p2pie[p2pielen++] = P2P_ATTR_GROUP_BSSID;
-
-			/*	Length: */
-			*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(ETH_ALEN);
-			p2pielen += 2;
-
-			/*	Value: */
-			/*	P2P Device Address for GO */
-			memcpy(p2pie + p2pielen, myid(&padapter->eeprompriv), ETH_ALEN);
-			p2pielen += ETH_ALEN;
-		}
-
-		/*	Channel List */
-		/*	Type: */
-		p2pie[p2pielen++] = P2P_ATTR_CH_LIST;
-
-		/*	Length: */
-		/*  Country String(3) */
-		/*  + (Operating Class (1) + Number of Channels(1)) * Operation Classes (?) */
-		/*  + number of channels in all classes */
-		len_channellist_attr = 3
-			+ (1 + 1) * (u16)pmlmeext->channel_list.reg_classes
-			+ get_reg_classes_full_count(&pmlmeext->channel_list);
-
-		*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(len_channellist_attr);
-		p2pielen += 2;
-
-		/*	Value: */
-		/*	Country String */
-		p2pie[p2pielen++] = 'X';
-		p2pie[p2pielen++] = 'X';
-
-		/*	The third byte should be set to 0x04. */
-		/*	Described in the "Operating Channel Attribute" section. */
-		p2pie[p2pielen++] = 0x04;
-
-		/*	Channel Entry List */
-		{
-			int i, j;
-			for (j = 0; j < pmlmeext->channel_list.reg_classes; j++) {
-				/*	Operating Class */
-				p2pie[p2pielen++] = pmlmeext->channel_list.reg_class[j].reg_class;
-
-				/*	Number of Channels */
-				p2pie[p2pielen++] = pmlmeext->channel_list.reg_class[j].channels;
-
-				/*	Channel List */
-				for (i = 0; i < pmlmeext->channel_list.reg_class[j].channels; i++) {
-					p2pie[p2pielen++] = pmlmeext->channel_list.reg_class[j].channel[i];
-				}
-			}
-		}
-	}
-
-	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, p2pielen, (unsigned char *)p2pie, &pattrib->pktlen);
-
-	pattrib->last_txcmdsz = pattrib->pktlen;
-
-	dump_mgntframe(padapter, pmgntframe);
-
-	return;
-}
-
-void issue_p2p_provision_request(struct adapter *padapter, u8 *pssid, u8 ussidlen, u8 *pdev_raddr)
-{
-	unsigned char category = RTW_WLAN_CATEGORY_PUBLIC;
-	u8 action = P2P_PUB_ACTION_ACTION;
-	u8 dialogToken = 1;
-	u8 oui_subtype = P2P_PROVISION_DISC_REQ;
-	u8 wpsie[100] = { 0x00 };
-	u8 wpsielen = 0;
-	__be32 p2poui = cpu_to_be32(P2POUI);
-	u32			p2pielen = 0;
-	struct xmit_frame			*pmgntframe;
-	struct pkt_attrib			*pattrib;
-	unsigned char					*pframe;
-	struct rtw_ieee80211_hdr	*pwlanhdr;
-	__le16 *fctrl;
-	struct xmit_priv			*pxmitpriv = &(padapter->xmitpriv);
-	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-
-	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
-		return;
-
-	DBG_88E("[%s] In\n", __func__);
-	/* update attribute */
-	pattrib = &pmgntframe->attrib;
-	update_mgntframe_attrib(padapter, pattrib);
-
-	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
-
-	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
-	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
-
-	fctrl = &(pwlanhdr->frame_ctl);
-	*(fctrl) = 0;
-
-	memcpy(pwlanhdr->addr1, pdev_raddr, ETH_ALEN);
-	memcpy(pwlanhdr->addr2, myid(&(padapter->eeprompriv)), ETH_ALEN);
-	memcpy(pwlanhdr->addr3, pdev_raddr, ETH_ALEN);
-
-	SetSeqNum(pwlanhdr, pmlmeext->mgnt_seq);
-	pmlmeext->mgnt_seq++;
-	SetFrameSubType(pframe, WIFI_ACTION);
-
-	pframe += sizeof(struct rtw_ieee80211_hdr_3addr);
-	pattrib->pktlen = sizeof(struct rtw_ieee80211_hdr_3addr);
-
-	pframe = rtw_set_fixed_ie(pframe, 1, &(category), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(action), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 4, (unsigned char *)&(p2poui), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(oui_subtype), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(dialogToken), &(pattrib->pktlen));
-
-	p2pielen = build_prov_disc_request_p2p_ie(pwdinfo, pframe, pssid, ussidlen, pdev_raddr);
-
-	pframe += p2pielen;
-	pattrib->pktlen += p2pielen;
-
-	wpsielen = 0;
-	/*	WPS OUI */
-	*(__be32 *)(wpsie) = cpu_to_be32(WPSOUI);
-	wpsielen += 4;
-
-	/*	WPS version */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_VER1);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0001);
-	wpsielen += 2;
-
-	/*	Value: */
-	wpsie[wpsielen++] = WPS_VERSION_1;	/*	Version 1.0 */
-
-	/*	Config Method */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_CONF_METHOD);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0002);
-	wpsielen += 2;
-
-	/*	Value: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(pwdinfo->tx_prov_disc_info.wps_config_method_request);
-	wpsielen += 2;
-
-	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, wpsielen, (unsigned char *)wpsie, &pattrib->pktlen);
-
-	pattrib->last_txcmdsz = pattrib->pktlen;
-
-	dump_mgntframe(padapter, pmgntframe);
-
-	return;
-}
-
-static u8 is_matched_in_profilelist(u8 *peermacaddr, struct profile_info *profileinfo)
-{
-	u8 i, match_result = 0;
-
-	DBG_88E("[%s] peermac=%.2X %.2X %.2X %.2X %.2X %.2X\n", __func__,
-		peermacaddr[0], peermacaddr[1], peermacaddr[2], peermacaddr[3], peermacaddr[4], peermacaddr[5]);
-
-	for (i = 0; i < P2P_MAX_PERSISTENT_GROUP_NUM; i++, profileinfo++) {
-	       DBG_88E("[%s] profileinfo_mac=%.2X %.2X %.2X %.2X %.2X %.2X\n", __func__,
-			    profileinfo->peermac[0], profileinfo->peermac[1], profileinfo->peermac[2], profileinfo->peermac[3], profileinfo->peermac[4], profileinfo->peermac[5]);
-		if (!memcmp(peermacaddr, profileinfo->peermac, ETH_ALEN)) {
-			match_result = 1;
-			DBG_88E("[%s] Match!\n", __func__);
-			break;
-		}
-	}
-	return match_result;
-}
-
-void issue_probersp_p2p(struct adapter *padapter, unsigned char *da)
-{
-	struct xmit_frame			*pmgntframe;
-	struct pkt_attrib			*pattrib;
-	unsigned char					*pframe;
-	struct rtw_ieee80211_hdr	*pwlanhdr;
-	__le16 *fctrl;
-	unsigned char					*mac;
-	struct xmit_priv	*pxmitpriv = &(padapter->xmitpriv);
-	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
-	u16 beacon_interval = 100;
-	u16 capInfo = 0;
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-	u8 wpsie[255] = { 0x00 };
-	u32					wpsielen = 0, p2pielen = 0;
-
-	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
-		return;
-
-	/* update attribute */
-	pattrib = &pmgntframe->attrib;
-	update_mgntframe_attrib(padapter, pattrib);
-
-	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
-
-	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
-	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
-
-	mac = myid(&(padapter->eeprompriv));
-
-	fctrl = &(pwlanhdr->frame_ctl);
-	*(fctrl) = 0;
-	memcpy(pwlanhdr->addr1, da, ETH_ALEN);
-	memcpy(pwlanhdr->addr2, mac, ETH_ALEN);
-
-	/*	Use the device address for BSSID field. */
-	memcpy(pwlanhdr->addr3, mac, ETH_ALEN);
-
-	SetSeqNum(pwlanhdr, pmlmeext->mgnt_seq);
-	pmlmeext->mgnt_seq++;
-	SetFrameSubType(fctrl, WIFI_PROBERSP);
-
-	pattrib->hdrlen = sizeof(struct rtw_ieee80211_hdr_3addr);
-	pattrib->pktlen = pattrib->hdrlen;
-	pframe += pattrib->hdrlen;
-
-	/* timestamp will be inserted by hardware */
-	pframe += 8;
-	pattrib->pktlen += 8;
-
-	/*  beacon interval: 2 bytes */
-	memcpy(pframe, (unsigned char *)&beacon_interval, 2);
-	pframe += 2;
-	pattrib->pktlen += 2;
-
-	/*	capability info: 2 bytes */
-	/*	ESS and IBSS bits must be 0 (defined in the 3.1.2.1.1 of WiFi Direct Spec) */
-	capInfo |= cap_ShortPremble;
-	capInfo |= cap_ShortSlot;
-
-	memcpy(pframe, (unsigned char *)&capInfo, 2);
-	pframe += 2;
-	pattrib->pktlen += 2;
-
-
-	/*  SSID */
-	pframe = rtw_set_ie(pframe, _SSID_IE_, 7, pwdinfo->p2p_wildcard_ssid, &pattrib->pktlen);
-
-	/*  supported rates... */
-	/*	Use the OFDM rate in the P2P probe response frame. (6(B), 9(B), 12, 18, 24, 36, 48, 54) */
-	pframe = rtw_set_ie(pframe, _SUPPORTEDRATES_IE_, 8, pwdinfo->support_rate, &pattrib->pktlen);
-
-	/*  DS parameter set */
-	pframe = rtw_set_ie(pframe, _DSSET_IE_, 1, (unsigned char *)&pwdinfo->listen_channel, &pattrib->pktlen);
-
-	/*	Todo: WPS IE */
-	/*	Noted by Albert 20100907 */
-	/*	According to the WPS specification, all the WPS attribute is presented by Big Endian. */
-
-	wpsielen = 0;
-	/*	WPS OUI */
-	*(__be32 *)(wpsie) = cpu_to_be32(WPSOUI);
-	wpsielen += 4;
-
-	/*	WPS version */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_VER1);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0001);
-	wpsielen += 2;
-
-	/*	Value: */
-	wpsie[wpsielen++] = WPS_VERSION_1;	/*	Version 1.0 */
-
-	/*	WiFi Simple Config State */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_SIMPLE_CONF_STATE);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0001);
-	wpsielen += 2;
-
-	/*	Value: */
-	wpsie[wpsielen++] = WPS_WSC_STATE_NOT_CONFIG;	/*	Not Configured. */
-
-	/*	Response Type */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_RESP_TYPE);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0001);
-	wpsielen += 2;
-
-	/*	Value: */
-	wpsie[wpsielen++] = WPS_RESPONSE_TYPE_8021X;
-
-	/*	UUID-E */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_UUID_E);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0010);
-	wpsielen += 2;
-
-	/*	Value: */
-	memcpy(wpsie + wpsielen, myid(&padapter->eeprompriv), ETH_ALEN);
-	wpsielen += 0x10;
-
-	/*	Manufacturer */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_MANUFACTURER);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0007);
-	wpsielen += 2;
-
-	/*	Value: */
-	memcpy(wpsie + wpsielen, "Realtek", 7);
-	wpsielen += 7;
-
-	/*	Model Name */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_MODEL_NAME);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0006);
-	wpsielen += 2;
-
-	/*	Value: */
-	memcpy(wpsie + wpsielen, "8188EU", 6);
-	wpsielen += 6;
-
-	/*	Model Number */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_MODEL_NUMBER);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0001);
-	wpsielen += 2;
-
-	/*	Value: */
-	wpsie[wpsielen++] = 0x31;		/*	character 1 */
-
-	/*	Serial Number */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_SERIAL_NUMBER);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(ETH_ALEN);
-	wpsielen += 2;
-
-	/*	Value: */
-	memcpy(wpsie + wpsielen, "123456" , ETH_ALEN);
-	wpsielen += ETH_ALEN;
-
-	/*	Primary Device Type */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_PRIMARY_DEV_TYPE);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0008);
-	wpsielen += 2;
-
-	/*	Value: */
-	/*	Category ID */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_PDT_CID_MULIT_MEDIA);
-	wpsielen += 2;
-
-	/*	OUI */
-	*(__be32 *)(wpsie + wpsielen) = cpu_to_be32(WPSOUI);
-	wpsielen += 4;
-
-	/*	Sub Category ID */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_PDT_SCID_MEDIA_SERVER);
-	wpsielen += 2;
-
-	/*	Device Name */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_DEVICE_NAME);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(pwdinfo->device_name_len);
-	wpsielen += 2;
-
-	/*	Value: */
-	if (pwdinfo->device_name_len) {
-		memcpy(wpsie + wpsielen, pwdinfo->device_name, pwdinfo->device_name_len);
-		wpsielen += pwdinfo->device_name_len;
-	}
-
-	/*	Config Method */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_CONF_METHOD);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0002);
-	wpsielen += 2;
-
-	/*	Value: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(pwdinfo->supported_wps_cm);
-	wpsielen += 2;
-
-
-	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, wpsielen, (unsigned char *)wpsie, &pattrib->pktlen);
-
-
-	p2pielen = build_probe_resp_p2p_ie(pwdinfo, pframe);
-	pframe += p2pielen;
-	pattrib->pktlen += p2pielen;
-
-	pattrib->last_txcmdsz = pattrib->pktlen;
-
-	dump_mgntframe(padapter, pmgntframe);
-
-	return;
-}
-
-static int _issue_probereq_p2p(struct adapter *padapter, u8 *da, int wait_ack)
-{
-	int ret = _FAIL;
-	struct xmit_frame		*pmgntframe;
-	struct pkt_attrib		*pattrib;
-	unsigned char			*pframe;
-	struct rtw_ieee80211_hdr	*pwlanhdr;
-	__le16 *fctrl;
-	unsigned char			*mac;
-	struct xmit_priv		*pxmitpriv = &(padapter->xmitpriv);
-	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
-	u8 bc_addr[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-	u8 wpsie[255] = { 0x00 }, p2pie[255] = { 0x00 };
-	u16 wpsielen = 0, p2pielen = 0;
-	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-
-	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
-		goto exit;
-
-	/* update attribute */
-	pattrib = &pmgntframe->attrib;
-	update_mgntframe_attrib(padapter, pattrib);
-
-
-	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
-
-	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
-	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
-
-	mac = myid(&(padapter->eeprompriv));
-
-	fctrl = &(pwlanhdr->frame_ctl);
-	*(fctrl) = 0;
-
-	if (da) {
-		memcpy(pwlanhdr->addr1, da, ETH_ALEN);
-		memcpy(pwlanhdr->addr3, da, ETH_ALEN);
-	} else {
-		if ((pwdinfo->p2p_info.scan_op_ch_only) || (pwdinfo->rx_invitereq_info.scan_op_ch_only)) {
-			/*	This two flags will be set when this is only the P2P client mode. */
-			memcpy(pwlanhdr->addr1, pwdinfo->p2p_peer_interface_addr, ETH_ALEN);
-			memcpy(pwlanhdr->addr3, pwdinfo->p2p_peer_interface_addr, ETH_ALEN);
-		} else {
-			/*	broadcast probe request frame */
-			memcpy(pwlanhdr->addr1, bc_addr, ETH_ALEN);
-			memcpy(pwlanhdr->addr3, bc_addr, ETH_ALEN);
-		}
-	}
-	memcpy(pwlanhdr->addr2, mac, ETH_ALEN);
-
-	SetSeqNum(pwlanhdr, pmlmeext->mgnt_seq);
-	pmlmeext->mgnt_seq++;
-	SetFrameSubType(pframe, WIFI_PROBEREQ);
-
-	pframe += sizeof (struct rtw_ieee80211_hdr_3addr);
-	pattrib->pktlen = sizeof (struct rtw_ieee80211_hdr_3addr);
-
-	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_TX_PROVISION_DIS_REQ))
-		pframe = rtw_set_ie(pframe, _SSID_IE_, pwdinfo->tx_prov_disc_info.ssid.SsidLength, pwdinfo->tx_prov_disc_info.ssid.Ssid, &(pattrib->pktlen));
-	else
-		pframe = rtw_set_ie(pframe, _SSID_IE_, P2P_WILDCARD_SSID_LEN, pwdinfo->p2p_wildcard_ssid, &(pattrib->pktlen));
-
-	/*	Use the OFDM rate in the P2P probe request frame. (6(B), 9(B), 12(B), 24(B), 36, 48, 54) */
-	pframe = rtw_set_ie(pframe, _SUPPORTEDRATES_IE_, 8, pwdinfo->support_rate, &pattrib->pktlen);
-
-
-	/*	WPS IE */
-	/*	Noted by Albert 20110221 */
-	/*	According to the WPS specification, all the WPS attribute is presented by Big Endian. */
-
-	wpsielen = 0;
-	/*	WPS OUI */
-	*(__be32 *)(wpsie) = cpu_to_be32(WPSOUI);
-	wpsielen += 4;
-
-	/*	WPS version */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_VER1);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0001);
-	wpsielen += 2;
-
-	/*	Value: */
-	wpsie[wpsielen++] = WPS_VERSION_1;	/*	Version 1.0 */
-
-	if (pmlmepriv->wps_probe_req_ie == NULL) {
-		/*	UUID-E */
-		/*	Type: */
-		*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_UUID_E);
-		wpsielen += 2;
-
-		/*	Length: */
-		*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0010);
-		wpsielen += 2;
-
-		/*	Value: */
-		memcpy(wpsie + wpsielen, myid(&padapter->eeprompriv), ETH_ALEN);
-		wpsielen += 0x10;
-
-		/*	Config Method */
-		/*	Type: */
-		*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_CONF_METHOD);
-		wpsielen += 2;
-
-		/*	Length: */
-		*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0002);
-		wpsielen += 2;
-
-		/*	Value: */
-		*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(pwdinfo->supported_wps_cm);
-		wpsielen += 2;
-	}
-
-	/*	Device Name */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_DEVICE_NAME);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(pwdinfo->device_name_len);
-	wpsielen += 2;
-
-	/*	Value: */
-	memcpy(wpsie + wpsielen, pwdinfo->device_name, pwdinfo->device_name_len);
-	wpsielen += pwdinfo->device_name_len;
-
-	/*	Primary Device Type */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_PRIMARY_DEV_TYPE);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0008);
-	wpsielen += 2;
-
-	/*	Value: */
-	/*	Category ID */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_PDT_CID_RTK_WIDI);
-	wpsielen += 2;
-
-	/*	OUI */
-	*(__be32 *)(wpsie + wpsielen) = cpu_to_be32(WPSOUI);
-	wpsielen += 4;
-
-	/*	Sub Category ID */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_PDT_SCID_RTK_DMP);
-	wpsielen += 2;
-
-	/*	Device Password ID */
-	/*	Type: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_ATTR_DEVICE_PWID);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(0x0002);
-	wpsielen += 2;
-
-	/*	Value: */
-	*(__be16 *)(wpsie + wpsielen) = cpu_to_be16(WPS_DPID_REGISTRAR_SPEC);	/*	Registrar-specified */
-	wpsielen += 2;
-
-	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, wpsielen, (unsigned char *)wpsie, &pattrib->pktlen);
-
-	/*	P2P OUI */
-	p2pielen = 0;
-	p2pie[p2pielen++] = 0x50;
-	p2pie[p2pielen++] = 0x6F;
-	p2pie[p2pielen++] = 0x9A;
-	p2pie[p2pielen++] = 0x09;	/*	WFA P2P v1.0 */
-
-	/*	Commented by Albert 20110221 */
-	/*	According to the P2P Specification, the probe request frame should contain 5 P2P attributes */
-	/*	1. P2P Capability */
-	/*	2. P2P Device ID if this probe request wants to find the specific P2P device */
-	/*	3. Listen Channel */
-	/*	4. Extended Listen Timing */
-	/*	5. Operating Channel if this WiFi is working as the group owner now */
-
-	/*	P2P Capability */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_CAPABILITY;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0002);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Device Capability Bitmap, 1 byte */
-	p2pie[p2pielen++] = DMP_P2P_DEVCAP_SUPPORT;
-
-	/*	Group Capability Bitmap, 1 byte */
-	if (pwdinfo->persistent_supported)
-		p2pie[p2pielen++] = P2P_GRPCAP_PERSISTENT_GROUP | DMP_P2P_GRPCAP_SUPPORT;
-	else
-		p2pie[p2pielen++] = DMP_P2P_GRPCAP_SUPPORT;
-
-	/*	Listen Channel */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_LISTEN_CH;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0005);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Country String */
-	p2pie[p2pielen++] = 'X';
-	p2pie[p2pielen++] = 'X';
-
-	/*	The third byte should be set to 0x04. */
-	/*	Described in the "Operating Channel Attribute" section. */
-	p2pie[p2pielen++] = 0x04;
-
-	/*	Operating Class */
-	p2pie[p2pielen++] = 0x51;	/*	Copy from SD7 */
-
-	/*	Channel Number */
-	p2pie[p2pielen++] = pwdinfo->listen_channel;	/*	listen channel */
-
-
-	/*	Extended Listen Timing */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_EX_LISTEN_TIMING;
-
-	/*	Length: */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0004);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Availability Period */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0xFFFF);
-	p2pielen += 2;
-
-	/*	Availability Interval */
-	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0xFFFF);
-	p2pielen += 2;
-
-	if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO)) {
-		/*	Operating Channel (if this WiFi is working as the group owner now) */
-		/*	Type: */
-		p2pie[p2pielen++] = P2P_ATTR_OPERATING_CH;
-
-		/*	Length: */
-		*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0005);
-		p2pielen += 2;
-
-		/*	Value: */
-		/*	Country String */
-		p2pie[p2pielen++] = 'X';
-		p2pie[p2pielen++] = 'X';
-
-		/*	The third byte should be set to 0x04. */
-		/*	Described in the "Operating Channel Attribute" section. */
-		p2pie[p2pielen++] = 0x04;
-
-		/*	Operating Class */
-		p2pie[p2pielen++] = 0x51;	/*	Copy from SD7 */
-
-		/*	Channel Number */
-		p2pie[p2pielen++] = pwdinfo->operating_channel;	/*	operating channel number */
-	}
-
-	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, p2pielen, (unsigned char *)p2pie, &pattrib->pktlen);
-
-	if (pmlmepriv->wps_probe_req_ie != NULL) {
-		/* WPS IE */
-		memcpy(pframe, pmlmepriv->wps_probe_req_ie, pmlmepriv->wps_probe_req_ie_len);
-		pattrib->pktlen += pmlmepriv->wps_probe_req_ie_len;
-		pframe += pmlmepriv->wps_probe_req_ie_len;
-	}
-
-	pattrib->last_txcmdsz = pattrib->pktlen;
-
-	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_, ("issuing probe_req, tx_len=%d\n", pattrib->last_txcmdsz));
-
-	if (wait_ack) {
-		ret = dump_mgntframe_and_wait_ack(padapter, pmgntframe);
-	} else {
-		dump_mgntframe(padapter, pmgntframe);
-		ret = _SUCCESS;
+		break;
 	}
 
 exit:
 	return ret;
 }
 
-inline void issue_probereq_p2p(struct adapter *adapter, u8 *da)
+unsigned int OnAction_qos(struct adapter *padapter, struct recv_frame *precv_frame)
 {
-	_issue_probereq_p2p(adapter, da, false);
+	return _SUCCESS;
 }
 
-int issue_probereq_p2p_ex(struct adapter *adapter, u8 *da, int try_cnt, int wait_ms)
+unsigned int OnAction_dls(struct adapter *padapter, struct recv_frame *precv_frame)
 {
-	int ret;
-	int i = 0;
-	u32 start = jiffies;
+	return _SUCCESS;
+}
 
-	do {
-		ret = _issue_probereq_p2p(adapter, da, wait_ms > 0 ? true : false);
+unsigned int OnAction_back(struct adapter *padapter, struct recv_frame *precv_frame)
+{
+	u8 *addr;
+	struct sta_info *psta = NULL;
+	struct recv_reorder_ctrl *preorder_ctrl;
+	unsigned char		*frame_body;
+	unsigned char		category, action;
+	unsigned short	tid, status, reason_code = 0;
+	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
+	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
+	u8 *pframe = precv_frame->rx_data;
+	struct sta_priv *pstapriv = &padapter->stapriv;
+	/* check RA matches or not */
+	if (memcmp(myid(&(padapter->eeprompriv)), GetAddr1Ptr(pframe),
+		   ETH_ALEN))/* for if1, sta/ap mode */
+		return _SUCCESS;
 
-		i++;
+	DBG_88E("%s\n", __func__);
 
-		if (adapter->bDriverStopped || adapter->bSurpriseRemoved)
-			break;
+	if ((pmlmeinfo->state&0x03) != WIFI_FW_AP_STATE)
+		if (!(pmlmeinfo->state & WIFI_FW_ASSOC_SUCCESS))
+			return _SUCCESS;
 
-		if (i < try_cnt && wait_ms > 0 && ret == _FAIL)
-			msleep(wait_ms);
-	} while ((i < try_cnt) && ((ret == _FAIL) || (wait_ms == 0)));
+	addr = GetAddr2Ptr(pframe);
+	psta = rtw_get_stainfo(pstapriv, addr);
 
-	if (ret != _FAIL) {
-		ret = _SUCCESS;
-		goto exit;
-	}
+	if (psta == NULL)
+		return _SUCCESS;
 
-	if (try_cnt && wait_ms) {
-		if (da)
-			DBG_88E(FUNC_ADPT_FMT" to %pM, ch:%u%s, %d/%d in %u ms\n",
-				FUNC_ADPT_ARG(adapter), da, rtw_get_oper_ch(adapter),
-				ret == _SUCCESS ? ", acked" : "", i, try_cnt, rtw_get_passing_time_ms(start));
-		else
-			DBG_88E(FUNC_ADPT_FMT", ch:%u%s, %d/%d in %u ms\n",
-				FUNC_ADPT_ARG(adapter), rtw_get_oper_ch(adapter),
-				ret == _SUCCESS ? ", acked" : "", i, try_cnt, rtw_get_passing_time_ms(start));
+	frame_body = (unsigned char *)(pframe + sizeof(struct rtw_ieee80211_hdr_3addr));
+
+	category = frame_body[0];
+	if (category == RTW_WLAN_CATEGORY_BACK) { /*  representing Block Ack */
+		if (!pmlmeinfo->HT_enable)
+			return _SUCCESS;
+		action = frame_body[1];
+		DBG_88E("%s, action=%d\n", __func__, action);
+		switch (action) {
+		case RTW_WLAN_ACTION_ADDBA_REQ: /* ADDBA request */
+			memcpy(&(pmlmeinfo->ADDBA_req), &(frame_body[2]), sizeof(struct ADDBA_request));
+			process_addba_req(padapter, (u8 *)&(pmlmeinfo->ADDBA_req), addr);
+
+			if (pmlmeinfo->bAcceptAddbaReq)
+				issue_action_BA(padapter, addr, RTW_WLAN_ACTION_ADDBA_RESP, 0);
+			else
+				issue_action_BA(padapter, addr, RTW_WLAN_ACTION_ADDBA_RESP, 37);/* reject ADDBA Req */
+			break;
+		case RTW_WLAN_ACTION_ADDBA_RESP: /* ADDBA response */
+			status = get_unaligned_le16(&frame_body[3]);
+			tid = ((frame_body[5] >> 2) & 0x7);
+			if (status == 0) {	/* successful */
+				DBG_88E("agg_enable for TID=%d\n", tid);
+				psta->htpriv.agg_enable_bitmap |= 1 << tid;
+				psta->htpriv.candidate_tid_bitmap &= ~BIT(tid);
+			} else {
+				psta->htpriv.agg_enable_bitmap &= ~BIT(tid);
+			}
+			break;
+		case RTW_WLAN_ACTION_DELBA: /* DELBA */
+			if ((frame_body[3] & BIT(3)) == 0) {
+				psta->htpriv.agg_enable_bitmap &= ~(1 << ((frame_body[3] >> 4) & 0xf));
+				psta->htpriv.candidate_tid_bitmap &= ~(1 << ((frame_body[3] >> 4) & 0xf));
+				reason_code = get_unaligned_le16(&frame_body[4]);
+			} else if ((frame_body[3] & BIT(3)) == BIT(3)) {
+				tid = (frame_body[3] >> 4) & 0x0F;
+				preorder_ctrl =  &psta->recvreorder_ctrl[tid];
+				preorder_ctrl->enable = false;
+				preorder_ctrl->indicate_seq = 0xffff;
+			}
+			DBG_88E("%s(): DELBA: %x(%x)\n", __func__, pmlmeinfo->agg_enable_bitmap, reason_code);
+			/* todo: how to notify the host while receiving DELETE BA */
+			break;
+		default:
+			break;
+		}
 	}
-exit:
-	return ret;
+	return _SUCCESS;
 }
 
-#endif /* CONFIG_88EU_P2P */
-
 static s32 rtw_action_public_decache(struct recv_frame *recv_frame, s32 token)
 {
 	struct adapter *adapter = recv_frame->adapter;
@@ -3893,16 +1716,6 @@ static unsigned int on_action_public_p2p(struct recv_frame *precv_frame)
 	u8 *pframe = precv_frame->rx_data;
 	u8 *frame_body;
 	u8 dialogToken = 0;
-#ifdef CONFIG_88EU_P2P
-	struct adapter *padapter = precv_frame->adapter;
-	uint len = precv_frame->len;
-	u8 *p2p_ie;
-	u32	p2p_ielen;
-	struct	wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-	u8	result = P2P_STATUS_SUCCESS;
-	u8	empty_addr[ETH_ALEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
-#endif /* CONFIG_88EU_P2P */
-
 	frame_body = (unsigned char *)(pframe + sizeof(struct rtw_ieee80211_hdr_3addr));
 
 	dialogToken = frame_body[7];
@@ -3910,272 +1723,6 @@ static unsigned int on_action_public_p2p(struct recv_frame *precv_frame)
 	if (rtw_action_public_decache(precv_frame, dialogToken) == _FAIL)
 		return _FAIL;
 
-#ifdef CONFIG_88EU_P2P
-	del_timer_sync(&pwdinfo->reset_ch_sitesurvey);
-	/*	Do nothing if the driver doesn't enable the P2P function. */
-	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE) || rtw_p2p_chk_state(pwdinfo, P2P_STATE_IDLE))
-		return _SUCCESS;
-
-	len -= sizeof(struct rtw_ieee80211_hdr_3addr);
-
-	switch (frame_body[6]) { /* OUI Subtype */
-	case P2P_GO_NEGO_REQ:
-		DBG_88E("[%s] Got GO Nego Req Frame\n", __func__);
-		memset(&pwdinfo->groupid_info, 0x00, sizeof(struct group_id_info));
-
-		if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_RX_PROVISION_DIS_REQ))
-			rtw_p2p_set_state(pwdinfo, rtw_p2p_pre_state(pwdinfo));
-
-		if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_GONEGO_FAIL)) {
-			/*	Commented by Albert 20110526 */
-			/*	In this case, this means the previous nego fail doesn't be reset yet. */
-			del_timer_sync(&pwdinfo->restore_p2p_state_timer);
-			/*	Restore the previous p2p state */
-			rtw_p2p_set_state(pwdinfo, rtw_p2p_pre_state(pwdinfo));
-			DBG_88E("[%s] Restore the previous p2p state to %d\n", __func__, rtw_p2p_state(pwdinfo));
-		}
-
-		/*	Commented by Kurt 20110902 */
-		/* Add if statement to avoid receiving duplicate prov disc req. such that pre_p2p_state would be covered. */
-		if (!rtw_p2p_chk_state(pwdinfo, P2P_STATE_GONEGO_ING))
-			rtw_p2p_set_pre_state(pwdinfo, rtw_p2p_state(pwdinfo));
-
-		/*	Commented by Kurt 20120113 */
-		/*	Get peer_dev_addr here if peer doesn't issue prov_disc frame. */
-		if (!memcmp(pwdinfo->rx_prov_disc_info.peerDevAddr, empty_addr,
-			    ETH_ALEN))
-			memcpy(pwdinfo->rx_prov_disc_info.peerDevAddr, GetAddr2Ptr(pframe), ETH_ALEN);
-
-		result = process_p2p_group_negotation_req(pwdinfo, frame_body, len);
-		issue_p2p_GO_response(padapter, GetAddr2Ptr(pframe), frame_body, len, result);
-
-		/*	Commented by Albert 20110718 */
-		/*	No matter negotiating or negotiation failure, the driver should set up the restore P2P state timer. */
-		_set_timer(&pwdinfo->restore_p2p_state_timer, 5000);
-		break;
-	case P2P_GO_NEGO_RESP:
-		DBG_88E("[%s] Got GO Nego Resp Frame\n", __func__);
-
-		if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_GONEGO_ING)) {
-			/*	Commented by Albert 20110425 */
-			/*	The restore timer is enabled when issuing the nego request frame of rtw_p2p_connect function. */
-			del_timer_sync(&pwdinfo->restore_p2p_state_timer);
-			pwdinfo->nego_req_info.benable = false;
-			result = process_p2p_group_negotation_resp(pwdinfo, frame_body, len);
-			issue_p2p_GO_confirm(pwdinfo->padapter, GetAddr2Ptr(pframe), result);
-			if (P2P_STATUS_SUCCESS == result) {
-				if (rtw_p2p_role(pwdinfo) == P2P_ROLE_CLIENT) {
-					pwdinfo->p2p_info.operation_ch[0] = pwdinfo->peer_operating_ch;
-					pwdinfo->p2p_info.scan_op_ch_only = 1;
-					_set_timer(&pwdinfo->reset_ch_sitesurvey2, P2P_RESET_SCAN_CH);
-				}
-			}
-			/*	Reset the dialog token for group negotiation frames. */
-			pwdinfo->negotiation_dialog_token = 1;
-			if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_GONEGO_FAIL))
-				_set_timer(&pwdinfo->restore_p2p_state_timer, 5000);
-		} else {
-			DBG_88E("[%s] Skipped GO Nego Resp Frame (p2p_state != P2P_STATE_GONEGO_ING)\n", __func__);
-		}
-		break;
-	case P2P_GO_NEGO_CONF:
-		DBG_88E("[%s] Got GO Nego Confirm Frame\n", __func__);
-		result = process_p2p_group_negotation_confirm(pwdinfo, frame_body, len);
-		if (P2P_STATUS_SUCCESS == result) {
-			if (rtw_p2p_role(pwdinfo) == P2P_ROLE_CLIENT) {
-				pwdinfo->p2p_info.operation_ch[0] = pwdinfo->peer_operating_ch;
-				pwdinfo->p2p_info.scan_op_ch_only = 1;
-				_set_timer(&pwdinfo->reset_ch_sitesurvey2, P2P_RESET_SCAN_CH);
-			}
-		}
-		break;
-	case P2P_INVIT_REQ:
-		/*	Added by Albert 2010/10/05 */
-		/*	Received the P2P Invite Request frame. */
-
-		DBG_88E("[%s] Got invite request frame!\n", __func__);
-		p2p_ie = rtw_get_p2p_ie(frame_body + _PUBLIC_ACTION_IE_OFFSET_, len - _PUBLIC_ACTION_IE_OFFSET_, NULL, &p2p_ielen);
-		if (p2p_ie) {
-			/*	Parse the necessary information from the P2P Invitation Request frame. */
-			/*	For example: The MAC address of sending this P2P Invitation Request frame. */
-			u32	attr_contentlen = 0;
-			u8	status_code = P2P_STATUS_FAIL_INFO_UNAVAILABLE;
-			struct group_id_info group_id;
-			u8	invitation_flag = 0;
-
-			rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_INVITATION_FLAGS, &invitation_flag, &attr_contentlen);
-			if (attr_contentlen) {
-				rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_GROUP_BSSID, pwdinfo->p2p_peer_interface_addr, &attr_contentlen);
-				/*	Commented by Albert 20120510 */
-				/*	Copy to the pwdinfo->p2p_peer_interface_addr. */
-				/*	So that the WFD UI (or Sigma) can get the peer interface address by using the following command. */
-				/*	#> iwpriv wlan0 p2p_get peer_ifa */
-				/*	After having the peer interface address, the sigma can find the correct conf file for wpa_supplicant. */
-
-				if (attr_contentlen) {
-					DBG_88E("[%s] GO's BSSID = %.2X %.2X %.2X %.2X %.2X %.2X\n", __func__,
-						pwdinfo->p2p_peer_interface_addr[0], pwdinfo->p2p_peer_interface_addr[1],
-						pwdinfo->p2p_peer_interface_addr[2], pwdinfo->p2p_peer_interface_addr[3],
-						pwdinfo->p2p_peer_interface_addr[4], pwdinfo->p2p_peer_interface_addr[5]);
-				}
-
-				if (invitation_flag & P2P_INVITATION_FLAGS_PERSISTENT) {
-					/*	Re-invoke the persistent group. */
-
-					memset(&group_id, 0x00, sizeof(struct group_id_info));
-					rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_GROUP_ID, (u8 *)&group_id, &attr_contentlen);
-					if (attr_contentlen) {
-						if (!memcmp(group_id.go_device_addr, myid(&padapter->eeprompriv), ETH_ALEN)) {
-							/*	The p2p device sending this p2p invitation request wants this Wi-Fi device to be the persistent GO. */
-							rtw_p2p_set_state(pwdinfo, P2P_STATE_RECV_INVITE_REQ_GO);
-							rtw_p2p_set_role(pwdinfo, P2P_ROLE_GO);
-							status_code = P2P_STATUS_SUCCESS;
-						} else {
-							/*	The p2p device sending this p2p invitation request wants to be the persistent GO. */
-							if (is_matched_in_profilelist(pwdinfo->p2p_peer_interface_addr, &pwdinfo->profileinfo[0])) {
-								u8 operatingch_info[5] = { 0x00 };
-								if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_OPERATING_CH, operatingch_info, &attr_contentlen)) {
-									if (rtw_ch_set_search_ch(padapter->mlmeextpriv.channel_set, (u32)operatingch_info[4])) {
-										/*	The operating channel is acceptable for this device. */
-										pwdinfo->rx_invitereq_info.operation_ch[0] = operatingch_info[4];
-										pwdinfo->rx_invitereq_info.scan_op_ch_only = 1;
-										_set_timer(&pwdinfo->reset_ch_sitesurvey, P2P_RESET_SCAN_CH);
-										rtw_p2p_set_state(pwdinfo, P2P_STATE_RECV_INVITE_REQ_MATCH);
-										rtw_p2p_set_role(pwdinfo, P2P_ROLE_CLIENT);
-										status_code = P2P_STATUS_SUCCESS;
-									} else {
-										/*	The operating channel isn't supported by this device. */
-										rtw_p2p_set_state(pwdinfo, P2P_STATE_RECV_INVITE_REQ_DISMATCH);
-										rtw_p2p_set_role(pwdinfo, P2P_ROLE_DEVICE);
-										status_code = P2P_STATUS_FAIL_NO_COMMON_CH;
-										_set_timer(&pwdinfo->restore_p2p_state_timer, 3000);
-									}
-								} else {
-									/*	Commented by Albert 20121130 */
-									/*	Intel will use the different P2P IE to store the operating channel information */
-									/*	Workaround for Intel WiDi 3.5 */
-									rtw_p2p_set_state(pwdinfo, P2P_STATE_RECV_INVITE_REQ_MATCH);
-									rtw_p2p_set_role(pwdinfo, P2P_ROLE_CLIENT);
-									status_code = P2P_STATUS_SUCCESS;
-								}
-							} else {
-								rtw_p2p_set_state(pwdinfo, P2P_STATE_RECV_INVITE_REQ_DISMATCH);
-								status_code = P2P_STATUS_FAIL_UNKNOWN_P2PGROUP;
-							}
-						}
-					} else {
-						DBG_88E("[%s] P2P Group ID Attribute NOT FOUND!\n", __func__);
-						status_code = P2P_STATUS_FAIL_INFO_UNAVAILABLE;
-					}
-				} else {
-					/*	Received the invitation to join a P2P group. */
-
-					memset(&group_id, 0x00, sizeof(struct group_id_info));
-					rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_GROUP_ID, (u8 *)&group_id, &attr_contentlen);
-					if (attr_contentlen) {
-						if (!memcmp(group_id.go_device_addr, myid(&padapter->eeprompriv), ETH_ALEN)) {
-							/*	In this case, the GO can't be myself. */
-							rtw_p2p_set_state(pwdinfo, P2P_STATE_RECV_INVITE_REQ_DISMATCH);
-							status_code = P2P_STATUS_FAIL_INFO_UNAVAILABLE;
-						} else {
-							/*	The p2p device sending this p2p invitation request wants to join an existing P2P group */
-							/*	Commented by Albert 2012/06/28 */
-							/*	In this case, this Wi-Fi device should use the iwpriv command to get the peer device address. */
-							/*	The peer device address should be the destination address for the provisioning discovery request. */
-							/*	Then, this Wi-Fi device should use the iwpriv command to get the peer interface address. */
-							/*	The peer interface address should be the address for WPS mac address */
-							memcpy(pwdinfo->p2p_peer_device_addr, group_id.go_device_addr , ETH_ALEN);
-							rtw_p2p_set_role(pwdinfo, P2P_ROLE_CLIENT);
-							rtw_p2p_set_state(pwdinfo, P2P_STATE_RECV_INVITE_REQ_JOIN);
-							status_code = P2P_STATUS_SUCCESS;
-						}
-					} else {
-						DBG_88E("[%s] P2P Group ID Attribute NOT FOUND!\n", __func__);
-						status_code = P2P_STATUS_FAIL_INFO_UNAVAILABLE;
-					}
-				}
-			} else {
-				DBG_88E("[%s] P2P Invitation Flags Attribute NOT FOUND!\n", __func__);
-				status_code = P2P_STATUS_FAIL_INFO_UNAVAILABLE;
-			}
-
-			DBG_88E("[%s] status_code = %d\n", __func__, status_code);
-
-			pwdinfo->inviteresp_info.token = frame_body[7];
-			issue_p2p_invitation_response(padapter, GetAddr2Ptr(pframe), pwdinfo->inviteresp_info.token, status_code);
-		}
-		break;
-	case P2P_INVIT_RESP: {
-		u8	attr_content = 0x00;
-		u32	attr_contentlen = 0;
-
-		DBG_88E("[%s] Got invite response frame!\n", __func__);
-		del_timer_sync(&pwdinfo->restore_p2p_state_timer);
-		p2p_ie = rtw_get_p2p_ie(frame_body + _PUBLIC_ACTION_IE_OFFSET_, len - _PUBLIC_ACTION_IE_OFFSET_, NULL, &p2p_ielen);
-		if (p2p_ie) {
-			rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_STATUS, &attr_content, &attr_contentlen);
-
-			if (attr_contentlen == 1) {
-				DBG_88E("[%s] Status = %d\n", __func__, attr_content);
-				pwdinfo->invitereq_info.benable = false;
-
-				if (attr_content == P2P_STATUS_SUCCESS) {
-					if (!memcmp(pwdinfo->invitereq_info.go_bssid, myid(&padapter->eeprompriv), ETH_ALEN)) {
-						rtw_p2p_set_role(pwdinfo, P2P_ROLE_GO);
-					} else {
-						rtw_p2p_set_role(pwdinfo, P2P_ROLE_CLIENT);
-					}
-					rtw_p2p_set_state(pwdinfo, P2P_STATE_RX_INVITE_RESP_OK);
-				} else {
-					rtw_p2p_set_role(pwdinfo, P2P_ROLE_DEVICE);
-					rtw_p2p_set_state(pwdinfo, P2P_STATE_RX_INVITE_RESP_FAIL);
-				}
-			} else {
-				rtw_p2p_set_role(pwdinfo, P2P_ROLE_DEVICE);
-				rtw_p2p_set_state(pwdinfo, P2P_STATE_RX_INVITE_RESP_FAIL);
-			}
-		} else {
-			rtw_p2p_set_role(pwdinfo, P2P_ROLE_DEVICE);
-			rtw_p2p_set_state(pwdinfo, P2P_STATE_RX_INVITE_RESP_FAIL);
-		}
-
-		if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_RX_INVITE_RESP_FAIL))
-			_set_timer(&pwdinfo->restore_p2p_state_timer, 5000);
-		break;
-	}
-	case P2P_DEVDISC_REQ:
-		process_p2p_devdisc_req(pwdinfo, pframe, len);
-		break;
-	case P2P_DEVDISC_RESP:
-		process_p2p_devdisc_resp(pwdinfo, pframe, len);
-		break;
-	case P2P_PROVISION_DISC_REQ:
-		DBG_88E("[%s] Got Provisioning Discovery Request Frame\n", __func__);
-		process_p2p_provdisc_req(pwdinfo, pframe, len);
-		memcpy(pwdinfo->rx_prov_disc_info.peerDevAddr, GetAddr2Ptr(pframe), ETH_ALEN);
-
-		/* 20110902 Kurt */
-		/* Add the following statement to avoid receiving duplicate prov disc req. such that pre_p2p_state would be covered. */
-		if (!rtw_p2p_chk_state(pwdinfo, P2P_STATE_RX_PROVISION_DIS_REQ))
-			rtw_p2p_set_pre_state(pwdinfo, rtw_p2p_state(pwdinfo));
-
-		rtw_p2p_set_state(pwdinfo, P2P_STATE_RX_PROVISION_DIS_REQ);
-		_set_timer(&pwdinfo->restore_p2p_state_timer, P2P_PROVISION_TIMEOUT);
-		break;
-	case P2P_PROVISION_DISC_RESP:
-		/*	Commented by Albert 20110707 */
-		/*	Should we check the pwdinfo->tx_prov_disc_info.bsent flag here?? */
-		DBG_88E("[%s] Got Provisioning Discovery Response Frame\n", __func__);
-		/*	Commented by Albert 20110426 */
-		/*	The restore timer is enabled when issuing the provisioing request frame in rtw_p2p_prov_disc function. */
-		del_timer_sync(&pwdinfo->restore_p2p_state_timer);
-		rtw_p2p_set_state(pwdinfo, P2P_STATE_RX_PROVISION_DIS_RSP);
-		process_p2p_provdisc_resp(pwdinfo, pframe);
-		_set_timer(&pwdinfo->restore_p2p_state_timer, P2P_PROVISION_TIMEOUT);
-		break;
-	}
-#endif /* CONFIG_88EU_P2P */
-
 	return _SUCCESS;
 }
 
@@ -4250,46 +1797,6 @@ unsigned int OnAction_wmm(struct adapter *padapter, struct recv_frame *precv_fra
 
 unsigned int OnAction_p2p(struct adapter *padapter, struct recv_frame *precv_frame)
 {
-#ifdef CONFIG_88EU_P2P
-	u8 *frame_body;
-	u8 category, OUI_Subtype;
-	u8 *pframe = precv_frame->rx_data;
-	uint len = precv_frame->len;
-	struct	wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-
-
-	DBG_88E("%s\n", __func__);
-
-	/* check RA matches or not */
-	if (memcmp(myid(&(padapter->eeprompriv)), GetAddr1Ptr(pframe), ETH_ALEN))/* for if1, sta/ap mode */
-		return _SUCCESS;
-
-	frame_body = (unsigned char *)(pframe + sizeof(struct rtw_ieee80211_hdr_3addr));
-
-	category = frame_body[0];
-	if (category != RTW_WLAN_CATEGORY_P2P)
-		return _SUCCESS;
-
-	if (be32_to_cpu(*((__be32 *)(frame_body + 1))) != P2POUI)
-		return _SUCCESS;
-
-	len -= sizeof(struct rtw_ieee80211_hdr_3addr);
-	OUI_Subtype = frame_body[5];
-
-	switch (OUI_Subtype) {
-	case P2P_NOTICE_OF_ABSENCE:
-		break;
-	case P2P_PRESENCE_REQUEST:
-		process_p2p_presence_req(pwdinfo, pframe, len);
-		break;
-	case P2P_PRESENCE_RESPONSE:
-		break;
-	case P2P_GO_DISC_REQUEST:
-		break;
-	default:
-		break;
-	}
-#endif /* CONFIG_88EU_P2P */
 	return _SUCCESS;
 }
 
@@ -4487,9 +1994,6 @@ void issue_beacon(struct adapter *padapter, int timeout_ms)
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 	struct wlan_bssid_ex		*cur_network = &(pmlmeinfo->network);
 	u8	bc_addr[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-#endif /* CONFIG_88EU_P2P */
 
 	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
 	if (pmgntframe == NULL) {
@@ -4526,108 +2030,26 @@ void issue_beacon(struct adapter *padapter, int timeout_ms)
 	pattrib->pktlen = sizeof (struct rtw_ieee80211_hdr_3addr);
 
 	if ((pmlmeinfo->state&0x03) == WIFI_FW_AP_STATE) {
-#ifdef CONFIG_88EU_P2P
-		/*  for P2P : Primary Device Type & Device Name */
-		u32 wpsielen = 0, insert_len = 0;
-		u8 *wpsie = NULL;
-		wpsie = rtw_get_wps_ie(cur_network->IEs+_FIXED_IE_LENGTH_, cur_network->IELength-_FIXED_IE_LENGTH_, NULL, &wpsielen);
-
-		if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO) && wpsie && wpsielen > 0) {
-			uint wps_offset, remainder_ielen;
-			u8 *premainder_ie, *pframe_wscie;
-
-			wps_offset = (uint)(wpsie - cur_network->IEs);
-			premainder_ie = wpsie + wpsielen;
-			remainder_ielen = cur_network->IELength - wps_offset - wpsielen;
-			pframe_wscie = pframe + wps_offset;
-			memcpy(pframe, cur_network->IEs, wps_offset+wpsielen);
-			pframe += (wps_offset + wpsielen);
-			pattrib->pktlen += (wps_offset + wpsielen);
-
-			/* now pframe is end of wsc ie, insert Primary Device Type & Device Name */
-			/*	Primary Device Type */
-			/*	Type: */
-			*(__be16 *)(pframe + insert_len) = cpu_to_be16(WPS_ATTR_PRIMARY_DEV_TYPE);
-			insert_len += 2;
-
-			/*	Length: */
-			*(__be16 *)(pframe + insert_len) = cpu_to_be16(0x0008);
-			insert_len += 2;
-
-			/*	Value: */
-			/*	Category ID */
-			*(__be16 *)(pframe + insert_len) = cpu_to_be16(WPS_PDT_CID_MULIT_MEDIA);
-			insert_len += 2;
-
-			/*	OUI */
-			*(__be32 *)(pframe + insert_len) = cpu_to_be32(WPSOUI);
-			insert_len += 4;
-
-			/*	Sub Category ID */
-			*(__be16 *)(pframe + insert_len) = cpu_to_be16(WPS_PDT_SCID_MEDIA_SERVER);
-			insert_len += 2;
-
-			/*	Device Name */
-			/*	Type: */
-			*(__be16 *)(pframe + insert_len) = cpu_to_be16(WPS_ATTR_DEVICE_NAME);
-			insert_len += 2;
-
-			/*	Length: */
-			*(__be16 *)(pframe + insert_len) = cpu_to_be16(pwdinfo->device_name_len);
-			insert_len += 2;
-
-			/*	Value: */
-			memcpy(pframe + insert_len, pwdinfo->device_name, pwdinfo->device_name_len);
-			insert_len += pwdinfo->device_name_len;
-
-			/* update wsc ie length */
-			*(pframe_wscie+1) = (wpsielen-2) + insert_len;
-
-			/* pframe move to end */
-			pframe += insert_len;
-			pattrib->pktlen += insert_len;
-
-			/* copy remainder_ie to pframe */
-			memcpy(pframe, premainder_ie, remainder_ielen);
-			pframe += remainder_ielen;
-			pattrib->pktlen += remainder_ielen;
-		} else
-#endif /* CONFIG_88EU_P2P */
-		{
-			int len_diff;
-			memcpy(pframe, cur_network->IEs, cur_network->IELength);
-			len_diff = update_hidden_ssid(
-				pframe+_BEACON_IE_OFFSET_
-				, cur_network->IELength-_BEACON_IE_OFFSET_
-				, pmlmeinfo->hidden_ssid_mode
+		int len_diff;
+		u8 *wps_ie;
+		uint wps_ielen;
+		u8 sr = 0;
+		memcpy(pframe, cur_network->IEs, cur_network->IELength);
+		len_diff = update_hidden_ssid(
+			pframe+_BEACON_IE_OFFSET_
+			, cur_network->IELength-_BEACON_IE_OFFSET_
+			, pmlmeinfo->hidden_ssid_mode
 			);
-			pframe += (cur_network->IELength+len_diff);
-			pattrib->pktlen += (cur_network->IELength+len_diff);
-		}
-
-		{
-			u8 *wps_ie;
-			uint wps_ielen;
-			u8 sr = 0;
-			wps_ie = rtw_get_wps_ie(pmgntframe->buf_addr+TXDESC_OFFSET+sizeof (struct rtw_ieee80211_hdr_3addr)+_BEACON_IE_OFFSET_,
-				pattrib->pktlen-sizeof (struct rtw_ieee80211_hdr_3addr)-_BEACON_IE_OFFSET_, NULL, &wps_ielen);
-			if (wps_ie && wps_ielen > 0)
-				rtw_get_wps_attr_content(wps_ie,  wps_ielen, WPS_ATTR_SELECTED_REGISTRAR, (u8 *)(&sr), NULL);
-			if (sr != 0)
-				set_fwstate(pmlmepriv, WIFI_UNDER_WPS);
-			else
-				_clr_fwstate_(pmlmepriv, WIFI_UNDER_WPS);
-		}
-
-#ifdef CONFIG_88EU_P2P
-		if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO)) {
-			u32 len;
-			len = build_beacon_p2p_ie(pwdinfo, pframe);
-
-			pframe += len;
-			pattrib->pktlen += len;
-		}
-#endif /* CONFIG_88EU_P2P */
+		pframe += (cur_network->IELength+len_diff);
+		pattrib->pktlen += (cur_network->IELength+len_diff);
+		wps_ie = rtw_get_wps_ie(pmgntframe->buf_addr+TXDESC_OFFSET+sizeof (struct rtw_ieee80211_hdr_3addr)+_BEACON_IE_OFFSET_,
+			pattrib->pktlen-sizeof (struct rtw_ieee80211_hdr_3addr)-_BEACON_IE_OFFSET_, NULL, &wps_ielen);
+		if (wps_ie && wps_ielen > 0)
+			rtw_get_wps_attr_content(wps_ie,  wps_ielen, WPS_ATTR_SELECTED_REGISTRAR, (u8 *)(&sr), NULL);
+		if (sr != 0)
+			set_fwstate(pmlmepriv, WIFI_UNDER_WPS);
+		else
+			_clr_fwstate_(pmlmepriv, WIFI_UNDER_WPS);
 
 		goto _issue_bcn;
 	}
@@ -4717,9 +2139,6 @@ void issue_probersp(struct adapter *padapter, unsigned char *da, u8 is_valid_p2p
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 	struct wlan_bssid_ex		*cur_network = &(pmlmeinfo->network);
 	unsigned int	rate_len;
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-#endif /* CONFIG_88EU_P2P */
 
 	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
 	if (pmgntframe == NULL) {
@@ -4844,16 +2263,6 @@ void issue_probersp(struct adapter *padapter, unsigned char *da, u8 is_valid_p2p
 		/* todo:HT for adhoc */
 	}
 
-#ifdef CONFIG_88EU_P2P
-	if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO) && is_valid_p2p_probereq) {
-		u32 len;
-		len = build_probe_resp_p2p_ie(pwdinfo, pframe);
-
-		pframe += len;
-		pattrib->pktlen += len;
-	}
-#endif /* CONFIG_88EU_P2P */
-
 	pattrib->last_txcmdsz = pattrib->pktlen;
 
 	dump_mgntframe(padapter, pmgntframe);
@@ -5153,9 +2562,6 @@ void issue_asocrsp(struct adapter *padapter, unsigned short status, struct sta_i
 	struct wlan_bssid_ex *pnetwork = &(pmlmeinfo->network);
 	u8 *ie = pnetwork->IEs;
 	__le16 lestatus, leval;
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-#endif /* CONFIG_88EU_P2P */
 
 	DBG_88E("%s\n", __func__);
 
@@ -5260,16 +2666,6 @@ void issue_asocrsp(struct adapter *padapter, unsigned short status, struct sta_i
 		pattrib->pktlen += pmlmepriv->wps_assoc_resp_ie_len;
 	}
 
-#ifdef CONFIG_88EU_P2P
-	if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO) && (pstat->is_p2p_device)) {
-		u32 len;
-
-		len = build_assoc_resp_p2p_ie(pwdinfo, pframe, pstat->p2p_status_code);
-
-		pframe += len;
-		pattrib->pktlen += len;
-	}
-#endif /* CONFIG_88EU_P2P */
 	pattrib->last_txcmdsz = pattrib->pktlen;
 	dump_mgntframe(padapter, pmgntframe);
 #endif
@@ -5293,11 +2689,6 @@ void issue_assocreq(struct adapter *padapter)
 	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 	int	bssrate_len = 0, sta_bssrate_len = 0;
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-	u8 p2pie[255] = { 0x00 };
-	u16 p2pielen = 0;
-#endif /* CONFIG_88EU_P2P */
 
 	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
 	if (pmgntframe == NULL)
@@ -5464,137 +2855,6 @@ void issue_assocreq(struct adapter *padapter)
 	if (pmlmeinfo->assoc_AP_vendor == HT_IOT_PEER_REALTEK)
 		pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, 6 , REALTEK_96B_IE, &(pattrib->pktlen));
 
-#ifdef CONFIG_88EU_P2P
-
-	if (!rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE) && !rtw_p2p_chk_state(pwdinfo, P2P_STATE_IDLE)) {
-		/*	Should add the P2P IE in the association request frame. */
-		/*	P2P OUI */
-
-		p2pielen = 0;
-		p2pie[p2pielen++] = 0x50;
-		p2pie[p2pielen++] = 0x6F;
-		p2pie[p2pielen++] = 0x9A;
-		p2pie[p2pielen++] = 0x09;	/*	WFA P2P v1.0 */
-
-		/*	Commented by Albert 20101109 */
-		/*	According to the P2P Specification, the association request frame should contain 3 P2P attributes */
-		/*	1. P2P Capability */
-		/*	2. Extended Listen Timing */
-		/*	3. Device Info */
-		/*	Commented by Albert 20110516 */
-		/*	4. P2P Interface */
-
-		/*	P2P Capability */
-		/*	Type: */
-		p2pie[p2pielen++] = P2P_ATTR_CAPABILITY;
-
-		/*	Length: */
-		*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0002);
-		p2pielen += 2;
-
-		/*	Value: */
-		/*	Device Capability Bitmap, 1 byte */
-		p2pie[p2pielen++] = DMP_P2P_DEVCAP_SUPPORT;
-
-		/*	Group Capability Bitmap, 1 byte */
-		if (pwdinfo->persistent_supported)
-			p2pie[p2pielen++] = P2P_GRPCAP_PERSISTENT_GROUP | DMP_P2P_GRPCAP_SUPPORT;
-		else
-			p2pie[p2pielen++] = DMP_P2P_GRPCAP_SUPPORT;
-
-		/*	Extended Listen Timing */
-		/*	Type: */
-		p2pie[p2pielen++] = P2P_ATTR_EX_LISTEN_TIMING;
-
-		/*	Length: */
-		*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x0004);
-		p2pielen += 2;
-
-		/*	Value: */
-		/*	Availability Period */
-		*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0xFFFF);
-		p2pielen += 2;
-
-		/*	Availability Interval */
-		*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0xFFFF);
-		p2pielen += 2;
-
-		/*	Device Info */
-		/*	Type: */
-		p2pie[p2pielen++] = P2P_ATTR_DEVICE_INFO;
-
-		/*	Length: */
-		/*	21 -> P2P Device Address (6bytes) + Config Methods (2bytes) + Primary Device Type (8bytes) */
-		/*	+ NumofSecondDevType (1byte) + WPS Device Name ID field (2bytes) + WPS Device Name Len field (2bytes) */
-		*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(21 + pwdinfo->device_name_len);
-		p2pielen += 2;
-
-		/*	Value: */
-		/*	P2P Device Address */
-		memcpy(p2pie + p2pielen, myid(&padapter->eeprompriv), ETH_ALEN);
-		p2pielen += ETH_ALEN;
-
-		/*	Config Method */
-		/*	This field should be big endian. Noted by P2P specification. */
-		if ((pwdinfo->ui_got_wps_info == P2P_GOT_WPSINFO_PEER_DISPLAY_PIN) ||
-		    (pwdinfo->ui_got_wps_info == P2P_GOT_WPSINFO_SELF_DISPLAY_PIN))
-			*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_CONFIG_METHOD_DISPLAY);
-		else
-			*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_CONFIG_METHOD_PBC);
-
-		p2pielen += 2;
-
-		/*	Primary Device Type */
-		/*	Category ID */
-		*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_PDT_CID_MULIT_MEDIA);
-		p2pielen += 2;
-
-		/*	OUI */
-		*(__be32 *)(p2pie + p2pielen) = cpu_to_be32(WPSOUI);
-		p2pielen += 4;
-
-		/*	Sub Category ID */
-		*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_PDT_SCID_MEDIA_SERVER);
-		p2pielen += 2;
-
-		/*	Number of Secondary Device Types */
-		p2pie[p2pielen++] = 0x00;	/*	No Secondary Device Type List */
-
-		/*	Device Name */
-		/*	Type: */
-		*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(WPS_ATTR_DEVICE_NAME);
-		p2pielen += 2;
-
-		/*	Length: */
-		*(__be16 *)(p2pie + p2pielen) = cpu_to_be16(pwdinfo->device_name_len);
-		p2pielen += 2;
-
-		/*	Value: */
-		memcpy(p2pie + p2pielen, pwdinfo->device_name, pwdinfo->device_name_len);
-		p2pielen += pwdinfo->device_name_len;
-
-		/*	P2P Interface */
-		/*	Type: */
-		p2pie[p2pielen++] = P2P_ATTR_INTERFACE;
-
-		/*	Length: */
-		*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(0x000D);
-		p2pielen += 2;
-
-		/*	Value: */
-		memcpy(p2pie + p2pielen, pwdinfo->device_addr, ETH_ALEN);	/*	P2P Device Address */
-		p2pielen += ETH_ALEN;
-
-		p2pie[p2pielen++] = 1;	/*	P2P Interface Address Count */
-
-		memcpy(p2pie + p2pielen, pwdinfo->device_addr, ETH_ALEN);	/*	P2P Interface Address List */
-		p2pielen += ETH_ALEN;
-
-		pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, p2pielen, (unsigned char *)p2pie, &pattrib->pktlen);
-	}
-
-#endif /* CONFIG_88EU_P2P */
-
 	pattrib->last_txcmdsz = pattrib->pktlen;
 	dump_mgntframe(padapter, pmgntframe);
 
@@ -5859,16 +3119,6 @@ static int _issue_deauth(struct adapter *padapter, unsigned char *da, unsigned s
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 	int ret = _FAIL;
 	__le16 le_tmp;
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
-#endif /* CONFIG_88EU_P2P */
-
-#ifdef CONFIG_88EU_P2P
-	if (!(rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE)) && (pwdinfo->rx_invitereq_info.scan_op_ch_only)) {
-		del_timer_sync(&pwdinfo->reset_ch_sitesurvey);
-		_set_timer(&pwdinfo->reset_ch_sitesurvey, 10);
-	}
-#endif /* CONFIG_88EU_P2P */
 
 	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
 	if (pmgntframe == NULL)
@@ -6375,38 +3625,15 @@ void site_survey(struct adapter *padapter)
 	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 	u32 initialgain = 0;
+	struct rtw_ieee80211_channel *ch;
 
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
-
-	if ((pwdinfo->rx_invitereq_info.scan_op_ch_only) || (pwdinfo->p2p_info.scan_op_ch_only)) {
-		if (pwdinfo->rx_invitereq_info.scan_op_ch_only) {
-			survey_channel = pwdinfo->rx_invitereq_info.operation_ch[pmlmeext->sitesurvey_res.channel_idx];
-		} else {
-			survey_channel = pwdinfo->p2p_info.operation_ch[pmlmeext->sitesurvey_res.channel_idx];
-		}
-		ScanType = SCAN_ACTIVE;
-	} else if (rtw_p2p_findphase_ex_is_social(pwdinfo)) {
-		/*	Commented by Albert 2011/06/03 */
-		/*	The driver is in the find phase, it should go through the social channel. */
-		int ch_set_idx;
-		survey_channel = pwdinfo->social_chan[pmlmeext->sitesurvey_res.channel_idx];
-		ch_set_idx = rtw_ch_set_search_ch(pmlmeext->channel_set, survey_channel);
-		if (ch_set_idx >= 0)
-			ScanType = pmlmeext->channel_set[ch_set_idx].ScanType;
-		else
-			ScanType = SCAN_ACTIVE;
-	} else
-#endif /* CONFIG_88EU_P2P */
-	{
-		struct rtw_ieee80211_channel *ch;
-		if (pmlmeext->sitesurvey_res.channel_idx < pmlmeext->sitesurvey_res.ch_num) {
-			ch = &pmlmeext->sitesurvey_res.ch[pmlmeext->sitesurvey_res.channel_idx];
-			survey_channel = ch->hw_value;
-			ScanType = (ch->flags & RTW_IEEE80211_CHAN_PASSIVE_SCAN) ? SCAN_PASSIVE : SCAN_ACTIVE;
-		}
+	if (pmlmeext->sitesurvey_res.channel_idx < pmlmeext->sitesurvey_res.ch_num) {
+		ch = &pmlmeext->sitesurvey_res.ch[pmlmeext->sitesurvey_res.channel_idx];
+		survey_channel = ch->hw_value;
+		ScanType = (ch->flags & RTW_IEEE80211_CHAN_PASSIVE_SCAN) ? SCAN_PASSIVE : SCAN_ACTIVE;
 	}
 
+
 	if (survey_channel != 0) {
 		/* PAUSE 4-AC Queue when site_survey */
 		/* rtw_hal_get_hwreg(padapter, HW_VAR_TXPAUSE, (u8 *)(&val8)); */
@@ -6418,118 +3645,78 @@ void site_survey(struct adapter *padapter)
 			SelectChannel(padapter, survey_channel);
 
 		if (ScanType == SCAN_ACTIVE) { /* obey the channel plan setting... */
-			#ifdef CONFIG_88EU_P2P
-			if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_SCAN) ||
-			    rtw_p2p_chk_state(pwdinfo, P2P_STATE_FIND_PHASE_SEARCH)) {
-				issue_probereq_p2p(padapter, NULL);
-				issue_probereq_p2p(padapter, NULL);
-				issue_probereq_p2p(padapter, NULL);
-			} else
-			#endif /* CONFIG_88EU_P2P */
-			{
-				int i;
-				for (i = 0; i < RTW_SSID_SCAN_AMOUNT; i++) {
-					if (pmlmeext->sitesurvey_res.ssid[i].SsidLength) {
-						/* todo: to issue two probe req??? */
-						issue_probereq(padapter, &(pmlmeext->sitesurvey_res.ssid[i]), NULL);
-						/* msleep(SURVEY_TO>>1); */
-						issue_probereq(padapter, &(pmlmeext->sitesurvey_res.ssid[i]), NULL);
-					}
-				}
-
-				if (pmlmeext->sitesurvey_res.scan_mode == SCAN_ACTIVE) {
+			int i;
+			for (i = 0; i < RTW_SSID_SCAN_AMOUNT; i++) {
+				if (pmlmeext->sitesurvey_res.ssid[i].SsidLength) {
 					/* todo: to issue two probe req??? */
-					issue_probereq(padapter, NULL, NULL);
+					issue_probereq(padapter, &(pmlmeext->sitesurvey_res.ssid[i]), NULL);
 					/* msleep(SURVEY_TO>>1); */
-					issue_probereq(padapter, NULL, NULL);
+					issue_probereq(padapter, &(pmlmeext->sitesurvey_res.ssid[i]), NULL);
 				}
 			}
+
+			if (pmlmeext->sitesurvey_res.scan_mode == SCAN_ACTIVE) {
+				/* todo: to issue two probe req??? */
+				issue_probereq(padapter, NULL, NULL);
+				/* msleep(SURVEY_TO>>1); */
+				issue_probereq(padapter, NULL, NULL);
+			}
+
+			if (pmlmeext->sitesurvey_res.scan_mode == SCAN_ACTIVE) {
+				/* todo: to issue two probe req??? */
+				issue_probereq(padapter, NULL, NULL);
+				/* msleep(SURVEY_TO>>1); */
+				issue_probereq(padapter, NULL, NULL);
+			}
 		}
 
 		set_survey_timer(pmlmeext, pmlmeext->chan_scan_time);
 	} else {
-		/*	channel number is 0 or this channel is not valid. */
-
-#ifdef CONFIG_88EU_P2P
-		if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_SCAN) || rtw_p2p_chk_state(pwdinfo, P2P_STATE_FIND_PHASE_SEARCH)) {
-			if ((pwdinfo->rx_invitereq_info.scan_op_ch_only) || (pwdinfo->p2p_info.scan_op_ch_only)) {
-				/*	Set the find_phase_state_exchange_cnt to P2P_FINDPHASE_EX_CNT. */
-				/*	This will let the following flow to run the scanning end. */
-				rtw_p2p_findphase_ex_set(pwdinfo, P2P_FINDPHASE_EX_MAX);
-			}
-		}
 
-		if (rtw_p2p_findphase_ex_is_needed(pwdinfo)) {
-			/*	Set the P2P State to the listen state of find phase and set the current channel to the listen channel */
-			set_channel_bwmode(padapter, pwdinfo->listen_channel, HAL_PRIME_CHNL_OFFSET_DONT_CARE, HT_CHANNEL_WIDTH_20);
-			rtw_p2p_set_state(pwdinfo, P2P_STATE_FIND_PHASE_LISTEN);
-			pmlmeext->sitesurvey_res.state = SCAN_DISABLE;
-
-			initialgain = 0xff; /* restore RX GAIN */
-			rtw_hal_set_hwreg(padapter, HW_VAR_INITIAL_GAIN, (u8 *)(&initialgain));
-			/* turn on dynamic functions */
-			Restore_DM_Func_Flag(padapter);
-			/* Switch_DM_Func(padapter, DYNAMIC_FUNC_DIG|DYNAMIC_FUNC_HP|DYNAMIC_FUNC_SS, true); */
-
-			_set_timer(&pwdinfo->find_phase_timer, (u32)((u32)(pwdinfo->listen_dwell) * 100));
-		} else
-#endif /* CONFIG_88EU_P2P */
-		{
-			/*  20100721:Interrupt scan operation here. */
-			/*  For SW antenna diversity before link, it needs to switch to another antenna and scan again. */
-			/*  It compares the scan result and select better one to do connection. */
-			if (rtw_hal_antdiv_before_linked(padapter)) {
-				pmlmeext->sitesurvey_res.bss_cnt = 0;
-				pmlmeext->sitesurvey_res.channel_idx = -1;
-				pmlmeext->chan_scan_time = SURVEY_TO / 2;
-				set_survey_timer(pmlmeext, pmlmeext->chan_scan_time);
-				return;
-			}
-#ifdef CONFIG_88EU_P2P
-			if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_SCAN) || rtw_p2p_chk_state(pwdinfo, P2P_STATE_FIND_PHASE_SEARCH))
-				rtw_p2p_set_state(pwdinfo, rtw_p2p_pre_state(pwdinfo));
-			rtw_p2p_findphase_ex_set(pwdinfo, P2P_FINDPHASE_EX_NONE);
-#endif /* CONFIG_88EU_P2P */
+		/*  20100721:Interrupt scan operation here. */
+		/*  For SW antenna diversity before link, it needs to switch to another antenna and scan again. */
+		/*  It compares the scan result and select better one to do connection. */
+		if (rtw_hal_antdiv_before_linked(padapter)) {
+			pmlmeext->sitesurvey_res.bss_cnt = 0;
+			pmlmeext->sitesurvey_res.channel_idx = -1;
+			pmlmeext->chan_scan_time = SURVEY_TO / 2;
+			set_survey_timer(pmlmeext, pmlmeext->chan_scan_time);
+			return;
+		}
 
-			pmlmeext->sitesurvey_res.state = SCAN_COMPLETE;
+		pmlmeext->sitesurvey_res.state = SCAN_COMPLETE;
 
-			/* switch back to the original channel */
+		/* switch back to the original channel */
 
-#ifdef CONFIG_88EU_P2P
-			if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_LISTEN))
-				set_channel_bwmode(padapter, pwdinfo->listen_channel, HAL_PRIME_CHNL_OFFSET_DONT_CARE, HT_CHANNEL_WIDTH_20);
-			else
-				set_channel_bwmode(padapter, pmlmeext->cur_channel, pmlmeext->cur_ch_offset, pmlmeext->cur_bwmode);
-#endif /* CONFIG_88EU_P2P */
+		set_channel_bwmode(padapter, pmlmeext->cur_channel, pmlmeext->cur_ch_offset, pmlmeext->cur_bwmode);
 
-			/* flush 4-AC Queue after site_survey */
-			/* val8 = 0; */
-			/* rtw_hal_set_hwreg(padapter, HW_VAR_TXPAUSE, (u8 *)(&val8)); */
+		/* flush 4-AC Queue after site_survey */
+		/* val8 = 0; */
+		/* rtw_hal_set_hwreg(padapter, HW_VAR_TXPAUSE, (u8 *)(&val8)); */
 
-			/* config MSR */
-			Set_MSR(padapter, (pmlmeinfo->state & 0x3));
+		/* config MSR */
+		Set_MSR(padapter, (pmlmeinfo->state & 0x3));
 
-			initialgain = 0xff; /* restore RX GAIN */
-			rtw_hal_set_hwreg(padapter, HW_VAR_INITIAL_GAIN, (u8 *)(&initialgain));
-			/* turn on dynamic functions */
-			Restore_DM_Func_Flag(padapter);
-			/* Switch_DM_Func(padapter, DYNAMIC_ALL_FUNC_ENABLE, true); */
+		initialgain = 0xff; /* restore RX GAIN */
+		rtw_hal_set_hwreg(padapter, HW_VAR_INITIAL_GAIN, (u8 *)(&initialgain));
+		/* turn on dynamic functions */
+		Restore_DM_Func_Flag(padapter);
+		/* Switch_DM_Func(padapter, DYNAMIC_ALL_FUNC_ENABLE, true); */
 
-			if (is_client_associated_to_ap(padapter))
-				issue_nulldata(padapter, NULL, 0, 3, 500);
+		if (is_client_associated_to_ap(padapter))
+			issue_nulldata(padapter, NULL, 0, 3, 500);
 
-			val8 = 0; /* survey done */
-			rtw_hal_set_hwreg(padapter, HW_VAR_MLME_SITESURVEY, (u8 *)(&val8));
+		val8 = 0; /* survey done */
+		rtw_hal_set_hwreg(padapter, HW_VAR_MLME_SITESURVEY, (u8 *)(&val8));
 
-			report_surveydone_event(padapter);
+		report_surveydone_event(padapter);
 
-			pmlmeext->chan_scan_time = SURVEY_TO;
-			pmlmeext->sitesurvey_res.state = SCAN_DISABLE;
+		pmlmeext->chan_scan_time = SURVEY_TO;
+		pmlmeext->sitesurvey_res.state = SCAN_DISABLE;
 
-			issue_action_BSSCoexistPacket(padapter);
-			issue_action_BSSCoexistPacket(padapter);
-			issue_action_BSSCoexistPacket(padapter);
-		}
+		issue_action_BSSCoexistPacket(padapter);
+		issue_action_BSSCoexistPacket(padapter);
+		issue_action_BSSCoexistPacket(padapter);
 	}
 	return;
 }
@@ -7555,9 +4742,6 @@ void linked_status_chk(struct adapter *padapter)
 		psta = rtw_get_stainfo(pstapriv, pmlmeinfo->network.MacAddress);
 		if (psta != NULL) {
 			bool is_p2p_enable = false;
-			#ifdef CONFIG_88EU_P2P
-			is_p2p_enable = !rtw_p2p_chk_state(&padapter->wdinfo, P2P_STATE_NONE);
-			#endif
 
 			if (!chk_ap_is_alive(padapter, psta))
 				rx_chk = _FAIL;
@@ -7655,9 +4839,6 @@ void survey_timer_hdl(struct adapter *padapter)
 	struct sitesurvey_parm	*psurveyPara;
 	struct cmd_priv					*pcmdpriv = &padapter->cmdpriv;
 	struct mlme_ext_priv		*pmlmeext = &padapter->mlmeextpriv;
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
-#endif
 
 	/* issue rtw_sitesurvey_cmd */
 	if (pmlmeext->sitesurvey_res.state > SCAN_START) {
@@ -7665,22 +4846,9 @@ void survey_timer_hdl(struct adapter *padapter)
 			pmlmeext->sitesurvey_res.channel_idx++;
 
 		if (pmlmeext->scan_abort) {
-			#ifdef CONFIG_88EU_P2P
-			if (!rtw_p2p_chk_state(&padapter->wdinfo, P2P_STATE_NONE)) {
-				rtw_p2p_findphase_ex_set(pwdinfo, P2P_FINDPHASE_EX_MAX);
-				pmlmeext->sitesurvey_res.channel_idx = 3;
-				DBG_88E("%s idx:%d, cnt:%u\n", __func__
-					, pmlmeext->sitesurvey_res.channel_idx
-					, pwdinfo->find_phase_state_exchange_cnt
-			);
-			} else
-			#endif
-			{
-				pmlmeext->sitesurvey_res.channel_idx = pmlmeext->sitesurvey_res.ch_num;
-				DBG_88E("%s idx:%d\n", __func__
-					, pmlmeext->sitesurvey_res.channel_idx
-			);
-			}
+			pmlmeext->sitesurvey_res.channel_idx = pmlmeext->sitesurvey_res.ch_num;
+			DBG_88E("%s idx:%d\n", __func__
+				, pmlmeext->sitesurvey_res.channel_idx);
 
 			pmlmeext->scan_abort = false;/* reset */
 		}
@@ -8056,10 +5224,6 @@ u8 sitesurvey_cmd_hdl(struct adapter *padapter, u8 *pbuf)
 	u32	initialgain;
 	u32	i;
 
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info *pwdinfo = &padapter->wdinfo;
-#endif
-
 	if (pmlmeext->sitesurvey_res.state == SCAN_DISABLE) {
 		/* for first time sitesurvey_cmd */
 		rtw_hal_set_hwreg(padapter, HW_VAR_CHECK_TXBUF, NULL);
@@ -8105,14 +5269,7 @@ u8 sitesurvey_cmd_hdl(struct adapter *padapter, u8 *pbuf)
 		Switch_DM_Func(padapter, DYNAMIC_FUNC_DISABLE, false);
 
 		/* config the initial gain under scanning, need to write the BB registers */
-#ifdef CONFIG_88EU_P2P
-		if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
-			initialgain = 0x1E;
-		else
-			initialgain = 0x28;
-#else	/*  CONFIG_88EU_P2P */
 		initialgain = 0x1E;
-#endif /*  CONFIG_88EU_P2P */
 
 		rtw_hal_set_hwreg(padapter, HW_VAR_INITIAL_GAIN, (u8 *)(&initialgain));
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_p2p.c b/drivers/staging/rtl8188eu/core/rtw_p2p.c
deleted file mode 100644
index e1fd198..0000000
--- a/drivers/staging/rtl8188eu/core/rtw_p2p.c
+++ /dev/null
@@ -1,2015 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- *
- ******************************************************************************/
-#define _RTW_P2P_C_
-
-#include <drv_types.h>
-#include <rtw_p2p.h>
-#include <wifi.h>
-
-#ifdef CONFIG_88EU_P2P
-
-static int rtw_p2p_is_channel_list_ok(u8 desired_ch, u8 *ch_list, u8 ch_cnt)
-{
-	int found = 0, i = 0;
-
-	for (i = 0; i < ch_cnt; i++) {
-		if (ch_list[i] == desired_ch) {
-			found = 1;
-			break;
-		}
-	}
-	return found;
-}
-
-static u32 go_add_group_info_attr(struct wifidirect_info *pwdinfo, u8 *pbuf)
-{
-	struct list_head *phead, *plist;
-	u32 len = 0;
-	u16 attr_len = 0;
-	u8 tmplen, *pdata_attr, *pstart, *pcur;
-	struct sta_info *psta = NULL;
-	struct adapter *padapter = pwdinfo->padapter;
-	struct sta_priv *pstapriv = &padapter->stapriv;
-
-	DBG_88E("%s\n", __func__);
-
-	pdata_attr = kzalloc(MAX_P2P_IE_LEN, GFP_KERNEL);
-
-	pstart = pdata_attr;
-	pcur = pdata_attr;
-
-	spin_lock_bh(&pstapriv->asoc_list_lock);
-	phead = &pstapriv->asoc_list;
-	plist = phead->next;
-
-	/* look up sta asoc_queue */
-	while (phead != plist) {
-		psta = container_of(plist, struct sta_info, asoc_list);
-
-		plist = plist->next;
-
-
-		if (psta->is_p2p_device) {
-			tmplen = 0;
-
-			pcur++;
-
-			/* P2P device address */
-			memcpy(pcur, psta->dev_addr, ETH_ALEN);
-			pcur += ETH_ALEN;
-
-			/* P2P interface address */
-			memcpy(pcur, psta->hwaddr, ETH_ALEN);
-			pcur += ETH_ALEN;
-
-			*pcur = psta->dev_cap;
-			pcur++;
-
-			*((u16 *)(pcur)) = cpu_to_be16(psta->config_methods);
-			pcur += 2;
-
-			memcpy(pcur, psta->primary_dev_type, 8);
-			pcur += 8;
-
-			*pcur = psta->num_of_secdev_type;
-			pcur++;
-
-			memcpy(pcur, psta->secdev_types_list, psta->num_of_secdev_type*8);
-			pcur += psta->num_of_secdev_type*8;
-
-			if (psta->dev_name_len > 0) {
-				*(u16 *)(pcur) = cpu_to_be16(WPS_ATTR_DEVICE_NAME);
-				pcur += 2;
-
-				*(u16 *)(pcur) = cpu_to_be16(psta->dev_name_len);
-				pcur += 2;
-
-				memcpy(pcur, psta->dev_name, psta->dev_name_len);
-				pcur += psta->dev_name_len;
-			}
-
-
-			tmplen = (u8)(pcur-pstart);
-
-			*pstart = (tmplen-1);
-
-			attr_len += tmplen;
-
-			/* pstart += tmplen; */
-			pstart = pcur;
-		}
-	}
-	spin_unlock_bh(&pstapriv->asoc_list_lock);
-
-	if (attr_len > 0)
-		len = rtw_set_p2p_attr_content(pbuf, P2P_ATTR_GROUP_INFO, attr_len, pdata_attr);
-
-	kfree(pdata_attr);
-	return len;
-}
-
-static void issue_group_disc_req(struct wifidirect_info *pwdinfo, u8 *da)
-{
-	struct xmit_frame			*pmgntframe;
-	struct pkt_attrib			*pattrib;
-	unsigned char					*pframe;
-	struct rtw_ieee80211_hdr	*pwlanhdr;
-	__le16 *fctrl;
-	struct adapter *padapter = pwdinfo->padapter;
-	struct xmit_priv			*pxmitpriv = &(padapter->xmitpriv);
-	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
-	unsigned char category = RTW_WLAN_CATEGORY_P2P;/* P2P action frame */
-	__be32	p2poui = cpu_to_be32(P2POUI);
-	u8	oui_subtype = P2P_GO_DISC_REQUEST;
-	u8	dialogToken = 0;
-
-	DBG_88E("[%s]\n", __func__);
-
-	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
-		return;
-
-	/* update attribute */
-	pattrib = &pmgntframe->attrib;
-	update_mgntframe_attrib(padapter, pattrib);
-
-	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
-
-	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
-	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
-
-	fctrl = &(pwlanhdr->frame_ctl);
-	*(fctrl) = 0;
-
-	memcpy(pwlanhdr->addr1, da, ETH_ALEN);
-	memcpy(pwlanhdr->addr2, pwdinfo->interface_addr, ETH_ALEN);
-	memcpy(pwlanhdr->addr3, pwdinfo->interface_addr, ETH_ALEN);
-
-	SetSeqNum(pwlanhdr, pmlmeext->mgnt_seq);
-	pmlmeext->mgnt_seq++;
-	SetFrameSubType(pframe, WIFI_ACTION);
-
-	pframe += sizeof(struct rtw_ieee80211_hdr_3addr);
-	pattrib->pktlen = sizeof(struct rtw_ieee80211_hdr_3addr);
-
-	/* Build P2P action frame header */
-	pframe = rtw_set_fixed_ie(pframe, 1, &(category), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 4, (unsigned char *)&(p2poui), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(oui_subtype), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(dialogToken), &(pattrib->pktlen));
-
-	/* there is no IE in this P2P action frame */
-
-	pattrib->last_txcmdsz = pattrib->pktlen;
-
-	dump_mgntframe(padapter, pmgntframe);
-}
-
-static void issue_p2p_devdisc_resp(struct wifidirect_info *pwdinfo, u8 *da, u8 status, u8 dialogToken)
-{
-	struct xmit_frame			*pmgntframe;
-	struct pkt_attrib			*pattrib;
-	unsigned char					*pframe;
-	struct rtw_ieee80211_hdr	*pwlanhdr;
-	__le16 *fctrl;
-	struct adapter *padapter = pwdinfo->padapter;
-	struct xmit_priv			*pxmitpriv = &(padapter->xmitpriv);
-	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
-	unsigned char category = RTW_WLAN_CATEGORY_PUBLIC;
-	u8			action = P2P_PUB_ACTION_ACTION;
-	__be32			p2poui = cpu_to_be32(P2POUI);
-	u8			oui_subtype = P2P_DEVDISC_RESP;
-	u8 p2pie[8] = { 0x00 };
-	u32 p2pielen = 0;
-
-	DBG_88E("[%s]\n", __func__);
-
-	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
-		return;
-
-	/* update attribute */
-	pattrib = &pmgntframe->attrib;
-	update_mgntframe_attrib(padapter, pattrib);
-
-	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
-
-	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
-	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
-
-	fctrl = &(pwlanhdr->frame_ctl);
-	*(fctrl) = 0;
-
-	memcpy(pwlanhdr->addr1, da, ETH_ALEN);
-	memcpy(pwlanhdr->addr2, pwdinfo->device_addr, ETH_ALEN);
-	memcpy(pwlanhdr->addr3, pwdinfo->device_addr, ETH_ALEN);
-
-	SetSeqNum(pwlanhdr, pmlmeext->mgnt_seq);
-	pmlmeext->mgnt_seq++;
-	SetFrameSubType(pframe, WIFI_ACTION);
-
-	pframe += sizeof(struct rtw_ieee80211_hdr_3addr);
-	pattrib->pktlen = sizeof(struct rtw_ieee80211_hdr_3addr);
-
-	/* Build P2P public action frame header */
-	pframe = rtw_set_fixed_ie(pframe, 1, &(category), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(action), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 4, (unsigned char *)&(p2poui), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(oui_subtype), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(dialogToken), &(pattrib->pktlen));
-
-
-	/* Build P2P IE */
-	/*	P2P OUI */
-	p2pielen = 0;
-	p2pie[p2pielen++] = 0x50;
-	p2pie[p2pielen++] = 0x6F;
-	p2pie[p2pielen++] = 0x9A;
-	p2pie[p2pielen++] = 0x09;	/*	WFA P2P v1.0 */
-
-	/*  P2P_ATTR_STATUS */
-	p2pielen += rtw_set_p2p_attr_content(&p2pie[p2pielen], P2P_ATTR_STATUS, 1, &status);
-
-	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, p2pielen, p2pie, &pattrib->pktlen);
-
-	pattrib->last_txcmdsz = pattrib->pktlen;
-
-	dump_mgntframe(padapter, pmgntframe);
-}
-
-static void issue_p2p_provision_resp(struct wifidirect_info *pwdinfo, u8 *raddr, u8 *frame_body, u16 config_method)
-{
-	struct adapter *padapter = pwdinfo->padapter;
-	unsigned char category = RTW_WLAN_CATEGORY_PUBLIC;
-	u8			action = P2P_PUB_ACTION_ACTION;
-	u8			dialogToken = frame_body[7];	/*	The Dialog Token of provisioning discovery request frame. */
-	__be32			p2poui = cpu_to_be32(P2POUI);
-	u8			oui_subtype = P2P_PROVISION_DISC_RESP;
-	u8			wpsie[100] = { 0x00 };
-	u8			wpsielen = 0;
-	struct xmit_frame			*pmgntframe;
-	struct pkt_attrib			*pattrib;
-	unsigned char					*pframe;
-	struct rtw_ieee80211_hdr	*pwlanhdr;
-	__le16 *fctrl;
-	struct xmit_priv			*pxmitpriv = &(padapter->xmitpriv);
-	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
-
-	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
-		return;
-
-	/* update attribute */
-	pattrib = &pmgntframe->attrib;
-	update_mgntframe_attrib(padapter, pattrib);
-
-	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
-
-	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
-	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
-
-	fctrl = &(pwlanhdr->frame_ctl);
-	*(fctrl) = 0;
-
-	memcpy(pwlanhdr->addr1, raddr, ETH_ALEN);
-	memcpy(pwlanhdr->addr2, myid(&(padapter->eeprompriv)), ETH_ALEN);
-	memcpy(pwlanhdr->addr3, myid(&(padapter->eeprompriv)), ETH_ALEN);
-
-	SetSeqNum(pwlanhdr, pmlmeext->mgnt_seq);
-	pmlmeext->mgnt_seq++;
-	SetFrameSubType(pframe, WIFI_ACTION);
-
-	pframe += sizeof(struct rtw_ieee80211_hdr_3addr);
-	pattrib->pktlen = sizeof(struct rtw_ieee80211_hdr_3addr);
-
-	pframe = rtw_set_fixed_ie(pframe, 1, &(category), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(action), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 4, (unsigned char *)&(p2poui), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(oui_subtype), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(dialogToken), &(pattrib->pktlen));
-
-	wpsielen = 0;
-	/*	WPS OUI */
-	*((u32 *)(wpsie+wpsielen)) = cpu_to_be32(WPSOUI);
-	wpsielen += 4;
-
-	/*	Config Method */
-	/*	Type: */
-	*(u16 *)(wpsie+wpsielen) = cpu_to_be16(WPS_ATTR_CONF_METHOD);
-	wpsielen += 2;
-
-	/*	Length: */
-	*(u16 *)(wpsie+wpsielen) = cpu_to_be16(0x0002);
-	wpsielen += 2;
-
-	/*	Value: */
-	*(u16 *)(wpsie+wpsielen) = cpu_to_be16(config_method);
-	wpsielen += 2;
-
-	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, wpsielen, (unsigned char *)wpsie, &pattrib->pktlen);
-
-	pattrib->last_txcmdsz = pattrib->pktlen;
-
-	dump_mgntframe(padapter, pmgntframe);
-
-	return;
-}
-
-static void issue_p2p_presence_resp(struct wifidirect_info *pwdinfo, u8 *da, u8 status, u8 dialogToken)
-{
-	struct xmit_frame			*pmgntframe;
-	struct pkt_attrib			*pattrib;
-	unsigned char					*pframe;
-	struct rtw_ieee80211_hdr	*pwlanhdr;
-	__le16 *fctrl;
-	struct adapter *padapter = pwdinfo->padapter;
-	struct xmit_priv			*pxmitpriv = &(padapter->xmitpriv);
-	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
-	unsigned char category = RTW_WLAN_CATEGORY_P2P;/* P2P action frame */
-	__be32	p2poui = cpu_to_be32(P2POUI);
-	u8	oui_subtype = P2P_PRESENCE_RESPONSE;
-	u8 p2pie[MAX_P2P_IE_LEN] = { 0x00 };
-	u8 noa_attr_content[32] = { 0x00 };
-	u32 p2pielen = 0;
-
-	DBG_88E("[%s]\n", __func__);
-
-	pmgntframe = alloc_mgtxmitframe(pxmitpriv);
-	if (pmgntframe == NULL)
-		return;
-
-	/* update attribute */
-	pattrib = &pmgntframe->attrib;
-	update_mgntframe_attrib(padapter, pattrib);
-
-	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
-
-	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
-	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
-
-	fctrl = &(pwlanhdr->frame_ctl);
-	*(fctrl) = 0;
-
-	memcpy(pwlanhdr->addr1, da, ETH_ALEN);
-	memcpy(pwlanhdr->addr2, pwdinfo->interface_addr, ETH_ALEN);
-	memcpy(pwlanhdr->addr3, pwdinfo->interface_addr, ETH_ALEN);
-
-	SetSeqNum(pwlanhdr, pmlmeext->mgnt_seq);
-	pmlmeext->mgnt_seq++;
-	SetFrameSubType(pframe, WIFI_ACTION);
-
-	pframe += sizeof(struct rtw_ieee80211_hdr_3addr);
-	pattrib->pktlen = sizeof(struct rtw_ieee80211_hdr_3addr);
-
-	/* Build P2P action frame header */
-	pframe = rtw_set_fixed_ie(pframe, 1, &(category), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 4, (unsigned char *)&(p2poui), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(oui_subtype), &(pattrib->pktlen));
-	pframe = rtw_set_fixed_ie(pframe, 1, &(dialogToken), &(pattrib->pktlen));
-
-
-	/* Add P2P IE header */
-	/*	P2P OUI */
-	p2pielen = 0;
-	p2pie[p2pielen++] = 0x50;
-	p2pie[p2pielen++] = 0x6F;
-	p2pie[p2pielen++] = 0x9A;
-	p2pie[p2pielen++] = 0x09;	/*	WFA P2P v1.0 */
-
-	/* Add Status attribute in P2P IE */
-	p2pielen += rtw_set_p2p_attr_content(&p2pie[p2pielen], P2P_ATTR_STATUS, 1, &status);
-
-	/* Add NoA attribute in P2P IE */
-	noa_attr_content[0] = 0x1;/* index */
-	noa_attr_content[1] = 0x0;/* CTWindow and OppPS Parameters */
-
-	/* todo: Notice of Absence Descriptor(s) */
-
-	p2pielen += rtw_set_p2p_attr_content(&p2pie[p2pielen], P2P_ATTR_NOA, 2, noa_attr_content);
-
-
-
-	pframe = rtw_set_ie(pframe, _VENDOR_SPECIFIC_IE_, p2pielen, p2pie, &(pattrib->pktlen));
-
-
-	pattrib->last_txcmdsz = pattrib->pktlen;
-
-	dump_mgntframe(padapter, pmgntframe);
-}
-
-u32 build_beacon_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf)
-{
-	u8 p2pie[MAX_P2P_IE_LEN] = { 0x00 };
-	u16 capability = 0;
-	u32 len = 0, p2pielen = 0;
-	__le16 le_tmp;
-
-	/*	P2P OUI */
-	p2pielen = 0;
-	p2pie[p2pielen++] = 0x50;
-	p2pie[p2pielen++] = 0x6F;
-	p2pie[p2pielen++] = 0x9A;
-	p2pie[p2pielen++] = 0x09;	/*	WFA P2P v1.0 */
-
-
-	/*	According to the P2P Specification, the beacon frame should contain 3 P2P attributes */
-	/*	1. P2P Capability */
-	/*	2. P2P Device ID */
-	/*	3. Notice of Absence (NOA) */
-
-	/*	P2P Capability ATTR */
-	/*	Type: */
-	/*	Length: */
-	/*	Value: */
-	/*	Device Capability Bitmap, 1 byte */
-	/*	Be able to participate in additional P2P Groups and */
-	/*	support the P2P Invitation Procedure */
-	/*	Group Capability Bitmap, 1 byte */
-	capability = P2P_DEVCAP_INVITATION_PROC|P2P_DEVCAP_CLIENT_DISCOVERABILITY;
-	capability |=  ((P2P_GRPCAP_GO | P2P_GRPCAP_INTRABSS) << 8);
-	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_PROVISIONING_ING))
-		capability |= (P2P_GRPCAP_GROUP_FORMATION<<8);
-
-	le_tmp = cpu_to_le16(capability);
-	p2pielen += rtw_set_p2p_attr_content(&p2pie[p2pielen], P2P_ATTR_CAPABILITY, 2, (u8 *)&le_tmp);
-
-	/*  P2P Device ID ATTR */
-	p2pielen += rtw_set_p2p_attr_content(&p2pie[p2pielen], P2P_ATTR_DEVICE_ID, ETH_ALEN, pwdinfo->device_addr);
-
-	/*  Notice of Absence ATTR */
-	/*	Type: */
-	/*	Length: */
-	/*	Value: */
-
-	pbuf = rtw_set_ie(pbuf, _VENDOR_SPECIFIC_IE_, p2pielen, (unsigned char *)p2pie, &len);
-	return len;
-}
-
-u32 build_probe_resp_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf)
-{
-	u8 p2pie[MAX_P2P_IE_LEN] = { 0x00 };
-	u32 len = 0, p2pielen = 0;
-
-	/*	P2P OUI */
-	p2pielen = 0;
-	p2pie[p2pielen++] = 0x50;
-	p2pie[p2pielen++] = 0x6F;
-	p2pie[p2pielen++] = 0x9A;
-	p2pie[p2pielen++] = 0x09;	/*	WFA P2P v1.0 */
-
-	/*	Commented by Albert 20100907 */
-	/*	According to the P2P Specification, the probe response frame should contain 5 P2P attributes */
-	/*	1. P2P Capability */
-	/*	2. Extended Listen Timing */
-	/*	3. Notice of Absence (NOA)	(Only GO needs this) */
-	/*	4. Device Info */
-	/*	5. Group Info	(Only GO need this) */
-
-	/*	P2P Capability ATTR */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_CAPABILITY;
-
-	/*	Length: */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_le16(0x0002);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Device Capability Bitmap, 1 byte */
-	p2pie[p2pielen++] = DMP_P2P_DEVCAP_SUPPORT;
-
-	/*	Group Capability Bitmap, 1 byte */
-	if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO)) {
-		p2pie[p2pielen] = (P2P_GRPCAP_GO | P2P_GRPCAP_INTRABSS);
-
-		if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_PROVISIONING_ING))
-			p2pie[p2pielen] |= P2P_GRPCAP_GROUP_FORMATION;
-
-		p2pielen++;
-	} else if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_DEVICE)) {
-		/*	Group Capability Bitmap, 1 byte */
-		if (pwdinfo->persistent_supported)
-			p2pie[p2pielen++] = P2P_GRPCAP_PERSISTENT_GROUP | DMP_P2P_GRPCAP_SUPPORT;
-		else
-			p2pie[p2pielen++] = DMP_P2P_GRPCAP_SUPPORT;
-	}
-
-	/*	Extended Listen Timing ATTR */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_EX_LISTEN_TIMING;
-
-	/*	Length: */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_le16(0x0004);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Availability Period */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_le16(0xFFFF);
-	p2pielen += 2;
-
-	/*	Availability Interval */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_le16(0xFFFF);
-	p2pielen += 2;
-
-
-	/*  Notice of Absence ATTR */
-	/*	Type: */
-	/*	Length: */
-	/*	Value: */
-
-	/*	Device Info ATTR */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_DEVICE_INFO;
-
-	/*	Length: */
-	/*	21 -> P2P Device Address (6bytes) + Config Methods (2bytes) + Primary Device Type (8bytes) */
-	/*	+ NumofSecondDevType (1byte) + WPS Device Name ID field (2bytes) + WPS Device Name Len field (2bytes) */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_le16(21 + pwdinfo->device_name_len);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	P2P Device Address */
-	memcpy(p2pie + p2pielen, pwdinfo->device_addr, ETH_ALEN);
-	p2pielen += ETH_ALEN;
-
-	/*	Config Method */
-	/*	This field should be big endian. Noted by P2P specification. */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(pwdinfo->supported_wps_cm);
-	p2pielen += 2;
-
-	/*	Primary Device Type */
-	/*	Category ID */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_PDT_CID_MULIT_MEDIA);
-	p2pielen += 2;
-
-	/*	OUI */
-	*((u32 *)(p2pie + p2pielen)) = cpu_to_be32(WPSOUI);
-	p2pielen += 4;
-
-	/*	Sub Category ID */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_PDT_SCID_MEDIA_SERVER);
-	p2pielen += 2;
-
-	/*	Number of Secondary Device Types */
-	p2pie[p2pielen++] = 0x00;	/*	No Secondary Device Type List */
-
-	/*	Device Name */
-	/*	Type: */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_ATTR_DEVICE_NAME);
-	p2pielen += 2;
-
-	/*	Length: */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(pwdinfo->device_name_len);
-	p2pielen += 2;
-
-	/*	Value: */
-	memcpy(p2pie + p2pielen, pwdinfo->device_name, pwdinfo->device_name_len);
-	p2pielen += pwdinfo->device_name_len;
-
-	/*  Group Info ATTR */
-	/*	Type: */
-	/*	Length: */
-	/*	Value: */
-	if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO))
-		p2pielen += go_add_group_info_attr(pwdinfo, p2pie + p2pielen);
-
-
-	pbuf = rtw_set_ie(pbuf, _VENDOR_SPECIFIC_IE_, p2pielen, (unsigned char *)p2pie, &len);
-
-
-	return len;
-}
-
-u32 build_prov_disc_request_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf, u8 *pssid, u8 ussidlen, u8 *pdev_raddr)
-{
-	u8 p2pie[MAX_P2P_IE_LEN] = { 0x00 };
-	u32 len = 0, p2pielen = 0;
-
-	/*	P2P OUI */
-	p2pielen = 0;
-	p2pie[p2pielen++] = 0x50;
-	p2pie[p2pielen++] = 0x6F;
-	p2pie[p2pielen++] = 0x9A;
-	p2pie[p2pielen++] = 0x09;	/*	WFA P2P v1.0 */
-
-	/*	Commented by Albert 20110301 */
-	/*	According to the P2P Specification, the provision discovery request frame should contain 3 P2P attributes */
-	/*	1. P2P Capability */
-	/*	2. Device Info */
-	/*	3. Group ID (When joining an operating P2P Group) */
-
-	/*	P2P Capability ATTR */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_CAPABILITY;
-
-	/*	Length: */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_le16(0x0002);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	Device Capability Bitmap, 1 byte */
-	p2pie[p2pielen++] = DMP_P2P_DEVCAP_SUPPORT;
-
-	/*	Group Capability Bitmap, 1 byte */
-	if (pwdinfo->persistent_supported)
-		p2pie[p2pielen++] = P2P_GRPCAP_PERSISTENT_GROUP | DMP_P2P_GRPCAP_SUPPORT;
-	else
-		p2pie[p2pielen++] = DMP_P2P_GRPCAP_SUPPORT;
-
-
-	/*	Device Info ATTR */
-	/*	Type: */
-	p2pie[p2pielen++] = P2P_ATTR_DEVICE_INFO;
-
-	/*	Length: */
-	/*	21 -> P2P Device Address (6bytes) + Config Methods (2bytes) + Primary Device Type (8bytes) */
-	/*	+ NumofSecondDevType (1byte) + WPS Device Name ID field (2bytes) + WPS Device Name Len field (2bytes) */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_le16(21 + pwdinfo->device_name_len);
-	p2pielen += 2;
-
-	/*	Value: */
-	/*	P2P Device Address */
-	memcpy(p2pie + p2pielen, pwdinfo->device_addr, ETH_ALEN);
-	p2pielen += ETH_ALEN;
-
-	/*	Config Method */
-	/*	This field should be big endian. Noted by P2P specification. */
-	if (pwdinfo->ui_got_wps_info == P2P_GOT_WPSINFO_PBC) {
-		*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_CONFIG_METHOD_PBC);
-	} else {
-		*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_CONFIG_METHOD_DISPLAY);
-	}
-
-	p2pielen += 2;
-
-	/*	Primary Device Type */
-	/*	Category ID */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_PDT_CID_MULIT_MEDIA);
-	p2pielen += 2;
-
-	/*	OUI */
-	*((u32 *)(p2pie + p2pielen)) = cpu_to_be32(WPSOUI);
-	p2pielen += 4;
-
-	/*	Sub Category ID */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_PDT_SCID_MEDIA_SERVER);
-	p2pielen += 2;
-
-	/*	Number of Secondary Device Types */
-	p2pie[p2pielen++] = 0x00;	/*	No Secondary Device Type List */
-
-	/*	Device Name */
-	/*	Type: */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(WPS_ATTR_DEVICE_NAME);
-	p2pielen += 2;
-
-	/*	Length: */
-	*(u16 *) (p2pie + p2pielen) = cpu_to_be16(pwdinfo->device_name_len);
-	p2pielen += 2;
-
-	/*	Value: */
-	memcpy(p2pie + p2pielen, pwdinfo->device_name, pwdinfo->device_name_len);
-	p2pielen += pwdinfo->device_name_len;
-
-	if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_CLIENT)) {
-		/*	Added by Albert 2011/05/19 */
-		/*	In this case, the pdev_raddr is the device address of the group owner. */
-
-		/*	P2P Group ID ATTR */
-		/*	Type: */
-		p2pie[p2pielen++] = P2P_ATTR_GROUP_ID;
-
-		/*	Length: */
-		*(u16 *) (p2pie + p2pielen) = cpu_to_le16(ETH_ALEN + ussidlen);
-		p2pielen += 2;
-
-		/*	Value: */
-		memcpy(p2pie + p2pielen, pdev_raddr, ETH_ALEN);
-		p2pielen += ETH_ALEN;
-
-		memcpy(p2pie + p2pielen, pssid, ussidlen);
-		p2pielen += ussidlen;
-	}
-
-	pbuf = rtw_set_ie(pbuf, _VENDOR_SPECIFIC_IE_, p2pielen, (unsigned char *)p2pie, &len);
-
-
-	return len;
-}
-
-
-u32 build_assoc_resp_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf, u8 status_code)
-{
-	u8 p2pie[MAX_P2P_IE_LEN] = { 0x00 };
-	u32 len = 0, p2pielen = 0;
-
-	/*	P2P OUI */
-	p2pielen = 0;
-	p2pie[p2pielen++] = 0x50;
-	p2pie[p2pielen++] = 0x6F;
-	p2pie[p2pielen++] = 0x9A;
-	p2pie[p2pielen++] = 0x09;	/*	WFA P2P v1.0 */
-
-	/*  According to the P2P Specification, the Association response frame should contain 2 P2P attributes */
-	/*	1. Status */
-	/*	2. Extended Listen Timing (optional) */
-
-
-	/*	Status ATTR */
-	p2pielen += rtw_set_p2p_attr_content(&p2pie[p2pielen], P2P_ATTR_STATUS, 1, &status_code);
-
-
-	/*  Extended Listen Timing ATTR */
-	/*	Type: */
-	/*	Length: */
-	/*	Value: */
-
-	pbuf = rtw_set_ie(pbuf, _VENDOR_SPECIFIC_IE_, p2pielen, (unsigned char *)p2pie, &len);
-
-	return len;
-}
-
-u32 build_deauth_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf)
-{
-	u32 len = 0;
-
-	return len;
-}
-
-u32 process_probe_req_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pframe, uint len)
-{
-	u8 *p;
-	u32 ret = false;
-	u8 *p2pie;
-	u32	p2pielen = 0;
-	int ssid_len = 0, rate_cnt = 0;
-
-	p = rtw_get_ie(pframe + WLAN_HDR_A3_LEN + _PROBEREQ_IE_OFFSET_, _SUPPORTEDRATES_IE_, (int *)&rate_cnt,
-			len - WLAN_HDR_A3_LEN - _PROBEREQ_IE_OFFSET_);
-
-	if (rate_cnt <= 4) {
-		int i, g_rate = 0;
-
-		for (i = 0; i < rate_cnt; i++) {
-			if (((*(p + 2 + i) & 0xff) != 0x02) &&
-			    ((*(p + 2 + i) & 0xff) != 0x04) &&
-			    ((*(p + 2 + i) & 0xff) != 0x0B) &&
-			    ((*(p + 2 + i) & 0xff) != 0x16))
-				g_rate = 1;
-		}
-
-		if (g_rate == 0) {
-			/*	There is no OFDM rate included in SupportedRates IE of this probe request frame */
-			/*	The driver should response this probe request. */
-			return ret;
-		}
-	} else {
-		/*	rate_cnt > 4 means the SupportRates IE contains the OFDM rate because the count of CCK rates are 4. */
-		/*	We should proceed the following check for this probe request. */
-	}
-
-	/*	Added comments by Albert 20100906 */
-	/*	There are several items we should check here. */
-	/*	1. This probe request frame must contain the P2P IE. (Done) */
-	/*	2. This probe request frame must contain the wildcard SSID. (Done) */
-	/*	3. Wildcard BSSID. (Todo) */
-	/*	4. Destination Address. (Done in mgt_dispatcher function) */
-	/*	5. Requested Device Type in WSC IE. (Todo) */
-	/*	6. Device ID attribute in P2P IE. (Todo) */
-
-	p = rtw_get_ie(pframe + WLAN_HDR_A3_LEN + _PROBEREQ_IE_OFFSET_, _SSID_IE_, (int *)&ssid_len,
-			len - WLAN_HDR_A3_LEN - _PROBEREQ_IE_OFFSET_);
-
-	ssid_len &= 0xff;	/*	Just last 1 byte is valid for ssid len of the probe request */
-	if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_DEVICE) || rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO)) {
-		p2pie = rtw_get_p2p_ie(pframe + WLAN_HDR_A3_LEN + _PROBEREQ_IE_OFFSET_ , len - WLAN_HDR_A3_LEN - _PROBEREQ_IE_OFFSET_ , NULL, &p2pielen);
-		if (p2pie) {
-			if ((p != NULL) && !memcmp((void *)(p+2), (void *)pwdinfo->p2p_wildcard_ssid , 7)) {
-				/* todo: */
-				/* Check Requested Device Type attributes in WSC IE. */
-				/* Check Device ID attribute in P2P IE */
-
-				ret = true;
-			} else if ((p != NULL) && (ssid_len == 0)) {
-				ret = true;
-			}
-		} else {
-			/* non -p2p device */
-		}
-	}
-
-
-	return ret;
-}
-
-u32 process_assoc_req_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pframe, uint len, struct sta_info *psta)
-{
-	u8 status_code = P2P_STATUS_SUCCESS;
-	u8 *pbuf, *pattr_content = NULL;
-	u32 attr_contentlen = 0;
-	u16 cap_attr = 0;
-	unsigned short	frame_type, ie_offset = 0;
-	u8 *ies;
-	u32 ies_len;
-	u8 *p2p_ie;
-	u32	p2p_ielen = 0;
-	__be16 be_tmp;
-	__le16 le_tmp;
-
-	if (!rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO))
-		return P2P_STATUS_FAIL_REQUEST_UNABLE;
-
-	frame_type = GetFrameSubType(pframe);
-	if (frame_type == WIFI_ASSOCREQ)
-		ie_offset = _ASOCREQ_IE_OFFSET_;
-	else /*  WIFI_REASSOCREQ */
-		ie_offset = _REASOCREQ_IE_OFFSET_;
-
-	ies = pframe + WLAN_HDR_A3_LEN + ie_offset;
-	ies_len = len - WLAN_HDR_A3_LEN - ie_offset;
-
-	p2p_ie = rtw_get_p2p_ie(ies , ies_len , NULL, &p2p_ielen);
-
-	if (!p2p_ie) {
-		DBG_88E("[%s] P2P IE not Found!!\n", __func__);
-		status_code =  P2P_STATUS_FAIL_INVALID_PARAM;
-	} else {
-		DBG_88E("[%s] P2P IE Found!!\n", __func__);
-	}
-
-	while (p2p_ie) {
-		/* Check P2P Capability ATTR */
-		if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_CAPABILITY, (u8 *)&le_tmp, (uint *)&attr_contentlen)) {
-			DBG_88E("[%s] Got P2P Capability Attr!!\n", __func__);
-			cap_attr = le16_to_cpu(le_tmp);
-			psta->dev_cap = cap_attr&0xff;
-		}
-
-		/* Check Extended Listen Timing ATTR */
-
-
-		/* Check P2P Device Info ATTR */
-		if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_DEVICE_INFO, NULL, (uint *)&attr_contentlen)) {
-			DBG_88E("[%s] Got P2P DEVICE INFO Attr!!\n", __func__);
-			pattr_content = kzalloc(attr_contentlen, GFP_KERNEL);
-			pbuf = pattr_content;
-			if (pattr_content) {
-				u8 num_of_secdev_type;
-				u16 dev_name_len;
-
-				rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_DEVICE_INFO , pattr_content, (uint *)&attr_contentlen);
-
-				memcpy(psta->dev_addr,	pattr_content, ETH_ALEN);/* P2P Device Address */
-
-				pattr_content += ETH_ALEN;
-
-				memcpy(&be_tmp, pattr_content, 2);/* Config Methods */
-				psta->config_methods = be16_to_cpu(be_tmp);
-
-				pattr_content += 2;
-
-				memcpy(psta->primary_dev_type, pattr_content, 8);
-
-				pattr_content += 8;
-
-				num_of_secdev_type = *pattr_content;
-				pattr_content += 1;
-
-				if (num_of_secdev_type == 0) {
-					psta->num_of_secdev_type = 0;
-				} else {
-					u32 len;
-
-					psta->num_of_secdev_type = num_of_secdev_type;
-
-					len = (sizeof(psta->secdev_types_list) < (num_of_secdev_type*8)) ?
-					      (sizeof(psta->secdev_types_list)) : (num_of_secdev_type*8);
-
-					memcpy(psta->secdev_types_list, pattr_content, len);
-
-					pattr_content += (num_of_secdev_type*8);
-				}
-
-
-				psta->dev_name_len = 0;
-				if (WPS_ATTR_DEVICE_NAME == be16_to_cpu(*(__be16 *)pattr_content)) {
-					dev_name_len = be16_to_cpu(*(__be16 *)(pattr_content+2));
-
-					psta->dev_name_len = (sizeof(psta->dev_name) < dev_name_len) ? sizeof(psta->dev_name) : dev_name_len;
-
-					memcpy(psta->dev_name, pattr_content+4, psta->dev_name_len);
-				}
-				kfree(pbuf);
-			}
-		}
-
-		/* Get the next P2P IE */
-		p2p_ie = rtw_get_p2p_ie(p2p_ie+p2p_ielen, ies_len - (p2p_ie - ies + p2p_ielen), NULL, &p2p_ielen);
-	}
-
-	return status_code;
-}
-
-u32 process_p2p_devdisc_req(struct wifidirect_info *pwdinfo, u8 *pframe, uint len)
-{
-	u8 *frame_body;
-	u8 status, dialogToken;
-	struct sta_info *psta = NULL;
-	struct adapter *padapter = pwdinfo->padapter;
-	struct sta_priv *pstapriv = &padapter->stapriv;
-	u8 *p2p_ie;
-	u32	p2p_ielen = 0;
-
-	frame_body = (unsigned char *)(pframe + sizeof(struct rtw_ieee80211_hdr_3addr));
-
-	dialogToken = frame_body[7];
-	status = P2P_STATUS_FAIL_UNKNOWN_P2PGROUP;
-
-	p2p_ie = rtw_get_p2p_ie(frame_body + _PUBLIC_ACTION_IE_OFFSET_, len - _PUBLIC_ACTION_IE_OFFSET_, NULL, &p2p_ielen);
-	if (p2p_ie) {
-		u8 groupid[38] = { 0x00 };
-		u8 dev_addr[ETH_ALEN] = { 0x00 };
-		u32	attr_contentlen = 0;
-
-		if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_GROUP_ID, groupid, &attr_contentlen)) {
-			if (!memcmp(pwdinfo->device_addr, groupid, ETH_ALEN) &&
-			    !memcmp(pwdinfo->p2p_group_ssid, groupid+ETH_ALEN, pwdinfo->p2p_group_ssid_len)) {
-				attr_contentlen = 0;
-				if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_DEVICE_ID, dev_addr, &attr_contentlen)) {
-					struct list_head *phead, *plist;
-
-					spin_lock_bh(&pstapriv->asoc_list_lock);
-					phead = &pstapriv->asoc_list;
-					plist = phead->next;
-
-					/* look up sta asoc_queue */
-					while (phead != plist) {
-						psta = container_of(plist, struct sta_info, asoc_list);
-
-						plist = plist->next;
-
-						if (psta->is_p2p_device && (psta->dev_cap&P2P_DEVCAP_CLIENT_DISCOVERABILITY) &&
-						    !memcmp(psta->dev_addr, dev_addr, ETH_ALEN)) {
-							/* issue GO Discoverability Request */
-							issue_group_disc_req(pwdinfo, psta->hwaddr);
-							status = P2P_STATUS_SUCCESS;
-							break;
-						} else {
-							status = P2P_STATUS_FAIL_INFO_UNAVAILABLE;
-						}
-					}
-					spin_unlock_bh(&pstapriv->asoc_list_lock);
-				} else {
-					status = P2P_STATUS_FAIL_INVALID_PARAM;
-				}
-			} else {
-				status = P2P_STATUS_FAIL_INVALID_PARAM;
-			}
-		}
-	}
-
-
-	/* issue Device Discoverability Response */
-	issue_p2p_devdisc_resp(pwdinfo, GetAddr2Ptr(pframe), status, dialogToken);
-
-	return (status == P2P_STATUS_SUCCESS) ? true : false;
-}
-
-u32 process_p2p_devdisc_resp(struct wifidirect_info *pwdinfo, u8 *pframe, uint len)
-{
-	return true;
-}
-
-u8 process_p2p_provdisc_req(struct wifidirect_info *pwdinfo,  u8 *pframe, uint len)
-{
-	u8 *frame_body;
-	u8 *wpsie;
-	uint	wps_ielen = 0, attr_contentlen = 0;
-	u16	uconfig_method = 0;
-	__be16 be_tmp;
-
-	frame_body = (pframe + sizeof(struct rtw_ieee80211_hdr_3addr));
-
-	wpsie = rtw_get_wps_ie(frame_body + _PUBLIC_ACTION_IE_OFFSET_, len - _PUBLIC_ACTION_IE_OFFSET_, NULL, &wps_ielen);
-	if (wpsie) {
-		if (rtw_get_wps_attr_content(wpsie, wps_ielen, WPS_ATTR_CONF_METHOD, (u8 *)&be_tmp, &attr_contentlen)) {
-			uconfig_method = be16_to_cpu(be_tmp);
-			switch (uconfig_method) {
-			case WPS_CM_DISPLYA:
-				memcpy(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, "dis", 3);
-				break;
-			case WPS_CM_LABEL:
-				memcpy(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, "lab", 3);
-				break;
-			case WPS_CM_PUSH_BUTTON:
-				memcpy(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, "pbc", 3);
-				break;
-			case WPS_CM_KEYPAD:
-				memcpy(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, "pad", 3);
-				break;
-			}
-			issue_p2p_provision_resp(pwdinfo, GetAddr2Ptr(pframe), frame_body, uconfig_method);
-		}
-	}
-	DBG_88E("[%s] config method = %s\n", __func__, pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req);
-	return true;
-}
-
-u8 process_p2p_provdisc_resp(struct wifidirect_info *pwdinfo,  u8 *pframe)
-{
-	return true;
-}
-
-static u8 rtw_p2p_get_peer_ch_list(struct wifidirect_info *pwdinfo, u8 *ch_content, u8 ch_cnt, u8 *peer_ch_list)
-{
-	u8 i = 0, j = 0;
-	u8 temp = 0;
-	u8 ch_no = 0;
-	ch_content += 3;
-	ch_cnt -= 3;
-
-	while (ch_cnt > 0) {
-		ch_content += 1;
-		ch_cnt -= 1;
-		temp = *ch_content;
-		for (i = 0 ; i < temp ; i++, j++)
-			peer_ch_list[j] = *(ch_content + 1 + i);
-		ch_content += (temp + 1);
-		ch_cnt -= (temp + 1);
-		ch_no += temp ;
-	}
-
-	return ch_no;
-}
-
-static u8 rtw_p2p_ch_inclusion(struct mlme_ext_priv *pmlmeext, u8 *peer_ch_list, u8 peer_ch_num, u8 *ch_list_inclusioned)
-{
-	int	i = 0, j = 0, temp = 0;
-	u8 ch_no = 0;
-
-	for (i = 0; i < peer_ch_num; i++) {
-		for (j = temp; j < pmlmeext->max_chan_nums; j++) {
-			if (*(peer_ch_list + i) == pmlmeext->channel_set[j].ChannelNum) {
-				ch_list_inclusioned[ch_no++] = *(peer_ch_list + i);
-				temp = j;
-				break;
-			}
-		}
-	}
-
-	return ch_no;
-}
-
-u8 process_p2p_group_negotation_req(struct wifidirect_info *pwdinfo, u8 *pframe, uint len)
-{
-	struct adapter *padapter = pwdinfo->padapter;
-	u8	result = P2P_STATUS_SUCCESS;
-	u32	p2p_ielen = 0, wps_ielen = 0;
-	u8 *ies;
-	u32 ies_len;
-	u8 *p2p_ie;
-	u8 *wpsie;
-	u16		wps_devicepassword_id = 0x0000;
-	uint	wps_devicepassword_id_len = 0;
-	__be16 be_tmp;
-
-	wpsie = rtw_get_wps_ie(pframe + _PUBLIC_ACTION_IE_OFFSET_, len - _PUBLIC_ACTION_IE_OFFSET_, NULL, &wps_ielen);
-	if (wpsie) {
-		/*	Commented by Kurt 20120113 */
-		/*	If some device wants to do p2p handshake without sending prov_disc_req */
-		/*	We have to get peer_req_cm from here. */
-		if (!memcmp(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, "000", 3)) {
-			rtw_get_wps_attr_content(wpsie, wps_ielen, WPS_ATTR_DEVICE_PWID, (u8 *)&be_tmp, &wps_devicepassword_id_len);
-			wps_devicepassword_id = be16_to_cpu(be_tmp);
-
-			if (wps_devicepassword_id == WPS_DPID_USER_SPEC)
-				memcpy(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, "dis", 3);
-			else if (wps_devicepassword_id == WPS_DPID_REGISTRAR_SPEC)
-				memcpy(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, "pad", 3);
-			else
-				memcpy(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, "pbc", 3);
-		}
-	} else {
-		DBG_88E("[%s] WPS IE not Found!!\n", __func__);
-		result = P2P_STATUS_FAIL_INCOMPATIBLE_PARAM;
-		rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_FAIL);
-		return result;
-	}
-
-	if (pwdinfo->ui_got_wps_info == P2P_NO_WPSINFO) {
-		result = P2P_STATUS_FAIL_INFO_UNAVAILABLE;
-		rtw_p2p_set_state(pwdinfo, P2P_STATE_TX_INFOR_NOREADY);
-		return result;
-	}
-
-	ies = pframe + _PUBLIC_ACTION_IE_OFFSET_;
-	ies_len = len - _PUBLIC_ACTION_IE_OFFSET_;
-
-	p2p_ie = rtw_get_p2p_ie(ies, ies_len, NULL, &p2p_ielen);
-
-	if (!p2p_ie) {
-		DBG_88E("[%s] P2P IE not Found!!\n", __func__);
-		result = P2P_STATUS_FAIL_INCOMPATIBLE_PARAM;
-		rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_FAIL);
-	}
-
-	while (p2p_ie) {
-		u8	attr_content = 0x00;
-		u32	attr_contentlen = 0;
-		u8	ch_content[50] = { 0x00 };
-		uint	ch_cnt = 0;
-		u8	peer_ch_list[50] = { 0x00 };
-		u8	peer_ch_num = 0;
-		u8	ch_list_inclusioned[50] = { 0x00 };
-		u8	ch_num_inclusioned = 0;
-
-		rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_ING);
-
-			if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_GO_INTENT , &attr_content, &attr_contentlen)) {
-			DBG_88E("[%s] GO Intent = %d, tie = %d\n", __func__, attr_content >> 1, attr_content & 0x01);
-			pwdinfo->peer_intent = attr_content;	/*	include both intent and tie breaker values. */
-
-			if (pwdinfo->intent == (pwdinfo->peer_intent >> 1)) {
-				/*	Try to match the tie breaker value */
-				if (pwdinfo->intent == P2P_MAX_INTENT) {
-					rtw_p2p_set_role(pwdinfo, P2P_ROLE_DEVICE);
-					result = P2P_STATUS_FAIL_BOTH_GOINTENT_15;
-				} else {
-					if (attr_content & 0x01)
-						rtw_p2p_set_role(pwdinfo, P2P_ROLE_CLIENT);
-					else
-						rtw_p2p_set_role(pwdinfo, P2P_ROLE_GO);
-				}
-			} else if (pwdinfo->intent > (pwdinfo->peer_intent >> 1)) {
-				rtw_p2p_set_role(pwdinfo, P2P_ROLE_GO);
-			} else {
-				rtw_p2p_set_role(pwdinfo, P2P_ROLE_CLIENT);
-			}
-
-			if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO)) {
-				/*	Store the group id information. */
-				memcpy(pwdinfo->groupid_info.go_device_addr, pwdinfo->device_addr, ETH_ALEN);
-				memcpy(pwdinfo->groupid_info.ssid, pwdinfo->nego_ssid, pwdinfo->nego_ssidlen);
-			}
-		}
-
-
-		attr_contentlen = 0;
-		if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_INTENTED_IF_ADDR, pwdinfo->p2p_peer_interface_addr, &attr_contentlen)) {
-			if (attr_contentlen != ETH_ALEN)
-				memset(pwdinfo->p2p_peer_interface_addr, 0x00, ETH_ALEN);
-		}
-
-		if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_CH_LIST, ch_content, &ch_cnt)) {
-			peer_ch_num = rtw_p2p_get_peer_ch_list(pwdinfo, ch_content, ch_cnt, peer_ch_list);
-			ch_num_inclusioned = rtw_p2p_ch_inclusion(&padapter->mlmeextpriv, peer_ch_list, peer_ch_num, ch_list_inclusioned);
-
-			if (ch_num_inclusioned == 0) {
-				DBG_88E("[%s] No common channel in channel list!\n", __func__);
-				result = P2P_STATUS_FAIL_NO_COMMON_CH;
-				rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_FAIL);
-				break;
-			}
-
-			if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO)) {
-				if (!rtw_p2p_is_channel_list_ok(pwdinfo->operating_channel,
-				    ch_list_inclusioned, ch_num_inclusioned)) {
-					u8 operatingch_info[5] = { 0x00 }, peer_operating_ch = 0;
-					attr_contentlen = 0;
-
-					if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_OPERATING_CH, operatingch_info, &attr_contentlen))
-						peer_operating_ch = operatingch_info[4];
-
-					if (rtw_p2p_is_channel_list_ok(peer_operating_ch,
-								       ch_list_inclusioned, ch_num_inclusioned)) {
-						/**
-						 *	Change our operating channel as peer's for compatibility.
-						 */
-						pwdinfo->operating_channel = peer_operating_ch;
-						DBG_88E("[%s] Change op ch to %02x as peer's\n", __func__, pwdinfo->operating_channel);
-					} else {
-						/*  Take first channel of ch_list_inclusioned as operating channel */
-						pwdinfo->operating_channel = ch_list_inclusioned[0];
-						DBG_88E("[%s] Change op ch to %02x\n", __func__, pwdinfo->operating_channel);
-					}
-				}
-			}
-		}
-
-		/* Get the next P2P IE */
-		p2p_ie = rtw_get_p2p_ie(p2p_ie+p2p_ielen, ies_len - (p2p_ie - ies + p2p_ielen), NULL, &p2p_ielen);
-	}
-	return result;
-}
-
-u8 process_p2p_group_negotation_resp(struct wifidirect_info *pwdinfo, u8 *pframe, uint len)
-{
-	struct adapter *padapter = pwdinfo->padapter;
-	u8	result = P2P_STATUS_SUCCESS;
-	u32	p2p_ielen, wps_ielen;
-	u8 *ies;
-	u32 ies_len;
-	u8 *p2p_ie;
-
-	ies = pframe + _PUBLIC_ACTION_IE_OFFSET_;
-	ies_len = len - _PUBLIC_ACTION_IE_OFFSET_;
-
-	/*	Be able to know which one is the P2P GO and which one is P2P client. */
-
-	if (rtw_get_wps_ie(ies, ies_len, NULL, &wps_ielen)) {
-	} else {
-		DBG_88E("[%s] WPS IE not Found!!\n", __func__);
-		result = P2P_STATUS_FAIL_INCOMPATIBLE_PARAM;
-		rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_FAIL);
-	}
-
-	p2p_ie = rtw_get_p2p_ie(ies, ies_len, NULL, &p2p_ielen);
-	if (!p2p_ie) {
-		rtw_p2p_set_role(pwdinfo, P2P_ROLE_DEVICE);
-		rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_FAIL);
-		result = P2P_STATUS_FAIL_INCOMPATIBLE_PARAM;
-	} else {
-		u8	attr_content = 0x00;
-		u32	attr_contentlen = 0;
-		u8	operatingch_info[5] = { 0x00 };
-		u8	groupid[38];
-		u8	peer_ch_list[50] = { 0x00 };
-		u8	peer_ch_num = 0;
-		u8	ch_list_inclusioned[50] = { 0x00 };
-		u8	ch_num_inclusioned = 0;
-
-		while (p2p_ie) {	/*	Found the P2P IE. */
-			rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_STATUS, &attr_content, &attr_contentlen);
-			if (attr_contentlen == 1) {
-				DBG_88E("[%s] Status = %d\n", __func__, attr_content);
-				if (attr_content == P2P_STATUS_SUCCESS) {
-					/*	Do nothing. */
-				} else {
-					if (P2P_STATUS_FAIL_INFO_UNAVAILABLE == attr_content) {
-						rtw_p2p_set_state(pwdinfo, P2P_STATE_RX_INFOR_NOREADY);
-					} else {
-						rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_FAIL);
-					}
-					rtw_p2p_set_role(pwdinfo, P2P_ROLE_DEVICE);
-					result = attr_content;
-					break;
-				}
-			}
-
-			/*	Try to get the peer's interface address */
-			attr_contentlen = 0;
-			if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_INTENTED_IF_ADDR, pwdinfo->p2p_peer_interface_addr, &attr_contentlen)) {
-				if (attr_contentlen != ETH_ALEN)
-					memset(pwdinfo->p2p_peer_interface_addr, 0x00, ETH_ALEN);
-			}
-
-			/*	Try to get the peer's intent and tie breaker value. */
-			attr_content = 0x00;
-			attr_contentlen = 0;
-			if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_GO_INTENT , &attr_content, &attr_contentlen)) {
-				DBG_88E("[%s] GO Intent = %d, tie = %d\n", __func__, attr_content >> 1, attr_content & 0x01);
-				pwdinfo->peer_intent = attr_content;	/*	include both intent and tie breaker values. */
-
-				if (pwdinfo->intent == (pwdinfo->peer_intent >> 1)) {
-					/*	Try to match the tie breaker value */
-					if (pwdinfo->intent == P2P_MAX_INTENT) {
-						rtw_p2p_set_role(pwdinfo, P2P_ROLE_DEVICE);
-						result = P2P_STATUS_FAIL_BOTH_GOINTENT_15;
-						rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_FAIL);
-					} else {
-						rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_OK);
-						rtw_p2p_set_pre_state(pwdinfo, P2P_STATE_GONEGO_OK);
-						if (attr_content & 0x01)
-							rtw_p2p_set_role(pwdinfo, P2P_ROLE_CLIENT);
-						else
-							rtw_p2p_set_role(pwdinfo, P2P_ROLE_GO);
-					}
-				} else if (pwdinfo->intent > (pwdinfo->peer_intent >> 1)) {
-					rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_OK);
-					rtw_p2p_set_pre_state(pwdinfo, P2P_STATE_GONEGO_OK);
-					rtw_p2p_set_role(pwdinfo, P2P_ROLE_GO);
-				} else {
-					rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_OK);
-					rtw_p2p_set_pre_state(pwdinfo, P2P_STATE_GONEGO_OK);
-					rtw_p2p_set_role(pwdinfo, P2P_ROLE_CLIENT);
-				}
-
-				if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO)) {
-					/*	Store the group id information. */
-					memcpy(pwdinfo->groupid_info.go_device_addr, pwdinfo->device_addr, ETH_ALEN);
-					memcpy(pwdinfo->groupid_info.ssid, pwdinfo->nego_ssid, pwdinfo->nego_ssidlen);
-				}
-			}
-
-			/*	Try to get the operation channel information */
-
-			attr_contentlen = 0;
-			if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_OPERATING_CH, operatingch_info, &attr_contentlen)) {
-				DBG_88E("[%s] Peer's operating channel = %d\n", __func__, operatingch_info[4]);
-				pwdinfo->peer_operating_ch = operatingch_info[4];
-			}
-
-			/*	Try to get the channel list information */
-			if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_CH_LIST, pwdinfo->channel_list_attr, &pwdinfo->channel_list_attr_len)) {
-				DBG_88E("[%s] channel list attribute found, len = %d\n", __func__,  pwdinfo->channel_list_attr_len);
-
-				peer_ch_num = rtw_p2p_get_peer_ch_list(pwdinfo, pwdinfo->channel_list_attr, pwdinfo->channel_list_attr_len, peer_ch_list);
-				ch_num_inclusioned = rtw_p2p_ch_inclusion(&padapter->mlmeextpriv, peer_ch_list, peer_ch_num, ch_list_inclusioned);
-
-				if (ch_num_inclusioned == 0) {
-					DBG_88E("[%s] No common channel in channel list!\n", __func__);
-					result = P2P_STATUS_FAIL_NO_COMMON_CH;
-					rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_FAIL);
-					break;
-				}
-
-				if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_GO)) {
-					if (!rtw_p2p_is_channel_list_ok(pwdinfo->operating_channel,
-					    ch_list_inclusioned, ch_num_inclusioned)) {
-						u8 operatingch_info[5] = { 0x00 }, peer_operating_ch = 0;
-						attr_contentlen = 0;
-
-						if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_OPERATING_CH, operatingch_info, &attr_contentlen))
-							peer_operating_ch = operatingch_info[4];
-
-						if (rtw_p2p_is_channel_list_ok(peer_operating_ch,
-						    ch_list_inclusioned, ch_num_inclusioned)) {
-							/**
-							 *	Change our operating channel as peer's for compatibility.
-							 */
-							pwdinfo->operating_channel = peer_operating_ch;
-							DBG_88E("[%s] Change op ch to %02x as peer's\n", __func__, pwdinfo->operating_channel);
-						} else {
-							/*  Take first channel of ch_list_inclusioned as operating channel */
-							pwdinfo->operating_channel = ch_list_inclusioned[0];
-							DBG_88E("[%s] Change op ch to %02x\n", __func__, pwdinfo->operating_channel);
-						}
-					}
-				}
-			} else {
-				DBG_88E("[%s] channel list attribute not found!\n", __func__);
-			}
-
-			/*	Try to get the group id information if peer is GO */
-			attr_contentlen = 0;
-			memset(groupid, 0x00, 38);
-			if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_GROUP_ID, groupid, &attr_contentlen)) {
-				memcpy(pwdinfo->groupid_info.go_device_addr, &groupid[0], ETH_ALEN);
-				memcpy(pwdinfo->groupid_info.ssid, &groupid[6], attr_contentlen - ETH_ALEN);
-			}
-
-			/* Get the next P2P IE */
-			p2p_ie = rtw_get_p2p_ie(p2p_ie+p2p_ielen, ies_len - (p2p_ie - ies + p2p_ielen), NULL, &p2p_ielen);
-		}
-	}
-	return result;
-}
-
-u8 process_p2p_group_negotation_confirm(struct wifidirect_info *pwdinfo, u8 *pframe, uint len)
-{
-	u8 *ies;
-	u32 ies_len;
-	u8 *p2p_ie;
-	u32	p2p_ielen = 0;
-	u8	result = P2P_STATUS_SUCCESS;
-	ies = pframe + _PUBLIC_ACTION_IE_OFFSET_;
-	ies_len = len - _PUBLIC_ACTION_IE_OFFSET_;
-
-	p2p_ie = rtw_get_p2p_ie(ies, ies_len, NULL, &p2p_ielen);
-	while (p2p_ie) {	/*	Found the P2P IE. */
-		u8	attr_content = 0x00, operatingch_info[5] = { 0x00 };
-		u8	groupid[38] = { 0x00 };
-		u32	attr_contentlen = 0;
-
-		pwdinfo->negotiation_dialog_token = 1;
-		rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_STATUS, &attr_content, &attr_contentlen);
-		if (attr_contentlen == 1) {
-			DBG_88E("[%s] Status = %d\n", __func__, attr_content);
-			result = attr_content;
-
-			if (attr_content == P2P_STATUS_SUCCESS) {
-				del_timer_sync(&pwdinfo->restore_p2p_state_timer);
-
-				/*	Commented by Albert 20100911 */
-				/*	Todo: Need to handle the case which both Intents are the same. */
-				rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_OK);
-				rtw_p2p_set_pre_state(pwdinfo, P2P_STATE_GONEGO_OK);
-				if ((pwdinfo->intent) > (pwdinfo->peer_intent >> 1)) {
-					rtw_p2p_set_role(pwdinfo, P2P_ROLE_GO);
-				} else if ((pwdinfo->intent) < (pwdinfo->peer_intent >> 1)) {
-					rtw_p2p_set_role(pwdinfo, P2P_ROLE_CLIENT);
-				} else {
-					/*	Have to compare the Tie Breaker */
-					if (pwdinfo->peer_intent & 0x01)
-						rtw_p2p_set_role(pwdinfo, P2P_ROLE_CLIENT);
-					else
-						rtw_p2p_set_role(pwdinfo, P2P_ROLE_GO);
-				}
-			} else {
-				rtw_p2p_set_role(pwdinfo, P2P_ROLE_DEVICE);
-				rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_FAIL);
-				break;
-			}
-		}
-
-		/*	Try to get the group id information */
-		attr_contentlen = 0;
-		memset(groupid, 0x00, 38);
-		if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_GROUP_ID, groupid, &attr_contentlen)) {
-			DBG_88E("[%s] Ssid = %s, ssidlen = %zu\n", __func__, &groupid[ETH_ALEN], strlen(&groupid[ETH_ALEN]));
-			memcpy(pwdinfo->groupid_info.go_device_addr, &groupid[0], ETH_ALEN);
-			memcpy(pwdinfo->groupid_info.ssid, &groupid[6], attr_contentlen - ETH_ALEN);
-		}
-
-		attr_contentlen = 0;
-		if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_OPERATING_CH, operatingch_info, &attr_contentlen)) {
-			DBG_88E("[%s] Peer's operating channel = %d\n", __func__, operatingch_info[4]);
-			pwdinfo->peer_operating_ch = operatingch_info[4];
-		}
-
-		/* Get the next P2P IE */
-		p2p_ie = rtw_get_p2p_ie(p2p_ie+p2p_ielen, ies_len - (p2p_ie - ies + p2p_ielen), NULL, &p2p_ielen);
-	}
-	return result;
-}
-
-u8 process_p2p_presence_req(struct wifidirect_info *pwdinfo, u8 *pframe, uint len)
-{
-	u8 *frame_body;
-	u8 dialogToken = 0;
-	u8 status = P2P_STATUS_SUCCESS;
-
-	frame_body = (unsigned char *)(pframe + sizeof(struct rtw_ieee80211_hdr_3addr));
-
-	dialogToken = frame_body[6];
-
-	/* todo: check NoA attribute */
-
-	issue_p2p_presence_resp(pwdinfo, GetAddr2Ptr(pframe), status, dialogToken);
-
-	return true;
-}
-
-static void find_phase_handler(struct adapter *padapter)
-{
-	struct wifidirect_info  *pwdinfo = &padapter->wdinfo;
-	struct ndis_802_11_ssid	ssid;
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-
-
-	memset((unsigned char *)&ssid, 0, sizeof(struct ndis_802_11_ssid));
-	memcpy(ssid.Ssid, pwdinfo->p2p_wildcard_ssid, P2P_WILDCARD_SSID_LEN);
-	ssid.SsidLength = P2P_WILDCARD_SSID_LEN;
-
-	rtw_p2p_set_state(pwdinfo, P2P_STATE_FIND_PHASE_SEARCH);
-
-	spin_lock_bh(&pmlmepriv->lock);
-	rtw_sitesurvey_cmd(padapter, &ssid, 1, NULL, 0);
-	spin_unlock_bh(&pmlmepriv->lock);
-}
-
-void p2p_concurrent_handler(struct adapter *padapter);
-
-static void restore_p2p_state_handler(struct adapter *padapter)
-{
-	struct wifidirect_info  *pwdinfo = &padapter->wdinfo;
-
-	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_GONEGO_ING) || rtw_p2p_chk_state(pwdinfo, P2P_STATE_GONEGO_FAIL))
-		rtw_p2p_set_role(pwdinfo, P2P_ROLE_DEVICE);
-	rtw_p2p_set_state(pwdinfo, rtw_p2p_pre_state(pwdinfo));
-
-	if (rtw_p2p_chk_role(pwdinfo, P2P_ROLE_DEVICE)) {
-		/*	In the P2P client mode, the driver should not switch back to its listen channel */
-		/*	because this P2P client should stay at the operating channel of P2P GO. */
-		set_channel_bwmode(padapter, pwdinfo->listen_channel, HAL_PRIME_CHNL_OFFSET_DONT_CARE, HT_CHANNEL_WIDTH_20);
-	}
-}
-
-static void pre_tx_invitereq_handler(struct adapter *padapter)
-{
-	struct wifidirect_info  *pwdinfo = &padapter->wdinfo;
-	u8	val8 = 1;
-
-	set_channel_bwmode(padapter, pwdinfo->invitereq_info.peer_ch, HAL_PRIME_CHNL_OFFSET_DONT_CARE, HT_CHANNEL_WIDTH_20);
-	padapter->HalFunc.SetHwRegHandler(padapter, HW_VAR_MLME_SITESURVEY, (u8 *)(&val8));
-	issue_probereq_p2p(padapter, NULL);
-	_set_timer(&pwdinfo->pre_tx_scan_timer, P2P_TX_PRESCAN_TIMEOUT);
-
-}
-
-static void pre_tx_provdisc_handler(struct adapter *padapter)
-{
-	struct wifidirect_info  *pwdinfo = &padapter->wdinfo;
-	u8	val8 = 1;
-
-	set_channel_bwmode(padapter, pwdinfo->tx_prov_disc_info.peer_channel_num[0], HAL_PRIME_CHNL_OFFSET_DONT_CARE, HT_CHANNEL_WIDTH_20);
-	rtw_hal_set_hwreg(padapter, HW_VAR_MLME_SITESURVEY, (u8 *)(&val8));
-	issue_probereq_p2p(padapter, NULL);
-	_set_timer(&pwdinfo->pre_tx_scan_timer, P2P_TX_PRESCAN_TIMEOUT);
-
-}
-
-static void pre_tx_negoreq_handler(struct adapter *padapter)
-{
-	struct wifidirect_info  *pwdinfo = &padapter->wdinfo;
-	u8	val8 = 1;
-
-	set_channel_bwmode(padapter, pwdinfo->nego_req_info.peer_channel_num[0], HAL_PRIME_CHNL_OFFSET_DONT_CARE, HT_CHANNEL_WIDTH_20);
-	rtw_hal_set_hwreg(padapter, HW_VAR_MLME_SITESURVEY, (u8 *)(&val8));
-	issue_probereq_p2p(padapter, NULL);
-	_set_timer(&pwdinfo->pre_tx_scan_timer, P2P_TX_PRESCAN_TIMEOUT);
-
-}
-
-void p2p_protocol_wk_hdl(struct adapter *padapter, int intCmdType)
-{
-	switch (intCmdType) {
-	case P2P_FIND_PHASE_WK:
-		find_phase_handler(padapter);
-		break;
-	case P2P_RESTORE_STATE_WK:
-		restore_p2p_state_handler(padapter);
-		break;
-	case P2P_PRE_TX_PROVDISC_PROCESS_WK:
-		pre_tx_provdisc_handler(padapter);
-		break;
-	case P2P_PRE_TX_INVITEREQ_PROCESS_WK:
-		pre_tx_invitereq_handler(padapter);
-		break;
-	case P2P_PRE_TX_NEGOREQ_PROCESS_WK:
-		pre_tx_negoreq_handler(padapter);
-		break;
-	}
-
-}
-
-void process_p2p_ps_ie(struct adapter *padapter, u8 *IEs, u32 IELength)
-{
-	u8 *ies;
-	u32 ies_len;
-	u8 *p2p_ie;
-	u32	p2p_ielen = 0;
-	u8	noa_attr[MAX_P2P_IE_LEN] = { 0x00 };/*  NoA length should be n*(13) + 2 */
-	u32	attr_contentlen = 0;
-
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-	u8	find_p2p = false, find_p2p_ps = false;
-	u8	noa_offset, noa_num, noa_index;
-
-
-	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
-		return;
-	if (IELength <= _BEACON_IE_OFFSET_)
-		return;
-
-	ies = IEs + _BEACON_IE_OFFSET_;
-	ies_len = IELength - _BEACON_IE_OFFSET_;
-
-	p2p_ie = rtw_get_p2p_ie(ies, ies_len, NULL, &p2p_ielen);
-
-	while (p2p_ie) {
-		find_p2p = true;
-		/*  Get Notice of Absence IE. */
-		if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_NOA, noa_attr, &attr_contentlen)) {
-			find_p2p_ps = true;
-			noa_index = noa_attr[0];
-
-			if ((pwdinfo->p2p_ps_mode == P2P_PS_NONE) ||
-			    (noa_index != pwdinfo->noa_index)) { /*  if index change, driver should reconfigure related setting. */
-				pwdinfo->noa_index = noa_index;
-				pwdinfo->opp_ps = noa_attr[1] >> 7;
-				pwdinfo->ctwindow = noa_attr[1] & 0x7F;
-
-				noa_offset = 2;
-				noa_num = 0;
-				/*  NoA length should be n*(13) + 2 */
-				if (attr_contentlen > 2) {
-					while (noa_offset < attr_contentlen) {
-						/* memcpy(&wifidirect_info->noa_count[noa_num], &noa_attr[noa_offset], 1); */
-						pwdinfo->noa_count[noa_num] = noa_attr[noa_offset];
-						noa_offset += 1;
-
-						memcpy(&pwdinfo->noa_duration[noa_num], &noa_attr[noa_offset], 4);
-						noa_offset += 4;
-
-						memcpy(&pwdinfo->noa_interval[noa_num], &noa_attr[noa_offset], 4);
-						noa_offset += 4;
-
-						memcpy(&pwdinfo->noa_start_time[noa_num], &noa_attr[noa_offset], 4);
-						noa_offset += 4;
-
-						noa_num++;
-					}
-				}
-				pwdinfo->noa_num = noa_num;
-
-				if (pwdinfo->opp_ps == 1) {
-					pwdinfo->p2p_ps_mode = P2P_PS_CTWINDOW;
-					/*  driver should wait LPS for entering CTWindow */
-					if (padapter->pwrctrlpriv.bFwCurrentInPSMode)
-						p2p_ps_wk_cmd(padapter, P2P_PS_ENABLE, 1);
-				} else if (pwdinfo->noa_num > 0) {
-					pwdinfo->p2p_ps_mode = P2P_PS_NOA;
-					p2p_ps_wk_cmd(padapter, P2P_PS_ENABLE, 1);
-				} else if (pwdinfo->p2p_ps_mode > P2P_PS_NONE) {
-					p2p_ps_wk_cmd(padapter, P2P_PS_DISABLE, 1);
-				}
-			}
-
-			break; /*  find target, just break. */
-		}
-
-		/* Get the next P2P IE */
-		p2p_ie = rtw_get_p2p_ie(p2p_ie+p2p_ielen, ies_len - (p2p_ie - ies + p2p_ielen), NULL, &p2p_ielen);
-	}
-
-	if (find_p2p) {
-		if ((pwdinfo->p2p_ps_mode > P2P_PS_NONE) && !find_p2p_ps)
-			p2p_ps_wk_cmd(padapter, P2P_PS_DISABLE, 1);
-	}
-
-}
-
-void p2p_ps_wk_hdl(struct adapter *padapter, u8 p2p_ps_state)
-{
-	struct pwrctrl_priv		*pwrpriv = &padapter->pwrctrlpriv;
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-
-
-	/*  Pre action for p2p state */
-	switch (p2p_ps_state) {
-	case P2P_PS_DISABLE:
-		pwdinfo->p2p_ps_state = p2p_ps_state;
-
-		rtw_hal_set_hwreg(padapter, HW_VAR_H2C_FW_P2P_PS_OFFLOAD, (u8 *)(&p2p_ps_state));
-
-		pwdinfo->noa_index = 0;
-		pwdinfo->ctwindow = 0;
-		pwdinfo->opp_ps = 0;
-		pwdinfo->noa_num = 0;
-		pwdinfo->p2p_ps_mode = P2P_PS_NONE;
-		if (padapter->pwrctrlpriv.bFwCurrentInPSMode) {
-			if (pwrpriv->smart_ps == 0) {
-				pwrpriv->smart_ps = 2;
-				rtw_hal_set_hwreg(padapter, HW_VAR_H2C_FW_PWRMODE, (u8 *)(&(padapter->pwrctrlpriv.pwr_mode)));
-			}
-		}
-		break;
-	case P2P_PS_ENABLE:
-		if (pwdinfo->p2p_ps_mode > P2P_PS_NONE) {
-			pwdinfo->p2p_ps_state = p2p_ps_state;
-
-			if (pwdinfo->ctwindow > 0) {
-				if (pwrpriv->smart_ps != 0) {
-					pwrpriv->smart_ps = 0;
-					DBG_88E("%s(): Enter CTW, change SmartPS\n", __func__);
-					rtw_hal_set_hwreg(padapter, HW_VAR_H2C_FW_PWRMODE, (u8 *)(&(padapter->pwrctrlpriv.pwr_mode)));
-				}
-			}
-			rtw_hal_set_hwreg(padapter, HW_VAR_H2C_FW_P2P_PS_OFFLOAD, (u8 *)(&p2p_ps_state));
-		}
-		break;
-	case P2P_PS_SCAN:
-	case P2P_PS_SCAN_DONE:
-	case P2P_PS_ALLSTASLEEP:
-		if (pwdinfo->p2p_ps_mode > P2P_PS_NONE) {
-			pwdinfo->p2p_ps_state = p2p_ps_state;
-			rtw_hal_set_hwreg(padapter, HW_VAR_H2C_FW_P2P_PS_OFFLOAD, (u8 *)(&p2p_ps_state));
-		}
-		break;
-	default:
-		break;
-	}
-
-}
-
-u8 p2p_ps_wk_cmd(struct adapter *padapter, u8 p2p_ps_state, u8 enqueue)
-{
-	struct cmd_obj	*ph2c;
-	struct drvextra_cmd_parm	*pdrvextra_cmd_parm;
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
-	u8	res = _SUCCESS;
-
-
-	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
-		return res;
-
-	if (enqueue) {
-		ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-		if (ph2c == NULL) {
-			res = _FAIL;
-			goto exit;
-		}
-
-		pdrvextra_cmd_parm = kzalloc(sizeof(struct drvextra_cmd_parm), GFP_KERNEL);
-		if (pdrvextra_cmd_parm == NULL) {
-			kfree(ph2c);
-			res = _FAIL;
-			goto exit;
-		}
-
-		pdrvextra_cmd_parm->ec_id = P2P_PS_WK_CID;
-		pdrvextra_cmd_parm->type_size = p2p_ps_state;
-		pdrvextra_cmd_parm->pbuf = NULL;
-
-		init_h2fwcmd_w_parm_no_rsp(ph2c, pdrvextra_cmd_parm, GEN_CMD_CODE(_Set_Drv_Extra));
-
-		res = rtw_enqueue_cmd(pcmdpriv, ph2c);
-	} else {
-		p2p_ps_wk_hdl(padapter, p2p_ps_state);
-	}
-
-exit:
-
-
-	return res;
-}
-
-static void reset_ch_sitesurvey_timer_process (void *FunctionContext)
-{
-	struct adapter *adapter = (struct adapter *)FunctionContext;
-	struct	wifidirect_info		*pwdinfo = &adapter->wdinfo;
-
-	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
-		return;
-
-	DBG_88E("[%s] In\n", __func__);
-	/*	Reset the operation channel information */
-	pwdinfo->rx_invitereq_info.operation_ch[0] = 0;
-	pwdinfo->rx_invitereq_info.scan_op_ch_only = 0;
-}
-
-static void reset_ch_sitesurvey_timer_process2 (void *FunctionContext)
-{
-	struct adapter *adapter = (struct adapter *)FunctionContext;
-	struct	wifidirect_info		*pwdinfo = &adapter->wdinfo;
-
-	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
-		return;
-
-	DBG_88E("[%s] In\n", __func__);
-	/*	Reset the operation channel information */
-	pwdinfo->p2p_info.operation_ch[0] = 0;
-	pwdinfo->p2p_info.scan_op_ch_only = 0;
-}
-
-static void restore_p2p_state_timer_process (void *FunctionContext)
-{
-	struct adapter *adapter = (struct adapter *)FunctionContext;
-	struct	wifidirect_info		*pwdinfo = &adapter->wdinfo;
-
-	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
-		return;
-
-	p2p_protocol_wk_cmd(adapter, P2P_RESTORE_STATE_WK);
-}
-
-static void pre_tx_scan_timer_process(void *FunctionContext)
-{
-	struct adapter *adapter = (struct adapter *)FunctionContext;
-	struct	wifidirect_info *pwdinfo = &adapter->wdinfo;
-	struct mlme_priv *pmlmepriv = &adapter->mlmepriv;
-
-	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
-		return;
-
-	spin_lock_bh(&pmlmepriv->lock);
-
-	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_TX_PROVISION_DIS_REQ)) {
-		if (pwdinfo->tx_prov_disc_info.benable) {	/*	the provision discovery request frame is trigger to send or not */
-			p2p_protocol_wk_cmd(adapter, P2P_PRE_TX_PROVDISC_PROCESS_WK);
-			/* issue_probereq_p2p(adapter, NULL); */
-			/* _set_timer(&pwdinfo->pre_tx_scan_timer, P2P_TX_PRESCAN_TIMEOUT); */
-		}
-	} else if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_GONEGO_ING)) {
-		if (pwdinfo->nego_req_info.benable)
-			p2p_protocol_wk_cmd(adapter, P2P_PRE_TX_NEGOREQ_PROCESS_WK);
-	} else if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_TX_INVITE_REQ)) {
-		if (pwdinfo->invitereq_info.benable)
-			p2p_protocol_wk_cmd(adapter, P2P_PRE_TX_INVITEREQ_PROCESS_WK);
-	} else {
-		DBG_88E("[%s] p2p_state is %d, ignore!!\n", __func__, rtw_p2p_state(pwdinfo));
-	}
-
-	spin_unlock_bh(&pmlmepriv->lock);
-}
-
-static void find_phase_timer_process(void *FunctionContext)
-{
-	struct adapter *adapter = (struct adapter *)FunctionContext;
-	struct	wifidirect_info		*pwdinfo = &adapter->wdinfo;
-
-	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
-		return;
-
-	adapter->wdinfo.find_phase_state_exchange_cnt++;
-
-	p2p_protocol_wk_cmd(adapter, P2P_FIND_PHASE_WK);
-}
-
-void reset_global_wifidirect_info(struct adapter *padapter)
-{
-	struct wifidirect_info	*pwdinfo;
-
-	pwdinfo = &padapter->wdinfo;
-	pwdinfo->persistent_supported = 0;
-	pwdinfo->session_available = true;
-	pwdinfo->wfd_tdls_enable = 0;
-	pwdinfo->wfd_tdls_weaksec = 0;
-}
-
-void rtw_init_wifidirect_timers(struct adapter *padapter)
-{
-	struct wifidirect_info *pwdinfo = &padapter->wdinfo;
-
-	_init_timer(&pwdinfo->find_phase_timer, padapter->pnetdev, find_phase_timer_process, padapter);
-	_init_timer(&pwdinfo->restore_p2p_state_timer, padapter->pnetdev, restore_p2p_state_timer_process, padapter);
-	_init_timer(&pwdinfo->pre_tx_scan_timer, padapter->pnetdev, pre_tx_scan_timer_process, padapter);
-	_init_timer(&pwdinfo->reset_ch_sitesurvey, padapter->pnetdev, reset_ch_sitesurvey_timer_process, padapter);
-	_init_timer(&pwdinfo->reset_ch_sitesurvey2, padapter->pnetdev, reset_ch_sitesurvey_timer_process2, padapter);
-}
-
-void rtw_init_wifidirect_addrs(struct adapter *padapter, u8 *dev_addr, u8 *iface_addr)
-{
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info *pwdinfo = &padapter->wdinfo;
-
-	/*init device&interface address */
-	if (dev_addr)
-		memcpy(pwdinfo->device_addr, dev_addr, ETH_ALEN);
-	if (iface_addr)
-		memcpy(pwdinfo->interface_addr, iface_addr, ETH_ALEN);
-#endif
-}
-
-void init_wifidirect_info(struct adapter *padapter, enum P2P_ROLE role)
-{
-	struct wifidirect_info	*pwdinfo;
-
-	pwdinfo = &padapter->wdinfo;
-	pwdinfo->padapter = padapter;
-
-	/*	1, 6, 11 are the social channel defined in the WiFi Direct specification. */
-	pwdinfo->social_chan[0] = 1;
-	pwdinfo->social_chan[1] = 6;
-	pwdinfo->social_chan[2] = 11;
-	pwdinfo->social_chan[3] = 0;	/*	channel 0 for scanning ending in site survey function. */
-
-	/*	Use the channel 11 as the listen channel */
-	pwdinfo->listen_channel = 11;
-
-	if (role == P2P_ROLE_DEVICE) {
-		rtw_p2p_set_role(pwdinfo, P2P_ROLE_DEVICE);
-		rtw_p2p_set_state(pwdinfo, P2P_STATE_LISTEN);
-		pwdinfo->intent = 1;
-		rtw_p2p_set_pre_state(pwdinfo, P2P_STATE_LISTEN);
-	} else if (role == P2P_ROLE_CLIENT) {
-		rtw_p2p_set_role(pwdinfo, P2P_ROLE_CLIENT);
-		rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_OK);
-		pwdinfo->intent = 1;
-		rtw_p2p_set_pre_state(pwdinfo, P2P_STATE_GONEGO_OK);
-	} else if (role == P2P_ROLE_GO) {
-		rtw_p2p_set_role(pwdinfo, P2P_ROLE_GO);
-		rtw_p2p_set_state(pwdinfo, P2P_STATE_GONEGO_OK);
-		pwdinfo->intent = 15;
-		rtw_p2p_set_pre_state(pwdinfo, P2P_STATE_GONEGO_OK);
-	}
-
-/*	Use the OFDM rate in the P2P probe response frame. (6(B), 9(B), 12, 18, 24, 36, 48, 54) */
-	pwdinfo->support_rate[0] = 0x8c;	/*	6(B) */
-	pwdinfo->support_rate[1] = 0x92;	/*	9(B) */
-	pwdinfo->support_rate[2] = 0x18;	/*	12 */
-	pwdinfo->support_rate[3] = 0x24;	/*	18 */
-	pwdinfo->support_rate[4] = 0x30;	/*	24 */
-	pwdinfo->support_rate[5] = 0x48;	/*	36 */
-	pwdinfo->support_rate[6] = 0x60;	/*	48 */
-	pwdinfo->support_rate[7] = 0x6c;	/*	54 */
-
-	memcpy(pwdinfo->p2p_wildcard_ssid, "DIRECT-", 7);
-
-	memset(pwdinfo->device_name, 0x00, WPS_MAX_DEVICE_NAME_LEN);
-	pwdinfo->device_name_len = 0;
-
-	memset(&pwdinfo->invitereq_info, 0x00, sizeof(struct tx_invite_req_info));
-	pwdinfo->invitereq_info.token = 3;	/*	Token used for P2P invitation request frame. */
-
-	memset(&pwdinfo->inviteresp_info, 0x00, sizeof(struct tx_invite_resp_info));
-	pwdinfo->inviteresp_info.token = 0;
-
-	pwdinfo->profileindex = 0;
-	memset(&pwdinfo->profileinfo[0], 0x00, sizeof(struct profile_info) * P2P_MAX_PERSISTENT_GROUP_NUM);
-
-	rtw_p2p_findphase_ex_set(pwdinfo, P2P_FINDPHASE_EX_NONE);
-
-	pwdinfo->listen_dwell = (u8) ((jiffies % 3) + 1);
-
-	memset(&pwdinfo->tx_prov_disc_info, 0x00, sizeof(struct tx_provdisc_req_info));
-	pwdinfo->tx_prov_disc_info.wps_config_method_request = WPS_CM_NONE;
-
-	memset(&pwdinfo->nego_req_info, 0x00, sizeof(struct tx_nego_req_info));
-
-	pwdinfo->device_password_id_for_nego = WPS_DPID_PBC;
-	pwdinfo->negotiation_dialog_token = 1;
-
-	memset(pwdinfo->nego_ssid, 0x00, WLAN_SSID_MAXLEN);
-	pwdinfo->nego_ssidlen = 0;
-
-	pwdinfo->ui_got_wps_info = P2P_NO_WPSINFO;
-	pwdinfo->supported_wps_cm = WPS_CONFIG_METHOD_DISPLAY | WPS_CONFIG_METHOD_PBC | WPS_CONFIG_METHOD_KEYPAD;
-	pwdinfo->channel_list_attr_len = 0;
-	memset(pwdinfo->channel_list_attr, 0x00, 100);
-
-	memset(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, 0x00, 4);
-	memset(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, '0', 3);
-	memset(&pwdinfo->groupid_info, 0x00, sizeof(struct group_id_info));
-	pwdinfo->wfd_tdls_enable = 0;
-	memset(pwdinfo->p2p_peer_interface_addr, 0x00, ETH_ALEN);
-	memset(pwdinfo->p2p_peer_device_addr, 0x00, ETH_ALEN);
-
-	pwdinfo->rx_invitereq_info.operation_ch[0] = 0;
-	pwdinfo->rx_invitereq_info.operation_ch[1] = 0;	/*	Used to indicate the scan end in site survey function */
-	pwdinfo->rx_invitereq_info.scan_op_ch_only = 0;
-	pwdinfo->p2p_info.operation_ch[0] = 0;
-	pwdinfo->p2p_info.operation_ch[1] = 0;			/*	Used to indicate the scan end in site survey function */
-	pwdinfo->p2p_info.scan_op_ch_only = 0;
-}
-
-int rtw_p2p_enable(struct adapter *padapter, enum P2P_ROLE role)
-{
-	int ret = _SUCCESS;
-	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
-
-	if (role == P2P_ROLE_DEVICE || role == P2P_ROLE_CLIENT || role == P2P_ROLE_GO) {
-		/* leave IPS/Autosuspend */
-		if (_FAIL == rtw_pwr_wakeup(padapter)) {
-			ret = _FAIL;
-			goto exit;
-		}
-
-		/*	Added by Albert 2011/03/22 */
-		/*	In the P2P mode, the driver should not support the b mode. */
-		/*	So, the Tx packet shouldn't use the CCK rate */
-		update_tx_basic_rate(padapter, WIRELESS_11AGN);
-
-		/* Enable P2P function */
-		init_wifidirect_info(padapter, role);
-
-		rtw_hal_set_odm_var(padapter, HAL_ODM_P2P_STATE, NULL, true);
-	} else if (role == P2P_ROLE_DISABLE) {
-		if (_FAIL == rtw_pwr_wakeup(padapter)) {
-			ret = _FAIL;
-			goto exit;
-		}
-
-		/* Disable P2P function */
-		if (!rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE)) {
-			del_timer_sync(&pwdinfo->find_phase_timer);
-			del_timer_sync(&pwdinfo->restore_p2p_state_timer);
-			del_timer_sync(&pwdinfo->pre_tx_scan_timer);
-			del_timer_sync(&pwdinfo->reset_ch_sitesurvey);
-			del_timer_sync(&pwdinfo->reset_ch_sitesurvey2);
-			reset_ch_sitesurvey_timer_process(padapter);
-			reset_ch_sitesurvey_timer_process2(padapter);
-			rtw_p2p_set_state(pwdinfo, P2P_STATE_NONE);
-			rtw_p2p_set_role(pwdinfo, P2P_ROLE_DISABLE);
-			memset(&pwdinfo->rx_prov_disc_info, 0x00, sizeof(struct rx_provdisc_req_info));
-		}
-
-		rtw_hal_set_odm_var(padapter, HAL_ODM_P2P_STATE, NULL, false);
-
-		/* Restore to initial setting. */
-		update_tx_basic_rate(padapter, padapter->registrypriv.wireless_mode);
-	}
-
-exit:
-	return ret;
-}
-
-#else
-u8 p2p_ps_wk_cmd(struct adapter *padapter, u8 p2p_ps_state, u8 enqueue)
-{
-	return _FAIL;
-}
-
-void process_p2p_ps_ie(struct adapter *padapter, u8 *IEs, u32 IELength)
-{
-}
-
-#endif /* CONFIG_88EU_P2P */
diff --git a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
index 5605d95..439bc8f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
@@ -218,10 +218,6 @@ int ips_leave(struct adapter *padapter)
 static bool rtw_pwr_unassociated_idle(struct adapter *adapter)
 {
 	struct mlme_priv *pmlmepriv = &(adapter->mlmepriv);
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info	*pwdinfo = &(adapter->wdinfo);
-#endif
-
 	bool ret = false;
 
 	if (time_after_eq(adapter->pwrctrlpriv.ips_deny_time, jiffies))
@@ -230,12 +226,7 @@ static bool rtw_pwr_unassociated_idle(struct adapter *adapter)
 	if (check_fwstate(pmlmepriv, WIFI_ASOC_STATE|WIFI_SITE_MONITOR) ||
 	    check_fwstate(pmlmepriv, WIFI_UNDER_LINKING|WIFI_UNDER_WPS) ||
 	    check_fwstate(pmlmepriv, WIFI_AP_STATE) ||
-	    check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE|WIFI_ADHOC_STATE) ||
-#if defined(CONFIG_88EU_P2P)
-	    !rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
-#else
-	    0)
-#endif
+	    check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE|WIFI_ADHOC_STATE))
 		goto exit;
 
 	ret = true;
@@ -387,9 +378,6 @@ static u8 PS_RDY_CHECK(struct adapter *padapter)
 void rtw_set_ps_mode(struct adapter *padapter, u8 ps_mode, u8 smart_ps, u8 bcn_ant_mode)
 {
 	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info	*pwdinfo = &(padapter->wdinfo);
-#endif /* CONFIG_88EU_P2P */
 
 	RT_TRACE(_module_rtl871x_pwrctrl_c_, _drv_notice_,
 		 ("%s: PowerMode=%d Smart_PS=%d\n",
@@ -411,16 +399,6 @@ void rtw_set_ps_mode(struct adapter *padapter, u8 ps_mode, u8 smart_ps, u8 bcn_a
 
 	/* if (pwrpriv->pwr_mode == PS_MODE_ACTIVE) */
 	if (ps_mode == PS_MODE_ACTIVE) {
-#ifdef CONFIG_88EU_P2P
-		if (pwdinfo->opp_ps == 0) {
-			DBG_88E("rtw_set_ps_mode: Leave 802.11 power save\n");
-			pwrpriv->pwr_mode = ps_mode;
-			rtw_set_rpwm(padapter, PS_STATE_S4);
-			rtw_hal_set_hwreg(padapter, HW_VAR_H2C_FW_PWRMODE, (u8 *)(&ps_mode));
-			pwrpriv->bFwCurrentInPSMode = false;
-		}
-	} else {
-#endif /* CONFIG_88EU_P2P */
 		if (PS_RDY_CHECK(padapter)) {
 			DBG_88E("%s: Enter 802.11 power save\n", __func__);
 			pwrpriv->bFwCurrentInPSMode = true;
@@ -428,13 +406,6 @@ void rtw_set_ps_mode(struct adapter *padapter, u8 ps_mode, u8 smart_ps, u8 bcn_a
 			pwrpriv->smart_ps = smart_ps;
 			pwrpriv->bcn_ant_mode = bcn_ant_mode;
 			rtw_hal_set_hwreg(padapter, HW_VAR_H2C_FW_PWRMODE, (u8 *)(&ps_mode));
-
-#ifdef CONFIG_88EU_P2P
-			/*  Set CTWindow after LPS */
-			if (pwdinfo->opp_ps == 1)
-				p2p_ps_wk_cmd(padapter, P2P_PS_ENABLE, 0);
-#endif /* CONFIG_88EU_P2P */
-
 			rtw_set_rpwm(padapter, PS_STATE_S2);
 		}
 	}
@@ -531,11 +502,8 @@ void LeaveAllPowerSaveMode(struct adapter *Adapter)
 	struct mlme_priv	*pmlmepriv = &(Adapter->mlmepriv);
 	u8	enqueue = 0;
 
-	if (check_fwstate(pmlmepriv, _FW_LINKED)) { /* connect */
-		p2p_ps_wk_cmd(Adapter, P2P_PS_DISABLE, enqueue);
-
+	if (check_fwstate(pmlmepriv, _FW_LINKED))
 		rtw_lps_ctrl_wk_cmd(Adapter, LPS_CTRL_LEAVE, enqueue);
-	}
 }
 
 void rtw_init_pwrctrl_priv(struct adapter *padapter)
diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
index 2e709e6..83e706f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
@@ -1357,15 +1357,6 @@ void set_sta_rate(struct adapter *padapter, struct sta_info *psta)
 void update_tx_basic_rate(struct adapter *padapter, u8 wirelessmode)
 {
 	unsigned char supported_rates[NDIS_802_11_LENGTH_RATES_EX];
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info *pwdinfo = &padapter->wdinfo;
-
-	/*	Added by Albert 2011/03/22 */
-	/*	In the P2P mode, the driver should not support the b mode. */
-	/*	So, the Tx packet shouldn't use the CCK rate */
-	if (!rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
-		return;
-#endif /* CONFIG_88EU_P2P */
 	memset(supported_rates, 0, NDIS_802_11_LENGTH_RATES_EX);
 
 	if ((wirelessmode & WIRELESS_11B) && (wirelessmode == WIRELESS_11B))
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
index 99ad9c7..6ad3bd4 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
@@ -687,75 +687,3 @@ void rtl8188e_set_FwJoinBssReport_cmd(struct adapter *adapt, u8 mstatus)
 		usb_write8(adapt,  REG_CR+1, haldata->RegCR_1);
 	}
 }
-
-void rtl8188e_set_p2p_ps_offload_cmd(struct adapter *adapt, u8 p2p_ps_state)
-{
-#ifdef CONFIG_88EU_P2P
-	struct hal_data_8188e *haldata = GET_HAL_DATA(adapt);
-	struct wifidirect_info	*pwdinfo = &(adapt->wdinfo);
-	struct P2P_PS_Offload_t	*p2p_ps_offload = &haldata->p2p_ps_offload;
-	u8 i;
-
-
-	switch (p2p_ps_state) {
-	case P2P_PS_DISABLE:
-		DBG_88E("P2P_PS_DISABLE\n");
-		memset(p2p_ps_offload, 0, 1);
-		break;
-	case P2P_PS_ENABLE:
-		DBG_88E("P2P_PS_ENABLE\n");
-		/*  update CTWindow value. */
-		if (pwdinfo->ctwindow > 0) {
-			p2p_ps_offload->CTWindow_En = 1;
-			usb_write8(adapt, REG_P2P_CTWIN, pwdinfo->ctwindow);
-		}
-
-		/*  hw only support 2 set of NoA */
-		for (i = 0; i < pwdinfo->noa_num; i++) {
-			/*  To control the register setting for which NOA */
-			usb_write8(adapt, REG_NOA_DESC_SEL, (i << 4));
-			if (i == 0)
-				p2p_ps_offload->NoA0_En = 1;
-			else
-				p2p_ps_offload->NoA1_En = 1;
-
-			/*  config P2P NoA Descriptor Register */
-			usb_write32(adapt, REG_NOA_DESC_DURATION, pwdinfo->noa_duration[i]);
-			usb_write32(adapt, REG_NOA_DESC_INTERVAL, pwdinfo->noa_interval[i]);
-			usb_write32(adapt, REG_NOA_DESC_START, pwdinfo->noa_start_time[i]);
-			usb_write8(adapt, REG_NOA_DESC_COUNT, pwdinfo->noa_count[i]);
-		}
-
-		if ((pwdinfo->opp_ps == 1) || (pwdinfo->noa_num > 0)) {
-			/*  rst p2p circuit */
-			usb_write8(adapt, REG_DUAL_TSF_RST, BIT(4));
-
-			p2p_ps_offload->Offload_En = 1;
-
-			if (pwdinfo->role == P2P_ROLE_GO) {
-				p2p_ps_offload->role = 1;
-				p2p_ps_offload->AllStaSleep = 0;
-			} else {
-				p2p_ps_offload->role = 0;
-			}
-
-			p2p_ps_offload->discovery = 0;
-		}
-		break;
-	case P2P_PS_SCAN:
-		DBG_88E("P2P_PS_SCAN\n");
-		p2p_ps_offload->discovery = 1;
-		break;
-	case P2P_PS_SCAN_DONE:
-		DBG_88E("P2P_PS_SCAN_DONE\n");
-		p2p_ps_offload->discovery = 0;
-		pwdinfo->p2p_ps_state = P2P_PS_ENABLE;
-		break;
-	default:
-		break;
-	}
-
-	FillH2CCmd_88E(adapt, H2C_PS_P2P_OFFLOAD, 1, (u8 *)p2p_ps_offload);
-#endif
-
-}
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index c98928b..e1839331 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -1735,14 +1735,6 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			rtl8188e_set_FwJoinBssReport_cmd(Adapter, mstatus);
 		}
 		break;
-#ifdef CONFIG_88EU_P2P
-	case HW_VAR_H2C_FW_P2P_PS_OFFLOAD:
-		{
-			u8 p2p_ps_state = (*(u8 *)val);
-			rtl8188e_set_p2p_ps_offload_cmd(Adapter, p2p_ps_state);
-		}
-		break;
-#endif
 	case HW_VAR_INITIAL_GAIN:
 		{
 			struct rtw_dig *pDigTable = &podmpriv->DM_DigTable;
diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 00a207c..fdf2c79 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -48,7 +48,6 @@
 #include <rtw_event.h>
 #include <rtw_led.h>
 #include <rtw_mlme_ext.h>
-#include <rtw_p2p.h>
 #include <rtw_ap.h>
 
 #define SPEC_DEV_ID_NONE		BIT(0)
@@ -241,11 +240,6 @@ struct adapter {
 	/* The driver will show up the desired channel number
 	 * when this flag is 1. */
 	u8 bNotifyChannelChange;
-#ifdef CONFIG_88EU_P2P
-	/* The driver will show the current P2P status when the
-	 * upper application reads it. */
-	u8 bShowGetP2PState;
-#endif
 
 	struct mutex hw_init_mutex;
 
diff --git a/drivers/staging/rtl8188eu/include/ieee80211.h b/drivers/staging/rtl8188eu/include/ieee80211.h
index c4d38d1..3299571 100644
--- a/drivers/staging/rtl8188eu/include/ieee80211.h
+++ b/drivers/staging/rtl8188eu/include/ieee80211.h
@@ -1233,19 +1233,6 @@ u8 *rtw_get_wps_attr_content(u8 *wps_ie, uint wps_ielen, u16 target_attr_id,
 void dump_ies(u8 *buf, u32 buf_len);
 void dump_wps_ie(u8 *ie, u32 ie_len);
 
-#ifdef CONFIG_88EU_P2P
-void dump_p2p_ie(u8 *ie, u32 ie_len);
-u8 *rtw_get_p2p_ie(u8 *in_ie, int in_len, u8 *p2p_ie, uint *p2p_ielen);
-u8 *rtw_get_p2p_attr(u8 *p2p_ie, uint p2p_ielen, u8 target_attr_id,
-		     u8 *buf_attr, u32 *len_attr);
-u8 *rtw_get_p2p_attr_content(u8 *p2p_ie, uint p2p_ielen, u8 target_attr_id,
-			     u8 *buf_content, uint *len_content);
-u32 rtw_set_p2p_attr_content(u8 *pbuf, u8 attr_id, u16 attr_len,
-			     u8 *pdata_attr);
-void rtw_wlan_bssid_ex_remove_p2p_attr(struct wlan_bssid_ex *bss_ex,
-				       u8 attr_id);
-#endif
-
 uint	rtw_get_rateset_len(u8	*rateset);
 
 struct registry_priv;
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_cmd.h b/drivers/staging/rtl8188eu/include/rtl8188e_cmd.h
index 4601169..0e78e2a 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_cmd.h
@@ -112,10 +112,6 @@ u8 rtl8188e_set_raid_cmd(struct adapter *padapter, u32 mask);
 void rtl8188e_Add_RateATid(struct adapter *padapter, u32 bitmap, u8 arg,
 			   u8 rssi_level);
 
-#ifdef CONFIG_88EU_P2P
-void rtl8188e_set_p2p_ps_offload_cmd(struct adapter *adapt, u8 p2p_ps_state);
-#endif /* CONFIG_88EU_P2P */
-
 void rtl8188e_set_FwMediaStatus_cmd(struct adapter *adapt, __le16 mstatus_rpt);
 
 #endif/* __RTL8188E_CMD_H__ */
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
index ed3204f..a0a3ca7 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
@@ -386,10 +386,6 @@ struct hal_data_8188e {
 
 	u16	EfuseUsedBytes;
 
-#ifdef CONFIG_88EU_P2P
-	struct P2P_PS_Offload_t	p2p_ps_offload;
-#endif
-
 	/*  Auto FSM to Turn On, include clock, isolation, power control
 	 *  for MAC only */
 	u8	bMacPwrCtrlOn;
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index c478bde..d7fbff2 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -107,9 +107,6 @@ u32 rtw_init_evt_priv(struct evt_priv *pevtpriv);
 void rtw_free_evt_priv(struct evt_priv *pevtpriv);
 void rtw_cmd_clr_isr(struct cmd_priv *pcmdpriv);
 void rtw_evt_notify_isr(struct evt_priv *pevtpriv);
-#ifdef CONFIG_88EU_P2P
-u8 p2p_protocol_wk_cmd(struct adapter *padapter, int intCmdType);
-#endif /* CONFIG_88EU_P2P */
 
 enum rtw_drvextra_cmd_id {
 	NONE_WK_CID,
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
index 09e2a39..17c680f 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
@@ -565,18 +565,6 @@ s32 dump_mgntframe_and_wait(struct adapter *padapter,
 s32 dump_mgntframe_and_wait_ack(struct adapter *padapter,
 				struct xmit_frame *pmgntframe);
 
-#ifdef CONFIG_88EU_P2P
-void issue_probersp_p2p(struct adapter *padapter, unsigned char *da);
-void issue_p2p_provision_request(struct adapter *padapter, u8 *pssid,
-				 u8 ussidlen, u8 *pdev_raddr);
-void issue_p2p_GO_request(struct adapter *padapter, u8 *raddr);
-void issue_probereq_p2p(struct adapter *padapter, u8 *da);
-int issue_probereq_p2p_ex(struct adapter *adapter, u8 *da, int try_cnt,
-			  int wait_ms);
-void issue_p2p_invitation_response(struct adapter *padapter, u8 *raddr,
-				   u8 dialogToken, u8 success);
-void issue_p2p_invitation_request(struct adapter *padapter, u8 *raddr);
-#endif /* CONFIG_88EU_P2P */
 void issue_beacon(struct adapter *padapter, int timeout_ms);
 void issue_probersp(struct adapter *padapter, unsigned char *da,
 		    u8 is_valid_p2p_probereq);
diff --git a/drivers/staging/rtl8188eu/include/rtw_p2p.h b/drivers/staging/rtl8188eu/include/rtw_p2p.h
deleted file mode 100644
index a3e3adc..0000000
--- a/drivers/staging/rtl8188eu/include/rtw_p2p.h
+++ /dev/null
@@ -1,135 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- *
- ******************************************************************************/
-#ifndef __RTW_P2P_H_
-#define __RTW_P2P_H_
-
-#include <drv_types.h>
-
-u32 build_beacon_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf);
-u32 build_probe_resp_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf);
-u32 build_prov_disc_request_p2p_ie(struct wifidirect_info *pwdinfo,
-				   u8 *pbuf, u8 *pssid, u8 ussidlen,
-				   u8 *pdev_raddr);
-u32 build_assoc_resp_p2p_ie(struct wifidirect_info *pwdinfo,
-			    u8 *pbuf, u8 status_code);
-u32 build_deauth_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf);
-u32 process_probe_req_p2p_ie(struct wifidirect_info *pwdinfo,
-			     u8 *pframe, uint len);
-u32 process_assoc_req_p2p_ie(struct wifidirect_info *pwdinfo,
-			     u8 *pframe, uint len, struct sta_info *psta);
-u32 process_p2p_devdisc_req(struct wifidirect_info *pwdinfo,
-			    u8 *pframe, uint len);
-u32 process_p2p_devdisc_resp(struct wifidirect_info *pwdinfo,
-			     u8 *pframe, uint len);
-u8 process_p2p_provdisc_req(struct wifidirect_info *pwdinfo,
-			    u8 *pframe, uint len);
-u8 process_p2p_provdisc_resp(struct wifidirect_info *pwdinfo,  u8 *pframe);
-u8 process_p2p_group_negotation_req(struct wifidirect_info *pwdinfo,
-				    u8 *pframe, uint len);
-u8 process_p2p_group_negotation_resp(struct wifidirect_info *pwdinfo,
-				     u8 *pframe, uint len);
-u8 process_p2p_group_negotation_confirm(struct wifidirect_info *pwdinfo,
-					u8 *pframe, uint len);
-u8 process_p2p_presence_req(struct wifidirect_info *pwdinfo, u8 *pframe,
-			    uint len);
-void p2p_protocol_wk_hdl(struct adapter *padapter, int intcmdtype);
-void process_p2p_ps_ie(struct adapter *padapter, u8 *ies, u32 ielength);
-void p2p_ps_wk_hdl(struct adapter *padapter, u8 p2p_ps_state);
-u8 p2p_ps_wk_cmd(struct adapter *padapter, u8 p2p_ps_state, u8 enqueue);
-void reset_global_wifidirect_info(struct adapter *padapter);
-int rtw_init_wifi_display_info(struct adapter *padapter);
-void rtw_init_wifidirect_timers(struct adapter *padapter);
-void rtw_init_wifidirect_addrs(struct adapter *padapter, u8 *dev_addr,
-			       u8 *iface_addr);
-void init_wifidirect_info(struct adapter *padapter, enum P2P_ROLE role);
-int rtw_p2p_enable(struct adapter *padapter, enum P2P_ROLE role);
-
-static inline void _rtw_p2p_set_state(struct wifidirect_info *wdinfo,
-				      enum P2P_STATE state)
-{
-	if (wdinfo->p2p_state != state)
-		wdinfo->p2p_state = state;
-}
-
-static inline void _rtw_p2p_set_pre_state(struct wifidirect_info *wdinfo,
-					  enum P2P_STATE state)
-{
-	if (wdinfo->pre_p2p_state != state)
-		wdinfo->pre_p2p_state = state;
-}
-
-static inline void _rtw_p2p_set_role(struct wifidirect_info *wdinfo,
-				     enum P2P_ROLE role)
-{
-	if (wdinfo->role != role)
-		wdinfo->role = role;
-}
-
-static inline int _rtw_p2p_state(struct wifidirect_info *wdinfo)
-{
-	return wdinfo->p2p_state;
-}
-
-static inline int _rtw_p2p_pre_state(struct wifidirect_info *wdinfo)
-{
-	return wdinfo->pre_p2p_state;
-}
-
-static inline int _rtw_p2p_role(struct wifidirect_info *wdinfo)
-{
-	return wdinfo->role;
-}
-
-static inline bool _rtw_p2p_chk_state(struct wifidirect_info *wdinfo,
-				      enum P2P_STATE state)
-{
-	return wdinfo->p2p_state == state;
-}
-
-static inline bool _rtw_p2p_chk_role(struct wifidirect_info *wdinfo,
-				     enum P2P_ROLE role)
-{
-	return wdinfo->role == role;
-}
-
-#define rtw_p2p_set_state(wdinfo, state) _rtw_p2p_set_state(wdinfo, state)
-#define rtw_p2p_set_pre_state(wdinfo, state)				\
-	 _rtw_p2p_set_pre_state(wdinfo, state)
-#define rtw_p2p_set_role(wdinfo, role) _rtw_p2p_set_role(wdinfo, role)
-
-#define rtw_p2p_state(wdinfo) _rtw_p2p_state(wdinfo)
-#define rtw_p2p_pre_state(wdinfo) _rtw_p2p_pre_state(wdinfo)
-#define rtw_p2p_role(wdinfo) _rtw_p2p_role(wdinfo)
-#define rtw_p2p_chk_state(wdinfo, state) _rtw_p2p_chk_state(wdinfo, state)
-#define rtw_p2p_chk_role(wdinfo, role) _rtw_p2p_chk_role(wdinfo, role)
-
-#define rtw_p2p_findphase_ex_set(wdinfo, value) \
-	((wdinfo)->find_phase_state_exchange_cnt = (value))
-
-/* is this find phase exchange for social channel scan? */
-#define rtw_p2p_findphase_ex_is_social(wdinfo)   \
-((wdinfo)->find_phase_state_exchange_cnt >= P2P_FINDPHASE_EX_SOCIAL_FIRST)
-
-/* should we need find phase exchange anymore? */
-#define rtw_p2p_findphase_ex_is_needed(wdinfo) \
-	((wdinfo)->find_phase_state_exchange_cnt < P2P_FINDPHASE_EX_MAX && \
-	(wdinfo)->find_phase_state_exchange_cnt != P2P_FINDPHASE_EX_NONE)
-
-#endif
diff --git a/drivers/staging/rtl8188eu/include/sta_info.h b/drivers/staging/rtl8188eu/include/sta_info.h
index 3e909db..9612490 100644
--- a/drivers/staging/rtl8188eu/include/sta_info.h
+++ b/drivers/staging/rtl8188eu/include/sta_info.h
@@ -182,21 +182,6 @@ struct sta_info {
 	unsigned int sleepq_ac_len;
 #endif	/*  CONFIG_88EU_AP_MODE */
 
-#ifdef CONFIG_88EU_P2P
-	/* p2p priv data */
-	u8 is_p2p_device;
-	u8 p2p_status_code;
-
-	/* p2p client info */
-	u8 dev_addr[ETH_ALEN];
-	u8 dev_cap;
-	u16 config_methods;
-	u8 primary_dev_type[8];
-	u8 num_of_secdev_type;
-	u8 secdev_types_list[32];/*  32/8 == 4; */
-	u16 dev_name_len;
-	u8 dev_name[32];
-#endif /* CONFIG_88EU_P2P */
 	u8 under_exist_checking;
 	u8 keep_alive_trycnt;
 
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 5e06e04..1f46ade 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -114,35 +114,6 @@ static char *translate_scan(struct adapter *padapter,
 	u8 bw_40MHz = 0, short_GI = 0;
 	u16 mcs_rate = 0;
 	u8 ss, sq;
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info *pwdinfo = &padapter->wdinfo;
-
-	if (!rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE)) {
-		u32	blnGotP2PIE = false;
-
-		/*	User is doing the P2P device discovery */
-		/*	The prefix of SSID should be "DIRECT-" and the IE should contains the P2P IE. */
-		/*	If not, the driver should ignore this AP and go to the next AP. */
-
-		/*	Verifying the SSID */
-		if (!memcmp(pnetwork->network.Ssid.Ssid, pwdinfo->p2p_wildcard_ssid, P2P_WILDCARD_SSID_LEN)) {
-			u32	p2pielen = 0;
-
-			if (pnetwork->network.Reserved[0] == 2) {/*  Probe Request */
-				/*	Verifying the P2P IE */
-				if (rtw_get_p2p_ie(pnetwork->network.IEs, pnetwork->network.IELength, NULL, &p2pielen))
-					blnGotP2PIE = true;
-			} else {/*  Beacon or Probe Respones */
-				/*	Verifying the P2P IE */
-				if (rtw_get_p2p_ie(&pnetwork->network.IEs[12], pnetwork->network.IELength - 12, NULL, &p2pielen))
-					blnGotP2PIE = true;
-			}
-		}
-
-		if (!blnGotP2PIE)
-			return start;
-	}
-#endif /* CONFIG_88EU_P2P */
 
 	/*  AP MAC address  */
 	iwe.cmd = SIOCGIWAP;
@@ -385,9 +356,6 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_priv	*pmlmepriv = &padapter->mlmepriv;
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info *pwdinfo = &padapter->wdinfo;
-#endif /* CONFIG_88EU_P2P */
 
 	param->u.crypt.err = 0;
 	param->u.crypt.alg[IEEE_CRYPT_ALG_NAME_LEN - 1] = '\0';
@@ -505,10 +473,6 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 					padapter->securitypriv.dot118021XGrpKeyid = param->u.crypt.idx;
 
 					rtw_set_key(padapter, &padapter->securitypriv, param->u.crypt.idx, 1);
-#ifdef CONFIG_88EU_P2P
-					if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_PROVISIONING_ING))
-						rtw_p2p_set_state(pwdinfo, P2P_STATE_PROVISIONING_DONE);
-#endif /* CONFIG_88EU_P2P */
 				}
 			}
 			pbcmc_sta = rtw_get_bcmc_stainfo(padapter);
@@ -537,9 +501,6 @@ static int rtw_set_wpa_ie(struct adapter *padapter, char *pie, unsigned short ie
 	u8 *buf = NULL;
 	int group_cipher = 0, pairwise_cipher = 0;
 	int ret = 0;
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info *pwdinfo = &padapter->wdinfo;
-#endif /* CONFIG_88EU_P2P */
 
 	if ((ielen > MAX_WPA_IE_LEN) || (pie == NULL)) {
 		_clr_fwstate_(&padapter->mlmepriv, WIFI_UNDER_WPS);
@@ -645,10 +606,6 @@ static int rtw_set_wpa_ie(struct adapter *padapter, char *pie, unsigned short ie
 					memcpy(padapter->securitypriv.wps_ie, &buf[cnt], padapter->securitypriv.wps_ie_len);
 
 					set_fwstate(&padapter->mlmepriv, WIFI_UNDER_WPS);
-#ifdef CONFIG_88EU_P2P
-					if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_GONEGO_OK))
-						rtw_p2p_set_state(pwdinfo, P2P_STATE_PROVISIONING_ING);
-#endif /* CONFIG_88EU_P2P */
 					cnt += buf[cnt+1]+2;
 					break;
 				} else {
@@ -1126,9 +1083,6 @@ static int rtw_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct ndis_802_11_ssid ssid[RTW_SSID_SCAN_AMOUNT];
-#ifdef CONFIG_88EU_P2P
-	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
-#endif /* CONFIG_88EU_P2P */
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_, ("rtw_wx_set_scan\n"));
 
 	if (padapter->registrypriv.mp_mode == 1) {
@@ -1175,15 +1129,6 @@ static int rtw_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 /*	the pmlmepriv->scan_interval is always equal to 3. */
 /*	So, the wpa_supplicant won't find out the WPS SoftAP. */
 
-#ifdef CONFIG_88EU_P2P
-	if (pwdinfo->p2p_state != P2P_STATE_NONE) {
-		rtw_p2p_set_pre_state(pwdinfo, rtw_p2p_state(pwdinfo));
-		rtw_p2p_set_state(pwdinfo, P2P_STATE_FIND_PHASE_SEARCH);
-		rtw_p2p_findphase_ex_set(pwdinfo, P2P_FINDPHASE_EX_FULL);
-		rtw_free_network_queue(padapter, true);
-	}
-#endif /* CONFIG_88EU_P2P */
-
 	memset(ssid, 0, sizeof(struct ndis_802_11_ssid)*RTW_SSID_SCAN_AMOUNT);
 
 	if (wrqu->data.length == sizeof(struct iw_scan_req)) {
@@ -1278,9 +1223,6 @@ static int rtw_wx_get_scan(struct net_device *dev, struct iw_request_info *a,
 	u32 cnt = 0;
 	u32 wait_for_surveydone;
 	int wait_status;
-#ifdef CONFIG_88EU_P2P
-	struct	wifidirect_info *pwdinfo = &padapter->wdinfo;
-#endif /* CONFIG_88EU_P2P */
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_, ("rtw_wx_get_scan\n"));
 	RT_TRACE(_module_rtl871x_ioctl_os_c, _drv_info_, (" Start of Query SIOCGIWSCAN .\n"));
 
@@ -1289,19 +1231,7 @@ static int rtw_wx_get_scan(struct net_device *dev, struct iw_request_info *a,
 		goto exit;
 	}
 
-#ifdef CONFIG_88EU_P2P
-	if (!rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE)) {
-		/*	P2P is enabled */
-		wait_for_surveydone = 200;
-	} else {
-		/*	P2P is disabled */
-		wait_for_surveydone = 100;
-	}
-#else
-	{
-		wait_for_surveydone = 100;
-	}
-#endif /* CONFIG_88EU_P2P */
+	wait_for_surveydone = 100;
 
 	wait_status = _FW_UNDER_SURVEY | _FW_UNDER_LINKING;
 
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index c2f55e2..aac9473 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -804,9 +804,6 @@ static u8 rtw_init_default_value(struct adapter *padapter)
 	padapter->bWritePortCancel = false;
 	padapter->bRxRSSIDisplay = 0;
 	padapter->bNotifyChannelChange = 0;
-#ifdef CONFIG_88EU_P2P
-	padapter->bShowGetP2PState = 1;
-#endif
 	return ret;
 }
 
@@ -867,12 +864,6 @@ u8 rtw_init_drv_sw(struct adapter *padapter)
 		goto exit;
 	}
 
-#ifdef CONFIG_88EU_P2P
-	rtw_init_wifidirect_timers(padapter);
-	init_wifidirect_info(padapter, P2P_ROLE_DISABLE);
-	reset_global_wifidirect_info(padapter);
-#endif /* CONFIG_88EU_P2P */
-
 	if (init_mlme_ext_priv(padapter) == _FAIL) {
 		RT_TRACE(_module_os_intfs_c_, _drv_err_, ("\n Can't init mlme_ext_priv\n"));
 		ret8 = _FAIL;
@@ -945,21 +936,6 @@ u8 rtw_free_drv_sw(struct adapter *padapter)
 {
 	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("==>rtw_free_drv_sw"));
 
-	/* we can call rtw_p2p_enable here, but: */
-	/*  1. rtw_p2p_enable may have IO operation */
-	/*  2. rtw_p2p_enable is bundled with wext interface */
-	#ifdef CONFIG_88EU_P2P
-	{
-		struct wifidirect_info *pwdinfo = &padapter->wdinfo;
-		if (!rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE)) {
-			del_timer_sync(&pwdinfo->find_phase_timer);
-			del_timer_sync(&pwdinfo->restore_p2p_state_timer);
-			del_timer_sync(&pwdinfo->pre_tx_scan_timer);
-			rtw_p2p_set_state(pwdinfo, P2P_STATE_NONE);
-		}
-	}
-	#endif
-
 	free_mlme_ext_priv(&padapter->mlmeextpriv);
 
 	rtw_free_cmd_priv(&padapter->cmdpriv);
@@ -1190,10 +1166,6 @@ int netdev_close(struct net_device *pnetdev)
 		rtw_led_control(padapter, LED_CTL_POWER_OFF);
 	}
 
-#ifdef CONFIG_88EU_P2P
-	rtw_p2p_enable(padapter, P2P_ROLE_DISABLE);
-#endif /* CONFIG_88EU_P2P */
-
 	kfree(dvobj->firmware.szFwBuffer);
 	dvobj->firmware.szFwBuffer = NULL;
 
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index f1630c2..b8676ac 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -428,10 +428,6 @@ static struct adapter *rtw_usb_if1_init(struct dvobj_priv *dvobj,
 	/*  alloc dev name after read efuse. */
 	rtw_init_netdev_name(pnetdev, padapter->registrypriv.ifname);
 	rtw_macaddr_cfg(padapter->eeprompriv.mac_addr);
-#ifdef CONFIG_88EU_P2P
-	rtw_init_wifidirect_addrs(padapter, padapter->eeprompriv.mac_addr,
-				  padapter->eeprompriv.mac_addr);
-#endif
 	memcpy(pnetdev->dev_addr, padapter->eeprompriv.mac_addr, ETH_ALEN);
 	DBG_88E("MAC Address from pnetdev->dev_addr =  %pM\n",
 		pnetdev->dev_addr);
-- 
1.7.10.4

