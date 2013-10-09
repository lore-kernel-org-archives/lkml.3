Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3JIVwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 17:52:43 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:34578 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3JIVwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 17:52:41 -0400
Message-ID: <5255D023.2030907@gmail.com>
Date: Thu, 10 Oct 2013 08:52:35 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com,
        Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        George Spelvin <linux@horizon.com>
CC: "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] vsprintf: Check real user/group id for %pK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some setuid binaries will allow reading of files which have read
permission by the real user id. This is problematic with files which
use %pK because the file access permission is checked at open() time,
but the kptr_restrict setting is checked at read() time. If a setuid
binary opens a %pK file as an unprivileged user, and then elevates
permissions before reading the file, then kernel pointer values may be
leaked.

This happens for example with the setuid pppd application on Ubuntu 12.04:

  $ head -1 /proc/kallsyms
  00000000 T startup_32

  $ pppd file /proc/kallsyms
  pppd: In file /proc/kallsyms: unrecognized option 'c1000000'

This will only leak the pointer value from the first line, but other
setuid binaries may leak more information.

Fix this by adding a check that in addition to the current process
having CAP_SYSLOG, that effective user and group ids are equal to the
real ids. If a setuid binary reads the contents of a file which uses
%pK then the pointer values will be printed as NULL if the real user
is unprivileged.

Update the sysctl documentation to reflect the changes, and also
correct the documentation to state the kptr_restrict=0 is the default.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---
Changes since v2:
  * Fixed typo in comment: 'proccess' -> 'process'
  * Use a switch statement for the kptr_restrict values
  * Updated the sysctl documentation

Changes since v1:
  * Fix the description to say 'vsprintf' instead of 'printk'.
  * Clarify the open() vs read() time checks in the patch description
and code comment.
  * Remove comment about 'badly written' setuid binaries. This occurs
with setuids binaries which correctly handle opening files.
  * Added extra people to the Cc list.
---

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 9d4c1d1..d57766e 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -290,13 +290,14 @@ Default value is "/sbin/hotplug".
 kptr_restrict:
 
 This toggle indicates whether restrictions are placed on
-exposing kernel addresses via /proc and other interfaces.  When
-kptr_restrict is set to (0), there are no restrictions.  When
-kptr_restrict is set to (1), the default, kernel pointers
-printed using the %pK format specifier will be replaced with 0's
-unless the user has CAP_SYSLOG.  When kptr_restrict is set to
-(2), kernel pointers printed using %pK will be replaced with 0's
-regardless of privileges.
+exposing kernel addresses via /proc and other interfaces.
+
+When kptr_restrict is set to (0), the default, there are no restrictions.
+When kptr_restrict is set to (1), kernel pointers printed using the %pK
+format specifier will be replaced with 0's unless the user has CAP_SYSLOG
+and effective user and group ids are equal to the real ids.
+When kptr_restrict is set to (2), kernel pointers printed using
+%pK will be replaced with 0's regardless of privileges.
 
 ==============================================================
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 26559bd..d76555c 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/ioport.h>
 #include <linux/dcache.h>
+#include <linux/cred.h>
 #include <net/addrconf.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
@@ -1312,11 +1313,37 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 				spec.field_width = default_width;
 			return string(buf, end, "pK-error", spec);
 		}
-		if (!((kptr_restrict == 0) ||
-		      (kptr_restrict == 1 &&
-		       has_capability_noaudit(current, CAP_SYSLOG))))
+
+		switch (kptr_restrict) {
+		case 0:
+			/* Always print %pK values */
+			break;
+		case 1: {
+			/*
+			 * Only print the real pointer value if the current
+			 * process has CAP_SYSLOG and is running with the
+			 * same credentials it started with. This is because
+			 * access to files is checked at open() time, but %pK
+			 * checks permission at read() time. We don't want to
+			 * leak pointer values if a binary opens a file using
+			 * %pK and then elevates privileges before reading it.
+			 */
+			const struct cred *cred = current_cred();
+
+			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
+			    !uid_eq(cred->euid, cred->uid) ||
+			    !gid_eq(cred->egid, cred->gid))
+				ptr = NULL;
+			break;
+		}
+		case 2:
+		default:
+			/* Always print 0's for %pK */
 			ptr = NULL;
+			break;
+		}
 		break;
+
 	case 'N':
 		switch (fmt[1]) {
 		case 'F':


