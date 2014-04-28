Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaD1BbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42900 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752801AbaD1B3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Larry Finger" <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.717968490@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 38/94] rtlwifi: rtl8192se: Fix too long disable of IRQs
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 2610decdd0b3808ba20471a999835cfee5275f98 upstream.

In commit f78bccd79ba3cd9d9664981b501d57bdb81ab8a4 entitled "rtlwifi:
rtl8192ce: Fix too long disable of IRQs", Olivier Langlois
<olivier@trillion01.com> fixed a problem caused by an extra long disabling
of interrupts. This patch makes the same fix for rtl8192se.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Drop change to an error path that we don't have]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -924,7 +924,7 @@ int rtl92se_hw_init(struct ieee80211_hw
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u8 tmp_byte = 0;
-
+	unsigned long flags;
 	bool rtstatus = true;
 	u8 tmp_u1b;
 	int err = false;
@@ -936,6 +936,16 @@ int rtl92se_hw_init(struct ieee80211_hw
 
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
@@ -969,7 +979,8 @@ int rtl92se_hw_init(struct ieee80211_hw
 	/* 3. Initialize MAC/PHY Config by MACPHY_reg.txt */
 	if (rtl92s_phy_mac_config(hw) != true) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("MAC Config failed\n"));
-		return rtstatus;
+		err = rtstatus;
+		goto exit;
 	}
 
 	/* Make sure BB/RF write OK. We should prevent enter IPS. radio off. */
@@ -979,7 +990,8 @@ int rtl92se_hw_init(struct ieee80211_hw
 	/* 4. Initialize BB After MAC Config PHY_reg.txt, AGC_Tab.txt */
 	if (rtl92s_phy_bb_config(hw) != true) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, ("BB Config failed\n"));
-		return rtstatus;
+		err = rtstatus;
+		goto exit;
 	}
 
 	/* 5. Initiailze RF RAIO_A.txt RF RAIO_B.txt */
@@ -1015,7 +1027,8 @@ int rtl92se_hw_init(struct ieee80211_hw
 
 	if (rtl92s_phy_rf_config(hw) != true) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, ("RF Config failed\n"));
-		return rtstatus;
+		err = rtstatus;
+		goto exit;
 	}
 
 	/* After read predefined TXT, we must set BB/MAC/RF
@@ -1089,8 +1102,9 @@ int rtl92se_hw_init(struct ieee80211_hw
 
 	rtlpriv->cfg->ops->led_control(hw, LED_CTL_POWER_ON);
 	rtl92s_dm_init(hw);
+exit:
+	local_irq_restore(flags);
 	rtlpci->being_init_adapter = false;
-
 	return err;
 }
 

