Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaBIVtI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 16:49:08 -0500
Received: from smtp.outflux.net ([198.145.64.163]:59764 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaBIVtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 16:49:05 -0500
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        keescook@chromium.org
Subject: [PATCH 1/3] lkdtm: convert to using pr_* for reports
Date: Sun,  9 Feb 2014 13:48:46 -0800
Message-Id: <1391982528-21083-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391982528-21083-1-git-send-email-keescook@chromium.org>
References: <1391982528-21083-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move to using pr_* calls instead of printk calls for reporting.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 49c7a23f02fc..e910b3c5331c 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -30,6 +30,7 @@
  *
  * See Documentation/fault-injection/provoke-crashes.txt for instructions
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -493,8 +494,8 @@ static void lkdtm_handler(void)
 
 	spin_lock_irqsave(&count_lock, flags);
 	count--;
-	printk(KERN_INFO "lkdtm: Crash point %s of type %s hit, trigger in %d rounds\n",
-			cp_name_to_str(cpoint), cp_type_to_str(cptype), count);
+	pr_info("Crash point %s of type %s hit, trigger in %d rounds\n",
+		cp_name_to_str(cpoint), cp_type_to_str(cptype), count);
 
 	if (count == 0) {
 		do_it = true;
@@ -551,18 +552,18 @@ static int lkdtm_register_cpoint(enum cname which)
 		lkdtm.kp.symbol_name = "generic_ide_ioctl";
 		lkdtm.entry = (kprobe_opcode_t*) jp_generic_ide_ioctl;
 #else
-		printk(KERN_INFO "lkdtm: Crash point not available\n");
+		pr_info("Crash point not available\n");
 		return -EINVAL;
 #endif
 		break;
 	default:
-		printk(KERN_INFO "lkdtm: Invalid Crash Point\n");
+		pr_info("Invalid Crash Point\n");
 		return -EINVAL;
 	}
 
 	cpoint = which;
 	if ((ret = register_jprobe(&lkdtm)) < 0) {
-		printk(KERN_INFO "lkdtm: Couldn't register jprobe\n");
+		pr_info("Couldn't register jprobe\n");
 		cpoint = CN_INVALID;
 	}
 
@@ -709,8 +710,7 @@ static ssize_t direct_entry(struct file *f, const char __user *user_buf,
 	if (type == CT_NONE)
 		return -EINVAL;
 
-	printk(KERN_INFO "lkdtm: Performing direct entry %s\n",
-			cp_type_to_str(type));
+	pr_info("Performing direct entry %s\n", cp_type_to_str(type));
 	lkdtm_do_action(type);
 	*off += count;
 
@@ -772,7 +772,7 @@ static int __init lkdtm_module_init(void)
 	/* Register debugfs interface */
 	lkdtm_debugfs_root = debugfs_create_dir("provoke-crash", NULL);
 	if (!lkdtm_debugfs_root) {
-		printk(KERN_ERR "lkdtm: creating root dir failed\n");
+		pr_err("creating root dir failed\n");
 		return -ENODEV;
 	}
 
@@ -787,28 +787,26 @@ static int __init lkdtm_module_init(void)
 		de = debugfs_create_file(cur->name, 0644, lkdtm_debugfs_root,
 				NULL, &cur->fops);
 		if (de == NULL) {
-			printk(KERN_ERR "lkdtm: could not create %s\n",
-					cur->name);
+			pr_err("could not create %s\n", cur->name);
 			goto out_err;
 		}
 	}
 
 	if (lkdtm_parse_commandline() == -EINVAL) {
-		printk(KERN_INFO "lkdtm: Invalid command\n");
+		pr_info("Invalid command\n");
 		goto out_err;
 	}
 
 	if (cpoint != CN_INVALID && cptype != CT_NONE) {
 		ret = lkdtm_register_cpoint(cpoint);
 		if (ret < 0) {
-			printk(KERN_INFO "lkdtm: Invalid crash point %d\n",
-					cpoint);
+			pr_info("Invalid crash point %d\n", cpoint);
 			goto out_err;
 		}
-		printk(KERN_INFO "lkdtm: Crash point %s of type %s registered\n",
-				cpoint_name, cpoint_type);
+		pr_info("Crash point %s of type %s registered\n",
+			cpoint_name, cpoint_type);
 	} else {
-		printk(KERN_INFO "lkdtm: No crash points registered, enable through debugfs\n");
+		pr_info("No crash points registered, enable through debugfs\n");
 	}
 
 	return 0;
@@ -823,7 +821,7 @@ static void __exit lkdtm_module_exit(void)
 	debugfs_remove_recursive(lkdtm_debugfs_root);
 
 	unregister_jprobe(&lkdtm);
-	printk(KERN_INFO "lkdtm: Crash point unregistered\n");
+	pr_info("Crash point unregistered\n");
 }
 
 module_init(lkdtm_module_init);
-- 
1.7.9.5

