Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3HBXW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:22:29 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46632 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450Ab3HBXW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:22:26 -0400
From: Zach Levis <zml@linux.vnet.ibm.com>
To: akpm@linux-foundation.org, oleg@redhat.com
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dan.carpenter@oracle.com,
        Zach Levis <zml@linux.vnet.ibm.com>, Zach Levis <zach@zachsthings.com>
Subject: [PATCH v3 2/3] fs/binfmts: Better handling of binfmt loops
Date: Fri,  2 Aug 2013 16:21:42 -0700
Message-Id: <1375485703-4077-3-git-send-email-zml@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080223-7182-0000-0000-000007F478BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With these changes, when a binfmt loop is encountered,
the ELOOP will propogate back to the 0 depth. At this point the
argv and argc values will be reset to what they were originally and an
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

My (rough, but functional) test scripts for this issue are available at:
    https://gist.github.com/zml2008/6075418

Signed-off-by: Zach Levis <zach@zachsthings.com>
Signed-off-by: Zach Levis <zml@linux.vnet.ibm.com>
---
 fs/exec.c               |   28 +++++++++++++++++++++++++++-
 include/linux/binfmts.h |    7 ++++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index eb229e1..779361d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1394,14 +1394,34 @@ int search_binary_handler(struct linux_binprm *bprm)
 		if (!try_module_get(fmt->module))
 			continue;
 		read_unlock(&binfmt_lock);
+		bprm->previous_binfmts[1] = bprm->previous_binfmts[0];
+		bprm->previous_binfmts[0] = fmt;
+
 		bprm->recursion_depth++;
 		retval = fmt->load_binary(bprm);
 		bprm->recursion_depth--;
-		if (retval >= 0 || retval != -ENOEXEC ||
+		if (retval == -ELOOP && bprm->recursion_depth == 0) { /* cur, previous */
+			pr_err("Too much recursion with binfmts (0:%s, -1:%s) in file %s, skipping (base %s).\n",
+					bprm->previous_binfmts[0]->name,
+					bprm->previous_binfmts[1]->name,
+					bprm->filename,
+					fmt->name);
+
+			/* Put argv back in its place */
+			bprm->p = bprm->p_no_argv;
+
+			bprm->argc = count(*(bprm->argv_orig), MAX_ARG_STRINGS);
+			retval = copy_strings(bprm->argc, *(bprm->argv_orig), bprm);
+			if (retval < 0)
+				return retval;
+
+			retval = -ENOEXEC;
+		} else if (retval >= 0 || retval != -ENOEXEC ||
 		    bprm->mm == NULL || bprm->file == NULL) {
 			put_binfmt(fmt);
 			return retval;
 		}
+
 		read_lock(&binfmt_lock);
 		put_binfmt(fmt);
 	}
@@ -1436,6 +1456,10 @@ static int exec_binprm(struct linux_binprm *bprm)
 	if (ret >= 0) {
 		trace_sched_process_exec(current, old_pid, bprm);
 		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
+		/* Successful execution, now null out the cached argv
+		 * (we don't want to access it later)
+		 * */
+		bprm->argv_orig = NULL;
 		current->did_exec = 1;
 		proc_exec_connector(current);
 
@@ -1533,9 +1557,11 @@ static int do_execve_common(const char *filename,
 	if (retval < 0)
 		goto out;
 
+	bprm->p_no_argv = bprm->p;
 	retval = copy_strings(bprm->argc, argv, bprm);
 	if (retval < 0)
 		goto out;
+	bprm->argv_orig = &argv;
 
 	retval = exec_binprm(bprm);
 	if (retval < 0)
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 402a74a..42c1656 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -8,6 +8,8 @@
 
 #define CORENAME_MAX_SIZE 128
 
+struct user_arg_ptr; /* Struct from fs/exec.c, for linux_binprm->argv_orig */
+
 /*
  * This structure is used to hold the arguments that are used when loading binaries.
  */
@@ -21,7 +23,7 @@ struct linux_binprm {
 	struct page *page[MAX_ARG_PAGES];
 #endif
 	struct mm_struct *mm;
-	unsigned long p; /* current top of mem */
+	unsigned long p, p_no_argv; /* current top of mem */
 	unsigned int
 		cred_prepared:1,/* true if creds already prepared (multiple
 				 * preps happen for interpreters) */
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
+	struct user_arg_ptr *argv_orig;
 	const char * filename;	/* Name of binary as seen by procps */
 	const char * interp;	/* Name of the binary really executed. Most
 				   of the time same as filename, but could be
-- 
1.7.1

