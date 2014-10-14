Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbaJNW56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:57:58 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:47004 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbaJNW5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:57:55 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 3/5] x86: Add a comment clarifying LDT context switching
Date: Tue, 14 Oct 2014 15:57:37 -0700
Message-Id: <93ffc13d9e829f3ded9776fec62385bccb7439e1.1413323612.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1413323611.git.luto@amacapital.net>
References: <cover.1413323611.git.luto@amacapital.net>
In-Reply-To: <cover.1413323611.git.luto@amacapital.net>
References: <cover.1413323611.git.luto@amacapital.net>
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

