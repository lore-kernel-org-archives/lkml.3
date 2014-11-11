Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaKKIS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:18:29 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55739 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbaKKIQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:16:19 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 13/21] backports: use BACKPORT_DIR prefix on kconfig sources
Date: Tue, 11 Nov 2014 00:15:04 -0800
Message-Id: <1415693712-23743-14-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This will allow us to do less work for built-in integration support.
When packaging we only use BACKPORT_DIR for Kconfig sources we control,
to avoid a large change we avoid doing this for other Kconfig files.

For integration we'll always have to use BACKPORT_DIR on kconfig sources.

Suporting requires a bit of self evaluation of the variable within our
kconfig library, ideally we'd have support for groking all variables
defined within the Kconfig setup but that requires quite a lot more
work as it means also parsing Makefiles and inheriting these definitions
within config symbols when used. Since we only define one right now and
its used for built-in support we deal with it ourselves for now.

Please consider the complexity of adding others, it doesn't seem like
there would be much need for others though. If others wanted to use a
different BACKPORT_DIR path other than 'backports' that would require
tweaking here, but we'll start by assuming no one will want to do that.

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

real    42m41.825s
user    1187m38.880s
sys     141m11.760s

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/Kconfig | 40 +++++++++++++++---------------
 gentree.py       | 18 ++++++++++++--
 lib/kconfig.py   | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 107 insertions(+), 25 deletions(-)

diff --git a/backport/Kconfig b/backport/Kconfig
index 415db89..b729d47 100644
--- a/backport/Kconfig
+++ b/backport/Kconfig
@@ -1,5 +1,8 @@
 mainmenu "Linux Backports from $BACKPORTED_KERNEL_NAME $BACKPORTED_KERNEL_VERSION (with backports $BACKPORTS_VERSION)"
 
+config BACKPORT_DIR
+	string
+	option env="BACKPORT_DIR"
 config BACKPORTS_VERSION
 	string
 	option env="BACKPORTS_VERSION"
@@ -10,33 +13,32 @@ config BACKPORTED_KERNEL_NAME
 	string
 	option env="BACKPORTED_KERNEL_NAME"
 
-# these will be generated
-source "Kconfig.kernel"
-source "Kconfig.versions"
+source "$BACKPORT_DIR/Kconfig.kernel"
+source "$BACKPORT_DIR/Kconfig.versions"
 
 # Packaging hacks
-source "Kconfig.package.hacks"
+source "$BACKPORT_DIR/Kconfig.package.hacks"
 
 # this has the configuration for the backport code
-source "compat/Kconfig"
+source "$BACKPORT_DIR/compat/Kconfig"
 
 # these are copied from the kernel
-source "net/wireless/Kconfig"
-source "net/mac80211/Kconfig"
-source "net/bluetooth/Kconfig"
-source "drivers/net/wireless/Kconfig"
-source "drivers/net/ethernet/Kconfig"
-source "drivers/net/usb/Kconfig"
+source "$BACKPORT_DIR/net/wireless/Kconfig"
+source "$BACKPORT_DIR/net/mac80211/Kconfig"
+source "$BACKPORT_DIR/net/bluetooth/Kconfig"
+source "$BACKPORT_DIR/drivers/net/wireless/Kconfig"
+source "$BACKPORT_DIR/drivers/net/ethernet/Kconfig"
+source "$BACKPORT_DIR/drivers/net/usb/Kconfig"
 
-source "drivers/ssb/Kconfig"
-source "drivers/bcma/Kconfig"
+source "$BACKPORT_DIR/drivers/ssb/Kconfig"
+source "$BACKPORT_DIR/drivers/bcma/Kconfig"
 
-source "net/nfc/Kconfig"
+source "$BACKPORT_DIR/net/nfc/Kconfig"
 
-source "drivers/media/Kconfig"
+source "$BACKPORT_DIR/drivers/media/Kconfig"
 
-source "net/ieee802154/Kconfig"
-source "net/mac802154/Kconfig"
-source "drivers/net/ieee802154/Kconfig"
+source "$BACKPORT_DIR/net/ieee802154/Kconfig"
+source "$BACKPORT_DIR/net/mac802154/Kconfig"
+source "$BACKPORT_DIR/drivers/net/ieee802154/Kconfig"
 
-source "drivers/usb/class/Kconfig"
+source "$BACKPORT_DIR/drivers/usb/class/Kconfig"
diff --git a/gentree.py b/gentree.py
index 2c08bba..7632b90 100755
--- a/gentree.py
+++ b/gentree.py
@@ -32,7 +32,8 @@ class Bp_Identity(object):
     """
     def __init__(self, integrate=False, kconfig_prefix='CPTCFG_',
                  project_prefix='', project_dir='',
-                 target_dir='', target_dir_name=''):
+                 target_dir='', target_dir_name='',
+                 kconfig_source_var=None):
         self.integrate = integrate
         self.kconfig_prefix = kconfig_prefix
         self.kconfig_prefix_resafe = re.escape(kconfig_prefix)
@@ -43,6 +44,11 @@ class Bp_Identity(object):
         self.project_dir = project_dir
         self.target_dir = target_dir
         self.target_dir_name = target_dir_name
+        self.kconfig_source_var = kconfig_source_var
+        if self.kconfig_source_var:
+            self.kconfig_source_var_resafe = re.escape(self.kconfig_source_var)
+        else:
+            self.kconfig_source_var_resafe = None
 
 def read_copy_list(copyfile):
     """
@@ -681,6 +687,7 @@ def _main():
                            project_dir = args.outdir,
                            target_dir = os.path.join(args.outdir, 'backports/'),
                            target_dir_name = 'backports/',
+                           kconfig_source_var = '$BACKPORT_DIR',
                            )
     else:
         bpid = Bp_Identity(integrate = integrate,
@@ -689,6 +696,7 @@ def _main():
                            project_dir = args.outdir,
                            target_dir = args.outdir,
                            target_dir_name = '',
+                           kconfig_source_var = '$BACKPORT_DIR',
                            )
 
     def logwrite(msg):
@@ -820,6 +828,7 @@ def process(kerneldir, copy_list_file, git_revision=None,
 
     disable_list = add_automatic_backports(args)
     if disable_list:
+        # No need to verify_sources() as compat's Kconfig has no 'source' call
         bpcfg = kconfig.ConfigTree(os.path.join(bpid.target_dir, 'compat', 'Kconfig'), bpid)
         bpcfg.disable_symbols(disable_list)
     git_debug_snapshot(args, 'Add automatic backports')
@@ -828,10 +837,15 @@ def process(kerneldir, copy_list_file, git_revision=None,
 
     # some post-processing is required
     configtree = kconfig.ConfigTree(os.path.join(bpid.target_dir, 'Kconfig'), bpid)
+    ignore=['Kconfig.kernel', 'Kconfig.versions']
+
+    configtree.verify_sources(ignore=ignore)
+    git_debug_snapshot(args, "verify sources on top level backports Kconfig")
+
     orig_symbols = configtree.symbols()
 
     logwrite('Modify Kconfig tree ...')
-    configtree.prune_sources(ignore=['Kconfig.kernel', 'Kconfig.versions'])
+    configtree.prune_sources(ignore=ignore)
     git_debug_snapshot(args, "prune Kconfig tree")
 
     if not bpid.integrate:
diff --git a/lib/kconfig.py b/lib/kconfig.py
index ac96613..ca3af63 100644
--- a/lib/kconfig.py
+++ b/lib/kconfig.py
@@ -12,10 +12,41 @@ sel_line = re.compile(r'^(?P<spc>\s+)select\s+(?P<sym>[^\s]*)\s*$')
 backport_line = re.compile(r'^\s+#(?P<key>[ch]-file|module-name)\s*(?P<name>.*)')
 
 class ConfigTree(object):
+    """
+    If you suppport kernel integration you should use bpid.kconfig_source_var
+    and set that to the the variable name you have used on your Kconfig file
+    for use as a directory prefix. When packaging you only need to set this on
+    the Kconfig sources part of backports. For integration this variable will
+    be used to prefix all Kconfig sources taken from the kernel. This variable
+    is used by Kconfig to expand to bpid.target_dir_name. All kernel Kconfig
+    source entries use a full path based on bpid.project_dir, when using
+    integration a prefix is needed on backported Kconfig entries to
+    help ensure that the base directory used for backported code is
+    bpid.target_dir and not bpid.project_dir. To help with we provide a
+    verification / modifier, verify_sources(), of the Kconfig entries, you
+    run this before working on the ConfigTree with any other helper.
+
+    Verification is only needed when integrating and if the top level Kconfig
+    entries that have a source entry.
+    """
     def __init__(self, rootfile, bpid):
         self.bpid = bpid
         self.rootfile = os.path.basename(rootfile)
-        self.src_line = re.compile(r'^\s*source\s+"(?P<src>[^\s"]*)"?\s*$')
+        if self.bpid.kconfig_source_var:
+            self.src_line = re.compile(r'^\s*source\s+"(?P<kconfig_var>' + self.bpid.kconfig_source_var_resafe + ')?/?(?P<src>[^\s"]*)"?\s*$')
+            self.kconfig_var_line = re.compile(r'.*(?P<kconfig_var>' + self.bpid.kconfig_source_var_resafe + ')+/+')
+        else:
+            self.src_line = re.compile(r'^\s*source\s+"(?P<src>[^\s"]*)"?\s*$')
+            self.kconfig_var_line = None
+        self.verified = False
+        self.need_verification = False
+        if self.bpid.integrate:
+            for l in open(os.path.join(self.bpid.target_dir, rootfile), 'r'):
+                m = self.src_line.match(l)
+                mrel = src_line_rel.match(l)
+                if m or mrel:
+                    self.need_verification = True
+                    break
 
     def _check_relative_source(self, f, l):
     #
@@ -28,12 +59,17 @@ class ConfigTree(object):
         if m:
             raise Exception('File: %s uses relative kconfig source entries (line: \'%s\'), use full path  with quotes' %
                             (os.path.join(self.bpid.target_dir, f), l))
-    def _walk(self, f):
+    def _walk(self, f, first_pass=False):
+        if self.bpid.integrate:
+            if not self.bpid.kconfig_source_var and self.need_verification:
+                raise Exception("You enabled integration but haven't set bpid.kconfig_source_var, this seems incorrect")
+            if not first_pass and not self.verified and self.need_verification:
+                raise Exception("You must run verify_sources() first, we don't do that for you as you may want to ignore some source files")
         yield f
         for l in open(os.path.join(self.bpid.target_dir, f), 'r'):
             m = self.src_line.match(l)
             if m and os.path.exists(os.path.join(self.bpid.target_dir, m.group('src'))):
-                for i in self._walk(m.group('src')):
+                for i in self._walk(m.group('src'), first_pass=first_pass):
                     yield i
             else:
                 self._check_relative_source(f, l)
@@ -49,12 +85,42 @@ class ConfigTree(object):
                     continue
                 src = m.group('src')
                 if src in ignore or os.path.exists(os.path.join(self.bpid.target_dir, src)):
+                        out += l
+                else:
+                        out += '#' + l
+            outf = open(os.path.join(self.bpid.target_dir, nf), 'w')
+            outf.write(out)
+            outf.close()
+
+    def verify_sources(self, ignore=[]):
+        if not self.need_verification:
+            return
+        for nf in self._walk(self.rootfile, first_pass=True):
+            out = ''
+            for l in open(os.path.join(self.bpid.target_dir, nf), 'r'):
+                m = self.src_line.match(l)
+                if not m:
+                    self._check_relative_source(nf, l)
                     out += l
+                    continue
+                src = m.group('src')
+                k = self.kconfig_var_line.match(l)
+                if src in ignore or os.path.exists(os.path.join(self.bpid.target_dir, src)):
+                    if k:
+                        out += l
+                    else:
+                        out += 'source "%s/%s"\n' % (self.bpid.kconfig_source_var,  m.group('src'))
                 else:
-                    out += '#' + l
+                    if k:
+                        out += '# source "' + self.bpid.kconfig_source_var + '/' + src + '"\n'
+                    else:
+                        out += '#' + l
             outf = open(os.path.join(self.bpid.target_dir, nf), 'w')
             outf.write(out)
             outf.close()
+        # Now the kconfig_var is always required from now on
+        self.src_line = re.compile(r'^\s*source\s+"(?P<kconfig_var>' + self.bpid.kconfig_source_var_resafe + ')+/+(?P<src>[^\s"]*)"?\s*$')
+        self.verified = True
 
     def prune_sources(self, ignore=[]):
         self._prune_sources(self.rootfile, ignore)
-- 
2.1.1

