Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaFDRpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:45:53 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:54938 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaFDRpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:45:52 -0400
X-Originating-IP: 78.232.94.57
From: Remi Pommarel <repk@triplefau.lt>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Remi Pommarel <repk@triplefau.lt>
Subject: [PATCH] Staging: rtl8821ae: use kmalloc instead of variable length stack arrays
Date: Wed,  4 Jun 2014 19:45:45 +0200
Message-Id: <1401903945-21094-1-git-send-email-repk@triplefau.lt>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes stack arrays of variable length and use kmalloc() instead, thus
removing the sparse warnings "Variable length array is used".

Signed-off-by: Remi Pommarel <repk@triplefau.lt>
---
 drivers/staging/rtl8821ae/efuse.c | 38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8821ae/efuse.c b/drivers/staging/rtl8821ae/efuse.c
index 206012c..a41aa84 100644
--- a/drivers/staging/rtl8821ae/efuse.c
+++ b/drivers/staging/rtl8821ae/efuse.c
@@ -232,7 +232,7 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	u8 efuse_tbl[rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]];
+	u8 *efuse_tbl;
 	u8 rtemp8[1];
 	u16 efuse_addr = 0;
 	u8 offset, wren;
@@ -243,7 +243,7 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 		rtlpriv->cfg->maps[EFUSE_MAX_SECTION_MAP];
 	const u32 efuse_real_content_len =
 		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
-	u16 efuse_word[efuse_max_section][EFUSE_MAX_WORD_UNIT];
+	u16 **efuse_word;
 	u16 efuse_utilized = 0;
 	u8 efuse_usage;
 
@@ -254,9 +254,26 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 		return;
 	}
 
+	efuse_tbl = kmalloc(rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE] *
+			sizeof(*efuse_tbl), GFP_ATOMIC);
+	if (efuse_tbl == NULL)
+		return;
+
+	efuse_word = kcalloc(EFUSE_MAX_WORD_UNIT, sizeof(*efuse_word),
+			GFP_ATOMIC);
+	if (efuse_word == NULL)
+		goto out;
+
+	for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
+		efuse_word[i] = kmalloc(efuse_max_section *
+				sizeof(**efuse_word), GFP_ATOMIC);
+		if (efuse_word[i] == NULL)
+			goto done;
+	}
+
 	for (i = 0; i < efuse_max_section; i++)
 		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++)
-			efuse_word[i][j] = 0xFFFF;
+			efuse_word[j][i] = 0xFFFF;
 
 	read_efuse_byte(hw, efuse_addr, rtemp8);
 	if (*rtemp8 != 0xFF) {
@@ -304,7 +321,7 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 					read_efuse_byte(hw, efuse_addr, rtemp8);
 					efuse_addr++;
 					efuse_utilized++;
-					efuse_word[offset][i] = (*rtemp8 &
+					efuse_word[i][offset] = (*rtemp8 &
 								 0xff);
 
 					if (efuse_addr >=
@@ -318,7 +335,7 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 					read_efuse_byte(hw, efuse_addr, rtemp8);
 					efuse_addr++;
 					efuse_utilized++;
-					efuse_word[offset][i] |=
+					efuse_word[i][offset] |=
 					    (((u16) * rtemp8 << 8) & 0xff00);
 
 					if (efuse_addr >= efuse_real_content_len)
@@ -341,9 +358,9 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 	for (i = 0; i < efuse_max_section; i++) {
 		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++) {
 			efuse_tbl[(i * 8) + (j * 2)] =
-			    (efuse_word[i][j] & 0xff);
+			    (efuse_word[j][i] & 0xff);
 			efuse_tbl[(i * 8) + ((j * 2) + 1)] =
-			    ((efuse_word[i][j] >> 8) & 0xff);
+			    ((efuse_word[j][i] >> 8) & 0xff);
 		}
 	}
 
@@ -357,6 +374,13 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 				      (u8 *) & efuse_utilized);
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_EFUSE_USAGE,
 				      (u8 *) & efuse_usage);
+
+done:
+	for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++)
+		kfree(efuse_word[i]);
+	kfree(efuse_word);
+out:
+	kfree(efuse_tbl);
 }
 
 bool efuse_shadow_update_chk(struct ieee80211_hw *hw)
-- 
1.8.5.1

