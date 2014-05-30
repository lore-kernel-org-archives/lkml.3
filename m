Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247AbaE3TBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:01:32 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:60646 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaE3TBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:01:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Dave Martin <Dave.Martin@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, iommu@lists.linux-foundation.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Date: Fri, 30 May 2014 21:01:19 +0200
Message-ID: <4830064.JvgTAs8Xty@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140530112226.GA3949@e103592.cambridge.arm.com>
References: <1400877395-4235-1-git-send-email-thierry.reding@gmail.com> <20140530112226.GA3949@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:u7oFGS+G3L0gcgDegrJjMN+c+ON8VeIHX6Pc1o7iT3W
 ujrFmdraoatHq6ASMgZ1QUPV6Qhc0HPXuEyvY2XcoMRttdQeMx
 VeNb6iKkVW2FYMXxEx4/+zMMHiTcya+s8qZKQWE646kuucrIFF
 8IUDnVcPyWzxUqTE2HZDK5jLAVuJQGNYYxrihVI8oAy6CUtNYI
 oqICe85/H2hguZDmC+r1Ygs5Bx6iMnUoewjzqMCFkXUZzyPjWa
 2yX7DXY5dH+gjSm4HLKsXuEKSV8MmyaN4jgxXPAOH9X6npeVe+
 lmnB1gtRNDsOjF8RqSunzPTdTsVqwKapQVtmqxRMa6nzWfYPpt
 y322VotljLuWzBe6xOCA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 May 2014 12:22:32 Dave Martin wrote:
> > +
> > +Examples:
> > +=========
> > +
> > +Single-master IOMMU:
> > +--------------------
> > +
> > +	iommu {
> > +		#address-cells = <0>;
> > +		#size-cells = <0>;
> > +	};
> > +
> > +	master {
> > +		iommus = <&/iommu>;
> > +	};
> > +
> > +Multiple-master IOMMU with fixed associations:
> > +----------------------------------------------
> > +
> > +	/* multiple-master IOMMU */
> > +	iommu {
> > +		/*
> > +		 * Masters are statically associated with this IOMMU and
> > +		 * address translation is always enabled.
> > +		 */
> > +		#address-cells = <0>;
> > +		#size-cells = <0>;
> 
> In this example, can different translations be set up for the different
> masters?
> 
> With no cells available to contain any sort of ID, it looks like this
> is not possible.

Correct, this example is for an IOMMU that does not use IDs but has a
shared address space for all devices.

> > +Multiple-master IOMMU with configurable DMA window:
> > +---------------------------------------------------
> > +
> > +	/ {
> > +		#address-cells = <1>;
> > +		#size-cells = <1>;
> > +
> > +		iommu {
> > +			/* master ID, address of DMA window */
> > +			#address-cells = <2>;
> > +			#size-cells = <2>;
> > +		};
> > +
> > +		master {
> > +			/* master ID 42, 4 GiB DMA window starting at 0 */
> > +			iommus = <&/iommu  42 0  0x1 0x0>;
> 
> I'm still concerned that in order to deal with future cases we will have
> to invent multiple ways to parse the "iommus" property.  For example, if
> we have a PCEe RC mastering through an IOMMU, it will pass a huge set
> of possible master IDs to the IOMMU, not just noe or two.
> 
> Do you have a solution in mind for that which doesn't break backwards
> compatibility?

I think we can treat PCI as a special case here and have an interface
that gets used by the PCI core code to talk to the IOMMU core code
when setting up a the dma_map_ops for a PCI function. As long as the
IOMMU driver understands what PCI is, we don't have to describe the
mapping in detail.

> One option is to include an extra cell to the IOMMUs property
> that indicates how to parse it.  For now, only a single value would
> be defined.  For example:
> 
> 	iommus = <&/iommu IOMMU_SIMPLE 42>;
> 
> Then maybe later
> 
> 	iommus = <&/iommu IOMMU_RANGE 0x10000 0x10000>;
> 
> (I'm not suggesting what IOMMU_RANGE might mean.)
> 

This can really be left up to the specific IOMMU driver itself.
We can have drivers that support both #address-cells=<1>
and #address-cells=<2> and behave differently based on that.
I don't see a reason to define that across IOMMU implementations.

> Other options are to introduce a new property name
> 
> 	range-iommus = <&/iommu 0x10000 0x10000>;
> 
> or control the parsing of incompatible iommus properties via a compatible
> string somewhere.

Introducing a new compatible string is always an option as the last resort.

	Arnd
