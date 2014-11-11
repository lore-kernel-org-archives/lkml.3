Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaKKIQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:16:44 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34128 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaKKIQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:16:42 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 18/21] backports: add backport version parsing for kernel integration
Date: Tue, 11 Nov 2014 00:15:09 -0800
Message-Id: <1415693712-23743-19-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
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
index afa4967..3e130f1 100755
--- a/gentree.py
+++ b/gentree.py
@@ -861,6 +861,24 @@ def process(kerneldir, copy_list_file, git_revision=None,
             f.write('BACKPORTS_GIT_TRACKED="backport tracker ID: $(shell git rev-parse HEAD 2>/dev/null || echo \'not built in git tree\')"\n')
         f.close()
         git_debug_snapshot(args, "add versions files")
+    else:
+        kconf_regexes = [
+                (re.compile(r'.*(?P<key>%%BACKPORT_DIR%%)'), '%%BACKPORT_DIR%%', 'backports/'),
+                (re.compile(r'.*(?P<key>%%BACKPORTS_VERSION%%).*'), '%%BACKPORTS_VERSION%%', backports_version),
+                (re.compile(r'.*(?P<key>%%BACKPORTED_KERNEL_VERSION%%).*'), '%%BACKPORTED_KERNEL_VERSION%%', kernel_version),
+                (re.compile(r'.*(?P<key>%%BACKPORTED_KERNEL_NAME%%).*'), '%%BACKPORTED_KERNEL_NAME%%', args.base_name),
+        ]
+        out = ''
+        for l in open(os.path.join(bpid.target_dir, 'Kconfig'), 'r'):
+            for r in kconf_regexes:
+                m = r[0].match(l)
+                if m:
+                    l = re.sub(r'(' + r[1] + ')', r'' + r[2] + '', l)
+            out += l
+        outf = open(os.path.join(bpid.target_dir, 'Kconfig'), 'w')
+        outf.write(out)
+        outf.close()
+        git_debug_snapshot(args, "modify top level backports/Kconfig with backports identity")
 
     if disable_list:
         # No need to verify_sources() as compat's Kconfig has no 'source' call
-- 
2.1.1

