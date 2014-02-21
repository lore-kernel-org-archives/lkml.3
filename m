Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaBUL1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 06:27:54 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40618 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbaBUL1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 06:27:50 -0500
Date: Fri, 21 Feb 2014 19:27:45 +0800
From: majianpeng <majianpeng@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Cc: tglx <tglx@linutronix.de>, mingo <mingo@redhat.com>, hpa <hpa@zytor.com>,
        bhelgaas <bhelgaas@google.com>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [BUG] Plug vga cable induce usb irq disabled.
X-Priority: 3
X-GUID: 310B97C6-3404-42D4-AD02-60CA58DA2753
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201402211927414183846@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1LBS3xb029626

Hi all:
	I met a problem. When i plug vga cable(only need once), the kernel print those messages and disable IRQ 16.

[   16.907826] irq 16: nobody cared (try booting with the "irqpoll" option)
[   16.907834] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc3+ #74
[   16.907836] Hardware name: To be filled by O.E.M. NVR2821/NVR2821, BIOS 1.00 11/06/2013
[   16.907838]  ffff880079429384 ffff880100203e18 ffffffff81547dae 00000000000400f6
[   16.907842]  ffff880079429300 ffff880100203e48 ffffffff8107c3ec 000000000000000b
[   16.907845]  ffff880079429300 0000000000000000 0000000000000010 ffff880100203e88
[   16.907848] Call Trace:
[   16.907850]  <IRQ>  [<ffffffff81547dae>] dump_stack+0x46/0x58
[   16.907860]  [<ffffffff8107c3ec>] __report_bad_irq+0x24/0xc7
[   16.907863]  [<ffffffff8107c7bd>] note_interrupt+0x164/0x1ef
[   16.907868]  [<ffffffff8107aa7f>] handle_irq_event_percpu+0x163/0x1a7
[   16.907872]  [<ffffffff8107aaf6>] handle_irq_event+0x33/0x51
[   16.907874]  [<ffffffff8107d0c4>] handle_fasteoi_irq+0x77/0xac
[   16.907878]  [<ffffffff81004048>] handle_irq+0x120/0x130
[   16.907882]  [<ffffffff81550905>] ? __atomic_notifier_call_chain+0xd/0xf
[   16.907885]  [<ffffffff81550916>] ? atomic_notifier_call_chain+0xf/0x11
[   16.907888]  [<ffffffff81003a1c>] do_IRQ+0x4b/0xc2
[   16.907891]  [<ffffffff8154da2a>] common_interrupt+0x6a/0x6a
[   16.907892]  <EOI>  [<ffffffff8136c25a>] ? cpuidle_enter_state+0x49/0xac
[   16.907900]  [<ffffffff8136c253>] ? cpuidle_enter_state+0x42/0xac
[   16.907904]  [<ffffffff8136c399>] cpuidle_idle_call+0xdc/0x14b
[   16.907909]  [<ffffffff81009cd0>] arch_cpu_idle+0x9/0x18
[   16.907912]  [<ffffffff8107a1d1>] cpu_startup_entry+0xdb/0x15e
[   16.907916]  [<ffffffff81540a8e>] rest_init+0x72/0x74
[   16.907921]  [<ffffffff81accd11>] start_kernel+0x3a0/0x3ad
[   16.907924]  [<ffffffff81acc779>] ? repair_env_string+0x5a/0x5a
[   16.907927]  [<ffffffff81acc481>] x86_64_start_reservations+0x2a/0x2c
[   16.907930]  [<ffffffff81acc57d>] x86_64_start_kernel+0xfa/0xfe
[   16.907931] handlers:
[   16.907942] [<ffffffffa005b0a7>] usb_hcd_irq [usbcore]
[   16.907944] Disabling IRQ #16

I found if the system has i915 driver, this bug can't occur.
I did some tests:
A:Not using IO-APIC rather than 8259A, the bug still occur(no i915 driver)
B:If i disable irq of vga controller(PCI 00:02.0) using the config file of sysfs.The bug can't occur.
C:Remove usb driver and enable IRQ 16 for io-apic, the bug still occur(because if no usb-drives,the do_IRQ will mask-irq,so i only to modify this).
D:From the datasheet of PCH, i know the PIRQA-H are connect to IRQ16-IRQ23.But from lspci,we can see the irq line of vga controlle is 11.Why?


I don't this bug is hardware or software bug?
The following messages are the machine infos:

root@debian:~# uname -a
Linux debian 3.14.0-rc3+ #74 SMP Fri Feb 21 19:16:55 CST 2014 x86_64 GNU/Linux

root@debian:~/linux# cat /proc/cpuinfo 
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Celeron(R) CPU 1037U @ 1.80GHz
stepping	: 9
microcode	: 0x17
cpu MHz		: 1800.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer xsave lahf_lm arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips	: 3591.83
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Celeron(R) CPU 1037U @ 1.80GHz
stepping	: 9
microcode	: 0x17
cpu MHz		: 1800.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer xsave lahf_lm arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips	: 3591.83
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

root@debian:~# cat /proc/interrupts 
           CPU0       CPU1       
  0:         17          0   IO-APIC-edge      timer
  1:          0          2   IO-APIC-edge      i8042
  8:          1          0   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          2          1   IO-APIC-edge      i8042
 16:      99982         19   IO-APIC-fasteoi   ehci_hcd:usb1
 23:         16         10   IO-APIC-fasteoi   ehci_hcd:usb2
 40:       5982       1901   PCI-MSI-edge      ahci
 41:          0          0   PCI-MSI-edge      ahci
 42:        456         10   PCI-MSI-edge      snd_hda_intel
 43:          0          0   PCI-MSI-edge      eth0
 44:          1         85   PCI-MSI-edge      eth0-rx-0
 45:          1         85   PCI-MSI-edge      eth0-rx-1
 46:          1         85   PCI-MSI-edge      eth0-tx-0
 47:          1         85   PCI-MSI-edge      eth0-tx-1
 48:          1          0   PCI-MSI-edge      eth1
 49:       2291         26   PCI-MSI-edge      eth1-rx-0
 50:         87          0   PCI-MSI-edge      eth1-rx-1
 51:         92          0   PCI-MSI-edge      eth1-tx-0
 52:        271         20   PCI-MSI-edge      eth1-tx-1
NMI:          0          0   Non-maskable interrupts
LOC:       6434       4700   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
IWI:        286        208   IRQ work interrupts
RTR:          0          0   APIC ICR read retries
RES:       2724       2949   Rescheduling interrupts
CAL:         14         34   Function call interrupts
TLB:        471        446   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:          2          2   Machine check polls
ERR:          0
MIS:          0

root@debian:~# lspci -v
00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
	Subsystem: Intel Corporation 3rd Gen Core processor DRAM Controller
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])
	Subsystem: Intel Corporation Device 2010
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at f7400000 (64-bit, non-prefetchable) [size=4M]
	Memory at e0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at f000 [size=64]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Power Management version 2
	Capabilities: [a4] PCI Advanced Features

00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
	Subsystem: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at f7c0a000 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
	Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+

00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])
	Subsystem: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2
	Flags: bus master, medium devsel, latency 0, IRQ 16
	Memory at f7c08000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
	Subsystem: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller
	Flags: bus master, fast devsel, latency 0, IRQ 42
	Memory at f7c00000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Root Complex Link
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: f7b00000-f7bfffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1
	Capabilities: [a0] Power Management version 2
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 (rev c4) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: f7a00000-f7afffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2
	Capabilities: [a0] Power Management version 2
	Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 (rev c4) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: f7900000-f79fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3
	Capabilities: [a0] Power Management version 2
	Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 4 (rev c4) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: f7800000-f78fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 4
	Capabilities: [a0] Power Management version 2
	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])
	Subsystem: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at f7c07000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci-pci

00:1f.0 ISA bridge: Intel Corporation 7 Series Chipset Family LPC Controller (rev 04)
	Subsystem: Intel Corporation 7 Series Chipset Family LPC Controller
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
	Subsystem: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode]
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 40
	I/O ports at f0b0 [size=8]
	I/O ports at f0a0 [size=4]
	I/O ports at f090 [size=8]
	I/O ports at f080 [size=4]
	I/O ports at f060 [size=32]
	Memory at f7c06000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [70] Power Management version 3
	Capabilities: [a8] SATA HBA v1.0
	Capabilities: [b0] PCI Advanced Features
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
	Subsystem: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller
	Flags: medium devsel, IRQ 18
	Memory at f7c05000 (64-bit, non-prefetchable) [size=256]
	I/O ports at f040 [size=32]

01:00.0 Ethernet controller: Intel Corporation I211 Gigabit Network Connection (rev 03)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at f7b00000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at e000 [size=32]
	Memory at f7b20000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
	Capabilities: [70] MSI-X: Enable+ Count=5 Masked-
	Capabilities: [a0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number 00-30-64-ff-ff-26-dc-f8
	Capabilities: [1a0] Transaction Processing Hints
	Kernel driver in use: igb

02:00.0 Ethernet controller: Intel Corporation I211 Gigabit Network Connection (rev 03)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at f7a00000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at d000 [size=32]
	Memory at f7a20000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
	Capabilities: [70] MSI-X: Enable+ Count=5 Masked-
	Capabilities: [a0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number 00-30-64-ff-ff-26-dc-f9
	Capabilities: [1a0] Transaction Processing Hints
	Kernel driver in use: igb

03:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
	Subsystem: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller
	Flags: bus master, fast devsel, latency 0, IRQ 10
	Memory at f7984000 (64-bit, non-prefetchable) [size=128]
	Memory at f7980000 (64-bit, non-prefetchable) [size=16K]
	I/O ports at c000 [size=128]
	Expansion ROM at f7900000 [disabled] [size=512K]
	Capabilities: [54] Power Management version 2
	Capabilities: [5c] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Legacy Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting

04:00.0 SATA controller: Marvell Technology Group Ltd. Device 9215 (rev 10) (prog-if 01 [AHCI 1.0])
	Subsystem: Marvell Technology Group Ltd. Device 9215
	Flags: bus master, fast devsel, latency 0, IRQ 41
	I/O ports at b050 [size=8]
	I/O ports at b040 [size=4]
	I/O ports at b030 [size=8]
	I/O ports at b020 [size=4]
	I/O ports at b000 [size=32]
	Memory at f7810000 (32-bit, non-prefetchable) [size=2K]
	Expansion ROM at f7800000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [70] Express Legacy Endpoint, MSI 00
	Capabilities: [e0] SATA HBA v0.0
	Capabilities: [100] Advanced Error Reporting
	Kernel driver in use: ahci



Thanks!
Jianpeng Ma
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
