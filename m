Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbaFUVPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:15:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35867 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758488AbaFUVPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:15:05 -0400
Date: Sat, 21 Jun 2014 14:14:03 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-84245af7297ced9e8fe837dc0fc4782438771bd2@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, pavel@ucw.cz, benh@kernel.crashing.org,
        bhelgaas@google.com, rjw@rjwysocki.net, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, pavel@ucw.cz, benh@kernel.crashing.org,
        bhelgaas@google.com, rjw@rjwysocki.net, paul.gortmaker@windriver.com
In-Reply-To: <1402380887-32512-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402380887-32512-1-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq, ACPI:
  Change __acpi_register_gsi to return IRQ number instead of GSI
Git-Commit-ID: 84245af7297ced9e8fe837dc0fc4782438771bd2
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

Commit-ID:  84245af7297ced9e8fe837dc0fc4782438771bd2
Gitweb:     http://git.kernel.org/tip/84245af7297ced9e8fe837dc0fc4782438771bd2
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 10 Jun 2014 14:14:47 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:42 +0200

x86, irq, ACPI: Change __acpi_register_gsi to return IRQ number instead of GSI

Currently __acpi_register_gsi is defined to return GSI number and
may be set to acpi_register_gsi_pic(), acpi_register_gsi_ioapic(),
acpi_register_gsi_xen_hvm() and acpi_register_gsi_xen().

Among which, acpi_register_gsi_ioapic() returns GSI number, but
acpi_register_gsi_xen_hvm() and acpi_register_gsi_xen() actually
returns IRQ number instead of GSI. And for acpi_register_gsi_pic(),
GSI number equals to IRQ number.

So change acpi_register_gsi_ioapic() to return IRQ number, it also
simplifies the code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Link: http://lkml.kernel.org/r/1402380887-32512-1-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 9965afb..0cf311c 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -419,7 +419,7 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 
 	irq = map_gsi_to_irq(gsi);
 	if (irq < 0)
-		return ACPI_INVALID_GSI;
+		return irq;
 
 	ioapic = mp_find_ioapic(gsi);
 	if (ioapic < 0) {
@@ -444,12 +444,11 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
 	ret = io_apic_set_pci_routing(dev, irq, &irq_attr);
 	if (ret < 0)
-		gsi = ACPI_INVALID_GSI;
+		irq = -1;
 
-	return gsi;
+	return irq;
 }
 
-
 static int __init
 acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 {
@@ -652,11 +651,13 @@ static int acpi_register_gsi_pic(struct device *dev, u32 gsi,
 static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 				    int trigger, int polarity)
 {
+	int irq = gsi;
+
 #ifdef CONFIG_X86_IO_APIC
-	gsi = mp_register_gsi(dev, gsi, trigger, polarity);
+	irq = mp_register_gsi(dev, gsi, trigger, polarity);
 #endif
 
-	return gsi;
+	return irq;
 }
 
 int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
@@ -674,13 +675,7 @@ int (*acpi_suspend_lowlevel)(void);
  */
 int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 {
-	unsigned int plat_gsi;
-
-	plat_gsi = __acpi_register_gsi(dev, gsi, trigger, polarity);
-	if (plat_gsi != ACPI_INVALID_GSI)
-		return map_gsi_to_irq(plat_gsi);
-
-	return -1;
+	return __acpi_register_gsi(dev, gsi, trigger, polarity);
 }
 EXPORT_SYMBOL_GPL(acpi_register_gsi);
 
