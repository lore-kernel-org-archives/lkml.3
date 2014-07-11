Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaGKMYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:24:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38342 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbaGKMYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:24:19 -0400
Date: Fri, 11 Jul 2014 13:24:25 +0100
From: Will Deacon <will.deacon@arm.com>
To: Olav Haugan <ohaugan@codeaurora.org>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        "mitchelh@codeaurora.org" <mitchelh@codeaurora.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140711122425.GD12899@arm.com>
References: <20140624091808.GC26013@arm.com>
 <53A9BC18.2090106@codeaurora.org>
 <20140624181150.GB4067@arm.com>
 <53A9EF3A.2070704@codeaurora.org>
 <20140625091858.GG6153@arm.com>
 <53ADEEDF.7060902@codeaurora.org>
 <20140630095220.GA25779@arm.com>
 <53BC95DA.1010500@codeaurora.org>
 <20140709105441.GE9485@arm.com>
 <53BF1470.1000704@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BF1470.1000704@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 11:32:16PM +0100, Olav Haugan wrote:
> On 7/9/2014 3:54 AM, Will Deacon wrote:
> > On Wed, Jul 09, 2014 at 02:07:38AM +0100, Olav Haugan wrote:
> >> So how does an algorithm figure this out in both my examples? The
> >> algorithm would have to know about both (all) bus masters and their
> >> stream IDs for a specific SMMU. If the algorithm operates on the set of
> >> stream IDs for one bus master at a time the algorithm has no way of
> >> knowing which bits can be ignored since it doesn't know the value of the
> >> other stream IDs for the other bus masters and thus could potentially
> >> create a mask that could cause a stream ID to match in two different
> >> entries.
> > 
> > Complete knowledge of the system topology (i.e. all bus masters) is a
> > requirement for being able to configure the SMMU correctly if you want to
> > guarantee that you don't have SMR aliasing issues.
> 
> So you agree that an algorithm needs to know about all the bus
> masters/stream IDs for a specific IOMMU before it can figure out the
> StreamID masks and how many SMRs can be allocated to a specific bus
> master? Andreas's algorithm does not know about the other bus
> masters/stream IDs. It operates on one bus master at a time.

Right, but it can certainly be improved. There are certain things you can do
without complete knowledge, as I mentioned previously (if you can have
densely packed power-of-2 aligned/sized regions).

> >>>> I am not familiar with Andreas's proposal. Do you have a link?
> >>>
> >>>   http://marc.info/?l=linux-arm-kernel&m=139110598005846&w=2
> >>
> >> Unless I am mistaken the algorithm works on one bus master at a time. I
> >> don't think that will work.
> > 
> > IIRC, it works for densely packed SIDs on the master, so it tries to build
> > up power-of-2 sized groups for that master then mops up the rest with
> > individual entries.
> 
> I ran the algorithm through a few trivial cases:
> 
> 1)
> Stream IDs: 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28
> Number of SMRs: 9
> 
> In this case the algorithm decided to set mask to 0 for all entries
> using up 8 of the SMRs.

Well think about what it's doing... we don't know about SID 0x20, for
example so there's not much it can do.

> 2) Same Stream IDs but only 2 SMRs.
> The algorithm gave an error saying I did not have enough SMRs.

There's a reason this didn't get merged, and it would be great if you could
try to improve the situation ;).

Will
