Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaBLLrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:47:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45705 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaBLLrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:47:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.30
Date: Wed, 12 Feb 2014 11:46:51 +0000
Message-Id: <1392205611-21479-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392205611-21479-1-git-send-email-luis.henriques@canonical.com>
References: <1392205611-21479-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index fb0a6ae..a3d5e7d 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1333,8 +1333,8 @@ may allocate from based on an estimation of its current memory and swap use.
 For example, if a task is using all allowed memory, its badness score will be
 1000.  If it is using half of its allowed memory, its score will be 500.
 
-There is an additional factor included in the badness score: root
-processes are given 3% extra memory over other tasks.
+There is an additional factor included in the badness score: the current memory
+and swap usage is discounted by 3% for root processes.
 
 The amount of "allowed" memory depends on the context in which the oom killer
 was called.  If it is due to the memory assigned to the allocating task's cpuset
diff --git a/Makefile b/Makefile
index e3d51be..b532f56 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .29
+EXTRAVERSION = .30
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/alpha/lib/csum_partial_copy.c b/arch/alpha/lib/csum_partial_copy.c
index 40736da..1d2ef5a 100644
--- a/arch/alpha/lib/csum_partial_copy.c
+++ b/arch/alpha/lib/csum_partial_copy.c
@@ -373,6 +373,11 @@ csum_partial_copy_from_user(const void __user *src, void *dst, int len,
 __wsum
 csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum)
 {
-	return csum_partial_copy_from_user((__force const void __user *)src,
-			dst, len, sum, NULL);
+	__wsum checksum;
+	mm_segment_t oldfs = get_fs();
+	set_fs(KERNEL_DS);
+	checksum = csum_partial_copy_from_user((__force const void __user *)src,
+						dst, len, sum, NULL);
+	set_fs(oldfs);
+	return checksum;
 }
diff --git a/arch/arm/mach-at91/sam9_smc.c b/arch/arm/mach-at91/sam9_smc.c
index 99a0a1d..b26156b 100644
--- a/arch/arm/mach-at91/sam9_smc.c
+++ b/arch/arm/mach-at91/sam9_smc.c
@@ -101,7 +101,7 @@ static void sam9_smc_cs_read(void __iomem *base,
 	/* Pulse register */
 	val = __raw_readl(base + AT91_SMC_PULSE);
 
-	config->nwe_setup = val & AT91_SMC_NWEPULSE;
+	config->nwe_pulse = val & AT91_SMC_NWEPULSE;
 	config->ncs_write_pulse = (val & AT91_SMC_NCS_WRPULSE) >> 8;
 	config->nrd_pulse = (val & AT91_SMC_NRDPULSE) >> 16;
 	config->ncs_read_pulse = (val & AT91_SMC_NCS_RDPULSE) >> 24;
diff --git a/arch/powerpc/kernel/cacheinfo.c b/arch/powerpc/kernel/cacheinfo.c
index 92c6b00..b4437e8 100644
--- a/arch/powerpc/kernel/cacheinfo.c
+++ b/arch/powerpc/kernel/cacheinfo.c
@@ -788,6 +788,9 @@ static void remove_cache_dir(struct cache_dir *cache_dir)
 {
 	remove_index_dirs(cache_dir);
 
+	/* Remove cache dir from sysfs */
+	kobject_del(cache_dir->kobj);
+
 	kobject_put(cache_dir->kobj);
 
 	kfree(cache_dir);
diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index 3580a0c..5871b4e 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -358,7 +358,7 @@ static void clear_tlb_refs(struct kvmppc_vcpu_e500 *vcpu_e500)
 }
 
 static inline void kvmppc_e500_deliver_tlb_miss(struct kvm_vcpu *vcpu,
-		unsigned int eaddr, int as)
+		gva_t eaddr, int as)
 {
 	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
 	unsigned int victim, tsized;
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index b23d9ac..e071600 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -103,7 +103,7 @@ static int __diag_ipl_functions(struct kvm_vcpu *vcpu)
 
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
 {
-	int code = (vcpu->arch.sie_block->ipb & 0xfff0000) >> 16;
+	int code = kvm_s390_get_base_disp_rs(vcpu) & 0xffff;
 
 	switch (code) {
 	case 0x10:
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 4018f6e..6eea380 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/ptrace.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/apic.h>
 
@@ -777,6 +778,18 @@ out:
 	return ret;
 }
 
+static void ibs_eilvt_setup(void)
+{
+	/*
+	 * Force LVT offset assignment for family 10h: The offsets are
+	 * not assigned by the BIOS for this family, so the OS is
+	 * responsible for doing it. If the OS assignment fails, fall
+	 * back to BIOS settings and try to setup this.
+	 */
+	if (boot_cpu_data.x86 == 0x10)
+		force_ibs_eilvt_setup();
+}
+
 static inline int get_ibs_lvt_offset(void)
 {
 	u64 val;
@@ -812,6 +825,36 @@ static void clear_APIC_ibs(void *dummy)
 		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
 }
 
+#ifdef CONFIG_PM
+
+static int perf_ibs_suspend(void)
+{
+	clear_APIC_ibs(NULL);
+	return 0;
+}
+
+static void perf_ibs_resume(void)
+{
+	ibs_eilvt_setup();
+	setup_APIC_ibs(NULL);
+}
+
+static struct syscore_ops perf_ibs_syscore_ops = {
+	.resume		= perf_ibs_resume,
+	.suspend	= perf_ibs_suspend,
+};
+
+static void perf_ibs_pm_init(void)
+{
+	register_syscore_ops(&perf_ibs_syscore_ops);
+}
+
+#else
+
+static inline void perf_ibs_pm_init(void) { }
+
+#endif
+
 static int __cpuinit
 perf_ibs_cpu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 {
@@ -838,18 +881,12 @@ static __init int amd_ibs_init(void)
 	if (!caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
-	/*
-	 * Force LVT offset assignment for family 10h: The offsets are
-	 * not assigned by the BIOS for this family, so the OS is
-	 * responsible for doing it. If the OS assignment fails, fall
-	 * back to BIOS settings and try to setup this.
-	 */
-	if (boot_cpu_data.x86 == 0x10)
-		force_ibs_eilvt_setup();
+	ibs_eilvt_setup();
 
 	if (!ibs_eilvt_valid())
 		goto out;
 
+	perf_ibs_pm_init();
 	get_online_cpus();
 	ibs_caps = caps;
 	/* make ibs_caps visible to other cpus: */
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 46e5387..884a437 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -432,7 +432,7 @@ void __init efi_reserve_boot_services(void)
 		 * - Not within any part of the kernel
 		 * - Not the bios reserved area
 		*/
-		if ((start+size >= virt_to_phys(_text)
+		if ((start + size > virt_to_phys(_text)
 				&& start <= virt_to_phys(_end)) ||
 			!e820_all_mapped(start, start+size, E820_RAM) ||
 			memblock_is_region_reserved(start, size)) {
diff --git a/arch/x86/xen/platform-pci-unplug.c b/arch/x86/xen/platform-pci-unplug.c
index ffcf261..2923f51 100644
--- a/arch/x86/xen/platform-pci-unplug.c
+++ b/arch/x86/xen/platform-pci-unplug.c
@@ -68,6 +68,80 @@ static int check_platform_magic(void)
 	return 0;
 }
 
+bool xen_has_pv_devices()
+{
+	if (!xen_domain())
+		return false;
+
+	/* PV domains always have them. */
+	if (xen_pv_domain())
+		return true;
+
+	/* And user has xen_platform_pci=0 set in guest config as
+	 * driver did not modify the value. */
+	if (xen_platform_pci_unplug == 0)
+		return false;
+
+	if (xen_platform_pci_unplug & XEN_UNPLUG_NEVER)
+		return false;
+
+	if (xen_platform_pci_unplug & XEN_UNPLUG_ALL)
+		return true;
+
+	/* This is an odd one - we are going to run legacy
+	 * and PV drivers at the same time. */
+	if (xen_platform_pci_unplug & XEN_UNPLUG_UNNECESSARY)
+		return true;
+
+	/* And the caller has to follow with xen_pv_{disk,nic}_devices
+	 * to be certain which driver can load. */
+	return false;
+}
+EXPORT_SYMBOL_GPL(xen_has_pv_devices);
+
+static bool __xen_has_pv_device(int state)
+{
+	/* HVM domains might or might not */
+	if (xen_hvm_domain() && (xen_platform_pci_unplug & state))
+		return true;
+
+	return xen_has_pv_devices();
+}
+
+bool xen_has_pv_nic_devices(void)
+{
+	return __xen_has_pv_device(XEN_UNPLUG_ALL_NICS | XEN_UNPLUG_ALL);
+}
+EXPORT_SYMBOL_GPL(xen_has_pv_nic_devices);
+
+bool xen_has_pv_disk_devices(void)
+{
+	return __xen_has_pv_device(XEN_UNPLUG_ALL_IDE_DISKS |
+				   XEN_UNPLUG_AUX_IDE_DISKS | XEN_UNPLUG_ALL);
+}
+EXPORT_SYMBOL_GPL(xen_has_pv_disk_devices);
+
+/*
+ * This one is odd - it determines whether you want to run PV _and_
+ * legacy (IDE) drivers together. This combination is only possible
+ * under HVM.
+ */
+bool xen_has_pv_and_legacy_disk_devices(void)
+{
+	if (!xen_domain())
+		return false;
+
+	/* N.B. This is only ever used in HVM mode */
+	if (xen_pv_domain())
+		return false;
+
+	if (xen_platform_pci_unplug & XEN_UNPLUG_UNNECESSARY)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(xen_has_pv_and_legacy_disk_devices);
+
 void xen_unplug_emulated_devices(void)
 {
 	int r;
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 54a5732..bb5aab4 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -33,6 +33,7 @@
 #include <linux/proc_fs.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
+#include <linux/regulator/machine.h>
 #ifdef CONFIG_X86
 #include <asm/mpspec.h>
 #endif
@@ -957,6 +958,14 @@ void __init acpi_early_init(void)
 		goto error0;
 	}
 
+	/*
+	 * If the system is using ACPI then we can be reasonably
+	 * confident that any regulators are managed by the firmware
+	 * so tell the regulator core it has everything it needs to
+	 * know.
+	 */
+	regulator_has_full_constraints();
+
 	return;
 
       error0:
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index e4fb337..1188f4e 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -995,7 +995,7 @@ static int blkfront_probe(struct xenbus_device *dev,
 		char *type;
 		int len;
 		/* no unplug has been done: do not hook devices != xen vbds */
-		if (xen_platform_pci_unplug & XEN_UNPLUG_UNNECESSARY) {
+		if (xen_has_pv_and_legacy_disk_devices()) {
 			int major;
 
 			if (!VDEV_IS_EXTENDED(vdevice))
@@ -1512,7 +1512,7 @@ static int __init xlblk_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
-	if (xen_hvm_domain() && !xen_platform_pci_unplug)
+	if (!xen_has_pv_disk_devices())
 		return -ENODEV;
 
 	if (register_blkdev(XENVBD_MAJOR, DEV_NAME)) {
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 3186512..847f248 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1182,9 +1182,11 @@ static int e752x_get_devs(struct pci_dev *pdev, int dev_idx,
 	pvt->bridge_ck = pci_get_device(PCI_VENDOR_ID_INTEL,
 				pvt->dev_info->err_dev, pvt->bridge_ck);
 
-	if (pvt->bridge_ck == NULL)
+	if (pvt->bridge_ck == NULL) {
 		pvt->bridge_ck = pci_scan_single_device(pdev->bus,
 							PCI_DEVFN(0, 1));
+		pci_dev_get(pvt->bridge_ck);
+	}
 
 	if (pvt->bridge_ck == NULL) {
 		e752x_printk(KERN_ERR, "error reporting device not found:"
diff --git a/drivers/gpu/drm/cirrus/cirrus_mode.c b/drivers/gpu/drm/cirrus/cirrus_mode.c
index 100f630..93d4fef 100644
--- a/drivers/gpu/drm/cirrus/cirrus_mode.c
+++ b/drivers/gpu/drm/cirrus/cirrus_mode.c
@@ -274,8 +274,8 @@ static int cirrus_crtc_mode_set(struct drm_crtc *crtc,
 		sr07 |= 0x11;
 		break;
 	case 16:
-		sr07 |= 0xc1;
-		hdr = 0xc0;
+		sr07 |= 0x17;
+		hdr = 0xc1;
 		break;
 	case 24:
 		sr07 |= 0x15;
diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index 4324c0d..64bc1fa 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -942,7 +942,10 @@ static int evergreen_cs_track_check(struct radeon_cs_parser *p)
 	if (track->cb_dirty) {
 		tmp = track->cb_target_mask;
 		for (i = 0; i < 8; i++) {
-			if ((tmp >> (i * 4)) & 0xF) {
+			u32 format = G_028C70_FORMAT(track->cb_color_info[i]);
+
+			if (format != V_028C70_COLOR_INVALID &&
+			    (tmp >> (i * 4)) & 0xF) {
 				/* at least one component is enabled */
 				if (track->cb_color_bo[i] == NULL) {
 					dev_warn(p->dev, "%s:%d mask 0x%08X | 0x%08X no cb for %d\n",
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 3458d4a..ec1a029 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2249,14 +2249,17 @@ void r600_fence_ring_emit(struct radeon_device *rdev,
 			  struct radeon_fence *fence)
 {
 	struct radeon_ring *ring = &rdev->ring[fence->ring];
+	u32 cp_coher_cntl = PACKET3_TC_ACTION_ENA | PACKET3_VC_ACTION_ENA |
+		PACKET3_SH_ACTION_ENA;
+
+	if (rdev->family >= CHIP_RV770)
+		cp_coher_cntl |= PACKET3_FULL_CACHE_ENA;
 
 	if (rdev->wb.use_event) {
 		u64 addr = rdev->fence_drv[fence->ring].gpu_addr;
 		/* flush read cache over gart */
 		radeon_ring_write(ring, PACKET3(PACKET3_SURFACE_SYNC, 3));
-		radeon_ring_write(ring, PACKET3_TC_ACTION_ENA |
-					PACKET3_VC_ACTION_ENA |
-					PACKET3_SH_ACTION_ENA);
+		radeon_ring_write(ring, cp_coher_cntl);
 		radeon_ring_write(ring, 0xFFFFFFFF);
 		radeon_ring_write(ring, 0);
 		radeon_ring_write(ring, 10); /* poll interval */
@@ -2270,9 +2273,7 @@ void r600_fence_ring_emit(struct radeon_device *rdev,
 	} else {
 		/* flush read cache over gart */
 		radeon_ring_write(ring, PACKET3(PACKET3_SURFACE_SYNC, 3));
-		radeon_ring_write(ring, PACKET3_TC_ACTION_ENA |
-					PACKET3_VC_ACTION_ENA |
-					PACKET3_SH_ACTION_ENA);
+		radeon_ring_write(ring, cp_coher_cntl);
 		radeon_ring_write(ring, 0xFFFFFFFF);
 		radeon_ring_write(ring, 0);
 		radeon_ring_write(ring, 10); /* poll interval */
diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index c05e88a..d11c75e 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -747,7 +747,10 @@ static int r600_cs_track_check(struct radeon_cs_parser *p)
 	if (track->cb_dirty) {
 		tmp = track->cb_target_mask;
 		for (i = 0; i < 8; i++) {
-			if ((tmp >> (i * 4)) & 0xF) {
+			u32 format = G_0280A0_FORMAT(track->cb_color_info[i]);
+
+			if (format != V_0280A0_COLOR_INVALID &&
+			    (tmp >> (i * 4)) & 0xF) {
 				/* at least one component is enabled */
 				if (track->cb_color_bo[i] == NULL) {
 					dev_warn(p->dev, "%s:%d mask 0x%08X | 0x%08X no cb for %d\n",
diff --git a/drivers/gpu/drm/radeon/r600d.h b/drivers/gpu/drm/radeon/r600d.h
index 025fd5b..6dea105 100644
--- a/drivers/gpu/drm/radeon/r600d.h
+++ b/drivers/gpu/drm/radeon/r600d.h
@@ -1108,6 +1108,7 @@
 #define	PACKET3_INDIRECT_BUFFER				0x32
 #define	PACKET3_SURFACE_SYNC				0x43
 #              define PACKET3_CB0_DEST_BASE_ENA    (1 << 6)
+#              define PACKET3_FULL_CACHE_ENA       (1 << 20) /* r7xx+ only */
 #              define PACKET3_TC_ACTION_ENA        (1 << 23)
 #              define PACKET3_VC_ACTION_ENA        (1 << 24)
 #              define PACKET3_CB_ACTION_ENA        (1 << 25)
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index c54d295..6d0c32b 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2785,6 +2785,10 @@ void radeon_atom_initialize_bios_scratch_regs(struct drm_device *dev)
 	/* tell the bios not to handle mode switching */
 	bios_6_scratch |= ATOM_S6_ACC_BLOCK_DISPLAY_SWITCH;
 
+	/* clear the vbios dpms state */
+	if (ASIC_IS_DCE4(rdev))
+		bios_2_scratch &= ~ATOM_S2_DEVICE_DPMS_STATE;
+
 	if (rdev->family >= CHIP_R600) {
 		WREG32(R600_BIOS_2_SCRATCH, bios_2_scratch);
 		WREG32(R600_BIOS_6_SCRATCH, bios_6_scratch);
diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/radeon_i2c.c
index 6076e85..19d68c5 100644
--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -1020,6 +1020,9 @@ void radeon_i2c_destroy(struct radeon_i2c_chan *i2c)
 /* Add the default buses */
 void radeon_i2c_init(struct radeon_device *rdev)
 {
+	if (radeon_hw_i2c)
+		DRM_INFO("hw_i2c forced on, you may experience display detection problems!\n");
+
 	if (rdev->is_atom_bios)
 		radeon_atombios_i2c_init(rdev);
 	else
diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index c7f3d6c..bb51395 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -575,8 +575,10 @@ void radeon_pm_resume(struct radeon_device *rdev)
 	rdev->pm.current_clock_mode_index = 0;
 	rdev->pm.current_sclk = rdev->pm.default_sclk;
 	rdev->pm.current_mclk = rdev->pm.default_mclk;
-	rdev->pm.current_vddc = rdev->pm.power_state[rdev->pm.default_power_state_index].clock_info[0].voltage.voltage;
-	rdev->pm.current_vddci = rdev->pm.power_state[rdev->pm.default_power_state_index].clock_info[0].voltage.vddci;
+	if (rdev->pm.power_state) {
+		rdev->pm.current_vddc = rdev->pm.power_state[rdev->pm.default_power_state_index].clock_info[0].voltage.voltage;
+		rdev->pm.current_vddci = rdev->pm.power_state[rdev->pm.default_power_state_index].clock_info[0].voltage.vddci;
+	}
 	if (rdev->pm.pm_method == PM_METHOD_DYNPM
 	    && rdev->pm.dynpm_state == DYNPM_STATE_SUSPENDED) {
 		rdev->pm.dynpm_state = DYNPM_STATE_ACTIVE;
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index fba26ee..8929be4 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -53,7 +53,7 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 
 #define BASE_SYSFS_ATTR_NO	2	/* Sysfs Base attr no for coretemp */
 #define NUM_REAL_CORES		32	/* Number of Real cores per cpu */
-#define CORETEMP_NAME_LENGTH	17	/* String Length of attrs */
+#define CORETEMP_NAME_LENGTH	19	/* String Length of attrs */
 #define MAX_CORE_ATTRS		4	/* Maximum no of basic attrs */
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
 #define MAX_CORE_DATA		(NUM_REAL_CORES + BASE_SYSFS_ATTR_NO)
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index a468bf2..9c96545 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -57,13 +57,20 @@ static void qib_ud_loopback(struct qib_qp *sqp, struct qib_swqe *swqe)
 	struct qib_sge *sge;
 	struct ib_wc wc;
 	u32 length;
+	enum ib_qp_type sqptype, dqptype;
 
 	qp = qib_lookup_qpn(ibp, swqe->wr.wr.ud.remote_qpn);
 	if (!qp) {
 		ibp->n_pkt_drops++;
 		return;
 	}
-	if (qp->ibqp.qp_type != sqp->ibqp.qp_type ||
+
+	sqptype = sqp->ibqp.qp_type == IB_QPT_GSI ?
+			IB_QPT_UD : sqp->ibqp.qp_type;
+	dqptype = qp->ibqp.qp_type == IB_QPT_GSI ?
+			IB_QPT_UD : qp->ibqp.qp_type;
+
+	if (dqptype != sqptype ||
 	    !(ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK)) {
 		ibp->n_pkt_drops++;
 		goto drop;
diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
index 02ca868..521b07c5 100644
--- a/drivers/input/misc/xen-kbdfront.c
+++ b/drivers/input/misc/xen-kbdfront.c
@@ -29,6 +29,7 @@
 #include <xen/interface/io/fbif.h>
 #include <xen/interface/io/kbdif.h>
 #include <xen/xenbus.h>
+#include <xen/platform_pci.h>
 
 struct xenkbd_info {
 	struct input_dev *kbd;
@@ -377,6 +378,9 @@ static int __init xenkbd_init(void)
 	if (xen_initial_domain())
 		return -ENODEV;
 
+	if (!xen_has_pv_devices())
+		return -ENODEV;
+
 	return xenbus_register_frontend(&xenkbd_driver);
 }
 
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index f3535d9..2052974 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -914,7 +914,7 @@ static void dma_pte_free_level(struct dmar_domain *domain, int level,
 
 		/* If range covers entire pagetable, free it */
 		if (!(start_pfn > level_pfn ||
-		      last_pfn < level_pfn + level_size(level))) {
+		      last_pfn < level_pfn + level_size(level) - 1)) {
 			dma_clear_pte(pte);
 			domain_flush_cache(domain, pte, sizeof(*pte));
 			free_pgtable_page(level_pte);
diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index 84d2b91..e0cc5d6 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -79,6 +79,11 @@ static const struct sysfs_ops dm_sysfs_ops = {
 	.show	= dm_attr_show,
 };
 
+static void dm_kobject_release(struct kobject *kobj)
+{
+	complete(dm_get_completion_from_kobject(kobj));
+}
+
 /*
  * dm kobject is embedded in mapped_device structure
  * no need to define release function here
@@ -86,6 +91,7 @@ static const struct sysfs_ops dm_sysfs_ops = {
 static struct kobj_type dm_ktype = {
 	.sysfs_ops	= &dm_sysfs_ops,
 	.default_attrs	= dm_attrs,
+	.release	= dm_kobject_release,
 };
 
 /*
@@ -104,5 +110,7 @@ int dm_sysfs_init(struct mapped_device *md)
  */
 void dm_sysfs_exit(struct mapped_device *md)
 {
-	kobject_put(dm_kobject(md));
+	struct kobject *kobj = dm_kobject(md);
+	kobject_put(kobj);
+	wait_for_completion(dm_get_completion_from_kobject(kobj));
 }
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 7ef83d9..a9bac03 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -964,13 +964,17 @@ static int ensure_next_mapping(struct pool *pool)
 
 static struct dm_thin_new_mapping *get_next_mapping(struct pool *pool)
 {
-	struct dm_thin_new_mapping *r = pool->next_mapping;
+	struct dm_thin_new_mapping *m = pool->next_mapping;
 
 	BUG_ON(!pool->next_mapping);
 
+	memset(m, 0, sizeof(struct dm_thin_new_mapping));
+	INIT_LIST_HEAD(&m->list);
+	m->bio = NULL;
+
 	pool->next_mapping = NULL;
 
-	return r;
+	return m;
 }
 
 static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
@@ -982,15 +986,10 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	struct pool *pool = tc->pool;
 	struct dm_thin_new_mapping *m = get_next_mapping(pool);
 
-	INIT_LIST_HEAD(&m->list);
-	m->quiesced = 0;
-	m->prepared = 0;
 	m->tc = tc;
 	m->virt_block = virt_block;
 	m->data_block = data_dest;
 	m->cell = cell;
-	m->err = 0;
-	m->bio = NULL;
 
 	if (!ds_add_work(&pool->shared_read_ds, &m->list))
 		m->quiesced = 1;
@@ -1052,15 +1051,12 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 	struct pool *pool = tc->pool;
 	struct dm_thin_new_mapping *m = get_next_mapping(pool);
 
-	INIT_LIST_HEAD(&m->list);
 	m->quiesced = 1;
 	m->prepared = 0;
 	m->tc = tc;
 	m->virt_block = virt_block;
 	m->data_block = data_block;
 	m->cell = cell;
-	m->err = 0;
-	m->bio = NULL;
 
 	/*
 	 * If the whole block of data is being overwritten or we are not
@@ -1224,7 +1220,6 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 			m->data_block = lookup_result.block;
 			m->cell = cell;
 			m->cell2 = cell2;
-			m->err = 0;
 			m->bio = bio;
 
 			if (!ds_add_work(&pool->all_io_ds, &m->list)) {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9a7290b..062f89a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -194,6 +194,9 @@ struct mapped_device {
 	/* sysfs handle */
 	struct kobject kobj;
 
+	/* wait until the kobject is released */
+	struct completion kobj_completion;
+
 	/* zero-length flush that will be cloned and submitted to targets */
 	struct bio flush_bio;
 };
@@ -1898,6 +1901,7 @@ static struct mapped_device *alloc_dev(int minor)
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
+	init_completion(&md->kobj_completion);
 
 	md->disk->major = _major;
 	md->disk->first_minor = minor;
@@ -2712,6 +2716,13 @@ struct mapped_device *dm_get_from_kobject(struct kobject *kobj)
 	return md;
 }
 
+struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
+{
+	struct mapped_device *md = container_of(kobj, struct mapped_device, kobj);
+
+	return &md->kobj_completion;
+}
+
 int dm_suspended_md(struct mapped_device *md)
 {
 	return test_bit(DMF_SUSPENDED, &md->flags);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index b7dacd5..1174e96 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -15,6 +15,7 @@
 #include <linux/list.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
+#include <linux/completion.h>
 
 /*
  * Suspend feature flags
@@ -123,6 +124,7 @@ int dm_sysfs_init(struct mapped_device *md);
 void dm_sysfs_exit(struct mapped_device *md);
 struct kobject *dm_kobject(struct mapped_device *md);
 struct mapped_device *dm_get_from_kobject(struct kobject *kobj);
+struct completion *dm_get_completion_from_kobject(struct kobject *kobj);
 
 /*
  * Targets for linear and striped mappings
diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index ff3beed..79c02d9 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -244,6 +244,10 @@ int sm_ll_extend(struct ll_disk *ll, dm_block_t extra_blocks)
 		return -EINVAL;
 	}
 
+	/*
+	 * We need to set this before the dm_tm_new_block() call below.
+	 */
+	ll->nr_blocks = nr_blocks;
 	for (i = old_blocks; i < blocks; i++) {
 		struct dm_block *b;
 		struct disk_index_entry idx;
@@ -251,6 +255,7 @@ int sm_ll_extend(struct ll_disk *ll, dm_block_t extra_blocks)
 		r = dm_tm_new_block(ll->tm, &dm_sm_bitmap_validator, &b);
 		if (r < 0)
 			return r;
+
 		idx.blocknr = cpu_to_le64(dm_block_location(b));
 
 		r = dm_tm_unlock(ll->tm, b);
@@ -265,7 +270,6 @@ int sm_ll_extend(struct ll_disk *ll, dm_block_t extra_blocks)
 			return r;
 	}
 
-	ll->nr_blocks = nr_blocks;
 	return 0;
 }
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2070e9c..92319b8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1203,7 +1203,7 @@ read_again:
 			/* Could not read all from this device, so we will
 			 * need another r10_bio.
 			 */
-			sectors_handled = (r10_bio->sectors + max_sectors
+			sectors_handled = (r10_bio->sector + max_sectors
 					   - bio->bi_sector);
 			r10_bio->sectors = max_sectors;
 			spin_lock_irq(&conf->device_lock);
@@ -1211,7 +1211,7 @@ read_again:
 				bio->bi_phys_segments = 2;
 			else
 				bio->bi_phys_segments++;
-			spin_unlock(&conf->device_lock);
+			spin_unlock_irq(&conf->device_lock);
 			/* Cannot call generic_make_request directly
 			 * as that will be queued in __generic_make_request
 			 * and subsequent mempool_alloc might block
@@ -3062,10 +3062,6 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			if (j == conf->copies) {
 				/* Cannot recover, so abort the recovery or
 				 * record a bad block */
-				put_buf(r10_bio);
-				if (rb2)
-					atomic_dec(&rb2->remaining);
-				r10_bio = rb2;
 				if (any_working) {
 					/* problem is that there are bad blocks
 					 * on other device(s)
@@ -3097,6 +3093,10 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 					mirror->recovery_disabled
 						= mddev->recovery_disabled;
 				}
+				put_buf(r10_bio);
+				if (rb2)
+					atomic_dec(&rb2->remaining);
+				r10_bio = rb2;
 				break;
 			}
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ecf09ec..eb0f9ea 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1851,6 +1851,7 @@ static void raid5_end_write_request(struct bio *bi, int error)
 			set_bit(R5_MadeGoodRepl, &sh->dev[i].flags);
 	} else {
 		if (!uptodate) {
+			set_bit(STRIPE_DEGRADED, &sh->state);
 			set_bit(WriteErrorSeen, &rdev->flags);
 			set_bit(R5_WriteError, &sh->dev[i].flags);
 			if (!test_and_set_bit(WantReplacement, &rdev->flags))
@@ -3284,7 +3285,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 			 */
 			set_bit(R5_Insync, &dev->flags);
 
-		if (rdev && test_bit(R5_WriteError, &dev->flags)) {
+		if (test_bit(R5_WriteError, &dev->flags)) {
 			/* This flag does not apply to '.replacement'
 			 * only to .rdev, so make sure to check that*/
 			struct md_rdev *rdev2 = rcu_dereference(
@@ -3297,7 +3298,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 			} else
 				clear_bit(R5_WriteError, &dev->flags);
 		}
-		if (rdev && test_bit(R5_MadeGood, &dev->flags)) {
+		if (test_bit(R5_MadeGood, &dev->flags)) {
 			/* This flag does not apply to '.replacement'
 			 * only to .rdev, so make sure to check that*/
 			struct md_rdev *rdev2 = rcu_dereference(
diff --git a/drivers/media/dvb/frontends/dib8000.c b/drivers/media/dvb/frontends/dib8000.c
index 9ca34f4..0b8c1bb 100644
--- a/drivers/media/dvb/frontends/dib8000.c
+++ b/drivers/media/dvb/frontends/dib8000.c
@@ -118,15 +118,10 @@ static u16 dib8000_i2c_read16(struct i2c_device *i2c, u16 reg)
 	return ret;
 }
 
-static u16 dib8000_read_word(struct dib8000_state *state, u16 reg)
+static u16 __dib8000_read_word(struct dib8000_state *state, u16 reg)
 {
 	u16 ret;
 
-	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
-		return 0;
-	}
-
 	state->i2c_write_buffer[0] = reg >> 8;
 	state->i2c_write_buffer[1] = reg & 0xff;
 
@@ -144,6 +139,21 @@ static u16 dib8000_read_word(struct dib8000_state *state, u16 reg)
 		dprintk("i2c read error on %d", reg);
 
 	ret = (state->i2c_read_buffer[0] << 8) | state->i2c_read_buffer[1];
+
+	return ret;
+}
+
+static u16 dib8000_read_word(struct dib8000_state *state, u16 reg)
+{
+	u16 ret;
+
+	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
+		dprintk("could not acquire lock");
+		return 0;
+	}
+
+	ret = __dib8000_read_word(state, reg);
+
 	mutex_unlock(&state->i2c_buffer_lock);
 
 	return ret;
@@ -153,8 +163,15 @@ static u32 dib8000_read32(struct dib8000_state *state, u16 reg)
 {
 	u16 rw[2];
 
-	rw[0] = dib8000_read_word(state, reg + 0);
-	rw[1] = dib8000_read_word(state, reg + 1);
+	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
+		dprintk("could not acquire lock");
+		return 0;
+	}
+
+	rw[0] = __dib8000_read_word(state, reg + 0);
+	rw[1] = __dib8000_read_word(state, reg + 1);
+
+	mutex_unlock(&state->i2c_buffer_lock);
 
 	return ((rw[0] << 16) | (rw[1]));
 }
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index ac472be..e27632e 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1106,11 +1106,22 @@ static void atmci_start_request(struct atmel_mci *host,
 	iflags |= ATMCI_CMDRDY;
 	cmd = mrq->cmd;
 	cmdflags = atmci_prepare_command(slot->mmc, cmd);
-	atmci_send_command(host, cmd, cmdflags);
+
+	/*
+	 * DMA transfer should be started before sending the command to avoid
+	 * unexpected errors especially for read operations in SDIO mode.
+	 * Unfortunately, in PDC mode, command has to be sent before starting
+	 * the transfer.
+	 */
+	if (host->submit_data != &atmci_submit_data_dma)
+		atmci_send_command(host, cmd, cmdflags);
 
 	if (data)
 		host->submit_data(host, data);
 
+	if (host->submit_data == &atmci_submit_data_dma)
+		atmci_send_command(host, cmd, cmdflags);
+
 	if (mrq->stop) {
 		host->stop_cmdr = atmci_prepare_command(slot->mmc, mrq->stop);
 		host->stop_cmdr |= ATMCI_CMDR_STOP_XFER;
diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 6acc790..f4e275a 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -669,7 +669,6 @@ static int mxc_nand_correct_data_v2_v3(struct mtd_info *mtd, u_char *dat,
 		ecc_stat >>= 4;
 	} while (--no_subpages);
 
-	mtd->ecc_stats.corrected += ret;
 	pr_debug("%d Symbol Correctable RS-ECC Error\n", ret);
 
 	return ret;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 27c2843..67d34eb 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -70,6 +70,7 @@ static u16 bnx2x_free_tx_pkt(struct bnx2x *bp, struct bnx2x_fp_txdata *txdata,
 	struct sk_buff *skb = tx_buf->skb;
 	u16 bd_idx = TX_BD(tx_buf->first_bd), new_cons;
 	int nbd;
+	u16 split_bd_len = 0;
 
 	/* prefetch skb end pointer to speedup dev_kfree_skb() */
 	prefetch(&skb->end);
@@ -77,10 +78,7 @@ static u16 bnx2x_free_tx_pkt(struct bnx2x *bp, struct bnx2x_fp_txdata *txdata,
 	DP(NETIF_MSG_TX_DONE, "fp[%d]: pkt_idx %d  buff @(%p)->skb %p\n",
 	   txdata->txq_index, idx, tx_buf, skb);
 
-	/* unmap first bd */
 	tx_start_bd = &txdata->tx_desc_ring[bd_idx].start_bd;
-	dma_unmap_single(&bp->pdev->dev, BD_UNMAP_ADDR(tx_start_bd),
-			 BD_UNMAP_LEN(tx_start_bd), DMA_TO_DEVICE);
 
 
 	nbd = le16_to_cpu(tx_start_bd->nbd) - 1;
@@ -99,12 +97,19 @@ static u16 bnx2x_free_tx_pkt(struct bnx2x *bp, struct bnx2x_fp_txdata *txdata,
 	--nbd;
 	bd_idx = TX_BD(NEXT_TX_IDX(bd_idx));
 
-	/* ...and the TSO split header bd since they have no mapping */
+	/* TSO headers+data bds share a common mapping. See bnx2x_tx_split() */
 	if (tx_buf->flags & BNX2X_TSO_SPLIT_BD) {
+		tx_data_bd = &txdata->tx_desc_ring[bd_idx].reg_bd;
+		split_bd_len = BD_UNMAP_LEN(tx_data_bd);
 		--nbd;
 		bd_idx = TX_BD(NEXT_TX_IDX(bd_idx));
 	}
 
+	/* unmap first bd */
+	dma_unmap_single(&bp->pdev->dev, BD_UNMAP_ADDR(tx_start_bd),
+			 BD_UNMAP_LEN(tx_start_bd) + split_bd_len,
+			 DMA_TO_DEVICE);
+
 	/* now free frags */
 	while (nbd > 0) {
 
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 4c1099e..5aa8caa 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -1601,6 +1601,7 @@ static void rhine_reset_task(struct work_struct *work)
 		goto out_unlock;
 
 	napi_disable(&rp->napi);
+	netif_tx_disable(dev);
 	spin_lock_bh(&rp->lock);
 
 	/* clear all descriptors */
diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index ac593ab..9f6a983 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -719,8 +719,6 @@ enum b43_firmware_file_type {
 struct b43_request_fw_context {
 	/* The device we are requesting the fw for. */
 	struct b43_wldev *dev;
-	/* a completion event structure needed if this call is asynchronous */
-	struct completion fw_load_complete;
 	/* a pointer to the firmware object */
 	const struct firmware *blob;
 	/* The type of firmware to request. */
@@ -797,6 +795,8 @@ enum {
 struct b43_wldev {
 	struct b43_bus_dev *dev;
 	struct b43_wl *wl;
+	/* a completion event structure needed if this call is asynchronous */
+	struct completion fw_load_complete;
 
 	/* The device initialization status.
 	 * Use b43_status() to query. */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 5b349da..71c72d1 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2061,6 +2061,7 @@ void b43_do_release_fw(struct b43_firmware_file *fw)
 
 static void b43_release_firmware(struct b43_wldev *dev)
 {
+	complete(&dev->fw_load_complete);
 	b43_do_release_fw(&dev->fw.ucode);
 	b43_do_release_fw(&dev->fw.pcm);
 	b43_do_release_fw(&dev->fw.initvals);
@@ -2086,7 +2087,7 @@ static void b43_fw_cb(const struct firmware *firmware, void *context)
 	struct b43_request_fw_context *ctx = context;
 
 	ctx->blob = firmware;
-	complete(&ctx->fw_load_complete);
+	complete(&ctx->dev->fw_load_complete);
 }
 
 int b43_do_request_fw(struct b43_request_fw_context *ctx,
@@ -2133,7 +2134,7 @@ int b43_do_request_fw(struct b43_request_fw_context *ctx,
 	}
 	if (async) {
 		/* do this part asynchronously */
-		init_completion(&ctx->fw_load_complete);
+		init_completion(&ctx->dev->fw_load_complete);
 		err = request_firmware_nowait(THIS_MODULE, 1, ctx->fwname,
 					      ctx->dev->dev->dev, GFP_KERNEL,
 					      ctx, b43_fw_cb);
@@ -2141,12 +2142,11 @@ int b43_do_request_fw(struct b43_request_fw_context *ctx,
 			pr_err("Unable to load firmware\n");
 			return err;
 		}
-		/* stall here until fw ready */
-		wait_for_completion(&ctx->fw_load_complete);
+		wait_for_completion(&ctx->dev->fw_load_complete);
 		if (ctx->blob)
 			goto fw_ready;
 	/* On some ARM systems, the async request will fail, but the next sync
-	 * request works. For this reason, we dall through here
+	 * request works. For this reason, we fall through here
 	 */
 	}
 	err = request_firmware(&ctx->blob, ctx->fwname,
@@ -2415,6 +2415,7 @@ error:
 
 static int b43_one_core_attach(struct b43_bus_dev *dev, struct b43_wl *wl);
 static void b43_one_core_detach(struct b43_bus_dev *dev);
+static int b43_rng_init(struct b43_wl *wl);
 
 static void b43_request_firmware(struct work_struct *work)
 {
@@ -2466,6 +2467,10 @@ start_ieee80211:
 		goto err_one_core_detach;
 	wl->hw_registred = true;
 	b43_leds_register(wl->current_dev);
+
+	/* Register HW RNG driver */
+	b43_rng_init(wl);
+
 	goto out;
 
 err_one_core_detach:
@@ -4595,9 +4600,6 @@ static void b43_wireless_core_exit(struct b43_wldev *dev)
 	if (!dev || b43_status(dev) != B43_STAT_INITIALIZED)
 		return;
 
-	/* Unregister HW RNG driver */
-	b43_rng_exit(dev->wl);
-
 	b43_set_status(dev, B43_STAT_UNINIT);
 
 	/* Stop the microcode PSM. */
@@ -4740,9 +4742,6 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
-	/* Register HW RNG driver */
-	b43_rng_init(dev->wl);
-
 out:
 	return err;
 
@@ -5403,6 +5402,9 @@ static void b43_bcma_remove(struct bcma_device *core)
 
 	b43_one_core_detach(wldev->dev);
 
+	/* Unregister HW RNG driver */
+	b43_rng_exit(wl);
+
 	b43_leds_unregister(wl);
 
 	ieee80211_free_hw(wl->hw);
@@ -5480,6 +5482,9 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 
 	b43_one_core_detach(dev);
 
+	/* Unregister HW RNG driver */
+	b43_rng_exit(wl);
+
 	if (list_empty(&wl->devlist)) {
 		b43_leds_unregister(wl);
 		/* Last core on the chip unregistered.
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index b31ccc0..87b8592 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -820,10 +820,10 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 		 * channel number in b43. */
 		if (chanstat & B43_RX_CHAN_5GHZ) {
 			status.band = IEEE80211_BAND_5GHZ;
-			status.freq = b43_freq_to_channel_5ghz(chanid);
+			status.freq = b43_channel_to_freq_5ghz(chanid);
 		} else {
 			status.band = IEEE80211_BAND_2GHZ;
-			status.freq = b43_freq_to_channel_2ghz(chanid);
+			status.freq = b43_channel_to_freq_2ghz(chanid);
 		}
 		break;
 	default:
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 0366dcc..2a1c348 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3917,6 +3917,7 @@ static void b43legacy_remove(struct ssb_device *dev)
 	 * as the ieee80211 unreg will destroy the workqueue. */
 	cancel_work_sync(&wldev->restart_work);
 	cancel_work_sync(&wl->firmware_load);
+	complete(&wldev->fw_load_complete);
 
 	B43legacy_WARN_ON(!wl);
 	if (!wldev->fw.ucode)
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 9ca1b9c..fee62b7 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1603,7 +1603,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		const u8 *ie_buf;
 		size_t ie_len;
 		u16 channel = 0;
-		u64 fw_tsf = 0;
+		__le64 fw_tsf = 0;
 		u16 beacon_size = 0;
 		u32 curr_bcn_bytes;
 		u32 freq;
@@ -1731,7 +1731,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 					      ie_buf, ie_len, rssi, GFP_KERNEL);
 				bss_priv = (struct mwifiex_bss_priv *)bss->priv;
 				bss_priv->band = band;
-				bss_priv->fw_tsf = fw_tsf;
+				bss_priv->fw_tsf = le64_to_cpu(fw_tsf);
 				if (priv->media_connected &&
 				    !memcmp(bssid,
 					    priv->curr_bss_params.bss_descriptor
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 278e9f9..e70333b 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -46,10 +46,20 @@ void rtl_fw_cb(const struct firmware *firmware, void *context)
 			 "Firmware callback routine entered!\n");
 	complete(&rtlpriv->firmware_loading_complete);
 	if (!firmware) {
+		if (rtlpriv->cfg->alt_fw_name) {
+			err = request_firmware(&firmware,
+					       rtlpriv->cfg->alt_fw_name,
+					       rtlpriv->io.dev);
+			pr_info("Loading alternative firmware %s\n",
+				rtlpriv->cfg->alt_fw_name);
+			if (!err)
+				goto found_alt;
+		}
 		pr_err("Firmware %s not available\n", rtlpriv->cfg->fw_name);
 		rtlpriv->max_fw_size = 0;
 		return;
 	}
+found_alt:
 	if (firmware->size > rtlpriv->max_fw_size) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Firmware is too big!\n");
@@ -175,6 +185,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 					rtlpriv->cfg->maps
 					[RTL_IBSS_INT_MASKS]);
 		}
+		mac->link_state = MAC80211_LINKED;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
index 518e208..4f232a0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
@@ -91,6 +91,17 @@
 #define TX_POWER_NEAR_FIELD_THRESH_LVL2		74
 #define TX_POWER_NEAR_FIELD_THRESH_LVL1		67
 
+#define DYNAMIC_FUNC_DISABLE			0x0
+#define DYNAMIC_FUNC_DIG			BIT(0)
+#define DYNAMIC_FUNC_HP				BIT(1)
+#define DYNAMIC_FUNC_SS				BIT(2) /*Tx Power Tracking*/
+#define DYNAMIC_FUNC_BT				BIT(3)
+#define DYNAMIC_FUNC_ANT_DIV			BIT(4)
+
+#define	RSSI_CCK				0
+#define	RSSI_OFDM				1
+#define	RSSI_DEFAULT				2
+
 struct swat_t {
 	u8 failure_cnt;
 	u8 try_flag;
@@ -167,5 +178,8 @@ void rtl92c_phy_lc_calibrate(struct ieee80211_hw *hw);
 void rtl92c_phy_iq_calibrate(struct ieee80211_hw *hw, bool recovery);
 void rtl92c_dm_dynamic_txpower(struct ieee80211_hw *hw);
 void rtl92c_dm_bt_coexist(struct ieee80211_hw *hw);
+void dm_savepowerindex(struct ieee80211_hw *hw);
+void dm_writepowerindex(struct ieee80211_hw *hw, u8 value);
+void dm_restorepowerindex(struct ieee80211_hw *hw);
 
 #endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
index 4763426..bbe9a78 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -85,17 +85,15 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 	if (mac->act_scanning) {
 		tx_agc[RF90_PATH_A] = 0x3f3f3f3f;
 		tx_agc[RF90_PATH_B] = 0x3f3f3f3f;
-		if (turbo_scanoff) {
-			for (idx1 = RF90_PATH_A; idx1 <= RF90_PATH_B; idx1++) {
-				tx_agc[idx1] = ppowerlevel[idx1] |
-				    (ppowerlevel[idx1] << 8) |
-				    (ppowerlevel[idx1] << 16) |
-				    (ppowerlevel[idx1] << 24);
-				if (rtlhal->interface == INTF_USB) {
-					if (tx_agc[idx1] > 0x20 &&
-					    rtlefuse->external_pa)
-						tx_agc[idx1] = 0x20;
-				}
+		for (idx1 = RF90_PATH_A; idx1 <= RF90_PATH_B; idx1++) {
+			tx_agc[idx1] = ppowerlevel[idx1] |
+			    (ppowerlevel[idx1] << 8) |
+			    (ppowerlevel[idx1] << 16) |
+			    (ppowerlevel[idx1] << 24);
+			if (rtlhal->interface == INTF_USB) {
+				if (tx_agc[idx1] > 0x20 &&
+				    rtlefuse->external_pa)
+					tx_agc[idx1] = 0x20;
 			}
 		}
 	} else {
@@ -107,7 +105,7 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 			   TXHIGHPWRLEVEL_LEVEL2) {
 			tx_agc[RF90_PATH_A] = 0x00000000;
 			tx_agc[RF90_PATH_B] = 0x00000000;
-		} else{
+		} else {
 			for (idx1 = RF90_PATH_A; idx1 <= RF90_PATH_B; idx1++) {
 				tx_agc[idx1] = ppowerlevel[idx1] |
 				    (ppowerlevel[idx1] << 8) |
@@ -379,7 +377,12 @@ static void _rtl92c_write_ofdm_power_reg(struct ieee80211_hw *hw,
 			    regoffset == RTXAGC_B_MCS07_MCS04)
 				regoffset = 0xc98;
 			for (i = 0; i < 3; i++) {
-				writeVal = (writeVal > 6) ? (writeVal - 6) : 0;
+				if (i != 2)
+					writeVal = (writeVal > 8) ?
+						   (writeVal - 8) : 0;
+				else
+					writeVal = (writeVal > 6) ?
+						   (writeVal - 6) : 0;
 				rtl_write_byte(rtlpriv, (u32)(regoffset + i),
 					      (u8)writeVal);
 			}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index 5212ad2..6245563 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -49,6 +49,9 @@ MODULE_AUTHOR("Larry Finger	<Larry.Finger@lwfinger.net>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek 8192C/8188C 802.11n USB wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8192cufw.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8192cufw_A.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8192cufw_B.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8192cufw_TMSC.bin");
 
 static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 {
@@ -68,15 +71,22 @@ static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 			 "Can't alloc buffer for fw\n");
 		return 1;
 	}
-
+	if (IS_VENDOR_UMC_A_CUT(rtlpriv->rtlhal.version) &&
+	    !IS_92C_SERIAL(rtlpriv->rtlhal.version)) {
+		rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cufw_A.bin";
+	} else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlpriv->rtlhal.version)) {
+		rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cufw_B.bin";
+	} else {
+		rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cufw_TMSC.bin";
+	}
+	/* provide name of alternative file */
+	rtlpriv->cfg->alt_fw_name = "rtlwifi/rtl8192cufw.bin";
 	pr_info("Loading firmware %s\n", rtlpriv->cfg->fw_name);
 	rtlpriv->max_fw_size = 0x4000;
 	err = request_firmware_nowait(THIS_MODULE, 1,
 				      rtlpriv->cfg->fw_name, rtlpriv->io.dev,
 				      GFP_KERNEL, hw, rtl_fw_cb);
-
-
-	return 0;
+	return err;
 }
 
 static void rtl92cu_deinit_sw_vars(struct ieee80211_hw *hw)
@@ -306,6 +316,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
 	{RTL_USB_DEVICE(0x0bda, 0x5088, rtl92cu_hal_cfg)}, /*Thinkware-CC&C*/
 	{RTL_USB_DEVICE(0x0df6, 0x0052, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
 	{RTL_USB_DEVICE(0x0df6, 0x005c, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
+	{RTL_USB_DEVICE(0x0df6, 0x0077, rtl92cu_hal_cfg)}, /*Sitecom-WLA2100V2*/
 	{RTL_USB_DEVICE(0x0eb0, 0x9071, rtl92cu_hal_cfg)}, /*NO Brand - Etop*/
 	{RTL_USB_DEVICE(0x4856, 0x0091, rtl92cu_hal_cfg)}, /*NetweeN - Feixun*/
 	/* HP - Lite-On ,8188CUS Slim Combo */
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index fa02202..2f08d08 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1529,6 +1529,7 @@ struct rtl_hal_cfg {
 	bool write_readback;
 	char *name;
 	char *fw_name;
+	char *alt_fw_name;
 	struct rtl_hal_ops *ops;
 	struct rtl_mod_params *mod_params;
 	struct rtl_hal_usbint_cfg *usb_interface_cfg;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index b88afc7..8c7579b 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1969,7 +1969,7 @@ static int __init netif_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
-	if (xen_hvm_domain() && !xen_platform_pci_unplug)
+	if (!xen_has_pv_nic_devices())
 		return -ENODEV;
 
 	printk(KERN_INFO "Initialising Xen virtual ethernet driver.\n");
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 5abffe5..978bc77 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2599,8 +2599,6 @@ enum parport_pc_pci_cards {
 	syba_2p_epp,
 	syba_1p_ecp,
 	titan_010l,
-	titan_1284p1,
-	titan_1284p2,
 	avlab_1p,
 	avlab_2p,
 	oxsemi_952,
@@ -2659,8 +2657,6 @@ static struct parport_pc_pci {
 	/* syba_2p_epp AP138B */	{ 2, { { 0, 0x078 }, { 0, 0x178 }, } },
 	/* syba_1p_ecp W83787 */	{ 1, { { 0, 0x078 }, } },
 	/* titan_010l */		{ 1, { { 3, -1 }, } },
-	/* titan_1284p1 */              { 1, { { 0, 1 }, } },
-	/* titan_1284p2 */		{ 2, { { 0, 1 }, { 2, 3 }, } },
 	/* avlab_1p		*/	{ 1, { { 0, 1}, } },
 	/* avlab_2p		*/	{ 2, { { 0, 1}, { 2, 3 },} },
 	/* The Oxford Semi cards are unusual: 954 doesn't support ECP,
@@ -2676,8 +2672,8 @@ static struct parport_pc_pci {
 	/* netmos_9705 */               { 1, { { 0, -1 }, } },
 	/* netmos_9715 */               { 2, { { 0, 1 }, { 2, 3 },} },
 	/* netmos_9755 */               { 2, { { 0, 1 }, { 2, 3 },} },
-	/* netmos_9805 */               { 1, { { 0, -1 }, } },
-	/* netmos_9815 */               { 2, { { 0, -1 }, { 2, -1 }, } },
+	/* netmos_9805 */		{ 1, { { 0, 1 }, } },
+	/* netmos_9815 */		{ 2, { { 0, 1 }, { 2, 3 }, } },
 	/* netmos_9901 */               { 1, { { 0, -1 }, } },
 	/* netmos_9865 */               { 1, { { 0, -1 }, } },
 	/* quatech_sppxp100 */		{ 1, { { 0, 1 }, } },
@@ -2721,8 +2717,6 @@ static const struct pci_device_id parport_pc_pci_tbl[] = {
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, syba_1p_ecp },
 	{ PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_010L,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, titan_010l },
-	{ 0x9710, 0x9805, 0x1000, 0x0010, 0, 0, titan_1284p1 },
-	{ 0x9710, 0x9815, 0x1000, 0x0020, 0, 0, titan_1284p2 },
 	/* PCI_VENDOR_ID_AVLAB/Intek21 has another bunch of cards ...*/
 	/* AFAVLAB_TK9902 */
 	{ 0x14db, 0x2120, PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_1p},
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index d6cc62c..04d185b 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -20,6 +20,7 @@
 #include <linux/workqueue.h>
 #include <linux/bitops.h>
 #include <linux/time.h>
+#include <xen/platform_pci.h>
 
 #define INVALID_GRANT_REF (0)
 #define INVALID_EVTCHN    (-1)
@@ -1137,6 +1138,9 @@ static int __init pcifront_init(void)
 	if (!xen_pv_domain() || xen_initial_domain())
 		return -ENODEV;
 
+	if (!xen_has_pv_devices())
+		return -ENODEV;
+
 	pci_frontend_registrar(1 /* enable */);
 
 	return xenbus_register_frontend(&xenpci_driver);
diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index fdacfce..0076fea 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -77,6 +77,7 @@ static inline void delayed_sysfs_set(struct led_classdev *led_cdev,
 static struct acpi_device_id lis3lv02d_device_ids[] = {
 	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
 	{"HPQ6000", 0}, /* HP Mobile Data Protection System PNP */
+	{"HPQ6007", 0}, /* HP Mobile Data Protection System PNP */
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 2e4b0be..d068873 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1598,7 +1598,7 @@ out:
 static u32 *
 bfad_load_fwimg(struct pci_dev *pdev)
 {
-	if (pdev->device == BFA_PCI_DEVICE_ID_CT2) {
+	if (bfa_asic_id_ct2(pdev->device)) {
 		if (bfi_image_ct2_size == 0)
 			bfad_read_firmware(pdev, &bfi_image_ct2,
 				&bfi_image_ct2_size, BFAD_FW_FILE_CT2);
@@ -1608,12 +1608,14 @@ bfad_load_fwimg(struct pci_dev *pdev)
 			bfad_read_firmware(pdev, &bfi_image_ct,
 				&bfi_image_ct_size, BFAD_FW_FILE_CT);
 		return bfi_image_ct;
-	} else {
+	} else if (bfa_asic_id_cb(pdev->device)) {
 		if (bfi_image_cb_size == 0)
 			bfad_read_firmware(pdev, &bfi_image_cb,
 				&bfi_image_cb_size, BFAD_FW_FILE_CB);
 		return bfi_image_cb;
 	}
+
+	return NULL;
 }
 
 static void
diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 713132c..d4f7fda 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -56,10 +56,6 @@ struct pcidio_board {
 	const char *name;	/*  name of the board */
 	int dev_id;
 	int n_8255;		/*  number of 8255 chips on board */
-
-	/*  indices of base address regions */
-	int pcicontroler_badrindex;
-	int dioregs_badrindex;
 };
 
 static const struct pcidio_board pcidio_boards[] = {
@@ -67,22 +63,16 @@ static const struct pcidio_board pcidio_boards[] = {
 	 .name = "pci-dio24",
 	 .dev_id = 0x0028,
 	 .n_8255 = 1,
-	 .pcicontroler_badrindex = 1,
-	 .dioregs_badrindex = 2,
 	 },
 	{
 	 .name = "pci-dio24h",
 	 .dev_id = 0x0014,
 	 .n_8255 = 1,
-	 .pcicontroler_badrindex = 1,
-	 .dioregs_badrindex = 2,
 	 },
 	{
 	 .name = "pci-dio48h",
 	 .dev_id = 0x000b,
 	 .n_8255 = 2,
-	 .pcicontroler_badrindex = 0,
-	 .dioregs_badrindex = 1,
 	 },
 };
 
@@ -173,10 +163,15 @@ found:
 	if (comedi_pci_enable(pcidev, thisboard->name))
 		return -EIO;
 
-	devpriv->dio_reg_base
-	    =
+	/*
+	 * Use PCI BAR 2 region if non-zero length, else use PCI BAR 1 region.
+	 * PCI BAR 1 is only used for older PCI-DIO48H boards.  At some point
+	 * the PCI-DIO48H was redesigned to use the same PCI interface chip
+	 * (and same PCI BAR region) as the other boards.
+	 */
+	devpriv->dio_reg_base =
 	    pci_resource_start(devpriv->pci_dev,
-			       pcidio_boards[index].dioregs_badrindex);
+			       (pci_resource_len(pcidev, 2) ? 2 : 1));
 
 /*
  * Allocate the subdevice structures.  alloc_subdevice() is a
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 1bc8097..d998c2f 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -361,6 +361,10 @@ static u8 key_2char2num(u8 hch, u8 lch)
 	return (hex_to_bin(hch) << 4) | hex_to_bin(lch);
 }
 
+static const struct device_type wlan_type = {
+	.name = "wlan",
+};
+
 /*
  * drv_init() - a device potentially for us
  *
@@ -396,6 +400,7 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 	padapter->pusb_intf = pusb_intf;
 	usb_set_intfdata(pusb_intf, pnetdev);
 	SET_NETDEV_DEV(pnetdev, &pusb_intf->dev);
+	pnetdev->dev.type = &wlan_type;
 	/* step 2. */
 	padapter->dvobj_init = &r8712_usb_dvobj_init;
 	padapter->dvobj_deinit = &r8712_usb_dvobj_deinit;
diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 858e2a8..4034281 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1634,7 +1634,6 @@ BBvUpdatePreEDThreshold(
 
             if( bScanning )
             {   // need Max sensitivity //RSSI -69, -70,....
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
@@ -1777,7 +1776,6 @@ BBvUpdatePreEDThreshold(
 
             if( bScanning )
             {   // need Max sensitivity  //RSSI -69, -70, ...
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x24); //CR206(0xCE)
@@ -1929,7 +1927,6 @@ BBvUpdatePreEDThreshold(
         case RF_VT3342A0: //RobertYu:20060627, testing table
             if( bScanning )
             {   // need Max sensitivity  //RSSI -67, -68, ...
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x38); //CR206(0xCE)
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 955392e..6e270f9 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -52,7 +52,7 @@
 static LIST_HEAD(g_tiqn_list);
 static LIST_HEAD(g_np_list);
 static DEFINE_SPINLOCK(tiqn_lock);
-static DEFINE_SPINLOCK(np_lock);
+static DEFINE_MUTEX(np_lock);
 
 static struct idr tiqn_idr;
 struct idr sess_idr;
@@ -264,6 +264,9 @@ int iscsit_deaccess_np(struct iscsi_np *np, struct iscsi_portal_group *tpg)
 	return 0;
 }
 
+/*
+ * Called with mutex np_lock held
+ */
 static struct iscsi_np *iscsit_get_np(
 	struct __kernel_sockaddr_storage *sockaddr,
 	int network_transport)
@@ -274,11 +277,10 @@ static struct iscsi_np *iscsit_get_np(
 	int ip_match = 0;
 	u16 port;
 
-	spin_lock_bh(&np_lock);
 	list_for_each_entry(np, &g_np_list, np_list) {
-		spin_lock(&np->np_thread_lock);
+		spin_lock_bh(&np->np_thread_lock);
 		if (np->np_thread_state != ISCSI_NP_THREAD_ACTIVE) {
-			spin_unlock(&np->np_thread_lock);
+			spin_unlock_bh(&np->np_thread_lock);
 			continue;
 		}
 
@@ -311,13 +313,11 @@ static struct iscsi_np *iscsit_get_np(
 			 * while iscsi_tpg_add_network_portal() is called.
 			 */
 			np->np_exports++;
-			spin_unlock(&np->np_thread_lock);
-			spin_unlock_bh(&np_lock);
+			spin_unlock_bh(&np->np_thread_lock);
 			return np;
 		}
-		spin_unlock(&np->np_thread_lock);
+		spin_unlock_bh(&np->np_thread_lock);
 	}
-	spin_unlock_bh(&np_lock);
 
 	return NULL;
 }
@@ -331,16 +331,22 @@ struct iscsi_np *iscsit_add_np(
 	struct sockaddr_in6 *sock_in6;
 	struct iscsi_np *np;
 	int ret;
+
+	mutex_lock(&np_lock);
+
 	/*
 	 * Locate the existing struct iscsi_np if already active..
 	 */
 	np = iscsit_get_np(sockaddr, network_transport);
-	if (np)
+	if (np) {
+		mutex_unlock(&np_lock);
 		return np;
+	}
 
 	np = kzalloc(sizeof(struct iscsi_np), GFP_KERNEL);
 	if (!np) {
 		pr_err("Unable to allocate memory for struct iscsi_np\n");
+		mutex_unlock(&np_lock);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -363,6 +369,7 @@ struct iscsi_np *iscsit_add_np(
 	ret = iscsi_target_setup_login_socket(np, sockaddr);
 	if (ret != 0) {
 		kfree(np);
+		mutex_unlock(&np_lock);
 		return ERR_PTR(ret);
 	}
 
@@ -371,6 +378,7 @@ struct iscsi_np *iscsit_add_np(
 		pr_err("Unable to create kthread: iscsi_np\n");
 		ret = PTR_ERR(np->np_thread);
 		kfree(np);
+		mutex_unlock(&np_lock);
 		return ERR_PTR(ret);
 	}
 	/*
@@ -381,10 +389,10 @@ struct iscsi_np *iscsit_add_np(
 	 * point because iscsi_np has not been added to g_np_list yet.
 	 */
 	np->np_exports = 1;
+	np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 
-	spin_lock_bh(&np_lock);
 	list_add_tail(&np->np_list, &g_np_list);
-	spin_unlock_bh(&np_lock);
+	mutex_unlock(&np_lock);
 
 	pr_debug("CORE[0] - Added Network Portal: %s:%hu on %s\n",
 		np->np_ip, np->np_port, (np->np_network_transport == ISCSI_TCP) ?
@@ -455,9 +463,9 @@ int iscsit_del_np(struct iscsi_np *np)
 	}
 	iscsit_del_np_comm(np);
 
-	spin_lock_bh(&np_lock);
+	mutex_lock(&np_lock);
 	list_del(&np->np_list);
-	spin_unlock_bh(&np_lock);
+	mutex_unlock(&np_lock);
 
 	pr_debug("CORE[0] - Removed Network Portal: %s:%hu on %s\n",
 		np->np_ip, np->np_port, (np->np_network_transport == ISCSI_TCP) ?
diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index d9e2594..899c2b9 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -2615,6 +2615,10 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 	if (port->type == PORT_16550A && port->iotype == UPIO_AU)
 		up->bugs |= UART_BUG_NOMSR;
 
+	/* HW bugs may trigger IRQ while IIR == NO_INT */
+	if (port->type == PORT_TEGRA)
+		up->bugs |= UART_BUG_NOMSR;
+
 	if (port->type != PORT_UNKNOWN && flags & UART_CONFIG_IRQ)
 		autoconfig_irq(up);
 
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 41c1db3..8e581dd 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1193,6 +1193,7 @@ pci_xr17c154_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_TITAN_800E	0xA014
 #define PCI_DEVICE_ID_TITAN_200EI	0xA016
 #define PCI_DEVICE_ID_TITAN_200EISI	0xA017
+#define PCI_DEVICE_ID_TITAN_200V3	0xA306
 #define PCI_DEVICE_ID_TITAN_400V3	0xA310
 #define PCI_DEVICE_ID_TITAN_410V3	0xA312
 #define PCI_DEVICE_ID_TITAN_800V3	0xA314
@@ -3529,6 +3530,9 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200EISI,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_oxsemi_2_4000000 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200V3,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b0_bt_2_921600 },
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_400V3,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_4_921600 },
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index da8a37f..63b8217 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1353,6 +1353,8 @@ static int pl011_startup(struct uart_port *port)
 	/*
 	 * Provoke TX FIFO interrupt into asserting.
 	 */
+	spin_lock_irq(&uap->port.lock);
+
 	cr = UART01x_CR_UARTEN | UART011_CR_TXE | UART011_CR_LBE;
 	writew(cr, uap->port.membase + UART011_CR);
 	writew(0, uap->port.membase + UART011_FBRD);
@@ -1377,6 +1379,8 @@ static int pl011_startup(struct uart_port *port)
 	cr |= UART01x_CR_UARTEN | UART011_CR_RXE | UART011_CR_TXE;
 	writew(cr, uap->port.membase + UART011_CR);
 
+	spin_unlock_irq(&uap->port.lock);
+
 	/*
 	 * initialise the old status of the modem signals
 	 */
@@ -1457,11 +1461,13 @@ static void pl011_shutdown(struct uart_port *port)
 	 * it during startup().
 	 */
 	uap->autorts = false;
+	spin_lock_irq(&uap->port.lock);
 	cr = readw(uap->port.membase + UART011_CR);
 	uap->old_cr = cr;
 	cr &= UART011_CR_RTS | UART011_CR_DTR;
 	cr |= UART01x_CR_UARTEN | UART011_CR_TXE;
 	writew(cr, uap->port.membase + UART011_CR);
+	spin_unlock_irq(&uap->port.lock);
 
 	/*
 	 * disable break condition and fifos
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index ed7cd37..ff58d28 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1022,12 +1022,24 @@ static int atmel_startup(struct uart_port *port)
 static void atmel_shutdown(struct uart_port *port)
 {
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+
 	/*
-	 * Ensure everything is stopped.
+	 * Clear out any scheduled tasklets before
+	 * we destroy the buffers
+	 */
+	tasklet_kill(&atmel_port->tasklet);
+
+	/*
+	 * Ensure everything is stopped and
+	 * disable all interrupts, port and break condition.
 	 */
 	atmel_stop_rx(port);
 	atmel_stop_tx(port);
 
+	UART_PUT_CR(port, ATMEL_US_RSTSTA);
+	UART_PUT_IDR(port, -1);
+
+
 	/*
 	 * Shut-down the DMA.
 	 */
@@ -1054,12 +1066,6 @@ static void atmel_shutdown(struct uart_port *port)
 	}
 
 	/*
-	 * Disable all interrupts, port and break condition.
-	 */
-	UART_PUT_CR(port, ATMEL_US_RSTSTA);
-	UART_PUT_IDR(port, -1);
-
-	/*
 	 * Free the interrupt
 	 */
 	free_irq(port->irq, port);
diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 78609d3..6ed7e7c 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -651,10 +651,6 @@ void usb_destroy_configuration(struct usb_device *dev)
  *
  * hub-only!! ... and only in reset path, or usb_new_device()
  * (used by real hubs and virtual root hubs)
- *
- * NOTE: if this is a WUSB device and is not authorized, we skip the
- *       whole thing. A non-authorized USB device has no
- *       configurations.
  */
 int usb_get_configuration(struct usb_device *dev)
 {
@@ -666,8 +662,6 @@ int usb_get_configuration(struct usb_device *dev)
 	struct usb_config_descriptor *desc;
 
 	cfgno = 0;
-	if (dev->authorized == 0)	/* Not really an error */
-		goto out_not_authorized;
 	result = -ENOMEM;
 	if (ncfg > USB_MAXCONFIG) {
 		dev_warn(ddev, "too many configurations: %d, "
@@ -749,7 +743,6 @@ int usb_get_configuration(struct usb_device *dev)
 
 err:
 	kfree(desc);
-out_not_authorized:
 	dev->descriptor.bNumConfigurations = cfgno;
 err2:
 	if (result == -ENOMEM)
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 5e67525..d13f9a7 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2146,18 +2146,13 @@ static int usb_enumerate_device(struct usb_device *udev)
 			goto fail;
 		}
 	}
-	if (udev->wusb == 1 && udev->authorized == 0) {
-		udev->product = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-		udev->manufacturer = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-		udev->serial = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-	}
-	else {
-		/* read the standard strings and cache them if present */
-		udev->product = usb_cache_string(udev, udev->descriptor.iProduct);
-		udev->manufacturer = usb_cache_string(udev,
-						      udev->descriptor.iManufacturer);
-		udev->serial = usb_cache_string(udev, udev->descriptor.iSerialNumber);
-	}
+
+	/* read the standard strings and cache them if present */
+	udev->product = usb_cache_string(udev, udev->descriptor.iProduct);
+	udev->manufacturer = usb_cache_string(udev,
+					      udev->descriptor.iManufacturer);
+	udev->serial = usb_cache_string(udev, udev->descriptor.iSerialNumber);
+
 	err = usb_enumerate_device_otg(udev);
 fail:
 	return err;
@@ -2311,16 +2306,6 @@ int usb_deauthorize_device(struct usb_device *usb_dev)
 	usb_dev->authorized = 0;
 	usb_set_configuration(usb_dev, -1);
 
-	kfree(usb_dev->product);
-	usb_dev->product = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-	kfree(usb_dev->manufacturer);
-	usb_dev->manufacturer = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-	kfree(usb_dev->serial);
-	usb_dev->serial = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-
-	usb_destroy_configuration(usb_dev);
-	usb_dev->descriptor.bNumConfigurations = 0;
-
 out_unauthorized:
 	usb_unlock_device(usb_dev);
 	return 0;
@@ -2348,17 +2333,7 @@ int usb_authorize_device(struct usb_device *usb_dev)
 		goto error_device_descriptor;
 	}
 
-	kfree(usb_dev->product);
-	usb_dev->product = NULL;
-	kfree(usb_dev->manufacturer);
-	usb_dev->manufacturer = NULL;
-	kfree(usb_dev->serial);
-	usb_dev->serial = NULL;
-
 	usb_dev->authorized = 1;
-	result = usb_enumerate_device(usb_dev);
-	if (result < 0)
-		goto error_enumerate;
 	/* Choose and set the configuration.  This registers the interfaces
 	 * with the driver core and lets interface drivers bind to them.
 	 */
@@ -2374,7 +2349,6 @@ int usb_authorize_device(struct usb_device *usb_dev)
 	}
 	dev_info(&usb_dev->dev, "authorized to connect\n");
 
-error_enumerate:
 error_device_descriptor:
 	usb_autosuspend_device(usb_dev);
 error_autoresume:
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 8ef76d2..0d4c7e4 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -315,6 +315,9 @@ static void xhci_cleanup_msix(struct xhci_hcd *xhci)
 	struct usb_hcd *hcd = xhci_to_hcd(xhci);
 	struct pci_dev *pdev = to_pci_dev(hcd->self.controller);
 
+	if (xhci->quirks & XHCI_PLAT)
+		return;
+
 	xhci_free_irq(xhci);
 
 	if (xhci->msix_entries) {
diff --git a/drivers/usb/serial/cypress_m8.h b/drivers/usb/serial/cypress_m8.h
index b461311..ce13e61 100644
--- a/drivers/usb/serial/cypress_m8.h
+++ b/drivers/usb/serial/cypress_m8.h
@@ -63,7 +63,7 @@
 #define UART_DSR	0x20	/* data set ready - flow control - device to host */
 #define CONTROL_RTS	0x10	/* request to send - flow control - host to device */
 #define UART_CTS	0x10	/* clear to send - flow control - device to host */
-#define UART_RI		0x10	/* ring indicator - modem - device to host */
+#define UART_RI		0x80	/* ring indicator - modem - device to host */
 #define UART_CD		0x40	/* carrier detect - modem - device to host */
 #define CYP_ERROR	0x08	/* received from input report - device to host */
 /* Note - the below has nothing to do with the "feature report" reset */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 947da9d..82c392f 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2162,10 +2162,20 @@ static void ftdi_set_termios(struct tty_struct *tty,
 	}
 
 	/*
-	 * All FTDI UART chips are limited to CS7/8. We won't pretend to
+	 * All FTDI UART chips are limited to CS7/8. We shouldn't pretend to
 	 * support CS5/6 and revert the CSIZE setting instead.
+	 *
+	 * CS5 however is used to control some smartcard readers which abuse
+	 * this limitation to switch modes. Original FTDI chips fall back to
+	 * eight data bits.
+	 *
+	 * TODO: Implement a quirk to only allow this with mentioned
+	 *       readers. One I know of (Argolis Smartreader V1)
+	 *       returns "USB smartcard server" as iInterface string.
+	 *       The vendor didn't bother with a custom VID/PID of
+	 *       course.
 	 */
-	if ((C_CSIZE(tty) != CS8) && (C_CSIZE(tty) != CS7)) {
+	if (C_CSIZE(tty) == CS6) {
 		dev_warn(&port->dev, "requested CSIZE setting not supported\n");
 
 		termios->c_cflag &= ~CSIZE;
@@ -2212,6 +2222,9 @@ no_skip:
 		urb_value |= FTDI_SIO_SET_DATA_PARITY_NONE;
 	}
 	switch (cflag & CSIZE) {
+	case CS5:
+		dbg("Setting CS5 quirk\n");
+		break;
 	case CS7:
 		urb_value |= 7;
 		dbg("Setting CS7\n");
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index aac4deb..83b50db 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -325,6 +325,9 @@ static void option_instat_callback(struct urb *urb);
  * It seems to contain a Qualcomm QSC6240/6290 chipset            */
 #define FOUR_G_SYSTEMS_PRODUCT_W14		0x9603
 
+/* iBall 3.5G connect wireless modem */
+#define IBALL_3_5G_CONNECT			0x9605
+
 /* Zoom */
 #define ZOOM_PRODUCT_4597			0x9607
 
@@ -1461,6 +1464,17 @@ static const struct usb_device_id option_ids[] = {
 		.driver_info = (kernel_ulong_t)&net_intf3_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0178, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)&net_intf3_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xffe9, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff8b, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff8c, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff8d, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff8e, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff8f, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff90, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff91, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff92, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff93, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff94, 0xff, 0xff, 0xff) },
 
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710, 0xff, 0xff, 0xff) },
@@ -1509,6 +1523,7 @@ static const struct usb_device_id option_ids[] = {
   	  .driver_info = (kernel_ulong_t)&four_g_w14_blacklist
   	},
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, ZOOM_PRODUCT_4597) },
+	{ USB_DEVICE(LONGCHEER_VENDOR_ID, IBALL_3_5G_CONNECT) },
 	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },
 	/* Pirelli  */
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_C100_1)},
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 7da68c4..d904c59 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -226,6 +226,13 @@ UNUSUAL_DEV(  0x0421, 0x0495, 0x0370, 0x0370,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64 ),
 
+/* Patch submitted by Mikhail Zolotaryov <lebon@lebon.org.ua> */
+UNUSUAL_DEV(  0x0421, 0x06aa, 0x1110, 0x1110,
+		"Nokia",
+		"502",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64 ),
+
 #ifdef NO_SDDR09
 UNUSUAL_DEV(  0x0436, 0x0005, 0x0100, 0x0100,
 		"Microtech",
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index b7f5173..3a631fb 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -35,6 +35,7 @@
 #include <xen/interface/io/fbif.h>
 #include <xen/interface/io/protocols.h>
 #include <xen/xenbus.h>
+#include <xen/platform_pci.h>
 
 struct xenfb_info {
 	unsigned char		*fb;
@@ -697,6 +698,9 @@ static int __init xenfb_init(void)
 	if (xen_initial_domain())
 		return -ENODEV;
 
+	if (!xen_has_pv_devices())
+		return -ENODEV;
+
 	return xenbus_register_frontend(&xenfb_driver);
 }
 
diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
index a31b54d..840c52e 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -446,7 +446,7 @@ subsys_initcall(xenbus_probe_frontend_init);
 #ifndef MODULE
 static int __init boot_wait_for_devices(void)
 {
-	if (xen_hvm_domain() && !xen_platform_pci_unplug)
+	if (!xen_has_pv_devices())
 		return -ENODEV;
 
 	ready_to_wait_for_devices = 1;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6bb1213..a37ec94 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7035,7 +7035,7 @@ out:
 	 */
 	if (root_dropped == false)
 		btrfs_add_dead_root(root);
-	if (err)
+	if (err && err != -EAGAIN)
 		btrfs_std_error(root->fs_info, err);
 	return err;
 }
diff --git a/fs/dcache.c b/fs/dcache.c
index 9b36632..6269583 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2737,8 +2737,13 @@ char *d_path(const struct path *path, char *buf, int buflen)
 	 * thus don't need to be hashed.  They also don't need a name until a
 	 * user wants to identify the object in /proc/pid/fd/.  The little hack
 	 * below allows us to generate a name for these objects on demand:
+	 *
+	 * Some pseudo inodes are mountable.  When they are mounted
+	 * path->dentry == path->mnt->mnt_root.  In that case don't call d_dname
+	 * and instead have d_path return the mounted path.
 	 */
-	if (path->dentry->d_op && path->dentry->d_op->d_dname)
+	if (path->dentry->d_op && path->dentry->d_op->d_dname &&
+	    (!IS_ROOT(path->dentry) || path->dentry != path->mnt->mnt_root))
 		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
 
 	get_fs_root(current->fs, &root);
diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index 1585db1..a73bc26 100644
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -103,7 +103,7 @@ int ore_verify_layout(unsigned total_comps, struct ore_layout *layout)
 
 	layout->max_io_length =
 		(BIO_MAX_PAGES_KMALLOC * PAGE_SIZE - layout->stripe_unit) *
-							layout->group_width;
+					(layout->group_width - layout->parity);
 	if (layout->parity) {
 		unsigned stripe_length =
 				(layout->group_width - layout->parity) *
@@ -286,7 +286,8 @@ int  ore_get_rw_state(struct ore_layout *layout, struct ore_components *oc,
 	if (length) {
 		ore_calc_stripe_info(layout, offset, length, &ios->si);
 		ios->length = ios->si.length;
-		ios->nr_pages = (ios->length + PAGE_SIZE - 1) / PAGE_SIZE;
+		ios->nr_pages = ((ios->offset & (PAGE_SIZE - 1)) +
+				 ios->length + PAGE_SIZE - 1) / PAGE_SIZE;
 		if (layout->parity)
 			_ore_post_alloc_raid_stuff(ios);
 	}
@@ -536,6 +537,7 @@ void ore_calc_stripe_info(struct ore_layout *layout, u64 file_offset,
 	u64	H = LmodS - G * T;
 
 	u32	N = div_u64(H, U);
+	u32	Nlast;
 
 	/* "H - (N * U)" is just "H % U" so it's bound to u32 */
 	u32	C = (u32)(H - (N * U)) / stripe_unit + G * group_width;
@@ -568,6 +570,10 @@ void ore_calc_stripe_info(struct ore_layout *layout, u64 file_offset,
 	si->length = T - H;
 	if (si->length > length)
 		si->length = length;
+
+	Nlast = div_u64(H + si->length + U - 1, U);
+	si->maxdevUnits = Nlast - N;
+
 	si->M = M;
 }
 EXPORT_SYMBOL(ore_calc_stripe_info);
@@ -583,13 +589,16 @@ int _ore_add_stripe_unit(struct ore_io_state *ios,  unsigned *cur_pg,
 	int ret;
 
 	if (per_dev->bio == NULL) {
-		unsigned pages_in_stripe = ios->layout->group_width *
-					(ios->layout->stripe_unit / PAGE_SIZE);
-		unsigned nr_pages = ios->nr_pages * ios->layout->group_width /
-					(ios->layout->group_width -
-					 ios->layout->parity);
-		unsigned bio_size = (nr_pages + pages_in_stripe) /
-					ios->layout->group_width;
+		unsigned bio_size;
+
+		if (!ios->reading) {
+			bio_size = ios->si.maxdevUnits;
+		} else {
+			bio_size = (ios->si.maxdevUnits + 1) *
+			     (ios->layout->group_width - ios->layout->parity) /
+			     ios->layout->group_width;
+		}
+		bio_size *= (ios->layout->stripe_unit / PAGE_SIZE);
 
 		per_dev->bio = bio_kmalloc(GFP_KERNEL, bio_size);
 		if (unlikely(!per_dev->bio)) {
@@ -609,8 +618,12 @@ int _ore_add_stripe_unit(struct ore_io_state *ios,  unsigned *cur_pg,
 		added_len = bio_add_pc_page(q, per_dev->bio, pages[pg],
 					    pglen, pgbase);
 		if (unlikely(pglen != added_len)) {
-			ORE_DBGMSG("Failed bio_add_pc_page bi_vcnt=%u\n",
-				   per_dev->bio->bi_vcnt);
+			/* If bi_vcnt == bi_max then this is a SW BUG */
+			ORE_DBGMSG("Failed bio_add_pc_page bi_vcnt=0x%x "
+				   "bi_max=0x%x BIO_MAX=0x%x cur_len=0x%x\n",
+				   per_dev->bio->bi_vcnt,
+				   per_dev->bio->bi_max_vecs,
+				   BIO_MAX_PAGES_KMALLOC, cur_len);
 			ret = -ENOMEM;
 			goto out;
 		}
@@ -1099,7 +1112,7 @@ int ore_truncate(struct ore_layout *layout, struct ore_components *oc,
 		size_attr->attr = g_attr_logical_length;
 		size_attr->attr.val_ptr = &size_attr->newsize;
 
-		ORE_DBGMSG("trunc(0x%llx) obj_offset=0x%llx dev=%d\n",
+		ORE_DBGMSG2("trunc(0x%llx) obj_offset=0x%llx dev=%d\n",
 			     _LLU(oc->comps->obj.id), _LLU(obj_size), i);
 		ret = _truncate_mirrors(ios, i * ios->layout->mirrors_p1,
 					&size_attr->attr);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8aacdda..efecfb7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1175,7 +1175,6 @@ static int ext4_journalled_write_end(struct file *file,
  */
 static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
 {
-	int retries = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int md_needed;
@@ -1197,7 +1196,6 @@ static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
 	 * in order to allocate nrblocks
 	 * worse case is one extent per block
 	 */
-repeat:
 	spin_lock(&ei->i_block_reservation_lock);
 	/*
 	 * ext4_calc_metadata_amount() has side effects, which we have
@@ -1217,10 +1215,6 @@ repeat:
 		ei->i_da_metadata_calc_len = save_len;
 		ei->i_da_metadata_calc_last_lblock = save_last_lblock;
 		spin_unlock(&ei->i_block_reservation_lock);
-		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
-			yield();
-			goto repeat;
-		}
 		dquot_release_reservation_block(inode, EXT4_C2B(sbi, 1));
 		return -ENOSPC;
 	}
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index bf7e15d..554aeb7 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -523,13 +523,16 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 	}
 	WARN_ON(inode->i_state & I_SYNC);
 	/*
-	 * Skip inode if it is clean. We don't want to mess with writeback
-	 * lists in this function since flusher thread may be doing for example
-	 * sync in parallel and if we move the inode, it could get skipped. So
-	 * here we make sure inode is on some writeback list and leave it there
-	 * unless we have completely cleaned the inode.
+	 * Skip inode if it is clean and we have no outstanding writeback in
+	 * WB_SYNC_ALL mode. We don't want to mess with writeback lists in this
+	 * function since flusher thread may be doing for example sync in
+	 * parallel and if we move the inode, it could get skipped. So here we
+	 * make sure inode is on some writeback list and leave it there unless
+	 * we have completely cleaned the inode.
 	 */
-	if (!(inode->i_state & I_DIRTY))
+	if (!(inode->i_state & I_DIRTY) &&
+	    (wbc->sync_mode != WB_SYNC_ALL ||
+	     !mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK)))
 		goto out;
 	inode->i_state |= I_SYNC;
 	spin_unlock(&inode->i_lock);
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index f4246cf..fd074cd 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1199,22 +1199,6 @@ static ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
 	return fuse_dev_do_read(fc, file, &cs, iov_length(iov, nr_segs));
 }
 
-static int fuse_dev_pipe_buf_steal(struct pipe_inode_info *pipe,
-				   struct pipe_buffer *buf)
-{
-	return 1;
-}
-
-static const struct pipe_buf_operations fuse_dev_pipe_buf_ops = {
-	.can_merge = 0,
-	.map = generic_pipe_buf_map,
-	.unmap = generic_pipe_buf_unmap,
-	.confirm = generic_pipe_buf_confirm,
-	.release = generic_pipe_buf_release,
-	.steal = fuse_dev_pipe_buf_steal,
-	.get = generic_pipe_buf_get,
-};
-
 static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
 				    struct pipe_inode_info *pipe,
 				    size_t len, unsigned int flags)
@@ -1261,7 +1245,11 @@ static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
 		buf->page = bufs[page_nr].page;
 		buf->offset = bufs[page_nr].offset;
 		buf->len = bufs[page_nr].len;
-		buf->ops = &fuse_dev_pipe_buf_ops;
+		/*
+		 * Need to be careful about this.  Having buf->ops in module
+		 * code can Oops if the buffer persists after module unload.
+		 */
+		buf->ops = &nosteal_pipe_buf_ops;
 
 		pipe->nrbufs++;
 		page_nr++;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 4bb79e7..69fd66a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6578,7 +6578,7 @@ nfs41_proc_secinfo_no_name(struct nfs_server *server, struct nfs_fh *fhandle,
 		switch (err) {
 		case 0:
 		case -NFS4ERR_WRONGSEC:
-		case -NFS4ERR_NOTSUPP:
+		case -ENOTSUPP:
 			goto out;
 		default:
 			err = nfs4_handle_exception(server, err, &exception);
@@ -6610,7 +6610,7 @@ nfs41_find_root_sec(struct nfs_server *server, struct nfs_fh *fhandle,
 	 * Fall back on "guess and check" method if
 	 * the server doesn't support SECINFO_NO_NAME
 	 */
-	if (err == -NFS4ERR_WRONGSEC || err == -NFS4ERR_NOTSUPP) {
+	if (err == -NFS4ERR_WRONGSEC || err == -ENOTSUPP) {
 		err = nfs4_find_root_sec(server, fhandle, info);
 		goto out_freepage;
 	}
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index cfce99b..9e2d9a4 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3011,7 +3011,8 @@ out_overflow:
 	return -EIO;
 }
 
-static int decode_op_hdr(struct xdr_stream *xdr, enum nfs_opnum4 expected)
+static bool __decode_op_hdr(struct xdr_stream *xdr, enum nfs_opnum4 expected,
+		int *nfs_retval)
 {
 	__be32 *p;
 	uint32_t opnum;
@@ -3021,19 +3022,32 @@ static int decode_op_hdr(struct xdr_stream *xdr, enum nfs_opnum4 expected)
 	if (unlikely(!p))
 		goto out_overflow;
 	opnum = be32_to_cpup(p++);
-	if (opnum != expected) {
-		dprintk("nfs: Server returned operation"
-			" %d but we issued a request for %d\n",
-				opnum, expected);
-		return -EIO;
-	}
+	if (unlikely(opnum != expected))
+		goto out_bad_operation;
 	nfserr = be32_to_cpup(p);
-	if (nfserr != NFS_OK)
-		return nfs4_stat_to_errno(nfserr);
-	return 0;
+	if (nfserr == NFS_OK)
+		*nfs_retval = 0;
+	else
+		*nfs_retval = nfs4_stat_to_errno(nfserr);
+	return true;
+out_bad_operation:
+	dprintk("nfs: Server returned operation"
+		" %d but we issued a request for %d\n",
+			opnum, expected);
+	*nfs_retval = -EREMOTEIO;
+	return false;
 out_overflow:
 	print_overflow_msg(__func__, xdr);
-	return -EIO;
+	*nfs_retval = -EIO;
+	return false;
+}
+
+static int decode_op_hdr(struct xdr_stream *xdr, enum nfs_opnum4 expected)
+{
+	int retval;
+
+	__decode_op_hdr(xdr, expected, &retval);
+	return retval;
 }
 
 /* Dummy routine */
@@ -4848,11 +4862,12 @@ static int decode_open(struct xdr_stream *xdr, struct nfs_openres *res)
 	uint32_t savewords, bmlen, i;
 	int status;
 
-	status = decode_op_hdr(xdr, OP_OPEN);
-	if (status != -EIO)
-		nfs_increment_open_seqid(status, res->seqid);
-	if (!status)
-		status = decode_stateid(xdr, &res->stateid);
+	if (!__decode_op_hdr(xdr, OP_OPEN, &status))
+		return status;
+	nfs_increment_open_seqid(status, res->seqid);
+	if (status)
+		return status;
+	status = decode_stateid(xdr, &res->stateid);
 	if (unlikely(status))
 		return status;
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 8992b33..e0a5a18 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1437,17 +1437,19 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 
 		nilfs_clear_logs(&sci->sc_segbufs);
 
-		err = nilfs_segctor_extend_segments(sci, nilfs, nadd);
-		if (unlikely(err))
-			return err;
-
 		if (sci->sc_stage.flags & NILFS_CF_SUFREED) {
 			err = nilfs_sufile_cancel_freev(nilfs->ns_sufile,
 							sci->sc_freesegs,
 							sci->sc_nfreesegs,
 							NULL);
 			WARN_ON(err); /* do not happen */
+			sci->sc_stage.flags &= ~NILFS_CF_SUFREED;
 		}
+
+		err = nilfs_segctor_extend_segments(sci, nilfs, nadd);
+		if (unlikely(err))
+			return err;
+
 		nadd = min_t(int, nadd << 1, SC_MAX_SEGDELTA);
 		sci->sc_stage = prev_stage;
 	}
diff --git a/fs/splice.c b/fs/splice.c
index 6cb3acb..74ff4f0 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -553,6 +553,24 @@ static const struct pipe_buf_operations default_pipe_buf_ops = {
 	.get = generic_pipe_buf_get,
 };
 
+static int generic_pipe_buf_nosteal(struct pipe_inode_info *pipe,
+				    struct pipe_buffer *buf)
+{
+	return 1;
+}
+
+/* Pipe buffer operations for a socket and similar. */
+const struct pipe_buf_operations nosteal_pipe_buf_ops = {
+	.can_merge = 0,
+	.map = generic_pipe_buf_map,
+	.unmap = generic_pipe_buf_unmap,
+	.confirm = generic_pipe_buf_confirm,
+	.release = generic_pipe_buf_release,
+	.steal = generic_pipe_buf_nosteal,
+	.get = generic_pipe_buf_get,
+};
+EXPORT_SYMBOL(nosteal_pipe_buf_ops);
+
 static ssize_t kernel_readv(struct file *file, const struct iovec *vec,
 			    unsigned long vlen, loff_t offset)
 {
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 41b4e49..8858e95 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -488,7 +488,7 @@ static inline void audit_syscall_exit(void *pt_regs)
 {
 	if (unlikely(current->audit_context)) {
 		int success = is_syscall_success(pt_regs);
-		int return_code = regs_return_value(pt_regs);
+		long return_code = regs_return_value(pt_regs);
 
 		__audit_syscall_exit(success, return_code);
 	}
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 9003fe3..16df330 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -24,6 +24,7 @@ struct hugepage_subpool *hugepage_new_subpool(long nr_blocks);
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 
 int PageHuge(struct page *page);
+int PageHeadHuge(struct page *page_head);
 
 void reset_vma_resv_huge_pages(struct vm_area_struct *vma);
 int hugetlb_sysctl_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
@@ -85,6 +86,11 @@ static inline int PageHuge(struct page *page)
 	return 0;
 }
 
+static inline int PageHeadHuge(struct page *page_head)
+{
+	return 0;
+}
+
 static inline void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
 {
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 53eb728..23a80570 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -791,7 +791,10 @@ static inline struct address_space *page_mapping(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
 
-	VM_BUG_ON(PageSlab(page));
+	/* This happens if someone calls flush_dcache_page on slab page */
+	if (unlikely(PageSlab(page)))
+		return NULL;
+
 	if (unlikely(PageSwapCache(page)))
 		mapping = &swapper_space;
 	else if ((unsigned long)mapping & PAGE_MAPPING_ANON)
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index e1ac1ce..e51bbd3 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -158,6 +158,8 @@ int generic_pipe_buf_confirm(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
 void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
 
+extern const struct pipe_buf_operations nosteal_pipe_buf_ops;
+
 /* for F_SETPIPE_SZ and F_GETPIPE_SZ */
 long pipe_fcntl(struct file *, unsigned int, unsigned long arg);
 struct pipe_inode_info *get_pipe_info(struct file *file);
diff --git a/include/scsi/osd_ore.h b/include/scsi/osd_ore.h
index a5f9b96..6ca3265 100644
--- a/include/scsi/osd_ore.h
+++ b/include/scsi/osd_ore.h
@@ -102,6 +102,7 @@ struct ore_striping_info {
 	unsigned unit_off;
 	unsigned cur_pg;
 	unsigned cur_comp;
+	unsigned maxdevUnits;
 };
 
 struct ore_io_state;
diff --git a/include/xen/platform_pci.h b/include/xen/platform_pci.h
index 438c256..b49eeab 100644
--- a/include/xen/platform_pci.h
+++ b/include/xen/platform_pci.h
@@ -48,4 +48,27 @@ static inline int xen_must_unplug_disks(void) {
 
 extern int xen_platform_pci_unplug;
 
+#if defined(CONFIG_XEN_PVHVM)
+extern bool xen_has_pv_devices(void);
+extern bool xen_has_pv_disk_devices(void);
+extern bool xen_has_pv_nic_devices(void);
+extern bool xen_has_pv_and_legacy_disk_devices(void);
+#else
+static inline bool xen_has_pv_devices(void)
+{
+	return IS_ENABLED(CONFIG_XEN);
+}
+static inline bool xen_has_pv_disk_devices(void)
+{
+	return IS_ENABLED(CONFIG_XEN);
+}
+static inline bool xen_has_pv_nic_devices(void)
+{
+	return IS_ENABLED(CONFIG_XEN);
+}
+static inline bool xen_has_pv_and_legacy_disk_devices(void)
+{
+	return false;
+}
+#endif
 #endif /* _XEN_PLATFORM_PCI_H */
diff --git a/lib/decompress_inflate.c b/lib/decompress_inflate.c
index 19ff89e..d619b28 100644
--- a/lib/decompress_inflate.c
+++ b/lib/decompress_inflate.c
@@ -48,7 +48,7 @@ STATIC int INIT gunzip(unsigned char *buf, int len,
 		out_len = 0x8000; /* 32 K */
 		out_buf = malloc(out_len);
 	} else {
-		out_len = 0x7fffffff; /* no limit */
+		out_len = ((size_t)~0) - (size_t)out_buf; /* no limit */
 	}
 	if (!out_buf) {
 		error("Out of memory while allocating output buffer");
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 44fd603..6c53091 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -679,6 +679,23 @@ int PageHuge(struct page *page)
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
+/*
+ * PageHeadHuge() only returns true for hugetlbfs head page, but not for
+ * normal or transparent huge pages.
+ */
+int PageHeadHuge(struct page *page_head)
+{
+	compound_page_dtor *dtor;
+
+	if (!PageHead(page_head))
+		return 0;
+
+	dtor = get_compound_page_dtor(page_head);
+
+	return dtor == free_huge_page;
+}
+EXPORT_SYMBOL_GPL(PageHeadHuge);
+
 pgoff_t __basepage_index(struct page *page)
 {
 	struct page *page_head = compound_head(page);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 1bf1092..5eb3f727 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1447,10 +1447,18 @@ static int soft_offline_huge_page(struct page *page, int flags)
 		return ret;
 	}
 done:
-	if (!PageHWPoison(hpage))
-		atomic_long_add(1 << compound_trans_order(hpage), &mce_bad_pages);
-	set_page_hwpoison_huge_page(hpage);
-	dequeue_hwpoisoned_huge_page(hpage);
+	/* overcommit hugetlb page will be freed to buddy */
+	if (PageHuge(hpage)) {
+		if (!PageHWPoison(hpage))
+			atomic_long_add(1 << compound_trans_order(hpage),
+					&mce_bad_pages);
+		set_page_hwpoison_huge_page(hpage);
+		dequeue_hwpoisoned_huge_page(hpage);
+	} else {
+		SetPageHWPoison(page);
+		atomic_long_inc(&mce_bad_pages);
+	}
+
 	/* keep elevated page count for bad page */
 	return ret;
 }
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index b45c813..0eba956 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -212,7 +212,7 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
 	 * implementation used by LSMs.
 	 */
 	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
-		adj -= 30;
+		points -= (points * 3) / 100;
 
 	/* Normalize to oom_score_adj units */
 	adj *= totalpages / 1000;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 194cc02..31ea8e2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -173,6 +173,25 @@ static struct prop_descriptor vm_completions;
  * global dirtyable memory first.
  */
 
+/**
+ * zone_dirtyable_memory - number of dirtyable pages in a zone
+ * @zone: the zone
+ *
+ * Returns the zone's number of pages potentially available for dirty
+ * page cache.  This is the base value for the per-zone dirty limits.
+ */
+static unsigned long zone_dirtyable_memory(struct zone *zone)
+{
+	unsigned long nr_pages;
+
+	nr_pages = zone_page_state(zone, NR_FREE_PAGES);
+	nr_pages -= min(nr_pages, zone->dirty_balance_reserve);
+
+	nr_pages += zone_reclaimable_pages(zone);
+
+	return nr_pages;
+}
+
 static unsigned long highmem_dirtyable_memory(unsigned long total)
 {
 #ifdef CONFIG_HIGHMEM
@@ -180,11 +199,9 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
 	unsigned long x = 0;
 
 	for_each_node_state(node, N_HIGH_MEMORY) {
-		struct zone *z =
-			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
+		struct zone *z = &NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
-		x += zone_page_state(z, NR_FREE_PAGES) +
-		     zone_reclaimable_pages(z) - z->dirty_balance_reserve;
+		x += zone_dirtyable_memory(z);
 	}
 	/*
 	 * Unreclaimable memory (kernel memory or anonymous memory
@@ -220,9 +237,11 @@ static unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
+	x = global_page_state(NR_FREE_PAGES);
 	x -= min(x, dirty_balance_reserve);
 
+	x += global_reclaimable_pages();
+
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
 
@@ -271,32 +290,6 @@ void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
 }
 
 /**
- * zone_dirtyable_memory - number of dirtyable pages in a zone
- * @zone: the zone
- *
- * Returns the zone's number of pages potentially available for dirty
- * page cache.  This is the base value for the per-zone dirty limits.
- */
-static unsigned long zone_dirtyable_memory(struct zone *zone)
-{
-	/*
-	 * The effective global number of dirtyable pages may exclude
-	 * highmem as a big-picture measure to keep the ratio between
-	 * dirty memory and lowmem reasonable.
-	 *
-	 * But this function is purely about the individual zone and a
-	 * highmem zone can hold its share of dirty pages, so we don't
-	 * care about vm_highmem_is_dirtyable here.
-	 */
-	unsigned long nr_pages = zone_page_state(zone, NR_FREE_PAGES) +
-		zone_reclaimable_pages(zone);
-
-	/* don't allow this to underflow */
-	nr_pages -= min(nr_pages, zone->dirty_balance_reserve);
-	return nr_pages;
-}
-
-/**
  * zone_dirty_limit - maximum number of dirty pages allowed in a zone
  * @zone: the zone
  *
diff --git a/mm/slub.c b/mm/slub.c
index 8c691fa..ca056a6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4520,7 +4520,13 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 			page = c->partial;
 
 			if (page) {
-				x = page->pobjects;
+				node = page_to_nid(page);
+				if (flags & SO_TOTAL)
+					WARN_ON_ONCE(1);
+				else if (flags & SO_OBJECTS)
+					WARN_ON_ONCE(1);
+				else
+					x = page->pages;
 				total += x;
 				nodes[node] += x;
 			}
diff --git a/mm/swap.c b/mm/swap.c
index 0c833e8..6325163 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -78,19 +78,6 @@ static void __put_compound_page(struct page *page)
 
 static void put_compound_page(struct page *page)
 {
-	/*
-	 * hugetlbfs pages cannot be split from under us.  If this is a
-	 * hugetlbfs page, check refcount on head page and release the page if
-	 * the refcount becomes zero.
-	 */
-	if (PageHuge(page)) {
-		page = compound_head(page);
-		if (put_page_testzero(page))
-			__put_compound_page(page);
-
-		return;
-	}
-
 	if (unlikely(PageTail(page))) {
 		/* __split_huge_page_refcount can run under us */
 		struct page *page_head = compound_trans_head(page);
@@ -107,14 +94,31 @@ static void put_compound_page(struct page *page)
 			 * still hot on arches that do not support
 			 * this_cpu_cmpxchg_double().
 			 */
-			if (PageSlab(page_head)) {
-				if (PageTail(page)) {
+			if (PageSlab(page_head) || PageHeadHuge(page_head)) {
+				if (likely(PageTail(page))) {
+					/*
+					 * __split_huge_page_refcount
+					 * cannot race here.
+					 */
+					VM_BUG_ON(!PageHead(page_head));
+					atomic_dec(&page->_mapcount);
 					if (put_page_testzero(page_head))
 						VM_BUG_ON(1);
-
-					atomic_dec(&page->_mapcount);
-					goto skip_lock_tail;
+					if (put_page_testzero(page_head))
+						__put_compound_page(page_head);
+					return;
 				} else
+					/*
+					 * __split_huge_page_refcount
+					 * run before us, "page" was a
+					 * THP tail. The split
+					 * page_head has been freed
+					 * and reallocated as slab or
+					 * hugetlbfs page of smaller
+					 * order (only possible if
+					 * reallocated as slab on
+					 * x86).
+					 */
 					goto skip_lock;
 			}
 			/*
@@ -128,8 +132,27 @@ static void put_compound_page(struct page *page)
 				/* __split_huge_page_refcount run before us */
 				compound_unlock_irqrestore(page_head, flags);
 skip_lock:
-				if (put_page_testzero(page_head))
-					__put_single_page(page_head);
+				if (put_page_testzero(page_head)) {
+					/*
+					 * The head page may have been
+					 * freed and reallocated as a
+					 * compound page of smaller
+					 * order and then freed again.
+					 * All we know is that it
+					 * cannot have become: a THP
+					 * page, a compound page of
+					 * higher order, a tail page.
+					 * That is because we still
+					 * hold the refcount of the
+					 * split THP tail and
+					 * page_head was the THP head
+					 * before the split.
+					 */
+					if (PageHead(page_head))
+						__put_compound_page(page_head);
+					else
+						__put_single_page(page_head);
+				}
 out_put_single:
 				if (put_page_testzero(page))
 					__put_single_page(page);
@@ -151,7 +174,6 @@ out_put_single:
 			VM_BUG_ON(atomic_read(&page->_count) != 0);
 			compound_unlock_irqrestore(page_head, flags);
 
-skip_lock_tail:
 			if (put_page_testzero(page_head)) {
 				if (PageHead(page_head))
 					__put_compound_page(page_head);
@@ -194,51 +216,52 @@ bool __get_page_tail(struct page *page)
 	 * proper PT lock that already serializes against
 	 * split_huge_page().
 	 */
+	unsigned long flags;
 	bool got = false;
-	struct page *page_head;
-
-	/*
-	 * If this is a hugetlbfs page it cannot be split under us.  Simply
-	 * increment refcount for the head page.
-	 */
-	if (PageHuge(page)) {
-		page_head = compound_head(page);
-		atomic_inc(&page_head->_count);
-		got = true;
-	} else {
-		unsigned long flags;
+	struct page *page_head = compound_trans_head(page);
 
-		page_head = compound_trans_head(page);
-		if (likely(page != page_head &&
-					get_page_unless_zero(page_head))) {
-
-			/* Ref to put_compound_page() comment. */
-			if (PageSlab(page_head)) {
-				if (likely(PageTail(page))) {
-					__get_page_tail_foll(page, false);
-					return true;
-				} else {
-					put_page(page_head);
-					return false;
-				}
-			}
-
-			/*
-			 * page_head wasn't a dangling pointer but it
-			 * may not be a head page anymore by the time
-			 * we obtain the lock. That is ok as long as it
-			 * can't be freed from under us.
-			 */
-			flags = compound_lock_irqsave(page_head);
-			/* here __split_huge_page_refcount won't run anymore */
+	if (likely(page != page_head && get_page_unless_zero(page_head))) {
+		/* Ref to put_compound_page() comment. */
+		if (PageSlab(page_head) || PageHeadHuge(page_head)) {
 			if (likely(PageTail(page))) {
+				/*
+				 * This is a hugetlbfs page or a slab
+				 * page. __split_huge_page_refcount
+				 * cannot race here.
+				 */
+				VM_BUG_ON(!PageHead(page_head));
 				__get_page_tail_foll(page, false);
-				got = true;
-			}
-			compound_unlock_irqrestore(page_head, flags);
-			if (unlikely(!got))
+				return true;
+			} else {
+				/*
+				 * __split_huge_page_refcount run
+				 * before us, "page" was a THP
+				 * tail. The split page_head has been
+				 * freed and reallocated as slab or
+				 * hugetlbfs page of smaller order
+				 * (only possible if reallocated as
+				 * slab on x86).
+				 */
 				put_page(page_head);
+				return false;
+			}
+		}
+
+		/*
+		 * page_head wasn't a dangling pointer but it
+		 * may not be a head page anymore by the time
+		 * we obtain the lock. That is ok as long as it
+		 * can't be freed from under us.
+		 */
+		flags = compound_lock_irqsave(page_head);
+		/* here __split_huge_page_refcount won't run anymore */
+		if (likely(PageTail(page))) {
+			__get_page_tail_foll(page, false);
+			got = true;
 		}
+		compound_unlock_irqrestore(page_head, flags);
+		if (unlikely(!got))
+			put_page(page_head);
 	}
 	return got;
 }
diff --git a/net/compat.c b/net/compat.c
index 1d223d5..9c0fca1 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -781,21 +781,16 @@ asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 	if (flags & MSG_CMSG_COMPAT)
 		return -EINVAL;
 
-	if (COMPAT_USE_64BIT_TIME)
-		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
-				      flags | MSG_CMSG_COMPAT,
-				      (struct timespec *) timeout);
-
 	if (timeout == NULL)
 		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				      flags | MSG_CMSG_COMPAT, NULL);
 
-	if (get_compat_timespec(&ktspec, timeout))
+	if (compat_get_timespec(&ktspec, timeout))
 		return -EFAULT;
 
 	datagrams = __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				   flags | MSG_CMSG_COMPAT, &ktspec);
-	if (datagrams > 0 && put_compat_timespec(&ktspec, timeout))
+	if (datagrams > 0 && compat_put_timespec(&ktspec, timeout))
 		datagrams = -EFAULT;
 
 	return datagrams;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7ed8ef3..1e37e1a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -74,36 +74,6 @@
 struct kmem_cache *skbuff_head_cache __read_mostly;
 static struct kmem_cache *skbuff_fclone_cache __read_mostly;
 
-static void sock_pipe_buf_release(struct pipe_inode_info *pipe,
-				  struct pipe_buffer *buf)
-{
-	put_page(buf->page);
-}
-
-static void sock_pipe_buf_get(struct pipe_inode_info *pipe,
-				struct pipe_buffer *buf)
-{
-	get_page(buf->page);
-}
-
-static int sock_pipe_buf_steal(struct pipe_inode_info *pipe,
-			       struct pipe_buffer *buf)
-{
-	return 1;
-}
-
-
-/* Pipe buffer operations for a socket. */
-static const struct pipe_buf_operations sock_pipe_buf_ops = {
-	.can_merge = 0,
-	.map = generic_pipe_buf_map,
-	.unmap = generic_pipe_buf_unmap,
-	.confirm = generic_pipe_buf_confirm,
-	.release = sock_pipe_buf_release,
-	.steal = sock_pipe_buf_steal,
-	.get = sock_pipe_buf_get,
-};
-
 /*
  *	Keep out-of-line to prevent kernel bloat.
  *	__builtin_return_address is not used because it is not always
@@ -1710,7 +1680,7 @@ int skb_splice_bits(struct sk_buff *skb, unsigned int offset,
 		.partial = partial,
 		.nr_pages_max = MAX_SKB_FRAGS,
 		.flags = flags,
-		.ops = &sock_pipe_buf_ops,
+		.ops = &nosteal_pipe_buf_ops,
 		.spd_release = sock_spd_release,
 	};
 	struct sk_buff *frag_iter;
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index e530c31..60e48d7 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -941,7 +941,7 @@ next_normal:
 			++num;
 		}
 
-		if (r->idiag_states & TCPF_TIME_WAIT) {
+		if (r->idiag_states & (TCPF_TIME_WAIT | TCPF_FIN_WAIT2)) {
 			struct inet_timewait_sock *tw;
 
 			inet_twsk_for_each(tw, node,
@@ -949,6 +949,8 @@ next_normal:
 
 				if (num < s_num)
 					goto next_dying;
+				if (!(r->idiag_states & (1 << tw->tw_substate)))
+					goto next_dying;
 				if (r->sdiag_family != AF_UNSPEC &&
 						tw->tw_family != r->sdiag_family)
 					goto next_dying;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index f780fa3..7fa2594 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -154,9 +154,12 @@ static struct mr_table *ipmr_get_table(struct net *net, u32 id)
 static int ipmr_fib_lookup(struct net *net, struct flowi4 *flp4,
 			   struct mr_table **mrt)
 {
-	struct ipmr_result res;
-	struct fib_lookup_arg arg = { .result = &res, };
 	int err;
+	struct ipmr_result res;
+	struct fib_lookup_arg arg = {
+		.result = &res,
+		.flags = FIB_LOOKUP_NOREF,
+	};
 
 	err = fib_rules_lookup(net->ipv4.mr_rules_ops,
 			       flowi4_to_flowi(flp4), 0, &arg);
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 65dff8a..2df3e4a 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -138,9 +138,12 @@ static struct mr6_table *ip6mr_get_table(struct net *net, u32 id)
 static int ip6mr_fib_lookup(struct net *net, struct flowi6 *flp6,
 			    struct mr6_table **mrt)
 {
-	struct ip6mr_result res;
-	struct fib_lookup_arg arg = { .result = &res, };
 	int err;
+	struct ip6mr_result res;
+	struct fib_lookup_arg arg = {
+		.result = &res,
+		.flags = FIB_LOOKUP_NOREF,
+	};
 
 	err = fib_rules_lookup(net->ipv6.mr6_rules_ops,
 			       flowi6_to_flowi(flp6), 0, &arg);
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 46b5fb6..c119c1b 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1334,9 +1334,13 @@ call_refreshresult(struct rpc_task *task)
 	task->tk_action = call_refresh;
 	switch (status) {
 	case 0:
-		if (rpcauth_uptodatecred(task))
+		if (rpcauth_uptodatecred(task)) {
 			task->tk_action = call_allocate;
-		return;
+			return;
+		}
+		/* Use rate-limiting and a max number of retries if refresh
+		 * had status 0 but failed to update the cred.
+		 */
 	case -ETIMEDOUT:
 		rpc_delay(task, 3*HZ);
 	case -EAGAIN:
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 9cd9b7c..142a59f 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1941,7 +1941,19 @@ static int filename_trans_read(struct policydb *p, void *fp)
 		if (rc)
 			goto out;
 
-		hashtab_insert(p->filename_trans, ft, otype);
+		rc = hashtab_insert(p->filename_trans, ft, otype);
+		if (rc) {
+			/*
+			 * Do not return -EEXIST to the caller, or the system
+			 * will not boot.
+			 */
+			if (rc != -EEXIST)
+				goto out;
+			/* But free memory to avoid memory leak. */
+			kfree(ft);
+			kfree(name);
+			kfree(otype);
+		}
 	}
 	hash_eval(p->filename_trans, "filenametr");
 	return 0;
diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index ff3af6e..1ae4c03 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -30,6 +30,7 @@ config SND_ALS300
 	select SND_PCM
 	select SND_AC97_CODEC
 	select SND_OPL3_LIB
+	select ZONE_DMA
 	help
 	  Say 'Y' or 'M' to include support for Avance Logic ALS300/ALS300+
 
@@ -54,6 +55,7 @@ config SND_ALI5451
 	tristate "ALi M5451 PCI Audio Controller"
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for the integrated AC97 sound
 	  device on motherboards using the ALi M5451 Audio Controller
@@ -158,6 +160,7 @@ config SND_AZT3328
 	select SND_PCM
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for Aztech AZF3328 (PCI168)
 	  soundcards.
@@ -463,6 +466,7 @@ config SND_EMU10K1
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y to include support for Sound Blaster PCI 512, Live!,
 	  Audigy and E-mu APS (partially supported) soundcards.
@@ -478,6 +482,7 @@ config SND_EMU10K1X
 	tristate "Emu10k1X (Dell OEM Version)"
 	select SND_AC97_CODEC
 	select SND_RAWMIDI
+	select ZONE_DMA
 	help
 	  Say Y here to include support for the Dell OEM version of the
 	  Sound Blaster Live!.
@@ -511,6 +516,7 @@ config SND_ES1938
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on ESS Solo-1
 	  (ES1938, ES1946, ES1969) chips.
@@ -522,6 +528,7 @@ config SND_ES1968
 	tristate "ESS ES1968/1978 (Maestro-1/2/2E)"
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on ESS Maestro
 	  1/2/2E chips.
@@ -602,6 +609,7 @@ config SND_ICE1712
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	select BITREVERSE
+	select ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on the
 	  ICE1712 (Envy24) chip.
@@ -688,6 +696,7 @@ config SND_LX6464ES
 config SND_MAESTRO3
 	tristate "ESS Allegro/Maestro3"
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on ESS Maestro 3
 	  (Allegro) chips.
@@ -782,6 +791,7 @@ config SND_SIS7019
 	tristate "SiS 7019 Audio Accelerator"
 	depends on X86 && !X86_64
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for the SiS 7019 Audio Accelerator.
 
@@ -793,6 +803,7 @@ config SND_SONICVIBES
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on the S3
 	  SonicVibes chip.
@@ -804,6 +815,7 @@ config SND_TRIDENT
 	tristate "Trident 4D-Wave DX/NX; SiS 7018"
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on Trident
 	  4D-Wave DX/NX or SiS 7018 chips.
diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index a15fc10..1b3ce88 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -285,7 +285,7 @@ static char channel_map_9636_ds[26] = {
 	/* ADAT channels are remapped */
 	1, 3, 5, 7, 9, 11, 13, 15,
 	/* channels 8 and 9 are S/PDIF */
-	24, 25
+	24, 25,
 	/* others don't exist */
 	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
 };
diff --git a/sound/soc/codecs/adau1701.c b/sound/soc/codecs/adau1701.c
index 3d50fc8..347f455 100644
--- a/sound/soc/codecs/adau1701.c
+++ b/sound/soc/codecs/adau1701.c
@@ -64,7 +64,7 @@
 
 #define ADAU1701_SEROCTL_WORD_LEN_24	0x0000
 #define ADAU1701_SEROCTL_WORD_LEN_20	0x0001
-#define ADAU1701_SEROCTL_WORD_LEN_16	0x0010
+#define ADAU1701_SEROCTL_WORD_LEN_16	0x0002
 #define ADAU1701_SEROCTL_WORD_LEN_MASK	0x0003
 
 #define ADAU1701_AUXNPOW_VBPD		0x40
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 56142d0..b21bc79 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -917,6 +917,7 @@ static struct machine *
 					       union perf_event *event)
 {
 	const u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct machine *machine;
 
 	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest) {
 		u32 pid;
@@ -926,7 +927,11 @@ static struct machine *
 		else
 			pid = event->ip.pid;
 
-		return perf_session__findnew_machine(session, pid);
+		machine = perf_session__find_machine(session, pid);
+		if (!machine)
+			machine = perf_session__findnew_machine(session,
+						DEFAULT_GUEST_KERNEL_ID);
+		return machine;
 	}
 
 	return perf_session__find_host_machine(session);
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 16de7ad..43a7bda 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -34,6 +34,7 @@
 #include <string.h>
 #include <ctype.h>
 #include <sched.h>
+#include <cpuid.h>
 
 #define MSR_TSC	0x10
 #define MSR_NEHALEM_PLATFORM_INFO	0xCE
@@ -955,7 +956,7 @@ void check_cpuid()
 
 	eax = ebx = ecx = edx = 0;
 
-	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0));
+	__get_cpuid(0, &max_level, &ebx, &ecx, &edx);
 
 	if (ebx == 0x756e6547 && edx == 0x49656e69 && ecx == 0x6c65746e)
 		genuine_intel = 1;
@@ -964,7 +965,7 @@ void check_cpuid()
 		fprintf(stderr, "%.4s%.4s%.4s ",
 			(char *)&ebx, (char *)&edx, (char *)&ecx);
 
-	asm("cpuid" : "=a" (fms), "=c" (ecx), "=d" (edx) : "a" (1) : "ebx");
+	__get_cpuid(1, &fms, &ebx, &ecx, &edx);
 	family = (fms >> 8) & 0xf;
 	model = (fms >> 4) & 0xf;
 	stepping = fms & 0xf;
@@ -986,7 +987,7 @@ void check_cpuid()
 	 * This check is valid for both Intel and AMD.
 	 */
 	ebx = ecx = edx = 0;
-	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x80000000));
+	__get_cpuid(0x80000000, &max_level, &ebx, &ecx, &edx);
 
 	if (max_level < 0x80000007) {
 		fprintf(stderr, "CPUID: no invariant TSC (max_level 0x%x)\n", max_level);
@@ -997,7 +998,7 @@ void check_cpuid()
 	 * Non-Stop TSC is advertised by CPUID.EAX=0x80000007: EDX.bit8
 	 * this check is valid for both Intel and AMD
 	 */
-	asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x80000007));
+	__get_cpuid(0x80000007, &eax, &ebx, &ecx, &edx);
 	has_invariant_tsc = edx & (1 << 8);
 
 	if (!has_invariant_tsc) {
@@ -1010,7 +1011,7 @@ void check_cpuid()
 	 * this check is valid for both Intel and AMD
 	 */
 
-	asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x6));
+	__get_cpuid(0x6, &eax, &ebx, &ecx, &edx);
 	has_aperf = ecx & (1 << 0);
 	if (!has_aperf) {
 		fprintf(stderr, "No APERF MSR\n");
