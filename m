Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaAaAnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:43:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37880 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaAaAnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:43:31 -0500
Date: Thu, 30 Jan 2014 16:42:39 -0800
From: tip-bot for Prarit Bhargava <tipbot@zytor.com>
Message-ID: <tip-39424e89d64661faa0a2e00c5ad1e6dbeebfa972@git.kernel.org>
Cc: mingo@kernel.org, seiji.aguchi@hds.com, tony.luck@intel.com,
        gong.chen@linux.intel.com, ruiv.wang@gmail.com, janet.morgan@intel.com,
        ak@linux.intel.com, tglx@linutronix.de, fengguang.wu@intel.com,
        rientjes@google.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, yang.z.zhang@intel.com, hpa@linux.intel.com,
        prarit@redhat.com, walken@google.com, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, seiji.aguchi@hds.com, tony.luck@intel.com,
        gong.chen@linux.intel.com, ruiv.wang@gmail.com, janet.morgan@intel.com,
        ak@linux.intel.com, tglx@linutronix.de, rientjes@google.com,
        fengguang.wu@intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, yang.z.zhang@intel.com, walken@google.com,
        hpa@linux.intel.com, prarit@redhat.com, paul.gortmaker@windriver.com
In-Reply-To: <1390915331-27375-1-git-send-email-prarit@redhat.com>
References: <1390915331-27375-1-git-send-email-prarit@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, cpu hotplug:
  Fix stack frame warning in check_irq_vectors_for_cpu_disable()
Git-Commit-ID: 39424e89d64661faa0a2e00c5ad1e6dbeebfa972
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 30 Jan 2014 16:42:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39424e89d64661faa0a2e00c5ad1e6dbeebfa972
Gitweb:     http://git.kernel.org/tip/39424e89d64661faa0a2e00c5ad1e6dbeebfa972
Author:     Prarit Bhargava <prarit@redhat.com>
AuthorDate: Tue, 28 Jan 2014 08:22:11 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 30 Jan 2014 16:40:13 -0800

x86, cpu hotplug: Fix stack frame warning in check_irq_vectors_for_cpu_disable()

Further discussion here: http://marc.info/?l=linux-kernel&m=139073901101034&w=2

kbuild, 0day kernel build service, outputs the warning:

arch/x86/kernel/irq.c:333:1: warning: the frame size of 2056 bytes
is larger than 2048 bytes [-Wframe-larger-than=]

because check_irq_vectors_for_cpu_disable() allocates two cpumasks on the
stack.   Fix this by moving the two cpumasks to a global file context.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1390915331-27375-1-git-send-email-prarit@redhat.com
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Yang Zhang <yang.z.zhang@Intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Janet Morgan <janet.morgan@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ruiv Wang <ruiv.wang@gmail.com>
Cc: Gong Chen <gong.chen@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/irq.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index dbb6087..d99f31d 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -266,6 +266,14 @@ __visible void smp_trace_x86_platform_ipi(struct pt_regs *regs)
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
@@ -277,7 +285,6 @@ int check_irq_vectors_for_cpu_disable(void)
 	unsigned int this_cpu, vector, this_count, count;
 	struct irq_desc *desc;
 	struct irq_data *data;
-	struct cpumask affinity_new, online_new;
 
 	this_cpu = smp_processor_id();
 	cpumask_copy(&online_new, cpu_online_mask);
