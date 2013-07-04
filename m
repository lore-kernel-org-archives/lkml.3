Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662Ab3GDWtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 18:49:25 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41878 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443Ab3GDWtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 18:49:24 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>
Subject: [PATCH v2] arch/um: make it work with defconfig and x86_64
Date: Fri,  5 Jul 2013 04:15:30 +0530
Message-Id: <1372977930-4248-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/defconfig only lists one default configuration, and that applies
only to the i386 architecture.  Replace it with two files:

  i386_defconfig and x86_64_defconfig

The build scripts now require two updates:

1. um's Kconfig (arch/x86/um/Kconfig) should specify an ARCH_DEFCONFIG
   section explicitly pointing to these scripts if the required
   variables are set.  Take care to remove the DEFCONFIG_LIST section
   defined in the included file arch/um/Kconfig.common.

2. um's Makefile (arch/um/Makefile) should set KBUILD_DEFCONFIG properly
   for the top-level Makefile to pick up.  Copy the logic in
   arch/x86/Makefile to properly pick the defconfig file depending on
   the actual architecture; except we're working with $SUBARCH here,
   instead of $ARCH.

Now, you can do:

  $ ARCH=um make defconfig
  $ ARCH=um make

and successfully build User-Mode Linux on an x86_64 box in default
configuration.

Cc: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 arch/um/Kconfig.common                          |   5 -
 arch/um/Makefile                                |  11 ++
 arch/um/{defconfig => configs/i386_defconfig}   | 209 +++++++++++++-------
 arch/um/{defconfig => configs/x86_64_defconfig} | 250 +++++++++++++++---------
 arch/x86/um/Kconfig                             |   5 +
 5 files changed, 306 insertions(+), 174 deletions(-)
 copy arch/um/{defconfig => configs/i386_defconfig} (86%)
 rename arch/um/{defconfig => configs/x86_64_defconfig} (83%)

diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index bceee66..10129a5 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -1,8 +1,3 @@
-config DEFCONFIG_LIST
-	string
-	option defconfig_list
-	default "arch/$ARCH/defconfig"
-
 config UML
 	bool
 	default y
diff --git a/arch/um/Makefile b/arch/um/Makefile
index 133f7de..48d92bb 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -6,6 +6,17 @@
 # Licensed under the GPL
 #
 
+# select defconfig based on actual architecture
+ifeq ($(SUBARCH),x86)
+  ifeq ($(shell uname -m),x86_64)
+        KBUILD_DEFCONFIG := x86_64_defconfig
+  else
+        KBUILD_DEFCONFIG := i386_defconfig
+  endif
+else
+        KBUILD_DEFCONFIG := $(SUBARCH)_defconfig
+endif
+
 ARCH_DIR := arch/um
 OS := $(shell uname -s)
 # We require bash because the vmlinux link and loader script cpp use bash
diff --git a/arch/um/defconfig b/arch/um/configs/i386_defconfig
similarity index 86%
copy from arch/um/defconfig
copy to arch/um/configs/i386_defconfig
index 08107a7..995aecd 100644
--- a/arch/um/defconfig
+++ b/arch/um/configs/i386_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated file; DO NOT EDIT.
-# User Mode Linux/i386 3.3.0 Kernel Configuration
+# User Mode Linux/x86 3.10.0 Kernel Configuration
 #
 CONFIG_DEFCONFIG_LIST="arch/$ARCH/defconfig"
 CONFIG_UML=y
@@ -11,7 +11,6 @@ CONFIG_LOCKDEP_SUPPORT=y
 # CONFIG_STACKTRACE_SUPPORT is not set
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_GENERIC_BUG=y
-CONFIG_GENERIC_CLOCKEVENTS=y
 CONFIG_HZ=100
 
 #
@@ -47,25 +46,17 @@ CONFIG_M686=y
 # CONFIG_MATOM is not set
 # CONFIG_X86_GENERIC is not set
 CONFIG_X86_INTERNODE_CACHE_SHIFT=5
-CONFIG_X86_CMPXCHG=y
 CONFIG_X86_L1_CACHE_SHIFT=5
-CONFIG_X86_XADD=y
 CONFIG_X86_PPRO_FENCE=y
-CONFIG_X86_WP_WORKS_OK=y
-CONFIG_X86_INVLPG=y
-CONFIG_X86_BSWAP=y
-CONFIG_X86_POPAD_OK=y
 CONFIG_X86_USE_PPRO_CHECKSUM=y
 CONFIG_X86_TSC=y
 CONFIG_X86_CMPXCHG64=y
 CONFIG_X86_CMOV=y
 CONFIG_X86_MINIMUM_CPU_FAMILY=5
 CONFIG_CPU_SUP_INTEL=y
-CONFIG_CPU_SUP_CYRIX_32=y
 CONFIG_CPU_SUP_AMD=y
 CONFIG_CPU_SUP_CENTAUR=y
 CONFIG_CPU_SUP_TRANSMETA_32=y
-CONFIG_CPU_SUP_UMC_32=y
 CONFIG_UML_X86=y
 # CONFIG_64BIT is not set
 CONFIG_X86_32=y
@@ -77,30 +68,28 @@ CONFIG_ARCH_HAS_SC_SIGNALS=y
 CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA=y
 CONFIG_GENERIC_HWEIGHT=y
 # CONFIG_STATIC_LINK is not set
-CONFIG_SELECT_MEMORY_MODEL=y
-CONFIG_FLATMEM_MANUAL=y
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
+# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
 CONFIG_PAGEFLAGS_EXTENDED=y
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_COMPACTION is not set
 # CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=0
-CONFIG_VIRT_TO_BUS=y
 # CONFIG_KSM is not set
 CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
+CONFIG_CROSS_MEMORY_ATTACH=y
 CONFIG_NEED_PER_CPU_KM=y
 # CONFIG_CLEANCACHE is not set
-CONFIG_TICK_ONESHOT=y
-CONFIG_NO_HZ=y
-CONFIG_HIGH_RES_TIMERS=y
-CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+# CONFIG_FRONTSWAP is not set
 CONFIG_LD_SCRIPT_DYN=y
 CONFIG_BINFMT_ELF=y
 CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
+CONFIG_BINFMT_SCRIPT=y
 CONFIG_HAVE_AOUT=y
 # CONFIG_BINFMT_AOUT is not set
 CONFIG_BINFMT_MISC=m
+CONFIG_COREDUMP=y
 CONFIG_HOSTFS=y
 # CONFIG_HPPFS is not set
 CONFIG_MCONSOLE=y
@@ -108,14 +97,15 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_KERNEL_STACK_ORDER=0
 # CONFIG_MMAPPER is not set
 CONFIG_NO_DMA=y
+CONFIG_IRQ_WORK=y
 
 #
 # General setup
 #
-CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=128
 CONFIG_CROSS_COMPILE=""
+# CONFIG_COMPILE_TEST is not set
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_DEFAULT_HOSTNAME="(none)"
@@ -124,10 +114,7 @@ CONFIG_SYSVIPC=y
 CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_POSIX_MQUEUE_SYSCTL=y
-CONFIG_BSD_PROCESS_ACCT=y
-# CONFIG_BSD_PROCESS_ACCT_V3 is not set
 # CONFIG_FHANDLE is not set
-# CONFIG_TASKSTATS is not set
 # CONFIG_AUDIT is not set
 CONFIG_HAVE_GENERIC_HARDIRQS=y
 
@@ -136,13 +123,33 @@ CONFIG_HAVE_GENERIC_HARDIRQS=y
 #
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_SHOW=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+
+#
+# Timers subsystem
+#
+CONFIG_TICK_ONESHOT=y
+CONFIG_NO_HZ_COMMON=y
+# CONFIG_HZ_PERIODIC is not set
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
+
+#
+# CPU/Task time and stats accounting
+#
+CONFIG_TICK_CPU_ACCOUNTING=y
+CONFIG_BSD_PROCESS_ACCT=y
+# CONFIG_BSD_PROCESS_ACCT_V3 is not set
+# CONFIG_TASKSTATS is not set
 
 #
 # RCU Subsystem
 #
 CONFIG_TINY_RCU=y
 # CONFIG_PREEMPT_RCU is not set
-# CONFIG_RCU_TRACE is not set
+# CONFIG_RCU_STALL_COMMON is not set
 # CONFIG_TREE_RCU_TRACE is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
@@ -155,10 +162,7 @@ CONFIG_CPUSETS=y
 CONFIG_PROC_PID_CPUSET=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEMCG=y
-CONFIG_CGROUP_MEMCG_SWAP=y
-# CONFIG_CGROUP_MEMCG_SWAP_ENABLED is not set
-# CONFIG_CGROUP_MEMCG_KMEM is not set
+# CONFIG_MEMCG is not set
 CONFIG_CGROUP_SCHED=y
 CONFIG_FAIR_GROUP_SCHED=y
 # CONFIG_CFS_BANDWIDTH is not set
@@ -172,8 +176,9 @@ CONFIG_IPC_NS=y
 # CONFIG_USER_NS is not set
 # CONFIG_PID_NS is not set
 CONFIG_NET_NS=y
+CONFIG_UIDGID_CONVERTED=y
+# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
 # CONFIG_SCHED_AUTOGROUP is not set
-CONFIG_MM_OWNER=y
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_SYSFS_DEPRECATED_V2 is not set
 # CONFIG_RELAY is not set
@@ -181,12 +186,12 @@ CONFIG_SYSFS_DEPRECATED=y
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
 CONFIG_ANON_INODES=y
+CONFIG_HAVE_UID16=y
 # CONFIG_EXPERT is not set
 CONFIG_UID16=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
-CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
@@ -208,6 +213,12 @@ CONFIG_COMPAT_BRK=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_PROFILING is not set
+# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
+CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
+CONFIG_MODULES_USE_ELF_REL=y
+CONFIG_CLONE_BACKWARDS=y
+CONFIG_OLD_SIGSUSPEND3=y
+CONFIG_OLD_SIGACTION=y
 
 #
 # GCOV-based kernel profiling
@@ -222,17 +233,20 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
+# CONFIG_MODULE_SIG is not set
 CONFIG_BLOCK=y
 CONFIG_LBDAF=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_BLK_DEV_BSGLIB is not set
 # CONFIG_BLK_DEV_INTEGRITY is not set
+# CONFIG_BLK_DEV_THROTTLING is not set
 
 #
 # Partition Types
 #
 # CONFIG_PARTITION_ADVANCED is not set
 CONFIG_MSDOS_PARTITION=y
+CONFIG_EFI_PARTITION=y
 
 #
 # IO Schedulers
@@ -242,38 +256,13 @@ CONFIG_IOSCHED_DEADLINE=y
 CONFIG_IOSCHED_CFQ=m
 # CONFIG_CFQ_GROUP_IOSCHED is not set
 CONFIG_DEFAULT_DEADLINE=y
-# CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="deadline"
-# CONFIG_INLINE_SPIN_TRYLOCK is not set
-# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
-# CONFIG_INLINE_SPIN_LOCK is not set
-# CONFIG_INLINE_SPIN_LOCK_BH is not set
-# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
-# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
-CONFIG_INLINE_SPIN_UNLOCK=y
-# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
 CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
-# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
-# CONFIG_INLINE_READ_TRYLOCK is not set
-# CONFIG_INLINE_READ_LOCK is not set
-# CONFIG_INLINE_READ_LOCK_BH is not set
-# CONFIG_INLINE_READ_LOCK_IRQ is not set
-# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
 CONFIG_INLINE_READ_UNLOCK=y
-# CONFIG_INLINE_READ_UNLOCK_BH is not set
 CONFIG_INLINE_READ_UNLOCK_IRQ=y
-# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
-# CONFIG_INLINE_WRITE_TRYLOCK is not set
-# CONFIG_INLINE_WRITE_LOCK is not set
-# CONFIG_INLINE_WRITE_LOCK_BH is not set
-# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
-# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
 CONFIG_INLINE_WRITE_UNLOCK=y
-# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
 CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
-# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
-# CONFIG_MUTEX_SPIN_ON_OWNER is not set
 CONFIG_FREEZER=y
 
 #
@@ -311,11 +300,16 @@ CONFIG_PREVENT_FIRMWARE_BUILD=y
 CONFIG_FW_LOADER=y
 CONFIG_FIRMWARE_IN_KERNEL=y
 CONFIG_EXTRA_FIRMWARE=""
+CONFIG_FW_LOADER_USER_HELPER=y
 # CONFIG_DEBUG_DRIVER is not set
 # CONFIG_DEBUG_DEVRES is not set
 # CONFIG_SYS_HYPERVISOR is not set
 CONFIG_GENERIC_CPU_DEVICES=y
 # CONFIG_DMA_SHARED_BUFFER is not set
+
+#
+# Bus devices
+#
 # CONFIG_CONNECTOR is not set
 # CONFIG_MTD is not set
 CONFIG_BLK_DEV=y
@@ -325,10 +319,7 @@ CONFIG_BLK_DEV_COW_COMMON=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
-
-#
-# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
-#
+# CONFIG_BLK_DEV_DRBD is not set
 CONFIG_BLK_DEV_NBD=m
 # CONFIG_BLK_DEV_RAM is not set
 # CONFIG_ATA_OVER_ETH is not set
@@ -337,6 +328,7 @@ CONFIG_BLK_DEV_NBD=m
 #
 # Misc devices
 #
+# CONFIG_DUMMY_IRQ is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
 # CONFIG_C2PORT is not set
 
@@ -370,6 +362,7 @@ CONFIG_DUMMY=m
 # CONFIG_MII is not set
 # CONFIG_NET_TEAM is not set
 # CONFIG_MACVLAN is not set
+# CONFIG_VXLAN is not set
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
@@ -379,11 +372,20 @@ CONFIG_TUN=m
 #
 # CAIF transport drivers
 #
+
+#
+# Distributed Switch Architecture drivers
+#
+# CONFIG_NET_DSA_MV88E6XXX is not set
+# CONFIG_NET_DSA_MV88E6060 is not set
+# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
+# CONFIG_NET_DSA_MV88E6131 is not set
+# CONFIG_NET_DSA_MV88E6123_61_65 is not set
 CONFIG_ETHERNET=y
-CONFIG_NET_VENDOR_CHELSIO=y
 CONFIG_NET_VENDOR_INTEL=y
 CONFIG_NET_VENDOR_I825XX=y
 CONFIG_NET_VENDOR_MARVELL=y
+# CONFIG_MVMDIO is not set
 CONFIG_NET_VENDOR_NATSEMI=y
 CONFIG_NET_VENDOR_8390=y
 # CONFIG_PHYLIB is not set
@@ -403,6 +405,7 @@ CONFIG_SLHC=m
 # CONFIG_SLIP_MODE_SLIP6 is not set
 CONFIG_WLAN=y
 # CONFIG_HOSTAP is not set
+# CONFIG_WL_TI is not set
 
 #
 # Enable WiMAX (Networking options) to see the WiMAX drivers
@@ -412,6 +415,7 @@ CONFIG_WLAN=y
 #
 # Character devices
 #
+CONFIG_TTY=y
 CONFIG_UNIX98_PTYS=y
 # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
 CONFIG_LEGACY_PTYS=y
@@ -424,6 +428,13 @@ CONFIG_UML_RANDOM=y
 # CONFIG_R3964 is not set
 # CONFIG_NSC_GPIO is not set
 # CONFIG_RAW_DRIVER is not set
+# CONFIG_I2C is not set
+
+#
+# Qualcomm MSM SSBI bus support
+#
+# CONFIG_SSBI is not set
+# CONFIG_HSI is not set
 
 #
 # PPS support
@@ -437,11 +448,13 @@ CONFIG_UML_RANDOM=y
 #
 # PTP clock support
 #
+# CONFIG_PTP_1588_CLOCK is not set
 
 #
-# Enable Device Drivers -> PPS to see the PTP clock options.
+# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
 #
 # CONFIG_POWER_SUPPLY is not set
+# CONFIG_POWER_AVS is not set
 # CONFIG_THERMAL is not set
 # CONFIG_WATCHDOG is not set
 # CONFIG_REGULATOR is not set
@@ -451,11 +464,11 @@ CONFIG_SOUND_OSS_CORE_PRECLAIM=y
 # CONFIG_ACCESSIBILITY is not set
 # CONFIG_AUXDISPLAY is not set
 # CONFIG_UIO is not set
+# CONFIG_VIRT_DRIVERS is not set
 
 #
 # Virtio drivers
 #
-# CONFIG_VIRTIO_BALLOON is not set
 
 #
 # Microsoft Hyper-V guest support
@@ -465,15 +478,30 @@ CONFIG_SOUND_OSS_CORE_PRECLAIM=y
 #
 # Hardware Spinlock drivers
 #
+# CONFIG_MAILBOX is not set
 CONFIG_IOMMU_SUPPORT=y
-# CONFIG_VIRT_DRIVERS is not set
+
+#
+# Remoteproc drivers
+#
+
+#
+# Rpmsg drivers
+#
 # CONFIG_PM_DEVFREQ is not set
+# CONFIG_EXTCON is not set
+# CONFIG_MEMORY is not set
+# CONFIG_IIO is not set
+# CONFIG_PWM is not set
+# CONFIG_RESET_CONTROLLER is not set
+# CONFIG_FMC is not set
 CONFIG_NET=y
 
 #
 # Networking options
 #
 CONFIG_PACKET=y
+# CONFIG_PACKET_DIAG is not set
 CONFIG_UNIX=y
 # CONFIG_UNIX_DIAG is not set
 CONFIG_XFRM=y
@@ -488,8 +516,10 @@ CONFIG_INET=y
 # CONFIG_IP_PNP is not set
 # CONFIG_NET_IPIP is not set
 # CONFIG_NET_IPGRE_DEMUX is not set
+# CONFIG_NET_IP_TUNNEL is not set
 # CONFIG_ARPD is not set
 # CONFIG_SYN_COOKIES is not set
+# CONFIG_NET_IPVTI is not set
 # CONFIG_INET_AH is not set
 # CONFIG_INET_ESP is not set
 # CONFIG_INET_IPCOMP is not set
@@ -517,7 +547,7 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_ATM is not set
 # CONFIG_L2TP is not set
 # CONFIG_BRIDGE is not set
-# CONFIG_NET_DSA is not set
+CONFIG_HAVE_NET_DSA=y
 # CONFIG_VLAN_8021Q is not set
 # CONFIG_DECNET is not set
 # CONFIG_LLC2 is not set
@@ -525,14 +555,15 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_ATALK is not set
 # CONFIG_X25 is not set
 # CONFIG_LAPB is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
 # CONFIG_PHONET is not set
 # CONFIG_IEEE802154 is not set
 # CONFIG_NET_SCHED is not set
 # CONFIG_DCB is not set
 # CONFIG_BATMAN_ADV is not set
 # CONFIG_OPENVSWITCH is not set
+# CONFIG_VSOCKETS is not set
+# CONFIG_NETLINK_MMAP is not set
+# CONFIG_NETLINK_DIAG is not set
 # CONFIG_NETPRIO_CGROUP is not set
 CONFIG_BQL=y
 
@@ -579,11 +610,11 @@ CONFIG_UML_NET_SLIRP=y
 # CONFIG_EXT3_FS is not set
 CONFIG_EXT4_FS=y
 CONFIG_EXT4_USE_FOR_EXT23=y
-CONFIG_EXT4_FS_XATTR=y
 # CONFIG_EXT4_FS_POSIX_ACL is not set
 # CONFIG_EXT4_FS_SECURITY is not set
 # CONFIG_EXT4_DEBUG is not set
 CONFIG_JBD2=y
+# CONFIG_JBD2_DEBUG is not set
 CONFIG_FS_MBCACHE=y
 CONFIG_REISERFS_FS=y
 # CONFIG_REISERFS_CHECK is not set
@@ -659,10 +690,12 @@ CONFIG_MISC_FILESYSTEMS=y
 # CONFIG_OMFS_FS is not set
 # CONFIG_HPFS_FS is not set
 # CONFIG_QNX4FS_FS is not set
+# CONFIG_QNX6FS_FS is not set
 # CONFIG_ROMFS_FS is not set
 # CONFIG_PSTORE is not set
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
+# CONFIG_F2FS_FS is not set
 CONFIG_NETWORK_FILESYSTEMS=y
 # CONFIG_NFS_FS is not set
 # CONFIG_NFSD is not set
@@ -710,6 +743,17 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_ISO8859_15 is not set
 # CONFIG_NLS_KOI8_R is not set
 # CONFIG_NLS_KOI8_U is not set
+# CONFIG_NLS_MAC_ROMAN is not set
+# CONFIG_NLS_MAC_CELTIC is not set
+# CONFIG_NLS_MAC_CENTEURO is not set
+# CONFIG_NLS_MAC_CROATIAN is not set
+# CONFIG_NLS_MAC_CYRILLIC is not set
+# CONFIG_NLS_MAC_GAELIC is not set
+# CONFIG_NLS_MAC_GREEK is not set
+# CONFIG_NLS_MAC_ICELAND is not set
+# CONFIG_NLS_MAC_INUIT is not set
+# CONFIG_NLS_MAC_ROMANIAN is not set
+# CONFIG_NLS_MAC_TURKISH is not set
 # CONFIG_NLS_UTF8 is not set
 
 #
@@ -727,8 +771,10 @@ CONFIG_CRYPTO=y
 # Crypto core or helper
 #
 # CONFIG_CRYPTO_FIPS is not set
-CONFIG_CRYPTO_ALGAPI=m
-CONFIG_CRYPTO_ALGAPI2=m
+CONFIG_CRYPTO_ALGAPI=y
+CONFIG_CRYPTO_ALGAPI2=y
+CONFIG_CRYPTO_HASH=y
+CONFIG_CRYPTO_HASH2=y
 CONFIG_CRYPTO_RNG=m
 CONFIG_CRYPTO_RNG2=m
 # CONFIG_CRYPTO_MANAGER is not set
@@ -761,6 +807,7 @@ CONFIG_CRYPTO_RNG2=m
 #
 # Hash modes
 #
+# CONFIG_CRYPTO_CMAC is not set
 # CONFIG_CRYPTO_HMAC is not set
 # CONFIG_CRYPTO_XCBC is not set
 # CONFIG_CRYPTO_VMAC is not set
@@ -768,7 +815,8 @@ CONFIG_CRYPTO_RNG2=m
 #
 # Digest
 #
-# CONFIG_CRYPTO_CRC32C is not set
+CONFIG_CRYPTO_CRC32C=y
+# CONFIG_CRYPTO_CRC32 is not set
 # CONFIG_CRYPTO_GHASH is not set
 # CONFIG_CRYPTO_MD4 is not set
 # CONFIG_CRYPTO_MD5 is not set
@@ -786,7 +834,7 @@ CONFIG_CRYPTO_RNG2=m
 #
 # Ciphers
 #
-CONFIG_CRYPTO_AES=m
+CONFIG_CRYPTO_AES=y
 # CONFIG_CRYPTO_AES_586 is not set
 # CONFIG_CRYPTO_ANUBIS is not set
 # CONFIG_CRYPTO_ARC4 is not set
@@ -825,6 +873,7 @@ CONFIG_CRYPTO_HW=y
 # Library routines
 #
 CONFIG_BITREVERSE=y
+CONFIG_GENERIC_NET_UTILS=y
 CONFIG_GENERIC_FIND_FIRST_BIT=y
 CONFIG_GENERIC_IO=y
 # CONFIG_CRC_CCITT is not set
@@ -832,6 +881,11 @@ CONFIG_CRC16=y
 # CONFIG_CRC_T10DIF is not set
 # CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
+# CONFIG_CRC32_SELFTEST is not set
+CONFIG_CRC32_SLICEBY8=y
+# CONFIG_CRC32_SLICEBY4 is not set
+# CONFIG_CRC32_SARWATE is not set
+# CONFIG_CRC32_BIT is not set
 # CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 # CONFIG_CRC8 is not set
@@ -841,6 +895,7 @@ CONFIG_DQL=y
 CONFIG_NLATTR=y
 # CONFIG_AVERAGE is not set
 # CONFIG_CORDIC is not set
+# CONFIG_DDR is not set
 
 #
 # Kernel hacking
@@ -851,13 +906,15 @@ CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_FRAME_WARN=1024
 # CONFIG_STRIP_ASM_SYMS is not set
+# CONFIG_READABLE_ASM is not set
 # CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_SECTION_MISMATCH is not set
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_SHIRQ is not set
 # CONFIG_LOCKUP_DETECTOR is not set
-# CONFIG_HARDLOCKUP_DETECTOR is not set
+# CONFIG_PANIC_ON_OOPS is not set
+CONFIG_PANIC_ON_OOPS_VALUE=0
 # CONFIG_DETECT_HUNG_TASK is not set
 CONFIG_SCHED_DEBUG=y
 # CONFIG_SCHEDSTATS is not set
@@ -868,7 +925,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_RT_MUTEX_TESTER is not set
 # CONFIG_DEBUG_SPINLOCK is not set
 # CONFIG_DEBUG_MUTEXES is not set
-# CONFIG_SPARSE_RCU_POINTER is not set
 # CONFIG_DEBUG_ATOMIC_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_STACK_USAGE is not set
@@ -886,15 +942,24 @@ CONFIG_DEBUG_MEMORY_INIT=y
 # CONFIG_DEBUG_CREDENTIALS is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
+
+#
+# RCU Debugging
+#
+# CONFIG_SPARSE_RCU_POINTER is not set
 # CONFIG_RCU_TORTURE_TEST is not set
+# CONFIG_RCU_TRACE is not set
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
+# CONFIG_NOTIFIER_ERROR_INJECTION is not set
 # CONFIG_FAULT_INJECTION is not set
-# CONFIG_SYSCTL_SYSCALL_CHECK is not set
 # CONFIG_DEBUG_PAGEALLOC is not set
+# CONFIG_RBTREE_TEST is not set
+# CONFIG_INTERVAL_TREE_TEST is not set
 # CONFIG_ATOMIC64_SELFTEST is not set
 # CONFIG_SAMPLES is not set
+# CONFIG_TEST_STRING_HELPERS is not set
 # CONFIG_TEST_KSTRTOX is not set
 # CONFIG_GPROF is not set
 # CONFIG_GCOV is not set
diff --git a/arch/um/defconfig b/arch/um/configs/x86_64_defconfig
similarity index 83%
rename from arch/um/defconfig
rename to arch/um/configs/x86_64_defconfig
index 08107a7..f2c6123 100644
--- a/arch/um/defconfig
+++ b/arch/um/configs/x86_64_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated file; DO NOT EDIT.
-# User Mode Linux/i386 3.3.0 Kernel Configuration
+# User Mode Linux/x86 3.10.0 Kernel Configuration
 #
 CONFIG_DEFCONFIG_LIST="arch/$ARCH/defconfig"
 CONFIG_UML=y
@@ -11,7 +11,6 @@ CONFIG_LOCKDEP_SUPPORT=y
 # CONFIG_STACKTRACE_SUPPORT is not set
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_GENERIC_BUG=y
-CONFIG_GENERIC_CLOCKEVENTS=y
 CONFIG_HZ=100
 
 #
@@ -25,7 +24,7 @@ CONFIG_HZ=100
 # CONFIG_M586 is not set
 # CONFIG_M586TSC is not set
 # CONFIG_M586MMX is not set
-CONFIG_M686=y
+# CONFIG_M686 is not set
 # CONFIG_MPENTIUMII is not set
 # CONFIG_MPENTIUMIII is not set
 # CONFIG_MPENTIUMM is not set
@@ -43,79 +42,67 @@ CONFIG_M686=y
 # CONFIG_MCYRIXIII is not set
 # CONFIG_MVIAC3_2 is not set
 # CONFIG_MVIAC7 is not set
+# CONFIG_MPSC is not set
 # CONFIG_MCORE2 is not set
 # CONFIG_MATOM is not set
-# CONFIG_X86_GENERIC is not set
-CONFIG_X86_INTERNODE_CACHE_SHIFT=5
-CONFIG_X86_CMPXCHG=y
-CONFIG_X86_L1_CACHE_SHIFT=5
-CONFIG_X86_XADD=y
-CONFIG_X86_PPRO_FENCE=y
-CONFIG_X86_WP_WORKS_OK=y
-CONFIG_X86_INVLPG=y
-CONFIG_X86_BSWAP=y
-CONFIG_X86_POPAD_OK=y
-CONFIG_X86_USE_PPRO_CHECKSUM=y
+CONFIG_GENERIC_CPU=y
+CONFIG_X86_INTERNODE_CACHE_SHIFT=6
+CONFIG_X86_L1_CACHE_SHIFT=6
 CONFIG_X86_TSC=y
 CONFIG_X86_CMPXCHG64=y
 CONFIG_X86_CMOV=y
-CONFIG_X86_MINIMUM_CPU_FAMILY=5
+CONFIG_X86_MINIMUM_CPU_FAMILY=64
 CONFIG_CPU_SUP_INTEL=y
-CONFIG_CPU_SUP_CYRIX_32=y
 CONFIG_CPU_SUP_AMD=y
 CONFIG_CPU_SUP_CENTAUR=y
-CONFIG_CPU_SUP_TRANSMETA_32=y
-CONFIG_CPU_SUP_UMC_32=y
 CONFIG_UML_X86=y
-# CONFIG_64BIT is not set
-CONFIG_X86_32=y
-# CONFIG_X86_64 is not set
-# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
-CONFIG_RWSEM_GENERIC_SPINLOCK=y
-# CONFIG_3_LEVEL_PGTABLES is not set
-CONFIG_ARCH_HAS_SC_SIGNALS=y
-CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA=y
+CONFIG_64BIT=y
+# CONFIG_X86_32 is not set
+CONFIG_X86_64=y
+CONFIG_RWSEM_XCHGADD_ALGORITHM=y
+# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
+CONFIG_3_LEVEL_PGTABLES=y
+# CONFIG_ARCH_HAS_SC_SIGNALS is not set
+# CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA is not set
 CONFIG_GENERIC_HWEIGHT=y
 # CONFIG_STATIC_LINK is not set
-CONFIG_SELECT_MEMORY_MODEL=y
-CONFIG_FLATMEM_MANUAL=y
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
+# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
 CONFIG_PAGEFLAGS_EXTENDED=y
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_COMPACTION is not set
-# CONFIG_PHYS_ADDR_T_64BIT is not set
+CONFIG_PHYS_ADDR_T_64BIT=y
 CONFIG_ZONE_DMA_FLAG=0
-CONFIG_VIRT_TO_BUS=y
 # CONFIG_KSM is not set
 CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
+CONFIG_CROSS_MEMORY_ATTACH=y
 CONFIG_NEED_PER_CPU_KM=y
 # CONFIG_CLEANCACHE is not set
-CONFIG_TICK_ONESHOT=y
-CONFIG_NO_HZ=y
-CONFIG_HIGH_RES_TIMERS=y
-CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+# CONFIG_FRONTSWAP is not set
 CONFIG_LD_SCRIPT_DYN=y
 CONFIG_BINFMT_ELF=y
 CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
-CONFIG_HAVE_AOUT=y
-# CONFIG_BINFMT_AOUT is not set
+CONFIG_BINFMT_SCRIPT=y
+# CONFIG_HAVE_AOUT is not set
 CONFIG_BINFMT_MISC=m
+CONFIG_COREDUMP=y
 CONFIG_HOSTFS=y
 # CONFIG_HPPFS is not set
 CONFIG_MCONSOLE=y
 CONFIG_MAGIC_SYSRQ=y
-CONFIG_KERNEL_STACK_ORDER=0
+CONFIG_KERNEL_STACK_ORDER=1
 # CONFIG_MMAPPER is not set
 CONFIG_NO_DMA=y
+CONFIG_IRQ_WORK=y
 
 #
 # General setup
 #
-CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=128
 CONFIG_CROSS_COMPILE=""
+# CONFIG_COMPILE_TEST is not set
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_DEFAULT_HOSTNAME="(none)"
@@ -124,10 +111,7 @@ CONFIG_SYSVIPC=y
 CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_POSIX_MQUEUE_SYSCTL=y
-CONFIG_BSD_PROCESS_ACCT=y
-# CONFIG_BSD_PROCESS_ACCT_V3 is not set
 # CONFIG_FHANDLE is not set
-# CONFIG_TASKSTATS is not set
 # CONFIG_AUDIT is not set
 CONFIG_HAVE_GENERIC_HARDIRQS=y
 
@@ -136,13 +120,33 @@ CONFIG_HAVE_GENERIC_HARDIRQS=y
 #
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_SHOW=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+
+#
+# Timers subsystem
+#
+CONFIG_TICK_ONESHOT=y
+CONFIG_NO_HZ_COMMON=y
+# CONFIG_HZ_PERIODIC is not set
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
+
+#
+# CPU/Task time and stats accounting
+#
+CONFIG_TICK_CPU_ACCOUNTING=y
+CONFIG_BSD_PROCESS_ACCT=y
+# CONFIG_BSD_PROCESS_ACCT_V3 is not set
+# CONFIG_TASKSTATS is not set
 
 #
 # RCU Subsystem
 #
 CONFIG_TINY_RCU=y
 # CONFIG_PREEMPT_RCU is not set
-# CONFIG_RCU_TRACE is not set
+# CONFIG_RCU_STALL_COMMON is not set
 # CONFIG_TREE_RCU_TRACE is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
@@ -155,10 +159,7 @@ CONFIG_CPUSETS=y
 CONFIG_PROC_PID_CPUSET=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
-CONFIG_CGROUP_MEMCG=y
-CONFIG_CGROUP_MEMCG_SWAP=y
-# CONFIG_CGROUP_MEMCG_SWAP_ENABLED is not set
-# CONFIG_CGROUP_MEMCG_KMEM is not set
+# CONFIG_MEMCG is not set
 CONFIG_CGROUP_SCHED=y
 CONFIG_FAIR_GROUP_SCHED=y
 # CONFIG_CFS_BANDWIDTH is not set
@@ -172,8 +173,9 @@ CONFIG_IPC_NS=y
 # CONFIG_USER_NS is not set
 # CONFIG_PID_NS is not set
 CONFIG_NET_NS=y
+CONFIG_UIDGID_CONVERTED=y
+# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
 # CONFIG_SCHED_AUTOGROUP is not set
-CONFIG_MM_OWNER=y
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_SYSFS_DEPRECATED_V2 is not set
 # CONFIG_RELAY is not set
@@ -181,12 +183,12 @@ CONFIG_SYSFS_DEPRECATED=y
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
 CONFIG_ANON_INODES=y
+CONFIG_HAVE_UID16=y
 # CONFIG_EXPERT is not set
 CONFIG_UID16=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
-CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
@@ -208,6 +210,8 @@ CONFIG_COMPAT_BRK=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_PROFILING is not set
+CONFIG_HAVE_64BIT_ALIGNED_ACCESS=y
+CONFIG_MODULES_USE_ELF_RELA=y
 
 #
 # GCOV-based kernel profiling
@@ -222,17 +226,19 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
+# CONFIG_MODULE_SIG is not set
 CONFIG_BLOCK=y
-CONFIG_LBDAF=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_BLK_DEV_BSGLIB is not set
 # CONFIG_BLK_DEV_INTEGRITY is not set
+# CONFIG_BLK_DEV_THROTTLING is not set
 
 #
 # Partition Types
 #
 # CONFIG_PARTITION_ADVANCED is not set
 CONFIG_MSDOS_PARTITION=y
+CONFIG_EFI_PARTITION=y
 
 #
 # IO Schedulers
@@ -242,38 +248,13 @@ CONFIG_IOSCHED_DEADLINE=y
 CONFIG_IOSCHED_CFQ=m
 # CONFIG_CFQ_GROUP_IOSCHED is not set
 CONFIG_DEFAULT_DEADLINE=y
-# CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="deadline"
-# CONFIG_INLINE_SPIN_TRYLOCK is not set
-# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
-# CONFIG_INLINE_SPIN_LOCK is not set
-# CONFIG_INLINE_SPIN_LOCK_BH is not set
-# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
-# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
-CONFIG_INLINE_SPIN_UNLOCK=y
-# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
 CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
-# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
-# CONFIG_INLINE_READ_TRYLOCK is not set
-# CONFIG_INLINE_READ_LOCK is not set
-# CONFIG_INLINE_READ_LOCK_BH is not set
-# CONFIG_INLINE_READ_LOCK_IRQ is not set
-# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
 CONFIG_INLINE_READ_UNLOCK=y
-# CONFIG_INLINE_READ_UNLOCK_BH is not set
 CONFIG_INLINE_READ_UNLOCK_IRQ=y
-# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
-# CONFIG_INLINE_WRITE_TRYLOCK is not set
-# CONFIG_INLINE_WRITE_LOCK is not set
-# CONFIG_INLINE_WRITE_LOCK_BH is not set
-# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
-# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
 CONFIG_INLINE_WRITE_UNLOCK=y
-# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
 CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
-# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
-# CONFIG_MUTEX_SPIN_ON_OWNER is not set
 CONFIG_FREEZER=y
 
 #
@@ -311,11 +292,16 @@ CONFIG_PREVENT_FIRMWARE_BUILD=y
 CONFIG_FW_LOADER=y
 CONFIG_FIRMWARE_IN_KERNEL=y
 CONFIG_EXTRA_FIRMWARE=""
+CONFIG_FW_LOADER_USER_HELPER=y
 # CONFIG_DEBUG_DRIVER is not set
 # CONFIG_DEBUG_DEVRES is not set
 # CONFIG_SYS_HYPERVISOR is not set
 CONFIG_GENERIC_CPU_DEVICES=y
 # CONFIG_DMA_SHARED_BUFFER is not set
+
+#
+# Bus devices
+#
 # CONFIG_CONNECTOR is not set
 # CONFIG_MTD is not set
 CONFIG_BLK_DEV=y
@@ -325,10 +311,7 @@ CONFIG_BLK_DEV_COW_COMMON=y
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
-
-#
-# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
-#
+# CONFIG_BLK_DEV_DRBD is not set
 CONFIG_BLK_DEV_NBD=m
 # CONFIG_BLK_DEV_RAM is not set
 # CONFIG_ATA_OVER_ETH is not set
@@ -337,6 +320,7 @@ CONFIG_BLK_DEV_NBD=m
 #
 # Misc devices
 #
+# CONFIG_DUMMY_IRQ is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
 # CONFIG_C2PORT is not set
 
@@ -370,6 +354,7 @@ CONFIG_DUMMY=m
 # CONFIG_MII is not set
 # CONFIG_NET_TEAM is not set
 # CONFIG_MACVLAN is not set
+# CONFIG_VXLAN is not set
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
@@ -379,11 +364,20 @@ CONFIG_TUN=m
 #
 # CAIF transport drivers
 #
+
+#
+# Distributed Switch Architecture drivers
+#
+# CONFIG_NET_DSA_MV88E6XXX is not set
+# CONFIG_NET_DSA_MV88E6060 is not set
+# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
+# CONFIG_NET_DSA_MV88E6131 is not set
+# CONFIG_NET_DSA_MV88E6123_61_65 is not set
 CONFIG_ETHERNET=y
-CONFIG_NET_VENDOR_CHELSIO=y
 CONFIG_NET_VENDOR_INTEL=y
 CONFIG_NET_VENDOR_I825XX=y
 CONFIG_NET_VENDOR_MARVELL=y
+# CONFIG_MVMDIO is not set
 CONFIG_NET_VENDOR_NATSEMI=y
 CONFIG_NET_VENDOR_8390=y
 # CONFIG_PHYLIB is not set
@@ -403,6 +397,7 @@ CONFIG_SLHC=m
 # CONFIG_SLIP_MODE_SLIP6 is not set
 CONFIG_WLAN=y
 # CONFIG_HOSTAP is not set
+# CONFIG_WL_TI is not set
 
 #
 # Enable WiMAX (Networking options) to see the WiMAX drivers
@@ -412,6 +407,7 @@ CONFIG_WLAN=y
 #
 # Character devices
 #
+CONFIG_TTY=y
 CONFIG_UNIX98_PTYS=y
 # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
 CONFIG_LEGACY_PTYS=y
@@ -422,8 +418,14 @@ CONFIG_DEVKMEM=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_UML_RANDOM=y
 # CONFIG_R3964 is not set
-# CONFIG_NSC_GPIO is not set
 # CONFIG_RAW_DRIVER is not set
+# CONFIG_I2C is not set
+
+#
+# Qualcomm MSM SSBI bus support
+#
+# CONFIG_SSBI is not set
+# CONFIG_HSI is not set
 
 #
 # PPS support
@@ -437,11 +439,13 @@ CONFIG_UML_RANDOM=y
 #
 # PTP clock support
 #
+# CONFIG_PTP_1588_CLOCK is not set
 
 #
-# Enable Device Drivers -> PPS to see the PTP clock options.
+# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
 #
 # CONFIG_POWER_SUPPLY is not set
+# CONFIG_POWER_AVS is not set
 # CONFIG_THERMAL is not set
 # CONFIG_WATCHDOG is not set
 # CONFIG_REGULATOR is not set
@@ -451,11 +455,11 @@ CONFIG_SOUND_OSS_CORE_PRECLAIM=y
 # CONFIG_ACCESSIBILITY is not set
 # CONFIG_AUXDISPLAY is not set
 # CONFIG_UIO is not set
+# CONFIG_VIRT_DRIVERS is not set
 
 #
 # Virtio drivers
 #
-# CONFIG_VIRTIO_BALLOON is not set
 
 #
 # Microsoft Hyper-V guest support
@@ -465,15 +469,30 @@ CONFIG_SOUND_OSS_CORE_PRECLAIM=y
 #
 # Hardware Spinlock drivers
 #
+# CONFIG_MAILBOX is not set
 CONFIG_IOMMU_SUPPORT=y
-# CONFIG_VIRT_DRIVERS is not set
+
+#
+# Remoteproc drivers
+#
+
+#
+# Rpmsg drivers
+#
 # CONFIG_PM_DEVFREQ is not set
+# CONFIG_EXTCON is not set
+# CONFIG_MEMORY is not set
+# CONFIG_IIO is not set
+# CONFIG_PWM is not set
+# CONFIG_RESET_CONTROLLER is not set
+# CONFIG_FMC is not set
 CONFIG_NET=y
 
 #
 # Networking options
 #
 CONFIG_PACKET=y
+# CONFIG_PACKET_DIAG is not set
 CONFIG_UNIX=y
 # CONFIG_UNIX_DIAG is not set
 CONFIG_XFRM=y
@@ -488,8 +507,10 @@ CONFIG_INET=y
 # CONFIG_IP_PNP is not set
 # CONFIG_NET_IPIP is not set
 # CONFIG_NET_IPGRE_DEMUX is not set
+# CONFIG_NET_IP_TUNNEL is not set
 # CONFIG_ARPD is not set
 # CONFIG_SYN_COOKIES is not set
+# CONFIG_NET_IPVTI is not set
 # CONFIG_INET_AH is not set
 # CONFIG_INET_ESP is not set
 # CONFIG_INET_IPCOMP is not set
@@ -517,7 +538,7 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_ATM is not set
 # CONFIG_L2TP is not set
 # CONFIG_BRIDGE is not set
-# CONFIG_NET_DSA is not set
+CONFIG_HAVE_NET_DSA=y
 # CONFIG_VLAN_8021Q is not set
 # CONFIG_DECNET is not set
 # CONFIG_LLC2 is not set
@@ -525,14 +546,15 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_ATALK is not set
 # CONFIG_X25 is not set
 # CONFIG_LAPB is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
 # CONFIG_PHONET is not set
 # CONFIG_IEEE802154 is not set
 # CONFIG_NET_SCHED is not set
 # CONFIG_DCB is not set
 # CONFIG_BATMAN_ADV is not set
 # CONFIG_OPENVSWITCH is not set
+# CONFIG_VSOCKETS is not set
+# CONFIG_NETLINK_MMAP is not set
+# CONFIG_NETLINK_DIAG is not set
 # CONFIG_NETPRIO_CGROUP is not set
 CONFIG_BQL=y
 
@@ -579,11 +601,11 @@ CONFIG_UML_NET_SLIRP=y
 # CONFIG_EXT3_FS is not set
 CONFIG_EXT4_FS=y
 CONFIG_EXT4_USE_FOR_EXT23=y
-CONFIG_EXT4_FS_XATTR=y
 # CONFIG_EXT4_FS_POSIX_ACL is not set
 # CONFIG_EXT4_FS_SECURITY is not set
 # CONFIG_EXT4_DEBUG is not set
 CONFIG_JBD2=y
+# CONFIG_JBD2_DEBUG is not set
 CONFIG_FS_MBCACHE=y
 CONFIG_REISERFS_FS=y
 # CONFIG_REISERFS_CHECK is not set
@@ -659,10 +681,12 @@ CONFIG_MISC_FILESYSTEMS=y
 # CONFIG_OMFS_FS is not set
 # CONFIG_HPFS_FS is not set
 # CONFIG_QNX4FS_FS is not set
+# CONFIG_QNX6FS_FS is not set
 # CONFIG_ROMFS_FS is not set
 # CONFIG_PSTORE is not set
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
+# CONFIG_F2FS_FS is not set
 CONFIG_NETWORK_FILESYSTEMS=y
 # CONFIG_NFS_FS is not set
 # CONFIG_NFSD is not set
@@ -710,6 +734,17 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_ISO8859_15 is not set
 # CONFIG_NLS_KOI8_R is not set
 # CONFIG_NLS_KOI8_U is not set
+# CONFIG_NLS_MAC_ROMAN is not set
+# CONFIG_NLS_MAC_CELTIC is not set
+# CONFIG_NLS_MAC_CENTEURO is not set
+# CONFIG_NLS_MAC_CROATIAN is not set
+# CONFIG_NLS_MAC_CYRILLIC is not set
+# CONFIG_NLS_MAC_GAELIC is not set
+# CONFIG_NLS_MAC_GREEK is not set
+# CONFIG_NLS_MAC_ICELAND is not set
+# CONFIG_NLS_MAC_INUIT is not set
+# CONFIG_NLS_MAC_ROMANIAN is not set
+# CONFIG_NLS_MAC_TURKISH is not set
 # CONFIG_NLS_UTF8 is not set
 
 #
@@ -727,8 +762,10 @@ CONFIG_CRYPTO=y
 # Crypto core or helper
 #
 # CONFIG_CRYPTO_FIPS is not set
-CONFIG_CRYPTO_ALGAPI=m
-CONFIG_CRYPTO_ALGAPI2=m
+CONFIG_CRYPTO_ALGAPI=y
+CONFIG_CRYPTO_ALGAPI2=y
+CONFIG_CRYPTO_HASH=y
+CONFIG_CRYPTO_HASH2=y
 CONFIG_CRYPTO_RNG=m
 CONFIG_CRYPTO_RNG2=m
 # CONFIG_CRYPTO_MANAGER is not set
@@ -761,6 +798,7 @@ CONFIG_CRYPTO_RNG2=m
 #
 # Hash modes
 #
+# CONFIG_CRYPTO_CMAC is not set
 # CONFIG_CRYPTO_HMAC is not set
 # CONFIG_CRYPTO_XCBC is not set
 # CONFIG_CRYPTO_VMAC is not set
@@ -768,7 +806,8 @@ CONFIG_CRYPTO_RNG2=m
 #
 # Digest
 #
-# CONFIG_CRYPTO_CRC32C is not set
+CONFIG_CRYPTO_CRC32C=y
+# CONFIG_CRYPTO_CRC32 is not set
 # CONFIG_CRYPTO_GHASH is not set
 # CONFIG_CRYPTO_MD4 is not set
 # CONFIG_CRYPTO_MD5 is not set
@@ -786,8 +825,8 @@ CONFIG_CRYPTO_RNG2=m
 #
 # Ciphers
 #
-CONFIG_CRYPTO_AES=m
-# CONFIG_CRYPTO_AES_586 is not set
+CONFIG_CRYPTO_AES=y
+# CONFIG_CRYPTO_AES_X86_64 is not set
 # CONFIG_CRYPTO_ANUBIS is not set
 # CONFIG_CRYPTO_ARC4 is not set
 # CONFIG_CRYPTO_BLOWFISH is not set
@@ -798,12 +837,12 @@ CONFIG_CRYPTO_AES=m
 # CONFIG_CRYPTO_FCRYPT is not set
 # CONFIG_CRYPTO_KHAZAD is not set
 # CONFIG_CRYPTO_SALSA20 is not set
-# CONFIG_CRYPTO_SALSA20_586 is not set
+# CONFIG_CRYPTO_SALSA20_X86_64 is not set
 # CONFIG_CRYPTO_SEED is not set
 # CONFIG_CRYPTO_SERPENT is not set
 # CONFIG_CRYPTO_TEA is not set
 # CONFIG_CRYPTO_TWOFISH is not set
-# CONFIG_CRYPTO_TWOFISH_586 is not set
+# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
 
 #
 # Compression
@@ -825,6 +864,7 @@ CONFIG_CRYPTO_HW=y
 # Library routines
 #
 CONFIG_BITREVERSE=y
+CONFIG_GENERIC_NET_UTILS=y
 CONFIG_GENERIC_FIND_FIRST_BIT=y
 CONFIG_GENERIC_IO=y
 # CONFIG_CRC_CCITT is not set
@@ -832,6 +872,11 @@ CONFIG_CRC16=y
 # CONFIG_CRC_T10DIF is not set
 # CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
+# CONFIG_CRC32_SELFTEST is not set
+CONFIG_CRC32_SLICEBY8=y
+# CONFIG_CRC32_SLICEBY4 is not set
+# CONFIG_CRC32_SARWATE is not set
+# CONFIG_CRC32_BIT is not set
 # CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 # CONFIG_CRC8 is not set
@@ -841,6 +886,7 @@ CONFIG_DQL=y
 CONFIG_NLATTR=y
 # CONFIG_AVERAGE is not set
 # CONFIG_CORDIC is not set
+# CONFIG_DDR is not set
 
 #
 # Kernel hacking
@@ -851,13 +897,15 @@ CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_FRAME_WARN=1024
 # CONFIG_STRIP_ASM_SYMS is not set
+# CONFIG_READABLE_ASM is not set
 # CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_SECTION_MISMATCH is not set
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_SHIRQ is not set
 # CONFIG_LOCKUP_DETECTOR is not set
-# CONFIG_HARDLOCKUP_DETECTOR is not set
+# CONFIG_PANIC_ON_OOPS is not set
+CONFIG_PANIC_ON_OOPS_VALUE=0
 # CONFIG_DETECT_HUNG_TASK is not set
 CONFIG_SCHED_DEBUG=y
 # CONFIG_SCHEDSTATS is not set
@@ -868,7 +916,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_RT_MUTEX_TESTER is not set
 # CONFIG_DEBUG_SPINLOCK is not set
 # CONFIG_DEBUG_MUTEXES is not set
-# CONFIG_SPARSE_RCU_POINTER is not set
 # CONFIG_DEBUG_ATOMIC_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_STACK_USAGE is not set
@@ -886,15 +933,24 @@ CONFIG_DEBUG_MEMORY_INIT=y
 # CONFIG_DEBUG_CREDENTIALS is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
+
+#
+# RCU Debugging
+#
+# CONFIG_SPARSE_RCU_POINTER is not set
 # CONFIG_RCU_TORTURE_TEST is not set
+# CONFIG_RCU_TRACE is not set
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
+# CONFIG_NOTIFIER_ERROR_INJECTION is not set
 # CONFIG_FAULT_INJECTION is not set
-# CONFIG_SYSCTL_SYSCALL_CHECK is not set
 # CONFIG_DEBUG_PAGEALLOC is not set
+# CONFIG_RBTREE_TEST is not set
+# CONFIG_INTERVAL_TREE_TEST is not set
 # CONFIG_ATOMIC64_SELFTEST is not set
 # CONFIG_SAMPLES is not set
+# CONFIG_TEST_STRING_HELPERS is not set
 # CONFIG_TEST_KSTRTOX is not set
 # CONFIG_GPROF is not set
 # CONFIG_GCOV is not set
diff --git a/arch/x86/um/Kconfig b/arch/x86/um/Kconfig
index 14ef8d1..ed56a1c 100644
--- a/arch/x86/um/Kconfig
+++ b/arch/x86/um/Kconfig
@@ -31,6 +31,11 @@ config X86_64
 	def_bool 64BIT
 	select MODULES_USE_ELF_RELA
 
+config ARCH_DEFCONFIG
+	string
+	default "arch/um/configs/i386_defconfig" if X86_32
+	default "arch/um/configs/x86_64_defconfig" if X86_64
+
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool 64BIT
 
-- 
1.8.3.1.643.gebeea52.dirty

