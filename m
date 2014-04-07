Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaDGE7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 00:59:52 -0400
Received: from ozlabs.org ([203.10.76.45]:36761 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaDGE71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 00:59:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
In-Reply-To: <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
References: <20140402144219.4cafbe37@gandalf.local.home> <20140402221212.GD16570@mguzik.redhat.com> <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 07 Apr 2014 14:24:45 +0930
Message-ID: <87wqf1oi22.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Wed, Apr 2, 2014 at 3:12 PM, Mateusz Guzik <mguzik@redhat.com> wrote:
>>
>> Well, parsing kernel cmdline by systemd is a bad idea
>
> No, we very much expose /proc/cmdline for a reason. System services
> are *supposed* to parse it, because it gives a unified way for people
> to pass in various flags. The kernel doesn't complain about flags it
> doesn't recognize, exactly because the kernel realizes that "hey,
> maybe this flag is for something else".

How's this in future?

Cheers,
Rusty.

Subject: param: hand arguments after -- straight to init

The kernel passes any args it doesn't need through to init, except it
assumes anything containing '.' belongs to the kernel (for a module).
This change means all users can clearly distinguish which arguments
are for init.

For example, the kernel uses debug ("dee-bug") to mean log everything to
the console, where systemd uses the debug from the Scandinavian "day-boog"
meaning "fail to boot".  If a future versions uses argv[] instead of
reading /proc/cmdline, this confusion will be avoided.

eg: test 'FOO="this is --foo"' -- 'systemd.debug="true true true"'

Gives:
argv[0] = '/debug-init'
argv[1] = 'test'
argv[2] = 'systemd.debug=true true true'
envp[0] = 'HOME=/'
envp[1] = 'TERM=linux'
envp[2] = 'FOO=this is --foo'

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 204a67743804..b1990c5524e1 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -321,7 +321,7 @@ extern bool parameq(const char *name1, const char *name2);
 extern bool parameqn(const char *name1, const char *name2, size_t n);
 
 /* Called on module insert or kernel boot */
-extern int parse_args(const char *name,
+extern char *parse_args(const char *name,
 		      char *args,
 		      const struct kernel_param *params,
 		      unsigned num,
diff --git a/init/main.c b/init/main.c
index 9c7fd4c9249f..e9d458b5d77b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -252,6 +252,27 @@ static int __init repair_env_string(char *param, char *val, const char *unused)
 	return 0;
 }
 
+/* Anything after -- gets handed straight to init. */
+static int __init set_init_arg(char *param, char *val, const char *unused)
+{
+	unsigned int i;
+
+	if (panic_later)
+		return 0;
+
+	repair_env_string(param, val, unused);
+
+	for (i = 0; argv_init[i]; i++) {
+		if (i == MAX_INIT_ARGS) {
+			panic_later = "init";
+			panic_param = param;
+			return 0;
+		}
+	}
+	argv_init[i] = param;
+	return 0;
+}
+
 /*
  * Unknown boot options get handed to init, unless they look like
  * unused parameters (modprobe will find them in /proc/cmdline).
@@ -478,7 +499,7 @@ static void __init mm_init(void)
 
 asmlinkage void __init start_kernel(void)
 {
-	char * command_line;
+	char * command_line, *after_dashes;
 	extern const struct kernel_param __start___param[], __stop___param[];
 
 	/*
@@ -519,9 +540,13 @@ asmlinkage void __init start_kernel(void)
 
 	pr_notice("Kernel command line: %s\n", boot_command_line);
 	parse_early_param();
-	parse_args("Booting kernel", static_command_line, __start___param,
-		   __stop___param - __start___param,
-		   -1, -1, &unknown_bootoption);
+	after_dashes = parse_args("Booting kernel",
+				  static_command_line, __start___param,
+				  __stop___param - __start___param,
+				  -1, -1, &unknown_bootoption);
+	if (after_dashes)
+		parse_args("Setting init args", after_dashes, NULL, 0, -1, -1,
+			   set_init_arg);
 
 	jump_label_init();
 
diff --git a/kernel/module.c b/kernel/module.c
index 29f7790eaa14..600d1fbf1773 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3193,6 +3193,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 {
 	struct module *mod;
 	long err;
+	char *after_dashes;
 
 	err = module_sig_check(info);
 	if (err)
@@ -3277,10 +3278,15 @@ static int load_module(struct load_info *info, const char __user *uargs,
 		goto ddebug_cleanup;
 
 	/* Module is ready to execute: parsing args may do that. */
-	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
-			 -32768, 32767, unknown_module_param_cb);
-	if (err < 0)
+	after_dashes = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
+				  -32768, 32767, unknown_module_param_cb);
+	if (IS_ERR(after_dashes)) {
+		err = PTR_ERR(after_dashes);
 		goto bug_cleanup;
+	} else if (after_dashes) {
+		pr_warn("%s: parameters '%s' after `--' ignored\n",
+		       mod->name, after_dashes);
+	}
 
 	/* Link in to syfs. */
 	err = mod_sysfs_setup(mod, info, mod->kp, mod->num_kp);
diff --git a/kernel/params.c b/kernel/params.c
index b00142e7f3ba..1e52ca233fd9 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -177,13 +177,13 @@ static char *next_arg(char *args, char **param, char **val)
 }
 
 /* Args looks like "foo=bar,bar2 baz=fuz wiz". */
-int parse_args(const char *doing,
-	       char *args,
-	       const struct kernel_param *params,
-	       unsigned num,
-	       s16 min_level,
-	       s16 max_level,
-	       int (*unknown)(char *param, char *val, const char *doing))
+char *parse_args(const char *doing,
+		 char *args,
+		 const struct kernel_param *params,
+		 unsigned num,
+		 s16 min_level,
+		 s16 max_level,
+		 int (*unknown)(char *param, char *val, const char *doing))
 {
 	char *param, *val;
 
@@ -198,6 +198,9 @@ int parse_args(const char *doing,
 		int irq_was_disabled;
 
 		args = next_arg(args, &param, &val);
+		/* Stop at -- */
+		if (!val && strcmp(param, "--") == 0)
+			return args;
 		irq_was_disabled = irqs_disabled();
 		ret = parse_one(param, val, doing, params, num,
 				min_level, max_level, unknown);
@@ -208,22 +211,22 @@ int parse_args(const char *doing,
 		switch (ret) {
 		case -ENOENT:
 			pr_err("%s: Unknown parameter `%s'\n", doing, param);
-			return ret;
+			return ERR_PTR(ret);
 		case -ENOSPC:
 			pr_err("%s: `%s' too large for parameter `%s'\n",
 			       doing, val ?: "", param);
-			return ret;
+			return ERR_PTR(ret);
 		case 0:
 			break;
 		default:
 			pr_err("%s: `%s' invalid for parameter `%s'\n",
 			       doing, val ?: "", param);
-			return ret;
+			return ERR_PTR(ret);
 		}
 	}
 
 	/* All parsed OK. */
-	return 0;
+	return NULL;
 }
 
 /* Lazy bastard, eh? */
