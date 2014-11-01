Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbaKABIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 21:08:52 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:55066 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaKABIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 21:08:51 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Sebastian Lackner <sebastian@fds-team.de>,
        Anish Bhatt <anish@chelsio.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>, stable@vger.kernel.org
Subject: [PATCH] x86_64, entry: Fix out of bounds read on sysenter
Date: Fri, 31 Oct 2014 18:08:45 -0700
Message-Id: <a27467328f7607b4f45a6c37e731c1f3e047f4a7.1414803784.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <CALCETrWJ4-PaLpceb7NCm6pKgkNXh77x1F6XHHxafcvBRFAoxg@mail.gmail.com>
References: <CALCETrWJ4-PaLpceb7NCm6pKgkNXh77x1F6XHHxafcvBRFAoxg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Fixes 8c7aa698baca x86_64, entry: Filter RFLAGS.NT on entry from userspace

Reported-by: Rusty Russell <rusty@ozlabs.org>
Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Linus, etc: this should probably go in pretty quickly before it hits -stable
too hard.  Fortunately it's unlikely to be a meaningful security problem,
but it's a nasty regression.  (It *is* a security problem in -next, but we
get a free pass on that one.)

 arch/x86/ia32/ia32entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 8ffba18395c8..ffe71228fc10 100644
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
1.9.3

