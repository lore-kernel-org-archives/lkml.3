Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaBCTm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:42:28 -0500
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:47202 "HELO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753411AbaBCTmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:42:24 -0500
MIME-Version: 1.0
In-Reply-To: <201401301516.27091.arnd@arndb.de>
References: <1390599168-13150-1-git-send-email-tinamdar@apm.com>
	<1390599168-13150-2-git-send-email-tinamdar@apm.com>
	<201401301516.27091.arnd@arndb.de>
Date: Mon, 3 Feb 2014 11:42:22 -0800
Message-ID: <CACoXjcnXoysMeBsGuOb3t5b10zdeJ8pOnuOOzR8AaZhsOOYVEw@mail.gmail.com>
Subject: Re: [RFC PATCH V3 1/4] pci: APM X-Gene PCIe controller driver
From: Tanmay Inamdar <tinamdar@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches <patches@apm.com>,
        Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 6:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 24 January 2014, Tanmay Inamdar wrote:
>
>> +static void xgene_pcie_fixup_bridge(struct pci_dev *dev)
>> +{
>> +     int i;
>> +
>> +     /* Hide the PCI host BARs from the kernel as their content doesn't
>> +      * fit well in the resource management
>> +      */
>> +     for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
>> +             dev->resource[i].start = dev->resource[i].end = 0;
>> +             dev->resource[i].flags = 0;
>> +     }
>> +     dev_info(&dev->dev, "Hiding X-Gene pci host bridge resources %s\n",
>> +              pci_name(dev));
>> +}
>> +DECLARE_PCI_FIXUP_HEADER(XGENE_PCIE_VENDORID, XGENE_PCIE_DEVICEID,
>> +                      xgene_pcie_fixup_bridge);
>
> Shouldn't this be gone now that the host bridge is correctly shown
> at the domain root?

In inbound region configuration, whole DDR space is mapped into the
BAR of RC. When Linux PCI mid-layer starts enumerating, it reads the
size of BAR of RC and tries to fit it into the memory resource. First
thing is that the outbound memory is not enough to map the inbound BAR
space. This creates problem with the resource management logic and
second thing is that, it is not required to map inbound BAR space RC
bar as no one will be accessing it further.

As Jason suggested, Bridge BAR's should be 0 size unless the bridge
itself has registers. However this is not the case with XGene PCIe
controller. It may have been inherited from the legacy design.
'arch/powerpc/sysdev/ppc4xx_pci.c' has similar fixup function.

>
>> +static int xgene_pcie_setup(int nr, struct pci_sys_data *sys)
>> +{
>> +     struct xgene_pcie_port *pp = sys->private_data;
>> +     struct resource *io = &pp->realio;
>> +
>> +     io->start = sys->domain * SZ_64K;
>> +     io->end = io->start + SZ_64K;
>> +     io->flags = pp->io.res.flags;
>> +     io->name = "PCI IO";
>> +     pci_ioremap_io(io->start, pp->io.res.start);
>> +
>> +     pci_add_resource_offset(&sys->resources, io, sys->io_offset);
>> +     sys->mem_offset = pp->mem.res.start - pp->mem.pci_addr;
>> +     pci_add_resource_offset(&sys->resources, &pp->mem.res,
>> +                             sys->mem_offset);
>> +     return 1;
>> +}
>
> Thanks for bringing back the I/O space handling.
>
> You don't seem to set sys->io_offset anywhere, but each of the
> ports listed in your DT starts a local bus I/O register range
> at port 0.
>
> AFAICT, you need to add (somewhere)
>
>         sys->io_offset = pp->realio.start - pp->io.pci_addr;
>
> but there could be something else missing. You clearly haven't
> tested if the I/O space actually works.

That is correct :-). Could not find the card. Thanks for the patch below.
>
> If you want to try out the I/O space, I'd suggest using an Intel
> e1000 network card, which has both memory and i/o space. There
> is a patch at http://www.spinics.net/lists/linux-pci/msg27684.html
> that lets you check the I/O registers on it, or you can go
> through /dev/port from user space.
>
> I also haven't seen your patch that adds pci_ioremap_io() for
> arm64. It would be helpful to keep it in the same patch
> series, since it won't build without this patch.

I will post the arm64 pci patch along with next revision of this
driver. That will cover the 'pci_ioremap_io' as well.

>
>         Arnd
