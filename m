Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaKFXDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:03:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58868 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaKFWm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:28 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 160/162] x86_64, entry: Fix out of bounds read on sysenter
Date: Thu,  6 Nov 2014 14:37:04 -0800
Message-Id: <1415313426-9622-161-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/ia32/ia32entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 711de08..92a2e93 100644
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
1.9.1

