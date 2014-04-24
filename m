Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaDXJ3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:29:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46987 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbaDXIzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emil Goode <emilgoode@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 147/182] brcmsmac: fix deadlock on missing firmware
Date: Thu, 24 Apr 2014 09:51:12 +0100
Message-Id: <1398329507-5911-148-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Goode <emilgoode@gmail.com>

commit 8fc1e8c240aab968db658b2d8d079b4391207a36 upstream.

When brcm80211 firmware is not installed networking hangs.
A deadlock happens because we call ieee80211_unregister_hw()
from the .start callback of struct ieee80211_ops. When .start
is called we are under rtnl lock and ieee80211_unregister_hw()
tries to take it again.

Function call stack:

dev_change_flags()
	__dev_change_flags()
		__dev_open()
			ASSERT_RTNL() <-- Assert rtnl lock
			ops->ndo_open()

.ndo_open = ieee80211_open,

ieee80211_open()
	ieee80211_do_open()
		drv_start()
			local->ops->start()

.start = brcms_ops_start,

brcms_ops_start()
	brcms_remove()
		ieee80211_unregister_hw()
			rtnl_lock() <-- Here we deadlock

Introduced by:
commit 25b5632fb35ca61b8ae3eee235edcdc2883f7a5e
("brcmsmac: request firmware in .start() callback")

This patch fixes the bug by removing the call to brcms_remove()
and moves the brcms_request_fw() call to the top of the .start
callback to not initiate anything unless firmware is installed.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 3a65447..8e8543c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -426,6 +426,12 @@ static int brcms_ops_start(struct ieee80211_hw *hw)
 	bool blocked;
 	int err;
 
+	if (!wl->ucode.bcm43xx_bomminor) {
+		err = brcms_request_fw(wl, wl->wlc->hw->d11core);
+		if (err)
+			return -ENOENT;
+	}
+
 	ieee80211_wake_queues(hw);
 	spin_lock_bh(&wl->lock);
 	blocked = brcms_rfkill_set_hw_state(wl);
@@ -433,14 +439,6 @@ static int brcms_ops_start(struct ieee80211_hw *hw)
 	if (!blocked)
 		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
 
-	if (!wl->ucode.bcm43xx_bomminor) {
-		err = brcms_request_fw(wl, wl->wlc->hw->d11core);
-		if (err) {
-			brcms_remove(wl->wlc->hw->d11core);
-			return -ENOENT;
-		}
-	}
-
 	spin_lock_bh(&wl->lock);
 	/* avoid acknowledging frames before a non-monitor device is added */
 	wl->mute_tx = true;
-- 
1.9.1

