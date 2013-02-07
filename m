Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462Ab3BGVZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:25:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759319Ab3BGVZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:25:24 -0500
Date: Thu, 7 Feb 2013 16:24:49 -0500
From: Rik van Riel <riel@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, knoel@redhat.com, chegu_vinod@hp.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Subject: [PATCH fix -v5 5/5] x86,smp: limit spinlock delay on virtual
 machines
Message-ID: <20130207162449.0292685a@cuia.bos.redhat.com>
In-Reply-To: <20130207111147.GE8945@gmail.com>
References: <20130206150311.19cd1e52@cuia.bos.redhat.com>
	<20130206150748.486d7bf8@cuia.bos.redhat.com>
	<20130207111147.GE8945@gmail.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The kernel build will be sad on !SMP configs.

Good catch, thank you. Here is a new version.

---8<---

Subject: x86,smp: limit spinlock delay on virtual machines

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
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/cpu/hypervisor.c |    2 ++
 arch/x86/kernel/smp.c            |   21 +++++++++++++++++++--
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
index 8e94469..4965399 100644
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
