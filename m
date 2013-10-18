Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab3JROL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:11:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56813 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754244Ab3JROL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:11:58 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
        janne.karhunen@gmail.com, geert@linux-m68k.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH v3] init: make init failures more explicit
Date: Fri, 18 Oct 2013 16:11:45 +0200
Message-Id: <1382105505-13730-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to make init failures more explicit.

Before this, the "No init found" message didn't help much.
It could sometimes be misleading and actually mean
"No *working* init found".

This message could hide many different issues:
- no init program candidates found at all
- some init program candidates exist but can't be executed
  (missing execute permissions, failed to load shared libraries,
  executable compiled for an unknown architecture...)

This patch notifies the kernel user when a candidate init program is
found but can't be executed. In each failure situation, the error code
is displayed, to quickly find the root cause. "No init found" is also
replaced by "No working init found", which is more correct.

This will help embedded Linux developers (especially the new comers),
regularly making and debugging new root filesystems.

Credits to Geert Uytterhoeven and Janne Karhunen for their improvement
suggestions.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 init/main.c | 39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/init/main.c b/init/main.c
index 63d3e8f..4ba3b33 100644
--- a/init/main.c
+++ b/init/main.c
@@ -811,10 +811,26 @@ static int run_init_process(const char *init_filename)
 		(const char __user *const __user *)envp_init);
 }
 
+static int try_to_run_init_process(const char *init_filename)
+{
+	int ret;
+
+	ret = run_init_process(init_filename);
+
+	if (ret && ret != -ENOENT) {
+		pr_err("Starting init: %s exists but couldn't execute it (error %d)\n",
+		       init_filename, ret);
+	}
+
+	return ret;
+}
+
 static noinline void __init kernel_init_freeable(void);
 
 static int __ref kernel_init(void *unused)
 {
+	int ret;
+
 	kernel_init_freeable();
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
@@ -826,9 +842,11 @@ static int __ref kernel_init(void *unused)
 	flush_delayed_fput();
 
 	if (ramdisk_execute_command) {
-		if (!run_init_process(ramdisk_execute_command))
+		ret = run_init_process(ramdisk_execute_command);
+		if (!ret)
 			return 0;
-		pr_err("Failed to execute %s\n", ramdisk_execute_command);
+		pr_err("Failed to execute %s (error %d)\n",
+		       ramdisk_execute_command, ret);
 	}
 
 	/*
@@ -838,18 +856,19 @@ static int __ref kernel_init(void *unused)
 	 * trying to recover a really broken machine.
 	 */
 	if (execute_command) {
-		if (!run_init_process(execute_command))
+		ret = run_init_process(execute_command);
+		if (!ret)
 			return 0;
-		pr_err("Failed to execute %s.  Attempting defaults...\n",
-			execute_command);
+		pr_err("Failed to execute %s (error %d).  Attempting defaults...\n",
+			execute_command, ret);
 	}
-	if (!run_init_process("/sbin/init") ||
-	    !run_init_process("/etc/init") ||
-	    !run_init_process("/bin/init") ||
-	    !run_init_process("/bin/sh"))
+	if (!try_to_run_init_process("/sbin/init") ||
+	    !try_to_run_init_process("/etc/init") ||
+	    !try_to_run_init_process("/bin/init") ||
+	    !try_to_run_init_process("/bin/sh"))
 		return 0;
 
-	panic("No init found.  Try passing init= option to kernel. "
+	panic("No working init found.  Try passing init= option to kernel. "
 	      "See Linux Documentation/init.txt for guidance.");
 }
 
-- 
1.8.1.2

