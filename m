Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbaBDVA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:00:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbaBDVAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:00:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.4 12/37] rtlwifi: rtl8192cu: Fix some code in RF handling
Date: Tue,  4 Feb 2014 13:00:48 -0800
Message-Id: <20140204210056.357486000@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210055.992134150@linuxfoundation.org>
References: <20140204210055.992134150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit e9b0784bb9de3152e787ee779868c626b137fb3b upstream.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c |   29 +++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -85,17 +85,15 @@ void rtl92cu_phy_rf6052_set_cck_txpower(
 	if (mac->act_scanning) {
 		tx_agc[RF90_PATH_A] = 0x3f3f3f3f;
 		tx_agc[RF90_PATH_B] = 0x3f3f3f3f;
-		if (turbo_scanoff) {
-			for (idx1 = RF90_PATH_A; idx1 <= RF90_PATH_B; idx1++) {
-				tx_agc[idx1] = ppowerlevel[idx1] |
-				    (ppowerlevel[idx1] << 8) |
-				    (ppowerlevel[idx1] << 16) |
-				    (ppowerlevel[idx1] << 24);
-				if (rtlhal->interface == INTF_USB) {
-					if (tx_agc[idx1] > 0x20 &&
-					    rtlefuse->external_pa)
-						tx_agc[idx1] = 0x20;
-				}
+		for (idx1 = RF90_PATH_A; idx1 <= RF90_PATH_B; idx1++) {
+			tx_agc[idx1] = ppowerlevel[idx1] |
+			    (ppowerlevel[idx1] << 8) |
+			    (ppowerlevel[idx1] << 16) |
+			    (ppowerlevel[idx1] << 24);
+			if (rtlhal->interface == INTF_USB) {
+				if (tx_agc[idx1] > 0x20 &&
+				    rtlefuse->external_pa)
+					tx_agc[idx1] = 0x20;
 			}
 		}
 	} else {
@@ -107,7 +105,7 @@ void rtl92cu_phy_rf6052_set_cck_txpower(
 			   TXHIGHPWRLEVEL_LEVEL2) {
 			tx_agc[RF90_PATH_A] = 0x00000000;
 			tx_agc[RF90_PATH_B] = 0x00000000;
-		} else{
+		} else {
 			for (idx1 = RF90_PATH_A; idx1 <= RF90_PATH_B; idx1++) {
 				tx_agc[idx1] = ppowerlevel[idx1] |
 				    (ppowerlevel[idx1] << 8) |
@@ -379,7 +377,12 @@ static void _rtl92c_write_ofdm_power_reg
 			    regoffset == RTXAGC_B_MCS07_MCS04)
 				regoffset = 0xc98;
 			for (i = 0; i < 3; i++) {
-				writeVal = (writeVal > 6) ? (writeVal - 6) : 0;
+				if (i != 2)
+					writeVal = (writeVal > 8) ?
+						   (writeVal - 8) : 0;
+				else
+					writeVal = (writeVal > 6) ?
+						   (writeVal - 6) : 0;
 				rtl_write_byte(rtlpriv, (u32)(regoffset + i),
 					      (u8)writeVal);
 			}


