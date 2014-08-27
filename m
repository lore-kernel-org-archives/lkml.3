Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbaH0JTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:19:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41456 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaH0JT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:19:29 -0400
Date: Wed, 27 Aug 2014 02:15:53 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-f395dcae7a68497751869cf0031fd8ce5e115f0a@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        grant.likely@linaro.org, yinghai@kernel.org, joro@8bytes.org,
        bp@alien8.de, benh@kernel.crashing.org, bhelgaas@google.com,
        mika.westerberg@linux.intel.com, rjw@rjwysocki.net, prarit@redhat.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        grant.likely@linaro.org, yinghai@kernel.org, joro@8bytes.org,
        bp@alien8.de, benh@kernel.crashing.org, bhelgaas@google.com,
        mika.westerberg@linux.intel.com, rjw@rjwysocki.net, prarit@redhat.com
In-Reply-To: <1409118795-17046-1-git-send-email-jiang.liu@linux.intel.com>
References: <1409118795-17046-1-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: irq:
  Fix bug in setting IOAPIC pin attributes
Git-Commit-ID: f395dcae7a68497751869cf0031fd8ce5e115f0a
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

Commit-ID:  f395dcae7a68497751869cf0031fd8ce5e115f0a
Gitweb:     http://git.kernel.org/tip/f395dcae7a68497751869cf0031fd8ce5e115f0a
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Wed, 27 Aug 2014 13:53:11 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 27 Aug 2014 11:02:16 +0200

x86: irq: Fix bug in setting IOAPIC pin attributes

Commit 15a3c7cc9154321fc3 "x86, irq: Introduce two helper functions
to support irqdomain map operation" breaks LPSS ACPI enumerated
devices.

On startup, IOAPIC driver preallocates IRQ descriptors and programs
IOAPIC pins with default level and polarity attributes for all legacy
IRQs. Later legacy IRQ users may fail to set IOAPIC pin attributes
if the requested attributes conflicts with the default IOAPIC pin
attributes. So change mp_irqdomain_map() to allow the first legacy IRQ
user to reprogram IOAPIC pin with different attributes.

Reported-and-tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1409118795-17046-1-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 29290f5..40a4aa3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1070,6 +1070,11 @@ static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
 	}
 
 	if (flags & IOAPIC_MAP_ALLOC) {
+		/* special handling for legacy IRQs */
+		if (irq < nr_legacy_irqs() && info->count == 1 &&
+		    mp_irqdomain_map(domain, irq, pin) != 0)
+			irq = -1;
+
 		if (irq > 0)
 			info->count++;
 		else if (info->count == 0)
@@ -3896,7 +3901,15 @@ int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			info->polarity = 1;
 		}
 		info->node = NUMA_NO_NODE;
-		info->set = 1;
+
+		/*
+		 * setup_IO_APIC_irqs() programs all legacy IRQs with default
+		 * trigger and polarity attributes. Don't set the flag for that
+		 * case so the first legacy IRQ user could reprogram the pin
+		 * with real trigger and polarity attributes.
+		 */
+		if (virq >= nr_legacy_irqs() || info->count)
+			info->set = 1;
 	}
 	set_io_apic_irq_attr(&attr, ioapic, hwirq, info->trigger,
 			     info->polarity);
