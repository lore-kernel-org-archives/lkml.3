Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbaCKTNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:13:14 -0400
Received: from vm1.sequanux.org ([188.165.36.56]:53499 "EHLO vm1.sequanux.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaCKTNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:13:10 -0400
From: Simon Guinot <simon.guinot@sequanux.org>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?R=C3=A9mi=20R=C3=A9rolle?= <remi.rerolle@seagate.com>,
        Simon Guinot <simon.guinot@sequanux.org>
Subject: [PATCH 2/2] md: fix deadlock while suspending RAID array
Date: Tue, 11 Mar 2014 20:12:10 +0100
Message-Id: <1394565130-24233-3-git-send-email-simon.guinot@sequanux.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394565130-24233-1-git-send-email-simon.guinot@sequanux.org>
References: <1394565130-24233-1-git-send-email-simon.guinot@sequanux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes a deadlock happens while migrating a RAID array level, using
the mdadm --grow command. In the following example, an ext4 filesystem
is installed over a RAID1 array and mdadm is used to transform this
array into a RAID5 one. Here are the observed backtraces for the locked
tasks:

jbd2/dm-0-8     D c0478384     0  9100      2 0x00000000
[<c0478384>] (__schedule+0x154/0x320) from [<c0157c68>] (jbd2_journal_commit_transaction+0x1b0/0x132c)
[<c0157c68>] (jbd2_journal_commit_transaction+0x1b0/0x132c) from [<c015b5f4>] (kjournald2+0x9c/0x200)
[<c015b5f4>] (kjournald2+0x9c/0x200) from [<c003558c>] (kthread+0xa4/0xb0)
[<c003558c>] (kthread+0xa4/0xb0) from [<c000df18>] (ret_from_fork+0x14/0x3c)
ext4lazyinit    D c0478384     0  9113      2 0x00000000
[<c0478384>] (__schedule+0x154/0x320) from [<c0364ed0>] (md_write_start+0xd8/0x194)
[<c0364ed0>] (md_write_start+0xd8/0x194) from [<bf004c80>] (make_request+0x3c/0xc5c [raid1])
[<bf004c80>] (make_request+0x3c/0xc5c [raid1]) from [<c0363784>] (md_make_request+0xe4/0x1f8)
[<c0363784>] (md_make_request+0xe4/0x1f8) from [<c025f544>] (generic_make_request+0xa8/0xc8)
[<c025f544>] (generic_make_request+0xa8/0xc8) from [<c025f5e4>] (submit_bio+0x80/0x12c)
[<c025f5e4>] (submit_bio+0x80/0x12c) from [<c0265648>] (__blkdev_issue_zeroout+0x134/0x1a0)
[<c0265648>] (__blkdev_issue_zeroout+0x134/0x1a0) from [<c0265748>] (blkdev_issue_zeroout+0x94/0xa0)
[<c0265748>] (blkdev_issue_zeroout+0x94/0xa0) from [<c011a3e8>] (ext4_init_inode_table+0x178/0x2cc)
[<c011a3e8>] (ext4_init_inode_table+0x178/0x2cc) from [<c0129fac>] (ext4_lazyinit_thread+0xe8/0x288)
[<c0129fac>] (ext4_lazyinit_thread+0xe8/0x288) from [<c003558c>] (kthread+0xa4/0xb0)
[<c003558c>] (kthread+0xa4/0xb0) from [<c000df18>] (ret_from_fork+0x14/0x3c)
mdadm           D c0478384     0 10163   9465 0x00000000
[<c0478384>] (__schedule+0x154/0x320) from [<c0362edc>] (mddev_suspend+0x68/0xc0)
[<c0362edc>] (mddev_suspend+0x68/0xc0) from [<c0363080>] (level_store+0x14c/0x59c)
[<c0363080>] (level_store+0x14c/0x59c) from [<c03665ac>] (md_attr_store+0xac/0xdc)
[<c03665ac>] (md_attr_store+0xac/0xdc) from [<c00eee38>] (sysfs_write_file+0x100/0x168)
[<c00eee38>] (sysfs_write_file+0x100/0x168) from [<c0098598>] (vfs_write+0xb8/0x184)
[<c0098598>] (vfs_write+0xb8/0x184) from [<c009893c>] (SyS_write+0x40/0x6c)
[<c009893c>] (SyS_write+0x40/0x6c) from [<c000de80>] (ret_fast_syscall+0x0/0x30)

This deadlock can be reproduced on different architecture (ARM and x86)
and also with different Linux kernel versions: 3.14-rc and 3.10 stable.

The problem comes from the mddev_suspend() function which don't allow
mddev->thread to complete the pending I/Os (mddev->active_io) if any:

1. mdadm holds mddev->reconfig_mutex before running mddev_suspend().
   If a write I/O is submitted while mdadm holds the mutex and when the
   RAID array is still not suspended, then mddev->thread is not able to
   complete the I/O: The superblock can't be updated because
   mddev->reconfig_mutex is not available. Note that having a write I/O
   over a "not suspended yet" RAID array is not a marginal scenario:
   To load a new RAID personality, level_store() calls request_module()
   which is allowed to schedule. Moreover on a SMP or a preemptible
   kernel, the odds are probably even greater.

2. In a same way, mddev_suspend() sets the mddev->suspended flag. Again
   this may prevent mddev->thread to complete some pending I/Os when
   a superblock update is needed: md_check_recovery, used by the RAID
   threads, does nothing but exits when the mddev->suspended flag is
   set. As a consequence the superblock is never updated.

This patch solves this issues by ensuring there is no pending active
I/Os before suspending effectively a RAID array.

Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
Tested-by: Rémi Rérolle <remi.rerolle@seagate.com>
---
 drivers/md/md.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fb4296adae80..ea3e95d1972b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -375,9 +375,22 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
 void mddev_suspend(struct mddev *mddev)
 {
 	BUG_ON(mddev->suspended);
-	mddev->suspended = 1;
-	synchronize_rcu();
-	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
+
+	for (;;) {
+		mddev->suspended = 1;
+		synchronize_rcu();
+		if (atomic_read(&mddev->active_io) == 0)
+			break;
+		mddev->suspended = 0;
+		synchronize_rcu();
+		/*
+		 * Note that mddev_unlock is also used to wake up mddev->thread.
+		 * This allows to complete the pending mddev->active_io.
+		 */
+		mddev_unlock(mddev);
+		wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
+		mddev_lock_nointr(mddev);
+	}
 	mddev->pers->quiesce(mddev, 1);
 
 	del_timer_sync(&mddev->safemode_timer);
-- 
1.8.5.3

