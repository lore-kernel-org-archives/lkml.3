Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3IPHZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 03:25:32 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56933 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab3IPHZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 03:25:31 -0400
X-Nat-Received: from [202.181.97.72]:62485 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379316315.24510
To: oleg@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, rientjes@google.com, dserrg@gmail.com,
        mhocko@suse.cz
Subject: [PATCH] coredump: Make startup of coredump to pipe killable.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309132318.HEC05218.OtVOFOFMLJHFQS@I-love.SAKURA.ne.jp>
	<20130914160515.GA8627@redhat.com>
	<201309150846.HED51521.tJOFOMVFSOHQFL@I-love.SAKURA.ne.jp>
	<201309152038.DDJ59271.OJMOHLFtSFOQVF@I-love.SAKURA.ne.jp>
	<20130915165531.GD13344@redhat.com>
In-Reply-To: <20130915165531.GD13344@redhat.com>
Message-Id: <201309161625.ADC26575.tFQFOJHVOFOLSM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 16 Sep 2013 16:25:16 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 16092013 #11064720, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> Hi Tetsuo,
> 
> please do not start the off-list discussions ;)

Sorry. Although I think and hope that there is no easy way to trigger this bug,
this bug might become a CVE if found one. Thus, I started without ML. I assume
you also think that there is no easy way to trigger this bug.

> > Do we want to change from call_usermodehelper_exec(UMH_WAIT_EXEC) to
> > call_usermodehelper_exec(UMH_WAIT_EXEC | UMH_WAIT_KILLABLE)
> 
> To me, this makes sense in any case. And this matches other recent
> "make coredump killable" changes.

OK, this patch is for do_coredump(). But I might be missing something. (e.g.
Is it safe to terminate current process while file descriptor table of current
process is planned to be updated by kthread later? Are there other resources
which have to be kept valid until kthread starts coredump process?)
----------------------------------------
>From 6b81b9956df284564112a95c941bf390c15f4f06 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 16 Sep 2013 15:59:05 +0900
Subject: [PATCH] coredump: Make startup of coredump to pipe killable.

Any users of wait_for_completion() might be chosen by the OOM killer while
waiting for completion() call by some process which does memory allocation.
call_usermodehelper() without UMH_KILLABLE flag is one of such users.

When such users are chosen by the OOM killer when they are waiting for
completion() in TASK_UNINTERRUPTIBLE, problem similar to CVE-2012-4398
"kernel: request_module() OOM local DoS" can happen.

This patch makes call_usermodehelper_exec() call in do_coredump() killable,
using similar approach used for fixing CVE-2012-4398.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/coredump.c           |  113 ++++++++++++++++++++++++++++++-----------------
 include/linux/binfmts.h |    2 +
 2 files changed, 74 insertions(+), 41 deletions(-)

diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index e8112ae..547690f 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -61,6 +61,8 @@ struct coredump_params {
 	struct file *file;
 	unsigned long limit;
 	unsigned long mm_flags;
+	char **argv; /* Maybe NULL. Used by only fs/coredump.c */
+	bool in_use; /* Used by only fs/coredump.c */
 };
 
 /*
diff --git a/fs/coredump.c b/fs/coredump.c
index 9bdeca1..45abf0b 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -485,6 +485,23 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 	return err;
 }
 
+/*
+ * umh_pipe_cleanup - Clean up resources as needed.
+ *
+ * @info: Pointer to "struct subprocess_info".
+ */
+static void umh_pipe_cleanup(struct subprocess_info *info)
+{
+	/* If user was SIGKILLed, I release the structure. */
+	struct coredump_params *cprm = (struct coredump_params *)info->data;
+
+	if (!xchg(&cprm->in_use, false)) {
+		if (cprm->argv)
+			argv_free(cprm->argv);
+		kfree(cprm);
+	}
+}
+
 void do_coredump(siginfo_t *siginfo)
 {
 	struct core_state core_state;
@@ -500,24 +517,26 @@ void do_coredump(siginfo_t *siginfo)
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
@@ -529,7 +548,7 @@ void do_coredump(siginfo_t *siginfo)
 	 * so we dump it as root in mode 2, and only into a controlled
 	 * environment (pipe handler or fully qualified path).
 	 */
-	if (__get_dumpable(cprm.mm_flags) == SUID_DUMP_ROOT) {
+	if (__get_dumpable(cprm->mm_flags) == SUID_DUMP_ROOT) {
 		/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
@@ -542,11 +561,10 @@ void do_coredump(siginfo_t *siginfo)
 
 	old_cred = override_creds(cred);
 
-	ispipe = format_corename(&cn, &cprm);
+	ispipe = format_corename(&cn, cprm);
 
 	if (ispipe) {
 		int dump_count;
-		char **helper_argv;
 		struct subprocess_info *sub_info;
 
 		if (ispipe < 0) {
@@ -555,12 +573,12 @@ void do_coredump(siginfo_t *siginfo)
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
@@ -577,7 +595,7 @@ void do_coredump(siginfo_t *siginfo)
 			printk(KERN_WARNING "Aborting core\n");
 			goto fail_unlock;
 		}
-		cprm.limit = RLIM_INFINITY;
+		cprm->limit = RLIM_INFINITY;
 
 		dump_count = atomic_inc_return(&core_dump_count);
 		if (core_pipe_limit && (core_pipe_limit < dump_count)) {
@@ -587,22 +605,29 @@ void do_coredump(siginfo_t *siginfo)
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
+			 * Let the cleanup of cprm to kthread if I was
+			 * SIGKILLed before the kthread starts cprm->argv[0].
+			 * We use cprm->in_use field for indicating whether
+			 * the kthread needs to cleanup cprm or not.
+			 */
+			cprm->in_use = true;
+			retval = call_usermodehelper_exec
+				(sub_info, UMH_WAIT_EXEC | UMH_KILLABLE);
+		}
+
 		if (retval) {
 			printk(KERN_INFO "Core dump to |%s pipe failed\n",
 			       cn.corename);
@@ -611,7 +636,7 @@ void do_coredump(siginfo_t *siginfo)
 	} else {
 		struct inode *inode;
 
-		if (cprm.limit < binfmt->min_coredump)
+		if (cprm->limit < binfmt->min_coredump)
 			goto fail_unlock;
 
 		if (need_nonrelative && cn.corename[0] != '/') {
@@ -622,16 +647,16 @@ void do_coredump(siginfo_t *siginfo)
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
@@ -645,9 +670,9 @@ void do_coredump(siginfo_t *siginfo)
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
 
@@ -658,15 +683,15 @@ void do_coredump(siginfo_t *siginfo)
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
+	if (cprm->file)
+		filp_close(cprm->file, NULL);
 fail_dropcount:
 	if (ispipe)
 		atomic_dec(&core_dump_count);
@@ -677,6 +702,12 @@ fail_unlock:
 fail_creds:
 	put_cred(cred);
 fail:
+	/* Cleanup if this structure is no longer used by the kthread. */
+	if (!xchg(&cprm->in_use, false)) {
+		if (cprm->argv)
+			argv_free(cprm->argv);
+		kfree(cprm);
+	}
 	return;
 }
 
-- 
1.7.1
