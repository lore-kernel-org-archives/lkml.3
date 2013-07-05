Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab3GEQ3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:29:40 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35027 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab3GEQ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:29:38 -0400
Subject: [PATCH 2/3] smp/ipi:Clarify ambiguous comments around deadlock
 scenarios in smp_call_function variants.
To: xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: npiggin@suse.de, deepthi@linux.vnet.ibm.com, peterz@infradead.org,
        rusty@rustcorp.com.au, heiko.carstens@de.ibm.com, udknight@gmail.com,
        rostedt@goodmis.org, miltonm@bga.com, srivatsa.bhat@linux.vnet.ibm.com,
        jens.axboe@oracle.com, tj@kernel.org, akpm@linux-foundation.org,
        svaidy@linux.vnet.ibm.com, shli@kernel.org, tglx@linutronix.de,
        lig.fnst@cn.fujitsu.com, anton@samba.org
Date: Fri, 05 Jul 2013 21:57:11 +0530
Message-ID: <20130705162711.16888.30274.stgit@preeti.in.ibm.com>
In-Reply-To: <20130705162548.16888.18957.stgit@preeti.in.ibm.com>
References: <20130705162548.16888.18957.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070516-5816-0000-0000-000008C8DCD8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elaborate on when deadlocks can occur when a call is made to
smp_call_function_single() and its friends. This avoids ambiguity about
when to use these calls.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: srivatsa.bhat@linux.vnet.ibm.com
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au
---

 kernel/smp.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 89be6e6..b6981ae 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -230,7 +230,23 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 	this_cpu = get_cpu();
 
 	/*
-	 * Can deadlock when called with interrupts disabled.
+	 * Can deadlock when called with interrupts disabled under two
+	 * different circumstances depending on the wait parameter.
+	 *
+	 * 1. wait = 1: Two CPUs execute smp_call_function_single(), send an
+	 * IPI to each other, and wait for func to finish on each other.
+	 * Since they are interrupt disabled, neither receives this IPI,
+	 * nor do they proceed forward,as they wait for each other to complete
+	 * execution of func.
+	 *
+	 * 2. wait = 0: This function could be called from an interrupt
+	 * context, and can get blocked on the csd_lock(csd) below in
+	 * "non wait cases".
+	 * This is because the percpu copy of csd of this_cpu is used
+	 * in non wait cases. Under such circumstances, if the previous caller
+	 * of this function who got preempted by this interrupt has already taken
+	 * the lock under non wait condition, it will result in deadlock.
+	 *
 	 * We allow cpu's that are not yet online though, as no one else can
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
@@ -329,6 +345,16 @@ void __smp_call_function_single(int cpu, struct call_single_data *csd,
 	this_cpu = get_cpu();
 	/*
 	 * Can deadlock when called with interrupts disabled.
+	 * 1. wait = 1: Two CPUs execute smp_call_function_single(), send an
+	 * IPI to each other, and wait for func to finish on each other.
+	 * Since they are interrupt disabled, neither receives this IPI,
+	 * nor do they proceed forward,as they wait for each other to complete
+	 * execution of func.
+	 *
+	 * 2. wait = 0:  A scenario similar to smp_call_function_single()
+	 * does not happen here, because each caller of
+	 * __smp_call_function_single() passes unique copies of csd.
+	 *
 	 * We allow cpu's that are not yet online though, as no one else can
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
@@ -368,7 +394,23 @@ void smp_call_function_many(const struct cpumask *mask,
 	int cpu, next_cpu, this_cpu = smp_processor_id();
 
 	/*
-	 * Can deadlock when called with interrupts disabled.
+	 * Can deadlock when called with interrupts disabled under two
+	 * different circumstances depending on the wait parameter.
+	 *
+	 * 1. wait = 1: Two CPUs execute smp_call_function_single(), send an
+	 * IPI to each other, and wait for func to finish on each other.
+	 * Since they are interrupt disabled, neither receives this IPI,
+	 * nor do they proceed forward,as they wait for each other to complete
+	 * execution of func.
+	 *
+	 * 2. wait = 0: This function could be called from an interrupt
+	 * context, and can get blocked on the csd_lock(csd) below in
+	 * "non wait cases".
+	 * This is because the percpu copy of csd of this_cpu is used
+	 * in non wait cases. Under such circumstances, if the previous caller
+	 * of this function who got preempted by this interrupt has already taken
+	 * the lock under non wait condition, it will result in deadlock.
+	 *
 	 * We allow cpu's that are not yet online though, as no one else can
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.

