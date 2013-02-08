Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582Ab3BHTa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:30:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34052 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760407Ab3BHTaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:30:16 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v2 23/26] x86, ioapic: Find usable ioapic id for 64bit.
Date: Fri,  8 Feb 2013 11:28:20 -0800
Message-Id: <1360351703-20571-24-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking the id in register, if that is duplicated, will pick one and
update that to register.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/io_apic.c |   41 +++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d4c68d9..42f273b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3663,27 +3663,54 @@ static int __init io_apic_get_unique_id(int ioapic, int apic_id)
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
+static u8 io_apic_unique_id(int idx, u8 id)
 {
 	int i;
+	u8 new_id;
+	unsigned long flags;
 	DECLARE_BITMAP(used, 256);
+	union IO_APIC_reg_00 reg_00;
 
 	bitmap_zero(used, 256);
-	for (i = 0; i < nr_ioapics; i++) {
+	for (i = 0; i < nr_ioapics; i++)
 		__set_bit(mpc_ioapic_id(i), used);
-	}
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
+
+	/* Sanity check */
+	if (reg_00.bits.ID != new_id)
+		pr_warn("IOAPIC[%d]: Unable to change apic_id to %d!\n",
+			idx, new_id);
+
+	return new_id;
 }
 #endif
 
@@ -3964,7 +3991,7 @@ int __mp_register_ioapic(int id, u32 address, u32 gsi_base, bool hotadd)
 	if (bad_ioapic_register(idx))
 		goto failed;
 
-	ioapics[idx].mp_config.apicid = io_apic_unique_id(id);
+	ioapics[idx].mp_config.apicid = io_apic_unique_id(idx, id);
 	ioapics[idx].mp_config.apicver = io_apic_get_version(idx);
 
 	/*
-- 
1.7.10.4

