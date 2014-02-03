Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaBCUOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:14:18 -0500
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:33396 "HELO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752883AbaBCUOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:14:16 -0500
MIME-Version: 1.0
In-Reply-To: <4985267.LnsktRmabM@wuerfel>
References: <1390599168-13150-1-git-send-email-tinamdar@apm.com>
	<201401301516.27091.arnd@arndb.de>
	<CACoXjcnXoysMeBsGuOb3t5b10zdeJ8pOnuOOzR8AaZhsOOYVEw@mail.gmail.com>
	<4985267.LnsktRmabM@wuerfel>
Date: Mon, 3 Feb 2014 12:14:15 -0800
Message-ID: <CACoXjc=fKMaR9-ScX3SSOojw2POZF8HPzXsN3rp=6sZpVu489g@mail.gmail.com>
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
        Jon Masters <jcm@redhat.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 12:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 03 February 2014 11:42:22 Tanmay Inamdar wrote:
>> On Thu, Jan 30, 2014 at 6:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Friday 24 January 2014, Tanmay Inamdar wrote:
>> >
>> >> +static void xgene_pcie_fixup_bridge(struct pci_dev *dev)
>> >> +{
>> >> +     int i;
>> >> +
>> >> +     /* Hide the PCI host BARs from the kernel as their content doesn't
>> >> +      * fit well in the resource management
>> >> +      */
>> >> +     for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
>> >> +             dev->resource[i].start = dev->resource[i].end = 0;
>> >> +             dev->resource[i].flags = 0;
>> >> +     }
>> >> +     dev_info(&dev->dev, "Hiding X-Gene pci host bridge resources %s\n",
>> >> +              pci_name(dev));
>> >> +}
>> >> +DECLARE_PCI_FIXUP_HEADER(XGENE_PCIE_VENDORID, XGENE_PCIE_DEVICEID,
>> >> +                      xgene_pcie_fixup_bridge);
>> >
>> > Shouldn't this be gone now that the host bridge is correctly shown
>> > at the domain root?
>>
>> In inbound region configuration, whole DDR space is mapped into the
>> BAR of RC. When Linux PCI mid-layer starts enumerating, it reads the
>> size of BAR of RC and tries to fit it into the memory resource. First
>> thing is that the outbound memory is not enough to map the inbound BAR
>> space. This creates problem with the resource management logic and
>> second thing is that, it is not required to map inbound BAR space RC
>> bar as no one will be accessing it further.
>>
>> As Jason suggested, Bridge BAR's should be 0 size unless the bridge
>> itself has registers. However this is not the case with XGene PCIe
>> controller. It may have been inherited from the legacy design.
>> 'arch/powerpc/sysdev/ppc4xx_pci.c' has similar fixup function.
>
> Are you sure that is true for the root bridge as well? I don't
> remember the details, but I though that for the host bridge,
> we don't actually look at the BARs at all.
>
>> > If you want to try out the I/O space, I'd suggest using an Intel
>> > e1000 network card, which has both memory and i/o space. There
>> > is a patch at http://www.spinics.net/lists/linux-pci/msg27684.html
>> > that lets you check the I/O registers on it, or you can go
>> > through /dev/port from user space.
>> >
>> > I also haven't seen your patch that adds pci_ioremap_io() for
>> > arm64. It would be helpful to keep it in the same patch
>> > series, since it won't build without this patch.
>>
>> I will post the arm64 pci patch along with next revision of this
>> driver. That will cover the 'pci_ioremap_io' as well.
>
> Please note that today, Liviu Dudau has also posted patches for this,
> so you should coordinate a bit.

Yes. Just looking at his patches. Looks similar to what I have. I will
wait till your solution shapes up.
>
>         Arnd
