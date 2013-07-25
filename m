Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab3GYQLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:11:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49408 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab3GYQLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:11:50 -0400
From: Zach Levis <zml@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, Zach Levis <zml@linux.vnet.ibm.com>,
        Zach Levis <zach@zachsthings.com>
Subject: [PATCH 2/3] fs/binfmts: Better handling of binfmt loops
Date: Thu, 25 Jul 2013 08:40:44 -0700
Message-Id: <1374766845-13565-2-git-send-email-zml@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072515-7282-0000-0000-000019A08575
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With these changes, when a binfmt loop is encountered,
the ELOOP will propogate back to the 0 depth. At this point the
argv and argc values will be reset to what they were originally and an
attempt is made to continue with the following binfmt handlers.

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
 fs/exec.c               |   30 +++++++++++++++++++++++++++++-
 include/linux/binfmts.h |    5 ++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ffd7a81..fa59f05 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1401,13 +1401,40 @@ int search_binary_handler(struct linux_binprm *bprm)
 			if (!try_module_get(fmt->module))
 				continue;
 			read_unlock(&binfmt_lock);
+			bprm->previous_binfmts[1] = bprm->previous_binfmts[0];
+			bprm->previous_binfmts[0] = fmt;
+
 			bprm->recursion_depth = depth + 1;
 			retval = fn(bprm);
 			bprm->recursion_depth = depth;
+			if (retval == -ELOOP && depth == 0) { /* cur, previous */
+				pr_err("Too much recursion with binfmts (0:%s, -1:%s) in file %s, skipping (base %s).\n",
+						bprm->previous_binfmts[0]->name,
+						bprm->previous_binfmts[1]->name,
+						bprm->filename,
+						fmt->name);
+
+				/* Put argv back in its place */
+				while (bprm->argc > 0) {
+					retval = remove_arg_zero(bprm);
+					if (retval)
+						return retval;
+				}
+
+				copy_strings(bprm->argc_orig, *((struct user_arg_ptr *) bprm->argv_orig), bprm);
+				bprm->argc = bprm->argc_orig;
+				retval = -ENOEXEC;
+				continue;
+			}
+
 			if (retval >= 0) {
 				if (depth == 0) {
 					trace_sched_process_exec(current, old_pid, bprm);
 					ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
+					/* Successful execution, now null out the cached argv
+					 * (we don't want to access it later)
+					 * */
+					bprm->argv_orig = NULL;
 				}
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
@@ -1515,7 +1542,7 @@ static int do_execve_common(const char *filename,
 	if (retval)
 		goto out_file;
 
-	bprm->argc = count(argv, MAX_ARG_STRINGS);
+	bprm->argc_orig = bprm->argc = count(argv, MAX_ARG_STRINGS);
 	if ((retval = bprm->argc) < 0)
 		goto out;
 
@@ -1539,6 +1566,7 @@ static int do_execve_common(const char *filename,
 	retval = copy_strings(bprm->argc, argv, bprm);
 	if (retval < 0)
 		goto out;
+	bprm->argv_orig = &argv;
 
 	retval = search_binary_handler(bprm);
 	if (retval < 0)
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 402a74a..2e3dc66 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -32,11 +32,14 @@ struct linux_binprm {
 	unsigned int taso:1;
 #endif
 	unsigned int recursion_depth;
+	/* current binfmt at 0 and previous binfmt at 1 */
+	struct linux_binfmt *previous_binfmts[2];
 	struct file * file;
 	struct cred *cred;	/* new credentials */
 	int unsafe;		/* how unsafe this exec is (mask of LSM_UNSAFE_*) */
 	unsigned int per_clear;	/* bits to clear in current->personality */
-	int argc, envc;
+	int argc, argc_orig, envc;
+	void *argv_orig;
 	const char * filename;	/* Name of binary as seen by procps */
 	const char * interp;	/* Name of the binary really executed. Most
 				   of the time same as filename, but could be
-- 
1.7.1

