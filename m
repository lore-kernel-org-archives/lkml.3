Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab3LBPUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:20:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab3LBPT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:19:58 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/3] Introduce FW_BUG* functions and messages
Date: Mon,  2 Dec 2013 10:19:39 -0500
Message-Id: <1385997579-22240-4-git-send-email-prarit@redhat.com>
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
introduces FW_BUG() and FW_BUG_DEV() which logs output like:

[  230.661137] [Firmware Bug]: pci_bus 0000:00: at
/home/prarit_modules/prarit.c:21 Your BIOS is broken because it is
-ENOWORKY.  [  230.671076] [Firmware Bug]: Intel Corporation SandyBridge
Platform/To be filled by O.E.M., BIOS RMLCRB.86I.R3.27.D685.1305151733
05/15/2013

instead of the verbose back traces we are currently seeing.  These
messages can be easily gleaned from /var/log/messages, etc., by automatic
bug reporting tools and system administrators to properly report bugs to
hardware vendors.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/apic/apic.c              |    8 ++---
 arch/x86/kernel/cpu/amd.c                |    9 +++--
 arch/x86/kernel/cpu/mcheck/mce.c         |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c     |   12 +++----
 arch/x86/kernel/cpu/mtrr/generic.c       |    4 +--
 arch/x86/kernel/cpu/perf_event.c         |    8 ++---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   10 +++---
 arch/x86/pci/mmconfig-shared.c           |    3 +-
 drivers/acpi/apei/apei-base.c            |   32 +++++++++---------
 drivers/acpi/apei/einj.c                 |    6 ++--
 drivers/acpi/apei/erst.c                 |    2 +-
 drivers/acpi/apei/ghes.c                 |    7 ++--
 drivers/acpi/apei/hest.c                 |    4 +--
 drivers/acpi/battery.c                   |   12 ++++---
 drivers/acpi/osl.c                       |    6 ++--
 drivers/acpi/pci_root.c                  |    4 +--
 drivers/acpi/processor_perflib.c         |   16 ++++-----
 drivers/acpi/thermal.c                   |    5 ++-
 drivers/acpi/video.c                     |   17 ++++------
 drivers/acpi/video_detect.c              |    4 +--
 drivers/cpufreq/powernow-k8.c            |   54 ++++++++++++++----------------
 drivers/firmware/dmi_scan.c              |    2 +-
 drivers/iommu/amd_iommu_init.c           |   24 ++++++++-----
 drivers/iommu/dmar.c                     |    3 +-
 drivers/iommu/intel_irq_remapping.c      |    4 +--
 drivers/pci/quirks.c                     |    2 +-
 drivers/pnp/quirks.c                     |    4 +--
 include/asm-generic/bug.h                |   22 ++++++++++++
 include/linux/printk.h                   |   16 ---------
 29 files changed, 149 insertions(+), 153 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d278736..d5a3ff7 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -437,17 +437,13 @@ int setup_APIC_eilvt(u8 offset, u8 vector, u8 msg_type, u8 mask)
 	reserved = reserve_eilvt_offset(offset, new);
 
 	if (reserved != new) {
-		pr_err(FW_BUG "cpu %d, try to use APIC%lX (LVT offset %d) for "
-		       "vector 0x%x, but the register is already in use for "
-		       "vector 0x%x on another cpu\n",
+		FW_WARN(1, "cpu %d, try to use APIC%lX (LVT offset %d) for vector 0x%x, but the register is already in use for vector 0x%x on another cpu\n",
 		       smp_processor_id(), reg, offset, new, reserved);
 		return -EINVAL;
 	}
 
 	if (!eilvt_entry_is_changeable(old, new)) {
-		pr_err(FW_BUG "cpu %d, try to use APIC%lX (LVT offset %d) for "
-		       "vector 0x%x, but the register is already in use for "
-		       "vector 0x%x on this cpu\n",
+		FW_WARN(1, "cpu %d, try to use APIC%lX (LVT offset %d) for vector 0x%x, but the register is already in use for vector 0x%x on this cpu\n",
 		       smp_processor_id(), reg, offset, new, old);
 		return -EBUSY;
 	}
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 1533b59..e33636c 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -456,9 +456,8 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 			u64 val;
 
 			rdmsrl(MSR_K7_HWCR, val);
-			if (!(val & BIT(24)))
-				printk(KERN_WARNING FW_BUG "TSC doesn't count "
-					"with P0 frequency!\n");
+			FW_INFO((!(val & BIT(24))),
+				"TSC doesn't count with P0 frequency!\n");
 		}
 	}
 
@@ -620,8 +619,8 @@ static void init_amd(struct cpuinfo_x86 *c)
 			rdmsrl(0xc0011005, value);
 			if (value & (1ULL << 54)) {
 				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
-				printk(KERN_INFO FW_BUG "CPU: Re-enabling "
-				  "disabled Topology Extensions Support\n");
+				FW_BUG(1,
+				       "CPU: Re-enabling disabled Topology Extensions Support\n");
 			}
 		}
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b3218cd..326e58d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1954,7 +1954,7 @@ static void __mce_disable_bank(void *arg)
 void mce_disable_bank(int bank)
 {
 	if (bank >= mca_cfg.banks) {
-		pr_warn(FW_BUG
+		FW_WARN(1,
 			"Ignoring request to disable invalid MCA bank %d.\n",
 			bank);
 		return;
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 603df4f..e06974f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -119,16 +119,16 @@ static int lvt_off_valid(struct threshold_block *b, int apic, u32 lo, u32 hi)
 	int msr = (hi & MASK_LVTOFF_HI) >> 20;
 
 	if (apic < 0) {
-		pr_err(FW_BUG "cpu %d, failed to setup threshold interrupt "
-		       "for bank %d, block %d (MSR%08X=0x%x%08x)\n", b->cpu,
-		       b->bank, b->block, b->address, hi, lo);
+		FW_WARN(1,
+			"cpu %d, failed to setup threshold interrupt for bank %d, block %d (MSR%08X=0x%x%08x)\n",
+			 b->cpu, b->bank, b->block, b->address, hi, lo);
 		return 0;
 	}
 
 	if (apic != msr) {
-		pr_err(FW_BUG "cpu %d, invalid threshold interrupt offset %d "
-		       "for bank %d, block %d (MSR%08X=0x%x%08x)\n",
-		       b->cpu, apic, b->bank, b->block, b->address, hi, lo);
+		FW_WARN(1,
+			"cpu %d, invalid threshold interrupt offset %d for bank %d, block %d (MSR%08X=0x%x%08x)\n",
+			b->cpu, apic, b->bank, b->block, b->address, hi, lo);
 		return 0;
 	}
 
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index bbab418..831a468 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -55,8 +55,8 @@ static inline void k8_check_syscfg_dram_mod_en(void)
 
 	rdmsr(MSR_K8_SYSCFG, lo, hi);
 	if (lo & K8_MTRRFIXRANGE_DRAM_MODIFY) {
-		printk(KERN_ERR FW_BUG "MTRR: CPU %u: SYSCFG[MtrrFixDramModEn]"
-		       " not cleared by BIOS, clearing this bit\n",
+		FW_BUG(1,
+		       "MTRR: CPU %u: SYSCFG[MtrrFixDramModEn] not cleared by BIOS, clearing this bit\n",
 		       smp_processor_id());
 		lo &= ~K8_MTRRFIXRANGE_DRAM_MODIFY;
 		mtrr_wrmsr(MSR_K8_SYSCFG, lo, hi);
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8e13293..1fc4aad 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -231,16 +231,14 @@ static bool check_hw_exists(void)
 	/*
 	 * We still allow the PMU driver to operate:
 	 */
-	if (bios_fail) {
-		printk(KERN_CONT "Broken BIOS detected, complain to your hardware vendor.\n");
-		printk(KERN_ERR FW_BUG "the BIOS has corrupted hw-PMU resources (MSR %x is %Lx)\n", reg_fail, val_fail);
-	}
+	FW_INFO(bios_fail,
+		"The BIOS has corrupted hw-PMU resources (MSR %x is %Lx)\n", reg_fail, val_fail);
 
 	return true;
 
 msr_fail:
 	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
-	printk(KERN_ERR "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
+	printk(KERN_ERR HW_ERR "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
 
 	return false;
 }
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index e09f0bf..461e3be 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -719,14 +719,16 @@ static inline int ibs_eilvt_valid(void)
 	offset = val & IBSCTL_LVT_OFFSET_MASK;
 
 	if (!(val & IBSCTL_LVT_OFFSET_VALID)) {
-		pr_err(FW_BUG "cpu %d, invalid IBS interrupt offset %d (MSR%08X=0x%016llx)\n",
-		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
+		FW_WARN(1,
+			"cpu %d, invalid IBS interrupt offset %d (MSR%08X=0x%016llx)\n",
+			smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
 		goto out;
 	}
 
 	if (!get_eilvt(offset)) {
-		pr_err(FW_BUG "cpu %d, IBS interrupt offset %d not available (MSR%08X=0x%016llx)\n",
-		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
+		FW_WARN(1,
+			"cpu %d, IBS interrupt offset %d not available (MSR%08X=0x%016llx)\n",
+			smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
 		goto out;
 	}
 
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 3cb0eff..cf54185 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -718,8 +718,7 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
 		dev_warn(dev, "fail to add MMCONFIG (out of memory)\n");
 		rc = -ENOMEM;
 	} else if (!pci_mmcfg_check_reserved(dev, cfg, 0)) {
-		dev_warn(dev, FW_BUG "MMCONFIG %pR isn't reserved\n",
-			 &cfg->res);
+		FW_INFO_DEV(1, dev, "MMCONFIG %pR isn't reserved\n", &cfg->res);
 	} else {
 		/* Insert resource if it's not in boot stage */
 		if (pci_mmcfg_running_state)
diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index bba2bd5..bcadea3 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -570,18 +570,18 @@ static int apei_check_gar(struct acpi_generic_address *reg, u64 *paddr,
 	/* Handle possible alignment issues */
 	memcpy(paddr, &reg->address, sizeof(*paddr));
 	if (!*paddr) {
-		pr_warning(FW_BUG APEI_PFX
-			   "Invalid physical address in GAR [0x%llx/%u/%u/%u/%u]\n",
-			   *paddr, bit_width, bit_offset, access_size_code,
-			   space_id);
+		FW_WARN(1,
+			APEI_PFX "Invalid physical address in GAR [0x%llx/%u/%u/%u/%u]\n",
+			*paddr, bit_width, bit_offset, access_size_code,
+			space_id);
 		return -EINVAL;
 	}
 
 	if (access_size_code < 1 || access_size_code > 4) {
-		pr_warning(FW_BUG APEI_PFX
-			   "Invalid access size code in GAR [0x%llx/%u/%u/%u/%u]\n",
-			   *paddr, bit_width, bit_offset, access_size_code,
-			   space_id);
+		FW_WARN(1,
+			APEI_PFX "Invalid access size code in GAR [0x%llx/%u/%u/%u/%u]\n",
+			*paddr, bit_width, bit_offset, access_size_code,
+			space_id);
 		return -EINVAL;
 	}
 	*access_bit_width = 1UL << (access_size_code + 2);
@@ -595,19 +595,19 @@ static int apei_check_gar(struct acpi_generic_address *reg, u64 *paddr,
 		*access_bit_width = 64;
 
 	if ((bit_width + bit_offset) > *access_bit_width) {
-		pr_warning(FW_BUG APEI_PFX
-			   "Invalid bit width + offset in GAR [0x%llx/%u/%u/%u/%u]\n",
-			   *paddr, bit_width, bit_offset, access_size_code,
-			   space_id);
+		FW_WARN(1,
+			APEI_PFX "Invalid bit width + offset in GAR [0x%llx/%u/%u/%u/%u]\n",
+			*paddr, bit_width, bit_offset, access_size_code,
+			space_id);
 		return -EINVAL;
 	}
 
 	if (space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY &&
 	    space_id != ACPI_ADR_SPACE_SYSTEM_IO) {
-		pr_warning(FW_BUG APEI_PFX
-			   "Invalid address space type in GAR [0x%llx/%u/%u/%u/%u]\n",
-			   *paddr, bit_width, bit_offset, access_size_code,
-			   space_id);
+		FW_WARN(1,
+			APEI_PFX "Invalid address space type in GAR [0x%llx/%u/%u/%u/%u]\n",
+			*paddr, bit_width, bit_offset, access_size_code,
+			space_id);
 		return -EINVAL;
 	}
 
diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index b32bda7..4864cf4 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -326,8 +326,8 @@ static int __einj_error_trigger(u64 trigger_paddr, u32 type,
 	}
 	rc = einj_check_trigger_header(trigger_tab);
 	if (rc) {
-		pr_warning(FW_BUG EINJ_PFX
-			   "The trigger error action table is invalid\n");
+		FW_WARN(1,
+			EINJ_PFX "The trigger error action table is invalid\n");
 		goto out_rel_header;
 	}
 
@@ -691,7 +691,7 @@ static int __init einj_init(void)
 
 	rc = einj_check_table(einj_tab);
 	if (rc) {
-		pr_warning(FW_BUG EINJ_PFX "EINJ table is invalid\n");
+		FW_WARN(1, EINJ_PFX "EINJ table is invalid\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index dd47b38..17f561c 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -1145,7 +1145,7 @@ static int __init erst_init(void)
 
 	rc = erst_check_table(erst_tab);
 	if (rc) {
-		pr_err(FW_BUG "ERST table is invalid.\n");
+		FW_WARN(1, "ERST table is invalid.\n");
 		goto err;
 	}
 
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index c84a4b88..5953995 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -923,9 +923,10 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	rc = -EIO;
 	if (generic->error_block_length <
 	    sizeof(struct acpi_generic_status)) {
-		pr_warning(FW_BUG GHES_PFX "Invalid error block length: %u for generic hardware error source: %d\n",
-			   generic->error_block_length,
-			   generic->header.source_id);
+		FW_WARN(1,
+			GHES_PFX "Invalid error block length: %u for generic hardware error source: %d\n",
+			generic->error_block_length,
+			generic->header.source_id);
 		goto err;
 	}
 	ghes = ghes_new(generic);
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index 4c74bca..b3b6e79 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -104,8 +104,8 @@ int apei_hest_parse(apei_hest_func_t func, void *data)
 		}
 		if ((void *)hest_hdr + len >
 		    (void *)hest_tab + hest_tab->header.length) {
-			pr_warning(FW_BUG HEST_PFX
-		"Table contents overflow for hardware error source: %d.\n",
+			FW_WARN(1,
+				HEST_PFX "Table contents overflow for hardware error source: %d.\n",
 				hest_hdr->source_id);
 			return -EINVAL;
 		}
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index fbf1ace..24e9e01 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -449,6 +449,7 @@ static int acpi_battery_get_state(struct acpi_battery *battery)
 	int result = 0;
 	acpi_status status = 0;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	static bool print_once;
 
 	if (!acpi_battery_present(battery))
 		return 0;
@@ -477,12 +478,13 @@ static int acpi_battery_get_state(struct acpi_battery *battery)
 	 * charging or discharging current and/or report 0 as 65536
 	 * due to bad math.
 	 */
-	if (battery->power_unit == ACPI_BATTERY_POWER_UNIT_MA &&
-		battery->rate_now != ACPI_BATTERY_VALUE_UNKNOWN &&
-		(s16)(battery->rate_now) < 0) {
+	if ((print_once == false) &&
+	    battery->power_unit == ACPI_BATTERY_POWER_UNIT_MA &&
+	    battery->rate_now != ACPI_BATTERY_VALUE_UNKNOWN &&
+	    (s16)(battery->rate_now) < 0) {
 		battery->rate_now = abs((s16)battery->rate_now);
-		printk_once(KERN_WARNING FW_BUG "battery: (dis)charge rate"
-			" invalid.\n");
+		FW_INFO(1, "battery: (dis)charge rate invalid.\n");
+		print_once = true;
 	}
 
 	if (test_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags)
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 54a20ff..6550672 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -148,14 +148,12 @@ static struct osi_linux {
 static u32 acpi_osi_handler(acpi_string interface, u32 supported)
 {
 	if (!strcmp("Linux", interface)) {
-
-		printk_once(KERN_NOTICE FW_BUG PREFIX
-			"BIOS _OSI(Linux) query %s%s\n",
+		FW_INFO(1,
+			PREFIX "BIOS _OSI(Linux) query %s%s\n",
 			osi_linux.enable ? "honored" : "ignored",
 			osi_linux.cmdline ? " via cmdline" :
 			osi_linux.dmi ? " via DMI" : "");
 	}
-
 	return supported;
 }
 
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 20360e4..cf970ff 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -533,8 +533,8 @@ static int acpi_pci_root_add(struct acpi_device *device,
 		 * can do is assume [_BBN-0xFF] or [0-0xFF].
 		 */
 		root->secondary.end = 0xFF;
-		dev_warn(&device->dev,
-			 FW_BUG "no secondary bus range in _CRS\n");
+		FW_INFO_DEV(1, &device->dev,
+			    "no secondary bus range in _CRS\n");
 		status = acpi_evaluate_integer(handle, METHOD_NAME__BBN,
 					       NULL, &bus);
 		if (ACPI_SUCCESS(status))
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 60a7c28..3ee2ef9 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -404,8 +404,8 @@ static int acpi_processor_get_performance_states(struct acpi_processor *pr)
 		if (!px->core_frequency ||
 		    ((u32)(px->core_frequency * 1000) !=
 		     (px->core_frequency * 1000))) {
-			printk(KERN_ERR FW_BUG PREFIX
-			       "Invalid BIOS _PSS frequency found for processor %d: 0x%llx MHz\n",
+			FW_WARN(1,
+			       PREFIX "Invalid BIOS _PSS frequency found for processor %d: 0x%llx MHz\n",
 			       pr->id, px->core_frequency);
 			if (last_invalid == -1)
 				last_invalid = i;
@@ -422,8 +422,8 @@ static int acpi_processor_get_performance_states(struct acpi_processor *pr)
 	}
 
 	if (last_invalid == 0) {
-		printk(KERN_ERR FW_BUG PREFIX
-		       "No valid BIOS _PSS frequency found for processor %d\n", pr->id);
+		FW_WARN(1,
+			PREFIX "No valid BIOS _PSS frequency found for processor %d\n", pr->id);
 		result = -EFAULT;
 		kfree(pr->performance->states);
 		pr->performance->states = NULL;
@@ -471,11 +471,9 @@ int acpi_processor_get_performance_info(struct acpi_processor *pr)
 	 */
  update_bios:
 #ifdef CONFIG_X86
-	if (acpi_has_method(pr->handle, "_PPC")) {
-		if(boot_cpu_has(X86_FEATURE_EST))
-			printk(KERN_WARNING FW_BUG "BIOS needs update for CPU "
-			       "frequency support\n");
-	}
+	FW_INFO((acpi_has_method(pr->handle, "_PPC") &&
+		 boot_cpu_has(X86_FEATURE_EST)),
+		"BIOS needs update for CPU frequency support\n");
 #endif
 	return result;
 }
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 0d9f46b..03da53a 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -299,8 +299,7 @@ static int acpi_thermal_trips_update(struct acpi_thermal *tz, int flag)
 			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 					  "No critical threshold\n"));
 		} else if (tmp <= 2732) {
-			pr_warn(FW_BUG "Invalid critical threshold (%llu)\n",
-				tmp);
+			FW_WARN(1, "Invalid critical threshold (%llu)\n", tmp);
 			tz->trips.critical.flags.valid = 0;
 		} else {
 			tz->trips.critical.flags.valid = 1;
@@ -504,7 +503,7 @@ static int acpi_thermal_get_trip_points(struct acpi_thermal *tz)
 		valid |= tz->trips.active[i].flags.valid;
 
 	if (!valid) {
-		pr_warn(FW_BUG "No valid trip found\n");
+		FW_WARN(1, "No valid trip found\n");
 		return -ENODEV;
 	}
 	return 0;
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 995e91b..cf32eee 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -833,7 +833,7 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 	if (acpi_has_method(device->dev->handle, "_BQC")) {
 		device->cap._BQC = 1;
 	} else if (acpi_has_method(device->dev->handle, "_BCQ")) {
-		printk(KERN_WARNING FW_BUG "_BCQ is used instead of _BQC\n");
+		FW_WARN(1, "_BCQ is used instead of _BQC\n");
 		device->cap._BCQ = 1;
 	}
 
@@ -892,11 +892,9 @@ static int acpi_video_bus_check(struct acpi_video_bus *video)
 
 	/* Does this device support video switching? */
 	if (video->cap._DOS || video->cap._DOD) {
-		if (!video->cap._DOS) {
-			printk(KERN_WARNING FW_BUG
-				"ACPI(%s) defines _DOD but not _DOS\n",
-				acpi_device_bid(video->device));
-		}
+		FW_WARN((!video->cap._DOS),
+			"ACPI(%s) defines _DOD but not _DOS\n",
+			acpi_device_bid(video->device));
 		video->flags.multihead = 1;
 		status = 0;
 	}
@@ -1746,11 +1744,8 @@ static int acpi_video_bus_add(struct acpi_device *device)
 				acpi_video_bus_match, NULL,
 				device, NULL);
 	if (status == AE_ALREADY_EXISTS) {
-		printk(KERN_WARNING FW_BUG
-			"Duplicate ACPI video bus devices for the"
-			" same VGA controller, please try module "
-			"parameter \"video.allow_duplicates=1\""
-			"if the current driver doesn't work.\n");
+		FW_INFO(1,
+			"Duplicate ACPI video bus devices for the same VGA controller, please try module parameter \"video.allow_duplicates=1\" if the current driver doesn't work.\n");
 		if (!allow_duplicates)
 			return -ENODEV;
 	}
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 84875fd..fb6e817 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -60,8 +60,8 @@ acpi_backlight_cap_match(acpi_handle handle, u32 level, void *context,
 				  "support\n"));
 		*cap |= ACPI_VIDEO_BACKLIGHT;
 		if (!acpi_has_method(handle, "_BQC"))
-			printk(KERN_WARNING FW_BUG PREFIX "No _BQC method, "
-				"cannot determine initial brightness\n");
+			FW_WARN(1,
+				"No _BQC method, cannot determine initial brightness\n");
 		/* We have backlight support, no need to scan further */
 		return AE_CTRL_TERMINATE;
 	}
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 6a521ff..1ea9308 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -529,43 +529,39 @@ static int check_pst_table(struct powernow_k8_data *data, struct pst_s *pst,
 
 	for (j = 0; j < data->numps; j++) {
 		if (pst[j].vid > LEAST_VID) {
-			printk(KERN_ERR FW_BUG PFX "vid %d invalid : 0x%x\n",
-			       j, pst[j].vid);
+			FW_WARN(1, PFX "vid %d invalid : 0x%x\n",
+				j, pst[j].vid);
 			return -EINVAL;
 		}
 		if (pst[j].vid < data->rvo) {
 			/* vid + rvo >= 0 */
-			printk(KERN_ERR FW_BUG PFX "0 vid exceeded with pstate"
-			       " %d\n", j);
+			FW_WARN(1, PFX "0 vid exceeded with pstate %d\n", j);
 			return -ENODEV;
 		}
 		if (pst[j].vid < maxvid + data->rvo) {
 			/* vid + rvo >= maxvid */
-			printk(KERN_ERR FW_BUG PFX "maxvid exceeded with pstate"
-			       " %d\n", j);
+			FW_WARN(1, PFX "maxvid exceeded with pstate %d\n", j);
 			return -ENODEV;
 		}
 		if (pst[j].fid > MAX_FID) {
-			printk(KERN_ERR FW_BUG PFX "maxfid exceeded with pstate"
-			       " %d\n", j);
+			FW_WARN(1, PFX "maxfid exceeded with pstate %d\n", j);
 			return -ENODEV;
 		}
 		if (j && (pst[j].fid < HI_FID_TABLE_BOTTOM)) {
 			/* Only first fid is allowed to be in "low" range */
-			printk(KERN_ERR FW_BUG PFX "two low fids - %d : "
-			       "0x%x\n", j, pst[j].fid);
+			FW_WARN(1, PFX "two low fids - %d : 0x%x\n",
+				j, pst[j].fid);
 			return -EINVAL;
 		}
 		if (pst[j].fid < lastfid)
 			lastfid = pst[j].fid;
 	}
 	if (lastfid & 1) {
-		printk(KERN_ERR FW_BUG PFX "lastfid invalid\n");
+		FW_WARN(1, PFX "lastfid invalid\n");
 		return -EINVAL;
 	}
-	if (lastfid > LO_FID_TABLE_TOP)
-		printk(KERN_INFO FW_BUG PFX
-			"first fid not from lo freq table\n");
+	FW_INFO((lastfid > LO_FID_TABLE_TOP),
+		PFX "first fid not from lo freq table\n");
 
 	return 0;
 }
@@ -681,13 +677,13 @@ static int find_psb_table(struct powernow_k8_data *data)
 
 		pr_debug("table vers: 0x%x\n", psb->tableversion);
 		if (psb->tableversion != PSB_VERSION_1_4) {
-			printk(KERN_ERR FW_BUG PFX "PSB table is not v1.4\n");
+			FW_WARN(1, PFX "PSB table is not v1.4\n");
 			return -ENODEV;
 		}
 
 		pr_debug("flags: 0x%x\n", psb->flags1);
 		if (psb->flags1) {
-			printk(KERN_ERR FW_BUG PFX "unknown flags\n");
+			FW_WARN(1, PFX "unknown flags\n");
 			return -ENODEV;
 		}
 
@@ -716,7 +712,7 @@ static int find_psb_table(struct powernow_k8_data *data)
 				cpst = 1;
 		}
 		if (cpst != 1) {
-			printk(KERN_ERR FW_BUG PFX "numpst must be 1\n");
+			FW_WARN(1, PFX "numpst must be 1\n");
 			return -ENODEV;
 		}
 
@@ -742,9 +738,8 @@ static int find_psb_table(struct powernow_k8_data *data)
 	 * BIOS and Kernel Developer's Guide, which is available on
 	 * www.amd.com
 	 */
-	printk(KERN_ERR FW_BUG PFX "No PSB or ACPI _PSS objects\n");
-	printk(KERN_ERR PFX "Make sure that your BIOS is up to date"
-		" and Cool'N'Quiet support is enabled in BIOS setup\n");
+	FW_INFO(1,
+		PFX "No PSB or ACPI _PSS objects.  Make sure that your BIOS is up to date and Cool'N'Quiet support is enabled in BIOS setup\n");
 	return -ENODEV;
 }
 
@@ -1072,9 +1067,9 @@ static void powernowk8_cpu_init_on_cpu(void *_init_on_cpu)
 
 static const char missing_pss_msg[] =
 	KERN_ERR
-	FW_BUG PFX "No compatible ACPI _PSS objects found.\n"
-	FW_BUG PFX "First, make sure Cool'N'Quiet is enabled in the BIOS.\n"
-	FW_BUG PFX "If that doesn't help, try upgrading your BIOS.\n";
+	PFX "No compatible ACPI _PSS objects found.\n"
+	PFX "First, make sure Cool'N'Quiet is enabled in the BIOS.\n"
+	PFX "If that doesn't help, try upgrading your BIOS.\n";
 
 /* per CPU init entry point to the driver */
 static int powernowk8_cpu_init(struct cpufreq_policy *pol)
@@ -1082,6 +1077,7 @@ static int powernowk8_cpu_init(struct cpufreq_policy *pol)
 	struct powernow_k8_data *data;
 	struct init_on_cpu init_on_cpu;
 	int rc;
+	static bool print_once;
 
 	smp_call_function_single(pol->cpu, check_supported_cpu, &rc, 1);
 	if (rc)
@@ -1101,13 +1097,15 @@ static int powernowk8_cpu_init(struct cpufreq_policy *pol)
 		 * an UP version, and is deprecated by AMD.
 		 */
 		if (num_online_cpus() != 1) {
-			printk_once(missing_pss_msg);
+			if (print_once == false) {
+				FW_WARN(1, missing_pss_msg);
+				print_once = true;
+			}
 			goto err_out;
 		}
 		if (pol->cpu != 0) {
-			printk(KERN_ERR FW_BUG PFX "No ACPI _PSS objects for "
-			       "CPU other than CPU0. Complain to your BIOS "
-			       "vendor.\n");
+			FW_WARN(1,
+				PFX "No ACPI _PSS objects for CPU other than CPU0.\n");
 			goto err_out;
 		}
 		rc = find_psb_table(data);
@@ -1135,7 +1133,7 @@ static int powernowk8_cpu_init(struct cpufreq_policy *pol)
 
 	/* min/max the cpu is capable of */
 	if (cpufreq_table_validate_and_show(pol, data->powernow_table)) {
-		printk(KERN_ERR FW_BUG PFX "invalid powernow_table\n");
+		FW_WARN(1, PFX "invalid powernow_table\n");
 		powernow_k8_cpu_exit_acpi(data);
 		kfree(data->powernow_table);
 		kfree(data);
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index c7e81ff..b9623af 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -345,7 +345,7 @@ static void __init save_mem_devices(const struct dmi_header *dm, void *v)
 	if (dm->type != DMI_ENTRY_MEM_DEVICE)
 		return;
 	if (nr >= dmi_memdev_nr) {
-		pr_warn(FW_BUG "Too many DIMM entries in SMBIOS table\n");
+		FW_WARN(1, "Too many DIMM entries in SMBIOS table\n");
 		return;
 	}
 	dmi_memdev[nr].handle = get_unaligned(&dm->handle);
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 8f798be..2e10c54 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1728,7 +1728,6 @@ static void __init free_on_init_error(void)
 
 static bool __init check_ioapic_information(void)
 {
-	const char *fw_bug = FW_BUG;
 	bool ret, has_sb_ioapic;
 	int idx;
 
@@ -1736,20 +1735,23 @@ static bool __init check_ioapic_information(void)
 	ret           = false;
 
 	/*
-	 * If we have map overrides on the kernel command line the
-	 * messages in this function might not describe firmware bugs
-	 * anymore - so be careful
+	 * If we have map overrides on the kernel command line,
+	 * ie) cmdline_maps is true, then the messages in this function
+	 * might not describe firmware bugs anymore.
 	 */
-	if (cmdline_maps)
-		fw_bug = "";
 
 	for (idx = 0; idx < nr_ioapics; idx++) {
 		int devid, id = mpc_ioapic_id(idx);
 
 		devid = get_ioapic_devid(id);
 		if (devid < 0) {
-			pr_err("%sAMD-Vi: IOAPIC[%d] not in IVRS table\n",
-				fw_bug, id);
+			if (cmdline_maps)
+				pr_err("AMD-Vi: IOAPIC[%d] not in IVRS table\n",
+				       id);
+			else
+				FW_WARN(1,
+					"AMD-Vi: IOAPIC[%d] not in IVRS table\n",
+					id);
 			ret = false;
 		} else if (devid == IOAPIC_SB_DEVID) {
 			has_sb_ioapic = true;
@@ -1766,7 +1768,11 @@ static bool __init check_ioapic_information(void)
 		 * when the BIOS is buggy and provides us the wrong
 		 * device id for the IOAPIC in the system.
 		 */
-		pr_err("%sAMD-Vi: No southbridge IOAPIC found\n", fw_bug);
+		if (cmdline_maps)
+			pr_err("AMD-Vi: No southbridge IOAPIC found\n");
+		else
+			FW_INFO(1, "AMD-Vi: No southbridge IOAPIC found\n");
+
 	}
 
 	if (!ret)
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 8b452c9..941ef5c 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -373,8 +373,7 @@ parse_dmar_table(void)
 
 		entry_header = ((void *)entry_header + entry_header->length);
 	}
-	if (drhd_count == 0)
-		pr_warn(FW_BUG "No DRHD structure found in DMAR table\n");
+	FW_INFO(!drhd_count, "No DRHD structure found in DMAR table\n");
 	return ret;
 }
 
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index bab10b1..489c448 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -797,8 +797,8 @@ int __init parse_ioapics_under_ir(void)
 	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
 		int ioapic_id = mpc_ioapic_id(ioapic_idx);
 		if (!map_ioapic_to_ir(ioapic_id)) {
-			pr_err(FW_BUG "ioapic %d has no mapping iommu, "
-			       "interrupt remapping will be disabled\n",
+			FW_WARN(1,
+				"ioapic %d has no mapping iommu, interrupt remapping will be disabled\n",
 			       ioapic_id);
 			return -1;
 		}
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 3a02717..e84a8a9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -112,7 +112,7 @@ static void quirk_tigerpoint_bm_sts(struct pci_dev *dev)
 	pm1a = inw(pmbase);
 
 	if (pm1a & 0x10) {
-		dev_info(&dev->dev, FW_BUG "TigerPoint LPC.BM_STS cleared\n");
+		FW_WARN_DEV(1, &dev->dev, "TigerPoint LPC.BM_STS cleared\n");
 		outw(0x10, pmbase);
 	}
 }
diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 258fef2..78b4ea2 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -316,8 +316,8 @@ static void quirk_amd_mmconfig_area(struct pnp_dev *dev)
 		    (res->start == mmconfig->start && res->end == mmconfig->end))
 			continue;
 
-		dev_info(&dev->dev, FW_BUG
-			 "%pR covers only part of AMD MMCONFIG area %pR; adding more reservations\n",
+		FW_WARN_DEV(1, &dev->dev,
+			"%pR covers only part of AMD MMCONFIG area %pR; adding more reservations\n",
 			 res, mmconfig);
 		if (mmconfig->start < res->start) {
 			start = mmconfig->start;
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index e829d76..a3dee84 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -138,6 +138,15 @@ extern void warn_slowpath_null(const char *file, const int line);
 })
 #define FW_WARN(condition, format...) FW_WARN_DEV(condition, NULL, format)
 
+#define FW_BUG_DEV(condition, dev, format...) ({			\
+	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on))					\
+		__WARN_printf_dev(dev, 3, format);			\
+	unlikely(__ret_warn_on);					\
+})
+#define FW_BUG(condition, format...) FW_BUG_DEV(condition, NULL, format)
+
+
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG() do {} while(0)
@@ -187,6 +196,19 @@ extern void warn_slowpath_null(const char *file, const int line);
 	unlikely(__ret_warn_on);					\
 })
 
+#define FW_BUG_DEV(condition, dev, format...) ({			\
+	int __ret_warn_on = !!(condition);				\
+	dev_warn(format);						\
+	unlikely(__ret_warn_on);					\
+})
+
+#define FW_BUG(condition, format...) ({					\
+	int __ret_warn_on = !!(condition);				\
+	pr_warn(format);						\
+	unlikely(__ret_warn_on);					\
+})
+
+
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
diff --git a/include/linux/printk.h b/include/linux/printk.h
index c5cf420..4fafb68 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -57,22 +57,6 @@ struct va_format {
 };
 
 /*
- * FW_BUG
- * Add this to a message where you are sure the firmware is buggy or behaves
- * really stupid or out of spec. Be aware that the responsible BIOS developer
- * should be able to fix this issue or at least get a concrete idea of the
- * problem by reading your message without the need of looking at the kernel
- * code.
- *
- * Use it for definite and high priority BIOS bugs.
- *
- * FW_WARN
- * Use it for not that clear (e.g. could the kernel messed up things already?)
- * and medium priority BIOS bugs.
- */
-#define FW_BUG		"[Firmware Bug]: "
-
-/*
  * HW_ERR
  * Add this to a message for hardware errors, so that user can report
  * it to hardware vendor instead of LKML or software vendor.
-- 
1.7.9.3

