Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaLSOFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:05:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45929 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaLSOFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:05:42 -0500
Date: Fri, 19 Dec 2014 06:04:37 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-5da2fd26193433006255d534b3a01eae37e58428@git.kernel.org>
Cc: konrad.wilk@oracle.com, mingo@kernel.org, bp@alien8.de,
        tony.luck@intel.com, len.brown@intel.com, jiang.liu@linux.intel.com,
        joro@8bytes.org, yinghai@kernel.org, pavel@ucw.cz,
        benh@kernel.crashing.org, hpa@zytor.com, tglx@linutronix.de,
        bhelgaas@google.com, linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        rdunlap@infradead.org, gregkh@linuxfoundation.org
Reply-To: tony.luck@intel.com, mingo@kernel.org, konrad.wilk@oracle.com,
        bp@alien8.de, benh@kernel.crashing.org, pavel@ucw.cz,
        len.brown@intel.com, yinghai@kernel.org, joro@8bytes.org,
        jiang.liu@linux.intel.com, tglx@linutronix.de, bhelgaas@google.com,
        hpa@zytor.com, rjw@rjwysocki.net, rdunlap@infradead.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1414908273-7552-15-git-send-email-jiang.liu@linux.intel.com>
References: <1414908273-7552-15-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq, ACPI:
  Introduce a mutex to protect IOAPIC operations from hotplug
Git-Commit-ID: 5da2fd26193433006255d534b3a01eae37e58428
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

Commit-ID:  5da2fd26193433006255d534b3a01eae37e58428
Gitweb:     http://git.kernel.org/tip/5da2fd26193433006255d534b3a01eae37e58428
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Sun, 2 Nov 2014 14:04:29 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:15 +0100

x86, irq, ACPI: Introduce a mutex to protect IOAPIC operations from hotplug

We are going to support ACPI based IOAPIC hotplug, so introduce a mutex
to protect IOAPIC data structures from IOAPIC hotplug. We choose to
serialize in ACPI instead of in the IOAPIC core because:

1) currently we only plan to support ACPI based IOAPIC hotplug
2) it's much more cleaner and easier
3) It does't affect IOAPIC discovered by devicetree, SFI and mpparse.

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
Link: http://lkml.kernel.org/r/1414908273-7552-15-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/acpi/boot.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6ddeba31..2d76f02 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -76,6 +76,19 @@ int acpi_fix_pin2_polarity __initdata;
 static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 #endif
 
+/*
+ * Locks related to IOAPIC hotplug
+ * Hotplug side:
+ *	->device_hotplug_lock
+ *		->acpi_ioapic_lock
+ *			->ioapic_lock
+ * Interrupt mapping side:
+ *	->acpi_ioapic_lock
+ *		->ioapic_mutex
+ *			->ioapic_lock
+ */
+static DEFINE_MUTEX(acpi_ioapic_lock);
+
 /* --------------------------------------------------------------------------
                               Boot-time Configuration
    -------------------------------------------------------------------------- */
@@ -609,8 +622,10 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
 		*irqp = gsi;
 	} else {
+		mutex_lock(&acpi_ioapic_lock);
 		irq = mp_map_gsi_to_irq(gsi,
 					IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+		mutex_unlock(&acpi_ioapic_lock);
 		if (irq < 0)
 			return -1;
 		*irqp = irq;
@@ -650,7 +665,9 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 	int irq = gsi;
 
 #ifdef CONFIG_X86_IO_APIC
+	mutex_lock(&acpi_ioapic_lock);
 	irq = mp_register_gsi(dev, gsi, trigger, polarity);
+	mutex_unlock(&acpi_ioapic_lock);
 #endif
 
 	return irq;
@@ -659,7 +676,9 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 static void acpi_unregister_gsi_ioapic(u32 gsi)
 {
 #ifdef CONFIG_X86_IO_APIC
+	mutex_lock(&acpi_ioapic_lock);
 	mp_unregister_gsi(gsi);
+	mutex_unlock(&acpi_ioapic_lock);
 #endif
 }
 
@@ -1187,7 +1206,9 @@ static void __init acpi_process_madt(void)
 			/*
 			 * Parse MADT IO-APIC entries
 			 */
+			mutex_lock(&acpi_ioapic_lock);
 			error = acpi_parse_madt_ioapic_entries();
+			mutex_unlock(&acpi_ioapic_lock);
 			if (!error) {
 				acpi_set_irq_model_ioapic();
 
