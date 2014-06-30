Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaF3Lxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:53:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52109 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754026AbaF3Lx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 101/181] Staging: rtl8188eu: overflow in update_sta_support_rate()
Date: Mon, 30 Jun 2014 13:52:02 +0200
Message-Id: <a323b12096d6d695c4903e4876486e75872d39de.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9dbd79aeb9842144d9a114a979a12c0949ee11eb upstream.

The ->SupportedRates[] array has NDIS_802_11_LENGTH_RATES_EX (16)
elements.  Since "ie_len" comes from then network and can go up to 255
then it means we should add a range check to prevent memory corruption.

Fixes: d6846af679e0 ('staging: r8188eu: Add files for new driver - part 7')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
index 8018edd3d42e..ce638d1723e3 100644
--- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
@@ -1607,13 +1607,18 @@ int update_sta_support_rate(struct adapter *padapter, u8 *pvar_ie, uint var_ie_l
 	pIE = (struct ndis_802_11_var_ie *)rtw_get_ie(pvar_ie, _SUPPORTEDRATES_IE_, &ie_len, var_ie_len);
 	if (pIE == NULL)
 		return _FAIL;
+	if (ie_len > NDIS_802_11_LENGTH_RATES_EX)
+		return _FAIL;
 
 	memcpy(pmlmeinfo->FW_sta_info[cam_idx].SupportedRates, pIE->data, ie_len);
 	supportRateNum = ie_len;
 
 	pIE = (struct ndis_802_11_var_ie *)rtw_get_ie(pvar_ie, _EXT_SUPPORTEDRATES_IE_, &ie_len, var_ie_len);
-	if (pIE)
+	if (pIE) {
+		if (supportRateNum + ie_len > NDIS_802_11_LENGTH_RATES_EX)
+			return _FAIL;
 		memcpy((pmlmeinfo->FW_sta_info[cam_idx].SupportedRates + supportRateNum), pIE->data, ie_len);
+	}
 
 	return _SUCCESS;
 }
-- 
2.0.0

