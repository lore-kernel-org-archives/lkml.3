Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935739Ab3IEKhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:37:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57877 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab3IEKhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:37:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.21
Date: Thu,  5 Sep 2013 11:37:31 +0100
Message-Id: <1378377451-17297-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378377451-17297-1-git-send-email-luis.henriques@canonical.com>
References: <1378377451-17297-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 4fdc06d..c724e1d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .20
+EXTRAVERSION = .21
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/alpha/Makefile b/arch/alpha/Makefile
index 4759fe7..2cc3cc5 100644
--- a/arch/alpha/Makefile
+++ b/arch/alpha/Makefile
@@ -12,7 +12,7 @@ NM := $(NM) -B
 
 LDFLAGS_vmlinux	:= -static -N #-relax
 CHECKFLAGS	+= -D__alpha__ -m64
-cflags-y	:= -pipe -mno-fp-regs -ffixed-8 -msmall-data
+cflags-y	:= -pipe -mno-fp-regs -ffixed-8
 cflags-y	+= $(call cc-option, -fno-jump-tables)
 
 cpuflags-$(CONFIG_ALPHA_EV4)		:= -mcpu=ev4
diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index f4e43e3..84d8bdb 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -14,11 +14,11 @@
 	compatible = "atmel,at91sam9n12ek", "atmel,at91sam9n12", "atmel,at91sam9";
 
 	chosen {
-		bootargs = "mem=128M console=ttyS0,115200 root=/dev/mtdblock1 rw rootfstype=jffs2";
+		bootargs = "console=ttyS0,115200 root=/dev/mtdblock1 rw rootfstype=jffs2";
 	};
 
 	memory {
-		reg = <0x20000000 0x10000000>;
+		reg = <0x20000000 0x8000000>;
 	};
 
 	clocks {
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 55790a5..54fbd46 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -109,7 +109,12 @@ armpmu_map_cache_event(const unsigned (*cache_map)
 static int
 armpmu_map_event(const unsigned (*event_map)[PERF_COUNT_HW_MAX], u64 config)
 {
-	int mapping = (*event_map)[config];
+	int mapping;
+
+	if (config >= PERF_COUNT_HW_MAX)
+		return -EINVAL;
+
+	mapping = (*event_map)[config];
 	return mapping == HW_OP_UNSUPPORTED ? -ENOENT : mapping;
 }
 
@@ -319,6 +324,9 @@ validate_event(struct pmu_hw_events *hw_events,
 	struct hw_perf_event fake_event = event->hw;
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
+	if (is_software_event(event))
+		return 1;
+
 	if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
 		return 1;
 
diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
index 8e77032..eeeb81f 100644
--- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -75,6 +75,7 @@ static struct davinci_nand_pdata davinci_nand_data = {
 	.parts			= davinci_nand_partitions,
 	.nr_parts		= ARRAY_SIZE(davinci_nand_partitions),
 	.ecc_mode		= NAND_ECC_HW_SYNDROME,
+	.ecc_bits		= 4,
 	.bbt_options		= NAND_BBT_USE_FLASH,
 };
 
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index d34ed55..87a904f 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -152,6 +152,7 @@ static struct davinci_nand_pdata davinci_evm_nandflash_data = {
 	.parts		= davinci_evm_nandflash_partition,
 	.nr_parts	= ARRAY_SIZE(davinci_evm_nandflash_partition),
 	.ecc_mode	= NAND_ECC_HW,
+	.ecc_bits	= 1,
 	.bbt_options	= NAND_BBT_USE_FLASH,
 	.timing		= &davinci_evm_nandflash_timing,
 };
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 958679a..5d4b51f 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -89,6 +89,7 @@ static struct davinci_nand_pdata davinci_nand_data = {
 	.parts			= davinci_nand_partitions,
 	.nr_parts		= ARRAY_SIZE(davinci_nand_partitions),
 	.ecc_mode		= NAND_ECC_HW,
+	.ecc_bits		= 1,
 	.options		= 0,
 };
 
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index 5de69f2..198289c 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -88,6 +88,7 @@ static struct davinci_nand_pdata davinci_ntosd2_nandflash_data = {
 	.parts		= davinci_ntosd2_nandflash_partition,
 	.nr_parts	= ARRAY_SIZE(davinci_ntosd2_nandflash_partition),
 	.ecc_mode	= NAND_ECC_HW,
+	.ecc_bits	= 1,
 	.bbt_options	= NAND_BBT_USE_FLASH,
 };
 
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 8d194df..6c5a533 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -768,15 +768,18 @@ config KUSER_HELPERS
 	  the CPU type fitted to the system.  This permits binaries to be
 	  run on ARMv4 through to ARMv7 without modification.
 
+	  See Documentation/arm/kernel_user_helpers.txt for details.
+
 	  However, the fixed address nature of these helpers can be used
 	  by ROP (return orientated programming) authors when creating
 	  exploits.
 
 	  If all of the binaries and libraries which run on your platform
 	  are built specifically for your platform, and make no use of
-	  these helpers, then you can turn this option off.  However,
-	  when such an binary or library is run, it will receive a SIGILL
-	  signal, which will terminate the program.
+	  these helpers, then you can turn this option off to hinder
+	  such exploits. However, in that case, if a binary or library
+	  relying on those helpers is run, it will receive a SIGILL signal,
+	  which will terminate the program.
 
 	  Say N here only if you are absolutely certain that you do not
 	  need these helpers; otherwise, the safe option is to say Y.
diff --git a/arch/m68k/emu/natfeat.c b/arch/m68k/emu/natfeat.c
index 2291a7d..fa277ae 100644
--- a/arch/m68k/emu/natfeat.c
+++ b/arch/m68k/emu/natfeat.c
@@ -18,9 +18,11 @@
 #include <asm/machdep.h>
 #include <asm/natfeat.h>
 
+extern long nf_get_id2(const char *feature_name);
+
 asm("\n"
-"	.global nf_get_id,nf_call\n"
-"nf_get_id:\n"
+"	.global nf_get_id2,nf_call\n"
+"nf_get_id2:\n"
 "	.short	0x7300\n"
 "	rts\n"
 "nf_call:\n"
@@ -29,12 +31,25 @@ asm("\n"
 "1:	moveq.l	#0,%d0\n"
 "	rts\n"
 "	.section __ex_table,\"a\"\n"
-"	.long	nf_get_id,1b\n"
+"	.long	nf_get_id2,1b\n"
 "	.long	nf_call,1b\n"
 "	.previous");
-EXPORT_SYMBOL_GPL(nf_get_id);
 EXPORT_SYMBOL_GPL(nf_call);
 
+long nf_get_id(const char *feature_name)
+{
+	/* feature_name may be in vmalloc()ed memory, so make a copy */
+	char name_copy[32];
+	size_t n;
+
+	n = strlcpy(name_copy, feature_name, sizeof(name_copy));
+	if (n >= sizeof(name_copy))
+		return 0;
+
+	return nf_get_id2(name_copy);
+}
+EXPORT_SYMBOL_GPL(nf_get_id);
+
 void nfprint(const char *fmt, ...)
 {
 	static char buf[256];
diff --git a/arch/m68k/include/asm/div64.h b/arch/m68k/include/asm/div64.h
index 444ea8a..ef881cf 100644
--- a/arch/m68k/include/asm/div64.h
+++ b/arch/m68k/include/asm/div64.h
@@ -15,16 +15,17 @@
 		unsigned long long n64;				\
 	} __n;							\
 	unsigned long __rem, __upper;				\
+	unsigned long __base = (base);				\
 								\
 	__n.n64 = (n);						\
 	if ((__upper = __n.n32[0])) {				\
 		asm ("divul.l %2,%1:%0"				\
-			: "=d" (__n.n32[0]), "=d" (__upper)	\
-			: "d" (base), "0" (__n.n32[0]));	\
+		     : "=d" (__n.n32[0]), "=d" (__upper)	\
+		     : "d" (__base), "0" (__n.n32[0]));		\
 	}							\
 	asm ("divu.l %2,%1:%0"					\
-		: "=d" (__n.n32[1]), "=d" (__rem)		\
-		: "d" (base), "1" (__upper), "0" (__n.n32[1]));	\
+	     : "=d" (__n.n32[1]), "=d" (__rem)			\
+	     : "d" (__base), "1" (__upper), "0" (__n.n32[1]));	\
 	(n) = __n.n64;						\
 	__rem;							\
 })
diff --git a/arch/microblaze/configs/mmu_defconfig b/arch/microblaze/configs/mmu_defconfig
index b3f5eec..d2b097a 100644
--- a/arch/microblaze/configs/mmu_defconfig
+++ b/arch/microblaze/configs/mmu_defconfig
@@ -1,25 +1,22 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
+CONFIG_POSIX_MQUEUE=y
+CONFIG_FHANDLE=y
+CONFIG_AUDIT=y
+CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
+CONFIG_SYSFS_DEPRECATED=y
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_BLK_DEV_INITRD=y
-CONFIG_INITRAMFS_SOURCE="rootfs.cpio"
-CONFIG_INITRAMFS_COMPRESSION_GZIP=y
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
-CONFIG_KALLSYMS_EXTRA_PASS=y
-# CONFIG_HOTPLUG is not set
 # CONFIG_BASE_FULL is not set
-# CONFIG_FUTEX is not set
-# CONFIG_EPOLL is not set
-# CONFIG_SIGNALFD is not set
-# CONFIG_SHMEM is not set
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
+CONFIG_PARTITION_ADVANCED=y
+# CONFIG_EFI_PARTITION is not set
 CONFIG_OPT_LIB_ASM=y
 CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR=1
 CONFIG_XILINX_MICROBLAZE0_USE_PCMP_INSTR=1
@@ -31,39 +28,62 @@ CONFIG_HZ_100=y
 CONFIG_MMU=y
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE_FORCE=y
+CONFIG_HIGHMEM=y
+CONFIG_PCI=y
+CONFIG_PCI_XILINX=y
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
 CONFIG_INET=y
 # CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
+CONFIG_MTD=y
 CONFIG_PROC_DEVICETREE=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
 CONFIG_NETDEVICES=y
-CONFIG_NET_ETHERNET=y
 CONFIG_XILINX_EMACLITE=y
+CONFIG_XILINX_LL_TEMAC=y
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_UARTLITE=y
 CONFIG_SERIAL_UARTLITE_CONSOLE=y
 # CONFIG_HW_RANDOM is not set
+CONFIG_XILINX_HWICAP=y
+CONFIG_I2C=y
+CONFIG_I2C_XILINX=y
+CONFIG_SPI=y
+CONFIG_SPI_XILINX=y
+CONFIG_GPIOLIB=y
+CONFIG_GPIO_SYSFS=y
+CONFIG_GPIO_XILINX=y
 # CONFIG_HWMON is not set
+CONFIG_WATCHDOG=y
+CONFIG_XILINX_WATCHDOG=y
+CONFIG_FB=y
+CONFIG_FB_XILINX=y
 # CONFIG_USB_SUPPORT is not set
+CONFIG_UIO=y
+CONFIG_UIO_PDRV=y
+CONFIG_UIO_PDRV_GENIRQ=y
+CONFIG_UIO_DMEM_GENIRQ=y
 CONFIG_EXT2_FS=y
 # CONFIG_DNOTIFY is not set
+CONFIG_CRAMFS=y
+CONFIG_ROMFS_FS=y
 CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
 CONFIG_CIFS=y
 CONFIG_CIFS_STATS=y
 CONFIG_CIFS_STATS2=y
-CONFIG_PARTITION_ADVANCED=y
-CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_DEBUG_SLAB=y
 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_INFO=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_EARLY_PRINTK=y
+CONFIG_KEYS=y
+CONFIG_ENCRYPTED_KEYS=y
+CONFIG_KEYS_DEBUG_PROC_KEYS=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/microblaze/configs/nommu_defconfig b/arch/microblaze/configs/nommu_defconfig
index 0249e4b..10b5172 100644
--- a/arch/microblaze/configs/nommu_defconfig
+++ b/arch/microblaze/configs/nommu_defconfig
@@ -1,41 +1,42 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
+CONFIG_FHANDLE=y
+CONFIG_AUDIT=y
+CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
+CONFIG_SYSFS_DEPRECATED=y
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
-CONFIG_KALLSYMS_EXTRA_PASS=y
-# CONFIG_HOTPLUG is not set
 # CONFIG_BASE_FULL is not set
+CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
-# CONFIG_OPT_LIB_FUNCTION is not set
+CONFIG_PARTITION_ADVANCED=y
+# CONFIG_EFI_PARTITION is not set
 CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR=1
 CONFIG_XILINX_MICROBLAZE0_USE_PCMP_INSTR=1
 CONFIG_XILINX_MICROBLAZE0_USE_BARREL=1
 CONFIG_XILINX_MICROBLAZE0_USE_DIV=1
 CONFIG_XILINX_MICROBLAZE0_USE_HW_MUL=2
 CONFIG_XILINX_MICROBLAZE0_USE_FPU=2
-CONFIG_HIGH_RES_TIMERS=y
 CONFIG_HZ_100=y
 CONFIG_CMDLINE_BOOL=y
-CONFIG_BINFMT_FLAT=y
+CONFIG_CMDLINE_FORCE=y
+CONFIG_PCI=y
+CONFIG_PCI_XILINX=y
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
 CONFIG_INET=y
 # CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
-# CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
@@ -45,41 +46,55 @@ CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_RAM=y
 CONFIG_MTD_UCLINUX=y
 CONFIG_PROC_DEVICETREE=y
-CONFIG_BLK_DEV_NBD=y
 CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_SIZE=8192
 CONFIG_NETDEVICES=y
-CONFIG_NET_ETHERNET=y
+CONFIG_XILINX_EMACLITE=y
+CONFIG_XILINX_LL_TEMAC=y
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_UARTLITE=y
 CONFIG_SERIAL_UARTLITE_CONSOLE=y
-CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM is not set
+CONFIG_XILINX_HWICAP=y
+CONFIG_I2C=y
+CONFIG_I2C_XILINX=y
+CONFIG_SPI=y
+CONFIG_SPI_XILINX=y
+CONFIG_GPIOLIB=y
+CONFIG_GPIO_SYSFS=y
+CONFIG_GPIO_XILINX=y
 # CONFIG_HWMON is not set
-CONFIG_VIDEO_OUTPUT_CONTROL=y
+CONFIG_WATCHDOG=y
+CONFIG_XILINX_WATCHDOG=y
+CONFIG_FB=y
+CONFIG_FB_XILINX=y
+# CONFIG_USB_SUPPORT is not set
+CONFIG_UIO=y
+CONFIG_UIO_PDRV=y
+CONFIG_UIO_PDRV_GENIRQ=y
+CONFIG_UIO_DMEM_GENIRQ=y
 CONFIG_EXT2_FS=y
 # CONFIG_DNOTIFY is not set
 CONFIG_CRAMFS=y
 CONFIG_ROMFS_FS=y
 CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
 CONFIG_NFS_V3_ACL=y
-CONFIG_UNUSED_SYMBOLS=y
-CONFIG_DEBUG_FS=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_SHIRQ=y
+CONFIG_NLS=y
 CONFIG_DETECT_HUNG_TASK=y
-CONFIG_SCHEDSTATS=y
-CONFIG_TIMER_STATS=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_SELFTEST=y
-CONFIG_DEBUG_OBJECTS_FREE=y
-CONFIG_DEBUG_OBJECTS_TIMERS=y
+CONFIG_DEBUG_SLAB=y
+CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_INFO=y
-CONFIG_DEBUG_LIST=y
-CONFIG_DEBUG_SG=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_EARLY_PRINTK=y
+CONFIG_KEYS=y
+CONFIG_ENCRYPTED_KEYS=y
+CONFIG_KEYS_DEBUG_PROC_KEYS=y
+CONFIG_CRYPTO_ECB=y
+CONFIG_CRYPTO_MD4=y
+CONFIG_CRYPTO_MD5=y
+CONFIG_CRYPTO_ARC4=y
+CONFIG_CRYPTO_DES=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
-# CONFIG_CRC32 is not set
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index b3e10fd..3811c84 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -25,6 +25,7 @@ config MIPS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_PCI_IOMAP
 	select HAVE_ARCH_JUMP_LABEL
 	select IRQ_FORCED_THREADING
 	select HAVE_MEMBLOCK
@@ -2353,7 +2354,6 @@ config PCI
 	bool "Support for PCI controller"
 	depends on HW_HAS_PCI
 	select PCI_DOMAINS
-	select GENERIC_PCI_IOMAP
 	select NO_GENERIC_PCI_IOPORT_MAP
 	help
 	  Find out whether you have a PCI motherboard. PCI is the name of a
diff --git a/arch/mips/include/asm/io.h b/arch/mips/include/asm/io.h
index 29d9c23..98ca652 100644
--- a/arch/mips/include/asm/io.h
+++ b/arch/mips/include/asm/io.h
@@ -169,6 +169,11 @@ static inline void * isa_bus_to_virt(unsigned long address)
 extern void __iomem * __ioremap(phys_t offset, phys_t size, unsigned long flags);
 extern void __iounmap(const volatile void __iomem *addr);
 
+#ifndef CONFIG_PCI
+struct pci_dev;
+static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr) {}
+#endif
+
 static inline void __iomem * __ioremap_mode(phys_t offset, unsigned long size,
 	unsigned long flags)
 {
diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index da9bd7d..ccb77ec 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -175,14 +175,13 @@ typedef struct { unsigned long pgprot; } pgprot_t;
 
 #ifdef CONFIG_FLATMEM
 
-#define pfn_valid(pfn)							\
-({									\
-	unsigned long __pfn = (pfn);					\
-	/* avoid <linux/bootmem.h> include hell */			\
-	extern unsigned long min_low_pfn;				\
-									\
-	__pfn >= min_low_pfn && __pfn < max_mapnr;			\
-})
+static inline int pfn_valid(unsigned long pfn)
+{
+	/* avoid <linux/mm.h> include hell */
+	extern unsigned long max_mapnr;
+
+	return pfn >= ARCH_PFN_OFFSET && pfn < max_mapnr;
+}
 
 #elif defined(CONFIG_SPARSEMEM)
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 4d8336c..74b6ce4 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -975,6 +975,7 @@ config RELOCATABLE
 	  must live at a different physical address than the primary
 	  kernel.
 
+# This value must have zeroes in the bottom 60 bits otherwise lots will break
 config PAGE_OFFSET
 	hex
 	default "0xc000000000000000"
diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index f072e97..2e6c4e5a 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -211,9 +211,19 @@ extern long long virt_phys_offset;
 #define __va(x) ((void *)(unsigned long)((phys_addr_t)(x) + VIRT_PHYS_OFFSET))
 #define __pa(x) ((unsigned long)(x) - VIRT_PHYS_OFFSET)
 #else
+#ifdef CONFIG_PPC64
+/*
+ * gcc miscompiles (unsigned long)(&static_var) - PAGE_OFFSET
+ * with -mcmodel=medium, so we use & and | instead of - and + on 64-bit.
+ */
+#define __va(x) ((void *)(unsigned long)((phys_addr_t)(x) | PAGE_OFFSET))
+#define __pa(x) ((unsigned long)(x) & 0x0fffffffffffffffUL)
+
+#else /* 32-bit, non book E */
 #define __va(x) ((void *)(unsigned long)((phys_addr_t)(x) + PAGE_OFFSET - MEMORY_START))
 #define __pa(x) ((unsigned long)(x) - PAGE_OFFSET + MEMORY_START)
 #endif
+#endif
 
 /*
  * Unfortunately the PLT is in the BSS in the PPC32 ELF ABI,
diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index f5725bc..7ebbae0 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -35,7 +35,13 @@
 #include <asm/vdso_datapage.h>
 #include <asm/vio.h>
 #include <asm/mmu.h>
+#include <asm/machdep.h>
 
+
+/*
+ * This isn't a module but we expose that to userspace
+ * via /proc so leave the definitions here
+ */
 #define MODULE_VERS "1.9"
 #define MODULE_NAME "lparcfg"
 
@@ -419,7 +425,8 @@ static void parse_em_data(struct seq_file *m)
 {
 	unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
 
-	if (plpar_hcall(H_GET_EM_PARMS, retbuf) == H_SUCCESS)
+	if (firmware_has_feature(FW_FEATURE_LPAR) &&
+	    plpar_hcall(H_GET_EM_PARMS, retbuf) == H_SUCCESS)
 		seq_printf(m, "power_mode_data=%016lx\n", retbuf[0]);
 }
 
@@ -678,7 +685,6 @@ static int lparcfg_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations lparcfg_fops = {
-	.owner		= THIS_MODULE,
 	.read		= seq_read,
 	.write		= lparcfg_write,
 	.open		= lparcfg_open,
@@ -704,15 +710,4 @@ static int __init lparcfg_init(void)
 	proc_ppc64_lparcfg = ent;
 	return 0;
 }
-
-static void __exit lparcfg_cleanup(void)
-{
-	if (proc_ppc64_lparcfg)
-		remove_proc_entry("lparcfg", proc_ppc64_lparcfg->parent);
-}
-
-module_init(lparcfg_init);
-module_exit(lparcfg_cleanup);
-MODULE_DESCRIPTION("Interface for LPAR configuration data");
-MODULE_AUTHOR("Dave Engebretsen");
-MODULE_LICENSE("GPL");
+machine_device_initcall(pseries, lparcfg_init);
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index b4d3c39..51534ef 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -115,7 +115,7 @@ static void find_start_end(unsigned long flags, unsigned long *begin,
 				*begin = new_begin;
 		}
 	} else {
-		*begin = TASK_UNMAPPED_BASE;
+		*begin = current->mm->mmap_legacy_base;
 		*end = TASK_SIZE;
 	}
 }
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 845df68..5c1ae28 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -112,12 +112,14 @@ static unsigned long mmap_legacy_base(void)
  */
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
+	mm->mmap_legacy_base = mmap_legacy_base();
+	mm->mmap_base = mmap_base();
+
 	if (mmap_is_legacy()) {
-		mm->mmap_base = mmap_legacy_base();
+		mm->mmap_base = mm->mmap_legacy_base;
 		mm->get_unmapped_area = arch_get_unmapped_area;
 		mm->unmap_area = arch_unmap_area;
 	} else {
-		mm->mmap_base = mmap_base();
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 		mm->unmap_area = arch_unmap_area_topdown;
 	}
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index c207fdb..1ba7725 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -318,6 +318,17 @@ static void xen_align_and_add_e820_region(u64 start, u64 size, int type)
 	e820_add_region(start, end - start, type);
 }
 
+void xen_ignore_unusable(struct e820entry *list, size_t map_size)
+{
+	struct e820entry *entry;
+	unsigned int i;
+
+	for (i = 0, entry = list; i < map_size; i++, entry++) {
+		if (entry->type == E820_UNUSABLE)
+			entry->type = E820_RAM;
+	}
+}
+
 /**
  * machine_specific_memory_setup - Hook for machine specific memory setup.
  **/
@@ -358,6 +369,17 @@ char * __init xen_memory_setup(void)
 	}
 	BUG_ON(rc);
 
+	/*
+	 * Xen won't allow a 1:1 mapping to be created to UNUSABLE
+	 * regions, so if we're using the machine memory map leave the
+	 * region as RAM as it is in the pseudo-physical map.
+	 *
+	 * UNUSABLE regions in domUs are not handled and will need
+	 * a patch in the future.
+	 */
+	if (xen_initial_domain())
+		xen_ignore_unusable(map, memmap.nr_entries);
+
 	/* Make sure the Xen-supplied memory map is well-ordered. */
 	sanitize_e820_map(map, memmap.nr_entries, &memmap.nr_entries);
 
diff --git a/arch/xtensa/kernel/Makefile b/arch/xtensa/kernel/Makefile
index 59fc3fe..0f9f35f 100644
--- a/arch/xtensa/kernel/Makefile
+++ b/arch/xtensa/kernel/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_MODULES) += xtensa_ksyms.o module.o
 # Replicate rules in scripts/Makefile.build
 
 sed-y = -e 's/\*(\(\.[a-z]*it\|\.ref\|\)\.text)/*(\1.literal \1.text)/g'    \
+	-e 's/\.text\.unlikely/.literal.unlikely .text.unlikely/g' \
 	-e 's/\*(\(\.text\.[a-z]*\))/*(\1.literal \1)/g'
 
 quiet_cmd__cpp_lds_S = LDS     $@
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index f63a588..f5c35be 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -289,24 +289,24 @@ static int sata_pmp_configure(struct ata_device *dev, int print_info)
 
 	/* Disable sending Early R_OK.
 	 * With "cached read" HDD testing and multiple ports busy on a SATA
-	 * host controller, 3726 PMP will very rarely drop a deferred
+	 * host controller, 3x26 PMP will very rarely drop a deferred
 	 * R_OK that was intended for the host. Symptom will be all
 	 * 5 drives under test will timeout, get reset, and recover.
 	 */
-	if (vendor == 0x1095 && devid == 0x3726) {
+	if (vendor == 0x1095 && (devid == 0x3726 || devid == 0x3826)) {
 		u32 reg;
 
 		err_mask = sata_pmp_read(&ap->link, PMP_GSCR_SII_POL, &reg);
 		if (err_mask) {
 			rc = -EIO;
-			reason = "failed to read Sil3726 Private Register";
+			reason = "failed to read Sil3x26 Private Register";
 			goto fail;
 		}
 		reg &= ~0x1;
 		err_mask = sata_pmp_write(&ap->link, PMP_GSCR_SII_POL, reg);
 		if (err_mask) {
 			rc = -EIO;
-			reason = "failed to write Sil3726 Private Register";
+			reason = "failed to write Sil3x26 Private Register";
 			goto fail;
 		}
 	}
@@ -383,8 +383,8 @@ static void sata_pmp_quirks(struct ata_port *ap)
 	u16 devid = sata_pmp_gscr_devid(gscr);
 	struct ata_link *link;
 
-	if (vendor == 0x1095 && devid == 0x3726) {
-		/* sil3726 quirks */
+	if (vendor == 0x1095 && (devid == 0x3726 || devid == 0x3826)) {
+		/* sil3x26 quirks */
 		ata_for_each_link(link, ap, EDGE) {
 			/* link reports offline after LPM */
 			link->flags |= ATA_LFLAG_NO_LPM;
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index d6577b9..a3f0bbd 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -290,6 +290,7 @@ static void fsl_sata_set_irq_coalescing(struct ata_host *host,
 {
 	struct sata_fsl_host_priv *host_priv = host->private_data;
 	void __iomem *hcr_base = host_priv->hcr_base;
+	unsigned long flags;
 
 	if (count > ICC_MAX_INT_COUNT_THRESHOLD)
 		count = ICC_MAX_INT_COUNT_THRESHOLD;
@@ -302,12 +303,12 @@ static void fsl_sata_set_irq_coalescing(struct ata_host *host,
 			(count > ICC_MIN_INT_COUNT_THRESHOLD))
 		ticks = ICC_SAFE_INT_TICKS;
 
-	spin_lock(&host->lock);
+	spin_lock_irqsave(&host->lock, flags);
 	iowrite32((count << 24 | ticks), hcr_base + ICC);
 
 	intr_coalescing_count = count;
 	intr_coalescing_ticks = ticks;
-	spin_unlock(&host->lock);
+	spin_unlock_irqrestore(&host->lock, flags);
 
 	DPRINTK("intrrupt coalescing, count = 0x%x, ticks = %x\n",
 			intr_coalescing_count, intr_coalescing_ticks);
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 7dda4f7..d63a06b 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -154,6 +154,8 @@ static ssize_t show_mem_removable(struct device *dev,
 		container_of(dev, struct memory_block, dev);
 
 	for (i = 0; i < sections_per_block; i++) {
+		if (!present_section_nr(mem->start_section_nr + i))
+			continue;
 		pfn = section_nr_to_pfn(mem->start_section_nr + i);
 		ret &= is_mem_section_removable(pfn, PAGES_PER_SECTION);
 	}
diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 8af01c1..47b0f70 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -90,6 +90,7 @@ static struct usb_device_id ath3k_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3393) },
 	{ USB_DEVICE(0x0489, 0xe04e) },
 	{ USB_DEVICE(0x0489, 0xe056) },
+	{ USB_DEVICE(0x0cf3, 0x3121) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
@@ -126,6 +127,7 @@ static struct usb_device_id ath3k_blist_tbl[] = {
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0x3121), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU22 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE03C), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index ff0782c..f403d46 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -156,6 +156,7 @@ static struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0x3121), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index d7c3540..8c7a8cf 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1006,6 +1006,31 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 }
 
 /*
+ * Returns the size of variable_name, in bytes, including the
+ * terminating NULL character, or variable_name_size if no NULL
+ * character is found among the first variable_name_size bytes.
+ */
+static unsigned long var_name_strnsize(efi_char16_t *variable_name,
+				       unsigned long variable_name_size)
+{
+	unsigned long len;
+	efi_char16_t c;
+
+	/*
+	 * The variable name is, by definition, a NULL-terminated
+	 * string, so make absolutely sure that variable_name_size is
+	 * the value we expect it to be. If not, return the real size.
+	 */
+	for (len = 2; len <= variable_name_size; len += sizeof(c)) {
+		c = variable_name[(len / sizeof(c)) - 1];
+		if (!c)
+			break;
+	}
+
+	return min(len, variable_name_size);
+}
+
+/*
  * Let's not leave out systab information that snuck into
  * the efivars driver
  */
@@ -1232,6 +1257,8 @@ int register_efivars(struct efivars *efivars,
 						&vendor_guid);
 		switch (status) {
 		case EFI_SUCCESS:
+			variable_name_size = var_name_strnsize(variable_name,
+							       variable_name_size);
 			efivar_create_sysfs_entry(efivars,
 						  variable_name_size,
 						  variable_name,
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 26b8bba..70bfc0f 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -572,6 +572,8 @@
 					will not assert AGPBUSY# and will only
 					be delivered when out of C3. */
 #define   INSTPM_FORCE_ORDERING				(1<<7) /* GEN6+ */
+#define   INSTPM_TLB_INVALIDATE	(1<<9)
+#define   INSTPM_SYNC_FLUSH	(1<<5)
 #define ACTHD	        0x020c8
 #define FW_BLC		0x020d8
 #define FW_BLC2		0x020dc
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 440ed88..30a6a15 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -408,13 +408,7 @@ static void intel_lvds_prepare(struct drm_encoder *encoder)
 {
 	struct intel_lvds *intel_lvds = to_intel_lvds(encoder);
 
-	/*
-	 * Prior to Ironlake, we must disable the pipe if we want to adjust
-	 * the panel fitter. However at all other times we can just reset
-	 * the registers regardless.
-	 */
-	if (!HAS_PCH_SPLIT(encoder->dev) && intel_lvds->pfit_dirty)
-		intel_lvds_disable(intel_lvds);
+	intel_lvds_disable(intel_lvds);
 }
 
 static void intel_lvds_commit(struct drm_encoder *encoder)
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 78486c7..7e9d3db 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -773,6 +773,18 @@ void intel_ring_setup_status_page(struct intel_ring_buffer *ring)
 
 	I915_WRITE(mmio, (u32)ring->status_page.gfx_addr);
 	POSTING_READ(mmio);
+
+	/* Flush the TLB for this page */
+	if (INTEL_INFO(dev)->gen >= 6) {
+		u32 reg = RING_INSTPM(ring->mmio_base);
+		I915_WRITE(reg,
+			   _MASKED_BIT_ENABLE(INSTPM_TLB_INVALIDATE |
+					      INSTPM_SYNC_FLUSH));
+		if (wait_for((I915_READ(reg) & INSTPM_SYNC_FLUSH) == 0,
+			     1000))
+			DRM_ERROR("%s: wait for SyncFlush to complete for TLB invalidation timed out\n",
+				  ring->name);
+	}
 }
 
 static int
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 25723d8..925ab8e 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -649,7 +649,7 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 		if ((mc->ptr + rec_len) > mc->end)
 			goto decode_failed;
 
-		memcpy(cf->data, mc->ptr, rec_len);
+		memcpy(cf->data, mc->ptr, cf->can_dlc);
 		mc->ptr += rec_len;
 	}
 
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index 18054d9..dbec2ff 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -522,9 +522,9 @@ static int prism2_ioctl_giwaplist(struct net_device *dev,
 
 	data->length = prism2_ap_get_sta_qual(local, addr, qual, IW_MAX_AP, 1);
 
-	memcpy(extra, &addr, sizeof(struct sockaddr) * data->length);
+	memcpy(extra, addr, sizeof(struct sockaddr) * data->length);
 	data->flags = 1; /* has quality information */
-	memcpy(extra + sizeof(struct sockaddr) * data->length, &qual,
+	memcpy(extra + sizeof(struct sockaddr) * data->length, qual,
 	       sizeof(struct iw_quality) * data->length);
 
 	kfree(addr);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index ff5d689..cbcf6f2 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4411,12 +4411,12 @@ il4965_irq_tasklet(struct il_priv *il)
 		 * is killed. Hence update the killswitch state here. The
 		 * rfkill handler will care about restarting if needed.
 		 */
-		if (!test_bit(S_ALIVE, &il->status)) {
-			if (hw_rf_kill)
-				set_bit(S_RFKILL, &il->status);
-			else
-				clear_bit(S_RFKILL, &il->status);
+		if (hw_rf_kill) {
+			set_bit(S_RFKILL, &il->status);
+		} else {
+			clear_bit(S_RFKILL, &il->status);
 			wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
+			il_force_reset(il, true);
 		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
@@ -5285,6 +5285,9 @@ il4965_alive_start(struct il_priv *il)
 
 	il->active_rate = RATES_MASK;
 
+	il_power_update_mode(il, true);
+	D_INFO("Updated power mode\n");
+
 	if (il_is_associated(il)) {
 		struct il_rxon_cmd *active_rxon =
 		    (struct il_rxon_cmd *)&il->active;
@@ -5315,9 +5318,6 @@ il4965_alive_start(struct il_priv *il)
 	D_INFO("ALIVE processing complete.\n");
 	wake_up(&il->wait_command_queue);
 
-	il_power_update_mode(il, true);
-	D_INFO("Updated power mode\n");
-
 	return;
 
 restart:
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index e2b25eb..6f9c1fa 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4659,6 +4659,7 @@ il_force_reset(struct il_priv *il, bool external)
 
 	return 0;
 }
+EXPORT_SYMBOL(il_force_reset);
 
 int
 il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 2c86c55..40bf6ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -958,7 +958,10 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
+	if (!test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
+		return;
+
+	if (ctx->vif)
 		ieee80211_chswitch_done(ctx->vif, is_success);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 844d0f6..283b423 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -2107,16 +2107,16 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	spin_lock_init(&trans_pcie->irq_lock);
 	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 
-	/* W/A - seems to solve weird behavior. We need to remove this if we
-	 * don't want to stay in L1 all the time. This wastes a lot of power */
-	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
-				PCIE_LINK_STATE_CLKPM);
-
 	if (pci_enable_device(pdev)) {
 		err = -ENODEV;
 		goto out_no_pci;
 	}
 
+	/* W/A - seems to solve weird behavior. We need to remove this if we
+	 * don't want to stay in L1 all the time. This wastes a lot of power */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+				PCIE_LINK_STATE_CLKPM);
+
 	pci_set_master(pdev);
 
 	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));
diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index 48273dd..4312eca 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -98,10 +98,12 @@ static int zd1201_fw_upload(struct usb_device *dev, int apfw)
 		goto exit;
 
 	err = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), 0x4,
-	    USB_DIR_IN | 0x40, 0,0, &ret, sizeof(ret), ZD1201_FW_TIMEOUT);
+	    USB_DIR_IN | 0x40, 0, 0, buf, sizeof(ret), ZD1201_FW_TIMEOUT);
 	if (err < 0)
 		goto exit;
 
+	memcpy(&ret, buf, sizeof(ret));
+
 	if (ret & 0x80) {
 		err = -EIO;
 		goto exit;
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 91a375f..17fad3b 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -390,6 +390,8 @@ static void __unflatten_device_tree(struct boot_param_header *blob,
 	mem = (unsigned long)
 		dt_alloc(size + 4, __alignof__(struct device_node));
 
+	memset((void *)mem, 0, size);
+
 	((__be32 *)mem)[size / 4] = cpu_to_be32(0xdeadbeef);
 
 	pr_debug("  unflattening %lx...\n", mem);
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index e1b4f80..5c87270 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -102,10 +102,13 @@ static void zfcp_erp_action_dismiss_port(struct zfcp_port *port)
 
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_INUSE)
 		zfcp_erp_action_dismiss(&port->erp_action);
-	else
-		shost_for_each_device(sdev, port->adapter->scsi_host)
+	else {
+		spin_lock(port->adapter->scsi_host->host_lock);
+		__shost_for_each_device(sdev, port->adapter->scsi_host)
 			if (sdev_to_zfcp(sdev)->port == port)
 				zfcp_erp_action_dismiss_lun(sdev);
+		spin_unlock(port->adapter->scsi_host->host_lock);
+	}
 }
 
 static void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *adapter)
@@ -592,9 +595,11 @@ static void _zfcp_erp_lun_reopen_all(struct zfcp_port *port, int clear,
 {
 	struct scsi_device *sdev;
 
-	shost_for_each_device(sdev, port->adapter->scsi_host)
+	spin_lock(port->adapter->scsi_host->host_lock);
+	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port)
 			_zfcp_erp_lun_reopen(sdev, clear, id, 0);
+	spin_unlock(port->adapter->scsi_host->host_lock);
 }
 
 static void zfcp_erp_strategy_followup_failed(struct zfcp_erp_action *act)
@@ -1435,8 +1440,10 @@ void zfcp_erp_set_adapter_status(struct zfcp_adapter *adapter, u32 mask)
 		atomic_set_mask(common_mask, &port->status);
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 
-	shost_for_each_device(sdev, adapter->scsi_host)
+	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, adapter->scsi_host)
 		atomic_set_mask(common_mask, &sdev_to_zfcp(sdev)->status);
+	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
 }
 
 /**
@@ -1470,11 +1477,13 @@ void zfcp_erp_clear_adapter_status(struct zfcp_adapter *adapter, u32 mask)
 	}
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 
-	shost_for_each_device(sdev, adapter->scsi_host) {
+	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, adapter->scsi_host) {
 		atomic_clear_mask(common_mask, &sdev_to_zfcp(sdev)->status);
 		if (clear_counter)
 			atomic_set(&sdev_to_zfcp(sdev)->erp_counter, 0);
 	}
+	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
 }
 
 /**
@@ -1488,16 +1497,19 @@ void zfcp_erp_set_port_status(struct zfcp_port *port, u32 mask)
 {
 	struct scsi_device *sdev;
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
+	unsigned long flags;
 
 	atomic_set_mask(mask, &port->status);
 
 	if (!common_mask)
 		return;
 
-	shost_for_each_device(sdev, port->adapter->scsi_host)
+	spin_lock_irqsave(port->adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port)
 			atomic_set_mask(common_mask,
 					&sdev_to_zfcp(sdev)->status);
+	spin_unlock_irqrestore(port->adapter->scsi_host->host_lock, flags);
 }
 
 /**
@@ -1512,6 +1524,7 @@ void zfcp_erp_clear_port_status(struct zfcp_port *port, u32 mask)
 	struct scsi_device *sdev;
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
 	u32 clear_counter = mask & ZFCP_STATUS_COMMON_ERP_FAILED;
+	unsigned long flags;
 
 	atomic_clear_mask(mask, &port->status);
 
@@ -1521,13 +1534,15 @@ void zfcp_erp_clear_port_status(struct zfcp_port *port, u32 mask)
 	if (clear_counter)
 		atomic_set(&port->erp_counter, 0);
 
-	shost_for_each_device(sdev, port->adapter->scsi_host)
+	spin_lock_irqsave(port->adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port) {
 			atomic_clear_mask(common_mask,
 					  &sdev_to_zfcp(sdev)->status);
 			if (clear_counter)
 				atomic_set(&sdev_to_zfcp(sdev)->erp_counter, 0);
 		}
+	spin_unlock_irqrestore(port->adapter->scsi_host->host_lock, flags);
 }
 
 /**
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index e76d003..52c6b59 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -224,11 +224,9 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
 
 static int zfcp_qdio_sbal_check(struct zfcp_qdio *qdio)
 {
-	spin_lock_irq(&qdio->req_q_lock);
 	if (atomic_read(&qdio->req_q_free) ||
 	    !(atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
 		return 1;
-	spin_unlock_irq(&qdio->req_q_lock);
 	return 0;
 }
 
@@ -246,9 +244,8 @@ int zfcp_qdio_sbal_get(struct zfcp_qdio *qdio)
 {
 	long ret;
 
-	spin_unlock_irq(&qdio->req_q_lock);
-	ret = wait_event_interruptible_timeout(qdio->req_q_wq,
-			       zfcp_qdio_sbal_check(qdio), 5 * HZ);
+	ret = wait_event_interruptible_lock_irq_timeout(qdio->req_q_wq,
+		       zfcp_qdio_sbal_check(qdio), qdio->req_q_lock, 5 * HZ);
 
 	if (!(atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
 		return -EIO;
@@ -262,7 +259,6 @@ int zfcp_qdio_sbal_get(struct zfcp_qdio *qdio)
 		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdsbg_1");
 	}
 
-	spin_lock_irq(&qdio->req_q_lock);
 	return -EIO;
 }
 
diff --git a/drivers/tty/hvc/hvsi_lib.c b/drivers/tty/hvc/hvsi_lib.c
index 59c135d..2c51419 100644
--- a/drivers/tty/hvc/hvsi_lib.c
+++ b/drivers/tty/hvc/hvsi_lib.c
@@ -341,8 +341,8 @@ void hvsilib_establish(struct hvsi_priv *pv)
 
 	pr_devel("HVSI@%x:   ... waiting handshake\n", pv->termno);
 
-	/* Try for up to 200s */
-	for (timeout = 0; timeout < 20; timeout++) {
+	/* Try for up to 400ms */
+	for (timeout = 0; timeout < 40; timeout++) {
 		if (pv->established)
 			goto established;
 		if (!hvsi_get_packet(pv))
diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 64565f8..5ceeed8 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -547,7 +547,7 @@ auart_console_write(struct console *co, const char *str, unsigned int count)
 	unsigned int old_ctrl0, old_ctrl2;
 	unsigned int to = 20000;
 
-	if (co->index >	MXS_AUART_PORTS || co->index < 0)
+	if (co->index >= MXS_AUART_PORTS || co->index < 0)
 		return;
 
 	s = auart_port[co->index];
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index b801512..d67ff42 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -103,6 +103,12 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x04d8, 0x000c), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* CarrolTouch 4000U */
+	{ USB_DEVICE(0x04e7, 0x0009), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* CarrolTouch 4500U */
+	{ USB_DEVICE(0x04e7, 0x0030), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Samsung Android phone modem - ID conflict with SPH-I500 */
 	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 284b854..14d9142 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -829,7 +829,7 @@ static int adu_probe(struct usb_interface *interface,
 
 	/* let the user know what node this device is now attached to */
 	dev_info(&interface->dev, "ADU%d %s now attached to /dev/usb/adutux%d\n",
-		 udev->descriptor.idProduct, dev->serial_number,
+		 le16_to_cpu(udev->descriptor.idProduct), dev->serial_number,
 		 (dev->minor - ADU_MINOR_BASE));
 exit:
 	dbg(2," %s : leave, return value %p (dev)", __func__, dev);
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 2d35ad4..9b55796 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -2439,7 +2439,7 @@ static int keyspan_startup(struct usb_serial *serial)
 	if (d_details == NULL) {
 		dev_err(&serial->dev->dev, "%s - unknown product id %x\n",
 		    __func__, le16_to_cpu(serial->dev->descriptor.idProduct));
-		return 1;
+		return -ENODEV;
 	}
 
 	/* Setup private data for serial driver */
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 614ad93..9809fbc 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -97,6 +97,7 @@ struct urbtracker {
 	struct list_head        urblist_entry;
 	struct kref             ref_count;
 	struct urb              *urb;
+	struct usb_ctrlrequest	*setup;
 };
 
 enum mos7715_pp_modes {
@@ -278,6 +279,7 @@ static void destroy_urbtracker(struct kref *kref)
 	struct mos7715_parport *mos_parport = urbtrack->mos_parport;
 
 	usb_free_urb(urbtrack->urb);
+	kfree(urbtrack->setup);
 	kfree(urbtrack);
 	kref_put(&mos_parport->ref_count, destroy_mos_parport);
 }
@@ -360,7 +362,6 @@ static int write_parport_reg_nonblock(struct mos7715_parport *mos_parport,
 	struct urbtracker *urbtrack;
 	int ret_val;
 	unsigned long flags;
-	struct usb_ctrlrequest setup;
 	struct usb_serial *serial = mos_parport->serial;
 	struct usb_device *usbdev = serial->dev;
 
@@ -378,14 +379,20 @@ static int write_parport_reg_nonblock(struct mos7715_parport *mos_parport,
 		kfree(urbtrack);
 		return -ENOMEM;
 	}
-	setup.bRequestType = (__u8)0x40;
-	setup.bRequest = (__u8)0x0e;
-	setup.wValue = get_reg_value(reg, dummy);
-	setup.wIndex = get_reg_index(reg);
-	setup.wLength = 0;
+	urbtrack->setup = kmalloc(sizeof(*urbtrack->setup), GFP_KERNEL);
+	if (!urbtrack->setup) {
+		usb_free_urb(urbtrack->urb);
+		kfree(urbtrack);
+		return -ENOMEM;
+	}
+	urbtrack->setup->bRequestType = (__u8)0x40;
+	urbtrack->setup->bRequest = (__u8)0x0e;
+	urbtrack->setup->wValue = get_reg_value(reg, dummy);
+	urbtrack->setup->wIndex = get_reg_index(reg);
+	urbtrack->setup->wLength = 0;
 	usb_fill_control_urb(urbtrack->urb, usbdev,
 			     usb_sndctrlpipe(usbdev, 0),
-			     (unsigned char *)&setup,
+			     (unsigned char *)urbtrack->setup,
 			     NULL, 0, async_complete, urbtrack);
 	kref_init(&urbtrack->ref_count);
 	INIT_LIST_HEAD(&urbtrack->urblist_entry);
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 0d51815..d9368be 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2405,7 +2405,7 @@ static int mos7810_check(struct usb_serial *serial)
 static int mos7840_probe(struct usb_serial *serial,
 				const struct usb_device_id *id)
 {
-	u16 product = serial->dev->descriptor.idProduct;
+	u16 product = le16_to_cpu(serial->dev->descriptor.idProduct);
 	u8 *buf;
 	int device_type;
 
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 2f02f79..ea41faa 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1641,14 +1641,15 @@ static int ti_download_firmware(struct ti_device *tdev)
 	char buf[32];
 
 	/* try ID specific firmware first, then try generic firmware */
-	sprintf(buf, "ti_usb-v%04x-p%04x.fw", dev->descriptor.idVendor,
-	    dev->descriptor.idProduct);
+	sprintf(buf, "ti_usb-v%04x-p%04x.fw",
+			le16_to_cpu(dev->descriptor.idVendor),
+			le16_to_cpu(dev->descriptor.idProduct));
 	status = request_firmware(&fw_p, buf, &dev->dev);
 
 	if (status != 0) {
 		buf[0] = '\0';
-		if (dev->descriptor.idVendor == MTS_VENDOR_ID) {
-			switch (dev->descriptor.idProduct) {
+		if (le16_to_cpu(dev->descriptor.idVendor) == MTS_VENDOR_ID) {
+			switch (le16_to_cpu(dev->descriptor.idProduct)) {
 			case MTS_CDMA_PRODUCT_ID:
 				strcpy(buf, "mts_cdma.fw");
 				break;
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 25c8ee9..2956414 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -297,18 +297,18 @@ static void usb_wwan_indat_callback(struct urb *urb)
 			tty_kref_put(tty);
 		}
 
-		/* Resubmit urb so we continue receiving */
-		err = usb_submit_urb(urb, GFP_ATOMIC);
-		if (err) {
-			if (err != -EPERM) {
-				printk(KERN_ERR "%s: resubmit read urb failed. "
-					"(%d)", __func__, err);
-				/* busy also in error unless we are killed */
-				usb_mark_last_busy(port->serial->dev);
-			}
-		} else {
+	}
+	/* Resubmit urb so we continue receiving */
+	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (err) {
+		if (err != -EPERM) {
+			printk(KERN_ERR "%s: resubmit read urb failed. (%d)\n",
+				__func__, err);
+			/* busy also in error unless we are killed */
 			usb_mark_last_busy(port->serial->dev);
 		}
+	} else {
+		usb_mark_last_busy(port->serial->dev);
 	}
 }
 
diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 57c01ab..1ebc17e 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -1110,6 +1110,12 @@ int wa_urb_dequeue(struct wahc *wa, struct urb *urb)
 	}
 	spin_lock_irqsave(&xfer->lock, flags);
 	rpipe = xfer->ep->hcpriv;
+	if (rpipe == NULL) {
+		pr_debug("%s: xfer id 0x%08X has no RPIPE.  %s",
+			__func__, wa_xfer_id(xfer),
+			"Probably already aborted.\n" );
+		goto out_unlock;
+	}
 	/* Check the delayed list -> if there, release and complete */
 	spin_lock_irqsave(&wa->xfer_list_lock, flags2);
 	if (!list_empty(&xfer->list_node) && xfer->seg == NULL)
@@ -1493,8 +1499,7 @@ static void wa_xfer_result_cb(struct urb *urb)
 			break;
 		}
 		usb_status = xfer_result->bTransferStatus & 0x3f;
-		if (usb_status == WA_XFER_STATUS_ABORTED
-		    || usb_status == WA_XFER_STATUS_NOT_FOUND)
+		if (usb_status == WA_XFER_STATUS_NOT_FOUND)
 			/* taken care of already */
 			break;
 		xfer_id = xfer_result->dwTransferID;
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index b5b559a..025e98b 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -324,7 +324,7 @@ static void init_evtchn_cpu_bindings(void)
 
 	for_each_possible_cpu(i)
 		memset(per_cpu(cpu_evtchn_mask, i),
-		       (i == 0) ? ~0 : 0, sizeof(*per_cpu(cpu_evtchn_mask, i)));
+		       (i == 0) ? ~0 : 0, NR_EVENT_CHANNELS/8);
 }
 
 static inline void clear_evtchn(int port)
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index f4f0ee6..a202728 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -109,10 +109,10 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_dirty_metadata(handle, bh);
-		if (err) {
-			/* Errors can only happen if there is a bug */
-			handle->h_err = err;
-			__ext4_journal_stop(where, line, handle);
+		/* Errors can only happen if there is a bug */
+		if (WARN_ON_ONCE(err)) {
+			ext4_journal_abort_handle(where, line, __func__, bh,
+						  handle, err);
 		}
 	} else {
 		if (inode)
diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 9197a1b..9f7c758 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -3047,6 +3047,14 @@ int jfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 
 		dir_index = (u32) filp->f_pos;
 
+		/*
+		 * NFSv4 reserves cookies 1 and 2 for . and .. so the value
+		 * we return to the vfs is one greater than the one we use
+		 * internally.
+		 */
+		if (dir_index)
+			dir_index--;
+
 		if (dir_index > 1) {
 			struct dir_table_slot dirtab_slot;
 
@@ -3086,7 +3094,7 @@ int jfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 			if (p->header.flag & BT_INTERNAL) {
 				jfs_err("jfs_readdir: bad index table");
 				DT_PUTPAGE(mp);
-				filp->f_pos = -1;
+				filp->f_pos = DIREND;
 				return 0;
 			}
 		} else {
@@ -3094,7 +3102,7 @@ int jfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 				/*
 				 * self "."
 				 */
-				filp->f_pos = 0;
+				filp->f_pos = 1;
 				if (filldir(dirent, ".", 1, 0, ip->i_ino,
 					    DT_DIR))
 					return 0;
@@ -3102,7 +3110,7 @@ int jfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 			/*
 			 * parent ".."
 			 */
-			filp->f_pos = 1;
+			filp->f_pos = 2;
 			if (filldir(dirent, "..", 2, 1, PARENT(ip), DT_DIR))
 				return 0;
 
@@ -3123,24 +3131,25 @@ int jfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		/*
 		 * Legacy filesystem - OS/2 & Linux JFS < 0.3.6
 		 *
-		 * pn = index = 0:	First entry "."
-		 * pn = 0; index = 1:	Second entry ".."
+		 * pn = 0; index = 1:	First entry "."
+		 * pn = 0; index = 2:	Second entry ".."
 		 * pn > 0:		Real entries, pn=1 -> leftmost page
 		 * pn = index = -1:	No more entries
 		 */
 		dtpos = filp->f_pos;
-		if (dtpos == 0) {
+		if (dtpos < 2) {
 			/* build "." entry */
 
+			filp->f_pos = 1;
 			if (filldir(dirent, ".", 1, filp->f_pos, ip->i_ino,
 				    DT_DIR))
 				return 0;
-			dtoffset->index = 1;
+			dtoffset->index = 2;
 			filp->f_pos = dtpos;
 		}
 
 		if (dtoffset->pn == 0) {
-			if (dtoffset->index == 1) {
+			if (dtoffset->index == 2) {
 				/* build ".." entry */
 
 				if (filldir(dirent, "..", 2, filp->f_pos,
@@ -3233,6 +3242,12 @@ int jfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 					}
 					jfs_dirent->position = unique_pos++;
 				}
+				/*
+				 * We add 1 to the index because we may
+				 * use a value of 2 internally, and NFSv4
+				 * doesn't like that.
+				 */
+				jfs_dirent->position++;
 			} else {
 				jfs_dirent->position = dtpos;
 				len = min(d_namleft, DTLHDRDATALEN_LEGACY);
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index dc9a913..2d8be51 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -345,8 +345,7 @@ static void nilfs_end_bio_write(struct bio *bio, int err)
 
 	if (err == -EOPNOTSUPP) {
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		bio_put(bio);
-		/* to be detected by submit_seg_bio() */
+		/* to be detected by nilfs_segbuf_submit_bio() */
 	}
 
 	if (!uptodate)
@@ -377,12 +376,12 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
 	bio->bi_private = segbuf;
 	bio_get(bio);
 	submit_bio(mode, bio);
+	segbuf->sb_nbio++;
 	if (bio_flagged(bio, BIO_EOPNOTSUPP)) {
 		bio_put(bio);
 		err = -EOPNOTSUPP;
 		goto failed;
 	}
-	segbuf->sb_nbio++;
 	bio_put(bio);
 
 	wi->bio = NULL;
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4540b8f..1868fe1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -693,14 +693,14 @@ typedef struct {
 } pagemap_entry_t;
 
 struct pagemapread {
-	int pos, len;
+	int pos, len;		/* units: PM_ENTRY_BYTES, not bytes */
 	pagemap_entry_t *buffer;
 };
 
 #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
 #define PAGEMAP_WALK_MASK	(PMD_MASK)
 
-#define PM_ENTRY_BYTES      sizeof(u64)
+#define PM_ENTRY_BYTES      sizeof(pagemap_entry_t)
 #define PM_STATUS_BITS      3
 #define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
 #define PM_STATUS_MASK      (((1LL << PM_STATUS_BITS) - 1) << PM_STATUS_OFFSET)
@@ -939,8 +939,8 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	if (!count)
 		goto out_task;
 
-	pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
-	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
+	pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
+	pm.buffer = kmalloc(pm.len * PM_ENTRY_BYTES, GFP_TEMPORARY);
 	ret = -ENOMEM;
 	if (!pm.buffer)
 		goto out_task;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 704a626..b5bea2f 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -307,6 +307,7 @@ struct mm_struct {
 	void (*unmap_area) (struct mm_struct *mm, unsigned long addr);
 #endif
 	unsigned long mmap_base;		/* base of mmap area */
+	unsigned long mmap_legacy_base;         /* base of mmap area in bottom-up allocations */
 	unsigned long task_size;		/* size of task vm space */
 	unsigned long cached_hole_size; 	/* if non-zero, the largest hole below free_area_cache */
 	unsigned long free_area_cache;		/* first hole of size cached_hole_size or larger */
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 6c6c20e..d331566 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -572,6 +572,64 @@ do {									\
 	__ret;								\
 })
 
+#define __wait_event_interruptible_lock_irq_timeout(wq, condition,	\
+						    lock, ret)		\
+do {									\
+	DEFINE_WAIT(__wait);						\
+									\
+	for (;;) {							\
+		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
+		}							\
+		spin_unlock_irq(&lock);					\
+		ret = schedule_timeout(ret);				\
+		spin_lock_irq(&lock);					\
+		if (!ret)						\
+			break;						\
+	}								\
+	finish_wait(&wq, &__wait);					\
+} while (0)
+
+/**
+ * wait_event_interruptible_lock_irq_timeout - sleep until a condition gets true or a timeout elapses.
+ *		The condition is checked under the lock. This is expected
+ *		to be called with the lock taken.
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @lock: a locked spinlock_t, which will be released before schedule()
+ *	  and reacquired afterwards.
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or signal is received. The @condition is
+ * checked each time the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * This is supposed to be called while holding the lock. The lock is
+ * dropped before going to sleep and is reacquired afterwards.
+ *
+ * The function returns 0 if the @timeout elapsed, -ERESTARTSYS if it
+ * was interrupted by a signal, and the remaining jiffies otherwise
+ * if the condition evaluated to true before the timeout elapsed.
+ */
+#define wait_event_interruptible_lock_irq_timeout(wq, condition, lock,	\
+						  timeout)		\
+({									\
+	int __ret = timeout;						\
+									\
+	if (!(condition))						\
+		__wait_event_interruptible_lock_irq_timeout(		\
+					wq, condition, lock, __ret);	\
+	__ret;								\
+})
+
+
 /*
  * These are the old interfaces to sleep waiting for an event.
  * They are racy.  DO NOT use them, use the wait_event* interfaces above.
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dd488af..0395ca8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1744,10 +1744,9 @@ static void move_linked_works(struct work_struct *work, struct list_head *head,
 		*nextp = n;
 }
 
-static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
+static void cwq_activate_delayed_work(struct work_struct *work)
 {
-	struct work_struct *work = list_first_entry(&cwq->delayed_works,
-						    struct work_struct, entry);
+	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
 	struct list_head *pos = gcwq_determine_ins_pos(cwq->gcwq, cwq);
 
 	trace_workqueue_activate_work(work);
@@ -1756,6 +1755,14 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
 	cwq->nr_active++;
 }
 
+static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
+{
+	struct work_struct *work = list_first_entry(&cwq->delayed_works,
+						    struct work_struct, entry);
+
+	cwq_activate_delayed_work(work);
+}
+
 /**
  * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
  * @cwq: cwq of interest
@@ -2653,6 +2660,18 @@ static int try_to_grab_pending(struct work_struct *work)
 		smp_rmb();
 		if (gcwq == get_work_gcwq(work)) {
 			debug_work_deactivate(work);
+
+			/*
+			 * A delayed work item cannot be grabbed directly
+			 * because it might have linked NO_COLOR work items
+			 * which, if left on the delayed_list, will confuse
+			 * cwq->nr_active management later on and cause
+			 * stall.  Make sure the work item is activated
+			 * before grabbing.
+			 */
+			if (*work_data_bits(work) & WORK_STRUCT_DELAYED)
+				cwq_activate_delayed_work(work);
+
 			list_del_init(&work->entry);
 			cwq_dec_nr_in_flight(get_work_cwq(work),
 				get_work_color(work),
diff --git a/mm/nommu.c b/mm/nommu.c
index a60db99..572c4c0 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1827,6 +1827,16 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(remap_pfn_range);
 
+int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len)
+{
+	unsigned long pfn = start >> PAGE_SHIFT;
+	unsigned long vm_len = vma->vm_end - vma->vm_start;
+
+	pfn += vma->vm_pgoff;
+	return io_remap_pfn_range(vma, vma->vm_start, pfn, vm_len, vma->vm_page_prot);
+}
+EXPORT_SYMBOL(vm_iomap_memory);
+
 int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 			unsigned long pgoff)
 {
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 7dcb525..b606ce5 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2687,6 +2687,7 @@ static int key_notify_policy_flush(const struct km_event *c)
 	hdr->sadb_msg_pid = c->pid;
 	hdr->sadb_msg_version = PF_KEY_V2;
 	hdr->sadb_msg_errno = (uint8_t) 0;
+	hdr->sadb_msg_satype = SADB_SATYPE_UNSPEC;
 	hdr->sadb_msg_len = (sizeof(struct sadb_msg) / sizeof(uint64_t));
 	hdr->sadb_msg_reserved = 0;
 	pfkey_broadcast(skb_out, GFP_ATOMIC, BROADCAST_ALL, NULL, c->net);
diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index 5849b12..1a96402 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -250,6 +250,7 @@ config MSND_FIFOSIZE
 menuconfig SOUND_OSS
 	tristate "OSS sound modules"
 	depends on ISA_DMA_API && VIRT_TO_BUS
+	depends on !GENERIC_ISA_DMA_SUPPORT_BROKEN
 	help
 	  OSS is the Open Sound System suite of sound card drivers.  They make
 	  sound programming easier since they provide a common API.  Say Y or
diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index 539e2f3..21b5d89 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -451,7 +451,7 @@ static const struct snd_kcontrol_new cs42l52_snd_controls[] = {
 	SOC_ENUM("Beep Pitch", beep_pitch_enum),
 	SOC_ENUM("Beep on Time", beep_ontime_enum),
 	SOC_ENUM("Beep off Time", beep_offtime_enum),
-	SOC_SINGLE_TLV("Beep Volume", CS42L52_BEEP_VOL, 0, 0x1f, 0x07, hl_tlv),
+	SOC_SINGLE_SX_TLV("Beep Volume", CS42L52_BEEP_VOL, 0, 0x07, 0x1f, hl_tlv),
 	SOC_SINGLE("Beep Mixer Switch", CS42L52_BEEP_TONE_CTL, 5, 1, 1),
 	SOC_ENUM("Beep Treble Corner Freq", beep_treble_enum),
 	SOC_ENUM("Beep Bass Corner Freq", beep_bass_enum),
diff --git a/sound/usb/6fire/midi.c b/sound/usb/6fire/midi.c
index f0e5179..0c09867 100644
--- a/sound/usb/6fire/midi.c
+++ b/sound/usb/6fire/midi.c
@@ -19,6 +19,10 @@
 #include "chip.h"
 #include "comm.h"
 
+enum {
+	MIDI_BUFSIZE = 64
+};
+
 static void usb6fire_midi_out_handler(struct urb *urb)
 {
 	struct midi_runtime *rt = urb->context;
@@ -156,6 +160,12 @@ int __devinit usb6fire_midi_init(struct sfire_chip *chip)
 	if (!rt)
 		return -ENOMEM;
 
+	rt->out_buffer = kzalloc(MIDI_BUFSIZE, GFP_KERNEL);
+	if (!rt->out_buffer) {
+		kfree(rt);
+		return -ENOMEM;
+	}
+
 	rt->chip = chip;
 	rt->in_received = usb6fire_midi_in_received;
 	rt->out_buffer[0] = 0x80; /* 'send midi' command */
@@ -169,6 +179,7 @@ int __devinit usb6fire_midi_init(struct sfire_chip *chip)
 
 	ret = snd_rawmidi_new(chip->card, "6FireUSB", 0, 1, 1, &rt->instance);
 	if (ret < 0) {
+		kfree(rt->out_buffer);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "unable to create midi.\n");
 		return ret;
@@ -197,6 +208,9 @@ void usb6fire_midi_abort(struct sfire_chip *chip)
 
 void usb6fire_midi_destroy(struct sfire_chip *chip)
 {
-	kfree(chip->midi);
+	struct midi_runtime *rt = chip->midi;
+
+	kfree(rt->out_buffer);
+	kfree(rt);
 	chip->midi = NULL;
 }
diff --git a/sound/usb/6fire/midi.h b/sound/usb/6fire/midi.h
index 5114ecc..d101ecb 100644
--- a/sound/usb/6fire/midi.h
+++ b/sound/usb/6fire/midi.h
@@ -16,10 +16,6 @@
 
 #include "common.h"
 
-enum {
-	MIDI_BUFSIZE = 64
-};
-
 struct midi_runtime {
 	struct sfire_chip *chip;
 	struct snd_rawmidi *instance;
@@ -32,7 +28,7 @@ struct midi_runtime {
 	struct snd_rawmidi_substream *out;
 	struct urb out_urb;
 	u8 out_serial; /* serial number of out packet */
-	u8 out_buffer[MIDI_BUFSIZE];
+	u8 *out_buffer;
 	int buffer_offset;
 
 	void (*in_received)(struct midi_runtime *rt, u8 *data, int length);
diff --git a/sound/usb/6fire/pcm.c b/sound/usb/6fire/pcm.c
index 7c4f311..51e3f62f 100644
--- a/sound/usb/6fire/pcm.c
+++ b/sound/usb/6fire/pcm.c
@@ -578,6 +578,33 @@ static void __devinit usb6fire_pcm_init_urb(struct pcm_urb *urb,
 	urb->instance.number_of_packets = PCM_N_PACKETS_PER_URB;
 }
 
+static int usb6fire_pcm_buffers_init(struct pcm_runtime *rt)
+{
+	int i;
+
+	for (i = 0; i < PCM_N_URBS; i++) {
+		rt->out_urbs[i].buffer = kzalloc(PCM_N_PACKETS_PER_URB
+				* PCM_MAX_PACKET_SIZE, GFP_KERNEL);
+		if (!rt->out_urbs[i].buffer)
+			return -ENOMEM;
+		rt->in_urbs[i].buffer = kzalloc(PCM_N_PACKETS_PER_URB
+				* PCM_MAX_PACKET_SIZE, GFP_KERNEL);
+		if (!rt->in_urbs[i].buffer)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+static void usb6fire_pcm_buffers_destroy(struct pcm_runtime *rt)
+{
+	int i;
+
+	for (i = 0; i < PCM_N_URBS; i++) {
+		kfree(rt->out_urbs[i].buffer);
+		kfree(rt->in_urbs[i].buffer);
+	}
+}
+
 int __devinit usb6fire_pcm_init(struct sfire_chip *chip)
 {
 	int i;
@@ -589,6 +616,13 @@ int __devinit usb6fire_pcm_init(struct sfire_chip *chip)
 	if (!rt)
 		return -ENOMEM;
 
+	ret = usb6fire_pcm_buffers_init(rt);
+	if (ret) {
+		usb6fire_pcm_buffers_destroy(rt);
+		kfree(rt);
+		return ret;
+	}
+
 	rt->chip = chip;
 	rt->stream_state = STREAM_DISABLED;
 	rt->rate = ARRAY_SIZE(rates);
@@ -610,6 +644,7 @@ int __devinit usb6fire_pcm_init(struct sfire_chip *chip)
 
 	ret = snd_pcm_new(chip->card, "DMX6FireUSB", 0, 1, 1, &pcm);
 	if (ret < 0) {
+		usb6fire_pcm_buffers_destroy(rt);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "cannot create pcm instance.\n");
 		return ret;
@@ -625,6 +660,7 @@ int __devinit usb6fire_pcm_init(struct sfire_chip *chip)
 			snd_dma_continuous_data(GFP_KERNEL),
 			MAX_BUFSIZE, MAX_BUFSIZE);
 	if (ret) {
+		usb6fire_pcm_buffers_destroy(rt);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX
 				"error preallocating pcm buffers.\n");
@@ -669,6 +705,9 @@ void usb6fire_pcm_abort(struct sfire_chip *chip)
 
 void usb6fire_pcm_destroy(struct sfire_chip *chip)
 {
-	kfree(chip->pcm);
+	struct pcm_runtime *rt = chip->pcm;
+
+	usb6fire_pcm_buffers_destroy(rt);
+	kfree(rt);
 	chip->pcm = NULL;
 }
diff --git a/sound/usb/6fire/pcm.h b/sound/usb/6fire/pcm.h
index 3104301..84610cf 100644
--- a/sound/usb/6fire/pcm.h
+++ b/sound/usb/6fire/pcm.h
@@ -32,7 +32,7 @@ struct pcm_urb {
 	struct urb instance;
 	struct usb_iso_packet_descriptor packets[PCM_N_PACKETS_PER_URB];
 	/* END DO NOT SEPARATE */
-	u8 buffer[PCM_N_PACKETS_PER_URB * PCM_MAX_PACKET_SIZE];
+	u8 *buffer;
 
 	struct pcm_urb *peer;
 };
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 3e513a8..9c6a7fe 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -720,7 +720,10 @@ static int check_input_term(struct mixer_build *state, int id, struct usb_audio_
 			return 0;
 		}
 		case UAC1_PROCESSING_UNIT:
-		case UAC1_EXTENSION_UNIT: {
+		case UAC1_EXTENSION_UNIT:
+		/* UAC2_PROCESSING_UNIT_V2 */
+		/* UAC2_EFFECT_UNIT */
+		case UAC2_EXTENSION_UNIT_V2: {
 			struct uac_processing_unit_descriptor *d = p1;
 			if (d->bNrInPins) {
 				id = d->baSourceID[0];
@@ -1983,6 +1986,8 @@ static int parse_audio_unit(struct mixer_build *state, int unitid)
 			return parse_audio_extension_unit(state, unitid, p1);
 		else /* UAC_VERSION_2 */
 			return parse_audio_processing_unit(state, unitid, p1);
+	case UAC2_EXTENSION_UNIT_V2:
+		return parse_audio_extension_unit(state, unitid, p1);
 	default:
 		snd_printk(KERN_ERR "usbaudio: unit %u: unexpected type 0x%02x\n", unitid, p1[2]);
 		return -EINVAL;
