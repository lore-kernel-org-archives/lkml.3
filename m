Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaLEIsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:48:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:34003 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaLEIsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:48:32 -0500
Message-Id: <20141204234737.728961990@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 05 Dec 2014 08:48:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>
Subject: [patch 0/5] x86/iommu: Bootup stage cleanups
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris reported that the conversion to stacked irqdomains causes a
GFP_KERNEL allocation from atomic context splat.

The callchain is:

kernel_init_freeable
 smp_prepare_cpus
  default_setup_apic_routing
   enable_IR_x2apic
    irq_remapping_enable
     intel_enable_irq_remapping
       intel_setup_irq_remapping
         irq_domain_add_hierarchy
	   __irq_domain_add

The reason for the splat is that smp_prepare_cpus() is pointlessly
disabling preemption and enable_IR_x2apic is calling
irq_remapping_enable with interrupts disabled.

Removing the completely useless preemption disable from
smp_prepare_cpus() is a no brainer, but resolving the interrupt
disabled issue in enable_IR_x2apic/irq_remapping_enable forced me to
look deeper into the iommu setup code.

Convoluted is probably an euphemism for that maze.

The early detection of iommus happens in mem_init() which looks for
the availability of ACPI tables describing iommus.

The actual parsing of the tables happens for AMD in
setup_irq_remapping_ops() which calls remap_ops.prepare() and for
Intel in irq_remapping_enable().

The AMD parsing allocates data structures, memory pages and the irq
domain from the prepare callback, which makes a lot of sense as this
has nothing to do with the actual enablement. That AMD code uses
GFP_KERNEL allocations inside of a preempt disabled region. That issue
is solved by removing the silly preempt_disable() from
smp_prepare_cpus().

For Intel the actual parsing and allocation is moved from the enable
to the prepare callback. That cures the reported splat and allows to
use GFP_KERNEL allocations for the iommu internal stuff as well. While
in the early bootup it does not matter much, for physical hotplug
GFP_ATOMIC allocations are not desired at all.

That solves the issue at hand, but the iommu setup stays a tangled
maze with completely non obvious setup mechanisms depending on the
options (iommu on/off - irq remapping on/off).

Thanks,

	tglx
---
 arch/x86/include/asm/irq_remapping.h |    2 -
 arch/x86/kernel/apic/apic.c          |    3 -
 arch/x86/kernel/smpboot.c            |    8 ----
 drivers/iommu/intel_irq_remapping.c  |   68 +++++++++++++++++++++++------------
 drivers/iommu/irq_remapping.c        |   19 +++------
 kernel/irq/irqdomain.c               |   21 +---------
 6 files changed, 56 insertions(+), 65 deletions(-)





