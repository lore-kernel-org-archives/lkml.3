Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaKZXP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:15:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbaKZXPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:15:23 -0500
Date: Wed, 26 Nov 2014 15:14:29 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-5c1eb3863d080848e04f196f9af30d8d70ab0fe6@git.kernel.org>
Cc: tglx@linutronix.de, mingo@kernel.org, bp@alien8.de, jroedel@suse.de,
        gregkh@linuxfoundation.org, yinghai@kernel.org, bhelgaas@google.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        tony.luck@intel.com, benh@kernel.crashing.org, rdunlap@infradead.org,
        hpa@zytor.com, jiang.liu@linux.intel.com, rjw@rjwysocki.net,
        konrad.wilk@oracle.com
Reply-To: rjw@rjwysocki.net, konrad.wilk@oracle.com, grant.likely@linaro.org,
        tony.luck@intel.com, benh@kernel.crashing.org, rdunlap@infradead.org,
        hpa@zytor.com, jiang.liu@linux.intel.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com, joro@8bytes.org,
        yinghai@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        jroedel@suse.de, bp@alien8.de
In-Reply-To: <1416901802-24211-8-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-8-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Simplify the way to print IOAPIC entry
Git-Commit-ID: 5c1eb3863d080848e04f196f9af30d8d70ab0fe6
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

Commit-ID:  5c1eb3863d080848e04f196f9af30d8d70ab0fe6
Gitweb:     http://git.kernel.org/tip/5c1eb3863d080848e04f196f9af30d8d70ab0fe6
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:31 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:46 +0100

x86, irq: Simplify the way to print IOAPIC entry

Simplify the way to print IOAPIC entry content, so we could kill
native_io_apic_print_entries(), intel_ir_io_apic_print_entries()
and x86_io_apic_ops.print_entries() later.

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
 arch/x86/kernel/apic/io_apic.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 74a0e95..b2618d4 100644
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
