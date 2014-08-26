Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192AbaHZInJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:43:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:59265 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933898AbaHZInE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:43:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,402,1406617200"; 
   d="scan'208";a="563488097"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
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
Date: Tue, 26 Aug 2014 16:45:01 +0800
Message-Id: <1409042706-11958-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140822124145.GF1660@lahna.fi.intel.com>
References: <20140822124145.GF1660@lahna.fi.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On startup, IOAPIC driver preallocates IRQ descriptors and programs
IOAPIC pins with default level and polarity attributes for all legacy
IRQs. Later legacy IRQ users may fail to set IOAPIC pin attributes
if the requested attributes conflicts with the default IOAPIC pin
attributes. So change mp_irqdomain_map() to allow the first legacy IRQ
user to reprogram IOAPIC pin with different attributes.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 29290f554e79..66c2700c9f83 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3896,7 +3896,15 @@ int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			info->polarity = 1;
 		}
 		info->node = NUMA_NO_NODE;
-		info->set = 1;
+
+		/*
+		 * setup_IO_APIC_irqs() programs all legacy IRQs with default
+		 * trigger and polarity attirbutes. Don't set the flag for that
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

