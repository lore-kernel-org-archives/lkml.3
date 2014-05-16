Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaEPUnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:43:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16650 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbaEPUns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:43:48 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, eshelton@pobox.com,
        hpa@zytor.com, ian.campbell@citrix.com, jbeulich@suse.com,
        jeremy@goop.org, konrad.wilk@oracle.com, matt.fleming@intel.com,
        mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: [PATCH v4 3/5] xen: Put EFI machinery in place
Date: Fri, 16 May 2014 22:41:42 +0200
Message-Id: <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put EFI machinery for Xen in place.

This patch is based on Jan Beulich and Tang Liang work.

v4 - suggestions/fixes:
   - "just populate an efi_system_table_t object"
     (suggested by Matt Fleming).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Tang Liang <liang.tang@oracle.com>
Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/xen/enlighten.c |   26 ++++
 drivers/xen/Kconfig      |    3 +
 drivers/xen/Makefile     |    1 +
 drivers/xen/efi.c        |  374 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 404 insertions(+)
 create mode 100644 drivers/xen/efi.c

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c34bfc4..d5cc21f 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -32,6 +32,7 @@
 #include <linux/gfp.h>
 #include <linux/memblock.h>
 #include <linux/edd.h>
+#include <linux/efi.h>
 
 #include <xen/xen.h>
 #include <xen/events.h>
@@ -150,6 +151,15 @@ struct shared_info *HYPERVISOR_shared_info = &xen_dummy_shared_info;
  */
 static int have_vcpu_info_placement = 1;
 
+#ifdef CONFIG_XEN_EFI
+extern efi_system_table_t __init *xen_efi_probe(void);
+#else
+static efi_system_table_t __init *xen_efi_probe(void)
+{
+	return NULL;
+}
+#endif
+
 struct tls_descs {
 	struct desc_struct desc[3];
 };
@@ -1519,6 +1529,7 @@ asmlinkage __visible void __init xen_start_kernel(void)
 {
 	struct physdev_set_iopl set_iopl;
 	int rc;
+	efi_system_table_t *efi_systab_xen;
 
 	if (!xen_start_info)
 		return;
@@ -1714,6 +1725,21 @@ asmlinkage __visible void __init xen_start_kernel(void)
 
 	xen_setup_runstate_info(0);
 
+	efi_systab_xen = xen_efi_probe();
+
+	if (efi_systab_xen) {
+		strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
+				sizeof(boot_params.efi_info.efi_loader_signature));
+		boot_params.efi_info.efi_systab = (__u32)((__u64)efi_systab_xen);
+		boot_params.efi_info.efi_systab_hi = (__u32)((__u64)efi_systab_xen >> 32);
+
+		x86_platform.get_wallclock = efi_get_time;
+		x86_platform.set_wallclock = efi_set_rtc_mmss;
+
+		set_bit(EFI_BOOT, &efi.flags);
+		set_bit(EFI_64BIT, &efi.flags);
+	}
+
 	/* Start the world */
 #ifdef CONFIG_X86_32
 	i386_start_kernel();
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 38fb36e..cead283 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -240,4 +240,7 @@ config XEN_MCE_LOG
 config XEN_HAVE_PVMMU
        bool
 
+config XEN_EFI
+	def_bool X86_64 && EFI
+
 endmenu
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 45e00af..c35de02 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_XEN_STUB)			+= xen-stub.o
 obj-$(CONFIG_XEN_ACPI_HOTPLUG_MEMORY)	+= xen-acpi-memhotplug.o
 obj-$(CONFIG_XEN_ACPI_HOTPLUG_CPU)	+= xen-acpi-cpuhotplug.o
 obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+= xen-acpi-processor.o
+obj-$(CONFIG_XEN_EFI)			+= efi.o
 xen-evtchn-y				:= evtchn.o
 xen-gntdev-y				:= gntdev.o
 xen-gntalloc-y				:= gntalloc.o
diff --git a/drivers/xen/efi.c b/drivers/xen/efi.c
new file mode 100644
index 0000000..d81458a
--- /dev/null
+++ b/drivers/xen/efi.c
@@ -0,0 +1,374 @@
+/*
+ * EFI support for Xen.
+ *
+ * Copyright (C) 1999 VA Linux Systems
+ * Copyright (C) 1999 Walt Drummond <drummond@valinux.com>
+ * Copyright (C) 1999-2002 Hewlett-Packard Co.
+ *	David Mosberger-Tang <davidm@hpl.hp.com>
+ *	Stephane Eranian <eranian@hpl.hp.com>
+ * Copyright (C) 2005-2008 Intel Co.
+ *	Fenghua Yu <fenghua.yu@intel.com>
+ *	Bibo Mao <bibo.mao@intel.com>
+ *	Chandramouli Narayanan <mouli@linux.intel.com>
+ *	Huang Ying <ying.huang@intel.com>
+ * Copyright (C) 2011 Novell Co.
+ *	Jan Beulich <JBeulich@suse.com>
+ * Copyright (C) 2011-2012 Oracle Co.
+ *	Liang Tang <liang.tang@oracle.com>
+ * Copyright (c) 2014 Daniel Kiper, Oracle Corporation
+ */
+
+#include <linux/bug.h>
+#include <linux/efi.h>
+#include <linux/init.h>
+#include <linux/string.h>
+
+#include <xen/interface/xen.h>
+#include <xen/interface/platform.h>
+
+#include <asm/xen/hypercall.h>
+
+#define call (op.u.efi_runtime_call)
+#define DECLARE_CALL(what) \
+	struct xen_platform_op op; \
+	op.cmd = XENPF_efi_runtime_call; \
+	call.function = XEN_EFI_##what; \
+	call.misc = 0
+
+static efi_status_t xen_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	int err;
+	DECLARE_CALL(get_time);
+
+	err = HYPERVISOR_dom0_op(&op);
+	if (err)
+		return EFI_UNSUPPORTED;
+
+	if (tm) {
+		BUILD_BUG_ON(sizeof(*tm) != sizeof(call.u.get_time.time));
+		memcpy(tm, &call.u.get_time.time, sizeof(*tm));
+	}
+
+	if (tc) {
+		tc->resolution = call.u.get_time.resolution;
+		tc->accuracy = call.u.get_time.accuracy;
+		tc->sets_to_zero = !!(call.misc &
+				      XEN_EFI_GET_TIME_SET_CLEARS_NS);
+	}
+
+	return call.status;
+}
+
+static efi_status_t xen_efi_set_time(efi_time_t *tm)
+{
+	DECLARE_CALL(set_time);
+
+	BUILD_BUG_ON(sizeof(*tm) != sizeof(call.u.set_time));
+	memcpy(&call.u.set_time, tm, sizeof(*tm));
+
+	return HYPERVISOR_dom0_op(&op) ? EFI_UNSUPPORTED : call.status;
+}
+
+static efi_status_t xen_efi_get_wakeup_time(efi_bool_t *enabled,
+					    efi_bool_t *pending,
+					    efi_time_t *tm)
+{
+	int err;
+	DECLARE_CALL(get_wakeup_time);
+
+	err = HYPERVISOR_dom0_op(&op);
+	if (err)
+		return EFI_UNSUPPORTED;
+
+	if (tm) {
+		BUILD_BUG_ON(sizeof(*tm) != sizeof(call.u.get_wakeup_time));
+		memcpy(tm, &call.u.get_wakeup_time, sizeof(*tm));
+	}
+
+	if (enabled)
+		*enabled = !!(call.misc & XEN_EFI_GET_WAKEUP_TIME_ENABLED);
+
+	if (pending)
+		*pending = !!(call.misc & XEN_EFI_GET_WAKEUP_TIME_PENDING);
+
+	return call.status;
+}
+
+static efi_status_t xen_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
+{
+	DECLARE_CALL(set_wakeup_time);
+
+	BUILD_BUG_ON(sizeof(*tm) != sizeof(call.u.set_wakeup_time));
+	if (enabled)
+		call.misc = XEN_EFI_SET_WAKEUP_TIME_ENABLE;
+	if (tm)
+		memcpy(&call.u.set_wakeup_time, tm, sizeof(*tm));
+	else
+		call.misc |= XEN_EFI_SET_WAKEUP_TIME_ENABLE_ONLY;
+
+	return HYPERVISOR_dom0_op(&op) ? EFI_UNSUPPORTED : call.status;
+}
+
+static efi_status_t xen_efi_get_variable(efi_char16_t *name,
+					 efi_guid_t *vendor,
+					 u32 *attr,
+					 unsigned long *data_size,
+					 void *data)
+{
+	int err;
+	DECLARE_CALL(get_variable);
+
+	set_xen_guest_handle(call.u.get_variable.name, name);
+	BUILD_BUG_ON(sizeof(*vendor) !=
+		     sizeof(call.u.get_variable.vendor_guid));
+	memcpy(&call.u.get_variable.vendor_guid, vendor, sizeof(*vendor));
+	call.u.get_variable.size = *data_size;
+	set_xen_guest_handle(call.u.get_variable.data, data);
+	err = HYPERVISOR_dom0_op(&op);
+	if (err)
+		return EFI_UNSUPPORTED;
+
+	*data_size = call.u.get_variable.size;
+	*attr = call.misc; /* misc in struction is U32 variable*/
+
+	return call.status;
+}
+
+static efi_status_t xen_efi_get_next_variable(unsigned long *name_size,
+					      efi_char16_t *name,
+					      efi_guid_t *vendor)
+{
+	int err;
+	DECLARE_CALL(get_next_variable_name);
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+	call.u.get_next_variable_name.size = *name_size;
+	set_xen_guest_handle(call.u.get_next_variable_name.name, name);
+	BUILD_BUG_ON(sizeof(*vendor) !=
+		     sizeof(call.u.get_next_variable_name.vendor_guid));
+	memcpy(&call.u.get_next_variable_name.vendor_guid, vendor,
+	       sizeof(*vendor));
+	err = HYPERVISOR_dom0_op(&op);
+	if (err)
+		return EFI_UNSUPPORTED;
+
+	*name_size = call.u.get_next_variable_name.size;
+	memcpy(vendor, &call.u.get_next_variable_name.vendor_guid,
+	       sizeof(*vendor));
+
+	return call.status;
+}
+
+static efi_status_t xen_efi_set_variable(efi_char16_t *name,
+					 efi_guid_t *vendor,
+					 u32 attr,
+					 unsigned long data_size,
+					 void *data)
+{
+	DECLARE_CALL(set_variable);
+
+	set_xen_guest_handle(call.u.set_variable.name, name);
+	call.misc = attr;
+	BUILD_BUG_ON(sizeof(*vendor) !=
+		     sizeof(call.u.set_variable.vendor_guid));
+	memcpy(&call.u.set_variable.vendor_guid, vendor, sizeof(*vendor));
+	call.u.set_variable.size = data_size;
+	set_xen_guest_handle(call.u.set_variable.data, data);
+
+	return HYPERVISOR_dom0_op(&op) ? EFI_UNSUPPORTED : call.status;
+}
+
+static efi_status_t xen_efi_query_variable_info(u32 attr,
+						u64 *storage_space,
+						u64 *remaining_space,
+						u64 *max_variable_size)
+{
+	int err;
+	DECLARE_CALL(query_variable_info);
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	err = HYPERVISOR_dom0_op(&op);
+	if (err)
+		return EFI_UNSUPPORTED;
+
+	*storage_space = call.u.query_variable_info.max_store_size;
+	*remaining_space = call.u.query_variable_info.remain_store_size;
+	*max_variable_size = call.u.query_variable_info.max_size;
+
+	return call.status;
+}
+
+static efi_status_t xen_efi_get_next_high_mono_count(u32 *count)
+{
+	int err;
+	DECLARE_CALL(get_next_high_monotonic_count);
+
+	err = HYPERVISOR_dom0_op(&op);
+	if (err)
+		return EFI_UNSUPPORTED;
+
+	*count = call.misc;
+
+	return call.status;
+}
+
+static efi_status_t xen_efi_update_capsule(efi_capsule_header_t **capsules,
+					   unsigned long count,
+					   unsigned long sg_list)
+{
+	DECLARE_CALL(update_capsule);
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	set_xen_guest_handle(call.u.update_capsule.capsule_header_array,
+			     capsules);
+	call.u.update_capsule.capsule_count = count;
+	call.u.update_capsule.sg_list = sg_list;
+
+	return HYPERVISOR_dom0_op(&op) ? EFI_UNSUPPORTED : call.status;
+}
+
+static efi_status_t xen_efi_query_capsule_caps(efi_capsule_header_t **capsules,
+					       unsigned long count,
+					       u64 *max_size,
+					       int *reset_type)
+{
+	int err;
+	DECLARE_CALL(query_capsule_capabilities);
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	set_xen_guest_handle(call.u.query_capsule_capabilities.
+		capsule_header_array, capsules);
+	call.u.query_capsule_capabilities.capsule_count = count;
+
+	err = HYPERVISOR_dom0_op(&op);
+	if (err)
+		return EFI_UNSUPPORTED;
+
+	*max_size = call.u.query_capsule_capabilities.max_capsule_size;
+	*reset_type = call.u.query_capsule_capabilities.reset_type;
+
+	return call.status;
+}
+
+#undef DECLARE_CALL
+#undef call
+
+static efi_char16_t vendor[100] __initdata;
+static const efi_char16_t unknown[] __initconst =
+			{'U', 'N', 'K', 'N', 'O', 'W', 'N', '\0'};
+
+static efi_system_table_t efi_systab_xen __initdata = {
+	.hdr = {
+		.signature	= EFI_SYSTEM_TABLE_SIGNATURE,
+		.revision	= 0, /* Initialized later. */
+		.headersize	= 0, /* Ignored by Linux Kernel. */
+		.crc32		= 0, /* Ignored by Linux Kernel. */
+		.reserved	= 0
+	},
+	.fw_vendor	= (unsigned long)unknown, /* Initialized later. */
+	.fw_revision	= 0,			  /* Initialized later. */
+	.con_in_handle	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.con_in		= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.con_out_handle	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.con_out	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.stderr_handle	= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.stderr		= EFI_INVALID_TABLE_ADDR, /* Not used under Xen. */
+	.runtime	= NULL,			  /* Not used under Xen. */
+	.boottime	= NULL,			  /* Not used under Xen. */
+	.nr_tables	= 0,			  /* Initialized later. */
+	.tables		= EFI_INVALID_TABLE_ADDR  /* Initialized later. */
+};
+
+static const struct efi efi_xen __initconst = {
+	.systab                   = NULL, /* Initialized later. */
+	.runtime_version	  = 0,    /* Initialized later. */
+	.mps                      = EFI_INVALID_TABLE_ADDR,
+	.acpi                     = EFI_INVALID_TABLE_ADDR,
+	.acpi20                   = EFI_INVALID_TABLE_ADDR,
+	.smbios                   = EFI_INVALID_TABLE_ADDR,
+	.sal_systab               = EFI_INVALID_TABLE_ADDR,
+	.boot_info                = EFI_INVALID_TABLE_ADDR,
+	.hcdp                     = EFI_INVALID_TABLE_ADDR,
+	.uga                      = EFI_INVALID_TABLE_ADDR,
+	.uv_systab                = EFI_INVALID_TABLE_ADDR,
+	.fw_vendor                = EFI_INVALID_TABLE_ADDR,
+	.runtime                  = EFI_INVALID_TABLE_ADDR,
+	.config_table             = EFI_INVALID_TABLE_ADDR,
+	.get_time                 = xen_efi_get_time,
+	.set_time                 = xen_efi_set_time,
+	.get_wakeup_time          = xen_efi_get_wakeup_time,
+	.set_wakeup_time          = xen_efi_set_wakeup_time,
+	.get_variable             = xen_efi_get_variable,
+	.get_next_variable        = xen_efi_get_next_variable,
+	.set_variable             = xen_efi_set_variable,
+	.query_variable_info      = xen_efi_query_variable_info,
+	.update_capsule           = xen_efi_update_capsule,
+	.query_capsule_caps       = xen_efi_query_capsule_caps,
+	.get_next_high_mono_count = xen_efi_get_next_high_mono_count,
+	.reset_system             = NULL, /* Functionality provided by Xen. */
+	.set_virtual_address_map  = NULL, /* Not used under Xen. */
+	.memmap                   = NULL, /* Not used under Xen. */
+	.flags			  = 0     /* Initialized later. */
+};
+
+efi_system_table_t __init *xen_efi_probe(void)
+{
+	struct xen_platform_op op = {
+		.cmd = XENPF_firmware_info,
+		.u.firmware_info = {
+			.type = XEN_FW_EFI_INFO,
+			.index = XEN_FW_EFI_CONFIG_TABLE
+		}
+	};
+	union xenpf_efi_info *info = &op.u.firmware_info.u.efi_info;
+
+	if (!xen_initial_domain() || HYPERVISOR_dom0_op(&op))
+		return NULL;
+
+	/* Here we know that Xen runs on EFI platform. */
+
+	efi = efi_xen;
+
+	op.cmd = XENPF_firmware_info;
+	op.u.firmware_info.type = XEN_FW_EFI_INFO;
+	op.u.firmware_info.index = XEN_FW_EFI_VENDOR;
+	info->vendor.bufsz = sizeof(vendor);
+	set_xen_guest_handle(info->vendor.name, vendor);
+
+	if (!HYPERVISOR_dom0_op(&op)) {
+		efi_systab_xen.fw_vendor = (unsigned long)vendor;
+		efi_systab_xen.fw_revision = info->vendor.revision;
+	}
+
+	op.cmd = XENPF_firmware_info;
+	op.u.firmware_info.type = XEN_FW_EFI_INFO;
+	op.u.firmware_info.index = XEN_FW_EFI_VERSION;
+
+	if (!HYPERVISOR_dom0_op(&op))
+		efi_systab_xen.hdr.revision = info->version;
+
+	op.cmd = XENPF_firmware_info;
+	op.u.firmware_info.type = XEN_FW_EFI_INFO;
+	op.u.firmware_info.index = XEN_FW_EFI_RT_VERSION;
+
+	if (!HYPERVISOR_dom0_op(&op))
+		efi.runtime_version = info->version;
+
+	op.cmd = XENPF_firmware_info;
+	op.u.firmware_info.type = XEN_FW_EFI_INFO;
+	op.u.firmware_info.index = XEN_FW_EFI_CONFIG_TABLE;
+
+	if (HYPERVISOR_dom0_op(&op))
+		BUG();
+
+	efi_systab_xen.tables = info->cfg.addr;
+	efi_systab_xen.nr_tables = info->cfg.nent;
+
+	return &efi_systab_xen;
+}
-- 
1.7.10.4

