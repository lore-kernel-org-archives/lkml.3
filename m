Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab3IKQ4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:56:06 -0400
Received: from a10-13.smtp-out.amazonses.com ([54.240.10.13]:33717 "EHLO
	a10-13.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754075Ab3IKQ4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:56:04 -0400
Date: Wed, 11 Sep 2013 16:56:02 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mike Galbraith <bitbucket@online.de>
cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
In-Reply-To: <1378911206.5476.134.camel@marge.simpson.net>
Message-ID: <000001410df378f7-b779c67a-a733-48b9-9e2a-cde27ac449cf-000000@email.amazonses.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com> <CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com> <1378795659.6046.41.camel@marge.simpson.net> <CAOtvUMfhLQYK95uPm8idG_vYv-9yG2-KSkScjMBCSuvtffW1Dg@mail.gmail.com>
 <1378797995.6046.54.camel@marge.simpson.net> <CAOtvUMdRmDYP_e7eFX1akU8vZ=dcVOnFDrBjKufumOaBxxXF3A@mail.gmail.com> <0000014109b5ec0e-ca64a736-ce4a-4be2-abf6-bbf2c1c15f80-000000@email.amazonses.com> <1378869632.5476.34.camel@marge.simpson.net>
 <000001410d659f85-21128fa5-a252-4006-804c-4ff03acbd50f-000000@email.amazonses.com> <1378911206.5476.134.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.11-54.240.10.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a draft of a patch to do autoconfig if CONFIG_NO_HZ_FULL_ALL is
set.


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
