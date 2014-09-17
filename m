Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbaIQWdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:33:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:45348 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726AbaIQWdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:33:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="387735130"
Subject: [RFC][PATCH 6/6] sched: consolidate config options
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, hpa@linux.intel.com, brice.goglin@gmail.com,
        bp@alien8.de, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Wed, 17 Sep 2014 15:33:20 -0700
References: <20140917223310.026BCC2C@viggo.jf.intel.com>
In-Reply-To: <20140917223310.026BCC2C@viggo.jf.intel.com>
Message-Id: <20140917223320.2FF9CF11@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I originally did this when renaming CONFIG_SCHED_MC.  I ended up
not renaming it, but I still think it's nice to have all the
Kconfigs consolidated like this.

--

From: Dave Hansen <dave.hansen@linux.intel.com>

We have 2 config options (SCHED_MC and SCHED_SMT) which are used
across a few architectures.  We have one (SCHED_BOOK) only used
on s390.

The Kconfig text for MC/SMT are copied verbatim across each of
the architectures that use it.  This consolidates them down to a
single Kconfig location.

This gives us a centrally-defined set of config options which
architectures can 'select' when needed.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/arm/Kconfig                       |   18 ++-----------
 b/arch/arm64/Kconfig                     |   18 ++-----------
 b/arch/ia64/Kconfig                      |    9 ------
 b/arch/mips/Kconfig                      |   14 +---------
 b/arch/powerpc/Kconfig                   |    8 -----
 b/arch/powerpc/platforms/Kconfig.cputype |    1 
 b/arch/s390/Kconfig                      |   14 ++--------
 b/arch/sh/Kconfig                        |    1 
 b/arch/sh/mm/Kconfig                     |    9 ------
 b/arch/sparc/Kconfig                     |   20 ++------------
 b/arch/x86/Kconfig                       |   20 ++------------
 b/kernel/sched/Kconfig                   |   42 +++++++++++++++++++++++++++++++
 12 files changed, 63 insertions(+), 111 deletions(-)

diff -puN arch/arm64/Kconfig~consolidate-config-SCHED_MC arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~consolidate-config-SCHED_MC	2014-09-17 15:28:58.592621508 -0700
+++ b/arch/arm64/Kconfig	2014-09-17 15:28:58.613622467 -0700
@@ -68,6 +68,8 @@ config ARM64
 	select SPARSE_IRQ
 	select SYSCTL_EXCEPTION_TRACE
 	select HAVE_CONTEXT_TRACKING
+	select ARCH_ENABLE_SCHED_MC
+	select ARCH_ENABLE_SCHED_SMT
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
@@ -235,21 +237,7 @@ config SMP
 
 	  If you don't know what to do here, say N.
 
-config SCHED_MC
-	bool "Multi-core scheduler support"
-	depends on SMP
-	help
-	  Multi-core scheduler support improves the CPU scheduler's decision
-	  making when dealing with multi-core CPU chips at a cost of slightly
-	  increased overhead in some places. If unsure say N here.
-
-config SCHED_SMT
-	bool "SMT scheduler support"
-	depends on SMP
-	help
-	  Improves the CPU scheduler's decision making when dealing with
-	  MultiThreading at a cost of slightly increased overhead in some
-	  places. If unsure say N here.
+source kernel/sched/Kconfig
 
 config NR_CPUS
 	int "Maximum number of CPUs (2-32)"
diff -puN arch/arm/Kconfig~consolidate-config-SCHED_MC arch/arm/Kconfig
--- a/arch/arm/Kconfig~consolidate-config-SCHED_MC	2014-09-17 15:28:58.593621554 -0700
+++ b/arch/arm/Kconfig	2014-09-17 15:28:58.614622513 -0700
@@ -1355,27 +1355,15 @@ config SMP_ON_UP
 config ARM_CPU_TOPOLOGY
 	bool "Support cpu topology definition"
 	depends on SMP && CPU_V7
+	select ARCH_ENABLE_SCHED_MC
+	select ARCH_ENABLE_SCHED_SMT
 	default y
 	help
 	  Support ARM cpu topology definition. The MPIDR register defines
 	  affinity between processors which is then used to describe the cpu
 	  topology of an ARM System.
 
-config SCHED_MC
-	bool "Multi-core scheduler support"
-	depends on ARM_CPU_TOPOLOGY
-	help
-	  Multi-core scheduler support improves the CPU scheduler's decision
-	  making when dealing with multi-core CPU chips at a cost of slightly
-	  increased overhead in some places. If unsure say N here.
-
-config SCHED_SMT
-	bool "SMT scheduler support"
-	depends on ARM_CPU_TOPOLOGY
-	help
-	  Improves the CPU scheduler's decision making when dealing with
-	  MultiThreading at a cost of slightly increased overhead in some
-	  places. If unsure say N here.
+source kernel/sched/Kconfig
 
 config HAVE_ARM_SCU
 	bool
diff -puN arch/ia64/Kconfig~consolidate-config-SCHED_MC arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~consolidate-config-SCHED_MC	2014-09-17 15:28:58.595621644 -0700
+++ b/arch/ia64/Kconfig	2014-09-17 15:28:58.614622513 -0700
@@ -49,6 +49,7 @@ config IA64
 	select MODULES_USE_ELF_RELA
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select HAVE_ARCH_AUDITSYSCALL
+	select ARCH_ENABLE_SCHED_SMT
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
@@ -382,14 +383,6 @@ config ARCH_ENABLE_MEMORY_HOTPLUG
 config ARCH_ENABLE_MEMORY_HOTREMOVE
 	def_bool y
 
-config SCHED_SMT
-	bool "SMT scheduler support"
-	depends on SMP
-	help
-	  Improves the CPU scheduler's decision making when dealing with
-	  Intel IA64 chips with MultiThreading at a cost of slightly increased
-	  overhead in some places. If unsure say N here.
-
 config PERMIT_BSP_REMOVE
 	bool "Support removal of Bootstrap Processor"
 	depends on HOTPLUG_CPU
diff -puN arch/mips/Kconfig~consolidate-config-SCHED_MC arch/mips/Kconfig
--- a/arch/mips/Kconfig~consolidate-config-SCHED_MC	2014-09-17 15:28:58.597621736 -0700
+++ b/arch/mips/Kconfig	2014-09-17 15:28:58.615622560 -0700
@@ -1948,7 +1948,7 @@ config MIPS_MT_SMP
 	select SMP
 	select SMP_UP
 	select SYS_SUPPORTS_SMP
-	select SYS_SUPPORTS_SCHED_SMT
+	select ARCH_ENABLE_SCHED_SMT
 	select MIPS_PERF_SHARED_TC_COUNTERS
 	help
 	  This is a kernel model which is known as SMVP. This is supported
@@ -1960,17 +1960,7 @@ config MIPS_MT_SMP
 config MIPS_MT
 	bool
 
-config SCHED_SMT
-	bool "SMT (multithreading) scheduler support"
-	depends on SYS_SUPPORTS_SCHED_SMT
-	default n
-	help
-	  SMT scheduler support improves the CPU scheduler's decision making
-	  when dealing with MIPS MT enabled cores at a cost of slightly
-	  increased overhead in some places. If unsure say N here.
-
-config SYS_SUPPORTS_SCHED_SMT
-	bool
+source "kernel/sched/Kconfig"
 
 config SYS_SUPPORTS_MULTITHREADING
 	bool
diff -puN arch/powerpc/Kconfig~consolidate-config-SCHED_MC arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~consolidate-config-SCHED_MC	2014-09-17 15:28:58.599621828 -0700
+++ b/arch/powerpc/Kconfig	2014-09-17 15:28:58.616622606 -0700
@@ -603,14 +603,6 @@ config PPC_SUBPAGE_PROT
 	  to set access permissions (read/write, readonly, or no access)
 	  on the 4k subpages of each 64k page.
 
-config SCHED_SMT
-	bool "SMT (Hyperthreading) scheduler support"
-	depends on PPC64 && SMP
-	help
-	  SMT scheduler support improves the CPU scheduler's decision making
-	  when dealing with POWER5 cpus at a cost of slightly increased
-	  overhead in some places. If unsure say N here.
-
 config PPC_DENORMALISATION
 	bool "PowerPC denormalisation exception handling"
 	depends on PPC_BOOK3S_64
diff -puN arch/powerpc/platforms/Kconfig.cputype~consolidate-config-SCHED_MC arch/powerpc/platforms/Kconfig.cputype
--- a/arch/powerpc/platforms/Kconfig.cputype~consolidate-config-SCHED_MC	2014-09-17 15:28:58.600621874 -0700
+++ b/arch/powerpc/platforms/Kconfig.cputype	2014-09-17 15:28:58.616622606 -0700
@@ -2,6 +2,7 @@ config PPC64
 	bool "64-bit kernel"
 	default n
 	select HAVE_VIRT_CPU_ACCOUNTING
+	select SCHED_SMT if SMP
 	help
 	  This option selects whether a 32-bit or a 64-bit kernel
 	  will be built.
diff -puN arch/s390/Kconfig~consolidate-config-SCHED_MC arch/s390/Kconfig
--- a/arch/s390/Kconfig~consolidate-config-SCHED_MC	2014-09-17 15:28:58.602621966 -0700
+++ b/arch/s390/Kconfig	2014-09-17 15:28:58.617622652 -0700
@@ -146,6 +146,8 @@ config S390
 	select VIRT_CPU_ACCOUNTING
 	select VIRT_TO_BUS
 	select ARCH_HAS_SG_CHAIN
+	select ARCH_ENABLE_SCHED_BOOK
+	select ARCH_ENABLE_SCHED_MC
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
@@ -372,17 +374,7 @@ config HOTPLUG_CPU
 	  can be controlled through /sys/devices/system/cpu/cpu#.
 	  Say N if you want to disable CPU hotplug.
 
-config SCHED_MC
-	def_bool n
-
-config SCHED_BOOK
-	def_bool y
-	prompt "Book scheduler support"
-	depends on SMP
-	select SCHED_MC
-	help
-	  Book scheduler support improves the CPU scheduler's decision making
-	  when dealing with machines that have several books.
+source kernel/sched/Kconfig
 
 source kernel/Kconfig.preempt
 
diff -puN arch/sh/Kconfig~consolidate-config-SCHED_MC arch/sh/Kconfig
--- a/arch/sh/Kconfig~consolidate-config-SCHED_MC	2014-09-17 15:28:58.604622056 -0700
+++ b/arch/sh/Kconfig	2014-09-17 15:28:58.618622698 -0700
@@ -43,6 +43,7 @@ config SUPERH
 	select OLD_SIGSUSPEND
 	select OLD_SIGACTION
 	select HAVE_ARCH_AUDITSYSCALL
+	select ARCH_ENABLE_SCHED_MC
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff -puN arch/sh/mm/Kconfig~consolidate-config-SCHED_MC arch/sh/mm/Kconfig
--- a/arch/sh/mm/Kconfig~consolidate-config-SCHED_MC	2014-09-17 15:28:58.606622148 -0700
+++ b/arch/sh/mm/Kconfig	2014-09-17 15:28:58.618622698 -0700
@@ -226,14 +226,7 @@ endchoice
 
 source "mm/Kconfig"
 
-config SCHED_MC
-	bool "Multi-core scheduler support"
-	depends on SMP
-	default y
-	help
-	  Multi-core scheduler support improves the CPU scheduler's decision
-	  making when dealing with multi-core CPU chips at a cost of slightly
-	  increased overhead in some places. If unsure say N here.
+source "kernel/sched/Kconfig"
 
 endmenu
 
diff -puN arch/sparc/Kconfig~consolidate-config-SCHED_MC arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~consolidate-config-SCHED_MC	2014-09-17 15:28:58.607622194 -0700
+++ b/arch/sparc/Kconfig	2014-09-17 15:28:58.618622698 -0700
@@ -79,6 +79,8 @@ config SPARC64
 	select NO_BOOTMEM
 	select HAVE_ARCH_AUDITSYSCALL
 	select ARCH_SUPPORTS_ATOMIC_RMW
+	select ARCH_ENABLE_SCHED_MC if SMP
+	select ARCH_ENABLE_SCHED_SMT if SMP
 
 config ARCH_DEFCONFIG
 	string
@@ -306,23 +308,7 @@ if SPARC64
 source "kernel/power/Kconfig"
 endif
 
-config SCHED_SMT
-	bool "SMT (Hyperthreading) scheduler support"
-	depends on SPARC64 && SMP
-	default y
-	help
-	  SMT scheduler support improves the CPU scheduler's decision making
-	  when dealing with SPARC cpus at a cost of slightly increased overhead
-	  in some places. If unsure say N here.
-
-config SCHED_MC
-	bool "Multi-core scheduler support"
-	depends on SPARC64 && SMP
-	default y
-	help
-	  Multi-core scheduler support improves the CPU scheduler's decision
-	  making when dealing with multi-core CPU chips at a cost of slightly
-	  increased overhead in some places. If unsure say N here.
+source "kernel/sched/Kconfig"
 
 source "kernel/Kconfig.preempt"
 
diff -puN arch/x86/Kconfig~consolidate-config-SCHED_MC arch/x86/Kconfig
--- a/arch/x86/Kconfig~consolidate-config-SCHED_MC	2014-09-17 15:28:58.609622286 -0700
+++ b/arch/x86/Kconfig	2014-09-17 15:28:58.620622789 -0700
@@ -255,6 +255,8 @@ config X86_64_SMP
 config X86_HT
 	def_bool y
 	depends on SMP
+	select ARCH_ENABLE_SCHED_MC
+	select ARCH_ENABLE_SCHED_SMT
 
 config X86_32_LAZY_GS
 	def_bool y
@@ -789,23 +791,7 @@ config NR_CPUS
 	  This is purely to save memory - each supported CPU adds
 	  approximately eight kilobytes to the kernel image.
 
-config SCHED_SMT
-	bool "SMT (Hyperthreading) scheduler support"
-	depends on X86_HT
-	---help---
-	  SMT scheduler support improves the CPU scheduler's decision making
-	  when dealing with Intel Pentium 4 chips with HyperThreading at a
-	  cost of slightly increased overhead in some places. If unsure say
-	  N here.
-
-config SCHED_MC
-	def_bool y
-	prompt "Multi-core scheduler support"
-	depends on X86_HT
-	---help---
-	  Multi-core scheduler support improves the CPU scheduler's decision
-	  making when dealing with multi-core CPU chips at a cost of slightly
-	  increased overhead in some places. If unsure say N here.
+source "kernel/sched/Kconfig"
 
 source "kernel/Kconfig.preempt"
 
diff -puN /dev/null kernel/sched/Kconfig
--- /dev/null	2014-04-10 11:28:14.066815724 -0700
+++ b/kernel/sched/Kconfig	2014-09-17 15:28:58.620622789 -0700
@@ -0,0 +1,42 @@
+config ARCH_ENABLE_SCHED_MC
+	depends on SMP
+	def_bool n
+
+config ARCH_ENABLE_SCHED_BOOK
+	depends on SMP
+	def_bool n
+
+config ARCH_ENABLE_SCHED_SMT
+	depends on SMP
+	def_bool n
+
+config SCHED_MC
+	bool "Multi-core scheduler support"
+	default n if s390
+	default y
+	depends on ARCH_ENABLE_SCHED_MC
+	help
+	  Multi-core scheduler support improves the CPU scheduler's decision
+	  making when dealing with multi-core CPU chips at a cost of slightly
+	  increased overhead in some places. If unsure say N here.
+
+config SCHED_BOOK
+	def_bool y
+	prompt "Book scheduler support"
+	depends on ARCH_ENABLE_SCHED_BOOK
+	select SCHED_MC
+	help
+	  Book scheduler support improves the CPU scheduler's decision making
+	  when dealing with machines that have several books.
+
+	  Currenltly only used on s390 which has only a single NUMA node.
+	  Books are collections of CPUs that are grouped similarly to a NUMA
+	  node, but without the same memory properites that NUMA nodes have.
+
+config SCHED_SMT
+	bool "SMT scheduler support"
+	depends on ARCH_ENABLE_SCHED_SMT
+	help
+	  Improves the CPU scheduler's decision making when dealing with
+	  MultiThreading at a cost of slightly increased overhead in some
+	  places. If unsure say N here.
_
