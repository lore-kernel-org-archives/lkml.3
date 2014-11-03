Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaKCLCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:02:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48271 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaKCLCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:02:05 -0500
Date: Mon, 3 Nov 2014 03:00:33 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-ff6213974cd90e1ebf9a153c74e6b0da647092b2@git.kernel.org>
Cc: bhelgaas@google.com, bp@alien8.de, rjw@rjwysocki.net,
        grant.likely@linaro.org, jiang.liu@linux.intel.com,
        rdunlap@infradead.org, prarit@redhat.com, mingo@kernel.org,
        len.brown@intel.com, hpa@zytor.com, benh@kernel.crashing.org,
        joro@8bytes.org, gregkh@linuxfoundation.org, yinghai@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, pavel@ucw.cz,
        tony.luck@intel.com, konrad.wilk@oracle.com
Reply-To: jiang.liu@linux.intel.com, grant.likely@linaro.org,
        rdunlap@infradead.org, prarit@redhat.com, mingo@kernel.org,
        bhelgaas@google.com, bp@alien8.de, rjw@rjwysocki.net,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, pavel@ucw.cz,
        tony.luck@intel.com, konrad.wilk@oracle.com, hpa@zytor.com,
        len.brown@intel.com, benh@kernel.crashing.org,
        gregkh@linuxfoundation.org, yinghai@kernel.org, joro@8bytes.org
In-Reply-To: <1414387308-27148-16-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-16-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq, ACPI:
  Implement interface to support ACPI based IOAPIC hot-addition
Git-Commit-ID: ff6213974cd90e1ebf9a153c74e6b0da647092b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff6213974cd90e1ebf9a153c74e6b0da647092b2
Gitweb:     http://git.kernel.org/tip/ff6213974cd90e1ebf9a153c74e6b0da647092b2
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 13:21:45 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 11:56:08 +0100

x86, irq, ACPI: Implement interface to support ACPI based IOAPIC hot-addition

Implement acpi_register_ioapic() and enhance mp_register_ioapic()
to support ACPI based IOAPIC hot-addition.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1414387308-27148-16-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c    | 31 +++++++++++++++++++++++++++++--
 arch/x86/kernel/apic/io_apic.c | 22 +++++++++++++++++++++-
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 1a2d9d4..ee7b311 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -778,8 +778,35 @@ EXPORT_SYMBOL(acpi_unmap_lsapic);
 
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
+	mutex_lock(&acpi_ioapic_lock);
+	ret  = mp_register_ioapic(ioapic_id, phys_addr, gsi_base, &cfg);
+	mutex_unlock(&acpi_ioapic_lock);
+#endif
+
+	return ret;
 }
 
 EXPORT_SYMBOL(acpi_register_ioapic);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 090d3fe..830244d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3861,7 +3861,13 @@ static int bad_ioapic_register(int idx)
 
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
@@ -3874,6 +3880,7 @@ static int find_free_ioapic_entry(void)
 int mp_register_ioapic(int id, u32 address, u32 gsi_base,
 		       struct ioapic_domain_cfg *cfg)
 {
+	bool hotplug = !!ioapic_initialized;
 	struct mp_ioapic_gsi *gsi_cfg;
 	int idx, ioapic, entries;
 	u32 gsi_end;
@@ -3935,6 +3942,19 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
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
