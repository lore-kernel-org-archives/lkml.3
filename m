Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038Ab3EJEQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 00:16:03 -0400
Received: from mail-gh0-f173.google.com ([209.85.160.173]:50735 "EHLO
	mail-gh0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3EJEPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 00:15:54 -0400
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] kmod: Use argv_split(), passing module as extra param
Date: Fri, 10 May 2013 01:15:15 -0300
Message-Id: <1368159316-31744-2-git-send-email-lucas.de.marchi@gmail.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com>
References: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that argv_split() leaves room for extra parameter, make
call_modprobe() use it.

Signed-off-by: Lucas De Marchi <lucas.de.marchi@gmail.com>
---
 kernel/kmod.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 166aff5..70df90b 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -67,12 +67,12 @@ static DECLARE_RWSEM(umhelper_sem);
 /*
 	modprobe_path is set via /proc/sys.
 */
-char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
+char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe -q --";
 
 static void free_modprobe_argv(struct subprocess_info *info)
 {
 	kfree(info->argv[3]); /* check call_modprobe() */
-	kfree(info->argv);
+	argv_free(info->argv);
 }
 
 static int call_modprobe(char *module_name, int wait)
@@ -84,8 +84,10 @@ static int call_modprobe(char *module_name, int wait)
 		"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
 		NULL
 	};
+	int argc;
+	char **argv;
 
-	char **argv = kmalloc(sizeof(char *[5]), GFP_KERNEL);
+	argv = argv_split(GFP_KERNEL, modprobe_path, &argc, 1);
 	if (!argv)
 		goto out;
 
@@ -93,13 +95,8 @@ static int call_modprobe(char *module_name, int wait)
 	if (!module_name)
 		goto free_argv;
 
-	argv[0] = modprobe_path;
-	argv[1] = "-q";
-	argv[2] = "--";
-	argv[3] = module_name;	/* check free_modprobe_argv() */
-	argv[4] = NULL;
-
-	info = call_usermodehelper_setup(modprobe_path, argv, envp, GFP_KERNEL,
+	argv[argc] = module_name;	/* check free_modprobe_argv() */
+	info = call_usermodehelper_setup(argv[0], argv, envp, GFP_KERNEL,
 					 NULL, free_modprobe_argv, NULL);
 	if (!info)
 		goto free_module_name;
@@ -109,7 +106,7 @@ static int call_modprobe(char *module_name, int wait)
 free_module_name:
 	kfree(module_name);
 free_argv:
-	kfree(argv);
+	argv_free(argv);
 out:
 	return -ENOMEM;
 }
-- 
1.8.2.2

