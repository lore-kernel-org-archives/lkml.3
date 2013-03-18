Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3CRCpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:45:46 -0400
Received: from ozlabs.org ([203.10.76.45]:40532 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab3CRCpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:45:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC PATCH] Allow optional module parameters
In-Reply-To: <CALCETrU+rehQzy4vVg589CGi561X_s73Xgsfp43pYZOoKvNDXQ@mail.gmail.com>
References: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net> <87ehfhtftn.fsf@rustcorp.com.au> <CALCETrU+rehQzy4vVg589CGi561X_s73Xgsfp43pYZOoKvNDXQ@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 18 Mar 2013 12:54:14 +1030
Message-ID: <87sj3tsawh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:
> On Thu, Mar 14, 2013 at 10:03 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>> Current parameter behavior is odd.  Boot parameters that have values
>>> and don't match anything become environment variables, with no
>>> warning.  Boot parameters without values that don't match anything
>>> go into argv_init.  Everything goes into /proc/cmdline.
>>>
>>> The init_module and finit_module syscalls, however, are strict:
>>> parameters that don't match result in -ENOENT.
>>>
>>> kmod (and hence modprobe), when loading a module called foo, look in
>>> /proc/cmdline for foo.x or foo.x=y, strip off the foo., and pass the
>>> rest to init_module.
>>>
>>> The upshot is that booting with module.nonexistent_parameter=1 is
>>> okay if module is built in or missing entirely but prevents module
>>> from loading if it's an actual module.  Similarly, option module
>>> nonexistent_parameter=1 in /etc/modprobe.d prevents the module from
>>> loading the parameter goes away.  This means that removing module
>>> parameters unnecessarily breaks things.
>>
>> Err, yes.  Don't remove module parameters, they're part of the API.  Do
>> you have a particular example?
>
> So things like i915.i915_enable_ppgtt, which is there to enable
> something experimental, needs to stay forever once the relevant
> feature becomes non-experimental and non-optional?  This seems silly.

Well, it's either experimental, in which case you're happy to break
users who use it, or it's not, in which case, don't.

> Having the module parameter go away while still allowing the module to
> load seems like a good solution (possibly with a warning in the logs
> so the user can eventually delete the parameter).

Why not do that for *every* missing parameter then?  Why have this weird
notation where the user must know that the parameter might one day go
away?

> In any case, I find it odd that the only parameters you can set that
> cause errors when the parameter is deleted are parameters for modules
> that are built as modules.

We could definitely expand the check: we should check for unknown
parameters to builtin modules.

This refers back to my question on lkml 'Re: No sysfs directory for
openvswitch module when built-in' as the kernel doesn't currently know
what modules are builtin.  We intuit it from parameter names, which is
sloppy.

Here's a rough patch.  Maybe someone on linux-kbuild can tell me why it
fails?

DOESNT_WORK: kernel: generate list of builtin modnames.

For some reason, the only contents of modules.builtin when this runs is
one line "kernel/kernel/configs.ko"?

This lets us emit an error when invalid boot parameters are used, since
we know what names can never be external modules.

diff --git a/include/linux/module.h b/include/linux/module.h
index 46f1ea0..3433f6b 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -186,6 +186,9 @@ struct notifier_block;
 
 #ifdef CONFIG_MODULES
 
+/* In generated file kernel/modnamelist.c */
+extern const char *builtin_modnames[];
+
 extern int modules_disabled; /* for sysctl */
 /* Get/put a kernel symbol (calls must be symmetric) */
 void *__symbol_get(const char *symbol);
diff --git a/init/main.c b/init/main.c
index 63534a1..e4dec79 100644
--- a/init/main.c
+++ b/init/main.c
@@ -245,12 +245,25 @@ static int __init repair_env_string(char *param, char *val, const char *unused)
 	return 0;
 }
 
+static bool builtin_modname(const char *name, size_t len)
+{
+	const char **n;
+
+	for (n = builtin_modnames; *n; n++) {
+		if (strncmp(name, *n, len) == 0 && !(*n)[len])
+			return true;
+	}
+	return false;
+}
+
 /*
  * Unknown boot options get handed to init, unless they look like
  * unused parameters (modprobe will find them in /proc/cmdline).
  */
 static int __init unknown_bootoption(char *param, char *val, const char *unused)
 {
+	size_t modname_len = strcspn(param, ".");
+
 	repair_env_string(param, val, unused);
 
 	/* Handle obsolete-style parameters */
@@ -258,8 +271,13 @@ static int __init unknown_bootoption(char *param, char *val, const char *unused)
 		return 0;
 
 	/* Unused module parameter. */
-	if (strchr(param, '.') && (!val || strchr(param, '.') < val))
+	if (param[modname_len] == '.') {
+		if (builtin_modname(param, modname_len)) {
+			printk(KERN_ERR "Unknown kernel parameter %s\n", param);
+			return -EINVAL;
+		}
 		return 0;
+	}
 
 	if (panic_later)
 		return 0;
diff --git a/kernel/.gitignore b/kernel/.gitignore
index ab4f109..df5b7c7 100644
--- a/kernel/.gitignore
+++ b/kernel/.gitignore
@@ -4,3 +4,4 @@
 config_data.h
 config_data.gz
 timeconst.h
+modnamelist.c
diff --git a/kernel/Makefile b/kernel/Makefile
index bbde5f1..3f3dad7 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o \
-	    async.o range.o groups.o lglock.o smpboot.o
+	    async.o range.o groups.o lglock.o smpboot.o modnamelist.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
@@ -139,6 +139,13 @@ targets += timeconst.h
 $(obj)/timeconst.h: $(obj)/hz.bc $(src)/timeconst.bc FORCE
 	$(call if_changed,bc)
 
+quiet_cmd_modnamelist  = MODNAMELIST      $@
+      cmd_modnamelist  = sh scripts/modnamelist.sh $@ $(src)/modules.builtin
+
+# Must match name-fix in scripts/Makefile.lib!
+kernel/modnamelist.c: modules.builtin FORCE
+	$(call if_changed,modnamelist)
+
 ifeq ($(CONFIG_MODULE_SIG),y)
 #
 # Pull the signing certificate and any extra certificates into the kernel
diff --git a/scripts/modnamelist.sh b/scripts/modnamelist.sh
new file mode 100755
index 0000000..5d06820
--- /dev/null
+++ b/scripts/modnamelist.sh
@@ -0,0 +1,22 @@
+#! /bin/sh
+set -e
+
+OUT="$1"
+LIST="$2"
+
+trap "rm -f $OUT.tmp" 0
+
+cat > $OUT.tmp <<EOF
+/* Autogenerated list of builtin modules. */
+#include <linux/module.h>
+
+const char *builtin_modnames[] = {
+EOF
+
+sed -e 's@.*/\(.*\)\.ko@\t"\1"@' -e 's@[,-]@_@g' -e 's@$@,@' < $LIST >> $OUT.tmp
+cat >> $OUT.tmp <<EOF
+	NULL
+};
+EOF
+
+mv $OUT.tmp $OUT
