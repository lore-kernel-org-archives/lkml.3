Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbaBRQYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:24:43 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:58004 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbaBRQYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:24:41 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lan Tianyu <tianyu.lan@intel.com>, Joe Perches <joe@perches.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v5 1/5] ACPI / idle: Make idle_boot_override depend on x86 and ia64
Date: Wed, 19 Feb 2014 00:23:54 +0800
Message-Id: <1392740638-2479-2-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392740638-2479-1-git-send-email-hanjun.guo@linaro.org>
References: <1392740638-2479-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idle_boot_override depends on x86 and ia64 now, and we can not
foresee it will be used on ARM or ARM64, so move the code into
CONFIG_X86 and CONFIG_IA64 #ifdefs to make processor_core.c
can be compiled on ARM64.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/processor_core.c |   47 ++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 7c50a4c..4d91b32 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -19,24 +19,6 @@
 #define _COMPONENT		ACPI_PROCESSOR_COMPONENT
 ACPI_MODULE_NAME("processor_core");
 
-static int __init set_no_mwait(const struct dmi_system_id *id)
-{
-	printk(KERN_NOTICE PREFIX "%s detected - "
-		"disabling mwait for CPU C-states\n", id->ident);
-	boot_option_idle_override = IDLE_NOMWAIT;
-	return 0;
-}
-
-static struct dmi_system_id processor_idle_dmi_table[] __initdata = {
-	{
-	set_no_mwait, "Extensa 5220", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
-	DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-	DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
-	DMI_MATCH(DMI_BOARD_NAME, "Columbia") }, NULL},
-	{},
-};
-
 static int map_lapic_id(struct acpi_subtable_header *entry,
 		 u32 acpi_id, int *apic_id)
 {
@@ -379,13 +361,40 @@ early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
 	return AE_OK;
 }
 
-void __init acpi_early_processor_set_pdc(void)
+#if defined(CONFIG_X86) || defined(CONFIG_IA64)
+static int __init set_no_mwait(const struct dmi_system_id *id)
+{
+	pr_notice(PREFIX "%s detected - disabling mwait for CPU C-states\n",
+		  id->ident);
+	boot_option_idle_override = IDLE_NOMWAIT;
+	return 0;
+}
+
+static struct dmi_system_id processor_idle_dmi_table[] __initdata = {
+	{
+	set_no_mwait, "Extensa 5220", {
+	DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
+	DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+	DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
+	DMI_MATCH(DMI_BOARD_NAME, "Columbia") }, NULL},
+	{},
+};
+
+static void __init processor_dmi_check(void)
 {
 	/*
 	 * Check whether the system is DMI table. If yes, OSPM
 	 * should not use mwait for CPU-states.
 	 */
 	dmi_check_system(processor_idle_dmi_table);
+}
+#else
+static inline void processor_dmi_check(void) {}
+#endif
+
+void __init acpi_early_processor_set_pdc(void)
+{
+	processor_dmi_check();
 
 	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX,
-- 
1.7.9.5

