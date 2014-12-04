Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434AbaLDXuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:50:04 -0500
Received: from mail-yk0-f180.google.com ([209.85.160.180]:33880 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119AbaLDXuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:50:00 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH] tinification: Make SRCU optional by using CONFIG_SRCU
Date: Thu,  4 Dec 2014 18:50:24 -0500
Message-Id: <1417737024-13967-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SRCU is not necessary to be compiled by default in all cases. For tinification
efforts not compiling SRCU unless necessary is desirable.

The current patch tries to make compiling SRCU optional by introducing a new
Kconfig option CONFIG_SRCU which is selected when any of the components making
use of SRCU are selected.

If we do not select CONFIG_SRCU, srcu.o will not be compiled at all.

   text    data     bss     dec     hex filename
   2007       0       0    2007     7d7 kernel/rcu/srcu.o

Size of arch/powerpc/boot/zImage changes from

   text    data     bss     dec     hex filename
 831552   64180   23944  919676   e087c arch/powerpc/boot/zImage : before
 829504   64180   23952  917636   e0084 arch/powerpc/boot/zImage : after

so the savings are about ~2000 bytes.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
CC: Paul McKenney <paulmck@linux.vnet.ibm.com>
CC: Josh Triplett <josh@joshtriplett.org>
---
 arch/arm/kvm/Kconfig     |  1 +
 arch/arm64/kvm/Kconfig   |  1 +
 arch/ia64/kvm/Kconfig    |  1 +
 arch/mips/kvm/Kconfig    |  1 +
 arch/powerpc/kvm/Kconfig |  1 +
 arch/s390/kvm/Kconfig    |  1 +
 arch/tile/kvm/Kconfig    |  1 +
 arch/x86/Kconfig         |  1 +
 arch/x86/kvm/Kconfig     |  1 +
 drivers/clk/Kconfig      |  1 +
 drivers/cpufreq/Kconfig  |  1 +
 drivers/devfreq/Kconfig  |  1 +
 drivers/md/Kconfig       |  1 +
 drivers/net/Kconfig      |  1 +
 fs/btrfs/Kconfig         |  1 +
 fs/notify/Kconfig        |  1 +
 init/Kconfig             | 10 ++++++++++
 kernel/notifier.c        |  3 +++
 kernel/rcu/Makefile      |  3 ++-
 lib/Kconfig.debug        |  1 +
 mm/Kconfig               |  1 +
 security/tomoyo/Kconfig  |  1 +
 22 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 466bd29..3afee5f 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -23,6 +23,7 @@ config KVM
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select KVM_MMIO
 	select KVM_ARM_HOST
+	select SRCU
 	depends on ARM_VIRT_EXT && ARM_LPAE
 	---help---
 	  Support hosting virtualized guest machines. You will also
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 8ba85e9..b334084 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -26,6 +26,7 @@ config KVM
 	select KVM_ARM_HOST
 	select KVM_ARM_VGIC
 	select KVM_ARM_TIMER
+	select SRCU
 	---help---
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index 3d50ea9..f7d380b 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -29,6 +29,7 @@ config KVM
 	select HAVE_KVM_IRQ_ROUTING
 	select KVM_APIC_ARCHITECTURE
 	select KVM_MMIO
+	select SRCU
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index 30e334e..2ae1282 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -20,6 +20,7 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select KVM_MMIO
+	select SRCU
 	---help---
 	  Support for hosting Guest kernels.
 	  Currently supported on MIPS32 processors.
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 602eb51..af18e0f 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -21,6 +21,7 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select HAVE_KVM_EVENTFD
+	select SRCU
 
 config KVM_BOOK3S_HANDLER
 	bool
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 646db9c..5fce52c 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -28,6 +28,7 @@ config KVM
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQFD
 	select HAVE_KVM_IRQ_ROUTING
+	select SRCU
 	---help---
 	  Support hosting paravirtualized guest machines using the SIE
 	  virtualization capability on the mainframe. This should work
diff --git a/arch/tile/kvm/Kconfig b/arch/tile/kvm/Kconfig
index 2298cb1..1e968f7 100644
--- a/arch/tile/kvm/Kconfig
+++ b/arch/tile/kvm/Kconfig
@@ -21,6 +21,7 @@ config KVM
 	depends on HAVE_KVM && MODULES
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
+	select SRCU
 	---help---
 	  Support hosting paravirtualized guest machines.
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ded8a67..1c581a0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -137,6 +137,7 @@ config X86
 	select HAVE_ACPI_APEI_NMI if ACPI
 	select ACPI_LEGACY_TABLES_LOOKUP if ACPI
 	select X86_FEATURE_NAMES if PROC_FS
+	select SRCU
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index f9d16ff..7dc7ba5 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -40,6 +40,7 @@ config KVM
 	select HAVE_KVM_MSI
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select KVM_VFIO
+	select SRCU
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 455fd17..53e64f1 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -13,6 +13,7 @@ config COMMON_CLK
 	bool
 	select HAVE_CLK_PREPARE
 	select CLKDEV_LOOKUP
+	select SRCU
 	---help---
 	  The common clock framework is a single definition of struct
 	  clk, useful across many platforms, as well as an
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 3489f8f..ebaa0cc 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -2,6 +2,7 @@ menu "CPU Frequency scaling"
 
 config CPU_FREQ
 	bool "CPU Frequency scaling"
+	select SRCU
 	help
 	  CPU Frequency scaling allows you to change the clock speed of 
 	  CPUs on the fly. This is a nice method to save power, because 
diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index faf4e70..3891f67 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -1,5 +1,6 @@
 menuconfig PM_DEVFREQ
 	bool "Generic Dynamic Voltage and Frequency Scaling (DVFS) support"
+	select SRCU
 	help
 	  A device may have a list of frequencies and voltages available.
 	  devfreq, a generic DVFS framework can be registered for a device
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 5bdedf6..c355a22 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -5,6 +5,7 @@
 menuconfig MD
 	bool "Multiple devices driver support (RAID and LVM)"
 	depends on BLOCK
+	select SRCU
 	help
 	  Support multiple physical spindles through a single logical device.
 	  Required for RAID and logical volume management.
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index f9009be..1c7efb1 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -177,6 +177,7 @@ config NETCONSOLE_DYNAMIC
 
 config NETPOLL
 	def_bool NETCONSOLE
+	select SRCU
 
 config NET_POLL_CONTROLLER
 	def_bool NETPOLL
diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index a66768e..80e9c18 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -8,6 +8,7 @@ config BTRFS_FS
 	select LZO_DECOMPRESS
 	select RAID6_PQ
 	select XOR_BLOCKS
+	select SRCU
 
 	help
 	  Btrfs is a general purpose copy-on-write filesystem with extents,
diff --git a/fs/notify/Kconfig b/fs/notify/Kconfig
index 22c629e..2a24249 100644
--- a/fs/notify/Kconfig
+++ b/fs/notify/Kconfig
@@ -1,5 +1,6 @@
 config FSNOTIFY
 	def_bool n
+	select SRCU
 
 source "fs/notify/dnotify/Kconfig"
 source "fs/notify/inotify/Kconfig"
diff --git a/init/Kconfig b/init/Kconfig
index 903505e..100f4e7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -501,9 +501,18 @@ config TINY_RCU
 
 endchoice
 
+config SRCU
+	bool "Sleepable form of RCU"
+	def_bool n
+	help
+	  This option selects the sleepable version of RCU. This version
+	  permits arbitrary sleeping or blocking within RCU read-side critical
+	  sections.
+
 config TASKS_RCU
 	bool "Task_based RCU implementation using voluntary context switch"
 	default n
+	select SRCU
 	help
 	  This option enables a task-based RCU implementation that uses
 	  only voluntary context switch (not preemption!), idle, and
@@ -1593,6 +1602,7 @@ config PERF_EVENTS
 	depends on HAVE_PERF_EVENTS
 	select ANON_INODES
 	select IRQ_WORK
+	select SRCU
 	help
 	  Enable kernel support for various performance events provided
 	  by software and hardware.
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 4803da6..ae9fc7c 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -402,6 +402,7 @@ int raw_notifier_call_chain(struct raw_notifier_head *nh,
 }
 EXPORT_SYMBOL_GPL(raw_notifier_call_chain);
 
+#ifdef CONFIG_SRCU
 /*
  *	SRCU notifier chain routines.    Registration and unregistration
  *	use a mutex, and call_chain is synchronized by SRCU (no locks).
@@ -528,6 +529,8 @@ void srcu_init_notifier_head(struct srcu_notifier_head *nh)
 }
 EXPORT_SYMBOL_GPL(srcu_init_notifier_head);
 
+#endif /* CONFIG_SRCU */
+
 static ATOMIC_NOTIFIER_HEAD(die_chain);
 
 int notrace notify_die(enum die_val val, const char *str,
diff --git a/kernel/rcu/Makefile b/kernel/rcu/Makefile
index e6fae50..50a8084 100644
--- a/kernel/rcu/Makefile
+++ b/kernel/rcu/Makefile
@@ -1,4 +1,5 @@
-obj-y += update.o srcu.o
+obj-y += update.o
+obj-$(CONFIG_SRCU) += srcu.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_TREE_RCU) += tree.o
 obj-$(CONFIG_PREEMPT_RCU) += tree.o
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d780351..ce76f34 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1199,6 +1199,7 @@ config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
 	select TORTURE_TEST
+	select SRCU
 	default n
 	help
 	  This option provides a kernel module that runs torture tests
diff --git a/mm/Kconfig b/mm/Kconfig
index 1d1ae6b..4395b12 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -325,6 +325,7 @@ config VIRT_TO_BUS
 
 config MMU_NOTIFIER
 	bool
+	select SRCU
 
 config KSM
 	bool "Enable KSM for page merging"
diff --git a/security/tomoyo/Kconfig b/security/tomoyo/Kconfig
index 8eb779b9d..604e718 100644
--- a/security/tomoyo/Kconfig
+++ b/security/tomoyo/Kconfig
@@ -5,6 +5,7 @@ config SECURITY_TOMOYO
 	select SECURITYFS
 	select SECURITY_PATH
 	select SECURITY_NETWORK
+	select SRCU
 	default n
 	help
 	  This selects TOMOYO Linux, pathname-based access control.
-- 
1.9.1

