Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbaGHNzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:55:14 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:42723 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaGHNzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:55:12 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org
Cc: gregkh@linuxfoundation.org, gulsah.1004@gmail.com,
        Larry.Finger@lwfinger.net, paulmck@linux.vnet.ibm.com,
        linville@tuxdriver.com, dan.carpenter@oracle.com,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] staging: rtl8192ee: Correct bitmask in comparsion
Date: Tue,  8 Jul 2014 16:54:59 +0300
Message-Id: <1404827699-7295-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issue is discovered by static checker. The proposed change (0x000c0
-> 0x000c) is likely correct because:
1. 16-bit `map` holds value coming from struct
ieee80211_vht_mcs_info.tx_mcs_map, which is described so: "TX MCS map 2
bits for each stream, total 8 streams". The changed code refers to case
of 2 TX streams, and 0x000c mask filters two bits related to the second
stream. Some codelines below 0x0003 mask is used to test first stream.
2. Mask 0x000c is used 3 more times in that place.
3. Specifying 5 digits of hex value is uncommon, especially while working
with `u16` variable. So likely the trailing zero is a typo.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=78041
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/staging/rtl8192ee/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192ee/base.c b/drivers/staging/rtl8192ee/base.c
index a7c69f7..71ed12e 100644
--- a/drivers/staging/rtl8192ee/base.c
+++ b/drivers/staging/rtl8192ee/base.c
@@ -827,7 +827,7 @@ static u8 _rtl_get_vht_highest_n_rate(struct ieee80211_hw *hw,
 	u16 map = le16_to_cpu(sta->vht_cap.vht_mcs.tx_mcs_map);
 
 	if ((get_rf_type(rtlphy) == RF_2T2R) &&
-	    (map & 0x000c) != 0x000c0) {
+	    (map & 0x000c) != 0x000c) {
 		if ((map & 0x000c) >> 2 == IEEE80211_VHT_MCS_SUPPORT_0_7)
 			hw_rate =
 			rtlpriv->cfg->maps[RTL_RC_VHT_RATE_2SS_MCS7];
-- 
1.8.3.2

