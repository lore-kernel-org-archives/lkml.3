Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaE0IWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:22:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:31879 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbaE0IW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:22:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="scan'208";a="545380704"
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
Subject: [RFC Patch V1 3/4] x86, irq, ACPI: implement interface to support ACPI based IOAPIC hot-addition
Date: Tue, 27 May 2014 16:24:36 +0800
Message-Id: <1401179077-2020-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401179077-2020-1-git-send-email-jiang.liu@linux.intel.com>
References: <1401179077-2020-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement acpi_register_ioapic() and enhance mp_register_ioapic()
to support ACPI based IOAPIC hot-addition.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c    |   18 ++++++++++++++++--
 arch/x86/kernel/apic/io_apic.c |   24 +++++++++++++++++++++---
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index a1b388e88bcb..d807e16f8fec 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -655,8 +655,22 @@ EXPORT_SYMBOL(acpi_unmap_lsapic);
 
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base)
 {
-	/* TBD */
-	return -EINVAL;
+	int ret = -ENOSYS;
+#ifdef CONFIG_X86_IO_APIC
+	unsigned long long uid;
+	acpi_status status;
+
+	status = acpi_evaluate_integer(handle, METHOD_NAME__UID, NULL, &uid);
+	if (ACPI_FAILURE(status))
+		uid = 0;
+
+	down_write(&acpi_ioapic_rwsem);
+	ret  = mp_register_ioapic((int)uid, phys_addr, gsi_base,
+				  acpi_create_irqdomain, NULL);
+	up_write(&acpi_ioapic_rwsem);
+#endif
+
+	return ret;
 }
 
 EXPORT_SYMBOL(acpi_register_ioapic);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f70fa239f34b..4bddff760ff4 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3802,7 +3802,13 @@ static int bad_ioapic_register(int idx)
 
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
@@ -3818,8 +3824,15 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
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
 
@@ -3875,6 +3888,11 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
 	if (nr_ioapics <= idx)
 		nr_ioapics = idx + 1;
 
+	if (ioapic_initialized && ioapic_create_irqdomain(idx)) {
+		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+		return -ENOMEM;
+	}
+
 	/* Set nr_registers to mark entry present */
 	ioapics[idx].nr_registers = entries;
 
-- 
1.7.10.4

