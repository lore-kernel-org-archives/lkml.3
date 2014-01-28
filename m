Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaA1NWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 08:22:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaA1NWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 08:22:38 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>, Gong Chen <gong.chen@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Fengguang Wu <fengguang.wu@Intel.com>, yinghai@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com
Subject: [PATCH] x86, cpu hotplug, Fix stack frame warning in check_irq_vectors_for_cpu_disable()
Date: Tue, 28 Jan 2014 08:22:11 -0500
Message-Id: <1390915331-27375-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further discussion here: http://marc.info/?l=linux-kernel&m=139073901101034&w=2

kbuild, 0day kernel build service, outputs the warning:

arch/x86/kernel/irq.c:333:1: warning: the frame size of 2056 bytes
is larger than 2048 bytes [-Wframe-larger-than=]

because check_irq_vectors_for_cpu_disable() allocates two cpumasks on the
stack.   Fix this by moving the two cpumasks to a global file context.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Yang Zhang <yang.z.zhang@Intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Janet Morgan <janet.morgan@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ruiv Wang <ruiv.wang@gmail.com>
Cc: Gong Chen <gong.chen@linux.intel.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Gong Chen <gong.chen@linux.intel.com>
Cc: x86@kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: yinghai@kernel.org
Cc: tglx@linutronix.de
Cc: mingo@elte.hu
Cc: hpa@zytor.com
---
 arch/x86/kernel/irq.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 4207e8d..3910078 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -262,6 +262,14 @@ __visible void smp_trace_x86_platform_ipi(struct pt_regs *regs)
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
 
 #ifdef CONFIG_HOTPLUG_CPU
+
+/* These two declarations are only used in check_irq_vectors_for_cpu_disable()
+ * below, which is protected by stop_machine().  Putting them on the stack
+ * results in a stack frame overflow.  Dynamically allocating could result in a
+ * failure so declare these two cpumasks as global.
+ */
+static struct cpumask affinity_new, online_new;
+
 /*
  * This cpu is going to be removed and its vectors migrated to the remaining
  * online cpus.  Check to see if there are enough vectors in the remaining cpus.
@@ -273,7 +281,6 @@ int check_irq_vectors_for_cpu_disable(void)
 	unsigned int this_cpu, vector, this_count, count;
 	struct irq_desc *desc;
 	struct irq_data *data;
-	struct cpumask affinity_new, online_new;
 
 	this_cpu = smp_processor_id();
 	cpumask_copy(&online_new, cpu_online_mask);
-- 
1.7.9.3

