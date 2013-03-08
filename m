Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695Ab3CHGQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:16:12 -0500
Received: from mail-gh0-f180.google.com ([209.85.160.180]:48671 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933279Ab3CHGQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:16:10 -0500
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: lucas.de.marchi@gmail.com
Cc: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/7] Split remaining calls to call_usermodehelper_fns()
Date: Fri,  8 Mar 2013 03:15:12 -0300
Message-Id: <1362723313-839-7-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the only users of call_usermodehelper_fns(). This function
suffers from not being able to determine if the cleanup is called. Even
if in this places the cleanup pointer is NULL, convert them to use the
separate call_usermodehelper_setup() + call_usermodehelper_exec()
functions so we can remove the _fns variant.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 fs/coredump.c           | 15 ++++++++++++---
 init/do_mounts_initrd.c | 11 +++++++++--
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 7dfb3b0..468b4f6 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -525,6 +525,7 @@ void do_coredump(siginfo_t *siginfo)
 	if (ispipe) {
 		int dump_count;
 		char **helper_argv;
+		struct subprocess_info *sub_info;
 
 		if (ispipe < 0) {
 			printk(KERN_WARNING "format_corename failed\n");
@@ -571,9 +572,17 @@ void do_coredump(siginfo_t *siginfo)
 			goto fail_dropcount;
 		}
 
-		retval = call_usermodehelper_fns(helper_argv[0], helper_argv,
-					NULL, UMH_WAIT_EXEC, umh_pipe_setup,
-					NULL, &cprm);
+		sub_info = call_usermodehelper_setup(helper_argv[0],
+						helper_argv, NULL, GFP_KERNEL,
+						umh_pipe_setup, NULL, &cprm);
+		if (!sub_info) {
+			printk(KERN_WARNING "%s failed to allocate memory\n",
+			       __func__);
+			argv_free(helper_argv);
+			goto fail_dropcount;
+		}
+
+		retval = call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
 		argv_free(helper_argv);
 		if (retval) {
 			printk(KERN_INFO "Core dump to %s pipe failed\n",
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index a32ec1c..747cc66 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -50,6 +50,7 @@ static int init_linuxrc(struct subprocess_info *info, struct cred *new)
 
 static void __init handle_initrd(void)
 {
+	struct subprocess_info *info;
 	static char *argv[] = { "linuxrc", NULL, };
 	extern char *envp_init[];
 	int error;
@@ -70,8 +71,14 @@ static void __init handle_initrd(void)
 	 */
 	current->flags |= PF_FREEZER_SKIP;
 
-	call_usermodehelper_fns("/linuxrc", argv, envp_init, UMH_WAIT_PROC,
-			init_linuxrc, NULL, NULL);
+	info = call_usermodehelper_setup("/linuxrc", argv, envp_init,
+					 GFP_KERNEL, init_linuxrc, NULL, NULL);
+	if (!info) {
+		printk(KERN_WARNING "%s failed to allocate memory\n",
+		       __func__);
+		return;
+	}
+	call_usermodehelper_exec(info, UMH_WAIT_PROC);
 
 	current->flags &= ~PF_FREEZER_SKIP;
 
-- 
1.8.1.5

