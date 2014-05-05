Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595AbaEEMzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:55:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:40996 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932270AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Emil Goode <emilgoode@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 02/50] brcmsmac: fix deadlock on missing firmware
Date: Mon,  5 May 2014 14:42:44 +0200
Message-Id: <de0b7b0dd1b625c8b4730869ae3d651e9189617c.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emil Goode <emilgoode@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index edc5d105ff98..03a56dfba2db 100644
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
1.9.2

