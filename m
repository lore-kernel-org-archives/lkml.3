Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaKDIn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:43:58 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49529 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaKDInu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:43:50 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v1 09/11] backports: use Kconfig for backport version information
Date: Tue,  4 Nov 2014 00:43:00 -0800
Message-Id: <1415090582-14129-10-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Instead of relying on Makefile hacks just use Kconfig for
defining the variables needed. We can do this since these
variables are all known at packaging time. The exception
is BACKPORTS_GIT_TRACKED, but for that we can define a
kconfig variable which only if set will we rely on the
environment for picking it up and later exporting it through
Kconfig. Since Kconfig doesn't keep config variables defined
with option env we use a secondary config entry for that.

With this we can remove all those extra defines and we can
rely on CPTCFG_ variables as typically expected in our
backport kernel code.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/Kconfig.package                 | 25 ++++++++++++++++---
 backport/Makefile.kernel                 |  4 ---
 backport/Makefile.real                   | 10 ++++----
 backport/backport-include/linux/module.h |  6 ++---
 backport/compat/main.c                   | 42 ++++++++++++++++----------------
 gentree.py                               | 30 ++++++++++++++++-------
 6 files changed, 71 insertions(+), 46 deletions(-)

diff --git a/backport/Kconfig.package b/backport/Kconfig.package
index c507de4..aade94d 100644
--- a/backport/Kconfig.package
+++ b/backport/Kconfig.package
@@ -1,17 +1,34 @@
-mainmenu "Backports from $BACKPORTED_KERNEL_NAME $BACKPORTED_KERNEL_VERSION (backports $BACKPORTS_VERSION)"
+mainmenu "Backports from %%BACKPORTED_KERNEL_NAME%% %%BACKPORTED_KERNEL_VERSION%% (backports %%BACKPORTS_VERSION%%)"
 
 config BACKPORT_DIR
 	string
 	option env="BACKPORT_DIR"
+
 config BACKPORTS_VERSION
 	string
-	option env="BACKPORTS_VERSION"
+	default "%%BACKPORTS_VERSION%%"
+
 config BACKPORTED_KERNEL_VERSION
 	string
-	option env="BACKPORTED_KERNEL_VERSION"
+	default "%%BACKPORTED_KERNEL_VERSION%%"
+
 config BACKPORTED_KERNEL_NAME
 	string
-	option env="BACKPORTED_KERNEL_NAME"
+	default "%%BACKPORTED_KERNEL_NAME%%"
+
+config BACKPORT_IS_GIT_TRACKED
+	def_bool %%BACKPORT_IS_GIT_TRACKED%%
+
+if BACKPORT_IS_GIT_TRACKED
+config __BACKPORT_GIT_TRACKED
+	string
+	option env="__BACKPORT_GIT_TRACKED"
+
+# The option env isn't sticky on .config / autoconf, so we need this
+config BACKPORTS_GIT_TRACKED
+	string
+	default $__BACKPORT_GIT_TRACKED
+endif # BACKPORT_IS_GIT_TRACKED
 
 # some hacks for when we use backports to generate a package
 # to build modules out of tree.
diff --git a/backport/Makefile.kernel b/backport/Makefile.kernel
index dcb2ba7..7a41273 100644
--- a/backport/Makefile.kernel
+++ b/backport/Makefile.kernel
@@ -10,10 +10,6 @@ NOSTDINC_FLAGS := \
 	-I$(M)/include/uapi \
 	-include $(M)/backport-include/backport/backport.h \
 	$(call backport-cc-disable-warning, unused-but-set-variable) \
-	-DBACKPORTS_VERSION=\"$(BACKPORTS_VERSION)\" \
-	-DBACKPORTED_KERNEL_VERSION=\"$(BACKPORTED_KERNEL_VERSION)\" \
-	-DBACKPORTED_KERNEL_NAME=\"$(BACKPORTED_KERNEL_NAME)\" \
-	$(BACKPORTS_GIT_TRACKER_DEF) \
 	$(CFLAGS)
 
 export backport_srctree = $(M)
diff --git a/backport/Makefile.real b/backport/Makefile.real
index a0f4916..6b342ce 100644
--- a/backport/Makefile.real
+++ b/backport/Makefile.real
@@ -1,9 +1,9 @@
-include versions
-export BACKPORTS_VERSION BACKPORTED_KERNEL_VERSION BACKPORTED_KERNEL_NAME
-ifdef BACKPORTS_GIT_TRACKED
-export BACKPORTS_GIT_TRACKER_DEF=-DBACKPORTS_GIT_TRACKED=\"$(BACKPORTS_GIT_TRACKED)\"
+ifeq ($(CPTCFG_BACKPORT_IS_GIT_TRACKED),y)
+export __BACKPORT_GIT_TRACKED="backport tracker ID: $(shell git rev-parse HEAD 2>/dev/null || echo \'not built in git tree\')"
 else
-export BACKPORTS_GIT_TRACKER_DEF=
+# Technically not required but Kconfig will complain otherwise for
+# undefined option env even if your kconfig environment does not need it
+export __BACKPORT_GIT_TRACKED="not built in git tree"
 endif
 
 # disable built-in rules for this file
diff --git a/backport/backport-include/linux/module.h b/backport/backport-include/linux/module.h
index 8942c5b..3f8cbec 100644
--- a/backport/backport-include/linux/module.h
+++ b/backport/backport-include/linux/module.h
@@ -20,9 +20,9 @@ extern void backport_dependency_symbol(void);
 #define BACKPORT_MOD_VERSIONS MODULE_VERSION(BACKPORTS_GIT_TRACKED);
 #else
 #define BACKPORT_MOD_VERSIONS						\
-	MODULE_VERSION("backported from " BACKPORTED_KERNEL_NAME	\
-		       " (" BACKPORTED_KERNEL_VERSION ")"		\
-		       " using backports " BACKPORTS_VERSION);
+	MODULE_VERSION("backported from " CPTCFG_BACKPORTED_KERNEL_NAME	\
+		       " (" CPTCFG_BACKPORTED_KERNEL_VERSION ")"	\
+		       " using backports " CPTCFG_BACKPORTS_VERSION);
 #endif
 
 #ifndef MODULE
diff --git a/backport/compat/main.c b/backport/compat/main.c
index d3f8944..44935bd 100644
--- a/backport/compat/main.c
+++ b/backport/compat/main.c
@@ -8,40 +8,40 @@ MODULE_AUTHOR("Luis R. Rodriguez");
 MODULE_DESCRIPTION("Kernel backport module");
 MODULE_LICENSE("GPL");
 
-#ifndef BACKPORTED_KERNEL_NAME
-#error "You need a BACKPORTED_KERNEL_NAME"
+#ifndef CPTCFG_BACKPORTED_KERNEL_NAME
+#error "You need a CPTCFG_BACKPORTED_KERNEL_NAME"
 #endif
 
-#ifndef BACKPORTED_KERNEL_VERSION
-#error "You need a BACKPORTED_KERNEL_VERSION"
+#ifndef CPTCFG_BACKPORTED_KERNEL_VERSION
+#error "You need a CPTCFG_BACKPORTED_KERNEL_VERSION"
 #endif
 
-#ifndef BACKPORTS_VERSION
-#error "You need a BACKPORTS_VERSION"
+#ifndef CPTCFG_BACKPORTS_VERSION
+#error "You need a CPTCFG_BACKPORTS_VERSION"
 #endif
 
-static char *backported_kernel_name = BACKPORTED_KERNEL_NAME;
+static char *backported_kernel_name = CPTCFG_BACKPORTED_KERNEL_NAME;
 
 module_param(backported_kernel_name, charp, 0400);
 MODULE_PARM_DESC(backported_kernel_name,
-		 "The kernel tree name that was used for this backport (" BACKPORTED_KERNEL_NAME ")");
+		 "The kernel tree name that was used for this backport (" CPTCFG_BACKPORTED_KERNEL_NAME ")");
 
-#ifdef BACKPORTS_GIT_TRACKED 
-static char *backports_tracker_id = BACKPORTS_GIT_TRACKED;
+#ifdef CPTCFG_BACKPORTS_GIT_TRACKED
+static char *backports_tracker_id = CPTCFG_BACKPORTS_GIT_TRACKED;
 module_param(backports_tracker_id, charp, 0400);
 MODULE_PARM_DESC(backports_tracker_id,
-		 "The version of the tree containing this backport (" BACKPORTS_GIT_TRACKED ")");
+		 "The version of the tree containing this backport (" CPTCFG_BACKPORTS_GIT_TRACKED ")");
 #else
-static char *backported_kernel_version = BACKPORTED_KERNEL_VERSION;
-static char *backports_version = BACKPORTS_VERSION;
+static char *backported_kernel_version = CPTCFG_BACKPORTED_KERNEL_VERSION;
+static char *backports_version = CPTCFG_BACKPORTS_VERSION;
 
 module_param(backported_kernel_version, charp, 0400);
 MODULE_PARM_DESC(backported_kernel_version,
-		 "The kernel version that was used for this backport (" BACKPORTED_KERNEL_VERSION ")");
+		 "The kernel version that was used for this backport (" CPTCFG_BACKPORTED_KERNEL_VERSION ")");
 
 module_param(backports_version, charp, 0400);
 MODULE_PARM_DESC(backports_version,
-		 "The git version of the backports tree used to generate this backport (" BACKPORTS_VERSION ")");
+		 "The git version of the backports tree used to generate this backport (" CPTCFG_BACKPORTS_VERSION ")");
 
 #endif
 
@@ -63,15 +63,15 @@ static int __init backport_init(void)
 		return ret;
 	}
 
-	printk(KERN_INFO "Loading modules backported from " BACKPORTED_KERNEL_NAME
-#ifndef BACKPORTS_GIT_TRACKED
-		" version " BACKPORTED_KERNEL_VERSION
+	printk(KERN_INFO "Loading modules backported from " CPTCFG_BACKPORTED_KERNEL_NAME
+#ifndef CPTCFG_BACKPORTS_GIT_TRACKED
+		" version " CPTCFG_BACKPORTED_KERNEL_VERSION
 #endif
 		"\n");
-#ifdef BACKPORTS_GIT_TRACKED
-	printk(KERN_INFO BACKPORTS_GIT_TRACKED "\n");
+#ifdef CPTCFG_BACKPORTS_GIT_TRACKED
+	printk(KERN_INFO CPTCFG_BACKPORTS_GIT_TRACKED "\n");
 #else
-	printk(KERN_INFO "Backport generated by backports.git " BACKPORTS_VERSION "\n");
+	printk(KERN_INFO "Backport generated by backports.git " CPTCFG_BACKPORTS_VERSION "\n");
 #endif
 
         return 0;
diff --git a/gentree.py b/gentree.py
index 1b6dc89..685fde5 100755
--- a/gentree.py
+++ b/gentree.py
@@ -798,15 +798,27 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
                                       tree=args.kerneldir,
                                       extra_args=['--long'])
 
-    if not integrate:
-        f = open(os.path.join(args.outdir, 'versions'), 'w')
-        f.write('BACKPORTS_VERSION="%s"\n' % backports_version)
-        f.write('BACKPORTED_KERNEL_VERSION="%s"\n' % kernel_version)
-        f.write('BACKPORTED_KERNEL_NAME="%s"\n' % args.base_name)
-        if git_tracked_version:
-            f.write('BACKPORTS_GIT_TRACKED="backport tracker ID: $(shell git rev-parse HEAD 2>/dev/null || echo \'not built in git tree\')"\n')
-        f.close()
-        git_debug_snapshot(args, "generate kernel version info file: version")
+    is_git_tracked_version = 'n'
+    if git_tracked_version:
+        git_tracked_version = 'y'
+    kconf_regexes = [
+            (re.compile(r'.*(?P<key>%%BACKPORT_DIR%%)'), '%%BACKPORT_DIR%%', 'backports/'),
+            (re.compile(r'.*(?P<key>%%BACKPORTS_VERSION%%).*'), '%%BACKPORTS_VERSION%%', backports_version),
+            (re.compile(r'.*(?P<key>%%BACKPORTED_KERNEL_VERSION%%).*'), '%%BACKPORTED_KERNEL_VERSION%%', kernel_version),
+            (re.compile(r'.*(?P<key>%%BACKPORTED_KERNEL_NAME%%).*'), '%%BACKPORTED_KERNEL_NAME%%', args.base_name),
+            (re.compile(r'.*(?P<key>%%BACKPORT_IS_GIT_TRACKED%%).*'), '%%BACKPORT_IS_GIT_TRACKED%%', is_git_tracked_version),
+    ]
+    out = ''
+    for l in open(os.path.join(args.outdir, 'Kconfig'), 'r'):
+        for r in kconf_regexes:
+            m = r[0].match(l)
+            if m:
+                l = re.sub(r'(' + r[1] + ')', r'' + r[2] + '', l)
+        out += l
+    outf = open(os.path.join(args.outdir, 'Kconfig'), 'w')
+    outf.write(out)
+    outf.close()
+    git_debug_snapshot(args, "modify top level backports/Kconfig with backports identity")
 
     disable_list = add_automatic_backports(args, bp_prefix)
     if disable_list:
-- 
2.1.1

