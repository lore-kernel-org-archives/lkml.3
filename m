Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaKDIoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:44:18 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:58492 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaKDIoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:44:00 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v1 11/11] backports: add full kernel integration support
Date: Tue,  4 Nov 2014 00:43:02 -0800
Message-Id: <1415090582-14129-12-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This enables support for using the backports project
to integrate device drivers from a future version of Linux
into an older version of Linux. What you end up seeing is
a backports submenu when configuring your kernel and the
ability to select specific device drivers from subsystems
supported through the Linux backports project.

At this time enabling one device driver from a future version
of Linux will require using only the latest version of the
subsystem modules and other subsystem drivers. For example
enabling cfg80211 and mac80211 from a future version of Linux
will require you to only use future version of the respective
device drivers. In order to enable the backported version of
802.11 drivers for example, you will have to enable first:

Networking support -->
  Wireless -->

But under that menu disable all options, then jump to the backports
submenu to now enable:

Backports -->
  cfg80211
  mac80211
  Wireless LAN  --->
    etc

You build these device drivers modular or built-in to the kernel.
Integration support requires only slight modifications to the original
kernel sources, one to the top level Kconfig to add our entry, and also
the top level Makefile to enable backports code to be part of the
built-in vmlinux.

Support for integration takes advantage over the existing infrastructure
added by Johannes to keep track of each indvidual change done by the
backports infrastructure if --gitdebug is used.

1   3.0.101             [  OK  ]
2   3.1.10              [  OK  ]
3   3.2.62              [  OK  ]
4   3.3.8               [  OK  ]
5   3.4.104             [  OK  ]
6   3.5.7               [  OK  ]
7   3.6.11              [  OK  ]
8   3.7.10              [  OK  ]
9   3.8.13              [  OK  ]
10  3.9.11              [  OK  ]
11  3.10.58             [  OK  ]
12  3.11.10             [  OK  ]
13  3.12.31             [  OK  ]
14  3.13.11             [  OK  ]
15  3.14.22             [  OK  ]
16  3.15.10             [  OK  ]
17  3.16.6              [  OK  ]
18  3.17.1              [  OK  ]
19  3.18-rc1            [  OK  ]

real    3m17.573s
user    67m33.172s
sys     18m27.596s

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/Kconfig.integrate                         | 36 +++++++++++
 backport/Makefile.kernel                           | 13 ++++
 backport/backport-include/backport/backport.h      |  5 ++
 backport/compat/Makefile                           |  4 ++
 backport/compat/main.c                             |  8 ++-
 devel/doc/kconfig-operation                        |  5 ++
 gentree.py                                         | 73 +++++++++++++++++++---
 .../0001-enable-backports-built-in.patch           | 40 ++++++++++++
 lib/bpversion.py                                   | 48 ++++++++++++++
 lib/kconfig.py                                     | 10 +++
 10 files changed, 233 insertions(+), 9 deletions(-)
 create mode 100644 backport/Kconfig.integrate
 create mode 100644 integration-patches/0001-enable-backports/0001-enable-backports-built-in.patch
 create mode 100644 lib/bpversion.py

diff --git a/backport/Kconfig.integrate b/backport/Kconfig.integrate
new file mode 100644
index 0000000..520f6da
--- /dev/null
+++ b/backport/Kconfig.integrate
@@ -0,0 +1,36 @@
+config BACKPORT_INTEGRATE
+	bool
+	def_bool y
+
+config BACKPORT_DIR
+	string
+	default "%%BACKPORT_DIR%%"
+
+config BACKPORTS_VERSION
+	string
+	default "%%BACKPORTS_VERSION%%"
+
+config BACKPORTED_KERNEL_VERSION
+	string
+	default "%%BACKPORTED_KERNEL_VERSION%%"
+
+config BACKPORTED_KERNEL_NAME
+	string
+	default "%%BACKPORTED_KERNEL_NAME%%"
+
+menuconfig BACKPORT_LINUX
+	bool "Backport %%BACKPORTED_KERNEL_NAME%% %%BACKPORTED_KERNEL_VERSION%% (backports %%BACKPORTS_VERSION%%)"
+	default n
+	---help---
+	  Enabling this will let give you the opportunity to use features and
+	  drivers backported from %%BACKPORTED_KERNEL_NAME%% %%BACKPORTED_KERNEL_VERSION%%
+	  on the kernel your are using. This is experimental and you should
+	  say no unless you'd like to help test things or want to help debug
+	  this should we run into any issues.
+
+if BACKPORT_LINUX
+
+source "$BACKPORT_DIR/Kconfig.versions"
+source "$BACKPORT_DIR/Kconfig.sources"
+
+endif # BACKPORT_LINUX
diff --git a/backport/Makefile.kernel b/backport/Makefile.kernel
index 7a41273..4726712 100644
--- a/backport/Makefile.kernel
+++ b/backport/Makefile.kernel
@@ -1,3 +1,4 @@
+ifeq ($(CONFIG_BACKPORT_INTEGRATE),)
 # Since 2.6.21, try-run is available, but cc-disable-warning
 # was only added later, so we add it here ourselves:
 backport-cc-disable-warning = $(call try-run,\
@@ -13,6 +14,18 @@ NOSTDINC_FLAGS := \
 	$(CFLAGS)
 
 export backport_srctree = $(M)
+else
+export BACKPORT_DIR = backports/
+export backport_srctree = $(BACKPORT_DIR)
+NOSTDINC_FLAGS := \
+	-I$(BACKPORT_DIR)/backport-include/ \
+	-I$(BACKPORT_DIR)/backport-include/uapi \
+	-I$(BACKPORT_DIR)/include/ \
+	-I$(BACKPORT_DIR)/include/uapi \
+	-include $(BACKPORT_DIR)/backport-include/backport/backport.h \
+	$(CFLAGS)
+endif
+
 
 obj-y += compat/
 
diff --git a/backport/backport-include/backport/backport.h b/backport/backport-include/backport/backport.h
index 7cf21aa..d1d3b10 100644
--- a/backport/backport-include/backport/backport.h
+++ b/backport/backport-include/backport/backport.h
@@ -1,11 +1,16 @@
 #ifndef __BACKPORT_H
 #define __BACKPORT_H
+#include <generated/autoconf.h>
+#ifndef CONFIG_BACKPORT_INTEGRATE
 #include <backport/autoconf.h>
+#endif
 #include <linux/kconfig.h>
 
 #ifndef __ASSEMBLY__
 #define LINUX_BACKPORT(__sym) backport_ ##__sym
+#ifndef CONFIG_BACKPORT_INTEGRATE
 #include <backport/checks.h>
 #endif
+#endif
 
 #endif /* __BACKPORT_H */
diff --git a/backport/compat/Makefile b/backport/compat/Makefile
index 0dd69fe..5a2f2f5 100644
--- a/backport/compat/Makefile
+++ b/backport/compat/Makefile
@@ -1,5 +1,9 @@
 ccflags-y += -I$(src)
+ifeq ($(CONFIG_BACKPORT_INTEGRATE),)
 obj-m += compat.o
+else
+obj-y += compat.o
+endif
 compat-y += main.o
 
 # Kernel backport compatibility code
diff --git a/backport/compat/main.c b/backport/compat/main.c
index 44935bd..a679f8d 100644
--- a/backport/compat/main.c
+++ b/backport/compat/main.c
@@ -71,8 +71,14 @@ static int __init backport_init(void)
 #ifdef CPTCFG_BACKPORTS_GIT_TRACKED
 	printk(KERN_INFO CPTCFG_BACKPORTS_GIT_TRACKED "\n");
 #else
+
+#ifdef CONFIG_BACKPORT_INTEGRATE
+	printk(KERN_INFO "Backport integrated by backports.git " CPTCFG_BACKPORTS_VERSION "\n");
+#else
 	printk(KERN_INFO "Backport generated by backports.git " CPTCFG_BACKPORTS_VERSION "\n");
-#endif
+#endif /* CPTCFG_BACKPORTS_GIT_TRACKED */
+
+#endif /* CPTCFG_BACKPORTS_GIT_TRACKED */
 
         return 0;
 }
diff --git a/devel/doc/kconfig-operation b/devel/doc/kconfig-operation
index f1ecf60..047e327 100644
--- a/devel/doc/kconfig-operation
+++ b/devel/doc/kconfig-operation
@@ -73,6 +73,11 @@ This allows code to, for example, have "#ifdef CONFIG_PM" which can only
 be set or cleared in the kernel, not in the backport configuration. Since
 this is needed, a transformation step is done at backport creation time.
 
+When using Linux backports to integrate into an existing Linux tree
+the CONFIG_BACKPORT_ prefix is used, this allows a CONFIG_BACKPORT_
+symbol to depend on the non-backported respective symbol to be selected
+allowing these to be mutually exclusive.
+
  Backport creation for Kconfig
 -------------------------------
 
diff --git a/gentree.py b/gentree.py
index 9593d31..e53aa66 100755
--- a/gentree.py
+++ b/gentree.py
@@ -16,6 +16,7 @@ from lib import bpgpg as gpg
 from lib import bpkup as kup
 from lib.tempdir import tempdir
 from lib import bpreqs as reqs
+from lib import bpversion as gen_version
 
 def read_copy_list(copyfile):
     """
@@ -613,6 +614,9 @@ def _main():
                              'and we use git ls-tree to get the files.')
     parser.add_argument('--clean', const=True, default=False, action="store_const",
                         help='Clean output directory instead of erroring if it isn\'t empty')
+    parser.add_argument('--integrate', const=True, default=False, action="store_const",
+                        help='Integrate a future backported kernel solution into ' +
+                             'an older kernel tree source directory.')
     parser.add_argument('--refresh', const=True, default=False, action="store_const",
                         help='Refresh patches as they are applied, the source dir will be modified!')
     parser.add_argument('--base-name', metavar='<name>', type=str, default='Linux',
@@ -643,13 +647,18 @@ def _main():
                              'of changes done by Coccinelle.')
     args = parser.parse_args()
 
+    if args.integrate:
+        args.outdir = os.path.join(args.outdir, 'backports/')
+
     def logwrite(msg):
         sys.stdout.write(msg)
         sys.stdout.write('\n')
         sys.stdout.flush()
 
     return process(args.kerneldir, args.outdir, args.copy_list,
-                   git_revision=args.git_revision, clean=args.clean,
+                   git_revision=args.git_revision,
+                   integrate=args.integrate,
+                   clean=args.clean,
                    refresh=args.refresh, base_name=args.base_name,
                    gitdebug=args.gitdebug, verbose=args.verbose,
                    extra_driver=args.extra_driver,
@@ -660,6 +669,7 @@ def _main():
                    logwrite=logwrite)
 
 def process(kerneldir, outdir, copy_list_file, git_revision=None,
+            integrate=False,
             clean=False, refresh=False, base_name="Linux", gitdebug=False,
             verbose=False, extra_driver=[], kup=False,
             kup_test=False,
@@ -669,7 +679,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
             git_tracked_version=False):
     class Args(object):
         def __init__(self, kerneldir, outdir, copy_list_file,
-                     git_revision, clean, refresh, base_name,
+                     git_revision, integrate, clean, refresh, base_name,
                      gitdebug, verbose, extra_driver, kup,
                      kup_test,
                      test_cocci,
@@ -678,6 +688,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
             self.outdir = outdir
             self.copy_list = copy_list_file
             self.git_revision = git_revision
+            self.integrate = integrate
             self.clean = clean
             self.refresh = refresh
             self.base_name = base_name
@@ -700,11 +711,15 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
             logwrite('Validated tree: %s' % tree)
 
     args = Args(kerneldir, outdir, copy_list_file,
-                git_revision, clean, refresh, base_name,
+                git_revision, integrate, clean, refresh, base_name,
                 gitdebug, verbose, extra_driver, kup, kup_test,
                 test_cocci, profile_cocci)
     rel_prep = None
-    integrate = False
+
+    if args.integrate:
+        if args.kup_test or args.test_cocci or args.profile_cocci or args.refresh:
+            logwrite('Cannot use integration with:\n\tkup_test\n\ttest_cocci\n\tprofile_cocci\n\trefresh\n');
+            sys.exit(1)
 
     # When building a package we use CPTCFG as we can rely on the
     # fact that kconfig treats CONFIG_ as an environment variable
@@ -752,6 +767,10 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     check_output_dir(args.outdir, args.clean)
 
     # do the copy
+    backport_integrate_files = [
+            ('Makefile.kernel', 'Makefile'),
+            ('Kconfig.integrate', 'Kconfig'),
+            ]
     backport_package_files = [(x, x) for x in [
         'Makefile',
         'kconf/',
@@ -770,8 +789,10 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
         'backport-include/',
     ]]
 
-    if not integrate:
+    if not args.integrate:
         backport_files += backport_package_files
+    else:
+        backport_files += backport_integrate_files
 
     if not args.git_revision:
         logwrite('Copy original source files ...')
@@ -780,7 +801,8 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     
     copy_files(os.path.join(source_dir, 'backport'), backport_files, args.outdir)
 
-    git_debug_init(args)
+    if not args.integrate:
+        git_debug_init(args)
 
     if not args.git_revision:
         copy_files(args.kerneldir, copy_list, args.outdir)
@@ -834,6 +856,21 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
 
     apply_patches(args, "backport", source_dir, 'patches', args.outdir, logwrite)
 
+    # Kernel integration requires Kconfig.versions already generated for you,
+    # we cannot do this for a package as we have no idea what kernel folks
+    # will be using.
+    if args.integrate:
+        kver = gen_version.kernelversion(os.path.join(args.outdir, "../"))
+        rel_specs = gen_version.get_rel_spec_stable(kver)
+        if not rel_specs:
+            logwrite('Cannot parse source kernel version, update parser')
+            sys.exit(1)
+        data = gen_version.genkconfig_versions(rel_specs)
+        fo = open(os.path.join(args.outdir, 'Kconfig.versions'), 'w')
+        fo.write(data)
+        fo.close()
+        git_debug_snapshot(args, "generate kernel version requirement Kconfig file")
+
     # some post-processing is required
     configtree = kconfig.ConfigTree(os.path.join(args.outdir, 'Kconfig'))
     orig_symbols = configtree.symbols()
@@ -854,7 +891,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
 
     symbols = configtree.symbols()
 
-    if not integrate:
+    if not args.integrate:
         # write local symbol list -- needed during build
         f = open(os.path.join(args.outdir, '.local-symbols'), 'w')
         for sym in symbols:
@@ -892,6 +929,11 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     for some_symbols in [all_symbols[i:i + 50] for i in range(0, len(all_symbols), 50)]:
         r = 'CONFIG_((?!BACKPORT)(' + '|'.join([s + '(_MODULE)?' for s in some_symbols]) + ')([^A-Za-z0-9_]|$))'
         regexes.append(re.compile(r, re.MULTILINE))
+    # Replace default prefix
+    reg = re.compile(r'(CPTCFG_)', re.MULTILINE)
+    # Get rid of doulble prefix
+    prefix = re.sub(r'^CONFIG_(.*)_', r'\1', bp_prefix)
+    reg_last = re.compile(r'(' + prefix + '_' + prefix + ')', re.MULTILINE)
     for root, dirs, files in os.walk(args.outdir):
         # don't go into .git dir (possible debug thing)
         if '.git' in dirs:
@@ -900,6 +942,9 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
             data = open(os.path.join(root, f), 'r').read()
             for r in regexes:
                 data = r.sub(r'' + bp_prefix + '\\1', data)
+            if bp_prefix != 'CPTCFG_':
+                data = reg.sub(r'' + bp_prefix + '', data)
+                data = reg_last.sub(r'' + prefix + '', data)
             data = re.sub(r'\$\(srctree\)', '$(backport_srctree)', data)
             data = re.sub(r'-Idrivers', '-I$(backport_srctree)/drivers', data)
             fo = open(os.path.join(root, f), 'w')
@@ -909,7 +954,10 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     git_debug_snapshot(args, "rename config symbol / srctree usage")
 
     # disable unbuildable Kconfig symbols and stuff Makefiles that doesn't exist
-    maketree = make.MakeTree(os.path.join(args.outdir, 'Makefile.kernel'))
+    if args.integrate:
+        maketree = make.MakeTree(os.path.join(args.outdir, 'Makefile'))
+    else:
+        maketree = make.MakeTree(os.path.join(args.outdir, 'Makefile.kernel'))
     disable_kconfig = []
     disable_makefile = []
     for sym in maketree.get_impossible_symbols():
@@ -956,6 +1004,15 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
         fo.close()
     git_debug_snapshot(args, "disable unsatisfied Makefile parts")
 
+    if args.integrate:
+        f = open(os.path.join(args.outdir, '../Kconfig'), 'a')
+        f.write('source "backports/Kconfig"\n')
+        f.close()
+        git_debug_snapshot(args, "hooked backport to top level Kconfig")
+
+        apply_patches(args, "integration", source_dir, 'integration-patches/',
+                      os.path.join(args.outdir, '../'), logwrite)
+
     if (args.kup or args.kup_test):
         req = reqs.Req()
         req.kup()
diff --git a/integration-patches/0001-enable-backports/0001-enable-backports-built-in.patch b/integration-patches/0001-enable-backports/0001-enable-backports-built-in.patch
new file mode 100644
index 0000000..d66b203
--- /dev/null
+++ b/integration-patches/0001-enable-backports/0001-enable-backports-built-in.patch
@@ -0,0 +1,40 @@
+Allow backports to be integrated into vmlinux.
+
+diff --git a/Makefile b/Makefile
+index 6d1e304..de26b18 100644
+--- a/Makefile
++++ b/Makefile
+@@ -542,6 +542,7 @@ scripts: scripts_basic include/config/auto.conf include/config/tristate.conf \
+ 	$(Q)$(MAKE) $(build)=$(@)
+ 
+ # Objects we will link into vmlinux / subdirs we need to visit
++backports-y 	:= backports/
+ init-y		:= init/
+ drivers-y	:= drivers/ sound/ firmware/
+ net-y		:= net/
+@@ -820,13 +821,16 @@ core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+ 
+ vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
+ 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
++		     $(backports-y) $(backports-m) \
+ 		     $(net-y) $(net-m) $(libs-y) $(libs-m)))
+ 
+ vmlinux-alldirs	:= $(sort $(vmlinux-dirs) $(patsubst %/,%,$(filter %/, \
+ 		     $(init-n) $(init-) \
+ 		     $(core-n) $(core-) $(drivers-n) $(drivers-) \
++		     $(backports-n) $(backports-) \
+ 		     $(net-n)  $(net-)  $(libs-n)    $(libs-))))
+ 
++backports-y	:= $(patsubst %/, %/built-in.o, $(backports-y))
+ init-y		:= $(patsubst %/, %/built-in.o, $(init-y))
+ core-y		:= $(patsubst %/, %/built-in.o, $(core-y))
+ drivers-y	:= $(patsubst %/, %/built-in.o, $(drivers-y))
+@@ -837,7 +841,7 @@ libs-y		:= $(libs-y1) $(libs-y2)
+ 
+ # Externally visible symbols (used by link-vmlinux.sh)
+ export KBUILD_VMLINUX_INIT := $(head-y) $(init-y)
+-export KBUILD_VMLINUX_MAIN := $(core-y) $(libs-y) $(drivers-y) $(net-y)
++export KBUILD_VMLINUX_MAIN := $(core-y) $(libs-y) $(drivers-y) $(net-y) $(backports-y)
+ export KBUILD_LDS          := arch/$(SRCARCH)/kernel/vmlinux.lds
+ export LDFLAGS_vmlinux
+ # used by scripts/pacmage/Makefile
diff --git a/lib/bpversion.py b/lib/bpversion.py
new file mode 100644
index 0000000..aefdcf0
--- /dev/null
+++ b/lib/bpversion.py
@@ -0,0 +1,48 @@
+import subprocess, os, re
+
+class VersionError(Exception):
+    pass
+class ExecutionError(VersionError):
+    def __init__(self, errcode):
+        self.error_code = errcode
+
+def _check(process):
+    if process.returncode != 0:
+        raise ExecutionError(process.returncode)
+
+def get_rel_spec_stable(rel):
+    """
+    Returns release specs for a linux-stable backports based release.
+    """
+    m = None
+    if ("rc" in rel):
+        m = re.match(r"v*(?P<VERSION>\d+)\.+" \
+                     "(?P<PATCHLEVEL>\d+)[.]*" \
+                     "(?P<SUBLEVEL>\d*)" \
+                     "[-rc]+(?P<RC_VERSION>\d+)",
+                     rel)
+    else:
+        m = re.match(r"(?P<VERSION>\d+)\.+" \
+                     "(?P<PATCHLEVEL>\d+)[.]*" \
+                     "(?P<SUBLEVEL>\d*)",
+                     rel)
+    if (not m):
+        return m
+    return m.groupdict()
+
+def kernelversion(tree):
+    cmd = ['make', '--no-print-directory', '-C', tree, 'kernelversion' ]
+    process = subprocess.Popen(cmd,
+                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
+                               close_fds=True, universal_newlines=True)
+    stdout = process.communicate()[0]
+    process.wait()
+    _check(process)
+    return stdout.strip()
+
+def genkconfig_versions(rel_specs):
+    data = ''
+    for i in range(int(rel_specs['PATCHLEVEL']) + 1, 99):
+        data += "config BACKPORT_KERNEL_%s_%s\n" % (rel_specs['VERSION'], i)
+        data += "    def_bool y\n"
+    return data
diff --git a/lib/kconfig.py b/lib/kconfig.py
index f89e468..40a5303 100644
--- a/lib/kconfig.py
+++ b/lib/kconfig.py
@@ -12,6 +12,8 @@ cfg_line = re.compile(r'^(?P<opt>config|menuconfig)\s+(?P<sym>[^\s]*)')
 sel_line = re.compile(r'^(?P<spc>\s+)select\s+(?P<sym>[^\s]*)\s*$')
 backport_line = re.compile(r'^\s+#(?P<key>[ch]-file|module-name)\s*(?P<name>.*)')
 ignore_parse_p = re.compile(r'^\s*#(?P<key>ignore-parser-package)')
+kernel_version_config = re.compile(r'^(?P<opt>config)\s+(?P<sym>BACKPORT_KERNEL_[\d])')
+ignore_syms = re.compile(r'^(?P<opt>config|menuconfig)\s+(?P<sym>BACKPORT_DIR|BACKPORTS_VERSION|BACKPORTED_KERNEL_VERSION|BACKPORTED_KERNEL_NAME|BACKPORT_LINUX)')
 
 class ConfigTree(object):
     def __init__(self, rootfile):
@@ -109,6 +111,14 @@ class ConfigTree(object):
                 if pm:
                     ignore_parse_modular = True
                     continue
+                vm = kernel_version_config.match(l)
+                if vm:
+                    out += l
+                    continue
+                ig = ignore_syms.match(l)
+                if ig:
+                    out += l
+                    continue
                 n = cfg_line.match(l)
                 if n:
                     m = n
-- 
2.1.1

