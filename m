Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab3IMOiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:38:10 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:34836 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755584Ab3IMOiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:38:08 -0400
Date: Fri, 13 Sep 2013 14:25:40 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
In-Reply-To: <20130913140422.GE4844@somewhere>
Message-ID: <0000014117b686ee-ee202f80-9803-495b-a638-e487e8983443-000000@email.amazonses.com>
References: <000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com> <20130912141625.GA23357@somewhere> <00000141128d759a-44dcacb6-8f48-4f9b-8381-d14003bd6da1-000000@email.amazonses.com> <20130912143137.GA23839@somewhere>
 <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com> <20130912151102.GB23839@somewhere> <alpine.DEB.2.02.1309121030390.21473@gentwo.org> <0000014112d66287-d0abaeb1-71ff-48a0-8740-f984d47400a7-000000@email.amazonses.com>
 <20130912183023.GA25386@somewhere> <00000141179222e5-8a10141c-7b95-4204-853c-ab266fd08532-000000@email.amazonses.com> <20130913140422.GE4844@somewhere>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.13-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Sep 2013, Frederic Weisbecker wrote:

> Indeed, I just looked that again and your cpu_kthread_mask actually also applies to init.
> cpu_init_mask would be a better name I think.

Yea the naming is iffy. I want to get a general direction on how to are
going to address these issues before putting more work into it. Any ideas
on how to do this in a nice way that makes it easy for everyone involved
would be appreciated.

There is a second stage to this which comes with NUMA systems. In that
case we need to have at least one processor reserved for the OS to do
reclaim and stuff like that. That is why I also posted the following patch
that amends some things. Not tested just an idea how to address these
issues. And it also does not do the placement of kswapd and other MM
specific threads yet.



Subject: Simple autoconfig for tickless system

This is on top of the prior patch that restricts the cpus that
kthread can spawn processes on.

It ensures that one processor per node is kept in regular
HZ mode and also adds that cpu to the kthread_mask so that
OS services (like kswapd etc) can run.

On a two node system two processors will be available for kthread and OS services.
The rest will be tickless and kept as free from OS services as possible.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c	2013-09-05 09:10:59.000000000 -0500
+++ linux/kernel/time/tick-sched.c	2013-09-11 11:46:59.387888072 -0500
@@ -330,7 +330,30 @@ static int tick_nohz_init_all(void)
 	}
 	err = 0;
 	cpumask_setall(tick_nohz_full_mask);
+
+	/* Exempt boot processor and use it for OS services */
 	cpumask_clear_cpu(smp_processor_id(), tick_nohz_full_mask);
+	cpumask_set(smp_processor_id(), cpumask_kthread_mask);
+
+	/* And one processor for each NUMA node */
+	for_each_node(node) {
+		struct cpumask *m = cpumask_of_node(node);
+
+		/* Boot node ? */
+		if (node == numa_node_id())
+			continue;
+
+		/*
+		 * Exempt the first processor on each node that has
+		 * processors available.
+		 */
+		if (cpumask_weight(m)) {
+			int cpu = cpumask_first(m);
+
+			cpumask_clear_cpu(cpu, tick_nohz_full_mask);
+			cpumask_set(cpu, cpu_kthread_mask);
+		}
+	}
 	tick_nohz_full_running = true;
 #endif
 	return err;
Index: linux/kernel/cpu.c
===================================================================
--- linux.orig/kernel/cpu.c	2013-09-11 10:45:47.686052132 -0500
+++ linux/kernel/cpu.c	2013-09-11 11:49:34.122210075 -0500
@@ -682,12 +682,14 @@ static DECLARE_BITMAP(cpu_kthread_bits,
 const struct cpumask *const cpu_kthread_mask = to_cpumask(cpu_kthread_bits);
 EXPORT_SYMBOL(cpu_kthread_mask);

+#ifndef CONFIG_NO_HZ_FULL_ALL
 static int __init kthread_setup(char *str)
 {
         cpulist_parse(str, (struct cpumask *)&cpu_kthread_bits);
         return 1;
 }
 __setup("kthread=", kthread_setup);
+#endif


 void set_cpu_possible(unsigned int cpu, bool possible)

