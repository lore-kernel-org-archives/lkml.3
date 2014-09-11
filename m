Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaIKIJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:09:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:35740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbaIKIDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:03:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="601322405"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: [Patch v5 07/15] x86, irq: Prefer assigned ID in APIC ID register for x86_64
Date: Thu, 11 Sep 2014 16:05:50 +0800
Message-Id: <1410422758-24942-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410422758-24942-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410422758-24942-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Perfer the assigned ID in APIC ID register for x86_64 if it's still
available.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 003945e71616..9011c5fa5aad 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3575,26 +3575,51 @@ static int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	return apic_id;
 }
 
-static u8 __init io_apic_unique_id(u8 id)
+static u8 __init io_apic_unique_id(int idx, u8 id)
 {
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
 	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
-		return io_apic_get_unique_id(nr_ioapics, id);
+		return io_apic_get_unique_id(idx, id);
 	else
 		return id;
 }
 #else
-static u8 __init io_apic_unique_id(u8 id)
+static u8 __init io_apic_unique_id(int idx, u8 id)
 {
 	int i;
+	u8 new_id;
+	unsigned long flags;
 	DECLARE_BITMAP(used, 256);
+	union IO_APIC_reg_00 reg_00;
 
 	bitmap_zero(used, 256);
 	for_each_ioapic(i)
 		__set_bit(mpc_ioapic_id(i), used);
 	if (!test_bit(id, used))
 		return id;
-	return find_first_zero_bit(used, 256);
+
+	/* check register at first */
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	reg_00.raw = io_apic_read(idx, 0);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+	new_id = reg_00.bits.ID;
+	if (!test_bit(new_id, used)) {
+		apic_printk(APIC_VERBOSE, KERN_INFO
+			"IOAPIC[%d]: Using reg apic_id %d instead of %d\n",
+			 idx, new_id, id);
+		return new_id;
+	}
+
+	new_id = find_first_zero_bit(used, 256);
+	reg_00.bits.ID = new_id;
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	io_apic_write(idx, 0, reg_00.raw);
+	reg_00.raw = io_apic_read(idx, 0);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+	/* Sanity check */
+	BUG_ON(reg_00.bits.ID != new_id);
+
+	return new_id;
 }
 #endif
 
@@ -3860,7 +3885,7 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
 		return;
 	}
 
-	ioapics[idx].mp_config.apicid = io_apic_unique_id(id);
+	ioapics[idx].mp_config.apicid = io_apic_unique_id(idx, id);
 	ioapics[idx].mp_config.apicver = io_apic_get_version(idx);
 
 	/*
-- 
1.7.10.4

