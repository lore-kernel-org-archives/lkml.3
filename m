Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaDYQ1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:27:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35904 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbaDYQKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:10:08 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: matt.fleming@intel.com, catalin.marinas@arm.com, msalter@redhat.com,
        grant.likely@linaro.org, roy.franz@linaro.org,
        ard.biesheuvel@linaro.org, mark.rutland@arm.com,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 03/10] efi: add helper function to get UEFI params from FDT
Date: Fri, 25 Apr 2014 17:09:07 +0100
Message-Id: <1398442154-19974-4-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

ARM and ARM64 architectures use the device tree to pass UEFI parameters
from stub to kernel. These parameters are things known to the stub but
not discoverable by the kernel after the stub calls ExitBootSerives().
There is a helper function in:

   drivers/firmware/efi/fdt.c

which the stub uses to add the UEFI parameters to the device tree.
This patch adds a complimentary helper function which UEFI runtime
support may use to retrieve the parameters from the device tree.
If an architecture wants to use this helper, it should select
CONFIG_UEFI_PARAMS_FROM_FDT.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 drivers/firmware/efi/Kconfig |    7 ++++
 drivers/firmware/efi/efi.c   |   79 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h          |    9 +++++
 3 files changed, 95 insertions(+)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 1e75f48..d3fe28d 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -47,6 +47,13 @@ config EFI_RUNTIME_MAP
 
 	  See also Documentation/ABI/testing/sysfs-firmware-efi-runtime-map.
 
+config UEFI_PARAMS_FROM_FDT
+	bool
+	help
+	  Select this config option from the architecture Kconfig if
+	  the EFI runtime support gets system table address, memory
+          map address, and other parameters from the device tree.
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index af20f17..ece6197 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -20,6 +20,8 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/efi.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
 #include <linux/io.h>
 
 struct efi __read_mostly efi = {
@@ -318,3 +320,80 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 
 	return 0;
 }
+
+#ifdef CONFIG_UEFI_PARAMS_FROM_FDT
+
+#define UEFI_PARAM(name, prop, field)			   \
+	{						   \
+		{ name },				   \
+		{ prop },				   \
+		offsetof(struct efi_fdt_params, field),    \
+		FIELD_SIZEOF(struct efi_fdt_params, field) \
+	}
+
+static __initdata struct {
+	const char name[32];
+	const char propname[32];
+	int offset;
+	int size;
+} dt_params[] = {
+	UEFI_PARAM("System Table", "linux,uefi-system-table", system_table),
+	UEFI_PARAM("MemMap Address", "linux,uefi-mmap-start", mmap),
+	UEFI_PARAM("MemMap Size", "linux,uefi-mmap-size", mmap_size),
+	UEFI_PARAM("MemMap Desc. Size", "linux,uefi-mmap-desc-size", desc_size),
+	UEFI_PARAM("MemMap Desc. Version", "linux,uefi-mmap-desc-ver", desc_ver)
+};
+
+struct param_info {
+	int verbose;
+	void *params;
+};
+
+static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
+				       int depth, void *data)
+{
+	struct param_info *info = data;
+	void *prop, *dest;
+	unsigned long len;
+	u64 val;
+	int i;
+
+	if (depth != 1 ||
+	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
+		return 0;
+
+	pr_info("Getting parameters from FDT:\n");
+
+	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
+		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
+		if (!prop) {
+			pr_err("Can't find %s in device tree!\n",
+			       dt_params[i].name);
+			return 0;
+		}
+		dest = info->params + dt_params[i].offset;
+
+		val = of_read_number(prop, len / sizeof(u32));
+
+		if (dt_params[i].size == sizeof(u32))
+			*(u32 *)dest = val;
+		else
+			*(u64 *)dest = val;
+
+		if (info->verbose)
+			pr_info("  %s: 0x%0*llx\n", dt_params[i].name,
+				dt_params[i].size * 2, val);
+	}
+	return 1;
+}
+
+int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
+{
+	struct param_info info;
+
+	info.verbose = verbose;
+	info.params = params;
+
+	return of_scan_flat_dt(fdt_find_uefi_params, &info);
+}
+#endif /* CONFIG_UEFI_PARAMS_FROM_FDT */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 82d0abb..4f52ac6 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -664,6 +664,14 @@ struct efi_memory_map {
 	unsigned long desc_size;
 };
 
+struct efi_fdt_params {
+	u64 system_table;
+	u64 mmap;
+	u32 mmap_size;
+	u32 desc_size;
+	u32 desc_ver;
+};
+
 typedef struct {
 	u32 revision;
 	u32 parent_handle;
@@ -861,6 +869,7 @@ extern void efi_initialize_iomem_resources(struct resource *code_resource,
 extern void efi_get_time(struct timespec *now);
 extern int efi_set_rtc_mmss(const struct timespec *now);
 extern void efi_reserve_boot_services(void);
+extern int efi_get_fdt_params(struct efi_fdt_params *params, int verbose);
 extern struct efi_memory_map memmap;
 
 /* Iterate through an efi_memory_map */
-- 
1.7.10.4

