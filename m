Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaBCUMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:12:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58735 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaBCUMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:12:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tanmay Inamdar <tinamdar@apm.com>
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
Subject: Re: [RFC PATCH V3 1/4] pci: APM X-Gene PCIe controller driver
Date: Mon, 03 Feb 2014 21:12:32 +0100
Message-ID: <4985267.LnsktRmabM@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CACoXjcnXoysMeBsGuOb3t5b10zdeJ8pOnuOOzR8AaZhsOOYVEw@mail.gmail.com>
References: <1390599168-13150-1-git-send-email-tinamdar@apm.com> <201401301516.27091.arnd@arndb.de> <CACoXjcnXoysMeBsGuOb3t5b10zdeJ8pOnuOOzR8AaZhsOOYVEw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:42Qb4Wq4imV49bHkLxuCZGFWP/bPswh4HdHihri+GUi
 HYJ4IqNddLokIk5+pWRBrmWWA3UCOd+1TW/Y2TSqRgTKkIWzBh
 GJrEYq0sQ6tyW9bsCrUYK4ja2EjSX2U6RLaynt/7g/dOT+CsID
 ZMDUjoTrYs8MGeLS76F4Ze2ueUru1ORb2/rZ5PK9zlj4cTSp8d
 qQXHY5aijSylbHgTTmlWzBjrhWoVCDdpYojNGYUoDALwm08edM
 QzS/owNBn2zuDvkCXvXmgoC4wK2BaOo9zAeTn3yWUlR2frq8x4
 ePv7kSYApHf8NkfWx721qYZjOx236XO33TGMi4N/US85x2GeW9
 j5D+P4UVo5m5qwVgusQk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 February 2014 11:42:22 Tanmay Inamdar wrote:
> On Thu, Jan 30, 2014 at 6:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 24 January 2014, Tanmay Inamdar wrote:
> >
> >> +static void xgene_pcie_fixup_bridge(struct pci_dev *dev)
> >> +{
> >> +     int i;
> >> +
> >> +     /* Hide the PCI host BARs from the kernel as their content doesn't
> >> +      * fit well in the resource management
> >> +      */
> >> +     for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
> >> +             dev->resource[i].start = dev->resource[i].end = 0;
> >> +             dev->resource[i].flags = 0;
> >> +     }
> >> +     dev_info(&dev->dev, "Hiding X-Gene pci host bridge resources %s\n",
> >> +              pci_name(dev));
> >> +}
> >> +DECLARE_PCI_FIXUP_HEADER(XGENE_PCIE_VENDORID, XGENE_PCIE_DEVICEID,
> >> +                      xgene_pcie_fixup_bridge);
> >
> > Shouldn't this be gone now that the host bridge is correctly shown
> > at the domain root?
> 
> In inbound region configuration, whole DDR space is mapped into the
> BAR of RC. When Linux PCI mid-layer starts enumerating, it reads the
> size of BAR of RC and tries to fit it into the memory resource. First
> thing is that the outbound memory is not enough to map the inbound BAR
> space. This creates problem with the resource management logic and
> second thing is that, it is not required to map inbound BAR space RC
> bar as no one will be accessing it further.
> 
> As Jason suggested, Bridge BAR's should be 0 size unless the bridge
> itself has registers. However this is not the case with XGene PCIe
> controller. It may have been inherited from the legacy design.
> 'arch/powerpc/sysdev/ppc4xx_pci.c' has similar fixup function.

Are you sure that is true for the root bridge as well? I don't
remember the details, but I though that for the host bridge,
we don't actually look at the BARs at all.

> > If you want to try out the I/O space, I'd suggest using an Intel
> > e1000 network card, which has both memory and i/o space. There
> > is a patch at http://www.spinics.net/lists/linux-pci/msg27684.html
> > that lets you check the I/O registers on it, or you can go
> > through /dev/port from user space.
> >
> > I also haven't seen your patch that adds pci_ioremap_io() for
> > arm64. It would be helpful to keep it in the same patch
> > series, since it won't build without this patch.
> 
> I will post the arm64 pci patch along with next revision of this
> driver. That will cover the 'pci_ioremap_io' as well.

Please note that today, Liviu Dudau has also posted patches for this,
so you should coordinate a bit.

	Arnd
