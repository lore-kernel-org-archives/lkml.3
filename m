Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab3CaAEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 20:04:43 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:35647 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab3CaAEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 20:04:41 -0400
Date: Sun, 31 Mar 2013 00:04:40 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>, Shawn Guo <shawn.guo@linaro.org>,
        maciej.rutecki@gmail.com, Fengguang Wu <fengguang.wu@intel.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Ingo Molnar <mingo@redhat.com>, Ben Chan <benchan@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] Revert "lockdep: check that no locks held at freeze time"
Message-ID: <alpine.DEB.2.00.1303310000180.6436@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This reverts commit 6aa9707099c4b25700940eb3d016f16c4434360d.

Commit 6aa970 causes problems with NFS root filesystems.  The failures
were noticed on OMAP2 and 3 boards during kernel init:

[    5.508148] [ BUG: swapper/0/1 still has locks held! ]
[    5.513610] 3.9.0-rc3-00344-ga937536 #1 Not tainted
[    5.518798] -------------------------------------
[    5.523773] 1 lock held by swapper/0/1:
[    5.527893]  #0:  (&type->s_umount_key#13/1){+.+.+.}, at: [<c011e84c>] sget+0x248/0x574
[    5.536437]
[    5.536437] stack backtrace:
[    5.541107] [<c001bba8>] (unwind_backtrace+0x0/0xf0) from [<c05304bc>] (rpc_wait_bit_killable+0x98/0xcc)
[    5.551208] [<c05304bc>] (rpc_wait_bit_killable+0x98/0xcc) from [<c0551600>] (__wait_on_bit+0x74/0xb8)
[    5.561096] [<c0551600>] (__wait_on_bit+0x74/0xb8) from [<c05516b0>] (out_of_line_wait_on_bit+0x6c/0x78)
[    5.571166] [<c05516b0>] (out_of_line_wait_on_bit+0x6c/0x78) from [<c0530a0c>] (__rpc_execute+0xf0/0x360)
[    5.581329] [<c0530a0c>] (__rpc_execute+0xf0/0x360) from [<c052a254>] (rpc_run_task+0x98/0xa4)
[    5.590515] [<c052a254>] (rpc_run_task+0x98/0xa4) from [<c052a374>] (rpc_call_sync+0x48/0xb4)
[    5.599578] [<c052a374>] (rpc_call_sync+0x48/0xb4) from [<c0234964>] (nfs_proc_get_root+0x48/0x124)
[    5.609191] [<c0234964>] (nfs_proc_get_root+0x48/0x124) from [<c0227300>] (nfs_get_root+0x58/0x190)
[    5.618804] [<c0227300>] (nfs_get_root+0x58/0x190) from [<c022abbc>] (nfs_fs_mount_common+0x98/0x158)
[    5.628601] [<c022abbc>] (nfs_fs_mount_common+0x98/0x158) from [<c022b440>] (nfs_try_mount+0x144/0x214)
[    5.638580] [<c022b440>] (nfs_try_mount+0x144/0x214) from [<c022c4e0>] (nfs_fs_mount+0x178/0x850)
[    5.648010] [<c022c4e0>] (nfs_fs_mount+0x178/0x850) from [<c011f6e8>] (mount_fs+0x44/0x184)
[    5.656860] [<c011f6e8>] (mount_fs+0x44/0x184) from [<c01384c4>] (vfs_kern_mount+0x4c/0xc0)
[    5.665740] [<c01384c4>] (vfs_kern_mount+0x4c/0xc0) from [<c013a6d4>] (do_mount+0x6d0/0x858)
[    5.674682] [<c013a6d4>] (do_mount+0x6d0/0x858) from [<c013a8e0>] (sys_mount+0x84/0xb8)
[    5.683197] [<c013a8e0>] (sys_mount+0x84/0xb8) from [<c075faf0>] (do_mount_root+0x24/0xb0)
[    5.691986] [<c075faf0>] (do_mount_root+0x24/0xb0) from [<c075fee4>] (mount_root+0x50/0xf8)
[    5.700866] [<c075fee4>] (mount_root+0x50/0xf8) from [<c07600ec>] (prepare_namespace+0x160/0x1c4)
[    5.710296] [<c07600ec>] (prepare_namespace+0x160/0x1c4) from [<c075f978>] (kernel_init_freeable+0x17c/0x1c4)
[    5.720825] [<c075f978>] (kernel_init_freeable+0x17c/0x1c4) from [<c054b6c4>] (kernel_init+0x8/0xe4)
[    5.730529] [<c054b6c4>] (kernel_init+0x8/0xe4) from [<c0013d90>] (ret_from_fork+0x14/0x24)

Although the rootfs mounts, the system is unstable.  Here's a transcript from
a PM test:

http://www.pwsan.com/omap/testlogs/test_v3.9-rc3/20130317194234/pm/37xxevm/37xxevm_log.txt

Here's what the test log should look like:

http://www.pwsan.com/omap/testlogs/test_v3.8/20130218214403/pm/37xxevm/37xxevm_log.txt

Mailing list discussion is here:

http://lkml.org/lkml/2013/3/4/221

Deal with this for v3.9 by reverting the problem commit, until folks can 
figure out the right long-term course of action.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: <maciej.rutecki@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ben Chan <benchan@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>

---
 include/linux/debug_locks.h |    4 ++--
 include/linux/freezer.h     |    3 ---
 kernel/exit.c               |    2 +-
 kernel/lockdep.c            |   17 +++++++++--------
 4 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index a975de1..3bd46f7 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -51,7 +51,7 @@ struct task_struct;
 extern void debug_show_all_locks(void);
 extern void debug_show_held_locks(struct task_struct *task);
 extern void debug_check_no_locks_freed(const void *from, unsigned long len);
-extern void debug_check_no_locks_held(void);
+extern void debug_check_no_locks_held(struct task_struct *task);
 #else
 static inline void debug_show_all_locks(void)
 {
@@ -67,7 +67,7 @@ debug_check_no_locks_freed(const void *from, unsigned long len)
 }
 
 static inline void
-debug_check_no_locks_held(void)
+debug_check_no_locks_held(struct task_struct *task)
 {
 }
 #endif
diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 043a5cf..e70df40 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -3,7 +3,6 @@
 #ifndef FREEZER_H_INCLUDED
 #define FREEZER_H_INCLUDED
 
-#include <linux/debug_locks.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
@@ -49,8 +48,6 @@ extern void thaw_kernel_threads(void);
 
 static inline bool try_to_freeze(void)
 {
-	if (!(current->flags & PF_NOFREEZE))
-		debug_check_no_locks_held();
 	might_sleep();
 	if (likely(!freezing(current)))
 		return false;
diff --git a/kernel/exit.c b/kernel/exit.c
index 51e485c..60bc027 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -835,7 +835,7 @@ void do_exit(long code)
 	/*
 	 * Make sure we are holding no locks:
 	 */
-	debug_check_no_locks_held();
+	debug_check_no_locks_held(tsk);
 	/*
 	 * We can do this unlocked here. The futex code uses this flag
 	 * just to verify whether the pi state cleanup has been done
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 259db20..8a0efac 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -4088,7 +4088,7 @@ void debug_check_no_locks_freed(const void *mem_from, unsigned long mem_len)
 }
 EXPORT_SYMBOL_GPL(debug_check_no_locks_freed);
 
-static void print_held_locks_bug(void)
+static void print_held_locks_bug(struct task_struct *curr)
 {
 	if (!debug_locks_off())
 		return;
@@ -4097,21 +4097,22 @@ static void print_held_locks_bug(void)
 
 	printk("\n");
 	printk("=====================================\n");
-	printk("[ BUG: %s/%d still has locks held! ]\n",
-	       current->comm, task_pid_nr(current));
+	printk("[ BUG: lock held at task exit time! ]\n");
 	print_kernel_ident();
 	printk("-------------------------------------\n");
-	lockdep_print_held_locks(current);
+	printk("%s/%d is exiting with locks still held!\n",
+		curr->comm, task_pid_nr(curr));
+	lockdep_print_held_locks(curr);
+
 	printk("\nstack backtrace:\n");
 	dump_stack();
 }
 
-void debug_check_no_locks_held(void)
+void debug_check_no_locks_held(struct task_struct *task)
 {
-	if (unlikely(current->lockdep_depth > 0))
-		print_held_locks_bug();
+	if (unlikely(task->lockdep_depth > 0))
+		print_held_locks_bug(task);
 }
-EXPORT_SYMBOL_GPL(debug_check_no_locks_held);
 
 void debug_show_all_locks(void)
 {
-- 
1.7.10.4

