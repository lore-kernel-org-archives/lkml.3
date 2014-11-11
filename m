Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaKKIPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:15:49 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62920 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaKKIPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:15:46 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 06/21] backports: allow for different backport prefix and simple integration support
Date: Tue, 11 Nov 2014 00:14:57 -0800
Message-Id: <1415693712-23743-7-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The way we backport when packaging is to minimize the amount of
changes required by taking advantage of the fact that Kconfig
can treat CONFIG_ as an environment variable with getenv()
when parsing menu entries. When doing integration we don't want
to do this so instead we'll rely on the CONFIG_BACKPORT prefix.
This requires a bit of work on our current parsers, so to do that
identify the backport and provide that to helpers.

This also provides initial basic support for integration where no
additional code was required other than prefixes or ensuring certain
things are not done for integration. Before we expose integration
support we'll need to add quite a bit more things so this just assumes
integration is never desired.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 devel/doc/kconfig-operation |  4 +--
 gentree.py                  | 83 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 67 insertions(+), 20 deletions(-)

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
index cb39a3f..40b0a55 100755
--- a/gentree.py
+++ b/gentree.py
@@ -17,6 +17,28 @@ from lib import bpkup as kup
 from lib.tempdir import tempdir
 from lib import bpreqs as reqs
 
+class Bp_Identity(object):
+    """
+    folks considering multiple integrations may want to
+    consider stuffing versioning info here as well but
+    that will need thought/design on sharing compat and
+    module namespaces.
+
+    Use the *_resafe when combining on regexps, although we currently
+    don't support regexps there perhaps later we will and this will
+    just make things safer for the output regardless. Once and if those
+    are added, how we actually use the others for regular printing will
+    need to be considered.
+    """
+    def __init__(self, integrate=False, kconfig_prefix='CPTCFG_', project_prefix=''):
+        self.integrate = integrate
+        self.kconfig_prefix = kconfig_prefix
+        self.kconfig_prefix_resafe = re.escape(kconfig_prefix)
+        self.project_prefix = project_prefix
+        self.project_prefix_resafe = re.escape(project_prefix)
+        self.full_prefix = kconfig_prefix + project_prefix
+        self.full_prefix_resafe = re.escape(self.full_prefix)
+
 def read_copy_list(copyfile):
     """
     Read a copy-list file and return a list of (source, target)
@@ -195,7 +217,7 @@ def automatic_backport_mangle_c_file(name):
     return name.replace('/', '-')
 
 
-def add_automatic_backports(args):
+def add_automatic_backports(args, bpid):
     disable_list = []
     export = re.compile(r'^EXPORT_SYMBOL(_GPL)?\((?P<sym>[^\)]*)\)')
     bpi = kconfig.get_backport_info(os.path.join(args.outdir, 'compat', 'Kconfig'))
@@ -228,9 +250,9 @@ def add_automatic_backports(args):
                 raise Exception('backporting a module requires a #module-name')
             for of in o_files:
                 mf.write('%s-objs += %s\n' % (module_name, of))
-            mf.write('obj-$(CPTCFG_%s) += %s.o\n' % (sym, module_name))
+            mf.write('obj-$(%s%s) += %s.o\n' % (bpid.full_prefix, sym, module_name))
         elif symtype == 'bool':
-            mf.write('compat-$(CPTCFG_%s) += %s\n' % (sym, ' '.join(o_files)))
+            mf.write('compat-$(%s%s) += %s\n' % (bpid.full_prefix, sym, ' '.join(o_files)))
 
         # finally create the include file
         syms = []
@@ -243,14 +265,14 @@ def add_automatic_backports(args):
         for f in h_files:
             outf = open(os.path.join(args.outdir, 'include', f), 'w')
             outf.write('/* Automatically created during backport process */\n')
-            outf.write('#ifndef CPTCFG_%s\n' % sym)
+            outf.write('#ifndef %s%s\n' % (bpid.full_prefix, sym))
             outf.write('#include_next <%s>\n' % f)
             outf.write('#else\n');
             for s in syms:
                 outf.write('#undef %s\n' % s)
                 outf.write('#define %s LINUX_BACKPORT(%s)\n' % (s, s))
             outf.write('#include <%s>\n' % (os.path.dirname(f) + '/backport-' + os.path.basename(f), ))
-            outf.write('#endif /* CPTCFG_%s */\n' % sym)
+            outf.write('#endif /* %s%s */\n' % (bpid.full_prefix, sym))
     return disable_list
 
 def git_debug_init(args):
@@ -695,6 +717,25 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
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
+    # there are already some users of the CPTCFG prefix.
+    bpid = None
+    if integrate:
+        bpid = Bp_Identity(integrate = integrate,
+                           kconfig_prefix = 'CONFIG_',
+                           project_prefix = 'BACKPORT_')
+    else:
+        bpid = Bp_Identity(integrate = integrate,
+                           kconfig_prefix = 'CPTCFG_',
+                           project_prefix = '')
 
     # start processing ...
     if (args.kup or args.kup_test):
@@ -758,7 +799,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
 
     git_debug_snapshot(args, 'Add driver sources')
 
-    disable_list = add_automatic_backports(args)
+    disable_list = add_automatic_backports(args, bpid)
     if disable_list:
         bpcfg = kconfig.ConfigTree(os.path.join(args.outdir, 'compat', 'Kconfig'))
         bpcfg.disable_symbols(disable_list)
@@ -769,11 +810,15 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     # some post-processing is required
     configtree = kconfig.ConfigTree(os.path.join(args.outdir, 'Kconfig'))
     orig_symbols = configtree.symbols()
+
     logwrite('Modify Kconfig tree ...')
     configtree.prune_sources(ignore=['Kconfig.kernel', 'Kconfig.versions'])
     git_debug_snapshot(args, "prune Kconfig tree")
-    configtree.force_tristate_modular()
-    git_debug_snapshot(args, "force tristate options modular")
+
+    if not bpid.integrate:
+        configtree.force_tristate_modular()
+        git_debug_snapshot(args, "force tristate options modular")
+
     configtree.modify_selects()
     git_debug_snapshot(args, "convert select to depends on")
 
@@ -793,16 +838,17 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     if git_tracked_version:
         f.write('BACKPORTS_GIT_TRACKED="backport tracker ID: $(shell git rev-parse HEAD 2>/dev/null || echo \'not built in git tree\')"\n')
     f.close()
+    git_debug_snapshot(args, "add versions files")
 
     symbols = configtree.symbols()
 
-    # write local symbol list -- needed during build
-    f = open(os.path.join(args.outdir, '.local-symbols'), 'w')
-    for sym in symbols:
-        f.write('%s=\n' % sym)
-    f.close()
-
-    git_debug_snapshot(args, "add versions/symbols files")
+    # write local symbol list -- needed during packaging build
+    if not bpid.integrate:
+        f = open(os.path.join(args.outdir, '.local-symbols'), 'w')
+        for sym in symbols:
+            f.write('%s=\n' % sym)
+        f.close()
+        git_debug_snapshot(args, "add symbols files")
 
     # add defconfigs that we want
     defconfigs_dir = os.path.join(source_dir, 'backport', 'defconfigs')
@@ -829,6 +875,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     logwrite('Rewrite Makefiles and Kconfig files ...')
 
     # rewrite Makefile and source symbols
+
     regexes = []
     for some_symbols in [orig_symbols[i:i + 50] for i in range(0, len(orig_symbols), 50)]:
         r = 'CONFIG_((' + '|'.join([s + '(_MODULE)?' for s in some_symbols]) + ')([^A-Za-z0-9_]|$))'
@@ -840,9 +887,11 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
         for f in files:
             data = open(os.path.join(root, f), 'r').read()
             for r in regexes:
-                data = r.sub(r'CPTCFG_\1', data)
+                data = r.sub(r'' + bpid.full_prefix + '\\1', data)
             data = re.sub(r'\$\(srctree\)', '$(backport_srctree)', data)
             data = re.sub(r'-Idrivers', '-I$(backport_srctree)/drivers', data)
+            if bpid.integrate:
+                data = re.sub(r'CPTCFG_', bpid.full_prefix, data)
             fo = open(os.path.join(root, f), 'w')
             fo.write(data)
             fo.close()
@@ -886,7 +935,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     # groups -- 50 seemed safer and is still fast)
     regexes = []
     for some_symbols in [disable_makefile[i:i + 50] for i in range(0, len(disable_makefile), 50)]:
-        r = '^([^#].*((CPTCFG|CONFIG)_(' + '|'.join([s for s in some_symbols]) + ')))'
+        r = '^([^#].*((' + bpid.full_prefix_resafe + '|CONFIG_)(' + '|'.join([s for s in some_symbols]) + ')))'
         regexes.append(re.compile(r, re.MULTILINE))
     for f in maketree.get_makefiles():
         data = open(f, 'r').read()
-- 
2.1.1

