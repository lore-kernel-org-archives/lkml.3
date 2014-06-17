Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbaFQF21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:28:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:21181 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165AbaFQF2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:28:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,492,1400050800"; 
   d="scan'208";a="549015334"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: [RFC Patch V2 12/16] x86, irq, ACPI: implement interface to support ACPI based IOAPIC hot-addition
Date: Tue, 17 Jun 2014 13:29:51 +0800
Message-Id: <1402982995-13747-13-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement acpi_register_ioapic() and enhance mp_register_ioapic()
to support ACPI based IOAPIC hot-addition.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c    |   37 +++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/apic/io_apic.c |   27 ++++++++++++++++++++++++---
 2 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 120b573f1e96..85caf3221cde 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -768,8 +768,41 @@ EXPORT_SYMBOL(acpi_unmap_lsapic);
 
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
+	if (ioapic_id >= 0) {
+		if (addr != phys_addr) {
+			acpi_handle_warn(handle,
+				"IOAPIC physical address doesn't match.\n");
+			return -EINVAL;
+		}
+	} else  {
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
index e1cce02e9f55..d26fd3ac1b4b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3842,7 +3842,13 @@ static int bad_ioapic_register(int idx)
 
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
 
 int mp_register_ioapic(int id, u32 address, u32 gsi_base,
@@ -3858,8 +3864,15 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
 	}
 	for_each_ioapic(ioapic)
 		if (ioapics[ioapic].mp_config.apicaddr == address) {
-			pr_warn("address 0x%x conflicts with IOAPIC%d\n",
-				address, ioapic);
+			/*
+			 * IOAPIC unit may also be visible in PCI scope.
+			 * When ioapic PCI driver's probe() is called,
+			 * the IOAPIC unit may have already been initialized
+			 * at boot time.
+			 */
+			if (!ioapic_initialized)
+				pr_warn("address 0x%x conflicts with IOAPIC%d\n",
+					address, ioapic);
 			return -EEXIST;
 		}
 
@@ -3909,6 +3922,14 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
 	ioapics[idx].irqdomain = NULL;
 	ioapics[idx].irqdomain_cfg = *cfg;
 
+	if (ioapic_initialized) {
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

