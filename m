Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbaIZKSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:18:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbaIZJqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:21 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 093/142] md/raid1,raid10: always abort recover on write error.
Date: Fri, 26 Sep 2014 11:45:04 +0200
Message-Id: <8c74345afe07978d0b7efdaf561183bdd888a3e1.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2446dba03f9dabe0b477a126cbeb377854785b47 upstream.

Currently we don't abort recovery on a write error if the write error
to the recovering device was triggerd by normal IO (as opposed to
recovery IO).

This means that for one bitmap region, the recovery might write to the
recovering device for a few sectors, then not bother for subsequent
sectors (as it never writes to failed devices).  In this case
the bitmap bit will be cleared, but it really shouldn't.

The result is that if the recovering device fails and is then re-added
(after fixing whatever hardware problem triggerred the failure),
the second recovery won't redo the region it was in the middle of,
so some of the device will not be recovered properly.

If we abort the recovery, the region being processes will be cancelled
(bit not cleared) and the whole region will be retried.

As the bug can result in data corruption the patch is suitable for
-stable.  For kernels prior to 3.11 there is a conflict in raid10.c
which will require care.

Original-from: jiao hui <jiaohui@bwstor.com.cn>
Reported-and-tested-by: jiao hui <jiaohui@bwstor.com.cn>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/raid1.c  |  8 ++++----
 drivers/md/raid10.c | 11 +++++------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 66c4aee20c72..9b582c9444f2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1406,12 +1406,12 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
 		mddev->degraded++;
 		set_bit(Faulty, &rdev->flags);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
-		/*
-		 * if recovery is running, make sure it aborts.
-		 */
-		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	} else
 		set_bit(Faulty, &rdev->flags);
+	/*
+	 * if recovery is running, make sure it aborts.
+	 */
+	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	printk(KERN_ALERT
 	       "md/raid1:%s: Disk failure on %s, disabling device.\n"
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 308575d23550..867a8b67d5b9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1698,13 +1698,12 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 		return;
 	}
-	if (test_and_clear_bit(In_sync, &rdev->flags)) {
+	if (test_and_clear_bit(In_sync, &rdev->flags))
 		mddev->degraded++;
-			/*
-		 * if recovery is running, make sure it aborts.
-		 */
-		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-	}
+	/*
+	 * If recovery is running, make sure it aborts.
+	 */
+	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(Blocked, &rdev->flags);
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
-- 
2.1.0

