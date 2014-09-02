Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaIBLDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:03:15 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33524 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaIBLDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:03:12 -0400
Message-ID: <5405A3EF.60908@linaro.org>
Date: Tue, 02 Sep 2014 12:03:11 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v10 03/19] arm: fiq: Replace default FIQ handler
References: <1408369264-14242-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-4-git-send-email-daniel.thompson@linaro.org> <20140819173742.GG30401@n2100.arm.linux.org.uk> <53F39377.1070308@linaro.org> <20140828150112.GD30401@n2100.arm.linux.org.uk> <53FF50B1.20009@linaro.org> <20140828161551.GC5001@linux.vnet.ibm.com>
In-Reply-To: <20140828161551.GC5001@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/14 17:15, Paul E. McKenney wrote:
> On Thu, Aug 28, 2014 at 04:54:25PM +0100, Daniel Thompson wrote:
>> On 28/08/14 16:01, Russell King - ARM Linux wrote:
>>> On Tue, Aug 19, 2014 at 07:12:07PM +0100, Daniel Thompson wrote:
>>>> On 19/08/14 18:37, Russell King - ARM Linux wrote:
>>>>> On Tue, Aug 19, 2014 at 05:45:53PM +0100, Daniel Thompson wrote:
>>>>>> +int register_fiq_nmi_notifier(struct notifier_block *nb)
>>>>>> +{
>>>>>> +	return atomic_notifier_chain_register(&fiq_nmi_chain, nb);
>>>>>> +}
>>>>>> +
>>>>>> +asmlinkage void __exception_irq_entry fiq_nmi_handler(struct pt_regs *regs)
>>>>>> +{
>>>>>> +	struct pt_regs *old_regs = set_irq_regs(regs);
>>>>>> +
>>>>>> +	nmi_enter();
>>>>>> +	atomic_notifier_call_chain(&fiq_nmi_chain, (unsigned long)regs, NULL);
>>>>>> +	nmi_exit();
>>>>>> +	set_irq_regs(old_regs);
>>>>>> +}
>>>>>
>>>>> Really not happy with this.  What happens if a FIQ occurs while we're
>>>>> inside register_fiq_nmi_notifier() - more specifically inside
>>>>> atomic_notifier_chain_register() ?
>>>>
>>>> Should depend on which side of the rcu update we're on.
>>>
>>> I just asked Paul McKenney, our RCU expert... essentially, yes, RCU
>>> stuff itself is safe in this context.  However, RCU stuff can call into
>>> lockdep if lockdep is configured, and there are questions over lockdep.
>>
>> Thanks for following this up.
>>
>> I originally formed the opinion RCU was safe from FIQ because it is also
>> used to manage the NMI notification handlers for x86
>> (register_nmi_handler) and I understood the runtime constraints on FIQ
>> to be very similar.
>>
>> Note that x86 manages the notifiers itself so it uses
>> list_for_each_entry_rcu() rather atomic_notifier_call_chain() but
>> nevertheless I think this boils down to the same thing w.r.t. safety
>> concerns.
>>
>>
>>> There's some things which can be done to reduce the lockdep exposure
>>> to it, such as ensuring that rcu_read_lock() is first called outside
>>> of FIQ context.
>>
>> lockdep is automatically disabled by calling nmi_enter() so all the
>> lockdep calls should end up following the early exit path based on
>> current->lockdep_recursion.
> 
> Ah, that was what I was missing.  Then the notification should be
> safe from NMI, so have at it!  ;-)
> 
> 							Thanx, Paul
> 
>>> There's concerns with whether either printk() in check_flags() could
>>> be reached too (flags there should always indicate that IRQs were
>>> disabled, so that reduces down to a question about just the first
>>> printk() there.)
>>>
>>> There's also the very_verbose() stuff for RCU lockdep classes which
>>> Paul says must not be enabled.
>>>
>>> Lastly, Paul isn't a lockdep expert, but he sees nothing that prevents
>>> lockdep doing the deadlock checking as a result of the above call.
>>>
>>> So... this coupled with my feeling that notifiers make it too easy for
>>> unreviewed code to be hooked into this path, I'm fairly sure that we
>>> don't want to be calling atomic notifier chains from FIQ context.

Having esablished (above) that RCU usage is safe from FIQ I have been
working on the assumption that your feeling regarding unreviewed code
is sufficient on its own to avoid using notifiers (and also to avoid
a list of function pointers like on x86).

Therefore I have made these changes I've produced a before/after patch
to show the impact of this. I will merge this into the FIQ patchset
shortly.

Personally I still favour using notifiers and think the coupling below is
excessive. Nevertheless I've run a couple of basic tests on the code
below and it works fine.

diff --git a/arch/arm/include/asm/fiq.h b/arch/arm/include/asm/fiq.h
index 175bfed..a25c952 100644
--- a/arch/arm/include/asm/fiq.h
+++ b/arch/arm/include/asm/fiq.h
@@ -54,7 +54,6 @@ extern void disable_fiq(int fiq);
 extern int ack_fiq(int fiq);
 extern void eoi_fiq(int fiq);
 extern bool has_fiq(int fiq);
-extern int register_fiq_nmi_notifier(struct notifier_block *nb);
 extern void fiq_register_mapping(int irq, struct fiq_chip *chip);
 
 /* helpers defined in fiqasm.S: */
diff --git a/arch/arm/include/asm/kgdb.h b/arch/arm/include/asm/kgdb.h
index 6563da0..cb5ccd6 100644
--- a/arch/arm/include/asm/kgdb.h
+++ b/arch/arm/include/asm/kgdb.h
@@ -51,6 +51,7 @@ extern void kgdb_handle_bus_error(void);
 extern int kgdb_fault_expected;
 
 extern int kgdb_register_fiq(unsigned int fiq);
+extern void kgdb_handle_fiq(struct pt_regs *regs);
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index b2bd1c7..7422b58 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -43,12 +43,14 @@
 #include <linux/irq.h>
 #include <linux/radix-tree.h>
 #include <linux/slab.h>
+#include <linux/irqchip/arm-gic.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cp15.h>
 #include <asm/exception.h>
 #include <asm/fiq.h>
 #include <asm/irq.h>
+#include <asm/kgdb.h>
 #include <asm/traps.h>
 
 #define FIQ_OFFSET ({					\
@@ -65,7 +67,6 @@ static unsigned long no_fiq_insn;
 static int fiq_start = -1;
 static RADIX_TREE(fiq_data_tree, GFP_KERNEL);
 static DEFINE_MUTEX(fiq_data_mutex);
-static ATOMIC_NOTIFIER_HEAD(fiq_nmi_chain);
 
 /* Default reacquire function
  * - we always relinquish FIQ control
@@ -218,17 +219,19 @@ bool has_fiq(int fiq)
 }
 EXPORT_SYMBOL(has_fiq);
 
-int register_fiq_nmi_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&fiq_nmi_chain, nb);
-}
-
 asmlinkage void __exception_irq_entry fiq_nmi_handler(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
 	nmi_enter();
-	atomic_notifier_call_chain(&fiq_nmi_chain, (unsigned long)regs, NULL);
+
+	/* these callbacks deliberately avoid using a notifier chain in
+	 * order to ensure code review happens (drivers cannot "secretly"
+	 * employ FIQ without modifying this chain of calls).
+	 */
+	kgdb_handle_fiq(regs);
+	gic_handle_fiq_ipi();
+
 	nmi_exit();
 	set_irq_regs(old_regs);
 }
diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index b77b885..630a3ef 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -312,12 +312,13 @@ struct kgdb_arch arch_kgdb_ops = {
 };
 
 #ifdef CONFIG_KGDB_FIQ
-static int kgdb_handle_fiq(struct notifier_block *nb, unsigned long arg,
-			   void *data)
+void kgdb_handle_fiq(struct pt_regs *regs)
 {
-	struct pt_regs *regs = (void *) arg;
 	int actual;
 
+	if (!kgdb_fiq)
+		return;
+
 	if (!kgdb_nmicallback(raw_smp_processor_id(), regs))
 		return NOTIFY_OK;
 
@@ -333,11 +334,6 @@ static int kgdb_handle_fiq(struct notifier_block *nb, unsigned long arg,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block kgdb_fiq_notifier = {
-	.notifier_call = kgdb_handle_fiq,
-	.priority = 100,
-};
-
 int kgdb_register_fiq(unsigned int fiq)
 {
 	static struct fiq_handler kgdb_fiq_desc = { .name = "kgdb", };
@@ -357,7 +353,6 @@ int kgdb_register_fiq(unsigned int fiq)
 	}
 
 	kgdb_fiq = fiq;
-	register_fiq_nmi_notifier(&kgdb_fiq_notifier);
 
 	return 0;
 }
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index bda5a91..8821160 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -502,13 +502,17 @@ static void __init gic_init_fiq(struct gic_chip_data *gic,
 /*
  * Fully acknowledge (both ack and eoi) a FIQ-based IPI
  */
-static int gic_handle_fiq_ipi(struct notifier_block *nb, unsigned long regs,
-			   void *data)
+void gic_handle_fiq_ipi(void)
 {
 	struct gic_chip_data *gic = &gic_data[0];
-	void __iomem *cpu_base = gic_data_cpu_base(gic);
+	void __iomem *cpu_base;
 	unsigned long irqstat, irqnr;
 
+	if (!gic || !gic->fiq_enable)
+		return;
+
+	cpu_base = gic_data_cpu_base(gic);
+
 	if (WARN_ON(!in_nmi()))
 		return NOTIFY_BAD;
 
@@ -525,13 +529,6 @@ static int gic_handle_fiq_ipi(struct notifier_block *nb, unsigned long regs,
 
 	return NOTIFY_OK;
 }
-
-/*
- * Notifier to ensure IPI FIQ is acknowledged correctly.
- */
-static struct notifier_block gic_fiq_ipi_notifier = {
-	.notifier_call = gic_handle_fiq_ipi,
-};
 #else /* CONFIG_FIQ */
 static inline void gic_set_group_irq(void __iomem *base, unsigned int hwirq,
 				     int group) {}
@@ -1250,10 +1247,6 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 #ifdef CONFIG_SMP
 		set_smp_cross_call(gic_raise_softirq);
 		register_cpu_notifier(&gic_cpu_notifier);
-#ifdef CONFIG_FIQ
-		if (gic_data_fiq_enable(gic))
-			register_fiq_nmi_notifier(&gic_fiq_ipi_notifier);
-#endif
 #endif
 		set_handle_irq(gic_handle_irq);
 	}
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 45e2d8c..52a5676 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -101,5 +101,8 @@ static inline void __init register_routable_domain_ops
 {
 	gic_routable_irq_domain_ops = ops;
 }
+
+void gic_handle_fiq_ipi(void);
+
 #endif /* __ASSEMBLY */
 #endif
