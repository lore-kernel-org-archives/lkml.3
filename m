Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614AbaEKTYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:24:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559AbaEKTYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:24:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.14 51/83] rtlwifi: rtl8192cu: Fix too long disable of IRQs
Date: Sun, 11 May 2014 21:19:52 +0200
Message-Id: <20140511191913.755594644@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit a53268be0cb9763f11da4f6fe3fb924cbe3a7d4a upstream.

In commit f78bccd79ba3cd9d9664981b501d57bdb81ab8a4 entitled "rtlwifi:
rtl8192ce: Fix too long disable of IRQs", Olivier Langlois
<olivier@trillion01.com> fixed a problem caused by an extra long disabling
of interrupts. This patch makes the same fix for rtl8192cu.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -985,6 +985,17 @@ int rtl92cu_hw_init(struct ieee80211_hw
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
@@ -997,7 +1008,7 @@ int rtl92cu_hw_init(struct ieee80211_hw
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "Failed to download FW. Init HW without FW now..\n");
 		err = 1;
-		return err;
+		goto exit;
 	}
 	rtlhal->last_hmeboxnum = 0; /* h2c */
 	_rtl92cu_phy_param_tab_init(hw);
@@ -1034,6 +1045,8 @@ int rtl92cu_hw_init(struct ieee80211_hw
 	_InitPABias(hw);
 	_update_mac_setting(hw);
 	rtl92c_dm_init(hw);
+exit:
+	local_irq_restore(flags);
 	return err;
 }
 


