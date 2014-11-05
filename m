Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaKEDVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:21:03 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51861 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbaKEDTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:19:23 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 08/13] backports: move version file generation to run earlier
Date: Tue,  4 Nov 2014 19:18:32 -0800
Message-Id: <1415157517-15442-9-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The version file contains:

  * BACKPORTS_VERSION
  * BACKPORTED_KERNEL_VERSION
  * BACKPORTED_KERNEL_NAME

This file is used by the Makefile to export variable
definitions used to identify the backport. For kernel
integration we'll be using a generated Kconfig file
instead and since these are needed when processing
kconfig logic this will need to be defined earlier.

Just move the generation of the version file for packaging
up early to match where we will generate the Kconfig with
the backports versioning identification.

This change has no real functional change other than the
move of some code running earlier.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 gentree.py | 50 ++++++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/gentree.py b/gentree.py
index 860bb71..1b6dc89 100755
--- a/gentree.py
+++ b/gentree.py
@@ -789,6 +789,25 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
 
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
+    if not integrate:
+        f = open(os.path.join(args.outdir, 'versions'), 'w')
+        f.write('BACKPORTS_VERSION="%s"\n' % backports_version)
+        f.write('BACKPORTED_KERNEL_VERSION="%s"\n' % kernel_version)
+        f.write('BACKPORTED_KERNEL_NAME="%s"\n' % args.base_name)
+        if git_tracked_version:
+            f.write('BACKPORTS_GIT_TRACKED="backport tracker ID: $(shell git rev-parse HEAD 2>/dev/null || echo \'not built in git tree\')"\n')
+        f.close()
+        git_debug_snapshot(args, "generate kernel version info file: version")
+
     disable_list = add_automatic_backports(args, bp_prefix)
     if disable_list:
         bpcfg = kconfig.ConfigTree(os.path.join(args.outdir, 'compat', 'Kconfig'))
@@ -815,32 +834,15 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
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
+    if not integrate:
+        # write local symbol list -- needed during build
+        f = open(os.path.join(args.outdir, '.local-symbols'), 'w')
+        for sym in symbols:
+            f.write('%s=\n' % sym)
+        f.close()
+        git_debug_snapshot(args, "add symbols files")
 
     # add defconfigs that we want
     defconfigs_dir = os.path.join(source_dir, 'backport', 'defconfigs')
-- 
2.1.1

