Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbaH0FvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 01:51:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:42749 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865AbaH0Fu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 01:50:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,408,1406617200"; 
   d="scan'208";a="582213711"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Prarit Bhargava <prarit@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [Bugfix] x86, irq: Fix bug in setting IOAPIC pin attributes
Date: Wed, 27 Aug 2014 13:53:11 +0800
Message-Id: <1409118795-17046-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140826095221.GO1660@lahna.fi.intel.com>
References: <20140826095221.GO1660@lahna.fi.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 15a3c7cc9154321fc3 "x86, irq: Introduce two helper functions
to support irqdomain map operation" breaks LPSS ACPI enumerated
devices.

On startup, IOAPIC driver preallocates IRQ descriptors and programs
IOAPIC pins with default level and polarity attributes for all legacy
IRQs. Later legacy IRQ users may fail to set IOAPIC pin attributes
if the requested attributes conflicts with the default IOAPIC pin
attributes. So change mp_irqdomain_map() to allow the first legacy IRQ
user to reprogram IOAPIC pin with different attributes.

Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi Mika,
	We have a plan to kill function mp_set_gsi_attr() later, so
I have slightly modified your changes. Could you please help to test
it again?
Regards!
Gerry
---
 arch/x86/kernel/apic/io_apic.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 29290f554e79..40a4aa3f4061 100644
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
-- 
1.7.10.4

