Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaAMTXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:23:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:2008 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbaAMTXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:23:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,654,1384329600"; 
   d="scan'208";a="465999851"
Subject: [PATCH 08/12] x86 Kconfig: bury obscure options
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 13 Jan 2014 11:22:55 -0800
References: <20140113192245.3F682C7F@viggo.jf.intel.com>
In-Reply-To: <20140113192245.3F682C7F@viggo.jf.intel.com>
Message-Id: <20140113192255.8F618A38@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

While I respect the fact that the owners of Dell Inspiron 8000s
have kept I8K compiling and "working" all these years, the URL
referenced contains a helpful README:

> This package is no longer maintained by me. I don't use it
> anymore and I'm not interested in maintaing it. Please DON'T
> SEND BUG REPORT OR PATCHES.

In other words, this is unmaintained code for a single
13-year-old model of a single vendor's laptop.  I don't think
such an option deserves to have he same visibility as
"Preemption Model".

This patch creates an "Obscure x86 Options" menu, and sticks
it way at the bottom where we won't have to look at it.  It moves
a few very obscure drivers and hardware feature in to there.
Here's how the menu looks now:

	[*] Enable MPS table
	[*] Enable DMI scanning
	[*] Old AMD GART IOMMU support
	[*] IBM Calgary IOMMU support
	[*]   Should Calgary be enabled by default? (NEW)
	[*] Reroute for broken boot IRQs
	<*> Dell laptop support                                      

On 32-bit it also contains these:

	[*] Enable VM86 support
	< > Toshiba Laptop support
	< > Eurobraille/Iris poweroff module
	[ ] PentiumPro memory ordering errata workaround

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/Kconfig     |  321 ++++++++++++++++----------------
 linux.git-davehans/arch/x86/Kconfig.cpu |   13 -
 2 files changed, 169 insertions(+), 165 deletions(-)

diff -puN arch/x86/Kconfig~x86-mps-hide arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~x86-mps-hide	2014-01-13 11:11:35.976226874 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2014-01-13 11:11:35.980227055 -0800
@@ -495,14 +495,6 @@ config X86_X2APIC
 
 	  If you don't know what to do here, say N.
 
-config X86_MPPARSE
-	bool "Enable MPS table" if ACPI || SFI
-	default y
-	depends on X86_LOCAL_APIC
-	---help---
-	  For old smp systems that do not have proper acpi support. Newer systems
-	  (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
-
 config X86_BIGSMP
 	bool "Support for big SMP systems with more than 8 CPUs"
 	depends on X86_32 && SMP
@@ -946,19 +938,6 @@ config X86_ES7000
 	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
 	  supposed to run on an IA32-based Unisys ES7000 system.
 
-config X86_32_IRIS
-	tristate "Eurobraille/Iris poweroff module"
-	depends on X86_32
-	---help---
-	  The Iris machines from EuroBraille do not have APM or ACPI support
-	  to shut themselves down properly.  A special I/O sequence is
-	  needed to do so, which is what this module does at
-	  kernel shutdown.
-
-	  This is only for Iris machines from EuroBraille.
-
-	  If unused, say N.
-
 menuconfig HYPERVISOR_GUEST
 	bool "Linux guest support"
 	---help---
@@ -1088,67 +1067,6 @@ config APB_TIMER
          as it is off-chip. APB timers are always running regardless of CPU
          C states, they are used as per CPU clockevent device when possible.
 
-# Mark as expert because too many people got it wrong.
-# The code disables itself when not needed.
-config DMI
-	default y
-	bool "Enable DMI scanning" if EXPERT
-	---help---
-	  Enabled scanning of DMI to identify machine quirks. Say Y
-	  here unless you have verified that your setup is not
-	  affected by entries in the DMI blacklist. Required by PNP
-	  BIOS code.
-
-config GART_IOMMU
-	bool "Old AMD GART IOMMU support"
-	select SWIOTLB
-	depends on X86_64 && PCI && AMD_NB
-	---help---
-	  Provides a driver for older AMD Athlon64/Opteron/Turion/Sempron
-	  GART based hardware IOMMUs.
-
-	  The GART supports full DMA access for devices with 32-bit access
-	  limitations, on systems with more than 3 GB. This is usually needed
-	  for USB, sound, many IDE/SATA chipsets and some other devices.
-
-	  Newer systems typically have a modern AMD IOMMU, supported via
-	  the CONFIG_AMD_IOMMU=y config option.
-
-	  In normal configurations this driver is only active when needed:
-	  there's more than 3 GB of memory and the system contains a
-	  32-bit limited device.
-
-	  If unsure, say Y.
-
-config CALGARY_IOMMU
-	bool "IBM Calgary IOMMU support"
-	select SWIOTLB
-	depends on X86_64 && PCI
-	---help---
-	  Support for hardware IOMMUs in IBM's xSeries x366 and x460
-	  systems. Needed to run systems with more than 3GB of memory
-	  properly with 32-bit PCI devices that do not support DAC
-	  (Double Address Cycle). Calgary also supports bus level
-	  isolation, where all DMAs pass through the IOMMU.  This
-	  prevents them from going anywhere except their intended
-	  destination. This catches hard-to-find kernel bugs and
-	  mis-behaving drivers and devices that do not use the DMA-API
-	  properly to set up their DMA buffers.  The IOMMU can be
-	  turned off at boot time with the iommu=off parameter.
-	  Normally the kernel will make the right choice by itself.
-	  If unsure, say Y.
-
-config CALGARY_IOMMU_ENABLED_BY_DEFAULT
-	def_bool y
-	prompt "Should Calgary be enabled by default?"
-	depends on CALGARY_IOMMU
-	---help---
-	  Should Calgary be enabled by default? if you choose 'y', Calgary
-	  will be used (if it exists). If you choose 'n', Calgary will not be
-	  used even if it exists. If you choose 'n' and would like to use
-	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
-	  If unsure, say Y.
-
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
 	def_bool y if X86_64
@@ -1236,29 +1154,6 @@ config X86_VISWS_APIC
 	def_bool y
 	depends on X86_32 && X86_VISWS
 
-config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
-	bool "Reroute for broken boot IRQs"
-	depends on X86_IO_APIC
-	---help---
-	  This option enables a workaround that fixes a source of
-	  spurious interrupts. This is recommended when threaded
-	  interrupt handling is used on systems where the generation of
-	  superfluous "boot interrupts" cannot be disabled.
-
-	  Some chipsets generate a legacy INTx "boot IRQ" when the IRQ
-	  entry in the chipset's IO-APIC is masked (as, e.g. the RT
-	  kernel does during interrupt handling). On chipsets where this
-	  boot IRQ generation cannot be disabled, this workaround keeps
-	  the original IRQ line masked so that only the equivalent "boot
-	  IRQ" is delivered to the CPUs. The workaround also tells the
-	  kernel to set up the IRQ handler on the boot IRQ line. In this
-	  way only one interrupt is delivered to the kernel. Otherwise
-	  the spurious second interrupt may cause the kernel to bring
-	  down (vital) interrupt lines.
-
-	  Only affects "broken" chipsets. Interrupt sharing may be
-	  increased on these systems.
-
 config X86_MCE
 	bool "Machine Check / overheating reporting"
 	default y
@@ -1308,53 +1203,6 @@ config X86_THERMAL_VECTOR
 	def_bool y
 	depends on X86_MCE_INTEL
 
-config VM86
-	bool "Enable VM86 support" if EXPERT
-	default y
-	depends on X86_32
-	---help---
-	  This option is required by programs like DOSEMU to run 16-bit legacy
-	  code on X86 processors. It also may be needed by software like
-	  XFree86 to initialize some video cards via BIOS. Disabling this
-	  option saves about 6k.
-
-config TOSHIBA
-	tristate "Toshiba Laptop support"
-	depends on X86_32
-	---help---
-	  This adds a driver to safely access the System Management Mode of
-	  the CPU on Toshiba portables with a genuine Toshiba BIOS. It does
-	  not work on models with a Phoenix BIOS. The System Management Mode
-	  is used to set the BIOS and power saving options on Toshiba portables.
-
-	  For information on utilities to make use of this driver see the
-	  Toshiba Linux utilities web site at:
-	  <http://www.buzzard.org.uk/toshiba/>.
-
-	  Say Y if you intend to run this kernel on a Toshiba portable.
-	  Say N otherwise.
-
-config I8K
-	tristate "Dell laptop support"
-	select HWMON
-	---help---
-	  This adds a driver to safely access the System Management Mode
-	  of the CPU on the Dell Inspiron 8000. The System Management Mode
-	  is used to read cpu temperature and cooling fan status and to
-	  control the fans on the I8K portables.
-
-	  This driver has been tested only on the Inspiron 8000 but it may
-	  also work with other Dell laptops. You can force loading on other
-	  models by passing the parameter `force=1' to the module. Use at
-	  your own risk.
-
-	  For information on utilities to make use of this driver see the
-	  I8K Linux utilities web site at:
-	  <http://people.debian.org/~dz/i8k/>
-
-	  Say Y if you intend to run this kernel on a Dell Inspiron 8000.
-	  Say N otherwise.
-
 config X86_REBOOTFIXUPS
 	bool "Enable X86 board specific fixups for reboot"
 	depends on X86_32
@@ -1865,6 +1713,175 @@ config X86_NUMAQ
 
 endif # X86_EXTENDED_PLATFORM
 
+menu "Obscure x86 Options"
+
+config X86_MPPARSE
+	bool "Enable MPS table" if ACPI || SFI
+	default y
+	depends on X86_LOCAL_APIC
+	---help---
+	  For old smp systems that do not have proper acpi support. Newer systems
+	  (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
+
+# Mark as expert because too many people got it wrong.
+# The code disables itself when not needed.
+config DMI
+	default y
+	bool "Enable DMI scanning" if EXPERT
+	---help---
+	  Enabled scanning of DMI to identify machine quirks. Say Y
+	  here unless you have verified that your setup is not
+	  affected by entries in the DMI blacklist. Required by PNP
+	  BIOS code.
+
+config GART_IOMMU
+	bool "Old AMD GART IOMMU support"
+	select SWIOTLB
+	depends on X86_64 && PCI && AMD_NB
+	---help---
+	  Provides a driver for older AMD Athlon64/Opteron/Turion/Sempron
+	  GART based hardware IOMMUs.
+
+	  The GART supports full DMA access for devices with 32-bit access
+	  limitations, on systems with more than 3 GB. This is usually needed
+	  for USB, sound, many IDE/SATA chipsets and some other devices.
+
+	  Newer systems typically have a modern AMD IOMMU, supported via
+	  the CONFIG_AMD_IOMMU=y config option.
+
+	  In normal configurations this driver is only active when needed:
+	  there's more than 3 GB of memory and the system contains a
+	  32-bit limited device.
+
+	  If unsure, say Y.
+
+config CALGARY_IOMMU
+	bool "IBM Calgary IOMMU support"
+	select SWIOTLB
+	depends on X86_64 && PCI
+	---help---
+	  Support for hardware IOMMUs in IBM's xSeries x366 and x460
+	  systems. Needed to run systems with more than 3GB of memory
+	  properly with 32-bit PCI devices that do not support DAC
+	  (Double Address Cycle). Calgary also supports bus level
+	  isolation, where all DMAs pass through the IOMMU.  This
+	  prevents them from going anywhere except their intended
+	  destination. This catches hard-to-find kernel bugs and
+	  mis-behaving drivers and devices that do not use the DMA-API
+	  properly to set up their DMA buffers.  The IOMMU can be
+	  turned off at boot time with the iommu=off parameter.
+	  Normally the kernel will make the right choice by itself.
+	  If unsure, say Y.
+
+config CALGARY_IOMMU_ENABLED_BY_DEFAULT
+	def_bool y
+	prompt "Should Calgary be enabled by default?"
+	depends on CALGARY_IOMMU
+	---help---
+	  Should Calgary be enabled by default? if you choose 'y', Calgary
+	  will be used (if it exists). If you choose 'n', Calgary will not be
+	  used even if it exists. If you choose 'n' and would like to use
+	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
+	  If unsure, say Y.
+
+config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
+	bool "Reroute for broken boot IRQs"
+	depends on X86_IO_APIC
+	---help---
+	  This option enables a workaround that fixes a source of
+	  spurious interrupts. This is recommended when threaded
+	  interrupt handling is used on systems where the generation of
+	  superfluous "boot interrupts" cannot be disabled.
+
+	  Some chipsets generate a legacy INTx "boot IRQ" when the IRQ
+	  entry in the chipset's IO-APIC is masked (as, e.g. the RT
+	  kernel does during interrupt handling). On chipsets where this
+	  boot IRQ generation cannot be disabled, this workaround keeps
+	  the original IRQ line masked so that only the equivalent "boot
+	  IRQ" is delivered to the CPUs. The workaround also tells the
+	  kernel to set up the IRQ handler on the boot IRQ line. In this
+	  way only one interrupt is delivered to the kernel. Otherwise
+	  the spurious second interrupt may cause the kernel to bring
+	  down (vital) interrupt lines.
+
+	  Only affects "broken" chipsets. Interrupt sharing may be
+	  increased on these systems.
+
+config VM86
+	bool "Enable VM86 support" if EXPERT
+	default y
+	depends on X86_32
+	---help---
+	  This option is required by programs like DOSEMU to run 16-bit legacy
+	  code on X86 processors. It also may be needed by software like
+	  XFree86 to initialize some video cards via BIOS. Disabling this
+	  option saves about 6k.
+
+config TOSHIBA
+	tristate "Toshiba Laptop support"
+	depends on X86_32
+	---help---
+	  This adds a driver to safely access the System Management Mode of
+	  the CPU on Toshiba portables with a genuine Toshiba BIOS. It does
+	  not work on models with a Phoenix BIOS. The System Management Mode
+	  is used to set the BIOS and power saving options on Toshiba portables.
+
+	  For information on utilities to make use of this driver see the
+	  Toshiba Linux utilities web site at:
+	  <http://www.buzzard.org.uk/toshiba/>.
+
+	  Say Y if you intend to run this kernel on a Toshiba portable.
+	  Say N otherwise.
+
+config I8K
+	tristate "Dell laptop support"
+	select HWMON
+	---help---
+	  This adds a driver to safely access the System Management Mode
+	  of the CPU on the Dell Inspiron 8000. The System Management Mode
+	  is used to read cpu temperature and cooling fan status and to
+	  control the fans on the I8K portables.
+
+	  This driver has been tested only on the Inspiron 8000 but it may
+	  also work with other Dell laptops. You can force loading on other
+	  models by passing the parameter `force=1' to the module. Use at
+	  your own risk.
+
+	  For information on utilities to make use of this driver see the
+	  I8K Linux utilities web site at:
+	  <http://people.debian.org/~dz/i8k/>
+
+	  Say Y if you intend to run this kernel on a Dell Inspiron 8000.
+	  Say N otherwise.
+
+config X86_32_IRIS
+	tristate "Eurobraille/Iris poweroff module"
+	depends on X86_32
+	---help---
+	  The Iris machines from EuroBraille do not have APM or ACPI support
+	  to shut themselves down properly.  A special I/O sequence is
+	  needed to do so, which is what this module does at
+	  kernel shutdown.
+
+	  This is only for Iris machines from EuroBraille.
+
+	  If unused, say N.
+
+config X86_PPRO_FENCE
+	bool "PentiumPro memory ordering errata workaround"
+	depends on M686 || M586MMX || M586TSC || M586 || M486 || MGEODEGX1
+	---help---
+	  Old PentiumPro multiprocessor systems had errata that could cause
+	  memory operations to violate the x86 ordering standard in rare cases.
+	  Enabling this option will attempt to work around some (but not all)
+	  occurrences of this problem, at the cost of much heavier spinlock and
+	  memory barrier operations.
+
+	  If unsure, say n here. Even distro kernels should think twice before
+	  enabling this: there are few systems, and an unlikely bug.
+
+endmenu # "Obscure x86 Options"
+
 endmenu
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
diff -puN arch/x86/Kconfig.cpu~x86-mps-hide arch/x86/Kconfig.cpu
--- linux.git/arch/x86/Kconfig.cpu~x86-mps-hide	2014-01-13 11:11:35.977226919 -0800
+++ linux.git-davehans/arch/x86/Kconfig.cpu	2014-01-13 11:11:35.980227055 -0800
@@ -304,19 +304,6 @@ config X86_L1_CACHE_SHIFT
 	default "4" if MELAN || M486 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 
-config X86_PPRO_FENCE
-	bool "PentiumPro memory ordering errata workaround"
-	depends on M686 || M586MMX || M586TSC || M586 || M486 || MGEODEGX1
-	---help---
-	  Old PentiumPro multiprocessor systems had errata that could cause
-	  memory operations to violate the x86 ordering standard in rare cases.
-	  Enabling this option will attempt to work around some (but not all)
-	  occurrences of this problem, at the cost of much heavier spinlock and
-	  memory barrier operations.
-
-	  If unsure, say n here. Even distro kernels should think twice before
-	  enabling this: there are few systems, and an unlikely bug.
-
 config X86_F00F_BUG
 	def_bool y
 	depends on M586MMX || M586TSC || M586 || M486
_
