Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaACAGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:06:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23263 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaACAGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:06:17 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Rui Wang <rui.y.wang@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 33/33] x86, ioapic: Hotadd of IOAPICs described in static MADT
Date: Thu,  2 Jan 2014 16:06:05 -0800
Message-Id: <1388707565-16535-34-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rui Wang <rui.y.wang@intel.com>

For IOAPICs described in static MADT, we already called __mp_register_ioapic()
in arch_early_irq_init(). During boot PCI root hotadd will call it again and
will find it already registered, thus register_ioapic() won't add it to the
ioapic_list. Subsequent hot-removal will also fail because it is not
found on the ioapic_list.

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c | 4 +++-
 drivers/pci/ioapic.c           | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 248a21d..ad28933 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3964,8 +3964,10 @@ int __mp_register_ioapic(int id, u32 address, u32 gsi_base, bool hotadd)
 
 	/* already registered ? */
 	idx = __mp_find_ioapic(gsi_base);
-	if (idx >= 0)
+	if (idx >= 0) {
+		ret = -EEXIST;
 		goto out;
+	}
 
 	idx = find_first_zero_bit(ioapics_mask, MAX_IO_APICS);
 	if (idx >= MAX_IO_APICS) {
diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
index 54de155..0a23295 100644
--- a/drivers/pci/ioapic.c
+++ b/drivers/pci/ioapic.c
@@ -126,7 +126,8 @@ static void handle_ioapic_add(acpi_handle handle, struct pci_dev **pdev,
 		}
 	}
 
-	if (acpi_register_ioapic(handle, res->start, gsi_base)) {
+	ret = acpi_register_ioapic(handle, res->start, gsi_base);
+	if (ret && ret != -EEXIST) {
 		if (dev)
 			goto exit_release;
 		return;
-- 
1.8.4

