Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab3AVHrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:47:09 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37348 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab3AVHrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:47:04 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v5 43/45] cpu: No more __stop_machine() in _cpu_down()
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, rjw@sisk.pl, sbw@mit.edu,
        fweisbec@gmail.com, linux@arm.linux.org.uk, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2013 13:14:58 +0530
Message-ID: <20130122074454.13822.21675.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com>
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012207-1618-0000-0000-0000033A4023
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The _cpu_down() function invoked as part of the CPU-hotplug offlining
process currently invokes __stop_machine(), which is slow and inflicts
substantial real-time latencies on the entire system.  This patch
substitutes stop_one_cpu() for __stop_machine() in order to improve
both performance and real-time latency.

There were a number of uses of preempt_disable() or local_irq_disable()
that were intended to block CPU-hotplug offlining. These were fixed by
using get/put_online_cpus_atomic(), which is the new synchronization
primitive to prevent CPU offline, while invoking from atomic context.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
[ srivatsa.bhat@linux.vnet.ibm.com: Refer to the new sync primitives for
  readers (in the changelog); s/stop_cpus/stop_one_cpu and fix comment
  referring to stop_machine in the code]
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/cpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 1c84138..7a51fb6 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -337,7 +337,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	}
 	smpboot_park_threads(cpu);
 
-	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
+	err = stop_one_cpu(cpu, take_cpu_down, &tcd_param);
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		smpboot_unpark_threads(cpu);
@@ -349,7 +349,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	/*
 	 * The migration_call() CPU_DYING callback will have removed all
 	 * runnable tasks from the cpu, there's only the idle task left now
-	 * that the migration thread is done doing the stop_machine thing.
+	 * that the migration thread is done doing the stop_one_cpu() thing.
 	 *
 	 * Wait for the stop thread to go away.
 	 */

