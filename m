Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338AbaEMKK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:10:56 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933312AbaEMKKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:10:52 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 162/182] rtlwifi: rtl8192cu: Fix too long disable of IRQs
Date: Tue, 13 May 2014 11:28:34 +0200
Message-Id: <f9993c6d5b70ab5908b6d8ce55db2725d06f6359.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a53268be0cb9763f11da4f6fe3fb924cbe3a7d4a upstream.

In commit f78bccd79ba3cd9d9664981b501d57bdb81ab8a4 entitled "rtlwifi:
rtl8192ce: Fix too long disable of IRQs", Olivier Langlois
<olivier@trillion01.com> fixed a problem caused by an extra long disabling
of interrupts. This patch makes the same fix for rtl8192cu.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 189ba124a8c6..324aa581938e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -985,6 +985,17 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	int err = 0;
 	static bool iqk_initialized;
+	unsigned long flags;
+
+	/* As this function can take a very long time (up to 350 ms)
+	 * and can be called with irqs disabled, reenable the irqs
+	 * to let the other devices continue being serviced.
+	 *
+	 * It is safe doing so since our own interrupts will only be enabled
+	 * in a subsequent step.
+	 */
+	local_save_flags(flags);
+	local_irq_enable();
 
 	rtlhal->hw_type = HARDWARE_TYPE_RTL8192CU;
 	err = _rtl92cu_init_mac(hw);
@@ -997,7 +1008,7 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "Failed to download FW. Init HW without FW now..\n");
 		err = 1;
-		return err;
+		goto exit;
 	}
 	rtlhal->last_hmeboxnum = 0; /* h2c */
 	_rtl92cu_phy_param_tab_init(hw);
@@ -1034,6 +1045,8 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 	_InitPABias(hw);
 	_update_mac_setting(hw);
 	rtl92c_dm_init(hw);
+exit:
+	local_irq_restore(flags);
 	return err;
 }
 
-- 
1.9.3

