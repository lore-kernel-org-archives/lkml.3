Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaKKLLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:11:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57955 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbaKKLLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 168/170] x86_64, entry: Fix out of bounds read on sysenter
Date: Tue, 11 Nov 2014 11:08:47 +0000
Message-Id: <1415704129-12709-169-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 653bc77af60911ead1f423e588f54fc2547c4957 upstream.

Rusty noticed a Really Bad Bug (tm) in my NT fix.  The entry code
reads out of bounds, causing the NT fix to be unreliable.  But, and
this is much, much worse, if your stack is somehow just below the
top of the direct map (or a hole), you read out of bounds and crash.

Excerpt from the crash:

[    1.129513] RSP: 0018:ffff88001da4bf88  EFLAGS: 00010296

  2b:*    f7 84 24 90 00 00 00     testl  $0x4000,0x90(%rsp)

That read is deterministically above the top of the stack.  I
thought I even single-stepped through this code when I wrote it to
check the offset, but I clearly screwed it up.

Fixes: 8c7aa698baca ("x86_64, entry: Filter RFLAGS.NT on entry from userspace")
Reported-by: Rusty Russell <rusty@ozlabs.org>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/ia32/ia32entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 711de084ab57..92a2e9333620 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -157,7 +157,7 @@ ENTRY(ia32_sysenter_target)
 	 * ourselves.  To save a few cycles, we can check whether
 	 * NT was set instead of doing an unconditional popfq.
 	 */
-	testl $X86_EFLAGS_NT,EFLAGS(%rsp)	/* saved EFLAGS match cpu */
+	testl $X86_EFLAGS_NT,EFLAGS-ARGOFFSET(%rsp)
 	jnz sysenter_fix_flags
 sysenter_flags_fixed:
 
-- 
2.1.0

