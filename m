Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab3JKFZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:25:46 -0400
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:43430 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751862Ab3JKFZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:25:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:355:379:421:541:800:960:973:988:989:1260:1345:1437:1534:1544:1605:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2904:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:4250:4321:4605:5007:6119:6261:7875:8603:10004:10026:10848:11026:11232:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13200:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fork53_14bb991de052d
X-Filterd-Recvd-Size: 4863
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ryan Mallon <rmallon@gmail.com>, Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] vsprintf/sysctl: Bugfix, neaten and document %pK usages
Date: Thu, 10 Oct 2013 22:25:39 -0700
Message-Id: <0aef7497929fd764a88ca7b3c22f082a5c2fe909.1381468961.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Printing kernel pointers via %pK has a minor defect when
kptr_restrict is set to 2:  the pointer may be emitted
as "pK-error" instead of all 0's when in an interrupt.

Fix this defect, neaten the code, and correct the sysctl
documentation.

Add missing documentation for 2 other uses: %pNF and %pV.

Trivially reduces vsprintf.o object size:

$ size lib/vsprintf.o*
   text	   data	    bss	    dec	    hex	filename
  14536	      6	      0	  14542	   38ce	lib/vsprintf.o.new
  14568	      6	      0	  14574	   38ee	lib/vsprintf.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 Documentation/sysctl/kernel.txt | 17 +++++++++--------
 lib/vsprintf.c                  | 38 ++++++++++++++++++++++++--------------
 2 files changed, 33 insertions(+), 22 deletions(-)

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
index 26559bd..ce55f52 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1301,21 +1301,28 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
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
-		}
-		if (!((kptr_restrict == 0) ||
-		      (kptr_restrict == 1 &&
-		       has_capability_noaudit(current, CAP_SYSLOG))))
+	case 'K':		/* see: Documentation/sysctl/kernel.txt */
+		switch (kptr_restrict) {
+		case 0:			/* None (default) */
+			break;
+		case 1:			/* Restricted */
+			if (in_irq() || in_serving_softirq() || in_nmi()) {
+				/*
+				 * This cannot be used in IRQ context because
+				 * the test for CAP_SYSLOG would be meaningless
+				 */
+				if (spec.field_width == -1)
+					spec.field_width = default_width;
+				return string(buf, end, "pK-error", spec);
+			}
+			if (!has_capability_noaudit(current, CAP_SYSLOG))
+				ptr = NULL;
+			break;
+		case 2:			/* Never - Always emit 0 */
+		default:
 			ptr = NULL;
+			break;
+		}
 		break;
 	case 'N':
 		switch (fmt[1]) {
@@ -1574,6 +1581,9 @@ qualifier:
  * %piS depending on sa_family of 'struct sockaddr *' print IPv4/IPv6 address
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
+ * %pV recurse and output a struct va_format (const char *fmt, va_list *)
+ * %pK output a kernel address or 0 depending on sysctl kptr_restrict
+ * %NF output a netdev_features_t
  * %*ph[CDN] a variable-length hex string with a separator (supports up to 64
  *           bytes of the input)
  * %n is ignored
-- 
1.8.1.2.459.gbcd45b4.dirty

