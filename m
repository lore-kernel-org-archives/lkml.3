Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbaLBTXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:23:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46709 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659AbaLBTXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:23:48 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 087/121] md: Always set RECOVERY_NEEDED when clearing RECOVERY_FROZEN
Date: Tue,  2 Dec 2014 11:19:26 -0800
Message-Id: <1417548000-1794-88-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 45eaf45dfa4850df16bc2e8e7903d89021137f40 upstream.

md_check_recovery will skip any recovery and also clear
MD_RECOVERY_NEEDED if MD_RECOVERY_FROZEN is set.
So when we clear _FROZEN, we must set _NEEDED and ensure that
md_check_recovery gets run.
Otherwise we could miss out on something that is needed.

In particular, this can make it impossible to remove a
failed device from an array is the  'recovery-needed' processing
didn't happen.
Suitable for stable kernels since 3.13.

Reported-and-tested-by: Joe Lawrence <joe.lawrence@stratus.com>
Fixes: 30b8feb730f9b9b3c5de02580897da03f59b6b16
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/md.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 09377ba..2ee29a7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5321,6 +5321,7 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 		printk("md: %s still in use.\n",mdname(mddev));
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			md_wakeup_thread(mddev->thread);
 		}
 		err = -EBUSY;
@@ -5335,6 +5336,8 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 		mddev->ro = 1;
 		set_disk_ro(mddev->gendisk, 1);
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 		err = 0;
 	}
@@ -5378,6 +5381,7 @@ static int do_md_stop(struct mddev * mddev, int mode,
 		mutex_unlock(&mddev->open_mutex);
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			md_wakeup_thread(mddev->thread);
 		}
 		return -EBUSY;
-- 
1.9.1

