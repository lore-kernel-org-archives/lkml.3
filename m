Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaEBPoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:44:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44104 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbaEBPoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:44:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 035/151] rtlwifi: rtl8192se: Fix too long disable of IRQs
Date: Fri,  2 May 2014 08:37:03 -0700
Message-Id: <1399045139-4531-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 2610decdd0b3808ba20471a999835cfee5275f98 upstream.

In commit f78bccd79ba3cd9d9664981b501d57bdb81ab8a4 entitled "rtlwifi:
rtl8192ce: Fix too long disable of IRQs", Olivier Langlois
<olivier@trillion01.com> fixed a problem caused by an extra long disabling
of interrupts. This patch makes the same fix for rtl8192se.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index 4f46178..c471400 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -955,7 +955,7 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u8 tmp_byte = 0;
-
+	unsigned long flags;
 	bool rtstatus = true;
 	u8 tmp_u1b;
 	int err = false;
@@ -967,6 +967,16 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 
 	rtlpci->being_init_adapter = true;
 
+	/* As this function can take a very long time (up to 350 ms)
+	 * and can be called with irqs disabled, reenable the irqs
+	 * to let the other devices continue being serviced.
+	 *
+	 * It is safe doing so since our own interrupts will only be enabled
+	 * in a subsequent step.
+	 */
+	local_save_flags(flags);
+	local_irq_enable();
+
 	rtlpriv->intf_ops->disable_aspm(hw);
 
 	/* 1. MAC Initialize */
@@ -984,7 +994,8 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "Failed to download FW. Init HW without FW now... "
 			 "Please copy FW into /lib/firmware/rtlwifi\n");
-		return 1;
+		err = 1;
+		goto exit;
 	}
 
 	/* After FW download, we have to reset MAC register */
@@ -997,7 +1008,8 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 	/* 3. Initialize MAC/PHY Config by MACPHY_reg.txt */
 	if (!rtl92s_phy_mac_config(hw)) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "MAC Config failed\n");
-		return rtstatus;
+		err = rtstatus;
+		goto exit;
 	}
 
 	/* because last function modify RCR, so we update
@@ -1016,7 +1028,8 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 	/* 4. Initialize BB After MAC Config PHY_reg.txt, AGC_Tab.txt */
 	if (!rtl92s_phy_bb_config(hw)) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "BB Config failed\n");
-		return rtstatus;
+		err = rtstatus;
+		goto exit;
 	}
 
 	/* 5. Initiailze RF RAIO_A.txt RF RAIO_B.txt */
@@ -1033,7 +1046,8 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 
 	if (!rtl92s_phy_rf_config(hw)) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "RF Config failed\n");
-		return rtstatus;
+		err = rtstatus;
+		goto exit;
 	}
 
 	/* After read predefined TXT, we must set BB/MAC/RF
@@ -1122,8 +1136,9 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 
 	rtlpriv->cfg->ops->led_control(hw, LED_CTL_POWER_ON);
 	rtl92s_dm_init(hw);
+exit:
+	local_irq_restore(flags);
 	rtlpci->being_init_adapter = false;
-
 	return err;
 }
 
-- 
1.9.1

