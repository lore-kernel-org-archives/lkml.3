Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbbAZGeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 01:34:46 -0500
Received: from www.osadl.org ([62.245.132.105]:45547 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbbAZGeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 01:34:44 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eliad Peller <eliad@wizery.com>, Arik Nemtsov <arik@wizery.com>,
        Kobi L <kobi.lev100@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH RFC] wlcore: match wait_for_completion_timeout return type
Date: Mon, 26 Jan 2015 07:26:12 +0100
Message-Id: <1422253572-19396-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return type of wait_for_completion_timeout is unsigned long not int, this
patch adds an appropriate return type and assignment.

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

The return type of wait_for_completion_timeout is unsigned long not
int. This patch adds a separate variable of proper type for handling
of the wait_for_completion_timeout.

The alternative would be to fold it into the if condition and not use
a separate variable like so:

	if (!pending) {
		if (!wait_for_completion_timeout( &compl,
				msecs_to_jiffies(WL1271_WAKEUP_TIMEOUT)) {
			wl1271_error("ELP wakeup timeout!");		    
			wl12xx_queue_recovery_work(wl);
			ret = -ETIMEDOUT;
			goto err;
		}
	}

not sure if this or the below solution is preferable.

Patch was compile tested only for x86_64_defconfig + CONFIG_WL_TI=y, 
CONFIG_WLCORE=m

Patch is against 3.19.0-rc5 -next-20150123

 drivers/net/wireless/ti/wlcore/ps.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index 4cd316e..d5f918a4 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -109,6 +109,7 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl)
 	DECLARE_COMPLETION_ONSTACK(compl);
 	unsigned long flags;
 	int ret;
+	unsigned long timeout;
 	unsigned long start_time = jiffies;
 	bool pending = false;
 
@@ -145,9 +146,9 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl)
 	}
 
 	if (!pending) {
-		ret = wait_for_completion_timeout(
+		timeout = wait_for_completion_timeout(
 			&compl, msecs_to_jiffies(WL1271_WAKEUP_TIMEOUT));
-		if (ret == 0) {
+		if (timeout == 0) {
 			wl1271_error("ELP wakeup timeout!");
 			wl12xx_queue_recovery_work(wl);
 			ret = -ETIMEDOUT;
-- 
1.7.10.4

