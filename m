Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab3GEQ3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:29:42 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:54498 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412Ab3GEQ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:29:34 -0400
Subject: [PATCH 1/3] smp/ipi: Remove redundant cfd->cpumask_ipi mask
To: xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: npiggin@suse.de, deepthi@linux.vnet.ibm.com, peterz@infradead.org,
        rusty@rustcorp.com.au, heiko.carstens@de.ibm.com, udknight@gmail.com,
        rostedt@goodmis.org, miltonm@bga.com, srivatsa.bhat@linux.vnet.ibm.com,
        jens.axboe@oracle.com, tj@kernel.org, akpm@linux-foundation.org,
        svaidy@linux.vnet.ibm.com, shli@kernel.org, tglx@linutronix.de,
        lig.fnst@cn.fujitsu.com, anton@samba.org
Date: Fri, 05 Jul 2013 21:57:01 +0530
Message-ID: <20130705162701.16888.81171.stgit@preeti.in.ibm.com>
In-Reply-To: <20130705162548.16888.18957.stgit@preeti.in.ibm.com>
References: <20130705162548.16888.18957.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070516-9574-0000-0000-000008998DD0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfd->cpumask_ipi is used only in smp_call_function_many().The existing
comment around it says that this additional mask is used because
cfd->cpumask can get overwritten.

There is no reason why the cfd->cpumask can be overwritten, since this
is a per_cpu mask; nobody can change it but us and we are
called with preemption disabled.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: srivatsa.bhat@linux.vnet.ibm.com
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---

 kernel/smp.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 4dba0f7..89be6e6 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -23,7 +23,6 @@ enum {
 struct call_function_data {
 	struct call_single_data	__percpu *csd;
 	cpumask_var_t		cpumask;
-	cpumask_var_t		cpumask_ipi;
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
@@ -47,9 +46,6 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
 				cpu_to_node(cpu)))
 			return notifier_from_errno(-ENOMEM);
-		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
-				cpu_to_node(cpu)))
-			return notifier_from_errno(-ENOMEM);
 		cfd->csd = alloc_percpu(struct call_single_data);
 		if (!cfd->csd) {
 			free_cpumask_var(cfd->cpumask);
@@ -64,7 +60,6 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		free_cpumask_var(cfd->cpumask);
-		free_cpumask_var(cfd->cpumask_ipi);
 		free_percpu(cfd->csd);
 		break;
 #endif
@@ -410,13 +405,6 @@ void smp_call_function_many(const struct cpumask *mask,
 	if (unlikely(!cpumask_weight(cfd->cpumask)))
 		return;
 
-	/*
-	 * After we put an entry into the list, cfd->cpumask may be cleared
-	 * again when another CPU sends another IPI for a SMP function call, so
-	 * cfd->cpumask will be zero.
-	 */
-	cpumask_copy(cfd->cpumask_ipi, cfd->cpumask);
-
 	for_each_cpu(cpu, cfd->cpumask) {
 		struct call_single_data *csd = per_cpu_ptr(cfd->csd, cpu);
 		struct call_single_queue *dst =
@@ -433,7 +421,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	}
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(cfd->cpumask_ipi);
+	arch_send_call_function_ipi_mask(cfd->cpumask);
 
 	if (wait) {
 		for_each_cpu(cpu, cfd->cpumask) {

