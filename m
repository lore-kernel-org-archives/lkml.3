Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbaHZXhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 19:37:35 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59492 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755541AbaHZXg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 19:36:58 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: [PATCH 3/5 v3] x86 / PM: Set IRQCHIP_SKIP_SET_WAKE for IOAPIC IRQ chip objects
Date: Wed, 27 Aug 2014 01:50:49 +0200
Message-ID: <5572679.hklRpx9fCZ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5320472.coYotHR1d0@vostro.rjw.lan>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan> <5320472.coYotHR1d0@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Set the IRQCHIP_SKIP_SET_WAKE for IOAPIC IRQ chip objects so that
interrupts from them can work as wakeup interrupts for suspend-to-idle.

After this change, running enable_irq_wake() on one of the IRQs in
question will succeed and IRQD_WAKEUP_STATE will be set for it, so
all of the suspend-to-idle wakeup mechanics introduced previously
will work for it automatically.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-pm/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-pm.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-pm/arch/x86/kernel/apic/io_apic.c
@@ -2618,6 +2618,7 @@ static struct irq_chip ioapic_chip __rea
 	.irq_eoi		= ack_apic_level,
 	.irq_set_affinity	= native_ioapic_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
 static inline void init_IO_APIC_traps(void)
@@ -3168,6 +3169,7 @@ static struct irq_chip msi_chip = {
 	.irq_ack		= ack_apic_edge,
 	.irq_set_affinity	= msi_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
 int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
@@ -3266,6 +3268,7 @@ static struct irq_chip dmar_msi_type = {
 	.irq_ack		= ack_apic_edge,
 	.irq_set_affinity	= dmar_msi_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
 int arch_setup_dmar_msi(unsigned int irq)
@@ -3316,6 +3319,7 @@ static struct irq_chip hpet_msi_type = {
 	.irq_ack = ack_apic_edge,
 	.irq_set_affinity = hpet_msi_set_affinity,
 	.irq_retrigger = ioapic_retrigger_irq,
+	.flags = IRQCHIP_SKIP_SET_WAKE,
 };
 
 int default_setup_hpet_msi(unsigned int irq, unsigned int id)
@@ -3379,6 +3383,7 @@ static struct irq_chip ht_irq_chip = {
 	.irq_ack		= ack_apic_edge,
 	.irq_set_affinity	= ht_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)

