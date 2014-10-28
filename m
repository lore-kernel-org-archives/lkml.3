Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbaJ1LOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:14:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51357 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaJ1LOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:14:30 -0400
Date: Tue, 28 Oct 2014 04:14:18 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-c4a7bba29bc6d9fcd5842d712b6b3d493b682b17@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com
Reply-To: luto@amacapital.net, linux-kernel@vger.kernel.org, hpa@zytor.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, mingo@kernel.org
In-Reply-To: <36275c99801a87d8dcf0502a41cf4e2ad81aae46.1412623954.git.luto@amacapital.net>
References: <36275c99801a87d8dcf0502a41cf4e2ad81aae46.1412623954.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] sched/x86:
  Add a comment clarifying LDT context switching
Git-Commit-ID: c4a7bba29bc6d9fcd5842d712b6b3d493b682b17
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4a7bba29bc6d9fcd5842d712b6b3d493b682b17
Gitweb:     http://git.kernel.org/tip/c4a7bba29bc6d9fcd5842d712b6b3d493b682b17
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Mon, 6 Oct 2014 12:36:47 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 11:11:57 +0100

sched/x86: Add a comment clarifying LDT context switching

The code is correct, but only for a rather subtle reason.  This
confused me for quite a while when I read switch_mm, so clarify
the code to avoid confusing other people, too.

TBH, I wouldn't be surprised if this code was only correct by
accident.

[ I wouldn't normally send a comment-only patch, but it took me a long
  time to first figure out wtf was going on here, and then to figure
  out why this wasn't exploitable by malicious code, and then to
  figure out why this oddity had no user-visible effect at all.  Let's
  spare future readers the same confusion. ]

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/36275c99801a87d8dcf0502a41cf4e2ad81aae46.1412623954.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/mmu_context.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 166af2a..0447810 100644
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
