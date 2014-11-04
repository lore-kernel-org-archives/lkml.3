Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbaKDIn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:43:28 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37138 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaKDInW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:43:22 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v1 03/11] backports: allow for different backport prefix
Date: Tue,  4 Nov 2014 00:42:54 -0800
Message-Id: <1415090582-14129-4-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The way we backport when packaging is to minimize the amount of
changes required by taking advantage of the fact that Kconfig
will treat can read CONFIG_ an environment variable with getenv()
when parsing menu entries. When doing integration we don't want
to do this so instead we'll rely on the CONFIG_BACKPORT prefix.
This requires a bit of work on our current parsers.

This adds some initial code for integration, this doesn't run yet.
Although adjust_backported_configs() runs when packaging right now
this just removes some comments out the top level Kconfig, but
leaves the code in place should it later want to consider using
CONFIG_BACKPORT prefix and the gains of now allowing to build
when a respective symbols is already built in.

As a small enhancement add to each backported local symbol a
dependency to require the user's kernel to not have built-in the
backported symbols when packaging, this allows to get rid of the
checks in checks.h, we make this more generic for all drivers and
subsystems we backport now.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/Kconfig            |  6 ++-
 devel/ckmake                |  2 +
 devel/doc/kconfig-operation |  4 +-
 gentree.py                  | 53 ++++++++++++++++++-------
 lib/kconfig.py              | 94 ++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 140 insertions(+), 19 deletions(-)

diff --git a/backport/Kconfig b/backport/Kconfig
index b14a268..f63f4fd 100644
--- a/backport/Kconfig
+++ b/backport/Kconfig
@@ -14,11 +14,15 @@ config BACKPORTED_KERNEL_NAME
 source Kconfig.kernel
 source Kconfig.versions
 
-# some hacks ...
+# some hacks for when we use backports to generate a package
+# to build modules out of tree.
+#ignore-parser-package
 config WIRELESS
 	def_bool y
+#ignore-parser-package
 config NET_CORE
 	def_bool y
+#ignore-parser-package
 config EXPERT
 	def_bool y
 
diff --git a/devel/ckmake b/devel/ckmake
index 0c238a6..6070d8f 100755
--- a/devel/ckmake
+++ b/devel/ckmake
@@ -165,6 +165,7 @@ def process_kernel(num, kset, cmdline_args):
         all_config_name = os.path.join(work_dir, 'all.config')
         all_config = open(all_config_name, 'w')
         all_config.write("CPTCFG_CFG80211_INTERNAL_REGDB=n\n")
+        all_config.write("CONFIG_BACKPORT_CFG80211_INTERNAL_REGDB=n\n")
         config_name = 'allnoconfig'
         if cmdline_args.allyesconfig:
             config_name = 'allyesconfig'
@@ -173,6 +174,7 @@ def process_kernel(num, kset, cmdline_args):
                 open(os.path.join(work_dir, 'defconfigs', cmdline_args.defconfig)).read())
         else:
             all_config.write("CPTCFG_BACKPORT_USERSEL_BUILD_ALL=y\n")
+            all_config.write("CONFIG_BACKPORT_CFG80211_INTERNAL_REGDB=y\n")
         all_config.close()
 
         all_config_env = os.environ.copy()
diff --git a/devel/doc/kconfig-operation b/devel/doc/kconfig-operation
index 0245889..f1ecf60 100644
--- a/devel/doc/kconfig-operation
+++ b/devel/doc/kconfig-operation
@@ -63,7 +63,7 @@ being compiled against is older than X.
 
 All together, this allows the correct options to be selected by the user.
 
-There's one more caveat: At backport configuration time, the CONFIG_
+When using Linux backports as a packaged solution the the CONFIG_
 environment variable is set to CPTCFG_ ("compat config", but also chosen
 because it has the same length as CONFIG_). This shows up in the .config
 file and other places, and in fact in all makefiles and in the code. The
@@ -73,8 +73,6 @@ This allows code to, for example, have "#ifdef CONFIG_PM" which can only
 be set or cleared in the kernel, not in the backport configuration. Since
 this is needed, a transformation step is done at backport creation time.
 
-
-
  Backport creation for Kconfig
 -------------------------------
 
diff --git a/gentree.py b/gentree.py
index 59ae19d..3d4a8b4 100755
--- a/gentree.py
+++ b/gentree.py
@@ -42,7 +42,7 @@ def read_copy_list(copyfile):
     return ret
 
 
-def read_dependencies(depfilename):
+def read_dependencies(depfilename, bp_prefix):
     """
     Read a (the) dependency file and return the list of
     dependencies as a dictionary, mapping a Kconfig symbol
@@ -71,6 +71,9 @@ def read_dependencies(depfilename):
                 ret[sym].append(kconfig_exp)
         else:
             sym, dep = item.split()
+            if bp_prefix != 'CPTCFG_':
+                dep_prefix = re.sub(r'^CONFIG_(.*)', r'\1', bp_prefix)
+                sym = dep_prefix + sym
             if not sym in ret:
                 ret[sym] = [dep, ]
             else:
@@ -195,7 +198,7 @@ def automatic_backport_mangle_c_file(name):
     return name.replace('/', '-')
 
 
-def add_automatic_backports(args):
+def add_automatic_backports(args, bp_prefix):
     disable_list = []
     export = re.compile(r'^EXPORT_SYMBOL(_GPL)?\((?P<sym>[^\)]*)\)')
     bpi = kconfig.get_backport_info(os.path.join(args.outdir, 'compat', 'Kconfig'))
@@ -228,9 +231,9 @@ def add_automatic_backports(args):
                 raise Exception('backporting a module requires a #module-name')
             for of in o_files:
                 mf.write('%s-objs += %s\n' % (module_name, of))
-            mf.write('obj-$(CPTCFG_%s) += %s.o\n' % (sym, module_name))
+            mf.write('obj-$(%s%s) += %s.o\n' % (bp_prefix, sym, module_name))
         elif symtype == 'bool':
-            mf.write('compat-$(CPTCFG_%s) += %s\n' % (sym, ' '.join(o_files)))
+            mf.write('compat-$(%s%s) += %s\n' % (bp_prefix, sym, ' '.join(o_files)))
 
         # finally create the include file
         syms = []
@@ -243,14 +246,14 @@ def add_automatic_backports(args):
         for f in h_files:
             outf = open(os.path.join(args.outdir, 'include', f), 'w')
             outf.write('/* Automatically created during backport process */\n')
-            outf.write('#ifndef CPTCFG_%s\n' % sym)
+            outf.write('#ifndef %s%s\n' % (bp_prefix, sym))
             outf.write('#include_next <%s>\n' % f)
             outf.write('#else\n');
             for s in syms:
                 outf.write('#undef %s\n' % s)
                 outf.write('#define %s LINUX_BACKPORT(%s)\n' % (s, s))
             outf.write('#include <%s>\n' % (os.path.dirname(f) + '/backport-' + os.path.basename(f), ))
-            outf.write('#endif /* CPTCFG_%s */\n' % sym)
+            outf.write('#endif /* %s%s */\n' % (bp_prefix, sym))
     return disable_list
 
 def git_debug_init(args):
@@ -695,6 +698,19 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
                 gitdebug, verbose, extra_driver, kup, kup_test,
                 test_cocci, profile_cocci)
     rel_prep = None
+    integrate = False
+
+    # When building a package we use CPTCFG as we can rely on the
+    # fact that kconfig treats CONFIG_ as an environment variable
+    # requring less changes on code. For kernel integration we use
+    # the longer CONFIG_BACKPORT given that we'll be sticking to
+    # the kernel symbol namespace, to address that we do a final
+    # search / replace. Technically its possible to rely on the
+    # same prefix for packaging as with kernel integration but
+    # there are already som users of the CPTCFG prefix.
+    bp_prefix = 'CPTCFG_'
+    if integrate:
+        bp_prefix = 'CONFIG_BACKPORT_'
 
     # start processing ...
     if (args.kup or args.kup_test):
@@ -724,7 +740,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
             sys.exit(1)
 
     copy_list = read_copy_list(args.copy_list)
-    deplist = read_dependencies(os.path.join(source_dir, 'dependencies'))
+    deplist = read_dependencies(os.path.join(source_dir, 'dependencies'), bp_prefix)
 
     # validate output directory
     check_output_dir(args.outdir, args.clean)
@@ -757,7 +773,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
 
     git_debug_snapshot(args, 'Add driver sources')
 
-    disable_list = add_automatic_backports(args)
+    disable_list = add_automatic_backports(args, bp_prefix)
     if disable_list:
         bpcfg = kconfig.ConfigTree(os.path.join(args.outdir, 'compat', 'Kconfig'))
         bpcfg.disable_symbols(disable_list)
@@ -767,11 +783,19 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
 
     # some post-processing is required
     configtree = kconfig.ConfigTree(os.path.join(args.outdir, 'Kconfig'))
+    orig_symbols = configtree.symbols()
+
     logwrite('Modify Kconfig tree ...')
     configtree.prune_sources(ignore=['Kconfig.kernel', 'Kconfig.versions'])
     git_debug_snapshot(args, "prune Kconfig tree")
-    configtree.force_tristate_modular()
-    git_debug_snapshot(args, "force tristate options modular")
+
+    if not integrate:
+        configtree.force_tristate_modular()
+        git_debug_snapshot(args, "force tristate options modular")
+
+    configtree.adjust_backported_configs(integrate, orig_symbols, bp_prefix)
+    git_debug_snapshot(args, "adjust backports config symbols we port")
+
     configtree.modify_selects()
     git_debug_snapshot(args, "convert select to depends on")
 
@@ -828,8 +852,9 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
 
     # rewrite Makefile and source symbols
     regexes = []
-    for some_symbols in [symbols[i:i + 50] for i in range(0, len(symbols), 50)]:
-        r = 'CONFIG_((' + '|'.join([s + '(_MODULE)?' for s in some_symbols]) + ')([^A-Za-z0-9_]|$))'
+    all_symbols = orig_symbols + symbols
+    for some_symbols in [all_symbols[i:i + 50] for i in range(0, len(all_symbols), 50)]:
+        r = 'CONFIG_((?!BACKPORT)(' + '|'.join([s + '(_MODULE)?' for s in some_symbols]) + ')([^A-Za-z0-9_]|$))'
         regexes.append(re.compile(r, re.MULTILINE))
     for root, dirs, files in os.walk(args.outdir):
         # don't go into .git dir (possible debug thing)
@@ -838,7 +863,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
         for f in files:
             data = open(os.path.join(root, f), 'r').read()
             for r in regexes:
-                data = r.sub(r'CPTCFG_\1', data)
+                data = r.sub(r'' + bp_prefix + '\\1', data)
             data = re.sub(r'\$\(srctree\)', '$(backport_srctree)', data)
             data = re.sub(r'-Idrivers', '-I$(backport_srctree)/drivers', data)
             fo = open(os.path.join(root, f), 'w')
@@ -884,7 +909,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     # groups -- 50 seemed safer and is still fast)
     regexes = []
     for some_symbols in [disable_makefile[i:i + 50] for i in range(0, len(disable_makefile), 50)]:
-        r = '^([^#].*((CPTCFG|CONFIG)_(' + '|'.join([s for s in some_symbols]) + ')))'
+        r = '^([^#].*((CPTCFG|CONFIG_BACKPORT|CONFIG)_(' + '|'.join([s for s in some_symbols]) + ')))'
         regexes.append(re.compile(r, re.MULTILINE))
     for f in maketree.get_makefiles():
         data = open(f, 'r').read()
diff --git a/lib/kconfig.py b/lib/kconfig.py
index 179121a..1efffed 100644
--- a/lib/kconfig.py
+++ b/lib/kconfig.py
@@ -7,9 +7,10 @@ import os, re
 src_line = re.compile(r'^\s*source\s+"?(?P<src>[^\s"]*)"?\s*$')
 tri_line = re.compile(r'^(?P<spc>\s+)tristate')
 bool_line = re.compile(r'^(?P<spc>\s+)bool')
-cfg_line = re.compile(r'^(config|menuconfig)\s+(?P<sym>[^\s]*)')
+cfg_line = re.compile(r'^(?P<opt>config|menuconfig)\s+(?P<sym>[^\s]*)')
 sel_line = re.compile(r'^(?P<spc>\s+)select\s+(?P<sym>[^\s]*)\s*$')
 backport_line = re.compile(r'^\s+#(?P<key>[ch]-file|module-name)\s*(?P<name>.*)')
+ignore_parse_p = re.compile(r'^\s*#(?P<key>ignore-parser-package)')
 
 class ConfigTree(object):
     def __init__(self, rootfile):
@@ -56,6 +57,97 @@ class ConfigTree(object):
             outf.write(out)
             outf.close()
 
+    def _mod_kconfig_line(self, l, orig_symbols, bp_prefix):
+        if bp_prefix != 'CPTCFG_':
+            prefix = re.sub(r'^CONFIG_(.*)', r'\1', bp_prefix)
+            for sym in orig_symbols:
+                if sym in l:
+                    return re.sub(r' (' + sym + ')', r' ' + prefix + '\1', l)
+        return l
+
+    def adjust_backported_configs(self, integrate, orig_symbols, bp_prefix):
+        m = None
+        old_l = None
+        ignore_parse_modular = False
+        for nf in self._walk(self.rootfile):
+            out = ''
+            for l in open(os.path.join(self.basedir, nf), 'r'):
+                pm = ignore_parse_p.match(l)
+                if pm:
+                    ignore_parse_modular = True
+                    continue
+                n = cfg_line.match(l)
+                if n:
+                    m = n
+                    old_l = l
+                    continue
+                # We're now on the second line for the config symbol
+                if m:
+                    # Right now this only supports one line hacks
+                    if ignore_parse_modular:
+                        if not integrate:
+                            out += old_l
+                            out += l
+                        ignore_parse_modular = False
+                        m = None
+                        continue
+                    built_in_sym = m.group('sym')
+                    if bp_prefix != 'CPTCFG_':
+                        prefix = re.sub(r'^CONFIG_(.*)_', r'\1', bp_prefix)
+                        built_in_sym = re.sub(r'' + prefix + '(.*)', r'\1', m.group('sym'))
+                    else:
+                        prefix = 'CPTCFG'
+                    # These are things that we carry as part of our backports
+                    # module or things we automatically copy over into our
+                    # backports module.
+                    if prefix in m.group('sym'):
+                        out += old_l
+                        out += l
+                        # For modular solutions This might still be possible if
+                        # we use backport_ prefixes for our own symbols but it
+                        # seems that folks now don't want these prefixes so
+                        # restrict to ensure what we replace will not be
+                        # available built-in as we are reviewing phasing that
+                        # usage out.
+                        if not integrate:
+                            x = 0
+                            # XXX: for we won't address this, as this needs
+                            # review and getting rid of the prefixes, otherwise
+                            # its OK. Some folks may *want* to replace built-in
+                            # old symbols with some modular hack when they
+                            # know its safe, for instance.
+                            # out += "\tdepends on %s!=y\n" % (built_in_sym)
+                        else:
+                            # For backports kernel integration solutions we
+                            # allow the backported solution from future kernels
+                            # to replace the kernel solution you on your
+                            # original tree
+                            # XXX: only do this for symbols that have C files
+                            # depending on it
+                            out += "\tdepends on !%s\n" % (built_in_sym)
+                    else:
+                        # First rewrite the upstream symbol with our prefix if
+                        # needed
+                        if bp_prefix != 'CPTCFG_':
+                            out += m.group('opt') + ' ' + prefix + '_' + m.group('sym') + '\n'
+                            out += l
+                            # This can be done when not using the CPTCFG CONFIG_
+                            # variable override, so it uses the checks.h but
+                            # that's a reactive measure.
+                            if not integrate:
+                                out += "\tdepends on %s!=y\n" % (built_in_sym)
+                            else:
+                                out += "\tdepends on !%s\n" % (built_in_sym)
+                        else:
+                            out += m.group('opt') + ' ' + m.group('sym') + '\n'
+                            out += l
+                    m = None
+                else:
+                    out += self._mod_kconfig_line(l, orig_symbols, bp_prefix)
+            outf = open(os.path.join(self.basedir, nf), 'w')
+            outf.write(out)
+            outf.close()
+
     def symbols(self):
         syms = []
         for nf in self._walk(self.rootfile):
-- 
2.1.1

