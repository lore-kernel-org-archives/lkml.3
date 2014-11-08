Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaKHSMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:12:53 -0500
Received: from mga14.intel.com ([192.55.52.115]:8211 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbaKHSMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:12:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413533371"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part3 v3 07/38] x86, irq: Simplify the way to print IOAPIC entry
Date: Sun,  9 Nov 2014 02:13:07 +0800
Message-Id: <1415470418-10874-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the way to print IOAPIC entry content, so we could kill
native_io_apic_print_entries(), intel_ir_io_apic_print_entries()
and x86_io_apic_ops.print_entries() later.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 74a0e95cfb3d..b2618d48d572 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1424,6 +1424,33 @@ void ioapic_zap_locks(void)
 	raw_spin_lock_init(&ioapic_lock);
 }
 
+static void io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
+{
+	int i;
+	char buf[256];
+	struct IO_APIC_route_entry entry;
+	struct IR_IO_APIC_route_entry *ir_entry = (void *)&entry;
+
+	printk(KERN_DEBUG "IOAPIC %d:\n", apic);
+	for (i = 0; i <= nr_entries; i++) {
+		entry = ioapic_read_entry(apic, i);
+		snprintf(buf, sizeof(buf),
+			 " pin%02x, %s, %s, %s, V(%02X), IRR(%1d), S(%1d)",
+			 i, entry.mask ? "enabled" : "disabled",
+			 entry.trigger ? "level" : "edge",
+			 entry.polarity ? "high" : "low",
+			 entry.vector, entry.irr, entry.delivery_status);
+		if (ir_entry->format)
+			printk(KERN_DEBUG "%s, remapped, I(%04X),  Z(%X)\n",
+			       buf, (ir_entry->index << 15) | ir_entry->index,
+			       ir_entry->zero);
+		else
+			printk(KERN_DEBUG "%s, %s, D(%02X), M(%1d)\n",
+			       buf, entry.dest_mode ? "logical" : "physical",
+			       entry.dest, entry.delivery_mode);
+	}
+}
+
 static void __init print_IO_APIC(int ioapic_idx)
 {
 	union IO_APIC_reg_00 reg_00;
@@ -1477,8 +1504,7 @@ static void __init print_IO_APIC(int ioapic_idx)
 	}
 
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
-
-	x86_io_apic_ops.print_entries(ioapic_idx, reg_01.bits.entries);
+	io_apic_print_entries(ioapic_idx, reg_01.bits.entries);
 }
 
 void __init print_IO_APICs(void)
-- 
1.7.10.4

