Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaACAUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:20:41 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21530 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaACAGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:06:14 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 29/33] PCI, x86, ACPI: Link acpi ioapic register to ioapic
Date: Thu,  2 Jan 2014 16:06:01 -0800
Message-Id: <1388707565-16535-30-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During ioapic hotplug, acpi_register_ioapic will be called.
Now for x86, that function is blank.
Fill that will update __mp_register_ioapic to use those ioapic.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/acpi/boot.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 0f9c133..77bf505 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -651,16 +651,26 @@ EXPORT_SYMBOL(acpi_unmap_lsapic);
 
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base)
 {
-	/* TBD */
-	return -EINVAL;
+	u64 addr = 0;
+	int apic_id;
+
+	apic_id = acpi_get_ioapic_id(handle, gsi_base, &addr);
+
+	if (apic_id < 0)
+		return -1;
+
+	if (phys_addr != addr)
+		pr_warn("ioapic 0x%02x address is not consistent _CRS/dev(%llx) _MAT/MADT(%llx) \n",
+			apic_id, phys_addr, addr);
+
+	return	__mp_register_ioapic(apic_id, phys_addr, gsi_base, true);
 }
 
 EXPORT_SYMBOL(acpi_register_ioapic);
 
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
 {
-	/* TBD */
-	return -EINVAL;
+	return mp_unregister_ioapic(gsi_base);
 }
 
 EXPORT_SYMBOL(acpi_unregister_ioapic);
-- 
1.8.4

