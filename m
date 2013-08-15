Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab3HOQ36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:29:58 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:60949 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555Ab3HOQ3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:29:37 -0400
From: Zach Levis <zach@zachsthings.com>
To: akpm@linux-foundation.org, oleg@redhat.com
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dan.carpenter@oracle.com,
        keescook@chromium.org, cody@linux.vnet.ibm.com, zml@linux.vnet.ibm.com,
        Zach Levis <zach@zachsthings.com>
Subject: [PATCH v5 2/3] fs/binfmts: Better handling of binfmt loops
Date: Thu, 15 Aug 2013 09:20:40 -0700
Message-Id: <1376583641-10298-3-git-send-email-zach@zachsthings.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With these changes, when a binfmt loop is encountered,
the ELOOP will propogate back to the 0 depth. At this point the
binprm's state will be reset to what it was originally and an
attempt is made to continue with the following binfmt handlers.

Example: a qemu is configured to run 64-bit ELFs on an otherwise 32-bit
system. The system's owner switches to running with 64-bit executables,
but forgets to disable the binfmt_misc option that redirects 64bit ELFs
to qemu. Since the qemu executable is a 64-bit ELF now, binfmt_misc
keeps on matching it with the qemu rule, preventing the execution of any
64-bit binary.

With these changes, an error is printed and search_binary_handler()
continues on to the next handler, allowing the original executable to
run normally so the user can (hopefully) fix their misconfiguration more
easily.

Caveats:
- binfmt_misc is skipped as a whole. To allow for a more generic
  solution that works for any binfmt without a lot of duplicated code
  and added complexity, the error detection code is applied on the
  binfmt level.
- This is a fallback solution. It attempts to restore the state to allow
  executing most binaries without side effects, but it may not work for
  everything and should not be depended on for regular usage.

Tested with:
- binfmt_misc line ":Testing:E::bft::/home/zlevis/test.bft:"
  and script at /home/zlevis/test.bft
      #!/bin/sh
      echo "hi"
      echo "$@"
- binfmt_script
  script at /home/zlevis/test
      echo "hi"
      echo "$@"

Signed-off-by: Zach Levis <zach@zachsthings.com>
---
 fs/exec.c               |  192 ++++++++++++++++++++++++++++++++++-------------
 include/linux/binfmts.h |    5 +
 2 files changed, 145 insertions(+), 52 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index eb229e1..aff9be2 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1365,6 +1365,111 @@ out:
 }
 EXPORT_SYMBOL(remove_arg_zero);
 
+static void bprm_close_file(struct linux_binprm *bprm)
+{
+	if (bprm->mm) {
+		acct_arg_size(bprm, 0);
+		mmput(bprm->mm);
+		bprm->mm = NULL;
+	}
+
+	if (bprm->file) {
+		allow_write_access(bprm->file);
+		fput(bprm->file);
+		bprm->file = NULL;
+	}
+}
+
+static int init_bprm(struct linux_binprm *bprm,
+		     const char *filename,
+		     struct user_arg_ptr *argv,
+		     struct user_arg_ptr *envp)
+{
+	int retval;
+	struct file *file;
+
+	file = open_exec(filename);
+	retval = PTR_ERR(file);
+	if (IS_ERR(file))
+		return retval;
+
+	if (!bprm->file)
+		sched_exec();
+
+	bprm->file = file;
+	bprm->filename = filename;
+	bprm->interp = filename;
+
+	retval = bprm_mm_init(bprm);
+	if (retval)
+		goto err;
+
+	retval = bprm->argc = count(*argv, MAX_ARG_STRINGS);
+	if (retval < 0)
+		goto err;
+
+	retval = bprm->envc = count(*envp, MAX_ARG_STRINGS);
+	if (retval < 0)
+		goto err;
+
+	retval = prepare_binprm(bprm);
+	if (retval < 0)
+		goto err;
+
+	retval = copy_strings_kernel(1, &bprm->filename, bprm);
+	if (retval < 0)
+		goto err;
+
+	bprm->argv_orig = argv;
+	bprm->envp_orig = envp;
+	bprm->exec = bprm->p;
+	retval = copy_strings(bprm->envc, *envp, bprm);
+	if (retval < 0)
+		goto err;
+
+	retval = copy_strings(bprm->argc, *argv, bprm);
+	if (retval < 0)
+		goto err;
+
+out:
+	return retval;
+err:
+	bprm_close_file(bprm);
+	goto out;
+}
+
+
+static bool update_prev_binfmts(struct linux_binprm *bprm,
+				struct linux_binfmt *cur_fmt)
+{
+
+	if (!try_module_get(cur_fmt->module))
+		return false;
+	if (bprm->previous_binfmts[1])
+		put_binfmt(bprm->previous_binfmts[1]);
+	bprm->previous_binfmts[1] = bprm->previous_binfmts[0];
+	bprm->previous_binfmts[0] = cur_fmt;
+	return true;
+}
+
+static void put_binfmts(struct linux_binprm *bprm)
+{
+	if (bprm->previous_binfmts[1]) {
+		put_binfmt(bprm->previous_binfmts[1]);
+		bprm->previous_binfmts[1] = NULL;
+	}
+	if (bprm->previous_binfmts[0]) {
+		put_binfmt(bprm->previous_binfmts[0]);
+		bprm->previous_binfmts[0] = NULL;
+	}
+}
+
+/* Get name null-safely */
+static inline const char *binfmt_name(struct linux_binfmt *fmt)
+{
+	return fmt ? fmt->name : "NULL";
+}
+
 #define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
 /*
  * cycle the list of binary formats handler, until one recognizes the image
@@ -1393,15 +1498,38 @@ int search_binary_handler(struct linux_binprm *bprm)
 	list_for_each_entry(fmt, &formats, lh) {
 		if (!try_module_get(fmt->module))
 			continue;
+
+		if (!update_prev_binfmts(bprm, fmt))
+			continue;
+
 		read_unlock(&binfmt_lock);
+
 		bprm->recursion_depth++;
 		retval = fmt->load_binary(bprm);
 		bprm->recursion_depth--;
-		if (retval >= 0 || retval != -ENOEXEC ||
-		    bprm->mm == NULL || bprm->file == NULL) {
+		if (retval == -ELOOP
+		    && bprm->recursion_depth == 0) { /* cur, previous */
+			pr_err("Too much recursion with binfmts (0:%s, -1:%s) in file %s, skipping (base %s).\n",
+				binfmt_name(bprm->previous_binfmts[0]),
+				binfmt_name(bprm->previous_binfmts[1]),
+				bprm->filename,
+				fmt->name);
+
+			free_arg_pages(bprm);
+			if (bprm->interp != bprm->filename)
+				kfree(bprm->interp);
+			bprm_close_file(bprm);
+			if (init_bprm(bprm, bprm->filename,
+				      bprm->argv_orig, bprm->envp_orig) < 0) {
+				put_binfmt(fmt);
+				return retval;
+			}
+		} else if (retval >= 0 || retval != -ENOEXEC ||
+			bprm->mm == NULL || bprm->file == NULL) {
 			put_binfmt(fmt);
 			return retval;
 		}
+
 		read_lock(&binfmt_lock);
 		put_binfmt(fmt);
 	}
@@ -1433,9 +1561,15 @@ static int exec_binprm(struct linux_binprm *bprm)
 	rcu_read_unlock();
 
 	ret = search_binary_handler(bprm);
+	put_binfmts(bprm);
 	if (ret >= 0) {
 		trace_sched_process_exec(current, old_pid, bprm);
 		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
+		/* Successful execution, now null out the cached argv
+		 * (we don't want anyone to access it later)
+		 * */
+		bprm->argv_orig = NULL;
+		bprm->envp_orig = NULL;
 		current->did_exec = 1;
 		proc_exec_connector(current);
 
@@ -1448,6 +1582,7 @@ static int exec_binprm(struct linux_binprm *bprm)
 	return ret;
 }
 
+
 /*
  * sys_execve() executes a new program.
  */
@@ -1456,7 +1591,6 @@ static int do_execve_common(const char *filename,
 				struct user_arg_ptr envp)
 {
 	struct linux_binprm *bprm;
-	struct file *file;
 	struct files_struct *displaced;
 	bool clear_in_exec;
 	int retval;
@@ -1497,45 +1631,9 @@ static int do_execve_common(const char *filename,
 	clear_in_exec = retval;
 	current->in_execve = 1;
 
-	file = open_exec(filename);
-	retval = PTR_ERR(file);
-	if (IS_ERR(file))
-		goto out_unmark;
-
-	sched_exec();
-
-	bprm->file = file;
-	bprm->filename = filename;
-	bprm->interp = filename;
-
-	retval = bprm_mm_init(bprm);
-	if (retval)
-		goto out_file;
-
-	bprm->argc = count(argv, MAX_ARG_STRINGS);
-	if ((retval = bprm->argc) < 0)
-		goto out;
-
-	bprm->envc = count(envp, MAX_ARG_STRINGS);
-	if ((retval = bprm->envc) < 0)
-		goto out;
-
-	retval = prepare_binprm(bprm);
+	retval = init_bprm(bprm, filename, &argv, &envp);
 	if (retval < 0)
-		goto out;
-
-	retval = copy_strings_kernel(1, &bprm->filename, bprm);
-	if (retval < 0)
-		goto out;
-
-	bprm->exec = bprm->p;
-	retval = copy_strings(bprm->envc, envp, bprm);
-	if (retval < 0)
-		goto out;
-
-	retval = copy_strings(bprm->argc, argv, bprm);
-	if (retval < 0)
-		goto out;
+		goto out_unmark;
 
 	retval = exec_binprm(bprm);
 	if (retval < 0)
@@ -1551,17 +1649,7 @@ static int do_execve_common(const char *filename,
 	return retval;
 
 out:
-	if (bprm->mm) {
-		acct_arg_size(bprm, 0);
-		mmput(bprm->mm);
-	}
-
-out_file:
-	if (bprm->file) {
-		allow_write_access(bprm->file);
-		fput(bprm->file);
-	}
-
+	bprm_close_file(bprm);
 out_unmark:
 	if (clear_in_exec)
 		current->fs->in_exec = 0;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 402a74a..3451db8 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -8,6 +8,8 @@
 
 #define CORENAME_MAX_SIZE 128
 
+struct user_arg_ptr; /* Struct from fs/exec.c, for linux_binprm->argv_orig */
+
 /*
  * This structure is used to hold the arguments that are used when loading binaries.
  */
@@ -32,11 +34,14 @@ struct linux_binprm {
 	unsigned int taso:1;
 #endif
 	unsigned int recursion_depth;
+	/* current binfmt at 0 and previous binfmt at 1 */
+	struct linux_binfmt *previous_binfmts[2];
 	struct file * file;
 	struct cred *cred;	/* new credentials */
 	int unsafe;		/* how unsafe this exec is (mask of LSM_UNSAFE_*) */
 	unsigned int per_clear;	/* bits to clear in current->personality */
 	int argc, envc;
+	struct user_arg_ptr *argv_orig, *envp_orig;
 	const char * filename;	/* Name of binary as seen by procps */
 	const char * interp;	/* Name of the binary really executed. Most
 				   of the time same as filename, but could be
-- 
1.7.1

