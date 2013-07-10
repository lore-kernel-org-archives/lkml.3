Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3GJQMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:12:34 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:41253 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3GJQMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 12:12:33 -0400
MIME-Version: 1.0
In-Reply-To: <51DCFDC7.3060406@hp.com>
References: <1373348531-31893-1-git-send-email-zhen-hual@hp.com>
 <CAErSpo6pCrzCOuthrgD_+oRyw7ZhqztVSi=ti336s2h5xeH_uA@mail.gmail.com> <51DCFDC7.3060406@hp.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 10 Jul 2013 10:12:09 -0600
Message-ID: <CAErSpo6LkwK5h7+1VDRKG81FdK2uoPSukSASfTEAngfNhNV8VA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ia64/pci: set mmio decoding on for some host bridge
To: ZhenHua <zhen-hual@hp.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 12:23 AM, ZhenHua <zhen-hual@hp.com> wrote:
> Hi Bjorn,
> On the system that this bug happens,  an MCA event is generated while kernel
> crashed:
>     Transaction Address: memory write to address 0x00000ae041428 (LMMIO -
> SBL Blade 1 SFW DDR Memory)
>
> I guess the there is some module trying to visit the address 0x00000ae041428
> right after this line is run:
>      pci_write_config_word(dev, PCI_COMMAND,
>                         orig_cmd & ~(PCI_COMMAND_MEMORY | PCI_COMMAND_IO));

Well, you need to figure out what is accessing 0x00000ae041428 and
why.  Presumably that address belongs to some device below the 40:01.0
root port, and knowing which device that is would be a good clue, but
you didn't include that in your lspci.

I'm trying to give you hints about how *you* can figure out what's
going on here.  Obviously I don't have the system and I'm not
proposing a change, so that's about all I can do.

>
> The output of lspci -vvv is followed.
> 40:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root
> Port 1 (rev 22) (prog-if 00 [Normal decode])
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
> Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=40, secondary=41, subordinate=41, sec-latency=0
>         I/O behind bridge: 0000f000-00000fff
>         Memory behind bridge: ae000000-af8fffff
>         Prefetchable memory behind bridge: fffffffffff00000-00000000000fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: [40] Subsystem: Intel Corporation 5520/5500/X58 I/O
> Hub PCI Express Root Port 1
>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit-
> Count=1/2 Enable+
>                 Address: fee00000  Data: 4046
>                 Masking: 00000002  Pending: 00000000
>         Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
> <64ns, L1 <1us
>                         ExtTag+ RBE+ FLReset-
>                 DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
> Unsupported+
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
> TransPend-
>                 LnkCap: Port #0, Speed 5GT/s, Width x2, ASPM L0s L1, Latency
> L0 <512ns, L1 <64us
>                         ClockPM- Suprise+ LLActRep+ BwNot+
>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
> CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> DLActive+ BWMgmt- ABWMgmt-
>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+
> CRSVisible-
>                 RootCap: CRSVisible-
>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                 DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
>                 DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis-
> ARIFwd-
>                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -3.5dB
>                          Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance- ComplianceSOS-
>                          Compliance De-emphasis: -6dB
>                 LnkSta2: Current De-emphasis Level: -3.5dB
>         Capabilities: [e0] Power Management version 3
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [100] Advanced Error Reporting
>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                 UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
>                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                 AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap-
> ChkEn-
>         Capabilities: [150] Access Control Services
>                 ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+
> UpstreamFwd+ EgressCtrl- DirectTrans-
>                 ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir-
> UpstreamFwd- EgressCtrl- DirectTrans-
>         Capabilities: [160] Vendor Specific Information <?>
>         Kernel driver in use: pcieport
>         Kernel modules: shpchp
>
>
>
> On 07/10/2013 12:49 AM, Bjorn Helgaas wrote:
>
> On Mon, Jul 8, 2013 at 11:42 PM, Li, Zhen-Hua <zhen-hual@hp.com> wrote:
>
> On some IA64 platforms with intel PCI bridge, for example, HP BL890c i2
> with  Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port,
> when kernel tries to disable the mmio decoding on the PCI bridge devices,
> kernel may crash.
>
> And in the comment of function quirk_mmio_always_on, it also says:
> "But doing so (disable the mmio decoding) may cause problems on host bridge
>  and perhaps other key system devices"
>
> So, for this PCI bridge,  dev->mmio_always_on bit should be set to 1.
>
> To avoid affecting the use of quirk_mmio_always_on, a new function is
> created.
>
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> ---
>  drivers/pci/quirks.c    |   17 +++++++++++++++++
>  include/linux/pci_ids.h |    1 +
>  2 files changed, 18 insertions(+)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index e85d230..665af3e 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -44,6 +44,23 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
>  DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
>                                 PCI_CLASS_BRIDGE_HOST, 8,
> quirk_mmio_always_on);
>
> +#ifdef CONFIG_IA64
> +/*
> + * On some IA64 platforms, for some intel PCI bridge devices, for example,
> + * the Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port,
> + * disable the mmio decoding on this device may cause system crash.
> + * So dev->mmio_always_on bit should be set to 1.
> + */
> +static void quirk_mmio_on_intel_pcibridge(struct pci_dev *dev)
> +{
> +       dev->mmio_always_on = 1;
> +}
> +DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_INTEL,
> +                       PCI_DEVICE_ID_INTEL_5520_5550_X58,
> +                       PCI_CLASS_BRIDGE_PCI,
> +                       8, quirk_mmio_on_intel_pcibridge);
> +#endif
> +
>  /* The Mellanox Tavor device gives false positive parity errors
>   * Mark this device with a broken_parity_status, to allow
>   * PCI scanning code to "skip" this now blacklisted device.
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 3bed2e8..d8c60b7 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2742,6 +2742,7 @@
>  #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_RANK_REV2  0x2db2
>  #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_TC_REV2    0x2db3
>  #define PCI_DEVICE_ID_INTEL_82855PM_HB 0x3340
> +#define PCI_DEVICE_ID_INTEL_5520_5550_X58       0x3408
>  #define PCI_DEVICE_ID_INTEL_IOAT_TBG4  0x3429
>  #define PCI_DEVICE_ID_INTEL_IOAT_TBG5  0x342a
>  #define PCI_DEVICE_ID_INTEL_IOAT_TBG6  0x342b
> --
> 1.7.10.4
>
> You need to figure out what the problem is, not just avoid it.  It's
> very unlikely that the problem is something unique to ia64.  In fact,
> I think it's very doubtful that the problem is even something unique
> to the 5520 root ports.  My guess is there's something special about
> the system you're testing.
>
> Evidently you have traffic going to a device behind the root port at
> the same time as we're trying to read the root port's BARs.  Linux
> should not generate traffic like that while we're enumerating the root
> port.  Does the problem happen on a root port with an iLO behind it?
> Can you collect "lspci -vvv" output and identify the root port where
> the problem occurs?
>
> Bjorn
>
>
