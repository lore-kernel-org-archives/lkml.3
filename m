Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3C2PIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 11:08:17 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:36685 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754766Ab3C2PIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:08:16 -0400
Message-ID: <5155ADD2.3090005@fold.natur.cuni.cz>
Date: Fri, 29 Mar 2013 16:05:54 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [Update][PATCH] PCI / ACPI: Always resume devices on ACPI wakeup
 notifications
References: <2282655.IicBMMa6jN@vostro.rjw.lan> <1396732.fV788D0xgr@vostro.rjw.lan> <2699206.HmPyNvCpNR@vostro.rjw.lan>
In-Reply-To: <2699206.HmPyNvCpNR@vostro.rjw.lan>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I applied this patches over 3.8.3 hoping it will fix my issue under
thread: "Re: 3.8.2: xhci port is dead until pcieport PME# goes to disabled"
but unfortunately, it is even worse! Now, although lsusb -v nor lsusb -vv do
wakeup the XHCI port but it falls asleep immediately, more quickly than I am
able to plug a device into the socket. To get a device working in the USB3 socket
I need to plug it in, run lsusb -vv and then it is recognized.

Without the patch, the 'lsusb -vv' woke up the port (PME# disabled happened
on both 1c.4 and 0b:00.0) and I had unlimited time to find some USB device
around and to plug it into the slot.


  I noticed this message some while after a bootup (no external USB devices were
connected to the laptop, neither into USB2 socket nor into USB3.0 sockets) before
I started to do the tests:

[   36.594171] xhci_hcd 0000:0b:00.0: xhci_suspend: stopping port polling.
[   36.594202] xhci_hcd 0000:0b:00.0: // Setting command ring address to 0xd6007001
[   36.594247] xhci_hcd 0000:0b:00.0: hcd_pci_runtime_suspend: 0
[   36.594349] xhci_hcd 0000:0b:00.0: PME# enabled
[   36.703695] r8169 0000:05:00.0 eth0: link down
[   37.098299] microcode: CPU0 updated to revision 0x28, date = 2012-04-24
[   37.098941] microcode: CPU1 updated to revision 0x28, date = 2012-04-24
[   37.098944] perf_event_intel: PEBS enabled due to microcode update
[   38.343029] r8169 0000:05:00.0 eth0: link up
[   39.094944] r8169 0000:05:00.0 eth0: link down
[   41.492768] r8169 0000:05:00.0 eth0: link up
[   62.782910] xhci_hcd 0000:0b:00.0: Poll event ring: 4294943584
[   62.782938] xhci_hcd 0000:0b:00.0: op reg status = 0xffffffff
[   62.782939] xhci_hcd 0000:0b:00.0: HW died, polling stopped.
[   88.754183] pcieport 0000:00:1c.0: PME# enabled
[   88.764182] xhci_hcd 0000:0b:00.0: PME# disabled
[   88.764192] xhci_hcd 0000:0b:00.0: enabling bus mastering
[   88.764206] xhci_hcd 0000:0b:00.0: // Setting command ring address to 0xd6007001
[   88.764242] xhci_hcd 0000:0b:00.0: Port Status Change Event for port 2
[   88.764246] xhci_hcd 0000:0b:00.0: resume root hub
[   88.764259] xhci_hcd 0000:0b:00.0: handle_port_status: starting port polling.
[   88.764276] xhci_hcd 0000:0b:00.0: xhci_resume: starting port polling.
[   88.764281] xhci_hcd 0000:0b:00.0: hcd_pci_runtime_resume: 0


What "HW died? Why 1c.0 is here? What is this device actually doing?

00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=03, subordinate=04, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
                        Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not Supported ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: Dell Device 04b3
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D3 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport





Nevertheless, I went to check if if the USB3 socket dies after first unplug of device
or not anymore thanks to the patch being tested:

I plugged into the USB3.0 socket a mouse, it worked. Around its unplug I got:

[   94.954779] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
[   94.954795] hub 3-0:1.0: hub_suspend
[   94.954802] usb usb3: bus auto-suspend, wakeup 1
[   94.954817] xhci_hcd 0000:0b:00.0: xhci_hub_status_data: stopping port polling.
[   94.954835] xhci_hcd 0000:0b:00.0: xhci_suspend: stopping port polling.
[   94.954857] xhci_hcd 0000:0b:00.0: // Setting command ring address to 0xd6007001
[   94.954898] xhci_hcd 0000:0b:00.0: hcd_pci_runtime_suspend: 0
[   94.954983] xhci_hcd 0000:0b:00.0: PME# enabled
[  169.622513] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0004
[  169.623057] hub 2-1:1.0: port 2, status 0101, change 0001, 12 Mb/s
[  169.777012] hub 2-1:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[  169.856992] usb 2-1.2: new low-speed USB device number 4 using ehci-pci

and the port was dead, no matter what "lsusb -v or -vv" options I tried. At about
[  169.622513] I plugged the mouse into a USB2.0 socket (do not know if that is 1a.0 or 1d.0).

# lspci -tv
-[0000:00]-+-00.0  Intel Corporation 2nd Generation Core Processor Family DRAM Controller
           +-02.0  Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller
           +-16.0  Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1
           +-1a.0  Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2
           +-1b.0  Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller
           +-1c.0-[03-04]--
           +-1c.1-[05-06]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168 PCI Express Gigabit Ethernet controller
           +-1c.3-[09-0a]----00.0  Intel Corporation Centrino Wireless-N 1030 [Rainbow Peak]
           +-1c.4-[0b-0c]----00.0  Texas Instruments TUSB73x0 SuperSpeed USB 3.0 xHCI Host Controller
           +-1c.7-[11-16]----00.0  Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller
           +-1d.0  Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1
           +-1f.0  Intel Corporation HM67 Express Chipset Family LPC Controller
           +-1f.2  Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller
           \-1f.3  Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller
#


 Why isn't the PME# enabled/disabled reported for the USB2.0 port of the
same laptop? There I can plugin a device many times in and out and not a single PME# line is
spitted by dmesg.
# grep . /sys/bus/pci/devices/*/power/control
/sys/bus/pci/devices/0000:00:00.0/power/control:auto
/sys/bus/pci/devices/0000:00:02.0/power/control:auto
/sys/bus/pci/devices/0000:00:16.0/power/control:auto
/sys/bus/pci/devices/0000:00:1a.0/power/control:auto
/sys/bus/pci/devices/0000:00:1b.0/power/control:auto
/sys/bus/pci/devices/0000:00:1c.0/power/control:auto
/sys/bus/pci/devices/0000:00:1c.1/power/control:auto
/sys/bus/pci/devices/0000:00:1c.3/power/control:auto
/sys/bus/pci/devices/0000:00:1c.4/power/control:auto
/sys/bus/pci/devices/0000:00:1c.7/power/control:auto
/sys/bus/pci/devices/0000:00:1d.0/power/control:auto
/sys/bus/pci/devices/0000:00:1f.0/power/control:auto
/sys/bus/pci/devices/0000:00:1f.2/power/control:auto
/sys/bus/pci/devices/0000:00:1f.3/power/control:auto
/sys/bus/pci/devices/0000:05:00.0/power/control:auto
/sys/bus/pci/devices/0000:09:00.0/power/control:auto
/sys/bus/pci/devices/0000:0b:00.0/power/control:auto
/sys/bus/pci/devices/0000:11:00.0/power/control:auto
# grep . /sys/bus/pci/devices/*/power/runtime_status
/sys/bus/pci/devices/0000:00:00.0/power/runtime_status:suspended
/sys/bus/pci/devices/0000:00:02.0/power/runtime_status:active
/sys/bus/pci/devices/0000:00:16.0/power/runtime_status:suspended
/sys/bus/pci/devices/0000:00:1a.0/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1b.0/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1c.0/power/runtime_status:suspended
/sys/bus/pci/devices/0000:00:1c.1/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1c.3/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1c.4/power/runtime_status:suspended
/sys/bus/pci/devices/0000:00:1c.7/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1d.0/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1f.0/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1f.2/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1f.3/power/runtime_status:suspended
/sys/bus/pci/devices/0000:05:00.0/power/runtime_status:active
/sys/bus/pci/devices/0000:09:00.0/power/runtime_status:active
/sys/bus/pci/devices/0000:0b:00.0/power/runtime_status:suspended
/sys/bus/pci/devices/0000:11:00.0/power/runtime_status:active
#

If I run lsusb -vv it does (with the problematic patch):

[ 1760.414086] pcieport 0000:00:1c.4: PME# disabled
[ 1760.434314] xhci_hcd 0000:0b:00.0: PME# disabled
[ 1760.434327] xhci_hcd 0000:0b:00.0: enabling bus mastering
[ 1760.434338] xhci_hcd 0000:0b:00.0: // Setting command ring address to 0xd6007001
[ 1760.434360] xhci_hcd 0000:0b:00.0: Port Status Change Event for port 2
[ 1760.434363] xhci_hcd 0000:0b:00.0: resume root hub
[ 1760.434367] xhci_hcd 0000:0b:00.0: handle_port_status: starting port polling.
[ 1760.434378] xhci_hcd 0000:0b:00.0: xhci_resume: starting port polling.
[ 1760.434383] xhci_hcd 0000:0b:00.0: hcd_pci_runtime_resume: 0
[ 1760.434388] usb usb3: usb auto-resume
[ 1760.434407] hub 3-0:1.0: hub_resume
[ 1760.434439] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
[ 1760.434440] xhci_hcd 0000:0b:00.0: Get port status returned 0x100
[ 1760.434464] xhci_hcd 0000:0b:00.0: get port status, actual port 1 status  = 0x202a0
[ 1760.434465] xhci_hcd 0000:0b:00.0: Get port status returned 0x10100
[ 1760.434492] xhci_hcd 0000:0b:00.0: clear port connect change, actual port 1 status  = 0x2a0
[ 1760.434642] usb usb4: usb wakeup-resume
[ 1760.434646] usb usb4: usb auto-resume
[ 1760.434661] hub 4-0:1.0: hub_resume
[ 1760.434683] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
[ 1760.434684] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
[ 1760.434710] xhci_hcd 0000:0b:00.0: get port status, actual port 1 status  = 0x2a0
[ 1760.434711] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
[ 1760.434727] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[ 1760.434757] xhci_hcd 0000:0b:00.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
[ 1760.434784] xhci_hcd 0000:0b:00.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
[ 1760.434791] hub 4-0:1.0: hub_suspend
[ 1760.434796] usb usb4: bus auto-suspend, wakeup 1
[ 1760.434807] xhci_hcd 0000:0b:00.0: xhci_hub_status_data: stopping port polling.
[ 1760.553734] xhci_hcd 0000:0b:00.0: xhci_hub_status_data: stopping port polling.
[ 1760.553751] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[ 1760.574793] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
[ 1760.574794] xhci_hcd 0000:0b:00.0: Get port status returned 0x100
[ 1760.575300] xhci_hcd 0000:0b:00.0: get port status, actual port 1 status  = 0x2a0
[ 1760.575301] xhci_hcd 0000:0b:00.0: Get port status returned 0x100
[ 1760.576768] hub 3-0:1.0: hub_suspend
[ 1760.576774] usb usb3: bus auto-suspend, wakeup 1
[ 1760.576789] xhci_hcd 0000:0b:00.0: xhci_hub_status_data: stopping port polling.
[ 1760.576802] xhci_hcd 0000:0b:00.0: xhci_suspend: stopping port polling.
[ 1760.576817] xhci_hcd 0000:0b:00.0: // Setting command ring address to 0xd6007001
[ 1760.576851] xhci_hcd 0000:0b:00.0: hcd_pci_runtime_suspend: 0
[ 1760.576938] xhci_hcd 0000:0b:00.0: PME# enabled
[ 1760.613874] xhci_hcd 0000:0b:00.0: PME# disabled
[ 1760.613884] xhci_hcd 0000:0b:00.0: enabling bus mastering
[ 1760.613895] xhci_hcd 0000:0b:00.0: // Setting command ring address to 0xd6007001
[ 1760.613914] xhci_hcd 0000:0b:00.0: xhci_resume: starting port polling.
[ 1760.613922] xhci_hcd 0000:0b:00.0: xhci_hub_status_data: stopping port polling.
[ 1760.613924] xhci_hcd 0000:0b:00.0: hcd_pci_runtime_resume: 0
[ 1760.613929] usb usb4: usb auto-resume
[ 1760.613945] hub 4-0:1.0: hub_resume
[ 1760.613981] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
[ 1760.613982] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
[ 1760.614010] xhci_hcd 0000:0b:00.0: get port status, actual port 1 status  = 0x2a0
[ 1760.614012] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
[ 1760.614038] usb usb3: usb wakeup-resume
[ 1760.614040] usb usb3: usb auto-resume
[ 1760.614059] hub 3-0:1.0: hub_resume
[ 1760.614080] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
[ 1760.614081] xhci_hcd 0000:0b:00.0: Get port status returned 0x100
[ 1760.614104] xhci_hcd 0000:0b:00.0: get port status, actual port 1 status  = 0x2a0
[ 1760.614105] xhci_hcd 0000:0b:00.0: Get port status returned 0x100
[ 1760.614122] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[ 1760.614126] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[ 1760.614134] hub 3-0:1.0: hub_suspend
[ 1760.614139] usb usb3: bus auto-suspend, wakeup 1
[ 1760.614152] xhci_hcd 0000:0b:00.0: xhci_hub_status_data: stopping port polling.
[ 1760.623621] xhci_hcd 0000:0b:00.0: xhci_hub_status_data: stopping port polling.
[ 1760.646744] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
[ 1760.646746] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
[ 1760.647281] xhci_hcd 0000:0b:00.0: get port status, actual port 1 status  = 0x2a0
[ 1760.647283] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
[ 1760.657965] xhci_hcd 0000:0b:00.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
[ 1760.657992] xhci_hcd 0000:0b:00.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
[ 1760.658000] hub 4-0:1.0: hub_suspend
[ 1760.658004] usb usb4: bus auto-suspend, wakeup 1
[ 1760.658015] xhci_hcd 0000:0b:00.0: xhci_hub_status_data: stopping port polling.
[ 1760.658027] xhci_hcd 0000:0b:00.0: xhci_suspend: stopping port polling.
[ 1760.658042] xhci_hcd 0000:0b:00.0: // Setting command ring address to 0xd6007001
[ 1760.658074] xhci_hcd 0000:0b:00.0: hcd_pci_runtime_suspend: 0
[ 1760.658159] xhci_hcd 0000:0b:00.0: PME# enabled
[ 1760.683743] pcieport 0000:00:1c.4: PME# enabled



Hope this helps,
Martin




Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: PCI / ACPI: Always resume devices on ACPI wakeup notifications
> 
> It turns out that the _Lxx control methods provided by some BIOSes
> clear the PME Status bit of PCI devices they handle, which means that
> pci_acpi_wake_dev() cannot really use that bit to check whether or
> not the device has signalled wakeup.
> 
> One symptom of the problem is, for example, that when an affected PCI
> USB controller is runtime-suspended, then plugging in a new USB device
> into one of the controller's ports will not wake up the controller,
> which should happen.
> 
> For this reason, make pci_acpi_wake_dev() always attempt to resume
> the device it is called for regardless of the device's PME Status bit
> value (that bit still has to be cleared if set at this point,
> though).
> 
> Reported-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Acked-by: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: 3.7+ <stable@vger.kernel.org>
> ---
> 
> The changelog in this version is slightly better than in the previous one, IMHO.
> 
> Thanks,
> Rafael
> 
> ---
>  drivers/pci/pci-acpi.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> Index: linux-pm/drivers/pci/pci-acpi.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/pci-acpi.c
> +++ linux-pm/drivers/pci/pci-acpi.c
> @@ -53,14 +53,15 @@ static void pci_acpi_wake_dev(acpi_handl
>  		return;
>  	}
>  
> -	if (!pci_dev->pm_cap || !pci_dev->pme_support
> -	     || pci_check_pme_status(pci_dev)) {
> -		if (pci_dev->pme_poll)
> -			pci_dev->pme_poll = false;
> +	/* Clear PME Status if set. */
> +	if (pci_dev->pme_support)
> +		pci_check_pme_status(pci_dev);
>  
> -		pci_wakeup_event(pci_dev);
> -		pm_runtime_resume(&pci_dev->dev);
> -	}
> +	if (pci_dev->pme_poll)
> +		pci_dev->pme_poll = false;
> +
> +	pci_wakeup_event(pci_dev);
> +	pm_runtime_resume(&pci_dev->dev);
>  
>  	if (pci_dev->subordinate)
>  		pci_pme_wakeup_bus(pci_dev->subordinate);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
