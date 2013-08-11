Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3HKCwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:52:21 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34893 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3HKCtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:49:33 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v4 20/28] x86, irq: More strict checking about registering ioapic
Date: Sat, 10 Aug 2013 19:48:06 -0700
Message-Id: <1376189294-32022-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. check overlaping gsi range
for hot-add ioapic case, BIOS may have some entries in MADT
and also have setting in pci root bus with _GSB of DSDT.

2. check if entries is in right range.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/io_apic.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b026cc7..60c6706 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3818,12 +3818,9 @@ void __init ioapic_insert_resources(void)
 	}
 }
 
-int mp_find_ioapic(u32 gsi)
+static int __mp_find_ioapic(u32 gsi)
 {
-	int i = 0;
-
-	if (nr_ioapics == 0)
-		return -1;
+	int i;
 
 	/* Find the IOAPIC that manages this GSI. */
 	for_each_ioapic(i) {
@@ -3833,10 +3830,19 @@ int mp_find_ioapic(u32 gsi)
 			return i;
 	}
 
-	printk(KERN_ERR "ERROR: Unable to locate IOAPIC for GSI %d\n", gsi);
 	return -1;
 }
 
+int mp_find_ioapic(u32 gsi)
+{
+	int ret = __mp_find_ioapic(gsi);
+
+	if (ret == -1)
+		pr_err("ERROR: Unable to locate IOAPIC for GSI %d\n", gsi);
+
+	return ret;
+}
+
 int mp_find_ioapic_pin(int ioapic, u32 gsi)
 {
 	struct mp_ioapic_gsi *gsi_cfg;
@@ -3888,6 +3894,11 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	if (bad_ioapic(address))
 		return;
 
+	/* already registered ? */
+	idx = __mp_find_ioapic(gsi_base);
+	if (idx >= 0)
+		return;
+
 	idx = find_first_zero_bit(ioapics_mask, MAX_IO_APICS);
 	if (idx >= MAX_IO_APICS) {
 		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded, skipping\n",
@@ -3914,6 +3925,13 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
 	entries = io_apic_get_redir_entries(idx);
+
+	if (!entries || entries > MP_MAX_IOAPIC_PIN) {
+		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+		memset(&ioapics[idx], 0, sizeof(struct ioapic));
+		return;
+	}
+
 	gsi_cfg = mp_ioapic_gsi_routing(idx);
 	gsi_cfg->gsi_base = gsi_base;
 	gsi_cfg->gsi_end = gsi_base + entries - 1;
-- 
1.8.1.4

