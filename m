Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaKEDTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:19:37 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46935 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaKEDTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:19:34 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 10/13] backports: add backport version parsing for kernel integration
Date: Tue,  4 Nov 2014 19:18:34 -0800
Message-Id: <1415157517-15442-11-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The way we'll define backports versioning information for
kernel integration is slightly different, we'll rely completely
on Kconfig for the job, but in the end share the same C code
defines.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 gentree.py | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/gentree.py b/gentree.py
index 1b6dc89..55abe6d 100755
--- a/gentree.py
+++ b/gentree.py
@@ -807,6 +807,24 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
             f.write('BACKPORTS_GIT_TRACKED="backport tracker ID: $(shell git rev-parse HEAD 2>/dev/null || echo \'not built in git tree\')"\n')
         f.close()
         git_debug_snapshot(args, "generate kernel version info file: version")
+    else:
+        kconf_regexes = [
+                (re.compile(r'.*(?P<key>%%BACKPORT_DIR%%)'), '%%BACKPORT_DIR%%', 'backports/'),
+                (re.compile(r'.*(?P<key>%%BACKPORTS_VERSION%%).*'), '%%BACKPORTS_VERSION%%', backports_version),
+                (re.compile(r'.*(?P<key>%%BACKPORTED_KERNEL_VERSION%%).*'), '%%BACKPORTED_KERNEL_VERSION%%', kernel_version),
+                (re.compile(r'.*(?P<key>%%BACKPORTED_KERNEL_NAME%%).*'), '%%BACKPORTED_KERNEL_NAME%%', args.base_name),
+        ]
+        out = ''
+        for l in open(os.path.join(args.outdir, 'Kconfig'), 'r'):
+            for r in kconf_regexes:
+                m = r[0].match(l)
+                if m:
+                    l = re.sub(r'(' + r[1] + ')', r'' + r[2] + '', l)
+            out += l
+        outf = open(os.path.join(args.outdir, 'Kconfig'), 'w')
+        outf.write(out)
+        outf.close()
+        git_debug_snapshot(args, "modify top level backports/Kconfig with backports identity")
 
     disable_list = add_automatic_backports(args, bp_prefix)
     if disable_list:
-- 
2.1.1

