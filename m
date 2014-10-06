Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaJFTgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:36:54 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54157 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaJFTgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:36:53 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86: Add a comment clarifying LDT context switching
Date: Mon,  6 Oct 2014 12:36:47 -0700
Message-Id: <36275c99801a87d8dcf0502a41cf4e2ad81aae46.1412623954.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code is correct, but only for a rather subtle reason.  This
confused me for quite a while when I read switch_mm, so clarify the
code to avoid confusing other people, too.

TBH, I wouldn't be surprised if this code was only correct by
accident.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

I wouldn't normally send a comment-only patch, but it took me a long
time to first figure out wtf was going on here, and then to figure
out why this wasn't exploitable by malicious code, and then to
figure out why this oddity had no user-visible effect at all.  Let's
spare future readers the same confusion.

 arch/x86/include/asm/mmu_context.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 166af2a8e865..04478103df37 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -53,7 +53,16 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		/* Stop flush ipis for the previous mm */
 		cpumask_clear_cpu(cpu, mm_cpumask(prev));
 
-		/* Load the LDT, if the LDT is different: */
+		/*
+		 * Load the LDT, if the LDT is different.
+		 *
+		 * It's possible leave_mm(prev) has been called.  If so,
+		 * then prev->context.ldt could be out of sync with the
+		 * LDT descriptor or the LDT register.  This can only happen
+		 * if prev->context.ldt is non-null, since we never free
+		 * an LDT.  But LDTs can't be shared across mms, so
+		 * prev->context.ldt won't be equal to next->context.ldt.
+		 */
 		if (unlikely(prev->context.ldt != next->context.ldt))
 			load_LDT_nolock(&next->context);
 	}
-- 
1.9.3

