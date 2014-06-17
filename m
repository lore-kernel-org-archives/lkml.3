Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967099AbaFQVw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:52:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54822 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967033AbaFQVwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 088/212] md: avoid possible spinning md thread at shutdown.
Date: Tue, 17 Jun 2014 14:43:02 -0700
Message-Id: <1403041506-13646-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 0f62fb220aa4ebabe8547d3a9ce4a16d3c045f21 upstream.

If an md array with externally managed metadata (e.g. DDF or IMSM)
is in use, then we should not set safemode==2 at shutdown because:

1/ this is ineffective: user-space need to be involved in any 'safemode' handling,
2/ The safemode management code doesn't cope with safemode==2 on external metadata
   and md_check_recover enters an infinite loop.

Even at shutdown, an infinite-looping process can be problematic, so this
could cause shutdown to hang.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 369d919..ddb71d8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8496,7 +8496,8 @@ static int md_notify_reboot(struct notifier_block *this,
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
1.9.1

