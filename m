Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbaACAHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:07:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21956 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaACAHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:07:45 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v5 20/33] x86, irq: More strict checking about registering ioapic
Date: Thu,  2 Jan 2014 16:05:52 -0800
Message-Id: <1388707565-16535-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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
index 5dd3886..d43894e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3826,12 +3826,9 @@ void __init ioapic_insert_resources(void)
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
@@ -3841,10 +3838,19 @@ int mp_find_ioapic(u32 gsi)
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
@@ -3896,6 +3902,11 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
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
@@ -3922,6 +3933,13 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
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
1.8.4

