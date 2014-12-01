Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaLAJrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:47:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaLAJrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:47:02 -0500
Date: Mon, 1 Dec 2014 01:45:52 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-eda7516e1d428caf3cfc88e4292f2a1357a2e569@git.kernel.org>
Cc: matthias.bgg@gmail.com, hpa@zytor.com, benh@kernel.crashing.org,
        grant.likely@linaro.org, bp@suse.de, mingo@kernel.org,
        wangyijing@huawei.com, tony.luck@intel.com, bhelgaas@google.com,
        marc.zyngier@arm.com, joro@8bytes.org, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, yingjoe.chen@mediatek.com,
        tglx@linutronix.de
Reply-To: jiang.liu@linux.intel.com, tglx@linutronix.de,
        yingjoe.chen@mediatek.com, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, marc.zyngier@arm.com, joro@8bytes.org,
        tony.luck@intel.com, mingo@kernel.org, wangyijing@huawei.com,
        bp@suse.de, hpa@zytor.com, benh@kernel.crashing.org,
        grant.likely@linaro.org, matthias.bgg@gmail.com
In-Reply-To: <1417351063-19039-1-git-send-email-bp@alien8.de>
References: <20141129125319.GA6491@pd.tnic>
	<1417351063-19039-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] irqdomain:
  Correct early allocation of irq domains with IRQs off
Git-Commit-ID: eda7516e1d428caf3cfc88e4292f2a1357a2e569
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eda7516e1d428caf3cfc88e4292f2a1357a2e569
Gitweb:     http://git.kernel.org/tip/eda7516e1d428caf3cfc88e4292f2a1357a2e569
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sun, 30 Nov 2014 13:37:43 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 1 Dec 2014 10:38:30 +0100

irqdomain: Correct early allocation of irq domains with IRQs off

I'm seeing the following lockdep splat on an x2APIC machine with
interrupts remapping. The problem is that enable_IR_x2apic() disables
interrupts before doing any further initialization. However, after
having moved to irq domains, domain allocation cannot happen with
interrupts disabled (GFP_KERNEL).

A proper fix would be to move that initialization to the early irq setup
path, which is something for another day. It is more involved work too.

So do a temporary fix which should not encourage the behaviour of even
assuming the irq domains code should be called with interrupts disabled.
Make it x86-only too.

...
dmar: Host address width 36
dmar: DRHD base: 0x000000fed90000 flags: 0x0
dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
dmar: DRHD base: 0x000000fed91000 flags: 0x1
dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
dmar: RMRR base: 0x000000da2ba000 end: 0x000000da2d0fff
dmar: RMRR base: 0x000000db800000 end: 0x000000df9fffff
IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
HPET id 0 under DRHD base 0xfed91000
Queued invalidation will be enabled to support x2apic and Intr-remapping.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:2744 lockdep_trace_alloc+0xd4/0xe0()
DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc6+ #1
Hardware name: LENOVO 2320CTO/2320CTO, BIOS G2ET86WW (2.06 ) 11/13/2012
 0000000000000009 ffff880213d07b58 ffffffff816502d7 0000000000000000
 ffff880213d07ba8 ffff880213d07b98 ffffffff81059790 0000000000000001
 0000000000000092 0000000000000000 00000000000080d0 0000000000000000
Call Trace:
 dump_stack
 warn_slowpath_common
 warn_slowpath_fmt
 lockdep_trace_alloc
 __alloc_pages_nodemask
 ? get_page_from_freelist
 ? trace_hardirqs_off_caller
 alloc_kmem_pages_node
 kmalloc_large_node
 __kmalloc_node
 ? __dmar_enable_qi
 __irq_domain_add
 irq_domain_add_hierarchy
 intel_setup_irq_remapping.part.4
 intel_enable_irq_remapping
 irq_remapping_enable
 enable_IR
 enable_IR_x2apic
 default_setup_apic_routing
 native_smp_prepare_cpus
 kernel_init_freeable
 ? ret_from_fork
 ? rest_init
 kernel_init
 ret_from_fork
 ? rest_init
---[ end trace fac50e785fc22942 ]---
Enabled IRQ remapping in x2apic mode
Enabling x2apic
Enabled x2apic
Switched APIC routing to cluster x2apic.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
...

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>
Link: http://lkml.kernel.org/r/20141129125319.GA6491@pd.tnic
Link: http://lkml.kernel.org/r/1417351063-19039-1-git-send-email-bp@alien8.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdomain.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 7fac311..3395d89 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -46,14 +46,31 @@ struct irq_domain *__irq_domain_add(struct device_node *of_node, int size,
 				    void *host_data)
 {
 	struct irq_domain *domain;
+	gfp_t gfp_flags = GFP_KERNEL;
+
+#ifdef CONFIG_X86
+	/*
+	 * BIG FAT COMMENT: Early initialization paths like enable_IR_x2apic(),
+	 * for example, call into here with interrupts disabled but then we do
+	 * allocate memory and can sleep so no-no. A proper fix would be to do
+	 * x2APIC IR setup in the early irq setup path but it is too late for
+	 * fixing it this way now, shortly before the merge window.
+	 *
+	 * So we do this little brown paper bag, which is temporary! Do not even
+	 * think of calling irq domain setup code with IRQs disabled. You will
+	 * get frozen-sharked!
+	 */
+	if (irqs_disabled())
+		gfp_flags = GFP_NOFS;
+#endif
 
 	domain = kzalloc_node(sizeof(*domain) + (sizeof(unsigned int) * size),
-			      GFP_KERNEL, of_node_to_nid(of_node));
+			      gfp_flags, of_node_to_nid(of_node));
 	if (WARN_ON(!domain))
 		return NULL;
 
 	/* Fill structure */
-	INIT_RADIX_TREE(&domain->revmap_tree, GFP_KERNEL);
+	INIT_RADIX_TREE(&domain->revmap_tree, gfp_flags);
 	domain->ops = ops;
 	domain->host_data = host_data;
 	domain->of_node = of_node_get(of_node);
