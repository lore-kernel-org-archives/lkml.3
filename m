Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbaKZXRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:17:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58811 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbaKZXRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:17:45 -0500
Date: Wed, 26 Nov 2014 15:16:50 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-66cb4424740b7584d8ffe22d5c2850f7c773a840@git.kernel.org>
Cc: benh@kernel.crashing.org, rdunlap@infradead.org, bp@alien8.de,
        konrad.wilk@oracle.com, bhelgaas@google.com, tglx@linutronix.de,
        yinghai@kernel.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net, mingo@kernel.org, joro@8bytes.org,
        tony.luck@intel.com
Reply-To: tony.luck@intel.com, joro@8bytes.org, rjw@rjwysocki.net,
        mingo@kernel.org, gregkh@linuxfoundation.org, yinghai@kernel.org,
        jiang.liu@linux.intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        konrad.wilk@oracle.com, bp@alien8.de, tglx@linutronix.de,
        bhelgaas@google.com, rdunlap@infradead.org, benh@kernel.crashing.org
In-Reply-To: <1416901802-24211-17-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-17-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Kill GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
Git-Commit-ID: 66cb4424740b7584d8ffe22d5c2850f7c773a840
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

Commit-ID:  66cb4424740b7584d8ffe22d5c2850f7c773a840
Gitweb:     http://git.kernel.org/tip/66cb4424740b7584d8ffe22d5c2850f7c773a840
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:40 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:47 +0100

x86, irq: Kill GENERIC_IRQ_LEGACY_ALLOC_HWIRQ

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
 arch/x86/Kconfig              |  1 -
 arch/x86/kernel/apic/vector.c | 34 ----------------------------------
 2 files changed, 35 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e05be74..9d783a7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -881,7 +881,6 @@ config X86_UP_IOAPIC
 config X86_LOCAL_APIC
 	def_bool y
 	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC || PCI_MSI
-	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
 	select IRQ_DOMAIN_HIERARCHY
 	select PCI_MSI_IRQ_DOMAIN if PCI_MSI
 
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 4b8fad9..31dc4a8 100644
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
