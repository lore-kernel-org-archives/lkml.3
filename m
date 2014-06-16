Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbaFPRcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:32:32 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:63630 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaFPRc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:32:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Cc: Stuart Yoder <stuart.yoder@freescale.com>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
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
Date: Mon, 16 Jun 2014 19:30:19 +0200
Message-ID: <5115654.pRN5gLfQMp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140616170416.GA16758@arm.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com> <8b0492b4697943a0b1f276ef42cc8223@DM2PR03MB352.namprd03.prod.outlook.com> <20140616170416.GA16758@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:M7UlQw8L7RlIhyhJVS+YDLBhPWsMYWMRCYzTgLw/GUg
 aHe7SOThJ0ujexd+RCqyjtClYpTW7aSTdNkTz6LbUGULKdL38Q
 kgfzDzLjbpOMkRlR/N96jJm9EHrenJ1TXVA1a4PAHy4bR4F/vP
 OmWxzr/1ezfdSFv8hak39gH/9qTB8Cb/y8dc+n2g8sN5yXQjGx
 77V9/ZfaFT8uBBzy0gTNpjvfBSpDcQQj0OOgl8WSr8VutGQ4T7
 SJa5M68byhIKFk2cptoCaEKUeWbLBrEgcBVeBbGZS3VT87aKmw
 ZSWy3dC6uTWAqKNjARndTaZPAbLQrMEhhUItDCzr0/sEP+5FYX
 zJ3Dku38sX/O6722N/Os=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 June 2014 18:04:16 Will Deacon wrote:
> 
> On Mon, Jun 16, 2014 at 05:56:32PM +0100, Stuart Yoder wrote:
> > > Do you have use-cases where you really need to change these mappings
> > > dynamically?
> > 
> > Yes.  In the case of a PCI bus-- you may not know in advance how many
> > PCI devices there are until you probe the bus.   We have another FSL
> > proprietary bus we call the "fsl-mc" bus that is similar.
> 
> For that case, though, you could still describe an algorithmic
> transformation from RequesterID to StreamID which corresponds to a fixed
> mapping.

It sounds to me like the best option here would be to have only the
RequesterID passed in the "iommus" property and have the StreamID
dynamically assigned. This would mean we treat the StreamID as
the context.

> > Another thing to consider-- starting with SMMUv2, as you know, there
> > is a new distributed architecture with multiple TBUs and a centralized
> > TCU that walks the SMMU page tables.  So instead of sprinkling multiple
> > SMMUs all over an SoC you now have the option a 1 central TCU and sprinkling
> > multiple TBUs around.   However, this means that the stream ID namespace
> > is now global and can be pretty limited.  In the SMMU implementation we 
> > have there are only 64 stream ID total for our Soc.  But we have many more
> > masters than that.
> > 
> > So we look at stream IDs as really corresponding to an 'isolation context'
> > and not to a bus master.  An isolation context is the domain you are
> > trying to isolate with the SMMU.  Devices that all belong to the same
> > 'isolation context' can share the same stream ID, since they share
> > the same domain and page tables.
> 
> Ok, this is more compelling.

This also makes sense from the kernel's perspective: The shared Stream ID
is the one that is used by the dma-mapping API here, while all other
Stream IDs would only be used if you have things like PCI device assignment
or GPU contexts that map into IOMMU contexts using the Linux IOMMU
abstraction, which is a lower-level interface than the dma-mapping
abstraction.

	Arnd
