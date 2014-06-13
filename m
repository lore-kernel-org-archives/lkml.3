Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaFMLEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 07:04:40 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60845 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaFMLDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 07:03:24 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de
Cc: linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        rric@kernel.org, Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH v3 1/5] apei, mce: Factor out APEI architecture specific MCE calls.
Date: Fri, 13 Jun 2014 13:02:56 +0200
Message-Id: <1402657380-18539-2-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit abstracts MCE calls and provides weak corresponding default
implementation for those architectures which do not need arch specific
actions. Each platform willing to do additional architectural actions
should provides desired function definition. It allows us to avoid wrap
code into #ifdef in generic code and prevent new platform from introducing
dummy stub function too.

Initially, there are two APEI arch-specific calls:
- apei_arch_enable_cmcff()
- apei_arch_report_mem_error()
Both interact with MCE driver for X86 architecture.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 arch/x86/kernel/acpi/Makefile |    1 +
 arch/x86/kernel/acpi/apei.c   |   56 +++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/apei/apei-base.c |   13 ++++++++++
 drivers/acpi/apei/ghes.c      |    6 ++---
 drivers/acpi/apei/hest.c      |   29 +--------------------
 include/acpi/apei.h           |    3 +++
 6 files changed, 76 insertions(+), 32 deletions(-)
 create mode 100644 arch/x86/kernel/acpi/apei.c

diff --git a/arch/x86/kernel/acpi/Makefile b/arch/x86/kernel/acpi/Makefile
index 163b225..3242e59 100644
--- a/arch/x86/kernel/acpi/Makefile
+++ b/arch/x86/kernel/acpi/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_ACPI)		+= boot.o
 obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup_$(BITS).o
+obj-$(CONFIG_ACPI_APEI)		+= apei.o
 
 ifneq ($(CONFIG_ACPI_PROCESSOR),)
 obj-y				+= cstate.o
diff --git a/arch/x86/kernel/acpi/apei.c b/arch/x86/kernel/acpi/apei.c
new file mode 100644
index 0000000..dca2852
--- /dev/null
+++ b/arch/x86/kernel/acpi/apei.c
@@ -0,0 +1,56 @@
+/*
+ * Arch-specific APEI-related functions.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <acpi/apei.h>
+
+#include <asm/mce.h>
+
+int apei_arch_enable_cmcff(struct acpi_hest_header *hest_hdr, void *data)
+{
+#ifdef CONFIG_X86_MCE
+	int i;
+	struct acpi_hest_ia_corrected *cmc;
+	struct acpi_hest_ia_error_bank *mc_bank;
+
+	if (hest_hdr->type != ACPI_HEST_TYPE_IA32_CORRECTED_CHECK)
+		return 0;
+
+	cmc = (struct acpi_hest_ia_corrected *)hest_hdr;
+	if (!cmc->enabled)
+		return 0;
+
+	/*
+	 * We expect HEST to provide a list of MC banks that report errors
+	 * in firmware first mode. Otherwise, return non-zero value to
+	 * indicate that we are done parsing HEST.
+	 */
+	if (!(cmc->flags & ACPI_HEST_FIRMWARE_FIRST) ||
+	    !cmc->num_hardware_banks)
+		return 1;
+
+	pr_info("HEST: Enabling Firmware First mode for corrected errors.\n");
+
+	mc_bank = (struct acpi_hest_ia_error_bank *)(cmc + 1);
+	for (i = 0; i < cmc->num_hardware_banks; i++, mc_bank++)
+		mce_disable_bank(mc_bank->bank_number);
+#endif
+	return 1;
+}
+
+void apei_arch_report_mem_error(int sev, struct cper_sec_mem_err *mem_err)
+{
+#ifdef CONFIG_X86_MCE
+	apei_mce_report_mem_error(sev, mem_err);
+#endif
+}
diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 8678dfe..4a11c1a 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -745,6 +745,19 @@ struct dentry *apei_get_debugfs_dir(void)
 }
 EXPORT_SYMBOL_GPL(apei_get_debugfs_dir);
 
+int __weak apei_arch_enable_cmcff(struct acpi_hest_header *hest_hdr,
+				  void *data)
+{
+	return 1;
+}
+EXPORT_SYMBOL_GPL(apei_arch_enable_cmcff);
+
+void __weak apei_arch_report_mem_error(int sev,
+				       struct cper_sec_mem_err *mem_err)
+{
+}
+EXPORT_SYMBOL_GPL(apei_arch_report_mem_error);
+
 int apei_osc_setup(void)
 {
 	static u8 whea_uuid_str[] = "ed855e0c-6c90-47bf-a62a-26de0fc5ad5c";
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index dab7cb7..e7dc5c6 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -49,7 +49,7 @@
 #include <linux/aer.h>
 
 #include <acpi/ghes.h>
-#include <asm/mce.h>
+#include <acpi/apei.h>
 #include <asm/tlbflush.h>
 #include <asm/nmi.h>
 
@@ -455,9 +455,7 @@ static void ghes_do_proc(struct ghes *ghes,
 			mem_err = (struct cper_sec_mem_err *)(gdata+1);
 			ghes_edac_report_mem_error(ghes, sev, mem_err);
 
-#ifdef CONFIG_X86_MCE
-			apei_mce_report_mem_error(sev, mem_err);
-#endif
+			apei_arch_report_mem_error(sev, mem_err);
 			ghes_handle_memory_failure(gdata, sev);
 		}
 #ifdef CONFIG_ACPI_APEI_PCIEAER
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index f5e37f3..edf26bc 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -36,7 +36,6 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <acpi/apei.h>
-#include <asm/mce.h>
 
 #include "apei-internal.h"
 
@@ -128,33 +127,7 @@ EXPORT_SYMBOL_GPL(apei_hest_parse);
  */
 static int __init hest_parse_cmc(struct acpi_hest_header *hest_hdr, void *data)
 {
-#ifdef CONFIG_X86_MCE
-	int i;
-	struct acpi_hest_ia_corrected *cmc;
-	struct acpi_hest_ia_error_bank *mc_bank;
-
-	if (hest_hdr->type != ACPI_HEST_TYPE_IA32_CORRECTED_CHECK)
-		return 0;
-
-	cmc = (struct acpi_hest_ia_corrected *)hest_hdr;
-	if (!cmc->enabled)
-		return 0;
-
-	/*
-	 * We expect HEST to provide a list of MC banks that report errors
-	 * in firmware first mode. Otherwise, return non-zero value to
-	 * indicate that we are done parsing HEST.
-	 */
-	if (!(cmc->flags & ACPI_HEST_FIRMWARE_FIRST) || !cmc->num_hardware_banks)
-		return 1;
-
-	pr_info(HEST_PFX "Enabling Firmware First mode for corrected errors.\n");
-
-	mc_bank = (struct acpi_hest_ia_error_bank *)(cmc + 1);
-	for (i = 0; i < cmc->num_hardware_banks; i++, mc_bank++)
-		mce_disable_bank(mc_bank->bank_number);
-#endif
-	return 1;
+	return apei_arch_enable_cmcff(hest_hdr, data);
 }
 
 struct ghes_arr {
diff --git a/include/acpi/apei.h b/include/acpi/apei.h
index 04f349d..62b9d1c 100644
--- a/include/acpi/apei.h
+++ b/include/acpi/apei.h
@@ -42,5 +42,8 @@ ssize_t erst_read(u64 record_id, struct cper_record_header *record,
 		  size_t buflen);
 int erst_clear(u64 record_id);
 
+int apei_arch_enable_cmcff(struct acpi_hest_header *hest_hdr, void *data);
+void apei_arch_report_mem_error(int sev, struct cper_sec_mem_err *mem_err);
+
 #endif
 #endif
-- 
1.7.9.5

