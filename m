Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3FZIpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:45:33 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:47358 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3FZIpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:45:31 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: [PATCH] Optimize wait_sb_inodes()
Date: Wed, 26 Jun 2013 17:45:23 +0900
Message-ID: <87ehbpntuk.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On the following stress, sync(2) became top of cpu load.

	fsstress -s 1 -n 50000 -p 3 -d `pwd`

After profile by perf, cpu load was lock contention of inode_sb_list_lock.

sync(2) is data integrity operation, so it has to make sure all dirty
data was written before sync(2) point. The bdi flusher flushes current
dirty data and wait those. But, if there is in-flight I/O before
sync_inodes_sb(), sync_inodes_sb() can be done before prior in-flight I/O.

So, wait_sb_inodes() is walking the all inodes on sb to make sure
in-flight I/O was done too. When it is walking inodes,
inode_sb_list_lock is contending with other operations like
create(2). This is the cause of cpu load.

On another view, wait_sb_inodes() would (arguably) be necessary for
legacy FSes. But, for example, if data=journal on ext*, wait_sb_inodes()
would be more than useless, because ext* can be done it by own
transaction list (and more efficient way).

Likewise, on tux3, the state is same with data=journal.

Also, even if data=ordered, ext* might be able to check in-flight I/O by
ordered data list (with some new additional check, I'm not sure).


So, this patch adds the sb->s_op->wait_inodes() handler to replace
wait_sb_inodes(). With this, FSes can optimize it by using own
internal knowledge.

[Alternative idea to optimize this, push down wait_sb_inodes() into
->sync_fs() handler on all FSes. Or if someone fixes this with another
idea, I'm happy enough.]


The following is profile of result on tux3 (->wait_inodes() handler is
noop function).

Thanks.

-  13.11%  fsstress  [kernel.kallsyms]  [k] sync_inodes_sb                     
   - sync_inodes_sb
      - 99.97% sync_inodes_one_sb
           iterate_supers
           sys_sync
           system_call
           sync
-   9.39%  fsstress  [kernel.kallsyms]  [k] _raw_spin_lock
   - _raw_spin_lock
      + 62.72% sync_inodes_sb
      + 7.46% _atomic_dec_and_lock
      + 6.15% inode_add_lru
      + 4.43% map_region
      + 3.07% __find_get_buffer
      + 2.71% sync_inodes_one_sb
      + 1.77% tux3_set_buffer_dirty_list
      + 1.43% find_inode
      + 1.02% iput
      + 0.69% dput
      + 0.57% __tux3_get_block
      + 0.53% shrink_dcache_parent
      + 0.53% __d_instantiate

Before patch:

real 2m40.994s
user 0m1.344s
sys  0m15.832s

After patch:

real 2m34.748
user 0m1.360s
sys  0m5.356s

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fs-writeback.c  |    5 ++++-
 include/linux/fs.h |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/fs.h~tux3-fix-wait_sb_inodes include/linux/fs.h
--- tux3fs/include/linux/fs.h~tux3-fix-wait_sb_inodes	2013-06-24 19:03:10.000000000 +0900
+++ tux3fs-hirofumi/include/linux/fs.h	2013-06-24 19:03:10.000000000 +0900
@@ -1595,6 +1595,7 @@ struct super_operations {
 	int (*write_inode) (struct inode *, struct writeback_control *wbc);
 	int (*drop_inode) (struct inode *);
 	void (*evict_inode) (struct inode *);
+	void (*wait_inodes)(struct super_block *);
 	void (*put_super) (struct super_block *);
 	int (*sync_fs)(struct super_block *sb, int wait);
 	int (*freeze_fs) (struct super_block *);
diff -puN fs/fs-writeback.c~tux3-fix-wait_sb_inodes fs/fs-writeback.c
--- tux3fs/fs/fs-writeback.c~tux3-fix-wait_sb_inodes	2013-06-24 19:03:10.000000000 +0900
+++ tux3fs-hirofumi/fs/fs-writeback.c	2013-06-24 19:03:10.000000000 +0900
@@ -1401,7 +1401,10 @@ void sync_inodes_sb(struct super_block *
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);
 
-	wait_sb_inodes(sb);
+	if (sb->s_op->wait_inodes)
+		sb->s_op->wait_inodes(sb);
+	else
+		wait_sb_inodes(sb);
 }
 EXPORT_SYMBOL(sync_inodes_sb);
 
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
