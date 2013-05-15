Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3EOG7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 02:59:10 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40683 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3EOG7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 02:59:08 -0400
Message-ID: <5193322D.1080009@gmail.com>
Date: Wed, 15 May 2013 14:58:53 +0800
From: majianpeng <majianpeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>, peterz@infradead.org,
        mingo@redhat.com
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-f2fs <linux-f2fs-devel@lists.sourceforge.net>
Subject: [RFC][PATCH] f2fs: Avoid print false deadlock messages.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When mounted the f2fs, kernel will print the following messages:

[  105.533038] =============================================
[  105.533065] [ INFO: possible recursive locking detected ]
[  105.533088] 3.10.0-rc1+ #101 Not tainted
[  105.533105] ---------------------------------------------
[  105.533127] mount/5833 is trying to acquire lock:
[  105.533147]  (&sbi->fs_lock[i]){+.+...}, at: [<ffffffffa02017a6>] write_checkpoint+0xb6/0xaf0 [f2fs]
[  105.533204]
[  105.533204] but task is already holding lock:
[  105.533228]  (&sbi->fs_lock[i]){+.+...}, at: [<ffffffffa02017a6>] write_checkpoint+0xb6/0xaf0 [f2fs]
[  105.533278]
[  105.533278] other info that might help us debug this:
[  105.533305]  Possible unsafe locking scenario:
[  105.533305]
[  105.533329]        CPU0
[  105.533341]        ----
[  105.533353]   lock(&sbi->fs_lock[i]);
[  105.533373]   lock(&sbi->fs_lock[i]);
[  105.533394]
[  105.533394]  *** DEADLOCK ***
[  105.533394]
[  105.533419]  May be due to missing lock nesting notation
[  105.533419]
[  105.533447] 3 locks held by mount/5833:
[  105.533463]  #0:  (&type->s_umount_key#23/1){+.+.+.}, at: [<ffffffff81167b2f>] sget+0x2af/0x620
[  105.533519]  #1:  (&sbi->cp_mutex){+.+...}, at: [<ffffffffa0201745>] write_checkpoint+0x55/0xaf0 [f2fs]
[  105.533573]  #2:  (&sbi->fs_lock[i]){+.+...}, at: [<ffffffffa02017a6>] write_checkpoint+0xb6/0xaf0 [f2fs]
[  105.533626]
[  105.533626] stack backtrace:
[  105.533647] CPU: 0 PID: 5833 Comm: mount Not tainted 3.10.0-rc1+ #101
[  105.533673] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080015  11/09/2011
[  105.533714]  ffffffff82240690 ffff8800a6f759d0 ffffffff8168286a ffff8800a6f75ac0
[  105.533754]  ffffffff810a03e3 0000000000000002 ffff8800a1b7a3f0 0000000000000000
[  105.533794]  ffff8800a6f75b28 ffffffff812c376e ffff8800a1b7a3f0 0000000000000000
[  105.533833] Call Trace:
[  105.533848]  [<ffffffff8168286a>] dump_stack+0x19/0x1b
[  105.533872]  [<ffffffff810a03e3>] __lock_acquire+0x733/0x1ee0
[  105.533898]  [<ffffffff812c376e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  105.533926]  [<ffffffff8168c65c>] ? retint_restore_args+0xe/0xe
[  105.533951]  [<ffffffff810a2205>] lock_acquire+0x95/0x130
[  105.533977]  [<ffffffffa02017a6>] ? write_checkpoint+0xb6/0xaf0 [f2fs]
[  105.534011]  [<ffffffff816878da>] mutex_lock_nested+0x7a/0x3c0
[  105.534011]  [<ffffffffa02017a6>] ? write_checkpoint+0xb6/0xaf0 [f2fs]
[  105.534011]  [<ffffffffa02017a6>] ? write_checkpoint+0xb6/0xaf0 [f2fs]
[  105.534011]  [<ffffffffa02017a6>] write_checkpoint+0xb6/0xaf0 [f2fs]
[  105.534011]  [<ffffffff8109e35b>] ? mark_held_locks+0xbb/0x140
[  105.534011]  [<ffffffff81688907>] ?__mutex_unlock_slowpath+0xc7/0x170
[  105.534011]  [<ffffffffa020f43c>] recover_fsync_data+0x43c/0x4f0 [f2fs]
[  105.534011]  [<ffffffff812673bb>] ? security_d_instantiate+0x1b/0x30
[  105.534011]  [<ffffffffa0200795>] f2fs_fill_super+0x845/0x870 [f2fs]
[  105.534011]  [<ffffffff81168104>] mount_bdev+0x1b4/0x1f0
[  105.534011]  [<ffffffffa01fff50>] ? validate_superblock+0x170/0x170 [f2fs]
[  105.534011]  [<ffffffffa01fe745>] f2fs_mount+0x15/0x20 [f2fs]
[  105.534011]  [<ffffffff81168e03>] mount_fs+0x43/0x1b0
[  105.534011]  [<ffffffff8112d9d0>] ? __alloc_percpu+0x10/0x20
[  105.534011]  [<ffffffff81183be4>] vfs_kern_mount+0x74/0x120
[  105.534011]  [<ffffffff811862b9>] do_mount+0x259/0xa20
[  105.534011]  [<ffffffff8112890b>] ? strndup_user+0x5b/0x80
[  105.534011]  [<ffffffff81186b0e>] SyS_mount+0x8e/0xe0
[  105.534011]  [<ffffffff81694b02>] system_call_fastpath+0x16/0x1b

By adding some messages, i found this problem because the gcc
optimizing. For those codes:
>        for (i = 0; i < NR_GLOBAL_LOCKS; i++)
>                mutex_init(&sbi->fs_lock[i]);
The defination of mutex_init is:
> #define mutex_init(mutex)
>do {
>
>        static struct lock_class_key __key;
>
>                                                                      
>        __mutex_init((mutex), #mutex, &__key);
>
>} while (0)

Because the optimizing of gcc, there are only one __key rather than
NR_GLOBAL_LOCKS times.

Add there is other problems about lockname.Using 'for()' the lockname is
the same which is '&sbi->fs_lock[i]'.If it met problem about
mutex-operation, it can't find which one.

Although my patch can work,i think it's not best.Because if
NR_GLOBAL_LOCKS changed, we may leak to change this.

BTY, if who know how to avoid optimize, please tell me. Thanks!

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/f2fs/super.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 8555f7d..ce08b96 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -520,7 +520,6 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
     struct buffer_head *raw_super_buf;
     struct inode *root;
     long err = -EINVAL;
-    int i;
 
     /* allocate memory for f2fs-specific super block info */
     sbi = kzalloc(sizeof(struct f2fs_sb_info), GFP_KERNEL);
@@ -578,8 +577,16 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
     mutex_init(&sbi->gc_mutex);
     mutex_init(&sbi->writepages);
     mutex_init(&sbi->cp_mutex);
-    for (i = 0; i < NR_GLOBAL_LOCKS; i++)
-        mutex_init(&sbi->fs_lock[i]);
+
+    mutex_init(&sbi->fs_lock[0]);
+    mutex_init(&sbi->fs_lock[1]);
+    mutex_init(&sbi->fs_lock[2]);
+    mutex_init(&sbi->fs_lock[3]);
+    mutex_init(&sbi->fs_lock[4]);
+    mutex_init(&sbi->fs_lock[5]);
+    mutex_init(&sbi->fs_lock[6]);
+    mutex_init(&sbi->fs_lock[7]);
+
     mutex_init(&sbi->node_write);
     sbi->por_doing = 0;
     spin_lock_init(&sbi->stat_lock);
-- 
1.8.3.rc1.44.gb387c77

