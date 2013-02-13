Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992Ab3BMMMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:12:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36616 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933905Ab3BMMMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:12:20 -0500
Date: Wed, 13 Feb 2013 04:10:53 -0800
From: tip-bot for Rik van Riel <riel@redhat.com>
Message-ID: <tip-12b682864a336d72bfd507244649bd1066d90e43@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, riel@redhat.com,
        raghavendra.kt@linux.vnet.ibm.com, akpm@linux-foundation.org,
        chegu_vinod@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        raghavendra.kt@linux.vnet.ibm.com, akpm@linux-foundation.org,
        chegu_vinod@hp.com, tglx@linutronix.de
In-Reply-To: <20130207162449.0292685a@cuia.bos.redhat.com>
References: <20130207162449.0292685a@cuia.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] x86/smp:
  Limit spinlock delay on virtual machines
Git-Commit-ID: 12b682864a336d72bfd507244649bd1066d90e43
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 13 Feb 2013 04:10:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12b682864a336d72bfd507244649bd1066d90e43
Gitweb:     http://git.kernel.org/tip/12b682864a336d72bfd507244649bd1066d90e43
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Thu, 7 Feb 2013 16:24:49 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Feb 2013 09:07:21 +0100

x86/smp: Limit spinlock delay on virtual machines

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
Reviewed-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: aquini@redhat.com
Cc: eric.dumazet@gmail.com
Cc: lwoodman@redhat.com
Cc: knoel@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130207162449.0292685a@cuia.bos.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
---
 arch/x86/include/asm/processor.h |  2 ++
 arch/x86/kernel/cpu/hypervisor.c |  2 ++
 arch/x86/kernel/smp.c            | 21 +++++++++++++++++++--
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 888184b..2856972 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -158,9 +158,11 @@ extern __u32			cpu_caps_set[NCAPINTS];
 #ifdef CONFIG_SMP
 DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 #define cpu_data(cpu)		per_cpu(cpu_info, cpu)
+extern void init_guest_spinlock_delay(void);
 #else
 #define cpu_info		boot_cpu_data
 #define cpu_data(cpu)		boot_cpu_data
+static inline void init_guest_spinlock_delay(void) {}
 #endif
 
 extern const struct seq_operations cpuinfo_op;
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index a8f8fa9..4a53724 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -76,6 +76,8 @@ void __init init_hypervisor_platform(void)
 
 	init_hypervisor(&boot_cpu_data);
 
+	init_guest_spinlock_delay();
+
 	if (x86_hyper->init_platform)
 		x86_hyper->init_platform();
 }
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 8e94469..73be656 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -116,8 +116,25 @@ static bool smp_no_nmi_ipi = false;
 #define DELAY_SHIFT			8
 #define DELAY_FIXED_1			(1<<DELAY_SHIFT)
 #define MIN_SPINLOCK_DELAY		(1 * DELAY_FIXED_1)
-#define MAX_SPINLOCK_DELAY		(16000 * DELAY_FIXED_1)
+#define MAX_SPINLOCK_DELAY_NATIVE	(16000 * DELAY_FIXED_1)
+#define MAX_SPINLOCK_DELAY_GUEST	(16 * DELAY_FIXED_1)
 #define DELAY_HASH_SHIFT		6
+
+/*
+ * Modern Intel and AMD CPUs tell the hypervisor when a guest is
+ * spinning excessively on a spinlock. The hypervisor will then
+ * schedule something else, effectively taking care of the backoff
+ * for us. Doing our own backoff on top of the hypervisor's pause
+ * loop exit handling can lead to excessively long delays, and
+ * performance degradations. Limit the spinlock delay in virtual
+ * machines to a smaller value. Called from init_hypervisor_platform
+ */
+static int __read_mostly max_spinlock_delay = MAX_SPINLOCK_DELAY_NATIVE;
+void __init init_guest_spinlock_delay(void)
+{
+	max_spinlock_delay = MAX_SPINLOCK_DELAY_GUEST;
+}
+
 struct delay_entry {
 	u32 hash;
 	u32 delay;
@@ -171,7 +188,7 @@ void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 		}
 
 		/* Aggressively increase delay, to minimize lock accesses. */
-		if (delay < MAX_SPINLOCK_DELAY)
+		if (delay < max_spinlock_delay)
 			delay += DELAY_FIXED_1 / 7;
 
 		loops = (delay * waiters_ahead) >> DELAY_SHIFT;
