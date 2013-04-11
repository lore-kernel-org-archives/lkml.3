Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab3DKUbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:31:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759476Ab3DKU0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:16 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ZCzINNuo-o0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3RLqpLRH_KUA:10 a=yQdBAQUQAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=vmLDa1wCAAAA:8 a=KjHbni0LSKGGTBY6usIA:9 a=IcxpeKGZWnEA:10 a=MSl-tDqOz04A:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202552.704997813@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Alessandro Lannocca <alessandro.lannocca@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 040/171 ] rtlwifi: rtl8192cu: Fix problem that prevents reassociation
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0040-rtlwifi-rtl8192cu-Fix-problem-that-prevents-reassoci.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

[ Upstream commit 9437a248e7cac427c898bdb11bd1ac6844a1ead4 ]

The driver was failing to clear the BSSID when a disconnect happened. That
prevented a reconnection. This problem is reported at
https://bugzilla.redhat.com/show_bug.cgi?id=789605,
https://bugzilla.redhat.com/show_bug.cgi?id=866786,
https://bugzilla.redhat.com/show_bug.cgi?id=906734, and
https://bugzilla.kernel.org/show_bug.cgi?id=46171.

Thanks to Jussi Kivilinna for making the critical observation
that led to the solution.

Reported-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Tested-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Tested-by: Alessandro Lannocca <alessandro.lannocca@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |   87 +++++++++++----------------
 1 file changed, 35 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index b4b2e43..82167ac 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1377,74 +1377,57 @@ void rtl92cu_card_disable(struct ieee80211_hw *hw)
 
 void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
-	/* dummy routine needed for callback from rtl_op_configure_filter() */
-}
-
-/*========================================================================== */
-
-static void _rtl92cu_set_check_bssid(struct ieee80211_hw *hw,
-			      enum nl80211_iftype type)
-{
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
-	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-	u8 filterout_non_associated_bssid = false;
+	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
 
-	switch (type) {
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_STATION:
-		filterout_non_associated_bssid = true;
-		break;
-	case NL80211_IFTYPE_UNSPECIFIED:
-	case NL80211_IFTYPE_AP:
-	default:
-		break;
-	}
-	if (filterout_non_associated_bssid) {
+	if (rtlpriv->psc.rfpwr_state != ERFON)
+		return;
+
+	if (check_bssid) {
+		u8 tmp;
 		if (IS_NORMAL_CHIP(rtlhal->version)) {
-			switch (rtlphy->current_io_type) {
-			case IO_CMD_RESUME_DM_BY_SCAN:
-				reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
-				rtlpriv->cfg->ops->set_hw_reg(hw,
-						 HW_VAR_RCR, (u8 *)(&reg_rcr));
-				/* enable update TSF */
-				_rtl92cu_set_bcn_ctrl_reg(hw, 0, BIT(4));
-				break;
-			case IO_CMD_PAUSE_DM_BY_SCAN:
-				reg_rcr &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);
-				rtlpriv->cfg->ops->set_hw_reg(hw,
-						 HW_VAR_RCR, (u8 *)(&reg_rcr));
-				/* disable update TSF */
-				_rtl92cu_set_bcn_ctrl_reg(hw, BIT(4), 0);
-				break;
-			}
+			reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
+			tmp = BIT(4);
 		} else {
-			reg_rcr |= (RCR_CBSSID);
-			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
-						      (u8 *)(&reg_rcr));
-			_rtl92cu_set_bcn_ctrl_reg(hw, 0, (BIT(4)|BIT(5)));
+			reg_rcr |= RCR_CBSSID;
+			tmp = BIT(4) | BIT(5);
 		}
-	} else if (filterout_non_associated_bssid == false) {
+		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
+					      (u8 *) (&reg_rcr));
+		_rtl92cu_set_bcn_ctrl_reg(hw, 0, tmp);
+	} else {
+		u8 tmp;
 		if (IS_NORMAL_CHIP(rtlhal->version)) {
-			reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
-			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
-						      (u8 *)(&reg_rcr));
-			_rtl92cu_set_bcn_ctrl_reg(hw, BIT(4), 0);
+			reg_rcr &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);
+			tmp = BIT(4);
 		} else {
-			reg_rcr &= (~RCR_CBSSID);
-			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
-						      (u8 *)(&reg_rcr));
-			_rtl92cu_set_bcn_ctrl_reg(hw, (BIT(4)|BIT(5)), 0);
+			reg_rcr &= ~RCR_CBSSID;
+			tmp = BIT(4) | BIT(5);
 		}
+		reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
+		rtlpriv->cfg->ops->set_hw_reg(hw,
+					      HW_VAR_RCR, (u8 *) (&reg_rcr));
+		_rtl92cu_set_bcn_ctrl_reg(hw, tmp, 0);
 	}
 }
 
+/*========================================================================== */
+
 int rtl92cu_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
 	if (_rtl92cu_set_media_status(hw, type))
 		return -EOPNOTSUPP;
-	_rtl92cu_set_check_bssid(hw, type);
+
+	if (rtlpriv->mac80211.link_state == MAC80211_LINKED) {
+		if (type != NL80211_IFTYPE_AP)
+			rtl92cu_set_check_bssid(hw, true);
+	} else {
+		rtl92cu_set_check_bssid(hw, false);
+	}
+
 	return 0;
 }
 
-- 
1.7.10.4


