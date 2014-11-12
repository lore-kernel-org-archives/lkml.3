Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965833AbaKLBuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:50:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965815AbaKLBuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:50:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rusty Russell <rusty@ozlabs.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 022/123] x86_64, entry: Fix out of bounds read on sysenter
Date: Wed, 12 Nov 2014 10:16:28 +0900
Message-Id: <20141112011720.022235687@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/ia32/ia32entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
 


