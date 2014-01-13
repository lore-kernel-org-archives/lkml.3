Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaAMTYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:24:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:14852 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbaAMTXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:23:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,654,1384329600"; 
   d="scan'208";a="438183718"
Subject: [PATCH 03/12] x86 Kconfig: move highmem
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 13 Jan 2014 11:22:49 -0800
References: <20140113192245.3F682C7F@viggo.jf.intel.com>
In-Reply-To: <20140113192245.3F682C7F@viggo.jf.intel.com>
Message-Id: <20140113192249.3A34B048@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This just continues to move things under the Memory and NUMA
Options menu, breaking it up a bit to make the patches easier to
audit.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/Kconfig |  248 ++++++++++++++++++------------------
 1 file changed, 124 insertions(+), 124 deletions(-)

diff -puN arch/x86/Kconfig~x86-config-move-highmem arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~x86-config-move-highmem	2014-01-13 11:11:34.925179358 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2014-01-13 11:11:34.928179494 -0800
@@ -546,6 +546,130 @@ config X86_SUPPORTS_MEMORY_FAILURE
 	depends on X86_64 || !SPARSEMEM
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 
+choice
+	prompt "High Memory Support"
+	default HIGHMEM64G if X86_NUMAQ
+	default HIGHMEM4G
+	depends on X86_32
+
+config NOHIGHMEM
+	bool "off"
+	depends on !X86_NUMAQ
+	---help---
+	  Linux can use up to 64 Gigabytes of physical memory on x86 systems.
+	  However, the address space of 32-bit x86 processors is only 4
+	  Gigabytes large. That means that, if you have a large amount of
+	  physical memory, not all of it can be "permanently mapped" by the
+	  kernel. The physical memory that's not permanently mapped is called
+	  "high memory".
+
+	  If you are compiling a kernel which will never run on a machine with
+	  more than 1 Gigabyte total physical RAM, answer "off" here (default
+	  choice and suitable for most users). This will result in a "3GB/1GB"
+	  split: 3GB are mapped so that each process sees a 3GB virtual memory
+	  space and the remaining part of the 4GB virtual memory space is used
+	  by the kernel to permanently map as much physical memory as
+	  possible.
+
+	  If the machine has between 1 and 4 Gigabytes physical RAM, then
+	  answer "4GB" here.
+
+	  If more than 4 Gigabytes is used then answer "64GB" here. This
+	  selection turns Intel PAE (Physical Address Extension) mode on.
+	  PAE implements 3-level paging on IA32 processors. PAE is fully
+	  supported by Linux, PAE mode is implemented on all recent Intel
+	  processors (Pentium Pro and better). NOTE: If you say "64GB" here,
+	  then the kernel will not boot on CPUs that don't support PAE!
+
+	  The actual amount of total physical memory will either be
+	  auto detected or can be forced by using a kernel command line option
+	  such as "mem=256M". (Try "man bootparam" or see the documentation of
+	  your boot loader (lilo or loadlin) about how to pass options to the
+	  kernel at boot time.)
+
+	  If unsure, say "off".
+
+config HIGHMEM4G
+	bool "4GB"
+	depends on !X86_NUMAQ
+	---help---
+	  Select this if you have a 32-bit processor and between 1 and 4
+	  gigabytes of physical RAM.
+
+config HIGHMEM64G
+	bool "64GB"
+	depends on !M486
+	select X86_PAE
+	---help---
+	  Select this if you have a 32-bit processor and more than 4
+	  gigabytes of physical RAM.
+
+endchoice
+
+choice
+	prompt "Memory split" if EXPERT
+	default VMSPLIT_3G
+	depends on X86_32
+	---help---
+	  Select the desired split between kernel and user memory.
+
+	  If the address range available to the kernel is less than the
+	  physical memory installed, the remaining memory will be available
+	  as "high memory". Accessing high memory is a little more costly
+	  than low memory, as it needs to be mapped into the kernel first.
+	  Note that increasing the kernel address space limits the range
+	  available to user programs, making the address space there
+	  tighter.  Selecting anything other than the default 3G/1G split
+	  will also likely make your kernel incompatible with binary-only
+	  kernel modules.
+
+	  If you are not absolutely sure what you are doing, leave this
+	  option alone!
+
+	config VMSPLIT_3G
+		bool "3G/1G user/kernel split"
+	config VMSPLIT_3G_OPT
+		depends on !X86_PAE
+		bool "3G/1G user/kernel split (for full 1G low memory)"
+	config VMSPLIT_2G
+		bool "2G/2G user/kernel split"
+	config VMSPLIT_2G_OPT
+		depends on !X86_PAE
+		bool "2G/2G user/kernel split (for full 2G low memory)"
+	config VMSPLIT_1G
+		bool "1G/3G user/kernel split"
+endchoice
+
+config PAGE_OFFSET
+	hex
+	default 0xB0000000 if VMSPLIT_3G_OPT
+	default 0x80000000 if VMSPLIT_2G
+	default 0x78000000 if VMSPLIT_2G_OPT
+	default 0x40000000 if VMSPLIT_1G
+	default 0xC0000000
+	depends on X86_32
+
+config HIGHMEM
+	def_bool y
+	depends on X86_32 && (HIGHMEM64G || HIGHMEM4G)
+
+config X86_PAE
+	bool "PAE (Physical Address Extension) Support"
+	depends on X86_32 && !HIGHMEM4G
+	---help---
+	  PAE is required for NX support, and furthermore enables
+	  larger swapspace support for non-overcommit purposes. It
+	  has the cost of more pagetable lookup overhead, and also
+	  consumes more pagetable space per process.
+
+config ARCH_PHYS_ADDR_T_64BIT
+	def_bool y
+	depends on X86_64 || X86_PAE
+
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool y
+	depends on X86_64 || HIGHMEM64G
+
 endmenu # Memory and NUMA Options
 
 if X86_WANT_INTEL_MID
@@ -1174,130 +1298,6 @@ config X86_CPUID
 	  with major 203 and minors 0 to 31 for /dev/cpu/0/cpuid to
 	  /dev/cpu/31/cpuid.
 
-choice
-	prompt "High Memory Support"
-	default HIGHMEM64G if X86_NUMAQ
-	default HIGHMEM4G
-	depends on X86_32
-
-config NOHIGHMEM
-	bool "off"
-	depends on !X86_NUMAQ
-	---help---
-	  Linux can use up to 64 Gigabytes of physical memory on x86 systems.
-	  However, the address space of 32-bit x86 processors is only 4
-	  Gigabytes large. That means that, if you have a large amount of
-	  physical memory, not all of it can be "permanently mapped" by the
-	  kernel. The physical memory that's not permanently mapped is called
-	  "high memory".
-
-	  If you are compiling a kernel which will never run on a machine with
-	  more than 1 Gigabyte total physical RAM, answer "off" here (default
-	  choice and suitable for most users). This will result in a "3GB/1GB"
-	  split: 3GB are mapped so that each process sees a 3GB virtual memory
-	  space and the remaining part of the 4GB virtual memory space is used
-	  by the kernel to permanently map as much physical memory as
-	  possible.
-
-	  If the machine has between 1 and 4 Gigabytes physical RAM, then
-	  answer "4GB" here.
-
-	  If more than 4 Gigabytes is used then answer "64GB" here. This
-	  selection turns Intel PAE (Physical Address Extension) mode on.
-	  PAE implements 3-level paging on IA32 processors. PAE is fully
-	  supported by Linux, PAE mode is implemented on all recent Intel
-	  processors (Pentium Pro and better). NOTE: If you say "64GB" here,
-	  then the kernel will not boot on CPUs that don't support PAE!
-
-	  The actual amount of total physical memory will either be
-	  auto detected or can be forced by using a kernel command line option
-	  such as "mem=256M". (Try "man bootparam" or see the documentation of
-	  your boot loader (lilo or loadlin) about how to pass options to the
-	  kernel at boot time.)
-
-	  If unsure, say "off".
-
-config HIGHMEM4G
-	bool "4GB"
-	depends on !X86_NUMAQ
-	---help---
-	  Select this if you have a 32-bit processor and between 1 and 4
-	  gigabytes of physical RAM.
-
-config HIGHMEM64G
-	bool "64GB"
-	depends on !M486
-	select X86_PAE
-	---help---
-	  Select this if you have a 32-bit processor and more than 4
-	  gigabytes of physical RAM.
-
-endchoice
-
-choice
-	prompt "Memory split" if EXPERT
-	default VMSPLIT_3G
-	depends on X86_32
-	---help---
-	  Select the desired split between kernel and user memory.
-
-	  If the address range available to the kernel is less than the
-	  physical memory installed, the remaining memory will be available
-	  as "high memory". Accessing high memory is a little more costly
-	  than low memory, as it needs to be mapped into the kernel first.
-	  Note that increasing the kernel address space limits the range
-	  available to user programs, making the address space there
-	  tighter.  Selecting anything other than the default 3G/1G split
-	  will also likely make your kernel incompatible with binary-only
-	  kernel modules.
-
-	  If you are not absolutely sure what you are doing, leave this
-	  option alone!
-
-	config VMSPLIT_3G
-		bool "3G/1G user/kernel split"
-	config VMSPLIT_3G_OPT
-		depends on !X86_PAE
-		bool "3G/1G user/kernel split (for full 1G low memory)"
-	config VMSPLIT_2G
-		bool "2G/2G user/kernel split"
-	config VMSPLIT_2G_OPT
-		depends on !X86_PAE
-		bool "2G/2G user/kernel split (for full 2G low memory)"
-	config VMSPLIT_1G
-		bool "1G/3G user/kernel split"
-endchoice
-
-config PAGE_OFFSET
-	hex
-	default 0xB0000000 if VMSPLIT_3G_OPT
-	default 0x80000000 if VMSPLIT_2G
-	default 0x78000000 if VMSPLIT_2G_OPT
-	default 0x40000000 if VMSPLIT_1G
-	default 0xC0000000
-	depends on X86_32
-
-config HIGHMEM
-	def_bool y
-	depends on X86_32 && (HIGHMEM64G || HIGHMEM4G)
-
-config X86_PAE
-	bool "PAE (Physical Address Extension) Support"
-	depends on X86_32 && !HIGHMEM4G
-	---help---
-	  PAE is required for NX support, and furthermore enables
-	  larger swapspace support for non-overcommit purposes. It
-	  has the cost of more pagetable lookup overhead, and also
-	  consumes more pagetable space per process.
-
-config ARCH_PHYS_ADDR_T_64BIT
-	def_bool y
-	depends on X86_64 || X86_PAE
-
-config ARCH_DMA_ADDR_T_64BIT
-	def_bool y
-	depends on X86_64 || HIGHMEM64G
-
 config MATH_EMULATION
 	bool
 	prompt "Math emulation" if X86_32
_
