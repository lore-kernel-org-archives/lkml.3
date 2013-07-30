Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab3G3Dma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:42:30 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:39883 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab3G3Dm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:42:28 -0400
MIME-Version: 1.0
In-Reply-To: <51F73108.4070905@huawei.com>
References: <1360036520-31032-1-git-send-email-wangyijing@huawei.com>
 <51A42137.9090908@huawei.com> <CAErSpo7iyiq6H-BsPNO0Nyc1SF+JteOzBqNQ+d_D=RYE_pdTEA@mail.gmail.com>
 <51F73108.4070905@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 29 Jul 2013 21:42:07 -0600
Message-ID: <CAErSpo4mHTwqrW-yq_1BkjD0GyFtVYZRm9+eGfASJ_aJCOagjg@mail.gmail.com>
Subject: Re: [PATCH] PCI: update device mps when doing pci hotplug
To: Yijing Wang <wangyijing@huawei.com>
Cc: Jon Mason <jdmason@kudzu.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing0307@gmail.com>,
        Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Joe Jin <joe.jin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 9:20 PM, Yijing Wang <wangyijing@huawei.com> wrote:
> On 2013/7/30 7:33, Bjorn Helgaas wrote:
>> On Mon, May 27, 2013 at 9:15 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>>> Hi Bjorn and Jon,
>>>    I'm sorry to disturb you. This patch is sent so long, but nobody seems had comment about it.
>>> Do you have any comment with this patch?
>>>
>>> This patch try to update device mps in following case:
>>> 1) target device under root port
>>>    Because root port can split TLP, so target device mps greatr than root port mps is ok.
>>>    But if root port mps greater than target device mps, it's bad, because target device cannot
>>>    receive TLP payload size greater than its MPS. So if a target device under a root port, I think
>>>    we should assign its mps greater than or equal root port mps.
>>> 2) target device under non root port
>>>    We assume the target device both is a transmitter and receiver, so the safest way is to assign target
>>>    device mps equal to its parent device.
>>
>> Thanks, I just started reviewing this patch, and your notes above are
>> exactly the question I was going to ask.  The comments in
>> pcie_bus_update_set() only tell me what the code does.  I can read the
>> C code just fine; what we need there is the explanation about *why* we
>> handle devices below root ports differently than others.  Maybe we can
>> adapt some of your notes as comments in the code.
>
> Hi Bjorn,
>    Thanks for your review and comments!
>
>>
>> Do you have references to the spec where it talks about this
>> difference?  I want to make sure we can rely on the fact that a root
>> port can accept TLPs larger than its MPS.
>
> PCIe Spec does not explicitly mention this issue, we can only get the message that
> root port/ root complex can split the TLP into smaller packets. For instance
> one 256B packet split into two 128B packet.
>
> I confirm this issue in my X86 machine and IA64 machine.
> 1. I unload NIC driver to make sure the safety during  change the NIC MPS.
> 2. Use setpci change NIC MPS to the max value it supports.
> 3. Reload the NIC driver
> 4. Ping and use scp cpoy large file bwtween machines. Result is ok.

The fact that it works on two pieces of hardware is not enough to be
confident that it will work on all spec-conforming hardware.  Maybe we
can deduce this from something in the spec, but I'll have to dig into
it more tomorrow.  I just hoped that you had a spec reference that
could save me some time.

> linux:/home/yijing # lspci -tv
>  \-[0000:00]-+-00.0  Intel Corporation 5500 I/O Hub to ESI Port
>              +-01.0-[01]--+-00.0  Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet
>              |            \-00.1  Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet
>              +-03.0-[02]----00.0  Xilinx Corporation Default PCIe endpoint ID
>              +-07.0-[03]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
>              |            \-00.1  Intel Corporation 82576 Gigabit Network Connection
>              +-09.0-[04]----00.0  LSI Logic / Symbios Logic MegaRAID SAS 1078
>                 ................
>
> linux:/home/yijing # ifconfig
> eth1      Link encap:Ethernet  HWaddr 80:FB:06:AD:B2:FF
>           inet addr:128.5.160.31  Bcast:128.5.160.255  Mask:255.255.255.0
>           inet6 addr: fe80::82fb:6ff:fead:b2ff/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:2737201 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:2665883 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:3681912141 (3511.3 Mb)  TX bytes:3672206941 (3502.0 Mb)
>
> linux:/home/yijing # ethtool -i eth1
> driver: bnx2
> version: 2.2.3
> firmware-version: bc 4.6.4
> bus-info: 0000:01:00.1  ------------->device
> supports-statistics: yes
> supports-test: yes
> supports-eeprom-access: yes
> supports-register-dump: yes
> supports-priv-flags: no
>
> linux:/home/yijing # lspci -vvv -s 0000:00:01.0
> 00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 1 (rev 22) (prog-if 00 [Normal decode])
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>         I/O behind bridge: 0000f000-00000fff
>         Memory behind bridge: c0000000-c3ffffff
>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: [40] Subsystem: Device 19e5:2008
>         Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
>                 Address: 00000000  Data: 0000
>                 Masking: 00000000  Pending: 00000000
>         Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>                         ExtTag+ RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes         --------------------------->root port device, MPS is 128B
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>                 LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <64us
>                         ClockPM- Surprise+ LLActRep+ BwNot+
>                 .........[snip].......
>
>
> linux:/home/yijing # lspci -vvv -s 01:00.1        ----------------->EP device, MPS change from 128B to 512B
> 01:00.1 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet (rev 20)
>         Subsystem: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 256 bytes
>         Interrupt: pin B routed to IRQ 40
>         Region 0: Memory at c2000000 (64-bit, non-prefetchable) [size=32M]
>         Capabilities: [48] Power Management version 3
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
>         Capabilities: [50] Vital Product Data
>                 Product Name: Broadcom NetXtreme II Ethernet Controller
>                 Read-only fields:
>                         [PN] Part number: BCM95706A0
>                         [EC] Engineering changes: 220197-2
>                         [SN] Serial number: 0123456789
>                         [MN] Manufacture ID: 31 34 65 34
>                         [RV] Reserved: checksum good, 31 byte(s) reserved
>                 End
>         Capabilities: [58] MSI: Enable- Count=1/16 Maskable- 64bit+
>                 Address: 0000000000000000  Data: 0000
>         Capabilities: [a0] MSI-X: Enable+ Count=9 Masked-
>                 Vector table: BAR=0 offset=0000c000
>                 PBA: BAR=0 offset=0000e000
>         Capabilities: [ac] Express (v2) Endpoint, MSI 00
>                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                         MaxPayload 512 bytes, MaxReadReq 512 bytes  ---------------------------->EP device, MPS is 512B
>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
>                 LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <2us, L1 <2us
>                         ClockPM- Surprise- LLActRep- BwNot-
>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>
>                 ...............[snip].............
>
> linux:/home/yijing # scp yijing@128.5.160.28:/home/yijing/ISO/HUAWEI_Enterprise_Linux_B016.iso ./
> yijing@128.5.160.28's password:
> HUAWEI_Enterprise_Linux_B016.iso                                                                                                   100% 3318MB  53.5MB/s   01:02
>
>
> linux:/home/yijing # ping 128.5.64.144 -l 65530
> WARNING: probably, rcvbuf is not enough to hold preload.
> PING 128.5.64.144 (128.5.64.144) 56(84) bytes of data.
> 64 bytes from 128.5.64.144: icmp_seq=1 ttl=126 time=9.12 ms
> 64 bytes from 128.5.64.144: icmp_seq=2 ttl=126 time=9.11 ms
> 64 bytes from 128.5.64.144: icmp_seq=3 ttl=126 time=10.0 ms
> 64 bytes from 128.5.64.144: icmp_seq=4 ttl=126 time=10.0 ms
> 64 bytes from 128.5.64.144: icmp_seq=5 ttl=126 time=10.0 ms
> 64 bytes from 128.5.64.144: icmp_seq=6 ttl=126 time=10.1 ms
> 64 bytes from 128.5.64.144: icmp_seq=7 ttl=126 time=7.66 ms
> 64 bytes from 128.5.64.144: icmp_seq=8 ttl=126 time=7.94 ms
> 64 bytes from 128.5.64.144: icmp_seq=9 ttl=126 time=59.3 ms
> 64 bytes from 128.5.64.144: icmp_seq=10 ttl=126 time=7.97 ms
> 64 bytes from 128.5.64.144: icmp_seq=11 ttl=126 time=9.68 ms
> 64 bytes from 128.5.64.144: icmp_seq=12 ttl=126 time=8.21 ms
> 64 bytes from 128.5.64.144: icmp_seq=13 ttl=126 time=7.95 ms
> 64 bytes from 128.5.64.144: icmp_seq=14 ttl=126 time=8.04 ms
> 64 bytes from 128.5.64.144: icmp_seq=15 ttl=126 time=7.77 ms
>
>
>
>
>
>
>
>
>
>
>
>
>
>>
>> Bjorn
>>
>>> On 2013/2/5 11:55, Yijing Wang wrote:
>>>> Currently we dont't update device's mps vaule when doing
>>>> pci device hot-add. The hot-added device's mps will be set
>>>> to default value (128B). But the upstream port device's mps
>>>> may be larger than 128B which was set by firmware during
>>>> system bootup. In this case the new added device may not
>>>> work normally.
>>>>
>>>> The reference discussion at
>>>> http://marc.info/?l=linux-pci&m=135420434508910&w=2
>>>> and
>>>> http://marc.info/?l=linux-pci&m=134815603407842&w=2
>>>>
>>>> Reported-by: Joe Jin <joe.jin@oracle.com>
>>>> Reported-by: Yijing Wang <wangyijing@huawei.com>
>>>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>>>> Cc: Jon Mason <jdmason@kudzu.us>
>>>> ---
>>>>  drivers/pci/probe.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  1 files changed, 49 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>>>> index bbe4be7..57d9a5b 100644
>>>> --- a/drivers/pci/probe.c
>>>> +++ b/drivers/pci/probe.c
>>>> @@ -1556,6 +1556,52 @@ static int pcie_bus_configure_set(struct pci_dev *dev, void *data)
>>>>       return 0;
>>>>  }
>>>>
>>>> +static int pcie_bus_update_set(struct pci_dev *dev, void *data)
>>>> +{
>>>> +     int mps, p_mps;
>>>> +
>>>> +     if (!pci_is_pcie(dev) || !dev->bus->self)
>>>> +             return 0;
>>>> +
>>>> +     mps = pcie_get_mps(dev);
>>>> +     p_mps = pcie_get_mps(dev->bus->self);
>>>> +
>>>> +     if (pci_pcie_type(dev->bus->self) != PCI_EXP_TYPE_ROOT_PORT) {
>>>> +             /* update mps when current device mps is not equal to upstream mps */
>>>> +             if (mps != p_mps)
>>>> +                     goto update;
>>>> +     } else {
>>>> +             /* update mps when current device mps is smaller than upstream mps */
>>>> +             if (mps < p_mps)
>>>> +                     goto update;
>>>> +     }
>>>> +
>>>> +     return 0;
>>>> +
>>>> +update:
>>>> +     /* If current mpss is lager than upstream, use upstream mps to update
>>>> +      * current mps, otherwise print warning info.
>>>> +      */
>>>> +     if ((128 << dev->pcie_mpss) >= p_mps)
>>>> +             pcie_write_mps(dev, p_mps);
>>>> +     else
>>>> +             dev_warn(&dev->dev, "MPS %d MPSS %d both smaller than upstream MPS %d\n"
>>>> +                             "If necessary, use \"pci=pcie_bus_peer2peer\" boot parameter to avoid this problem\n",
>>>> +                             mps, 128 << dev->pcie_mpss, p_mps);
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +static void pcie_bus_update_setting(struct pci_bus *bus)
>>>> +{
>>>> +
>>>> +     /*
>>>> +      * After hot added a pci device, the device's mps will set to default
>>>> +      * vaule(128 bytes). But the upstream port mps may be larger than 128B.
>>>> +      * In this case, we should update this device's mps for better performance.
>>>> +      */
>>>> +     pci_walk_bus(bus, pcie_bus_update_set, NULL);
>>>> +}
>>>> +
>>>>  /* pcie_bus_configure_settings requires that pci_walk_bus work in a top-down,
>>>>   * parents then children fashion.  If this changes, then this code will not
>>>>   * work as designed.
>>>> @@ -1566,6 +1612,9 @@ void pcie_bus_configure_settings(struct pci_bus *bus, u8 mpss)
>>>>
>>>>       if (!pci_is_pcie(bus->self))
>>>>               return;
>>>> +
>>>> +     /* update mps setting for newly hot added device */
>>>> +     pcie_bus_update_setting(bus);
>>>>
>>>>       if (pcie_bus_config == PCIE_BUS_TUNE_OFF)
>>>>               return;
>>>>
>>>
>>>
>>> --
>>> Thanks!
>>> Yijing
>>>
>>
>> .
>>
>
>
> --
> Thanks!
> Yijing
>
