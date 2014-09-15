Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbaIOW3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:29:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51287 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbaIOWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 119/187] md/raid1,raid10: always abort recover on write error.
Date: Mon, 15 Sep 2014 15:08:49 -0700
Message-Id: <1410818997-9432-120-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid1.c  |  8 ++++----
 drivers/md/raid10.c | 11 +++++------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5166401..f4d5e52 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1500,12 +1500,12 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
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
index 06eeb99..496a46e 100644
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
1.9.1

