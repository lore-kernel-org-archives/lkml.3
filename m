Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaAORin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:38:43 -0500
Received: from static-151-200-251-90.washdc.east.verizon.net ([151.200.251.90]:58546
	"EHLO static-151-200-251-90.washdc.east.verizon.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbaAORi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:38:29 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jan 2014 12:38:28 EST
Message-ID: <52D6C625.50802@metrics.net>
Date: Wed, 15 Jan 2014 12:32:21 -0500
From: Anthony DeRobertis <aderobertis@metrics.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Linux-kernel mailing list <linux-kernel@vger.kernel.org>
CC: iommu@lists.linux-foundation.org
Subject: PROBLEM: do_IRQ: [number] No irq handler for vector (irq -1) [resend]
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I repeatedly get "No irq handler for vector" since upgrading to 3.12. I 
have confirmed it happens in git master as of yesterday morning 
(061f49ec2d722f485237870f04544d8bec15a778). Fixed by disabling VT-d quirk.

[please cc me on responses; I'm not subscribed to the list. Adding 
linux-kernel because the iommu list seems broken.]

DETAILS:

This is on a ASUS Sabertooth X58 board. Ever since upgrading to 3.12, 
I've been flooded with messages like:

Jan  5 19:06:46 Zia kernel: [292039.181501] do_IRQ: 1.76 No irq handler 
for vector (irq -1)
Jan  5 19:08:26 Zia kernel: [292138.390433] do_IRQ: 2.140 No irq handler 
for vector (irq -1)
Jan  5 19:40:16 Zia kernel: [294049.535992] do_IRQ: 1.84 No irq handler 
for vector (irq -1)
Jan  5 23:12:18 Zia kernel: [306774.882154] do_IRQ: 1.227 No irq handler 
for vector (irq -1)

When first booting 3.12, I got the "This system BIOS has enabled 
interrupt remapping on a chipset that contains an erratum making that 
feature unstable.  To maintain system stability interrupt remapping is 
being disabled. Please contact your BIOS vendor for an update" message. 
I believe I also got the do_IRQ messages in that configuration, but am 
not completely sure.

After seeing that, I rebooted the machine and turned off VT-d in the 
BIOS. The warning went away after that. However, the do_IRQ messages are 
definitely present in that configuration.

I have found one configuration that stops them. I turned back on VT-d in 
the BIOS, and then disabled the fix
"iommu/vt-d: add quirk for broken interrupt remapping on 55XX chipsets" 
(03bbcb2e7e292838bb0244f5a7816d194c911d62).

Also, I am running BIOS version 1402 (the latest), released 2012-08-29, 
with the release notes "improve VT-d compatibility issue." The machine 
has been perfectly stable, running pre-3.12 kernels with VT-d enabled 
(though I'm not sure I'm actually really using that feature, as I 
sometimes use KVM, but don't redirect any real hardware to the VMs).

Here is the patch I used to disable the quirk:

diff --git a/drivers/iommu/intel_irq_remapping.c 
b/drivers/iommu/intel_irq_remapping.c
index bab10b1..a5bf817 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -530,10 +530,11 @@ static int __init intel_irq_remapping_supported(void)
                         "on a chipset that contains an erratum making 
that\n"
                         "feature unstable.  To maintain system stability\n"
                         "interrupt remapping is being disabled.  Please\n"
-                       "contact your BIOS vendor for an update\n");
-               add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
+                       "contact your BIOS vendor for an update\n"
+                       "Ignoring and leaving enabled anyway!\n");
+               /* add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
                 disable_irq_remap = 1;
-               return 0;
+               return 0; */
         }
          if (!dmar_ir_support())


SYSTEM INFO:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 26
model name      : Intel(R) Core(TM) i7 CPU         930  @ 2.80GHz
stepping        : 5
microcode       : 0x19
cpu MHz         : 1600.000
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx f
xsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon 
pebs bts rep_good nopl xtopology nonsto
p_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr 
pdcm sse4_1 sse4_2 popcnt lahf_lm ida dth
erm tpr_shadow vnmi flexpriority ept vpid
bogomips        : 5612.59
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

... (repeats through 7)





00:00.0 Host bridge: Intel Corporation 5520/5500/X58 I/O Hub to ESI Port 
(rev 13)
	Subsystem: ASUSTeK Computer Inc. Device 836b
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-SERR-

00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express 
Root Port 1 (rev 13) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort-SERR-TAbort-Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities:
	Kernel driver in use: pcieport

00:02.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express 
Root Port 2 (rev 13) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort-SERR-TAbort-Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities:
	Kernel driver in use: pcieport

00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express 
Root Port 3 (rev 13) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort-SERR-TAbort-Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities:
	Kernel driver in use: pcieport

00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express 
Root Port 7 (rev 13) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort-SERR-TAbort-Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities:
	Kernel driver in use: pcieport

00:14.0 PIC: Intel Corporation 7500/5520/5500/X58 I/O Hub System 
Management Registers (rev 13) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-SERR-
	Kernel driver in use: i7core_edac

00:14.1 PIC: Intel Corporation 7500/5520/5500/X58 I/O Hub GPIO and 
Scratch Pad Registers (rev 13) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-SERR-

00:14.2 PIC: Intel Corporation 7500/5520/5500/X58 I/O Hub Control Status 
and RAS Registers (rev 13) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-SERR-

00:14.3 PIC: Intel Corporation 7500/5520/5500/X58 I/O Hub Throttle 
Registers (rev 13) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort-SERR-TAbort-SERR-
	Kernel driver in use: uhci_hcd

00:1a.1 USB controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #5 (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. P5Q Deluxe Motherboard
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-SERR-
	Kernel driver in use: uhci_hcd

00:1a.2 USB controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #6 (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. P5Q Deluxe Motherboard
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-SERR-
	Kernel driver in use: uhci_hcd

00:1a.7 USB controller: Intel Corporation 82801JI (ICH10 Family) USB2 
EHCI Controller #2 (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. P5Q Deluxe Motherboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-SERR-
	Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio 
Controller
	Subsystem: ASUSTeK Computer Inc. Device 8436
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-SERR-
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Root Port 1 (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort-SERR-TAbort-Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities:
	Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Root Port 5 (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort-SERR-TAbort-Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities:
	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #1 (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. P5Q Deluxe Motherboard
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-SERR-
	Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #2 (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. P5Q Deluxe Motherboard
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-SERR-
	Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #3 (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. P5Q Deluxe Motherboard
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-SERR-
	Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation 82801JI (ICH10 Family) USB2 
EHCI Controller #1 (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. P5Q Deluxe Motherboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-SERR-
	Kernel driver in use: ehci-pci

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90) (prog-if 
01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort-SERR-TAbort-Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities:

00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface 
Controller
	Subsystem: ASUSTeK Computer Inc. P5Q Deluxe Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-SERR-
	Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA 
AHCI Controller (prog-if 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. P5Q Deluxe Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-SERR-
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
	Subsystem: ASUSTeK Computer Inc. P5Q Deluxe Motherboard
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort-SERR-TAbort-SERR-
	Kernel driver in use: ahci

02:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host 
Controller (rev 04) (prog-if 30 [XHCI])
	Subsystem: ASUSTeK Computer Inc. P8P67 Deluxe Motherboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-SERR-
	Kernel driver in use: xhci_hcd

03:00.0 VGA compatible controller: NVIDIA Corporation GF108 [GeForce GT 
440] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 83b7
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-SERR-
	Kernel driver in use: nouveau

03:00.1 Audio device: NVIDIA Corporation GF108 High Definition Audio 
Controller (rev a1)
	Subsystem: ASUSTeK Computer Inc. Device 83b7
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-SERR-
	Kernel driver in use: snd_hda_intel

05:00.0 SATA controller: JMicron Technology Corp. JMB362 SATA Controller 
(rev 10) (prog-if 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. P8P67 Deluxe Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-SERR-
	Kernel driver in use: ahci

07:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8110SC/8169SC Gigabit Ethernet (rev 10)
	Subsystem: ASUSTeK Computer Inc. Device 820d
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-SERR-
	Kernel driver in use: r8169

07:02.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire 
II(M)] IEEE 1394 OHCI Controller (rev c0) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-SERR-
	Kernel driver in use: firewire_ohci

ff:00.0 Host bridge: Intel Corporation Xeon 5500/Core i7 QuickPath 
Architecture Generic Non-Core Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast 
 >TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-TAbort-SERR-





Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
         Vendor: American Megatrends Inc.
         Version: 1402
         Release Date: 08/09/2012
         Address: 0xF0000
         Runtime Size: 64 kB
         ROM Size: 2048 kB
         Characteristics:
                 ISA is supported
                 PCI is supported
                 PNP is supported
                 APM is supported
                 BIOS is upgradeable
                 BIOS shadowing is allowed
                 ESCD support is available
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
                 Targeted content distribution is supported
         BIOS Revision: 8.15

...

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
         Manufacturer: ASUSTeK Computer INC.
         Product Name: SABERTOOTH X58
         Version: Rev 1.xx
         Serial Number: 112835500000084
         Asset Tag: To Be Filled By O.E.M.
         Features:
                 Board is a hosting board
                 Board is replaceable
         Location In Chassis: To Be Filled By O.E.M.
         Chassis Handle: 0x0003
         Type: Motherboard
         Contained Object Handles: 0


