Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbbATDNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:13:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:28466 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbbATDNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:13:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442530075"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part1 v7 36/38] x86/irq: Simplify the way to print IOAPIC entry
Date: Tue, 20 Jan 2015 11:08:39 +0800
Message-Id: <1421723321-8386-37-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the way to print IOAPIC entry content, so we could kill
native_io_apic_print_entries(), intel_ir_io_apic_print_entries()
and x86_io_apic_ops.print_entries() later.

Folded a patch from Thomas to fix errors in printed pin attributes,
http://www.spinics.net/lists/linux-tip-commits/msg26108.html

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
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1416901802-24211-8-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/apic/io_apic.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 16d4ba3ac844..3c6609617306 100644
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
+			 i, entry.mask ? "disabled" : "enabled ",
+			 entry.trigger ? "level" : "edge ",
+			 entry.polarity ? "low " : "high",
+			 entry.vector, entry.irr, entry.delivery_status);
+		if (ir_entry->format)
+			printk(KERN_DEBUG "%s, remapped, I(%04X),  Z(%X)\n",
+			       buf, (ir_entry->index << 15) | ir_entry->index,
+			       ir_entry->zero);
+		else
+			printk(KERN_DEBUG "%s, %s, D(%02X), M(%1d)\n",
+			       buf, entry.dest_mode ? "logical " : "physical",
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

