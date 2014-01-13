Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaAMTXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:23:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:2008 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbaAMTXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:23:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,654,1384329600"; 
   d="scan'208";a="465999829"
Subject: [PATCH 02/12] x86 Kconfig: memory options
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 13 Jan 2014 11:22:48 -0800
References: <20140113192245.3F682C7F@viggo.jf.intel.com>
In-Reply-To: <20140113192245.3F682C7F@viggo.jf.intel.com>
Message-Id: <20140113192248.BC4B996A@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This consolidates a bunch of VM, memory and NUMA options down to
be under a single Kconfig menu.  Most of this stuff is pretty
obscure, like HIGHPTE or ZONE_DMA support.  It doesn't really
deserve to be in the top-level menu.

For what it's worth "Processor type and features" seems to have
become mostly a dumping ground for architecture-specific
features.  Maybe we should just change the name of the menu too?

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/Kconfig |  450 ++++++++++++++++++------------------
 1 file changed, 227 insertions(+), 223 deletions(-)

diff -puN arch/x86/Kconfig~x86-memory-options arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~x86-memory-options	2014-01-13 11:11:34.717169954 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2014-01-13 11:11:34.720170090 -0800
@@ -264,16 +264,6 @@ source "kernel/Kconfig.freezer"
 
 menu "Processor type and features"
 
-config ZONE_DMA
-	bool "DMA memory allocation support" if EXPERT
-	default y
-	help
-	  DMA memory allocation support allows devices with less than 32-bit
-	  addressing to allocate within the first 16MB of address space.
-	  Disable if no such devices will be used.
-
-	  If unsure, say Y.
-
 config SMP
 	bool "Symmetric multi-processing support"
 	---help---
@@ -331,6 +321,233 @@ config GOLDFISH
        def_bool y
        depends on X86_GOLDFISH
 
+menu "Memory and NUMA Options"
+
+config ZONE_DMA
+	bool "DMA memory allocation support" if EXPERT
+	default y
+	help
+	  DMA memory allocation support allows devices with less than 32-bit
+	  addressing to allocate within the first 16MB of address space.
+	  Disable if no such devices will be used.
+
+	  If unsure, say Y.
+
+config DIRECT_GBPAGES
+	bool "Enable 1GB pages for kernel pagetables" if EXPERT
+	default y
+	depends on X86_64
+	---help---
+	  Allow the kernel linear mapping to use 1GB pages on CPUs that
+	  support it. This can improve the kernel's performance a tiny bit by
+	  reducing TLB pressure. If in doubt, say "Y".
+
+# Common NUMA Features
+config NUMA
+	bool "Numa Memory Allocation and Scheduler Support"
+	depends on SMP
+	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI))
+	default y if (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP)
+	---help---
+	  Enable NUMA (Non Uniform Memory Access) support.
+
+	  The kernel will try to allocate memory used by a CPU on the
+	  local memory controller of the CPU and add some more
+	  NUMA awareness to the kernel.
+
+	  For 64-bit this is recommended if the system is Intel Core i7
+	  (or later), AMD Opteron, or EM64T NUMA.
+
+	  For 32-bit this is only needed on (rare) 32-bit-only platforms
+	  that support NUMA topologies, such as NUMAQ / Summit, or if you
+	  boot a 32-bit kernel on a 64-bit NUMA platform.
+
+	  Otherwise, you should say N.
+
+comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
+	depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)
+
+config AMD_NUMA
+	def_bool y
+	prompt "Old style AMD Opteron NUMA detection"
+	depends on X86_64 && NUMA && PCI
+	---help---
+	  Enable AMD NUMA node topology detection.  You should say Y here if
+	  you have a multi processor AMD system. This uses an old method to
+	  read the NUMA configuration directly from the builtin Northbridge
+	  of Opteron. It is recommended to use X86_64_ACPI_NUMA instead,
+	  which also takes priority if both are compiled in.
+
+config X86_64_ACPI_NUMA
+	def_bool y
+	prompt "ACPI NUMA detection"
+	depends on X86_64 && NUMA && ACPI && PCI
+	select ACPI_NUMA
+	---help---
+	  Enable ACPI SRAT based node topology detection.
+
+# Some NUMA nodes have memory ranges that span
+# other nodes.  Even though a pfn is valid and
+# between a node's start and end pfns, it may not
+# reside on that node.  See memmap_init_zone()
+# for details.
+config NODES_SPAN_OTHER_NODES
+	def_bool y
+	depends on X86_64_ACPI_NUMA
+
+config NUMA_EMU
+	bool "NUMA emulation"
+	depends on NUMA
+	---help---
+	  Enable NUMA emulation. A flat machine will be split
+	  into virtual nodes when booted with "numa=fake=N", where N is the
+	  number of nodes. This is only useful for debugging.
+
+config NODES_SHIFT
+	int "Maximum NUMA Nodes (as a power of 2)" if !MAXSMP
+	range 1 10
+	default "10" if MAXSMP
+	default "6" if X86_64
+	default "4" if X86_NUMAQ
+	default "3"
+	depends on NEED_MULTIPLE_NODES
+	---help---
+	  Specify the maximum number of NUMA Nodes available on the target
+	  system.  Increases memory reserved to accommodate various tables.
+
+config ARCH_HAVE_MEMORY_PRESENT
+	def_bool y
+	depends on X86_32 && DISCONTIGMEM
+
+config NEED_NODE_MEMMAP_SIZE
+	def_bool y
+	depends on X86_32 && (DISCONTIGMEM || SPARSEMEM)
+
+config ARCH_FLATMEM_ENABLE
+	def_bool y
+	depends on X86_32 && !NUMA
+
+config ARCH_DISCONTIGMEM_ENABLE
+	def_bool y
+	depends on NUMA && X86_32
+
+config ARCH_DISCONTIGMEM_DEFAULT
+	def_bool y
+	depends on NUMA && X86_32
+
+config ARCH_SPARSEMEM_ENABLE
+	def_bool y
+	depends on X86_64 || NUMA || X86_32 || X86_32_NON_STANDARD
+	select SPARSEMEM_STATIC if X86_32
+	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
+
+config ARCH_SPARSEMEM_DEFAULT
+	def_bool y
+	depends on X86_64
+
+config ARCH_SELECT_MEMORY_MODEL
+	def_bool y
+	depends on ARCH_SPARSEMEM_ENABLE
+
+config ARCH_MEMORY_PROBE
+	bool "Enable sysfs memory/probe interface"
+	depends on X86_64 && MEMORY_HOTPLUG
+	help
+	  This option enables a sysfs memory/probe interface for testing.
+	  See Documentation/memory-hotplug.txt for more information.
+	  If you are unsure how to answer this question, answer N.
+
+config ARCH_PROC_KCORE_TEXT
+	def_bool y
+	depends on X86_64 && PROC_KCORE
+
+config ILLEGAL_POINTER_VALUE
+       hex
+       default 0 if X86_32
+       default 0xdead000000000000 if X86_64
+
+source "mm/Kconfig"
+
+config HIGHPTE
+	bool "Allocate 3rd-level pagetables from highmem"
+	depends on HIGHMEM
+	---help---
+	  The VM uses one page table entry for each page of physical memory.
+	  For systems with a lot of RAM, this can be wasteful of precious
+	  low memory.  Setting this option will put user-space page table
+	  entries in high memory.
+
+config X86_CHECK_BIOS_CORRUPTION
+	bool "Check for low memory corruption"
+	---help---
+	  Periodically check for memory corruption in low memory, which
+	  is suspected to be caused by BIOS.  Even when enabled in the
+	  configuration, it is disabled at runtime.  Enable it by
+	  setting "memory_corruption_check=1" on the kernel command
+	  line.  By default it scans the low 64k of memory every 60
+	  seconds; see the memory_corruption_check_size and
+	  memory_corruption_check_period parameters in
+	  Documentation/kernel-parameters.txt to adjust this.
+
+	  When enabled with the default parameters, this option has
+	  almost no overhead, as it reserves a relatively small amount
+	  of memory and scans it infrequently.  It both detects corruption
+	  and prevents it from affecting the running system.
+
+	  It is, however, intended as a diagnostic tool; if repeatable
+	  BIOS-originated corruption always affects the same memory,
+	  you can use memmap= to prevent the kernel from using that
+	  memory.
+
+config X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
+	bool "Set the default setting of memory_corruption_check"
+	depends on X86_CHECK_BIOS_CORRUPTION
+	default y
+	---help---
+	  Set whether the default state of memory_corruption_check is
+	  on or off.
+
+config X86_RESERVE_LOW
+	int "Amount of low memory, in kilobytes, to reserve for the BIOS"
+	default 64
+	range 4 640
+	---help---
+	  Specify the amount of low memory to reserve for the BIOS.
+
+	  The first page contains BIOS data structures that the kernel
+	  must not use, so that page must always be reserved.
+
+	  By default we reserve the first 64K of physical RAM, as a
+	  number of BIOSes are known to corrupt that memory range
+	  during events such as suspend/resume or monitor cable
+	  insertion, so it must not be used by the kernel.
+
+	  You can set this to 4 if you are absolutely sure that you
+	  trust the BIOS to get all its memory reservations and usages
+	  right.  If you know your BIOS have problems beyond the
+	  default 64K area, you can set this to 640 to avoid using the
+	  entire low memory range.
+
+	  If you have doubts about the BIOS (e.g. suspend/resume does
+	  not work or there's kernel crashes after certain hardware
+	  hotplug events) then you might want to enable
+	  X86_CHECK_BIOS_CORRUPTION=y to allow the kernel to check
+	  typical corruption patterns.
+
+	  Leave this to the default value of 64 if you are unsure.
+
+config X86_SUPPORTS_MEMORY_FAILURE
+	def_bool y
+	# MCE code calls memory_failure():
+	depends on X86_MCE
+	# On 32-bit this adds too big of NODES_SHIFT and we run out of page flags:
+	depends on !X86_NUMAQ
+	# On 32-bit SPARSEMEM adds too big of SECTIONS_WIDTH:
+	depends on X86_64 || !SPARSEMEM
+	select ARCH_SUPPORTS_MEMORY_FAILURE
+
+endmenu # Memory and NUMA Options
+
 if X86_WANT_INTEL_MID
 
 config X86_INTEL_MID
@@ -370,16 +587,6 @@ config X86_INTEL_LPSS
 	  things like clock tree (common clock framework) and pincontrol
 	  which are needed by the LPSS peripheral drivers.
 
-config X86_SUPPORTS_MEMORY_FAILURE
-	def_bool y
-	# MCE code calls memory_failure():
-	depends on X86_MCE
-	# On 32-bit this adds too big of NODES_SHIFT and we run out of page flags:
-	depends on !X86_NUMAQ
-	# On 32-bit SPARSEMEM adds too big of SECTIONS_WIDTH:
-	depends on X86_64 || !SPARSEMEM
-	select ARCH_SUPPORTS_MEMORY_FAILURE
-
 config X86_VISWS
 	bool "SGI 320/540 (Visual Workstation)"
 	depends on X86_32 && PCI && X86_MPPARSE && PCI_GODIRECT
@@ -1091,209 +1298,6 @@ config ARCH_DMA_ADDR_T_64BIT
 	def_bool y
 	depends on X86_64 || HIGHMEM64G
 
-config DIRECT_GBPAGES
-	bool "Enable 1GB pages for kernel pagetables" if EXPERT
-	default y
-	depends on X86_64
-	---help---
-	  Allow the kernel linear mapping to use 1GB pages on CPUs that
-	  support it. This can improve the kernel's performance a tiny bit by
-	  reducing TLB pressure. If in doubt, say "Y".
-
-# Common NUMA Features
-config NUMA
-	bool "Numa Memory Allocation and Scheduler Support"
-	depends on SMP
-	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI))
-	default y if (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP)
-	---help---
-	  Enable NUMA (Non Uniform Memory Access) support.
-
-	  The kernel will try to allocate memory used by a CPU on the
-	  local memory controller of the CPU and add some more
-	  NUMA awareness to the kernel.
-
-	  For 64-bit this is recommended if the system is Intel Core i7
-	  (or later), AMD Opteron, or EM64T NUMA.
-
-	  For 32-bit this is only needed on (rare) 32-bit-only platforms
-	  that support NUMA topologies, such as NUMAQ / Summit, or if you
-	  boot a 32-bit kernel on a 64-bit NUMA platform.
-
-	  Otherwise, you should say N.
-
-comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
-	depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)
-
-config AMD_NUMA
-	def_bool y
-	prompt "Old style AMD Opteron NUMA detection"
-	depends on X86_64 && NUMA && PCI
-	---help---
-	  Enable AMD NUMA node topology detection.  You should say Y here if
-	  you have a multi processor AMD system. This uses an old method to
-	  read the NUMA configuration directly from the builtin Northbridge
-	  of Opteron. It is recommended to use X86_64_ACPI_NUMA instead,
-	  which also takes priority if both are compiled in.
-
-config X86_64_ACPI_NUMA
-	def_bool y
-	prompt "ACPI NUMA detection"
-	depends on X86_64 && NUMA && ACPI && PCI
-	select ACPI_NUMA
-	---help---
-	  Enable ACPI SRAT based node topology detection.
-
-# Some NUMA nodes have memory ranges that span
-# other nodes.  Even though a pfn is valid and
-# between a node's start and end pfns, it may not
-# reside on that node.  See memmap_init_zone()
-# for details.
-config NODES_SPAN_OTHER_NODES
-	def_bool y
-	depends on X86_64_ACPI_NUMA
-
-config NUMA_EMU
-	bool "NUMA emulation"
-	depends on NUMA
-	---help---
-	  Enable NUMA emulation. A flat machine will be split
-	  into virtual nodes when booted with "numa=fake=N", where N is the
-	  number of nodes. This is only useful for debugging.
-
-config NODES_SHIFT
-	int "Maximum NUMA Nodes (as a power of 2)" if !MAXSMP
-	range 1 10
-	default "10" if MAXSMP
-	default "6" if X86_64
-	default "4" if X86_NUMAQ
-	default "3"
-	depends on NEED_MULTIPLE_NODES
-	---help---
-	  Specify the maximum number of NUMA Nodes available on the target
-	  system.  Increases memory reserved to accommodate various tables.
-
-config ARCH_HAVE_MEMORY_PRESENT
-	def_bool y
-	depends on X86_32 && DISCONTIGMEM
-
-config NEED_NODE_MEMMAP_SIZE
-	def_bool y
-	depends on X86_32 && (DISCONTIGMEM || SPARSEMEM)
-
-config ARCH_FLATMEM_ENABLE
-	def_bool y
-	depends on X86_32 && !NUMA
-
-config ARCH_DISCONTIGMEM_ENABLE
-	def_bool y
-	depends on NUMA && X86_32
-
-config ARCH_DISCONTIGMEM_DEFAULT
-	def_bool y
-	depends on NUMA && X86_32
-
-config ARCH_SPARSEMEM_ENABLE
-	def_bool y
-	depends on X86_64 || NUMA || X86_32 || X86_32_NON_STANDARD
-	select SPARSEMEM_STATIC if X86_32
-	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
-
-config ARCH_SPARSEMEM_DEFAULT
-	def_bool y
-	depends on X86_64
-
-config ARCH_SELECT_MEMORY_MODEL
-	def_bool y
-	depends on ARCH_SPARSEMEM_ENABLE
-
-config ARCH_MEMORY_PROBE
-	bool "Enable sysfs memory/probe interface"
-	depends on X86_64 && MEMORY_HOTPLUG
-	help
-	  This option enables a sysfs memory/probe interface for testing.
-	  See Documentation/memory-hotplug.txt for more information.
-	  If you are unsure how to answer this question, answer N.
-
-config ARCH_PROC_KCORE_TEXT
-	def_bool y
-	depends on X86_64 && PROC_KCORE
-
-config ILLEGAL_POINTER_VALUE
-       hex
-       default 0 if X86_32
-       default 0xdead000000000000 if X86_64
-
-source "mm/Kconfig"
-
-config HIGHPTE
-	bool "Allocate 3rd-level pagetables from highmem"
-	depends on HIGHMEM
-	---help---
-	  The VM uses one page table entry for each page of physical memory.
-	  For systems with a lot of RAM, this can be wasteful of precious
-	  low memory.  Setting this option will put user-space page table
-	  entries in high memory.
-
-config X86_CHECK_BIOS_CORRUPTION
-	bool "Check for low memory corruption"
-	---help---
-	  Periodically check for memory corruption in low memory, which
-	  is suspected to be caused by BIOS.  Even when enabled in the
-	  configuration, it is disabled at runtime.  Enable it by
-	  setting "memory_corruption_check=1" on the kernel command
-	  line.  By default it scans the low 64k of memory every 60
-	  seconds; see the memory_corruption_check_size and
-	  memory_corruption_check_period parameters in
-	  Documentation/kernel-parameters.txt to adjust this.
-
-	  When enabled with the default parameters, this option has
-	  almost no overhead, as it reserves a relatively small amount
-	  of memory and scans it infrequently.  It both detects corruption
-	  and prevents it from affecting the running system.
-
-	  It is, however, intended as a diagnostic tool; if repeatable
-	  BIOS-originated corruption always affects the same memory,
-	  you can use memmap= to prevent the kernel from using that
-	  memory.
-
-config X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
-	bool "Set the default setting of memory_corruption_check"
-	depends on X86_CHECK_BIOS_CORRUPTION
-	default y
-	---help---
-	  Set whether the default state of memory_corruption_check is
-	  on or off.
-
-config X86_RESERVE_LOW
-	int "Amount of low memory, in kilobytes, to reserve for the BIOS"
-	default 64
-	range 4 640
-	---help---
-	  Specify the amount of low memory to reserve for the BIOS.
-
-	  The first page contains BIOS data structures that the kernel
-	  must not use, so that page must always be reserved.
-
-	  By default we reserve the first 64K of physical RAM, as a
-	  number of BIOSes are known to corrupt that memory range
-	  during events such as suspend/resume or monitor cable
-	  insertion, so it must not be used by the kernel.
-
-	  You can set this to 4 if you are absolutely sure that you
-	  trust the BIOS to get all its memory reservations and usages
-	  right.  If you know your BIOS have problems beyond the
-	  default 64K area, you can set this to 640 to avoid using the
-	  entire low memory range.
-
-	  If you have doubts about the BIOS (e.g. suspend/resume does
-	  not work or there's kernel crashes after certain hardware
-	  hotplug events) then you might want to enable
-	  X86_CHECK_BIOS_CORRUPTION=y to allow the kernel to check
-	  typical corruption patterns.
-
-	  Leave this to the default value of 64 if you are unsure.
-
 config MATH_EMULATION
 	bool
 	prompt "Math emulation" if X86_32
_
