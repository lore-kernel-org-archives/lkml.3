Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaETHju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:39:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:26120 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaETHjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:39:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,872,1392192000"; 
   d="scan'208";a="534687881"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI: Cleanup for acpi_os_map/unmap_memory() to eliminate __iomem.
Date: Tue, 20 May 2014 15:39:41 +0800
Message-Id: <078ed47fc489dd33b8a0c2d7fd8c2f956bbaf762.1400571372.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPICA doesn't include protections around address space checking, Linux
build tests always complain increased sparse warnings around ACPICA
internal acpi_os_map/unmap_memory() invocations.  This patch tries to fix
this issue permanently.

There are 2 choices left for us to solve this issue:
1. Add __iomem address space awareness into ACPICA.
2. Remove sparse checker of __iomem from ACPICA source code.

This patch chooses solution 2, because:
1.  Most of the acpi_os_map/unmap_memory() invocations are used for ACPICA
    table mappings, which in fact are not IO addresses.
2.  The only IO addresses usage is for "system memory space" mapping code:
     drivers/acpi/acpica/exregion.c:		mem_info->mapped_logical_address = acpi_os_map_memory((acpi_physical_address) address, map_length);
     drivers/acpi/acpica/evrgnini.c:				acpi_os_unmap_memory(local_region_context->
     drivers/acpi/acpica/exregion.c:			acpi_os_unmap_memory(mem_info->mapped_logical_address,
    The mapped address is accessed in the handler of "system memory space"
    - acpi_ex_system_memory_space_handler().  This function in fact can be
    changed to invoke acpi_os_read/write_memory() so that __iomem can
    always be type-casted in the OSL layer.
According to the above investigation, we drew the following conclusion:
It is not a good idea to introduce __iomem address space awareness into
ACPICA mostly in order to protect non-IO addresses.

We can simply remove __iomem for acpi_os_map/unmap_memory() to remove
__iomem checker for ACPICA code. Then we need to enforces external usages
to invoke other APIs that are aware of __iomem address space.
The external usages are:
 drivers/acpi/apei/einj.c:	v = acpi_os_map_memory(paddr + offset, sizeof(*v));
 drivers/acpi/apei/einj.c:		v5param = acpi_os_map_memory(pa_v5, sizeof(*v5param));
 drivers/acpi/apei/einj.c:		v4param = acpi_os_map_memory(pa_v4, sizeof(*v4param));
 drivers/acpi/acpi_extlog.c:	extlog_l1_hdr = acpi_os_map_memory(l1_dirbase, l1_hdr_size);
 drivers/acpi/acpi_extlog.c:	extlog_l1_addr = acpi_os_map_memory(l1_dirbase, l1_size);
 drivers/acpi/acpi_extlog.c:	elog_addr = acpi_os_map_memory(elog_base, elog_size);
 drivers/char/tpm/tpm_acpi.c:	virt = acpi_os_map_memory(start, len);
 drivers/acpi/nvs.c:					acpi_os_unmap_memory(entry->kaddr,

This patch thus performs cleanups in this way:
1. Add acpi_os_map/unmap_iomem() to be invoked by non-ACPICA code.
2. Remove __iomem from acpi_os_map/unmap_memory().
Note that, further cleanups might be done to move early table mapping code
from acpi_os_map/unmap_iomem() to acpi_os_map/unmap_memory(), but this
patch doesn't go that far in order not to introduce regressions.

After applying this patch, following sparse warnings are eliminated from
ACPICA internal usages:
 drivers/acpi/acpica/tbutils.c:279:15: warning: incorrect type in assignment (different address spaces)
 drivers/acpi/acpica/tbutils.c:286:30: warning: incorrect type in argument 1 (different address spaces)
 drivers/acpi/acpica/tbutils.c:298:15: warning: incorrect type in assignment (different address spaces)
 drivers/acpi/acpica/tbutils.c:329:30: warning: incorrect type in argument 1 (different address spaces)
 drivers/acpi/acpica/tbutils.c:367:14: warning: incorrect type in assignment (different address spaces)
 drivers/acpi/acpica/tbutils.c:398:30: warning: incorrect type in argument 1 (different address spaces)
 drivers/acpi/acpica/tbutils.c:421:15: warning: incorrect type in assignment (different address spaces)
 drivers/acpi/acpica/tbutils.c:433:30: warning: incorrect type in argument 1 (different address spaces)
 drivers/acpi/acpica/tbutils.c:442:15: warning: incorrect type in assignment (different address spaces)
 drivers/acpi/acpica/tbutils.c:451:38: warning: incorrect type in argument 1 (different address spaces)
 drivers/acpi/acpica/tbutils.c:495:30: warning: incorrect type in argument 1 (different address spaces)
 drivers/acpi/acpica/evrgnini.c:89:74: warning: incorrect type in argument 1 (different address spaces)
 drivers/acpi/acpica/exregion.c:145:54: warning: incorrect type in argument 1 (different address spaces)
 drivers/acpi/acpica/exregion.c:180:50: warning: incorrect type in assignment (different address spaces)
 drivers/acpi/acpica/tbdata.c:109:23: warning: incorrect type in assignment (different address spaces)
 drivers/acpi/acpica/tbdata.c:162:38: warning: incorrect type in argument 1 (different address spaces)
 drivers/acpi/acpica/tbdata.c:201:30: warning: incorrect type in assignment (different address spaces)
 drivers/acpi/acpica/tbdata.c:210:38: warning: incorrect type in argument 1 (different address spaces)
 drivers/acpi/acpica/tbfadt.c:312:15: warning: incorrect type in assignment (different address spaces)
 drivers/acpi/acpica/tbfadt.c:331:30: warning: incorrect type in argument 1 (different address spaces)
 drivers/acpi/acpica/tbxface.c:237:40: warning: incorrect type in assignment (different address spaces)
 drivers/acpi/acpica/tbxface.c:247:54: warning: incorrect type in argument 1 (different address spaces)
 drivers/acpi/acpica/tbxfroot.c:124:19: warning: incorrect type in assignment (different address spaces)
 drivers/acpi/acpica/tbxfroot.c:140:30: warning: incorrect type in argument 1 (different address spaces)
 drivers/acpi/acpica/tbxfroot.c:149:27: warning: incorrect type in assignment (different address spaces)
 drivers/acpi/acpica/tbxfroot.c:163:38: warning: incorrect type in argument 1 (different address spaces)
 drivers/acpi/acpica/tbxfroot.c:180:19: warning: incorrect type in assignment (different address spaces)
 drivers/acpi/acpica/tbxfroot.c:195:30: warning: incorrect type in argument 1 (different address spaces)
And ACPICA external usages are not affected.

[zetalog: based on linux-pm.git/bleeding-edge]
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpi_extlog.c        |   16 ++++++++--------
 drivers/acpi/apei/einj.c          |   14 +++++++-------
 drivers/acpi/nvs.c                |    4 ++--
 drivers/acpi/osl.c                |   21 +++++++++++++++++----
 drivers/char/tpm/tpm_acpi.c       |    4 ++--
 include/acpi/acpi_io.h            |    3 +++
 include/acpi/platform/aclinux.h   |    6 ------
 include/acpi/platform/aclinuxex.h |    4 ----
 8 files changed, 39 insertions(+), 33 deletions(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index c4a5d87..1853341 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -220,13 +220,13 @@ static int __init extlog_init(void)
 		goto err;
 	}
 
-	extlog_l1_hdr = acpi_os_map_memory(l1_dirbase, l1_hdr_size);
+	extlog_l1_hdr = acpi_os_map_iomem(l1_dirbase, l1_hdr_size);
 	l1_head = (struct extlog_l1_head *)extlog_l1_hdr;
 	l1_size = l1_head->total_len;
 	l1_percpu_entry = l1_head->entries;
 	elog_base = l1_head->elog_base;
 	elog_size = l1_head->elog_len;
-	acpi_os_unmap_memory(extlog_l1_hdr, l1_hdr_size);
+	acpi_os_unmap_iomem(extlog_l1_hdr, l1_hdr_size);
 	release_mem_region(l1_dirbase, l1_hdr_size);
 
 	/* remap L1 header again based on completed information */
@@ -237,7 +237,7 @@ static int __init extlog_init(void)
 			(unsigned long long)l1_dirbase + l1_size);
 		goto err;
 	}
-	extlog_l1_addr = acpi_os_map_memory(l1_dirbase, l1_size);
+	extlog_l1_addr = acpi_os_map_iomem(l1_dirbase, l1_size);
 	l1_entry_base = (u64 *)((u8 *)extlog_l1_addr + l1_hdr_size);
 
 	/* remap elog table */
@@ -248,7 +248,7 @@ static int __init extlog_init(void)
 			(unsigned long long)elog_base + elog_size);
 		goto err_release_l1_dir;
 	}
-	elog_addr = acpi_os_map_memory(elog_base, elog_size);
+	elog_addr = acpi_os_map_iomem(elog_base, elog_size);
 
 	rc = -ENOMEM;
 	/* allocate buffer to save elog record */
@@ -270,11 +270,11 @@ static int __init extlog_init(void)
 
 err_release_elog:
 	if (elog_addr)
-		acpi_os_unmap_memory(elog_addr, elog_size);
+		acpi_os_unmap_iomem(elog_addr, elog_size);
 	release_mem_region(elog_base, elog_size);
 err_release_l1_dir:
 	if (extlog_l1_addr)
-		acpi_os_unmap_memory(extlog_l1_addr, l1_size);
+		acpi_os_unmap_iomem(extlog_l1_addr, l1_size);
 	release_mem_region(l1_dirbase, l1_size);
 err:
 	pr_warn(FW_BUG "Extended error log disabled because of problems parsing f/w tables\n");
@@ -287,9 +287,9 @@ static void __exit extlog_exit(void)
 	mce_unregister_decode_chain(&extlog_mce_dec);
 	((struct extlog_l1_head *)extlog_l1_addr)->flags &= ~FLAG_OS_OPTIN;
 	if (extlog_l1_addr)
-		acpi_os_unmap_memory(extlog_l1_addr, l1_size);
+		acpi_os_unmap_iomem(extlog_l1_addr, l1_size);
 	if (elog_addr)
-		acpi_os_unmap_memory(elog_addr, elog_size);
+		acpi_os_unmap_iomem(elog_addr, elog_size);
 	release_mem_region(elog_base, elog_size);
 	release_mem_region(l1_dirbase, l1_size);
 	kfree(elog_buf);
diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index 1be6f55..a095d4f 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -202,7 +202,7 @@ static void check_vendor_extension(u64 paddr,
 
 	if (!offset)
 		return;
-	v = acpi_os_map_memory(paddr + offset, sizeof(*v));
+	v = acpi_os_map_iomem(paddr + offset, sizeof(*v));
 	if (!v)
 		return;
 	sbdf = v->pcie_sbdf;
@@ -210,7 +210,7 @@ static void check_vendor_extension(u64 paddr,
 		sbdf >> 24, (sbdf >> 16) & 0xff,
 		(sbdf >> 11) & 0x1f, (sbdf >> 8) & 0x7,
 		 v->vendor_id, v->device_id, v->rev_id);
-	acpi_os_unmap_memory(v, sizeof(*v));
+	acpi_os_unmap_iomem(v, sizeof(*v));
 }
 
 static void *einj_get_parameter_address(void)
@@ -236,7 +236,7 @@ static void *einj_get_parameter_address(void)
 	if (pa_v5) {
 		struct set_error_type_with_address *v5param;
 
-		v5param = acpi_os_map_memory(pa_v5, sizeof(*v5param));
+		v5param = acpi_os_map_iomem(pa_v5, sizeof(*v5param));
 		if (v5param) {
 			acpi5 = 1;
 			check_vendor_extension(pa_v5, v5param);
@@ -246,11 +246,11 @@ static void *einj_get_parameter_address(void)
 	if (param_extension && pa_v4) {
 		struct einj_parameter *v4param;
 
-		v4param = acpi_os_map_memory(pa_v4, sizeof(*v4param));
+		v4param = acpi_os_map_iomem(pa_v4, sizeof(*v4param));
 		if (!v4param)
 			return NULL;
 		if (v4param->reserved1 || v4param->reserved2) {
-			acpi_os_unmap_memory(v4param, sizeof(*v4param));
+			acpi_os_unmap_iomem(v4param, sizeof(*v4param));
 			return NULL;
 		}
 		return v4param;
@@ -794,7 +794,7 @@ err_unmap:
 			sizeof(struct set_error_type_with_address) :
 			sizeof(struct einj_parameter);
 
-		acpi_os_unmap_memory(einj_param, size);
+		acpi_os_unmap_iomem(einj_param, size);
 	}
 	apei_exec_post_unmap_gars(&ctx);
 err_release:
@@ -816,7 +816,7 @@ static void __exit einj_exit(void)
 			sizeof(struct set_error_type_with_address) :
 			sizeof(struct einj_parameter);
 
-		acpi_os_unmap_memory(einj_param, size);
+		acpi_os_unmap_iomem(einj_param, size);
 	}
 	einj_exec_ctx_init(&ctx);
 	apei_exec_post_unmap_gars(&ctx);
diff --git a/drivers/acpi/nvs.c b/drivers/acpi/nvs.c
index de4fe03..85287b8 100644
--- a/drivers/acpi/nvs.c
+++ b/drivers/acpi/nvs.c
@@ -139,8 +139,8 @@ void suspend_nvs_free(void)
 					iounmap(entry->kaddr);
 					entry->unmap = false;
 				} else {
-					acpi_os_unmap_memory(entry->kaddr,
-							     entry->size);
+					acpi_os_unmap_iomem(entry->kaddr,
+							    entry->size);
 				}
 				entry->kaddr = NULL;
 			}
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 9aeae41..147bc1b 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -355,7 +355,7 @@ static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
 }
 
 void __iomem *__init_refok
-acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
+acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 {
 	struct acpi_ioremap *map;
 	void __iomem *virt;
@@ -401,10 +401,17 @@ acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
 
 	list_add_tail_rcu(&map->list, &acpi_ioremaps);
 
- out:
+out:
 	mutex_unlock(&acpi_ioremap_lock);
 	return map->virt + (phys - map->phys);
 }
+EXPORT_SYMBOL_GPL(acpi_os_map_iomem);
+
+void *__init_refok
+acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
+{
+	return (void *)acpi_os_map_iomem(phys, size);
+}
 EXPORT_SYMBOL_GPL(acpi_os_map_memory);
 
 static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
@@ -422,7 +429,7 @@ static void acpi_os_map_cleanup(struct acpi_ioremap *map)
 	}
 }
 
-void __ref acpi_os_unmap_memory(void __iomem *virt, acpi_size size)
+void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size)
 {
 	struct acpi_ioremap *map;
 
@@ -443,6 +450,12 @@ void __ref acpi_os_unmap_memory(void __iomem *virt, acpi_size size)
 
 	acpi_os_map_cleanup(map);
 }
+EXPORT_SYMBOL_GPL(acpi_os_unmap_iomem);
+
+void __ref acpi_os_unmap_memory(void *virt, acpi_size size)
+{
+	return acpi_os_unmap_iomem((void __iomem *)virt, size);
+}
 EXPORT_SYMBOL_GPL(acpi_os_unmap_memory);
 
 void __init early_acpi_os_unmap_memory(void __iomem *virt, acpi_size size)
@@ -464,7 +477,7 @@ int acpi_os_map_generic_address(struct acpi_generic_address *gas)
 	if (!addr || !gas->bit_width)
 		return -EINVAL;
 
-	virt = acpi_os_map_memory(addr, gas->bit_width / 8);
+	virt = acpi_os_map_iomem(addr, gas->bit_width / 8);
 	if (!virt)
 		return -EIO;
 
diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index b9a57fa..565a947 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -95,7 +95,7 @@ int read_log(struct tpm_bios_log *log)
 
 	log->bios_event_log_end = log->bios_event_log + len;
 
-	virt = acpi_os_map_memory(start, len);
+	virt = acpi_os_map_iomem(start, len);
 	if (!virt) {
 		kfree(log->bios_event_log);
 		printk("%s: ERROR - Unable to map memory\n", __func__);
@@ -104,6 +104,6 @@ int read_log(struct tpm_bios_log *log)
 
 	memcpy_fromio(log->bios_event_log, virt, len);
 
-	acpi_os_unmap_memory(virt, len);
+	acpi_os_unmap_iomem(virt, len);
 	return 0;
 }
diff --git a/include/acpi/acpi_io.h b/include/acpi/acpi_io.h
index 2be8580..444671e 100644
--- a/include/acpi/acpi_io.h
+++ b/include/acpi/acpi_io.h
@@ -9,6 +9,9 @@ static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
        return ioremap_cache(phys, size);
 }
 
+void __iomem *__init_refok
+acpi_os_map_iomem(acpi_physical_address phys, acpi_size size);
+void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size);
 void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size);
 
 int acpi_os_map_generic_address(struct acpi_generic_address *addr);
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index e700129..cd1f052 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -128,8 +128,6 @@
 #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_acquire_object
 #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_get_thread_id
 #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_create_lock
-#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_map_memory
-#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_unmap_memory
 
 /*
  * OSL interfaces used by debugger/disassembler
@@ -163,10 +161,6 @@
 #define __init
 #endif
 
-#ifndef __iomem
-#define __iomem
-#endif
-
 /* Host-dependent types and defines for user-space ACPICA */
 
 #define ACPI_FLUSH_CPU_CACHE()
diff --git a/include/acpi/platform/aclinuxex.h b/include/acpi/platform/aclinuxex.h
index cce0723..191e741 100644
--- a/include/acpi/platform/aclinuxex.h
+++ b/include/acpi/platform/aclinuxex.h
@@ -102,10 +102,6 @@ static inline acpi_thread_id acpi_os_get_thread_id(void)
 		lock ? AE_OK : AE_NO_MEMORY; \
 	})
 
-void __iomem *acpi_os_map_memory(acpi_physical_address where, acpi_size length);
-
-void acpi_os_unmap_memory(void __iomem * logical_address, acpi_size size);
-
 /*
  * OSL interfaces added by Linux
  */
-- 
1.7.10

