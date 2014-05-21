Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaEUIv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:51:26 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:60126 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaEUIvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:51:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
        iommu@lists.linux-foundation.org, Kumar Gala <galak@codeaurora.org>,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Date: Wed, 21 May 2014 10:50:38 +0200
Message-ID: <4367469.BqpJyVF8PT@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140521082606.GB11068@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com> <5612206.Fzsy1mf3q3@wuerfel> <20140521082606.GB11068@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dyA8deIKG+pK+FwBt6EPa3eMzLDkFdQR4m8JlreLYTv
 71y41QFlX4oKFb9HAQEUKTPwVhZIY6pRybaGThyRt7kTuvUe5K
 s87KRabfh6ejyMrjYH0PCfUCenc8KlPAQ4/Qstqg2ZoKs6HElb
 1fSPmlCprXP0NUqTL2GQpl8WGsCz7VzuhI83ygVIsU6RbDfXt4
 j9Jmi0kLMzL9FI4UuNuuthIDJ0zCIrjc1dlLMPz0YAEH0ef2dj
 ghMiVTP964Ou2sATM9Tpl4u5rrFf6FsW/A//1N/Yj0G9tBFNYv
 pLB9UXtXrtcUTGAAu/vSoYxdcOZMylyN+8ofag4g8B/lc1KbMp
 bmU2wq+KYfEB84dP5pr4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2014 10:26:11 Thierry Reding wrote:
> On Tue, May 20, 2014 at 10:26:12PM +0200, Arnd Bergmann wrote:
> > On Tuesday 20 May 2014 16:24:59 Dave Martin wrote:
> > > On Tue, May 20, 2014 at 02:41:18PM +0200, Arnd Bergmann wrote:
> > > > On Tuesday 20 May 2014 14:02:43 Thierry Reding wrote:
> [...]
> > > > > Multiple-master IOMMU:
> > > > > ----------------------
> > > > > 
> > > > > 	iommu {
> > > > > 		/* the specifier represents the ID of the master */
> > > > > 		#address-cells = <1>;
> > > > > 		#size-cells = <0>;
> > > 
> > > How do we know the size of the input address to the IOMMU?  Do we
> > > get cases for example where the IOMMU only accepts a 32-bit input
> > > address, but some 64-bit capable masters are connected through it?
> > 
> > I was stuck on this question for a while before, but then I realized
> > that it doesn't matter at all: It's the IOMMU driver itself that
> > manages the address space, and it doesn't matter if a slave can
> > address a larger range than the IOMMU can accept. If the IOMMU
> > needs to deal with the opposite case (64-bit input addresses
> > but a 32-bit master), that limitation can be put into the specifier.
> 
> Isn't this what DMA masks are for? Couldn't the IOMMU simply use the
> master device's DMA mask to do the right thing here?

Ah, yes. I guess that's the right way to do it.

> > > For determining dma masks, it is the output address that it
> > > important.  Santosh's code can probably be taught to handle this,
> > > if given an additional traversal rule for following "iommus"
> > > properties.  However, deploying an IOMMU whose output address size
> > > is smaller than the 
> > 
> > Something seems to be missing here. I don't think we want to handle
> > the case where the IOMMU output cannot the entire memory address
> > space. If necessary, that would mean using both an IOMMU driver
> > and swiotlb, but I think it's a reasonable assumption that hardware
> > isn't /that/ crazy.
> 
> Similarily, should the IOMMU not be treated like any other device here?
> Its DMA mask should determine what address range it can access.

Right. But for that we need a dma-ranges property in the parent of the
iommu, just so the mask can be set correctly and we don't have to
rely on the 32-bit fallback case.

	Arnd
