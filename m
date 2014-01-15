Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaAOTgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 14:36:16 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:53344 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaAOTgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 14:36:15 -0500
Date: Wed, 15 Jan 2014 20:36:05 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <126550032.20140115203605@eikelenboom.it>
To: eiichiro.oiwa.nm@hitachi.com, bhelgaas@google.com
CC: airlied@redhat.com, gregkh@linuxfoundation.org, konrad.wilk@oracle.com,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: In "pci_fixup_video" check if this is or should be the primary video devi
In-Reply-To: <XNM1$9$0$4$$3$3$7$A$9006860U52d614ca@hitachi.com>
References: <1389499841-6097-1-git-send-email-linux@eikelenboom.it> <XNM1$9$0$4$$3$3$7$A$9006858U52d4d109@hitachi.com> <6310129377.20140114162641@eikelenboom.it> <XNM1$9$0$4$$3$3$7$A$9006860U52d614ca@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wednesday, January 15, 2014, 5:55:38 AM, you wrote:

> Hi Sander,

> I understood there is no bridge for a VGA device in your virtual machine.
> Your emulator for the bridge control register is odd.
> I guess your virtual machine ignore "PCI-to-PCI Bridge Architecture
> Specification".

All the devices are connected to the root bus and by reading from what i could find that would be a valid setup.
(perhaps not common, but hey we are doing a fixup here for other non common cases).

And i don't understand what is wrong with my patch, earlier in the boot the vga_default_device is already set
by the arch and/or vga arbitration code before the fixup is being run.

In other words ..

If we know the vga boot device .. why not use that information to apply the fixup *only* to that vga boot device ?

And that's just what my patch does ..

+       if (!vga_default_device() || pdev == vga_default_device()) {

If we don't know the vga_default_device ... because we don't have that knowlegde
or
if this is actually the vga_default_device  ... because we do have that knowledge ..

and only then .. run the fixup code and set this device as the vga_default_device


So this change actually makes the code adhere to the comment already above it .. saying it should only be applied to the vga_default_device aka
boot video device.

Also added Bjorn and linux-pci to the CC .. should have done that right away ..
sorry for that.

--
Sander


> Thank you,

> Eiichiro Oiwa

>>
>>Tuesday, January 14, 2014, 6:54:17 AM, you wrote:
>>
>>> Hi Sander,
>>
>>>>It's calling the "pci_fixup_video" quirk ... and it's calling it twice ..
>>>>which if i read the comment correctly .. shouldn't be the case:
>>
>>> I think that there is only one bridge VGA Enable bit is set on normal machine.
>>> I guess two virtual VGA Enable bit are set on your virtual machine.
>>
>>> static void pci_fixup_video(struct pci_dev *pdev)
>>> ...
>>>                          if (!(config & PCI_BRIDGE_CTL_VGA))
>>>                                  return;
>>>                  }
>>> ...
>>
>>> Eiichiro
>>
>>I have added some printk stuff .. and that shows that that code never runs for any of the 2 devices ..
>>since it runs the while loop once but !bridge ...
>>
>>Here is the complete lspci output, 00:03.0 is the emulated device, 00:05.0 the one passedthrough:
>>
>># lspci -vvknn
>>00:00.0 Host bridge [0600]: Intel Corporation 440FX - 82441FX PMC [Natoma] [8086:1237] (rev 02)
>>        Subsystem: Red Hat, Inc Qemu virtual machine [1af4:1100]
>>        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0
>>
>>00:01.0 ISA bridge [0601]: Intel Corporation 82371SB PIIX3 ISA [Natoma/Triton II] [8086:7000]
>>        Subsystem: Red Hat, Inc Qemu virtual machine [1af4:1100]
>>        Physical Slot: 1
>>        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0
>>
>>00:01.1 IDE interface [0101]: Intel Corporation 82371SB PIIX3 IDE [Natoma/Triton II] [8086:7010] (prog-if 80 [Master])
>>        Subsystem: Red Hat, Inc Qemu virtual machine [1af4:1100]
>>        Physical Slot: 1
>>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0
>>        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
>>        Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
>>        Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
>>        Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
>>        Region 4: I/O ports at c260 [size=16]
>>        Kernel driver in use: PIIX_IDE
>>
>>00:01.2 USB controller [0c03]: Intel Corporation 82371SB PIIX3 USB [Natoma/Triton II] [8086:7020] (rev 01) (prog-if 00 [UHCI])
>>        Subsystem: Red Hat, Inc Qemu virtual machine [1af4:1100]
>>        Physical Slot: 1
>>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0
>>        Interrupt: pin D routed to IRQ 23
>>        Region 4: I/O ports at c240 [size=32]
>>        Kernel driver in use: uhci_hcd
>>
>>00:01.3 Bridge [0680]: Intel Corporation 82371AB/EB/MB PIIX4 ACPI [8086:7113] (rev 03)
>>        Subsystem: Red Hat, Inc Qemu virtual machine [1af4:1100]
>>        Physical Slot: 1
>>        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0
>>        Interrupt: pin A routed to IRQ 9
>>
>>00:02.0 Unassigned class [ff80]: XenSource, Inc. Xen Platform Device [5853:0001] (rev 01)
>>        Subsystem: XenSource, Inc. Xen Platform Device [5853:0001]
>>        Physical Slot: 2
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0
>>        Interrupt: pin A routed to IRQ 24
>>        Region 0: I/O ports at c000 [size=256]
>>        Region 1: Memory at f2000000 (32-bit, prefetchable) [size=16M]
>>        Kernel driver in use: xen-platform-pci
>>
>>00:03.0 VGA compatible controller [0300]: Cirrus Logic GD 5446 [1013:00b8] (prog-if 00 [VGA controller])
>>        Subsystem: Red Hat, Inc Device [1af4:1100]
>>        Physical Slot: 3
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0
>>        Region 0: Memory at f0000000 (32-bit, prefetchable) [size=32M]
>>        Region 1: Memory at f30b0000 (32-bit, non-prefetchable) [size=4K]
>>        Expansion ROM at f30a0000 [disabled] [size=64K]
>>
>>00:05.0 VGA compatible controller [0300]: Advanced Micro Devices [AMD] nee ATI Turks [Radeon HD 6570] [1002:6759] (prog-if 00 [VGA controller])
>>        Subsystem: PC Partner Limited Device [174b:e193]
>>        Physical Slot: 5
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0
>>        Interrupt: pin A routed to IRQ 81
>>        Region 0: Memory at e0000000 (64-bit, prefetchable) [size=256M]
>>        Region 2: Memory at f3060000 (64-bit, non-prefetchable) [size=128K]
>>        Region 4: I/O ports at c100 [size=256]
>>        Expansion ROM at f3080000 [disabled] [size=128K]
>>        Capabilities: [50] Power Management version 3
>>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>        Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
>>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
>>                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>>                DevSta: CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
>>                LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
>>                        ClockPM- Surprise- LLActRep- BwNot-
>>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
>>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>                DevCap2: Completion Timeout: Not Supported, TimeoutDis-
>>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
>>                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>>                         Compliance De-emphasis: -6dB
>>                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
>>                         EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
>>        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>                Address: 00000000fee57000  Data: 4300
>>        Capabilities: [100 v9] #1002
>>        Kernel driver in use: radeon
>>
>>>>Hi Eiichiro / Dave / Greg,
>>>>
>>>>While trying to get secondary PCI/VGA passthrough of a AMD 6570 card to a Xen guest with the radeon driver and modesetting
>>>>i'm running into the problem that the driver says the BIOS is a COMBIOS while it expects a ATOMBIOS for the cards.
>>>>
>>>>So the Guest uses both it's normal emulated VGA card provided by Qemu (f.e. cirrus logic) and a real VGA card via
>>>>PCI passthrough.
>>>>
>>>>While debugging it turned out that the bios that the driver read was not the AMD bios, but the bios from the emulated card.
>>>>(so it wasn't a COMBIOS either ..)
>>>>
>>>>I first thought the culprit was with Xen, Seabios or Qemu ..
>>>>So it took quite a while and debugging, but finally my eye fell on this in the guest dmesg:
>>>>
>>>>[    2.545728] pci 0000:00:00.0: calling quirk_natoma+0x0/0x40
>>>>[    2.545730] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
>>>>[    2.558998] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x90
>>>>[    2.559121] pci 0000:00:01.0: PIIX3: Enabling Passive Release
>>>>[    2.572412] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x40
>>>>[    2.572415] pci 0000:00:01.0: Activating ISA DMA hang workarounds
>>>>[    2.586527] pci 0000:00:03.0: calling pci_fixup_video+0x0/0xd0
>>>>[    2.586609] pci 0000:00:03.0: Boot video device
>>>>[    2.586696] pci 0000:00:05.0: calling pci_fixup_video+0x0/0xd0
>>>>[    2.586827] pci 0000:00:05.0: Boot video device
>>>>[    2.586928] pci 0000:00:06.0: calling quirk_e100_interrupt+0x0/0x1c0
>>>>
>>>>It's calling the "pci_fixup_video" quirk ... and it's calling it twice ..
>>>>which if i read the comment correctly .. shouldn't be the case:
>>>>
>>>> /*
>>>> * Fixup to mark boot BIOS video selected by BIOS before it changes
>>>> *
>>>> * From information provided by "Jon Smirl" <jonsmirl@gmail.com>
>>>> *
>>>> * The standard boot ROM sequence for an x86 machine uses the BIOS
>>>> * to select an initial video card for boot display. This boot video
>>>> * card will have it's BIOS copied to C0000 in system RAM.
>>>> * IORESOURCE_ROM_SHADOW is used to associate the boot video
>>>> * card with this copy. On laptops this copy has to be used since
>>>> * the main ROM may be compressed or combined with another image.
>>>> * See pci_map_rom() for use of this flag. IORESOURCE_ROM_SHADOW
>>>> * is marked here since the boot video device will be the only enabled
>>>> * video device at this point.
>>>> */
>>>>
>>>>
>>>>But the code doesn't check if it's actually the only enabled (or first) video device at that point ..
>>>>and it's setting 2 boot video devices and setting both to use the IORESOURCE_ROM_SHADOW at C000 ..
>>>>which happens to be the bios from the emulated card.
>>>>
>>>>With this patch applied the passthrough of the card works fine in the guest and dmesg reports:
>>>>
>>>>[    2.167076] pci 0000:00:00.0: calling quirk_natoma+0x0/0x40
>>>>[    2.167078] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
>>>>[    2.179807] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x90
>>>>[    2.179953] pci 0000:00:01.0: PIIX3: Enabling Passive Release
>>>>[    2.192953] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x40
>>>>[    2.192955] pci 0000:00:01.0: Activating ISA DMA hang workarounds
>>>>[    2.206543] pci 0000:00:03.0: calling pci_fixup_video+0x0/0xe0
>>>>[    2.206623] pci 0000:00:03.0: Boot video device
>>>>[    2.206710] pci 0000:00:05.0: calling pci_fixup_video+0x0/0xe0
>>>>[    2.206842] pci 0000:00:06.0: calling quirk_e100_interrupt+0x0/0x1c0
>>>>
>>>>--
>>>>Sander
>>>>
>>>>Sander Eikelenboom (1):
>>>>  In "pci_fixup_video" check if this is or should be the primary video
>>>>    device to prevent setting the IORESOURCE_ROM_SHADOW flag on a
>>>>    secondary VGA card
>>>>
>>>> arch/x86/pci/fixup.c |   17 +++++++++--------
>>>> 1 file changed, 9 insertions(+), 8 deletions(-)
>>>>
>>>>-- 
>>>>1.7.10.4
>>>>
>>>>
>>
>>
>>


