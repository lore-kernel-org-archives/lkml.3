Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3LBPUC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:20:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab3LBPTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:19:54 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/3] Introduce FW_WARN* functions and messages
Date: Mon,  2 Dec 2013 10:19:38 -0500
Message-Id: <1385997579-22240-3-git-send-email-prarit@redhat.com>
In-Reply-To: <1385997579-22240-1-git-send-email-prarit@redhat.com>
References: <1385997579-22240-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logging and tracking firmware bugs in the kernel has long been an issue
for system administrators.  The current kernel does not have a good
uniform method of reporting firmware bugs and the code in the kernel is a
mix of printk's and WARN_ONs.  This causes problems for both system
administrators and QA engineers who attempt to diagnose problems within
the kernel.

Using printk's is somewhat effective but lacks information useful for
reporting a bug such as the system vendor or model, BIOS revision, etc.
Using WARN_ONs is also questionable because the data like the backtrace
and the list of modules is usually unnecessary for firmware issues as the
warning stems from one call path during system or driver initialization.
We have heard many complaints from users about the excess verbosity and
confusing stacktraces for these messages.

I'm proposing with this patch to do something similar to the WARN()
mechanism that is currently implemented in the kernel.  This patchset
introduces FW_WARN() and FW_WARN_DEV() which logs output like:

[  230.661137] [Firmware Warn]: pci_bus 0000:00: at
/home/prarit_modules/prarit.c:21 Your BIOS is broken because it is
-ENOWORKY.  [  230.671076] [Firmware Warn]: Intel Corporation SandyBridge
Platform/To be filled by O.E.M., BIOS RMLCRB.86I.R3.27.D685.1305151733
05/15/2013

instead of the verbose back traces we are currently seeing.  These
messages can be easily gleaned from /var/log/messages, etc., by automatic
bug reporting tools and system administrators to properly report bugs to
hardware vendors.

Also made some usage corrections.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c          |    2 +-
 arch/x86/kernel/cpu/mtrr/generic.c |    2 +-
 drivers/acpi/apei/apei-base.c      |    8 ++++----
 drivers/acpi/apei/einj.c           |    3 +--
 drivers/acpi/apei/erst.c           |   15 ++++++---------
 drivers/acpi/apei/ghes.c           |   35 +++++++++++++++++------------------
 drivers/acpi/apei/hest.c           |   11 +++++------
 drivers/cpufreq/acpi-cpufreq.c     |    4 ++--
 drivers/cpufreq/powernow-k8.c      |    2 +-
 drivers/firmware/efi/cper.c        |    2 +-
 include/asm-generic/bug.h          |   21 +++++++++++++++++++++
 include/linux/printk.h             |    1 -
 12 files changed, 60 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index bca023b..1533b59 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -620,7 +620,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 			rdmsrl(0xc0011005, value);
 			if (value & (1ULL << 54)) {
 				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
-				printk(KERN_INFO FW_INFO "CPU: Re-enabling "
+				printk(KERN_INFO FW_BUG "CPU: Re-enabling "
 				  "disabled Topology Extensions Support\n");
 			}
 		}
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index ce2d0a2..bbab418 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -55,7 +55,7 @@ static inline void k8_check_syscfg_dram_mod_en(void)
 
 	rdmsr(MSR_K8_SYSCFG, lo, hi);
 	if (lo & K8_MTRRFIXRANGE_DRAM_MODIFY) {
-		printk(KERN_ERR FW_WARN "MTRR: CPU %u: SYSCFG[MtrrFixDramModEn]"
+		printk(KERN_ERR FW_BUG "MTRR: CPU %u: SYSCFG[MtrrFixDramModEn]"
 		       " not cleared by BIOS, clearing this bit\n",
 		       smp_processor_id());
 		lo &= ~K8_MTRRFIXRANGE_DRAM_MODIFY;
diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 6d2c49b..bba2bd5 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -182,7 +182,7 @@ rewind:
 		if (ip == ctx->ip) {
 			if (entry->instruction >= ctx->instructions ||
 			    !ctx->ins_table[entry->instruction].run) {
-				pr_warning(FW_WARN APEI_PFX
+				FW_WARN(1, APEI_PFX
 			"Invalid action table, unknown instruction type: %d\n",
 					   entry->instruction);
 				return -EINVAL;
@@ -223,9 +223,9 @@ static int apei_exec_for_each_entry(struct apei_exec_context *ctx,
 		if (end)
 			*end = i;
 		if (ins >= ctx->instructions || !ins_table[ins].run) {
-			pr_warning(FW_WARN APEI_PFX
-			"Invalid action table, unknown instruction type: %d\n",
-				   ins);
+			FW_WARN(1, APEI_PFX
+				"Invalid action table, unknown instruction type: %d\n",
+				ins);
 			return -EINVAL;
 		}
 		rc = func(ctx, entry, data);
diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index fb57d03..b32bda7 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -183,8 +183,7 @@ static int einj_get_available_error_type(u32 *type)
 static int einj_timedout(u64 *t)
 {
 	if ((s64)*t < SPIN_UNIT) {
-		pr_warning(FW_WARN EINJ_PFX
-			   "Firmware does not respond in time\n");
+		FW_WARN(1, EINJ_PFX "Firmware does not respond in time\n");
 		return 1;
 	}
 	*t -= SPIN_UNIT;
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 26311f2..dd47b38 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -110,7 +110,7 @@ static inline int erst_errno(int command_status)
 static int erst_timedout(u64 *t, u64 spin_unit)
 {
 	if ((s64)*t < spin_unit) {
-		pr_warn(FW_WARN "Firmware does not respond in time.\n");
+		FW_WARN(1, "Firmware does not respond in time.\n");
 		return 1;
 	}
 	*t -= spin_unit;
@@ -186,9 +186,8 @@ static int erst_exec_stall(struct apei_exec_context *ctx,
 
 	if (ctx->value > FIRMWARE_MAX_STALL) {
 		if (!in_nmi())
-			pr_warn(FW_WARN
-			"Too long stall time for stall instruction: 0x%llx.\n",
-				   ctx->value);
+			FW_WARN(1, "Too long stall time for stall instruction: 0x%llx.\n",
+				ctx->value);
 		stall_time = FIRMWARE_MAX_STALL;
 	} else
 		stall_time = ctx->value;
@@ -206,9 +205,8 @@ static int erst_exec_stall_while_true(struct apei_exec_context *ctx,
 
 	if (ctx->var1 > FIRMWARE_MAX_STALL) {
 		if (!in_nmi())
-			pr_warn(FW_WARN
-		"Too long stall time for stall while true instruction: 0x%llx.\n",
-				   ctx->var1);
+			FW_WARN(1, "Too long stall time for stall while true instruction: 0x%llx.\n",
+				ctx->var1);
 		stall_time = FIRMWARE_MAX_STALL;
 	} else
 		stall_time = ctx->var1;
@@ -522,8 +520,7 @@ retry:
 		new_size = clamp_val(new_size, ERST_RECORD_ID_CACHE_SIZE_MIN,
 				     ERST_RECORD_ID_CACHE_SIZE_MAX);
 		if (new_size <= erst_record_id_cache.size) {
-			if (printk_ratelimit())
-				pr_warn(FW_WARN "too many record IDs!\n");
+			FW_WARN(printk_ratelimit(), "too many record IDs!\n");
 			return 0;
 		}
 		alloc_size = new_size * sizeof(entries[0]);
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a30bc31..c84a4b88 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -270,10 +270,9 @@ static struct ghes *ghes_new(struct acpi_hest_generic *generic)
 		goto err_free;
 	error_block_length = generic->error_block_length;
 	if (error_block_length > GHES_ESTATUS_MAX_SIZE) {
-		pr_warning(FW_WARN GHES_PFX
-			   "Error status block length is too long: %u for "
-			   "generic hardware error source: %d.\n",
-			   error_block_length, generic->header.source_id);
+		FW_WARN(1,
+			GHES_PFX "Error status block length is too long: %u for generic hardware error source: %d.\n",
+			error_block_length, generic->header.source_id);
 		error_block_length = GHES_ESTATUS_MAX_SIZE;
 	}
 	ghes->estatus = kmalloc(error_block_length, GFP_KERNEL);
@@ -361,9 +360,9 @@ static int ghes_read_estatus(struct ghes *ghes, int silent)
 	rc = apei_read(&buf_paddr, &g->error_status_address);
 	if (rc) {
 		if (!silent && printk_ratelimit())
-			pr_warning(FW_WARN GHES_PFX
-"Failed to read error status block address for hardware error source: %d.\n",
-				   g->header.source_id);
+			FW_WARN(1,
+				GHES_PFX "Failed to read error status block address for hardware error source: %d.\n",
+				g->header.source_id);
 		return -EIO;
 	}
 	if (!buf_paddr)
@@ -393,9 +392,8 @@ static int ghes_read_estatus(struct ghes *ghes, int silent)
 	rc = 0;
 
 err_read_block:
-	if (rc && !silent && printk_ratelimit())
-		pr_warning(FW_WARN GHES_PFX
-			   "Failed to read error status block!\n");
+	FW_INFO((rc && !silent && printk_ratelimit()),
+		GHES_PFX "Failed to read error status block!\n");
 	return rc;
 }
 
@@ -423,10 +421,10 @@ static void ghes_handle_memory_failure(struct acpi_generic_data *gdata, int sev)
 		pfn = mem_err->physical_addr >> PAGE_SHIFT;
 		if (pfn_valid(pfn))
 			memory_failure_queue(pfn, 0, MF_SOFT_OFFLINE);
-		else if (printk_ratelimit())
-			pr_warn(FW_WARN GHES_PFX
-			"Invalid address in generic error data: %#llx\n",
-			mem_err->physical_addr);
+		else
+			FW_INFO((printk_ratelimit()),
+				GHES_PFX "Invalid address in generic error data: %#llx\n",
+				mem_err->physical_addr);
 	}
 	if (sev == GHES_SEV_RECOVERABLE &&
 	    sec_sev == GHES_SEV_RECOVERABLE &&
@@ -686,8 +684,9 @@ static void ghes_add_timer(struct ghes *ghes)
 	unsigned long expire;
 
 	if (!g->notify.poll_interval) {
-		pr_warning(FW_WARN GHES_PFX "Poll interval is 0 for generic hardware error source: %d, disabled.\n",
-			   g->header.source_id);
+		FW_WARN(1,
+			GHES_PFX "Poll interval is 0 for generic hardware error source: %d, disabled.\n",
+			g->header.source_id);
 		return;
 	}
 	expire = jiffies + msecs_to_jiffies(g->notify.poll_interval);
@@ -916,8 +915,8 @@ static int ghes_probe(struct platform_device *ghes_dev)
 			   generic->header.source_id);
 		goto err;
 	default:
-		pr_warning(FW_WARN GHES_PFX "Unknown notification type: %u for generic hardware error source: %d\n",
-			   generic->notify.type, generic->header.source_id);
+		FW_WARN(1, GHES_PFX "Unknown notification type: %u for generic hardware error source: %d\n",
+			generic->notify.type, generic->header.source_id);
 		goto err;
 	}
 
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index f5e37f3..4c74bca 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -97,10 +97,9 @@ int apei_hest_parse(apei_hest_func_t func, void *data)
 	for (i = 0; i < hest_tab->error_source_count; i++) {
 		len = hest_esrc_len(hest_hdr);
 		if (!len) {
-			pr_warning(FW_WARN HEST_PFX
-				   "Unknown or unused hardware error source "
-				   "type: %d for hardware error source: %d.\n",
-				   hest_hdr->type, hest_hdr->source_id);
+			FW_WARN(1, HEST_PFX
+				"Unknown or unused hardware error source type: %d for hardware error source: %d.\n",
+				hest_hdr->type, hest_hdr->source_id);
 			return -EINVAL;
 		}
 		if ((void *)hest_hdr + len >
@@ -187,8 +186,8 @@ static int __init hest_parse_ghes(struct acpi_hest_header *hest_hdr, void *data)
 		ghes_dev = ghes_arr->ghes_devs[i];
 		hdr = *(struct acpi_hest_header **)ghes_dev->dev.platform_data;
 		if (hdr->source_id == hest_hdr->source_id) {
-			pr_warning(FW_WARN HEST_PFX "Duplicated hardware error source ID: %d.\n",
-				   hdr->source_id);
+			FW_WARN(1, HEST_PFX "Duplicated hardware error source ID: %d.\n",
+				hdr->source_id);
 			return -EIO;
 		}
 	}
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index caf41eb..824c0a7 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -813,8 +813,8 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	if (result)
 		goto err_freqfree;
 
-	if (perf->states[0].core_frequency * 1000 != policy->cpuinfo.max_freq)
-		printk(KERN_WARNING FW_WARN "P-state 0 is not max freq\n");
+	FW_INFO((perf->states[0].core_frequency * 1000 != policy->cpuinfo.max_freq),
+		 "P-state 0 is not max freq\n");
 
 	switch (perf->control_register.space_id) {
 	case ACPI_ADR_SPACE_SYSTEM_IO:
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 0023c7d..6a521ff 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -917,7 +917,7 @@ static int get_transition_latency(struct powernow_k8_data *data)
 			max_latency = cur_latency;
 	}
 	if (max_latency == 0) {
-		pr_err(FW_WARN PFX "Invalid zero transition latency\n");
+		FW_WARN(1, PFX "Invalid zero transition latency\n");
 		max_latency = 1;
 	}
 	/* value in usecs, needs to be in nanoseconds */
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 1491dd4..e242265 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -340,7 +340,7 @@ static void cper_estatus_print_section(
 	return;
 
 err_section_too_small:
-	pr_err(FW_WARN "error section length is too small\n");
+	FW_WARN(1, "error section length is too small\n");
 }
 
 void cper_estatus_print(const char *pfx,
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index b3cb4ed..e829d76 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -130,6 +130,14 @@ extern void warn_slowpath_null(const char *file, const int line);
 })
 #define FW_INFO(condition, format...) FW_INFO_DEV(condition, NULL, format)
 
+#define FW_WARN_DEV(condition, dev, format...) ({			\
+	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on))					\
+		__WARN_printf_dev(dev, 2, format);			\
+	unlikely(__ret_warn_on);					\
+})
+#define FW_WARN(condition, format...) FW_WARN_DEV(condition, NULL, format)
+
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG() do {} while(0)
@@ -166,6 +174,19 @@ extern void warn_slowpath_null(const char *file, const int line);
 	pr_info(format);						\
 	unlikely(__ret_warn_on);					\
 })
+
+#define FW_WARN_DEV(condition, dev, format...) ({			\
+	int __ret_warn_on = !!(condition);				\
+	dev_warn(format);						\
+	unlikely(__ret_warn_on);					\
+})
+
+#define FW_WARN(condition, format...) ({				\
+	int __ret_warn_on = !!(condition);				\
+	pr_warn(format);						\
+	unlikely(__ret_warn_on);					\
+})
+
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
diff --git a/include/linux/printk.h b/include/linux/printk.h
index db540cc..c5cf420 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -71,7 +71,6 @@ struct va_format {
  * and medium priority BIOS bugs.
  */
 #define FW_BUG		"[Firmware Bug]: "
-#define FW_WARN		"[Firmware Warn]: "
 
 /*
  * HW_ERR
-- 
1.7.9.3

