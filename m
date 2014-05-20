Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaETLQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:16:10 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:55190 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaETLQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:16:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, iommu@lists.linux-foundation.org,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Date: Tue, 20 May 2014 13:15:48 +0200
Message-ID: <10711669.TTjp9L4tTG@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140520110536.GA10302@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com> <5759340.gycj7cP1t3@wuerfel> <20140520110536.GA10302@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Rexy57gx0FxuBBWuO+CiRZAp9IPcEj02LSuKiuhFTJO
 yMA9ZH+AQC5DANeZY/gMJv2E+GZMXV/grwSoBUuB5GjO0U3zK4
 BnzRDSubjytNhUihTCOUqH1ETFizZoERA2YC7OWw/zQZsHMT3Y
 JZ3wIyIPq+QVE14i6TS2ndDPLjVRewEJ+KA3cIObUgunMapuOC
 XTfJE1uLl7iG29xUlfGkRlbw5tXFc3U1uxj/GiSUk9nPwFVM5v
 LI17icZmweFG8Cp4bzz4SiB3MEGiYUtJ9PYIu7XBHtpKzJycBs
 T9zRD4q5qnCBmvDTu/3pWEAVbsNBsJWniVctddIFAzv2+J8mFq
 LghxVyraMneiG/MxRxfA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2014 13:05:37 Thierry Reding wrote:
> On Tue, May 20, 2014 at 12:04:54PM +0200, Arnd Bergmann wrote:
> > On Monday 19 May 2014 22:59:46 Thierry Reding wrote:
> > > On Mon, May 19, 2014 at 08:34:07PM +0200, Arnd Bergmann wrote:
> > > > On Monday 19 May 2014 14:53:37 Thierry Reding wrote:
> > > > > On Mon, May 19, 2014 at 12:26:35PM +0200, Arnd Bergmann wrote:
> > > > > > On Friday 16 May 2014 14:23:18 Thierry Reding wrote:
> > > > > > > From: Thierry Reding <treding@nvidia.com>
> [...]
> > > > > > Finally, it makes no sense to use the dma-ranges property of the master's
> > > > > > parent bus, because that bus isn't actually involved in the translation.
> > > > > 
> > > > > My understanding here is mostly based on the OpenFirmware working group
> > > > > proposal for the dma-ranges property[0]. I'll give another example to
> > > > > try and clarify how I had imagined this to work:
> > > > > 
> > > > > 	/ {
> > > > > 		#address-cells = <2>;
> > > > > 		#size-cells = <2>;
> > > > > 
> > > > > 		iommu {
> > > > > 			/*
> > > > > 			 * This is somewhat unusual (or maybe not) in that we
> > > > > 			 * need 2 cells to represent the size of an address
> > > > > 			 * space that is 32 bits long.
> > > > > 			 */
> > > > > 			#address-cells = <1>;
> > > > > 			#size-cells = <2>;
> > > > 
> > > > You should never need #size-cells > #address-cells
> > > 
> > > That was always my impression as well. But how then do you represent the
> > > full 4 GiB address space in a 32-bit system? It starts at 0 and ends at
> > > 4 GiB - 1, which makes it 4 GiB large. That's:
> > > 
> > > 	<0 1 0>
> > > 
> > > With #address-cells = <1> and #size-cells = <1> the best you can do is:
> > > 
> > > 	<0 0xffffffff>
> > > 
> > > but that's not accurate.
> > 
> > I think we've done both in the past, either extended #size-cells or
> > taken 0xffffffff as a special token. Note that in your example,
> > the iommu actually needs #address-cells = <2> anyway.
> 
> But it needs #address-cells = <2> only to encode an ID in addition to
> the address. If this was a single-master IOMMU then there'd be no need
> for the ID.

Right. But for a single-master IOMMU, there is no need to specify
any additional data, it could have #address-cells=<0> if we take the
optimization you suggested.

> This really isn't specific to IOMMUs though. It really applies to all
> cases where #address-cells and #size-cells are parsed. While it's way
> too late to change the semantics of standard properties, perhaps for
> properties that are introduced it would make more sense to encode this
> as a <start limit> pair, both of length #address-cells, to avoid this
> type of corner case.
> 
> On the other hand doing so would make it inconsistent with existing
> bindings which may not be desirable either.
> 
> But since it seems like we're headed for something completely different
> for IOMMUs, perhaps it would be worth considering to describe the IOMMU
> range as <start limit>. Since it will likely use #iommu-cells rather
> than #address-cells we have an opportunity to change the semantics.

I'd still prefer #address-cells/#size-cells over #iommu-cells.

> > / {
> > 	#address-cells = <1>;
> > 	#size-cells = <1>;
> > 
> > 	iommu {
> > 		#address-cells = <2>; // ID, address
> > 		#size-cells = <2>;
> > 	};
> > 
> > 	master@a {
> > 		iommus = <& {/iommu} 0xa 0x0  0x1 0x0>; // 4GB ID '0xa'
> > 	}
> > 
> > 	bus1 {
> > 		#address-cells = <1>;
> > 		#size-cells = <1>;
> > 		ranges;
> > 		iommus = <& {/iommu} 0 0   0x100 0>; // all IDs
> > 		dma-ranges = <0  0xb 0  1 0>; // child devices use ID '0xb'
> > 
> > 		anothermaster {
> > 			// no iommus link, implied by dma-ranges above
> > 		};
> > 	};
> > };
> > 
> > If you set #size-cells=<0>, you can't really do that but instead would
> > require an iommus property in each master, which is not a big concern
> > either.
> 
> I'm not sure I understand the need for 0x100 (all IDs) entry above. If
> bus1's iommus property applies to all devices on the bus, why can't the
> ID 0xb be listed in the iommus property?
> 
> 	bus1 {
> 		#address-cells = <1>;
> 		#size-cells = <1>;
> 		ranges;
> 		iommus = <&{/iommu} 0xb 0  0x1 0x0>; // 4GB ID '0xb'
> 		dma-ranges = <0  0xb 0  0x1 0x0>;
> 
> 		anothermaster {
> 			...
> 		};
> 	};

It depends on how the address is interpreted, but we could make this
a valid case too.

> In which case I guess dma-ranges would be redundant.

No, because the iommus property doesn't translate the address range, it
just creates a new address space. bus1 and iommu in the example have
different #address-cells, so you definitely need a non-empty ranges
property.

> > The main advantage I think would be for IOMMUs that use the PCI b/d/f
> > numbers as IDs. These can have #address-cells=<3>, #size-cells=<2>
> > and have an empty dma-ranges property in the PCI host bridge node,
> > and interpret this as using the same encoding as the PCI BARs in
> > the ranges property.
> 
> I'm somewhat confused here, since you said earlier:
> 
> > After giving the ranges stuff some more thought, I have come to the
> > conclusion that using #iommu-cells should work fine for almost
> > all cases, including windowed iommus, because the window is not
> > actually needed in the device, but only in the iommu, wihch is of course
> > free to interpret the arguments as addresses.
> 
> But now you seem to be saying that we should still be using the
> #address-cells and #size-cells properties in the IOMMU node to determine
> the length of the specifier.

I probably wasn't clear. I think we can make it work either way, but
my feeling is that using #address-cells/#size-cells gives us a nicer
syntax for the more complex cases.

	Arnd
