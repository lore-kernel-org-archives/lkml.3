Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaKKIP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:15:27 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35647 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaKKIPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:15:23 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 01/21] backports: move legacy and SmPL patch application into helper
Date: Tue, 11 Nov 2014 00:14:52 -0800
Message-Id: <1415693712-23743-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This allows us to extend how backports uses patches for
different types of applications. This will later be used
for kernel integration support, for example.

This should have no functional change.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 gentree.py | 279 +++++++++++++++++++++++++++++++------------------------------
 1 file changed, 144 insertions(+), 135 deletions(-)

diff --git a/gentree.py b/gentree.py
index 9b4db98..59ae19d 100755
--- a/gentree.py
+++ b/gentree.py
@@ -438,6 +438,149 @@ def upload_release(args, rel_prep, logwrite=lambda x:None):
         kup_cmd = "kup put /\n\t\t%s /\n\t\t%s /\n\t\t%s" % (gzip_name, tar_name + '.asc', korg_path)
         logwrite("kup-test: skipping cmd: %s" % kup_cmd)
 
+def apply_patches(args, desc, source_dir, patch_src, target_dir, logwrite=lambda x:None):
+    """
+    Given a path of a directories of patches and SmPL patches apply
+    them on the target directory. If requested refresh patches, or test
+    a specific SmPL patch.
+    """
+    logwrite('Applying patches from %s to %s ...' % (patch_src, target_dir))
+    test_cocci = args.test_cocci or args.profile_cocci
+    test_cocci_found = False
+    patches = []
+    sempatches = []
+    for root, dirs, files in os.walk(os.path.join(source_dir, patch_src)):
+        for f in files:
+            if not test_cocci and f.endswith('.patch'):
+                patches.append(os.path.join(root, f))
+            if f.endswith('.cocci'):
+                if test_cocci:
+                    if f not in test_cocci:
+                        continue
+                    test_cocci_found = True
+                    if args.test_cocci:
+                        logwrite("Testing Coccinelle SmPL patch: %s" % test_cocci)
+                    elif args.profile_cocci:
+                        logwrite("Profiling Coccinelle SmPL patch: %s" % test_cocci)
+                sempatches.append(os.path.join(root, f))
+    patches.sort()
+    prefix_len = len(os.path.join(source_dir, patch_src)) + 1
+    for pfile in patches:
+        print_name = pfile[prefix_len:]
+        # read the patch file
+        p = patch.fromfile(pfile)
+        # complain if it's not a patch
+        if not p:
+            raise Exception('No patch content found in %s' % print_name)
+        # leading / seems to be stripped?
+        if 'dev/null' in p.items[0].source:
+            raise Exception('Patches creating files are not supported (in %s)' % print_name)
+        # check if the first file the patch touches exists, if so
+        # assume the patch needs to be applied -- otherwise continue
+        patched_file = '/'.join(p.items[0].source.split('/')[1:])
+        fullfn = os.path.join(target_dir, patched_file)
+        if not os.path.exists(fullfn):
+            if args.verbose:
+                logwrite("Not applying %s, not needed" % print_name)
+            continue
+        if args.verbose:
+            logwrite("Applying patch %s" % print_name)
+
+        if args.refresh:
+            # but for refresh, of course look at all files the patch touches
+            for patchitem in p.items:
+                patched_file = '/'.join(patchitem.source.split('/')[1:])
+                fullfn = os.path.join(target_dir, patched_file)
+                shutil.copyfile(fullfn, fullfn + '.orig_file')
+
+        process = subprocess.Popen(['patch', '-p1'], stdout=subprocess.PIPE,
+                                   stderr=subprocess.STDOUT, stdin=subprocess.PIPE,
+                                   close_fds=True, universal_newlines=True,
+                                   cwd=target_dir)
+        output = process.communicate(input=open(pfile, 'r').read())[0]
+        output = output.split('\n')
+        if output[-1] == '':
+            output = output[:-1]
+        if args.verbose:
+            for line in output:
+                logwrite('> %s' % line)
+        if process.returncode != 0:
+            if not args.verbose:
+                logwrite("Failed to apply changes from %s" % print_name)
+                for line in output:
+                    logwrite('> %s' % line)
+            raise Exception('Patch failed')
+
+        if args.refresh:
+            pfilef = open(pfile + '.tmp', 'a')
+            pfilef.write(p.top_header)
+            pfilef.flush()
+            for patchitem in p.items:
+                patched_file = '/'.join(patchitem.source.split('/')[1:])
+                fullfn = os.path.join(target_dir, patched_file)
+                process = subprocess.Popen(['diff', '-p', '-u', patched_file + '.orig_file', patched_file,
+                                            '--label', 'a/' + patched_file,
+                                            '--label', 'b/' + patched_file],
+                                           stdout=pfilef, close_fds=True,
+                                           universal_newlines=True, cwd=target_dir)
+                process.wait()
+                os.unlink(fullfn + '.orig_file')
+                if not process.returncode in (0, 1):
+                    logwrite("Failed to diff to refresh %s" % print_name)
+                    pfilef.close()
+                    os.unlink(pfile + '.tmp')
+                    raise Exception('Refresh failed')
+            pfilef.close()
+            os.rename(pfile + '.tmp', pfile)
+
+        # remove orig/rej files that patch sometimes creates
+        for root, dirs, files in os.walk(target_dir):
+            for f in files:
+                if f[-5:] == '.orig' or f[-4:] == '.rej':
+                    os.unlink(os.path.join(root, f))
+        git_debug_snapshot(args, "apply %s patch %s" % (desc, print_name))
+
+    sempatches.sort()
+    prefix_len = len(os.path.join(source_dir, patch_src)) + 1
+
+    for cocci_file in sempatches:
+        # Until Coccinelle picks this up
+        pycocci = os.path.join(source_dir, 'devel/pycocci')
+        cmd = [pycocci, cocci_file]
+        extra_spatch_args = []
+        if args.profile_cocci:
+            cmd.append('--profile-cocci')
+        cmd.append(os.path.abspath(target_dir))
+        print_name = cocci_file[prefix_len:]
+        if args.verbose:
+            logwrite("Applying SmPL patch %s" % print_name)
+        sprocess = subprocess.Popen(cmd,
+                                    stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
+                                    close_fds=True, universal_newlines=True,
+                                    cwd=target_dir)
+        output = sprocess.communicate()[0]
+        sprocess.wait()
+        if sprocess.returncode != 0:
+            logwrite("Failed to process SmPL patch %s" % print_name)
+            raise Exception('SmPL patch failed')
+        output = output.split('\n')
+        if output[-1] == '':
+            output = output[:-1]
+        if args.verbose:
+            for line in output:
+                logwrite('> %s' % line)
+
+        # remove cocci_backup files
+        for root, dirs, files in os.walk(target_dir):
+            for f in files:
+                if f.endswith('.cocci_backup'):
+                    os.unlink(os.path.join(root, f))
+        git_debug_snapshot(args, "apply %s SmPL patch %s" % (desc, print_name))
+
+    if test_cocci and test_cocci_found:
+        logwrite('Done!')
+        sys.exit(0)
+
 def _main():
     # Our binary requirements go here
     req = reqs.Req()
@@ -620,141 +763,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
         bpcfg.disable_symbols(disable_list)
     git_debug_snapshot(args, 'Add automatic backports')
 
-    test_cocci = args.test_cocci or args.profile_cocci
-
-    logwrite('Apply patches ...')
-    patches = []
-    sempatches = []
-    for root, dirs, files in os.walk(os.path.join(source_dir, 'patches')):
-        for f in files:
-            if not test_cocci and f.endswith('.patch'):
-                patches.append(os.path.join(root, f))
-            if f.endswith('.cocci'):
-                if test_cocci:
-                    if f not in test_cocci:
-                        continue
-                    if args.test_cocci:
-                        logwrite("Testing Coccinelle SmPL patch: %s" % test_cocci)
-                    elif args.profile_cocci:
-                        logwrite("Profiling Coccinelle SmPL patch: %s" % test_cocci)
-                sempatches.append(os.path.join(root, f))
-    patches.sort()
-    prefix_len = len(os.path.join(source_dir, 'patches')) + 1
-    for pfile in patches:
-        print_name = pfile[prefix_len:]
-        # read the patch file
-        p = patch.fromfile(pfile)
-        # complain if it's not a patch
-        if not p:
-            raise Exception('No patch content found in %s' % print_name)
-        # leading / seems to be stripped?
-        if 'dev/null' in p.items[0].source:
-            raise Exception('Patches creating files are not supported (in %s)' % print_name)
-        # check if the first file the patch touches exists, if so
-        # assume the patch needs to be applied -- otherwise continue
-        patched_file = '/'.join(p.items[0].source.split('/')[1:])
-        fullfn = os.path.join(args.outdir, patched_file)
-        if not os.path.exists(fullfn):
-            if args.verbose:
-                logwrite("Not applying %s, not needed" % print_name)
-            continue
-        if args.verbose:
-            logwrite("Applying patch %s" % print_name)
-
-        if args.refresh:
-            # but for refresh, of course look at all files the patch touches
-            for patchitem in p.items:
-                patched_file = '/'.join(patchitem.source.split('/')[1:])
-                fullfn = os.path.join(args.outdir, patched_file)
-                shutil.copyfile(fullfn, fullfn + '.orig_file')
-
-        process = subprocess.Popen(['patch', '-p1'], stdout=subprocess.PIPE,
-                                   stderr=subprocess.STDOUT, stdin=subprocess.PIPE,
-                                   close_fds=True, universal_newlines=True,
-                                   cwd=args.outdir)
-        output = process.communicate(input=open(pfile, 'r').read())[0]
-        output = output.split('\n')
-        if output[-1] == '':
-            output = output[:-1]
-        if args.verbose:
-            for line in output:
-                logwrite('> %s' % line)
-        if process.returncode != 0:
-            if not args.verbose:
-                logwrite("Failed to apply changes from %s" % print_name)
-                for line in output:
-                    logwrite('> %s' % line)
-            return 2
-
-        if args.refresh:
-            pfilef = open(pfile + '.tmp', 'a')
-            pfilef.write(p.top_header)
-            pfilef.flush()
-            for patchitem in p.items:
-                patched_file = '/'.join(patchitem.source.split('/')[1:])
-                fullfn = os.path.join(args.outdir, patched_file)
-                process = subprocess.Popen(['diff', '-p', '-u', patched_file + '.orig_file', patched_file,
-                                            '--label', 'a/' + patched_file,
-                                            '--label', 'b/' + patched_file],
-                                           stdout=pfilef, close_fds=True,
-                                           universal_newlines=True, cwd=args.outdir)
-                process.wait()
-                os.unlink(fullfn + '.orig_file')
-                if not process.returncode in (0, 1):
-                    logwrite("Failed to diff to refresh %s" % print_name)
-                    pfilef.close()
-                    os.unlink(pfile + '.tmp')
-                    return 3
-            pfilef.close()
-            os.rename(pfile + '.tmp', pfile)
-
-        # remove orig/rej files that patch sometimes creates
-        for root, dirs, files in os.walk(args.outdir):
-            for f in files:
-                if f[-5:] == '.orig' or f[-4:] == '.rej':
-                    os.unlink(os.path.join(root, f))
-        git_debug_snapshot(args, "apply backport patch %s" % print_name)
-
-    sempatches.sort()
-    prefix_len = len(os.path.join(source_dir, 'patches')) + 1
-
-    for cocci_file in sempatches:
-        # Until Coccinelle picks this up
-        pycocci = os.path.join(source_dir, 'devel/pycocci')
-        cmd = [pycocci, cocci_file]
-        extra_spatch_args = []
-        if args.profile_cocci:
-            cmd.append('--profile-cocci')
-        cmd.append(os.path.abspath(args.outdir))
-        print_name = cocci_file[prefix_len:]
-        if args.verbose:
-            logwrite("Applying SmPL patch %s" % print_name)
-        sprocess = subprocess.Popen(cmd,
-                                    stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
-                                    close_fds=True, universal_newlines=True,
-                                    cwd=args.outdir)
-        output = sprocess.communicate()[0]
-        sprocess.wait()
-        if sprocess.returncode != 0:
-            logwrite("Failed to process SmPL patch %s" % print_name)
-            return 3
-        output = output.split('\n')
-        if output[-1] == '':
-            output = output[:-1]
-        if args.verbose:
-            for line in output:
-                logwrite('> %s' % line)
-
-        # remove cocci_backup files
-        for root, dirs, files in os.walk(args.outdir):
-            for f in files:
-                if f.endswith('.cocci_backup'):
-                    os.unlink(os.path.join(root, f))
-        git_debug_snapshot(args, "apply backport SmPL patch %s" % print_name)
-
-    if test_cocci:
-        logwrite('Done!')
-        return 0
+    apply_patches(args, "backport", source_dir, 'patches', args.outdir, logwrite)
 
     # some post-processing is required
     configtree = kconfig.ConfigTree(os.path.join(args.outdir, 'Kconfig'))
-- 
2.1.1

