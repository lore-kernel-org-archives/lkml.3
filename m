Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaDRNLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:11:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39044 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbaDRNLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:11:36 -0400
Date: Fri, 18 Apr 2014 06:10:45 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-wotyeoj99h1dpojjeest2jbk@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        yasutake.koichi@jp.panasonic.com, paulmck@linux.vnet.ibm.com,
        dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        yasutake.koichi@jp.panasonic.com, paulmck@linux.vnet.ibm.com,
        dhowells@redhat.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,mn10300: Convert smp_mb__*()
Git-Commit-ID: 9424cdf0fc7f768f20daef77980da9617a76679b
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

Commit-ID:  9424cdf0fc7f768f20daef77980da9617a76679b
Gitweb:     http://git.kernel.org/tip/9424cdf0fc7f768f20daef77980da9617a76679b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:39 +0200

arch,mn10300: Convert smp_mb__*()

mn10300 fully relies on asm-generic/barrier.h and therefore its
smp_mb() is barrier(). We can use the default implementation.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-wotyeoj99h1dpojjeest2jbk@git.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-am33-list@redhat.com
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/mn10300/include/asm/atomic.h | 7 +------
 arch/mn10300/include/asm/bitops.h | 4 +---
 arch/mn10300/mm/tlb-smp.c         | 4 ++--
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/mn10300/include/asm/atomic.h b/arch/mn10300/include/asm/atomic.h
index 975e184..cadeb1e 100644
--- a/arch/mn10300/include/asm/atomic.h
+++ b/arch/mn10300/include/asm/atomic.h
@@ -13,6 +13,7 @@
 
 #include <asm/irqflags.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #ifndef CONFIG_SMP
 #include <asm-generic/atomic.h>
@@ -234,12 +235,6 @@ static inline void atomic_set_mask(unsigned long mask, unsigned long *addr)
 #endif
 }
 
-/* Atomic operations are already serializing on MN10300??? */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /* __KERNEL__ */
 #endif /* CONFIG_SMP */
 #endif /* _ASM_ATOMIC_H */
diff --git a/arch/mn10300/include/asm/bitops.h b/arch/mn10300/include/asm/bitops.h
index 596bb27..fe6f8e2 100644
--- a/arch/mn10300/include/asm/bitops.h
+++ b/arch/mn10300/include/asm/bitops.h
@@ -18,9 +18,7 @@
 #define __ASM_BITOPS_H
 
 #include <asm/cpu-regs.h>
-
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
+#include <asm/barrier.h>
 
 /*
  * set bit
diff --git a/arch/mn10300/mm/tlb-smp.c b/arch/mn10300/mm/tlb-smp.c
index 3e57faf..e5d0ef7 100644
--- a/arch/mn10300/mm/tlb-smp.c
+++ b/arch/mn10300/mm/tlb-smp.c
@@ -78,9 +78,9 @@ void smp_flush_tlb(void *unused)
 	else
 		local_flush_tlb_page(flush_mm, flush_va);
 
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	cpumask_clear_cpu(cpu_id, &flush_cpumask);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 out:
 	put_cpu();
 }
