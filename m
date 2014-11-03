Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaKCLC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:02:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaKCLCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:02:25 -0500
Date: Mon, 3 Nov 2014 02:59:11 -0800
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-b141cb5363583a887ab2d6f742bc849f615634ff@git.kernel.org>
Cc: rdunlap@infradead.org, jiang.liu@linux.intel.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, bhelgaas@google.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, prarit@redhat.com, tglx@linutronix.de,
        sebastian@breakpoint.cc, tony.luck@intel.com, yinghai@kernel.org,
        benh@kernel.crashing.org, mingo@kernel.org, hpa@zytor.com,
        bp@alien8.de, grant.likely@linaro.org, rjw@rjwysocki.net
Reply-To: yinghai@kernel.org, tony.luck@intel.com, sebastian@breakpoint.cc,
        tglx@linutronix.de, prarit@redhat.com, gregkh@linuxfoundation.org,
        rjw@rjwysocki.net, grant.likely@linaro.org, bp@alien8.de,
        hpa@zytor.com, mingo@kernel.org, benh@kernel.crashing.org,
        konrad.wilk@oracle.com, jiang.liu@linux.intel.com,
        rdunlap@infradead.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com
In-Reply-To: <1414387308-27148-11-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-11-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Prefer assigned ID in APIC ID register for x86_64
Git-Commit-ID: b141cb5363583a887ab2d6f742bc849f615634ff
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

Commit-ID:  b141cb5363583a887ab2d6f742bc849f615634ff
Gitweb:     http://git.kernel.org/tip/b141cb5363583a887ab2d6f742bc849f615634ff
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Oct 2014 13:21:40 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 11:56:07 +0100

x86, irq: Prefer assigned ID in APIC ID register for x86_64

Perfer the assigned ID in APIC ID register for x86_64 if it's still
available.

[ tglx: Added comments ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1414387308-27148-11-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 45 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index acaee90..02212fb 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3580,26 +3580,59 @@ static int __init io_apic_get_unique_id(int ioapic, int apic_id)
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
-	int i;
+	union IO_APIC_reg_00 reg_00;
 	DECLARE_BITMAP(used, 256);
+	unsigned long flags;
+	u8 new_id;
+	int i;
 
 	bitmap_zero(used, 256);
 	for_each_ioapic(i)
 		__set_bit(mpc_ioapic_id(i), used);
+
+	/* Hand out the requested id if available */
 	if (!test_bit(id, used))
 		return id;
-	return find_first_zero_bit(used, 256);
+
+	/*
+	 * Read the current id from the ioapic and keep it if
+	 * available.
+	 */
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
+	/*
+	 * Get the next free id and write it to the ioapic.
+	 */
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
 
@@ -3865,7 +3898,7 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
 		return;
 	}
 
-	ioapics[idx].mp_config.apicid = io_apic_unique_id(id);
+	ioapics[idx].mp_config.apicid = io_apic_unique_id(idx, id);
 	ioapics[idx].mp_config.apicver = io_apic_get_version(idx);
 
 	/*
