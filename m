Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3EJOTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:19:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56867 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823Ab3EJOTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:19:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Fred Hartnett" <fred.hartnett@hp.com>,
        "Tony Luck" <tony.luck@intel.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.281151932@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [013/118] Fix initialization of CMCI/CMCP interrupts
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/ia64/include/asm/mca.h |    1 +
 arch/ia64/kernel/irq.c      |    8 ++++++++
 arch/ia64/kernel/mca.c      |   37 ++++++++++++++++++++++++-------------
 3 files changed, 33 insertions(+), 13 deletions(-)

--- a/arch/ia64/include/asm/mca.h
+++ b/arch/ia64/include/asm/mca.h
@@ -143,6 +143,7 @@ extern unsigned long __per_cpu_mca[NR_CP
 extern int cpe_vector;
 extern int ia64_cpe_irq;
 extern void ia64_mca_init(void);
+extern void ia64_mca_irq_init(void);
 extern void ia64_mca_cpu_init(void *);
 extern void ia64_os_mca_dispatch(void);
 extern void ia64_os_mca_dispatch_end(void);
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
@@ -83,6 +85,12 @@ bool is_affinity_mask_valid(const struct
 
 #endif /* CONFIG_SMP */
 
+int __init arch_early_irq_init(void)
+{
+	ia64_mca_irq_init();
+	return 0;
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 unsigned int vectors_in_migration[NR_IRQS];
 
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -2071,22 +2071,16 @@ ia64_mca_init(void)
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
@@ -2105,6 +2099,23 @@ ia64_mca_late_init(void)
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
 

