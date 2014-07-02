Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaGBIsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:48:45 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:39109 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaGBIsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:48:39 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 3/4] ACPI / processor: Introduce ARCH_HAS_ACPI_PDC
Date: Wed,  2 Jul 2014 16:47:25 +0800
Message-Id: <1404290847-7671-4-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404290847-7671-1-git-send-email-hanjun.guo@linaro.org>
References: <1404290847-7671-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of _PDC is deprecated in ACPI 3.0 in favor of _OSC,
as ARM platform is supported only in ACPI 5.0 or higher version,
_PDC will not be used in ARM platform, so make Make _PDC only for
platforms with Intel CPUs.

Introduce ARCH_HAS_ACPI_PDC and move _PDC related code in ACPI
processor driver into a single file processor_pdc.c, make x86
and ia64 select ARCH_HAS_ACPI_PDC when ACPI is enabled.

This patch also use pr_* to replace printk to fix the checkpatch
warning and factor acpi_processor_alloc_pdc() a little bit to
avoid duplicate pr_err() code.

Suggested-by: Robert Richter <rric@kernel.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/ia64/Kconfig             |    1 +
 arch/x86/Kconfig              |    1 +
 drivers/acpi/Kconfig          |   10 ++
 drivers/acpi/Makefile         |    1 +
 drivers/acpi/internal.h       |    5 +
 drivers/acpi/processor_core.c |  198 ---------------------------------------
 drivers/acpi/processor_pdc.c  |  206 +++++++++++++++++++++++++++++++++++++++++
 7 files changed, 224 insertions(+), 198 deletions(-)
 create mode 100644 drivers/acpi/processor_pdc.c

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index f82b352..cde2626 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -10,6 +10,7 @@ config IA64
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select PCI if (!IA64_HP_SIM)
 	select ACPI if (!IA64_HP_SIM)
+	select ARCH_HAS_ACPI_PDC if ACPI
 	select PM if (!IA64_HP_SIM)
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4865d44..d60cec7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -21,6 +21,7 @@ config X86_64
 ### Arch settings
 config X86
 	def_bool y
+	select ARCH_HAS_ACPI_PDC if ACPI
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 70eaf7a..0e6f72d 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -367,6 +367,16 @@ config ACPI_REDUCED_HARDWARE_ONLY
 
 	If you are unsure what to do, do not enable this option.
 
+config ARCH_HAS_ACPI_PDC
+	bool
+	help
+	  The _PDC object provides OSPM a mechanism to convey to the platform
+	  the capabilities supported by OSPM for processor power management.
+	  This allows the platform to modify the ACPI namespace objects returning
+	  configuration information for processor power management based on the
+	  level of support provided by OSPM.The use of _PDC is deprecated in
+	  ACPI 3.0 in favor of _OSC.
+
 source "drivers/acpi/apei/Kconfig"
 
 config ACPI_EXTLOG
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index ea55e01..b638e95 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -36,6 +36,7 @@ acpi-y				+= scan.o
 acpi-y				+= resource.o
 acpi-y				+= acpi_processor.o
 acpi-y				+= processor_core.o
+acpi-$(CONFIG_ARCH_HAS_ACPI_PDC) += processor_pdc.o
 acpi-y				+= ec.o
 acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
 acpi-y				+= pci_root.o pci_link.o pci_irq.o
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 7de5b60..d7376ee 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -108,7 +108,12 @@ int acpi_power_transition(struct acpi_device *device, int state);
 int acpi_device_update_power(struct acpi_device *device, int *state_p);
 
 int acpi_wakeup_device_init(void);
+
+#ifdef CONFIG_ARCH_HAS_ACPI_PDC
 void acpi_early_processor_set_pdc(void);
+#else
+static inline void acpi_early_processor_set_pdc(void) {}
+#endif
 
 /* --------------------------------------------------------------------------
                                   Embedded Controller
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 71e2065..00f48d1 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -4,17 +4,11 @@
  *
  *	Alex Chiang <achiang@hp.com>
  *	- Unified x86/ia64 implementations
- *	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
- *	- Added _PDC for platforms with Intel CPUs
  */
 #include <linux/export.h>
-#include <linux/dmi.h>
-#include <linux/slab.h>
 #include <linux/acpi.h>
 #include <acpi/processor.h>
 
-#include "internal.h"
-
 #define _COMPONENT		ACPI_PROCESSOR_COMPONENT
 ACPI_MODULE_NAME("processor_core");
 
@@ -208,195 +202,3 @@ int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
 	return acpi_map_cpuid(apic_id, acpi_id);
 }
 EXPORT_SYMBOL_GPL(acpi_get_cpuid);
-
-static bool __init processor_physically_present(acpi_handle handle)
-{
-	int cpuid, type;
-	u32 acpi_id;
-	acpi_status status;
-	acpi_object_type acpi_type;
-	unsigned long long tmp;
-	union acpi_object object = { 0 };
-	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
-
-	status = acpi_get_type(handle, &acpi_type);
-	if (ACPI_FAILURE(status))
-		return false;
-
-	switch (acpi_type) {
-	case ACPI_TYPE_PROCESSOR:
-		status = acpi_evaluate_object(handle, NULL, NULL, &buffer);
-		if (ACPI_FAILURE(status))
-			return false;
-		acpi_id = object.processor.proc_id;
-		break;
-	case ACPI_TYPE_DEVICE:
-		status = acpi_evaluate_integer(handle, "_UID", NULL, &tmp);
-		if (ACPI_FAILURE(status))
-			return false;
-		acpi_id = tmp;
-		break;
-	default:
-		return false;
-	}
-
-	type = (acpi_type == ACPI_TYPE_DEVICE) ? 1 : 0;
-	cpuid = acpi_get_cpuid(handle, type, acpi_id);
-
-	if (cpuid == -1)
-		return false;
-
-	return true;
-}
-
-static void acpi_set_pdc_bits(u32 *buf)
-{
-	buf[0] = ACPI_PDC_REVISION_ID;
-	buf[1] = 1;
-
-	/* Enable coordination with firmware's _TSD info */
-	buf[2] = ACPI_PDC_SMP_T_SWCOORD;
-
-	/* Twiddle arch-specific bits needed for _PDC */
-	arch_acpi_set_pdc_bits(buf);
-}
-
-static struct acpi_object_list *acpi_processor_alloc_pdc(void)
-{
-	struct acpi_object_list *obj_list;
-	union acpi_object *obj;
-	u32 *buf;
-
-	/* allocate and initialize pdc. It will be used later. */
-	obj_list = kmalloc(sizeof(struct acpi_object_list), GFP_KERNEL);
-	if (!obj_list) {
-		printk(KERN_ERR "Memory allocation error\n");
-		return NULL;
-	}
-
-	obj = kmalloc(sizeof(union acpi_object), GFP_KERNEL);
-	if (!obj) {
-		printk(KERN_ERR "Memory allocation error\n");
-		kfree(obj_list);
-		return NULL;
-	}
-
-	buf = kmalloc(12, GFP_KERNEL);
-	if (!buf) {
-		printk(KERN_ERR "Memory allocation error\n");
-		kfree(obj);
-		kfree(obj_list);
-		return NULL;
-	}
-
-	acpi_set_pdc_bits(buf);
-
-	obj->type = ACPI_TYPE_BUFFER;
-	obj->buffer.length = 12;
-	obj->buffer.pointer = (u8 *) buf;
-	obj_list->count = 1;
-	obj_list->pointer = obj;
-
-	return obj_list;
-}
-
-/*
- * _PDC is required for a BIOS-OS handshake for most of the newer
- * ACPI processor features.
- */
-static acpi_status
-acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
-{
-	acpi_status status = AE_OK;
-
-	if (boot_option_idle_override == IDLE_NOMWAIT) {
-		/*
-		 * If mwait is disabled for CPU C-states, the C2C3_FFH access
-		 * mode will be disabled in the parameter of _PDC object.
-		 * Of course C1_FFH access mode will also be disabled.
-		 */
-		union acpi_object *obj;
-		u32 *buffer = NULL;
-
-		obj = pdc_in->pointer;
-		buffer = (u32 *)(obj->buffer.pointer);
-		buffer[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
-
-	}
-	status = acpi_evaluate_object(handle, "_PDC", pdc_in, NULL);
-
-	if (ACPI_FAILURE(status))
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-		    "Could not evaluate _PDC, using legacy perf. control.\n"));
-
-	return status;
-}
-
-void acpi_processor_set_pdc(acpi_handle handle)
-{
-	struct acpi_object_list *obj_list;
-
-	if (arch_has_acpi_pdc() == false)
-		return;
-
-	obj_list = acpi_processor_alloc_pdc();
-	if (!obj_list)
-		return;
-
-	acpi_processor_eval_pdc(handle, obj_list);
-
-	kfree(obj_list->pointer->buffer.pointer);
-	kfree(obj_list->pointer);
-	kfree(obj_list);
-}
-
-static acpi_status __init
-early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
-{
-	if (processor_physically_present(handle) == false)
-		return AE_OK;
-
-	acpi_processor_set_pdc(handle);
-	return AE_OK;
-}
-
-#if defined(CONFIG_X86) || defined(CONFIG_IA64)
-static int __init set_no_mwait(const struct dmi_system_id *id)
-{
-	pr_notice(PREFIX "%s detected - disabling mwait for CPU C-states\n",
-		  id->ident);
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
-static void __init processor_dmi_check(void)
-{
-	/*
-	 * Check whether the system is DMI table. If yes, OSPM
-	 * should not use mwait for CPU-states.
-	 */
-	dmi_check_system(processor_idle_dmi_table);
-}
-#else
-static inline void processor_dmi_check(void) {}
-#endif
-
-void __init acpi_early_processor_set_pdc(void)
-{
-	processor_dmi_check();
-
-	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
-			    ACPI_UINT32_MAX,
-			    early_init_pdc, NULL, NULL, NULL);
-	acpi_get_devices(ACPI_PROCESSOR_DEVICE_HID, early_init_pdc, NULL, NULL);
-}
diff --git a/drivers/acpi/processor_pdc.c b/drivers/acpi/processor_pdc.c
new file mode 100644
index 0000000..e5dd808
--- /dev/null
+++ b/drivers/acpi/processor_pdc.c
@@ -0,0 +1,206 @@
+/*
+ * Copyright (C) 2005 Intel Corporation
+ * Copyright (C) 2009 Hewlett-Packard Development Company, L.P.
+ *
+ *      Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
+ *      - Added _PDC for platforms with Intel CPUs
+ */
+
+#define pr_fmt(fmt) "ACPI: " fmt
+
+#include <linux/dmi.h>
+#include <linux/slab.h>
+#include <linux/acpi.h>
+#include <acpi/processor.h>
+
+#include "internal.h"
+
+#define _COMPONENT              ACPI_PROCESSOR_COMPONENT
+ACPI_MODULE_NAME("processor_pdc");
+
+static bool __init processor_physically_present(acpi_handle handle)
+{
+	int cpuid, type;
+	u32 acpi_id;
+	acpi_status status;
+	acpi_object_type acpi_type;
+	unsigned long long tmp;
+	union acpi_object object = { 0 };
+	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
+
+	status = acpi_get_type(handle, &acpi_type);
+	if (ACPI_FAILURE(status))
+		return false;
+
+	switch (acpi_type) {
+	case ACPI_TYPE_PROCESSOR:
+		status = acpi_evaluate_object(handle, NULL, NULL, &buffer);
+		if (ACPI_FAILURE(status))
+			return false;
+		acpi_id = object.processor.proc_id;
+		break;
+	case ACPI_TYPE_DEVICE:
+		status = acpi_evaluate_integer(handle, "_UID", NULL, &tmp);
+		if (ACPI_FAILURE(status))
+			return false;
+		acpi_id = tmp;
+		break;
+	default:
+		return false;
+	}
+
+	type = (acpi_type == ACPI_TYPE_DEVICE) ? 1 : 0;
+	cpuid = acpi_get_cpuid(handle, type, acpi_id);
+
+	if (cpuid == -1)
+		return false;
+
+	return true;
+}
+
+static void acpi_set_pdc_bits(u32 *buf)
+{
+	buf[0] = ACPI_PDC_REVISION_ID;
+	buf[1] = 1;
+
+	/* Enable coordination with firmware's _TSD info */
+	buf[2] = ACPI_PDC_SMP_T_SWCOORD;
+
+	/* Twiddle arch-specific bits needed for _PDC */
+	arch_acpi_set_pdc_bits(buf);
+}
+
+static struct acpi_object_list *acpi_processor_alloc_pdc(void)
+{
+	struct acpi_object_list *obj_list;
+	union acpi_object *obj;
+	u32 *buf;
+
+	/* allocate and initialize pdc. It will be used later. */
+	obj_list = kmalloc(sizeof(struct acpi_object_list), GFP_KERNEL);
+	if (!obj_list)
+		goto out;
+
+	obj = kmalloc(sizeof(union acpi_object), GFP_KERNEL);
+	if (!obj) {
+		kfree(obj_list);
+		goto out;
+	}
+
+	buf = kmalloc(12, GFP_KERNEL);
+	if (!buf) {
+		kfree(obj);
+		kfree(obj_list);
+		goto out;
+	}
+
+	acpi_set_pdc_bits(buf);
+
+	obj->type = ACPI_TYPE_BUFFER;
+	obj->buffer.length = 12;
+	obj->buffer.pointer = (u8 *) buf;
+	obj_list->count = 1;
+	obj_list->pointer = obj;
+
+	return obj_list;
+out:
+	pr_err("Memory allocation error\n");
+	return NULL;
+}
+
+/*
+ * _PDC is required for a BIOS-OS handshake for most of the newer
+ * ACPI processor features.
+ */
+static acpi_status
+acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
+{
+	acpi_status status = AE_OK;
+
+	if (boot_option_idle_override == IDLE_NOMWAIT) {
+		/*
+		 * If mwait is disabled for CPU C-states, the C2C3_FFH access
+		 * mode will be disabled in the parameter of _PDC object.
+		 * Of course C1_FFH access mode will also be disabled.
+		 */
+		union acpi_object *obj;
+		u32 *buffer = NULL;
+
+		obj = pdc_in->pointer;
+		buffer = (u32 *)(obj->buffer.pointer);
+		buffer[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
+
+	}
+	status = acpi_evaluate_object(handle, "_PDC", pdc_in, NULL);
+
+	if (ACPI_FAILURE(status))
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+		    "Could not evaluate _PDC, using legacy perf. control.\n"));
+
+	return status;
+}
+
+void acpi_processor_set_pdc(acpi_handle handle)
+{
+	struct acpi_object_list *obj_list;
+
+	if (arch_has_acpi_pdc() == false)
+		return;
+
+	obj_list = acpi_processor_alloc_pdc();
+	if (!obj_list)
+		return;
+
+	acpi_processor_eval_pdc(handle, obj_list);
+
+	kfree(obj_list->pointer->buffer.pointer);
+	kfree(obj_list->pointer);
+	kfree(obj_list);
+}
+
+static acpi_status __init
+early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
+{
+	if (processor_physically_present(handle) == false)
+		return AE_OK;
+
+	acpi_processor_set_pdc(handle);
+	return AE_OK;
+}
+
+static int __init set_no_mwait(const struct dmi_system_id *id)
+{
+	pr_notice("%s detected - disabling mwait for CPU C-states\n",
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
+{
+	/*
+	 * Check whether the system is DMI table. If yes, OSPM
+	 * should not use mwait for CPU-states.
+	 */
+	dmi_check_system(processor_idle_dmi_table);
+}
+
+void __init acpi_early_processor_set_pdc(void)
+{
+	processor_dmi_check();
+
+	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
+			    ACPI_UINT32_MAX,
+			    early_init_pdc, NULL, NULL, NULL);
+	acpi_get_devices(ACPI_PROCESSOR_DEVICE_HID, early_init_pdc, NULL, NULL);
+}
-- 
1.7.9.5

