Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaAMTXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:23:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:31655 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbaAMTXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:23:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,654,1384329600"; 
   d="scan'208";a="458081185"
Subject: [PATCH 04/12] x86 Kconfig: processor options menu
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 13 Jan 2014 11:22:50 -0800
References: <20140113192245.3F682C7F@viggo.jf.intel.com>
In-Reply-To: <20140113192245.3F682C7F@viggo.jf.intel.com>
Message-Id: <20140113192250.38D9ADDB@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This tries to consolidate the actual processor options that
someone might want to configure.  It's a bit arbitrary how you
might separate these, but I at least took a stab at it.

The real goal here was to hide stuff that folks will rarely look
at, and to make them easier to find when folks _do_ need to
change them.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/Kconfig |  208 ++++++++++++++++++------------------
 1 file changed, 106 insertions(+), 102 deletions(-)

diff -puN arch/x86/Kconfig~processor-options arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~processor-options	2014-01-13 11:11:35.138188988 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2014-01-13 11:11:35.141189123 -0800
@@ -264,6 +264,8 @@ source "kernel/Kconfig.freezer"
 
 menu "Processor type and features"
 
+menu "Processor Options and Features"
+
 config SMP
 	bool "Symmetric multi-processing support"
 	---help---
@@ -292,6 +294,110 @@ config SMP
 
 	  If you don't know what to do here, say N.
 
+config MAXSMP
+	bool "Enable Maximum number of SMP Processors and NUMA Nodes"
+	depends on X86_64 && SMP && DEBUG_KERNEL
+	select CPUMASK_OFFSTACK
+	---help---
+	  Enable maximum number of CPUS and NUMA Nodes for this architecture.
+	  If unsure, say N.
+
+config NR_CPUS
+	int "Maximum number of CPUs" if SMP && !MAXSMP
+	range 2 8 if SMP && X86_32 && !X86_BIGSMP
+	range 2 512 if SMP && !MAXSMP && !CPUMASK_OFFSTACK
+	range 2 8192 if SMP && !MAXSMP && CPUMASK_OFFSTACK && X86_64
+	default "1" if !SMP
+	default "8192" if MAXSMP
+	default "32" if SMP && (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000)
+	default "8" if SMP
+	---help---
+	  This allows you to specify the maximum number of CPUs which this
+	  kernel will support.  If CPUMASK_OFFSTACK is enabled, the maximum
+	  supported value is 4096, otherwise the maximum value is 512.  The
+	  minimum value which makes sense is 2.
+
+	  This is purely to save memory - each supported CPU adds
+	  approximately eight kilobytes to the kernel image.
+
+config HOTPLUG_CPU
+	bool "Support for hot-pluggable CPUs"
+	depends on SMP
+	---help---
+	  Say Y here to allow turning CPUs off and on. CPUs can be
+	  controlled through /sys/devices/system/cpu.
+	  ( Note: power management support will enable this option
+	    automatically on SMP systems. )
+	  Say N if you want to disable CPU hotplug.
+
+config BOOTPARAM_HOTPLUG_CPU0
+	bool "Set default setting of cpu0_hotpluggable"
+	default n
+	depends on HOTPLUG_CPU
+	---help---
+	  Set whether default state of cpu0_hotpluggable is on or off.
+
+	  Say Y here to enable CPU0 hotplug by default. If this switch
+	  is turned on, there is no need to give cpu0_hotplug kernel
+	  parameter and the CPU0 hotplug feature is enabled by default.
+
+	  Please note: there are two known CPU0 dependencies if you want
+	  to enable the CPU0 hotplug feature either by this switch or by
+	  cpu0_hotplug kernel parameter.
+
+	  First, resume from hibernate or suspend always starts from CPU0.
+	  So hibernate and suspend are prevented if CPU0 is offline.
+
+	  Second dependency is PIC interrupts always go to CPU0. CPU0 can not
+	  offline if any interrupt can not migrate out of CPU0. There may
+	  be other CPU0 dependencies.
+
+	  Please make sure the dependencies are under your control before
+	  you enable this feature.
+
+	  Say N if you don't want to enable CPU0 hotplug feature by default.
+	  You still can enable the CPU0 hotplug feature at boot by kernel
+	  parameter cpu0_hotplug.
+
+config DEBUG_HOTPLUG_CPU0
+	def_bool n
+	prompt "Debug CPU0 hotplug"
+	depends on HOTPLUG_CPU
+	---help---
+	  Enabling this option offlines CPU0 (if CPU0 can be offlined) as
+	  soon as possible and boots up userspace with CPU0 offlined. User
+	  can online CPU0 back after boot time.
+
+	  To debug CPU0 hotplug, you need to enable CPU0 offline/online
+	  feature by either turning on CONFIG_BOOTPARAM_HOTPLUG_CPU0 during
+	  compilation or giving cpu0_hotplug kernel parameter at boot.
+
+	  If unsure, say N.
+
+source "arch/x86/Kconfig.cpu"
+
+config ARCH_RANDOM
+	def_bool y
+	prompt "x86 architectural random number generator" if EXPERT
+	---help---
+	  Enable the x86 architectural RDRAND instruction
+	  (Intel Bull Mountain technology) to generate random numbers.
+	  If supported, this is a high bandwidth, cryptographically
+	  secure hardware random number generator.
+
+config X86_SMAP
+	def_bool y
+	prompt "Supervisor Mode Access Prevention" if EXPERT
+	---help---
+	  Supervisor Mode Access Prevention (SMAP) is a security
+	  feature in newer Intel processors.  There is a small
+	  performance cost if this enabled and turned on; there is
+	  also a small increase in the kernel size if this is enabled.
+
+	  If unsure, say Y.
+
+endmenu # Processor Options
+
 config X86_X2APIC
 	bool "Support x2apic"
 	depends on X86_LOCAL_APIC && X86_64 && IRQ_REMAP
@@ -884,8 +990,6 @@ config X86_CYCLONE_TIMER
 	def_bool y
 	depends on X86_SUMMIT
 
-source "arch/x86/Kconfig.cpu"
-
 config HPET_TIMER
 	def_bool X86_64
 	prompt "HPET Timer Support" if X86_32
@@ -996,32 +1100,6 @@ config IOMMU_HELPER
 	def_bool y
 	depends on CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU
 
-config MAXSMP
-	bool "Enable Maximum number of SMP Processors and NUMA Nodes"
-	depends on X86_64 && SMP && DEBUG_KERNEL
-	select CPUMASK_OFFSTACK
-	---help---
-	  Enable maximum number of CPUS and NUMA Nodes for this architecture.
-	  If unsure, say N.
-
-config NR_CPUS
-	int "Maximum number of CPUs" if SMP && !MAXSMP
-	range 2 8 if SMP && X86_32 && !X86_BIGSMP
-	range 2 512 if SMP && !MAXSMP && !CPUMASK_OFFSTACK
-	range 2 8192 if SMP && !MAXSMP && CPUMASK_OFFSTACK && X86_64
-	default "1" if !SMP
-	default "8192" if MAXSMP
-	default "32" if SMP && (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000)
-	default "8" if SMP
-	---help---
-	  This allows you to specify the maximum number of CPUs which this
-	  kernel will support.  If CPUMASK_OFFSTACK is enabled, the maximum
-	  supported value is 4096, otherwise the maximum value is 512.  The
-	  minimum value which makes sense is 2.
-
-	  This is purely to save memory - each supported CPU adds
-	  approximately eight kilobytes to the kernel image.
-
 config SCHED_SMT
 	bool "SMT (Hyperthreading) scheduler support"
 	depends on X86_HT
@@ -1409,26 +1487,6 @@ config ARCH_USES_PG_UNCACHED
 	def_bool y
 	depends on X86_PAT
 
-config ARCH_RANDOM
-	def_bool y
-	prompt "x86 architectural random number generator" if EXPERT
-	---help---
-	  Enable the x86 architectural RDRAND instruction
-	  (Intel Bull Mountain technology) to generate random numbers.
-	  If supported, this is a high bandwidth, cryptographically
-	  secure hardware random number generator.
-
-config X86_SMAP
-	def_bool y
-	prompt "Supervisor Mode Access Prevention" if EXPERT
-	---help---
-	  Supervisor Mode Access Prevention (SMAP) is a security
-	  feature in newer Intel processors.  There is a small
-	  performance cost if this enabled and turned on; there is
-	  also a small increase in the kernel size if this is enabled.
-
-	  If unsure, say Y.
-
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
@@ -1614,60 +1672,6 @@ config PHYSICAL_ALIGN
 
 	  Don't change this unless you know what you are doing.
 
-config HOTPLUG_CPU
-	bool "Support for hot-pluggable CPUs"
-	depends on SMP
-	---help---
-	  Say Y here to allow turning CPUs off and on. CPUs can be
-	  controlled through /sys/devices/system/cpu.
-	  ( Note: power management support will enable this option
-	    automatically on SMP systems. )
-	  Say N if you want to disable CPU hotplug.
-
-config BOOTPARAM_HOTPLUG_CPU0
-	bool "Set default setting of cpu0_hotpluggable"
-	default n
-	depends on HOTPLUG_CPU
-	---help---
-	  Set whether default state of cpu0_hotpluggable is on or off.
-
-	  Say Y here to enable CPU0 hotplug by default. If this switch
-	  is turned on, there is no need to give cpu0_hotplug kernel
-	  parameter and the CPU0 hotplug feature is enabled by default.
-
-	  Please note: there are two known CPU0 dependencies if you want
-	  to enable the CPU0 hotplug feature either by this switch or by
-	  cpu0_hotplug kernel parameter.
-
-	  First, resume from hibernate or suspend always starts from CPU0.
-	  So hibernate and suspend are prevented if CPU0 is offline.
-
-	  Second dependency is PIC interrupts always go to CPU0. CPU0 can not
-	  offline if any interrupt can not migrate out of CPU0. There may
-	  be other CPU0 dependencies.
-
-	  Please make sure the dependencies are under your control before
-	  you enable this feature.
-
-	  Say N if you don't want to enable CPU0 hotplug feature by default.
-	  You still can enable the CPU0 hotplug feature at boot by kernel
-	  parameter cpu0_hotplug.
-
-config DEBUG_HOTPLUG_CPU0
-	def_bool n
-	prompt "Debug CPU0 hotplug"
-	depends on HOTPLUG_CPU
-	---help---
-	  Enabling this option offlines CPU0 (if CPU0 can be offlined) as
-	  soon as possible and boots up userspace with CPU0 offlined. User
-	  can online CPU0 back after boot time.
-
-	  To debug CPU0 hotplug, you need to enable CPU0 offline/online
-	  feature by either turning on CONFIG_BOOTPARAM_HOTPLUG_CPU0 during
-	  compilation or giving cpu0_hotplug kernel parameter at boot.
-
-	  If unsure, say N.
-
 config COMPAT_VDSO
 	def_bool y
 	prompt "Compat VDSO support"
_
