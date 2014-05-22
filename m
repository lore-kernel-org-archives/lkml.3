Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbaEVNIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:08:18 -0400
Received: from isis.lip6.fr ([132.227.60.2]:62866 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbaEVNIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:08:16 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: benoit.taine@lip6.fr, Jes Sorensen <Jes.Sorensen@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: Use kmemdup() instead of memcpy() to duplicate memory
Date: Thu, 22 May 2014 15:08:33 +0200
Message-Id: <1400764113-15933-1-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Thu, 22 May 2014 15:08:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci, and tested by compilation.

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c |    3 +--
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c |   17 +++++++----------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
index e2d426a..f917edd 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
@@ -339,12 +339,11 @@ int rtl8723a_FirmwareDownload(struct rtw_adapter *padapter)
 		rtStatus = _FAIL;
 		goto Exit;
 	}
-	firmware_buf = kzalloc(fw->size, GFP_KERNEL);
+	firmware_buf = kmemdup(fw->data, fw->size, GFP_KERNEL);
 	if (!firmware_buf) {
 		rtStatus = _FAIL;
 		goto Exit;
 	}
-	memcpy(firmware_buf, fw->data, fw->size);
 	buf = firmware_buf;
 	fw_size = fw->size;
 	release_firmware(fw);
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index 182f57c..c88a416 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -1426,14 +1426,14 @@ static int rtw_cfg80211_set_probe_req_wpsp2pie(struct rtw_adapter *padapter,
 				pmlmepriv->wps_probe_req_ie = NULL;
 			}
 
-			pmlmepriv->wps_probe_req_ie =
-				kmalloc(wps_ielen, GFP_KERNEL);
+			pmlmepriv->wps_probe_req_ie = kmemdup(wps_ie,
+							      wps_ielen,
+							      GFP_KERNEL);
 			if (pmlmepriv->wps_probe_req_ie == NULL) {
 				DBG_8723A("%s()-%d: kmalloc() ERROR!\n",
 					  __func__, __LINE__);
 				return -EINVAL;
 			}
-			memcpy(pmlmepriv->wps_probe_req_ie, wps_ie, wps_ielen);
 			pmlmepriv->wps_probe_req_ie_len = wps_ielen;
 		}
 	}
@@ -1697,12 +1697,11 @@ static int rtw_cfg80211_set_wpa_ie(struct rtw_adapter *padapter, const u8 *pie,
 		ret = -EINVAL;
 		goto exit;
 	}
-	buf = kzalloc(ielen, GFP_KERNEL);
+	buf = kmemdup(pie, ielen, GFP_KERNEL);
 	if (buf == NULL) {
 		ret = -ENOMEM;
 		goto exit;
 	}
-	memcpy(buf, pie, ielen);
 
 	/* dump */
 	DBG_8723A("set wpa_ie(length:%zu):\n", ielen);
@@ -3178,14 +3177,13 @@ static int rtw_cfg80211_set_beacon_wpsp2pie(struct net_device *ndev, char *buf,
 				pmlmepriv->wps_beacon_ie = NULL;
 			}
 
-			pmlmepriv->wps_beacon_ie =
-				kmalloc(wps_ielen, GFP_KERNEL);
+			pmlmepriv->wps_beacon_ie = kmemdup(wps_ie, wps_ielen,
+							   GFP_KERNEL);
 			if (pmlmepriv->wps_beacon_ie == NULL) {
 				DBG_8723A("%s()-%d: kmalloc() ERROR!\n",
 					  __func__, __LINE__);
 				return -EINVAL;
 			}
-			memcpy(pmlmepriv->wps_beacon_ie, wps_ie, wps_ielen);
 			pmlmepriv->wps_beacon_ie_len = wps_ielen;
 
 #ifdef CONFIG_8723AU_AP_MODE
@@ -3270,14 +3268,13 @@ static int rtw_cfg80211_set_assoc_resp_wpsp2pie(struct net_device *net,
 			pmlmepriv->wps_assoc_resp_ie = NULL;
 		}
 
-		pmlmepriv->wps_assoc_resp_ie = kmalloc(len, GFP_KERNEL);
+		pmlmepriv->wps_assoc_resp_ie = kmemdup(buf, len, GFP_KERNEL);
 		if (pmlmepriv->wps_assoc_resp_ie == NULL) {
 			DBG_8723A("%s()-%d: kmalloc() ERROR!\n",
 				  __func__, __LINE__);
 			return -EINVAL;
 
 		}
-		memcpy(pmlmepriv->wps_assoc_resp_ie, buf, len);
 		pmlmepriv->wps_assoc_resp_ie_len = len;
 	}
 

