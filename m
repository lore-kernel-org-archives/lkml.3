Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbaFUVMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:12:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35613 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbaFUVMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:12:01 -0400
Date: Sat, 21 Jun 2014 14:10:54 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-2c0a6894df19515baf9d2bf0076a2b57c8b51efb@git.kernel.org>
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
In-Reply-To: <1402380683-32345-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402380683-32345-1-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ACPI, irq:
  Enhance error handling in function acpi_register_gsi()
Git-Commit-ID: 2c0a6894df19515baf9d2bf0076a2b57c8b51efb
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

Commit-ID:  2c0a6894df19515baf9d2bf0076a2b57c8b51efb
Gitweb:     http://git.kernel.org/tip/2c0a6894df19515baf9d2bf0076a2b57c8b51efb
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 10 Jun 2014 14:11:23 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:40 +0200

x86, ACPI, irq: Enhance error handling in function acpi_register_gsi()

Function mp_register_gsi() may return error code when failed to look up
or program corresponding IOAPIC pin for GSI, so enhance acpi_register_gsi()
to handle possible error cases.

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
Link: http://lkml.kernel.org/r/1402380683-32345-1-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 392360c..298f796 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -97,6 +97,8 @@ static u32 isa_irq_to_gsi[NR_IRQS_LEGACY] __read_mostly = {
 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
 };
 
+#define	ACPI_INVALID_GSI		INT_MIN
+
 static unsigned int gsi_to_irq(unsigned int gsi)
 {
 	unsigned int irq = gsi + NR_IRQS_LEGACY;
@@ -441,7 +443,7 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
 	ret = io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
 	if (ret < 0)
-		gsi = INT_MIN;
+		gsi = ACPI_INVALID_GSI;
 
 	return gsi;
 }
@@ -666,13 +668,13 @@ int (*acpi_suspend_lowlevel)(void);
  */
 int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 {
-	unsigned int irq;
-	unsigned int plat_gsi = gsi;
+	unsigned int plat_gsi;
 
-	plat_gsi = (*__acpi_register_gsi)(dev, gsi, trigger, polarity);
-	irq = gsi_to_irq(plat_gsi);
+	plat_gsi = __acpi_register_gsi(dev, gsi, trigger, polarity);
+	if (plat_gsi != ACPI_INVALID_GSI)
+		return gsi_to_irq(plat_gsi);
 
-	return irq;
+	return -1;
 }
 EXPORT_SYMBOL_GPL(acpi_register_gsi);
 
