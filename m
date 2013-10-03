Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3JCIpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 04:45:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35099 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3JCIo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 04:44:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.22
Date: Thu,  3 Oct 2013 09:44:49 +0100
Message-Id: <1380789889-14100-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380789889-14100-1-git-send-email-luis.henriques@canonical.com>
References: <1380789889-14100-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 4e8e898..541f22d 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -1,6 +1,6 @@
 <?xml version="1.0"?>
-<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
-	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" [
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
+	"http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" [
 <!ENTITY % media-entities SYSTEM "./media-entities.tmpl"> %media-entities;
 <!ENTITY media-indices SYSTEM "./media-indices.tmpl">
 
diff --git a/Makefile b/Makefile
index c724e1d..539f784 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .21
+EXTRAVERSION = .22
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index af94887..474e76d 100644
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -43,9 +43,9 @@
 #define PCI_IMAP0		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x0)
 #define PCI_IMAP1		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x4)
 #define PCI_IMAP2		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x8)
-#define PCI_SMAP0		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x10)
-#define PCI_SMAP1		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x14)
-#define PCI_SMAP2		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x18)
+#define PCI_SMAP0		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x14)
+#define PCI_SMAP1		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x18)
+#define PCI_SMAP2		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x1c)
 #define PCI_SELFID		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0xc)
 
 #define DEVICE_ID_OFFSET		0x00
@@ -308,6 +308,19 @@ int __init pci_versatile_setup(int nr, struct pci_sys_data *sys)
 	__raw_writel(PHYS_OFFSET, local_pci_cfg_base + PCI_BASE_ADDRESS_2);
 
 	/*
+	 * For many years the kernel and QEMU were symbiotically buggy
+	 * in that they both assumed the same broken IRQ mapping.
+	 * QEMU therefore attempts to auto-detect old broken kernels
+	 * so that they still work on newer QEMU as they did on old
+	 * QEMU. Since we now use the correct (ie matching-hardware)
+	 * IRQ mapping we write a definitely different value to a
+	 * PCI_INTERRUPT_LINE register to tell QEMU that we expect
+	 * real hardware behaviour and it need not be backwards
+	 * compatible for us. This write is harmless on real hardware.
+	 */
+	__raw_writel(0, VERSATILE_PCI_VIRT_BASE+PCI_INTERRUPT_LINE);
+
+	/*
 	 * Do not to map Versatile FPGA PCI device into memory space
 	 */
 	pci_slot_ignore |= (1 << myslot);
@@ -341,13 +354,13 @@ static int __init versatile_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
 
-	/* slot,  pin,	irq
-	 *  24     1     IRQ_SIC_PCI0
-	 *  25     1     IRQ_SIC_PCI1
-	 *  26     1     IRQ_SIC_PCI2
-	 *  27     1     IRQ_SIC_PCI3
+	/*
+	 * Slot	INTA	INTB	INTC	INTD
+	 * 31	PCI1	PCI2	PCI3	PCI0
+	 * 30	PCI0	PCI1	PCI2	PCI3
+	 * 29	PCI3	PCI0	PCI1	PCI2
 	 */
-	irq = IRQ_SIC_PCI0 + ((slot - 24 + pin - 1) & 3);
+	irq = IRQ_SIC_PCI0 + ((slot + 2 + pin - 1) & 3);
 
 	return irq;
 }
diff --git a/arch/mips/ath79/clock.c b/arch/mips/ath79/clock.c
index 579f452..300d7d3 100644
--- a/arch/mips/ath79/clock.c
+++ b/arch/mips/ath79/clock.c
@@ -164,7 +164,7 @@ static void __init ar933x_clocks_init(void)
 		ath79_ahb_clk.rate = freq / t;
 	}
 
-	ath79_wdt_clk.rate = ath79_ref_clk.rate;
+	ath79_wdt_clk.rate = ath79_ahb_clk.rate;
 	ath79_uart_clk.rate = ath79_ref_clk.rate;
 }
 
diff --git a/arch/powerpc/kernel/align.c b/arch/powerpc/kernel/align.c
index ee5b690..52e5758 100644
--- a/arch/powerpc/kernel/align.c
+++ b/arch/powerpc/kernel/align.c
@@ -764,6 +764,16 @@ int fix_alignment(struct pt_regs *regs)
 	nb = aligninfo[instr].len;
 	flags = aligninfo[instr].flags;
 
+	/* ldbrx/stdbrx overlap lfs/stfs in the DSISR unfortunately */
+	if (IS_XFORM(instruction) && ((instruction >> 1) & 0x3ff) == 532) {
+		nb = 8;
+		flags = LD+SW;
+	} else if (IS_XFORM(instruction) &&
+		   ((instruction >> 1) & 0x3ff) == 660) {
+		nb = 8;
+		flags = ST+SW;
+	}
+
 	/* Byteswap little endian loads and stores */
 	swiz = 0;
 	if (regs->msr & MSR_LE) {
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 51ecac9..1e09357 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -352,7 +352,7 @@ static int alloc_dispatch_log_kmem_cache(void)
 }
 early_initcall(alloc_dispatch_log_kmem_cache);
 
-static void pSeries_idle(void)
+static void pseries_lpar_idle(void)
 {
 	/* This would call on the cpuidle framework, and the back-end pseries
 	 * driver to  go to idle states
@@ -360,10 +360,22 @@ static void pSeries_idle(void)
 	if (cpuidle_idle_call()) {
 		/* On error, execute default handler
 		 * to go into low thread priority and possibly
-		 * low power mode.
+		 * low power mode by cedeing processor to hypervisor
 		 */
-		HMT_low();
-		HMT_very_low();
+
+		/* Indicate to hypervisor that we are idle. */
+		get_lppaca()->idle = 1;
+
+		/*
+		 * Yield the processor to the hypervisor.  We return if
+		 * an external interrupt occurs (which are driven prior
+		 * to returning here) or if a prod occurs from another
+		 * processor. When returning here, external interrupts
+		 * are enabled.
+		 */
+		cede_processor();
+
+		get_lppaca()->idle = 0;
 	}
 }
 
@@ -395,15 +407,14 @@ static void __init pSeries_setup_arch(void)
 
 	pSeries_nvram_init();
 
-	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
+	if (firmware_has_feature(FW_FEATURE_LPAR)) {
 		vpa_init(boot_cpuid);
-		ppc_md.power_save = pSeries_idle;
-	}
-
-	if (firmware_has_feature(FW_FEATURE_LPAR))
+		ppc_md.power_save = pseries_lpar_idle;
 		ppc_md.enable_pmcs = pseries_lpar_enable_pmcs;
-	else
+	} else {
+		/* No special idle routine */
 		ppc_md.enable_pmcs = power4_enable_pmcs;
+	}
 }
 
 static int __init pSeries_init_panel(void)
diff --git a/crypto/api.c b/crypto/api.c
index 033a714..cea3cf6 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -34,6 +34,8 @@ EXPORT_SYMBOL_GPL(crypto_alg_sem);
 BLOCKING_NOTIFIER_HEAD(crypto_chain);
 EXPORT_SYMBOL_GPL(crypto_chain);
 
+static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
+
 static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
 {
 	atomic_inc(&alg->cra_refcnt);
@@ -150,8 +152,11 @@ static struct crypto_alg *crypto_larval_add(const char *name, u32 type,
 	}
 	up_write(&crypto_alg_sem);
 
-	if (alg != &larval->alg)
+	if (alg != &larval->alg) {
 		kfree(larval);
+		if (crypto_is_larval(alg))
+			alg = crypto_larval_wait(alg);
+	}
 
 	return alg;
 }
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index f9914e5..d1a9674 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -974,6 +974,14 @@ static struct dmi_system_id __initdata ec_dmi_table[] = {
 	ec_enlarge_storm_threshold, "CLEVO hardware", {
 	DMI_MATCH(DMI_SYS_VENDOR, "CLEVO Co."),
 	DMI_MATCH(DMI_PRODUCT_NAME, "M720T/M730T"),}, NULL},
+	{
+	ec_skip_dsdt_scan, "HP Folio 13", {
+	DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+	DMI_MATCH(DMI_PRODUCT_NAME, "HP Folio 13"),}, NULL},
+	{
+	ec_validate_ecdt, "ASUS hardware", {
+	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTek Computer Inc."),
+	DMI_MATCH(DMI_PRODUCT_NAME, "L4R"),}, NULL},
 	{},
 };
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c89aa01..cb721e3 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -69,7 +69,7 @@ bool regmap_precious(struct regmap *map, unsigned int reg)
 }
 
 static bool regmap_volatile_range(struct regmap *map, unsigned int reg,
-	unsigned int num)
+	size_t num)
 {
 	unsigned int i;
 
diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 47b0f70..5a757be 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -90,7 +90,11 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3393) },
 	{ USB_DEVICE(0x0489, 0xe04e) },
 	{ USB_DEVICE(0x0489, 0xe056) },
+	{ USB_DEVICE(0x0489, 0xe04d) },
+	{ USB_DEVICE(0x04c5, 0x1330) },
+	{ USB_DEVICE(0x13d3, 0x3402) },
 	{ USB_DEVICE(0x0cf3, 0x3121) },
+	{ USB_DEVICE(0x0cf3, 0xe003) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
@@ -127,7 +131,11 @@ static struct usb_device_id ath3k_blist_tbl[] = {
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04c5, 0x1330), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3121), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0xe003), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU22 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE03C), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index f403d46..e17340f 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -63,6 +63,9 @@ static struct usb_device_id btusb_table[] = {
 	/* Apple-specific (Broadcom) devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x05ac, 0xff, 0x01, 0x01) },
 
+	/* MediaTek MT76x0E */
+	{ USB_DEVICE(0x0e8d, 0x763f) },
+
 	/* Broadcom SoftSailing reporting vendor specific */
 	{ USB_DEVICE(0x0a5c, 0x21e1) },
 
@@ -156,7 +159,11 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04c5, 0x1330), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3121), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0xe003), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index c674823..bdbc6a2 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -125,6 +125,9 @@ static struct edid_quirk {
 
 	/* ViewSonic VA2026w */
 	{ "VSC", 5020, EDID_QUIRK_FORCE_REDUCED_BLANKING },
+
+	/* Medion MD 30217 PG */
+	{ "MED", 0x7b8, EDID_QUIRK_PREFER_LARGE_75 },
 };
 
 /*** DDC fetch and block validation ***/
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 70bfc0f..e275ef6 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3991,7 +3991,7 @@
 #define EDP_LINK_TRAIN_600MV_0DB_IVB		(0x30 <<22)
 #define EDP_LINK_TRAIN_600MV_3_5DB_IVB		(0x36 <<22)
 #define EDP_LINK_TRAIN_800MV_0DB_IVB		(0x38 <<22)
-#define EDP_LINK_TRAIN_800MV_3_5DB_IVB		(0x33 <<22)
+#define EDP_LINK_TRAIN_800MV_3_5DB_IVB		(0x3e <<22)
 
 /* legacy values */
 #define EDP_LINK_TRAIN_500MV_0DB_IVB		(0x00 <<22)
diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index e27c170..6d708d7 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -163,7 +163,7 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
 
 	max = intel_panel_get_max_backlight(dev);
 	intel_panel_set_backlight(dev, bclp * max / 255);
-	iowrite32((bclp*0x64)/0xff | ASLE_CBLV_VALID, &asle->cblv);
+	iowrite32(DIV_ROUND_UP(bclp * 100, 255) | ASLE_CBLV_VALID, &asle->cblv);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index 824d03c..a672379 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -51,7 +51,7 @@ static char *pre_emph_names[] = {
  * or from atom. Note that atom operates on
  * dw units.
  */
-static void radeon_copy_swap(u8 *dst, u8 *src, u8 num_bytes, bool to_le)
+void radeon_atom_copy_swap(u8 *dst, u8 *src, u8 num_bytes, bool to_le)
 {
 #ifdef __BIG_ENDIAN
 	u8 src_tmp[20], dst_tmp[20]; /* used for byteswapping */
@@ -101,7 +101,7 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan *chan,
 
 	base = (unsigned char *)(rdev->mode_info.atom_context->scratch + 1);
 
-	radeon_copy_swap(base, send, send_bytes, true);
+	radeon_atom_copy_swap(base, send, send_bytes, true);
 
 	args.v1.lpAuxRequest = cpu_to_le16((u16)(0 + 4));
 	args.v1.lpDataOut = cpu_to_le16((u16)(16 + 4));
@@ -138,7 +138,7 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan *chan,
 		recv_bytes = recv_size;
 
 	if (recv && recv_size)
-		radeon_copy_swap(recv, base + 16, recv_bytes, false);
+		radeon_atom_copy_swap(recv, base + 16, recv_bytes, false);
 
 	return recv_bytes;
 }
diff --git a/drivers/gpu/drm/radeon/atombios_i2c.c b/drivers/gpu/drm/radeon/atombios_i2c.c
index 44d87b6..9ed94a8 100644
--- a/drivers/gpu/drm/radeon/atombios_i2c.c
+++ b/drivers/gpu/drm/radeon/atombios_i2c.c
@@ -27,6 +27,8 @@
 #include "radeon.h"
 #include "atom.h"
 
+extern void radeon_atom_copy_swap(u8 *dst, u8 *src, u8 num_bytes, bool to_le);
+
 #define TARGET_HW_I2C_CLOCK 50
 
 /* these are a limitation of ProcessI2cChannelTransaction not the hw */
@@ -77,7 +79,7 @@ static int radeon_process_i2c_ch(struct radeon_i2c_chan *chan,
 	}
 
 	if (!(flags & HW_I2C_WRITE))
-		memcpy(buf, base, num);
+		radeon_atom_copy_swap(buf, base, num, false);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 7ac565f..650e2d7 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -534,7 +534,8 @@ static u32 evergreen_line_buffer_adjust(struct radeon_device *rdev,
 					struct drm_display_mode *mode,
 					struct drm_display_mode *other_mode)
 {
-	u32 tmp;
+	u32 tmp, buffer_alloc, i;
+	u32 pipe_offset = radeon_crtc->crtc_id * 0x20;
 	/*
 	 * Line Buffer Setup
 	 * There are 3 line buffers, each one shared by 2 display controllers.
@@ -557,18 +558,34 @@ static u32 evergreen_line_buffer_adjust(struct radeon_device *rdev,
 	 * non-linked crtcs for maximum line buffer allocation.
 	 */
 	if (radeon_crtc->base.enabled && mode) {
-		if (other_mode)
+		if (other_mode) {
 			tmp = 0; /* 1/2 */
-		else
+			buffer_alloc = 1;
+		} else {
 			tmp = 2; /* whole */
-	} else
+			buffer_alloc = 2;
+		}
+	} else {
 		tmp = 0;
+		buffer_alloc = 0;
+	}
 
 	/* second controller of the pair uses second half of the lb */
 	if (radeon_crtc->crtc_id % 2)
 		tmp += 4;
 	WREG32(DC_LB_MEMORY_SPLIT + radeon_crtc->crtc_offset, tmp);
 
+	if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev)) {
+		WREG32(PIPE0_DMIF_BUFFER_CONTROL + pipe_offset,
+		       DMIF_BUFFERS_ALLOCATED(buffer_alloc));
+		for (i = 0; i < rdev->usec_timeout; i++) {
+			if (RREG32(PIPE0_DMIF_BUFFER_CONTROL + pipe_offset) &
+			    DMIF_BUFFERS_ALLOCATED_COMPLETED)
+				break;
+			udelay(1);
+		}
+	}
+
 	if (radeon_crtc->base.enabled && mode) {
 		switch (tmp) {
 		case 0:
@@ -3064,6 +3081,11 @@ static int evergreen_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	evergreen_pcie_gen2_enable(rdev);
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	evergreen_mc_program(rdev);
 
 	if (ASIC_IS_DCE5(rdev)) {
@@ -3089,10 +3111,6 @@ static int evergreen_startup(struct radeon_device *rdev)
 		}
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	if (rdev->flags & RADEON_IS_AGP) {
 		evergreen_agp_enable(rdev);
 	} else {
diff --git a/drivers/gpu/drm/radeon/evergreend.h b/drivers/gpu/drm/radeon/evergreend.h
index 735e515..5e24050 100644
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -707,6 +707,10 @@
 #       define LATENCY_LOW_WATERMARK(x)                   ((x) << 0)
 #       define LATENCY_HIGH_WATERMARK(x)                  ((x) << 16)
 
+#define	PIPE0_DMIF_BUFFER_CONTROL			  0x0ca0
+#       define DMIF_BUFFERS_ALLOCATED(x)                  ((x) << 0)
+#       define DMIF_BUFFERS_ALLOCATED_COMPLETED           (1 << 4)
+
 #define IH_RB_CNTL                                        0x3e00
 #       define IH_RB_ENABLE                               (1 << 0)
 #       define IH_IB_SIZE(x)                              ((x) << 1) /* log2 */
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index ba9ae56..fcd7335 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1239,6 +1239,11 @@ static int cayman_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	evergreen_pcie_gen2_enable(rdev);
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	evergreen_mc_program(rdev);
 
 	if (rdev->flags & RADEON_IS_IGP) {
@@ -1265,10 +1270,6 @@ static int cayman_startup(struct radeon_device *rdev)
 		}
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	r = cayman_pcie_gart_enable(rdev);
 	if (r)
 		return r;
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 0e431c0..3458d4a 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2361,6 +2361,11 @@ int r600_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	r600_pcie_gen2_enable(rdev);
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	r600_mc_program(rdev);
 
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
@@ -2371,10 +2376,6 @@ int r600_startup(struct radeon_device *rdev)
 		}
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	if (rdev->flags & RADEON_IS_AGP) {
 		r600_agp_enable(rdev);
 	} else {
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 38d87e1..c54d295 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -715,13 +715,16 @@ bool radeon_get_atom_connector_info_from_object_table(struct drm_device *dev)
 								(ATOM_SRC_DST_TABLE_FOR_ONE_OBJECT *)
 								(ctx->bios + data_offset +
 								 le16_to_cpu(router_obj->asObjects[k].usSrcDstTableOffset));
+							u8 *num_dst_objs = (u8 *)
+								((u8 *)router_src_dst_table + 1 +
+								 (router_src_dst_table->ucNumberOfSrc * 2));
+							u16 *dst_objs = (u16 *)(num_dst_objs + 1);
 							int enum_id;
 
 							router.router_id = router_obj_id;
-							for (enum_id = 0; enum_id < router_src_dst_table->ucNumberOfDst;
-							     enum_id++) {
+							for (enum_id = 0; enum_id < (*num_dst_objs); enum_id++) {
 								if (le16_to_cpu(path->usConnObjectId) ==
-								    le16_to_cpu(router_src_dst_table->usDstObjectID[enum_id]))
+								    le16_to_cpu(dst_objs[enum_id]))
 									break;
 							}
 
@@ -1622,7 +1625,9 @@ struct radeon_encoder_atom_dig *radeon_atombios_get_lvds_info(struct
 								kfree(edid);
 						}
 					}
-					record += sizeof(ATOM_FAKE_EDID_PATCH_RECORD);
+					record += fake_edid_record->ucFakeEDIDLength ?
+						fake_edid_record->ucFakeEDIDLength + 2 :
+						sizeof(ATOM_FAKE_EDID_PATCH_RECORD);
 					break;
 				case LCD_PANEL_RESOLUTION_RECORD_TYPE:
 					panel_res_record = (ATOM_PANEL_RESOLUTION_PATCH_RECORD *)record;
diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
index 30003b6..6169e1b 100644
--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -198,16 +198,18 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
 			dev_info(rdev->dev, "radeon: using MSI.\n");
 		}
 	}
+
+	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
+	INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
+
 	rdev->irq.installed = true;
 	r = drm_irq_install(rdev->ddev);
 	if (r) {
 		rdev->irq.installed = false;
+		flush_work(&rdev->hotplug_work);
 		return r;
 	}
 
-	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
-	INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
-
 	DRM_INFO("radeon: irq initialized.\n");
 	return 0;
 }
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index 9ada7ed..a56f440 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -174,10 +174,13 @@ int rs400_gart_enable(struct radeon_device *rdev)
 	/* FIXME: according to doc we should set HIDE_MMCFG_BAR=0,
 	 * AGPMODE30=0 & AGP30ENHANCED=0 in NB_CNTL */
 	if ((rdev->family == CHIP_RS690) || (rdev->family == CHIP_RS740)) {
-		WREG32_MC(RS480_MC_MISC_CNTL,
-			  (RS480_GART_INDEX_REG_EN | RS690_BLOCK_GFX_D3_EN));
+		tmp = RREG32_MC(RS480_MC_MISC_CNTL);
+		tmp |= RS480_GART_INDEX_REG_EN | RS690_BLOCK_GFX_D3_EN;
+		WREG32_MC(RS480_MC_MISC_CNTL, tmp);
 	} else {
-		WREG32_MC(RS480_MC_MISC_CNTL, RS480_GART_INDEX_REG_EN);
+		tmp = RREG32_MC(RS480_MC_MISC_CNTL);
+		tmp |= RS480_GART_INDEX_REG_EN;
+		WREG32_MC(RS480_MC_MISC_CNTL, tmp);
 	}
 	/* Enable gart */
 	WREG32_MC(RS480_AGP_ADDRESS_SPACE_SIZE, (RS480_GART_EN | size_reg));
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index d6fa2b5..186d019 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -890,6 +890,11 @@ static int rv770_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	rv770_pcie_gen2_enable(rdev);
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	rv770_mc_program(rdev);
 
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
@@ -900,10 +905,6 @@ static int rv770_startup(struct radeon_device *rdev)
 		}
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	if (rdev->flags & RADEON_IS_AGP) {
 		rv770_agp_enable(rdev);
 	} else {
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 625c4ba..9987345 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -411,7 +411,8 @@ static u32 dce6_line_buffer_adjust(struct radeon_device *rdev,
 				   struct drm_display_mode *mode,
 				   struct drm_display_mode *other_mode)
 {
-	u32 tmp;
+	u32 tmp, buffer_alloc, i;
+	u32 pipe_offset = radeon_crtc->crtc_id * 0x20;
 	/*
 	 * Line Buffer Setup
 	 * There are 3 line buffers, each one shared by 2 display controllers.
@@ -426,16 +427,30 @@ static u32 dce6_line_buffer_adjust(struct radeon_device *rdev,
 	 * non-linked crtcs for maximum line buffer allocation.
 	 */
 	if (radeon_crtc->base.enabled && mode) {
-		if (other_mode)
+		if (other_mode) {
 			tmp = 0; /* 1/2 */
-		else
+			buffer_alloc = 1;
+		} else {
 			tmp = 2; /* whole */
-	} else
+			buffer_alloc = 2;
+		}
+	} else {
 		tmp = 0;
+		buffer_alloc = 0;
+	}
 
 	WREG32(DC_LB_MEMORY_SPLIT + radeon_crtc->crtc_offset,
 	       DC_LB_MEMORY_CONFIG(tmp));
 
+	WREG32(PIPE0_DMIF_BUFFER_CONTROL + pipe_offset,
+	       DMIF_BUFFERS_ALLOCATED(buffer_alloc));
+	for (i = 0; i < rdev->usec_timeout; i++) {
+		if (RREG32(PIPE0_DMIF_BUFFER_CONTROL + pipe_offset) &
+		    DMIF_BUFFERS_ALLOCATED_COMPLETED)
+			break;
+		udelay(1);
+	}
+
 	if (radeon_crtc->base.enabled && mode) {
 		switch (tmp) {
 		case 0:
@@ -3683,6 +3698,11 @@ static int si_startup(struct radeon_device *rdev)
 	struct radeon_ring *ring;
 	int r;
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	si_mc_program(rdev);
 
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->ce_fw ||
@@ -3700,10 +3720,6 @@ static int si_startup(struct radeon_device *rdev)
 		return r;
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	r = si_pcie_gart_enable(rdev);
 	if (r)
 		return r;
diff --git a/drivers/gpu/drm/radeon/sid.h b/drivers/gpu/drm/radeon/sid.h
index 916e13f..0a240fa 100644
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -62,6 +62,10 @@
 
 #define DMIF_ADDR_CALC  				0xC00
 
+#define	PIPE0_DMIF_BUFFER_CONTROL			  0x0ca0
+#       define DMIF_BUFFERS_ALLOCATED(x)                  ((x) << 0)
+#       define DMIF_BUFFERS_ALLOCATED_COMPLETED           (1 << 4)
+
 #define	SRBM_STATUS				        0xE50
 
 #define	CC_SYS_RB_BACKEND_DISABLE			0xe80
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
index 21ee782..e1978a2 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
@@ -29,7 +29,9 @@
 #include "drmP.h"
 #include "ttm/ttm_bo_driver.h"
 
-#define VMW_PPN_SIZE sizeof(unsigned long)
+#define VMW_PPN_SIZE (sizeof(unsigned long))
+/* A future safe maximum remap size. */
+#define VMW_PPN_PER_REMAP ((31 * 1024) / VMW_PPN_SIZE)
 
 static int vmw_gmr2_bind(struct vmw_private *dev_priv,
 			 struct page *pages[],
@@ -38,43 +40,61 @@ static int vmw_gmr2_bind(struct vmw_private *dev_priv,
 {
 	SVGAFifoCmdDefineGMR2 define_cmd;
 	SVGAFifoCmdRemapGMR2 remap_cmd;
-	uint32_t define_size = sizeof(define_cmd) + 4;
-	uint32_t remap_size = VMW_PPN_SIZE * num_pages + sizeof(remap_cmd) + 4;
 	uint32_t *cmd;
 	uint32_t *cmd_orig;
+	uint32_t define_size = sizeof(define_cmd) + sizeof(*cmd);
+	uint32_t remap_num = num_pages / VMW_PPN_PER_REMAP + ((num_pages % VMW_PPN_PER_REMAP) > 0);
+	uint32_t remap_size = VMW_PPN_SIZE * num_pages + (sizeof(remap_cmd) + sizeof(*cmd)) * remap_num;
+	uint32_t remap_pos = 0;
+	uint32_t cmd_size = define_size + remap_size;
 	uint32_t i;
 
-	cmd_orig = cmd = vmw_fifo_reserve(dev_priv, define_size + remap_size);
+	cmd_orig = cmd = vmw_fifo_reserve(dev_priv, cmd_size);
 	if (unlikely(cmd == NULL))
 		return -ENOMEM;
 
 	define_cmd.gmrId = gmr_id;
 	define_cmd.numPages = num_pages;
 
+	*cmd++ = SVGA_CMD_DEFINE_GMR2;
+	memcpy(cmd, &define_cmd, sizeof(define_cmd));
+	cmd += sizeof(define_cmd) / sizeof(*cmd);
+
+	/*
+	 * Need to split the command if there are too many
+	 * pages that goes into the gmr.
+	 */
+
 	remap_cmd.gmrId = gmr_id;
 	remap_cmd.flags = (VMW_PPN_SIZE > sizeof(*cmd)) ?
 		SVGA_REMAP_GMR2_PPN64 : SVGA_REMAP_GMR2_PPN32;
-	remap_cmd.offsetPages = 0;
-	remap_cmd.numPages = num_pages;
 
-	*cmd++ = SVGA_CMD_DEFINE_GMR2;
-	memcpy(cmd, &define_cmd, sizeof(define_cmd));
-	cmd += sizeof(define_cmd) / sizeof(uint32);
+	while (num_pages > 0) {
+		unsigned long nr = min(num_pages, (unsigned long)VMW_PPN_PER_REMAP);
+
+		remap_cmd.offsetPages = remap_pos;
+		remap_cmd.numPages = nr;
 
-	*cmd++ = SVGA_CMD_REMAP_GMR2;
-	memcpy(cmd, &remap_cmd, sizeof(remap_cmd));
-	cmd += sizeof(remap_cmd) / sizeof(uint32);
+		*cmd++ = SVGA_CMD_REMAP_GMR2;
+		memcpy(cmd, &remap_cmd, sizeof(remap_cmd));
+		cmd += sizeof(remap_cmd) / sizeof(*cmd);
 
-	for (i = 0; i < num_pages; ++i) {
-		if (VMW_PPN_SIZE <= 4)
-			*cmd = page_to_pfn(*pages++);
-		else
-			*((uint64_t *)cmd) = page_to_pfn(*pages++);
+		for (i = 0; i < nr; ++i) {
+			if (VMW_PPN_SIZE <= 4)
+				*cmd = page_to_pfn(*pages++);
+			else
+				*((uint64_t *)cmd) = page_to_pfn(*pages++);
 
-		cmd += VMW_PPN_SIZE / sizeof(*cmd);
+			cmd += VMW_PPN_SIZE / sizeof(*cmd);
+		}
+
+		num_pages -= nr;
+		remap_pos += nr;
 	}
 
-	vmw_fifo_commit(dev_priv, define_size + remap_size);
+	BUG_ON(cmd != cmd_orig + cmd_size / sizeof(*cmd));
+
+	vmw_fifo_commit(dev_priv, cmd_size);
 
 	return 0;
 }
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2f85e59..0d76d3f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -63,6 +63,8 @@ struct hid_report *hid_register_report(struct hid_device *device, unsigned type,
 	struct hid_report_enum *report_enum = device->report_enum + type;
 	struct hid_report *report;
 
+	if (id >= HID_MAX_IDS)
+		return NULL;
 	if (report_enum->report_id_hash[id])
 		return report_enum->report_id_hash[id];
 
@@ -392,8 +394,10 @@ static int hid_parser_global(struct hid_parser *parser, struct hid_item *item)
 
 	case HID_GLOBAL_ITEM_TAG_REPORT_ID:
 		parser->global.report_id = item_udata(item);
-		if (parser->global.report_id == 0) {
-			hid_err(parser->device, "report_id 0 is invalid\n");
+		if (parser->global.report_id == 0 ||
+		    parser->global.report_id >= HID_MAX_IDS) {
+			hid_err(parser->device, "report_id %u is invalid\n",
+				parser->global.report_id);
 			return -1;
 		}
 		return 0;
@@ -563,7 +567,7 @@ static void hid_close_report(struct hid_device *device)
 	for (i = 0; i < HID_REPORT_TYPES; i++) {
 		struct hid_report_enum *report_enum = device->report_enum + i;
 
-		for (j = 0; j < 256; j++) {
+		for (j = 0; j < HID_MAX_IDS; j++) {
 			struct hid_report *report = report_enum->report_id_hash[j];
 			if (report)
 				hid_free_report(report);
@@ -1129,7 +1133,12 @@ EXPORT_SYMBOL_GPL(hid_output_report);
 
 int hid_set_field(struct hid_field *field, unsigned offset, __s32 value)
 {
-	unsigned size = field->report_size;
+	unsigned size;
+
+	if (!field)
+		return -1;
+
+	size = field->report_size;
 
 	hid_dump_input(field->report->device, field->usage + offset, value);
 
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 5301006..c460b74 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -325,7 +325,7 @@ static int hidinput_get_battery_property(struct power_supply *psy,
 {
 	struct hid_device *dev = container_of(psy, struct hid_device, battery);
 	int ret = 0;
-	__u8 buf[2] = {};
+	__u8 *buf;
 
 	switch (prop) {
 	case POWER_SUPPLY_PROP_PRESENT:
@@ -334,21 +334,29 @@ static int hidinput_get_battery_property(struct power_supply *psy,
 		break;
 
 	case POWER_SUPPLY_PROP_CAPACITY:
+
+		buf = kmalloc(2 * sizeof(__u8), GFP_KERNEL);
+		if (!buf) {
+			ret = -ENOMEM;
+			break;
+		}
 		ret = dev->hid_get_raw_report(dev, dev->battery_report_id,
-					      buf, sizeof(buf),
+					      buf, 2,
 					      dev->battery_report_type);
 
 		if (ret != 2) {
-			if (ret >= 0)
-				ret = -EINVAL;
+			ret = -ENODATA;
+			kfree(buf);
 			break;
 		}
+		ret = 0;
 
 		if (dev->battery_min < dev->battery_max &&
 		    buf[1] >= dev->battery_min &&
 		    buf[1] <= dev->battery_max)
 			val->intval = (100 * (buf[1] - dev->battery_min)) /
 				(dev->battery_max - dev->battery_min);
+		kfree(buf);
 		break;
 
 	case POWER_SUPPLY_PROP_MODEL_NAME:
diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 9fae2eb..48cba85 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -115,7 +115,8 @@ static inline int ntrig_get_mode(struct hid_device *hdev)
 	struct hid_report *report = hdev->report_enum[HID_FEATURE_REPORT].
 				    report_id_hash[0x0d];
 
-	if (!report)
+	if (!report || report->maxfield < 1 ||
+	    report->field[0]->report_count < 1)
 		return -EINVAL;
 
 	usbhid_submit_report(hdev, report, USB_DIR_IN);
diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 45c3433..95f9047 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -1424,7 +1424,7 @@ static ssize_t picolcd_operation_mode_store(struct device *dev,
 		buf += 10;
 		cnt -= 10;
 	}
-	if (!report)
+	if (!report || report->maxfield != 1)
 		return -EINVAL;
 
 	while (cnt > 0 && (buf[cnt-1] == '\n' || buf[cnt-1] == '\r'))
diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
index 47ed74c..00cd2f8 100644
--- a/drivers/hid/hid-pl.c
+++ b/drivers/hid/hid-pl.c
@@ -129,8 +129,14 @@ static int plff_init(struct hid_device *hid)
 			strong = &report->field[0]->value[2];
 			weak = &report->field[0]->value[3];
 			debug("detected single-field device");
-		} else if (report->maxfield >= 4 && report->field[0]->maxusage == 1 &&
-				report->field[0]->usage[0].hid == (HID_UP_LED | 0x43)) {
+		} else if (report->field[0]->maxusage == 1 &&
+			   report->field[0]->usage[0].hid ==
+				(HID_UP_LED | 0x43) &&
+			   report->maxfield >= 4 &&
+			   report->field[0]->report_count >= 1 &&
+			   report->field[1]->report_count >= 1 &&
+			   report->field[2]->report_count >= 1 &&
+			   report->field[3]->report_count >= 1) {
 			report->field[0]->value[0] = 0x00;
 			report->field[1]->value[0] = 0x00;
 			strong = &report->field[2]->value[0];
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index eafc4ed..e560f54 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -887,56 +887,54 @@ static int dma_pte_clear_range(struct dmar_domain *domain,
 	return order;
 }
 
+static void dma_pte_free_level(struct dmar_domain *domain, int level,
+			       struct dma_pte *pte, unsigned long pfn,
+			       unsigned long start_pfn, unsigned long last_pfn)
+{
+	pfn = max(start_pfn, pfn);
+	pte = &pte[pfn_level_offset(pfn, level)];
+
+	do {
+		unsigned long level_pfn;
+		struct dma_pte *level_pte;
+
+		if (!dma_pte_present(pte) || dma_pte_superpage(pte))
+			goto next;
+
+		level_pfn = pfn & level_mask(level - 1);
+		level_pte = phys_to_virt(dma_pte_addr(pte));
+
+		if (level > 2)
+			dma_pte_free_level(domain, level - 1, level_pte,
+					   level_pfn, start_pfn, last_pfn);
+
+		/* If range covers entire pagetable, free it */
+		if (!(start_pfn > level_pfn ||
+		      last_pfn < level_pfn + level_size(level))) {
+			dma_clear_pte(pte);
+			domain_flush_cache(domain, pte, sizeof(*pte));
+			free_pgtable_page(level_pte);
+		}
+next:
+		pfn += level_size(level);
+	} while (!first_pte_in_page(++pte) && pfn <= last_pfn);
+}
+
 /* free page table pages. last level pte should already be cleared */
 static void dma_pte_free_pagetable(struct dmar_domain *domain,
 				   unsigned long start_pfn,
 				   unsigned long last_pfn)
 {
 	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
-	struct dma_pte *first_pte, *pte;
-	int total = agaw_to_level(domain->agaw);
-	int level;
-	unsigned long tmp;
-	int large_page = 2;
 
 	BUG_ON(addr_width < BITS_PER_LONG && start_pfn >> addr_width);
 	BUG_ON(addr_width < BITS_PER_LONG && last_pfn >> addr_width);
 	BUG_ON(start_pfn > last_pfn);
 
 	/* We don't need lock here; nobody else touches the iova range */
-	level = 2;
-	while (level <= total) {
-		tmp = align_to_level(start_pfn, level);
-
-		/* If we can't even clear one PTE at this level, we're done */
-		if (tmp + level_size(level) - 1 > last_pfn)
-			return;
-
-		do {
-			large_page = level;
-			first_pte = pte = dma_pfn_level_pte(domain, tmp, level, &large_page);
-			if (large_page > level)
-				level = large_page + 1;
-			if (!pte) {
-				tmp = align_to_level(tmp + 1, level + 1);
-				continue;
-			}
-			do {
-				if (dma_pte_present(pte)) {
-					free_pgtable_page(phys_to_virt(dma_pte_addr(pte)));
-					dma_clear_pte(pte);
-				}
-				pte++;
-				tmp += level_size(level);
-			} while (!first_pte_in_page(pte) &&
-				 tmp + level_size(level) - 1 <= last_pfn);
+	dma_pte_free_level(domain, agaw_to_level(domain->agaw),
+			   domain->pgd, 0, start_pfn, last_pfn);
 
-			domain_flush_cache(domain, first_pte,
-					   (void *)pte - (void *)first_pte);
-			
-		} while (tmp && tmp + level_size(level) - 1 <= last_pfn);
-		level++;
-	}
 	/* free pgd */
 	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw)) {
 		free_pgtable_page(domain->pgd);
diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
index 304f43e..dcb7833 100644
--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -309,6 +309,11 @@ static int hdpvr_probe(struct usb_interface *interface,
 
 	dev->workqueue = 0;
 
+	/* init video transfer queues first of all */
+	/* to prevent oops in hdpvr_delete() on error paths */
+	INIT_LIST_HEAD(&dev->free_buff_list);
+	INIT_LIST_HEAD(&dev->rec_buff_list);
+
 	/* register v4l2_device early so it can be used for printks */
 	if (v4l2_device_register(&interface->dev, &dev->v4l2_dev)) {
 		dev_err(&interface->dev, "v4l2_device_register failed\n");
@@ -331,10 +336,6 @@ static int hdpvr_probe(struct usb_interface *interface,
 	if (!dev->workqueue)
 		goto error;
 
-	/* init video transfer queues */
-	INIT_LIST_HEAD(&dev->free_buff_list);
-	INIT_LIST_HEAD(&dev->rec_buff_list);
-
 	dev->options = hdpvr_default_options;
 
 	if (default_video_input < HDPVR_VIDEO_INPUTS)
diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
index 9132f61..f35903c 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite.c
@@ -75,14 +75,14 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 	}, {
 		.name		= "RAW10 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG10,
-		.depth		= { 10 },
+		.depth		= { 16 },
 		.color		= FIMC_FMT_RAW10,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_SGRBG10_1X10,
 	}, {
 		.name		= "RAW12 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG12,
-		.depth		= { 12 },
+		.depth		= { 16 },
 		.color		= FIMC_FMT_RAW12,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_SGRBG12_1X12,
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 52cef48..8a3ec6f 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -980,9 +980,9 @@ static int fimc_md_probe(struct platform_device *pdev)
 err_unlock:
 	mutex_unlock(&fmd->media_dev.graph_mutex);
 err_clk:
-	media_device_unregister(&fmd->media_dev);
 	fimc_md_put_clocks(fmd);
 	fimc_md_unregister_entities(fmd);
+	media_device_unregister(&fmd->media_dev);
 err_md:
 	v4l2_device_unregister(&fmd->v4l2_dev);
 	return ret;
diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index 7c98ee7..a96d7a2 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -753,6 +753,7 @@ static int g2d_probe(struct platform_device *pdev)
 	   This driver needs auditing so that this flag can be removed. */
 	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	vfd->lock = &dev->mutex;
+	vfd->v4l2_dev = &dev->v4l2_dev;
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
diff --git a/drivers/mmc/host/tmio_mmc_dma.c b/drivers/mmc/host/tmio_mmc_dma.c
index fff9286..491e9ec 100644
--- a/drivers/mmc/host/tmio_mmc_dma.c
+++ b/drivers/mmc/host/tmio_mmc_dma.c
@@ -104,6 +104,7 @@ static void tmio_mmc_start_dma_rx(struct tmio_mmc_host *host)
 pio:
 	if (!desc) {
 		/* DMA failed, fall back to PIO */
+		tmio_mmc_enable_dma(host, false);
 		if (ret >= 0)
 			ret = -EIO;
 		host->chan_rx = NULL;
@@ -116,7 +117,6 @@ pio:
 		}
 		dev_warn(&host->pdev->dev,
 			 "DMA failed: %d, falling back to PIO\n", ret);
-		tmio_mmc_enable_dma(host, false);
 	}
 
 	dev_dbg(&host->pdev->dev, "%s(): desc %p, cookie %d, sg[%d]\n", __func__,
@@ -185,6 +185,7 @@ static void tmio_mmc_start_dma_tx(struct tmio_mmc_host *host)
 pio:
 	if (!desc) {
 		/* DMA failed, fall back to PIO */
+		tmio_mmc_enable_dma(host, false);
 		if (ret >= 0)
 			ret = -EIO;
 		host->chan_tx = NULL;
@@ -197,7 +198,6 @@ pio:
 		}
 		dev_warn(&host->pdev->dev,
 			 "DMA failed: %d, falling back to PIO\n", ret);
-		tmio_mmc_enable_dma(host, false);
 	}
 
 	dev_dbg(&host->pdev->dev, "%s(): desc %p, cookie %d\n", __func__,
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 1e1ae64..c7fd229c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3759,11 +3759,17 @@ static int bond_neigh_init(struct neighbour *n)
  * The bonding ndo_neigh_setup is called at init time beofre any
  * slave exists. So we must declare proxy setup function which will
  * be used at run time to resolve the actual slave neigh param setup.
+ *
+ * It's also called by master devices (such as vlans) to setup their
+ * underlying devices. In that case - do nothing, we're already set up from
+ * our init.
  */
 static int bond_neigh_setup(struct net_device *dev,
 			    struct neigh_parms *parms)
 {
-	parms->neigh_setup   = bond_neigh_init;
+	/* modify only our neigh_parms */
+	if (parms->dev == dev)
+		parms->neigh_setup = bond_neigh_init;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index bf8eb57..efd3e34 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -524,6 +524,7 @@ rx_status_loop:
 					 PCI_DMA_FROMDEVICE);
 		if (dma_mapping_error(&cp->pdev->dev, new_mapping)) {
 			dev->stats.rx_dropped++;
+			kfree_skb(new_skb);
 			goto rx_next;
 		}
 
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index cc5b48d..8b7c4f2 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -643,6 +643,28 @@ static int macvtap_skb_to_vnet_hdr(const struct sk_buff *skb,
 	return 0;
 }
 
+static unsigned long iov_pages(const struct iovec *iv, int offset,
+			       unsigned long nr_segs)
+{
+	unsigned long seg, base;
+	int pages = 0, len, size;
+
+	while (nr_segs && (offset >= iv->iov_len)) {
+		offset -= iv->iov_len;
+		++iv;
+		--nr_segs;
+	}
+
+	for (seg = 0; seg < nr_segs; seg++) {
+		base = (unsigned long)iv[seg].iov_base + offset;
+		len = iv[seg].iov_len - offset;
+		size = ((base & ~PAGE_MASK) + len + ~PAGE_MASK) >> PAGE_SHIFT;
+		pages += size;
+		offset = 0;
+	}
+
+	return pages;
+}
 
 /* Get packet from user space buffer */
 static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
@@ -689,31 +711,15 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
 	if (unlikely(count > UIO_MAXIOV))
 		goto err;
 
-	if (m && m->msg_control && sock_flag(&q->sk, SOCK_ZEROCOPY))
-		zerocopy = true;
-
-	if (zerocopy) {
-		/* Userspace may produce vectors with count greater than
-		 * MAX_SKB_FRAGS, so we need to linearize parts of the skb
-		 * to let the rest of data to be fit in the frags.
-		 */
-		if (count > MAX_SKB_FRAGS) {
-			copylen = iov_length(iv, count - MAX_SKB_FRAGS);
-			if (copylen < vnet_hdr_len)
-				copylen = 0;
-			else
-				copylen -= vnet_hdr_len;
-		}
-		/* There are 256 bytes to be copied in skb, so there is enough
-		 * room for skb expand head in case it is used.
-		 * The rest buffer is mapped from userspace.
-		 */
-		if (copylen < vnet_hdr.hdr_len)
-			copylen = vnet_hdr.hdr_len;
-		if (!copylen)
-			copylen = GOODCOPY_LEN;
+	if (m && m->msg_control && sock_flag(&q->sk, SOCK_ZEROCOPY)) {
+		copylen = vnet_hdr.hdr_len ? vnet_hdr.hdr_len : GOODCOPY_LEN;
 		linear = copylen;
-	} else {
+		if (iov_pages(iv, vnet_hdr_len + copylen, count)
+		    <= MAX_SKB_FRAGS)
+			zerocopy = true;
+	}
+
+	if (!zerocopy) {
 		copylen = len;
 		linear = vnet_hdr.hdr_len;
 	}
@@ -725,9 +731,15 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
 
 	if (zerocopy)
 		err = zerocopy_sg_from_iovec(skb, iv, vnet_hdr_len, count);
-	else
+	else {
 		err = skb_copy_datagram_from_iovec(skb, 0, iv, vnet_hdr_len,
 						   len);
+		if (!err && m && m->msg_control) {
+			struct ubuf_info *uarg = m->msg_control;
+			uarg->callback(uarg);
+		}
+	}
+
 	if (err)
 		goto err_kfree;
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 21c33f2..f21bcef 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -615,8 +615,9 @@ static ssize_t tun_get_user(struct tun_struct *tun,
 	int offset = 0;
 
 	if (!(tun->flags & TUN_NO_PI)) {
-		if ((len -= sizeof(pi)) > count)
+		if (len < sizeof(pi))
 			return -EINVAL;
+		len -= sizeof(pi);
 
 		if (memcpy_fromiovecend((void *)&pi, iv, 0, sizeof(pi)))
 			return -EFAULT;
@@ -624,8 +625,9 @@ static ssize_t tun_get_user(struct tun_struct *tun,
 	}
 
 	if (tun->flags & TUN_VNET_HDR) {
-		if ((len -= tun->vnet_hdr_sz) > count)
+		if (len < tun->vnet_hdr_sz)
 			return -EINVAL;
+		len -= tun->vnet_hdr_sz;
 
 		if (memcpy_fromiovecend((void *)&gso, iv, offset, sizeof(gso)))
 			return -EFAULT;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index ac2aa7a..fb919e5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -956,6 +956,10 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 		 * is_on == 0 means MRC CCK is OFF (more noise imm)
 		 */
 		bool is_on = param ? 1 : 0;
+
+		if (ah->caps.rx_chainmask == 1)
+			break;
+
 		REG_RMW_FIELD(ah, AR_PHY_MRC_CCK_CTRL,
 			      AR_PHY_MRC_CCK_ENABLE, is_on);
 		REG_RMW_FIELD(ah, AR_PHY_MRC_CCK_CTRL,
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index e9a14c0..9afbb39 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -79,10 +79,6 @@ struct ath_config {
 		       sizeof(struct ath_buf_state));		\
 	} while (0)
 
-#define ATH_RXBUF_RESET(_bf) do {		\
-		(_bf)->bf_stale = false;	\
-	} while (0)
-
 /**
  * enum buffer_type - Buffer type flags
  *
@@ -314,6 +310,7 @@ struct ath_rx {
 	struct ath_buf *rx_bufptr;
 	struct ath_rx_edma rx_edma[ATH9K_RX_QUEUE_MAX];
 
+	struct ath_buf *buf_hold;
 	struct sk_buff *frag;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 9cbbb6a..43b8aba 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -448,6 +448,7 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
 	struct ieee80211_conf *cur_conf = &priv->hw->conf;
 	bool txok;
 	int slot;
+	int hdrlen, padsize;
 
 	slot = strip_drv_header(priv, skb);
 	if (slot < 0) {
@@ -504,6 +505,15 @@ send_mac80211:
 
 	ath9k_htc_tx_clear_slot(priv, slot);
 
+	/* Remove padding before handing frame back to mac80211 */
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+
+	padsize = hdrlen & 3;
+	if (padsize && skb->len > hdrlen + padsize) {
+		memmove(skb->data + padsize, skb->data, hdrlen);
+		skb_pull(skb, padsize);
+	}
+
 	/* Send status to mac80211 */
 	ieee80211_tx_status(priv->hw, skb);
 }
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 0247fb1..ad82b4a 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -78,8 +78,6 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 	struct ath_desc *ds;
 	struct sk_buff *skb;
 
-	ATH_RXBUF_RESET(bf);
-
 	ds = bf->bf_desc;
 	ds->ds_link = 0; /* link to null */
 	ds->ds_data = bf->bf_buf_addr;
@@ -106,6 +104,14 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 	sc->rx.rxlink = &ds->ds_link;
 }
 
+static void ath_rx_buf_relink(struct ath_softc *sc, struct ath_buf *bf)
+{
+	if (sc->rx.buf_hold)
+		ath_rx_buf_link(sc, sc->rx.buf_hold);
+
+	sc->rx.buf_hold = bf;
+}
+
 static void ath_setdefantenna(struct ath_softc *sc, u32 antenna)
 {
 	/* XXX block beacon interrupts */
@@ -153,7 +159,6 @@ static bool ath_rx_edma_buf_link(struct ath_softc *sc,
 
 	skb = bf->bf_mpdu;
 
-	ATH_RXBUF_RESET(bf);
 	memset(skb->data, 0, ah->caps.rx_status_len);
 	dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
 				ah->caps.rx_status_len, DMA_TO_DEVICE);
@@ -478,6 +483,7 @@ int ath_startrecv(struct ath_softc *sc)
 	if (list_empty(&sc->rx.rxbuf))
 		goto start_recv;
 
+	sc->rx.buf_hold = NULL;
 	sc->rx.rxlink = NULL;
 	list_for_each_entry_safe(bf, tbf, &sc->rx.rxbuf, list) {
 		ath_rx_buf_link(sc, bf);
@@ -723,6 +729,9 @@ static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
 	}
 
 	bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
+	if (bf == sc->rx.buf_hold)
+		return NULL;
+
 	ds = bf->bf_desc;
 
 	/*
@@ -1972,7 +1981,7 @@ requeue:
 		if (edma) {
 			ath_rx_edma_buf_link(sc, qtype);
 		} else {
-			ath_rx_buf_link(sc, bf);
+			ath_rx_buf_relink(sc, bf);
 			ath9k_hw_rxena(ah);
 		}
 	} while (1);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 894ed0e..63ce4cf 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2479,6 +2479,7 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	for (acno = 0, ac = &an->ac[acno];
 	     acno < WME_NUM_AC; acno++, ac++) {
 		ac->sched    = false;
+		ac->clear_ps_filter = true;
 		ac->txq = sc->tx.txq_map[acno];
 		INIT_LIST_HEAD(&ac->tid_q);
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 11054ae..f76efd5 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -1013,9 +1013,10 @@ static bool dma64_rxidle(struct dma_info *di)
 
 /*
  * post receive buffers
- *  return false is refill failed completely and ring is empty this will stall
- *  the rx dma and user might want to call rxfill again asap. This unlikely
- *  happens on memory-rich NIC, but often on memory-constrained dongle
+ *  Return false if refill failed completely or dma mapping failed. The ring
+ *  is empty, which will stall the rx dma and user might want to call rxfill
+ *  again asap. This is unlikely to happen on a memory-rich NIC, but often on
+ *  memory-constrained dongle.
  */
 bool dma_rxfill(struct dma_pub *pub)
 {
@@ -1074,6 +1075,8 @@ bool dma_rxfill(struct dma_pub *pub)
 
 		pa = dma_map_single(di->dmadev, p->data, di->rxbufsize,
 				    DMA_FROM_DEVICE);
+		if (dma_mapping_error(di->dmadev, pa))
+			return false;
 
 		/* save the free packet pointer */
 		di->rxp[rxout] = p;
@@ -1294,6 +1297,9 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p, bool commit)
 
 	/* get physical address of buffer start */
 	pa = dma_map_single(di->dmadev, data, len, DMA_TO_DEVICE);
+	/* if mapping failed, free skb */
+	if (dma_mapping_error(di->dmadev, pa))
+		goto outoftxd;
 
 	/* With a DMA segment list, Descriptor table is filled
 	 * using the segment list instead of looping over
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index cbcf6f2..fde725c 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4415,9 +4415,9 @@ il4965_irq_tasklet(struct il_priv *il)
 			set_bit(S_RFKILL, &il->status);
 		} else {
 			clear_bit(S_RFKILL, &il->status);
-			wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
 			il_force_reset(il, true);
 		}
+		wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
 
 		handled |= CSR_INT_BIT_RF_KILL;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ec36e2b..8e3629a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -799,7 +799,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 					 BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
 		if (ret)
 			return ret;
-	} else {
+	} else if (priv->cfg->bt_params) {
 		/*
 		 * default is 2-wire BT coexexistence support
 		 */
diff --git a/drivers/of/base.c b/drivers/of/base.c
index d9bfd49..226beaa 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1227,6 +1227,7 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 		ap = dt_alloc(sizeof(*ap) + len + 1, 4);
 		if (!ap)
 			continue;
+		memset(ap, 0, sizeof(*ap) + len + 1);
 		ap->alias = start;
 		of_alias_add(ap, np, id, start, len);
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8e18431..68eb46e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2226,14 +2226,9 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 			}
 		}
 
-		if (modepage == 0x3F) {
-			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
-				  "present\n");
-			goto defaults;
-		} else if ((buffer[offset] & 0x3f) != modepage) {
-			sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
-			goto defaults;
-		}
+		sd_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
+		goto defaults;
+
 	Page_found:
 		if (modepage == 8) {
 			sdkp->WCE = ((buffer[offset + 2] & 0x04) != 0);
diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 736d8fa..ec85fe2 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -277,8 +277,9 @@ struct dt282x_private {
 			}					\
 			udelay(5);				\
 		}						\
-		if (_i)						\
+		if (_i) {					\
 			b					\
+		}						\
 	} while (0)
 
 static int prep_ai_dma(struct comedi_device *dev, int chan, int size);
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 2e88a68..60ffc8c 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -697,9 +697,7 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	struct zram *zram;
 
 	zram = bdev->bd_disk->private_data;
-	down_write(&zram->lock);
 	zram_free_page(zram, index);
-	up_write(&zram->lock);
 	zram_stat64_inc(zram, &zram->stats.notify_free);
 }
 
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 1047e82..fbe8ac9 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -107,9 +107,8 @@ struct zram {
 	void *compress_buffer;
 	struct table *table;
 	spinlock_t stat64_lock;	/* protect 64-bit stats */
-	struct rw_semaphore lock; /* protect compression buffers, table,
-				   * 32bit stat counters against concurrent
-				   * notifications, reads and writes */
+	struct rw_semaphore lock; /* protect compression buffers and table
+				   * against concurrent read and writes */
 	struct request_queue *queue;
 	struct gendisk *disk;
 	int init_done;
diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index dd09f0f..1756838 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -97,9 +97,12 @@ target_emulate_inquiry_std(struct se_cmd *cmd, char *buf)
 
 	buf[7] = 0x2; /* CmdQue=1 */
 
-	snprintf(&buf[8], 8, "LIO-ORG");
-	snprintf(&buf[16], 16, "%s", dev->se_sub_dev->t10_wwn.model);
-	snprintf(&buf[32], 4, "%s", dev->se_sub_dev->t10_wwn.revision);
+	memcpy(&buf[8], "LIO-ORG ", 8);
+	memset(&buf[16], 0x20, 16);
+	memcpy(&buf[16], dev->se_sub_dev->t10_wwn.model,
+	       min_t(size_t, strlen(dev->se_sub_dev->t10_wwn.model), 16));
+	memcpy(&buf[32], dev->se_sub_dev->t10_wwn.revision,
+	       min_t(size_t, strlen(dev->se_sub_dev->t10_wwn.revision), 4));
 	buf[4] = 31; /* Set additional length to 31 */
 
 	return 0;
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 97c1d8e..7c25710 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -233,6 +233,7 @@ skip_error:
 static void wdm_int_callback(struct urb *urb)
 {
 	int rv = 0;
+	int responding;
 	int status = urb->status;
 	struct wdm_device *desc;
 	struct usb_cdc_notification *dr;
@@ -286,8 +287,8 @@ static void wdm_int_callback(struct urb *urb)
 
 	spin_lock(&desc->iuspin);
 	clear_bit(WDM_READ, &desc->flags);
-	set_bit(WDM_RESPONDING, &desc->flags);
-	if (!test_bit(WDM_DISCONNECTING, &desc->flags)
+	responding = test_and_set_bit(WDM_RESPONDING, &desc->flags);
+	if (!responding && !test_bit(WDM_DISCONNECTING, &desc->flags)
 		&& !test_bit(WDM_SUSPENDING, &desc->flags)) {
 		rv = usb_submit_urb(desc->response, GFP_ATOMIC);
 		dev_dbg(&desc->intf->dev, "%s: usb_submit_urb %d",
@@ -691,16 +692,20 @@ static void wdm_rxwork(struct work_struct *work)
 {
 	struct wdm_device *desc = container_of(work, struct wdm_device, rxwork);
 	unsigned long flags;
-	int rv;
+	int rv = 0;
+	int responding;
 
 	spin_lock_irqsave(&desc->iuspin, flags);
 	if (test_bit(WDM_DISCONNECTING, &desc->flags)) {
 		spin_unlock_irqrestore(&desc->iuspin, flags);
 	} else {
+		responding = test_and_set_bit(WDM_RESPONDING, &desc->flags);
 		spin_unlock_irqrestore(&desc->iuspin, flags);
-		rv = usb_submit_urb(desc->response, GFP_KERNEL);
+		if (!responding)
+			rv = usb_submit_urb(desc->response, GFP_KERNEL);
 		if (rv < 0 && rv != -EPERM) {
 			spin_lock_irqsave(&desc->iuspin, flags);
+			clear_bit(WDM_RESPONDING, &desc->flags);
 			if (!test_bit(WDM_DISCONNECTING, &desc->flags))
 				schedule_work(&desc->rxwork);
 			spin_unlock_irqrestore(&desc->iuspin, flags);
diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index f4bdd0c..78609d3 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -424,7 +424,8 @@ static int usb_parse_configuration(struct usb_device *dev, int cfgidx,
 
 	memcpy(&config->desc, buffer, USB_DT_CONFIG_SIZE);
 	if (config->desc.bDescriptorType != USB_DT_CONFIG ||
-	    config->desc.bLength < USB_DT_CONFIG_SIZE) {
+	    config->desc.bLength < USB_DT_CONFIG_SIZE ||
+	    config->desc.bLength > size) {
 		dev_err(ddev, "invalid descriptor for config index %d: "
 		    "type = 0x%X, length = %d\n", cfgidx,
 		    config->desc.bDescriptorType, config->desc.bLength);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 8deaeb5..7be4e11 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2798,7 +2798,7 @@ int usb_port_suspend(struct usb_device *udev, pm_message_t msg)
 					status);
 			/* bail if autosuspend is requested */
 			if (PMSG_IS_AUTO(msg))
-				return status;
+				goto err_wakeup;
 		}
 	}
 
@@ -2807,9 +2807,10 @@ int usb_port_suspend(struct usb_device *udev, pm_message_t msg)
 		usb_set_usb2_hardware_lpm(udev, 0);
 
 	if (usb_unlocked_disable_lpm(udev)) {
-		dev_err(&udev->dev, "%s Failed to disable LPM before suspend\n.",
-				__func__);
-		return -ENOMEM;
+		dev_err(&udev->dev, "Failed to disable LPM before suspend\n.");
+		status = -ENOMEM;
+		if (PMSG_IS_AUTO(msg))
+			goto err_lpm3;
 	}
 
 	/* see 7.1.7.6 */
@@ -2823,27 +2824,29 @@ int usb_port_suspend(struct usb_device *udev, pm_message_t msg)
 	if (status) {
 		dev_dbg(hub->intfdev, "can't suspend port %d, status %d\n",
 				port1, status);
-		/* paranoia:  "should not happen" */
-		if (udev->do_remote_wakeup) {
-			if (!hub_is_superspeed(hub->hdev)) {
-				(void) usb_control_msg(udev,
-						usb_sndctrlpipe(udev, 0),
-						USB_REQ_CLEAR_FEATURE,
-						USB_RECIP_DEVICE,
-						USB_DEVICE_REMOTE_WAKEUP, 0,
-						NULL, 0,
-						USB_CTRL_SET_TIMEOUT);
-			} else
-				(void) usb_disable_function_remotewakeup(udev);
-
-		}
 
+		/* Try to enable USB3 LPM and LTM again */
+		usb_unlocked_enable_lpm(udev);
+ err_lpm3:
 		/* Try to enable USB2 hardware LPM again */
 		if (udev->usb2_hw_lpm_capable == 1)
 			usb_set_usb2_hardware_lpm(udev, 1);
 
-		/* Try to enable USB3 LPM again */
-		usb_unlocked_enable_lpm(udev);
+		if (udev->do_remote_wakeup) {
+			if (udev->speed < USB_SPEED_SUPER)
+				usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+						USB_REQ_CLEAR_FEATURE,
+						USB_RECIP_DEVICE,
+						USB_DEVICE_REMOTE_WAKEUP, 0,
+						NULL, 0, USB_CTRL_SET_TIMEOUT);
+			else
+				usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+						USB_REQ_CLEAR_FEATURE,
+						USB_RECIP_INTERFACE,
+						USB_INTRF_FUNC_SUSPEND, 0,
+						NULL, 0, USB_CTRL_SET_TIMEOUT);
+		}
+ err_wakeup:
 
 		/* System sleep transitions should never fail */
 		if (!PMSG_IS_AUTO(msg))
diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index c778ffe..7bce025 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -291,7 +291,7 @@ static int __exit ehci_mxc_drv_remove(struct platform_device *pdev)
 	if (pdata && pdata->exit)
 		pdata->exit(pdev);
 
-	if (pdata->otg)
+	if (pdata && pdata->otg)
 		usb_phy_shutdown(pdata->otg);
 
 	usb_remove_hcd(hcd);
diff --git a/drivers/usb/host/ohci-pci.c b/drivers/usb/host/ohci-pci.c
index 1843bb6..6847b93 100644
--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -414,7 +414,7 @@ static struct pci_driver ohci_pci_driver = {
 	.remove =	usb_hcd_pci_remove,
 	.shutdown =	usb_hcd_pci_shutdown,
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	.driver =	{
 		.pm =	&usb_hcd_pci_pm_ops
 	},
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 93ad67e..6e70ce9 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -24,7 +24,7 @@ static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
 	 * here that the generic code does not try to make a pci_dev from our
 	 * dev struct in order to setup MSI
 	 */
-	xhci->quirks |= XHCI_BROKEN_MSI;
+	xhci->quirks |= XHCI_PLAT;
 }
 
 /* called during probe() after chip reset completes */
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 585bd6c..2acae4d 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -342,9 +342,14 @@ static void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
 static int xhci_try_enable_msi(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
-	struct pci_dev  *pdev = to_pci_dev(xhci_to_hcd(xhci)->self.controller);
+	struct pci_dev  *pdev;
 	int ret;
 
+	/* The xhci platform device has set up IRQs through usb_add_hcd. */
+	if (xhci->quirks & XHCI_PLAT)
+		return 0;
+
+	pdev = to_pci_dev(xhci_to_hcd(xhci)->self.controller);
 	/*
 	 * Some Fresco Logic host controllers advertise MSI, but fail to
 	 * generate interrupts.  Don't even try to enable MSI.
@@ -3496,10 +3501,21 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	struct xhci_virt_device *virt_dev;
+	struct device *dev = hcd->self.controller;
 	unsigned long flags;
 	u32 state;
 	int i, ret;
 
+#ifndef CONFIG_USB_DEFAULT_PERSIST
+	/*
+	 * We called pm_runtime_get_noresume when the device was attached.
+	 * Decrement the counter here to allow controller to runtime suspend
+	 * if no devices remain.
+	 */
+	if (xhci->quirks & XHCI_RESET_ON_RESUME)
+		pm_runtime_put_noidle(dev);
+#endif
+
 	ret = xhci_check_args(hcd, udev, NULL, 0, true, __func__);
 	/* If the host is halted due to driver unload, we still need to free the
 	 * device.
@@ -3571,6 +3587,7 @@ static int xhci_reserve_host_control_ep_resources(struct xhci_hcd *xhci)
 int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	struct device *dev = hcd->self.controller;
 	unsigned long flags;
 	int timeleft;
 	int ret;
@@ -3623,6 +3640,16 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 		goto disable_slot;
 	}
 	udev->slot_id = xhci->slot_id;
+
+#ifndef CONFIG_USB_DEFAULT_PERSIST
+	/*
+	 * If resetting upon resume, we can't put the controller into runtime
+	 * suspend if there is a device attached.
+	 */
+	if (xhci->quirks & XHCI_RESET_ON_RESUME)
+		pm_runtime_get_noresume(dev);
+#endif
+
 	/* Is this a LS or FS device under a HS hub? */
 	/* Hub or peripherial? */
 	return 1;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 3e8bf2d..30c3a1d 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1516,6 +1516,7 @@ struct xhci_hcd {
 #define XHCI_SPURIOUS_REBOOT	(1 << 13)
 #define XHCI_COMP_MODE_QUIRK	(1 << 14)
 #define XHCI_AVOID_BEI		(1 << 15)
+#define XHCI_PLAT		(1 << 16)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 9809fbc..e1c35fb 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -379,7 +379,7 @@ static int write_parport_reg_nonblock(struct mos7715_parport *mos_parport,
 		kfree(urbtrack);
 		return -ENOMEM;
 	}
-	urbtrack->setup = kmalloc(sizeof(*urbtrack->setup), GFP_KERNEL);
+	urbtrack->setup = kmalloc(sizeof(*urbtrack->setup), GFP_ATOMIC);
 	if (!urbtrack->setup) {
 		usb_free_urb(urbtrack->urb);
 		kfree(urbtrack);
@@ -387,8 +387,8 @@ static int write_parport_reg_nonblock(struct mos7715_parport *mos_parport,
 	}
 	urbtrack->setup->bRequestType = (__u8)0x40;
 	urbtrack->setup->bRequest = (__u8)0x0e;
-	urbtrack->setup->wValue = get_reg_value(reg, dummy);
-	urbtrack->setup->wIndex = get_reg_index(reg);
+	urbtrack->setup->wValue = cpu_to_le16(get_reg_value(reg, dummy));
+	urbtrack->setup->wIndex = cpu_to_le16(get_reg_index(reg));
 	urbtrack->setup->wLength = 0;
 	usb_fill_control_urb(urbtrack->urb, usbdev,
 			     usb_sndctrlpipe(usbdev, 0),
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 025e98b..8a8cd6e 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1431,8 +1431,10 @@ void rebind_evtchn_irq(int evtchn, int irq)
 /* Rebind an evtchn so that it gets delivered to a specific cpu */
 static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 {
+	struct shared_info *s = HYPERVISOR_shared_info;
 	struct evtchn_bind_vcpu bind_vcpu;
 	int evtchn = evtchn_from_irq(irq);
+	int masked;
 
 	if (!VALID_EVTCHN(evtchn))
 		return -1;
@@ -1449,6 +1451,12 @@ static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 	bind_vcpu.vcpu = tcpu;
 
 	/*
+	 * Mask the event while changing the VCPU binding to prevent
+	 * it being delivered on an unexpected VCPU.
+	 */
+	masked = sync_test_and_set_bit(evtchn, s->evtchn_mask);
+
+	/*
 	 * If this fails, it usually just indicates that we're dealing with a
 	 * virq or IPI channel, which don't actually need to be rebound. Ignore
 	 * it, but don't do the xenlinux-level rebind in that case.
@@ -1456,6 +1464,9 @@ static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_vcpu, &bind_vcpu) >= 0)
 		bind_evtchn_to_cpu(evtchn, tcpu);
 
+	if (!masked)
+		unmask_evtchn(evtchn);
+
 	return 0;
 }
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 22be735..8a6ecc5 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -728,9 +728,18 @@ void gnttab_request_free_callback(struct gnttab_free_callback *callback,
 				  void (*fn)(void *), void *arg, u16 count)
 {
 	unsigned long flags;
+	struct gnttab_free_callback *cb;
+
 	spin_lock_irqsave(&gnttab_list_lock, flags);
-	if (callback->next)
-		goto out;
+
+	/* Check if the callback is already on the list */
+	cb = gnttab_free_callback_list;
+	while (cb) {
+		if (cb == callback)
+			goto out;
+		cb = cb->next;
+	}
+
 	callback->fn = fn;
 	callback->arg = arg;
 	callback->count = count;
diff --git a/fs/bio.c b/fs/bio.c
index 73922ab..bbd45cd 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -790,12 +790,22 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
 int bio_uncopy_user(struct bio *bio)
 {
 	struct bio_map_data *bmd = bio->bi_private;
-	int ret = 0;
+	struct bio_vec *bvec;
+	int ret = 0, i;
 
-	if (!bio_flagged(bio, BIO_NULL_MAPPED))
-		ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
-				     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
-				     0, bmd->is_our_pages);
+	if (!bio_flagged(bio, BIO_NULL_MAPPED)) {
+		/*
+		 * if we're in a workqueue, the request is orphaned, so
+		 * don't copy into a random user address space, just free.
+		 */
+		if (current->mm)
+			ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
+					     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
+					     0, bmd->is_our_pages);
+		else if (bmd->is_our_pages)
+			__bio_for_each_segment(bvec, bio, i, 0)
+				__free_page(bvec->bv_page);
+	}
 	bio_free_map_data(bmd);
 	bio_put(bio);
 	return ret;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 780385f..ce93dd5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -382,6 +382,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		try_to_freeze();
 
 		/* we should try only the port we connected to before */
+		mutex_lock(&server->srv_mutex);
 		rc = generic_ip_connect(server);
 		if (rc) {
 			cFYI(1, "reconnect error %d", rc);
@@ -393,6 +394,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 				server->tcpStatus = CifsNeedNegotiate;
 			spin_unlock(&GlobalMid_Lock);
 		}
+		mutex_unlock(&server->srv_mutex);
 	} while (server->tcpStatus == CifsNeedReconnect);
 
 	return rc;
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 6cb83b9..8ae4457 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -107,6 +107,14 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 		dput(dentry);
 	}
 
+	/*
+	 * If we know that the inode will need to be revalidated immediately,
+	 * then don't create a new dentry for it. We'll end up doing an on
+	 * the wire call either way and this spares us an invalidation.
+	 */
+	if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
+		return NULL;
+
 	dentry = d_alloc(parent, name);
 	if (dentry == NULL)
 		return NULL;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index f6e4bc8..b60cc5f 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1511,6 +1511,8 @@ static int fuse_setxattr(struct dentry *entry, const char *name,
 		fc->no_setxattr = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err)
+		fuse_invalidate_attr(inode);
 	return err;
 }
 
@@ -1640,6 +1642,8 @@ static int fuse_removexattr(struct dentry *entry, const char *name)
 		fc->no_removexattr = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err)
+		fuse_invalidate_attr(inode);
 	return err;
 }
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 514f12a..e7785e4 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1296,7 +1296,6 @@ static int fuse_writepage_locked(struct page *page)
 
 	inc_bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
 	inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
-	end_page_writeback(page);
 
 	spin_lock(&fc->lock);
 	list_add(&req->writepages_entry, &fi->writepages);
@@ -1304,6 +1303,8 @@ static int fuse_writepage_locked(struct page *page)
 	fuse_flush_writepages(inode);
 	spin_unlock(&fc->lock);
 
+	end_page_writeback(page);
+
 	return 0;
 
 err_free:
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 4dd0239..5083b75 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -782,7 +782,6 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	cpos = map_start >> osb->s_clustersize_bits;
 	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
 					       map_start + map_len);
-	mapping_end -= cpos;
 	is_last = 0;
 	while (cpos < mapping_end && !is_last) {
 		u32 fe_flags;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 449fa38..69b6e30 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -425,10 +425,12 @@ struct hid_report {
 	struct hid_device *device;			/* associated device */
 };
 
+#define HID_MAX_IDS 256
+
 struct hid_report_enum {
 	unsigned numbered;
 	struct list_head report_list;
-	struct hid_report *report_id_hash[256];
+	struct hid_report *report_id_hash[HID_MAX_IDS];
 };
 
 #define HID_REPORT_TYPES 3
diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index ba45e6b..f5a21d0 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -123,6 +123,8 @@ static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)
 #define ICMPV6_NOT_NEIGHBOUR		2
 #define ICMPV6_ADDR_UNREACH		3
 #define ICMPV6_PORT_UNREACH		4
+#define ICMPV6_POLICY_FAIL		5
+#define ICMPV6_REJECT_ROUTE		6
 
 /*
  *	Codes for Time Exceeded
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 8260ef7..e6412ee 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -260,6 +260,7 @@ struct inet6_skb_parm {
 #define IP6SKB_XFRM_TRANSFORMED	1
 #define IP6SKB_FORWARDED	2
 #define IP6SKB_REROUTED		4
+#define IP6SKB_FRAGMENTED      16
 };
 
 #define IP6CB(skb)	((struct inet6_skb_parm*)((skb)->cb))
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index e0f0fab..bbea697 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -267,8 +267,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
  */
 #define list_first_or_null_rcu(ptr, type, member) \
 	({struct list_head *__ptr = (ptr); \
-	  struct list_head __rcu *__next = list_next_rcu(__ptr); \
-	  likely(__ptr != __next) ? container_of(__next, type, member) : NULL; \
+	  struct list_head *__next = ACCESS_ONCE(__ptr->next); \
+	  likely(__ptr != __next) ? \
+		list_entry_rcu(__next, type, member) : NULL; \
 	})
 
 /**
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 49b3ac2..aed9773 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -402,7 +402,7 @@ extern int usb_hcd_pci_probe(struct pci_dev *dev,
 extern void usb_hcd_pci_remove(struct pci_dev *dev);
 extern void usb_hcd_pci_shutdown(struct pci_dev *dev);
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 extern const struct dev_pm_ops usb_hcd_pci_pm_ops;
 #endif
 #endif /* CONFIG_PCI */
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 776605f..9b08010 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -22,6 +22,7 @@
 #define _V4L2_CTRLS_H
 
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/videodev2.h>
 
 /* forward references */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7d0eb9e..613d436 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1900,6 +1900,8 @@ static void collapse_huge_page(struct mm_struct *mm,
 		goto out;
 
 	vma = find_vma(mm, address);
+	if (!vma)
+		goto out;
 	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (address < hstart || address + HPAGE_PMD_SIZE > hend)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 08bcbd8..226b63e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4298,7 +4298,13 @@ static int compare_thresholds(const void *a, const void *b)
 	const struct mem_cgroup_threshold *_a = a;
 	const struct mem_cgroup_threshold *_b = b;
 
-	return _a->threshold - _b->threshold;
+	if (_a->threshold > _b->threshold)
+		return 1;
+
+	if (_a->threshold < _b->threshold)
+		return -1;
+
+	return 0;
 }
 
 static int mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
diff --git a/mm/swap.c b/mm/swap.c
index 4e7e2ec..0c833e8 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -30,6 +30,7 @@
 #include <linux/backing-dev.h>
 #include <linux/memcontrol.h>
 #include <linux/gfp.h>
+#include <linux/hugetlb.h>
 
 #include "internal.h"
 
@@ -77,6 +78,19 @@ static void __put_compound_page(struct page *page)
 
 static void put_compound_page(struct page *page)
 {
+	/*
+	 * hugetlbfs pages cannot be split from under us.  If this is a
+	 * hugetlbfs page, check refcount on head page and release the page if
+	 * the refcount becomes zero.
+	 */
+	if (PageHuge(page)) {
+		page = compound_head(page);
+		if (put_page_testzero(page))
+			__put_compound_page(page);
+
+		return;
+	}
+
 	if (unlikely(PageTail(page))) {
 		/* __split_huge_page_refcount can run under us */
 		struct page *page_head = compound_trans_head(page);
@@ -180,38 +194,51 @@ bool __get_page_tail(struct page *page)
 	 * proper PT lock that already serializes against
 	 * split_huge_page().
 	 */
-	unsigned long flags;
 	bool got = false;
-	struct page *page_head = compound_trans_head(page);
+	struct page *page_head;
 
-	if (likely(page != page_head && get_page_unless_zero(page_head))) {
+	/*
+	 * If this is a hugetlbfs page it cannot be split under us.  Simply
+	 * increment refcount for the head page.
+	 */
+	if (PageHuge(page)) {
+		page_head = compound_head(page);
+		atomic_inc(&page_head->_count);
+		got = true;
+	} else {
+		unsigned long flags;
+
+		page_head = compound_trans_head(page);
+		if (likely(page != page_head &&
+					get_page_unless_zero(page_head))) {
+
+			/* Ref to put_compound_page() comment. */
+			if (PageSlab(page_head)) {
+				if (likely(PageTail(page))) {
+					__get_page_tail_foll(page, false);
+					return true;
+				} else {
+					put_page(page_head);
+					return false;
+				}
+			}
 
-		/* Ref to put_compound_page() comment. */
-		if (PageSlab(page_head)) {
+			/*
+			 * page_head wasn't a dangling pointer but it
+			 * may not be a head page anymore by the time
+			 * we obtain the lock. That is ok as long as it
+			 * can't be freed from under us.
+			 */
+			flags = compound_lock_irqsave(page_head);
+			/* here __split_huge_page_refcount won't run anymore */
 			if (likely(PageTail(page))) {
 				__get_page_tail_foll(page, false);
-				return true;
-			} else {
-				put_page(page_head);
-				return false;
+				got = true;
 			}
+			compound_unlock_irqrestore(page_head, flags);
+			if (unlikely(!got))
+				put_page(page_head);
 		}
-
-		/*
-		 * page_head wasn't a dangling pointer but it
-		 * may not be a head page anymore by the time
-		 * we obtain the lock. That is ok as long as it
-		 * can't be freed from under us.
-		 */
-		flags = compound_lock_irqsave(page_head);
-		/* here __split_huge_page_refcount won't run anymore */
-		if (likely(PageTail(page))) {
-			__get_page_tail_foll(page, false);
-			got = true;
-		}
-		compound_unlock_irqrestore(page_head, flags);
-		if (unlikely(!got))
-			put_page(page_head);
 	}
 	return got;
 }
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 4c1954b..e881f7f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1172,7 +1172,8 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		mld2q = (struct mld2_query *)icmp6_hdr(skb);
 		if (!mld2q->mld2q_nsrcs)
 			group = &mld2q->mld2q_mca;
-		max_delay = mld2q->mld2q_mrc ? MLDV2_MRC(mld2q->mld2q_mrc) : 1;
+
+		max_delay = max(msecs_to_jiffies(MLDV2_MRC(ntohs(mld2q->mld2q_mrc))), 1UL);
 	}
 
 	if (!group)
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index f181972..a90c575 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1745,6 +1745,8 @@ int ceph_osdc_start_request(struct ceph_osd_client *osdc,
 				dout("osdc_start_request failed map, "
 				     " will retry %lld\n", req->r_tid);
 				rc = 0;
+			} else {
+				__unregister_request(osdc, req);
 			}
 			goto out_unlock;
 		}
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index d10a72b..dfedfd8 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1064,7 +1064,7 @@ static int *calc_pg_raw(struct ceph_osdmap *osdmap, struct ceph_pg pgid,
 
 	/* pg_temp? */
 	t = ceph_stable_mod(ps, le32_to_cpu(pool->v.pg_num),
-			    pool->pgp_num_mask);
+			    pool->pg_num_mask);
 	pgid.ps = cpu_to_le16(t);
 	pg = __lookup_pg_mapping(&osdmap->pg_temp, pgid);
 	if (pg) {
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index c09f82b..38d5188 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1443,16 +1443,18 @@ struct neigh_parms *neigh_parms_alloc(struct net_device *dev,
 		atomic_set(&p->refcnt, 1);
 		p->reachable_time =
 				neigh_rand_reach_time(p->base_reachable_time);
+		dev_hold(dev);
+		p->dev = dev;
+		write_pnet(&p->net, hold_net(net));
+		p->sysctl_table = NULL;
 
 		if (ops->ndo_neigh_setup && ops->ndo_neigh_setup(dev, p)) {
+			release_net(net);
+			dev_put(dev);
 			kfree(p);
 			return NULL;
 		}
 
-		dev_hold(dev);
-		p->dev = dev;
-		write_pnet(&p->net, hold_net(net));
-		p->sysctl_table = NULL;
 		write_lock_bh(&tbl->lock);
 		p->next		= tbl->parms.next;
 		tbl->parms.next = p;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index a7c3684..df0dafe 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -20,6 +20,9 @@
 #include <net/sock.h>
 #include <net/net_ratelimit.h>
 
+static int zero = 0;
+static int ushort_max = USHRT_MAX;
+
 #ifdef CONFIG_RPS
 static int rps_sock_flow_sysctl(ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -198,7 +201,9 @@ static struct ctl_table netns_core_table[] = {
 		.data		= &init_net.core.sysctl_somaxconn,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.extra1		= &zero,
+		.extra2		= &ushort_max,
+		.proc_handler	= proc_dointvec_minmax
 	},
 	{ }
 };
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 30b88d7..424704a 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -71,7 +71,6 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-#include <linux/prefetch.h>
 #include <linux/export.h>
 #include <net/net_namespace.h>
 #include <net/ip.h>
@@ -1772,10 +1771,8 @@ static struct leaf *leaf_walk_rcu(struct tnode *p, struct rt_trie_node *c)
 			if (!c)
 				continue;
 
-			if (IS_LEAF(c)) {
-				prefetch(rcu_dereference_rtnl(p->child[idx]));
+			if (IS_LEAF(c))
 				return (struct leaf *) c;
-			}
 
 			/* Rescan start scanning in new node */
 			p = (struct tnode *) c;
diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index a9077f4..b6ae92a 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -206,8 +206,8 @@ static u32 cubic_root(u64 a)
  */
 static inline void bictcp_update(struct bictcp *ca, u32 cwnd)
 {
-	u64 offs;
-	u32 delta, t, bic_target, max_cnt;
+	u32 delta, bic_target, max_cnt;
+	u64 offs, t;
 
 	ca->ack_cnt++;	/* count the number of ACKs */
 
@@ -250,9 +250,11 @@ static inline void bictcp_update(struct bictcp *ca, u32 cwnd)
 	 * if the cwnd < 1 million packets !!!
 	 */
 
+	t = (s32)(tcp_time_stamp - ca->epoch_start);
+	t += msecs_to_jiffies(ca->delay_min >> 3);
 	/* change the unit from HZ to bictcp_HZ */
-	t = ((tcp_time_stamp + msecs_to_jiffies(ca->delay_min>>3)
-	      - ca->epoch_start) << BICTCP_HZ) / HZ;
+	t <<= BICTCP_HZ;
+	do_div(t, HZ);
 
 	if (t < ca->bic_K)		/* t - K */
 		offs = ca->bic_K - t;
@@ -414,7 +416,7 @@ static void bictcp_acked(struct sock *sk, u32 cnt, s32 rtt_us)
 		return;
 
 	/* Discard delay samples right after fast recovery */
-	if ((s32)(tcp_time_stamp - ca->epoch_start) < HZ)
+	if (ca->epoch_start && (s32)(tcp_time_stamp - ca->epoch_start) < HZ)
 		return;
 
 	delay = (rtt_us << 3) / USEC_PER_MSEC;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 5e23f99..f4d2364 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -909,12 +909,10 @@ retry:
 	if (ifp->flags & IFA_F_OPTIMISTIC)
 		addr_flags |= IFA_F_OPTIMISTIC;
 
-	ift = !max_addresses ||
-	      ipv6_count_addresses(idev) < max_addresses ?
-		ipv6_add_addr(idev, &addr, tmp_plen,
-			      ipv6_addr_type(&addr)&IPV6_ADDR_SCOPE_MASK,
-			      addr_flags) : NULL;
-	if (!ift || IS_ERR(ift)) {
+	ift = ipv6_add_addr(idev, &addr, tmp_plen,
+			    ipv6_addr_type(&addr)&IPV6_ADDR_SCOPE_MASK,
+			    addr_flags);
+	if (IS_ERR(ift)) {
 		in6_ifa_put(ifp);
 		in6_dev_put(idev);
 		pr_info("%s: retry temporary address regeneration\n", __func__);
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 091a297..2da16f0 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -917,6 +917,14 @@ static const struct icmp6_err {
 		.err	= ECONNREFUSED,
 		.fatal	= 1,
 	},
+	{	/* POLICY_FAIL */
+		.err	= EACCES,
+		.fatal	= 1,
+	},
+	{	/* REJECT_ROUTE	*/
+		.err	= EACCES,
+		.fatal	= 1,
+	},
 };
 
 int icmpv6_err_convert(u8 type, u8 code, int *err)
@@ -928,7 +936,7 @@ int icmpv6_err_convert(u8 type, u8 code, int *err)
 	switch (type) {
 	case ICMPV6_DEST_UNREACH:
 		fatal = 1;
-		if (code <= ICMPV6_PORT_UNREACH) {
+		if (code < ARRAY_SIZE(tab_unreach)) {
 			*err  = tab_unreach[code].err;
 			fatal = tab_unreach[code].fatal;
 		}
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 0907191..3c30320 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -949,14 +949,22 @@ static struct fib6_node * fib6_lookup_1(struct fib6_node *root,
 
 			if (ipv6_prefix_equal(&key->addr, args->addr, key->plen)) {
 #ifdef CONFIG_IPV6_SUBTREES
-				if (fn->subtree)
-					fn = fib6_lookup_1(fn->subtree, args + 1);
+				if (fn->subtree) {
+					struct fib6_node *sfn;
+					sfn = fib6_lookup_1(fn->subtree,
+							    args + 1);
+					if (!sfn)
+						goto backtrack;
+					fn = sfn;
+				}
 #endif
-				if (!fn || fn->fn_flags & RTN_RTINFO)
+				if (fn->fn_flags & RTN_RTINFO)
 					return fn;
 			}
 		}
-
+#ifdef CONFIG_IPV6_SUBTREES
+backtrack:
+#endif
 		if (fn->fn_flags & RTN_ROOT)
 			break;
 
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 35bfebc..fbe0f9f 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -429,7 +429,6 @@ struct sk_buff *ndisc_build_skb(struct net_device *dev,
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
 	int len;
-	int err;
 	u8 *opt;
 
 	if (!dev->addr_len)
@@ -439,13 +438,11 @@ struct sk_buff *ndisc_build_skb(struct net_device *dev,
 	if (llinfo)
 		len += ndisc_opt_addr_space(dev);
 
-	skb = sock_alloc_send_skb(sk,
-				  (MAX_HEADER + sizeof(struct ipv6hdr) +
-				   len + hlen + tlen),
-				  1, &err);
+	skb = alloc_skb((MAX_HEADER + sizeof(struct ipv6hdr) +
+			 len + hlen + tlen), GFP_ATOMIC);
 	if (!skb) {
-		ND_PRINTK(0, err, "ND: %s failed to allocate an skb, err=%d\n",
-			  __func__, err);
+		ND_PRINTK(0, err, "ND: %s failed to allocate an skb\n",
+			  __func__);
 		return NULL;
 	}
 
@@ -473,6 +470,11 @@ struct sk_buff *ndisc_build_skb(struct net_device *dev,
 					   csum_partial(hdr,
 							len, 0));
 
+	/* Manually assign socket ownership as we avoid calling
+	 * sock_alloc_send_pskb() to bypass wmem buffer limits
+	 */
+	skb_set_owner_w(skb, sk);
+
 	return skb;
 }
 
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 3673b8f..4da218c 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -531,6 +531,7 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *prev,
 	head->tstamp = fq->q.stamp;
 	ipv6_hdr(head)->payload_len = htons(payload_len);
 	IP6CB(head)->nhoff = nhoff;
+	IP6CB(head)->flags |= IP6SKB_FRAGMENTED;
 
 	/* Yes, and fold redundant checksum back. 8) */
 	if (head->ip_summed == CHECKSUM_COMPLETE)
@@ -564,6 +565,9 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	const struct ipv6hdr *hdr = ipv6_hdr(skb);
 	struct net *net = dev_net(skb_dst(skb)->dev);
 
+	if (IP6CB(skb)->flags & IP6SKB_FRAGMENTED)
+		goto fail_hdr;
+
 	IP6_INC_STATS_BH(net, ip6_dst_idev(skb_dst(skb)), IPSTATS_MIB_REASMREQDS);
 
 	/* Jumbo payload inhibits frag. header */
@@ -584,6 +588,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 				 ip6_dst_idev(skb_dst(skb)), IPSTATS_MIB_REASMOKS);
 
 		IP6CB(skb)->nhoff = (u8 *)fhdr - skb_network_header(skb);
+		IP6CB(skb)->flags |= IP6SKB_FRAGMENTED;
 		return 1;
 	}
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 989c024..1467fc7 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1573,7 +1573,7 @@ ipv6_pktoptions:
 		if (np->rxopt.bits.rxhlim || np->rxopt.bits.rxohlim)
 			np->mcast_hops = ipv6_hdr(opt_skb)->hop_limit;
 		if (np->rxopt.bits.rxtclass)
-			np->rcv_tclass = ipv6_tclass(ipv6_hdr(skb));
+			np->rcv_tclass = ipv6_tclass(ipv6_hdr(opt_skb));
 		if (ipv6_opt_accepted(sk, opt_skb)) {
 			skb_set_owner_r(opt_skb, sk);
 			opt_skb = xchg(&np->pktoptions, opt_skb);
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index e9ea2f3..6f15bd1 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -86,7 +86,7 @@ struct htb_class {
 	unsigned int children;
 	struct htb_class *parent;	/* parent class */
 
-	int prio;		/* these two are used only by leaves... */
+	u32 prio;		/* these two are used only by leaves... */
 	int quantum;		/* but stored for parent-to-leaf return */
 
 	union {
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index fddcccf..78ad0f6 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -233,10 +233,13 @@ _shift_data_right_pages(struct page **pages, size_t pgto_base,
 		pgfrom_base -= copy;
 
 		vto = kmap_atomic(*pgto);
-		vfrom = kmap_atomic(*pgfrom);
-		memmove(vto + pgto_base, vfrom + pgfrom_base, copy);
+		if (*pgto != *pgfrom) {
+			vfrom = kmap_atomic(*pgfrom);
+			memcpy(vto + pgto_base, vfrom + pgfrom_base, copy);
+			kunmap_atomic(vfrom);
+		} else
+			memmove(vto + pgto_base, vto + pgfrom_base, copy);
 		flush_dcache_page(*pgto);
-		kunmap_atomic(vfrom);
 		kunmap_atomic(vto);
 
 	} while ((len -= copy) != 0);
diff --git a/net/tipc/eth_media.c b/net/tipc/eth_media.c
index 90ac9bf..f2e04b4 100644
--- a/net/tipc/eth_media.c
+++ b/net/tipc/eth_media.c
@@ -46,12 +46,14 @@
  * @bearer: ptr to associated "generic" bearer structure
  * @dev: ptr to associated Ethernet network device
  * @tipc_packet_type: used in binding TIPC to Ethernet driver
+ * @setup: work item used when enabling bearer
  * @cleanup: work item used when disabling bearer
  */
 struct eth_bearer {
 	struct tipc_bearer *bearer;
 	struct net_device *dev;
 	struct packet_type tipc_packet_type;
+	struct work_struct setup;
 	struct work_struct cleanup;
 };
 
@@ -134,6 +136,17 @@ static int recv_msg(struct sk_buff *buf, struct net_device *dev,
 }
 
 /**
+ * setup_bearer - setup association between Ethernet bearer and interface
+ */
+static void setup_bearer(struct work_struct *work)
+{
+	struct eth_bearer *eb_ptr =
+		container_of(work, struct eth_bearer, setup);
+
+	dev_add_pack(&eb_ptr->tipc_packet_type);
+}
+
+/**
  * enable_bearer - attach TIPC bearer to an Ethernet interface
  */
 static int enable_bearer(struct tipc_bearer *tb_ptr)
@@ -173,7 +186,8 @@ static int enable_bearer(struct tipc_bearer *tb_ptr)
 	eb_ptr->tipc_packet_type.func = recv_msg;
 	eb_ptr->tipc_packet_type.af_packet_priv = eb_ptr;
 	INIT_LIST_HEAD(&(eb_ptr->tipc_packet_type.list));
-	dev_add_pack(&eb_ptr->tipc_packet_type);
+	INIT_WORK(&eb_ptr->setup, setup_bearer);
+	schedule_work(&eb_ptr->setup);
 
 	/* Associate TIPC bearer with Ethernet bearer */
 	eb_ptr->bearer = tb_ptr;
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 9b0c0b8..55ab5e4 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2045,6 +2045,9 @@ sub process_file($) {
 
     $section_counter = 0;
     while (<IN>) {
+	while (s/\\\s*$//) {
+	    $_ .= <IN>;
+	}
 	if ($state == 0) {
 	    if (/$doc_start/o) {
 		$state = 1;		# next line is always the function name
diff --git a/sound/i2c/other/ak4xxx-adda.c b/sound/i2c/other/ak4xxx-adda.c
index cef813d..ed726d1 100644
--- a/sound/i2c/other/ak4xxx-adda.c
+++ b/sound/i2c/other/ak4xxx-adda.c
@@ -571,7 +571,7 @@ static int ak4xxx_capture_source_info(struct snd_kcontrol *kcontrol,
 	struct snd_akm4xxx *ak = snd_kcontrol_chip(kcontrol);
 	int mixer_ch = AK_GET_SHIFT(kcontrol->private_value);
 	const char **input_names;
-	int  num_names, idx;
+	unsigned int num_names, idx;
 
 	num_names = ak4xxx_capture_num_inputs(ak, mixer_ch);
 	if (!num_names)
diff --git a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
index d7ccf28..4589acd 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -173,11 +173,7 @@ MODULE_DEVICE_TABLE(pnp_card, snd_opti9xx_pnpids);
 
 #endif	/* CONFIG_PNP */
 
-#ifdef OPTi93X
-#define DEV_NAME "opti93x"
-#else
-#define DEV_NAME "opti92x"
-#endif
+#define DEV_NAME KBUILD_MODNAME
 
 static char * snd_opti9xx_names[] = {
 	"unknown",
@@ -1126,7 +1122,7 @@ static void __devexit snd_opti9xx_pnp_remove(struct pnp_card_link * pcard)
 
 static struct pnp_card_driver opti9xx_pnpc_driver = {
 	.flags		= PNP_DRIVER_RES_DISABLE,
-	.name		= "opti9xx",
+	.name		= DEV_NAME,
 	.id_table	= snd_opti9xx_pnpids,
 	.probe		= snd_opti9xx_pnp_probe,
 	.remove		= __devexit_p(snd_opti9xx_pnp_remove),
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index d086bbf..c4b29d4 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2812,6 +2812,7 @@ static struct snd_pci_quirk msi_black_list[] __devinitdata = {
 	SND_PCI_QUIRK(0x1043, 0x81f2, "ASUS", 0), /* Athlon64 X2 + nvidia */
 	SND_PCI_QUIRK(0x1043, 0x81f6, "ASUS", 0), /* nvidia */
 	SND_PCI_QUIRK(0x1043, 0x822d, "ASUS", 0), /* Athlon64 X2 + nvidia MCP55 */
+	SND_PCI_QUIRK(0x1179, 0xfb44, "Toshiba Satellite C870", 0), /* AMD Hudson */
 	SND_PCI_QUIRK(0x1849, 0x0888, "ASRock", 0), /* Athlon64 X2 + nvidia */
 	SND_PCI_QUIRK(0xa0a0, 0x0575, "Aopen MZ915-M", 0), /* ICH6 */
 	{}
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 375e0ff..c3cd1f8 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -513,6 +513,17 @@ static int hdmi_channel_allocation(struct hdmi_eld *eld, int channels)
 		}
 	}
 
+	if (!ca) {
+		/* if there was no match, select the regular ALSA channel
+		 * allocation with the matching number of channels */
+		for (i = 0; i < ARRAY_SIZE(channel_allocations); i++) {
+			if (channels == channel_allocations[i].channels) {
+				ca = channel_allocations[i].ca_index;
+				break;
+			}
+		}
+	}
+
 	snd_print_channel_allocation(eld->spk_alloc, buf, sizeof(buf));
 	snd_printdd("HDMI: select CA 0x%x for %d-channel allocation: %s\n",
 		    ca, channels, buf);
diff --git a/sound/soc/codecs/mc13783.c b/sound/soc/codecs/mc13783.c
index 6276e35..3086194 100644
--- a/sound/soc/codecs/mc13783.c
+++ b/sound/soc/codecs/mc13783.c
@@ -126,6 +126,10 @@ static int mc13783_write(struct snd_soc_codec *codec,
 
 	ret = mc13xxx_reg_write(priv->mc13xxx, reg, value);
 
+	/* include errata fix for spi audio problems */
+	if (reg == MC13783_AUDIO_CODEC || reg == MC13783_AUDIO_DAC)
+		ret = mc13xxx_reg_write(priv->mc13xxx, reg, value);
+
 	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 8bc659d..f27448b 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -789,9 +789,9 @@ static int wm8960_set_dai_pll(struct snd_soc_dai *codec_dai, int pll_id,
 	if (pll_div.k) {
 		reg |= 0x20;
 
-		snd_soc_write(codec, WM8960_PLL2, (pll_div.k >> 18) & 0x3f);
-		snd_soc_write(codec, WM8960_PLL3, (pll_div.k >> 9) & 0x1ff);
-		snd_soc_write(codec, WM8960_PLL4, pll_div.k & 0x1ff);
+		snd_soc_write(codec, WM8960_PLL2, (pll_div.k >> 16) & 0xff);
+		snd_soc_write(codec, WM8960_PLL3, (pll_div.k >> 8) & 0xff);
+		snd_soc_write(codec, WM8960_PLL4, pll_div.k & 0xff);
 	}
 	snd_soc_write(codec, WM8960_PLL1, reg);
 
