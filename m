Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaGVLB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:01:58 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:39113 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaGVLBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:01:54 -0400
Message-ID: <53CE449C.2090001@gmail.com>
Date: Tue, 22 Jul 2014 13:01:48 +0200
From: Klemen Jan Enova <klemen.jan.enova@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com, mingo@redhat.com, x86@kernel.org
Subject: [PATCH] arch: x86: boot: bioscall.S: simplify self-modification of
 the INT instruction
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the start of the intcall function, the %al register is compared to 
0x3f. If it does not equal 0x3f it is equated to it. Instruction flow 
continues in both cases from the label 1. The comparison is therefore 
unneeded.

Testing data is appended.

Signed-off-and-tested-by: Klemen Jan Enova <klemen.jan.enova@gmail.com>
---
diff --git a/arch/x86/boot/bioscall.S b/arch/x86/boot/bioscall.S
index d401b4a..a91ff8e 100644
--- a/arch/x86/boot/bioscall.S
+++ b/arch/x86/boot/bioscall.S
@@ -19,11 +19,8 @@
  	.type	intcall, @function
  intcall:
  	/* Self-modify the INT instruction.  Ugly, but works. */
-	cmpb	%al, 3f
-	je	1f
  	movb	%al, 3f
-	jmp	1f		/* Synchronize pipeline */
-1:
+
  	/* Save state */
  	pushfl
  	pushw	%fs

Testing:

--- box #1, 64 bit kernel version --- ✓

--- grep CONFIG_X86 .config

CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_NUMACHIP=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_UV is not set
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_X86_PAT=y
CONFIG_X86_SMAP=y
CONFIG_X86_PM_TIMER=y
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_P4_CLOCKMOD=m
CONFIG_X86_SPEEDSTEP_LIB=m
# CONFIG_X86_SYSFB is not set
CONFIG_X86_X32=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_X86_DECODER_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

--- sudo dmidecode

# dmidecode 2.12
SMBIOS 2.6 present.
23 structures occupying 1202 bytes.
Table at 0x000FD1D0.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: P1.80
	Release Date: 10/20/2010
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 2048 kB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		LS-120 boot is supported
		ATAPI Zip drive boot is supported
		BIOS boot specification is supported
		Function key-initiated network boot is supported
		Targeted content distribution is supported
	BIOS Revision: 8.15

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: ASRock
	Product Name: H55M-LE
	Version:
	Serial Number:
	Asset Tag:
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis:
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0004, DMI type 4, 42 bytes
Processor Information
	Socket Designation: CPUSocket
	Type: Central Processor
	Family: Core i3
	Manufacturer: Intel
	ID: 55 06 02 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 37, Stepping 5
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		DS (Debug store)
		ACPI (ACPI supported)
		MMX (MMX technology supported)
		FXSR (FXSAVE and FXSTOR instructions supported)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		SS (Self-snoop)
		HTT (Multi-threading)
		TM (Thermal monitor supported)
		PBE (Pending break enabled)
	Version: Intel(R) Core(TM) i3 CPU         540  @ 3.07GHz
	Voltage: Unknown
	External Clock: 133 MHz
	Max Speed: 3066 MHz
	Current Speed: 3066 MHz
	Status: Populated, Enabled
	Upgrade: Other
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: 0x0007
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Part Number: To Be Filled By O.E.M.
	Core Count: 2
	Core Enabled: 2
	Thread Count: 4
	Characteristics:
		64-bit capable

--- cat /proc/cpuinfo

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i3 CPU         540  @ 3.07GHz
stepping	: 5
microcode	: 0x2
cpu MHz		: 1200.000
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology 
nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 
xtpr pdcm pcid sse4_1 sse4_2 popcnt lahf_lm arat dtherm tpr_shadow vnmi 
flexpriority ept vpid
bogomips	: 6156.97
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

--- box #1, 32 bit kernel version --- ✓

--- grep CONFIG_X86 .config

CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_NON_STANDARD is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX32=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_X86_PAT=y
CONFIG_X86_SMAP=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_X86_PM_TIMER=y
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=m
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set
CONFIG_X86_SPEEDSTEP_LIB=m
# CONFIG_X86_SYSFB is not set
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_X86_DECODER_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

--- kvm, 64 bit CPUs ---

QEMU emulator version 2.0.0 (Debian 2.0.0+dfsg-2ubuntu1.1), Copyright 
(c) 2003-2008 Fabrice Bellard

QEMU uses the PC BIOS from the Seabios project and the Plex86/Bochs LGPL 
VGA BIOS.

	sudo kvm -cpu * -m 2G -hda /dev/sda

	- qemu64 ✓
	- phenom ✓
	- core2duo ✓
	- kvm64 ✓

--- kvm, 32 bit CPUs ---

	sudo kvm -cpu * -m 2G -hda /dev/sda

	- qemu32 ✓
	- coreduo ✓
	- pentium ✓
	- pentium2 ✓
	- pentium3 ✓
	- athlon ✓
	- n270 ✓
	- Conroe ✓
	- Penryn ✓
	- Nehalem ✓
	- Westmere ✓
	- SandyBridge ✓
	- Haswell ✓
	- Opteron_G1 ✓
	- Opteron_G2 ✓
	- Opteron_G3 ✓
	- Opteron_G4 ✓
	- Opteron_G5 ✓
