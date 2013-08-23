Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3HWI7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:59:30 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:35967 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab3HWI71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:59:27 -0400
From: Liu Ping Fan <kernelfans@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kevin Hao <haokexin@gmail.com>
Subject: [PATCH] x86: ioapic needs check attr when programmed more than once
Date: Fri, 23 Aug 2013 16:58:47 +0800
Message-Id: <1377248327-19633-1-git-send-email-pingfank@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When programming ioapic pinX more than once, current code
does not check whether the later attr (trigger&polarity) is the
same as the former or not. This causes a broken semantic.

This can be observed in qemu q35 machine, where ioapic's ioredtbl[x]
can never be set as low-active, even if the hpet driver registered it.
And hpet driver may share a high-level active IRQ line with other
device. So in qemu, when hpet-dev asserts low-level as kernel expects,
the kernel has no response. With this patch, we can observe an
ioredtbl[x] set as low-active for hpet.

Fix it by reporting -EBUSY to the caller, when attr is different.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 arch/x86/kernel/acpi/boot.c    | 5 ++++-
 arch/x86/kernel/apic/io_apic.c | 7 ++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 230c8ea..9ef2ce9 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1113,6 +1113,7 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 	int ioapic;
 	int ioapic_pin;
 	struct io_apic_irq_attr irq_attr;
+	int ret;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
@@ -1142,7 +1143,9 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
 			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
+	ret = io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
+	if (ret < 0)
+		gsi = INT_MIN;
 
 	return gsi;
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9ed796c..ce31d902 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3375,12 +3375,17 @@ int io_apic_setup_irq_pin_once(unsigned int irq, int node,
 {
 	unsigned int ioapic_idx = attr->ioapic, pin = attr->ioapic_pin;
 	int ret;
+	struct IO_APIC_route_entry orig;
 
 	/* Avoid redundant programming */
 	if (test_bit(pin, ioapics[ioapic_idx].pin_programmed)) {
 		pr_debug("Pin %d-%d already programmed\n",
 			 mpc_ioapic_id(ioapic_idx), pin);
-		return 0;
+		orig = ioapic_read_entry(attr->ioapic, pin);
+		if (attr->trigger == orig.trigger &&
+			attr->polarity == orig.polarity)
+			return 0;
+		return -EBUSY;
 	}
 	ret = io_apic_setup_irq_pin(irq, node, attr);
 	if (!ret)
-- 
1.8.1.4

