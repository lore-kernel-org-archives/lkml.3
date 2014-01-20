Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaATPKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:10:18 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:57214 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaATPJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:09:54 -0500
Date: Mon, 20 Jan 2014 16:09:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "Luck, Tony" <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RAS changes for v3.14
Message-ID: <20140120150950.GA15732@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-ras-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-ras-for-linus

   # HEAD: b769e014f3ae4af8a56c6327077b3c40410dedad Merge tag 'ras_for_3.14_p2' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras into x86/ras

The main changes:

    * SCI reporting for other error types not only correctable ones

    * GHES cleanups

    * Add the functionality to override error reporting agents as some
      machines are sporting a new extended error logging capability which, if
      done properly in the BIOS, makes a corresponding EDAC module redundant
    
    * PCIe AER tracepoint severity levels fix
    
    * Error path correction for the mce device init

    * MCE timer fix

    * Add more flexibility to the error injection (EINJ) debugfs interface

  out-of-topic modifications in x86-ras-for-linus:
  --------------------------------------------------
  drivers/acpi/acpi_extlog.c         # 42139eb: ACPI, eMCA: Combine eMCA/EDAC eve
  drivers/acpi/apei/apei-base.c      # d3ab3ed: ACPI, APEI: Cleanup alignment-awa
  drivers/acpi/apei/einj.c           # d3ab3ed: ACPI, APEI: Cleanup alignment-awa
                                   # 3482fb5: ACPI, APEI, EINJ: Changes to the 
  drivers/acpi/apei/erst.c           # d3ab3ed: ACPI, APEI: Cleanup alignment-awa
  drivers/acpi/apei/ghes.c           # ca104ed: ACPI, APEI, GHES: Cleanup ghes me
                                   # addccbb: ACPI, APEI, GHES: Do not report o
  drivers/edac/edac_stub.c           # c700f01: EDAC: Add an edac_report paramete
  drivers/edac/sb_edac.c             # fd52103: EDAC, sb_edac: Modify H/W event r
  include/linux/edac.h               # c700f01: EDAC: Add an edac_report paramete
  include/trace/events/ras.h         # 545104d: PCI, AER: Fix severity usage in a

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86, mce: Fix mce_start_timer semantics

Chen, Gong (6):
      EDAC: Add an edac_report parameter to EDAC
      EDAC, sb_edac: Modify H/W event reporting policy
      ACPI, eMCA: Combine eMCA/EDAC event reporting priority
      ACPI, APEI, GHES: Do not report only correctable errors with SCI
      ACPI, APEI: Cleanup alignment-aware accesses
      ACPI, APEI, GHES: Cleanup ghes memory error handling

Levente Kurusa (1):
      x86, mce: Call put_device on device_register failure

Rui Wang (1):
      PCI, AER: Fix severity usage in aer trace event

Tony Luck (1):
      ACPI, APEI, EINJ: Changes to the ACPI/APEI/EINJ debugfs interface


 Documentation/acpi/apei/einj.txt      | 19 +++++++++++-
 Documentation/kernel-parameters.txt   |  8 +++++
 arch/x86/kernel/cpu/mcheck/mce-apei.c | 14 ++++++---
 arch/x86/kernel/cpu/mcheck/mce.c      | 12 +++++---
 drivers/acpi/acpi_extlog.c            | 18 +++++++++--
 drivers/acpi/apei/apei-base.c         |  4 +--
 drivers/acpi/apei/einj.c              | 58 ++++++++++++++++++++++++++---------
 drivers/acpi/apei/erst.c              |  2 +-
 drivers/acpi/apei/ghes.c              | 39 ++++++++++++-----------
 drivers/edac/edac_stub.c              | 19 ++++++++++++
 drivers/edac/sb_edac.c                |  6 +++-
 include/linux/edac.h                  | 28 +++++++++++++++++
 include/trace/events/ras.h            | 10 +++---
 13 files changed, 183 insertions(+), 54 deletions(-)

diff --git a/Documentation/acpi/apei/einj.txt b/Documentation/acpi/apei/einj.txt
index a58b63d..f51861b 100644
--- a/Documentation/acpi/apei/einj.txt
+++ b/Documentation/acpi/apei/einj.txt
@@ -45,11 +45,22 @@ directory apei/einj. The following files are provided.
   injection. Before this, please specify all necessary error
   parameters.
 
+- flags
+  Present for kernel version 3.13 and above. Used to specify which
+  of param{1..4} are valid and should be used by BIOS during injection.
+  Value is a bitmask as specified in ACPI5.0 spec for the
+  SET_ERROR_TYPE_WITH_ADDRESS data structure:
+	Bit 0 - Processor APIC field valid (see param3 below)
+	Bit 1 - Memory address and mask valid (param1 and param2)
+	Bit 2 - PCIe (seg,bus,dev,fn) valid (param4 below)
+  If set to zero, legacy behaviour is used where the type of injection
+  specifies just one bit set, and param1 is multiplexed.
+
 - param1
   This file is used to set the first error parameter value. Effect of
   parameter depends on error_type specified. For example, if error
   type is memory related type, the param1 should be a valid physical
-  memory address.
+  memory address. [Unless "flag" is set - see above]
 
 - param2
   This file is used to set the second error parameter value. Effect of
@@ -58,6 +69,12 @@ directory apei/einj. The following files are provided.
   address mask. Linux requires page or narrower granularity, say,
   0xfffffffffffff000.
 
+- param3
+  Used when the 0x1 bit is set in "flag" to specify the APIC id
+
+- param4
+  Used when the 0x4 bit is set in "flag" to specify target PCIe device
+
 - notrigger
   The EINJ mechanism is a two step process. First inject the error, then
   perform some actions to trigger it. Setting "notrigger" to 1 skips the
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b9e9bd8..1e1e0b7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -881,6 +881,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 			The xen output can only be used by Xen PV guests.
 
+	edac_report=	[HW,EDAC] Control how to report EDAC event
+			Format: {"on" | "off" | "force"}
+			on: enable EDAC to report H/W event. May be overridden
+			by other higher priority error reporting module.
+			off: disable H/W event reporting through EDAC.
+			force: enforce the use of EDAC to report H/W event.
+			default: on.
+
 	ekgdboc=	[X86,KGDB] Allow early kernel console debugging
 			ekgdboc=kbd
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce-apei.c b/arch/x86/kernel/cpu/mcheck/mce-apei.c
index de8b60a..a1aef95 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-apei.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-apei.c
@@ -33,22 +33,28 @@
 #include <linux/acpi.h>
 #include <linux/cper.h>
 #include <acpi/apei.h>
+#include <acpi/ghes.h>
 #include <asm/mce.h>
 
 #include "mce-internal.h"
 
-void apei_mce_report_mem_error(int corrected, struct cper_sec_mem_err *mem_err)
+void apei_mce_report_mem_error(int severity, struct cper_sec_mem_err *mem_err)
 {
 	struct mce m;
 
-	/* Only corrected MC is reported */
-	if (!corrected || !(mem_err->validation_bits & CPER_MEM_VALID_PA))
+	if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
 		return;
 
 	mce_setup(&m);
 	m.bank = 1;
-	/* Fake a memory read corrected error with unknown channel */
+	/* Fake a memory read error with unknown channel */
 	m.status = MCI_STATUS_VAL | MCI_STATUS_EN | MCI_STATUS_ADDRV | 0x9f;
+
+	if (severity >= GHES_SEV_RECOVERABLE)
+		m.status |= MCI_STATUS_UC;
+	if (severity >= GHES_SEV_PANIC)
+		m.status |= MCI_STATUS_PCC;
+
 	m.addr = mem_err->physical_addr;
 	mce_log(&m);
 	mce_notify_irq();
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b3218cd..4d5419b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1638,15 +1638,15 @@ static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
 
 static void mce_start_timer(unsigned int cpu, struct timer_list *t)
 {
-	unsigned long iv = mce_adjust_timer(check_interval * HZ);
-
-	__this_cpu_write(mce_next_interval, iv);
+	unsigned long iv = check_interval * HZ;
 
 	if (mca_cfg.ignore_ce || !iv)
 		return;
 
+	per_cpu(mce_next_interval, cpu) = iv;
+
 	t->expires = round_jiffies(jiffies + iv);
-	add_timer_on(t, smp_processor_id());
+	add_timer_on(t, cpu);
 }
 
 static void __mcheck_cpu_init_timer(void)
@@ -2272,8 +2272,10 @@ static int mce_device_create(unsigned int cpu)
 	dev->release = &mce_device_release;
 
 	err = device_register(dev);
-	if (err)
+	if (err) {
+		put_device(dev);
 		return err;
+	}
 
 	for (i = 0; mce_device_attrs[i]; i++) {
 		err = device_create_file(dev, mce_device_attrs[i]);
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index a6869e1..5d33c54 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -12,6 +12,7 @@
 #include <acpi/acpi_bus.h>
 #include <linux/cper.h>
 #include <linux/ratelimit.h>
+#include <linux/edac.h>
 #include <asm/cpu.h>
 #include <asm/mce.h>
 
@@ -43,6 +44,8 @@ struct extlog_l1_head {
 	u8  rev1[12];
 };
 
+static int old_edac_report_status;
+
 static u8 extlog_dsm_uuid[] = "663E35AF-CC10-41A4-88EA-5470AF055295";
 
 /* L1 table related physical address */
@@ -150,7 +153,7 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 
 	rc = print_extlog_rcd(NULL, (struct acpi_generic_status *)elog_buf, cpu);
 
-	return NOTIFY_DONE;
+	return NOTIFY_STOP;
 }
 
 static int extlog_get_dsm(acpi_handle handle, int rev, int func, u64 *ret)
@@ -231,8 +234,12 @@ static int __init extlog_init(void)
 	u64 cap;
 	int rc;
 
-	rc = -ENODEV;
+	if (get_edac_report_status() == EDAC_REPORTING_FORCE) {
+		pr_warn("Not loading eMCA, error reporting force-enabled through EDAC.\n");
+		return -EPERM;
+	}
 
+	rc = -ENODEV;
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 	if (!(cap & MCG_ELOG_P))
 		return rc;
@@ -287,6 +294,12 @@ static int __init extlog_init(void)
 	if (elog_buf == NULL)
 		goto err_release_elog;
 
+	/*
+	 * eMCA event report method has higher priority than EDAC method,
+	 * unless EDAC event report method is mandatory.
+	 */
+	old_edac_report_status = get_edac_report_status();
+	set_edac_report_status(EDAC_REPORTING_DISABLED);
 	mce_register_decode_chain(&extlog_mce_dec);
 	/* enable OS to be involved to take over management from BIOS */
 	((struct extlog_l1_head *)extlog_l1_addr)->flags |= FLAG_OS_OPTIN;
@@ -308,6 +321,7 @@ err:
 
 static void __exit extlog_exit(void)
 {
+	set_edac_report_status(old_edac_report_status);
 	mce_unregister_decode_chain(&extlog_mce_dec);
 	((struct extlog_l1_head *)extlog_l1_addr)->flags &= ~FLAG_OS_OPTIN;
 	if (extlog_l1_addr)
diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 6d2c49b..e55584a 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -41,6 +41,7 @@
 #include <linux/rculist.h>
 #include <linux/interrupt.h>
 #include <linux/debugfs.h>
+#include <asm/unaligned.h>
 
 #include "apei-internal.h"
 
@@ -567,8 +568,7 @@ static int apei_check_gar(struct acpi_generic_address *reg, u64 *paddr,
 	bit_offset = reg->bit_offset;
 	access_size_code = reg->access_width;
 	space_id = reg->space_id;
-	/* Handle possible alignment issues */
-	memcpy(paddr, &reg->address, sizeof(*paddr));
+	*paddr = get_unaligned(&reg->address);
 	if (!*paddr) {
 		pr_warning(FW_BUG APEI_PFX
 			   "Invalid physical address in GAR [0x%llx/%u/%u/%u/%u]\n",
diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index fb57d03..7dcc8a8 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -34,6 +34,7 @@
 #include <linux/delay.h>
 #include <linux/mm.h>
 #include <acpi/acpi.h>
+#include <asm/unaligned.h>
 
 #include "apei-internal.h"
 
@@ -216,7 +217,7 @@ static void check_vendor_extension(u64 paddr,
 static void *einj_get_parameter_address(void)
 {
 	int i;
-	u64 paddrv4 = 0, paddrv5 = 0;
+	u64 pa_v4 = 0, pa_v5 = 0;
 	struct acpi_whea_header *entry;
 
 	entry = EINJ_TAB_ENTRY(einj_tab);
@@ -225,30 +226,28 @@ static void *einj_get_parameter_address(void)
 		    entry->instruction == ACPI_EINJ_WRITE_REGISTER &&
 		    entry->register_region.space_id ==
 		    ACPI_ADR_SPACE_SYSTEM_MEMORY)
-			memcpy(&paddrv4, &entry->register_region.address,
-			       sizeof(paddrv4));
+			pa_v4 = get_unaligned(&entry->register_region.address);
 		if (entry->action == ACPI_EINJ_SET_ERROR_TYPE_WITH_ADDRESS &&
 		    entry->instruction == ACPI_EINJ_WRITE_REGISTER &&
 		    entry->register_region.space_id ==
 		    ACPI_ADR_SPACE_SYSTEM_MEMORY)
-			memcpy(&paddrv5, &entry->register_region.address,
-			       sizeof(paddrv5));
+			pa_v5 = get_unaligned(&entry->register_region.address);
 		entry++;
 	}
-	if (paddrv5) {
+	if (pa_v5) {
 		struct set_error_type_with_address *v5param;
 
-		v5param = acpi_os_map_memory(paddrv5, sizeof(*v5param));
+		v5param = acpi_os_map_memory(pa_v5, sizeof(*v5param));
 		if (v5param) {
 			acpi5 = 1;
-			check_vendor_extension(paddrv5, v5param);
+			check_vendor_extension(pa_v5, v5param);
 			return v5param;
 		}
 	}
-	if (param_extension && paddrv4) {
+	if (param_extension && pa_v4) {
 		struct einj_parameter *v4param;
 
-		v4param = acpi_os_map_memory(paddrv4, sizeof(*v4param));
+		v4param = acpi_os_map_memory(pa_v4, sizeof(*v4param));
 		if (!v4param)
 			return NULL;
 		if (v4param->reserved1 || v4param->reserved2) {
@@ -416,7 +415,8 @@ out:
 	return rc;
 }
 
-static int __einj_error_inject(u32 type, u64 param1, u64 param2)
+static int __einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
+			       u64 param3, u64 param4)
 {
 	struct apei_exec_context ctx;
 	u64 val, trigger_paddr, timeout = FIRMWARE_TIMEOUT;
@@ -446,6 +446,12 @@ static int __einj_error_inject(u32 type, u64 param1, u64 param2)
 				break;
 			}
 			v5param->flags = vendor_flags;
+		} else if (flags) {
+				v5param->flags = flags;
+				v5param->memory_address = param1;
+				v5param->memory_address_range = param2;
+				v5param->apicid = param3;
+				v5param->pcie_sbdf = param4;
 		} else {
 			switch (type) {
 			case ACPI_EINJ_PROCESSOR_CORRECTABLE:
@@ -514,11 +520,17 @@ static int __einj_error_inject(u32 type, u64 param1, u64 param2)
 }
 
 /* Inject the specified hardware error */
-static int einj_error_inject(u32 type, u64 param1, u64 param2)
+static int einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
+			     u64 param3, u64 param4)
 {
 	int rc;
 	unsigned long pfn;
 
+	/* If user manually set "flags", make sure it is legal */
+	if (flags && (flags &
+		~(SETWA_FLAGS_APICID|SETWA_FLAGS_MEM|SETWA_FLAGS_PCIE_SBDF)))
+		return -EINVAL;
+
 	/*
 	 * We need extra sanity checks for memory errors.
 	 * Other types leap directly to injection.
@@ -532,7 +544,7 @@ static int einj_error_inject(u32 type, u64 param1, u64 param2)
 	if (type & ACPI5_VENDOR_BIT) {
 		if (vendor_flags != SETWA_FLAGS_MEM)
 			goto inject;
-	} else if (!(type & MEM_ERROR_MASK))
+	} else if (!(type & MEM_ERROR_MASK) && !(flags & SETWA_FLAGS_MEM))
 		goto inject;
 
 	/*
@@ -546,15 +558,18 @@ static int einj_error_inject(u32 type, u64 param1, u64 param2)
 
 inject:
 	mutex_lock(&einj_mutex);
-	rc = __einj_error_inject(type, param1, param2);
+	rc = __einj_error_inject(type, flags, param1, param2, param3, param4);
 	mutex_unlock(&einj_mutex);
 
 	return rc;
 }
 
 static u32 error_type;
+static u32 error_flags;
 static u64 error_param1;
 static u64 error_param2;
+static u64 error_param3;
+static u64 error_param4;
 static struct dentry *einj_debug_dir;
 
 static int available_error_type_show(struct seq_file *m, void *v)
@@ -648,7 +663,8 @@ static int error_inject_set(void *data, u64 val)
 	if (!error_type)
 		return -EINVAL;
 
-	return einj_error_inject(error_type, error_param1, error_param2);
+	return einj_error_inject(error_type, error_flags, error_param1, error_param2,
+		error_param3, error_param4);
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(error_inject_fops, NULL,
@@ -729,6 +745,10 @@ static int __init einj_init(void)
 	rc = -ENOMEM;
 	einj_param = einj_get_parameter_address();
 	if ((param_extension || acpi5) && einj_param) {
+		fentry = debugfs_create_x32("flags", S_IRUSR | S_IWUSR,
+					    einj_debug_dir, &error_flags);
+		if (!fentry)
+			goto err_unmap;
 		fentry = debugfs_create_x64("param1", S_IRUSR | S_IWUSR,
 					    einj_debug_dir, &error_param1);
 		if (!fentry)
@@ -737,6 +757,14 @@ static int __init einj_init(void)
 					    einj_debug_dir, &error_param2);
 		if (!fentry)
 			goto err_unmap;
+		fentry = debugfs_create_x64("param3", S_IRUSR | S_IWUSR,
+					    einj_debug_dir, &error_param3);
+		if (!fentry)
+			goto err_unmap;
+		fentry = debugfs_create_x64("param4", S_IRUSR | S_IWUSR,
+					    einj_debug_dir, &error_param4);
+		if (!fentry)
+			goto err_unmap;
 
 		fentry = debugfs_create_x32("notrigger", S_IRUSR | S_IWUSR,
 					    einj_debug_dir, &notrigger);
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index cb1d557..ed65e9c 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -611,7 +611,7 @@ static void __erst_record_id_cache_compact(void)
 		if (entries[i] == APEI_ERST_INVALID_RECORD_ID)
 			continue;
 		if (wpos != i)
-			memcpy(&entries[wpos], &entries[i], sizeof(entries[i]));
+			entries[wpos] = entries[i];
 		wpos++;
 	}
 	erst_record_id_cache.len = wpos;
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a30bc31..46766ef 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -413,27 +413,31 @@ static void ghes_handle_memory_failure(struct acpi_generic_data *gdata, int sev)
 {
 #ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
 	unsigned long pfn;
+	int flags = -1;
 	int sec_sev = ghes_severity(gdata->error_severity);
 	struct cper_sec_mem_err *mem_err;
 	mem_err = (struct cper_sec_mem_err *)(gdata + 1);
 
-	if (sec_sev == GHES_SEV_CORRECTED &&
-	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED) &&
-	    (mem_err->validation_bits & CPER_MEM_VALID_PA)) {
-		pfn = mem_err->physical_addr >> PAGE_SHIFT;
-		if (pfn_valid(pfn))
-			memory_failure_queue(pfn, 0, MF_SOFT_OFFLINE);
-		else if (printk_ratelimit())
-			pr_warn(FW_WARN GHES_PFX
-			"Invalid address in generic error data: %#llx\n",
-			mem_err->physical_addr);
-	}
-	if (sev == GHES_SEV_RECOVERABLE &&
-	    sec_sev == GHES_SEV_RECOVERABLE &&
-	    mem_err->validation_bits & CPER_MEM_VALID_PA) {
-		pfn = mem_err->physical_addr >> PAGE_SHIFT;
-		memory_failure_queue(pfn, 0, 0);
+	if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
+		return;
+
+	pfn = mem_err->physical_addr >> PAGE_SHIFT;
+	if (!pfn_valid(pfn)) {
+		pr_warn_ratelimited(FW_WARN GHES_PFX
+		"Invalid address in generic error data: %#llx\n",
+		mem_err->physical_addr);
+		return;
 	}
+
+	/* iff following two events can be handled properly by now */
+	if (sec_sev == GHES_SEV_CORRECTED &&
+	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
+		flags = MF_SOFT_OFFLINE;
+	if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)
+		flags = 0;
+
+	if (flags != -1)
+		memory_failure_queue(pfn, 0, flags);
 #endif
 }
 
@@ -453,8 +457,7 @@ static void ghes_do_proc(struct ghes *ghes,
 			ghes_edac_report_mem_error(ghes, sev, mem_err);
 
 #ifdef CONFIG_X86_MCE
-			apei_mce_report_mem_error(sev == GHES_SEV_CORRECTED,
-						  mem_err);
+			apei_mce_report_mem_error(sev, mem_err);
 #endif
 			ghes_handle_memory_failure(gdata, sev);
 		}
diff --git a/drivers/edac/edac_stub.c b/drivers/edac/edac_stub.c
index 351945f..9d9e18a 100644
--- a/drivers/edac/edac_stub.c
+++ b/drivers/edac/edac_stub.c
@@ -29,6 +29,25 @@ EXPORT_SYMBOL_GPL(edac_err_assert);
 
 static atomic_t edac_subsys_valid = ATOMIC_INIT(0);
 
+int edac_report_status = EDAC_REPORTING_ENABLED;
+EXPORT_SYMBOL_GPL(edac_report_status);
+
+static int __init edac_report_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!strncmp(str, "on", 2))
+		set_edac_report_status(EDAC_REPORTING_ENABLED);
+	else if (!strncmp(str, "off", 3))
+		set_edac_report_status(EDAC_REPORTING_DISABLED);
+	else if (!strncmp(str, "force", 5))
+		set_edac_report_status(EDAC_REPORTING_FORCE);
+
+	return 0;
+}
+__setup("edac_report=", edac_report_setup);
+
 /*
  * called to determine if there is an EDAC driver interested in
  * knowing an event (such as NMI) occurred
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index d7f1b57..1229123 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1829,6 +1829,9 @@ static int sbridge_mce_check_error(struct notifier_block *nb, unsigned long val,
 	struct mem_ctl_info *mci;
 	struct sbridge_pvt *pvt;
 
+	if (get_edac_report_status() == EDAC_REPORTING_DISABLED)
+		return NOTIFY_DONE;
+
 	mci = get_mci_for_node_id(mce->socketid);
 	if (!mci)
 		return NOTIFY_BAD;
@@ -2142,9 +2145,10 @@ static int __init sbridge_init(void)
 	opstate_init();
 
 	pci_rc = pci_register_driver(&sbridge_driver);
-
 	if (pci_rc >= 0) {
 		mce_register_decode_chain(&sbridge_mce_dec);
+		if (get_edac_report_status() == EDAC_REPORTING_DISABLED)
+			sbridge_printk(KERN_WARNING, "Loading driver, error reporting disabled.\n");
 		return 0;
 	}
 
diff --git a/include/linux/edac.h b/include/linux/edac.h
index dbdffe8..8e6c20a 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -35,6 +35,34 @@ extern void edac_atomic_assert_error(void);
 extern struct bus_type *edac_get_sysfs_subsys(void);
 extern void edac_put_sysfs_subsys(void);
 
+enum {
+	EDAC_REPORTING_ENABLED,
+	EDAC_REPORTING_DISABLED,
+	EDAC_REPORTING_FORCE
+};
+
+extern int edac_report_status;
+#ifdef CONFIG_EDAC
+static inline int get_edac_report_status(void)
+{
+	return edac_report_status;
+}
+
+static inline void set_edac_report_status(int new)
+{
+	edac_report_status = new;
+}
+#else
+static inline int get_edac_report_status(void)
+{
+	return EDAC_REPORTING_DISABLED;
+}
+
+static inline void set_edac_report_status(int new)
+{
+}
+#endif
+
 static inline void opstate_init(void)
 {
 	switch (edac_op_state) {
diff --git a/include/trace/events/ras.h b/include/trace/events/ras.h
index 88b8783..1c875ad 100644
--- a/include/trace/events/ras.h
+++ b/include/trace/events/ras.h
@@ -5,7 +5,7 @@
 #define _TRACE_AER_H
 
 #include <linux/tracepoint.h>
-#include <linux/edac.h>
+#include <linux/aer.h>
 
 
 /*
@@ -63,10 +63,10 @@ TRACE_EVENT(aer_event,
 
 	TP_printk("%s PCIe Bus Error: severity=%s, %s\n",
 		__get_str(dev_name),
-		__entry->severity == HW_EVENT_ERR_CORRECTED ? "Corrected" :
-			__entry->severity == HW_EVENT_ERR_FATAL ?
-			"Fatal" : "Uncorrected",
-		__entry->severity == HW_EVENT_ERR_CORRECTED ?
+		__entry->severity == AER_CORRECTABLE ? "Corrected" :
+			__entry->severity == AER_FATAL ?
+			"Fatal" : "Uncorrected, non-fatal",
+		__entry->severity == AER_CORRECTABLE ?
 		__print_flags(__entry->status, "|", aer_correctable_errors) :
 		__print_flags(__entry->status, "|", aer_uncorrectable_errors))
 );
