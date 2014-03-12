Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbaCLPzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:55:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:58990 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaCLPza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:55:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: mmp: allow platform devices with modular USB
Date: Wed, 12 Mar 2014 16:55:24 +0100
Message-ID: <5101681.pZMdJoGtZk@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:PjZt5HQb0/eKsu0v8zYGsdCaVKHtT5KkUWCLDKpn35g
 pBcFI7fgjgiMdqEqEvvv4svqRH5Qc+tyVA+Y++kYAVbyLqHVl4
 FW2+3WepaZznljmsfzyvaceBNbzBrH8AoxxkXXXyuJ9A0bqQfe
 YnnsgFnLjGfNeAQk/2xGl8HgPKeNTi4OhLHcPbo0HR/uW+60b7
 uYH61kC97oYfZ9Rr7xGkx3NGxcfkzVR9nk74B/61fA7Mhm0O13
 opkefssXiUA4i0xlaKU3szDZHTBI2ZZULfJAIxkT3Oq+ZNn74G
 EHai5ENVaznh3TSDS55/FIOI19hqIHtlmuo9r9DxVl91mIePge
 V9I7EWmiVH7AN5EnLcZs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB host drivers need platform data to be defined on
pxa168 and pxa910, but the conditionals used in the devices.c
file only work if the drivers are built-in. This patch
fixes the definition by changing the #ifdef to #if IS_ENABLED(),
which works both for built-in and modular Kconfig symbols.

I found one specific problem using 'randconfig' builds, but
for consistency, this patch uses IS_ENABLED() for all Kconfig
symbols in these three files.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/mach-mmp/aspenite.c b/arch/arm/mach-mmp/aspenite.c
index 0c00209..7e02485 100644
--- a/arch/arm/mach-mmp/aspenite.c
+++ b/arch/arm/mach-mmp/aspenite.c
@@ -231,7 +231,7 @@ static struct pxa27x_keypad_platform_data aspenite_keypad_info __initdata = {
 	.debounce_interval	= 30,
 };
 
-#if defined(CONFIG_USB_EHCI_MV)
+#if IS_ENABLED(CONFIG_USB_EHCI_MV)
 static struct mv_usb_platform_data pxa168_sph_pdata = {
 	.mode           = MV_USB_MODE_HOST,
 	.phy_init	= pxa_usb_phy_init,
@@ -258,7 +258,7 @@ static void __init common_init(void)
 	/* off-chip devices */
 	platform_device_register(&smc91x_device);
 
-#if defined(CONFIG_USB_EHCI_MV)
+#if IS_ENABLED(CONFIG_USB_EHCI_MV)
 	pxa168_add_usb_host(&pxa168_sph_pdata);
 #endif
 }
diff --git a/arch/arm/mach-mmp/devices.c b/arch/arm/mach-mmp/devices.c
index dd2d8b1..2bcb766 100644
--- a/arch/arm/mach-mmp/devices.c
+++ b/arch/arm/mach-mmp/devices.c
@@ -72,7 +72,7 @@ int __init pxa_register_device(struct pxa_device_desc *desc,
 	return platform_device_add(pdev);
 }
 
-#if defined(CONFIG_USB) || defined(CONFIG_USB_GADGET)
+#if IS_ENABLED(CONFIG_USB) || IS_ENABLED(CONFIG_USB_GADGET)
 
 /*****************************************************************************
  * The registers read/write routines
@@ -112,9 +112,9 @@ static void u2o_write(void __iomem *base, unsigned int offset,
 	readl_relaxed(base + offset);
 }
 
-#if defined(CONFIG_USB_MV_UDC) || defined(CONFIG_USB_EHCI_MV)
+#if IS_ENABLED(CONFIG_USB_MV_UDC) || IS_ENABLED(CONFIG_USB_EHCI_MV)
 
-#if defined(CONFIG_CPU_PXA910) || defined(CONFIG_CPU_PXA168)
+#if IS_ENABLED(CONFIG_CPU_PXA910) || IS_ENABLED(CONFIG_CPU_PXA168)
 
 static DEFINE_MUTEX(phy_lock);
 static int phy_init_cnt;
@@ -238,10 +238,10 @@ void pxa_usb_phy_deinit(void __iomem *phy_reg)
 #endif
 #endif
 
-#ifdef CONFIG_USB_SUPPORT
+#if IS_ENABLED(CONFIG_USB_SUPPORT)
 static u64 usb_dma_mask = ~(u32)0;
 
-#ifdef CONFIG_USB_MV_UDC
+#if IS_ENABLED(CONFIG_USB_MV_UDC)
 struct resource pxa168_u2o_resources[] = {
 	/* regbase */
 	[0] = {
@@ -276,7 +276,7 @@ struct platform_device pxa168_device_u2o = {
 };
 #endif /* CONFIG_USB_MV_UDC */
 
-#ifdef CONFIG_USB_EHCI_MV_U2O
+#if IS_ENABLED(CONFIG_USB_EHCI_MV_U2O)
 struct resource pxa168_u2oehci_resources[] = {
 	/* regbase */
 	[0] = {
@@ -312,7 +312,7 @@ struct platform_device pxa168_device_u2oehci = {
 };
 #endif
 
-#if defined(CONFIG_USB_MV_OTG)
+#if IS_ENABLED(CONFIG_USB_MV_OTG)
 struct resource pxa168_u2ootg_resources[] = {
 	/* regbase */
 	[0] = {
diff --git a/arch/arm/mach-mmp/ttc_dkb.c b/arch/arm/mach-mmp/ttc_dkb.c
index cfadd97..ac4af81 100644
--- a/arch/arm/mach-mmp/ttc_dkb.c
+++ b/arch/arm/mach-mmp/ttc_dkb.c
@@ -164,8 +164,8 @@ static struct i2c_board_info ttc_dkb_i2c_info[] = {
 	},
 };
 
-#ifdef CONFIG_USB_SUPPORT
-#if defined(CONFIG_USB_MV_UDC) || defined(CONFIG_USB_EHCI_MV_U2O)
+#if IS_ENABLED(CONFIG_USB_SUPPORT)
+#if IS_ENABLED(CONFIG_USB_MV_UDC) || IS_ENABLED(CONFIG_USB_EHCI_MV_U2O)
 
 static struct mv_usb_platform_data ttc_usb_pdata = {
 	.vbus		= NULL,
@@ -178,14 +178,14 @@ static struct mv_usb_platform_data ttc_usb_pdata = {
 #endif
 #endif
 
-#ifdef CONFIG_MTD_NAND_PXA3xx
+#if IS_ENABLED(CONFIG_MTD_NAND_PXA3xx)
 static struct pxa3xx_nand_platform_data dkb_nand_info = {
 	.enable_arbiter = 1,
 	.num_cs = 1,
 };
 #endif
 
-#ifdef CONFIG_MMP_DISP
+#if IS_ENABLED(CONFIG_MMP_DISP)
 /* path config */
 #define CFG_IOPADMODE(iopad)   (iopad)  /* 0x0 ~ 0xd */
 #define SCLK_SOURCE_SELECT(x)  (x << 30) /* 0x0 ~ 0x3 */
@@ -275,7 +275,7 @@ static void __init ttc_dkb_init(void)
 
 	/* on-chip devices */
 	pxa910_add_uart(1);
-#ifdef CONFIG_MTD_NAND_PXA3xx
+#if IS_ENABLED(CONFIG_MTD_NAND_PXA3xx)
 	pxa910_add_nand(&dkb_nand_info);
 #endif
 
@@ -285,22 +285,22 @@ static void __init ttc_dkb_init(void)
 				 sizeof(struct pxa_gpio_platform_data));
 	platform_add_devices(ARRAY_AND_SIZE(ttc_dkb_devices));
 
-#ifdef CONFIG_USB_MV_UDC
+#if IS_ENABLED(CONFIG_USB_MV_UDC)
 	pxa168_device_u2o.dev.platform_data = &ttc_usb_pdata;
 	platform_device_register(&pxa168_device_u2o);
 #endif
 
-#ifdef CONFIG_USB_EHCI_MV_U2O
+#if IS_ENABLED(CONFIG_USB_EHCI_MV_U2O)
 	pxa168_device_u2oehci.dev.platform_data = &ttc_usb_pdata;
 	platform_device_register(&pxa168_device_u2oehci);
 #endif
 
-#ifdef CONFIG_USB_MV_OTG
+#if IS_ENABLED(CONFIG_USB_MV_OTG)
 	pxa168_device_u2ootg.dev.platform_data = &ttc_usb_pdata;
 	platform_device_register(&pxa168_device_u2ootg);
 #endif
 
-#ifdef CONFIG_MMP_DISP
+#if IS_ENABLED(CONFIG_MMP_DISP)
 	add_disp();
 #endif
 }

