Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab3CCBzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 20:55:00 -0500
Received: from smtp-01.mandic.com.br ([200.225.81.132]:36030 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab3CCByS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 20:54:18 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 13/14] scripts: add checkmaintainers.py
Date: Sat,  2 Mar 2013 22:53:51 -0300
Message-Id: <1362275632-20242-14-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small script checks the file patterns in the MAINTAINERS file.

For every file pattern, it checks if the pattern matches any file or
directory in the kernel tree, printing the patterns which do not have a
match.

It also checks for any file pattern pointing to any of the include
directories which does not have a corresponding UAPI file pattern, but
only if the UAPI file pattern would have a match. It also does the same
in the opposite direction.

The script is written in Python; I found its glob function more
well-behaved than Perl's. It should work on both Python 2 and Python 3
without any changes (not even 2to3 is needed); tested on 2.7, 3.2, and
3.3.

I do not think such a short script should have a copyright. But to avoid
any problems, I arbitrarily used the "GNU All-Permissive License" (found
in FSF's GPL-compatible list). If needed, feel free to relicense it as
GPLv2+, 3-clause BSD, or even WTFPLv2 or CC0.

Cc: David Howells <dhowells@redhat.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 scripts/checkmaintainers.py | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100755 scripts/checkmaintainers.py

diff --git a/scripts/checkmaintainers.py b/scripts/checkmaintainers.py
new file mode 100755
index 0000000..99740e3
--- /dev/null
+++ b/scripts/checkmaintainers.py
@@ -0,0 +1,35 @@
+#!/usr/bin/python
+# Quick check for missing file patterns in the MAINTAINERS file.
+#
+# Copyright (C) 2012 Cesar Eduardo Barros <cesarb@cesarb.net>
+#
+# Copying and distribution of this file, with or without modification,
+# are permitted in any medium without royalty provided the copyright
+# notice and this notice are preserved.  This file is offered as-is,
+# without any warranty.
+
+from __future__ import print_function, unicode_literals, with_statement
+from glob import glob
+
+seen = set()
+
+with open('MAINTAINERS', 'rb') as f:
+    for line in f:
+        line = line.decode('utf-8')
+        if line.startswith('F:'):
+            pattern = line.partition(':')[2].strip()
+            seen.add(pattern)
+
+            if not glob(pattern):
+                print('No match for F: {0}'.format(pattern))
+
+# Check for missing uapi/ pattern
+for pattern in seen:
+    if 'include/' in pattern:
+        if 'include/uapi/' in pattern:
+            other = pattern.replace('include/uapi/', 'include/')
+        else:
+            other = pattern.replace('include/', 'include/uapi/')
+
+        if other not in seen and glob(other):
+            print('Missing {0} for {1}'.format(other, pattern))
-- 
1.7.11.7

