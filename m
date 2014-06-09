Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947AbaFIJPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:15:17 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58387 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754815AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 040/146] md: avoid possible spinning md thread at shutdown.
Date: Mon,  9 Jun 2014 10:49:35 +0200
Message-Id: <c9378670f53de5174f73a7efc8eb88799e2473ee.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0f62fb220aa4ebabe8547d3a9ce4a16d3c045f21 upstream.

If an md array with externally managed metadata (e.g. DDF or IMSM)
is in use, then we should not set safemode==2 at shutdown because:

1/ this is ineffective: user-space need to be involved in any 'safemode' handling,
2/ The safemode management code doesn't cope with safemode==2 on external metadata
   and md_check_recover enters an infinite loop.

Even at shutdown, an infinite-looping process can be problematic, so this
could cause shutdown to hang.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 015bc455cf1c..0ed6daf3b1e4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8520,7 +8520,8 @@ static int md_notify_reboot(struct notifier_block *this,
 		if (mddev_trylock(mddev)) {
 			if (mddev->pers)
 				__md_stop_writes(mddev);
-			mddev->safemode = 2;
+			if (mddev->persistent)
+				mddev->safemode = 2;
 			mddev_unlock(mddev);
 		}
 		need_delay = 1;
-- 
1.9.3

