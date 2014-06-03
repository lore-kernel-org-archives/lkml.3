Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbaFCLlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:41:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43477 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbaFCLlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 056/138] md: avoid possible spinning md thread at shutdown.
Date: Tue,  3 Jun 2014 12:38:22 +0100
Message-Id: <1401795584-22664-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c4b33642d125..78a848cc106e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8502,7 +8502,8 @@ static int md_notify_reboot(struct notifier_block *this,
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

