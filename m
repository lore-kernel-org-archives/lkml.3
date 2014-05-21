Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaEUS6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:58:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:45225 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaEUS6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:58:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH v2] Deprecate BUG/BUG_ON in favour of CRASH/CRASH_ON
Date: Wed, 21 May 2014 14:57:52 -0400
Message-Id: <1400698672-29421-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A long standing problem for us has been the misuse of BUG/BUG_ON.
The typical misuse is someone only thinking of what represents
a bug in their local code, and especially for people relatively
new to Linux, starting out in device drivers, the appeal of using
BUG w/o knowing what it really does is too great.

So you end up with some trivial non system critical driver bringing
the whole system to a grinding halt just because it detected an
internal inconsistency.  That just makes users unhappy and looks bad.

It is hopeless to think we can reclaim BUG/BUG_ON for their original
intent, given there are currently ~20k instances.  To make progress
here, we create CRASH/CRASH_ON variants, which leave no doubt as to
what they do in name alone.

Then we can incrementally move the real BUG users (unrecoverable fs
corruption, page table mangling, etc) onto CRASH/CRASH_ON, and finally
at some time in the future we'll simply make the old BUG/BUG_ON be
aliases for WARN/WARN_ON, once we've moved over the bulk of the
instances really needing to halt the system.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[v2: "s/BUG_AND_HALT/CRASH/" as per Ingo's suggestion.]

 include/asm-generic/bug.h | 17 +++++++++++++++++
 scripts/checkpatch.pl     |  7 +++++++
 2 files changed, 24 insertions(+)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 630dd23..12c3ae5 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -43,6 +43,15 @@ struct bug_entry {
  * If you're tempted to BUG(), think again:  is completely giving up
  * really the *only* solution?  There are usually better options, where
  * users don't need to reboot ASAP and can mostly shut down cleanly.
+ *
+ * Sadly nobody listens to the above, and trying to reclaim BUG/BUG_ON
+ * for their original intent is about as hopeful as wishing "selfie"
+ * wasn't headed for the OED.  So the plan is to avoid BUG/BUG_ON
+ * entirely.  Either use WARN/WARN_ON or CRASH/CRASH_ON.
+ *
+ * Once the critical (e.g. fs etc) BUG/BUG_ON users are updated to use
+ * the clearly named CRASH variants, we can point the old BUG/BUG_ON
+ * defines below to be aliases of the less drastic WARN variants.
  */
 #ifndef HAVE_ARCH_BUG
 #define BUG() do { \
@@ -51,10 +60,18 @@ struct bug_entry {
 } while (0)
 #endif
 
+#ifndef HAVE_ARCH_CRASH
+#define CRASH BUG
+#endif
+
 #ifndef HAVE_ARCH_BUG_ON
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
 #endif
 
+#ifndef HAVE_ARCH_CRASH_ON
+#define CRASH_ON BUG_ON
+#endif
+
 /*
  * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
  * significant issues that need prompt attention if they should ever
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 33eb71f..2970481 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2028,6 +2028,13 @@ sub process {
 			$rpt_cleaners = 1;
 		}
 
+# Dont use BUG/BUG_ON; use WARN/WARN_ON or CRASH/CRASH_ON
+		if ($rawline =~ /^\+.*BUG\(/ || $rawline =~ /^\+.*BUG_ON\(/) {
+			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
+			WARN("BUG/BUG_ON",
+			     "Use of BUG/BUG_ON is deprecated. Use WARN/WARN_ON or CRASH/CRASH_ON\n" . $herevet);
+		}
+
 # Check for FSF mailing addresses.
 		if ($rawline =~ /\bwrite to the Free/i ||
 		    $rawline =~ /\b59\s+Temple\s+Pl/i ||
-- 
1.8.2.3

