Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaEEQhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 12:37:36 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:58037 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbaEEQhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 12:37:34 -0400
Date: Mon, 5 May 2014 12:37:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: axboe@kernel.dk, Li Zefan <lizefan@huawei.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        cgroups@vger.kernel.org
Subject: [PATCH cgroup/for-3.15-fixes] blkcg: use trylock on blkcg_pol_mutex
 in blkcg_reset_stats()
Message-ID: <20140505163730.GL11231@htj.dyndns.org>
References: <5363C04B.4010400@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5363C04B.4010400@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the recent conversion of cgroup to kernfs, cgroup_tree_mutex
which nests above both the kernfs s_active protection and cgroup_mutex
is added to synchronize cgroup file type operations as cgroup_mutex
needed to be grabbed from some file operations and thus can't be put
above s_active protection.

While this arrangement mostly worked for cgroup, this triggered the
following lockdep warning.

  ======================================================
  [ INFO: possible circular locking dependency detected ]
  3.15.0-rc3-next-20140430-sasha-00016-g4e281fa-dirty #429 Tainted: G        W
  -------------------------------------------------------
  trinity-c173/9024 is trying to acquire lock:
  (blkcg_pol_mutex){+.+.+.}, at: blkcg_reset_stats (include/linux/spinlock.h:328 block/blk-cgroup.c:455)

  but task is already holding lock:
  (s_active#89){++++.+}, at: kernfs_fop_write (fs/kernfs/file.c:283)

  which lock already depends on the new lock.


  the existing dependency chain (in reverse order) is:

  -> #2 (s_active#89){++++.+}:
  lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
  __kernfs_remove (arch/x86/include/asm/atomic.h:27 fs/kernfs/dir.c:352 fs/kernfs/dir.c:1024)
  kernfs_remove_by_name_ns (fs/kernfs/dir.c:1219)
  cgroup_addrm_files (include/linux/kernfs.h:427 kernel/cgroup.c:1074 kernel/cgroup.c:2899)
  cgroup_clear_dir (kernel/cgroup.c:1092 (discriminator 2))
  rebind_subsystems (kernel/cgroup.c:1144)
  cgroup_setup_root (kernel/cgroup.c:1568)
  cgroup_mount (kernel/cgroup.c:1716)
  mount_fs (fs/super.c:1094)
  vfs_kern_mount (fs/namespace.c:899)
  do_mount (fs/namespace.c:2238 fs/namespace.c:2561)
  SyS_mount (fs/namespace.c:2758 fs/namespace.c:2729)
  tracesys (arch/x86/kernel/entry_64.S:746)

  -> #1 (cgroup_tree_mutex){+.+.+.}:
  lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
  mutex_lock_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:587)
  cgroup_add_cftypes (include/linux/list.h:76 kernel/cgroup.c:3040)
  blkcg_policy_register (block/blk-cgroup.c:1106)
  throtl_init (block/blk-throttle.c:1694)
  do_one_initcall (init/main.c:789)
  kernel_init_freeable (init/main.c:854 init/main.c:863 init/main.c:882 init/main.c:1003)
  kernel_init (init/main.c:935)
  ret_from_fork (arch/x86/kernel/entry_64.S:552)

  -> #0 (blkcg_pol_mutex){+.+.+.}:
  __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
  lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
  mutex_lock_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:587)
  blkcg_reset_stats (include/linux/spinlock.h:328 block/blk-cgroup.c:455)
  cgroup_file_write (kernel/cgroup.c:2714)
  kernfs_fop_write (fs/kernfs/file.c:295)
  vfs_write (fs/read_write.c:532)
  SyS_write (fs/read_write.c:584 fs/read_write.c:576)
  tracesys (arch/x86/kernel/entry_64.S:746)

  other info that might help us debug this:

  Chain exists of:
  blkcg_pol_mutex --> cgroup_tree_mutex --> s_active#89

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(s_active#89);
				 lock(cgroup_tree_mutex);
				 lock(s_active#89);
    lock(blkcg_pol_mutex);

   *** DEADLOCK ***

  4 locks held by trinity-c173/9024:
  #0: (&f->f_pos_lock){+.+.+.}, at: __fdget_pos (fs/file.c:714)
  #1: (sb_writers#18){.+.+.+}, at: vfs_write (include/linux/fs.h:2255 fs/read_write.c:530)
  #2: (&of->mutex){+.+.+.}, at: kernfs_fop_write (fs/kernfs/file.c:283)
  #3: (s_active#89){++++.+}, at: kernfs_fop_write (fs/kernfs/file.c:283)

  stack backtrace:
  CPU: 3 PID: 9024 Comm: trinity-c173 Tainted: G        W     3.15.0-rc3-next-20140430-sasha-00016-g4e281fa-dirty #429
   ffffffff919687b0 ffff8805f6373bb8 ffffffff8e52cdbb 0000000000000002
   ffffffff919d8400 ffff8805f6373c08 ffffffff8e51fb88 0000000000000004
   ffff8805f6373c98 ffff8805f6373c08 ffff88061be70d98 ffff88061be70dd0
  Call Trace:
  dump_stack (lib/dump_stack.c:52)
  print_circular_bug (kernel/locking/lockdep.c:1216)
  __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
  lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
  mutex_lock_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:587)
  blkcg_reset_stats (include/linux/spinlock.h:328 block/blk-cgroup.c:455)
  cgroup_file_write (kernel/cgroup.c:2714)
  kernfs_fop_write (fs/kernfs/file.c:295)
  vfs_write (fs/read_write.c:532)
  SyS_write (fs/read_write.c:584 fs/read_write.c:576)

This is a highly unlikely but valid circular dependency between "echo
1 > blkcg.reset_stats" and cfq module [un]loading.  cgroup is going
through further locking update which will remove this complication but
for now let's use trylock on blkcg_pol_mutex and retry the file
operation if the trylock fails.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Li Zefan <lizefan@huawei.com>
References: http://lkml.kernel.org/g/5363C04B.4010400@oracle.com
---
 block/blk-cgroup.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index e4a4145..1039fb9 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -451,7 +451,20 @@ static int blkcg_reset_stats(struct cgroup_subsys_state *css,
 	struct blkcg_gq *blkg;
 	int i;
 
-	mutex_lock(&blkcg_pol_mutex);
+	/*
+	 * XXX: We invoke cgroup_add/rm_cftypes() under blkcg_pol_mutex
+	 * which ends up putting cgroup's internal cgroup_tree_mutex under
+	 * it; however, cgroup_tree_mutex is nested above cgroup file
+	 * active protection and grabbing blkcg_pol_mutex from a cgroup
+	 * file operation creates a possible circular dependency.  cgroup
+	 * internal locking is planned to go through further simplification
+	 * and this issue should go away soon.  For now, let's trylock
+	 * blkcg_pol_mutex and restart the write on failure.
+	 *
+	 * http://lkml.kernel.org/g/5363C04B.4010400@oracle.com
+	 */
+	if (!mutex_trylock(&blkcg_pol_mutex))
+		return restart_syscall();
 	spin_lock_irq(&blkcg->lock);
 
 	/*
