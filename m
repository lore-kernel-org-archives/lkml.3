Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab3APQG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:06:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36355 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454Ab3APQGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:06:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, halfdog <me@halfdog.net>,
        P J P <ppandit@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 139/222] exec: do not leave bprm->interp on stack
Date: Wed, 16 Jan 2013 13:55:39 -0200
Message-Id: <1358351822-7675-140-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/binfmt_misc.c        |    5 ++++-
 fs/binfmt_script.c      |    4 +++-
 fs/exec.c               |   15 +++++++++++++++
 include/linux/binfmts.h |    1 +
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 790b3cd..772428d 100644
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
index d3b8c1f..df49d48 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -82,7 +82,9 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
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
index 8726a93..5ee73d2 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1202,9 +1202,24 @@ void free_bprm(struct linux_binprm *bprm)
 		mutex_unlock(&current->signal->cred_guard_mutex);
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
index 366422b..eb53e15 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -128,6 +128,7 @@ extern int setup_arg_pages(struct linux_binprm * bprm,
 			   unsigned long stack_top,
 			   int executable_stack);
 extern int bprm_mm_init(struct linux_binprm *bprm);
+extern int bprm_change_interp(char *interp, struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc, const char *const *argv,
 			       struct linux_binprm *bprm);
 extern int prepare_bprm_creds(struct linux_binprm *bprm);
-- 
1.7.9.5

