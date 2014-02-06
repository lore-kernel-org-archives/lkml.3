Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaBFBfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 20:35:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:39609 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaBFBfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 20:35:36 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH-next] powerpc: delete old PrPMC 280/2800 support
Date: Wed, 5 Feb 2014 20:35:13 -0500
Message-ID: <1391650513-4577-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This processor/memory module was mostly used on ATCA blades and
before that, on cPCI blades.  It wasn't really user friendly, with
custom non u-boot bootloaders (powerboot/motload) and no real way
to recover corrupted boot flash (which was a common problem).

As such, it had its day back before the big ppc --> powerpc move
to device trees, and that was largely through commercial BSPs that
started to dry up around 2007.

Systems using one were largely in a "deploy and sustain" mode,
so interest in upgrading to new kernels in the field was nil.
Also, requiring 50A, 48V power supplies and a 2'x2'x2' ATCA
chassis largely rules out any hobbyist/enthusiast interest.

The point of all this, is that we might as well delete the in
kernel files relating to this platform.  No point in continuing
to build it via walking the defconfigs or via linux-next testing.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[The above description is not idle speculation based on 2nd hand
info -- I personally suffered with these platforms, and when faced
with a chance to take some for free vs. letting them go to e-waste,
I happily chose the latter option.   So lets get this out early in
the 3.15 cycle so any objections have a full window to appear.  ]

 arch/powerpc/boot/Makefile                     |   5 +-
 arch/powerpc/configs/prpmc2800_defconfig       | 108 -----------------
 arch/powerpc/platforms/embedded6xx/Kconfig     |   8 --
 arch/powerpc/platforms/embedded6xx/Makefile    |   1 -
 arch/powerpc/platforms/embedded6xx/prpmc2800.c | 156 -------------------------
 5 files changed, 2 insertions(+), 276 deletions(-)
 delete mode 100644 arch/powerpc/configs/prpmc2800_defconfig
 delete mode 100644 arch/powerpc/platforms/embedded6xx/prpmc2800.c

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 90e9d9548660..a1f8c7f1ec60 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -54,7 +54,7 @@ zlib       := inffast.c inflate.c inftrees.c
 zlibheader := inffast.h inffixed.h inflate.h inftrees.h infutil.h
 zliblinuxheader := zlib.h zconf.h zutil.h
 
-$(addprefix $(obj)/,$(zlib) cuboot-c2k.o gunzip_util.o main.o prpmc2800.o): \
+$(addprefix $(obj)/,$(zlib) cuboot-c2k.o gunzip_util.o main.o): \
 	$(addprefix $(obj)/,$(zliblinuxheader)) $(addprefix $(obj)/,$(zlibheader))
 
 libfdt       := fdt.c fdt_ro.c fdt_wip.c fdt_sw.c fdt_rw.c fdt_strerror.c
@@ -95,7 +95,7 @@ src-plat-$(CONFIG_FSL_SOC_BOOKE) += cuboot-85xx.c cuboot-85xx-cpm2.c
 src-plat-$(CONFIG_EMBEDDED6xx) += cuboot-pq2.c cuboot-mpc7448hpc2.c \
 					cuboot-c2k.c gamecube-head.S \
 					gamecube.c wii-head.S wii.c holly.c \
-					prpmc2800.c fixed-head.S mvme5100.c
+					fixed-head.S mvme5100.c
 src-plat-$(CONFIG_AMIGAONE) += cuboot-amigaone.c
 src-plat-$(CONFIG_PPC_PS3) += ps3-head.S ps3-hvcall.S ps3.c
 src-plat-$(CONFIG_EPAPR_BOOT) += epapr.c epapr-wrapper.c
@@ -204,7 +204,6 @@ image-$(CONFIG_PPC_CHRP)		+= zImage.chrp
 image-$(CONFIG_PPC_EFIKA)		+= zImage.chrp
 image-$(CONFIG_PPC_PMAC)		+= zImage.pmac
 image-$(CONFIG_PPC_HOLLY)		+= dtbImage.holly
-image-$(CONFIG_PPC_PRPMC2800)		+= dtbImage.prpmc2800
 image-$(CONFIG_DEFAULT_UIMAGE)		+= uImage
 image-$(CONFIG_EPAPR_BOOT)		+= zImage.epapr
 
diff --git a/arch/powerpc/configs/prpmc2800_defconfig b/arch/powerpc/configs/prpmc2800_defconfig
deleted file mode 100644
index cd80fb615d34..000000000000
--- a/arch/powerpc/configs/prpmc2800_defconfig
+++ /dev/null
@@ -1,108 +0,0 @@
-CONFIG_ALTIVEC=y
-CONFIG_EXPERIMENTAL=y
-CONFIG_SYSVIPC=y
-CONFIG_POSIX_MQUEUE=y
-CONFIG_LOG_BUF_SHIFT=14
-CONFIG_BLK_DEV_INITRD=y
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-# CONFIG_BLK_DEV_BSG is not set
-# CONFIG_IOSCHED_DEADLINE is not set
-# CONFIG_IOSCHED_CFQ is not set
-# CONFIG_PPC_CHRP is not set
-# CONFIG_PPC_PMAC is not set
-CONFIG_EMBEDDED6xx=y
-CONFIG_PPC_PRPMC2800=y
-CONFIG_HIGHMEM=y
-CONFIG_NO_HZ=y
-CONFIG_HIGH_RES_TIMERS=y
-CONFIG_BINFMT_MISC=y
-CONFIG_SPARSE_IRQ=y
-# CONFIG_SECCOMP is not set
-CONFIG_NET=y
-CONFIG_PACKET=y
-CONFIG_UNIX=y
-CONFIG_XFRM_USER=y
-CONFIG_INET=y
-CONFIG_IP_MULTICAST=y
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-CONFIG_IP_PNP_BOOTP=y
-CONFIG_SYN_COOKIES=y
-# CONFIG_IPV6 is not set
-CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
-CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
-CONFIG_MTD_BLOCK=y
-CONFIG_MTD_CFI=y
-CONFIG_MTD_JEDECPROBE=y
-CONFIG_MTD_CFI_INTELEXT=y
-CONFIG_MTD_PHYSMAP_OF=y
-CONFIG_PROC_DEVICETREE=y
-CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_SIZE=131072
-CONFIG_IDE=y
-CONFIG_BLK_DEV_GENERIC=y
-CONFIG_BLK_DEV_PDC202XX_NEW=y
-CONFIG_BLK_DEV_SD=y
-CONFIG_ATA=y
-CONFIG_SATA_MV=y
-CONFIG_MACINTOSH_DRIVERS=y
-CONFIG_NETDEVICES=y
-CONFIG_NET_ETHERNET=y
-CONFIG_NET_PCI=y
-CONFIG_E100=y
-CONFIG_8139TOO=y
-# CONFIG_8139TOO_PIO is not set
-CONFIG_E1000=y
-CONFIG_MV643XX_ETH=y
-# CONFIG_INPUT_KEYBOARD is not set
-# CONFIG_INPUT_MOUSE is not set
-# CONFIG_SERIO is not set
-CONFIG_SERIAL_MPSC=y
-CONFIG_SERIAL_MPSC_CONSOLE=y
-# CONFIG_HW_RANDOM is not set
-CONFIG_I2C=y
-CONFIG_I2C_CHARDEV=y
-CONFIG_I2C_MV64XXX=y
-CONFIG_VIDEO_OUTPUT_CONTROL=y
-CONFIG_HID_DRAGONRISE=y
-CONFIG_HID_GYRATION=y
-CONFIG_HID_TWINHAN=y
-CONFIG_HID_NTRIG=y
-CONFIG_HID_ORTEK=y
-CONFIG_HID_PANTHERLORD=y
-CONFIG_HID_PETALYNX=y
-CONFIG_HID_SAMSUNG=y
-CONFIG_HID_SONY=y
-CONFIG_HID_SUNPLUS=y
-CONFIG_HID_GREENASIA=y
-CONFIG_HID_SMARTJOYPLUS=y
-CONFIG_HID_TOPSEED=y
-CONFIG_HID_THRUSTMASTER=y
-CONFIG_THRUSTMASTER_FF=y
-CONFIG_HID_ZEROPLUS=y
-CONFIG_ZEROPLUS_FF=y
-CONFIG_USB=y
-CONFIG_USB_DEVICEFS=y
-# CONFIG_USB_DEVICE_CLASS is not set
-CONFIG_USB_MON=y
-CONFIG_USB_EHCI_HCD=y
-CONFIG_USB_OHCI_HCD=y
-CONFIG_RTC_CLASS=y
-CONFIG_RTC_DRV_MAX6900=y
-CONFIG_EXT2_FS=y
-CONFIG_EXT3_FS=y
-# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
-CONFIG_INOTIFY=y
-CONFIG_PROC_KCORE=y
-CONFIG_TMPFS=y
-CONFIG_NFS_FS=y
-CONFIG_ROOT_NFS=y
-CONFIG_PARTITION_ADVANCED=y
-CONFIG_CRC_T10DIF=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/powerpc/platforms/embedded6xx/Kconfig b/arch/powerpc/platforms/embedded6xx/Kconfig
index 6d3c7a9fd047..3fdc8bc6258f 100644
--- a/arch/powerpc/platforms/embedded6xx/Kconfig
+++ b/arch/powerpc/platforms/embedded6xx/Kconfig
@@ -49,14 +49,6 @@ config PPC_HOLLY
 	  Select PPC_HOLLY if configuring for an IBM 750GX/CL Eval
 	  Board with TSI108/9 bridge (Hickory/Holly)
 
-config PPC_PRPMC2800
-	bool "Motorola-PrPMC2800"
-	depends on EMBEDDED6xx
-	select MV64X60
-	select NOT_COHERENT_CACHE
-	help
-	  This option enables support for the Motorola PrPMC2800 board
-
 config PPC_C2K
 	bool "SBS/GEFanuc C2K board"
 	depends on EMBEDDED6xx
diff --git a/arch/powerpc/platforms/embedded6xx/Makefile b/arch/powerpc/platforms/embedded6xx/Makefile
index cdd48d402b93..f126a2a09981 100644
--- a/arch/powerpc/platforms/embedded6xx/Makefile
+++ b/arch/powerpc/platforms/embedded6xx/Makefile
@@ -5,7 +5,6 @@ obj-$(CONFIG_MPC7448HPC2)	+= mpc7448_hpc2.o
 obj-$(CONFIG_LINKSTATION)	+= linkstation.o ls_uart.o
 obj-$(CONFIG_STORCENTER)	+= storcenter.o
 obj-$(CONFIG_PPC_HOLLY)		+= holly.o
-obj-$(CONFIG_PPC_PRPMC2800)	+= prpmc2800.o
 obj-$(CONFIG_PPC_C2K)		+= c2k.o
 obj-$(CONFIG_USBGECKO_UDBG)	+= usbgecko_udbg.o
 obj-$(CONFIG_GAMECUBE_COMMON)	+= flipper-pic.o
diff --git a/arch/powerpc/platforms/embedded6xx/prpmc2800.c b/arch/powerpc/platforms/embedded6xx/prpmc2800.c
deleted file mode 100644
index d455f08bea53..000000000000
--- a/arch/powerpc/platforms/embedded6xx/prpmc2800.c
+++ /dev/null
@@ -1,156 +0,0 @@
-/*
- * Board setup routines for the Motorola PrPMC2800
- *
- * Author: Dale Farnsworth <dale@farnsworth.org>
- *
- * 2007 (c) MontaVista, Software, Inc.  This file is licensed under
- * the terms of the GNU General Public License version 2.  This program
- * is licensed "as is" without any warranty of any kind, whether express
- * or implied.
- */
-
-#include <linux/stddef.h>
-#include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/interrupt.h>
-#include <linux/seq_file.h>
-
-#include <asm/machdep.h>
-#include <asm/prom.h>
-#include <asm/time.h>
-
-#include <mm/mmu_decl.h>
-
-#include <sysdev/mv64x60.h>
-
-#define MV64x60_MPP_CNTL_0	0x0000
-#define MV64x60_MPP_CNTL_2	0x0008
-
-#define MV64x60_GPP_IO_CNTL	0x0000
-#define MV64x60_GPP_LEVEL_CNTL	0x0010
-#define MV64x60_GPP_VALUE_SET	0x0018
-
-#define PLATFORM_NAME_MAX	32
-
-static char prpmc2800_platform_name[PLATFORM_NAME_MAX];
-
-static void __iomem *mv64x60_mpp_reg_base;
-static void __iomem *mv64x60_gpp_reg_base;
-
-static void __init prpmc2800_setup_arch(void)
-{
-	struct device_node *np;
-	phys_addr_t paddr;
-	const unsigned int *reg;
-
-	/*
-	 * ioremap mpp and gpp registers in case they are later
-	 * needed by prpmc2800_reset_board().
-	 */
-	np = of_find_compatible_node(NULL, NULL, "marvell,mv64360-mpp");
-	reg = of_get_property(np, "reg", NULL);
-	paddr = of_translate_address(np, reg);
-	of_node_put(np);
-	mv64x60_mpp_reg_base = ioremap(paddr, reg[1]);
-
-	np = of_find_compatible_node(NULL, NULL, "marvell,mv64360-gpp");
-	reg = of_get_property(np, "reg", NULL);
-	paddr = of_translate_address(np, reg);
-	of_node_put(np);
-	mv64x60_gpp_reg_base = ioremap(paddr, reg[1]);
-
-#ifdef CONFIG_PCI
-	mv64x60_pci_init();
-#endif
-
-	printk("Motorola %s\n", prpmc2800_platform_name);
-}
-
-static void prpmc2800_reset_board(void)
-{
-	u32 temp;
-
-	local_irq_disable();
-
-	temp = in_le32(mv64x60_mpp_reg_base + MV64x60_MPP_CNTL_0);
-	temp &= 0xFFFF0FFF;
-	out_le32(mv64x60_mpp_reg_base + MV64x60_MPP_CNTL_0, temp);
-
-	temp = in_le32(mv64x60_gpp_reg_base + MV64x60_GPP_LEVEL_CNTL);
-	temp |= 0x00000004;
-	out_le32(mv64x60_gpp_reg_base + MV64x60_GPP_LEVEL_CNTL, temp);
-
-	temp = in_le32(mv64x60_gpp_reg_base + MV64x60_GPP_IO_CNTL);
-	temp |= 0x00000004;
-	out_le32(mv64x60_gpp_reg_base + MV64x60_GPP_IO_CNTL, temp);
-
-	temp = in_le32(mv64x60_mpp_reg_base + MV64x60_MPP_CNTL_2);
-	temp &= 0xFFFF0FFF;
-	out_le32(mv64x60_mpp_reg_base + MV64x60_MPP_CNTL_2, temp);
-
-	temp = in_le32(mv64x60_gpp_reg_base + MV64x60_GPP_LEVEL_CNTL);
-	temp |= 0x00080000;
-	out_le32(mv64x60_gpp_reg_base + MV64x60_GPP_LEVEL_CNTL, temp);
-
-	temp = in_le32(mv64x60_gpp_reg_base + MV64x60_GPP_IO_CNTL);
-	temp |= 0x00080000;
-	out_le32(mv64x60_gpp_reg_base + MV64x60_GPP_IO_CNTL, temp);
-
-	out_le32(mv64x60_gpp_reg_base + MV64x60_GPP_VALUE_SET, 0x00080004);
-}
-
-static void prpmc2800_restart(char *cmd)
-{
-	volatile ulong i = 10000000;
-
-	prpmc2800_reset_board();
-
-	while (i-- > 0);
-	panic("restart failed\n");
-}
-
-#ifdef CONFIG_NOT_COHERENT_CACHE
-#define PPRPM2800_COHERENCY_SETTING "off"
-#else
-#define PPRPM2800_COHERENCY_SETTING "on"
-#endif
-
-void prpmc2800_show_cpuinfo(struct seq_file *m)
-{
-	seq_printf(m, "Vendor\t\t: Motorola\n");
-	seq_printf(m, "coherency\t: %s\n", PPRPM2800_COHERENCY_SETTING);
-}
-
-/*
- * Called very early, device-tree isn't unflattened
- */
-static int __init prpmc2800_probe(void)
-{
-	unsigned long root = of_get_flat_dt_root();
-	unsigned long len = PLATFORM_NAME_MAX;
-	void *m;
-
-	if (!of_flat_dt_is_compatible(root, "motorola,PrPMC2800"))
-		return 0;
-
-	/* Update ppc_md.name with name from dt */
-	m = of_get_flat_dt_prop(root, "model", &len);
-	if (m)
-		strncpy(prpmc2800_platform_name, m,
-			min((int)len, PLATFORM_NAME_MAX - 1));
-
-	_set_L2CR(_get_L2CR() | L2CR_L2E);
-	return 1;
-}
-
-define_machine(prpmc2800){
-	.name			= prpmc2800_platform_name,
-	.probe			= prpmc2800_probe,
-	.setup_arch		= prpmc2800_setup_arch,
-	.init_early		= mv64x60_init_early,
-	.show_cpuinfo		= prpmc2800_show_cpuinfo,
-	.init_IRQ		= mv64x60_init_irq,
-	.get_irq		= mv64x60_get_irq,
-	.restart		= prpmc2800_restart,
-	.calibrate_decr		= generic_calibrate_decr,
-};
-- 
1.8.5.2

