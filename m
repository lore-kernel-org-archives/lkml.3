Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703Ab3CHGRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:17:01 -0500
Received: from mail-gg0-f172.google.com ([209.85.161.172]:52368 "EHLO
	mail-gg0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab3CHGQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:16:04 -0500
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: lucas.de.marchi@gmail.com
Cc: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] kmod: split call to call_usermodehelper_fns()
Date: Fri,  8 Mar 2013 03:15:09 -0300
Message-Id: <1362723313-839-4-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use call_usermodehelper_setup() + call_usermodehelper_exec() instead of
calling call_usermodehelper_fns(). In case the latter returns -ENOMEM
the cleanup function may had not been called - in this case we would
not free argv and module_name.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 kernel/kmod.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index b39f240..2fd6222 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -77,6 +77,8 @@ static void free_modprobe_argv(struct subprocess_info *info)
 
 static int call_modprobe(char *module_name, int wait)
 {
+	struct subprocess_info *info;
+	gfp_t gfp_mask;
 	static char *envp[] = {
 		"HOME=/",
 		"TERM=linux",
@@ -98,8 +100,17 @@ static int call_modprobe(char *module_name, int wait)
 	argv[3] = module_name;	/* check free_modprobe_argv() */
 	argv[4] = NULL;
 
-	return call_usermodehelper_fns(modprobe_path, argv, envp,
-		wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
+	gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
+	info = call_usermodehelper_setup(modprobe_path, argv, envp,
+					 gfp_mask, NULL, free_modprobe_argv,
+					 NULL);
+	if (!info)
+		goto free_module_name;
+
+	return call_usermodehelper_exec(info, wait | UMH_KILLABLE);
+
+free_module_name:
+	kfree(module_name);
 free_argv:
 	kfree(argv);
 out:
-- 
1.8.1.5

