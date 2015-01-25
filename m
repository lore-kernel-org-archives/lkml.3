Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbbAYRlZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 12:41:25 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62027 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbbAYRlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 12:41:19 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        navin patidar <navin.patidar@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jeff Oczek <jeffoczek@gmail.com>,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] staging: rtl8188eu: core: rtw_wlan_util: Remove some unused functions
Date: Sun, 25 Jan 2015 18:44:30 +0100
Message-Id: <1422207870-10616-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
CAM_empty_entry() get_bsstype() rtw_get_oper_choffset()
rtw_get_oper_bw() is_ap_in_wep() should_forbid_n_rate()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c   |   90 ----------------------
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h |    6 --
 2 files changed, 96 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
index 33ccbbb..49229de 100644
--- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
@@ -326,21 +326,11 @@ inline void rtw_set_oper_ch(struct adapter *adapter, u8 ch)
 	adapter->mlmeextpriv.oper_channel = ch;
 }
 
-inline u8 rtw_get_oper_bw(struct adapter *adapter)
-{
-	return adapter->mlmeextpriv.oper_bwmode;
-}
-
 inline void rtw_set_oper_bw(struct adapter *adapter, u8 bw)
 {
 	adapter->mlmeextpriv.oper_bwmode = bw;
 }
 
-inline u8 rtw_get_oper_choffset(struct adapter *adapter)
-{
-	return adapter->mlmeextpriv.oper_ch_offset;
-}
-
 inline void rtw_set_oper_choffset(struct adapter *adapter, u8 offset)
 {
 	adapter->mlmeextpriv.oper_ch_offset = offset;
@@ -395,16 +385,6 @@ void set_channel_bwmode(struct adapter *padapter, unsigned char channel, unsigne
 	SetBWMode(padapter, bwmode, channel_offset);
 }
 
-int get_bsstype(unsigned short capability)
-{
-	if (capability & BIT(0))
-		return WIFI_FW_AP_STATE;
-	else if (capability & BIT(1))
-		return WIFI_FW_ADHOC_STATE;
-	else
-		return 0;
-}
-
 __inline u8 *get_my_bssid(struct wlan_bssid_ex *pnetwork)
 {
 	return pnetwork->MacAddress;
@@ -469,11 +449,6 @@ unsigned int decide_wait_for_beacon_timeout(unsigned int bcn_interval)
 		return bcn_interval << 2;
 }
 
-void CAM_empty_entry(struct adapter *Adapter, u8 ucIndex)
-{
-	rtw_hal_set_hwreg(Adapter, HW_VAR_CAM_EMPTY_ENTRY, (u8 *)(&ucIndex));
-}
-
 void invalidate_cam_all(struct adapter *padapter)
 {
 	rtw_hal_set_hwreg(padapter, HW_VAR_CAM_INVALID_ALL, NULL);
@@ -1157,71 +1132,6 @@ unsigned int is_ap_in_tkip(struct adapter *padapter)
 	}
 }
 
-unsigned int should_forbid_n_rate(struct adapter *padapter)
-{
-	u32 i;
-	struct ndis_802_11_var_ie *pIE;
-	struct mlme_priv	*pmlmepriv = &padapter->mlmepriv;
-	struct wlan_bssid_ex  *cur_network = &pmlmepriv->cur_network.network;
-
-	if (rtw_get_capability((struct wlan_bssid_ex *)cur_network) & WLAN_CAPABILITY_PRIVACY) {
-		for (i = sizeof(struct ndis_802_11_fixed_ie); i < cur_network->IELength;) {
-			pIE = (struct ndis_802_11_var_ie *)(cur_network->IEs + i);
-
-			switch (pIE->ElementID) {
-			case _VENDOR_SPECIFIC_IE_:
-				if (!memcmp(pIE->data, RTW_WPA_OUI, 4) &&
-				    ((!memcmp((pIE->data + 12), WPA_CIPHER_SUITE_CCMP, 4)) ||
-				    (!memcmp((pIE->data + 16), WPA_CIPHER_SUITE_CCMP, 4))))
-					return false;
-				break;
-			case _RSN_IE_2_:
-				if  ((!memcmp((pIE->data + 8), RSN_CIPHER_SUITE_CCMP, 4))  ||
-				       (!memcmp((pIE->data + 12), RSN_CIPHER_SUITE_CCMP, 4)))
-					return false;
-			default:
-				break;
-			}
-
-			i += (pIE->Length + 2);
-		}
-
-		return true;
-	} else {
-		return false;
-	}
-}
-
-unsigned int is_ap_in_wep(struct adapter *padapter)
-{
-	u32 i;
-	struct ndis_802_11_var_ie *pIE;
-	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
-	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
-	struct wlan_bssid_ex		*cur_network = &(pmlmeinfo->network);
-
-	if (rtw_get_capability((struct wlan_bssid_ex *)cur_network) & WLAN_CAPABILITY_PRIVACY) {
-		for (i = sizeof(struct ndis_802_11_fixed_ie); i < pmlmeinfo->network.IELength;) {
-			pIE = (struct ndis_802_11_var_ie *)(pmlmeinfo->network.IEs + i);
-
-			switch (pIE->ElementID) {
-			case _VENDOR_SPECIFIC_IE_:
-				if (!memcmp(pIE->data, RTW_WPA_OUI, 4))
-					return false;
-				break;
-			case _RSN_IE_2_:
-				return false;
-			default:
-				break;
-			}
-			i += (pIE->Length + 2);
-		}
-		return true;
-	} else {
-		return false;
-	}
-}
-
 static int wifirate2_ratetbl_inx(unsigned char rate)
 {
 	int	inx = 0;
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
index d699ca1..1aac00b 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
@@ -467,9 +467,7 @@ void Set_MSR(struct adapter *padapter, u8 type);
 
 u8 rtw_get_oper_ch(struct adapter *adapter);
 void rtw_set_oper_ch(struct adapter *adapter, u8 ch);
-u8 rtw_get_oper_bw(struct adapter *adapter);
 void rtw_set_oper_bw(struct adapter *adapter, u8 bw);
-u8 rtw_get_oper_choffset(struct adapter *adapter);
 void rtw_set_oper_choffset(struct adapter *adapter, u8 offset);
 
 void set_channel_bwmode(struct adapter *padapter, unsigned char channel,
@@ -484,7 +482,6 @@ void write_cam(struct adapter *padapter, u8 entry, u16 ctrl, u8 *mac, u8 *key);
 void clear_cam_entry(struct adapter *padapter, u8 entry);
 
 void invalidate_cam_all(struct adapter *padapter);
-void CAM_empty_entry(struct adapter *Adapter, u8 ucIndex);
 
 int allocate_fw_sta_entry(struct adapter *padapter);
 void flush_all_cam_entry(struct adapter *padapter);
@@ -495,7 +492,6 @@ u8 collect_bss_info(struct adapter *padapter, struct recv_frame *precv_frame,
 void update_network(struct wlan_bssid_ex *dst, struct wlan_bssid_ex *src,
 		    struct adapter *adapter, bool update_ie);
 
-int get_bsstype(unsigned short capability);
 u8 *get_my_bssid(struct wlan_bssid_ex *pnetwork);
 u16 get_beacon_interval(struct wlan_bssid_ex *bss);
 
@@ -540,8 +536,6 @@ unsigned int receive_disconnect(struct adapter *padapter,
 unsigned char get_highest_rate_idx(u32 mask);
 int support_short_GI(struct adapter *padapter, struct HT_caps_element *caps);
 unsigned int is_ap_in_tkip(struct adapter *padapter);
-unsigned int is_ap_in_wep(struct adapter *padapter);
-unsigned int should_forbid_n_rate(struct adapter *padapter);
 
 void report_join_res(struct adapter *padapter, int res);
 void report_survey_event(struct adapter *padapter,
-- 
1.7.10.4

