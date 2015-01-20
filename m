Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbbATFvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:51:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:36961 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbbATFvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:51:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664447383"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part2 v4 07/33] x86/irq: Kill GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
Date: Tue, 20 Jan 2015 13:51:27 +0800
Message-Id: <1421733113-15704-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no user of irq_alloc_hwirqs(), irq_alloc_hwirq(), irq_free_hwirqs()
and irq_free_hwirq() anymore, so kill GENERIC_IRQ_LEGACY_ALLOC_HWIRQ and
related code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1416901802-24211-17-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig              |    1 -
 arch/x86/kernel/apic/vector.c |   34 ----------------------------------
 2 files changed, 35 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 89a530a5836e..66513678ad11 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -882,7 +882,6 @@ config X86_UP_IOAPIC
 config X86_LOCAL_APIC
 	def_bool y
 	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC || PCI_MSI
-	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
 	select IRQ_DOMAIN_HIERARCHY
 	select PCI_MSI_IRQ_DOMAIN if PCI_MSI
 
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 4b8fad9aa685..31dc4a871673 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -660,40 +660,6 @@ void irq_force_complete_move(int irq)
 }
 #endif
 
-/*
- * Dynamic irq allocate and deallocation. Should be replaced by irq domains!
- */
-int arch_setup_hwirq(unsigned int irq, int node)
-{
-	struct irq_cfg *cfg;
-	unsigned long flags;
-	int ret;
-
-	cfg = alloc_irq_cfg(node);
-	if (!cfg)
-		return -ENOMEM;
-
-	raw_spin_lock_irqsave(&vector_lock, flags);
-	ret = __assign_irq_vector(irq, cfg, apic->target_cpus());
-	raw_spin_unlock_irqrestore(&vector_lock, flags);
-
-	if (!ret)
-		irq_set_chip_data(irq, cfg);
-	else
-		free_irq_cfg(cfg);
-	return ret;
-}
-
-void arch_teardown_hwirq(unsigned int irq)
-{
-	struct irq_cfg *cfg = irq_cfg(irq);
-
-	free_remapped_irq(irq);
-	clear_irq_vector(irq, cfg);
-	irq_set_chip_data(irq, NULL);
-	free_irq_cfg(cfg);
-}
-
 static void __init print_APIC_field(int base)
 {
 	int i;
-- 
1.7.10.4

