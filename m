Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaK3Mhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:37:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56110 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbaK3Mhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:37:48 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] irqdomain: Correct early allocation of irq domains with IRQs off
Date: Sun, 30 Nov 2014 13:37:43 +0100
Message-Id: <1417351063-19039-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <alpine.DEB.2.11.1411292112390.3961@nanos>
References: <alpine.DEB.2.11.1411292112390.3961@nanos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

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

Cc: Thomas Gleixner <tglx@linutronix.de>
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
Link: Link: http://lkml.kernel.org/r/20141129125319.GA6491@pd.tnic
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 kernel/irq/irqdomain.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 7fac311057b8..3395d8923f96 100644
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
-- 
2.0.0

