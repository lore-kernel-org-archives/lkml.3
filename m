Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab3AYTUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 14:20:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757481Ab3AYTUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 14:20:40 -0500
Date: Fri, 25 Jan 2013 14:19:17 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: aquini@redhat.com, walken@google.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, knoel@redhat.com, chegu_vinod@hp.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Subject: [PATCH -v4 5/5] x86,smp: limit spinlock delay on virtual machines
Message-ID: <20130125141917.6d5960a8@annuminas.surriel.com>
In-Reply-To: <20130125140553.060b8ced@annuminas.surriel.com>
References: <20130125140553.060b8ced@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modern Intel and AMD CPUs will trap to the host when the guest
is spinning on a spinlock, allowing the host to schedule in
something else.

This effectively means the host is taking care of spinlock
backoff for virtual machines. It also means that doing the
spinlock backoff in the guest anyway can lead to totally
unpredictable results, extremely large backoffs, and
performance regressions.

To prevent those problems, we limit the spinlock backoff
delay, when running in a virtual machine, to a small value.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/setup.c          |    2 ++
 arch/x86/kernel/smp.c            |   30 ++++++++++++++++++++++++------
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 888184b..a365f97 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -997,6 +997,8 @@ extern bool cpu_has_amd_erratum(const int *);
 extern unsigned long arch_align_stack(unsigned long sp);
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
+extern void init_spinlock_delay(void);
+
 void default_idle(void);
 bool set_pm_idle_to_default(void);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 23ddd55..b834eae 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1048,6 +1048,8 @@ void __init setup_arch(char **cmdline_p)
 
 	arch_init_ideal_nops();
 
+	init_spinlock_delay();
+
 	register_refined_jiffies(CLOCK_TICK_RATE);
 
 #ifdef CONFIG_EFI
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 1877890..b1a65f0 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -31,6 +31,7 @@
 #include <asm/proto.h>
 #include <asm/apic.h>
 #include <asm/nmi.h>
+#include <asm/hypervisor.h>
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
  *
@@ -114,6 +115,27 @@ static atomic_t stopping_cpu = ATOMIC_INIT(-1);
 static bool smp_no_nmi_ipi = false;
 
 /*
+ * Modern Intel and AMD CPUs tell the hypervisor when a guest is
+ * spinning excessively on a spinlock. The hypervisor will then
+ * schedule something else, effectively taking care of the backoff
+ * for us. Doing our own backoff on top of the hypervisor's pause
+ * loop exit handling can lead to excessively long delays, and
+ * performance degradations. Limit the spinlock delay in virtual
+ * machines to a smaller value.
+ */
+#define DELAY_SHIFT 8
+#define DELAY_FIXED_1 (1<<DELAY_SHIFT)
+#define MIN_SPINLOCK_DELAY (1 * DELAY_FIXED_1)
+#define MAX_SPINLOCK_DELAY_NATIVE (16000 * DELAY_FIXED_1)
+#define MAX_SPINLOCK_DELAY_GUEST (16 * DELAY_FIXED_1)
+static int __read_mostly max_spinlock_delay = MAX_SPINLOCK_DELAY_NATIVE;
+void __init init_spinlock_delay(void)
+{
+	if (x86_hyper)
+		max_spinlock_delay = MAX_SPINLOCK_DELAY_GUEST;
+}
+
+/*
  * Wait on a congested ticket spinlock. Many spinlocks are embedded in
  * data structures; having many CPUs pounce on the cache line with the
  * spinlock simultaneously can slow down the lock holder, and the system
@@ -131,10 +153,6 @@ static bool smp_no_nmi_ipi = false;
  * the queue, to slowly increase the delay if we sleep for too short a
  * time, and to decrease the delay if we slept for too long.
  */
-#define DELAY_SHIFT 8
-#define DELAY_FIXED_1 (1<<DELAY_SHIFT)
-#define MIN_SPINLOCK_DELAY (1 * DELAY_FIXED_1)
-#define MAX_SPINLOCK_DELAY (16000 * DELAY_FIXED_1)
 #define DELAY_HASH_SHIFT 6
 struct delay_entry {
 	u32 hash;
@@ -171,7 +189,7 @@ void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 		}
 
 		/* Aggressively increase delay, to minimize lock accesses. */
-		if (delay < MAX_SPINLOCK_DELAY)
+		if (delay < max_spinlock_delay)
 			delay += DELAY_FIXED_1 / 7;
 
 		loops = (delay * waiters_ahead) >> DELAY_SHIFT;
