Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbaAGC4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:56:25 -0500
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:45420 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756716AbaAGC4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:56:22 -0500
MIME-Version: 1.0
In-Reply-To: <20140103005253.GB12098@obsidianresearch.com>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
	<1387785725-24262-3-git-send-email-tinamdar@apm.com>
	<20131223174634.GD25089@obsidianresearch.com>
	<CACoXjcnPvgDX3s8OywLHP6Tu2OrpNzM1Phx+s3RLmKDgu3t8gA@mail.gmail.com>
	<20140103005253.GB12098@obsidianresearch.com>
Date: Mon, 6 Jan 2014 18:56:21 -0800
Message-ID: <CACoXjcnykxdjekfmz6B3Ovk-+naCCOCWFZ3t=ZaMWAEPyVs_eQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] arm64: dts: APM X-Gene PCIe device tree nodes
From: Tanmay Inamdar <tinamdar@apm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Masters <jcm@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 2, 2014 at 4:52 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Thu, Jan 02, 2014 at 01:56:51PM -0800, Tanmay Inamdar wrote:
>> On Mon, Dec 23, 2013 at 9:46 AM, Jason Gunthorpe
>> <jgunthorpe@obsidianresearch.com> wrote:
>> > On Mon, Dec 23, 2013 at 01:32:03PM +0530, Tanmay Inamdar wrote:
>> >> This patch adds the device tree nodes for APM X-Gene PCIe controller and
>> >> PCIe clock interface. Since X-Gene SOC supports maximum 5 ports, 5 dts nodes
>> >> are added.
>> >
>> > Can you include an lspci dump for PCI DT bindings please? It is
>> > impossible to review otherwise..
>> >
>>
>> On the X-Gene evaluation platform, there is only one PCIe port
>> enabled. Here is the 'lspci' dump
>
> This is a bit hard to read withouth more context, but:
>
>> # lspci -vvv
>> 00:00.0 Class 0604: Device 19aa:e008 (rev 04)
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>
> This is an on-chip device? (19aa does not seem to be a VID I can find)

oops.. looks like vendor and device IDs are jumbled. You can look for
e008 vendor ID.
I will fix it in next version.

>
> Ideally this is the on-chip PCI-PCI bridge which represents the port.
>
> The problem I see is that your DT binding has a top level stanza per
> port.
>
> We *really* prefer to see a single stanza for all ports - but this
> requires the HW to be able to fit into the Linux resource assignment
> model - a single resource pool for all ports and standard PCI-PCI
> bridge config access to assign the resource to a port.
>
> If your HW can't do this (eg because the port aperture 0xe000000000 is
> hard wired) then the fall back is to place every port in a distinct
> domain, with a distinct DT node and have overlapping bus numbers
> and fixed windows. I don't see PCI domain support in your driver..

Thanks for the suggestion. I will think over this.

>
> There is some kind of an addressing problem because you've done this:
>
> +static void xgene_pcie_fixup_bridge(struct pci_dev *dev)
> +{
> +       int i;
> +
> +       for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
> +               dev->resource[i].start = dev->resource[i].end = 0;
> +               dev->resource[i].flags = 0;
> +       }
> +}
> +DECLARE_PCI_FIXUP_HEADER(XGENE_PCIE_VENDORID, XGENE_PCIE_BRIDGE_DEVICEID,
> +                        xgene_pcie_fixup_bridge);
>
> Which is usually a sign that something is wonky with how the HW is
> being fit into the PCI core.

We map the whole DDR range (eg 256 GB) into host's BAR. The Linux PCI
resource management tries to fit the host's memory into the ranges
provided (eg 0xe000000000).
Please let me know if there is any use case to do this mapping.

>
>> ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Region 0: Memory at <ignored> (64-bit, prefetchable)
>>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>>         I/O behind bridge: 0000f000-00000fff
>>         Memory behind bridge: 00c00000-00cfffff
>
> [..]
>
>> 01:00.0 Class 0200: Device 15b3:1003
>>         Region 0: Memory at e000c00000 (64-bit, non-prefetchable) [size=1M]
>>         Region 2: Memory at e000000000 (64-bit, prefetchable)
>>         [size=8M]
>
> Something funky is going on here too, the 64 bit address e000000000
> should be reflected in the 'memory behind bridge' above, not
> truncated.

That's the Mellanox device that is plugged into the system. The
device's memory gets mapped at '0xe0xxxxxxxx'

>
> ranges = <0x02000000 0x0 0x00000000 0x90 0x00000000 0x0 0x10000000 /* mem*/
> +                                 0x01000000 0x0 0x80000000 0x90 0x80000000 0x0 0x00010000 /* io */
> +                                 0x00000000 0x0 0xd0000000 0x90 0xd0000000 0x0 0x00200000 /* cfg */
> +                                 0x00000000 0x0 0x79000000 0x00 0x79000000 0x0 0x00800000>; /* msi */
>
> Ranges has a defined meaning, MSI shouldn't be in ranges, and 'cfg' is
> only OK if the address encoding exactly matches the funky PCI-E extended
> configuration address format. You can move these to regs or other
> properties

ok

>
> (MSI is tricky, I'm not aware of DT binding work for MSI :()
>

It does not. This is the range required to be mapped by the controller
to support MSI. I know it is not a standard way of doing. I was just
trying to utilize 'of_pci_range_to_resource' api.

> Also, unrelated, can you please double check that your HW cannot
> generate 8 and 16 bit configuration write TLPs natively? The
> xgene_pcie_cfg_out8/16 hack is not desirable if it can be avoided.
>

Sadly HW cannot generate 8 and 16 bit configuration transactions.

> Regards,
> Jason
