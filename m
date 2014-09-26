Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbaIZKWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:22:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbaIZJqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>, Gong Chen <gong.chen@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 004/142] x86, cpu hotplug: Fix stack frame warning in check_irq_vectors_for_cpu_disable()
Date: Fri, 26 Sep 2014 11:43:35 +0200
Message-Id: <66acfbf79cf6f97b0935a5830703166fae3104c1.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Prarit Bhargava <prarit@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 39424e89d64661faa0a2e00c5ad1e6dbeebfa972 upstream.

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/irq.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 4207e8d1a094..39100783cf26 100644
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
2.1.0

