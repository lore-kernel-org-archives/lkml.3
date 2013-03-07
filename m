Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab3CGM5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:57:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab3CGM5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:57:39 -0500
Date: Thu, 7 Mar 2013 09:57:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130307095703.03d040ee@redhat.com>
In-Reply-To: <20121211140108.GC4303@liondog.tnic>
References: <20121211140108.GC4303@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Em Tue, 11 Dec 2012 15:01:08 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> Hi Linus,
> 
> please pull the 'for-linus' branch below to receive the following
> changes to EDAC:
> 
> * EDAC core error path fix, from Denis Kirjanov.
> 
> * Generalization of AMD MCE bank names and some minor error reporting
> improvements.
> 
> * EDAC core cleanups and simplifications, from Wei Yongjun.
> 
> * amd64_edac fixes for sysfs-reported values, from Josh Hunt.
> 
> * some heavy amd64_edac error reporting path shaving, leading to
> removing a bunch of code.
> 
> * amd64_edac error injection method improvements.
> 
> * EDAC core cleanups and fixes.
> 
> Thanks.
> 
> The following changes since commit 9489e9dcae718d5fde988e4a684a0f55b5f94d17:
> 
>   Linux 3.7-rc7 (2012-11-25 17:59:19 -0800)
> 
> are available in the git repository at:
> 
>   ssh://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus
> 
> for you to fetch changes up to 3bfe5aae8edd8436d26cddfeab783492d8950821:
> 
>   EDAC, pci_sysfs: Use for_each_pci_dev to simplify the code (2012-12-04 08:27:39 +0100)
> 
> ----------------------------------------------------------------
> Borislav Petkov (19):
>       EDAC: Respect operational state in edac_pci.c
>       EDAC: Boundary-check edac_debug_level
>       EDAC: Remove useless assignment of error type
>       EDAC: Handle empty msg strings when reporting errors
>       amd64_edac: Small fixlets and cleanups
>       amd64_edac: Cleanup error injection code
>       amd64_edac: Improve error injection
>       amd64_edac: Do not check whether error address is valid
>       amd64_edac: Reorganize error reporting path
>       amd64_edac: Fix K8 chip select reporting
>       amd64_edac: Use DBAM_DIMM macro
>       amd64_edac: Fix csrows size and pages computation
>       EDAC: Add memory controller flags
>       EDAC: Pass mci parent
>       EDAC: Fix csrow size reported in sysfs

As I pointed in the past, the above fix is wrong/incomplete.

After running my edac testbanch on an AMD64 machine, populated
with 4 DIMMS, each being a 4GB QUAD-rank DIMMs, the EDAC driver
reported 4 different memory configurations ;)

This is what the csrows nodes show:

/sys/devices/system/edac/mc/mc0/csrow2/size_mb:2048
/sys/devices/system/edac/mc/mc0/csrow3/size_mb:2048
/sys/devices/system/edac/mc/mc0/csrow6/size_mb:2048
/sys/devices/system/edac/mc/mc0/csrow7/size_mb:2048
/sys/devices/system/edac/mc/mc1/csrow2/size_mb:2048
/sys/devices/system/edac/mc/mc1/csrow3/size_mb:2048
/sys/devices/system/edac/mc/mc1/csrow6/size_mb:2048
/sys/devices/system/edac/mc/mc1/csrow7/size_mb:2048

Total size is 16Gb, but the number of ranks are wrong.

This is what's reported by the new API:

/sys/devices/system/edac/mc/mc0/rank12/size:2048
/sys/devices/system/edac/mc/mc0/rank13/size:2048
/sys/devices/system/edac/mc/mc0/rank14/size:2048
/sys/devices/system/edac/mc/mc0/rank15/size:2048
/sys/devices/system/edac/mc/mc0/rank4/size:2048
/sys/devices/system/edac/mc/mc0/rank5/size:2048
/sys/devices/system/edac/mc/mc0/rank6/size:2048
/sys/devices/system/edac/mc/mc0/rank7/size:2048
/sys/devices/system/edac/mc/mc1/rank12/size:2048
/sys/devices/system/edac/mc/mc1/rank13/size:2048
/sys/devices/system/edac/mc/mc1/rank14/size:2048
/sys/devices/system/edac/mc/mc1/rank15/size:2048
/sys/devices/system/edac/mc/mc1/rank4/size:2048
/sys/devices/system/edac/mc/mc1/rank5/size:2048
/sys/devices/system/edac/mc/mc1/rank6/size:2048
/sys/devices/system/edac/mc/mc1/rank7/size:2048

Here, the number of ranks are ok, but the size is wrong.

This is what the edac debug logs say:

[   18.829184] EDAC amd64: F10h detected (node 0).
[   18.829206] EDAC MC: DCT0 chip selects:
[   18.829207] EDAC amd64: MC: 0:     0MB 1:     0MB
[   18.829219] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   18.829220] EDAC amd64: MC: 4:     0MB 5:     0MB
[   18.829221] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   18.829222] EDAC MC: DCT1 chip selects:
[   18.829223] EDAC amd64: MC: 0:     0MB 1:     0MB
[   18.829223] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   18.829224] EDAC amd64: MC: 4:     0MB 5:     0MB
[   18.829225] EDAC amd64: MC: 6:  1024MB 7:  1024MB

[   18.923914] EDAC amd64: F10h detected (node 1).
[   18.956025] EDAC MC: DCT0 chip selects:
[   18.956028] EDAC amd64: MC: 0:     0MB 1:     0MB
[   18.962055] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   18.968167] EDAC amd64: MC: 4:     0MB 5:     0MB
[   18.974252] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   18.980333] EDAC MC: DCT1 chip selects:
[   18.980335] EDAC amd64: MC: 0:     0MB 1:     0MB
[   18.986415] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   18.991454] EDAC amd64: MC: 4:     0MB 5:     0MB
[   18.996155] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   19.000854] EDAC amd64: using x8 syndromes.

Here, everything is fine.

I'm enclosing the data from my edac testbench.

Regards,
Mauro


RUNNING driver amd64_edac_mod on kernel 3.9.0-rc1+, hostname dell-per515-01.lab.bos.redhat.com, at Qui Mar  7 07:36:00 EST 2013
# ./edac-ctl --layout
          +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
          |                                              mc0                                              |                                              mc1                                              |
          |  csrow0   |  csrow1   |  csrow2   |  csrow3   |  csrow4   |  csrow5   |  csrow6   |  csrow7   |  csrow0   |  csrow1   |  csrow2   |  csrow3   |  csrow4   |  csrow5   |  csrow6   |  csrow7   |
----------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
channel1: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |  2048 MB  |  2048 MB  |  2048 MB  |  2048 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |  2048 MB  |  2048 MB  |  2048 MB  |  2048 MB  |
channel0: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |  2048 MB  |  2048 MB  |  2048 MB  |  2048 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |  2048 MB  |  2048 MB  |  2048 MB  |  2048 MB  |
----------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
# ./edac-ctl --guess-labels
memory stick 'DIMM_A1' is located at 'Not Specified'
memory stick 'DIMM_A2' is located at 'Not Specified'
memory stick 'DIMM_A3' is located at 'Not Specified'
memory stick 'DIMM_A4' is located at 'Not Specified'
memory stick 'DIMM_B1' is located at 'Not Specified'
memory stick 'DIMM_B2' is located at 'Not Specified'
memory stick 'DIMM_B3' is located at 'Not Specified'
memory stick 'DIMM_B4' is located at 'Not Specified'
# free -l
             total       used       free     shared    buffers     cached
Mem:      16419864     360804   16059060          0       8992      80160
Low:      16419864     360804   16059060
High:            0          0          0
-/+ buffers/cache:     271652   16148212
Swap:      8216572          0    8216572
# dmidecode
# dmidecode 2.11
SMBIOS 2.6 present.
63 structures occupying 3505 bytes.
Table at 0xDF79C000.

Handle 0xDA00, DMI type 218, 11 bytes
OEM-specific Type
	Header and Data:
		DA 0B 00 DA B0 00 17 00 0E 20 00

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Dell Inc.
	Version: 1.2.5
	Release Date: 03/16/2011
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 4096 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		EDD is supported
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Function key-initiated network boot is supported
		Targeted content distribution is supported
	BIOS Revision: 1.2

Handle 0x0100, DMI type 1, 27 bytes
System Information
	Manufacturer: Dell Inc.
	Product Name: PowerEdge R515
	Version: Not Specified
	Serial Number: DM5QWP1
	UUID: 4C4C4544-004D-3510-8051-C4C04F575031
	Wake-up Type: Power Switch
	SKU Number: Not Specified
	Family: Not Specified

Handle 0x0200, DMI type 2, 9 bytes
Base Board Information
	Manufacturer: Dell Inc.
	Product Name: 03X0MN
	Version: A01
	Serial Number: ..CN717030BN0680.
	Asset Tag: Not Specified

Handle 0x0300, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: Dell Inc.
	Type: Rack Mount Chassis
	Lock: Present
	Version: Not Specified
	Serial Number: DM5QWP1
	Asset Tag: Not Specified
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: Unknown
	OEM Information: 0x00000000
	Height: 2 U
	Number Of Power Cords: Unspecified
	Contained Elements: 0

Handle 0x0400, DMI type 4, 40 bytes
Processor Information
	Socket Designation: CPU1
	Type: Central Processor
	Family: Six-Core Opteron
	Manufacturer: AMD
	ID: 81 0F 10 00 FF FB 8B 17
	Signature: Family 16, Model 8, Stepping 1
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
		MMX (MMX technology supported)
		FXSR (FXSAVE and FXSTOR instructions supported)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		HTT (Multi-threading)
	Version: AMD Opteron(tm) Processor 4162 EE              
	Voltage: 1.0 V
	External Clock: 3200 MHz
	Max Speed: 1700 MHz
	Current Speed: 1700 MHz
	Status: Populated, Enabled
	Upgrade: Socket AM3
	L1 Cache Handle: 0x0700
	L2 Cache Handle: 0x0701
	L3 Cache Handle: 0x0702
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified
	Core Count: 6
	Core Enabled: 6
	Thread Count: 6
	Characteristics:
		64-bit capable

Handle 0x0401, DMI type 4, 40 bytes
Processor Information
	Socket Designation: CPU2
	Type: Central Processor
	Family: Six-Core Opteron
	Manufacturer: AMD
	ID: 81 0F 10 00 FF FB 8B 17
	Signature: Family 16, Model 8, Stepping 1
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
		MMX (MMX technology supported)
		FXSR (FXSAVE and FXSTOR instructions supported)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		HTT (Multi-threading)
	Version: AMD Opteron(tm) Processor 4162 EE              
	Voltage: 1.0 V
	External Clock: 3200 MHz
	Max Speed: 1700 MHz
	Current Speed: 1700 MHz
	Status: Populated, Idle
	Upgrade: Socket AM3
	L1 Cache Handle: 0x0703
	L2 Cache Handle: 0x0704
	L3 Cache Handle: 0x0705
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified
	Core Count: 6
	Core Enabled: 6
	Thread Count: 6
	Characteristics:
		64-bit capable

Handle 0x0700, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Not Specified
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 768 kB
	Maximum Size: 768 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 2-way Set-associative

Handle 0x0701, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Not Specified
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 3072 kB
	Maximum Size: 3072 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 16-way Set-associative

Handle 0x0702, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Not Specified
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 5120 kB
	Maximum Size: 5120 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 16-way Set-associative

Handle 0x0703, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Not Specified
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 768 kB
	Maximum Size: 768 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 2-way Set-associative

Handle 0x0704, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Not Specified
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 3072 kB
	Maximum Size: 3072 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 16-way Set-associative

Handle 0x0705, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Not Specified
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 5120 kB
	Maximum Size: 5120 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 16-way Set-associative

Handle 0x0800, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x0801, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x0802, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0803, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0804, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0805, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0806, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: INT_USB1
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x0807, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: INT_USB2
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x0808, DMI type 126, 9 bytes
Inactive

Handle 0x0809, DMI type 126, 9 bytes
Inactive

Handle 0x080A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x080B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x080C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: DB-9 male
	Port Type: Serial Port 16550A Compatible

Handle 0x0900, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI1
	Type: x4 PCI Express 2 x4
	Current Usage: Available
	Length: Long
	ID: 1
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x0901, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI2
	Type: x4 PCI Express 2 x4
	Current Usage: Available
	Length: Short
	ID: 2
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x0902, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI3
	Type: x8 PCI Express 2 x8
	Current Usage: Available
	Length: Short
	ID: 3
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x0A00, DMI type 10, 12 bytes
On Board Device 1 Information
	Type: Video
	Status: Enabled
	Description: Embedded Matrox G200 Video
On Board Device 2 Information
	Type: Ethernet
	Status: Enabled
	Description: Embedded Broadcom 5709C NIC 1
On Board Device 3 Information
	Type: Ethernet
	Status: Enabled
	Description: Embedded Broadcom 5709C NIC 2
On Board Device 4 Information
	Type: SAS Controller
	Status: Enabled
	Description: Integrated SAS Controller 

Handle 0x0B00, DMI type 11, 5 bytes
OEM Strings
	String 1: Dell System
	String 2: 5[0000]

Handle 0x7E00, DMI type 126, 170 bytes
Inactive

Handle 0x0C00, DMI type 12, 5 bytes
System Configuration Options
	Option 1: NVRAM_CLR:  Clear user settable NVRAM areas and set defaults
	Option 2: PWRD_EN:  Close to enable password

Handle 0x0D00, DMI type 13, 22 bytes
BIOS Language Information
	Language Description Format: Long
	Installable Languages: 1
		en|US|iso8859-1
	Currently Installed Language: en|US|iso8859-1

Handle 0x1000, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: Multi-bit ECC
	Maximum Capacity: 256 GB
	Error Information Handle: Not Provided
	Number Of Devices: 8

Handle 0x1100, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: 1
	Locator: DIMM_A1 
	Bank Locator: Not Specified
	Type: DDR3
	Type Detail: Synchronous Registered (Buffered)
	Speed: 1067 MHz
	Manufacturer: 044604B3802C
	Serial Number: FFFFFFFF
	Asset Tag: 000C0F11
	Part Number:                   
	Rank: 4

Handle 0x1101, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: 1
	Locator: DIMM_A2 
	Bank Locator: Not Specified
	Type: DDR3
	Type Detail: Synchronous Registered (Buffered)
	Speed: 1067 MHz
	Manufacturer: 044604B3802C
	Serial Number: FFFFFFFF
	Asset Tag: 000C0F11
	Part Number:                   
	Rank: 4

Handle 0x1102, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 2
	Locator: DIMM_A3 
	Bank Locator: Not Specified
	Type: DDR3
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer:             
	Serial Number:         
	Asset Tag:         
	Part Number:                   
	Rank: Unknown

Handle 0x1103, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 2
	Locator: DIMM_A4 
	Bank Locator: Not Specified
	Type: DDR3
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer:             
	Serial Number:         
	Asset Tag:         
	Part Number:                   
	Rank: Unknown

Handle 0x1104, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: 3
	Locator: DIMM_B1 
	Bank Locator: Not Specified
	Type: DDR3
	Type Detail: Synchronous Registered (Buffered)
	Speed: 1067 MHz
	Manufacturer: 044604B3802C
	Serial Number: FFFFFFFF
	Asset Tag: 000C0F11
	Part Number:                   
	Rank: 4

Handle 0x1105, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: 3
	Locator: DIMM_B2 
	Bank Locator: Not Specified
	Type: DDR3
	Type Detail: Synchronous Registered (Buffered)
	Speed: 1067 MHz
	Manufacturer: 044604B3802C
	Serial Number: FFFFFFFF
	Asset Tag: 000C0F11
	Part Number:                   
	Rank: 4

Handle 0x1106, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 4
	Locator: DIMM_B3 
	Bank Locator: Not Specified
	Type: DDR3
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer:             
	Serial Number:         
	Asset Tag:         
	Part Number:                   
	Rank: Unknown

Handle 0x1107, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 4
	Locator: DIMM_B4 
	Bank Locator: Not Specified
	Type: DDR3
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer:             
	Serial Number:         
	Asset Tag:         
	Part Number:                   
	Rank: Unknown

Handle 0x1300, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000DFFFFFFF
	Range Size: 3584 MB
	Physical Array Handle: 0x1000
	Partition Width: 2

Handle 0x1301, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00100000000
	Ending Address: 0x0041FFFFFFF
	Range Size: 12800 MB
	Physical Array Handle: 0x1000
	Partition Width: 2

Handle 0x2000, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x2600, DMI type 38, 18 bytes
IPMI Device Information
	Interface Type: KCS (Keyboard Control Style)
	Specification Version: 2.0
	I2C Slave Address: 0x10
	NV Storage Device: Not Present
	Base Address: 0x0000000000000CA8 (I/O)
	Register Spacing: 32-bit Boundaries

Handle 0x2900, DMI type 41, 11 bytes
Onboard Device
	Reference Designation: Embedded NIC 1                          
	Type: Ethernet
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:02:00.0

Handle 0x2901, DMI type 41, 11 bytes
Onboard Device
	Reference Designation: Embedded NIC 2                          
	Type: Ethernet
	Status: Enabled
	Type Instance: 2
	Bus Address: 0000:02:00.1

Handle 0x2902, DMI type 41, 11 bytes
Onboard Device
	Reference Designation: Integrated SAS                          
	Type: SAS Controller
	Status: Enabled
	Type Instance: 4
	Bus Address: 0000:01:00.0

Handle 0x2903, DMI type 126, 11 bytes
Inactive

Handle 0x2904, DMI type 41, 11 bytes
Onboard Device
	Reference Designation: Embedded Video                          
	Type: Video
	Status: Enabled
	Type Instance: 4
	Bus Address: 0000:03:04.0

Handle 0xD000, DMI type 208, 16 bytes
OEM-specific Type
	Header and Data:
		D0 10 00 D0 02 00 FE 00 89 04 00 00 00 01 00 00

Handle 0xD200, DMI type 210, 12 bytes
OEM-specific Type
	Header and Data:
		D2 0C 00 D2 F8 03 04 03 06 80 04 05

Handle 0xD400, DMI type 212, 87 bytes
OEM-specific Type
	Header and Data:
		D4 57 00 D4 70 00 71 00 00 10 2D 2E 42 00 11 FE
		01 43 00 11 FE 00 70 01 11 9F 20 6F 01 11 9F 00
		00 00 11 9F 20 00 00 11 9F 00 31 40 11 FB 00 32
		40 11 FB 04 9D 00 11 FD 02 9E 00 11 FD 00 9F 00
		26 FE 01 A0 00 26 FE 00 28 40 26 DF 20 29 40 26
		DF 00 FF FF 00 00 00

Handle 0xD401, DMI type 212, 252 bytes
OEM-specific Type
	Header and Data:
		D4 FC 01 D4 70 00 71 00 03 40 5A 6D 5C 00 78 BF
		40 5D 00 78 BF 00 6C 01 57 FC 00 6B 01 57 FC 01
		6A 01 57 FC 02 76 02 57 EF 00 75 02 57 EF 10 00
		00 5B FB 04 00 00 5B FB 00 77 01 54 FC 00 78 01
		54 FC 01 79 01 54 FC 02 7A 01 54 FC 03 33 40 54
		CF 00 34 40 54 CF 10 35 40 54 CF 20 36 40 54 CF
		30 1A 40 54 FB 04 1B 40 54 FB 00 1C 40 54 F7 08
		1D 40 54 F7 00 43 40 58 DF 20 42 40 58 DF 00 24
		40 58 BF 40 25 40 58 BF 00 6E 00 58 FC 01 2D 00
		58 FC 02 DA 01 58 FC 03 22 40 58 EF 10 23 40 58
		EF 00 BB 00 58 F3 04 BC 00 58 F3 08 DB 01 58 F3
		0C 2D 02 55 FE 01 2E 02 55 FE 00 D8 00 55 7F 80
		D9 00 55 7F 00 54 02 56 DF 00 57 02 56 DF 20 4D
		02 56 BF 00 4E 02 56 BF 40 2D 01 56 7F 80 2E 01
		56 7F 00 00 C0 5C 00 0A 03 C0 67 00 05 83 00 76
		00 00 84 00 77 00 00 FF FF 00 00 00

Handle 0xD402, DMI type 212, 27 bytes
OEM-specific Type
	Header and Data:
		D4 1B 02 D4 70 00 71 00 03 40 5A 6D 74 02 57 DF
		00 73 02 57 DF 20 FF FF 00 00 00

Handle 0xD403, DMI type 212, 217 bytes
OEM-specific Type
	Header and Data:
		D4 D9 03 D4 72 00 73 00 00 C0 DD DE D3 00 80 00
		02 D4 00 82 00 02 D5 00 84 00 02 D6 00 86 00 02
		4A 01 C6 BF 40 4B 01 C6 BF 00 00 90 AC 00 00 01
		90 AD 00 00 C4 02 C8 7F 00 B3 02 C8 7F 80 00 00
		C9 EB 14 00 00 C9 EF 10 00 00 C9 FB 04 DB 00 C9
		EB 00 00 00 C9 7F 00 00 00 C9 7F 80 00 00 C9 FC
		00 00 00 C9 FC 01 00 00 C9 FC 02 DE 00 E3 FE 01
		26 40 C2 FE 01 27 40 C2 FE 00 1F 01 C4 FE 00 20
		01 C4 FE 01 17 01 CA FE 00 18 01 CA FE 01 19 01
		CA FD 00 1A 01 CA FD 02 1B 01 CA FB 00 1C 01 CA
		FB 04 1D 01 CA F7 00 1E 01 CA F7 08 35 01 CB FC
		00 37 01 CB FC 01 02 40 C6 DF 00 01 40 C6 DF 20
		FC 01 C5 BF 00 FD 01 C5 BF 40 00 00 C5 7F 80 00
		00 C5 7F 00 FF FF 00 00 00

Handle 0xD404, DMI type 212, 142 bytes
OEM-specific Type
	Header and Data:
		D4 8E 04 D4 72 00 73 00 00 C0 DD DE 32 02 C0 07
		10 31 02 C0 07 20 6F 02 C0 07 00 00 00 C0 07 40
		00 00 C0 07 50 00 00 C0 07 60 6E 02 C0 07 00 A1
		02 C5 FB 00 A2 02 C5 FB 04 00 00 C6 FE 00 00 00
		C6 FE 01 40 01 C7 EF 10 41 01 C7 EF 00 C4 01 D0
		FE 00 C5 01 D0 FE 01 73 01 D0 BF 40 74 01 D0 BF
		00 AB 02 D0 DF 20 AC 02 D0 DF 00 A9 02 D0 EF 10
		AA 02 D0 EF 00 6A 02 DB FE 00 6B 02 DB FE 01 7B
		02 DB FD 00 7C 02 DB FD 02 FF FF 00 00 00

Handle 0xD800, DMI type 216, 9 bytes
OEM-specific Type
	Header and Data:
		D8 09 00 D8 01 02 01 00 00
	Strings:
		MATROX
		VGA/VBE BIOS, Version V3.8WZ

Handle 0xDE00, DMI type 222, 16 bytes
OEM-specific Type
	Header and Data:
		DE 10 00 DE 01 08 00 00 12 03 19 13 13 00 00 01

Handle 0xE100, DMI type 225, 45 bytes
OEM-specific Type
	Header and Data:
		E1 2D 00 E1 01 01 00 04 00 02 01 04 00 03 00 11
		00 04 01 11 00 05 02 11 00 06 03 11 00 07 04 11
		00 08 05 11 00 09 06 11 00 0A 07 11 00
	Strings:
		CPU.Socket.1
		CPU.Socket.2
		DIMM.Socket.A1
		DIMM.Socket.A2
		DIMM.Socket.A3
		DIMM.Socket.A4
		DIMM.Socket.B1
		DIMM.Socket.B2
		DIMM.Socket.B3
		DIMM.Socket.B4

Handle 0x7F00, DMI type 127, 4 bytes
End Of Table

# tree /sys/devices/system/edac/
./edac_tests: line 18: tree: comando não encontrado
# grep . /sys/devices/system/edac/mc/mc?/dimm*/* /sys/devices/system/edac/mc/mc0/rank12/dimm_dev_type /sys/devices/system/edac/mc/mc0/rank12/dimm_edac_mode /sys/devices/system/edac/mc/mc0/rank12/dimm_label /sys/devices/system/edac/mc/mc0/rank12/dimm_location /sys/devices/system/edac/mc/mc0/rank12/dimm_mem_type /sys/devices/system/edac/mc/mc0/rank12/power /sys/devices/system/edac/mc/mc0/rank12/size /sys/devices/system/edac/mc/mc0/rank12/subsystem /sys/devices/system/edac/mc/mc0/rank12/uevent /sys/devices/system/edac/mc/mc0/rank13/dimm_dev_type /sys/devices/system/edac/mc/mc0/rank13/dimm_edac_mode /sys/devices/system/edac/mc/mc0/rank13/dimm_label /sys/devices/system/edac/mc/mc0/rank13/dimm_location /sys/devices/system/edac/mc/mc0/rank13/dimm_mem_type /sys/devices/system/edac/mc/mc0/rank13/power /sys/devices/system/edac/mc/mc0/rank13/size /sys/devices/system/edac/mc/mc0/rank13/subsystem /sys/devices/system/edac/mc/mc0/rank13/uevent /sys/devices/system/edac/mc/mc0/rank14/dimm_dev_type /sys/devices/system/edac/mc/mc0/rank14/dimm_edac_mode /sys/devices/system/edac/mc/mc0/rank14/dimm_label /sys/devices/system/edac/mc/mc0/rank14/dimm_location /sys/devices/system/edac/mc/mc0/rank14/dimm_mem_type /sys/devices/system/edac/mc/mc0/rank14/power /sys/devices/system/edac/mc/mc0/rank14/size /sys/devices/system/edac/mc/mc0/rank14/subsystem /sys/devices/system/edac/mc/mc0/rank14/uevent /sys/devices/system/edac/mc/mc0/rank15/dimm_dev_type /sys/devices/system/edac/mc/mc0/rank15/dimm_edac_mode /sys/devices/system/edac/mc/mc0/rank15/dimm_label /sys/devices/system/edac/mc/mc0/rank15/dimm_location /sys/devices/system/edac/mc/mc0/rank15/dimm_mem_type /sys/devices/system/edac/mc/mc0/rank15/power /sys/devices/system/edac/mc/mc0/rank15/size /sys/devices/system/edac/mc/mc0/rank15/subsystem /sys/devices/system/edac/mc/mc0/rank15/uevent /sys/devices/system/edac/mc/mc0/rank4/dimm_dev_type /sys/devices/system/edac/mc/mc0/rank4/dimm_edac_mode /sys/devices/system/edac/mc/mc0/rank4/dimm_label /sys/devices/system/edac/mc/mc0/rank4/dimm_location /sys/devices/system/edac/mc/mc0/rank4/dimm_mem_type /sys/devices/system/edac/mc/mc0/rank4/power /sys/devices/system/edac/mc/mc0/rank4/size /sys/devices/system/edac/mc/mc0/rank4/subsystem /sys/devices/system/edac/mc/mc0/rank4/uevent /sys/devices/system/edac/mc/mc0/rank5/dimm_dev_type /sys/devices/system/edac/mc/mc0/rank5/dimm_edac_mode /sys/devices/system/edac/mc/mc0/rank5/dimm_label /sys/devices/system/edac/mc/mc0/rank5/dimm_location /sys/devices/system/edac/mc/mc0/rank5/dimm_mem_type /sys/devices/system/edac/mc/mc0/rank5/power /sys/devices/system/edac/mc/mc0/rank5/size /sys/devices/system/edac/mc/mc0/rank5/subsystem /sys/devices/system/edac/mc/mc0/rank5/uevent /sys/devices/system/edac/mc/mc0/rank6/dimm_dev_type /sys/devices/system/edac/mc/mc0/rank6/dimm_edac_mode /sys/devices/system/edac/mc/mc0/rank6/dimm_label /sys/devices/system/edac/mc/mc0/rank6/dimm_location /sys/devices/system/edac/mc/mc0/rank6/dimm_mem_type /sys/devices/system/edac/mc/mc0/rank6/power /sys/devices/system/edac/mc/mc0/rank6/size /sys/devices/system/edac/mc/mc0/rank6/subsystem /sys/devices/system/edac/mc/mc0/rank6/uevent /sys/devices/system/edac/mc/mc0/rank7/dimm_dev_type /sys/devices/system/edac/mc/mc0/rank7/dimm_edac_mode /sys/devices/system/edac/mc/mc0/rank7/dimm_label /sys/devices/system/edac/mc/mc0/rank7/dimm_location /sys/devices/system/edac/mc/mc0/rank7/dimm_mem_type /sys/devices/system/edac/mc/mc0/rank7/power /sys/devices/system/edac/mc/mc0/rank7/size /sys/devices/system/edac/mc/mc0/rank7/subsystem /sys/devices/system/edac/mc/mc0/rank7/uevent /sys/devices/system/edac/mc/mc1/rank12/dimm_dev_type /sys/devices/system/edac/mc/mc1/rank12/dimm_edac_mode /sys/devices/system/edac/mc/mc1/rank12/dimm_label /sys/devices/system/edac/mc/mc1/rank12/dimm_location /sys/devices/system/edac/mc/mc1/rank12/dimm_mem_type /sys/devices/system/edac/mc/mc1/rank12/power /sys/devices/system/edac/mc/mc1/rank12/size /sys/devices/system/edac/mc/mc1/rank12/subsystem /sys/devices/system/edac/mc/mc1/rank12/uevent /sys/devices/system/edac/mc/mc1/rank13/dimm_dev_type /sys/devices/system/edac/mc/mc1/rank13/dimm_edac_mode /sys/devices/system/edac/mc/mc1/rank13/dimm_label /sys/devices/system/edac/mc/mc1/rank13/dimm_location /sys/devices/system/edac/mc/mc1/rank13/dimm_mem_type /sys/devices/system/edac/mc/mc1/rank13/power /sys/devices/system/edac/mc/mc1/rank13/size /sys/devices/system/edac/mc/mc1/rank13/subsystem /sys/devices/system/edac/mc/mc1/rank13/uevent /sys/devices/system/edac/mc/mc1/rank14/dimm_dev_type /sys/devices/system/edac/mc/mc1/rank14/dimm_edac_mode /sys/devices/system/edac/mc/mc1/rank14/dimm_label /sys/devices/system/edac/mc/mc1/rank14/dimm_location /sys/devices/system/edac/mc/mc1/rank14/dimm_mem_type /sys/devices/system/edac/mc/mc1/rank14/power /sys/devices/system/edac/mc/mc1/rank14/size /sys/devices/system/edac/mc/mc1/rank14/subsystem /sys/devices/system/edac/mc/mc1/rank14/uevent /sys/devices/system/edac/mc/mc1/rank15/dimm_dev_type /sys/devices/system/edac/mc/mc1/rank15/dimm_edac_mode /sys/devices/system/edac/mc/mc1/rank15/dimm_label /sys/devices/system/edac/mc/mc1/rank15/dimm_location /sys/devices/system/edac/mc/mc1/rank15/dimm_mem_type /sys/devices/system/edac/mc/mc1/rank15/power /sys/devices/system/edac/mc/mc1/rank15/size /sys/devices/system/edac/mc/mc1/rank15/subsystem /sys/devices/system/edac/mc/mc1/rank15/uevent /sys/devices/system/edac/mc/mc1/rank4/dimm_dev_type /sys/devices/system/edac/mc/mc1/rank4/dimm_edac_mode /sys/devices/system/edac/mc/mc1/rank4/dimm_label /sys/devices/system/edac/mc/mc1/rank4/dimm_location /sys/devices/system/edac/mc/mc1/rank4/dimm_mem_type /sys/devices/system/edac/mc/mc1/rank4/power /sys/devices/system/edac/mc/mc1/rank4/size /sys/devices/system/edac/mc/mc1/rank4/subsystem /sys/devices/system/edac/mc/mc1/rank4/uevent /sys/devices/system/edac/mc/mc1/rank5/dimm_dev_type /sys/devices/system/edac/mc/mc1/rank5/dimm_edac_mode /sys/devices/system/edac/mc/mc1/rank5/dimm_label /sys/devices/system/edac/mc/mc1/rank5/dimm_location /sys/devices/system/edac/mc/mc1/rank5/dimm_mem_type /sys/devices/system/edac/mc/mc1/rank5/power /sys/devices/system/edac/mc/mc1/rank5/size /sys/devices/system/edac/mc/mc1/rank5/subsystem /sys/devices/system/edac/mc/mc1/rank5/uevent /sys/devices/system/edac/mc/mc1/rank6/dimm_dev_type /sys/devices/system/edac/mc/mc1/rank6/dimm_edac_mode /sys/devices/system/edac/mc/mc1/rank6/dimm_label /sys/devices/system/edac/mc/mc1/rank6/dimm_location /sys/devices/system/edac/mc/mc1/rank6/dimm_mem_type /sys/devices/system/edac/mc/mc1/rank6/power /sys/devices/system/edac/mc/mc1/rank6/size /sys/devices/system/edac/mc/mc1/rank6/subsystem /sys/devices/system/edac/mc/mc1/rank6/uevent /sys/devices/system/edac/mc/mc1/rank7/dimm_dev_type /sys/devices/system/edac/mc/mc1/rank7/dimm_edac_mode /sys/devices/system/edac/mc/mc1/rank7/dimm_label /sys/devices/system/edac/mc/mc1/rank7/dimm_location /sys/devices/system/edac/mc/mc1/rank7/dimm_mem_type /sys/devices/system/edac/mc/mc1/rank7/power /sys/devices/system/edac/mc/mc1/rank7/size /sys/devices/system/edac/mc/mc1/rank7/subsystem /sys/devices/system/edac/mc/mc1/rank7/uevent
grep: /sys/devices/system/edac/mc/mc?/dimm*/*: Arquivo ou diretório não encontrado
/sys/devices/system/edac/mc/mc0/rank12/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank12/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/rank12/dimm_label:mc#0csrow#6channel#0
/sys/devices/system/edac/mc/mc0/rank12/dimm_location:csrow 6 channel 0 
/sys/devices/system/edac/mc/mc0/rank12/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc0/rank12/power: É um diretório
/sys/devices/system/edac/mc/mc0/rank12/size:2048
grep: /sys/devices/system/edac/mc/mc0/rank12/subsystem: É um diretório
/sys/devices/system/edac/mc/mc0/rank13/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank13/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/rank13/dimm_label:mc#0csrow#6channel#1
/sys/devices/system/edac/mc/mc0/rank13/dimm_location:csrow 6 channel 1 
/sys/devices/system/edac/mc/mc0/rank13/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc0/rank13/power: É um diretório
/sys/devices/system/edac/mc/mc0/rank13/size:2048
grep: /sys/devices/system/edac/mc/mc0/rank13/subsystem: É um diretório
/sys/devices/system/edac/mc/mc0/rank14/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank14/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/rank14/dimm_label:mc#0csrow#7channel#0
/sys/devices/system/edac/mc/mc0/rank14/dimm_location:csrow 7 channel 0 
/sys/devices/system/edac/mc/mc0/rank14/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc0/rank14/power: É um diretório
/sys/devices/system/edac/mc/mc0/rank14/size:2048
grep: /sys/devices/system/edac/mc/mc0/rank14/subsystem: É um diretório
/sys/devices/system/edac/mc/mc0/rank15/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank15/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/rank15/dimm_label:mc#0csrow#7channel#1
/sys/devices/system/edac/mc/mc0/rank15/dimm_location:csrow 7 channel 1 
/sys/devices/system/edac/mc/mc0/rank15/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc0/rank15/power: É um diretório
/sys/devices/system/edac/mc/mc0/rank15/size:2048
grep: /sys/devices/system/edac/mc/mc0/rank15/subsystem: É um diretório
/sys/devices/system/edac/mc/mc0/rank4/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank4/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/rank4/dimm_label:mc#0csrow#2channel#0
/sys/devices/system/edac/mc/mc0/rank4/dimm_location:csrow 2 channel 0 
/sys/devices/system/edac/mc/mc0/rank4/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc0/rank4/power: É um diretório
/sys/devices/system/edac/mc/mc0/rank4/size:2048
grep: /sys/devices/system/edac/mc/mc0/rank4/subsystem: É um diretório
/sys/devices/system/edac/mc/mc0/rank5/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank5/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/rank5/dimm_label:mc#0csrow#2channel#1
/sys/devices/system/edac/mc/mc0/rank5/dimm_location:csrow 2 channel 1 
/sys/devices/system/edac/mc/mc0/rank5/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc0/rank5/power: É um diretório
/sys/devices/system/edac/mc/mc0/rank5/size:2048
grep: /sys/devices/system/edac/mc/mc0/rank5/subsystem: É um diretório
/sys/devices/system/edac/mc/mc0/rank6/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank6/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/rank6/dimm_label:mc#0csrow#3channel#0
/sys/devices/system/edac/mc/mc0/rank6/dimm_location:csrow 3 channel 0 
/sys/devices/system/edac/mc/mc0/rank6/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc0/rank6/power: É um diretório
/sys/devices/system/edac/mc/mc0/rank6/size:2048
grep: /sys/devices/system/edac/mc/mc0/rank6/subsystem: É um diretório
/sys/devices/system/edac/mc/mc0/rank7/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank7/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/rank7/dimm_label:mc#0csrow#3channel#1
/sys/devices/system/edac/mc/mc0/rank7/dimm_location:csrow 3 channel 1 
/sys/devices/system/edac/mc/mc0/rank7/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc0/rank7/power: É um diretório
/sys/devices/system/edac/mc/mc0/rank7/size:2048
grep: /sys/devices/system/edac/mc/mc0/rank7/subsystem: É um diretório
/sys/devices/system/edac/mc/mc1/rank12/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc1/rank12/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc1/rank12/dimm_label:mc#1csrow#6channel#0
/sys/devices/system/edac/mc/mc1/rank12/dimm_location:csrow 6 channel 0 
/sys/devices/system/edac/mc/mc1/rank12/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc1/rank12/power: É um diretório
/sys/devices/system/edac/mc/mc1/rank12/size:2048
grep: /sys/devices/system/edac/mc/mc1/rank12/subsystem: É um diretório
/sys/devices/system/edac/mc/mc1/rank13/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc1/rank13/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc1/rank13/dimm_label:mc#1csrow#6channel#1
/sys/devices/system/edac/mc/mc1/rank13/dimm_location:csrow 6 channel 1 
/sys/devices/system/edac/mc/mc1/rank13/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc1/rank13/power: É um diretório
/sys/devices/system/edac/mc/mc1/rank13/size:2048
grep: /sys/devices/system/edac/mc/mc1/rank13/subsystem: É um diretório
/sys/devices/system/edac/mc/mc1/rank14/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc1/rank14/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc1/rank14/dimm_label:mc#1csrow#7channel#0
/sys/devices/system/edac/mc/mc1/rank14/dimm_location:csrow 7 channel 0 
/sys/devices/system/edac/mc/mc1/rank14/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc1/rank14/power: É um diretório
/sys/devices/system/edac/mc/mc1/rank14/size:2048
grep: /sys/devices/system/edac/mc/mc1/rank14/subsystem: É um diretório
/sys/devices/system/edac/mc/mc1/rank15/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc1/rank15/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc1/rank15/dimm_label:mc#1csrow#7channel#1
/sys/devices/system/edac/mc/mc1/rank15/dimm_location:csrow 7 channel 1 
/sys/devices/system/edac/mc/mc1/rank15/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc1/rank15/power: É um diretório
/sys/devices/system/edac/mc/mc1/rank15/size:2048
grep: /sys/devices/system/edac/mc/mc1/rank15/subsystem: É um diretório
/sys/devices/system/edac/mc/mc1/rank4/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc1/rank4/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc1/rank4/dimm_label:mc#1csrow#2channel#0
/sys/devices/system/edac/mc/mc1/rank4/dimm_location:csrow 2 channel 0 
/sys/devices/system/edac/mc/mc1/rank4/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc1/rank4/power: É um diretório
/sys/devices/system/edac/mc/mc1/rank4/size:2048
grep: /sys/devices/system/edac/mc/mc1/rank4/subsystem: É um diretório
/sys/devices/system/edac/mc/mc1/rank5/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc1/rank5/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc1/rank5/dimm_label:mc#1csrow#2channel#1
/sys/devices/system/edac/mc/mc1/rank5/dimm_location:csrow 2 channel 1 
/sys/devices/system/edac/mc/mc1/rank5/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc1/rank5/power: É um diretório
/sys/devices/system/edac/mc/mc1/rank5/size:2048
grep: /sys/devices/system/edac/mc/mc1/rank5/subsystem: É um diretório
/sys/devices/system/edac/mc/mc1/rank6/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc1/rank6/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc1/rank6/dimm_label:mc#1csrow#3channel#0
/sys/devices/system/edac/mc/mc1/rank6/dimm_location:csrow 3 channel 0 
/sys/devices/system/edac/mc/mc1/rank6/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc1/rank6/power: É um diretório
/sys/devices/system/edac/mc/mc1/rank6/size:2048
grep: /sys/devices/system/edac/mc/mc1/rank6/subsystem: É um diretório
/sys/devices/system/edac/mc/mc1/rank7/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc1/rank7/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc1/rank7/dimm_label:mc#1csrow#3channel#1
/sys/devices/system/edac/mc/mc1/rank7/dimm_location:csrow 3 channel 1 
/sys/devices/system/edac/mc/mc1/rank7/dimm_mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc1/rank7/power: É um diretório
/sys/devices/system/edac/mc/mc1/rank7/size:2048
grep: /sys/devices/system/edac/mc/mc1/rank7/subsystem: É um diretório
# grep . /sys/devices/system/edac/mc/mc0/csrow2/ce_count /sys/devices/system/edac/mc/mc0/csrow2/ch0_ce_count /sys/devices/system/edac/mc/mc0/csrow2/ch0_dimm_label /sys/devices/system/edac/mc/mc0/csrow2/ch1_ce_count /sys/devices/system/edac/mc/mc0/csrow2/ch1_dimm_label /sys/devices/system/edac/mc/mc0/csrow2/dev_type /sys/devices/system/edac/mc/mc0/csrow2/edac_mode /sys/devices/system/edac/mc/mc0/csrow2/mem_type /sys/devices/system/edac/mc/mc0/csrow2/power /sys/devices/system/edac/mc/mc0/csrow2/size_mb /sys/devices/system/edac/mc/mc0/csrow2/subsystem /sys/devices/system/edac/mc/mc0/csrow2/ue_count /sys/devices/system/edac/mc/mc0/csrow2/uevent /sys/devices/system/edac/mc/mc0/csrow3/ce_count /sys/devices/system/edac/mc/mc0/csrow3/ch0_ce_count /sys/devices/system/edac/mc/mc0/csrow3/ch0_dimm_label /sys/devices/system/edac/mc/mc0/csrow3/ch1_ce_count /sys/devices/system/edac/mc/mc0/csrow3/ch1_dimm_label /sys/devices/system/edac/mc/mc0/csrow3/dev_type /sys/devices/system/edac/mc/mc0/csrow3/edac_mode /sys/devices/system/edac/mc/mc0/csrow3/mem_type /sys/devices/system/edac/mc/mc0/csrow3/power /sys/devices/system/edac/mc/mc0/csrow3/size_mb /sys/devices/system/edac/mc/mc0/csrow3/subsystem /sys/devices/system/edac/mc/mc0/csrow3/ue_count /sys/devices/system/edac/mc/mc0/csrow3/uevent /sys/devices/system/edac/mc/mc0/csrow6/ce_count /sys/devices/system/edac/mc/mc0/csrow6/ch0_ce_count /sys/devices/system/edac/mc/mc0/csrow6/ch0_dimm_label /sys/devices/system/edac/mc/mc0/csrow6/ch1_ce_count /sys/devices/system/edac/mc/mc0/csrow6/ch1_dimm_label /sys/devices/system/edac/mc/mc0/csrow6/dev_type /sys/devices/system/edac/mc/mc0/csrow6/edac_mode /sys/devices/system/edac/mc/mc0/csrow6/mem_type /sys/devices/system/edac/mc/mc0/csrow6/power /sys/devices/system/edac/mc/mc0/csrow6/size_mb /sys/devices/system/edac/mc/mc0/csrow6/subsystem /sys/devices/system/edac/mc/mc0/csrow6/ue_count /sys/devices/system/edac/mc/mc0/csrow6/uevent /sys/devices/system/edac/mc/mc0/csrow7/ce_count /sys/devices/system/edac/mc/mc0/csrow7/ch0_ce_count /sys/devices/system/edac/mc/mc0/csrow7/ch0_dimm_label /sys/devices/system/edac/mc/mc0/csrow7/ch1_ce_count /sys/devices/system/edac/mc/mc0/csrow7/ch1_dimm_label /sys/devices/system/edac/mc/mc0/csrow7/dev_type /sys/devices/system/edac/mc/mc0/csrow7/edac_mode /sys/devices/system/edac/mc/mc0/csrow7/mem_type /sys/devices/system/edac/mc/mc0/csrow7/power /sys/devices/system/edac/mc/mc0/csrow7/size_mb /sys/devices/system/edac/mc/mc0/csrow7/subsystem /sys/devices/system/edac/mc/mc0/csrow7/ue_count /sys/devices/system/edac/mc/mc0/csrow7/uevent /sys/devices/system/edac/mc/mc1/csrow2/ce_count /sys/devices/system/edac/mc/mc1/csrow2/ch0_ce_count /sys/devices/system/edac/mc/mc1/csrow2/ch0_dimm_label /sys/devices/system/edac/mc/mc1/csrow2/ch1_ce_count /sys/devices/system/edac/mc/mc1/csrow2/ch1_dimm_label /sys/devices/system/edac/mc/mc1/csrow2/dev_type /sys/devices/system/edac/mc/mc1/csrow2/edac_mode /sys/devices/system/edac/mc/mc1/csrow2/mem_type /sys/devices/system/edac/mc/mc1/csrow2/power /sys/devices/system/edac/mc/mc1/csrow2/size_mb /sys/devices/system/edac/mc/mc1/csrow2/subsystem /sys/devices/system/edac/mc/mc1/csrow2/ue_count /sys/devices/system/edac/mc/mc1/csrow2/uevent /sys/devices/system/edac/mc/mc1/csrow3/ce_count /sys/devices/system/edac/mc/mc1/csrow3/ch0_ce_count /sys/devices/system/edac/mc/mc1/csrow3/ch0_dimm_label /sys/devices/system/edac/mc/mc1/csrow3/ch1_ce_count /sys/devices/system/edac/mc/mc1/csrow3/ch1_dimm_label /sys/devices/system/edac/mc/mc1/csrow3/dev_type /sys/devices/system/edac/mc/mc1/csrow3/edac_mode /sys/devices/system/edac/mc/mc1/csrow3/mem_type /sys/devices/system/edac/mc/mc1/csrow3/power /sys/devices/system/edac/mc/mc1/csrow3/size_mb /sys/devices/system/edac/mc/mc1/csrow3/subsystem /sys/devices/system/edac/mc/mc1/csrow3/ue_count /sys/devices/system/edac/mc/mc1/csrow3/uevent /sys/devices/system/edac/mc/mc1/csrow6/ce_count /sys/devices/system/edac/mc/mc1/csrow6/ch0_ce_count /sys/devices/system/edac/mc/mc1/csrow6/ch0_dimm_label /sys/devices/system/edac/mc/mc1/csrow6/ch1_ce_count /sys/devices/system/edac/mc/mc1/csrow6/ch1_dimm_label /sys/devices/system/edac/mc/mc1/csrow6/dev_type /sys/devices/system/edac/mc/mc1/csrow6/edac_mode /sys/devices/system/edac/mc/mc1/csrow6/mem_type /sys/devices/system/edac/mc/mc1/csrow6/power /sys/devices/system/edac/mc/mc1/csrow6/size_mb /sys/devices/system/edac/mc/mc1/csrow6/subsystem /sys/devices/system/edac/mc/mc1/csrow6/ue_count /sys/devices/system/edac/mc/mc1/csrow6/uevent /sys/devices/system/edac/mc/mc1/csrow7/ce_count /sys/devices/system/edac/mc/mc1/csrow7/ch0_ce_count /sys/devices/system/edac/mc/mc1/csrow7/ch0_dimm_label /sys/devices/system/edac/mc/mc1/csrow7/ch1_ce_count /sys/devices/system/edac/mc/mc1/csrow7/ch1_dimm_label /sys/devices/system/edac/mc/mc1/csrow7/dev_type /sys/devices/system/edac/mc/mc1/csrow7/edac_mode /sys/devices/system/edac/mc/mc1/csrow7/mem_type /sys/devices/system/edac/mc/mc1/csrow7/power /sys/devices/system/edac/mc/mc1/csrow7/size_mb /sys/devices/system/edac/mc/mc1/csrow7/subsystem /sys/devices/system/edac/mc/mc1/csrow7/ue_count /sys/devices/system/edac/mc/mc1/csrow7/uevent
/sys/devices/system/edac/mc/mc0/csrow2/ce_count:0
/sys/devices/system/edac/mc/mc0/csrow2/ch0_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow2/ch0_dimm_label:mc#0csrow#2channel#0
/sys/devices/system/edac/mc/mc0/csrow2/ch1_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow2/ch1_dimm_label:mc#0csrow#2channel#1
/sys/devices/system/edac/mc/mc0/csrow2/dev_type:Unknown
/sys/devices/system/edac/mc/mc0/csrow2/edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/csrow2/mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc0/csrow2/power: É um diretório
/sys/devices/system/edac/mc/mc0/csrow2/size_mb:2048
grep: /sys/devices/system/edac/mc/mc0/csrow2/subsystem: É um diretório
/sys/devices/system/edac/mc/mc0/csrow2/ue_count:0
/sys/devices/system/edac/mc/mc0/csrow3/ce_count:0
/sys/devices/system/edac/mc/mc0/csrow3/ch0_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow3/ch0_dimm_label:mc#0csrow#3channel#0
/sys/devices/system/edac/mc/mc0/csrow3/ch1_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow3/ch1_dimm_label:mc#0csrow#3channel#1
/sys/devices/system/edac/mc/mc0/csrow3/dev_type:Unknown
/sys/devices/system/edac/mc/mc0/csrow3/edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/csrow3/mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc0/csrow3/power: É um diretório
/sys/devices/system/edac/mc/mc0/csrow3/size_mb:2048
grep: /sys/devices/system/edac/mc/mc0/csrow3/subsystem: É um diretório
/sys/devices/system/edac/mc/mc0/csrow3/ue_count:0
/sys/devices/system/edac/mc/mc0/csrow6/ce_count:0
/sys/devices/system/edac/mc/mc0/csrow6/ch0_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow6/ch0_dimm_label:mc#0csrow#6channel#0
/sys/devices/system/edac/mc/mc0/csrow6/ch1_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow6/ch1_dimm_label:mc#0csrow#6channel#1
/sys/devices/system/edac/mc/mc0/csrow6/dev_type:Unknown
/sys/devices/system/edac/mc/mc0/csrow6/edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/csrow6/mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc0/csrow6/power: É um diretório
/sys/devices/system/edac/mc/mc0/csrow6/size_mb:2048
grep: /sys/devices/system/edac/mc/mc0/csrow6/subsystem: É um diretório
/sys/devices/system/edac/mc/mc0/csrow6/ue_count:0
/sys/devices/system/edac/mc/mc0/csrow7/ce_count:0
/sys/devices/system/edac/mc/mc0/csrow7/ch0_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow7/ch0_dimm_label:mc#0csrow#7channel#0
/sys/devices/system/edac/mc/mc0/csrow7/ch1_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow7/ch1_dimm_label:mc#0csrow#7channel#1
/sys/devices/system/edac/mc/mc0/csrow7/dev_type:Unknown
/sys/devices/system/edac/mc/mc0/csrow7/edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/csrow7/mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc0/csrow7/power: É um diretório
/sys/devices/system/edac/mc/mc0/csrow7/size_mb:2048
grep: /sys/devices/system/edac/mc/mc0/csrow7/subsystem: É um diretório
/sys/devices/system/edac/mc/mc0/csrow7/ue_count:0
/sys/devices/system/edac/mc/mc1/csrow2/ce_count:0
/sys/devices/system/edac/mc/mc1/csrow2/ch0_ce_count:0
/sys/devices/system/edac/mc/mc1/csrow2/ch0_dimm_label:mc#1csrow#2channel#0
/sys/devices/system/edac/mc/mc1/csrow2/ch1_ce_count:0
/sys/devices/system/edac/mc/mc1/csrow2/ch1_dimm_label:mc#1csrow#2channel#1
/sys/devices/system/edac/mc/mc1/csrow2/dev_type:Unknown
/sys/devices/system/edac/mc/mc1/csrow2/edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc1/csrow2/mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc1/csrow2/power: É um diretório
/sys/devices/system/edac/mc/mc1/csrow2/size_mb:2048
grep: /sys/devices/system/edac/mc/mc1/csrow2/subsystem: É um diretório
/sys/devices/system/edac/mc/mc1/csrow2/ue_count:0
/sys/devices/system/edac/mc/mc1/csrow3/ce_count:0
/sys/devices/system/edac/mc/mc1/csrow3/ch0_ce_count:0
/sys/devices/system/edac/mc/mc1/csrow3/ch0_dimm_label:mc#1csrow#3channel#0
/sys/devices/system/edac/mc/mc1/csrow3/ch1_ce_count:0
/sys/devices/system/edac/mc/mc1/csrow3/ch1_dimm_label:mc#1csrow#3channel#1
/sys/devices/system/edac/mc/mc1/csrow3/dev_type:Unknown
/sys/devices/system/edac/mc/mc1/csrow3/edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc1/csrow3/mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc1/csrow3/power: É um diretório
/sys/devices/system/edac/mc/mc1/csrow3/size_mb:2048
grep: /sys/devices/system/edac/mc/mc1/csrow3/subsystem: É um diretório
/sys/devices/system/edac/mc/mc1/csrow3/ue_count:0
/sys/devices/system/edac/mc/mc1/csrow6/ce_count:0
/sys/devices/system/edac/mc/mc1/csrow6/ch0_ce_count:0
/sys/devices/system/edac/mc/mc1/csrow6/ch0_dimm_label:mc#1csrow#6channel#0
/sys/devices/system/edac/mc/mc1/csrow6/ch1_ce_count:0
/sys/devices/system/edac/mc/mc1/csrow6/ch1_dimm_label:mc#1csrow#6channel#1
/sys/devices/system/edac/mc/mc1/csrow6/dev_type:Unknown
/sys/devices/system/edac/mc/mc1/csrow6/edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc1/csrow6/mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc1/csrow6/power: É um diretório
/sys/devices/system/edac/mc/mc1/csrow6/size_mb:2048
grep: /sys/devices/system/edac/mc/mc1/csrow6/subsystem: É um diretório
/sys/devices/system/edac/mc/mc1/csrow6/ue_count:0
/sys/devices/system/edac/mc/mc1/csrow7/ce_count:0
/sys/devices/system/edac/mc/mc1/csrow7/ch0_ce_count:0
/sys/devices/system/edac/mc/mc1/csrow7/ch0_dimm_label:mc#1csrow#7channel#0
/sys/devices/system/edac/mc/mc1/csrow7/ch1_ce_count:0
/sys/devices/system/edac/mc/mc1/csrow7/ch1_dimm_label:mc#1csrow#7channel#1
/sys/devices/system/edac/mc/mc1/csrow7/dev_type:Unknown
/sys/devices/system/edac/mc/mc1/csrow7/edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc1/csrow7/mem_type:Registered-DDR3
grep: /sys/devices/system/edac/mc/mc1/csrow7/power: É um diretório
/sys/devices/system/edac/mc/mc1/csrow7/size_mb:2048
grep: /sys/devices/system/edac/mc/mc1/csrow7/subsystem: É um diretório
/sys/devices/system/edac/mc/mc1/csrow7/ue_count:0
# dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.0-rc1+ (root@dell-per515-01.lab.bos.redhat.com) (gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) ) #2 SMP Thu Mar 7 06:30:44 EST 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.9.0-rc1+ root=/dev/mapper/fedora_dell--per515--01-root ro rd.md=0 rd.lvm.lv=fedora_dell-per515-01/swap rd.dm=0 console=ttyS1,115200n81 rd.luks=0 vconsole.keymap=us rd.lvm.lv=fedora_dell-per515-01/root LANG=en_US.UTF-8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000df698fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000df699000-0x00000000df6aefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000df6af000-0x00000000df6cdfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000df6ce000-0x00000000dfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fec8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec94000-0x00000000feccffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fecd4000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Dell Inc. PowerEdge R515/03X0MN, BIOS 1.2.5 03/16/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x420000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-EBFFF uncachable
[    0.000000]   EC000-EFFFF write-back
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFE0000000 write-back
[    0.000000]   3 base 000100000000 mask FFFF00000000 write-back
[    0.000000]   4 base 000200000000 mask FFFE00000000 write-back
[    0.000000]   5 base 000400000000 mask FFFFE0000000 write-back
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000420000000 aka 16896M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xe0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdf699 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fe710-0x000fe71f] mapped at [ffff8800000fe710]
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fc8000, 0x01fc8fff] PGTABLE
[    0.000000] BRK [0x01fc9000, 0x01fc9fff] PGTABLE
[    0.000000] BRK [0x01fca000, 0x01fcafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41fe00000-0x41fffffff]
[    0.000000]  [mem 0x41fe00000-0x41fffffff] page 2M
[    0.000000] BRK [0x01fcb000, 0x01fcbfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41c000000-0x41fdfffff]
[    0.000000]  [mem 0x41c000000-0x41fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
[    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdf698fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xdf5fffff] page 2M
[    0.000000]  [mem 0xdf600000-0xdf698fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x36082000-0x37038fff]
[    0.000000] ACPI: RSDP 00000000000f11e0 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000000f1268 000A4 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: FACP 00000000df6bbcf4 000F4 (v03 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI BIOS Bug: Warning: Invalid length for FADT/Pm2ControlBlock: 16, using default 8 (20130117/tbfadt-649)
[    0.000000] ACPI: DSDT 00000000df6af000 06682 (v01 DELL   PE_SC3   00000001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000df6be000 00040
[    0.000000] ACPI: APIC 00000000df6bb478 00254 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: SPCR 00000000df6bb6dc 00050 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: HPET 00000000df6bb730 00038 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: MCFG 00000000df6bb76c 0003C (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: WD__ 00000000df6bb7ac 00134 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: SLIC 00000000df6bb8e4 00024 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: ERST 00000000df6b5804 00270 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: HEST 00000000df6b5a74 00354 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: BERT 00000000df6b5684 00030 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: EINJ 00000000df6b56b4 00150 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: IV__ 00000000df6bba68 00030 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: SRAT 00000000df6bba9c 00190 (v02 AMD    F10      00000001 AMD  00000001)
[    0.000000] ACPI: SLIT 00000000df6bbc58 00030 (v01 AMD    F10      00000001 AMD  00000001)
[    0.000000] ACPI: SS__ 00000000df6bf000 00030 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: TCPA 00000000df6bbc8c 00064 (v02 DELL   PE_SC3   00000001 DELL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0d -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x10 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x11 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x12 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x13 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x14 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x15 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0xdfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x21fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x220000000-0x41fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xdfffffff] -> [mem 0x00000000-0xdfffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xdfffffff] + [mem 0x100000000-0x21fffffff] -> [mem 0x00000000-0x21fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x21fffffff]
[    0.000000]   NODE_DATA [mem 0x21ffec000-0x21fffffff]
[    0.000000] Initmem setup node 1 [mem 0x220000000-0x41fffffff]
[    0.000000]   NODE_DATA [mem 0x41ffe9000-0x41fffcfff]
[    0.000000]  [ffffea0000000000-ffffea00087fffff] PMD -> [ffff880217e00000-ffff88021fdfffff] on node 0
[    0.000000]  [ffffea0008800000-ffffea00107fffff] PMD -> [ffff880417600000-ffff88041f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x41fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0xdf698fff]
[    0.000000]   node   0: [mem 0x100000000-0x21fffffff]
[    0.000000]   node   1: [mem 0x220000000-0x41fffffff]
[    0.000000] On node 0 totalpages: 2094648
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 23 pages reserved
[    0.000000]   DMA zone: 3999 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14235 pages used for memmap
[    0.000000]   DMA32 zone: 911001 pages, LIFO batch:31
[    0.000000]   Normal zone: 18432 pages used for memmap
[    0.000000]   Normal zone: 1179648 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x16] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 22, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x17] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 23, version 33, address 0xfec80000, GSI 24-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538301 base: 0xfed00000
[    0.000000] smpboot: Allowing 64 CPUs, 52 hotplug CPUs
[    0.000000] nr_irqs_gsi: 72
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df699000 - 00000000df6af000
[    0.000000] PM: Registered nosave memory: 00000000df6af000 - 00000000df6ce000
[    0.000000] PM: Registered nosave memory: 00000000df6ce000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000fe000000
[    0.000000] PM: Registered nosave memory: 00000000fe000000 - 00000000fec90000
[    0.000000] PM: Registered nosave memory: 00000000fec90000 - 00000000fec94000
[    0.000000] PM: Registered nosave memory: 00000000fec94000 - 00000000fecd0000
[    0.000000] PM: Registered nosave memory: 00000000fecd0000 - 00000000fecd4000
[    0.000000] PM: Registered nosave memory: 00000000fecd4000 - 0000000100000000
[    0.000000] e820: [mem 0xe0000000-0xefffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:64 nr_node_ids:2
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880217a00000 s85184 r8192 d21312 u131072
[    0.000000] pcpu-alloc: s85184 r8192 d21312 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 02 03 04 05 06 12 14 16 18 20 22 24 26 28 30 
[    0.000000] pcpu-alloc: [0] 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 
[    0.000000] pcpu-alloc: [1] 01 07 08 09 10 11 13 15 17 19 21 23 25 27 29 31 
[    0.000000] pcpu-alloc: [1] 33 35 37 39 41 43 45 47 49 51 53 55 57 59 61 63 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 4126278
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.9.0-rc1+ root=/dev/mapper/fedora_dell--per515--01-root ro rd.md=0 rd.lvm.lv=fedora_dell-per515-01/swap rd.dm=0 console=ttyS1,115200n81 rd.luks=0 vconsole.keymap=us rd.lvm.lv=fedora_dell-per515-01/root LANG=en_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ d4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ d4000000
[    0.000000] PM: Registered nosave memory: 00000000d4000000 - 00000000d8000000
[    0.000000] Memory: 16333512k/17301504k available (6570k kernel code, 534304k absent, 433688k reserved, 6672k data, 1356k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=64, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=64.
[    0.000000] NR_IRQS:8448 nr_irqs:1736 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS1] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Enabling automatic NUMA balancing. Configure with numa_balancing= or sysctl
[    0.000000] hpet clockevent registered
[    0.001000] tsc: Fast TSC calibration using PIT
[    0.002000] tsc: Detected 1699.989 MHz processor
[    0.000021] Calibrating delay loop (skipped), value calculated using timer frequency.. 3399.97 BogoMIPS (lpj=1699989)
[    0.010624] pid_max: default: 65536 minimum: 512
[    0.015339] Security Framework initialized
[    0.019434] SELinux:  Initializing.
[    0.022934] SELinux:  Starting in permissive mode
[    0.024961] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.038447] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.048372] Mount-cache hash table entries: 256
[    0.053328] Initializing cgroup subsys cpuacct
[    0.057767] Initializing cgroup subsys memory
[    0.062140] Initializing cgroup subsys devices
[    0.066577] Initializing cgroup subsys freezer
[    0.071011] Initializing cgroup subsys net_cls
[    0.075446] Initializing cgroup subsys blkio
[    0.079708] Initializing cgroup subsys perf_event
[    0.084464] tseg: 00df800000
[    0.084468] CPU: Physical Processor ID: 0
[    0.088470] CPU: Processor Core ID: 0
[    0.092125] mce: CPU supports 6 MCE banks
[    0.096132] LVT offset 0 assigned for vector 0xf9
[    0.100834] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
tlb_flushall_shift: 4
[    0.115528] Freeing SMP alternatives: 24k freed
[    0.121146] ACPI: Core revision 20130117
[    0.127325] ACPI: All ACPI Tables successfully acquired
[    0.134261] ftrace: allocating 24505 entries in 96 pages
[    0.154606] Switched APIC routing to physical flat.
[    0.160067] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.176054] smpboot: CPU0: AMD Opteron(tm) Processor 4162 EE (fam: 10, model: 08, stepping: 01)
[    0.286346] Performance Events: Broken BIOS detected, complain to your hardware vendor.
[    0.294341] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010000 is 1430076)
[    0.302841] AMD PMU driver.
[    0.305625] ... version:                0
[    0.309621] ... bit width:              48
[    0.313705] ... generic registers:      4
[    0.317701] ... value mask:             0000ffffffffffff
[    0.322997] ... max period:             00007fffffffffff
[    0.328294] ... fixed-purpose events:   0
[    0.332290] ... event mask:             000000000000000f
[    0.339820] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.347937] smpboot: Booting Node   1, Processors  #1 OK
[    0.443892] smpboot: Booting Node   0, Processors  #2 #3 #4 #5 #6 OK
[    0.516472] smpboot: Booting Node   1, Processors  #7 #8 #9 #10 #11
[    0.588677] Brought up 12 CPUs
[    0.591909] smpboot: Total of 12 processors activated (40801.87 BogoMIPS)
[    0.617442] devtmpfs: initialized
[    0.622511] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.629399] RTC time:  7:09:19, date: 03/07/13
[    0.633954] NET: Registered protocol family 16
[    0.638568] node 0 link 1: io port [e000, ffff]
[    0.638572] TOM: 00000000e0000000 aka 3584M
[    0.642748] Fam 10h mmconf [mem 0xf0000000-0xf3ffffff]
[    0.642751] node 0 link 1: mmio [e9800000, e9ffffff]
[    0.642754] node 0 link 1: mmio [ea000000, ef2fffff]
[    0.642757] node 0 link 1: mmio [fec80000, fecbffff]
[    0.642760] TOM2: 0000000420000000 aka 16896M
[    0.647108] bus: [bus 00-3f] on node 0 link 1
[    0.647110] bus: 00 [io  0x0000-0xffff]
[    0.647112] bus: 00 [mem 0xe0000000-0xefffffff]
[    0.647114] bus: 00 [mem 0xf4000000-0xffffffff]
[    0.647116] bus: 00 [mem 0x420000000-0xfcffffffff]
[    0.647279] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.654834] ACPI: bus type pci registered
[    0.658950] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.668236] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.678766] PCI: Using configuration type 1 for base access
[    0.684936] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.690928] mtrr: probably your BIOS does not setup all CPUs.
[    0.696659] mtrr: corrected configuration.
[    0.701935] bio: create slab <bio-0> at 0
[    0.706198] ACPI: Added _OSI(Module Device)
[    0.710373] ACPI: Added _OSI(Processor Device)
[    0.714806] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.719497] ACPI: Added _OSI(Processor Aggregator Device)
[    0.725637] ACPI: EC: Look up EC in DSDT
[    0.727435] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.734358] ACPI: Interpreter enabled
[    0.738015] ACPI: (supports S0ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.748815] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.758036] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20130117/hwxface-568)
[    0.767262]  S4 S5)
[    0.769383] ACPI: Using IOAPIC for interrupt routing
[    0.774463] HEST: Table parsing has been initialized.
[    0.779505] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.800120] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.806547] acpi PNP0A08:00: Requesting ACPI _OSC control (0x15)
[    0.812783] acpi PNP0A08:00: ACPI _OSC control (0x15) granted
[    0.820542] PCI host bridge to bus 0000:00
[    0.824631] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.830104] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.836269] pci_bus 0000:00: root bus resource [io  0xe000-0xffff]
[    0.842436] pci_bus 0000:00: root bus resource [io  0x0d00-0x0fff]
[    0.848601] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.855458] pci_bus 0000:00: root bus resource [mem 0xfec00000-0xfec7ffff]
[    0.862319] pci_bus 0000:00: root bus resource [mem 0xfec80000-0xfecbffff]
[    0.869179] pci_bus 0000:00: root bus resource [mem 0xea000000-0xef2fffff]
[    0.876039] pci_bus 0000:00: root bus resource [mem 0xe9800000-0xe9ffffff]
[    0.882896] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.889766] pci 0000:00:00.0: [1002:5a12] type 00 class 0x060000
[    0.889900] pci 0000:00:04.0: [1002:5a18] type 01 class 0x060400
[    0.889936] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.889959] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.895648] pci 0000:00:09.0: [1002:5a1c] type 01 class 0x060400
[    0.895682] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.895710] pci 0000:00:09.0: System wakeup disabled by ACPI
[    0.901411] pci 0000:00:11.0: [1002:4390] type 00 class 0x01018f
[    0.901431] pci 0000:00:11.0: reg 10: [io  0xecd0-0xecd7]
[    0.901441] pci 0000:00:11.0: reg 14: [io  0xecf0-0xecf3]
[    0.901452] pci 0000:00:11.0: reg 18: [io  0xecd8-0xecdf]
[    0.901462] pci 0000:00:11.0: reg 1c: [io  0xecf4-0xecf7]
[    0.901472] pci 0000:00:11.0: reg 20: [io  0xecb0-0xecbf]
[    0.901482] pci 0000:00:11.0: reg 24: [mem 0xef2ff800-0xef2ffbff]
[    0.901503] pci 0000:00:11.0: set SATA to AHCI mode
[    0.906477] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.906491] pci 0000:00:12.0: reg 10: [mem 0xef2fb000-0xef2fbfff]
[    0.906624] pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310
[    0.906639] pci 0000:00:12.1: reg 10: [mem 0xef2fc000-0xef2fcfff]
[    0.906775] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.906795] pci 0000:00:12.2: reg 10: [mem 0xef2ffe00-0xef2ffeff]
[    0.906878] pci 0000:00:12.2: supports D1 D2
[    0.906880] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.906974] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.906989] pci 0000:00:13.0: reg 10: [mem 0xef2fd000-0xef2fdfff]
[    0.907122] pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310
[    0.907136] pci 0000:00:13.1: reg 10: [mem 0xef2fe000-0xef2fefff]
[    0.907274] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.907294] pci 0000:00:13.2: reg 10: [mem 0xef2fff00-0xef2fffff]
[    0.907376] pci 0000:00:13.2: supports D1 D2
[    0.907379] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.907475] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.907639] pci 0000:00:14.1: [1002:439c] type 00 class 0x01018f
[    0.907656] pci 0000:00:14.1: reg 10: [io  0xece0-0xece7]
[    0.907666] pci 0000:00:14.1: reg 14: [io  0xecf8-0xecfb]
[    0.907676] pci 0000:00:14.1: reg 18: [io  0xece8-0xecef]
[    0.907686] pci 0000:00:14.1: reg 1c: [io  0xecfc-0xecff]
[    0.907696] pci 0000:00:14.1: reg 20: [io  0xecc0-0xeccf]
[    0.907818] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.907937] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.908029] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    0.908126] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    0.908207] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    0.908287] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    0.908373] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    0.908455] pci 0000:00:19.0: [1022:1200] type 00 class 0x060000
[    0.908548] pci 0000:00:19.1: [1022:1201] type 00 class 0x060000
[    0.908629] pci 0000:00:19.2: [1022:1202] type 00 class 0x060000
[    0.908711] pci 0000:00:19.3: [1022:1203] type 00 class 0x060000
[    0.908796] pci 0000:00:19.4: [1022:1204] type 00 class 0x060000
[    0.908925] pci 0000:01:00.0: [1000:0072] type 00 class 0x010700
[    0.908935] pci 0000:01:00.0: reg 10: [io  0xfc00-0xfcff]
[    0.908945] pci 0000:01:00.0: reg 14: [mem 0xef1f0000-0xef1fffff 64bit]
[    0.908955] pci 0000:01:00.0: reg 1c: [mem 0xef180000-0xef1bffff 64bit]
[    0.908967] pci 0000:01:00.0: reg 30: [mem 0xef000000-0xef0fffff pref]
[    0.909001] pci 0000:01:00.0: supports D1 D2
[    0.911074] pci 0000:00:04.0: PCI bridge to [bus 01]
[    0.916038] pci 0000:00:04.0:   bridge window [io  0xf000-0xffff]
[    0.916042] pci 0000:00:04.0:   bridge window [mem 0xef000000-0xef1fffff]
[    0.916111] pci 0000:02:00.0: [14e4:163b] type 00 class 0x020000
[    0.916129] pci 0000:02:00.0: reg 10: [mem 0xea000000-0xebffffff 64bit]
[    0.916210] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.916285] pci 0000:02:00.1: [14e4:163b] type 00 class 0x020000
[    0.916301] pci 0000:02:00.1: reg 10: [mem 0xec000000-0xedffffff 64bit]
[    0.916380] pci 0000:02:00.1: PME# supported from D0 D3hot D3cold
[    0.918072] pci 0000:00:09.0: PCI bridge to [bus 02]
[    0.923036] pci 0000:00:09.0:   bridge window [mem 0xea000000-0xedffffff]
[    0.923096] pci 0000:03:04.0: [102b:0532] type 00 class 0x030000
[    0.923119] pci 0000:03:04.0: reg 10: [mem 0xe9800000-0xe9ffffff pref]
[    0.923132] pci 0000:03:04.0: reg 14: [mem 0xeeffc000-0xeeffffff]
[    0.923146] pci 0000:03:04.0: reg 18: [mem 0xee000000-0xee7fffff]
[    0.923308] pci 0000:00:14.4: PCI bridge to [bus 03] (subtractive decode)
[    0.930084] pci 0000:00:14.4:   bridge window [mem 0xee000000-0xeeffffff]
[    0.930089] pci 0000:00:14.4:   bridge window [mem 0xe9800000-0xe9ffffff pref]
[    0.930092] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.930095] pci 0000:00:14.4:   bridge window [io  0xe000-0xffff] (subtractive decode)
[    0.930098] pci 0000:00:14.4:   bridge window [io  0x0d00-0x0fff] (subtractive decode)
[    0.930101] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.930104] pci 0000:00:14.4:   bridge window [mem 0xfec00000-0xfec7ffff] (subtractive decode)
[    0.930106] pci 0000:00:14.4:   bridge window [mem 0xfec80000-0xfecbffff] (subtractive decode)
[    0.930109] pci 0000:00:14.4:   bridge window [mem 0xea000000-0xef2fffff] (subtractive decode)
[    0.930112] pci 0000:00:14.4:   bridge window [mem 0xe9800000-0xe9ffffff] (subtractive decode)
[    0.930115] pci 0000:00:14.4:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.932154] ACPI: PCI Interrupt Link [LN24] (IRQs *24)
[    0.937368] ACPI: PCI Interrupt Link [LN25] (IRQs *25)
[    0.942575] ACPI: PCI Interrupt Link [LN26] (IRQs *26)
[    0.947780] ACPI: PCI Interrupt Link [LN27] (IRQs *27)
[    0.952987] ACPI: PCI Interrupt Link [LN28] (IRQs *28)
[    0.958198] ACPI: PCI Interrupt Link [LN29] (IRQs *29)
[    0.963407] ACPI: PCI Interrupt Link [LN30] (IRQs *30)
[    0.968613] ACPI: PCI Interrupt Link [LN31] (IRQs *31)
[    0.973819] ACPI: PCI Interrupt Link [LN32] (IRQs *32)
[    0.979025] ACPI: PCI Interrupt Link [LN33] (IRQs *33)
[    0.984233] ACPI: PCI Interrupt Link [LN34] (IRQs *34)
[    0.989443] ACPI: PCI Interrupt Link [LN35] (IRQs *35)
[    0.994649] ACPI: PCI Interrupt Link [LN36] (IRQs *36)
[    0.999852] ACPI: PCI Interrupt Link [LN37] (IRQs *37)
[    1.005058] ACPI: PCI Interrupt Link [LN38] (IRQs *38)
[    1.010268] ACPI: PCI Interrupt Link [LN39] (IRQs *39)
[    1.015477] ACPI: PCI Interrupt Link [LN40] (IRQs *40)
[    1.020680] ACPI: PCI Interrupt Link [LN41] (IRQs *41)
[    1.025886] ACPI: PCI Interrupt Link [LN42] (IRQs *42)
[    1.031093] ACPI: PCI Interrupt Link [LN43] (IRQs *43)
[    1.036303] ACPI: PCI Interrupt Link [LN44] (IRQs *44)
[    1.041511] ACPI: PCI Interrupt Link [LN45] (IRQs *45)
[    1.046714] ACPI: PCI Interrupt Link [LN46] (IRQs *46)
[    1.051921] ACPI: PCI Interrupt Link [LN47] (IRQs *47)
[    1.057138] ACPI: PCI Interrupt Link [LN48] (IRQs *48)
[    1.062345] ACPI: PCI Interrupt Link [LN49] (IRQs *49)
[    1.067554] ACPI: PCI Interrupt Link [LN50] (IRQs *50)
[    1.072758] ACPI: PCI Interrupt Link [LN51] (IRQs *51)
[    1.077966] ACPI: PCI Interrupt Link [LN52] (IRQs *52)
[    1.083175] ACPI: PCI Interrupt Link [LN53] (IRQs *53)
[    1.088383] ACPI: PCI Interrupt Link [LN54] (IRQs *54)
[    1.093593] ACPI: PCI Interrupt Link [LN55] (IRQs *55)
[    1.098877] ACPI: PCI Interrupt Link [LK00] (IRQs 3 4 5 6 7 10 11 *14 15)
[    1.105846] ACPI: PCI Interrupt Link [LK01] (IRQs 3 4 5 6 7 10 *11 14 15)
[    1.112806] ACPI: PCI Interrupt Link [LK02] (IRQs 3 4 5 6 7 *10 11 14 15)
[    1.119767] ACPI: PCI Interrupt Link [LK03] (IRQs 3 4 5 *6 7 10 11 14 15)
[    1.126728] ACPI: PCI Interrupt Link [LK04] (IRQs 3 4 *5 6 7 10 11 14 15)
[    1.133687] ACPI: PCI Interrupt Link [LK05] (IRQs 3 4 5 6 7 10 11 14 15) *0
[    1.140825] ACPI: PCI Interrupt Link [LK06] (IRQs 3 4 5 6 7 10 11 14 *15)
[    1.147787] ACPI: PCI Interrupt Link [LK07] (IRQs 3 4 5 6 7 10 11 14 15) *0
[    1.154939] ACPI: Enabled 2 GPEs in block 00 to 1F
[    1.159742] acpi root: \_SB_.PCI0 notify handler is installed
[    1.159782] Found 1 acpi root devices
[    1.159906] ACPI: No dock devices found.
[    1.163963] vgaarb: device added: PCI:0000:03:04.0,decodes=io+mem,owns=io+mem,locks=none
[    1.172044] vgaarb: loaded
[    1.174742] vgaarb: bridge control possible 0000:03:04.0
[    1.180136] SCSI subsystem initialized
[    1.183876] ACPI: bus type scsi registered
[    1.188089] libata version 3.00 loaded.
[    1.188120] ACPI: bus type usb registered
[    1.192144] usbcore: registered new interface driver usbfs
[    1.197624] usbcore: registered new interface driver hub
[    1.203006] usbcore: registered new device driver usb
[    1.208219] PCI: Using ACPI for IRQ routing
[    1.214376] PCI: pci_cache_line_size set to 64 bytes
[    1.214436] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    1.221380] Expanded resource reserved due to conflict with reserved
[    1.227718] e820: reserve RAM buffer [mem 0xdf699000-0xdfffffff]
[    1.227862] NetLabel: Initializing
[    1.231255] NetLabel:  domain hash size = 128
[    1.235600] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.240563] NetLabel:  unlabeled traffic allowed by default
[    1.246187] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.251365] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    1.259222] Switching to clocksource hpet
[    1.271187] pnp: PnP ACPI init
[    1.274271] ACPI: bus type pnp registered
[    1.278407] pnp 00:00: [dma 4]
[    1.278471] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.278542] pnp 00:01: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.278635] system 00:02: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.278689] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.279006] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.279285] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.280793] system 00:06: [io  0x0800-0x087f] has been reserved
[    1.286705] system 00:06: [io  0x0900-0x093f] has been reserved
[    1.292618] system 00:06: [io  0x0d00-0x0dfe] has been reserved
[    1.298529] system 00:06: [io  0x0dff] has been reserved
[    1.303834] system 00:06: [io  0x0e00-0x0efe] has been reserved
[    1.309745] system 00:06: [io  0x0eff] has been reserved
[    1.315050] system 00:06: [io  0x040b] has been reserved
[    1.320357] system 00:06: [io  0x04d6] has been reserved
[    1.325659] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    1.331569] system 00:06: [io  0x0c00-0x0c01] has been reserved
[    1.337478] system 00:06: [io  0x0c14] has been reserved
[    1.342783] system 00:06: [io  0x0c50-0x0c52] has been reserved
[    1.348693] system 00:06: [io  0x0c6c] has been reserved
[    1.353999] system 00:06: [io  0x0c6f] has been reserved
[    1.359305] system 00:06: [io  0x0cd0-0x0cd1] has been reserved
[    1.365215] system 00:06: [io  0x0cd2-0x0cd3] has been reserved
[    1.371127] system 00:06: [io  0x0cd4-0x0cd5] has been reserved
[    1.377038] system 00:06: [io  0x0cd6-0x0cd7] has been reserved
[    1.382948] system 00:06: [io  0x0cd8-0x0cdb] has been reserved
[    1.388859] system 00:06: [io  0x0cdc-0x0cdf] has been reserved
[    1.394770] system 00:06: [io  0x0ca0-0x0ca7] has been reserved
[    1.400681] system 00:06: [io  0x0ca9-0x0cab] has been reserved
[    1.406592] system 00:06: [io  0x0cad-0x0caf] has been reserved
[    1.412503] system 00:06: [io  0x0950] has been reserved
[    1.417809] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.417863] pnp 00:07: [irq 0 disabled]
[    1.417906] system 00:07: [io  0x0ca8] has been reserved
[    1.423217] system 00:07: [io  0x0cac] has been reserved
[    1.428521] system 00:07: Plug and Play ACPI device, IDs IPI0001 PNP0c01 (active)
[    1.429877] pnp 00:08: Plug and Play ACPI device, IDs PNP0c31 (active)
[    1.430551] pnp 00:09: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.430723] pnp: PnP ACPI: found 10 devices
[    1.434900] ACPI: ACPI bus type pnp unregistered
[    1.446850] pci 0000:00:04.0: PCI bridge to [bus 01]
[    1.451813] pci 0000:00:04.0:   bridge window [io  0xf000-0xffff]
[    1.457901] pci 0000:00:04.0:   bridge window [mem 0xef000000-0xef1fffff]
[    1.464682] pci 0000:00:09.0: PCI bridge to [bus 02]
[    1.469644] pci 0000:00:09.0:   bridge window [mem 0xea000000-0xedffffff]
[    1.476423] pci 0000:00:14.4: PCI bridge to [bus 03]
[    1.481385] pci 0000:00:14.4:   bridge window [mem 0xee000000-0xeeffffff]
[    1.488162] pci 0000:00:14.4:   bridge window [mem 0xe9800000-0xe9ffffff pref]
[    1.495499] ACPI: PCI Interrupt Link [LN52] enabled at IRQ 52
[    1.501345] ACPI: PCI Interrupt Link [LN53] enabled at IRQ 53
[    1.507104] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.507108] pci_bus 0000:00: resource 5 [io  0xe000-0xffff]
[    1.507110] pci_bus 0000:00: resource 6 [io  0x0d00-0x0fff]
[    1.507114] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
[    1.507117] pci_bus 0000:00: resource 8 [mem 0xfec00000-0xfec7ffff]
[    1.507119] pci_bus 0000:00: resource 9 [mem 0xfec80000-0xfecbffff]
[    1.507122] pci_bus 0000:00: resource 10 [mem 0xea000000-0xef2fffff]
[    1.507125] pci_bus 0000:00: resource 11 [mem 0xe9800000-0xe9ffffff]
[    1.507128] pci_bus 0000:00: resource 12 [mem 0xfed40000-0xfed44fff]
[    1.507131] pci_bus 0000:01: resource 0 [io  0xf000-0xffff]
[    1.507134] pci_bus 0000:01: resource 1 [mem 0xef000000-0xef1fffff]
[    1.507137] pci_bus 0000:02: resource 1 [mem 0xea000000-0xedffffff]
[    1.507141] pci_bus 0000:03: resource 1 [mem 0xee000000-0xeeffffff]
[    1.507144] pci_bus 0000:03: resource 2 [mem 0xe9800000-0xe9ffffff pref]
[    1.507147] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    1.507149] pci_bus 0000:03: resource 5 [io  0xe000-0xffff]
[    1.507152] pci_bus 0000:03: resource 6 [io  0x0d00-0x0fff]
[    1.507155] pci_bus 0000:03: resource 7 [mem 0x000a0000-0x000bffff]
[    1.507158] pci_bus 0000:03: resource 8 [mem 0xfec00000-0xfec7ffff]
[    1.507168] pci_bus 0000:03: resource 9 [mem 0xfec80000-0xfecbffff]
[    1.507171] pci_bus 0000:03: resource 10 [mem 0xea000000-0xef2fffff]
[    1.507174] pci_bus 0000:03: resource 11 [mem 0xe9800000-0xe9ffffff]
[    1.507177] pci_bus 0000:03: resource 12 [mem 0xfed40000-0xfed44fff]
[    1.507284] NET: Registered protocol family 2
[    1.512250] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    1.520498] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.527558] TCP: Hash tables configured (established 131072 bind 65536)
[    1.534216] TCP: reno registered
[    1.537481] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    1.543713] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    1.550607] NET: Registered protocol family 1
[    1.682059] pci 0000:03:04.0: Boot video device
[    1.682085] PCI: CLS 64 bytes, default 64
[    1.682155] Unpacking initramfs...
[    2.104346] Freeing initrd memory: 16092k freed
[    2.117513] PCI-DMA: Disabling AGP.
[    2.121164] PCI-DMA: aperture base @ d4000000 size 65536 KB
[    2.126729] PCI-DMA: using GART IOMMU.
[    2.130473] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    2.143971] LVT offset 1 assigned for vector 0x400
[    2.148772] IBS: LVT offset 1 assigned
[    2.152635] perf: AMD IBS detected (0x0000001f)
[    2.158815] Initialise module verification
[    2.162992] audit: initializing netlink socket (disabled)
[    2.168417] type=2000 audit(1362640158.396:1): initialized
[    2.209409] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.218789] VFS: Disk quotas dquot_6.5.2
[    2.222816] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.230065] msgmni has been set to 32061
[    2.234102] SELinux:  Registering netfilter hooks
[    2.236278] alg: No test for stdrng (krng)
[    2.240406] NET: Registered protocol family 38
[    2.244869] Key type asymmetric registered
[    2.248959] Asymmetric key parser 'x509' registered
[    2.253902] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.261398] io scheduler noop registered
[    2.265322] io scheduler deadline registered
[    2.269600] io scheduler cfq registered (default)
[    2.274522] pcieport 0000:00:04.0: irq 72 for MSI/MSI-X
[    2.274663] pcieport 0000:00:09.0: irq 73 for MSI/MSI-X
[    2.274813] pcieport 0000:00:04.0: Signaling PME through PCIe PME interrupt
[    2.281769] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    2.288285] pcie_pme 0000:00:04.0:pcie01: service driver pcie_pme loaded
[    2.288302] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
[    2.295249] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    2.301762] pci 0000:02:00.1: Signaling PME through PCIe PME interrupt
[    2.308281] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
[    2.308299] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.313877] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.320477] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    2.327271] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.334656] ACPI: Power Button [PWRF]
[    2.344729] ERST: Error Record Serialization Table (ERST) support is initialized.
[    2.352367] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
[    2.359868] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.386750] 00:04: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.412986] 00:05: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.419189] Non-volatile memory driver v1.3
[    2.423367] Linux agpgart interface v0.103
[    2.429059] loop: module loaded
[    2.432302] ahci 0000:00:11.0: version 3.0
[    2.432585] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    2.440684] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    2.449644] scsi0 : ahci
[    2.452355] scsi1 : ahci
[    2.455029] scsi2 : ahci
[    2.457710] scsi3 : ahci
[    2.460293] ata1: SATA max UDMA/133 abar m1024@0xef2ff800 port 0xef2ff900 irq 22
[    2.467676] ata2: SATA max UDMA/133 abar m1024@0xef2ff800 port 0xef2ff980 irq 22
[    2.475056] ata3: SATA max UDMA/133 abar m1024@0xef2ff800 port 0xef2ffa00 irq 22
[    2.482437] ata4: SATA max UDMA/133 abar m1024@0xef2ff800 port 0xef2ffa80 irq 22
[    2.489989] libphy: Fixed MDIO Bus: probed
[    2.494189] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.500710] ehci-pci: EHCI PCI platform driver
[    2.505262] ehci-pci 0000:00:12.2: EHCI Host Controller
[    2.510610] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[    2.518003] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.526694] ehci-pci 0000:00:12.2: debug port 1
[    2.531264] ehci-pci 0000:00:12.2: irq 17, io mem 0xef2ffe00
[    2.542645] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.548430] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.555204] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.562411] usb usb1: Product: EHCI Host Controller
[    2.567280] usb usb1: Manufacturer: Linux 3.9.0-rc1+ ehci_hcd
[    2.573014] usb usb1: SerialNumber: 0000:00:12.2
[    2.577792] hub 1-0:1.0: USB hub found
[    2.581548] hub 1-0:1.0: 6 ports detected
[    2.585838] ehci-pci 0000:00:13.2: EHCI Host Controller
[    2.591166] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[    2.598555] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.607248] ehci-pci 0000:00:13.2: debug port 1
[    2.611811] ehci-pci 0000:00:13.2: irq 19, io mem 0xef2fff00
[    2.622598] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.628354] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.635129] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.642336] usb usb2: Product: EHCI Host Controller
[    2.647205] usb usb2: Manufacturer: Linux 3.9.0-rc1+ ehci_hcd
[    2.652939] usb usb2: SerialNumber: 0000:00:13.2
[    2.657707] hub 2-0:1.0: USB hub found
[    2.661458] hub 2-0:1.0: 6 ports detected
[    2.665640] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.671930] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.677259] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    2.684682] ohci_hcd 0000:00:12.0: irq 16, io mem 0xef2fb000
[    2.744577] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.751355] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.758561] usb usb3: Product: OHCI Host Controller
[    2.763432] usb usb3: Manufacturer: Linux 3.9.0-rc1+ ohci_hcd
[    2.769167] usb usb3: SerialNumber: 0000:00:12.0
[    2.773930] hub 3-0:1.0: USB hub found
[    2.777686] hub 3-0:1.0: 3 ports detected
[    2.781921] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    2.787240] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    2.794516] ata1: SATA link down (SStatus 0 SControl 300)
[    2.794568] ata3: SATA link down (SStatus 0 SControl 300)
[    2.794622] ata4: SATA link down (SStatus 0 SControl 300)
[    2.794676] ata2: SATA link down (SStatus 0 SControl 300)
[    2.816175] ohci_hcd 0000:00:12.1: irq 16, io mem 0xef2fc000
[    2.876485] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.883262] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.890469] usb usb4: Product: OHCI Host Controller
[    2.895337] usb usb4: Manufacturer: Linux 3.9.0-rc1+ ohci_hcd
[    2.901071] usb usb4: SerialNumber: 0000:00:12.1
[    2.905841] hub 4-0:1.0: USB hub found
[    2.909594] hub 4-0:1.0: 3 ports detected
[    2.913822] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.919144] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    2.926562] ohci_hcd 0000:00:13.0: irq 18, io mem 0xef2fd000
[    2.986419] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.993194] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.000401] usb usb5: Product: OHCI Host Controller
[    3.005269] usb usb5: Manufacturer: Linux 3.9.0-rc1+ ohci_hcd
[    3.011004] usb usb5: SerialNumber: 0000:00:13.0
[    3.015755] hub 5-0:1.0: USB hub found
[    3.019515] hub 5-0:1.0: 3 ports detected
[    3.023745] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    3.029077] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    3.036481] ohci_hcd 0000:00:13.1: irq 18, io mem 0xef2fe000
[    3.096360] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.103137] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.110343] usb usb6: Product: OHCI Host Controller
[    3.115211] usb usb6: Manufacturer: Linux 3.9.0-rc1+ ohci_hcd
[    3.120945] usb usb6: SerialNumber: 0000:00:13.1
[    3.125719] hub 6-0:1.0: USB hub found
[    3.129474] hub 6-0:1.0: 3 ports detected
[    3.133607] uhci_hcd: USB Universal Host Controller Interface driver
[    3.140043] usbcore: registered new interface driver usbserial
[    3.145875] tsc: Refined TSC clocksource calibration: 1700.020 MHz
[    3.152051] Switching to clocksource tsc
[    3.152102] usbcore: registered new interface driver usbserial_generic
[    3.152117] usbserial: USB Serial support registered for generic
[    3.152160] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.154985] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.154991] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.155164] mousedev: PS/2 mouse device common for all mice
[    3.155506] rtc_cmos 00:03: RTC can wake from S4
[    3.155743] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    3.155795] rtc_cmos 00:03: alarms up to one day, y3k, 242 bytes nvram, hpet irqs
[    3.155917] device-mapper: uevent: version 1.0.3
[    3.156035] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[    3.156092] cpuidle: using governor ladder
[    3.156093] cpuidle: using governor menu
[    3.156617] EFI Variables Facility v0.08 2004-May-17
[    3.156636] hidraw: raw HID events driver (C) Jiri Kosina
[    3.156758] usbcore: registered new interface driver usbhid
[    3.156758] usbhid: USB HID core driver
[    3.156825] drop_monitor: Initializing network drop monitor service
[    3.156967] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.261215] TCP: cubic registered
[    3.261227] usb 1-3: new high-speed USB device number 3 using ehci-pci
[    3.271053] Initializing XFRM netlink socket
[    3.275491] NET: Registered protocol family 10
[    3.280257] mip6: Mobile IPv6
[    3.283218] NET: Registered protocol family 17
[    3.288265] PM: Hibernation image not present or could not be loaded.
[    3.288268] Loading module verification certificates
[    3.293252] X.509: Cert 133ea77f00abda964be00043ec3fc74fd2ca00cd is not yet valid
[    3.300719] MODSIGN: Problem loading in-kernel X.509 certificate (-129)
[    3.307326] registered taskstats version 1
[    3.312951]   Magic number: 5:861:166
[    3.316763] powernow-k8: This CPU is not supported anymore, using acpi-cpufreq instead.
[    3.328137] Freeing unused kernel memory: 1356k freed
[    3.333596] Write protecting the kernel read-only data: 12288k
[    3.344981] Freeing unused kernel memory: 1612k freed
[    3.354901] Freeing unused kernel memory: 1316k freed
[    3.366125] systemd[1]: systemd 197 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    3.378677] systemd[1]: Running in initial RAM disk.
[    3.389752] usb 1-3: New USB device found, idVendor=0424, idProduct=2514
[    3.397539] usb 1-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.406877] hub 1-3:1.0: USB hub found
[    3.410896] systemd[1]: Set hostname to <dell-per515-01.lab.bos.redhat.com>.
[    3.411056] hub 1-3:1.0: 4 ports detected
[    3.431738] systemd[1]: Starting udev Kernel Socket.
[    3.443189] systemd[1]: Listening on udev Kernel Socket.
[    3.448620] systemd[1]: Starting udev Control Socket.
[    3.459163] systemd[1]: Listening on udev Control Socket.
[    3.464582] systemd[1]: Starting Journal Socket.
[    3.475157] systemd[1]: Listening on Journal Socket.
[    3.480144] systemd[1]: Starting dracut cmdline hook...
[    3.492493] systemd[1]: Started Load Kernel Modules.
[    3.497468] systemd[1]: Starting Journal Service...
[    3.514108] systemd[1]: Started Journal Service.
[    3.519056] systemd[1]: Starting Sockets.
[    3.529099] systemd[1]: Reached target Sockets.
[    3.533653] systemd[1]: Starting Swap.
[    3.542071] systemd[1]: Reached target Swap.
[    3.546360] systemd[1]: Starting Local File Systems.
[    3.557094] systemd[1]: Reached target Local File Systems.
[    3.592109] systemd[1]: Started dracut cmdline hook.
[    3.597162] systemd[1]: Starting Setup Virtual Console...
[    3.607904] systemd[1]: Starting dracut pre-udev hook...
[    3.627079] systemd[1]: Started Setup Virtual Console.
[    3.632304] systemd[1]: Starting System Initialization.
[    3.641011] usb 3-2: new full-speed USB device number 2 using ohci_hcd
[    3.650076] systemd[1]: Reached target System Initialization.
[    3.662012] systemd[1]: Started dracut pre-udev hook.
[    3.667231] systemd[1]: Starting udev Kernel Device Manager...
[    3.682412] systemd-udevd[178]: starting version 197
[    3.693035] systemd[1]: Started udev Kernel Device Manager.
[    3.698689] systemd[1]: Starting dracut pre-trigger hook...
[    3.777568] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[    3.780107] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[    3.780142] pata_atiixp: module verification failed: signature and/or required key missing - tainting kernel
[    3.781774] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[    3.824322] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[    3.824584] scsi4 : pata_atiixp
[    3.824672] scsi5 : pata_atiixp
[    3.824722] ata5: PATA max UDMA/100 cmd 0xece0 ctl 0xecf8 bmdma 0xecc0 irq 16
[    3.824723] ata6: PATA max UDMA/100 cmd 0xece8 ctl 0xecfc bmdma 0xecc8 irq 16
[    3.829952] usb 3-2: New USB device found, idVendor=0624, idProduct=0248
[    3.829954] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.829956] usb 3-2: Product: USB Composite Device-0
[    3.829958] usb 3-2: Manufacturer: Avocent
[    3.829959] usb 3-2: SerialNumber: 20080519
[    3.830021] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[    3.846256] input: Avocent USB Composite Device-0 as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.0/input/input1
[    3.846393] hid-generic 0003:0624:0248.0001: input,hidraw0: USB HID v1.00 Keyboard [Avocent USB Composite Device-0] on usb-0000:00:12.0-2/input0
[    3.854182] input: Avocent USB Composite Device-0 as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.1/input/input2
[    3.854342] hid-generic 0003:0624:0248.0002: input,hidraw1: USB HID v1.00 Mouse [Avocent USB Composite Device-0] on usb-0000:00:12.0-2/input1
[    3.942577] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[    3.944942] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[    3.966409] mpt2sas version 14.100.00.00 loaded
[    3.966437] [drm] Initialized drm 1.1.0 20060810
[    3.977029] scsi6 : Fusion MPT SAS Host
[    3.979242] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[    3.993416] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[    3.993429] ACPI: PCI Interrupt Link [LN44] enabled at IRQ 44
[    3.993462] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (16419864 kB)
[    3.994078] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[    3.996314] ata5.00: ATAPI: TEAC DVD-ROM DV-28SW, R.2A, max UDMA/100
[    3.996321] ata5.00: limited to UDMA/33 due to 40-wire cable
[    4.035297] ata5.00: configured for UDMA/33
[    4.045837] mpt2sas 0000:01:00.0: irq 74 for MSI/MSI-X
[    4.045864] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 74
[    4.046104] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[    4.062260] mpt2sas0: iomem(0x00000000ef1f0000), mapped(0xffffc90005d60000), size(65536)
[    4.070373] mpt2sas0: ioport(0x000000000000fc00), size(256)
[    4.070393] scsi 4:0:0:0: CD-ROM            TEAC     DVD-ROM DV-28SW  R.2A PQ: 0 ANSI: 5
[    4.071544] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[    4.100455] [TTM] Zone  kernel: Available graphics memory: 8209932 kiB
[    4.107036] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    4.113557] [TTM] Initializing pool allocator
[    4.117917] [TTM] Initializing DMA pool allocator
[    4.139776] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[    4.145977] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.151454] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    4.151837] sr 4:0:0:0: Attached scsi generic sg0 type 5
[    4.176671] fbcon: mgadrmfb (fb0) is primary device
[    4.275029] [drm] mga base 0
[    4.411381] Console: switching to colour frame buffer device 128x48
[    4.515835] mgag200 0000:03:04.0: fb0: mgadrmfb frame buffer device
[    4.515837] mgag200 0000:03:04.0: registered panic notifier
[    4.515849] [drm] Initialized mgag200 1.0.0 20110418 for 0000:03:04.0 on minor 0
[    4.525459] mpt2sas0: sending diag reset !!
[    5.846734] mpt2sas0: diag reset: SUCCESS
[    5.893380] mpt2sas0: Allocated physical memory: size(5629 kB)
[    5.899214] mpt2sas0: Current Controller Queue Depth(2508), Max Controller Queue Depth(2607)
[    5.907639] mpt2sas0: Scatter Gather Elements per IO(128)
[    5.972255] mpt2sas0: LSISAS2008: FWVersion(07.15.08.00), ChipRevision(0x03), BiosVersion(07.11.10.00)
[    5.981560] mpt2sas0: Dell PERC H200 Integrated: Vendor(0x1000), Device(0x0072), SSVID(0x1028), SSDID(0x1F1E)
[    5.991459] mpt2sas0: Protocol=(Initiator,Target), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[    6.003533] mpt2sas0: sending port enable !!
[    7.623802] mpt2sas0: host_add: handle(0x0001), sas_addr(0x5842b2b075e97c00), phys(8)
[   13.747202] mpt2sas0: port enable: SUCCESS
[   13.752533] scsi 6:0:0:0: Direct-Access     SEAGATE  ST9146803SS      FS64 PQ: 0 ANSI: 5
[   13.760627] scsi 6:0:0:0: SSP: handle(0x000b), sas_addr(0x5000c50031c9b7f1), phy(7), device_name(0x00c50050f0b7c931)
[   13.771124] scsi 6:0:0:0: SSP: enclosure_logical_id(0x5842b2b075e97c00), slot(0)
[   13.778523] scsi 6:0:0:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
[   13.789615] scsi 6:0:1:0: Direct-Access     SEAGATE  ST9146803SS      FS64 PQ: 0 ANSI: 5
[   13.797707] scsi 6:0:1:0: SSP: handle(0x000a), sas_addr(0x5000c50031c968b5), phy(6), device_name(0x00c50050b468c931)
[   13.808201] scsi 6:0:1:0: SSP: enclosure_logical_id(0x5842b2b075e97c00), slot(1)
[   13.815588] scsi 6:0:1:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
[   13.825856] sd 6:0:0:0: Attached scsi generic sg1 type 0
[   13.831456] sd 6:0:0:0: [sda] 286749480 512-byte logical blocks: (146 GB/136 GiB)
[   13.831479] sd 6:0:1:0: Attached scsi generic sg2 type 0
[   13.831761] sd 6:0:1:0: [sdb] 286749480 512-byte logical blocks: (146 GB/136 GiB)
[   13.833332] sd 6:0:1:0: [sdb] Write Protect is off
[   13.833336] sd 6:0:1:0: [sdb] Mode Sense: bb 00 10 08
[   13.834562] sd 6:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   13.838547]  sdb: sdb1
[   13.843167] sd 6:0:1:0: [sdb] Attached SCSI disk
[   13.873564] sd 6:0:0:0: [sda] Write Protect is off
[   13.878374] sd 6:0:0:0: [sda] Mode Sense: bb 00 10 08
[   13.879606] sd 6:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   13.892285]  sda: sda1 sda2
[   13.899850] sd 6:0:0:0: [sda] Attached SCSI disk
[   14.211176] bio: create slab <bio-1> at 1
[   14.436586] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   14.557297] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   14.685467] systemd-journald[123]: Received SIGTERM
[   15.192946] type=1404 audit(1362640171.428:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[   15.306973] SELinux: 2048 avtab hash slots, 95415 rules.
[   15.328333] SELinux: 2048 avtab hash slots, 95415 rules.
[   15.501832] SELinux:  9 users, 15 roles, 4379 types, 243 bools, 1 sens, 1024 cats
[   15.501838] SELinux:  83 classes, 95415 rules
[   15.507834] SELinux:  Permission attach_queue in class tun_socket not defined in policy.
[   15.515909] SELinux: the above unknown classes and permissions will be allowed
[   15.523118] SELinux:  Completing initialization.
[   15.523120] SELinux:  Setting up existing superblocks.
[   15.523128] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   15.523135] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[   15.523146] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[   15.523153] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   15.523163] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   15.523184] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[   15.524234] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[   15.524240] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[   15.525450] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[   15.525457] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[   15.525461] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[   15.525479] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[   15.525486] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   15.525494] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[   15.525513] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   15.526099] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[   15.526102] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   15.526114] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   15.526225] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   15.526264] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   15.526270] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   15.526278] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   15.526303] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   15.526314] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   15.526320] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   15.526325] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   15.526330] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   15.526343] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[   15.526353] SELinux: initialized (dev dm-1, type ext4), uses xattr
[   15.543092] type=1403 audit(1362640171.778:3): policy loaded auid=4294967295 ses=4294967295
[   15.557082] systemd[1]: Successfully loaded SELinux policy in 392ms 252us.
[   15.655056] systemd[1]: RTC configured in localtime, applying delta of -300 minutes to system time.
[   15.732301] systemd[1]: Relabelled /dev and /run in 52ms 67us.
[   16.213651] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   16.328883] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[   16.449098] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   16.528563] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[   16.530714] systemd-udevd[461]: starting version 197
[   16.933373] EXT4-fs (dm-1): re-mounted. Opts: (null)
[   18.208993] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.209379] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.209415] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.243468] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.260396] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.262346] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.262501] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.262521] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.262529] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.262600] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.262760] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.262916] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.263013] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.263062] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.263385] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.263698] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.270175] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.270252] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.271265] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.271865] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.272255] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.273131] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.273600] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.279413] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.243206] ACPI Error: No handler for Region [IPMI] (ffff880414410318) [IPMI] (20130117/evregion-161)
[   18.487070] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   18.487361] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.508123] ACPI Error: Region IPMI (ID=7) has no handler (20130117/exfldio-305)
[   18.524621] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.515556] ACPI Error: Method parse/execution failed [\_SB_.PMI0._GHL] (Node ffff88021444e168), AE_NOT_EXIST (20130117/psparse-537)
[   18.541285] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   18.538825] ACPI Error: Method parse/execution failed [\_SB_.PMI0._PMC] (Node ffff88021444e0c8), AE_NOT_EXIST (20130117/psparse-537)
[   18.550344] ACPI Exception: AE_NOT_EXIST, 
[   18.550345] Evaluating _PMC
[   18.550346]  (20130117/power_meter-753)
[   18.553940] microcode: CPU0: patch_level=0x010000c4
[   18.554148] MCE: In-kernel MCE decoding enabled.
[   18.563318] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.563462] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.571261] tpm_tis 00:08: 1.2 TPM (device-id 0x0, rev-id 78)
[   18.599861] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0x900, revision 0
[   18.600891] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.601018] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.633329] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller at 0x920
[   18.634474] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.635270] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.663938] bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.2.3 (June 27, 2012)
[   18.672451] EDAC MC: Ver: 3.0.0
[   18.672495] ACPI: PCI Interrupt Link [LN48] enabled at IRQ 48
[   18.672839] microcode: failed to load file amd-ucode/microcode_amd.bin
[   18.673374] bnx2 0000:02:00.0 eth0: Broadcom NetXtreme II BCM5716 1000Base-T (C0) PCI Express found at mem ea000000, IRQ 48, node addr 60:eb:69:8f:6b:1d
[   18.673501] ACPI: PCI Interrupt Link [LN49] enabled at IRQ 49
[   18.674350] bnx2 0000:02:00.1 eth1: Broadcom NetXtreme II BCM5716 1000Base-T (C0) PCI Express found at mem ec000000, IRQ 49, node addr 60:eb:69:8f:6b:1e
[   18.720776] microcode: CPU1: patch_level=0x010000c4
[   18.725651] microcode: CPU2: patch_level=0x010000c4
[   18.730527] microcode: CPU3: patch_level=0x010000c4
[   18.730555] kvm: Nested Virtualization enabled
[   18.730579] kvm: Nested Paging enabled
[   18.743568] microcode: CPU4: patch_level=0x010000c4
[   18.748443] microcode: CPU5: patch_level=0x010000c4
[   18.753315] microcode: CPU6: patch_level=0x010000c4
[   18.758207] microcode: CPU7: patch_level=0x010000c4
[   18.758783] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.774361] microcode: CPU8: patch_level=0x010000c4
[   18.779271] microcode: CPU9: patch_level=0x010000c4
[   18.784144] microcode: CPU10: patch_level=0x010000c4
[   18.784170] microcode: CPU11: patch_level=0x010000c4
[   18.784337] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   18.784954] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.814083] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   18.825481] AMD64 EDAC driver v3.4.0
[   18.829163] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.03
[   18.829173] EDAC amd64: DRAM ECC enabled.
[   18.829184] EDAC amd64: F10h detected (node 0).
[   18.829206] EDAC MC: DCT0 chip selects:
[   18.829207] EDAC amd64: MC: 0:     0MB 1:     0MB
[   18.829219] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   18.829220] EDAC amd64: MC: 4:     0MB 5:     0MB
[   18.829221] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   18.829222] EDAC MC: DCT1 chip selects:
[   18.829223] EDAC amd64: MC: 0:     0MB 1:     0MB
[   18.829223] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   18.829224] EDAC amd64: MC: 4:     0MB 5:     0MB
[   18.829225] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   18.829226] EDAC amd64: using x8 syndromes.
[   18.829227] EDAC amd64: MCT channel count: 2
[   18.829252] EDAC amd64: CS2: Registered DDR3 RAM
[   18.829253] EDAC amd64: CS3: Registered DDR3 RAM
[   18.829254] EDAC amd64: CS6: Registered DDR3 RAM
[   18.829254] EDAC amd64: CS7: Registered DDR3 RAM
[   18.829571] EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
[   18.829607] EDAC amd64: DRAM ECC enabled.
[   18.923914] EDAC amd64: F10h detected (node 1).
[   18.924011] sp5100_tco: PCI Revision ID: 0x3d
[   18.924104] sp5100_tco: Using 0xf4000000 for watchdog MMIO address
[   18.924121] sp5100_tco: Last reboot was not triggered by watchdog.
[   18.924322] sp5100_tco: initialized (0xffffc90005c12000). heartbeat=60 sec (nowayout=0, force_addr=none)
[   18.956025] EDAC MC: DCT0 chip selects:
[   18.956028] EDAC amd64: MC: 0:     0MB 1:     0MB
[   18.962055] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   18.968167] EDAC amd64: MC: 4:     0MB 5:     0MB
[   18.974252] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   18.980333] EDAC MC: DCT1 chip selects:
[   18.980335] EDAC amd64: MC: 0:     0MB 1:     0MB
[   18.986415] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[   18.991454] EDAC amd64: MC: 4:     0MB 5:     0MB
[   18.996155] EDAC amd64: MC: 6:  1024MB 7:  1024MB
[   19.000854] EDAC amd64: using x8 syndromes.
[   19.005034] EDAC amd64: MCT channel count: 2
[   19.009326] EDAC amd64: CS2: Registered DDR3 RAM
[   19.013944] EDAC amd64: CS3: Registered DDR3 RAM
[   19.018554] EDAC amd64: CS6: Registered DDR3 RAM
[   19.023164] EDAC amd64: CS7: Registered DDR3 RAM
[   19.028133] EDAC MC1: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:19.2
[   19.035613] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
[   19.049370] systemd-udevd[495]: renamed network interface eth0 to em1
[   19.063332] systemd-udevd[498]: renamed network interface eth1 to em2
[   19.157090] Adding 8216572k swap on /dev/mapper/fedora_dell--per515--01-swap.  Priority:-1 extents:1 across:8216572k 
[   19.614499] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[   19.622168] SELinux: initialized (dev dm-2, type ext4), uses xattr
[   20.073168] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   20.083562] SELinux: initialized (dev sda1, type ext4), uses xattr
[   20.111648] systemd-journald[481]: Received SIGUSR1
[   20.488043] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   20.500038] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   20.510411] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   20.532668] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   20.544537] Ebtables v2.0 registered
[   20.551597] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   20.576201] bnx2 0000:02:00.0: irq 75 for MSI/MSI-X
[   20.576243] bnx2 0000:02:00.0: irq 76 for MSI/MSI-X
[   20.576261] bnx2 0000:02:00.0: irq 77 for MSI/MSI-X
[   20.576271] bnx2 0000:02:00.0: irq 78 for MSI/MSI-X
[   20.576285] bnx2 0000:02:00.0: irq 79 for MSI/MSI-X
[   20.576295] bnx2 0000:02:00.0: irq 80 for MSI/MSI-X
[   20.576304] bnx2 0000:02:00.0: irq 81 for MSI/MSI-X
[   20.576314] bnx2 0000:02:00.0: irq 82 for MSI/MSI-X
[   20.576323] bnx2 0000:02:00.0: irq 83 for MSI/MSI-X
[   20.615592] bnx2 0000:02:00.0 em1: using MSIX
[   20.620096] IPv6: ADDRCONF(NETDEV_UP): em1: link is not ready
[   20.632153] bnx2 0000:02:00.1: irq 84 for MSI/MSI-X
[   20.632170] bnx2 0000:02:00.1: irq 85 for MSI/MSI-X
[   20.632201] bnx2 0000:02:00.1: irq 86 for MSI/MSI-X
[   20.632215] bnx2 0000:02:00.1: irq 87 for MSI/MSI-X
[   20.632225] bnx2 0000:02:00.1: irq 88 for MSI/MSI-X
[   20.632235] bnx2 0000:02:00.1: irq 89 for MSI/MSI-X
[   20.632244] bnx2 0000:02:00.1: irq 90 for MSI/MSI-X
[   20.632254] bnx2 0000:02:00.1: irq 91 for MSI/MSI-X
[   20.632264] bnx2 0000:02:00.1: irq 92 for MSI/MSI-X
[   20.671553] bnx2 0000:02:00.1 em2: using MSIX
[   20.676015] IPv6: ADDRCONF(NETDEV_UP): em2: link is not ready
[   20.722442] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   20.735282] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   20.742114] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   20.756228] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   20.768436] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   20.845041] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   20.904754] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   20.917417] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   20.929345] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   20.990231] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   21.002945] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   21.036887] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   21.098050] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   21.338943] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   21.351390] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   21.598536] Request for unknown module key 'Magrathea: Glacier signing key: 133ea77f00abda964be00043ec3fc74fd2ca00cd' err -11
[   23.750701] bnx2 0000:02:00.0 em1: NIC Copper Link is Up, 1000 Mbps full duplex

[   23.759624] IPv6: ADDRCONF(NETDEV_CHANGE): em1: link becomes ready
[   66.736767] nf_conntrack: automatic helper assignment is deprecated and it will be removed soon. Use the iptables CT target to attach helpers instead.
