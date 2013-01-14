Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481Ab3ANXYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 18:24:22 -0500
Received: from mail.crc.id.au ([203.56.246.92]:60157 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757928Ab3ANXYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 18:24:20 -0500
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2013 18:24:19 EST
Message-ID: <50F491C8.2030506@crc.id.au>
Date: Tue, 15 Jan 2013 10:16:24 +1100
From: Steven Haigh <netwiz@crc.id.au>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel 3.7.[12] - irq 16: nobody cared
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Firstly, please include me in any replies as I am not a list subscriber.

I'm trying to nail down a problem using Xen 4.2.1 & Kernel 3.7.1 (also 
3.7.2). It seems at random periods of time I get the following via the 
syslog:

Message from syslogd@xenhost at Jan 15 09:02:36 ...
  kernel:Disabling IRQ #16

Looking at IRQ16:
[root@xenhost xen]# cat /proc/interrupts | grep 16
  16:    1900000  xen-pirq-ioapic-level  sata_mv

I also see this in the dmesg:
irq 16: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper/0 Not tainted 3.7.2-1.el6xen.x86_64 #1
Call Trace:
  <IRQ>  [<ffffffff810a77f2>] __report_bad_irq+0x3a/0xc6
  [<ffffffff810a79e7>] note_interrupt+0x169/0x1e5
  [<ffffffff810a59b7>] handle_irq_event_percpu+0x16e/0x1b6
  [<ffffffff810a5a37>] handle_irq_event+0x38/0x54
  [<ffffffff810a8199>] handle_fasteoi_irq+0x88/0xd5
  [<ffffffff812c23f5>] __xen_evtchn_do_upcall+0x15a/0x1f7
  [<ffffffff812c3707>] xen_evtchn_do_upcall+0x2f/0x42
  [<ffffffff814a44be>] xen_do_hypervisor_callback+0x1e/0x30
  <EOI>  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
  [<ffffffff81007047>] ? xen_safe_halt+0x10/0x1a
  [<ffffffff810169b1>] ? default_idle+0x50/0x8a
  [<ffffffff81016318>] ? cpu_idle+0xc0/0xff
  [<ffffffff8148160e>] ? rest_init+0x72/0x74
  [<ffffffff81745b22>] ? start_kernel+0x3b0/0x3bd
  [<ffffffff817455a7>] ? repair_env_string+0x58/0x58
  [<ffffffff817452dd>] ? x86_64_start_reservations+0xb8/0xbd
  [<ffffffff81748cad>] ? xen_start_kernel+0x4f2/0x4f4
handlers:
[<ffffffffa012edd9>] mv_interrupt [sata_mv]
Disabling IRQ #16

I have tried booting with the irqpoll option on the kernel boot line, 
but the same problem occurs.

It seems disk throughput almost drops dead when this happens - as the 
SATA controller seems to go into some different mode of operation. It 
also seems like this has only happened recently - I was using builds of 
3.6.x as my Xen Dom0 kernel with no signs of this problem.

Has anyone else seen this in recent kernel releases? I'm not quite sure 
how to try and track this down.

Some system specs follow:
# dmidecode 2.11
SMBIOS 2.7 present.
75 structures occupying 3098 bytes.
Table at 0x000EB420.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
         Vendor: American Megatrends Inc.
         Version: U1f
         Release Date: 06/13/2012
         Address: 0xF0000
         Runtime Size: 64 kB
         ROM Size: 4096 kB
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
                 ACPI is supported
                 USB legacy is supported
                 BIOS boot specification is supported
                 Targeted content distribution is supported
                 UEFI is supported
         BIOS Revision: 4.6

Handle 0x0001, DMI type 1, 27 bytes
System Information
         Manufacturer: Gigabyte Technology Co., Ltd.
         Product Name: To be filled by O.E.M.
         Version: To be filled by O.E.M.
         Serial Number: To be filled by O.E.M.
         UUID: 03E50250-0449-054D-4A06-F60700080009
         Wake-up Type: Power Switch
         SKU Number: To be filled by O.E.M.
         Family: To be filled by O.E.M.

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
         Manufacturer: Gigabyte Technology Co., Ltd.
         Product Name: Z68M-D2H
         Version: To be filled by O.E.M.
         Serial Number: To be filled by O.E.M.
         Asset Tag: To be filled by O.E.M.
         Features:
                 Board is a hosting board
                 Board is replaceable
         Location In Chassis: To be filled by O.E.M.
         Chassis Handle: 0x0003
         Type: Motherboard
         Contained Object Handles: 0

Handle 0x0003, DMI type 3, 22 bytes
Chassis Information
         Manufacturer: Gigabyte Technology Co., Ltd.
         Type: Desktop
         Lock: Not Present
         Version: To Be Filled By O.E.M.
         Serial Number: To Be Filled By O.E.M.
         Asset Tag: To Be Filled By O.E.M.
         Boot-up State: Safe
         Power Supply State: Safe
         Thermal State: Safe
         Security Status: None
         OEM Information: 0x00000000
         Height: Unspecified
         Number Of Power Cords: 1
         Contained Elements: 0
         SKU Number: To be filled by O.E.M.

Handle 0x0004, DMI type 7, 19 bytes
Cache Information
         Socket Designation: CPU Internal L1
         Configuration: Enabled, Not Socketed, Level 1
         Operational Mode: Write Through
         Location: Internal
         Installed Size: 128 kB
         Maximum Size: 128 kB
         Supported SRAM Types:
                 Unknown
         Installed SRAM Type: Unknown
         Speed: Unknown
         Error Correction Type: Parity
         System Type: Other
         Associativity: 16-way Set-associative

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
         Socket Designation: CPU Internal L2
         Configuration: Enabled, Not Socketed, Level 2
         Operational Mode: Write Through
         Location: Internal
         Installed Size: 1024 kB
         Maximum Size: 1024 kB
         Supported SRAM Types:
                 Unknown
         Installed SRAM Type: Unknown
         Speed: Unknown
         Error Correction Type: Multi-bit ECC
         System Type: Instruction
         Associativity: 16-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
         Socket Designation: CPU Internal L3
         Configuration: Enabled, Not Socketed, Level 3
         Operational Mode: Write Back
         Location: Internal
         Installed Size: 6144 kB
         Maximum Size: 6144 kB
         Supported SRAM Types:
                 Unknown
         Installed SRAM Type: Unknown
         Speed: Unknown
         Error Correction Type: Multi-bit ECC
         System Type: Instruction
         Associativity: 48-way Set-associative

... snip a bit ...

Handle 0x0020, DMI type 9, 17 bytes
System Slot Information
         Designation: J6B2
         Type: x16 PCI Express
         Current Usage: In Use
         Length: Long
         ID: 0
         Characteristics:
                 3.3 V is provided
                 Opening is shared
                 PME signal is supported
         Bus Address: 0000:00:02.0

Handle 0x0021, DMI type 9, 17 bytes
System Slot Information
         Designation: J6B1
         Type: x1 PCI Express
         Current Usage: In Use
         Length: Short
         ID: 1
         Characteristics:
                 3.3 V is provided
                 Opening is shared
                 PME signal is supported
         Bus Address: 0000:00:1c.0

Handle 0x0022, DMI type 9, 17 bytes
System Slot Information
         Designation: J6D1
         Type: x8 PCI Express
         Current Usage: In Use
         Length: Short
         ID: 2
         Characteristics:
                 3.3 V is provided
                 Opening is shared
                 PME signal is supported
         Bus Address: 0000:00:01.0

Handle 0x0023, DMI type 9, 17 bytes
System Slot Information
         Designation: J7B1
         Type: x16 PCI Express
         Current Usage: In Use
         Length: Short
         ID: 3
         Characteristics:
                 3.3 V is provided
                 Opening is shared
                 PME signal is supported
         Bus Address: 0000:00:03.0

Handle 0x0024, DMI type 9, 17 bytes
System Slot Information
         Designation: J8B4
         Type: x1 PCI Express
         Current Usage: In Use
         Length: Short
         ID: 4
         Characteristics:
                 3.3 V is provided
                 Opening is shared
                 PME signal is supported
         Bus Address: 0000:00:1c.7

Handle 0x0025, DMI type 9, 17 bytes
System Slot Information
         Designation: J8B3
         Type: 32-bit PCI
         Current Usage: In Use
         Length: Short
         ID: 6
         Characteristics:
                 3.3 V is provided
                 Opening is shared
                 PME signal is supported
         Bus Address: 0000:14:1e.0

... snip a bit more ....

Handle 0x0043, DMI type 4, 42 bytes
Processor Information
         Socket Designation: Intel(R) Core(TM) i5-2500K CPU @ 3.30GHz
         Type: Central Processor
         Family: Core i7
         Manufacturer: Intel
         ID: A7 06 02 00 FF FB EB BF
         Signature: Type 0, Family 6, Model 42, Stepping 7
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
         Version: Intel(R) Core(TM) i5-2500K CPU @ 3.30GHz
         Voltage: 1.2 V
         External Clock: 100 MHz
         Max Speed: 7000 MHz
         Current Speed: 3700 MHz
         Status: Populated, Enabled
         Upgrade: Other
         L1 Cache Handle: 0x0004
         L2 Cache Handle: 0x0005
         L3 Cache Handle: 0x0006
         Serial Number: Not Specified
         Asset Tag: Fill By OEM
         Part Number: Fill By OEM
         Core Count: 4
         Core Enabled: 1
         Characteristics:
                 64-bit capable

... end

# lspci
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor 
Family DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core 
Processor Family PCI Express Root Port (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core 
Processor Family Integrated Graphics Controller (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series 
Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset 
Family USB Enhanced Host Controller #2 (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 1 (rev b5)
00:1c.6 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 7 (rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset 
Family USB Enhanced Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation Z68 Express Chipset Family LPC 
Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset 
Family SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family 
SMBus Controller (rev 05)
01:00.0 SCSI storage controller: Marvell Technology Group Ltd. 88SX7042 
PCI-e 4-port SATA-II (rev 02)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)

Disks are configured as such:
# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid1 sda1[1] sdb1[0]
       204788 blocks super 1.0 [2/2] [UU]

md2 : active raid6 sdc[5] sde[1] sdf[4] sdd[0]
       3907026688 blocks super 1.2 level 6, 128k chunk, algorithm 2 
[4/4] [UUUU]

md1 : active raid1 sdb2[0] sda2[1]
       77942716 blocks super 1.1 [2/2] [UU]

-- 
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299

