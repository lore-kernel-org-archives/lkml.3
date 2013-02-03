Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3BCO6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:58:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34515 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479Ab3BCO5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:53 -0500
Message-Id: <20130203144652.889299448@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Wang YanQing <udknight@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <jbeulich@suse.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 100/128] smp: Fix SMP function call empty cpu mask race
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang YanQing <udknight@gmail.com>

commit f44310b98ddb7f0d06550d73ed67df5865e3eda5 upstream.

I get the following warning every day with v3.7, once or
twice a day:

  [ 2235.186027] WARNING: at /mnt/sda7/kernel/linux/arch/x86/kernel/apic/ipi.c:109 default_send_IPI_mask_logical+0x2f/0xb8()

As explained by Linus as well:

 |
 | Once we've done the "list_add_rcu()" to add it to the
 | queue, we can have (another) IPI to the target CPU that can
 | now see it and clear the mask.
 |
 | So by the time we get to actually send the IPI, the mask might
 | have been cleared by another IPI.
 |

This patch also fixes a system hang problem, if the data->cpumask
gets cleared after passing this point:

        if (WARN_ONCE(!mask, "empty IPI mask"))
                return;

then the problem in commit 83d349f35e1a ("x86: don't send an IPI to
the empty set of CPU's") will happen again.

Signed-off-by: Wang YanQing <udknight@gmail.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Jan Beulich <jbeulich@suse.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: peterz@infradead.org
Cc: mina86@mina86.org
Cc: srivatsa.bhat@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/20130126075357.GA3205@udknight
[ Tidied up the changelog and the comment in the code. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/smp.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 29dd40a..69f38bd 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -33,6 +33,7 @@ struct call_function_data {
 	struct call_single_data	csd;
 	atomic_t		refs;
 	cpumask_var_t		cpumask;
+	cpumask_var_t		cpumask_ipi;
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
@@ -56,6 +57,9 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
 				cpu_to_node(cpu)))
 			return notifier_from_errno(-ENOMEM);
+		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
+				cpu_to_node(cpu)))
+			return notifier_from_errno(-ENOMEM);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -65,6 +69,7 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		free_cpumask_var(cfd->cpumask);
+		free_cpumask_var(cfd->cpumask_ipi);
 		break;
 #endif
 	};
@@ -526,6 +531,12 @@ void smp_call_function_many(const struct cpumask *mask,
 		return;
 	}
 
+	/*
+	 * After we put an entry into the list, data->cpumask
+	 * may be cleared again when another CPU sends another IPI for
+	 * a SMP function call, so data->cpumask will be zero.
+	 */
+	cpumask_copy(data->cpumask_ipi, data->cpumask);
 	raw_spin_lock_irqsave(&call_function.lock, flags);
 	/*
 	 * Place entry at the _HEAD_ of the list, so that any cpu still
@@ -549,7 +560,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	smp_mb();
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(data->cpumask);
+	arch_send_call_function_ipi_mask(data->cpumask_ipi);
 
 	/* Optionally wait for the CPUs to complete */
 	if (wait)


