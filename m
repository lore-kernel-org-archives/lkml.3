Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbaBEUzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:55:44 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48190 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbaBEUFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:45 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kees Cook <keescook@chromium.org>, halfdog <me@halfdog.net>,
        P J P <ppandit@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 086/213] exec: use -ELOOP for max recursion depth
Date: Wed, 5 Feb 2014 15:00:41 -0500
Message-ID: <1391630568-49251-87-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d740269867021faf4ce38a449353d2b986c34a67 upstream.

To avoid an explosion of request_module calls on a chain of abusive
scripts, fail maximum recursion with -ELOOP instead of -ENOEXEC. As soon
as maximum recursion depth is hit, the error will fail all the way back
up the chain, aborting immediately.

This also has the side-effect of stopping the user's shell from attempting
to reexecute the top-level file as a shell script. As seen in the
dash source:

        if (cmd != path_bshell && errno == ENOEXEC) {
                *argv-- = cmd;
                *argv = cmd = path_bshell;
                goto repeat;
        }

The above logic was designed for running scripts automatically that lacked
the "#!" header, not to re-try failed recursion. On a legitimate -ENOEXEC,
things continue to behave as the shell expects.

Additionally, when tracking recursion, the binfmt handlers should not be
involved. The recursion being tracked is the depth of calls through
search_binary_handler(), so that function should be exclusively responsible
for tracking the depth.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: halfdog <me@halfdog.net>
Cc: P J P <ppandit@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/binfmt_em86.c        |  1 -
 fs/binfmt_misc.c        |  6 ------
 fs/binfmt_script.c      |  4 +---
 fs/exec.c               | 10 +++++-----
 include/linux/binfmts.h |  2 --
 5 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/fs/binfmt_em86.c b/fs/binfmt_em86.c
index b8e8b0acf9bd..4a1b984638a3 100644
--- a/fs/binfmt_em86.c
+++ b/fs/binfmt_em86.c
@@ -42,7 +42,6 @@ static int load_em86(struct linux_binprm *bprm,struct pt_regs *regs)
 			return -ENOEXEC;
 	}
 
-	bprm->recursion_depth++; /* Well, the bang-shell is implicit... */
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index fb939976d58c..258c5ca3f534 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -116,10 +116,6 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	if (!enabled)
 		goto _ret;
 
-	retval = -ENOEXEC;
-	if (bprm->recursion_depth > BINPRM_MAX_RECURSION)
-		goto _ret;
-
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
@@ -200,8 +196,6 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	if (retval < 0)
 		goto _error;
 
-	bprm->recursion_depth++;
-
 	retval = search_binary_handler (bprm, regs);
 	if (retval < 0)
 		goto _error;
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 73d51f39c89a..65a3c1732ced 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -21,15 +21,13 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 	char interp[BINPRM_BUF_SIZE];
 	int retval;
 
-	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!') ||
-	    (bprm->recursion_depth > BINPRM_MAX_RECURSION))
+	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!'))
 		return -ENOEXEC;
 	/*
 	 * This section does the #! interpretation.
 	 * Sorta complicated, but hopefully it will work.  -TYT
 	 */
 
-	bprm->recursion_depth++;
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff --git a/fs/exec.c b/fs/exec.c
index 0ee94fe2fe37..aa3d2ec58c97 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1296,6 +1296,10 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	int try,retval;
 	struct linux_binfmt *fmt;
 
+	/* This allows 4 levels of binfmt rewrites before failing hard. */
+	if (depth > 5)
+		return -ELOOP;
+
 	retval = security_bprm_check(bprm);
 	if (retval)
 		return retval;
@@ -1314,12 +1318,8 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			if (!try_module_get(fmt->module))
 				continue;
 			read_unlock(&binfmt_lock);
+			bprm->recursion_depth = depth + 1;
 			retval = fn(bprm, regs);
-			/*
-			 * Restore the depth counter to its starting value
-			 * in this call, so we don't have to rely on every
-			 * load_binary function to restore it on return.
-			 */
 			bprm->recursion_depth = depth;
 			if (retval >= 0) {
 				if (depth == 0)
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 8e0957df83bb..d0ddba228449 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -71,8 +71,6 @@ extern struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 #define BINPRM_FLAGS_EXECFD_BIT 1
 #define BINPRM_FLAGS_EXECFD (1 << BINPRM_FLAGS_EXECFD_BIT)
 
-#define BINPRM_MAX_RECURSION 4
-
 /* Function parameter for binfmt->coredump */
 struct coredump_params {
 	long signr;
-- 
1.8.5.2

