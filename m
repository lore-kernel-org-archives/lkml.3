Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934996Ab3FSR5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:57:54 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:34280 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869Ab3FSR5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:57:52 -0400
Subject: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff mode
 for corrected errors
To: tony.luck@intel.com, bp@alien8.de
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: ananth@in.ibm.com, masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        ying.huang@intel.com
Date: Wed, 19 Jun 2013 23:27:42 +0530
Message-ID: <20130619175728.2852.73156.stgit@localhost.localdomain>
In-Reply-To: <20130619175438.2852.93449.stgit@localhost.localdomain>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061917-3864-0000-0000-000008B4F0C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a boot option to disable firmware first mode for corrected errors.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 Documentation/x86/x86_64/boot-options.txt |    5 +++++
 arch/x86/include/asm/acpi.h               |    2 ++
 arch/x86/kernel/acpi/boot.c               |    5 +++++
 drivers/acpi/apei/hest.c                  |    3 ++-
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index e9e8ddb..1228b22 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -176,6 +176,11 @@ ACPI
 
   acpi=noirq	Don't route interrupts
 
+  acpi=nocmcff	Disable firmware first mode for corrected errors. This
+		disables parsing the HEST CMC error source to check if
+		firmware has set the FF flag. This may result in
+		duplicate corrected error reports.
+
 PCI
 
   pci=off		Don't use PCI
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index b31bf97..42db2b8 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -86,6 +86,7 @@ extern int acpi_pci_disabled;
 extern int acpi_skip_timer_override;
 extern int acpi_use_timer_override;
 extern int acpi_fix_pin2_polarity;
+extern int acpi_disable_cmcff;
 
 extern u8 acpi_sci_flags;
 extern int acpi_sci_override_gsi;
@@ -168,6 +169,7 @@ static inline void arch_acpi_set_pdc_bits(u32 *buf)
 
 #define acpi_lapic 0
 #define acpi_ioapic 0
+#define acpi_disable_cmcff 0
 static inline void acpi_noirq_set(void) { }
 static inline void acpi_disable_pci(void) { }
 static inline void disable_acpi(void) { }
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 230c8ea..d1998d5 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -66,6 +66,7 @@ EXPORT_SYMBOL(acpi_pci_disabled);
 int acpi_lapic;
 int acpi_ioapic;
 int acpi_strict;
+int acpi_disable_cmcff;
 
 u8 acpi_sci_flags __initdata;
 int acpi_sci_override_gsi __initdata;
@@ -1619,6 +1620,10 @@ static int __init parse_acpi(char *arg)
 	/* "acpi=copy_dsdt" copys DSDT */
 	else if (strcmp(arg, "copy_dsdt") == 0) {
 		acpi_gbl_copy_dsdt_locally = 1;
+	}
+	/* "acpi=nocmcff" disables FF mode for corrected errors */
+	else if (strcmp(arg, "nocmcff") == 0) {
+		acpi_disable_cmcff = 1;
 	} else {
 		/* Core will printk when we return error. */
 		return -EINVAL;
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index d8c69ba..f8b1115 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -261,7 +261,8 @@ void __init acpi_hest_init(void)
 		goto err;
 	}
 
-	apei_hest_parse(hest_parse_cmc, NULL);
+	if (!acpi_disable_cmcff)
+		apei_hest_parse(hest_parse_cmc, NULL);
 
 	if (!ghes_disable) {
 		rc = apei_hest_parse(hest_parse_ghes_count, &ghes_count);

