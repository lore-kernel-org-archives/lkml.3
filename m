Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609Ab3BHTcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:32:14 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34166 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760391Ab3BHTa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:30:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v2 22/26] x86, irq: Make ioapics loop skip blank slots
Date: Fri,  8 Feb 2013 11:28:19 -0800
Message-Id: <1360351703-20571-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When multiple ioapics get added and removed, we could have blank slots
in middle of ioapics array.

Add skip code for this case by checking nr_registers.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/io_apic.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4a9ccf6..d4c68d9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -793,7 +793,8 @@ int save_ioapic_entries(void)
 	int err = 0;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapics[apic].saved_registers) {
+		if (!ioapics[apic].saved_registers &&
+		    ioapics[apic].nr_registers) {
 			err = -ENOMEM;
 			continue;
 		}
@@ -899,9 +900,12 @@ static int __init find_isa_irq_apic(int irq, int type)
 	if (i < mp_irq_entries) {
 		int ioapic_idx;
 
-		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
+			if (!ioapics[ioapic_idx].nr_registers)
+				continue;
 			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic)
 				return ioapic_idx;
+		}
 	}
 
 	return -1;
@@ -1121,10 +1125,13 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 	for (i = 0; i < mp_irq_entries; i++) {
 		int lbus = mp_irqs[i].srcbus;
 
-		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
+			if (!ioapics[ioapic_idx].nr_registers)
+				continue;
 			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic ||
 			    mp_irqs[i].dstapic == MP_APIC_ALL)
 				break;
+		}
 
 		if (!test_bit(lbus, mp_bus_not_pci) &&
 		    !mp_irqs[i].irqtype &&
@@ -2084,6 +2091,9 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 	 * Set the IOAPIC ID to the value stored in the MPC table.
 	 */
 	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
+		if (!ioapics[ioapic_idx].nr_registers)
+			continue;
+
 		/* Read the register 0 value */
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(ioapic_idx, 0);
@@ -3013,8 +3023,12 @@ static void ioapic_resume(void)
 {
 	int ioapic_idx;
 
-	for (ioapic_idx = nr_ioapics - 1; ioapic_idx >= 0; ioapic_idx--)
+	for (ioapic_idx = nr_ioapics - 1; ioapic_idx >= 0; ioapic_idx--) {
+		if (!ioapics[ioapic_idx].nr_registers)
+			continue;
+
 		resume_ioapic_id(ioapic_idx);
+	}
 
 	restore_ioapic_entries();
 }
@@ -3854,8 +3868,11 @@ static int __mp_find_ioapic(u32 gsi, bool quiet)
 	/* Find the IOAPIC that manages this GSI. */
 	for (i = 0; i < nr_ioapics; i++) {
 		struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(i);
-		if ((gsi >= gsi_cfg->gsi_base)
-		    && (gsi <= gsi_cfg->gsi_end))
+
+		if (!ioapics[i].nr_registers)
+			continue;
+
+		if ((gsi >= gsi_cfg->gsi_base) && (gsi <= gsi_cfg->gsi_end))
 			return i;
 	}
 
-- 
1.7.10.4

