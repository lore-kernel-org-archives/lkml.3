Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbaLJSac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:30:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:39317 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932479AbaLJSa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:30:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="651723413"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v1] x86, ioapic: fix kernel crash on boot on non-PC platforms
Date: Wed, 10 Dec 2014 20:29:25 +0200
Message-Id: <1418236165-13961-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel MID platforms have no legacy IRQ support. The commit bfa644bfa9e3 (x86,
irq: Convert IOAPIC to use hierarchy irqdomain interfaces) introduces new
scheme of allocating IRQs for IOAPIC, though it maps a pin disregarding whether
or not the platform supports legacy IRQs. Thus, during boot we end up with a
kernel crash like following:

	Enabling APIC mode:  Flat.  Using 1 I/O APICs
	BUG: unable to handle kernel NULL pointer dereference at 00000018
	IP: [<c107bdc6>] __irq_domain_alloc_irqs+0xff/0x250

The patch fixes the issue by threating legacy property correctly on non-PC
platforms.

Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fe67a5d..14144d8 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -149,6 +149,11 @@ static inline u32 mp_pin_to_gsi(int ioapic, int pin)
 	return mp_ioapic_gsi_routing(ioapic)->gsi_base + pin;
 }
 
+static inline bool mp_is_legacy_irq(int irq)
+{
+	return irq >= 0 && irq < nr_legacy_irqs();
+}
+
 /*
  * Initialize all legacy IRQs and all pins on the first IOAPIC
  * if we have legacy interrupt controller. Kernel boot option "pirq="
@@ -159,7 +164,7 @@ static inline int mp_init_irq_at_boot(int ioapic, int irq)
 	if (!nr_legacy_irqs())
 		return 0;
 
-	return ioapic == 0 || (irq >= 0 && irq < nr_legacy_irqs());
+	return ioapic == 0 || mp_is_legacy_irq(irq);
 }
 
 static inline struct irq_domain *mp_ioapic_irqdomain(int ioapic)
@@ -960,7 +965,7 @@ static int alloc_irq_from_domain(struct irq_domain *domain, int ioapic, u32 gsi,
 		 */
 		if (!ioapic_initialized || gsi >= nr_legacy_irqs())
 			irq = gsi;
-		legacy = irq >= 0 && irq < nr_legacy_irqs();
+		legacy = mp_is_legacy_irq(irq);
 		break;
 	case IOAPIC_DOMAIN_STRICT:
 		irq = gsi;
@@ -1031,8 +1036,8 @@ static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
 		return -ENOSYS;
 
 	if (idx >= 0 && test_bit(mp_irqs[idx].srcbus, mp_bus_not_pci)) {
-		legacy = true;
 		irq = mp_irqs[idx].srcbusirq;
+		legacy = mp_is_legacy_irq(irq);
 	}
 
 	mutex_lock(&ioapic_mutex);
-- 
2.1.3

