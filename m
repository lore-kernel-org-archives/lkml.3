Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaBEUF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:05:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:54825 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaBEUFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:41 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kees Cook <keescook@chromium.org>, halfdog <me@halfdog.net>,
        P J P <ppandit@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 085/213] exec: do not leave bprm->interp on stack
Date: Wed, 5 Feb 2014 15:00:40 -0500
Message-ID: <1391630568-49251-86-git-send-email-paul.gortmaker@windriver.com>
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

commit b66c5984017533316fd1951770302649baf1aa33 upstream.

If a series of scripts are executed, each triggering module loading via
unprintable bytes in the script header, kernel stack contents can leak
into the command line.

Normally execution of binfmt_script and binfmt_misc happens recursively.
However, when modules are enabled, and unprintable bytes exist in the
bprm->buf, execution will restart after attempting to load matching
binfmt modules.  Unfortunately, the logic in binfmt_script and
binfmt_misc does not expect to get restarted.  They leave bprm->interp
pointing to their local stack.  This means on restart bprm->interp is
left pointing into unused stack memory which can then be copied into the
userspace argv areas.

After additional study, it seems that both recursion and restart remains
the desirable way to handle exec with scripts, misc, and modules.  As
such, we need to protect the changes to interp.

This changes the logic to require allocation for any changes to the
bprm->interp.  To avoid adding a new kmalloc to every exec, the default
value is left as-is.  Only when passing through binfmt_script or
binfmt_misc does an allocation take place.

For a proof of concept, see DoTest.sh from:

   http://www.halfdog.net/Security/2012/LinuxKernelBinfmtScriptStackDataDisclosure/

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: halfdog <me@halfdog.net>
Cc: P J P <ppandit@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/binfmt_misc.c        |  5 ++++-
 fs/binfmt_script.c      |  4 +++-
 fs/exec.c               | 15 +++++++++++++++
 include/linux/binfmts.h |  1 +
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 42b60b04ea06..fb939976d58c 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -176,7 +176,10 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 		goto _error;
 	bprm->argc ++;
 
-	bprm->interp = iname;	/* for binfmt_script */
+	/* Update interp in case binfmt_script needs it. */
+	retval = bprm_change_interp(iname, bprm);
+	if (retval < 0)
+		goto _error;
 
 	interp_file = open_exec (iname);
 	retval = PTR_ERR (interp_file);
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index aca9d55afb22..73d51f39c89a 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -81,7 +81,9 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 	retval = copy_strings_kernel(1, &i_name, bprm);
 	if (retval) return retval; 
 	bprm->argc++;
-	bprm->interp = interp;
+	retval = bprm_change_interp(interp, bprm);
+	if (retval < 0)
+		return retval;
 
 	/*
 	 * OK, now restart the process with the interpreter's dentry.
diff --git a/fs/exec.c b/fs/exec.c
index 4afb996086d5..0ee94fe2fe37 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1119,9 +1119,24 @@ void free_bprm(struct linux_binprm *bprm)
 		mutex_unlock(&current->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
+	/* If a binfmt changed the interp, free it. */
+	if (bprm->interp != bprm->filename)
+		kfree(bprm->interp);
 	kfree(bprm);
 }
 
+int bprm_change_interp(char *interp, struct linux_binprm *bprm)
+{
+	/* If a binfmt changed the interp, free it first. */
+	if (bprm->interp != bprm->filename)
+		kfree(bprm->interp);
+	bprm->interp = kstrdup(interp, GFP_KERNEL);
+	if (!bprm->interp)
+		return -ENOMEM;
+	return 0;
+}
+EXPORT_SYMBOL(bprm_change_interp);
+
 /*
  * install the new credentials for this executable
  */
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 074b620d5d8b..8e0957df83bb 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -131,6 +131,7 @@ extern int setup_arg_pages(struct linux_binprm * bprm,
 			   unsigned long stack_top,
 			   int executable_stack);
 extern int bprm_mm_init(struct linux_binprm *bprm);
+extern int bprm_change_interp(char *interp, struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc,char ** argv,struct linux_binprm *bprm);
 extern int prepare_bprm_creds(struct linux_binprm *bprm);
 extern void install_exec_creds(struct linux_binprm *bprm);
-- 
1.8.5.2

