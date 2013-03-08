Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3CHGVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:21:45 -0500
Received: from mail-gg0-f171.google.com ([209.85.161.171]:43048 "EHLO
	mail-gg0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3CHGVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:21:43 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Mar 2013 01:21:43 EST
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: lucas.de.marchi@gmail.com
Cc: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] kmod: remove call_usermodehelper_fns()
Date: Fri,  8 Mar 2013 03:15:13 -0300
Message-Id: <1362723313-839-8-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function suffers from not being able to determine if the cleanup is
called in case it returns -ENOMEM. Nobody is using it anymore, so let's
remove it.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 include/linux/kmod.h | 11 +----------
 kernel/kmod.c        | 31 +++++++++++++++++--------------
 2 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 7eebcf5..0555cc6 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -67,9 +67,7 @@ struct subprocess_info {
 };
 
 extern int
-call_usermodehelper_fns(char *path, char **argv, char **envp, int wait,
-			int (*init)(struct subprocess_info *info, struct cred *new),
-			void (*cleanup)(struct subprocess_info *), void *data);
+call_usermodehelper(char *path, char **argv, char **envp, int wait);
 
 extern struct subprocess_info *
 call_usermodehelper_setup(char *path, char **argv, char **envp, gfp_t gfp_mask,
@@ -79,13 +77,6 @@ call_usermodehelper_setup(char *path, char **argv, char **envp, gfp_t gfp_mask,
 extern int
 call_usermodehelper_exec(struct subprocess_info *info, int wait);
 
-static inline int
-call_usermodehelper(char *path, char **argv, char **envp, int wait)
-{
-	return call_usermodehelper_fns(path, argv, envp, wait,
-				       NULL, NULL, NULL);
-}
-
 extern struct ctl_table usermodehelper_table[];
 
 enum umh_disable_depth {
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 2fd6222..eebb63c 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -557,8 +557,8 @@ struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
  * call_usermodehelper_exec - start a usermode application
  * @sub_info: information about the subprocessa
  * @wait: wait for the application to finish and return status.
- *        when -1 don't wait at all, but you get no useful error back when
- *        the program couldn't be exec'ed. This makes it safe to call
+ *        when UMH_NO_WAIT don't wait at all, but you get no useful error back
+ *        when the program couldn't be exec'ed. This makes it safe to call
  *        from interrupt context.
  *
  * Runs a user-space application.  The application is started
@@ -618,29 +618,32 @@ unlock:
 }
 EXPORT_SYMBOL(call_usermodehelper_exec);
 
-/*
- * call_usermodehelper_fns() will not run the caller-provided cleanup function
- * if a memory allocation failure is experienced.  So the caller might need to
- * check the call_usermodehelper_fns() return value: if it is -ENOMEM, perform
- * the necessaary cleanup within the caller.
+/**
+ * call_usermodehelper() - prepare and start a usermode application
+ * @path: path to usermode executable
+ * @argv: arg vector for process
+ * @envp: environment for process
+ * @wait: wait for the application to finish and return status.
+ *        when UMH_NO_WAIT don't wait at all, but you get no useful error back
+ *        when the program couldn't be exec'ed. This makes it safe to call
+ *        from interrupt context.
+ *
+ * This function is the equivalent to use call_usermodehelper_setup() and
+ * call_usermodehelper_exec().
  */
-int call_usermodehelper_fns(
-	char *path, char **argv, char **envp, int wait,
-	int (*init)(struct subprocess_info *info, struct cred *new),
-	void (*cleanup)(struct subprocess_info *), void *data)
+int call_usermodehelper(char *path, char **argv, char **envp, int wait)
 {
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
 	info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
-					 init, cleanup, data);
-
+					 NULL, NULL, NULL);
 	if (info == NULL)
 		return -ENOMEM;
 
 	return call_usermodehelper_exec(info, wait);
 }
-EXPORT_SYMBOL(call_usermodehelper_fns);
+EXPORT_SYMBOL(call_usermodehelper);
 
 static int proc_cap_handler(struct ctl_table *table, int write,
 			 void __user *buffer, size_t *lenp, loff_t *ppos)
-- 
1.8.1.5

