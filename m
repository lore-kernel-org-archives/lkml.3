Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab3CHGQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:16:05 -0500
Received: from mail-gh0-f180.google.com ([209.85.160.180]:46796 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3CHGQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:16:01 -0500
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: lucas.de.marchi@gmail.com
Cc: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/7] usermodehelper: Export _exec() and _setup() functions
Date: Fri,  8 Mar 2013 03:15:08 -0300
Message-Id: <1362723313-839-3-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call_usermodehelper_setup() + call_usermodehelper_exec() need to be
called instead of call_usermodehelper_fns() when the cleanup function
needs to be called even when an ENOMEM error occurs. In this case using
call_usermodehelper_fns() the user can't distinguish if the cleanup
function was called or not.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 include/linux/kmod.h |  8 ++++++++
 kernel/kmod.c        | 56 +++++++++++++++++++++-------------------------------
 2 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 5398d58..7eebcf5 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -71,6 +71,14 @@ call_usermodehelper_fns(char *path, char **argv, char **envp, int wait,
 			int (*init)(struct subprocess_info *info, struct cred *new),
 			void (*cleanup)(struct subprocess_info *), void *data);
 
+extern struct subprocess_info *
+call_usermodehelper_setup(char *path, char **argv, char **envp, gfp_t gfp_mask,
+			  int (*init)(struct subprocess_info *info, struct cred *new),
+			  void (*cleanup)(struct subprocess_info *), void *data);
+
+extern int
+call_usermodehelper_exec(struct subprocess_info *info, int wait);
+
 static inline int
 call_usermodehelper(char *path, char **argv, char **envp, int wait)
 {
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 56dd349..b39f240 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -502,14 +502,28 @@ static void helper_unlock(void)
  * @argv: arg vector for process
  * @envp: environment for process
  * @gfp_mask: gfp mask for memory allocation
+ * @cleanup: a cleanup function
+ * @init: an init function
+ * @data: arbitrary context sensitive data
  *
  * Returns either %NULL on allocation failure, or a subprocess_info
  * structure.  This should be passed to call_usermodehelper_exec to
  * exec the process and free the structure.
+ *
+ * The init function is used to customize the helper process prior to
+ * exec.  A non-zero return code causes the process to error out, exit,
+ * and return the failure to the calling process
+ *
+ * The cleanup function is just before ethe subprocess_info is about to
+ * be freed.  This can be used for freeing the argv and envp.  The
+ * Function must be runnable in either a process context or the
+ * context in which call_usermodehelper_exec is called.
  */
-static
 struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
-						  char **envp, gfp_t gfp_mask)
+		char **envp, gfp_t gfp_mask,
+		int (*init)(struct subprocess_info *info, struct cred *new),
+		void (*cleanup)(struct subprocess_info *info),
+		void *data)
 {
 	struct subprocess_info *sub_info;
 	sub_info = kzalloc(sizeof(struct subprocess_info), gfp_mask);
@@ -520,38 +534,15 @@ struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
 	sub_info->path = path;
 	sub_info->argv = argv;
 	sub_info->envp = envp;
+
+	sub_info->cleanup = cleanup;
+	sub_info->init = init;
+	sub_info->data = data;
   out:
 	return sub_info;
 }
 
 /**
- * call_usermodehelper_setfns - set a cleanup/init function
- * @info: a subprocess_info returned by call_usermodehelper_setup
- * @cleanup: a cleanup function
- * @init: an init function
- * @data: arbitrary context sensitive data
- *
- * The init function is used to customize the helper process prior to
- * exec.  A non-zero return code causes the process to error out, exit,
- * and return the failure to the calling process
- *
- * The cleanup function is just before ethe subprocess_info is about to
- * be freed.  This can be used for freeing the argv and envp.  The
- * Function must be runnable in either a process context or the
- * context in which call_usermodehelper_exec is called.
- */
-static
-void call_usermodehelper_setfns(struct subprocess_info *info,
-		    int (*init)(struct subprocess_info *info, struct cred *new),
-		    void (*cleanup)(struct subprocess_info *info),
-		    void *data)
-{
-	info->cleanup = cleanup;
-	info->init = init;
-	info->data = data;
-}
-
-/**
  * call_usermodehelper_exec - start a usermode application
  * @sub_info: information about the subprocessa
  * @wait: wait for the application to finish and return status.
@@ -563,7 +554,6 @@ void call_usermodehelper_setfns(struct subprocess_info *info,
  * asynchronously if wait is not set, and runs as a child of keventd.
  * (ie. it runs with full root capabilities).
  */
-static
 int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
@@ -615,6 +605,7 @@ unlock:
 	helper_unlock();
 	return retval;
 }
+EXPORT_SYMBOL(call_usermodehelper_exec);
 
 /*
  * call_usermodehelper_fns() will not run the caller-provided cleanup function
@@ -630,13 +621,12 @@ int call_usermodehelper_fns(
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
-	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
+	info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
+					 init, cleanup, data);
 
 	if (info == NULL)
 		return -ENOMEM;
 
-	call_usermodehelper_setfns(info, init, cleanup, data);
-
 	return call_usermodehelper_exec(info, wait);
 }
 EXPORT_SYMBOL(call_usermodehelper_fns);
-- 
1.8.1.5

