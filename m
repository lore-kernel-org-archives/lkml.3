Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbaFUVUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:20:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36277 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785AbaFUVUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:20:44 -0400
Date: Sat, 21 Jun 2014 14:14:42 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-ca7e28aa4ff34fdd6622d915682b2765453c5ddd@git.kernel.org>
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
In-Reply-To: <1402302011-23642-26-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-26-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ACPI, irq: Provide basic irqdomain support
Git-Commit-ID: ca7e28aa4ff34fdd6622d915682b2765453c5ddd
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

Commit-ID:  ca7e28aa4ff34fdd6622d915682b2765453c5ddd
Gitweb:     http://git.kernel.org/tip/ca7e28aa4ff34fdd6622d915682b2765453c5ddd
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:54 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:42 +0200

x86, ACPI, irq: Provide basic irqdomain support

Enhance ACPI driver to provide basic irqdomain support for IOAPIC.

We will build identity mapping for IOAPICs hosting legacy IRQs,
otherwise dynamically allocate IRQ numbers for IOAPIC pins on demand.

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
Link: http://lkml.kernel.org/r/1402302011-23642-26-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index f86b4ba..8d9aee1 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/dmi.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/slab.h>
 #include <linux/bootmem.h>
 #include <linux/ioport.h>
@@ -449,10 +450,16 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	return irq;
 }
 
+static struct irq_domain_ops acpi_irqdomain_ops;
+
 static int __init
 acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 {
 	struct acpi_madt_io_apic *ioapic = NULL;
+	struct ioapic_domain_cfg cfg = {
+		.type = IOAPIC_DOMAIN_DYNAMIC,
+		.ops = &acpi_irqdomain_ops,
+	};
 
 	ioapic = (struct acpi_madt_io_apic *)header;
 
@@ -461,8 +468,12 @@ acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 
 	acpi_table_print_madt_entry(header);
 
-	mp_register_ioapic(ioapic->id,
-			   ioapic->address, ioapic->global_irq_base, NULL);
+	/* Statically assign IRQ numbers for IOAPICs hosting legacy IRQs */
+	if (ioapic->global_irq_base < nr_legacy_irqs())
+		cfg.type = IOAPIC_DOMAIN_LEGACY;
+
+	mp_register_ioapic(ioapic->id, ioapic->address, ioapic->global_irq_base,
+			   &cfg);
 
 	return 0;
 }
