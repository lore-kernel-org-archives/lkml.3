Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab3F0T7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:59:14 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57800 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab3F0T7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:59:10 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 17/45] tick-broadcast: Use get/put_online_cpus_atomic() to
 prevent CPU offline
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com,
        David.Laight@aculab.com
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, sbw@mit.edu, fweisbec@gmail.com,
        zhong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 28 Jun 2013 01:25:37 +0530
Message-ID: <20130627195536.29830.580.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130627195136.29830.10445.stgit@srivatsabhat.in.ibm.com>
References: <20130627195136.29830.10445.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062719-7014-0000-0000-0000033E2BC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once stop_machine() is gone from the CPU offline path, we won't be able
to depend on disabling preemption to prevent CPUs from going offline
from under us.

Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going
offline, while invoking from atomic context.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/time/tick-broadcast.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 9d96a54..1e4ac45 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -227,12 +227,14 @@ static void tick_do_broadcast(struct cpumask *mask)
  */
 static void tick_do_periodic_broadcast(void)
 {
+	get_online_cpus_atomic();
 	raw_spin_lock(&tick_broadcast_lock);
 
 	cpumask_and(tmpmask, cpu_online_mask, tick_broadcast_mask);
 	tick_do_broadcast(tmpmask);
 
 	raw_spin_unlock(&tick_broadcast_lock);
+	put_online_cpus_atomic();
 }
 
 /*
@@ -335,11 +337,13 @@ out:
  */
 void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 {
+	get_online_cpus_atomic();
 	if (!cpumask_test_cpu(*oncpu, cpu_online_mask))
 		printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
 		       "offline CPU #%d\n", *oncpu);
 	else
 		tick_do_broadcast_on_off(&reason);
+	put_online_cpus_atomic();
 }
 
 /*
@@ -505,6 +509,7 @@ static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 	ktime_t now, next_event;
 	int cpu, next_cpu = 0;
 
+	get_online_cpus_atomic();
 	raw_spin_lock(&tick_broadcast_lock);
 again:
 	dev->next_event.tv64 = KTIME_MAX;
@@ -562,6 +567,7 @@ again:
 			goto again;
 	}
 	raw_spin_unlock(&tick_broadcast_lock);
+	put_online_cpus_atomic();
 }
 
 /*
@@ -756,6 +762,7 @@ void tick_broadcast_switch_to_oneshot(void)
 	struct clock_event_device *bc;
 	unsigned long flags;
 
+	get_online_cpus_atomic();
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
@@ -764,6 +771,7 @@ void tick_broadcast_switch_to_oneshot(void)
 		tick_broadcast_setup_oneshot(bc);
 
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+	put_online_cpus_atomic();
 }
 
 

