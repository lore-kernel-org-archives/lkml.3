Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3FGLWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:22:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39689 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab3FGLW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:22:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.14
Date: Fri,  7 Jun 2013 12:22:18 +0100
Message-Id: <1370604138-16414-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370604138-16414-1-git-send-email-luis.henriques@canonical.com>
References: <1370604138-16414-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index cfc5c91..b57a3c0f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .13
+EXTRAVERSION = .14
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/mach-kirkwood/ts219-setup.c b/arch/arm/mach-kirkwood/ts219-setup.c
index 73e2b6c..3a73fc7 100644
--- a/arch/arm/mach-kirkwood/ts219-setup.c
+++ b/arch/arm/mach-kirkwood/ts219-setup.c
@@ -124,7 +124,7 @@ static void __init qnap_ts219_init(void)
 static int __init ts219_pci_init(void)
 {
 	if (machine_is_ts219())
-		kirkwood_pcie_init(KW_PCIE0);
+		kirkwood_pcie_init(KW_PCIE1 | KW_PCIE0);
 
 	return 0;
 }
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index c179378..895cdaf 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -368,7 +368,7 @@ static struct resource orion_ge10_shared_resources[] = {
 
 static struct platform_device orion_ge10_shared = {
 	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 1,
+	.id		= 2,
 	.dev		= {
 		.platform_data	= &orion_ge10_shared_data,
 	},
@@ -383,8 +383,8 @@ static struct resource orion_ge10_resources[] = {
 
 static struct platform_device orion_ge10 = {
 	.name		= MV643XX_ETH_NAME,
-	.id		= 1,
-	.num_resources	= 2,
+	.id		= 2,
+	.num_resources	= 1,
 	.resource	= orion_ge10_resources,
 	.dev		= {
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
@@ -420,7 +420,7 @@ static struct resource orion_ge11_shared_resources[] = {
 
 static struct platform_device orion_ge11_shared = {
 	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 1,
+	.id		= 3,
 	.dev		= {
 		.platform_data	= &orion_ge11_shared_data,
 	},
@@ -435,8 +435,8 @@ static struct resource orion_ge11_resources[] = {
 
 static struct platform_device orion_ge11 = {
 	.name		= MV643XX_ETH_NAME,
-	.id		= 1,
-	.num_resources	= 2,
+	.id		= 3,
+	.num_resources	= 1,
 	.resource	= orion_ge11_resources,
 	.dev		= {
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
diff --git a/arch/avr32/kernel/module.c b/arch/avr32/kernel/module.c
index 596f730..2c94129 100644
--- a/arch/avr32/kernel/module.c
+++ b/arch/avr32/kernel/module.c
@@ -264,7 +264,7 @@ int apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
 			break;
 		case R_AVR32_GOT18SW:
 			if ((relocation & 0xfffe0003) != 0
-			    && (relocation & 0xfffc0003) != 0xffff0000)
+			    && (relocation & 0xfffc0000) != 0xfffc0000)
 				return reloc_overflow(module, "R_AVR32_GOT18SW",
 						     relocation);
 			relocation >>= 2;
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 45d8097..1440887 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -132,6 +132,49 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
 	return AE_OK;
 }
 
+/* Force to use vendor driver when the ACPI device is known to be
+ * buggy */
+static int video_detect_force_vendor(const struct dmi_system_id *d)
+{
+	acpi_video_support |= ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
+	return 0;
+}
+
+static struct dmi_system_id video_detect_dmi_table[] = {
+	/* On Samsung X360, the BIOS will set a flag (VDRV) if generic
+	 * ACPI backlight device is used. This flag will definitively break
+	 * the backlight interface (even the vendor interface) untill next
+	 * reboot. It's why we should prevent video.ko from being used here
+	 * and we can't rely on a later call to acpi_video_unregister().
+	 */
+	{
+	 .callback = video_detect_force_vendor,
+	 .ident = "X360",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "X360"),
+		DMI_MATCH(DMI_BOARD_NAME, "X360"),
+		},
+	},
+	{
+	.callback = video_detect_force_vendor,
+	.ident = "Asus UL30VT",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "UL30VT"),
+		},
+	},
+	{
+	.callback = video_detect_force_vendor,
+	.ident = "Asus UL30A",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "UL30A"),
+		},
+	},
+	{ },
+};
+
 /*
  * Returns the video capabilities of a specific ACPI graphics device
  *
@@ -164,6 +207,8 @@ long acpi_video_get_capabilities(acpi_handle graphics_handle)
 		 *		ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
 		 *}
 		 */
+
+		dmi_check_system(video_detect_dmi_table);
 	} else {
 		status = acpi_bus_get_device(graphics_handle, &tmp_dev);
 		if (ACPI_FAILURE(status)) {
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 531ceb3..4e8213a 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -117,13 +117,13 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 
 	spin_lock(&brd->brd_lock);
 	idx = sector >> PAGE_SECTORS_SHIFT;
+	page->index = idx;
 	if (radix_tree_insert(&brd->brd_pages, idx, page)) {
 		__free_page(page);
 		page = radix_tree_lookup(&brd->brd_pages, idx);
 		BUG_ON(!page);
 		BUG_ON(page->index != idx);
-	} else
-		page->index = idx;
+	}
 	spin_unlock(&brd->brd_lock);
 
 	radix_tree_preload_end();
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 91abbc4..395d2e8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -868,16 +868,24 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 	if (r->entropy_count / 8 < min + reserved) {
 		nbytes = 0;
 	} else {
+		int entropy_count, orig;
+retry:
+		entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 		/* If limited, never pull more than available */
-		if (r->limit && nbytes + reserved >= r->entropy_count / 8)
-			nbytes = r->entropy_count/8 - reserved;
-
-		if (r->entropy_count / 8 >= nbytes + reserved)
-			r->entropy_count -= nbytes*8;
-		else
-			r->entropy_count = reserved;
+		if (r->limit && nbytes + reserved >= entropy_count / 8)
+			nbytes = entropy_count/8 - reserved;
+
+		if (entropy_count / 8 >= nbytes + reserved) {
+			entropy_count -= nbytes*8;
+			if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+				goto retry;
+		} else {
+			entropy_count = reserved;
+			if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+				goto retry;
+		}
 
-		if (r->entropy_count < random_write_wakeup_thresh)
+		if (entropy_count < random_write_wakeup_thresh)
 			wakeup_write = 1;
 	}
 
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index dd708a3..d18b343 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2176,8 +2176,8 @@ int evergreen_mc_init(struct radeon_device *rdev)
 		rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE);
 	} else {
 		/* size in MB on evergreen/cayman/tn */
-		rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024 * 1024;
-		rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024 * 1024;
+		rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
+		rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
 	}
 	rdev->mc.visible_vram_size = rdev->mc.aper_size;
 	r700_vram_gtt_location(rdev, &rdev->mc);
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 00ff10e..d14044e 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -364,18 +364,17 @@ bool radeon_card_posted(struct radeon_device *rdev)
 		return false;
 
 	/* first check CRTCs */
-	if (ASIC_IS_DCE41(rdev)) {
+	if (ASIC_IS_DCE4(rdev)) {
 		reg = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET) |
 			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET);
-		if (reg & EVERGREEN_CRTC_MASTER_EN)
-			return true;
-	} else if (ASIC_IS_DCE4(rdev)) {
-		reg = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET);
+			if (rdev->num_crtc >= 4) {
+				reg |= RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET) |
+					RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET);
+			}
+			if (rdev->num_crtc >= 6) {
+				reg |= RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET) |
+					RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET);
+			}
 		if (reg & EVERGREEN_CRTC_MASTER_EN)
 			return true;
 	} else if (ASIC_IS_AVIVO(rdev)) {
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index c94a225..7296b56 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -753,7 +753,7 @@ int radeon_ttm_init(struct radeon_device *rdev)
 		return r;
 	}
 	DRM_INFO("radeon: %uM of VRAM memory ready\n",
-		 (unsigned)rdev->mc.real_vram_size / (1024 * 1024));
+		 (unsigned) (rdev->mc.real_vram_size / (1024 * 1024)));
 	r = ttm_bo_init_mm(&rdev->mman.bdev, TTM_PL_TT,
 				rdev->mc.gtt_size >> PAGE_SHIFT);
 	if (r) {
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index c43a544..df76c27 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1556,7 +1556,7 @@ static void si_gpu_init(struct radeon_device *rdev)
 	default:
 		rdev->config.si.max_shader_engines = 1;
 		rdev->config.si.max_tile_pipes = 4;
-		rdev->config.si.max_cu_per_sh = 2;
+		rdev->config.si.max_cu_per_sh = 5;
 		rdev->config.si.max_sh_per_se = 2;
 		rdev->config.si.max_backends_per_se = 4;
 		rdev->config.si.max_texture_channel_caches = 4;
@@ -2310,8 +2310,8 @@ static int si_mc_init(struct radeon_device *rdev)
 	rdev->mc.aper_base = pci_resource_start(rdev->pdev, 0);
 	rdev->mc.aper_size = pci_resource_len(rdev->pdev, 0);
 	/* size in MB on si */
-	rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024 * 1024;
-	rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024 * 1024;
+	rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
+	rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
 	rdev->mc.visible_vram_size = rdev->mc.aper_size;
 	si_vram_gtt_location(rdev, &rdev->mc);
 	radeon_update_bandwidth_info(rdev);
diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
index a72bf25..56b178a 100644
--- a/drivers/hwmon/abituguru.c
+++ b/drivers/hwmon/abituguru.c
@@ -1410,14 +1410,18 @@ static int __devinit abituguru_probe(struct platform_device *pdev)
 	pr_info("found Abit uGuru\n");
 
 	/* Register sysfs hooks */
-	for (i = 0; i < sysfs_attr_i; i++)
-		if (device_create_file(&pdev->dev,
-				&data->sysfs_attr[i].dev_attr))
+	for (i = 0; i < sysfs_attr_i; i++) {
+		res = device_create_file(&pdev->dev,
+					 &data->sysfs_attr[i].dev_attr);
+		if (res)
 			goto abituguru_probe_error;
-	for (i = 0; i < ARRAY_SIZE(abituguru_sysfs_attr); i++)
-		if (device_create_file(&pdev->dev,
-				&abituguru_sysfs_attr[i].dev_attr))
+	}
+	for (i = 0; i < ARRAY_SIZE(abituguru_sysfs_attr); i++) {
+		res = device_create_file(&pdev->dev,
+					 &abituguru_sysfs_attr[i].dev_attr);
+		if (res)
 			goto abituguru_probe_error;
+	}
 
 	data->hwmon_dev = hwmon_device_register(&pdev->dev);
 	if (!IS_ERR(data->hwmon_dev))
diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 7b8ebbe..534fc13 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -360,7 +360,8 @@ static void i2c_dw_xfer_init(struct dw_i2c_dev *dev)
 	/* Enable the adapter */
 	dw_writel(dev, 1, DW_IC_ENABLE);
 
-	/* Enable interrupts */
+	/* Clear and enable interrupts */
+	i2c_dw_clear_int(dev);
 	dw_writel(dev, DW_IC_INTR_DEFAULT_MASK, DW_IC_INTR_MASK);
 }
 
@@ -413,8 +414,14 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 
 		while (buf_len > 0 && tx_limit > 0 && rx_limit > 0) {
 			if (msgs[dev->msg_write_idx].flags & I2C_M_RD) {
+
+				/* avoid rx buffer overrun */
+				if (rx_limit - dev->rx_outstanding <= 0)
+					break;
+
 				dw_writel(dev, 0x100, DW_IC_DATA_CMD);
 				rx_limit--;
+				dev->rx_outstanding++;
 			} else
 				dw_writel(dev, *buf++, DW_IC_DATA_CMD);
 			tx_limit--; buf_len--;
@@ -467,8 +474,10 @@ i2c_dw_read(struct dw_i2c_dev *dev)
 
 		rx_valid = dw_readl(dev, DW_IC_RXFLR);
 
-		for (; len > 0 && rx_valid > 0; len--, rx_valid--)
+		for (; len > 0 && rx_valid > 0; len--, rx_valid--) {
 			*buf++ = dw_readl(dev, DW_IC_DATA_CMD);
+			dev->rx_outstanding--;
+		}
 
 		if (len > 0) {
 			dev->status |= STATUS_READ_IN_PROGRESS;
@@ -526,6 +535,7 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	dev->msg_err = 0;
 	dev->status = STATUS_IDLE;
 	dev->abort_source = 0;
+	dev->rx_outstanding = 0;
 
 	ret = i2c_dw_wait_bus_not_busy(dev);
 	if (ret < 0)
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 9c1840e..e761ad1 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -60,6 +60,7 @@
  * @adapter: i2c subsystem adapter node
  * @tx_fifo_depth: depth of the hardware tx fifo
  * @rx_fifo_depth: depth of the hardware rx fifo
+ * @rx_outstanding: current master-rx elements in tx fifo
  */
 struct dw_i2c_dev {
 	struct device		*dev;
@@ -88,6 +89,7 @@ struct dw_i2c_dev {
 	u32			master_cfg;
 	unsigned int		tx_fifo_depth;
 	unsigned int		rx_fifo_depth;
+	int			rx_outstanding;
 };
 
 #define ACCESS_SWAP		0x00000001
diff --git a/drivers/input/touchscreen/egalax_ts.c b/drivers/input/touchscreen/egalax_ts.c
index 70524dd..be2a271 100644
--- a/drivers/input/touchscreen/egalax_ts.c
+++ b/drivers/input/touchscreen/egalax_ts.c
@@ -203,7 +203,7 @@ static int __devinit egalax_ts_probe(struct i2c_client *client,
 	input_set_abs_params(input_dev,
 			     ABS_MT_POSITION_X, 0, EGALAX_MAX_X, 0, 0);
 	input_set_abs_params(input_dev,
-			     ABS_MT_POSITION_X, 0, EGALAX_MAX_Y, 0, 0);
+			     ABS_MT_POSITION_Y, 0, EGALAX_MAX_Y, 0, 0);
 	input_mt_init_slots(input_dev, MAX_SUPPORT_POINTS);
 
 	input_set_drvdata(input_dev, ts);
diff --git a/drivers/leds/leds-ot200.c b/drivers/leds/leds-ot200.c
index c464682..676e729 100644
--- a/drivers/leds/leds-ot200.c
+++ b/drivers/leds/leds-ot200.c
@@ -47,37 +47,37 @@ static struct ot200_led leds[] = {
 	{
 		.name = "led_1",
 		.port = 0x49,
-		.mask = BIT(7),
+		.mask = BIT(6),
 	},
 	{
 		.name = "led_2",
 		.port = 0x49,
-		.mask = BIT(6),
+		.mask = BIT(5),
 	},
 	{
 		.name = "led_3",
 		.port = 0x49,
-		.mask = BIT(5),
+		.mask = BIT(4),
 	},
 	{
 		.name = "led_4",
 		.port = 0x49,
-		.mask = BIT(4),
+		.mask = BIT(3),
 	},
 	{
 		.name = "led_5",
 		.port = 0x49,
-		.mask = BIT(3),
+		.mask = BIT(2),
 	},
 	{
 		.name = "led_6",
 		.port = 0x49,
-		.mask = BIT(2),
+		.mask = BIT(1),
 	},
 	{
 		.name = "led_7",
 		.port = 0x49,
-		.mask = BIT(1),
+		.mask = BIT(0),
 	}
 };
 
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index c0fc827..e9097af 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -321,6 +321,9 @@ static void __cache_size_refresh(void)
 static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
 			       enum data_mode *data_mode)
 {
+	unsigned noio_flag;
+	void *ptr;
+
 	if (c->block_size <= DM_BUFIO_BLOCK_SIZE_SLAB_LIMIT) {
 		*data_mode = DATA_MODE_SLAB;
 		return kmem_cache_alloc(DM_BUFIO_CACHE(c), gfp_mask);
@@ -334,7 +337,28 @@ static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
 	}
 
 	*data_mode = DATA_MODE_VMALLOC;
-	return __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
+
+	/*
+	 * __vmalloc allocates the data pages and auxiliary structures with
+	 * gfp_flags that were specified, but pagetables are always allocated
+	 * with GFP_KERNEL, no matter what was specified as gfp_mask.
+	 *
+	 * Consequently, we must set per-process flag PF_MEMALLOC_NOIO so that
+	 * all allocations done by this process (including pagetables) are done
+	 * as if GFP_NOIO was specified.
+	 */
+
+	if (gfp_mask & __GFP_NORETRY) {
+		noio_flag = current->flags & PF_MEMALLOC;
+		current->flags |= PF_MEMALLOC;
+	}
+
+	ptr = __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
+
+	if (gfp_mask & __GFP_NORETRY)
+		current->flags = (current->flags & ~PF_MEMALLOC) | noio_flag;
+
+	return ptr;
 }
 
 /*
diff --git a/drivers/media/dvb/mantis/mantis_dvb.c b/drivers/media/dvb/mantis/mantis_dvb.c
index e5180e4..5d15c6b 100644
--- a/drivers/media/dvb/mantis/mantis_dvb.c
+++ b/drivers/media/dvb/mantis/mantis_dvb.c
@@ -248,8 +248,10 @@ int __devinit mantis_dvb_init(struct mantis_pci *mantis)
 err5:
 	tasklet_kill(&mantis->tasklet);
 	dvb_net_release(&mantis->dvbnet);
-	dvb_unregister_frontend(mantis->fe);
-	dvb_frontend_detach(mantis->fe);
+	if (mantis->fe) {
+		dvb_unregister_frontend(mantis->fe);
+		dvb_frontend_detach(mantis->fe);
+	}
 err4:
 	mantis->demux.dmx.remove_frontend(&mantis->demux.dmx, &mantis->fe_mem);
 
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index c2450f4..99d4d07 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -2737,6 +2737,31 @@ static int tg3_5700_link_polarity(struct tg3 *tp, u32 speed)
 	return 0;
 }
 
+static bool tg3_phy_power_bug(struct tg3 *tp)
+{
+	switch (GET_ASIC_REV(tp->pci_chip_rev_id)) {
+	case ASIC_REV_5700:
+	case ASIC_REV_5704:
+		return true;
+	case ASIC_REV_5780:
+		if (tp->phy_flags & TG3_PHYFLG_MII_SERDES)
+			return true;
+		return false;
+	case ASIC_REV_5717:
+		if (!tp->pci_fn)
+			return true;
+		return false;
+	case ASIC_REV_5719:
+	case ASIC_REV_5720:
+		if ((tp->phy_flags & TG3_PHYFLG_PHY_SERDES) &&
+		    !tp->pci_fn)
+			return true;
+		return false;
+	}
+
+	return false;
+}
+
 static void tg3_power_down_phy(struct tg3 *tp, bool do_low_power)
 {
 	u32 val;
@@ -2793,12 +2818,7 @@ static void tg3_power_down_phy(struct tg3 *tp, bool do_low_power)
 	/* The PHY should not be powered down on some chips because
 	 * of bugs.
 	 */
-	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5700 ||
-	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5704 ||
-	    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5780 &&
-	     (tp->phy_flags & TG3_PHYFLG_MII_SERDES)) ||
-	    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5717 &&
-	     !tp->pci_fn))
+	if (tg3_phy_power_bug(tp))
 		return;
 
 	if (GET_CHIP_REV(tp->pci_chip_rev_id) == CHIPREV_5784_AX ||
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4506cda..3a5b73f 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1622,9 +1622,6 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct net_device *dev)
 	if (dev->reg_state == NETREG_REGISTERED)
 		unregister_netdevice(dev);
 
-	if (dev->reg_state == NETREG_UNREGISTERED)
-		free_netdev(dev);
-
 	/* Clear the priv in adapter */
 	priv->netdev = NULL;
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 3192855..4be4d43 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -636,6 +636,7 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 						struct net_device *dev)
 {
 	dev->netdev_ops = &mwifiex_netdev_ops;
+	dev->destructor = free_netdev;
 	/* Initialize private structure */
 	priv->current_key_index = 0;
 	priv->media_connected = false;
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index a98f012..228607b 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -46,11 +46,33 @@
 #include <asm/xen/hypercall.h>
 #include <asm/xen/page.h>
 
+/*
+ * This is the maximum slots a skb can have. If a guest sends a skb
+ * which exceeds this limit it is considered malicious.
+ */
+#define FATAL_SKB_SLOTS_DEFAULT 20
+static unsigned int fatal_skb_slots = FATAL_SKB_SLOTS_DEFAULT;
+module_param(fatal_skb_slots, uint, 0444);
+
+/*
+ * To avoid confusion, we define XEN_NETBK_LEGACY_SLOTS_MAX indicating
+ * the maximum slots a valid packet can use. Now this value is defined
+ * to be XEN_NETIF_NR_SLOTS_MIN, which is supposed to be supported by
+ * all backend.
+ */
+#define XEN_NETBK_LEGACY_SLOTS_MAX XEN_NETIF_NR_SLOTS_MIN
+
+typedef unsigned int pending_ring_idx_t;
+#define INVALID_PENDING_RING_IDX (~0U)
+
 struct pending_tx_info {
-	struct xen_netif_tx_request req;
+	struct xen_netif_tx_request req; /* coalesced tx request */
 	struct xenvif *vif;
+	pending_ring_idx_t head; /* head != INVALID_PENDING_RING_IDX
+				  * if it is head of one or more tx
+				  * reqs
+				  */
 };
-typedef unsigned int pending_ring_idx_t;
 
 struct netbk_rx_meta {
 	int id;
@@ -101,7 +123,11 @@ struct xen_netbk {
 	atomic_t netfront_count;
 
 	struct pending_tx_info pending_tx_info[MAX_PENDING_REQS];
-	struct gnttab_copy tx_copy_ops[MAX_PENDING_REQS];
+	/* Coalescing tx requests before copying makes number of grant
+	 * copy ops greater or equal to number of slots required. In
+	 * worst case a tx request consumes 2 gnttab_copy.
+	 */
+	struct gnttab_copy tx_copy_ops[2*MAX_PENDING_REQS];
 
 	u16 pending_ring[MAX_PENDING_REQS];
 
@@ -117,6 +143,16 @@ struct xen_netbk {
 static struct xen_netbk *xen_netbk;
 static int xen_netbk_group_nr;
 
+/*
+ * If head != INVALID_PENDING_RING_IDX, it means this tx request is head of
+ * one or more merged tx requests, otherwise it is the continuation of
+ * previous tx request.
+ */
+static inline int pending_tx_is_head(struct xen_netbk *netbk, RING_IDX idx)
+{
+	return netbk->pending_tx_info[idx].head != INVALID_PENDING_RING_IDX;
+}
+
 void xen_netbk_add_xenvif(struct xenvif *vif)
 {
 	int i;
@@ -249,6 +285,7 @@ static int max_required_rx_slots(struct xenvif *vif)
 {
 	int max = DIV_ROUND_UP(vif->dev->mtu, PAGE_SIZE);
 
+	/* XXX FIXME: RX path dependent on MAX_SKB_FRAGS */
 	if (vif->can_sg || vif->gso || vif->gso_prefix)
 		max += MAX_SKB_FRAGS + 1; /* extra_info + frags */
 
@@ -626,6 +663,7 @@ static void xen_netbk_rx_action(struct xen_netbk *netbk)
 		__skb_queue_tail(&rxq, skb);
 
 		/* Filled the batch queue? */
+		/* XXX FIXME: RX path dependent on MAX_SKB_FRAGS */
 		if (count + MAX_SKB_FRAGS >= XEN_NETIF_RX_RING_SIZE)
 			break;
 	}
@@ -873,47 +911,99 @@ static int netbk_count_requests(struct xenvif *vif,
 				int work_to_do)
 {
 	RING_IDX cons = vif->tx.req_cons;
-	int frags = 0;
+	int slots = 0;
+	int drop_err = 0;
+	int more_data;
 
 	if (!(first->flags & XEN_NETTXF_more_data))
 		return 0;
 
 	do {
-		if (frags >= work_to_do) {
-			netdev_err(vif->dev, "Need more frags\n");
+		struct xen_netif_tx_request dropped_tx = { 0 };
+
+		if (slots >= work_to_do) {
+			netdev_err(vif->dev,
+				   "Asked for %d slots but exceeds this limit\n",
+				   work_to_do);
 			netbk_fatal_tx_err(vif);
 			return -ENODATA;
 		}
 
-		if (unlikely(frags >= MAX_SKB_FRAGS)) {
-			netdev_err(vif->dev, "Too many frags\n");
+		/* This guest is really using too many slots and
+		 * considered malicious.
+		 */
+		if (unlikely(slots >= fatal_skb_slots)) {
+			netdev_err(vif->dev,
+				   "Malicious frontend using %d slots, threshold %u\n",
+				   slots, fatal_skb_slots);
 			netbk_fatal_tx_err(vif);
 			return -E2BIG;
 		}
 
-		memcpy(txp, RING_GET_REQUEST(&vif->tx, cons + frags),
+		/* Xen network protocol had implicit dependency on
+		 * MAX_SKB_FRAGS. XEN_NETBK_LEGACY_SLOTS_MAX is set to
+		 * the historical MAX_SKB_FRAGS value 18 to honor the
+		 * same behavior as before. Any packet using more than
+		 * 18 slots but less than fatal_skb_slots slots is
+		 * dropped
+		 */
+		if (!drop_err && slots >= XEN_NETBK_LEGACY_SLOTS_MAX) {
+			if (net_ratelimit())
+				netdev_dbg(vif->dev,
+					   "Too many slots (%d) exceeding limit (%d), dropping packet\n",
+					   slots, XEN_NETBK_LEGACY_SLOTS_MAX);
+			drop_err = -E2BIG;
+		}
+
+		if (drop_err)
+			txp = &dropped_tx;
+
+		memcpy(txp, RING_GET_REQUEST(&vif->tx, cons + slots),
 		       sizeof(*txp));
-		if (txp->size > first->size) {
-			netdev_err(vif->dev, "Frag is bigger than frame.\n");
-			netbk_fatal_tx_err(vif);
-			return -EIO;
+
+		/* If the guest submitted a frame >= 64 KiB then
+		 * first->size overflowed and following slots will
+		 * appear to be larger than the frame.
+		 *
+		 * This cannot be fatal error as there are buggy
+		 * frontends that do this.
+		 *
+		 * Consume all slots and drop the packet.
+		 */
+		if (!drop_err && txp->size > first->size) {
+			if (net_ratelimit())
+				netdev_dbg(vif->dev,
+					   "Invalid tx request, slot size %u > remaining size %u\n",
+					   txp->size, first->size);
+			drop_err = -EIO;
 		}
 
 		first->size -= txp->size;
-		frags++;
+		slots++;
 
 		if (unlikely((txp->offset + txp->size) > PAGE_SIZE)) {
-			netdev_err(vif->dev, "txp->offset: %x, size: %u\n",
+			netdev_err(vif->dev, "Cross page boundary, txp->offset: %x, size: %u\n",
 				 txp->offset, txp->size);
 			netbk_fatal_tx_err(vif);
 			return -EINVAL;
 		}
-	} while ((txp++)->flags & XEN_NETTXF_more_data);
-	return frags;
+
+		more_data = txp->flags & XEN_NETTXF_more_data;
+
+		if (!drop_err)
+			txp++;
+
+	} while (more_data);
+
+	if (drop_err) {
+		netbk_tx_err(vif, first, cons + slots);
+		return drop_err;
+	}
+
+	return slots;
 }
 
 static struct page *xen_netbk_alloc_page(struct xen_netbk *netbk,
-					 struct sk_buff *skb,
 					 u16 pending_idx)
 {
 	struct page *page;
@@ -934,48 +1024,114 @@ static struct gnttab_copy *xen_netbk_get_requests(struct xen_netbk *netbk,
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	skb_frag_t *frags = shinfo->frags;
 	u16 pending_idx = *((u16 *)skb->data);
-	int i, start;
+	u16 head_idx = 0;
+	int slot, start;
+	struct page *page;
+	pending_ring_idx_t index, start_idx = 0;
+	uint16_t dst_offset;
+	unsigned int nr_slots;
+	struct pending_tx_info *first = NULL;
+
+	/* At this point shinfo->nr_frags is in fact the number of
+	 * slots, which can be as large as XEN_NETBK_LEGACY_SLOTS_MAX.
+	 */
+	nr_slots = shinfo->nr_frags;
 
 	/* Skip first skb fragment if it is on same page as header fragment. */
 	start = (frag_get_pending_idx(&shinfo->frags[0]) == pending_idx);
 
-	for (i = start; i < shinfo->nr_frags; i++, txp++) {
-		struct page *page;
-		pending_ring_idx_t index;
+	/* Coalesce tx requests, at this point the packet passed in
+	 * should be <= 64K. Any packets larger than 64K have been
+	 * handled in netbk_count_requests().
+	 */
+	for (shinfo->nr_frags = slot = start; slot < nr_slots;
+	     shinfo->nr_frags++) {
 		struct pending_tx_info *pending_tx_info =
 			netbk->pending_tx_info;
 
-		index = pending_index(netbk->pending_cons++);
-		pending_idx = netbk->pending_ring[index];
-		page = xen_netbk_alloc_page(netbk, skb, pending_idx);
+		page = alloc_page(GFP_KERNEL|__GFP_COLD);
 		if (!page)
 			goto err;
 
-		gop->source.u.ref = txp->gref;
-		gop->source.domid = vif->domid;
-		gop->source.offset = txp->offset;
-
-		gop->dest.u.gmfn = virt_to_mfn(page_address(page));
-		gop->dest.domid = DOMID_SELF;
-		gop->dest.offset = txp->offset;
-
-		gop->len = txp->size;
-		gop->flags = GNTCOPY_source_gref;
+		dst_offset = 0;
+		first = NULL;
+		while (dst_offset < PAGE_SIZE && slot < nr_slots) {
+			gop->flags = GNTCOPY_source_gref;
+
+			gop->source.u.ref = txp->gref;
+			gop->source.domid = vif->domid;
+			gop->source.offset = txp->offset;
+
+			gop->dest.domid = DOMID_SELF;
+
+			gop->dest.offset = dst_offset;
+			gop->dest.u.gmfn = virt_to_mfn(page_address(page));
+
+			if (dst_offset + txp->size > PAGE_SIZE) {
+				/* This page can only merge a portion
+				 * of tx request. Do not increment any
+				 * pointer / counter here. The txp
+				 * will be dealt with in future
+				 * rounds, eventually hitting the
+				 * `else` branch.
+				 */
+				gop->len = PAGE_SIZE - dst_offset;
+				txp->offset += gop->len;
+				txp->size -= gop->len;
+				dst_offset += gop->len; /* quit loop */
+			} else {
+				/* This tx request can be merged in the page */
+				gop->len = txp->size;
+				dst_offset += gop->len;
+
+				index = pending_index(netbk->pending_cons++);
+
+				pending_idx = netbk->pending_ring[index];
+
+				memcpy(&pending_tx_info[pending_idx].req, txp,
+				       sizeof(*txp));
+				xenvif_get(vif);
+
+				pending_tx_info[pending_idx].vif = vif;
+
+				/* Poison these fields, corresponding
+				 * fields for head tx req will be set
+				 * to correct values after the loop.
+				 */
+				netbk->mmap_pages[pending_idx] = (void *)(~0UL);
+				pending_tx_info[pending_idx].head =
+					INVALID_PENDING_RING_IDX;
+
+				if (!first) {
+					first = &pending_tx_info[pending_idx];
+					start_idx = index;
+					head_idx = pending_idx;
+				}
+
+				txp++;
+				slot++;
+			}
 
-		gop++;
+			gop++;
+		}
 
-		memcpy(&pending_tx_info[pending_idx].req, txp, sizeof(*txp));
-		xenvif_get(vif);
-		pending_tx_info[pending_idx].vif = vif;
-		frag_set_pending_idx(&frags[i], pending_idx);
+		first->req.offset = 0;
+		first->req.size = dst_offset;
+		first->head = start_idx;
+		set_page_ext(page, netbk, head_idx);
+		netbk->mmap_pages[head_idx] = page;
+		frag_set_pending_idx(&frags[shinfo->nr_frags], head_idx);
 	}
 
+	BUG_ON(shinfo->nr_frags > MAX_SKB_FRAGS);
+
 	return gop;
 err:
 	/* Unwind, freeing all pages and sending error responses. */
-	while (i-- > start) {
-		xen_netbk_idx_release(netbk, frag_get_pending_idx(&frags[i]),
-				      XEN_NETIF_RSP_ERROR);
+	while (shinfo->nr_frags-- > start) {
+		xen_netbk_idx_release(netbk,
+				frag_get_pending_idx(&frags[shinfo->nr_frags]),
+				XEN_NETIF_RSP_ERROR);
 	}
 	/* The head too, if necessary. */
 	if (start)
@@ -991,8 +1147,10 @@ static int xen_netbk_tx_check_gop(struct xen_netbk *netbk,
 	struct gnttab_copy *gop = *gopp;
 	u16 pending_idx = *((u16 *)skb->data);
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	struct pending_tx_info *tx_info;
 	int nr_frags = shinfo->nr_frags;
 	int i, err, start;
+	u16 peek; /* peek into next tx request */
 
 	/* Check status of header. */
 	err = gop->status;
@@ -1004,11 +1162,20 @@ static int xen_netbk_tx_check_gop(struct xen_netbk *netbk,
 
 	for (i = start; i < nr_frags; i++) {
 		int j, newerr;
+		pending_ring_idx_t head;
 
 		pending_idx = frag_get_pending_idx(&shinfo->frags[i]);
+		tx_info = &netbk->pending_tx_info[pending_idx];
+		head = tx_info->head;
 
 		/* Check error status: if okay then remember grant handle. */
-		newerr = (++gop)->status;
+		do {
+			newerr = (++gop)->status;
+			if (newerr)
+				break;
+			peek = netbk->pending_ring[pending_index(++head)];
+		} while (!pending_tx_is_head(netbk, peek));
+
 		if (likely(!newerr)) {
 			/* Had a previous error? Invalidate this fragment. */
 			if (unlikely(err))
@@ -1233,11 +1400,12 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 	struct sk_buff *skb;
 	int ret;
 
-	while (((nr_pending_reqs(netbk) + MAX_SKB_FRAGS) < MAX_PENDING_REQS) &&
+	while ((nr_pending_reqs(netbk) + XEN_NETBK_LEGACY_SLOTS_MAX
+		< MAX_PENDING_REQS) &&
 		!list_empty(&netbk->net_schedule_list)) {
 		struct xenvif *vif;
 		struct xen_netif_tx_request txreq;
-		struct xen_netif_tx_request txfrags[MAX_SKB_FRAGS];
+		struct xen_netif_tx_request txfrags[XEN_NETBK_LEGACY_SLOTS_MAX];
 		struct page *page;
 		struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX-1];
 		u16 pending_idx;
@@ -1325,7 +1493,7 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 		pending_idx = netbk->pending_ring[index];
 
 		data_len = (txreq.size > PKT_PROT_LEN &&
-			    ret < MAX_SKB_FRAGS) ?
+			    ret < XEN_NETBK_LEGACY_SLOTS_MAX) ?
 			PKT_PROT_LEN : txreq.size;
 
 		skb = alloc_skb(data_len + NET_SKB_PAD + NET_IP_ALIGN,
@@ -1352,7 +1520,7 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 		}
 
 		/* XXX could copy straight to head */
-		page = xen_netbk_alloc_page(netbk, skb, pending_idx);
+		page = xen_netbk_alloc_page(netbk, pending_idx);
 		if (!page) {
 			kfree_skb(skb);
 			netbk_tx_err(vif, &txreq, idx);
@@ -1375,6 +1543,7 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 		memcpy(&netbk->pending_tx_info[pending_idx].req,
 		       &txreq, sizeof(txreq));
 		netbk->pending_tx_info[pending_idx].vif = vif;
+		netbk->pending_tx_info[pending_idx].head = index;
 		*((u16 *)skb->data) = pending_idx;
 
 		__skb_put(skb, data_len);
@@ -1505,7 +1674,10 @@ static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx,
 {
 	struct xenvif *vif;
 	struct pending_tx_info *pending_tx_info;
-	pending_ring_idx_t index;
+	pending_ring_idx_t head;
+	u16 peek; /* peek into next tx request */
+
+	BUG_ON(netbk->mmap_pages[pending_idx] == (void *)(~0UL));
 
 	/* Already complete? */
 	if (netbk->mmap_pages[pending_idx] == NULL)
@@ -1514,19 +1686,40 @@ static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx,
 	pending_tx_info = &netbk->pending_tx_info[pending_idx];
 
 	vif = pending_tx_info->vif;
+	head = pending_tx_info->head;
+
+	BUG_ON(!pending_tx_is_head(netbk, head));
+	BUG_ON(netbk->pending_ring[pending_index(head)] != pending_idx);
 
-	make_tx_response(vif, &pending_tx_info->req, status);
+	do {
+		pending_ring_idx_t index;
+		pending_ring_idx_t idx = pending_index(head);
+		u16 info_idx = netbk->pending_ring[idx];
 
-	index = pending_index(netbk->pending_prod++);
-	netbk->pending_ring[index] = pending_idx;
+		pending_tx_info = &netbk->pending_tx_info[info_idx];
+		make_tx_response(vif, &pending_tx_info->req, status);
 
-	xenvif_put(vif);
+		/* Setting any number other than
+		 * INVALID_PENDING_RING_IDX indicates this slot is
+		 * starting a new packet / ending a previous packet.
+		 */
+		pending_tx_info->head = 0;
+
+		index = pending_index(netbk->pending_prod++);
+		netbk->pending_ring[index] = netbk->pending_ring[info_idx];
+
+		xenvif_put(vif);
+
+		peek = netbk->pending_ring[pending_index(++head)];
+
+	} while (!pending_tx_is_head(netbk, peek));
 
 	netbk->mmap_pages[pending_idx]->mapping = 0;
 	put_page(netbk->mmap_pages[pending_idx]);
 	netbk->mmap_pages[pending_idx] = NULL;
 }
 
+
 static void make_tx_response(struct xenvif *vif,
 			     struct xen_netif_tx_request *txp,
 			     s8       st)
@@ -1579,8 +1772,9 @@ static inline int rx_work_todo(struct xen_netbk *netbk)
 static inline int tx_work_todo(struct xen_netbk *netbk)
 {
 
-	if (((nr_pending_reqs(netbk) + MAX_SKB_FRAGS) < MAX_PENDING_REQS) &&
-			!list_empty(&netbk->net_schedule_list))
+	if ((nr_pending_reqs(netbk) + XEN_NETBK_LEGACY_SLOTS_MAX
+	     < MAX_PENDING_REQS) &&
+	     !list_empty(&netbk->net_schedule_list))
 		return 1;
 
 	return 0;
@@ -1663,6 +1857,13 @@ static int __init netback_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
+	if (fatal_skb_slots < XEN_NETBK_LEGACY_SLOTS_MAX) {
+		printk(KERN_INFO
+		       "xen-netback: fatal_skb_slots too small (%d), bump it to XEN_NETBK_LEGACY_SLOTS_MAX (%d)\n",
+		       fatal_skb_slots, XEN_NETBK_LEGACY_SLOTS_MAX);
+		fatal_skb_slots = XEN_NETBK_LEGACY_SLOTS_MAX;
+	}
+
 	xen_netbk_group_nr = num_online_cpus();
 	xen_netbk = vzalloc(sizeof(struct xen_netbk) * xen_netbk_group_nr);
 	if (!xen_netbk)
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 3089990..526702d 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -481,7 +481,6 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct netfront_info *np = netdev_priv(dev);
 	struct netfront_stats *stats = this_cpu_ptr(np->stats);
 	struct xen_netif_tx_request *tx;
-	struct xen_netif_extra_info *extra;
 	char *data = skb->data;
 	RING_IDX i;
 	grant_ref_t ref;
@@ -525,7 +524,6 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx->gref = np->grant_tx_ref[id] = ref;
 	tx->offset = offset;
 	tx->size = len;
-	extra = NULL;
 
 	tx->flags = 0;
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
@@ -541,10 +539,7 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		gso = (struct xen_netif_extra_info *)
 			RING_GET_REQUEST(&np->tx, ++i);
 
-		if (extra)
-			extra->flags |= XEN_NETIF_EXTRA_FLAG_MORE;
-		else
-			tx->flags |= XEN_NETTXF_extra_info;
+		tx->flags |= XEN_NETTXF_extra_info;
 
 		gso->u.gso.size = skb_shinfo(skb)->gso_size;
 		gso->u.gso.type = XEN_NETIF_GSO_TYPE_TCPV4;
@@ -553,7 +548,6 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		gso->type = XEN_NETIF_EXTRA_TYPE_GSO;
 		gso->flags = 0;
-		extra = gso;
 	}
 
 	np->tx.req_prod_pvt = i + 1;
@@ -662,7 +656,7 @@ static int xennet_get_responses(struct netfront_info *np,
 	struct sk_buff *skb = xennet_get_rx_skb(np, cons);
 	grant_ref_t ref = xennet_get_rx_ref(np, cons);
 	int max = MAX_SKB_FRAGS + (rx->status <= RX_COPY_THRESHOLD);
-	int frags = 1;
+	int slots = 1;
 	int err = 0;
 	unsigned long ret;
 
@@ -685,7 +679,7 @@ static int xennet_get_responses(struct netfront_info *np,
 		/*
 		 * This definitely indicates a bug, either in this driver or in
 		 * the backend driver. In future this should flag the bad
-		 * situation to the system controller to reboot the backed.
+		 * situation to the system controller to reboot the backend.
 		 */
 		if (ref == GRANT_INVALID_REF) {
 			if (net_ratelimit())
@@ -706,27 +700,27 @@ next:
 		if (!(rx->flags & XEN_NETRXF_more_data))
 			break;
 
-		if (cons + frags == rp) {
+		if (cons + slots == rp) {
 			if (net_ratelimit())
-				dev_warn(dev, "Need more frags\n");
+				dev_warn(dev, "Need more slots\n");
 			err = -ENOENT;
 			break;
 		}
 
-		rx = RING_GET_RESPONSE(&np->rx, cons + frags);
-		skb = xennet_get_rx_skb(np, cons + frags);
-		ref = xennet_get_rx_ref(np, cons + frags);
-		frags++;
+		rx = RING_GET_RESPONSE(&np->rx, cons + slots);
+		skb = xennet_get_rx_skb(np, cons + slots);
+		ref = xennet_get_rx_ref(np, cons + slots);
+		slots++;
 	}
 
-	if (unlikely(frags > max)) {
+	if (unlikely(slots > max)) {
 		if (net_ratelimit())
-			dev_warn(dev, "Too many frags\n");
+			dev_warn(dev, "Too many slots\n");
 		err = -E2BIG;
 	}
 
 	if (unlikely(err))
-		np->rx.rsp_cons = cons + frags;
+		np->rx.rsp_cons = cons + slots;
 
 	return err;
 }
diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index 5d44252..7fca1da 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -471,6 +471,10 @@ static irqreturn_t tsi721_irqhandler(int irq, void *ptr)
 	u32 intval;
 	u32 ch_inte;
 
+	/* For MSI mode disable all device-level interrupts */
+	if (priv->flags & TSI721_USING_MSI)
+		iowrite32(0, priv->regs + TSI721_DEV_INTE);
+
 	dev_int = ioread32(priv->regs + TSI721_DEV_INT);
 	if (!dev_int)
 		return IRQ_NONE;
@@ -560,6 +564,14 @@ static irqreturn_t tsi721_irqhandler(int irq, void *ptr)
 		}
 	}
 #endif
+
+	/* For MSI mode re-enable device-level interrupts */
+	if (priv->flags & TSI721_USING_MSI) {
+		dev_int = TSI721_DEV_INT_SR2PC_CH | TSI721_DEV_INT_SRIO |
+			TSI721_DEV_INT_SMSG_CH | TSI721_DEV_INT_BDMA_CH;
+		iowrite32(dev_int, priv->regs + TSI721_DEV_INTE);
+	}
+
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/staging/iio/light/tsl2x7x_core.c b/drivers/staging/iio/light/tsl2x7x_core.c
index c3b05a1..0c656ca 100755
--- a/drivers/staging/iio/light/tsl2x7x_core.c
+++ b/drivers/staging/iio/light/tsl2x7x_core.c
@@ -1924,6 +1924,7 @@ static int __devinit tsl2x7x_probe(struct i2c_client *clientp,
 		dev_info(&chip->client->dev,
 				"%s: i2c device found does not match expected id\n",
 				__func__);
+		ret = -EINVAL;
 		goto fail1;
 	}
 
@@ -1962,7 +1963,7 @@ static int __devinit tsl2x7x_probe(struct i2c_client *clientp,
 		if (ret) {
 			dev_err(&clientp->dev,
 				"%s: irq request failed", __func__);
-			goto fail2;
+			goto fail1;
 		}
 	}
 
@@ -1975,17 +1976,17 @@ static int __devinit tsl2x7x_probe(struct i2c_client *clientp,
 	if (ret) {
 		dev_err(&clientp->dev,
 			"%s: iio registration failed\n", __func__);
-		goto fail1;
+		goto fail2;
 	}
 
 	dev_info(&clientp->dev, "%s Light sensor found.\n", id->name);
 
 	return 0;
 
-fail1:
+fail2:
 	if (clientp->irq)
 		free_irq(clientp->irq, indio_dev);
-fail2:
+fail1:
 	iio_device_free(indio_dev);
 
 	return ret;
diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index 51b5adf..df8ea25 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -153,7 +153,7 @@ static int hostap_disable_hostapd(PSDevice pDevice, int rtnl_locked)
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Netdevice %s unregistered\n",
 		       pDevice->dev->name, pDevice->apdev->name);
 	}
-	kfree(pDevice->apdev);
+	free_netdev(pDevice->apdev);
 	pDevice->apdev = NULL;
     pDevice->bEnable8021x = FALSE;
     pDevice->bEnableHostWEP = FALSE;
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index ed5241e..18c086d 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -713,9 +713,9 @@ static int iscsi_add_notunderstood_response(
 	}
 	INIT_LIST_HEAD(&extra_response->er_list);
 
-	strncpy(extra_response->key, key, strlen(key) + 1);
-	strncpy(extra_response->value, NOTUNDERSTOOD,
-			strlen(NOTUNDERSTOOD) + 1);
+	strlcpy(extra_response->key, key, sizeof(extra_response->key));
+	strlcpy(extra_response->value, NOTUNDERSTOOD,
+		sizeof(extra_response->value));
 
 	list_add_tail(&extra_response->er_list,
 			&param_list->extra_response_list);
@@ -1554,8 +1554,6 @@ int iscsi_decode_text_input(
 
 		if (phase & PHASE_SECURITY) {
 			if (iscsi_check_for_auth_key(key) > 0) {
-				char *tmpptr = key + strlen(key);
-				*tmpptr = '=';
 				kfree(tmpbuf);
 				return 1;
 			}
diff --git a/drivers/target/iscsi/iscsi_target_parameters.h b/drivers/target/iscsi/iscsi_target_parameters.h
index 6a37fd6..83eed65 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.h
+++ b/drivers/target/iscsi/iscsi_target_parameters.h
@@ -1,8 +1,10 @@
 #ifndef ISCSI_PARAMETERS_H
 #define ISCSI_PARAMETERS_H
 
+#include <scsi/iscsi_proto.h>
+
 struct iscsi_extra_response {
-	char key[64];
+	char key[KEY_MAXLEN];
 	char value[32];
 	struct list_head er_list;
 } ____cacheline_aligned;
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 26f0d0e..72d3ff8 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1529,6 +1529,14 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 			tty->real_raw = 0;
 	}
 	n_tty_set_room(tty);
+	/*
+	 * Fix tty hang when I_IXON(tty) is cleared, but the tty
+	 * been stopped by STOP_CHAR(tty) before it.
+	 */
+	if (!I_IXON(tty) && old && (old->c_iflag & IXON) && !tty->flow_stopped) {
+		start_tty(tty);
+	}
+
 	/* The termios change make the tty ready for I/O */
 	wake_up_interruptible(&tty->write_wait);
 	wake_up_interruptible(&tty->read_wait);
diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index b7eb86a..8a7eb77 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -686,7 +686,8 @@ static int cxacru_cm_get_array(struct cxacru_data *instance, enum cxacru_cm_requ
 {
 	int ret, len;
 	__le32 *buf;
-	int offb, offd;
+	int offb;
+	unsigned int offd;
 	const int stride = CMD_PACKET_SIZE / (4 * 2) - 1;
 	int buflen =  ((size - 1) / stride + 1 + size * 2) * 4;
 
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 3f08c09..b801512 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -113,6 +113,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Edirol SD-20 */
 	{ USB_DEVICE(0x0582, 0x0027), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Alcor Micro Corp. Hub */
+	{ USB_DEVICE(0x058f, 0x9254), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* appletouch */
 	{ USB_DEVICE(0x05ac, 0x021a), .driver_info = USB_QUIRK_RESET_RESUME },
 
diff --git a/drivers/usb/host/uhci-hub.c b/drivers/usb/host/uhci-hub.c
index 768d542..c994655 100644
--- a/drivers/usb/host/uhci-hub.c
+++ b/drivers/usb/host/uhci-hub.c
@@ -222,7 +222,8 @@ static int uhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 		/* auto-stop if nothing connected for 1 second */
 		if (any_ports_active(uhci))
 			uhci->rh_state = UHCI_RH_RUNNING;
-		else if (time_after_eq(jiffies, uhci->auto_stop_time))
+		else if (time_after_eq(jiffies, uhci->auto_stop_time) &&
+				!uhci->wait_for_hp)
 			suspend_rh(uhci, UHCI_RH_AUTO_STOPPED);
 		break;
 
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 35616ff..90ce33b 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1443,15 +1443,17 @@ int xhci_endpoint_init(struct xhci_hcd *xhci,
 	ep_ctx->ep_info2 |= cpu_to_le32(xhci_get_endpoint_type(udev, ep));
 
 	/* Set the max packet size and max burst */
+	max_packet = GET_MAX_PACKET(usb_endpoint_maxp(&ep->desc));
+	max_burst = 0;
 	switch (udev->speed) {
 	case USB_SPEED_SUPER:
-		max_packet = usb_endpoint_maxp(&ep->desc);
-		ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(max_packet));
 		/* dig out max burst from ep companion desc */
-		max_packet = ep->ss_ep_comp.bMaxBurst;
-		ep_ctx->ep_info2 |= cpu_to_le32(MAX_BURST(max_packet));
+		max_burst = ep->ss_ep_comp.bMaxBurst;
 		break;
 	case USB_SPEED_HIGH:
+		/* Some devices get this wrong */
+		if (usb_endpoint_xfer_bulk(&ep->desc))
+			max_packet = 512;
 		/* bits 11:12 specify the number of additional transaction
 		 * opportunities per microframe (USB 2.0, section 9.6.6)
 		 */
@@ -1459,17 +1461,16 @@ int xhci_endpoint_init(struct xhci_hcd *xhci,
 				usb_endpoint_xfer_int(&ep->desc)) {
 			max_burst = (usb_endpoint_maxp(&ep->desc)
 				     & 0x1800) >> 11;
-			ep_ctx->ep_info2 |= cpu_to_le32(MAX_BURST(max_burst));
 		}
-		/* Fall through */
+		break;
 	case USB_SPEED_FULL:
 	case USB_SPEED_LOW:
-		max_packet = GET_MAX_PACKET(usb_endpoint_maxp(&ep->desc));
-		ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(max_packet));
 		break;
 	default:
 		BUG();
 	}
+	ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(max_packet) |
+			MAX_BURST(max_burst));
 	max_esit_payload = xhci_get_max_esit_payload(xhci, udev, ep);
 	ep_ctx->tx_info = cpu_to_le32(MAX_ESIT_PAYLOAD_FOR_EP(max_esit_payload));
 
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index d5b9a74..45e80a7 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -197,6 +197,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_BOOST_PID) },
 	{ USB_DEVICE(NEWPORT_VID, NEWPORT_AGILIS_PID) },
+	{ USB_DEVICE(NEWPORT_VID, NEWPORT_CONEX_CC_PID) },
+	{ USB_DEVICE(NEWPORT_VID, NEWPORT_CONEX_AGP_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 9852827..6dd7925 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -772,6 +772,8 @@
  */
 #define NEWPORT_VID			0x104D
 #define NEWPORT_AGILIS_PID		0x3000
+#define NEWPORT_CONEX_CC_PID		0x3002
+#define NEWPORT_CONEX_AGP_PID		0x3006
 
 /* Interbiometrics USB I/O Board */
 /* Developed for Interbiometrics by Rudolf Gugler */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index c5a50c9..38ea4b7 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -196,6 +196,7 @@ static void option_instat_callback(struct urb *urb);
 
 #define DELL_PRODUCT_5800_MINICARD_VZW		0x8195  /* Novatel E362 */
 #define DELL_PRODUCT_5800_V2_MINICARD_VZW	0x8196  /* Novatel E362 */
+#define DELL_PRODUCT_5804_MINICARD_ATT		0x819b  /* Novatel E371 */
 
 #define KYOCERA_VENDOR_ID			0x0c88
 #define KYOCERA_PRODUCT_KPC650			0x17da
@@ -341,8 +342,8 @@ static void option_instat_callback(struct urb *urb);
 #define CINTERION_PRODUCT_EU3_E			0x0051
 #define CINTERION_PRODUCT_EU3_P			0x0052
 #define CINTERION_PRODUCT_PH8			0x0053
-#define CINTERION_PRODUCT_AH6			0x0055
-#define CINTERION_PRODUCT_PLS8			0x0060
+#define CINTERION_PRODUCT_AHXX			0x0055
+#define CINTERION_PRODUCT_PLXX			0x0060
 
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -771,6 +772,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_VZW) }, 	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
 	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5800_MINICARD_VZW, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5800_V2_MINICARD_VZW, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5804_MINICARD_ATT, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },	/* ADU-E100, ADU-310 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_620UW) },
@@ -966,6 +968,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0330, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0395, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0412, 0xff, 0xff, 0xff), /* Telewell TW-LTE 4G */
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0414, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0417, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1008, 0xff, 0xff, 0xff),
@@ -1264,8 +1268,9 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_E) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_P) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8) },
-	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AH6) },
-	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLS8) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AHXX) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLXX),
+		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDM) }, 
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC25_MDM) },
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0e92e57..baa4a40 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1665,7 +1665,11 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		item_off = btrfs_item_ptr_offset(leaf, i);
 		item_len = btrfs_item_size_nr(leaf, i);
 
-		if (item_len > BTRFS_SEARCH_ARGS_BUFSIZE)
+		btrfs_item_key_to_cpu(leaf, key, i);
+		if (!key_in_sk(key, sk))
+			continue;
+
+		if (sizeof(sh) + item_len > BTRFS_SEARCH_ARGS_BUFSIZE)
 			item_len = 0;
 
 		if (sizeof(sh) + item_len + *sk_offset >
@@ -1674,10 +1678,6 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 			goto overflow;
 		}
 
-		btrfs_item_key_to_cpu(leaf, key, i);
-		if (!key_in_sk(key, sk))
-			continue;
-
 		sh.objectid = key->objectid;
 		sh.offset = key->offset;
 		sh.type = key->type;
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 2263144..d0e5fc5 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/vfs.h>
 #include <linux/fs.h>
+#include <linux/inet.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifsfs.h"
@@ -150,7 +151,8 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	 * assuming that we have 'unc=' and 'ip=' in
 	 * the original sb_mountdata
 	 */
-	md_len = strlen(sb_mountdata) + rc + strlen(ref->node_name) + 12;
+	md_len = strlen(sb_mountdata) + rc + strlen(ref->node_name) + 12 +
+			INET6_ADDRSTRLEN;
 	mountdata = kzalloc(md_len+1, GFP_KERNEL);
 	if (mountdata == NULL) {
 		rc = -ENOMEM;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 745da3d..6fbfbdb 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -173,7 +173,8 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 
 	if (fattr->cf_flags & CIFS_FATTR_DFS_REFERRAL)
 		inode->i_flags |= S_AUTOMOUNT;
-	cifs_set_ops(inode);
+	if (inode->i_state & I_NEW)
+		cifs_set_ops(inode);
 }
 
 void
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 0038b32..e69b441e 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1218,6 +1218,19 @@ static int fat_read_root(struct inode *inode)
 	return 0;
 }
 
+static unsigned long calc_fat_clusters(struct super_block *sb)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+
+	/* Divide first to avoid overflow */
+	if (sbi->fat_bits != 12) {
+		unsigned long ent_per_sec = sb->s_blocksize * 8 / sbi->fat_bits;
+		return ent_per_sec * sbi->fat_length;
+	}
+
+	return sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
+}
+
 /*
  * Read the super block of an MS-DOS FS.
  */
@@ -1415,7 +1428,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		sbi->fat_bits = (total_clusters > MAX_FAT12) ? 16 : 12;
 
 	/* check that FAT table does not overflow */
-	fat_clusters = sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
+	fat_clusters = calc_fat_clusters(sb);
 	total_clusters = min(total_clusters, fat_clusters - FAT_START_ENT);
 	if (total_clusters > MAX_FAT(sb)) {
 		if (!silent)
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 4692bf3..7e54dfd 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -125,7 +125,7 @@ int jfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int wait = wbc->sync_mode == WB_SYNC_ALL;
 
-	if (test_cflag(COMMIT_Nolink, inode))
+	if (inode->i_nlink == 0)
 		return 0;
 	/*
 	 * If COMMIT_DIRTY is not set, the inode isn't really dirty.
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 2eb952c..cbe48ea 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1058,7 +1058,8 @@ static int lmLogSync(struct jfs_log * log, int hard_sync)
  */
 void jfs_syncpt(struct jfs_log *log, int hard_sync)
 {	LOG_LOCK(log);
-	lmLogSync(log, hard_sync);
+	if (!test_bit(log_QUIESCE, &log->flag))
+		lmLogSync(log, hard_sync);
 	LOG_UNLOCK(log);
 }
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 480918e..871d50c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1072,7 +1072,7 @@ static struct nfs4_state *nfs4_try_open_cached(struct nfs4_opendata *opendata)
 	struct nfs4_state *state = opendata->state;
 	struct nfs_inode *nfsi = NFS_I(state->inode);
 	struct nfs_delegation *delegation;
-	int open_mode = opendata->o_arg.open_flags & (O_EXCL|O_TRUNC);
+	int open_mode = opendata->o_arg.open_flags;
 	fmode_t fmode = opendata->o_arg.fmode;
 	nfs4_stateid stateid;
 	int ret = -EAGAIN;
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 7cc6446..ba5128d 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -195,13 +195,32 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
 
 static int nilfs_set_page_dirty(struct page *page)
 {
-	int ret = __set_page_dirty_buffers(page);
+	int ret = __set_page_dirty_nobuffers(page);
 
-	if (ret) {
+	if (page_has_buffers(page)) {
 		struct inode *inode = page->mapping->host;
-		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
+		unsigned nr_dirty = 0;
+		struct buffer_head *bh, *head;
 
-		nilfs_set_file_dirty(inode, nr_dirty);
+		/*
+		 * This page is locked by callers, and no other thread
+		 * concurrently marks its buffers dirty since they are
+		 * only dirtied through routines in fs/buffer.c in
+		 * which call sites of mark_buffer_dirty are protected
+		 * by page lock.
+		 */
+		bh = head = page_buffers(page);
+		do {
+			/* Do not mark hole blocks dirty */
+			if (buffer_dirty(bh) || !buffer_mapped(bh))
+				continue;
+
+			set_buffer_dirty(bh);
+			nr_dirty++;
+		} while (bh = bh->b_this_page, bh != head);
+
+		if (nr_dirty)
+			nilfs_set_file_dirty(inode, nr_dirty);
 	}
 	return ret;
 }
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 70b5863..4dd0239 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -791,7 +791,7 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 						 &hole_size, &rec, &is_last);
 		if (ret) {
 			mlog_errno(ret);
-			goto out;
+			goto out_unlock;
 		}
 
 		if (rec.e_blkno == 0ULL) {
diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index 66c53b6..6c2d136 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -204,6 +204,8 @@ int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
 				next_pos = deh_offset(deh) + 1;
 
 				if (item_moved(&tmp_ih, &path_to_entry)) {
+					set_cpu_key_k_offset(&pos_key,
+							     next_pos);
 					goto research;
 				}
 			}	/* for */
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 210f70e..591b79f 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1810,11 +1810,16 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 				  TYPE_STAT_DATA, SD_SIZE, MAX_US_INT);
 	memcpy(INODE_PKEY(inode), &(ih.ih_key), KEY_SIZE);
 	args.dirid = le32_to_cpu(ih.ih_key.k_dir_id);
-	if (insert_inode_locked4(inode, args.objectid,
-			     reiserfs_find_actor, &args) < 0) {
+
+	reiserfs_write_unlock(inode->i_sb);
+	err = insert_inode_locked4(inode, args.objectid,
+			     reiserfs_find_actor, &args);
+	reiserfs_write_lock(inode->i_sb);
+	if (err) {
 		err = -EINVAL;
 		goto out_bad_inode;
 	}
+
 	if (old_format_only(sb))
 		/* not a perfect generation count, as object ids can be reused, but
 		 ** this is as good as reiserfs can do right now.
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 048d990..cff0888 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -318,7 +318,19 @@ static int delete_one_xattr(struct dentry *dentry, void *data)
 static int chown_one_xattr(struct dentry *dentry, void *data)
 {
 	struct iattr *attrs = data;
-	return reiserfs_setattr(dentry, attrs);
+	int ia_valid = attrs->ia_valid;
+	int err;
+
+	/*
+	 * We only want the ownership bits. Otherwise, we'll do
+	 * things like change a directory to a regular file if
+	 * ATTR_MODE is set.
+	 */
+	attrs->ia_valid &= (ATTR_UID|ATTR_GID);
+	err = reiserfs_setattr(dentry, attrs);
+	attrs->ia_valid = ia_valid;
+
+	return err;
 }
 
 /* No i_mutex, but the inode is unconnected. */
diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index 44474f9..84fe30c 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -429,6 +429,9 @@ int reiserfs_acl_chmod(struct inode *inode)
 	int depth;
 	int error;
 
+	if (IS_PRIVATE(inode))
+		return 0;
+
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1a25fd8..1ad330c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -454,6 +454,28 @@ xfs_vn_getattr(
 	return 0;
 }
 
+static void
+xfs_setattr_mode(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct iattr		*iattr)
+{
+	struct inode	*inode = VFS_I(ip);
+	umode_t		mode = iattr->ia_mode;
+
+	ASSERT(tp);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+		mode &= ~S_ISGID;
+
+	ip->i_d.di_mode &= S_IFMT;
+	ip->i_d.di_mode |= mode & ~S_IFMT;
+
+	inode->i_mode &= S_IFMT;
+	inode->i_mode |= mode & ~S_IFMT;
+}
+
 int
 xfs_setattr_nonsize(
 	struct xfs_inode	*ip,
@@ -605,18 +627,8 @@ xfs_setattr_nonsize(
 	/*
 	 * Change file access modes.
 	 */
-	if (mask & ATTR_MODE) {
-		umode_t mode = iattr->ia_mode;
-
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			mode &= ~S_ISGID;
-
-		ip->i_d.di_mode &= S_IFMT;
-		ip->i_d.di_mode |= mode & ~S_IFMT;
-
-		inode->i_mode &= S_IFMT;
-		inode->i_mode |= mode & ~S_IFMT;
-	}
+	if (mask & ATTR_MODE)
+		xfs_setattr_mode(tp, ip, iattr);
 
 	/*
 	 * Change file access or modified times.
@@ -713,9 +725,8 @@ xfs_setattr_size(
 		return XFS_ERROR(error);
 
 	ASSERT(S_ISREG(ip->i_d.di_mode));
-	ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
-			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
-			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+	ASSERT((mask & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
+			ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
 
 	if (!(flags & XFS_ATTR_NOLOCK)) {
 		lock_flags |= XFS_IOLOCK_EXCL;
@@ -856,6 +867,12 @@ xfs_setattr_size(
 		xfs_iflags_set(ip, XFS_ITRUNCATED);
 	}
 
+	/*
+	 * Change file access modes.
+	 */
+	if (mask & ATTR_MODE)
+		xfs_setattr_mode(tp, ip, iattr);
+
 	if (mask & ATTR_CTIME) {
 		inode->i_ctime = iattr->ia_ctime;
 		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
diff --git a/include/linux/virtio_console.h b/include/linux/virtio_console.h
index bdf4b00..82e12ad 100644
--- a/include/linux/virtio_console.h
+++ b/include/linux/virtio_console.h
@@ -39,7 +39,7 @@
 #define VIRTIO_CONSOLE_F_SIZE	0	/* Does host provide console size? */
 #define VIRTIO_CONSOLE_F_MULTIPORT 1	/* Does host provide multiple ports? */
 
-#define VIRTIO_CONSOLE_BAD_ID		(~(u32)0)
+#define VIRTIO_CONSOLE_BAD_ID		(~(__u32)0)
 
 struct virtio_console_config {
 	/* colums of the screens */
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 1dee81c..6c6c20e 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -233,6 +233,8 @@ do {									\
 		if (!ret)						\
 			break;						\
 	}								\
+	if (!ret && (condition))					\
+		ret = 1;						\
 	finish_wait(&wq, &__wait);					\
 } while (0)
 
@@ -249,8 +251,9 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
- * The function returns 0 if the @timeout elapsed, and the remaining
- * jiffies if the condition evaluated to true before the timeout elapsed.
+ * The function returns 0 if the @timeout elapsed, or the remaining
+ * jiffies (at least 1) if the @condition evaluated to %true before
+ * the @timeout elapsed.
  */
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
@@ -318,6 +321,8 @@ do {									\
 		ret = -ERESTARTSYS;					\
 		break;							\
 	}								\
+	if (!ret && (condition))					\
+		ret = 1;						\
 	finish_wait(&wq, &__wait);					\
 } while (0)
 
@@ -334,9 +339,10 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
- * The function returns 0 if the @timeout elapsed, -ERESTARTSYS if it
- * was interrupted by a signal, and the remaining jiffies otherwise
- * if the condition evaluated to true before the timeout elapsed.
+ * Returns:
+ * 0 if the @timeout elapsed, -%ERESTARTSYS if it was interrupted by
+ * a signal, or the remaining jiffies (at least 1) if the @condition
+ * evaluated to %true before the @timeout elapsed.
  */
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
diff --git a/include/xen/interface/io/netif.h b/include/xen/interface/io/netif.h
index cb94668..a36c87a 100644
--- a/include/xen/interface/io/netif.h
+++ b/include/xen/interface/io/netif.h
@@ -13,6 +13,24 @@
 #include "../grant_table.h"
 
 /*
+ * Older implementation of Xen network frontend / backend has an
+ * implicit dependency on the MAX_SKB_FRAGS as the maximum number of
+ * ring slots a skb can use. Netfront / netback may not work as
+ * expected when frontend and backend have different MAX_SKB_FRAGS.
+ *
+ * A better approach is to add mechanism for netfront / netback to
+ * negotiate this value. However we cannot fix all possible
+ * frontends, so we need to define a value which states the minimum
+ * slots backend must support.
+ *
+ * The minimum value derives from older Linux kernel's MAX_SKB_FRAGS
+ * (18), which is proved to work with most frontends. Any new backend
+ * which doesn't negotiate with frontend should expect frontend to
+ * send a valid packet using slots up to this value.
+ */
+#define XEN_NETIF_NR_SLOTS_MIN 18
+
+/*
  * Notifications after enqueuing any type of message should be conditional on
  * the appropriate req_event or rsp_event field in the shared ring.
  * If the client sends notification for rx requests then it should specify
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 473cac3..89e8c2c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5434,16 +5434,25 @@ static void sd_free_ctl_entry(struct ctl_table **tablep)
 	*tablep = NULL;
 }
 
+static int min_load_idx = 0;
+static int max_load_idx = CPU_LOAD_IDX_MAX-1;
+
 static void
 set_table_entry(struct ctl_table *entry,
 		const char *procname, void *data, int maxlen,
-		umode_t mode, proc_handler *proc_handler)
+		umode_t mode, proc_handler *proc_handler,
+		bool load_idx)
 {
 	entry->procname = procname;
 	entry->data = data;
 	entry->maxlen = maxlen;
 	entry->mode = mode;
 	entry->proc_handler = proc_handler;
+
+	if (load_idx) {
+		entry->extra1 = &min_load_idx;
+		entry->extra2 = &max_load_idx;
+	}
 }
 
 static struct ctl_table *
@@ -5455,30 +5464,30 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		return NULL;
 
 	set_table_entry(&table[0], "min_interval", &sd->min_interval,
-		sizeof(long), 0644, proc_doulongvec_minmax);
+		sizeof(long), 0644, proc_doulongvec_minmax, false);
 	set_table_entry(&table[1], "max_interval", &sd->max_interval,
-		sizeof(long), 0644, proc_doulongvec_minmax);
+		sizeof(long), 0644, proc_doulongvec_minmax, false);
 	set_table_entry(&table[2], "busy_idx", &sd->busy_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[3], "idle_idx", &sd->idle_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[4], "newidle_idx", &sd->newidle_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[5], "wake_idx", &sd->wake_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[6], "forkexec_idx", &sd->forkexec_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[7], "busy_factor", &sd->busy_factor,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[8], "imbalance_pct", &sd->imbalance_pct,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[9], "cache_nice_tries",
 		&sd->cache_nice_tries,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[10], "flags", &sd->flags,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[11], "name", sd->name,
-		CORENAME_MAX_SIZE, 0444, proc_dostring);
+		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
 	/* &table[12] is terminator */
 
 	return table;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 57c4b93..7d0eb9e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1955,7 +1955,12 @@ static void collapse_huge_page(struct mm_struct *mm,
 		pte_unmap(pte);
 		spin_lock(&mm->page_table_lock);
 		BUG_ON(!pmd_none(*pmd));
-		set_pmd_at(mm, address, pmd, _pmd);
+		/*
+		 * We can only use set_pmd_at when establishing
+		 * hugepmds and never for establishing regular pmds that
+		 * points to regular pagetables. Use pmd_populate for that
+		 */
+		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
 		spin_unlock(&mm->page_table_lock);
 		anon_vma_unlock(vma->anon_vma);
 		goto out;
diff --git a/mm/migrate.c b/mm/migrate.c
index 2e03986..65cc229 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -147,7 +147,7 @@ static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
 		pte = arch_make_huge_pte(pte, vma, new, 0);
 	}
 #endif
-	flush_cache_page(vma, addr, pte_pfn(pte));
+	flush_dcache_page(new);
 	set_pte_at(mm, addr, ptep, pte);
 
 	if (PageHuge(new)) {
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 8d1ca2d..a160ec8 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -37,51 +37,48 @@ static struct srcu_struct srcu;
 void __mmu_notifier_release(struct mm_struct *mm)
 {
 	struct mmu_notifier *mn;
+	struct hlist_node *n;
 	int id;
 
 	/*
-	 * srcu_read_lock() here will block synchronize_srcu() in
-	 * mmu_notifier_unregister() until all registered
-	 * ->release() callouts this function makes have
-	 * returned.
+	 * SRCU here will block mmu_notifier_unregister until
+	 * ->release returns.
 	 */
 	id = srcu_read_lock(&srcu);
+	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist)
+		/*
+		 * If ->release runs before mmu_notifier_unregister it must be
+		 * handled, as it's the only way for the driver to flush all
+		 * existing sptes and stop the driver from establishing any more
+		 * sptes before all the pages in the mm are freed.
+		 */
+		if (mn->ops->release)
+			mn->ops->release(mn, mm);
+	srcu_read_unlock(&srcu, id);
+
 	spin_lock(&mm->mmu_notifier_mm->lock);
 	while (unlikely(!hlist_empty(&mm->mmu_notifier_mm->list))) {
 		mn = hlist_entry(mm->mmu_notifier_mm->list.first,
 				 struct mmu_notifier,
 				 hlist);
-
 		/*
-		 * Unlink.  This will prevent mmu_notifier_unregister()
-		 * from also making the ->release() callout.
+		 * We arrived before mmu_notifier_unregister so
+		 * mmu_notifier_unregister will do nothing other than to wait
+		 * for ->release to finish and for mmu_notifier_unregister to
+		 * return.
 		 */
 		hlist_del_init_rcu(&mn->hlist);
-		spin_unlock(&mm->mmu_notifier_mm->lock);
-
-		/*
-		 * Clear sptes. (see 'release' description in mmu_notifier.h)
-		 */
-		if (mn->ops->release)
-			mn->ops->release(mn, mm);
-
-		spin_lock(&mm->mmu_notifier_mm->lock);
 	}
 	spin_unlock(&mm->mmu_notifier_mm->lock);
 
 	/*
-	 * All callouts to ->release() which we have done are complete.
-	 * Allow synchronize_srcu() in mmu_notifier_unregister() to complete
-	 */
-	srcu_read_unlock(&srcu, id);
-
-	/*
-	 * mmu_notifier_unregister() may have unlinked a notifier and may
-	 * still be calling out to it.	Additionally, other notifiers
-	 * may have been active via vmtruncate() et. al. Block here
-	 * to ensure that all notifier callouts for this mm have been
-	 * completed and the sptes are really cleaned up before returning
-	 * to exit_mmap().
+	 * synchronize_srcu here prevents mmu_notifier_release from returning to
+	 * exit_mmap (which would proceed with freeing all pages in the mm)
+	 * until the ->release method returns, if it was invoked by
+	 * mmu_notifier_unregister.
+	 *
+	 * The mmu_notifier_mm can't go away from under us because one mm_count
+	 * is held by exit_mmap.
 	 */
 	synchronize_srcu(&srcu);
 }
@@ -302,31 +299,34 @@ void mmu_notifier_unregister(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	BUG_ON(atomic_read(&mm->mm_count) <= 0);
 
-	spin_lock(&mm->mmu_notifier_mm->lock);
 	if (!hlist_unhashed(&mn->hlist)) {
+		/*
+		 * SRCU here will force exit_mmap to wait for ->release to
+		 * finish before freeing the pages.
+		 */
 		int id;
 
+		id = srcu_read_lock(&srcu);
 		/*
-		 * Ensure we synchronize up with __mmu_notifier_release().
+		 * exit_mmap will block in mmu_notifier_release to guarantee
+		 * that ->release is called before freeing the pages.
 		 */
-		id = srcu_read_lock(&srcu);
-
-		hlist_del_rcu(&mn->hlist);
-		spin_unlock(&mm->mmu_notifier_mm->lock);
-
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
+		srcu_read_unlock(&srcu, id);
 
+		spin_lock(&mm->mmu_notifier_mm->lock);
 		/*
-		 * Allow __mmu_notifier_release() to complete.
+		 * Can not use list_del_rcu() since __mmu_notifier_release
+		 * can delete it before we hold the lock.
 		 */
-		srcu_read_unlock(&srcu, id);
-	} else
+		hlist_del_init_rcu(&mn->hlist);
 		spin_unlock(&mm->mmu_notifier_mm->lock);
+	}
 
 	/*
-	 * Wait for any running method to finish, including ->release() if it
-	 * was run by __mmu_notifier_release() instead of us.
+	 * Wait for any running method to finish, of course including
+	 * ->release if it was run by mmu_notifier_relase instead of us.
 	 */
 	synchronize_srcu(&srcu);
 
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 6c118d0..449cad6 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -127,28 +127,7 @@ static int walk_hugetlb_range(struct vm_area_struct *vma,
 	return 0;
 }
 
-static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
-{
-	struct vm_area_struct *vma;
-
-	/* We don't need vma lookup at all. */
-	if (!walk->hugetlb_entry)
-		return NULL;
-
-	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
-	vma = find_vma(walk->mm, addr);
-	if (vma && vma->vm_start <= addr && is_vm_hugetlb_page(vma))
-		return vma;
-
-	return NULL;
-}
-
 #else /* CONFIG_HUGETLB_PAGE */
-static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
-{
-	return NULL;
-}
-
 static int walk_hugetlb_range(struct vm_area_struct *vma,
 			      unsigned long addr, unsigned long end,
 			      struct mm_walk *walk)
@@ -198,30 +177,53 @@ int walk_page_range(unsigned long addr, unsigned long end,
 	if (!walk->mm)
 		return -EINVAL;
 
+	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
+
 	pgd = pgd_offset(walk->mm, addr);
 	do {
-		struct vm_area_struct *vma;
+		struct vm_area_struct *vma = NULL;
 
 		next = pgd_addr_end(addr, end);
 
 		/*
-		 * handle hugetlb vma individually because pagetable walk for
-		 * the hugetlb page is dependent on the architecture and
-		 * we can't handled it in the same manner as non-huge pages.
+		 * This function was not intended to be vma based.
+		 * But there are vma special cases to be handled:
+		 * - hugetlb vma's
+		 * - VM_PFNMAP vma's
 		 */
-		vma = hugetlb_vma(addr, walk);
+		vma = find_vma(walk->mm, addr);
 		if (vma) {
-			if (vma->vm_end < next)
+			/*
+			 * There are no page structures backing a VM_PFNMAP
+			 * range, so do not allow split_huge_page_pmd().
+			 */
+			if ((vma->vm_start <= addr) &&
+			    (vma->vm_flags & VM_PFNMAP)) {
 				next = vma->vm_end;
+				pgd = pgd_offset(walk->mm, next);
+				continue;
+			}
 			/*
-			 * Hugepage is very tightly coupled with vma, so
-			 * walk through hugetlb entries within a given vma.
+			 * Handle hugetlb vma individually because pagetable
+			 * walk for the hugetlb page is dependent on the
+			 * architecture and we can't handled it in the same
+			 * manner as non-huge pages.
 			 */
-			err = walk_hugetlb_range(vma, addr, next, walk);
-			if (err)
-				break;
-			pgd = pgd_offset(walk->mm, next);
-			continue;
+			if (walk->hugetlb_entry && (vma->vm_start <= addr) &&
+			    is_vm_hugetlb_page(vma)) {
+				if (vma->vm_end < next)
+					next = vma->vm_end;
+				/*
+				 * Hugepage is very tightly coupled with vma,
+				 * so walk through hugetlb entries within a
+				 * given vma.
+				 */
+				err = walk_hugetlb_range(vma, addr, next, walk);
+				if (err)
+					break;
+				pgd = pgd_offset(walk->mm, next);
+				continue;
+			}
 		}
 
 		if (pgd_none_or_clear_bad(pgd)) {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 064384c..1914a65 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2861,6 +2861,9 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			 * and location updates. Note that mac80211
 			 * itself never looks at these frames.
 			 */
+			if (!multicast &&
+			    !ether_addr_equal(sdata->vif.addr, hdr->addr1))
+				return 0;
 			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN) &&
 			    ieee80211_is_public_action(hdr, skb->len))
 				return 1;
diff --git a/net/netfilter/ipvs/ip_vs_pe_sip.c b/net/netfilter/ipvs/ip_vs_pe_sip.c
index 1aa5cac..55add93 100644
--- a/net/netfilter/ipvs/ip_vs_pe_sip.c
+++ b/net/netfilter/ipvs/ip_vs_pe_sip.c
@@ -37,14 +37,10 @@ static int get_callid(const char *dptr, unsigned int dataoff,
 		if (ret > 0)
 			break;
 		if (!ret)
-			return 0;
+			return -EINVAL;
 		dataoff += *matchoff;
 	}
 
-	/* Empty callid is useless */
-	if (!*matchlen)
-		return -EINVAL;
-
 	/* Too large is useless */
 	if (*matchlen > IP_VS_PEDATA_MAXLEN)
 		return -EINVAL;
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 72d89e1..c393017 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -302,13 +302,20 @@ EXPORT_SYMBOL_GPL(__rpc_wait_for_completion_task);
 /*
  * Make an RPC task runnable.
  *
- * Note: If the task is ASYNC, this must be called with
- * the spinlock held to protect the wait queue operation.
+ * Note: If the task is ASYNC, and is being made runnable after sitting on an
+ * rpc_wait_queue, this must be called with the queue spinlock held to protect
+ * the wait queue operation.
+ * Note the ordering of rpc_test_and_set_running() and rpc_clear_queued(),
+ * which is needed to ensure that __rpc_execute() doesn't loop (due to the
+ * lockless RPC_IS_QUEUED() test) before we've had a chance to test
+ * the RPC_TASK_RUNNING flag.
  */
 static void rpc_make_runnable(struct rpc_task *task)
 {
+	bool need_wakeup = !rpc_test_and_set_running(task);
+
 	rpc_clear_queued(task);
-	if (rpc_test_and_set_running(task))
+	if (!need_wakeup)
 		return;
 	if (RPC_IS_ASYNC(task)) {
 		INIT_WORK(&task->u.tk_work, rpc_async_schedule);
diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index a3b2631..539e2f3 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -88,7 +88,7 @@ static const struct reg_default cs42l52_reg_defaults[] = {
 	{ CS42L52_BEEP_VOL, 0x00 },	/* r1D Beep Volume off Time */
 	{ CS42L52_BEEP_TONE_CTL, 0x00 },	/* r1E Beep Tone Cfg. */
 	{ CS42L52_TONE_CTL, 0x00 },	/* r1F Tone Ctl */
-	{ CS42L52_MASTERA_VOL, 0x88 },	/* r20 Master A Volume */
+	{ CS42L52_MASTERA_VOL, 0x00 },	/* r20 Master A Volume */
 	{ CS42L52_MASTERB_VOL, 0x00 },	/* r21 Master B Volume */
 	{ CS42L52_HPA_VOL, 0x00 },	/* r22 Headphone A Volume */
 	{ CS42L52_HPB_VOL, 0x00 },	/* r23 Headphone B Volume */
diff --git a/tools/perf/scripts/python/net_dropmonitor.py b/tools/perf/scripts/python/net_dropmonitor.py
index a4ffc95..4c11605 100755
--- a/tools/perf/scripts/python/net_dropmonitor.py
+++ b/tools/perf/scripts/python/net_dropmonitor.py
@@ -40,9 +40,9 @@ def get_kallsyms_table():
 
 def get_sym(sloc):
 	loc = int(sloc)
-	for i in kallsyms:
-		if (i['loc'] >= loc):
-			return (i['name'], i['loc']-loc)
+	for i in kallsyms[::-1]:
+		if loc >= i['loc']:
+			return (i['name'], loc - i['loc'])
 	return (None, 0)
 
 def print_drop_table():
@@ -64,7 +64,7 @@ def trace_end():
 
 # called from perf, when it finds a correspoinding event
 def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm,
-			skbaddr, protocol, location):
+		   skbaddr, location, protocol):
 	slocation = str(location)
 	try:
 		drop_log[slocation] = drop_log[slocation] + 1
