Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab3A1TLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 14:11:48 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:45862 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3A1TLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:11:45 -0500
Message-ID: <5106CD6C.4070009@googlemail.com>
Date: Mon, 28 Jan 2013 19:11:40 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130108 Thunderbird/17.0.2
MIME-Version: 1.0
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
CC: Yijing Wang <wangyijing@huawei.com>,
        Yijing Wang <wangyijing0307@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz> <5105AFDB.9000200@googlemail.com> <5105E51D.2020606@huawei.com> <51064F1A.1020909@googlemail.com> <51065FA6.4070208@googlemail.com> <51066B46.10409@fold.natur.cuni.cz>
In-Reply-To: <51066B46.10409@fold.natur.cuni.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

On 01/28/13 12:12, Martin Mokrejs wrote:
> Chris Clayton wrote:
>>
>> [snip]
>>
>>> [chris:~]$ cat /proc/cmdline
>>> root=/dev/sda5 pciehp_ports=native ro resume=/dev/sda6
>>                       ^^
>>                    **typo**
>> I've run the test again with pcie_ports=native and the directories now get populated. Even better though, is that when I plug in the card, hotplug **works** and the card's drivers are loaded.
>
> BTW, I have with acpiphp on 3.7.4:
>
> ls -la /sys/bus/pci_express/devices
> total 0
> drwxr-xr-x 2 root root 0 Jan 28 13:07 .
> drwxr-xr-x 4 root root 0 Jan 28 13:07 ..
> $ ls -la /sys/bus/pci/devices/slots
                        ^^^^^^^^
                         **typo**
It should be /sys/bus/pci/slots.

> ls: cannot access /sys/bus/pci/devices/slots: No such file or directory
> $
>
With acpiphp, I get /sys/bus/pci_express/devices populated but 
/sys/bus/pci/slots is empty.

> And for me hotplug also works (as far as I can tell). ;-)
>
>>
>> Excellent! Thank you so much for your help (and patience) Martin and Yijing.
>>
>> Now to solving why running scandvb doesn't find any TV channels.
>
> Would be fine if you could re-do the PresDet checks and confirm whether it is also broken
> for you under pciehp.
I've struggled with this a little. For some reason, the expresscard 
doesn't always stay properly inserted in the slot when I insert it. Now 
that hotplug is working, the modules are being loaded and when the card 
pops out again, I get an oops because, of course, the driver is running 
and the card disappears. Perhaps the driver can be made a bit more 
robust to sudden disappearance of the card. I'll report the oops later. 
Anyway, to run these tests I built a kernel without the dvb card's 
drivers, effectively simulating the situation I had before Yijing got 
hotplug working for me. The card popping out may also have affected 
these diffs a bit because, for example, the first one has the CorrErr 
flag changed, possibly because I had to have two or more goes at getting 
the card to lock in the slot. Yesterday that diff showed no changes. 
Anyway, here are the diffs:

diff lspci.after_insertion.txt lspci.after_1st_re-insertion.txt
262c262
<               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
---
 >               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
295c295
< 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 04
---
 > 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 04

============================================================
diff lspci.after_1st_removal.txt lspci.after_2nd_removal.txt

<no difference>

=============================================================
diff lspci.before_insertion.txt lspci.after_1st_removal.txt
112c112
< 60: 20 20 ff 07 00 00 00 00 01 00 00 00 00 00 08 c0
---
 > 60: 20 20 ff 07 00 00 00 00 01 00 00 00 00 00 00 c0
262,263c262,263
<               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
<               LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <16us
---
 >               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
 >               LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <512ns, L1 <16us
265c265
<               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- 
Retrain- CommClk-
---
 >               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
267c267
<               LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
---
 >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt+ ABWMgmt-
273c273
<                       Changed: MRL- PresDet- LinkState-
---
 >                       Changed: MRL- PresDet- LinkState+
295,296c295,296
< 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 4c 12 04
< 50: 03 00 01 10 60 b2 1c 00 28 00 00 00 00 00 00 00
---
 > 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 04
 > 50: 40 00 11 50 60 b2 1c 00 28 00 00 01 00 00 00 00

===========================================================
diff lspci.after_1st_removal.txt lspci.after_2nd_removal.txt

<no difference>

========================================================
diff lspci.before_insertion.txt lspci.after_insertion.txt
112c112
< 60: 20 20 ff 07 00 00 00 00 01 00 00 00 00 00 08 c0
---
 > 60: 20 20 ff 07 00 00 00 00 01 00 00 00 00 00 00 c0
263c263
<               LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <16us
---
 >               LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <512ns, L1 <16us
265c265
<               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- 
Retrain- CommClk-
---
 >               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
267c267
<               LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
---
 >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
272,273c272,273
<               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
<                       Changed: MRL- PresDet- LinkState-
---
 >               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
 >                       Changed: MRL- PresDet- LinkState+
295,296c295,296
< 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 4c 12 04
< 50: 03 00 01 10 60 b2 1c 00 28 00 00 00 00 00 00 00
---
 > 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 04
 > 50: 40 00 11 70 60 b2 1c 00 28 00 40 01 00 00 00 00
538a539,598
 >
 > 02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 
PCI Video and Audio Decoder (rev 02)
 >       Subsystem: Hauppauge computer works Inc. Hauppauge WinTV 
HVR-1400 ExpressCard
 >       Physical Slot: 3
 >       Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
 >       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 >       Interrupt: pin A routed to IRQ 0
 >       Region 0: Memory at f0e00000 (64-bit, non-prefetchable) 
[disabled] [size=2M]
 >       Capabilities: [40] Express (v1) Endpoint, MSI 00
 >               DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
 >                       ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
 >               DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
 >                       RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
 >                       MaxPayload 128 bytes, MaxReadReq 512 bytes
 >               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
 >               LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <2us, L1 <4us
 >                       ClockPM- Surprise- LLActRep- BwNot-
 >               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
 >                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
 >       Capabilities: [80] Power Management version 2
 >               Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
 >               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 >       Capabilities: [90] Vital Product Data
 >               No end tag found
 >       Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
 >               Address: 0000000000000000  Data: 0000
 >       Capabilities: [100 v1] Advanced Error Reporting
 >               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
 >               UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
 >               UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
 >               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
 >               CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
 >               AERCap: First Error Pointer: 00, GenCap- CGenEn- 
ChkCap- ChkEn-
 >       Capabilities: [200 v1] Virtual Channel
 >               Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
 >               Arb:    Fixed+ WRR32+ WRR64+ WRR128-
 >               Ctrl:   ArbSelect=WRR64
 >               Status: InProgress-
 >               Port Arbitration Table [240] <?>
 >               VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
 >                       Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
 >                       Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
 >                       Status: NegoPending- InProgress-
 > 00: f1 14 52 88 00 00 10 00 02 00 00 04 00 00 00 00
 > 10: 04 00 e0 f0 00 00 00 00 00 00 00 00 00 00 00 00
 > 20: 00 00 00 00 00 00 00 00 00 00 00 00 70 00 10 80
 > 30: 00 00 00 00 40 00 00 00 00 00 00 00 00 01 00 00
 > 40: 10 80 01 00 00 00 90 05 10 28 00 00 11 5c 01 00
 > 50: 40 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
 > 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 > 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 > 80: 01 90 22 7e 00 00 00 00 00 00 00 00 00 00 00 00
 > 90: 03 a0 00 80 ff ff ff ff 00 00 00 00 00 00 00 00
 > a0: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
 > b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 > c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 > d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 > e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 > f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

=================================================================
diff lspci.after_1st_removal.txt lspci.after_1st_re-insertion.txt
267c267
<               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt+ ABWMgmt-
---
 >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
272c272
<               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
---
 >               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
296c296
< 50: 40 00 11 50 60 b2 1c 00 28 00 00 01 00 00 00 00
---
 > 50: 40 00 11 70 60 b2 1c 00 28 00 40 01 00 00 00 00
538a539,598
 >
 > 02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 
PCI Video and Audio Decoder (rev 02)
 >       Subsystem: Hauppauge computer works Inc. Hauppauge WinTV 
HVR-1400 ExpressCard
 >       Physical Slot: 3
 >       Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
 >       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 >       Interrupt: pin A routed to IRQ 0
 >       Region 0: Memory at f0e00000 (64-bit, non-prefetchable) 
[disabled] [size=2M]
 >       Capabilities: [40] Express (v1) Endpoint, MSI 00
 >               DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
 >                       ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
 >               DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
 >                       RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
 >                       MaxPayload 128 bytes, MaxReadReq 512 bytes
 >               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
 >               LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <2us, L1 <4us
 >                       ClockPM- Surprise- LLActRep- BwNot-
 >               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
 >                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
 >       Capabilities: [80] Power Management version 2
 >               Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
 >               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 >       Capabilities: [90] Vital Product Data
 >               No end tag found
 >       Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
 >               Address: 0000000000000000  Data: 0000
 >       Capabilities: [100 v1] Advanced Error Reporting
 >               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
 >               UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
 >               UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
 >               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
 >               CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
 >               AERCap: First Error Pointer: 00, GenCap- CGenEn- 
ChkCap- ChkEn-
 >       Capabilities: [200 v1] Virtual Channel
 >               Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
 >               Arb:    Fixed+ WRR32+ WRR64+ WRR128-
 >               Ctrl:   ArbSelect=WRR64
 >               Status: InProgress-
 >               Port Arbitration Table [240] <?>
 >               VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
 >                       Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
 >                       Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
 >                       Status: NegoPending- InProgress-
 > 00: f1 14 52 88 00 00 10 00 02 00 00 04 00 00 00 00
 > 10: 04 00 e0 f0 00 00 00 00 00 00 00 00 00 00 00 00
 > 20: 00 00 00 00 00 00 00 00 00 00 00 00 70 00 10 80
 > 30: 00 00 00 00 40 00 00 00 00 00 00 00 00 01 00 00
 > 40: 10 80 01 00 00 00 90 05 10 28 00 00 11 5c 01 00
 > 50: 40 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
 > 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 > 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 > 80: 01 90 22 7e 00 00 00 00 00 00 00 00 00 00 00 00
 > 90: 03 a0 00 80 ff ff ff ff 00 00 00 00 00 00 00 00
 > a0: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
 > b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 > c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 > d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 > e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 > f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

==========================================================
diff lspci.after_insertion.txt lspci.after_1st_removal.txt
262c262
<               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
---
 >               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
267c267
<               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
---
 >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt+ ABWMgmt-
272c272
<               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
---
 >               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
295,296c295,296
< 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 04
< 50: 40 00 11 70 60 b2 1c 00 28 00 40 01 00 00 00 00
---
 > 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 04
 > 50: 40 00 11 50 60 b2 1c 00 28 00 00 01 00 00 00 00
539,598d538
<
< 02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 
PCI Video and Audio Decoder (rev 02)
<       Subsystem: Hauppauge computer works Inc. Hauppauge WinTV 
HVR-1400 ExpressCard
<       Physical Slot: 3
<       Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
<       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
<       Interrupt: pin A routed to IRQ 0
<       Region 0: Memory at f0e00000 (64-bit, non-prefetchable) 
[disabled] [size=2M]
<       Capabilities: [40] Express (v1) Endpoint, MSI 00
<               DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
<                       ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
<               DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
<                       RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
<                       MaxPayload 128 bytes, MaxReadReq 512 bytes
<               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
<               LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <2us, L1 <4us
<                       ClockPM- Surprise- LLActRep- BwNot-
<               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
<                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
<               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
<       Capabilities: [80] Power Management version 2
<               Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
<               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
<       Capabilities: [90] Vital Product Data
<               No end tag found
<       Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
<               Address: 0000000000000000  Data: 0000
<       Capabilities: [100 v1] Advanced Error Reporting
<               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
<               UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
<               UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
<               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
<               CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
<               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- 
ChkEn-
<       Capabilities: [200 v1] Virtual Channel
<               Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
<               Arb:    Fixed+ WRR32+ WRR64+ WRR128-
<               Ctrl:   ArbSelect=WRR64
<               Status: InProgress-
<               Port Arbitration Table [240] <?>
<               VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
<                       Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
<                       Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
<                       Status: NegoPending- InProgress-
< 00: f1 14 52 88 00 00 10 00 02 00 00 04 00 00 00 00
< 10: 04 00 e0 f0 00 00 00 00 00 00 00 00 00 00 00 00
< 20: 00 00 00 00 00 00 00 00 00 00 00 00 70 00 10 80
< 30: 00 00 00 00 40 00 00 00 00 00 00 00 00 01 00 00
< 40: 10 80 01 00 00 00 90 05 10 28 00 00 11 5c 01 00
< 50: 40 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
< 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
< 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
< 80: 01 90 22 7e 00 00 00 00 00 00 00 00 00 00 00 00
< 90: 03 a0 00 80 ff ff ff ff 00 00 00 00 00 00 00 00
< a0: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
< b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
< c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
< d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
< e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
< f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

================================================================
diff lspci.after_1st_re-insertion.txt lspci.after_2nd_removal.txt
267c267
<               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
---
 >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt+ ABWMgmt-
272c272
<               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
---
 >               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
296c296
< 50: 40 00 11 70 60 b2 1c 00 28 00 40 01 00 00 00 00
---
 > 50: 40 00 11 50 60 b2 1c 00 28 00 00 01 00 00 00 00
539,598d538
<
< 02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 
PCI Video and Audio Decoder (rev 02)
<       Subsystem: Hauppauge computer works Inc. Hauppauge WinTV 
HVR-1400 ExpressCard
<       Physical Slot: 3
<       Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
<       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
<       Interrupt: pin A routed to IRQ 0
<       Region 0: Memory at f0e00000 (64-bit, non-prefetchable) 
[disabled] [size=2M]
<       Capabilities: [40] Express (v1) Endpoint, MSI 00
<               DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
<                       ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
<               DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
<                       RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
<                       MaxPayload 128 bytes, MaxReadReq 512 bytes
<               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
<               LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <2us, L1 <4us
<                       ClockPM- Surprise- LLActRep- BwNot-
<               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
<                       ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
<               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
<       Capabilities: [80] Power Management version 2
<               Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
<               Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
<       Capabilities: [90] Vital Product Data
<               No end tag found
<       Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
<               Address: 0000000000000000  Data: 0000
<       Capabilities: [100 v1] Advanced Error Reporting
<               UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
<               UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
<               UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
<               CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
<               CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
<               AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- 
ChkEn-
<       Capabilities: [200 v1] Virtual Channel
<               Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
<               Arb:    Fixed+ WRR32+ WRR64+ WRR128-
<               Ctrl:   ArbSelect=WRR64
<               Status: InProgress-
<               Port Arbitration Table [240] <?>
<               VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
<                       Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
<                       Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
<                       Status: NegoPending- InProgress-
< 00: f1 14 52 88 00 00 10 00 02 00 00 04 00 00 00 00
< 10: 04 00 e0 f0 00 00 00 00 00 00 00 00 00 00 00 00
< 20: 00 00 00 00 00 00 00 00 00 00 00 00 70 00 10 80
< 30: 00 00 00 00 40 00 00 00 00 00 00 00 00 01 00 00
< 40: 10 80 01 00 00 00 90 05 10 28 00 00 11 5c 01 00
< 50: 40 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
< 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
< 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
< 80: 01 90 22 7e 00 00 00 00 00 00 00 00 00 00 00 00
< 90: 03 a0 00 80 ff ff ff ff 00 00 00 00 00 00 00 00
< a0: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
< b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
< c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
< d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
< e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
< f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00





>
> Martin
>
