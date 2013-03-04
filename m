Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab3CDERW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:17:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60816 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754823Ab3CDDmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:43 -0500
Message-Id: <20130304033722.200526197@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:36 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Kees Cook <keescook@chromium.org>,
        halfdog <me@halfdog.net>, P J P <ppandit@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [ 149/153] exec: use -ELOOP for max recursion depth
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/binfmt_em86.c        |    1 -
 fs/binfmt_misc.c        |    6 ------
 fs/binfmt_script.c      |    4 +---
 fs/exec.c               |   10 +++++-----
 include/linux/binfmts.h |    2 --
 5 files changed, 6 insertions(+), 17 deletions(-)

--- a/fs/binfmt_em86.c
+++ b/fs/binfmt_em86.c
@@ -42,7 +42,6 @@ static int load_em86(struct linux_binprm
 			return -ENOEXEC;
 	}
 
-	bprm->recursion_depth++; /* Well, the bang-shell is implicit... */
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -116,10 +116,6 @@ static int load_misc_binary(struct linux
 	if (!enabled)
 		goto _ret;
 
-	retval = -ENOEXEC;
-	if (bprm->recursion_depth > BINPRM_MAX_RECURSION)
-		goto _ret;
-
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
@@ -199,8 +195,6 @@ static int load_misc_binary(struct linux
 	if (retval < 0)
 		goto _error;
 
-	bprm->recursion_depth++;
-
 	retval = search_binary_handler (bprm, regs);
 	if (retval < 0)
 		goto _error;
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -22,15 +22,13 @@ static int load_script(struct linux_binp
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
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1385,6 +1385,10 @@ int search_binary_handler(struct linux_b
 	struct linux_binfmt *fmt;
 	pid_t old_pid;
 
+	/* This allows 4 levels of binfmt rewrites before failing hard. */
+	if (depth > 5)
+		return -ELOOP;
+
 	retval = security_bprm_check(bprm);
 	if (retval)
 		return retval;
@@ -1408,12 +1412,8 @@ int search_binary_handler(struct linux_b
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
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -67,8 +67,6 @@ struct linux_binprm {
 #define BINPRM_FLAGS_EXECFD_BIT 1
 #define BINPRM_FLAGS_EXECFD (1 << BINPRM_FLAGS_EXECFD_BIT)
 
-#define BINPRM_MAX_RECURSION 4
-
 /* Function parameter for binfmt->coredump */
 struct coredump_params {
 	long signr;


