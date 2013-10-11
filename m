Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3JKGry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:47:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:19003 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200Ab3JKGrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:47:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1078,1371106800"; 
   d="scan'208";a="391441910"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@alien8.de
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [PATCH 3/8] ACPI, x86: Extended error log driver for x86 platform
Date: Fri, 11 Oct 2013 02:32:41 -0400
Message-Id: <1381473166-29303-4-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This error log driver (a.k.a eMCA driver) is implemented based on
http://www.intel.com/content/www/us/en/architecture-and-technology/enhanced-mca-logging-xeon-paper.html.
After errors are captured, more valuable information can be
got with this new enhanced error log driver.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 arch/x86/include/asm/mce.h       |   5 +
 arch/x86/kernel/cpu/mcheck/mce.c |  10 ++
 drivers/acpi/Kconfig             |   8 +
 drivers/acpi/Makefile            |   2 +
 drivers/acpi/acpi_extlog.c       | 339 +++++++++++++++++++++++++++++++++++++++
 drivers/acpi/bus.c               |   3 +-
 include/linux/acpi.h             |   1 +
 7 files changed, 367 insertions(+), 1 deletion(-)
 create mode 100644 drivers/acpi/acpi_extlog.c

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index cbe6b9e..f8c33e2 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -12,6 +12,7 @@
 #define MCG_CTL_P		(1ULL<<8)    /* MCG_CTL register available */
 #define MCG_EXT_P		(1ULL<<9)    /* Extended registers available */
 #define MCG_CMCI_P		(1ULL<<10)   /* CMCI supported */
+#define MCG_EXT_ERR_LOG		(1ULL<<26)   /* Extended error log supported */
 #define MCG_EXT_CNT_MASK	0xff0000     /* Number of Extended registers */
 #define MCG_EXT_CNT_SHIFT	16
 #define MCG_EXT_CNT(c)		(((c) & MCG_EXT_CNT_MASK) >> MCG_EXT_CNT_SHIFT)
@@ -204,6 +205,10 @@ extern void mce_disable_bank(int bank);
  * Exception handler
  */
 
+extern spinlock_t mce_elog_lock;
+extern int (*mce_extlog_support)(void);
+/* Call the installed extended error log print function */
+extern int (*mce_ext_err_print)(const char *, int cpu, int bank);
 /* Call the installed machine check handler for this CPU setup. */
 extern void (*machine_check_vector)(struct pt_regs *, long error_code);
 void do_machine_check(struct pt_regs *, long);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b3218cd..6802637 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -48,6 +48,12 @@
 
 #include "mce-internal.h"
 
+DEFINE_SPINLOCK(mce_elog_lock);
+EXPORT_SYMBOL_GPL(mce_elog_lock);
+
+int (*mce_ext_err_print)(const char *, int, int) = NULL;
+EXPORT_SYMBOL_GPL(mce_ext_err_print);
+
 static DEFINE_MUTEX(mce_chrdev_read_mutex);
 
 #define rcu_dereference_check_mce(p) \
@@ -624,6 +630,10 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		    (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC)))
 			continue;
 
+		spin_lock(&mce_elog_lock);
+		if (mce_ext_err_print)
+			mce_ext_err_print(NULL, m.extcpu, i);
+		spin_unlock(&mce_elog_lock);
 		mce_read_aux(&m, i);
 
 		if (!(flags & MCP_TIMESTAMP))
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 22327e6..1465fa8 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -372,4 +372,12 @@ config ACPI_BGRT
 
 source "drivers/acpi/apei/Kconfig"
 
+config ACPI_EXTLOG
+	tristate "Extended Error Log support"
+	depends on X86 && X86_MCE
+	default n
+	help
+	  This driver adds support for decoding extended errors from hardware.
+	  which allows the operating system to obtain data from trace.
+
 endif	# ACPI
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index cdaf68b..bce34af 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -82,3 +82,5 @@ processor-$(CONFIG_CPU_FREQ)	+= processor_perflib.o
 obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
 
 obj-$(CONFIG_ACPI_APEI)		+= apei/
+
+obj-$(CONFIG_ACPI_EXTLOG)	+= acpi_extlog.o
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
new file mode 100644
index 0000000..3e3e286
--- /dev/null
+++ b/drivers/acpi/acpi_extlog.c
@@ -0,0 +1,339 @@
+/*
+ * Extended Error Log driver
+ *
+ * Copyright (C) 2013 Intel Corp.
+ * Author: Chen, Gong <gong.chen@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/acpi.h>
+#include <acpi/acpi_bus.h>
+#include <linux/cper.h>
+#include <linux/ratelimit.h>
+#include <asm/mce.h>
+
+#include "apei/apei-internal.h"
+
+#define EXT_ELOG_ENTRY_MASK	0xfffffffffffff /* elog entry address mask */
+
+#define EXTLOG_DSM_REV		0x0
+#define	EXTLOG_FN_QUERY		0x0
+#define	EXTLOG_FN_ADDR		0x1
+
+#define FLAG_OS_OPTIN		BIT(0)
+#define EXTLOG_QUERY_L1_EXIST	BIT(1)
+#define ELOG_ENTRY_VALID	(1ULL<<63)
+#define ELOG_ENTRY_LEN		0x1000
+
+#define EMCA_BUG \
+	"Can not request iomem region <0x%016llx-0x%016llx> - eMCA disabled\n"
+
+struct extlog_l1_head {
+	u32 ver;	/* Header Version */
+	u32 hdr_len;	/* Header Length */
+	u64 total_len;	/* entire L1 Directory length including this header */
+	u64 elog_base;	/* MCA Error Log Directory base address */
+	u64 elog_len;	/* MCA Error Log Directory length */
+	u32 flags;	/* bit 0 - OS/VMM Opt-in */
+	u8  rev0[12];
+	u32 entries;	/* Valid L1 Directory entries per logical processor */
+	u8  rev1[12];
+};
+
+static u8 extlog_dsm_uuid[] = "663E35AF-CC10-41A4-88EA-5470AF055295";
+
+/* L1 table related physical address */
+static u64 elog_base;
+static size_t elog_size;
+static u64 l1_dirbase;
+static size_t l1_size;
+
+/* L1 table related virtual address */
+static void __iomem *extlog_l1_addr;
+static void __iomem *elog_addr;
+
+static void *elog_buf;
+
+static u64 *l1_entry_base;
+static u32 l1_percpu_entry;
+
+#define ELOG_IDX(cpu, bank) \
+	(cpu_physical_id(cpu) * l1_percpu_entry + (bank))
+
+#define ELOG_ENTRY_DATA(idx) \
+	(*(l1_entry_base + (idx)))
+
+#define ELOG_ENTRY_ADDR(phyaddr) \
+	(phyaddr - elog_base + (u8 *)elog_addr)
+
+static struct acpi_generic_status *extlog_elog_entry_check(int cpu, int bank)
+{
+	int idx;
+	u64 data;
+	struct acpi_generic_status *estatus;
+
+	BUG_ON(cpu < 0);
+	idx = ELOG_IDX(cpu, bank);
+	data = ELOG_ENTRY_DATA(idx);
+	if ((data & ELOG_ENTRY_VALID) == 0)
+		return NULL;
+
+	data &= EXT_ELOG_ENTRY_MASK;
+	estatus = (struct acpi_generic_status *)ELOG_ENTRY_ADDR(data);
+
+	/* if no valid data in elog entry, just return */
+	if (estatus->block_status == 0)
+		return NULL;
+
+	return estatus;
+}
+
+static void __print_extlog_rcd(const char *pfx,
+		struct acpi_generic_status *estatus, int cpu)
+{
+	static atomic_t seqno;
+	unsigned int curr_seqno;
+	char pfx_seq[64];
+
+	if (pfx == NULL) {
+		if (estatus->error_severity <= CPER_SEV_CORRECTED)
+			pfx = KERN_INFO;
+		else
+			pfx = KERN_ERR;
+	}
+	curr_seqno = atomic_inc_return(&seqno);
+	snprintf(pfx_seq, sizeof(pfx_seq), "%s{%u}", pfx, curr_seqno);
+	printk("%s""Hardware error detected on CPU%d\n", pfx_seq, cpu);
+	cper_estatus_print(pfx_seq, estatus);
+}
+
+static int print_extlog_rcd(const char *pfx,
+		struct acpi_generic_status *estatus, int cpu)
+{
+	/* Not more than 2 messages every 5 seconds */
+	static DEFINE_RATELIMIT_STATE(ratelimit_corrected, 5*HZ, 2);
+	static DEFINE_RATELIMIT_STATE(ratelimit_uncorrected, 5*HZ, 2);
+	struct ratelimit_state *ratelimit;
+
+	if (estatus->error_severity == CPER_SEV_CORRECTED ||
+			(estatus->error_severity == CPER_SEV_INFORMATIONAL))
+		ratelimit = &ratelimit_corrected;
+	else
+		ratelimit = &ratelimit_uncorrected;
+	if (__ratelimit(ratelimit)) {
+		__print_extlog_rcd(pfx, estatus, cpu);
+		return 0;
+	}
+
+	return 1;
+}
+
+static int extlog_print(const char *pfx, int cpu, int bank)
+{
+	struct acpi_generic_status *estatus;
+	int rc;
+
+	estatus = extlog_elog_entry_check(cpu, bank);
+	if (estatus == NULL)
+		return -EINVAL;
+
+	memcpy(elog_buf, (void *)estatus, ELOG_ENTRY_LEN);
+	/* clear record status to enable BIOS to update it again */
+	estatus->block_status = 0;
+
+	rc = print_extlog_rcd(pfx, (struct acpi_generic_status *)elog_buf, cpu);
+
+	return rc;
+}
+
+static int extlog_get_dsm(acpi_handle handle, int rev, int func, u64 *ret)
+{
+	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
+	struct acpi_object_list input;
+	union acpi_object params[4], *obj;
+	u8 uuid[16];
+	int i;
+
+	acpi_str_to_uuid(extlog_dsm_uuid, uuid);
+	input.count = 4;
+	input.pointer = params;
+	params[0].type = ACPI_TYPE_BUFFER;
+	params[0].buffer.length = 16;
+	params[0].buffer.pointer = uuid;
+	params[1].type = ACPI_TYPE_INTEGER;
+	params[1].integer.value = rev;
+	params[2].type = ACPI_TYPE_INTEGER;
+	params[2].integer.value = func;
+	params[3].type = ACPI_TYPE_PACKAGE;
+	params[3].package.count = 0;
+	params[3].package.elements = NULL;
+
+	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DSM", &input, &buf)))
+		return -1;
+
+	*ret = 0;
+	obj = (union acpi_object *)buf.pointer;
+	if (obj->type == ACPI_TYPE_INTEGER)
+		*ret = obj->integer.value;
+	else if (obj->type == ACPI_TYPE_BUFFER) {
+		if (obj->buffer.length <= 8) {
+			for (i = 0; i < obj->buffer.length; i++)
+				*ret |= (obj->buffer.pointer[i] << (i * 8));
+		}
+	}
+	kfree(buf.pointer);
+
+	return 0;
+}
+
+static bool extlog_get_l1addr(void)
+{
+	acpi_handle handle;
+	u64 ret;
+
+	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))
+		goto fail;
+
+	if (extlog_get_dsm(handle, EXTLOG_DSM_REV, EXTLOG_FN_QUERY, &ret) ||
+			!(ret & EXTLOG_QUERY_L1_EXIST))
+		goto fail;
+
+	if (extlog_get_dsm(handle, EXTLOG_DSM_REV, EXTLOG_FN_ADDR, &ret))
+		goto fail;
+
+	l1_dirbase = ret;
+	/* Spec says L1 directory must be 4K aligned, bail out if it isn't */
+	if (l1_dirbase & ((1 << 12) - 1)) {
+		pr_warn(FW_BUG "L1 Directory is invalid at physical %llx\n",
+			l1_dirbase);
+		goto fail;
+	}
+
+	return true;
+fail:
+	return false;
+}
+
+static int __init extlog_init(void)
+{
+	struct extlog_l1_head *l1_head;
+	void __iomem *extlog_l1_hdr;
+	size_t l1_hdr_size;
+	unsigned long flags;
+	struct resource *r;
+	u64 cap;
+	int rc;
+
+	rc = -ENODEV;
+
+	rdmsrl(MSR_IA32_MCG_CAP, cap);
+	if (!(cap & MCG_EXT_ERR_LOG))
+		return rc;
+
+	if (!extlog_get_l1addr())
+		return rc;
+
+	rc = -EINVAL;
+	/* get L1 header to fetch necessary information */
+	l1_hdr_size = sizeof(struct extlog_l1_head);
+	r = request_mem_region(l1_dirbase, l1_hdr_size, "L1 DIR HDR");
+	if (!r) {
+		pr_warn(FW_BUG EMCA_BUG,
+			(unsigned long long)l1_dirbase,
+			(unsigned long long)l1_dirbase + l1_hdr_size);
+		goto err;
+	}
+
+	extlog_l1_hdr = acpi_os_map_memory(l1_dirbase, l1_hdr_size);
+	l1_head = (struct extlog_l1_head *)extlog_l1_hdr;
+	l1_size = l1_head->total_len;
+	l1_percpu_entry = l1_head->entries;
+	elog_base = l1_head->elog_base;
+	elog_size = l1_head->elog_len;
+	acpi_os_unmap_memory(extlog_l1_hdr, l1_hdr_size);
+	release_mem_region(l1_dirbase, l1_hdr_size);
+
+	/* remap L1 header again based on completed information */
+	r = request_mem_region(l1_dirbase, l1_size, "L1 Table");
+	if (!r) {
+		pr_warn(FW_BUG EMCA_BUG,
+			(unsigned long long)l1_dirbase,
+			(unsigned long long)l1_dirbase + l1_size);
+		goto err;
+	}
+	extlog_l1_addr = acpi_os_map_memory(l1_dirbase, l1_size);
+	l1_entry_base = (u64 *)((u8 *)extlog_l1_addr + l1_hdr_size);
+
+	/* remap elog table */
+	r = request_mem_region(elog_base, elog_size, "Elog Table");
+	if (!r) {
+		pr_warn(FW_BUG EMCA_BUG,
+			(unsigned long long)elog_base,
+			(unsigned long long)elog_base + elog_size);
+		goto err_release_l1_dir;
+	}
+	elog_addr = acpi_os_map_memory(elog_base, elog_size);
+
+	rc = -ENOMEM;
+	/* allocate buffer to save elog record */
+	elog_buf = kmalloc(ELOG_ENTRY_LEN, GFP_KERNEL);
+	if (elog_buf == NULL)
+		goto err_release_elog;
+
+	spin_lock_irqsave(&mce_elog_lock, flags);
+	mce_ext_err_print = extlog_print;
+	spin_unlock_irqrestore(&mce_elog_lock, flags);
+	/* enable OS to be involved to take over management from BIOS */
+	((struct extlog_l1_head *)extlog_l1_addr)->flags |= FLAG_OS_OPTIN;
+
+	return 0;
+
+err_release_elog:
+	if (elog_addr)
+		acpi_os_unmap_memory(elog_addr, elog_size);
+	release_mem_region(elog_base, elog_size);
+err_release_l1_dir:
+	if (extlog_l1_addr)
+		acpi_os_unmap_memory(extlog_l1_addr, l1_size);
+	release_mem_region(l1_dirbase, l1_size);
+err:
+	pr_warn(FW_BUG "Extended error log disabled because of problems parsing f/w tables\n");
+	return rc;
+}
+
+static void __exit extlog_exit(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mce_elog_lock, flags);
+	mce_ext_err_print = NULL;
+	spin_unlock_irqrestore(&mce_elog_lock, flags);
+	((struct extlog_l1_head *)extlog_l1_addr)->flags &= ~FLAG_OS_OPTIN;
+	if (extlog_l1_addr)
+		acpi_os_unmap_memory(extlog_l1_addr, l1_size);
+	if (elog_addr)
+		acpi_os_unmap_memory(elog_addr, elog_size);
+	release_mem_region(elog_base, elog_size);
+	release_mem_region(l1_dirbase, l1_size);
+	kfree(elog_buf);
+}
+
+module_init(extlog_init);
+module_exit(extlog_exit);
+
+MODULE_AUTHOR("Chen, Gong <gong.chen@intel.com>");
+MODULE_DESCRIPTION("Extended Error Log Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index b587ec8..e1bd9a1 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -174,7 +174,7 @@ static void acpi_print_osc_error(acpi_handle handle,
 	printk("\n");
 }
 
-static acpi_status acpi_str_to_uuid(char *str, u8 *uuid)
+acpi_status acpi_str_to_uuid(char *str, u8 *uuid)
 {
 	int i;
 	static int opc_map_to_uuid[16] = {6, 4, 2, 0, 11, 9, 16, 14, 19, 21,
@@ -195,6 +195,7 @@ static acpi_status acpi_str_to_uuid(char *str, u8 *uuid)
 	}
 	return AE_OK;
 }
+EXPORT_SYMBOL_GPL(acpi_str_to_uuid);
 
 acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context)
 {
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index a5db4ae..c30bac8 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -311,6 +311,7 @@ struct acpi_osc_context {
 #define OSC_INVALID_REVISION_ERROR	8
 #define OSC_CAPABILITIES_MASK_ERROR	16
 
+acpi_status acpi_str_to_uuid(char *str, u8 *uuid);
 acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 
 /* platform-wide _OSC bits */
-- 
1.8.4.rc3

