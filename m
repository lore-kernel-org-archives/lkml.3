Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab3CNKhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:37:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51926 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab3CNKhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, halfdog <me@halfdog.net>,
        P J P <ppandit@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 42/88] exec: use -ELOOP for max recursion depth
Date: Thu, 14 Mar 2013 10:35:35 +0000
Message-Id: <1363257381-15900-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

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
[ luis: backport to 3.5 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/binfmt_em86.c        |  1 -
 fs/binfmt_misc.c        |  8 +-------
 fs/binfmt_script.c      |  4 +---
 fs/exec.c               | 10 +++++-----
 include/linux/binfmts.h |  2 --
 5 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/fs/binfmt_em86.c b/fs/binfmt_em86.c
index 2790c7e..575796a 100644
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
index 772428d..233dcb4 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -117,10 +117,6 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	if (!enabled)
 		goto _ret;
 
-	retval = -ENOEXEC;
-	if (bprm->recursion_depth > BINPRM_MAX_RECURSION)
-		goto _ret;
-
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
@@ -200,9 +196,7 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	if (retval < 0)
 		goto _error;
 
-	bprm->recursion_depth++;
-
-	retval = search_binary_handler (bprm, regs);
+	retval = search_binary_handler(bprm, regs);
 	if (retval < 0)
 		goto _error;
 
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index df49d48..8ae4be1 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -22,15 +22,13 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
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
index 5ee73d2..858423a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1398,6 +1398,10 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	struct linux_binfmt *fmt;
 	pid_t old_pid, old_vpid;
 
+	/* This allows 4 levels of binfmt rewrites before failing hard. */
+	if (depth > 5)
+		return -ELOOP;
+
 	retval = security_bprm_check(bprm);
 	if (retval)
 		return retval;
@@ -1422,12 +1426,8 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
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
 				if (depth == 0) {
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index eb53e15..5bab59b 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -68,8 +68,6 @@ struct linux_binprm {
 #define BINPRM_FLAGS_EXECFD_BIT 1
 #define BINPRM_FLAGS_EXECFD (1 << BINPRM_FLAGS_EXECFD_BIT)
 
-#define BINPRM_MAX_RECURSION 4
-
 /* Function parameter for binfmt->coredump */
 struct coredump_params {
 	long signr;
-- 
1.8.1.2

