Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab3LBUSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:18:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3LBTR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ryan Mallon <rmallon@gmail.com>, Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Joe Perches <joe@perches.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 047/212] vsprintf: check real user/group id for %pK
Date: Mon,  2 Dec 2013 11:13:58 -0800
Message-Id: <20131202191253.528886767@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Mallon <rmallon@gmail.com>

commit 312b4e226951f707e120b95b118cbc14f3d162b2 upstream.

Some setuid binaries will allow reading of files which have read
permission by the real user id.  This is problematic with files which
use %pK because the file access permission is checked at open() time,
but the kptr_restrict setting is checked at read() time.  If a setuid
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

Fix this by adding a check that in addition to the current process having
CAP_SYSLOG, that effective user and group ids are equal to the real ids.
If a setuid binary reads the contents of a file which uses %pK then the
pointer values will be printed as NULL if the real user is unprivileged.

Update the sysctl documentation to reflect the changes, and also correct
the documentation to state the kptr_restrict=0 is the default.

This is a only temporary solution to the issue.  The correct solution is
to do the permission check at open() time on files, and to replace %pK
with a function which checks the open() time permission.  %pK uses in
printk should be removed since no sane permission check can be done, and
instead protected by using dmesg_restrict.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Joe Perches <joe@perches.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/sysctl/kernel.txt |   25 ++++++++++++++++++-------
 lib/vsprintf.c                  |   33 ++++++++++++++++++++++++++++++---
 2 files changed, 48 insertions(+), 10 deletions(-)

--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -290,13 +290,24 @@ Default value is "/sbin/hotplug".
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
+
+When kptr_restrict is set to (1), kernel pointers printed using the %pK
+format specifier will be replaced with 0's unless the user has CAP_SYSLOG
+and effective user and group ids are equal to the real ids. This is
+because %pK checks are done at read() time rather than open() time, so
+if permissions are elevated between the open() and the read() (e.g via
+a setuid binary) then %pK will not leak kernel pointers to unprivileged
+users. Note, this is a temporary solution only. The correct long-term
+solution is to do the permission checks at open() time. Consider removing
+world read permissions from files that use %pK, and using dmesg_restrict
+to protect against uses of %pK in dmesg(8) if leaking kernel pointer
+values to unprivileged users is a concern.
+
+When kptr_restrict is set to (2), kernel pointers printed using
+%pK will be replaced with 0's regardless of privileges.
 
 ==============================================================
 
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/ioport.h>
 #include <linux/dcache.h>
+#include <linux/cred.h>
 #include <net/addrconf.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
@@ -1312,11 +1313,37 @@ char *pointer(const char *fmt, char *buf
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


