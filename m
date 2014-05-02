Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaEBPo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:44:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44084 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbaEBPoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:44:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 036/151] rtlwifi: rtl8188ee: Fix too long disable of IRQs
Date: Fri,  2 May 2014 08:37:04 -0700
Message-Id: <1399045139-4531-37-git-send-email-kamal@canonical.com>
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

commit 6b6392715856d563719991e9ce95e773491a8983 upstream.

In commit f78bccd79ba3cd9d9664981b501d57bdb81ab8a4 entitled "rtlwifi:
rtl8192ce: Fix too long disable of IRQs", Olivier Langlois
<olivier@trillion01.com> fixed a problem caused by an extra long disabling
of interrupts. This patch makes the same fix for rtl8188ee.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
index e06971b..f923d8c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -1025,9 +1025,20 @@ int rtl88ee_hw_init(struct ieee80211_hw *hw)
 	bool rtstatus = true;
 	int err = 0;
 	u8 tmp_u1b, u1byte;
+	unsigned long flags;
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Rtl8188EE hw init\n");
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
 
 	tmp_u1b = rtl_read_byte(rtlpriv, REG_SYS_CLKR+1);
@@ -1043,7 +1054,7 @@ int rtl88ee_hw_init(struct ieee80211_hw *hw)
 	if (rtstatus != true) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Init MAC failed\n");
 		err = 1;
-		return err;
+		goto exit;
 	}
 
 	err = rtl88e_download_fw(hw, false);
@@ -1051,8 +1062,7 @@ int rtl88ee_hw_init(struct ieee80211_hw *hw)
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "Failed to download FW. Init HW without FW now..\n");
 		err = 1;
-		rtlhal->fw_ready = false;
-		return err;
+		goto exit;
 	} else {
 		rtlhal->fw_ready = true;
 	}
@@ -1135,10 +1145,12 @@ int rtl88ee_hw_init(struct ieee80211_hw *hw)
 	}
 	rtl_write_byte(rtlpriv, REG_NAV_CTRL+2,  ((30000+127)/128));
 	rtl88e_dm_init(hw);
+exit:
+	local_irq_restore(flags);
 	rtlpriv->rtlhal.being_init_adapter = false;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "end of Rtl8188EE hw init %x\n",
 		 err);
-	return 0;
+	return err;
 }
 
 static enum version_8188e _rtl88ee_read_chip_version(struct ieee80211_hw *hw)
-- 
1.9.1

