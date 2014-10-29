Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148AbaJ2QAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:00:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933688AbaJ2QAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:00:05 -0400
Date: Wed, 29 Oct 2014 17:00:04 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Stefan Assmann <sassmann@kpanic.de>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz
Subject: Re: [RFC v2 4/4] backports: add kernl integration support to
	gentree.py
Message-ID: <20141029160003.GW28966@wotan.suse.de>
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com> <1414570902-5675-5-git-send-email-mcgrof@do-not-panic.com> <5451099B.7090102@kpanic.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5451099B.7090102@kpanic.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 04:36:59PM +0100, Stefan Assmann wrote:
> On 29.10.2014 09:21, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > ---
> >  backport/Kconfig                              |  54 --------
> >  backport/Kconfig.sources                      |  23 ++++
> >  backport/Makefile                             |   3 +-
> >  backport/Makefile.kernel                      |  18 +++
> >  backport/backport-include/backport/backport.h |   2 +
> >  backport/compat/Makefile                      |   4 +
> >  gentree.py                                    | 186 +++++++++++++++++++++-----
> >  lib/bpversion.py                              |  48 +++++++
> >  lib/kconfig.py                                |  12 +-
> >  9 files changed, 260 insertions(+), 90 deletions(-)
> >  delete mode 100644 backport/Kconfig
> >  create mode 100644 backport/Kconfig.sources
> >  create mode 100644 lib/bpversion.py
> 
> This breaks my usual gentree.py run.
> 
> ~/backports> ./gentree.py --clean --git-revision next-20141023 ~/backports/linux-next/ /dev/shm/backports-next
> Get original source files from git ...
> Traceback (most recent call last):
>   File "./gentree.py", line 1028, in <module>
>     ret = _main()
>   File "./gentree.py", line 517, in _main
>     logwrite=logwrite)
>   File "./gentree.py", line 637, in process
>     copy_files(os.path.join(source_dir, 'backport'), backport_files, args.outdir)
>   File "./gentree.py", line 175, in copy_files
>     os.path.join(outdir, tgtitem))
>   File "/usr/lib64/python2.7/shutil.py", line 119, in copy
>     copyfile(src, dst)
>   File "/usr/lib64/python2.7/shutil.py", line 82, in copyfile
>     with open(src, 'rb') as fsrc:
> IOError: [Errno 2] No such file or directory: '/root/backports/backport/Kconfig.package'
> 
> I don't see Kconfig.package in this series. Did you forget to git add it?

Oops yes, here is the new patch:

>From 2f981d2de3da505d3ad54778afd7c8789c2b46cc Mon Sep 17 00:00:00 2001
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Wed, 29 Oct 2014 01:08:24 -0700
Subject: [PATCH] backports: add kernl integration support to gentree.py

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/Kconfig                              |  54 --------
 backport/Kconfig.package                      |  31 +++++
 backport/Kconfig.sources                      |  23 ++++
 backport/Makefile                             |   3 +-
 backport/Makefile.kernel                      |  18 +++
 backport/backport-include/backport/backport.h |   2 +
 backport/compat/Makefile                      |   4 +
 gentree.py                                    | 186 +++++++++++++++++++++-----
 lib/bpversion.py                              |  48 +++++++
 lib/kconfig.py                                |  12 +-
 10 files changed, 291 insertions(+), 90 deletions(-)
 delete mode 100644 backport/Kconfig
 create mode 100644 backport/Kconfig.package
 create mode 100644 backport/Kconfig.sources
 create mode 100644 lib/bpversion.py

diff --git a/backport/Kconfig b/backport/Kconfig
deleted file mode 100644
index c523323..0000000
--- a/backport/Kconfig
+++ /dev/null
@@ -1,54 +0,0 @@
-mainmenu "Linux Backports from $BACKPORTED_KERNEL_NAME $BACKPORTED_KERNEL_VERSION (with backports $BACKPORTS_VERSION)"
-
-config BACKPORT_DIR
-	string
-	option env="BACKPORT_DIR"
-config BACKPORTS_VERSION
-	string
-	option env="BACKPORTS_VERSION"
-config BACKPORTED_KERNEL_VERSION
-	string
-	option env="BACKPORTED_KERNEL_VERSION"
-config BACKPORTED_KERNEL_NAME
-	string
-	option env="BACKPORTED_KERNEL_NAME"
-
-# these will be generated
-source "$BACKPORT_DIR/Kconfig.kernel"
-source "$BACKPORT_DIR/Kconfig.versions"
-
-# some hacks for when we use backports to generate a package
-# to build modules out of tree.
-#ignore-parser-package
-config WIRELESS
-	def_bool y
-#ignore-parser-package
-config NET_CORE
-	def_bool y
-#ignore-parser-package
-config EXPERT
-	def_bool y
-
-# this has the configuration for the backport code
-source "$BACKPORT_DIR/compat/Kconfig"
-
-# these are copied from the kernel
-source "$BACKPORT_DIR/net/wireless/Kconfig"
-source "$BACKPORT_DIR/net/mac80211/Kconfig"
-source "$BACKPORT_DIR/net/bluetooth/Kconfig"
-source "$BACKPORT_DIR/drivers/net/wireless/Kconfig"
-source "$BACKPORT_DIR/drivers/net/ethernet/Kconfig"
-source "$BACKPORT_DIR/drivers/net/usb/Kconfig"
-
-source "$BACKPORT_DIR/drivers/ssb/Kconfig"
-source "$BACKPORT_DIR/drivers/bcma/Kconfig"
-
-source "$BACKPORT_DIR/net/nfc/Kconfig"
-
-source "$BACKPORT_DIR/drivers/media/Kconfig"
-
-source "$BACKPORT_DIR/net/ieee802154/Kconfig"
-source "$BACKPORT_DIR/net/mac802154/Kconfig"
-source "$BACKPORT_DIR/drivers/net/ieee802154/Kconfig"
-
-source "$BACKPORT_DIR/drivers/usb/class/Kconfig"
diff --git a/backport/Kconfig.package b/backport/Kconfig.package
new file mode 100644
index 0000000..1382cdb
--- /dev/null
+++ b/backport/Kconfig.package
@@ -0,0 +1,31 @@
+mainmenu "Backports from $BACKPORTED_KERNEL_NAME $BACKPORTED_KERNEL_VERSION (backports $BACKPORTS_VERSION)"
+
+config BACKPORT_DIR
+	string
+	option env="BACKPORT_DIR"
+config BACKPORTS_VERSION
+	string
+	option env="BACKPORTS_VERSION"
+config BACKPORTED_KERNEL_VERSION
+	string
+	option env="BACKPORTED_KERNEL_VERSION"
+config BACKPORTED_KERNEL_NAME
+	string
+	option env="BACKPORTED_KERNEL_NAME"
+
+# some hacks for when we use backports to generate a package
+# to build modules out of tree.
+#ignore-parser-package
+config WIRELESS
+	def_bool y
+#ignore-parser-package
+config NET_CORE
+	def_bool y
+#ignore-parser-package
+config EXPERT
+	def_bool y
+
+# these will be generated
+source "$BACKPORT_DIR/Kconfig.kernel"
+source "$BACKPORT_DIR/Kconfig.versions"
+source "$BACKPORT_DIR/Kconfig.sources"
diff --git a/backport/Kconfig.sources b/backport/Kconfig.sources
new file mode 100644
index 0000000..cdf993c
--- /dev/null
+++ b/backport/Kconfig.sources
@@ -0,0 +1,23 @@
+# this has the configuration for the backport code
+source "$BACKPORT_DIR/compat/Kconfig"
+
+# these are copied from the kernel
+source "$BACKPORT_DIR/net/wireless/Kconfig"
+source "$BACKPORT_DIR/net/mac80211/Kconfig"
+source "$BACKPORT_DIR/net/bluetooth/Kconfig"
+source "$BACKPORT_DIR/drivers/net/wireless/Kconfig"
+source "$BACKPORT_DIR/drivers/net/ethernet/Kconfig"
+source "$BACKPORT_DIR/drivers/net/usb/Kconfig"
+
+source "$BACKPORT_DIR/drivers/ssb/Kconfig"
+source "$BACKPORT_DIR/drivers/bcma/Kconfig"
+
+source "$BACKPORT_DIR/net/nfc/Kconfig"
+
+source "$BACKPORT_DIR/drivers/media/Kconfig"
+
+source "$BACKPORT_DIR/net/ieee802154/Kconfig"
+source "$BACKPORT_DIR/net/mac802154/Kconfig"
+source "$BACKPORT_DIR/drivers/net/ieee802154/Kconfig"
+
+source "$BACKPORT_DIR/drivers/usb/class/Kconfig"
diff --git a/backport/Makefile b/backport/Makefile
index fcf2f01..b2ada90 100644
--- a/backport/Makefile
+++ b/backport/Makefile
@@ -19,8 +19,9 @@ KLIB_BUILD ?= $(KLIB)/build/
 KERNEL_CONFIG := $(KLIB_BUILD)/.config
 KERNEL_MAKEFILE := $(KLIB_BUILD)/Makefile
 CONFIG_MD5 := $(shell md5sum $(KERNEL_CONFIG) 2>/dev/null | sed 's/\s.*//')
+BACKPORT_PACKAGE := 1
 
-export KLIB KLIB_BUILD BACKPORT_DIR KMODDIR KMODPATH_ARG
+export KLIB KLIB_BUILD BACKPORT_DIR KMODDIR KMODPATH_ARG BACKPORT_PACKAGE
 
 # disable built-in rules for this file
 .SUFFIXES:
diff --git a/backport/Makefile.kernel b/backport/Makefile.kernel
index c31def8..6efea0d 100644
--- a/backport/Makefile.kernel
+++ b/backport/Makefile.kernel
@@ -1,3 +1,4 @@
+ifneq ($(BACKPORT_PACKAGE),)
 # Since 2.6.21, try-run is available, but cc-disable-warning
 # was only added later, so we add it here ourselves:
 backport-cc-disable-warning = $(call try-run,\
@@ -13,10 +14,27 @@ NOSTDINC_FLAGS := \
 	-DBACKPORTS_VERSION=\"$(BACKPORTS_VERSION)\" \
 	-DBACKPORTED_KERNEL_VERSION=\"$(BACKPORTED_KERNEL_VERSION)\" \
 	-DBACKPORTED_KERNEL_NAME=\"$(BACKPORTED_KERNEL_NAME)\" \
+	-DBACKPORT_PACKAGE=\"$(BACKPORT_PACKAGE)\" \
 	$(BACKPORTS_GIT_TRACKER_DEF) \
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
+	-DBACKPORTS_VERSION=\"$(BACKPORTS_VERSION)\" \
+	-DBACKPORTED_KERNEL_VERSION=\"$(BACKPORTED_KERNEL_VERSION)\" \
+	-DBACKPORTED_KERNEL_NAME=\"$(BACKPORTED_KERNEL_NAME)\" \
+	$(BACKPORTS_GIT_TRACKER_DEF) \
+	$(CFLAGS)
+endif
+
 
 obj-y += compat/
 
diff --git a/backport/backport-include/backport/backport.h b/backport/backport-include/backport/backport.h
index 8edb151..10c7c35 100644
--- a/backport/backport-include/backport/backport.h
+++ b/backport/backport-include/backport/backport.h
@@ -1,6 +1,8 @@
 #ifndef __BACKPORT_H
 #define __BACKPORT_H
+#ifdef BACKPORT_PACKAGE
 #include <backport/autoconf.h>
+#endif
 #include <linux/kconfig.h>
 
 #ifndef __ASSEMBLY__
diff --git a/backport/compat/Makefile b/backport/compat/Makefile
index aba2c3a..b8fa48c 100644
--- a/backport/compat/Makefile
+++ b/backport/compat/Makefile
@@ -1,5 +1,9 @@
 ccflags-y += -I$(src)
+ifneq ($(BACKPORT_PACKAGE),)
 obj-m += compat.o
+else
+obj-y += compat.o
+endif
 compat-y += main.o
 
 # Kernel backport compatibility code
diff --git a/gentree.py b/gentree.py
index 47e3ca2..971f15b 100755
--- a/gentree.py
+++ b/gentree.py
@@ -16,6 +16,7 @@ from lib import bpgpg as gpg
 from lib import bpkup as kup
 from lib.tempdir import tempdir
 from lib import bpreqs as reqs
+from lib import bpversion as gen_version
 
 def read_copy_list(copyfile):
     """
@@ -461,6 +462,9 @@ def _main():
                              'and we use git ls-tree to get the files.')
     parser.add_argument('--clean', const=True, default=False, action="store_const",
                         help='Clean output directory instead of erroring if it isn\'t empty')
+    parser.add_argument('--integrate', const=True, default=False, action="store_const",
+                        help='Integrate a future backported kernel solution into ' +
+                             'an older kernel tree source directory.')
     parser.add_argument('--refresh', const=True, default=False, action="store_const",
                         help='Refresh patches as they are applied, the source dir will be modified!')
     parser.add_argument('--base-name', metavar='<name>', type=str, default='Linux',
@@ -491,13 +495,18 @@ def _main():
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
@@ -508,6 +517,7 @@ def _main():
                    logwrite=logwrite)
 
 def process(kerneldir, outdir, copy_list_file, git_revision=None,
+            integrate=False,
             clean=False, refresh=False, base_name="Linux", gitdebug=False,
             verbose=False, extra_driver=[], kup=False,
             kup_test=False,
@@ -517,7 +527,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
             git_tracked_version=False):
     class Args(object):
         def __init__(self, kerneldir, outdir, copy_list_file,
-                     git_revision, clean, refresh, base_name,
+                     git_revision, integrate, clean, refresh, base_name,
                      gitdebug, verbose, extra_driver, kup,
                      kup_test,
                      test_cocci,
@@ -526,6 +536,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
             self.outdir = outdir
             self.copy_list = copy_list_file
             self.git_revision = git_revision
+            self.integrate = integrate
             self.clean = clean
             self.refresh = refresh
             self.base_name = base_name
@@ -548,11 +559,15 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
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
 
     # start processing ...
     if (args.kup or args.kup_test):
@@ -588,11 +603,32 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     check_output_dir(args.outdir, args.clean)
 
     # do the copy
+    backport_integrate_files = [
+            ('Makefile.kernel', 'Makefile'),
+            ]
+    backport_package_files = [(x, x) for x in [
+        'Makefile',
+        'kconf/' ,
+        'Makefile.real',
+        'Makefile.kernel',
+        'scripts/',
+        '.blacklist.map',
+        '.gitignore',
+        'Makefile.build'] ]
+    backport_package_files += [
+            ('Kconfig.package', 'Kconfig'),
+            ]
     backport_files = [(x, x) for x in [
-        'Kconfig', 'Makefile', 'Makefile.build', 'Makefile.kernel', '.gitignore',
-        'Makefile.real', 'compat/', 'backport-include/', 'kconf/',
-        'scripts/', '.blacklist.map',
+        'Kconfig.sources',
+        'compat/',
+        'backport-include/',
     ]]
+
+    if not args.integrate:
+        backport_files += backport_package_files
+    else:
+        backport_files += backport_integrate_files
+
     if not args.git_revision:
         logwrite('Copy original source files ...')
     else:
@@ -600,7 +636,8 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     
     copy_files(os.path.join(source_dir, 'backport'), backport_files, args.outdir)
 
-    git_debug_init(args)
+    if not args.integrate:
+        git_debug_init(args)
 
     if not args.git_revision:
         copy_files(args.kerneldir, copy_list, args.outdir)
@@ -615,6 +652,60 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
 
     git_debug_snapshot(args, 'Add driver sources')
 
+    if git_tracked_version:
+        backports_version = "(see git)"
+        kernel_version = "(see git)"
+    else:
+        backports_version = git.describe(tree=source_dir, extra_args=['--long'])
+        kernel_version = git.describe(rev=args.git_revision or 'HEAD',
+                                      tree=args.kerneldir,
+                                      extra_args=['--long'])
+
+    if not args.integrate:
+        f = open(os.path.join(args.outdir, 'versions'), 'w')
+        f.write('BACKPORTS_VERSION="%s"\n' % backports_version)
+        f.write('BACKPORTED_KERNEL_VERSION="%s"\n' % kernel_version)
+        f.write('BACKPORTED_KERNEL_NAME="%s"\n' % args.base_name)
+        if git_tracked_version:
+            f.write('BACKPORTS_GIT_TRACKED="backport tracker ID: $(shell git rev-parse HEAD 2>/dev/null || echo \'not built in git tree\')"\n')
+        f.close()
+        git_debug_snapshot(args, "generate kernel version info file: version")
+    else:
+        # Only the kconfig 'mainmenu' entries grok variables, we want to keep
+        # this the main Kconfig as part of our program to be able to give it
+        # enough dynamic information
+        k = open(os.path.join(args.outdir, 'Kconfig'), 'w')
+        k.write('config BACKPORT_DIR\n')
+        k.write('\tstring\n')
+        k.write('\tdefault "backports/"\n')
+        k.write('config BACKPORTS_VERSION\n')
+        k.write('\tstring\n')
+        k.write('\tdefault "%s"\n' % backports_version)
+        k.write('config BACKPORTED_KERNEL_VERSION\n')
+        k.write('\tstring\n')
+        k.write('\tdefault "%s"\n' % kernel_version)
+        k.write('config BACKPORTED_KERNEL_NAME\n')
+        k.write('\tstring\n')
+        k.write('\tdefault "%s"\n' % args.base_name)
+        k.write('\n')
+        k.write('menuconfig BACKPORT_LINUX\n')
+        k.write('\tbool "Backport %s %s (backports %s)"\n' % (args.base_name, kernel_version, backports_version))
+        k.write('\tdefault n\n')
+        k.write('\t---help--- \n')
+        k.write('\t  Enabling this will let give you the opportunity to use\n')
+        k.write('\t  features and drivers backported from %s %s\n' % (args.base_name, kernel_version))
+        k.write('\t  on the kernel your are using. This is experimental and you should\n')
+        k.write('\t  say no unless you\'d like to help test things.\n')
+        k.write('\n')
+        k.write('if BACKPORT_LINUX\n')
+        k.write('\n')
+        k.write('source "$BACKPORT_DIR/Kconfig.versions"\n')
+        k.write('source "$BACKPORT_DIR/Kconfig.sources"\n')
+        k.write('\n')
+        k.write('endif # BACKPORT_LINUX\n')
+        k.close()
+        git_debug_snapshot(args, "generate top level backports/Kconfig")
+
     disable_list = add_automatic_backports(args)
     if disable_list:
         bpcfg = kconfig.ConfigTree(os.path.join(args.outdir, 'compat', 'Kconfig'))
@@ -757,6 +848,21 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
         logwrite('Done!')
         return 0
 
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
@@ -765,7 +871,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     configtree.prune_sources(ignore=['Kconfig.kernel', 'Kconfig.versions'])
     git_debug_snapshot(args, "prune Kconfig tree")
 
-    configtree.adjust_backported_configs(integrate, orig_symbols)
+    configtree.adjust_backported_configs(args.integrate, orig_symbols)
     git_debug_snapshot(args, "adjust backports config symbols we port")
 
     if (not integrate):
@@ -775,32 +881,15 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     configtree.modify_selects()
     git_debug_snapshot(args, "convert select to depends on")
 
-    # write the versioning file
-    if git_tracked_version:
-        backports_version = "(see git)"
-        kernel_version = "(see git)"
-    else:
-        backports_version = git.describe(tree=source_dir, extra_args=['--long'])
-        kernel_version = git.describe(rev=args.git_revision or 'HEAD',
-                                      tree=args.kerneldir,
-                                      extra_args=['--long'])
-    f = open(os.path.join(args.outdir, 'versions'), 'w')
-    f.write('BACKPORTS_VERSION="%s"\n' % backports_version)
-    f.write('BACKPORTED_KERNEL_VERSION="%s"\n' % kernel_version)
-    f.write('BACKPORTED_KERNEL_NAME="%s"\n' % args.base_name)
-    if git_tracked_version:
-        f.write('BACKPORTS_GIT_TRACKED="backport tracker ID: $(shell git rev-parse HEAD 2>/dev/null || echo \'not built in git tree\')"\n')
-    f.close()
-
     symbols = configtree.symbols()
 
-    # write local symbol list -- needed during build
-    f = open(os.path.join(args.outdir, '.local-symbols'), 'w')
-    for sym in symbols:
-        f.write('%s=\n' % sym)
-    f.close()
-
-    git_debug_snapshot(args, "add versions/symbols files")
+    if not args.integrate:
+        # write local symbol list -- needed during build
+        f = open(os.path.join(args.outdir, '.local-symbols'), 'w')
+        for sym in symbols:
+            f.write('%s=\n' % sym)
+        f.close()
+        git_debug_snapshot(args, "add symbols files")
 
     # add defconfigs that we want
     defconfigs_dir = os.path.join(source_dir, 'backport', 'defconfigs')
@@ -849,7 +938,10 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
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
@@ -896,6 +988,32 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
         fo.close()
     git_debug_snapshot(args, "disable unsatisfied Makefile parts")
 
+    if args.integrate:
+        f = open(os.path.join(args.outdir, '../arch/x86/Kconfig'), 'a')
+        f.write('source "backports/Kconfig"\n')
+        f.close()
+        git_debug_snapshot(args, "hooked backport Kconfig to supported architectures")
+
+        f = open(os.path.join(args.outdir, '../MAINTAINERS'), 'a')
+        f.write('M:\tHauke Mehrtens <hauke@hauke-m.de>\n')
+        f.write('M:\tLuis R. Rodriguez <mcgrof@do-not-panic.com>\n')
+        f.write('L:\tbackports@vger.kernel.org\n')
+        f.write('T:\tgit://git.kernel.org/pub/scm/linux/kernel/git/backports/backports.git\n')
+        f.write('F:\tbackports/\n')
+        f.close()
+        git_debug_snapshot(args, "add backport maintainers entry")
+
+        f = open(os.path.join(args.outdir, '../Makefile'), 'a')
+        f.write('ifeq ($(KBUILD_EXTMOD),)\n')
+        f.write('backports-y := backports/\n')
+        f.write('vmlinux-dirs += $(patsubst %/,%,$(filter %/, $(backports-y) $(backports-m)))\n')
+        f.write('vmlinux-alldirs += $(patsubst %/,%,$(filter %/, $(backports-n) $(backports-)))\n')
+        f.write('backports-y       := $(patsubst %/, %/built-in.o, $(backports-y))\n')
+        f.write('KBUILD_VMLINUX_MAIN += $(backports-y)\n')
+        f.write('endif\n')
+        f.close()
+        git_debug_snapshot(args, "add backports to the vmlinux built-in hunt")
+
     if (args.kup or args.kup_test):
         req = reqs.Req()
         req.kup()
diff --git a/lib/bpversion.py b/lib/bpversion.py
new file mode 100644
index 0000000..7ba4d99
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
+    for i in range(int(rel_specs['PATCHLEVEL']), 99):
+        data += "config BACKPORT_KERNEL_%s_%s\n" % (rel_specs['VERSION'], i)
+        data += "    def_bool y\n"
+    return data
diff --git a/lib/kconfig.py b/lib/kconfig.py
index 29c42ad..5366085 100644
--- a/lib/kconfig.py
+++ b/lib/kconfig.py
@@ -12,6 +12,8 @@ cfg_line = re.compile(r'^(?P<opt>config|menuconfig)\s+(?P<sym>[^\s]*)')
 sel_line = re.compile(r'^(?P<spc>\s+)select\s+(?P<sym>[^\s]*)\s*$')
 backport_line = re.compile(r'^\s+#(?P<key>[ch]-file|module-name)\s*(?P<name>.*)')
 ignore_parse_p = re.compile(r'^\s+#(?P<key>ignore-parser-package)')
+kernel_versin_config = re.compile(r'^(?P<opt>config)\s+(?P<sym>BACKPORT_KERNEL_[\d])')
+ignore_syms = re.compile(r'^(?P<opt>config|menuconfig)\s+(?P<sym>BACKPORT_DIR|BACKPORTS_VERSION|BACKPORTED_KERNEL_VERSION|BACKPORTED_KERNEL_NAME|BACKPORT_LINUX)')
 
 class ConfigTree(object):
     def __init__(self, rootfile):
@@ -84,7 +86,7 @@ class ConfigTree(object):
 
     def _mod_kconfig_line(self, l, orig_symbols):
         for sym in orig_symbols:
-            if sym in l:
+            if sym in l and 'BACKPORT_' not in l:
                 return re.sub(r' (' + sym + ')', r' BACKPORT_\1', l)
         return l
 
@@ -99,6 +101,14 @@ class ConfigTree(object):
                 if pm:
                     ignore_parse_modular = True
                     continue
+                vm = kernel_versin_config.match(l)
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

