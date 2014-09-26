Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaIZV52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:57:28 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37515 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040AbaIZV5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:57:25 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, tiwai@suse.de,
        tj@kernel.org, arjan@linux.intel.com
Cc: teg@jklm.no, rmilasan@suse.com, werner@suse.com, oleg@redhat.com,
        hare@suse.com, bpoirier@suse.de, santosh@chelsio.com, pmladek@suse.cz,
        dbueso@suse.com, mcgrof@suse.com, linux-kernel@vger.kernel.org,
        cocci@systeme.lip6.fr, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Hellwig <hch@infradead.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Ewan Milne <emilne@redhat.com>, Jean Delvare <jdelvare@suse.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v1 1/5] module: add extra argument for parse_params() callback
Date: Fri, 26 Sep 2014 14:57:13 -0700
Message-Id: <1411768637-6809-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411768637-6809-1-git-send-email-mcgrof@do-not-panic.com>
References: <1411768637-6809-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This adds an extra argument onto parse_params() to be used
as a way to make the unused callback a bit more useful and
generic by allowing the caller to pass on a data structure
of its choice. An example use case is to allow us to easily
make module parameters for every module which we will do
next.

@ parse @
identifier name, args, params, num, level_min, level_max;
identifier unknown, param, val, doing;
type s16;
@@
 extern char *parse_args(const char *name,
 			 char *args,
 			 const struct kernel_param *params,
 			 unsigned num,
 			 s16 level_min,
 			 s16 level_max,
+			 void *arg,
 			 int (*unknown)(char *param, char *val,
					const char *doing
+					, void *arg,
					));

@ parse_mod @
identifier name, args, params, num, level_min, level_max;
identifier unknown, param, val, doing;
type s16;
@@
 char *parse_args(const char *name,
 			 char *args,
 			 const struct kernel_param *params,
 			 unsigned num,
 			 s16 level_min,
 			 s16 level_max,
+			 void *arg,
 			 int (*unknown)(char *param, char *val,
					const char *doing
+					, void *arg,
					))
{
	...
}

@ parse_args_found @
expression R, E1, E2, E3, E4, E5, E6;
identifier func;
@@

(
	R =
	parse_args(E1, E2, E3, E4, E5, E6,
+		   NULL,
		   func);
|
	R =
	parse_args(E1, E2, E3, E4, E5, E6,
+		   NULL,
		   &func);
|
	R =
	parse_args(E1, E2, E3, E4, E5, E6,
+		   NULL,
		   NULL);
|
	parse_args(E1, E2, E3, E4, E5, E6,
+		   NULL,
		   func);
|
	parse_args(E1, E2, E3, E4, E5, E6,
+		   NULL,
		   &func);
|
	parse_args(E1, E2, E3, E4, E5, E6,
+		   NULL,
		   NULL);
)

@ parse_args_unused depends on parse_args_found @
identifier parse_args_found.func;
@@

int func(char *param, char *val, const char *unused
+		 , void *arg
		 )
{
	...
}

@ mod_unused depends on parse_args_found @
identifier parse_args_found.func;
expression A1, A2, A3;
@@

-	func(A1, A2, A3);
+	func(A1, A2, A3, NULL);

Generated-by: Coccinelle SmPL
Cc: cocci@systeme.lip6.fr
Cc: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Ewan Milne <emilne@redhat.com>
Cc: Jean Delvare <jdelvare@suse.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 arch/powerpc/mm/hugetlbpage.c |  4 ++--
 include/linux/moduleparam.h   |  3 ++-
 init/main.c                   | 25 +++++++++++++++----------
 kernel/module.c               |  6 ++++--
 kernel/params.c               | 11 +++++++----
 lib/dynamic_debug.c           |  4 ++--
 6 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 7e70ae9..f3f836e 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -333,7 +333,7 @@ int alloc_bootmem_huge_page(struct hstate *hstate)
 unsigned long gpage_npages[MMU_PAGE_COUNT];
 
 static int __init do_gpage_early_setup(char *param, char *val,
-				       const char *unused)
+				       const char *unused, void *arg)
 {
 	static phys_addr_t size;
 	unsigned long npages;
@@ -375,7 +375,7 @@ void __init reserve_hugetlb_gpages(void)
 
 	strlcpy(cmdline, boot_command_line, COMMAND_LINE_SIZE);
 	parse_args("hugetlb gpages", cmdline, NULL, 0, 0, 0,
-			&do_gpage_early_setup);
+			NULL, &do_gpage_early_setup);
 
 	/*
 	 * Walk gpage list in reverse, allocating larger page sizes first.
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 494f99e..e975628 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -327,8 +327,9 @@ extern char *parse_args(const char *name,
 		      unsigned num,
 		      s16 level_min,
 		      s16 level_max,
+		      void *arg,
 		      int (*unknown)(char *param, char *val,
-			      const char *doing));
+				     const char *doing, void *arg));
 
 /* Called by module remove. */
 #ifdef CONFIG_SYSFS
diff --git a/init/main.c b/init/main.c
index bb1aed9..32ae416 100644
--- a/init/main.c
+++ b/init/main.c
@@ -236,7 +236,8 @@ static int __init loglevel(char *str)
 early_param("loglevel", loglevel);
 
 /* Change NUL term back to "=", to make "param" the whole string. */
-static int __init repair_env_string(char *param, char *val, const char *unused)
+static int __init repair_env_string(char *param, char *val,
+				    const char *unused, void *arg)
 {
 	if (val) {
 		/* param=val or param="val"? */
@@ -253,14 +254,15 @@ static int __init repair_env_string(char *param, char *val, const char *unused)
 }
 
 /* Anything after -- gets handed straight to init. */
-static int __init set_init_arg(char *param, char *val, const char *unused)
+static int __init set_init_arg(char *param, char *val,
+			       const char *unused, void *arg)
 {
 	unsigned int i;
 
 	if (panic_later)
 		return 0;
 
-	repair_env_string(param, val, unused);
+	repair_env_string(param, val, unused, NULL);
 
 	for (i = 0; argv_init[i]; i++) {
 		if (i == MAX_INIT_ARGS) {
@@ -277,9 +279,10 @@ static int __init set_init_arg(char *param, char *val, const char *unused)
  * Unknown boot options get handed to init, unless they look like
  * unused parameters (modprobe will find them in /proc/cmdline).
  */
-static int __init unknown_bootoption(char *param, char *val, const char *unused)
+static int __init unknown_bootoption(char *param, char *val,
+				     const char *unused, void *arg)
 {
-	repair_env_string(param, val, unused);
+	repair_env_string(param, val, unused, NULL);
 
 	/* Handle obsolete-style parameters */
 	if (obsolete_checksetup(param))
@@ -419,7 +422,8 @@ static noinline void __init_refok rest_init(void)
 }
 
 /* Check for early params. */
-static int __init do_early_param(char *param, char *val, const char *unused)
+static int __init do_early_param(char *param, char *val,
+				 const char *unused, void *arg)
 {
 	const struct obs_kernel_param *p;
 
@@ -438,7 +442,8 @@ static int __init do_early_param(char *param, char *val, const char *unused)
 
 void __init parse_early_options(char *cmdline)
 {
-	parse_args("early options", cmdline, NULL, 0, 0, 0, do_early_param);
+	parse_args("early options", cmdline, NULL, 0, 0, 0, NULL,
+		   do_early_param);
 }
 
 /* Arch code calls this early on, or if not, just before other parsing. */
@@ -543,10 +548,10 @@ asmlinkage __visible void __init start_kernel(void)
 	after_dashes = parse_args("Booting kernel",
 				  static_command_line, __start___param,
 				  __stop___param - __start___param,
-				  -1, -1, &unknown_bootoption);
+				  -1, -1, NULL, &unknown_bootoption);
 	if (after_dashes)
 		parse_args("Setting init args", after_dashes, NULL, 0, -1, -1,
-			   set_init_arg);
+			   NULL, set_init_arg);
 
 	jump_label_init();
 
@@ -851,7 +856,7 @@ static void __init do_initcall_level(int level)
 		   initcall_command_line, __start___param,
 		   __stop___param - __start___param,
 		   level, level,
-		   &repair_env_string);
+		   NULL, &repair_env_string);
 
 	for (fn = initcall_levels[level]; fn < initcall_levels[level+1]; fn++)
 		do_one_initcall(*fn);
diff --git a/kernel/module.c b/kernel/module.c
index 03214bd2..88f3d6c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3172,7 +3172,8 @@ out:
 	return err;
 }
 
-static int unknown_module_param_cb(char *param, char *val, const char *modname)
+static int unknown_module_param_cb(char *param, char *val, const char *modname,
+				   void *arg)
 {
 	/* Check for magic 'dyndbg' arg */ 
 	int ret = ddebug_dyndbg_module_param_cb(param, val, modname);
@@ -3277,7 +3278,8 @@ static int load_module(struct load_info *info, const char __user *uargs,
 
 	/* Module is ready to execute: parsing args may do that. */
 	after_dashes = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
-				  -32768, 32767, unknown_module_param_cb);
+				  -32768, 32767, NULL,
+				  unknown_module_param_cb);
 	if (IS_ERR(after_dashes)) {
 		err = PTR_ERR(after_dashes);
 		goto bug_cleanup;
diff --git a/kernel/params.c b/kernel/params.c
index 34f5270..4182607 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -90,8 +90,9 @@ static int parse_one(char *param,
 		     unsigned num_params,
 		     s16 min_level,
 		     s16 max_level,
+		     void *arg,
 		     int (*handle_unknown)(char *param, char *val,
-				     const char *doing))
+				     const char *doing, void *arg))
 {
 	unsigned int i;
 	int err;
@@ -117,7 +118,7 @@ static int parse_one(char *param,
 
 	if (handle_unknown) {
 		pr_debug("doing %s: %s='%s'\n", doing, param, val);
-		return handle_unknown(param, val, doing);
+		return handle_unknown(param, val, doing, arg);
 	}
 
 	pr_debug("Unknown argument '%s'\n", param);
@@ -183,7 +184,9 @@ char *parse_args(const char *doing,
 		 unsigned num,
 		 s16 min_level,
 		 s16 max_level,
-		 int (*unknown)(char *param, char *val, const char *doing))
+		 void *arg,
+		 int (*unknown)(char *param, char *val,
+				const char *doing, void *arg))
 {
 	char *param, *val;
 
@@ -203,7 +206,7 @@ char *parse_args(const char *doing,
 			return args;
 		irq_was_disabled = irqs_disabled();
 		ret = parse_one(param, val, doing, params, num,
-				min_level, max_level, unknown);
+				min_level, max_level, arg, unknown);
 		if (irq_was_disabled && !irqs_disabled())
 			pr_warn("%s: option '%s' enabled irq's!\n",
 				doing, param);
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index c9afbe2..d0a8898 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -910,7 +910,7 @@ static int ddebug_dyndbg_param_cb(char *param, char *val,
 
 /* handle both dyndbg and $module.dyndbg params at boot */
 static int ddebug_dyndbg_boot_param_cb(char *param, char *val,
-				const char *unused)
+				const char *unused, void *arg)
 {
 	vpr_info("%s=\"%s\"\n", param, val);
 	return ddebug_dyndbg_param_cb(param, val, NULL, 0);
@@ -1051,7 +1051,7 @@ static int __init dynamic_debug_init(void)
 	 */
 	cmdline = kstrdup(saved_command_line, GFP_KERNEL);
 	parse_args("dyndbg params", cmdline, NULL,
-		   0, 0, 0, &ddebug_dyndbg_boot_param_cb);
+		   0, 0, 0, NULL, &ddebug_dyndbg_boot_param_cb);
 	kfree(cmdline);
 	return 0;
 
-- 
2.1.0

