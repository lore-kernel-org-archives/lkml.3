Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaETNYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:24:39 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:56987 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbaETNYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:24:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Date: Tue, 20 May 2014 15:23:47 +0200
Message-ID: <6382280.3uMvoxaUSK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140520130659.GA5041@e103592.cambridge.arm.com>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com> <5080348.QmhgfQRxZW@wuerfel> <20140520130659.GA5041@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:MMSeu7ROu+mvikVvy5Ra+U/v39z2Xo7VMjszd1Se5h9
 hMMH7lk6VGEyWtM3G0SU/BY+i9aNG3AhO+CJUHt1iukTgPqJhk
 HJQIoSQZmq8ji5bXct5Nx1AFYruVS5mDY3QLq2TnY55t6AoJp9
 21hPfdqxjsX+yjWX1e8e3dYDJJPQZlb2Q+85vwd2WWHgCsl+pw
 UgCtFQo+QEcASd/JAaxrciGpJ/6ah1kWsnWmpwFkuInAPfzLSM
 oXXTvOOtqXukEOtAXgkqf5EGcqEm+QtQG9MMv3CeTD6/9YoBQy
 LxA1XfhLPEl9NFxBpbgqAWF54KcvJ6XLh29ObA/pl6bJgAo9v3
 DK9+2VUlPFm70jsNd6bw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2014 14:07:09 Dave Martin wrote:
> On Tue, May 20, 2014 at 12:08:44PM +0200, Arnd Bergmann wrote:
> > On Monday 19 May 2014 22:32:33 Thierry Reding wrote:
> > > On Mon, May 19, 2014 at 06:22:31PM +0100, Dave Martin wrote:
> > > > On Mon, May 19, 2014 at 01:53:37PM +0100, Thierry Reding wrote:
> > > [...]
> > > > > My understanding here is mostly based on the OpenFirmware working group
> > > > > proposal for the dma-ranges property[0]. I'll give another example to
> > > > > try and clarify how I had imagined this to work:
> > > > > 
> > > > >     / {
> > > > >             #address-cells = <2>;
> > > > >             #size-cells = <2>;
> > > > > 
> > > > >             iommu {
> > > > >                     /*
> > > > >                      * This is somewhat unusual (or maybe not) in that we
> > > > >                      * need 2 cells to represent the size of an address
> > > > >                      * space that is 32 bits long.
> > > > >                      */
> > > > >                     #address-cells = <1>;
> > > > >                     #size-cells = <2>;
> > > > > 
> > > > >                     #iommu-cells = <1>;
> > > > >             };
> > > > > 
> > > > >             master {
> > > > >                     iommus = <&/iommu 42>;
> > > > 
> > > > Comparing this with the other discussion thread, we have a similar
> > > > concept here, in that the iommu is made a logical parent, however...
> > > > 
> > > > Firstly, there's an implicit assumption here that the only kind of
> > > > thing the master could possibly be connected to is an IOMMU, with
> > > > no non-trivial interconnect in between.  I'm not sure this is going
> > > > to scale to complex SoCs.
> > > 
> > > Here we go again. We're now in the very same bad spot that we've been in
> > > so many times before. There are at least two SoCs that we know do not
> > > require anything fancy, yet we're blocking adding support for those use
> > > cases because we think that at some point some IOMMU may require more
> > > than that. But at the same time it seems like we don't have enough data
> > > about what exactly that is, so we keep speculating. At this rate we're
> > > making it impossible to get a reasonable feature set supported upstream.
> > > 
> > > That's very frustrating.
> > 
> > I agree. While I just commented that I want to think through how this
> > would look for other IOMMUs, the generic case of all masters that Dave
> > wants is going overboard with the complexity and we'd be better off
> 
> I don't want that, and actually I agree with the conclusion "overboard".
> 
> It was really about exploring the problem space, including things that
> we can reasonably foresee.  Any bindings today should necessarily be
> much simpler, and that's certainly the correct approach.
> 
> I've been neglecting this thread (apologies) -- but although I have to
> think a bit about Thierry's most recent suggestions, I think there's
> actually reasonable alignment now.
> 
> > deferring this to whenever someone needs it, which I assume is never.
> 
> Well, some of it might be.  But I'm not saying we should give in to
> wild speculation (except to get a feel for what we're ruling out, and
> the consequences of that).


Ok, fair enough.

> > > > If a range of Stream IDs may be issued (especially from something like
> > > > a PCIe RC where the stream ID may be a many-bit value), describing
> > > > the IDs individually may be impractical.
> > > 
> > > The IOMMU specifier is completely specific to the IOMMU. If an IOMMU has
> > > a need to represent the stream IDs as a range there's nothing keeping it
> > > from defining the specifier accordingly.
> > 
> > If we make the IOMMU address space look like the PCI address space, we
> > can have a simple representation for this in DT. For the code, I assume
> > that we will always have to treat PCI and platform devices differently.
> 
> Can you elaborate on that?
> 
> Master ID signals in ARM systems and how they are handled are rather
> under-specified today.  Treating the master ID bits as some extra bits
> in some kind of extended bus address could work for ARM IOMMUs etc.,
> but I didn't have a complete answer yet.

The PCI binding at http://www.openfirmware.org/1275/bindings/pci/pci2_1.pdf
defines a 96-bit address space for MMIO registers and other things, so
it can uniquely identify not just an address on the bus, but also 
any standard resource as seen by the device, quoting from there:

2.2.1.1. Numerical Representation
(The Numerical Representation of an address is the format that Open
 Firmware uses for storing an address within a property value and on
 the stack, as an argument to a package method.) The numerical
 representation of a PCI address consists of three cells, encoded as
 follows. For this purpose, the least-significant 32 bits of a cell is used;
 if the cell size is larger than 32 bits, any additional high-order bits
 are zero. Bit# 0 refers to the least-significant bit.

	Bit#   33222222 22221111 11111100 00000000
	       10987654 32109876 54321098 76543210
phys.hi cell:  npt000ss bbbbbbbb dddddfff rrrrrrrr
phys.mid cell: hhhhhhhh hhhhhhhh hhhhhhhh hhhhhhhh
phys.lo cell:  llllllll llllllll llllllll llllllll

where:
n is 0 if the address is relocatable, 1 otherwise
p is 1 if the addressable region is "prefetchable", 0 otherwise
t is 1 if the address is aliased (for non-relocatable I/O),
 below 1 MB (for Memory), or below 64 KB (for relocatable I/O).
ss is the space code, denoting the address space
bbbbbbbb is the 8-bit Bus Number
ddddd is the 5-bit Device Number
fff is the 3-bit Function Number
rrrrrrrr is the 8-bit Register Number
hh...hh is a 32-bit unsigned number
ll...ll is a 32-bit unsigned number

We can ignore n, p, t and r here, and use the same format for a DMA
address, then define an empty "dma-ranges" property. That would
imply that using b/d/f is sufficient to identify each master at the
iommu. Any device outside of the PCI host but connected to the same
iommu can use the same notation to list the logical b/d/f that gets
sent to the IOMMU in bus master transactions.

Do you think this is sufficient for the ARM SMMU, or do we need
something beyond that?

	Arnd
