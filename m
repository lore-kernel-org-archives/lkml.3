Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3IJFAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 01:00:54 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52531 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3IJFAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 01:00:52 -0400
MIME-Version: 1.0
Date: Tue, 10 Sep 2013 13:00:52 +0800
Message-ID: <CAPoh-nY8wwu-2yYRbKycPX2gEUofQu6y29TOYhOm83C2au6ZQQ@mail.gmail.com>
Subject: Subject: [PATCH] md: avoid deadlock when raid5 array has unack
 badblocks during md_stop_writes.
From: y b <ycbzzjlby@gmail.com>
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When raid5 hit a fresh badblock, this badblock will flagged as unack
badblock until md_update_sb is called.
But md_stop/reboot/md_set_readonly will avoid raid5d call md_update_sb
in md_check_recovery, the badblock will always be unack, so raid5d
thread enter a infinite loop and never can unregister sync_thread
that cause deadlock.

To solve this, before md_stop_writes call md_unregister_thread, set
MD_STOPPING_WRITES on mddev->flags. In raid5.c analyse_stripe judge
MD_STOPPING_WRITES bit on mddev->flags, if setted don't block rdev
to wait md_update_sb. so raid5d thread can be finished.
Signed-off-by: Bian Yu <bianyu@kedacom.com>
---
 drivers/md/md.c    |    2 ++
 drivers/md/md.h    |    3 +++
 drivers/md/raid5.c |    3 ++-
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index adf4d7e..54ef71f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5278,6 +5278,7 @@ static void md_clean(struct mddev *mddev)
 static void __md_stop_writes(struct mddev *mddev)
 {
     set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+    set_bit(MD_STOPPING_WRITES, &mddev->flags);
     if (mddev->sync_thread) {
         set_bit(MD_RECOVERY_INTR, &mddev->recovery);
         md_reap_sync_thread(mddev);
@@ -5294,6 +5295,7 @@ static void __md_stop_writes(struct mddev *mddev)
         mddev->in_sync = 1;
         md_update_sb(mddev, 1);
     }
+    clear_bit(MD_STOPPING_WRITES, &mddev->flags);
 }

 void md_stop_writes(struct mddev *mddev)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 608050c..c998b82 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -214,6 +214,9 @@ struct mddev {
 #define MD_STILL_CLOSED    4    /* If set, then array has not been opened since
                  * md_ioctl checked on it.
                  */
+#define MD_STOPPING_WRITES 5     /* If set, raid5 shouldn't set unacknowledged
+                  * badblock blocked in analyse_stripe to avoid infinite loop
+                  */

     int                suspended;
     atomic_t            active_io;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f9972e2..ff1aecf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3446,7 +3446,8 @@ static void analyse_stripe(struct stripe_head
*sh, struct stripe_head_state *s)
         if (rdev) {
             is_bad = is_badblock(rdev, sh->sector, STRIPE_SECTORS,
                          &first_bad, &bad_sectors);
-            if (s->blocked_rdev == NULL
+            if (!test_bit(MD_STOPPING_WRITES, &conf->mddev->flags)
+                && s->blocked_rdev == NULL
                 && (test_bit(Blocked, &rdev->flags)
                 || is_bad < 0)) {
                 if (is_bad < 0)
-- 
1.7.1
