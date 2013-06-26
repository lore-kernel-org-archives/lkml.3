Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3FZPft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:35:49 -0400
Received: from mout3.freenet.de ([195.4.92.93]:39083 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab3FZPfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:35:46 -0400
X-Greylist: delayed 1129 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jun 2013 11:35:45 EDT
Date: Wed, 26 Jun 2013 17:14:28 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH RFC] pci: ACS quirk for AMD southbridge
Message-ID: <20130626171428.33940803@dualc.maya.org>
In-Reply-To: <CAErSpo6Xf=eF3xv=9CLmDYVMpWT6FSv634s8V-YfreiN6icDUA@mail.gmail.com>
References: <20120712050653.20439.11009.stgit@bling.home> <CAErSpo7=p7HyUfw4AQ-oQpLvgMfBi5iPfB+Fvrb02FWVHd_FAg@mail.gmail.com> <CAErSpo6Xf=eF3xv=9CLmDYVMpWT6FSv634s8V-YfreiN6icDUA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> [fix Joerg's email address]
> 
> On Tue, Jun 25, 2013 at 10:15 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Wed, Jul 11, 2012 at 11:18 PM, Alex Williamson
>> <alex.williamson@redhat.com> wrote:
>>> We've confirmed that peer-to-peer between these devices is
>>> not possible.  We can therefore claim that they support a
>>> subset of ACS.
>>>
>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>> Cc: Joerg Roedel <Joerg.Roedel@amd.com>
>>> ---
>>>
>>> Two things about this patch make me a little nervous.  The
>>> first is that I'd really like to have a pci_is_pcie() test
>>> in pci_mf_no_p2p_acs_enabled(), but these devices don't
>>> have a PCIe capability.  That means that if there was a
>>> topology where these devices sit on a legacy PCI bus,
>>> we incorrectly return that we're ACS safe here.  That leads
>>> to my second problem, pciids seems to suggest that some of
>>> these functions have been around for a while.  Is it just
>>> this package that's peer-to-peer safe, or is it safe to
>>> assume that any previous assembly of these functions is
>>> also p2p safe.  Maybe we need to factor in device revs if
>>> that uniquely identifies this package?
>>>
>>> Looks like another useful device to potentially quirk
>>> would be:
>>>
>>> 00:15.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0)
>>> 00:15.1 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1)
>>> 00:15.2 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB900 PCI to PCI bridge (PCIE port 2)
>>> 00:15.3 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB900 PCI to PCI bridge (PCIE port 3)
>>>
>>> 00:15.0 0604: 1002:43a0
>>> 00:15.1 0604: 1002:43a1
>>> 00:15.2 0604: 1002:43a2
>>> 00:15.3 0604: 1002:43a3
>>>
>>>  drivers/pci/quirks.c |   29 +++++++++++++++++++++++++++++
>>>  1 file changed, 29 insertions(+)
>>>
>>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>>> index 4ebc865..2c84961 100644
>>> --- a/drivers/pci/quirks.c
>>> +++ b/drivers/pci/quirks.c
>>> @@ -3271,11 +3271,40 @@ struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
>>>         return pci_dev_get(dev);
>>>  }
>>>
>>> +/*
>>> + * Multifunction devices that do not support peer-to-peer between
>>> + * functions can claim to support a subset of ACS.  Such devices
>>> + * effectively enable request redirect (RR) and completion redirect (CR)
>>> + * since all transactions are redirected to the upstream root complex.
>>> + */
>>> +static int pci_mf_no_p2p_acs_enabled(struct pci_dev *dev, u16 acs_flags)
>>> +{
>>> +       if (!dev->multifunction)
>>> +               return -ENODEV;
>>> +
>>> +       /* Filter out flags not applicable to multifunction */
>>> +       acs_flags &= (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC | PCI_ACS_DT);
>>> +
>>> +       return acs_flags & ~(PCI_ACS_RR | PCI_ACS_CR) ? 0 : 1;
>>> +}
>>> +
>>>  static const struct pci_dev_acs_enabled {
>>>         u16 vendor;
>>>         u16 device;
>>>         int (*acs_enabled)(struct pci_dev *dev, u16 acs_flags);
>>>  } pci_dev_acs_enabled[] = {
>>> +       /*
>>> +        * AMD/ATI multifunction southbridge devices.  AMD has confirmed
>>> +        * that peer-to-peer between these devices is not possible, so
>>> +        * they do support a subset of ACS even though the capability is
>>> +        * not exposed in config space.
>>> +        */
>>> +       { PCI_VENDOR_ID_ATI, 0x4385, pci_mf_no_p2p_acs_enabled },
>>> +       { PCI_VENDOR_ID_ATI, 0x439c, pci_mf_no_p2p_acs_enabled },
>>> +       { PCI_VENDOR_ID_ATI, 0x4383, pci_mf_no_p2p_acs_enabled },
>>> +       { PCI_VENDOR_ID_ATI, 0x439d, pci_mf_no_p2p_acs_enabled },
>>> +       { PCI_VENDOR_ID_ATI, 0x4384, pci_mf_no_p2p_acs_enabled },
>>> +       { PCI_VENDOR_ID_ATI, 0x4399, pci_mf_no_p2p_acs_enabled },
>>>         { 0 }
>>>  };
>>>
>>>
>>
>> I was looking for something else and found this old email.  This patch
>> hasn't been applied and I haven't seen any discussion about it.  Is it
>> still of interest?  It seems relevant to the current ACS discussion
>> [1].

It is absolutely relevant. I always have to patch my kernel to get it
working to put my pci device to VM. Meanwhile I'm doing it for
kernel 3.9. I would be very glad to get these patches to the kernel as
they don't do anything bad!

My multifunction devices are the devices defined in the patch. My
current pci device passed through is a intel ethernet device:

-[0000:00]-+-00.0  Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (external gfx0 port B)
           +-00.2  Advanced Micro Devices [AMD] nee ATI RD990 I/O Memory Management Unit (IOMMU)
           +-02.0-[01]--+-00.0  Advanced Micro Devices [AMD] nee ATI Turks [Radeon HD 6570]
           |            \-00.1  Advanced Micro Devices [AMD] nee ATI Turks HDMI Audio [Radeon HD 6000 Series]
           +-04.0-[02]----00.0  Etron Technology, Inc. EJ168 USB 3.0 Host Controller
           +-05.0-[03]----00.0  Atheros Communications Inc. AR9300 Wireless LAN adaptor
           +-09.0-[04]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller
           +-0a.0-[05]----00.0  Etron Technology, Inc. EJ168 USB 3.0 Host Controller
           +-11.0  Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
           +-12.0  Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
           +-12.2  Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
           +-13.0  Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
           +-13.2  Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
           +-14.0  Advanced Micro Devices [AMD] nee ATI SBx00 SMBus Controller
           +-14.2  Advanced Micro Devices [AMD] nee ATI SBx00 Azalia (Intel HDA)
           +-14.3  Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 LPC host controller
           +-14.4-[06]--+-06.0  Intel Corporation 82557/8/9/0/1 Ethernet Pro 100
           |            \-0e.0  VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller
           +-14.5  Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
           +-15.0-[07]--
           +-16.0  Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
           +-16.2  Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
           +-18.0  Advanced Micro Devices [AMD] Family 15h Processor Function 0
           +-18.1  Advanced Micro Devices [AMD] Family 15h Processor Function 1
           +-18.2  Advanced Micro Devices [AMD] Family 15h Processor Function 2
           +-18.3  Advanced Micro Devices [AMD] Family 15h Processor Function 3
           +-18.4  Advanced Micro Devices [AMD] Family 15h Processor Function 4
           \-18.5  Advanced Micro Devices [AMD] Family 15h Processor Function 5


lspci -vvvvv -s 14.4
00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Bus: primary=00, secondary=06, subordinate=06, sec-latency=64
        I/O behind bridge: 00009000-00009fff
        Memory behind bridge: fd800000-fd8fffff
        Prefetchable memory behind bridge: fd700000-fd7fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-


lspci -vvvvv -s 6.0
06:06.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 0c)
        Subsystem: Intel Corporation EtherExpress PRO/100 S Desktop Adapter
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (2000ns min, 14000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at fd8ff000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at 9f00 [size=64]
        Region 2: Memory at fd8c0000 (32-bit, non-prefetchable) [size=128K]
        Expansion ROM at fd700000 [disabled] [size=64K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
        Kernel driver in use: vfio-pci


Thanks,
kind regards,
Andreas Hartmann
