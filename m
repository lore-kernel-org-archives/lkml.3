Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaC3XZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:25:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36205 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbaC3XY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:24:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "John W. Linville" <linville@tuxdriver.com>,
        "Larry Finger" <Larry.Finger@lwfinger.net>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.960567136@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 002/200] rtlwifi: rtl8192cu: Fix some code in RF handling
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit e9b0784bb9de3152e787ee779868c626b137fb3b upstream.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c | 29 ++++++++++++++++-------------
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
@@ -380,7 +378,12 @@ static void _rtl92c_write_ofdm_power_reg
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

