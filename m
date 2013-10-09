Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3JIXJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:09:54 -0400
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:58306 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752136Ab3JIXJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:09:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:2:41:69:355:379:421:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:2892:2895:2901:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3873:3874:4117:4250:4321:4605:5007:6117:6119:7514:7652:7875:7903:7904:10004:10044:10848:11026:11232:11658:11914:12043:12291:1229
X-HE-Tag: alarm94_1b8835200532c
X-Filterd-Recvd-Size: 6922
Message-ID: <1381360187.2050.44.camel@joe-AO722>
Subject: [PATCH v3a] vsprintf: Check real user/group id for %pK
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com,
        Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        George Spelvin <linux@horizon.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 09 Oct 2013 16:09:47 -0700
In-Reply-To: <5255DBD8.30005@gmail.com>
References: <5255D023.2030907@gmail.com>
	 <1381356014.2050.28.camel@joe-AO722> <5255D2FD.6050705@gmail.com>
	 <1381356861.2050.33.camel@joe-AO722> <5255D7D4.8050204@gmail.com>
	 <1381358030.2050.36.camel@joe-AO722> <5255DBD8.30005@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
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

This happens for example with the setuid pppd application on Ubuntu
12.04:

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

Original-patch-by: Ryan Mallon <rmallon@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
On Thu, 2013-10-10 at 09:42 +1100, Ryan Mallon wrote:
> If it was noisy, it would indicate a bunch of broken kernel code which
> needs fixing :-).

Or maybe a single kernel source line but
you'd still have a filled up log file.

Changes in V3a:

Do the in_irq tests only when kptr_restrict is 1.
Document the %pK mechanism in vsnprintf
Add missing documentation for %pV and %pNF too

 Documentation/sysctl/kernel.txt | 17 ++++++++--------
 lib/vsprintf.c                  | 43 ++++++++++++++++++++++++++++-------------
 2 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 9d4c1d1..c17d5ca 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -289,14 +289,15 @@ Default value is "/sbin/hotplug".
 
 kptr_restrict:
 
-This toggle indicates whether restrictions are placed on
-exposing kernel addresses via /proc and other interfaces.  When
-kptr_restrict is set to (0), there are no restrictions.  When
-kptr_restrict is set to (1), the default, kernel pointers
-printed using the %pK format specifier will be replaced with 0's
-unless the user has CAP_SYSLOG.  When kptr_restrict is set to
-(2), kernel pointers printed using %pK will be replaced with 0's
-regardless of privileges.
+This toggle indicates whether restrictions are placed on exposing kernel
+addresses via /proc and other interfaces.
+
+When kptr_restrict is set to (0), the default, there are no restrictions.
+When kptr_restrict is set to (1), kernel pointers printed using the %pK
+format specifier will be replaced with 0's unless the user has CAP_SYSLOG
+and effective user and group ids are equal to the real ids.
+When kptr_restrict is set to (2), kernel pointers printed using %pK will
+be replaced with 0's regardless of privileges.
 
 ==============================================================
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 26559bd..3efcf29 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/ioport.h>
 #include <linux/dcache.h>
+#include <linux/cred.h>
 #include <net/addrconf.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
@@ -1301,21 +1302,34 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			va_end(va);
 			return buf;
 		}
-	case 'K':
-		/*
-		 * %pK cannot be used in IRQ context because its test
-		 * for CAP_SYSLOG would be meaningless.
-		 */
-		if (kptr_restrict && (in_irq() || in_serving_softirq() ||
-				      in_nmi())) {
-			if (spec.field_width == -1)
-				spec.field_width = default_width;
-			return string(buf, end, "pK-error", spec);
+	case 'K':		/* see: Documentation/sysctl/kernel.txt */
+		switch (kptr_restrict) {
+		case 0:			/* None (default) */
+			break;
+		case 1: {		/* Restricted */
+			const struct cred *cred;
+
+			if (in_irq() || in_serving_softirq() || in_nmi()) {
+				/*
+				 * This cannot be used in IRQ context because
+				 * the test for CAP_SYSLOG would be meaningless
+				 */
+				if (spec.field_width == -1)
+					spec.field_width = default_width;
+				return string(buf, end, "pK-error", spec);
+			}
+			cred = current_cred();
+			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
+			    !uid_eq(cred->euid, cred->uid) ||
+			    !gid_eq(cred->egid, cred->gid))
+				ptr = NULL;
+			break;
 		}
-		if (!((kptr_restrict == 0) ||
-		      (kptr_restrict == 1 &&
-		       has_capability_noaudit(current, CAP_SYSLOG))))
+		case 2:			/* Never - Always emit 0 */
+		default:
 			ptr = NULL;
+			break;
+		}
 		break;
 	case 'N':
 		switch (fmt[1]) {
@@ -1574,6 +1588,9 @@ qualifier:
  * %piS depending on sa_family of 'struct sockaddr *' print IPv4/IPv6 address
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
+ * %pV recurse and output a struct va_format (const char *fmt, va_list *)
+ * %pK output a kernel address or 0 depending on sysctl kptr_restrict
+ * %pNF output a netdev_features_t
  * %*ph[CDN] a variable-length hex string with a separator (supports up to 64
  *           bytes of the input)
  * %n is ignored


