Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaKKIQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:16:15 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39968 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaKKIQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:16:11 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 11/21] backports: modify kconfig parser to use bpid and target_dir
Date: Tue, 11 Nov 2014 00:15:02 -0800
Message-Id: <1415693712-23743-12-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The kconfig parser sets a base directory using the directory
in which the Kconfig file passed lives in. This strategy assumes the
kernel uses relative paths, while this is truly supported in
practice though upstream only deals with full paths based on
the actual root directory of the kernel. Its safer, cleaner and
much simpler to support full paths, and since the kernel uses
full paths anyway lets stick to that and complain when relative
paths are found. This also modifies our own provided Kconfig to
use full paths as well, we'll need this later to adjust our
Kconfigs for kernel integration.

$ time /home/mcgrof/backports/devel/ckmake --allyesconfig
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

real    44m3.002s
user    1188m20.708s
sys     140m25.540s

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/Kconfig | 36 ++++++++++++++++++------------------
 gentree.py       |  6 +++---
 lib/kconfig.py   | 51 +++++++++++++++++++++++++++++++++------------------
 3 files changed, 54 insertions(+), 39 deletions(-)

diff --git a/backport/Kconfig b/backport/Kconfig
index a8f2867..415db89 100644
--- a/backport/Kconfig
+++ b/backport/Kconfig
@@ -11,32 +11,32 @@ config BACKPORTED_KERNEL_NAME
 	option env="BACKPORTED_KERNEL_NAME"
 
 # these will be generated
-source Kconfig.kernel
-source Kconfig.versions
+source "Kconfig.kernel"
+source "Kconfig.versions"
 
 # Packaging hacks
-source Kconfig.package.hacks
+source "Kconfig.package.hacks"
 
 # this has the configuration for the backport code
-source compat/Kconfig
+source "compat/Kconfig"
 
 # these are copied from the kernel
-source net/wireless/Kconfig
-source net/mac80211/Kconfig
-source net/bluetooth/Kconfig
-source drivers/net/wireless/Kconfig
-source drivers/net/ethernet/Kconfig
-source drivers/net/usb/Kconfig
+source "net/wireless/Kconfig"
+source "net/mac80211/Kconfig"
+source "net/bluetooth/Kconfig"
+source "drivers/net/wireless/Kconfig"
+source "drivers/net/ethernet/Kconfig"
+source "drivers/net/usb/Kconfig"
 
-source drivers/ssb/Kconfig
-source drivers/bcma/Kconfig
+source "drivers/ssb/Kconfig"
+source "drivers/bcma/Kconfig"
 
-source net/nfc/Kconfig
+source "net/nfc/Kconfig"
 
-source drivers/media/Kconfig
+source "drivers/media/Kconfig"
 
-source net/ieee802154/Kconfig
-source net/mac802154/Kconfig
-source drivers/net/ieee802154/Kconfig
+source "net/ieee802154/Kconfig"
+source "net/mac802154/Kconfig"
+source "drivers/net/ieee802154/Kconfig"
 
-source drivers/usb/class/Kconfig
+source "drivers/usb/class/Kconfig"
diff --git a/gentree.py b/gentree.py
index 68efce9..2c08bba 100755
--- a/gentree.py
+++ b/gentree.py
@@ -226,7 +226,7 @@ def add_automatic_backports(args):
     disable_list = []
     export = re.compile(r'^EXPORT_SYMBOL(_GPL)?\((?P<sym>[^\)]*)\)')
     bpi = kconfig.get_backport_info(os.path.join(args.bpid.target_dir, 'compat', 'Kconfig'))
-    configtree = kconfig.ConfigTree(os.path.join(args.bpid.target_dir, 'Kconfig'))
+    configtree = kconfig.ConfigTree(os.path.join(args.bpid.target_dir, 'Kconfig'), args.bpid)
     all_selects = configtree.all_selects()
     for sym, vals in bpi.items():
         if sym.startswith('BACKPORT_BUILD_'):
@@ -820,14 +820,14 @@ def process(kerneldir, copy_list_file, git_revision=None,
 
     disable_list = add_automatic_backports(args)
     if disable_list:
-        bpcfg = kconfig.ConfigTree(os.path.join(bpid.target_dir, 'compat', 'Kconfig'))
+        bpcfg = kconfig.ConfigTree(os.path.join(bpid.target_dir, 'compat', 'Kconfig'), bpid)
         bpcfg.disable_symbols(disable_list)
     git_debug_snapshot(args, 'Add automatic backports')
 
     apply_patches(args, "backport", source_dir, 'patches', bpid.target_dir, logwrite)
 
     # some post-processing is required
-    configtree = kconfig.ConfigTree(os.path.join(bpid.target_dir, 'Kconfig'))
+    configtree = kconfig.ConfigTree(os.path.join(bpid.target_dir, 'Kconfig'), bpid)
     orig_symbols = configtree.symbols()
 
     logwrite('Modify Kconfig tree ...')
diff --git a/lib/kconfig.py b/lib/kconfig.py
index 3562630..f348d4a 100644
--- a/lib/kconfig.py
+++ b/lib/kconfig.py
@@ -4,7 +4,8 @@
 
 import os, re
 
-src_line = re.compile(r'^\s*source\s+"?(?P<src>[^\s"]*)"?\s*$')
+src_line = re.compile(r'^\s*source\s+"(?P<src>[^\s"]*)"?\s*$')
+src_line_rel = re.compile(r'^\s*source\s+(?P<src>[^\s"]*)"?\s*$')
 tri_line = re.compile(r'^(?P<spc>\s+)tristate')
 bool_line = re.compile(r'^(?P<spc>\s+)bool')
 cfg_line = re.compile(r'^(?P<opt>config|menuconfig)\s+(?P<sym>[^\s]*)')
@@ -12,32 +13,46 @@ sel_line = re.compile(r'^(?P<spc>\s+)select\s+(?P<sym>[^\s]*)\s*$')
 backport_line = re.compile(r'^\s+#(?P<key>[ch]-file|module-name)\s*(?P<name>.*)')
 
 class ConfigTree(object):
-    def __init__(self, rootfile):
-        self.basedir = os.path.dirname(rootfile)
+    def __init__(self, rootfile, bpid):
+        self.bpid = bpid
         self.rootfile = os.path.basename(rootfile)
 
+    def _check_relative_source(self, f, l):
+    #
+    # Although we can support relative kconfig source lines its a lot safer,
+    # clearer to use full paths; it also makes it easier to support / parse and
+    # modify kconfig entries. The kernel also uses full paths anyway but if
+    # a relative path is found we should consider changing that upstream to
+    # streamline usage of full path.
+        m = src_line_rel.match(l)
+        if m:
+            raise Exception('File: %s uses relative kconfig source entries (line: \'%s\'), use full path  with quotes' %
+                            (os.path.join(self.bpid.target_dir, f), l))
     def _walk(self, f):
         yield f
-        for l in open(os.path.join(self.basedir, f), 'r'):
+        for l in open(os.path.join(self.bpid.target_dir, f), 'r'):
             m = src_line.match(l)
-            if m and os.path.exists(os.path.join(self.basedir, m.group('src'))):
+            if m and os.path.exists(os.path.join(self.bpid.target_dir, m.group('src'))):
                 for i in self._walk(m.group('src')):
                     yield i
+            else:
+                self._check_relative_source(f, l)
 
     def _prune_sources(self, f, ignore):
         for nf in self._walk(f):
             out = ''
-            for l in open(os.path.join(self.basedir, nf), 'r'):
+            for l in open(os.path.join(self.bpid.target_dir, nf), 'r'):
                 m = src_line.match(l)
                 if not m:
+                    self._check_relative_source(nf, l)
                     out += l
                     continue
                 src = m.group('src')
-                if src in ignore or os.path.exists(os.path.join(self.basedir, src)):
+                if src in ignore or os.path.exists(os.path.join(self.bpid.target_dir, src)):
                     out += l
                 else:
                     out += '#' + l
-            outf = open(os.path.join(self.basedir, nf), 'w')
+            outf = open(os.path.join(self.bpid.target_dir, nf), 'w')
             outf.write(out)
             outf.close()
 
@@ -47,19 +62,19 @@ class ConfigTree(object):
     def force_tristate_modular(self):
         for nf in self._walk(self.rootfile):
             out = ''
-            for l in open(os.path.join(self.basedir, nf), 'r'):
+            for l in open(os.path.join(self.bpid.target_dir, nf), 'r'):
                 m = tri_line.match(l)
                 out += l
                 if m:
                     out += m.group('spc') + "depends on m\n"
-            outf = open(os.path.join(self.basedir, nf), 'w')
+            outf = open(os.path.join(self.bpid.target_dir, nf), 'w')
             outf.write(out)
             outf.close()
 
     def symbols(self):
         syms = []
         for nf in self._walk(self.rootfile):
-            for l in open(os.path.join(self.basedir, nf), 'r'):
+            for l in open(os.path.join(self.bpid.target_dir, nf), 'r'):
                 m = cfg_line.match(l)
                 if m:
                     syms.append(m.group('sym'))
@@ -68,7 +83,7 @@ class ConfigTree(object):
     def all_selects(self):
         result = []
         for nf in self._walk(self.rootfile):
-            for l in open(os.path.join(self.basedir, nf), 'r'):
+            for l in open(os.path.join(self.bpid.target_dir, nf), 'r'):
                 m = sel_line.match(l)
                 if m:
                     result.append(m.group('sym'))
@@ -78,7 +93,7 @@ class ConfigTree(object):
         syms = self.symbols()
         for nf in self._walk(self.rootfile):
             out = ''
-            for l in open(os.path.join(self.basedir, nf), 'r'):
+            for l in open(os.path.join(self.bpid.target_dir, nf), 'r'):
                 m = sel_line.match(l)
                 if m and not m.group('sym') in syms:
                     if 'BACKPORT_' + m.group('sym') in syms:
@@ -87,32 +102,32 @@ class ConfigTree(object):
                         out += m.group('spc') + "depends on " + m.group('sym') + '\n'
                 else:
                     out += l
-            outf = open(os.path.join(self.basedir, nf), 'w')
+            outf = open(os.path.join(self.bpid.target_dir, nf), 'w')
             outf.write(out)
             outf.close()
 
     def disable_symbols(self, syms):
         for nf in self._walk(self.rootfile):
             out = ''
-            for l in open(os.path.join(self.basedir, nf), 'r'):
+            for l in open(os.path.join(self.bpid.target_dir, nf), 'r'):
                 m = cfg_line.match(l)
                 out += l
                 if m and m.group('sym') in syms:
                     out += "\tdepends on n\n"
-            outf = open(os.path.join(self.basedir, nf), 'w')
+            outf = open(os.path.join(self.bpid.target_dir, nf), 'w')
             outf.write(out)
             outf.close()
 
     def add_dependencies(self, deps):
         for nf in self._walk(self.rootfile):
             out = ''
-            for l in open(os.path.join(self.basedir, nf), 'r'):
+            for l in open(os.path.join(self.bpid.target_dir, nf), 'r'):
                 m = cfg_line.match(l)
                 out += l
                 if m:
                     for dep in deps.get(m.group('sym'), []):
                         out += "\tdepends on %s\n" % dep
-            outf = open(os.path.join(self.basedir, nf), 'w')
+            outf = open(os.path.join(self.bpid.target_dir, nf), 'w')
             outf.write(out)
             outf.close()
 
-- 
2.1.1

