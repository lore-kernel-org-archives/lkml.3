Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340AbaEFIDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:03:21 -0400
Received: from relay.parallels.com ([195.214.232.42]:52257 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934069AbaEFIDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:03:18 -0400
Message-ID: <1399363388.3718.59.camel@tkhai>
Subject: [PATCH] kmod: Pass usermodehelper "-b" to use blacklist commands
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        <tkhai@yandex.ru>
Date: Tue, 6 May 2014 12:03:08 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User may want to prohibit autoloading of some modules,
which happens when someone in kernel calls request_module().
    
For comparison, udev considers blacklist even if corresponding
hardware presents in the system. In-kernel request_module()
functionality is rather similar to udev's, so user may want
to disallow it too.
    
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/kmod.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 0ac67a5..68a4ca4 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -71,7 +71,7 @@ char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
 
 static void free_modprobe_argv(struct subprocess_info *info)
 {
-	kfree(info->argv[3]); /* check call_modprobe() */
+	kfree(info->argv[4]); /* check call_modprobe() */
 	kfree(info->argv);
 }
 
@@ -85,7 +85,7 @@ static int call_modprobe(char *module_name, int wait)
 		NULL
 	};
 
-	char **argv = kmalloc(sizeof(char *[5]), GFP_KERNEL);
+	char **argv = kmalloc(sizeof(char *[6]), GFP_KERNEL);
 	if (!argv)
 		goto out;
 
@@ -95,9 +95,10 @@ static int call_modprobe(char *module_name, int wait)
 
 	argv[0] = modprobe_path;
 	argv[1] = "-q";
-	argv[2] = "--";
-	argv[3] = module_name;	/* check free_modprobe_argv() */
-	argv[4] = NULL;
+	argv[2] = "-b";
+	argv[3] = "--";
+	argv[4] = module_name;	/* check free_modprobe_argv() */
+	argv[5] = NULL;
 
 	info = call_usermodehelper_setup(modprobe_path, argv, envp, GFP_KERNEL,
 					 NULL, free_modprobe_argv, NULL);


