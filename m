Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab3IKQfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:35:42 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:48851 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3IKQfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:35:39 -0400
From: ycbzzjlby@gmail.com
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bian Yu <bianyu@kedacom.com>
Subject: [PATCH v2] md/raid5: avoid deadlock when raid5 array has unack badblocks during md_stop_writes.
Date: Mon,  2 Sep 2013 01:09:55 -0400
Message-Id: <1378098595-11536-1-git-send-email-ycbzzjlby@gmail.com>
X-Mailer: git-send-email 1.7.1
Content-Type: text/plain; charset="utf-8"
X-Antivirus: avast! (VPS 130911-0, 2013/09/11), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bian Yu <bianyu@kedacom.com>

When raid5 hit a fresh badblock, this badblock will flagged as unack
badblock until md_update_sb is called.
But md_stop/reboot/md_set_readonly will avoid raid5d call md_update_sb
in md_check_recovery, the badblock will always be unack, so raid5d
thread enter a infinite loop and never can unregister sync_thread
that cause deadlock.

To solve this, before md_stop_writes call md_unregister_thread, set
MD_STOPPING_WRITES on mddev->flags. In raid5.c analyse_stripe judge
MD_STOPPING_WRITES bit on mddev->flags, if setted don't block rdev
to wait md_update_sb. so raid5d thread can be stopped.

I can reproduce it by using follow way:
When raid5 array is recovering and hit a fresh badblock, then shutdown array at once.

[  480.850203]       Not tainted 3.11.0-next-20130906+ #4
[  480.852344] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.854380]  [<ffffffff8153b324>] md_do_sync+0x7e4/0xe60
[  480.854386]  [<ffffffff81747fcb>] ? _raw_spin_unlock_irq+0x2b/0x40
[  480.854395]  [<ffffffff81536fa0>] ? md_unregister_thread+0x90/0x90
[  480.854400]  [<ffffffff810a716d>] ? trace_hardirqs_on+0xd/0x10
[  480.854405]  [<ffffffff815370bf>] md_thread+0x11f/0x170
[  480.854410]  [<ffffffff81536fa0>] ? md_unregister_thread+0x90/0x90
[  480.854415]  [<ffffffff8106d956>] kthread+0xd6/0xe0
[  480.854423]  [<ffffffff8106d880>] ? __init_kthread_worker+0x70/0x70
[  480.854428]  [<ffffffff8174ff2c>] ret_from_fork+0x7c/0xb0
[  480.854432]  [<ffffffff8106d880>] ? __init_kthread_worker+0x70/0x70
[  480.854435] no locks held by md0_resync/3246.
[  480.854437] INFO: task mdadm:3257 blocked for more than 120 seconds.
[  480.854438]       Not tainted 3.11.0-next-20130906+ #4
[  480.854439] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.854442] mdadm           D 0000000000000000  5024  3257   3209 0x00000080
[  480.854445]  ffff880138c37b18 0000000000000046 00000000ffffffff ffff880037d3b120
[  480.854447]  ffff88013a038720 ffff88013a038000 0000000000013500 ffff880138c37fd8
[  480.854449]  ffff880138c36010 0000000000013500 0000000000013500 ffff880138c37fd8
[  480.854449] Call Trace:
[  480.854452]  [<ffffffff81745fa4>] schedule+0x24/0x70
[  480.854453]  [<ffffffff81742725>] schedule_timeout+0x175/0x200
[  480.854455]  [<ffffffff810a6d30>] ? mark_held_locks+0x80/0x130
[  480.854457]  [<ffffffff81747fcb>] ? _raw_spin_unlock_irq+0x2b/0x40
[  480.854459]  [<ffffffff810a709d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[  480.854461]  [<ffffffff810a716d>] ? trace_hardirqs_on+0xd/0x10
[  480.854463]  [<ffffffff81746600>] wait_for_completion+0xa0/0x110
[  480.854465]  [<ffffffff8107d160>] ? try_to_wake_up+0x300/0x300
[  480.854467]  [<ffffffff8106ddbc>] kthread_stop+0x4c/0xe0
[  480.854468]  [<ffffffff81536f5e>] md_unregister_thread+0x4e/0x90
[  480.854470]  [<ffffffff8153965d>] md_reap_sync_thread+0x1d/0x140
[  480.854472]  [<ffffffff815397ab>] __md_stop_writes+0x2b/0x80
[  480.854473]  [<ffffffff8153c911>] do_md_stop+0x91/0x4d0
[  480.854475]  [<ffffffff8153e8a7>] ? md_ioctl+0xf7/0x15c0
[  480.854477]  [<ffffffff810a716d>] ? trace_hardirqs_on+0xd/0x10
[  480.854479]  [<ffffffff8153f6a9>] md_ioctl+0xef9/0x15c0
[  480.854481]  [<ffffffff8113145d>] ? handle_mm_fault+0x17d/0x920

Signed-off-by: Bian Yu <bianyu@kedacom.com>
---
 drivers/md/md.c    |    2 ++
 drivers/md/md.h    |    4 ++++
 drivers/md/raid5.c |    3 ++-
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index adf4d7e..54ef71f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5278,6 +5278,7 @@ static void md_clean(struct mddev *mddev)
 static void __md_stop_writes(struct mddev *mddev)
 {
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	set_bit(MD_STOPPING_WRITES, &mddev->flags);
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		md_reap_sync_thread(mddev);
@@ -5294,6 +5295,7 @@ static void __md_stop_writes(struct mddev *mddev)
 		mddev->in_sync = 1;
 		md_update_sb(mddev, 1);
 	}
+	clear_bit(MD_STOPPING_WRITES, &mddev->flags);
 }
 
 void md_stop_writes(struct mddev *mddev)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 608050c..a24ae1d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -214,6 +214,10 @@ struct mddev {
 #define MD_STILL_CLOSED	4	/* If set, then array has not been opened since
 				 * md_ioctl checked on it.
 				 */
+#define MD_STOPPING_WRITES 5	/* If set, raid5 shouldn't set unacknowledged
+				 * badblock blocked in analyse_stripe to avoid
+				 * infinite loop.
+				 */
 
 	int				suspended;
 	atomic_t			active_io;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f9972e2..ff1aecf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3446,7 +3446,8 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		if (rdev) {
 			is_bad = is_badblock(rdev, sh->sector, STRIPE_SECTORS,
 					     &first_bad, &bad_sectors);
-			if (s->blocked_rdev == NULL
+			if (!test_bit(MD_STOPPING_WRITES, &conf->mddev->flags)
+			    && s->blocked_rdev == NULL
 			    && (test_bit(Blocked, &rdev->flags)
 				|| is_bad < 0)) {
 				if (is_bad < 0)
-- 
1.7.1

