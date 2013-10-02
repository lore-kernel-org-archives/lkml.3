Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3JBNod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:44:33 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:60047 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3JBNob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:44:31 -0400
X-Nat-Received: from [202.181.97.72]:59289 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1380721456.24614
To: rientjes@google.com
Cc: akpm@linux-foundation.org, oleg@redhat.com, security@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: kthread: Make kthread_create() killable.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.DEB.2.02.1309261149050.10904@chino.kir.corp.google.com>
	<201309281618.JAG82364.VFMtSOOQOLFHJF@I-love.SAKURA.ne.jp>
	<alpine.DEB.2.02.1309301441270.28109@chino.kir.corp.google.com>
	<201310012220.EIE35417.HFOQLFSFMJOtOV@I-love.SAKURA.ne.jp>
	<alpine.DEB.2.02.1310012358140.20628@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1310012358140.20628@chino.kir.corp.google.com>
Message-Id: <201310022244.AAD90647.JOFVtMFQFHSOOL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 2 Oct 2013 22:44:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 02102013 #11161823, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> I thought you had addressed the kthread_create() issue on 
> security@kernel.org, is it possible to address the others?

I don't know how to call call_usermodehelper_keys(). I need a lot of help
if I write a patch and a testcase for call_usermodehelper_keys().

Thus, I explain only do_coredump() case.

> If you have a reproducible testcase or an example from the kernel log that 
> demonstrates this problem, please post it.

OK, quoting a kernel log. I want to keep the reproducer program and backtrace
by the reproducer program secret for now, for I don't think it is a good thing
to publish DoS attacking program before the problem is fixed.

Theoretically, OOM killer can choose a process which is sleeping at
wait_for_completion(). I reproduced such condition using below patch which
increases the race window for triggering the OOM killer.

---------- patch start ----------
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -485,6 +485,8 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 	return err;
 }
 
+#include <linux/delay.h>
+
 void do_coredump(siginfo_t *siginfo)
 {
 	struct core_state core_state;
@@ -598,9 +600,16 @@ void do_coredump(siginfo_t *siginfo)
 		sub_info = call_usermodehelper_setup(helper_argv[0],
 						helper_argv, NULL, GFP_KERNEL,
 						umh_pipe_setup, NULL, &cprm);
+		if (sub_info) {
+			printk(KERN_INFO "***** Delaying\n");
+			ssleep(5); /* Give other tasks chance to trigger OOM killer */
+			printk(KERN_INFO "***** Calling call_usermodehelper_exec()\n");
+		}
 		if (sub_info)
 			retval = call_usermodehelper_exec(sub_info,
 							  UMH_WAIT_EXEC);
+		if (sub_info)
+			printk(KERN_INFO "***** call_usermodehelper_exec() done.\n");
 
 		argv_free(helper_argv);
 		if (retval) {
---------- patch end ----------

---------- dmesg start ----------
[  412.089694] a.out[4110]: segfault at 0 ip 08048476 sp bfe82730 error 4 in a.out[8048000+1000]
[  412.091986] ***** Delaying
[  415.988417] memeater invoked oom-killer: gfp_mask=0x200d2, order=0, oom_score_adj=0
[  415.990294] CPU: 0 PID: 4111 Comm: memeater Not tainted 3.11.0-10050-g3711d86-dirty #119
[  415.992732] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 08/15/2008
[  415.995265]  df1da3d0 de02bd38 c05542eb 000200d2 de02bd9c c01a76a1 c067c530 df1da5c8
[  415.997938]  000200d2 00000000 00000000 c013e3d1 de02bd60 c012817c de02bdb8 c0557b6d
[  416.000153]  df147bd0 00000027 00002727 00000206 de02bd9c c0351862 df147edc 0000007b
[  416.002366] Call Trace:
(... snipped ...)
[  416.027799] Mem-Info:
[  416.028453] DMA per-cpu:
[  416.030255] CPU    0: hi:    0, btch:   1 usd:   0
[  416.031483] CPU    1: hi:    0, btch:   1 usd:   0
[  416.032733] Normal per-cpu:
[  416.033486] CPU    0: hi:  186, btch:  31 usd:  30
[  416.034706] CPU    1: hi:  186, btch:  31 usd:   0
[  416.035935] active_anon:117681 inactive_anon:350 isolated_anon:0
[  416.035935]  active_file:13 inactive_file:6 isolated_file:0
[  416.035935]  unevictable:0 dirty:0 writeback:0 unstable:0
[  416.035935]  free:1181 slab_reclaimable:412 slab_unreclaimable:1472
[  416.035935]  mapped:0 shmem:34 pagetables:161 bounce:0
[  416.035935]  free_cma:0
[  416.044759] DMA free:2008kB min:48kB low:60kB high:72kB active_anon:6880kB inactive_anon:20kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15992kB managed:9248kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:40kB slab_unreclaimable:84kB kernel_stack:0kB pagetables:20kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[  416.055474] lowmem_reserve[]: 0 491 491 491
[  416.056800] Normal free:2716kB min:2808kB low:3508kB high:4212kB active_anon:463844kB inactive_anon:1380kB active_file:52kB inactive_file:24kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:507840kB managed:503244kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:136kB slab_reclaimable:1608kB slab_unreclaimable:5804kB kernel_stack:552kB pagetables:624kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:130 all_unreclaimable? yes
[  416.068128] lowmem_reserve[]: 0 0 0 0
[  416.069291] DMA: 0*4kB 1*8kB (R) 1*16kB (R) 0*32kB 1*64kB (R) 1*128kB (R) 1*256kB (R) 1*512kB (R) 1*1024kB (R) 0*2048kB 0*4096kB = 2008kB
[  416.074373] Normal: 275*4kB (UEM) 136*8kB (UEM) 33*16kB (EM) 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2716kB
[  416.078022] 56 total pagecache pages
[  416.078954] 0 pages in swap cache
[  416.079829] Swap cache stats: add 120624, delete 120624, find 23686/24787
[  416.081544] Free swap  = 0kB
[  416.083515] Total swap = 0kB
[  416.085827] 131071 pages RAM
[  416.086644] 0 pages HighMem
[  416.087686] 2948 pages reserved
[  416.088581] 523856 pages shared
[  416.089421] 126585 pages non-shared
[  416.090338] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
[  416.092365] [ 2943]     0  2943      625       94       2        0         -1000 udevd
[  416.095624] [ 3542]     0  3542     2732       45       2        6         -1000 auditd
[  416.097695] [ 3790]     0  3790     2171      122       4        0         -1000 sshd
[  416.099690] [ 3888]     0  3888      624       95       2        0         -1000 udevd
[  416.101750] [ 3889]     0  3889      624       93       2        0         -1000 udevd
[  416.104906] [ 4074]     0  4074      993      106       4        0             0 login
[  416.106926] [ 4075]     0  4075      513       14       3        0             0 mingetty
[  416.109019] [ 4076]     0  4076      513       13       3        0             0 mingetty
[  416.111072] [ 4077]     0  4077      513       14       3        0             0 mingetty
[  416.113162] [ 4078]     0  4078      513       13       3        0             0 mingetty
[  416.116363] [ 4079]     0  4079      993      107       3        0             0 login
[  416.118357] [ 4080]     0  4080     1611       70       4        0             0 bash
[  416.120354] [ 4093]   500  4093     1611       60       4        0             0 bash
[  416.122327] [ 4110]     0  4110   117665   117200     117        0             0 a.out
[  416.125436] [ 4111]   500  4111      478       10       3        0             0 memeater
[  416.127509] Out of memory: Kill process 4110 (a.out) score 885 or sacrifice child
[  416.129458] Killed process 4110 (a.out) total-vm:470660kB, anon-rss:468800kB, file-rss:0kB
[  417.096035] ***** Calling call_usermodehelper_exec()
[  600.976438] INFO: task a.out:4110 blocked for more than 120 seconds.
[  600.978185]       Not tainted 3.11.0-10050-g3711d86-dirty #119
[  600.979655] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  600.980561] a.out           D 0000bc00     0  4110   4080 0x00100084
[  600.982320]  de6a9d20 00000082 00000000 0000bc00 0000000a 1cf02990 df1dab10 df097510
[  600.985850]  df1dab10 c07b8180 c07b2000 c07b8180 df1dab10 df1dab50 00000000 c0568220
[  600.988293]  dffea180 c0568220 de6a9cf0 c015c29a dffea180 df0974d0 dffea180 de6a9d04
[  600.990597] Call Trace:
[  600.993308]  [<c015c29a>] ? check_preempt_curr+0x6a/0x80
[  600.994658]  [<c015c2ca>] ? ttwu_do_wakeup+0x1a/0xd0
[  600.995931]  [<c015fe5a>] ? ttwu_do_activate.clone.1+0x3a/0x50
[  600.996651]  [<c055660e>] schedule+0x1e/0x50
[  600.997749]  [<c0554435>] schedule_timeout+0x135/0x180
[  600.999069]  [<c016009a>] ? wake_up_process+0x1a/0x30
[  601.000470]  [<c014c229>] ? wake_up_worker+0x19/0x20
[  601.001733]  [<c014c643>] ? insert_work+0x53/0x90
[  601.002941]  [<c0555dc4>] wait_for_common+0x94/0x120
[  601.005966]  [<c0160060>] ? try_to_wake_up+0x1f0/0x1f0
[  601.007258]  [<c0555ef2>] wait_for_completion+0x12/0x20
[  601.008590]  [<c014b697>] call_usermodehelper_exec+0xd7/0x100
[  601.010026]  [<c0219104>] do_coredump+0x994/0xca0
[  601.011215]  [<c0219410>] ? do_coredump+0xca0/0xca0
[  601.012540]  [<c0140000>] ? do_proc_dointvec_ms_jiffies_conv+0x70/0x80
[  601.014169]  [<c0145d42>] ? __dequeue_signal+0xd2/0x140
[  601.015500]  [<c014877a>] get_signal_to_deliver+0x19a/0x4e0
[  601.016609]  [<c0101a47>] do_signal+0x37/0x960
[  601.017747]  [<c013e3d1>] ? irq_exit+0x51/0x90
[  601.020353]  [<c0103236>] ? do_IRQ+0x46/0xb0
[  601.021455]  [<c010931d>] ? init_fpu+0x3d/0xa0
[  601.022602]  [<c055a840>] ? __do_page_fault+0x500/0x500
[  601.023915]  [<c01023c5>] do_notify_resume+0x55/0x70
[  601.025088]  [<c0557a6b>] work_notifysig+0x24/0x29
[  601.026304]  [<c055a840>] ? __do_page_fault+0x500/0x500
---------- dmesg end ----------

Below is the patch to fix this problem.

----------------------------------------
>From 052fedc920b735354b618e23c0b74c7b88ecd3c6 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Wed, 2 Oct 2013 22:11:00 +0900
Subject: [PATCH v2] coredump: Make startup of coredump to pipe killable.

Any user process callers of wait_for_completion() except global init process
might be chosen by the OOM killer while waiting for completion() call by some
other process which does memory allocation.

When such users are chosen by the OOM killer when they are waiting for
completion() in TASK_UNINTERRUPTIBLE, the system will be kept stressed
due to memory starvation because the OOM killer cannot kill such users.

call_usermodehelper() without UMH_KILLABLE flag is one of such users and this
patch fixes the problem for do_coredump() by making startup of coredump to pipe
killable.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/coredump.c           |  124 +++++++++++++++++++++++++++++++----------------
 include/linux/binfmts.h |    2 +
 2 files changed, 84 insertions(+), 42 deletions(-)

diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index e8112ae..b0cb384 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -61,6 +61,8 @@ struct coredump_params {
 	struct file *file;
 	unsigned long limit;
 	unsigned long mm_flags;
+	char **argv; /* Maybe NULL. Used by only fs/coredump.c */
+	bool defer_cleanup; /* Used by only fs/coredump.c */
 };
 
 /*
diff --git a/fs/coredump.c b/fs/coredump.c
index 9bdeca1..42d6d0e 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -485,6 +485,38 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 	return err;
 }
 
+/*
+ * umh_pipe_free - Clean up resources.
+ *
+ * @cprm: Pointer to "struct coredump_params".
+ */
+static void umh_pipe_free(struct coredump_params *cprm)
+{
+	/*
+	 * This xchg() returns true only if "the caller of do_coredump() needs
+	 * to wait for completion of the khelper" or vice versa.
+	 */
+	if (xchg(&cprm->defer_cleanup, false))
+		return;
+	/* Close the pipe's writer side if it is not yet closed. */
+	if (cprm->file)
+		fput(cprm->file);
+	/* Release arguments used by execve() if they are not yet released. */
+	if (cprm->argv)
+		argv_free(cprm->argv);
+	kfree(cprm);
+}
+
+/*
+ * umh_pipe_cleanup - Clean up resources as needed.
+ *
+ * @info: Pointer to "struct subprocess_info".
+ */
+static void umh_pipe_cleanup(struct subprocess_info *info)
+{
+	umh_pipe_free((struct coredump_params *) info->data);
+}
+
 void do_coredump(siginfo_t *siginfo)
 {
 	struct core_state core_state;
@@ -500,24 +532,26 @@ void do_coredump(siginfo_t *siginfo)
 	bool need_nonrelative = false;
 	bool core_dumped = false;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
-	struct coredump_params cprm = {
-		.siginfo = siginfo,
-		.regs = signal_pt_regs(),
-		.limit = rlimit(RLIMIT_CORE),
-		/*
-		 * We must use the same mm->flags while dumping core to avoid
-		 * inconsistency of bit flags, since this flag is not protected
-		 * by any locks.
-		 */
-		.mm_flags = mm->flags,
-	};
+	struct coredump_params *cprm = kzalloc(sizeof(*cprm), GFP_KERNEL);
 
 	audit_core_dumps(siginfo->si_signo);
 
+	if (!cprm)
+		return;
+	cprm->siginfo = siginfo;
+	cprm->regs = signal_pt_regs();
+	cprm->limit = rlimit(RLIMIT_CORE);
+	/*
+	 * We must use the same mm->flags while dumping core to avoid
+	 * inconsistency of bit flags, since this flag is not protected
+	 * by any locks.
+	 */
+	cprm->mm_flags = mm->flags;
+
 	binfmt = mm->binfmt;
 	if (!binfmt || !binfmt->core_dump)
 		goto fail;
-	if (!__get_dumpable(cprm.mm_flags))
+	if (!__get_dumpable(cprm->mm_flags))
 		goto fail;
 
 	cred = prepare_creds();
@@ -529,7 +563,7 @@ void do_coredump(siginfo_t *siginfo)
 	 * so we dump it as root in mode 2, and only into a controlled
 	 * environment (pipe handler or fully qualified path).
 	 */
-	if (__get_dumpable(cprm.mm_flags) == SUID_DUMP_ROOT) {
+	if (__get_dumpable(cprm->mm_flags) == SUID_DUMP_ROOT) {
 		/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
@@ -542,11 +576,10 @@ void do_coredump(siginfo_t *siginfo)
 
 	old_cred = override_creds(cred);
 
-	ispipe = format_corename(&cn, &cprm);
+	ispipe = format_corename(&cn, cprm);
 
 	if (ispipe) {
 		int dump_count;
-		char **helper_argv;
 		struct subprocess_info *sub_info;
 
 		if (ispipe < 0) {
@@ -555,12 +588,12 @@ void do_coredump(siginfo_t *siginfo)
 			goto fail_unlock;
 		}
 
-		if (cprm.limit == 1) {
+		if (cprm->limit == 1) {
 			/* See umh_pipe_setup() which sets RLIMIT_CORE = 1.
 			 *
 			 * Normally core limits are irrelevant to pipes, since
 			 * we're not writing to the file system, but we use
-			 * cprm.limit of 1 here as a speacial value, this is a
+			 * cprm->limit of 1 here as a speacial value, this is a
 			 * consistent way to catch recursive crashes.
 			 * We can still crash if the core_pattern binary sets
 			 * RLIM_CORE = !1, but it runs as root, and can do
@@ -577,7 +610,7 @@ void do_coredump(siginfo_t *siginfo)
 			printk(KERN_WARNING "Aborting core\n");
 			goto fail_unlock;
 		}
-		cprm.limit = RLIM_INFINITY;
+		cprm->limit = RLIM_INFINITY;
 
 		dump_count = atomic_inc_return(&core_dump_count);
 		if (core_pipe_limit && (core_pipe_limit < dump_count)) {
@@ -587,22 +620,27 @@ void do_coredump(siginfo_t *siginfo)
 			goto fail_dropcount;
 		}
 
-		helper_argv = argv_split(GFP_KERNEL, cn.corename, NULL);
-		if (!helper_argv) {
+		cprm->argv = argv_split(GFP_KERNEL, cn.corename, NULL);
+		if (!cprm->argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
 			goto fail_dropcount;
 		}
 
 		retval = -ENOMEM;
-		sub_info = call_usermodehelper_setup(helper_argv[0],
-						helper_argv, NULL, GFP_KERNEL,
-						umh_pipe_setup, NULL, &cprm);
-		if (sub_info)
-			retval = call_usermodehelper_exec(sub_info,
-							  UMH_WAIT_EXEC);
-
-		argv_free(helper_argv);
+		sub_info = call_usermodehelper_setup
+			(cprm->argv[0], cprm->argv, NULL, GFP_KERNEL,
+			 umh_pipe_setup, umh_pipe_cleanup, cprm);
+		if (sub_info) {
+			/*
+			 * Let the cleanup of cprm to the khelper if I was
+			 * SIGKILLed before the khelper starts cprm->argv[0].
+			 */
+			cprm->defer_cleanup = true;
+			retval = call_usermodehelper_exec
+				(sub_info, UMH_WAIT_EXEC | UMH_KILLABLE);
+		}
+
 		if (retval) {
 			printk(KERN_INFO "Core dump to |%s pipe failed\n",
 			       cn.corename);
@@ -611,7 +649,7 @@ void do_coredump(siginfo_t *siginfo)
 	} else {
 		struct inode *inode;
 
-		if (cprm.limit < binfmt->min_coredump)
+		if (cprm->limit < binfmt->min_coredump)
 			goto fail_unlock;
 
 		if (need_nonrelative && cn.corename[0] != '/') {
@@ -622,16 +660,16 @@ void do_coredump(siginfo_t *siginfo)
 			goto fail_unlock;
 		}
 
-		cprm.file = filp_open(cn.corename,
+		cprm->file = filp_open(cn.corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
-		if (IS_ERR(cprm.file))
+		if (IS_ERR(cprm->file))
 			goto fail_unlock;
 
-		inode = file_inode(cprm.file);
+		inode = file_inode(cprm->file);
 		if (inode->i_nlink > 1)
 			goto close_fail;
-		if (d_unhashed(cprm.file->f_path.dentry))
+		if (d_unhashed(cprm->file->f_path.dentry))
 			goto close_fail;
 		/*
 		 * AK: actually i see no reason to not allow this for named
@@ -645,9 +683,9 @@ void do_coredump(siginfo_t *siginfo)
 		 */
 		if (!uid_eq(inode->i_uid, current_fsuid()))
 			goto close_fail;
-		if (!cprm.file->f_op || !cprm.file->f_op->write)
+		if (!cprm->file->f_op || !cprm->file->f_op->write)
 			goto close_fail;
-		if (do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file))
+		if (do_truncate(cprm->file->f_path.dentry, 0, 0, cprm->file))
 			goto close_fail;
 	}
 
@@ -658,15 +696,17 @@ void do_coredump(siginfo_t *siginfo)
 	if (displaced)
 		put_files_struct(displaced);
 	if (!dump_interrupted()) {
-		file_start_write(cprm.file);
-		core_dumped = binfmt->core_dump(&cprm);
-		file_end_write(cprm.file);
+		file_start_write(cprm->file);
+		core_dumped = binfmt->core_dump(cprm);
+		file_end_write(cprm->file);
 	}
 	if (ispipe && core_pipe_limit)
-		wait_for_dump_helpers(cprm.file);
+		wait_for_dump_helpers(cprm->file);
 close_fail:
-	if (cprm.file)
-		filp_close(cprm.file, NULL);
+	if (cprm->file) {
+		filp_close(cprm->file, NULL);
+		cprm->file = NULL;
+	}
 fail_dropcount:
 	if (ispipe)
 		atomic_dec(&core_dump_count);
@@ -677,7 +717,7 @@ fail_unlock:
 fail_creds:
 	put_cred(cred);
 fail:
-	return;
+	umh_pipe_free(cprm);
 }
 
 /*
-- 
1.7.1
