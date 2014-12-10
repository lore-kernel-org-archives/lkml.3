Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbaLJWqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 17:46:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48726 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041AbaLJWqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:46:07 -0500
Date: Wed, 10 Dec 2014 14:45:43 -0800
From: tip-bot for Andy Shevchenko <tipbot@zytor.com>
Message-ID: <tip-c528d8b32d130956b3c158394d854e948cfc3411@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        david.a.cohen@linux.intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, joro@8bytes.org, jiang.liu@linux.intel.com,
        hpa@zytor.com
Reply-To: hpa@zytor.com, jiang.liu@linux.intel.com, joro@8bytes.org,
        tglx@linutronix.de, andriy.shevchenko@linux.intel.com,
        david.a.cohen@linux.intel.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1418236165-13961-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1418236165-13961-1-git-send-email-andriy.shevchenko@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic:
  Add proper legacy interrupt check to mp_map_pin_to_irq()
Git-Commit-ID: c528d8b32d130956b3c158394d854e948cfc3411
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

Commit-ID:  c528d8b32d130956b3c158394d854e948cfc3411
Gitweb:     http://git.kernel.org/tip/c528d8b32d130956b3c158394d854e948cfc3411
Author:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
AuthorDate: Wed, 10 Dec 2014 20:29:25 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 10 Dec 2014 23:43:56 +0100

x86, ioapic: Add proper legacy interrupt check to mp_map_pin_to_irq()

Since commit bfa644bfa9e3 (x86, irq: Convert IOAPIC to use hierarchy
irqdomain interfaces) Intel MID platforms crashes on boot:

 Enabling APIC mode:  Flat.  Using 1 I/O APICs
 BUG: unable to handle kernel NULL pointer dereference at 00000018
 IP: [<c107bdc6>] __irq_domain_alloc_irqs+0xff/0x250

The reason is that mp_map_pin_to_irq() assumes blindly that any non
PCI interrupt is legacy, but thats wrong for MID platforms as they
have no legacy interrupt support.

alloc_irq_from_domain() and mp_init_irq_at_boot() have checks for
this, but mp_map_pin_to_irq() is lacking one.

Instead of copying the same code another time, move the check to an
inline function and use it everywhere.

[ tglx: Massaged changelog ]

Fixes: bfa644bfa9e3 'x86, irq: Convert IOAPIC to use hierarchy irqdomain interfaces'
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1418236165-13961-1-git-send-email-andriy.shevchenko@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ed22b4c..f60e06e 100644
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
