Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbaF1SY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:24:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbaF1RvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 3.15 011/139] Staging: rtl8188eu: overflow in update_sta_support_rate()
Date: Sat, 28 Jun 2014 10:46:12 -0700
Message-Id: <20140628174605.877565091@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 9dbd79aeb9842144d9a114a979a12c0949ee11eb upstream.

The ->SupportedRates[] array has NDIS_802_11_LENGTH_RATES_EX (16)
elements.  Since "ie_len" comes from then network and can go up to 255
then it means we should add a range check to prevent memory corruption.

Fixes: d6846af679e0 ('staging: r8188eu: Add files for new driver - part 7')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
@@ -1599,13 +1599,18 @@ int update_sta_support_rate(struct adapt
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


