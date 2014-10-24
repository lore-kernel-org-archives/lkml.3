Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbaJXW6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:58:43 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36297 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623AbaJXW6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:58:36 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vince Weaver <vince@deater.net>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 4/8] x86: Add a comment clarifying LDT context switching
Date: Fri, 24 Oct 2014 15:58:09 -0700
Message-Id: <0db86397f968996fb772c443c251415b0b430ddd.1414190806.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1414190806.git.luto@amacapital.net>
References: <cover.1414190806.git.luto@amacapital.net>
In-Reply-To: <cover.1414190806.git.luto@amacapital.net>
References: <cover.1414190806.git.luto@amacapital.net>
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
 arch/x86/include/asm/mmu_context.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 166af2a8e865..23697f74b372 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -53,7 +53,18 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		/* Stop flush ipis for the previous mm */
 		cpumask_clear_cpu(cpu, mm_cpumask(prev));
 
-		/* Load the LDT, if the LDT is different: */
+		/*
+		 * Load the LDT, if the LDT is different.
+		 *
+		 * It's possible that prev->context.ldt doesn't match
+		 * the LDT register.  This can happen if leave_mm(prev)
+		 * was called and then modify_ldt changed
+		 * prev->context.ldt but suppressed an IPI to this CPU.
+		 * In this case, prev->context.ldt != NULL, because we
+		 * never free an LDT while the mm still exists.  That
+		 * means that next->context.ldt != prev->context.ldt,
+		 * because mms never share an LDT.
+		 */
 		if (unlikely(prev->context.ldt != next->context.ldt))
 			load_LDT_nolock(&next->context);
 	}
-- 
1.9.3

