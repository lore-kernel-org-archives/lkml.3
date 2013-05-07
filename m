Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698Ab3EGODK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:03:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42393 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab3EGNlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tony Luck <tony.luck@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 069/118] Fix initialization of CMCI/CMCP interrupts
Date: Tue,  7 May 2013 14:38:35 +0100
Message-Id: <1367933964-1564-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit d303e9e98fce56cdb3c6f2ac92f626fc2bd51c77 upstream.

Back 2010 during a revamp of the irq code some initializations
were moved from ia64_mca_init() to ia64_mca_late_init() in

	commit c75f2aa13f5b268aba369b5dc566088b5194377c
	Cannot use register_percpu_irq() from ia64_mca_init()

But this was hideously wrong. First of all these initializations
are now down far too late. Specifically after all the other cpus
have been brought up and initialized their own CMC vectors from
smp_callin(). Also ia64_mca_late_init() may be called from any cpu
so the line:
	ia64_mca_cmc_vector_setup();       /* Setup vector on BSP */
is generally not executed on the BSP, and so the CMC vector isn't
setup at all on that processor.

Make use of the arch_early_irq_init() hook to get this code executed
at just the right moment: not too early, not too late.

Reported-by: Fred Hartnett <fred.hartnett@hp.com>
Tested-by: Fred Hartnett <fred.hartnett@hp.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/ia64/include/asm/mca.h |  1 +
 arch/ia64/kernel/irq.c      |  8 ++++++++
 arch/ia64/kernel/mca.c      | 37 ++++++++++++++++++++++++-------------
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/include/asm/mca.h b/arch/ia64/include/asm/mca.h
index 43f96ab..8c70961 100644
--- a/arch/ia64/include/asm/mca.h
+++ b/arch/ia64/include/asm/mca.h
@@ -143,6 +143,7 @@ extern unsigned long __per_cpu_mca[NR_CPUS];
 extern int cpe_vector;
 extern int ia64_cpe_irq;
 extern void ia64_mca_init(void);
+extern void ia64_mca_irq_init(void);
 extern void ia64_mca_cpu_init(void *);
 extern void ia64_os_mca_dispatch(void);
 extern void ia64_os_mca_dispatch_end(void);
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index ad69606..f2c41828 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -23,6 +23,8 @@
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 
+#include <asm/mca.h>
+
 /*
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
@@ -83,6 +85,12 @@ bool is_affinity_mask_valid(const struct cpumask *cpumask)
 
 #endif /* CONFIG_SMP */
 
+int __init arch_early_irq_init(void)
+{
+	ia64_mca_irq_init();
+	return 0;
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 unsigned int vectors_in_migration[NR_IRQS];
 
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index 65bf9cd..d7396db 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -2074,22 +2074,16 @@ ia64_mca_init(void)
 	printk(KERN_INFO "MCA related initialization done\n");
 }
 
+
 /*
- * ia64_mca_late_init
- *
- *	Opportunity to setup things that require initialization later
- *	than ia64_mca_init.  Setup a timer to poll for CPEs if the
- *	platform doesn't support an interrupt driven mechanism.
- *
- *  Inputs  :   None
- *  Outputs :   Status
+ * These pieces cannot be done in ia64_mca_init() because it is called before
+ * early_irq_init() which would wipe out our percpu irq registrations. But we
+ * cannot leave them until ia64_mca_late_init() because by then all the other
+ * processors have been brought online and have set their own CMC vectors to
+ * point at a non-existant action. Called from arch_early_irq_init().
  */
-static int __init
-ia64_mca_late_init(void)
+void __init ia64_mca_irq_init(void)
 {
-	if (!mca_init)
-		return 0;
-
 	/*
 	 *  Configure the CMCI/P vector and handler. Interrupts for CMC are
 	 *  per-processor, so AP CMC interrupts are setup in smp_callin() (smpboot.c).
@@ -2108,6 +2102,23 @@ ia64_mca_late_init(void)
 	/* Setup the CPEI/P handler */
 	register_percpu_irq(IA64_CPEP_VECTOR, &mca_cpep_irqaction);
 #endif
+}
+
+/*
+ * ia64_mca_late_init
+ *
+ *	Opportunity to setup things that require initialization later
+ *	than ia64_mca_init.  Setup a timer to poll for CPEs if the
+ *	platform doesn't support an interrupt driven mechanism.
+ *
+ *  Inputs  :   None
+ *  Outputs :   Status
+ */
+static int __init
+ia64_mca_late_init(void)
+{
+	if (!mca_init)
+		return 0;
 
 	register_hotcpu_notifier(&mca_cpu_notifier);
 
-- 
1.8.1.2

