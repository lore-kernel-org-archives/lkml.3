Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaEUJh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:37:26 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:60649 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaEUJhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:37:23 -0400
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
Date: Wed, 21 May 2014 11:36:32 +0200
Message-ID: <5371868.4QO1YJ0hU2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140521090037.GA19268@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com> <4367469.BqpJyVF8PT@wuerfel> <20140521090037.GA19268@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:U1Bp0FNQX4vJn864ZYmoM+Ks7oOEFKs/D2rmWeosRqx
 LNgTDuN3X+YplO61VNq9O9LkF+V5dNX62Mya0AylWtEyyMXKzU
 aO/QoMoM25emKKnYCHFj1bVobG9oazX6d2yEqhlVV3zRA5hgws
 gOV+2nKmWg0iCKyCG6NSTqzFBGjQ58rI/KevGKm8DxuLyT/2QA
 9ZZVLzEghQkOktQyKokNWfPTfnlxM38fDgfSCxPLUZtuu5KxPY
 Z4wRxpFORocciuiuniCRSX4EIoNihlvXywlc/06xmMhGKs2Owg
 NC9iZob2AUFfLFkN5xOWQvyJn0zO+OO1LFMTlSH1A90j8UZqVE
 Yc0I0D1gMa7nBaX6Pezc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2014 11:00:38 Thierry Reding wrote:
> On Wed, May 21, 2014 at 10:50:38AM +0200, Arnd Bergmann wrote:
> > On Wednesday 21 May 2014 10:26:11 Thierry Reding wrote:

> > > > > For determining dma masks, it is the output address that it
> > > > > important.  Santosh's code can probably be taught to handle this,
> > > > > if given an additional traversal rule for following "iommus"
> > > > > properties.  However, deploying an IOMMU whose output address size
> > > > > is smaller than the 
> > > > 
> > > > Something seems to be missing here. I don't think we want to handle
> > > > the case where the IOMMU output cannot the entire memory address
> > > > space. If necessary, that would mean using both an IOMMU driver
> > > > and swiotlb, but I think it's a reasonable assumption that hardware
> > > > isn't /that/ crazy.
> > > 
> > > Similarily, should the IOMMU not be treated like any other device here?
> > > Its DMA mask should determine what address range it can access.
> > 
> > Right. But for that we need a dma-ranges property in the parent of the
> > iommu, just so the mask can be set correctly and we don't have to
> > rely on the 32-bit fallback case.
> 
> Shouldn't the IOMMU driver be the one to set the DMA mask for the device
> in exactly the same way that other drivers override the 32-bit default?

The IOMMU driver could /ask/ for an appropriate mask based on its internal
design, but if you have an IOMMU with a 64-bit output address connected
to a 32-bit bus, that should fail.

Note that it's not obvious what the IOMMU's DMA mask actually means.
It clearly has to be the mask that is used for allocating the IO page
tables, but it wouldn't normally be used in the path that allocates
pages on behalf of a DMA master attached to the IOMMU, because that
allocation is performed by the code that looks at the other device's
dma mask.

	Arnd
