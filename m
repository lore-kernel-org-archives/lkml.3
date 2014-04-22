Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbaDVUZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:25:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36767 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296AbaDVUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:25:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 050/133] rtlwifi: rtl8723ae: Fix too long disable of IRQs
Date: Tue, 22 Apr 2014 13:13:08 -0700
Message-Id: <1398197671-12786-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit bfc1010c418a22cbebd8b1bd1e75dad6a527a609 upstream.

In commit f78bccd79ba3cd9d9664981b501d57bdb81ab8a4 entitled "rtlwifi:
rtl8192ce: Fix too long disable of IRQs", Olivier Langlois
<olivier@trillion01.com> fixed a problem caused by an extra long disabling
of interrupts. This patch makes the same fix for rtl8723ae.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
index 0a8c038..f0532c6 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
@@ -846,14 +846,25 @@ int rtl8723ae_hw_init(struct ieee80211_hw *hw)
 	bool rtstatus = true;
 	int err;
 	u8 tmp_u1b;
+	unsigned long flags;
 
 	rtlpriv->rtlhal.being_init_adapter = true;
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
 	rtstatus = _rtl8712e_init_mac(hw);
 	if (rtstatus != true) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Init MAC failed\n");
 		err = 1;
-		return err;
+		goto exit;
 	}
 
 	err = rtl8723ae_download_fw(hw);
@@ -861,8 +872,7 @@ int rtl8723ae_hw_init(struct ieee80211_hw *hw)
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "Failed to download FW. Init HW without FW now..\n");
 		err = 1;
-		rtlhal->fw_ready = false;
-		return err;
+		goto exit;
 	} else {
 		rtlhal->fw_ready = true;
 	}
@@ -937,6 +947,8 @@ int rtl8723ae_hw_init(struct ieee80211_hw *hw)
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "under 1.5V\n");
 	}
 	rtl8723ae_dm_init(hw);
+exit:
+	local_irq_restore(flags);
 	rtlpriv->rtlhal.being_init_adapter = false;
 	return err;
 }
-- 
1.9.1

