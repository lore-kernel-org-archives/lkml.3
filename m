Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbaD3PEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:04:22 -0400
Received: from mail1.windriver.com ([147.11.146.13]:44713 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905AbaD3PEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:04:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH/RFC] Deprecate BUG/BUG_ON in favour of BUG_AND_HALT/BUG_AND_HALT_ON
Date: Wed, 30 Apr 2014 11:03:27 -0400
Message-ID: <1398870207-52889-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
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
here, we create BUG_AND_HALT variants, which leave no doubt as to
what they do in name alone.

Then we can incrementally move the real BUG users (unrecoverable
filesystem corruption, page table mangling, etc) onto BUG_AND_HALT,
and finally at some time in the future we'll simply make the old
BUG/BUG_ON be aliases for WARN/WARN_ON, once we've moved over the
bulk of the instances really needing to halt the system.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This might not be a unique idea; but I'm pretty sure I'd first
heard of it during a discussion with Ingo at RT summit last year.]

 include/asm-generic/bug.h | 16 ++++++++++++++++
 scripts/checkpatch.pl     |  7 +++++++
 2 files changed, 23 insertions(+)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 630dd2372238..57b79a394ceb 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -43,6 +43,14 @@ struct bug_entry {
  * If you're tempted to BUG(), think again:  is completely giving up
  * really the *only* solution?  There are usually better options, where
  * users don't need to reboot ASAP and can mostly shut down cleanly.
+ *
+ * Sadly nobody listens to the above, and trying to reclaim BUG/BUG_ON
+ * for their original intent is about as hopeful as wishing "selfie"
+ * wasn't headed for the OED.  So the plan is to avoid BUG/BUG_ON
+ * entirely.  Either use WARN/WARN_ON or BUG_AND_HALT/BUG_AND_HALT_ON.
+ * Once the critical (e.g. fs etc) BUG/BUG_ON users are updated to use
+ * the clearly named HALT variants, we can point the old BUG/BUG_ON
+ * defines below to be clones of the less drastic WARN variants.
  */
 #ifndef HAVE_ARCH_BUG
 #define BUG() do { \
@@ -51,10 +59,18 @@ struct bug_entry {
 } while (0)
 #endif
 
+#ifndef HAVE_ARCH_BUG_AND_HALT
+#define BUG_AND_HALT BUG
+#endif
+
 #ifndef HAVE_ARCH_BUG_ON
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
 #endif
 
+#ifndef HAVE_ARCH_BUG_AND_HALT_ON
+#define BUG_AND_HALT_ON BUG_ON
+#endif
+
 /*
  * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
  * significant issues that need prompt attention if they should ever
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 34eb2160489d..3cbf3591cf76 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2010,6 +2010,13 @@ sub process {
 			$rpt_cleaners = 1;
 		}
 
+# Dont use BUG/BUG_ON; use WARN/WARN_ON or BUG_AND_HALT/BUG_AND_HALT_ON
+		if ($rawline =~ /^\+.*BUG\(/ || $rawline =~ /^\+.*BUG_ON\(/) {
+			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
+			WARN("BUG/BUG_ON",
+			     "Use of BUG/BUG_ON is deprecated. Use WARN/WARN_ON or BUG_AND_HALT/BUG_AND_HALT_ON\n" . $herevet);
+		}
+
 # Check for FSF mailing addresses.
 		if ($rawline =~ /\bwrite to the Free/i ||
 		    $rawline =~ /\b59\s+Temple\s+Pl/i ||
-- 
1.9.0

