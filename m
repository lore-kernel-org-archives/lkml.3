Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594Ab3BHTaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:30:30 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26754 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760441Ab3BHTaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:30:19 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v2 19/26] x86, irq: More strict checking about registering ioapic
Date: Fri,  8 Feb 2013 11:28:16 -0800
Message-Id: <1360351703-20571-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. check overlaping gsi range
for hotplug ioapic case, BIOS may have some entries in MADT
and also have setting in pci root bus with _GSB of DSDT.

2. make bad_ioapics check idx instead of nr_ioapics.
for hotadd ioapic could find spare slot in the middle later.

3. check if entries is in right range.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/io_apic.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9514728..8e92ba0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3821,7 +3821,7 @@ void __init ioapic_insert_resources(void)
 	}
 }
 
-int mp_find_ioapic(u32 gsi)
+static int __mp_find_ioapic(u32 gsi, bool quiet)
 {
 	int i = 0;
 
@@ -3836,10 +3836,16 @@ int mp_find_ioapic(u32 gsi)
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
@@ -3854,11 +3860,11 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
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
@@ -3889,14 +3895,17 @@ static __init int bad_ioapic_register(int idx)
 
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
@@ -3917,6 +3926,12 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
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
1.7.10.4

