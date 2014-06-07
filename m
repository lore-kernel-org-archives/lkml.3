Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaFGBcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:32:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36104 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Larry Finger" <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.691610255@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 42/92] rtlwifi: rtl8192cu: Fix too long disable of IRQs
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit a53268be0cb9763f11da4f6fe3fb924cbe3a7d4a upstream.

In commit f78bccd79ba3cd9d9664981b501d57bdb81ab8a4 entitled "rtlwifi:
rtl8192ce: Fix too long disable of IRQs", Olivier Langlois
<olivier@trillion01.com> fixed a problem caused by an extra long disabling
of interrupts. This patch makes the same fix for rtl8192cu.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1158,6 +1158,17 @@ int rtl92cu_hw_init(struct ieee80211_hw
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
@@ -1171,7 +1182,7 @@ int rtl92cu_hw_init(struct ieee80211_hw
 			 ("Failed to download FW. Init HW without FW now..\n"));
 		err = 1;
 		rtlhal->fw_ready = false;
-		return err;
+		goto exit;
 	} else {
 		rtlhal->fw_ready = true;
 	}
@@ -1212,6 +1223,8 @@ int rtl92cu_hw_init(struct ieee80211_hw
 	_update_mac_setting(hw);
 	rtl92c_dm_init(hw);
 	_dump_registers(hw);
+exit:
+	local_irq_restore(flags);
 	return err;
 }
 

