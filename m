Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab3FGWfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 18:35:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22452 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660Ab3FGWdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 18:33:32 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v3 18/27] x86, irq: More strict checking about registering ioapic
Date: Fri,  7 Jun 2013 15:31:04 -0700
Message-Id: <1370644273-10495-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. check overlaping gsi range
for hot-add ioapic case, BIOS may have some entries in MADT
and also have setting in pci root bus with _GSB of DSDT.

2. make bad_ioapics check idx instead of nr_ioapics.
for hotadd ioapic could find spare slot in the middle later.

3. check if entries is in right range.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/io_apic.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7f95bbe..850d8e99 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3818,7 +3818,7 @@ void __init ioapic_insert_resources(void)
 	}
 }
 
-int mp_find_ioapic(u32 gsi)
+static int __mp_find_ioapic(u32 gsi, bool quiet)
 {
 	int i = 0;
 
@@ -3833,10 +3833,16 @@ int mp_find_ioapic(u32 gsi)
 			return i;
 	}
 
-	printk(KERN_ERR "ERROR: Unable to locate IOAPIC for GSI %d\n", gsi);
+	if (!quiet)
+		pr_err("ERROR: Unable to locate IOAPIC for GSI %d\n", gsi);
 	return -1;
 }
 
+int mp_find_ioapic(u32 gsi)
+{
+	return __mp_find_ioapic(gsi, false);
+}
+
 int mp_find_ioapic_pin(int ioapic, u32 gsi)
 {
 	struct mp_ioapic_gsi *gsi_cfg;
@@ -3851,11 +3857,11 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 	return gsi - gsi_cfg->gsi_base;
 }
 
-static __init int bad_ioapic(unsigned long address)
+static __init int bad_ioapic(int idx, unsigned long address)
 {
-	if (nr_ioapics >= MAX_IO_APICS) {
+	if (idx >= MAX_IO_APICS) {
 		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded (found %d), skipping\n",
-			MAX_IO_APICS, nr_ioapics);
+			MAX_IO_APICS, idx);
 		return 1;
 	}
 	if (!address) {
@@ -3886,14 +3892,17 @@ static __init int bad_ioapic_register(int idx)
 
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
-	int idx = 0;
+	int idx;
 	int entries;
 	struct mp_ioapic_gsi *gsi_cfg;
 
-	if (bad_ioapic(address))
+	idx = __mp_find_ioapic(gsi_base, true);
+	if (idx >= 0)
 		return;
 
 	idx = nr_ioapics;
+	if (bad_ioapic(idx, address))
+		return;
 
 	ioapics[idx].mp_config.type = MP_IOAPIC;
 	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
@@ -3914,6 +3923,12 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
 	entries = io_apic_get_redir_entries(idx);
+
+	if (!entries || entries > MP_MAX_IOAPIC_PIN) {
+		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+		return;
+	}
+
 	gsi_cfg = mp_ioapic_gsi_routing(idx);
 	gsi_cfg->gsi_base = gsi_base;
 	gsi_cfg->gsi_end = gsi_base + entries - 1;
-- 
1.8.1.4

