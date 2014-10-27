Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaJ0FVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:21:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:28915 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbaJ0FVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:21:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="406497920"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: [Patch v7 15/18] x86, irq, ACPI: Implement interface to support ACPI based IOAPIC hot-addition
Date: Mon, 27 Oct 2014 13:21:45 +0800
Message-Id: <1414387308-27148-16-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement acpi_register_ioapic() and enhance mp_register_ioapic()
to support ACPI based IOAPIC hot-addition.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c    |   31 +++++++++++++++++++++++++++++--
 arch/x86/kernel/apic/io_apic.c |   22 +++++++++++++++++++++-
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 3f6b665f5aa6..8205f6381d77 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -779,8 +779,35 @@ EXPORT_SYMBOL(acpi_unmap_lsapic);
 
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base)
 {
-	/* TBD */
-	return -EINVAL;
+	int ret = -ENOSYS;
+#ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
+	int ioapic_id;
+	u64 addr;
+	struct ioapic_domain_cfg cfg = {
+		.type = IOAPIC_DOMAIN_DYNAMIC,
+		.ops = &acpi_irqdomain_ops,
+	};
+
+	ioapic_id = acpi_get_ioapic_id(handle, gsi_base, &addr);
+	if (ioapic_id < 0) {
+		unsigned long long uid;
+		acpi_status status;
+
+		status = acpi_evaluate_integer(handle, METHOD_NAME__UID,
+					       NULL, &uid);
+		if (ACPI_FAILURE(status)) {
+			acpi_handle_warn(handle, "failed to get IOAPIC ID.\n");
+			return -EINVAL;
+		}
+		ioapic_id = (int)uid;
+	}
+
+	down_write(&acpi_ioapic_rwsem);
+	ret  = mp_register_ioapic(ioapic_id, phys_addr, gsi_base, &cfg);
+	up_write(&acpi_ioapic_rwsem);
+#endif
+
+	return ret;
 }
 
 EXPORT_SYMBOL(acpi_register_ioapic);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 59267659e5b1..4d9d87cc3259 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3853,7 +3853,13 @@ static int bad_ioapic_register(int idx)
 
 static int find_free_ioapic_entry(void)
 {
-	return nr_ioapics;
+	int idx;
+
+	for (idx = 0; idx < MAX_IO_APICS; idx++)
+		if (ioapics[idx].nr_registers == 0)
+			return idx;
+
+	return MAX_IO_APICS;
 }
 
 /**
@@ -3869,6 +3875,7 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
 	u32 gsi_end;
 	int idx, ioapic, entries;
 	struct mp_ioapic_gsi *gsi_cfg;
+	bool hotplug = !!ioapic_initialized;
 
 	if (!address) {
 		pr_warn("Bogus (zero) I/O APIC address found, skipping!\n");
@@ -3927,6 +3934,19 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
 	ioapics[idx].irqdomain = NULL;
 	ioapics[idx].irqdomain_cfg = *cfg;
 
+	/*
+	 * If mp_register_ioapic() is called during early boot stage when
+	 * walking ACPI/SFI/DT tables, it's too early to create irqdomain,
+	 * we are still using bootmem allocator. So delay it to setup_IO_APIC().
+	 */
+	if (hotplug) {
+		if (mp_irqdomain_create(idx)) {
+			clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+			return -ENOMEM;
+		}
+		alloc_ioapic_saved_registers(idx);
+	}
+
 	if (gsi_cfg->gsi_end >= gsi_top)
 		gsi_top = gsi_cfg->gsi_end + 1;
 	if (nr_ioapics <= idx)
-- 
1.7.10.4

