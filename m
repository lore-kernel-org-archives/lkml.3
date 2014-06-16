Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaFPREY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:04:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54565 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754702AbaFPREW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:04:22 -0400
Date: Mon, 16 Jun 2014 18:04:16 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stuart Yoder <stuart.yoder@freescale.com>
Cc: Varun Sethi <Varun.Sethi@freescale.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140616170416.GA16758@arm.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com>
 <4545972.cM7IP1qTXQ@wuerfel>
 <CAL_Jsq+tkFNpjSEZboT+o69B_Z3a8e-ZVKaYDmLwtkyYoPy6VQ@mail.gmail.com>
 <5288123.eXagyPAxNq@wuerfel>
 <20140602104104.GD3855@e103592.cambridge.arm.com>
 <20140604143509.GF28484@ulmo>
 <20140604164132.GF6644@arm.com>
 <07321368d15d4ad9928ebb83af87e401@DM2PR03MB479.namprd03.prod.outlook.com>
 <20140616152739.GS16758@arm.com>
 <8b0492b4697943a0b1f276ef42cc8223@DM2PR03MB352.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b0492b4697943a0b1f276ef42cc8223@DM2PR03MB352.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stuart,

On Mon, Jun 16, 2014 at 05:56:32PM +0100, Stuart Yoder wrote:
> > Do you have use-cases where you really need to change these mappings
> > dynamically?
> 
> Yes.  In the case of a PCI bus-- you may not know in advance how many
> PCI devices there are until you probe the bus.   We have another FSL
> proprietary bus we call the "fsl-mc" bus that is similar.

For that case, though, you could still describe an algorithmic
transformation from RequesterID to StreamID which corresponds to a fixed
mapping.

> Another thing to consider-- starting with SMMUv2, as you know, there
> is a new distributed architecture with multiple TBUs and a centralized
> TCU that walks the SMMU page tables.  So instead of sprinkling multiple
> SMMUs all over an SoC you now have the option a 1 central TCU and sprinkling
> multiple TBUs around.   However, this means that the stream ID namespace
> is now global and can be pretty limited.  In the SMMU implementation we 
> have there are only 64 stream ID total for our Soc.  But we have many more
> masters than that.
> 
> So we look at stream IDs as really corresponding to an 'isolation context'
> and not to a bus master.  An isolation context is the domain you are
> trying to isolate with the SMMU.  Devices that all belong to the same
> 'isolation context' can share the same stream ID, since they share
> the same domain and page tables.

Ok, this is more compelling.

> So, perhaps by default some/most SMMU masters may have a default stream ID
> of 0x0 that is used by the host...and that could be represented
> statically in the device tree.
> 
> But, we absolutely will need to dynamically set new stream IDs
> into masters when a new IOMMU 'domain' is created and devices
> are added to it.   All the devices in a domain will share
> the same stream ID.
> 
> So whatever we do, let's please have an architecture flexible enough
> to allow for this.

What is the software interface to the logic that assigns the StreamIDs? Is
it part of the SMMU, or a separate device (or set of devices)?

Will
