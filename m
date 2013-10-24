Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab3JXFXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 01:23:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48347 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751893Ab3JXFXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 01:23:34 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: mmarek@suse.cz, yann.morin.1998@free.fr, akpm@linux-foundation.org,
        joe@perches.com
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] scripts/checkkconfig.py: find unused Kconfig parameters
Date: Thu, 24 Oct 2013 07:23:29 +0200
Message-Id: <1382592209-10246-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first version of a script to look for
Kconfig parameters which are still defined but no longer
used in the kernel source code.

The script may be extended in the future to perform
more checks. This explains why a rather generic name was chosen.

Several issues have already been reported and fixed
thanks to the use of this script. It is time to share it now!

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 scripts/checkkconfig.py | 131 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)
 create mode 100755 scripts/checkkconfig.py

diff --git a/scripts/checkkconfig.py b/scripts/checkkconfig.py
new file mode 100755
index 0000000..4155656
--- /dev/null
+++ b/scripts/checkkconfig.py
@@ -0,0 +1,131 @@
+#!/usr/bin/env python
+#
+# Copyright 2013 Free Electrons
+# Michael Opdenacker <michael.opdenacker@free-electrons.com>
+#
+# Look for issues in Kconfig files
+#
+# This first version supports:
+# - Looking for unused Kconfig parameters
+#
+# Usage: scripts/checkkconfig.py
+#
+# Licensed under the terms of the GNU GPL License version 2
+
+import fnmatch
+import os
+import subprocess
+
+########################################################
+# Parse Kconfig files
+########################################################
+
+def parse_kconfig(file):
+
+    global has_select, choice_type, source_file
+
+    current_param = ''
+    in_choice = False
+
+    with open(file, 'r') as f:
+         for line in f:
+	     words = line.split()
+
+	     if len(words) != 0:
+	        key = words[0]
+
+	        if len(words) == 1:
+
+		   if key == 'choice':
+		      in_choice = True
+		   elif key == 'endchoice':
+		      in_choice = False
+
+	        elif len(words) > 1:
+
+	           if key == 'config' or key == 'menuconfig':
+		      current_param = words[1]
+
+		      has_select[current_param] = False
+		      choice_type[current_param] = in_choice
+		      source_file[current_param] = file
+
+		   elif key == 'select' and words[1] != '':
+
+		      has_select[current_param] = True
+
+########################################################
+# Find occurrences of a parameter
+########################################################
+
+def count_param(param):
+
+    global source_file, bad_params_in_file
+
+    if os.path.isdir('.git'):
+       # Use git grep when available
+       count = subprocess.check_output('git grep ' + param + '| grep -v defconfig | wc -l', shell=True)
+    else:
+       # Fallback to regular grep
+       count = subprocess.check_output('grep -R ' + param + ' . | grep -v defconfig | wc -l', shell=True)
+
+    num = int(count.strip())
+
+    if num == 1:
+       'WARNING: parameter ' + param + ' is used nowhere'
+
+       file=source_file[param]
+
+       if bad_params_in_file.has_key(file):
+          bad_params_in_file[file].append(param)
+       else:
+	  bad_params_in_file[file]=[param]
+
+
+########################################################
+# Main program
+########################################################
+
+global has_select, choice_type, source_file, bad_params_in_file
+
+has_select = dict()
+choice_type = dict()
+source_file = dict()
+bad_params_in_file = dict()
+
+kconfig_files = []
+
+for root, dirnames, filenames in os.walk('.'):
+    for filename in fnmatch.filter(filenames, 'Kconfig*'):
+      	kconfig_files.append(os.path.join(root, filename))
+
+print 'INFO: processing Kconfig files...'
+
+for f in kconfig_files:
+    parse_kconfig(f)
+
+total = len(has_select)
+count = 0
+old_percentage = -1
+
+for param in has_select.keys():
+
+    # Progress information... running the script can take hours!
+
+    count += 1
+    percentage = int((100*count)/total)
+
+    if percentage > old_percentage:
+       print 'INFO: checking kconfig parameter %d / %d (%d %%)' % (count, total, percentage)
+       old_percentage = percentage
+
+    # Ignore parameters with select dependencies
+    # Also ignore parameters inside 'choice ... endchoice'
+    # All of them are valid, even if they have only one instance
+
+    if not(has_select[param]) and not(choice_type[param]):
+       count_param(param)
+
+for file in bad_params_in_file.keys():
+    print 'File: ' + file
+    print bad_params_in_file[file]
-- 
1.8.1.2

