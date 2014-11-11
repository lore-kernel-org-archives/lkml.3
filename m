Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaKKIQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:16:07 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33965 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbaKKIQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:16:02 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 09/21] backports: fold outdir as a backport identity target
Date: Tue, 11 Nov 2014 00:15:00 -0800
Message-Id: <1415693712-23743-10-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The output directory is always the same as the project directory
for packaging backports but for integration these will differ,
to make introduction of integration easier to follow use the
outdir as  both project directory and target directory and fold
the existing args.outdir under the backport identity object as
both "project_dir" and "target_dir".

This commit has no functional changes.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 gentree.py | 140 ++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 78 insertions(+), 62 deletions(-)

diff --git a/gentree.py b/gentree.py
index dd7af84..04e8f5e 100755
--- a/gentree.py
+++ b/gentree.py
@@ -30,7 +30,9 @@ class Bp_Identity(object):
     are added, how we actually use the others for regular printing will
     need to be considered.
     """
-    def __init__(self, integrate=False, kconfig_prefix='CPTCFG_', project_prefix=''):
+    def __init__(self, integrate=False, kconfig_prefix='CPTCFG_',
+                 project_prefix='', project_dir='',
+                 target_dir='', target_dir_name=''):
         self.integrate = integrate
         self.kconfig_prefix = kconfig_prefix
         self.kconfig_prefix_resafe = re.escape(kconfig_prefix)
@@ -38,6 +40,9 @@ class Bp_Identity(object):
         self.project_prefix_resafe = re.escape(project_prefix)
         self.full_prefix = kconfig_prefix + project_prefix
         self.full_prefix_resafe = re.escape(self.full_prefix)
+        self.project_dir = project_dir
+        self.target_dir = target_dir
+        self.target_dir_name = target_dir_name
 
 def read_copy_list(copyfile):
     """
@@ -217,11 +222,11 @@ def automatic_backport_mangle_c_file(name):
     return name.replace('/', '-')
 
 
-def add_automatic_backports(args, bpid):
+def add_automatic_backports(args):
     disable_list = []
     export = re.compile(r'^EXPORT_SYMBOL(_GPL)?\((?P<sym>[^\)]*)\)')
-    bpi = kconfig.get_backport_info(os.path.join(args.outdir, 'compat', 'Kconfig'))
-    configtree = kconfig.ConfigTree(os.path.join(args.outdir, 'Kconfig'))
+    bpi = kconfig.get_backport_info(os.path.join(args.bpid.target_dir, 'compat', 'Kconfig'))
+    configtree = kconfig.ConfigTree(os.path.join(args.bpid.target_dir, 'Kconfig'))
     all_selects = configtree.all_selects()
     for sym, vals in bpi.items():
         if sym.startswith('BACKPORT_BUILD_'):
@@ -238,41 +243,41 @@ def add_automatic_backports(args, bpid):
             files.append((os.path.join('include', f),
                           os.path.join('include', os.path.dirname(f), 'backport-' + os.path.basename(f))))
         if args.git_revision:
-            copy_git_files(args.kerneldir, files, args.git_revision, args.outdir)
+            copy_git_files(args.kerneldir, files, args.git_revision, args.bpid.target_dir)
         else:
-            copy_files(args.kerneldir, files, args.outdir)
+            copy_files(args.kerneldir, files, args.bpid.target_dir)
 
         # now add the Makefile line
-        mf = open(os.path.join(args.outdir, 'compat', 'Makefile'), 'a+')
+        mf = open(os.path.join(args.bpid.target_dir, 'compat', 'Makefile'), 'a+')
         o_files = [automatic_backport_mangle_c_file(f)[:-1] + 'o' for f in c_files]
         if symtype == 'tristate':
             if not module_name:
                 raise Exception('backporting a module requires a #module-name')
             for of in o_files:
                 mf.write('%s-objs += %s\n' % (module_name, of))
-            mf.write('obj-$(%s%s) += %s.o\n' % (bpid.full_prefix, sym, module_name))
+            mf.write('obj-$(%s%s) += %s.o\n' % (args.bpid.full_prefix, sym, module_name))
         elif symtype == 'bool':
-            mf.write('compat-$(%s%s) += %s\n' % (bpid.full_prefix, sym, ' '.join(o_files)))
+            mf.write('compat-$(%s%s) += %s\n' % (args.bpid.full_prefix, sym, ' '.join(o_files)))
 
         # finally create the include file
         syms = []
         for f in c_files:
-            for l in open(os.path.join(args.outdir, 'compat',
+            for l in open(os.path.join(args.bpid.target_dir, 'compat',
                                        automatic_backport_mangle_c_file(f)), 'r'):
                 m = export.match(l)
                 if m:
                     syms.append(m.group('sym'))
         for f in h_files:
-            outf = open(os.path.join(args.outdir, 'include', f), 'w')
+            outf = open(os.path.join(args.bpid.target_dir, 'include', f), 'w')
             outf.write('/* Automatically created during backport process */\n')
-            outf.write('#ifndef %s%s\n' % (bpid.full_prefix, sym))
+            outf.write('#ifndef %s%s\n' % (args.bpid.full_prefix, sym))
             outf.write('#include_next <%s>\n' % f)
             outf.write('#else\n');
             for s in syms:
                 outf.write('#undef %s\n' % s)
                 outf.write('#define %s LINUX_BACKPORT(%s)\n' % (s, s))
             outf.write('#include <%s>\n' % (os.path.dirname(f) + '/backport-' + os.path.basename(f), ))
-            outf.write('#endif /* %s%s */\n' % (bpid.full_prefix, sym))
+            outf.write('#endif /* %s%s */\n' % (args.bpid.full_prefix, sym))
     return disable_list
 
 def git_debug_init(args):
@@ -283,8 +288,8 @@ def git_debug_init(args):
     """
     if not args.gitdebug:
         return
-    git.init(tree=args.outdir)
-    git.commit_all("Copied backport", tree=args.outdir)
+    git.init(tree=args.bpid.project_dir)
+    git.commit_all("Copied backport", tree=args.bpid.project_dir)
 
 
 def git_debug_snapshot(args, name):
@@ -293,7 +298,7 @@ def git_debug_snapshot(args, name):
     """
     if not args.gitdebug:
         return
-    git.commit_all(name, tree=args.outdir)
+    git.commit_all(name, tree=args.bpid.project_dir)
 
 def get_rel_spec_stable(rel):
     """
@@ -426,12 +431,12 @@ def upload_release(args, rel_prep, logwrite=lambda x:None):
     if (rel_prep['stable']):
         korg_path += "/stable"
 
-    parent = os.path.dirname(args.outdir)
-    release = os.path.basename(args.outdir)
+    parent = os.path.dirname(args.bpid.project_dir)
+    release = os.path.basename(args.bpid.project_dir)
     tar_name = parent + '/' + release + ".tar"
     gzip_name = tar_name + ".gz"
 
-    create_tar_and_gz(tar_name, args.outdir)
+    create_tar_and_gz(tar_name, args.bpid.project_dir)
 
     logwrite(gpg.sign(tar_name, extra_args=['--armor', '--detach-sign']))
 
@@ -656,13 +661,42 @@ def _main():
                              'of changes done by Coccinelle.')
     args = parser.parse_args()
 
+    # When building a package we use CPTCFG as we can rely on the
+    # fact that kconfig treats CONFIG_ as an environment variable
+    # requring less changes on code. For kernel integration we use
+    # the longer CONFIG_BACKPORT given that we'll be sticking to
+    # the kernel symbol namespace, to address that we do a final
+    # search / replace. Technically its possible to rely on the
+    # same prefix for packaging as with kernel integration but
+    # there are already some users of the CPTCFG prefix.
+    bpid = None
+    integrate = False
+    if integrate:
+        bpid = Bp_Identity(integrate = integrate,
+                           kconfig_prefix = 'CONFIG_',
+                           project_prefix = 'BACKPORT_',
+                           project_dir = args.outdir,
+                           target_dir = os.path.join(args.outdir, 'backports/'),
+                           target_dir_name = 'backports/',
+                           )
+    else:
+        bpid = Bp_Identity(integrate = integrate,
+                           kconfig_prefix = 'CPTCFG_',
+                           project_prefix = '',
+                           project_dir = args.outdir,
+                           target_dir = args.outdir,
+                           target_dir_name = '',
+                           )
+
     def logwrite(msg):
         sys.stdout.write(msg)
         sys.stdout.write('\n')
         sys.stdout.flush()
 
-    return process(args.kerneldir, args.outdir, args.copy_list,
-                   git_revision=args.git_revision, clean=args.clean,
+    return process(args.kerneldir, args.copy_list,
+                   git_revision=args.git_revision,
+                   bpid=bpid,
+                   clean=args.clean,
                    refresh=args.refresh, base_name=args.base_name,
                    gitdebug=args.gitdebug, verbose=args.verbose,
                    extra_driver=args.extra_driver,
@@ -672,7 +706,8 @@ def _main():
                    profile_cocci=args.profile_cocci,
                    logwrite=logwrite)
 
-def process(kerneldir, outdir, copy_list_file, git_revision=None,
+def process(kerneldir, copy_list_file, git_revision=None,
+            bpid=None,
             clean=False, refresh=False, base_name="Linux", gitdebug=False,
             verbose=False, extra_driver=[], kup=False,
             kup_test=False,
@@ -681,16 +716,16 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
             logwrite=lambda x:None,
             git_tracked_version=False):
     class Args(object):
-        def __init__(self, kerneldir, outdir, copy_list_file,
-                     git_revision, clean, refresh, base_name,
+        def __init__(self, kerneldir, copy_list_file,
+                     git_revision, bpid, clean, refresh, base_name,
                      gitdebug, verbose, extra_driver, kup,
                      kup_test,
                      test_cocci,
                      profile_cocci):
             self.kerneldir = kerneldir
-            self.outdir = outdir
             self.copy_list = copy_list_file
             self.git_revision = git_revision
+            self.bpid = bpid
             self.clean = clean
             self.refresh = refresh
             self.base_name = base_name
@@ -712,30 +747,11 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
         else:
             logwrite('Validated tree: %s' % tree)
 
-    args = Args(kerneldir, outdir, copy_list_file,
-                git_revision, clean, refresh, base_name,
+    args = Args(kerneldir, copy_list_file,
+                git_revision, bpid, clean, refresh, base_name,
                 gitdebug, verbose, extra_driver, kup, kup_test,
                 test_cocci, profile_cocci)
     rel_prep = None
-    integrate = False
-
-    # When building a package we use CPTCFG as we can rely on the
-    # fact that kconfig treats CONFIG_ as an environment variable
-    # requring less changes on code. For kernel integration we use
-    # the longer CONFIG_BACKPORT given that we'll be sticking to
-    # the kernel symbol namespace, to address that we do a final
-    # search / replace. Technically its possible to rely on the
-    # same prefix for packaging as with kernel integration but
-    # there are already some users of the CPTCFG prefix.
-    bpid = None
-    if integrate:
-        bpid = Bp_Identity(integrate = integrate,
-                           kconfig_prefix = 'CONFIG_',
-                           project_prefix = 'BACKPORT_')
-    else:
-        bpid = Bp_Identity(integrate = integrate,
-                           kconfig_prefix = 'CPTCFG_',
-                           project_prefix = '')
 
     # start processing ...
     if (args.kup or args.kup_test):
@@ -743,7 +759,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
         git_paranoia(kerneldir, logwrite)
 
         rel_describe = git.describe(rev=None, tree=source_dir, extra_args=['--dirty'])
-        release = os.path.basename(args.outdir)
+        release = os.path.basename(bpid.target_dir)
         version = release.replace("backports-", "")
 
         rel_prep = get_rel_prep(version)
@@ -768,7 +784,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     deplist = read_dependencies(os.path.join(source_dir, 'dependencies'))
 
     # validate output directory
-    check_output_dir(args.outdir, args.clean)
+    check_output_dir(bpid.target_dir, args.clean)
 
     # do the copy
     backport_files = [(x, x) for x in [
@@ -782,33 +798,33 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     else:
         logwrite('Get original source files from git ...')
     
-    copy_files(os.path.join(source_dir, 'backport'), backport_files, args.outdir)
+    copy_files(os.path.join(source_dir, 'backport'), backport_files, bpid.target_dir)
 
     git_debug_init(args)
 
     if not args.git_revision:
-        copy_files(args.kerneldir, copy_list, args.outdir)
+        copy_files(args.kerneldir, copy_list, bpid.target_dir)
     else:
-        copy_git_files(args.kerneldir, copy_list, args.git_revision, args.outdir)
+        copy_git_files(args.kerneldir, copy_list, args.git_revision, bpid.target_dir)
 
     # FIXME: should we add a git version of this (e.g. --git-extra-driver)?
     for src, copy_list in args.extra_driver:
         if (args.kup or args.kup_test):
             git_paranoia(src)
-        copy_files(src, read_copy_list(open(copy_list, 'r')), args.outdir)
+        copy_files(src, read_copy_list(open(copy_list, 'r')), bpid.target_dir)
 
     git_debug_snapshot(args, 'Add driver sources')
 
-    disable_list = add_automatic_backports(args, bpid)
+    disable_list = add_automatic_backports(args)
     if disable_list:
-        bpcfg = kconfig.ConfigTree(os.path.join(args.outdir, 'compat', 'Kconfig'))
+        bpcfg = kconfig.ConfigTree(os.path.join(bpid.target_dir, 'compat', 'Kconfig'))
         bpcfg.disable_symbols(disable_list)
     git_debug_snapshot(args, 'Add automatic backports')
 
-    apply_patches(args, "backport", source_dir, 'patches', args.outdir, logwrite)
+    apply_patches(args, "backport", source_dir, 'patches', bpid.target_dir, logwrite)
 
     # some post-processing is required
-    configtree = kconfig.ConfigTree(os.path.join(args.outdir, 'Kconfig'))
+    configtree = kconfig.ConfigTree(os.path.join(bpid.target_dir, 'Kconfig'))
     orig_symbols = configtree.symbols()
 
     logwrite('Modify Kconfig tree ...')
@@ -831,7 +847,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
         kernel_version = git.describe(rev=args.git_revision or 'HEAD',
                                       tree=args.kerneldir,
                                       extra_args=['--long'])
-    f = open(os.path.join(args.outdir, 'versions'), 'w')
+    f = open(os.path.join(bpid.target_dir, 'versions'), 'w')
     f.write('BACKPORTS_VERSION="%s"\n' % backports_version)
     f.write('BACKPORTED_KERNEL_VERSION="%s"\n' % kernel_version)
     f.write('BACKPORTED_KERNEL_NAME="%s"\n' % args.base_name)
@@ -844,7 +860,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
 
     # write local symbol list -- needed during packaging build
     if not bpid.integrate:
-        f = open(os.path.join(args.outdir, '.local-symbols'), 'w')
+        f = open(os.path.join(bpid.project_dir, '.local-symbols'), 'w')
         for sym in symbols:
             f.write('%s=\n' % sym)
         f.close()
@@ -852,7 +868,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
 
     # add defconfigs that we want
     defconfigs_dir = os.path.join(source_dir, 'backport', 'defconfigs')
-    os.mkdir(os.path.join(args.outdir, 'defconfigs'))
+    os.mkdir(os.path.join(bpid.target_dir, 'defconfigs'))
     for dfbase in os.listdir(defconfigs_dir):
         copy_defconfig = True
         dfsrc = os.path.join(defconfigs_dir, dfbase)
@@ -868,7 +884,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
                 copy_defconfig = False
                 break
         if copy_defconfig:
-            shutil.copy(dfsrc, os.path.join(args.outdir, 'defconfigs', dfbase))
+            shutil.copy(dfsrc, os.path.join(bpid.target_dir, 'defconfigs', dfbase))
 
     git_debug_snapshot(args, "add (useful) defconfig files")
 
@@ -880,7 +896,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     for some_symbols in [orig_symbols[i:i + 50] for i in range(0, len(orig_symbols), 50)]:
         r = 'CONFIG_((' + '|'.join([s + '(_MODULE)?' for s in some_symbols]) + ')([^A-Za-z0-9_]|$))'
         regexes.append(re.compile(r, re.MULTILINE))
-    for root, dirs, files in os.walk(args.outdir):
+    for root, dirs, files in os.walk(bpid.target_dir):
         # don't go into .git dir (possible debug thing)
         if '.git' in dirs:
             dirs.remove('.git')
@@ -899,7 +915,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     git_debug_snapshot(args, "rename config symbol / srctree usage")
 
     # disable unbuildable Kconfig symbols and stuff Makefiles that doesn't exist
-    maketree = make.MakeTree(os.path.join(args.outdir, 'Makefile.kernel'))
+    maketree = make.MakeTree(os.path.join(bpid.target_dir, 'Makefile.kernel'))
     disable_kconfig = []
     disable_makefile = []
     for sym in maketree.get_impossible_symbols():
-- 
2.1.1

