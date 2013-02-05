Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab3BEVtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:49:36 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:57835 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab3BEVtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:49:32 -0500
Subject: [PATCH 2/4] Expand the steal time msr to also contain the consigned
 time.
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mtosatti@redhat.com, glommer@parallels.com,
        mingo@redhat.com, anthony@codemonkey.ws
Date: Tue, 05 Feb 2013 15:49:20 -0600
Message-ID: <20130205214920.4615.29831.stgit@lambeau>
In-Reply-To: <20130205214818.4615.12937.stgit@lambeau>
References: <20130205214818.4615.12937.stgit@lambeau>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020521-8878-0000-0000-000005CB5B55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand the steal time msr to also contain the consigned time.

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
---
 arch/x86/include/asm/paravirt.h       |    4 ++--
 arch/x86/include/asm/paravirt_types.h |    2 +-
 arch/x86/kernel/kvm.c                 |    7 ++-----
 kernel/sched/core.c                   |   10 +++++++++-
 kernel/sched/cputime.c                |    2 +-
 5 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 5edd174..9b753ea 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -196,9 +196,9 @@ struct static_key;
 extern struct static_key paravirt_steal_enabled;
 extern struct static_key paravirt_steal_rq_enabled;
 
-static inline u64 paravirt_steal_clock(int cpu)
+static inline void paravirt_steal_clock(int cpu, u64 *steal)
 {
-	return PVOP_CALL1(u64, pv_time_ops.steal_clock, cpu);
+	PVOP_VCALL2(pv_time_ops.steal_clock, cpu, steal);
 }
 
 static inline unsigned long long paravirt_read_pmc(int counter)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 142236e..5d4fc8b 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -95,7 +95,7 @@ struct pv_lazy_ops {
 
 struct pv_time_ops {
 	unsigned long long (*sched_clock)(void);
-	unsigned long long (*steal_clock)(int cpu);
+	void (*steal_clock)(int cpu, unsigned long long *steal);
 	unsigned long (*get_tsc_khz)(void);
 };
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index fe75a28..89e5468 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -386,9 +386,8 @@ static struct notifier_block kvm_pv_reboot_nb = {
 	.notifier_call = kvm_pv_reboot_notify,
 };
 
-static u64 kvm_steal_clock(int cpu)
+static void kvm_steal_clock(int cpu, u64 *steal)
 {
-	u64 steal;
 	struct kvm_steal_time *src;
 	int version;
 
@@ -396,11 +395,9 @@ static u64 kvm_steal_clock(int cpu)
 	do {
 		version = src->version;
 		rmb();
-		steal = src->steal;
+		*steal = src->steal;
 		rmb();
 	} while ((version & 1) || (version != src->version));
-
-	return steal;
 }
 
 void kvm_disable_steal_time(void)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..efc2652 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -757,6 +757,7 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
  */
 #if defined(CONFIG_IRQ_TIME_ACCOUNTING) || defined(CONFIG_PARAVIRT_TIME_ACCOUNTING)
 	s64 steal = 0, irq_delta = 0;
+	u64 consigned = 0;
 #endif
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 	irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
@@ -785,8 +786,15 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
 	if (static_key_false((&paravirt_steal_rq_enabled))) {
 		u64 st;
+		u64 cs;
 
-		steal = paravirt_steal_clock(cpu_of(rq));
+		paravirt_steal_clock(cpu_of(rq), &steal, &consigned);
+		/*
+		 * since we are not assigning the steal time to cpustats
+		 * here, just combine the steal and consigned times to
+		 * do the rest of the calculations.
+		 */
+		steal += consigned;
 		steal -= rq->prev_steal_time_rq;
 
 		if (unlikely(steal > delta))
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 825a956..0b4f1ec 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -275,7 +275,7 @@ static __always_inline bool steal_account_process_tick(void)
 	if (static_key_false(&paravirt_steal_enabled)) {
 		u64 steal, st = 0;
 
-		steal = paravirt_steal_clock(smp_processor_id());
+		paravirt_steal_clock(smp_processor_id(), &steal);
 		steal -= this_rq()->prev_steal_time;
 
 		st = steal_ticks(steal);

