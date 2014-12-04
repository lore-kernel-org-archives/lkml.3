Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaLDBxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:53:46 -0500
Received: from mail-yk0-f169.google.com ([209.85.160.169]:42135 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaLDBxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:53:45 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [RFC PATCH] tinification: Introduce CONFIG_SRCU to make  SRCU optional
Date: Wed,  3 Dec 2014 20:54:06 -0500
Message-Id: <1417658046-4538-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC list restricted since this is just for initial feedback)

SRCU is not necessary to be compiled by default in all cases. For tinification
efforts not compiling SRCU unless necessary is desirable.

The current patch tries to make compiling SRCU optional by introducing a new
Kconfig option CONFIG_SRCU which is selected when any of the components making
use of SRCU are selected.

The current tinyconfig on x86 enables SRCU by default since x86 enables
PERF_EVENTS which in-turn require SRCU support. If we disable PERF_EVENTS, we
can disable compiling SRCU for tiny configs on x86 systems.

I tested this using randconfig and building about 15 kernels. This is definitely
not complete and could use more testing. Sticking it in next might help in that
regards.

Comments and suggestions are welcome. Please let me know if I should split
up this patch. 

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
 arch/x86/kvm/Kconfig     |  1 +
 drivers/md/Kconfig       |  1 +
 drivers/net/Kconfig      |  1 +
 fs/btrfs/Kconfig         |  1 +
 fs/notify/Kconfig        |  1 +
 init/Kconfig             | 10 ++++++++++
 kernel/rcu/Makefile      |  3 ++-
 lib/Kconfig.debug        |  1 +
 mm/Kconfig               |  1 +
 security/tomoyo/Kconfig  |  1 +
 17 files changed, 27 insertions(+), 1 deletion(-)

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
index 4706386..221e623 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -176,6 +176,7 @@ config NETCONSOLE_DYNAMIC
 
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
index 3ee28ae..80ac0a4 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -501,6 +501,14 @@ config TINY_RCU
 
 endchoice
 
+config SRCU
+	bool "Sleepable form of RCU"
+	def_bool n
+	help
+	  This option selects the sleepable version of RCU. This version
+	  permits arbitrary sleeping or blocking within RCU read-side critical
+	  sections.
+
 config PREEMPT_RCU
 	def_bool TREE_PREEMPT_RCU
 	help
@@ -510,6 +518,7 @@ config PREEMPT_RCU
 config TASKS_RCU
 	bool "Task_based RCU implementation using voluntary context switch"
 	default n
+	select SRCU
 	help
 	  This option enables a task-based RCU implementation that uses
 	  only voluntary context switch (not preemption!), idle, and
@@ -1586,6 +1595,7 @@ config PERF_EVENTS
 	depends on HAVE_PERF_EVENTS
 	select ANON_INODES
 	select IRQ_WORK
+	select SRCU
 	help
 	  Enable kernel support for various performance events provided
 	  by software and hardware.
diff --git a/kernel/rcu/Makefile b/kernel/rcu/Makefile
index 807ccfb..a484080 100644
--- a/kernel/rcu/Makefile
+++ b/kernel/rcu/Makefile
@@ -1,4 +1,5 @@
-obj-y += update.o srcu.o
+obj-y += update.o
+obj-$(CONFIG_SRCU) += srcu.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_TREE_RCU) += tree.o
 obj-$(CONFIG_TREE_PREEMPT_RCU) += tree.o
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4e35a5d..797511a 100644
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

