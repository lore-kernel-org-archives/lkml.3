Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3CLArh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:47:37 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:52073 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab3CLArf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:47:35 -0400
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lucas.de.marchi@gmail.com, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH v3 3/7] kmod: split call to call_usermodehelper_fns()
Date: Mon, 11 Mar 2013 21:48:07 -0300
Message-Id: <1363049291-946-3-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363049291-946-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <1363049291-946-1-git-send-email-lucas.demarchi@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use call_usermodehelper_setup() + call_usermodehelper_exec() instead of
calling call_usermodehelper_fns(). In case the latter returns -ENOMEM
the cleanup function may had not been called - in this case we would
not free argv and module_name.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---

Changes from v2: remove check for wait == UMH_NO_WAIT since this never happens,
	as pointed out by Oleg

 kernel/kmod.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index b39f240..ae255a3 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -77,6 +77,7 @@ static void free_modprobe_argv(struct subprocess_info *info)
 
 static int call_modprobe(char *module_name, int wait)
 {
+	struct subprocess_info *info;
 	static char *envp[] = {
 		"HOME=/",
 		"TERM=linux",
@@ -98,8 +99,15 @@ static int call_modprobe(char *module_name, int wait)
 	argv[3] = module_name;	/* check free_modprobe_argv() */
 	argv[4] = NULL;
 
-	return call_usermodehelper_fns(modprobe_path, argv, envp,
-		wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
+	info = call_usermodehelper_setup(modprobe_path, argv, envp, GFP_KERNEL,
+					 NULL, free_modprobe_argv, NULL);
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

