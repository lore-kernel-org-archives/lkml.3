Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaH2USp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:18:45 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:50610 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaH2USl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:18:41 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/4] kernel/param: Consolidate __{start,stop}___param[] in <linux/moduleparam.h>
Date: Fri, 29 Aug 2014 22:18:36 +0200
Message-Id: <1409343516-5132-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409343516-5132-1-git-send-email-geert@linux-m68k.org>
References: <1409343516-5132-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the various external const and non-const declarations of
__start___param[] and __stop___param in <linux/moduleparam.h>.
This requires making a few struct kernel_param pointers in kernel/params.c
const.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/moduleparam.h | 2 ++
 init/main.c                 | 2 --
 kernel/params.c             | 7 +++----
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 494f99e852da..af582591e05a 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -68,6 +68,8 @@ struct kernel_param {
 	};
 };
 
+extern const struct kernel_param __start___param[], __stop___param[];
+
 /* Special one for strings we want to copy into */
 struct kparam_string {
 	unsigned int maxlen;
diff --git a/init/main.c b/init/main.c
index bb1aed928f21..8197dfc738bc 100644
--- a/init/main.c
+++ b/init/main.c
@@ -501,7 +501,6 @@ asmlinkage __visible void __init start_kernel(void)
 {
 	char *command_line;
 	char *after_dashes;
-	extern const struct kernel_param __start___param[], __stop___param[];
 
 	/*
 	 * Need to run as early as possible, to initialize the
@@ -843,7 +842,6 @@ static char *initcall_level_names[] __initdata = {
 
 static void __init do_initcall_level(int level)
 {
-	extern const struct kernel_param __start___param[], __stop___param[];
 	initcall_t *fn;
 
 	strcpy(initcall_command_line, saved_command_line);
diff --git a/kernel/params.c b/kernel/params.c
index 34f527023794..27c0320fae36 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -19,6 +19,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/slab.h>
@@ -503,8 +504,6 @@ EXPORT_SYMBOL(param_ops_string);
 #define to_module_attr(n) container_of(n, struct module_attribute, attr)
 #define to_module_kobject(n) container_of(n, struct module_kobject, kobj)
 
-extern struct kernel_param __start___param[], __stop___param[];
-
 struct param_attribute
 {
 	struct module_attribute mattr;
@@ -763,7 +762,7 @@ static struct module_kobject * __init locate_module_kobject(const char *name)
 }
 
 static void __init kernel_add_sysfs_param(const char *name,
-					  struct kernel_param *kparam,
+					  const struct kernel_param *kparam,
 					  unsigned int name_skip)
 {
 	struct module_kobject *mk;
@@ -798,7 +797,7 @@ static void __init kernel_add_sysfs_param(const char *name,
  */
 static void __init param_sysfs_builtin(void)
 {
-	struct kernel_param *kp;
+	const struct kernel_param *kp;
 	unsigned int name_len;
 	char modname[MODULE_NAME_LEN];
 
-- 
1.9.1

