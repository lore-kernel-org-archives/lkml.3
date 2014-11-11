Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaKKIRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:17:00 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39354 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaKKIQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:16:56 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 21/21] backports: add full kernel integration support
Date: Tue, 11 Nov 2014 00:15:12 -0800
Message-Id: <1415693712-23743-22-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
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

mcgrof@drvbp1 ~/backports (git::master)$ time ./gentree.py --clean \
	/home/mcgrof/linux-next /home/mcgrof/build/backports-20141023
Copy original source files ...
Applying patches from patches to /home/mcgrof/build/backports-20141023
...
Modify Kconfig tree ...
Rewrite Makefiles and Kconfig files ...
Done!

real    1m27.942s
user    13m23.752s
sys     0m47.608s

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

real    42m44.838s
user    1190m5.092s
sys     140m37.208s

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/Kconfig.integrate                         | 36 +++++++++++
 backport/Makefile.kernel                           | 13 ++++
 backport/backport-include/backport/backport.h      |  5 ++
 backport/compat/Makefile                           |  4 ++
 backport/compat/main.c                             |  8 ++-
 devel/doc/kconfig-operation                        |  5 ++
 gentree.py                                         | 72 ++++++++++++++++++++--
 .../0001-enable-backports-built-in.patch           | 40 ++++++++++++
 lib/bpversion.py                                   | 48 +++++++++++++++
 lib/kconfig.py                                     | 67 ++++++++++++++++++++
 10 files changed, 291 insertions(+), 7 deletions(-)
 create mode 100644 backport/Kconfig.integrate
 create mode 100644 integration-patches/0001-enable-backports/0001-enable-backports-built-in.patch
 create mode 100644 lib/bpversion.py

diff --git a/backport/Kconfig.integrate b/backport/Kconfig.integrate
new file mode 100644
index 0000000..f64a3f6
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
+config BACKPORT_VERSION
+	string
+	default "%%BACKPORTS_VERSION%%"
+
+config BACKPORT_KERNEL_VERSION
+	string
+	default "%%BACKPORTED_KERNEL_VERSION%%"
+
+config BACKPORT_KERNEL_NAME
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
index a63184b..c57b2d3 100644
--- a/backport/Makefile.kernel
+++ b/backport/Makefile.kernel
@@ -1,3 +1,4 @@
+ifeq ($(CONFIG_BACKPORT_INTEGRATE),)
 # Since 2.6.21, try-run is available, but cc-disable-warning
 # was only added later, so we add it here ourselves:
 backport-cc-disable-warning = $(call try-run,\
@@ -17,6 +18,18 @@ NOSTDINC_FLAGS := \
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
index e787763..f14b516 100644
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
index 04ebbfd..5d45e3d 100644
--- a/backport/compat/main.c
+++ b/backport/compat/main.c
@@ -71,8 +71,14 @@ static int __init backport_init(void)
 #ifdef BACKPORTS_GIT_TRACKED
 	printk(KERN_INFO BACKPORTS_GIT_TRACKED "\n");
 #else
+
+#ifdef CONFIG_BACKPORT_INTEGRATE
+	printk(KERN_INFO "Backport integrated by backports.git " CPTCFG_VERSION "\n");
+#else
 	printk(KERN_INFO "Backport generated by backports.git " CPTCFG_VERSION "\n");
-#endif
+#endif /* CONFIG_BACKPORT_INTEGRATE */
+
+#endif /* BACKPORTS_GIT_TRACKED */
 
         return 0;
 }
diff --git a/devel/doc/kconfig-operation b/devel/doc/kconfig-operation
index ddb4de7..35e198c 100644
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
index 90334ef..00e2d46 100755
--- a/gentree.py
+++ b/gentree.py
@@ -16,6 +16,7 @@ from lib import bpgpg as gpg
 from lib import bpkup as kup
 from lib.tempdir import tempdir
 from lib import bpreqs as reqs
+from lib import bpversion as gen_version
 
 class Bp_Identity(object):
     """
@@ -233,6 +234,9 @@ def add_automatic_backports(args):
     export = re.compile(r'^EXPORT_SYMBOL(_GPL)?\((?P<sym>[^\)]*)\)')
     bpi = kconfig.get_backport_info(os.path.join(args.bpid.target_dir, 'compat', 'Kconfig'))
     configtree = kconfig.ConfigTree(os.path.join(args.bpid.target_dir, 'Kconfig'), args.bpid)
+    ignore=['Kconfig.kernel', 'Kconfig.versions']
+    configtree.verify_sources(ignore=ignore)
+    git_debug_snapshot(args, "verify sources for automatic backports")
     all_selects = configtree.all_selects()
     for sym, vals in bpi.items():
         if sym.startswith('BPAUTO_BUILD_'):
@@ -640,6 +644,9 @@ def _main():
                              'and we use git ls-tree to get the files.')
     parser.add_argument('--clean', const=True, default=False, action="store_const",
                         help='Clean output directory instead of erroring if it isn\'t empty')
+    parser.add_argument('--integrate', const=True, default=False, action="store_const",
+                        help='Integrate a future backported kernel solution into ' +
+                             'an older kernel tree source directory.')
     parser.add_argument('--refresh', const=True, default=False, action="store_const",
                         help='Refresh patches as they are applied, the source dir will be modified!')
     parser.add_argument('--base-name', metavar='<name>', type=str, default='Linux',
@@ -679,9 +686,8 @@ def _main():
     # same prefix for packaging as with kernel integration but
     # there are already some users of the CPTCFG prefix.
     bpid = None
-    integrate = False
-    if integrate:
-        bpid = Bp_Identity(integrate = integrate,
+    if args.integrate:
+        bpid = Bp_Identity(integrate = args.integrate,
                            kconfig_prefix = 'CONFIG_',
                            project_prefix = 'BACKPORT_',
                            project_dir = args.outdir,
@@ -690,7 +696,7 @@ def _main():
                            kconfig_source_var = '$BACKPORT_DIR',
                            )
     else:
-        bpid = Bp_Identity(integrate = integrate,
+        bpid = Bp_Identity(integrate = args.integrate,
                            kconfig_prefix = 'CPTCFG_',
                            project_prefix = '',
                            project_dir = args.outdir,
@@ -764,6 +770,11 @@ def process(kerneldir, copy_list_file, git_revision=None,
                 test_cocci, profile_cocci)
     rel_prep = None
 
+    if bpid.integrate:
+        if args.kup_test or args.test_cocci or args.profile_cocci or args.refresh:
+            logwrite('Cannot use integration with:\n\tkup_test\n\ttest_cocci\n\tprofile_cocci\n\trefresh\n');
+            sys.exit(1)
+
     # start processing ...
     if (args.kup or args.kup_test):
         git_paranoia(source_dir, logwrite)
@@ -798,6 +809,10 @@ def process(kerneldir, copy_list_file, git_revision=None,
     check_output_dir(bpid.target_dir, args.clean)
 
     # do the copy
+    backport_integrate_files = [
+            ('Makefile.kernel', 'Makefile'),
+            ('Kconfig.integrate', 'Kconfig'),
+            ]
     backport_package_files = [(x, x) for x in [
         'Makefile',
         'kconf/',
@@ -819,6 +834,8 @@ def process(kerneldir, copy_list_file, git_revision=None,
 
     if not bpid.integrate:
         backport_files += backport_package_files
+    else:
+        backport_files += backport_integrate_files
 
     if not args.git_revision:
         logwrite('Copy original source files ...')
@@ -888,6 +905,21 @@ def process(kerneldir, copy_list_file, git_revision=None,
 
     apply_patches(args, "backport", source_dir, 'patches', bpid.target_dir, logwrite)
 
+    # Kernel integration requires Kconfig.versions already generated for you,
+    # we cannot do this for a package as we have no idea what kernel folks
+    # will be using.
+    if bpid.integrate:
+        kver = gen_version.kernelversion(bpid.project_dir)
+        rel_specs = gen_version.get_rel_spec_stable(kver)
+        if not rel_specs:
+            logwrite('Cannot parse source kernel version, update parser')
+            sys.exit(1)
+        data = gen_version.genkconfig_versions(rel_specs)
+        fo = open(os.path.join(bpid.target_dir, 'Kconfig.versions'), 'w')
+        fo.write(data)
+        fo.close()
+        git_debug_snapshot(args, "generate kernel version requirement Kconfig file")
+
     # some post-processing is required
     configtree = kconfig.ConfigTree(os.path.join(bpid.target_dir, 'Kconfig'), bpid)
     ignore=['Kconfig.kernel', 'Kconfig.versions']
@@ -905,6 +937,15 @@ def process(kerneldir, copy_list_file, git_revision=None,
         configtree.force_tristate_modular()
         git_debug_snapshot(args, "force tristate options modular")
 
+    ignore = [os.path.join(bpid.target_dir, x) for x in [
+                'Kconfig.package.hacks',
+                'Kconfig.versions',
+                'Kconfig',
+                ]
+            ]
+    configtree.adjust_backported_configs(ignore=ignore, orig_symbols=orig_symbols)
+    git_debug_snapshot(args, "adjust backports config symbols we port")
+
     configtree.modify_selects()
     git_debug_snapshot(args, "convert select to depends on")
 
@@ -944,8 +985,15 @@ def process(kerneldir, copy_list_file, git_revision=None,
 
     # rewrite Makefile and source symbols
 
+    # symbols we know only we can provide under the backport project prefix
+    # for which we need an exception.
+    skip_orig_syms = [ bpid.project_prefix + x for x in [
+            'INTEGRATE',
+            ]
+    ]
+    parse_orig_syms = [x for x in orig_symbols if x not in skip_orig_syms ]
     regexes = []
-    for some_symbols in [orig_symbols[i:i + 50] for i in range(0, len(orig_symbols), 50)]:
+    for some_symbols in [parse_orig_syms[i:i + 50] for i in range(0, len(parse_orig_syms), 50)]:
         r = 'CONFIG_((' + '|'.join([s + '(_MODULE)?' for s in some_symbols]) + ')([^A-Za-z0-9_]|$))'
         regexes.append(re.compile(r, re.MULTILINE))
     for root, dirs, files in os.walk(bpid.target_dir):
@@ -967,7 +1015,10 @@ def process(kerneldir, copy_list_file, git_revision=None,
     git_debug_snapshot(args, "rename config symbol / srctree usage")
 
     # disable unbuildable Kconfig symbols and stuff Makefiles that doesn't exist
-    maketree = make.MakeTree(os.path.join(bpid.target_dir, 'Makefile.kernel'))
+    if bpid.integrate:
+        maketree = make.MakeTree(os.path.join(bpid.target_dir, 'Makefile'))
+    else:
+        maketree = make.MakeTree(os.path.join(bpid.target_dir, 'Makefile.kernel'))
     disable_kconfig = []
     disable_makefile = []
     for sym in maketree.get_impossible_symbols():
@@ -1017,6 +1068,15 @@ def process(kerneldir, copy_list_file, git_revision=None,
         fo.close()
     git_debug_snapshot(args, "disable unsatisfied Makefile parts")
 
+    if bpid.integrate:
+        f = open(os.path.join(bpid.project_dir, 'Kconfig'), 'a')
+        f.write('source "backports/Kconfig"\n')
+        f.close()
+        git_debug_snapshot(args, "hooked backport to top level Kconfig")
+
+        apply_patches(args, "integration", source_dir, 'integration-patches/',
+                      bpid.project_dir, logwrite)
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
index ca3af63..ea9c121 100644
--- a/lib/kconfig.py
+++ b/lib/kconfig.py
@@ -137,6 +137,73 @@ class ConfigTree(object):
             outf.write(out)
             outf.close()
 
+    def _mod_kconfig_line(self, l, orig_symbols):
+        if self.bpid.project_prefix != '':
+            for sym in orig_symbols:
+                if sym in l:
+                    return re.sub(r' (' + sym + ')', r' ' + self.bpid.project_prefix + '\\1', l)
+        return l
+
+    def adjust_backported_configs(self, ignore=[], orig_symbols=[]):
+        m = None
+        old_l = None
+        for nf in self._walk(self.rootfile):
+            if os.path.join(self.bpid.target_dir, nf) in ignore:
+                continue
+            out = ''
+            for l in open(os.path.join(self.bpid.target_dir, nf), 'r'):
+                n = cfg_line.match(l)
+                if n:
+                    m = n
+                    old_l = l
+                    continue
+                # We're now on the second line for the config symbol
+                if m:
+                    built_in_sym = m.group('sym')
+                    if self.bpid.project_prefix != '':
+                        built_in_sym = re.sub(r'' + self.bpid.project_prefix + '(.*)', r'\1', m.group('sym'))
+                    # These are things that we carry as part of our backports
+                    # module or things we automatically copy over into our
+                    # backports module. What we want to do is ensure that we
+                    # always negate a backported symbol we provide with the one
+                    # provided by the old kernel.
+                    #
+                    # Note that this means that since project_prefix is empty
+                    # it likely means the kconfig getenv() trick was used to
+                    # backport and when that's used the same symbol is used,
+                    # that means you can't easily negate an internal symbol
+                    # as kconfig will always apply the kconfig_prefix.
+                    #
+                    # XXX: only do this for symbols that have C files
+                    # depending on it
+                    if self.bpid.project_prefix != '' and self.bpid.project_prefix in m.group('sym'):
+                        out += old_l
+                        out += l
+                        out += "\tdepends on !%s\n" % (built_in_sym)
+                    else:
+                        # First rewrite the upstream symbol with our prefix if
+                        # needed
+                        if self.bpid.project_prefix != '':
+                            out += m.group('opt') + ' ' + self.bpid.project_prefix + m.group('sym') + '\n'
+                            out += l
+                            # Packaging uses the checks.h but that's a reactive
+                            # measure, this is proactive.
+                            if not self.bpid.integrate:
+                                # This doesn't happen right now as packaging
+                                # always uses an empty project prefix.
+                                out += "\tdepends on %s!=y\n" % (built_in_sym)
+                            else:
+                                out += "\tdepends on !%s\n" % (built_in_sym)
+                        else:
+                            out += m.group('opt') + ' ' + m.group('sym') + '\n'
+                            out += l
+                    m = None
+                else:
+                    out += self._mod_kconfig_line(l, orig_symbols)
+            outf = open(os.path.join(self.bpid.target_dir, nf), 'w')
+            outf.write(out)
+            outf.close()
+
     def symbols(self):
         syms = []
         for nf in self._walk(self.rootfile):
-- 
2.1.1

