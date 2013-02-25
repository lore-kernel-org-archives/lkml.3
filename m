Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab3BYOd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:33:27 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:47736 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab3BYOdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:33:22 -0500
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2013 09:33:22 EST
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH] usermodehelper: Fix -ENOMEM return logic
Date: Mon, 25 Feb 2013 11:25:50 -0300
Message-Id: <1361802350-9299-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Callers of call_usermodehelper_fns() should check the return value and
free themselves the data passed if the return is -ENOMEM. This is
because the subprocess_info is allocated in this function, and if the
allocation fail, the cleanup function cannot be called.

However call_usermodehelper_exec() may also return -ENOMEM, in which
case the cleanup function is called. This means that if the caller
checked the return code, it was risking running the cleanup twice (like
kernel/sys.c:orderly_poweroff()) and if not, a leak could happen.

This patch fixes both call_usermodehelper_fns() to never call the
cleanup function in case retval == -ENOMEM and also the callers to
actually check the return value of this function.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 kernel/kmod.c               |  9 +++++++--
 security/keys/request_key.c | 10 +++++++---
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 56dd349..c4fec52 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -77,6 +77,7 @@ static void free_modprobe_argv(struct subprocess_info *info)
 
 static int call_modprobe(char *module_name, int wait)
 {
+	int ret;
 	static char *envp[] = {
 		"HOME=/",
 		"TERM=linux",
@@ -98,8 +99,12 @@ static int call_modprobe(char *module_name, int wait)
 	argv[3] = module_name;	/* check free_modprobe_argv() */
 	argv[4] = NULL;
 
-	return call_usermodehelper_fns(modprobe_path, argv, envp,
+	ret = call_usermodehelper_fns(modprobe_path, argv, envp,
 		wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
+	if (ret != -ENOMEM)
+		return ret;
+
+	kfree(module_name);
 free_argv:
 	kfree(argv);
 out:
@@ -249,7 +254,7 @@ static int call_helper(void *data)
 
 static void call_usermodehelper_freeinfo(struct subprocess_info *info)
 {
-	if (info->cleanup)
+	if (info->cleanup && info->retval != -ENOMEM)
 		(*info->cleanup)(info);
 	kfree(info);
 }
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 4bd6bdb..22dc7a4 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -93,9 +93,13 @@ static void umh_keys_cleanup(struct subprocess_info *info)
 static int call_usermodehelper_keys(char *path, char **argv, char **envp,
 					struct key *session_keyring, int wait)
 {
-	return call_usermodehelper_fns(path, argv, envp, wait,
-				       umh_keys_init, umh_keys_cleanup,
-				       key_get(session_keyring));
+	int ret = call_usermodehelper_fns(path, argv, envp, wait,
+					  umh_keys_init, umh_keys_cleanup,
+					  key_get(session_keyring));
+	if (ret == -ENOMEM)
+		key_put(session_keyring);
+
+	return ret;
 }
 
 /*
-- 
1.8.1.4

