Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbaK0IwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:52:08 -0500
Received: from mail.kernel.org ([198.145.19.201]:42983 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbaK0IuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:50:23 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Satoshi IWAMOTO <satoshi.iwamoto@nifty.ne.jp>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 87/91] rtl8192ce: Fix null dereference in watchdog
Date: Thu, 27 Nov 2014 16:43:10 +0800
Message-Id: <1417077794-9299-87-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


Dmitry Semyonov reported that after upgrading from 3.2.54 to
3.2.57 the rtl8192ce driver will crash when its interface is brought
up.  The oops message shows:

[ 1833.611397] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[ 1833.611455] IP: [<ffffffffa0410c6a>] rtl92ce_update_hal_rate_tbl+0x29/0x4db [rtl8192ce]
...
[ 1833.613326] Call Trace:
[ 1833.613346]  [<ffffffffa02ad9c6>] ? rtl92c_dm_watchdog+0xd0b/0xec9 [rtl8192c_common]
[ 1833.613391]  [<ffffffff8105b5cf>] ? process_one_work+0x161/0x269
[ 1833.613425]  [<ffffffff8105c598>] ? worker_thread+0xc2/0x145
[ 1833.613458]  [<ffffffff8105c4d6>] ? manage_workers.isra.25+0x15b/0x15b
[ 1833.613496]  [<ffffffff8105f6d9>] ? kthread+0x76/0x7e
[ 1833.613527]  [<ffffffff81356b74>] ? kernel_thread_helper+0x4/0x10
[ 1833.613563]  [<ffffffff8105f663>] ? kthread_worker_fn+0x139/0x139
[ 1833.613598]  [<ffffffff81356b70>] ? gs_change+0x13/0x13

Disassembly of rtl92ce_update_hal_rate_tbl() shows that the 'sta'
parameter was null.  None of the changes to the rtlwifi family between
3.2.54 and 3.2.57 seem to directly cause this, and reverting commit
f78bccd79ba3 ('rtlwifi: rtl8192ce: Fix too long disable of IRQs')
doesn't fix it.

rtl92c_dm_watchdog() calls rtl92ce_update_hal_rate_tbl() via
rtl92c_dm_refresh_rate_adaptive_mask(), which does not appear in the
call trace as it was inlined.  That function has been completely
removed upstream which may explain why this crash wasn't seen there.

I'm not sure that it is sensible to completely remove
rtl92c_dm_refresh_rate_adaptive_mask() without making other
compensating changes elsewhere, so try to work around this for 3.2 by
checking for a null pointer in rtl92c_dm_refresh_rate_adaptive_mask()
and then skipping the call to rtl92ce_update_hal_rate_tbl().

References: https://bugs.debian.org/745137
References: https://bugs.debian.org/745462
Reported-by: Dmitry Semyonov <linulin@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Satoshi IWAMOTO <satoshi.iwamoto@nifty.ne.jp>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index 1208b75..513baa0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -1210,11 +1210,14 @@ static void rtl92c_dm_refresh_rate_adaptive_mask(struct ieee80211_hw *hw)
 			if (rtlhal->interface == INTF_PCI) {
 				rcu_read_lock();
 				sta = ieee80211_find_sta(mac->vif, mac->bssid);
+				if (!sta)
+					goto out_unlock;
 			}
 			rtlpriv->cfg->ops->update_rate_tbl(hw, sta,
 					p_ra->ratr_state);
 
 			p_ra->pre_ratr_state = p_ra->ratr_state;
+		out_unlock:
 			if (rtlhal->interface == INTF_PCI)
 				rcu_read_unlock();
 		}
-- 
1.9.1

