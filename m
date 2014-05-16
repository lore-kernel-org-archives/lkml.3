Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbaEPMvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:51:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49580 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753881AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Larry Finger" <Larry.Finger@lwfinger.net>,
        "Chaoming Li" <chaoming_li@realsil.com.cn>,
        "Dmitry Semyonov" <linulin@gmail.com>
Date: Fri, 16 May 2014 13:47:21 +0100
Message-ID: <lsq.1400244441.849613969@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 31/34] rtl8192ce: Fix null dereference in watchdog
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

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
---
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -1228,11 +1228,14 @@ static void rtl92c_dm_refresh_rate_adapt
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

