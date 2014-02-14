Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaBNSD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:03:58 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:51538 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaBNSDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:03:55 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming_Li <chaoming_li@realsil.com.cn>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        lekensteyn@gmail.com
Subject: [PATCH 1/3] rtlwifi: avoid accessing RCR directly
Date: Fri, 14 Feb 2014 19:03:44 +0100
Message-Id: <1392401026-18417-2-git-send-email-lekensteyn@gmail.com>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1392401026-18417-1-git-send-email-lekensteyn@gmail.com>
References: <1392401026-18417-1-git-send-email-lekensteyn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtl*_set_check_bssid functions are mostly the same, but access the
RCR register in different ways. Use the get_hw_reg abstraction layer
(which reads rtlpci->receive_config for PCI devices and mac->rx_conf for
USB).

There is no functional change for cases where receive_config was
accessed directly. For rtl8192ce, there is still no change because
nothing modifies REG_RCR or receive_config. For rtl8192cu, it now also
applies changes to rx_conf from configure_filter, but that can be
considered a bug which is fixed later.

Signed-off-by: Peter Wu <lekensteyn@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 5 +++--
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c | 4 +++-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 4 +++-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c | 6 ++++--
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c | 5 +++--
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c | 5 +++--
 6 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
index e06971b..ce2226c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -1235,12 +1235,13 @@ static int _rtl88ee_set_media_status(struct ieee80211_hw *hw,
 void rtl88ee_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	u32 reg_rcr = rtlpci->receive_config;
+	u32 reg_rcr;
 
 	if (rtlpriv->psc.rfpwr_state != ERFON)
 		return;
 
+	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
+
 	if (check_bssid == true) {
 		reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index a82b30a..25e178c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1200,11 +1200,13 @@ static int _rtl92ce_set_media_status(struct ieee80211_hw *hw,
 void rtl92ce_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
+	u32 reg_rcr;
 
 	if (rtlpriv->psc.rfpwr_state != ERFON)
 		return;
 
+	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
+
 	if (check_bssid) {
 		reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 468bf73..49ad106 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1379,11 +1379,13 @@ void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
-	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
+	u32 reg_rcr;
 
 	if (rtlpriv->psc.rfpwr_state != ERFON)
 		return;
 
+	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
+
 	if (check_bssid) {
 		u8 tmp;
 		if (IS_NORMAL_CHIP(rtlhal->version)) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
index c4a7db9..c16aa6b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -1138,11 +1138,13 @@ static int _rtl92de_set_media_status(struct ieee80211_hw *hw,
 void rtl92de_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	u32 reg_rcr = rtlpci->receive_config;
+	u32 reg_rcr;
 
 	if (rtlpriv->psc.rfpwr_state != ERFON)
 		return;
+
+	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
+
 	if (check_bssid) {
 		reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index 4f46178..5aa39ef 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -1135,12 +1135,13 @@ void rtl92se_set_mac_addr(struct rtl_io *io, const u8 *addr)
 void rtl92se_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	u32 reg_rcr = rtlpci->receive_config;
+	u32 reg_rcr;
 
 	if (rtlpriv->psc.rfpwr_state != ERFON)
 		return;
 
+	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
+
 	if (check_bssid) {
 		reg_rcr |= (RCR_CBSSID);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
index c333dfd..4680816 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
@@ -1112,12 +1112,13 @@ static int _rtl8723ae_set_media_status(struct ieee80211_hw *hw,
 void rtl8723ae_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	u32 reg_rcr = rtlpci->receive_config;
+	u32 reg_rcr;
 
 	if (rtlpriv->psc.rfpwr_state != ERFON)
 		return;
 
+	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
+
 	if (check_bssid == true) {
 		reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
-- 
1.8.5.4

