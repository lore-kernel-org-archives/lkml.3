Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaFEJnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:43:08 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56051 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaFEJnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:43:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>,
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
Date: Thu, 05 Jun 2014 11:42:12 +0200
Message-ID: <6794037.0YTCc6JFQV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140604213159.GB18780@mithrandir>
References: <1400877395-4235-1-git-send-email-thierry.reding@gmail.com> <4830064.JvgTAs8Xty@wuerfel> <20140604213159.GB18780@mithrandir>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:yYAghirob7CGtXfYNEqoxhraT2j+yLohYnioRr2RDEo
 GsOkOucAve+RoKkJGVCUnmarVUJ5YXvCkDwBL3Z3iJ4x7BNJZK
 Zqmvelp5ut6o4W+YFu7BK69U+5ePi1ycsPhH12mUO4jusCYVV2
 sSlYEG8iXq+Y8Lv7bb5fdocWsNhYflHOnXOqYwzAq3JAkBc2s4
 vSdJeU7Ibj+mjPEGnEGM1+pqBJ+JqA0EobmmuwKeePmWIju0T0
 9kSPNPqAFOiIealSPP6MzuP1xNpZbnjUutUgEY8tQjBoX7XpiE
 NwnwPkIz4AXY9JyTVoZxCxbyTkyHIZgE1cwDsv5KgD3+o8ILhb
 6Wl8gwb0n5fUQMYcrU0w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2014 23:32:00 Thierry Reding wrote:
> On Fri, May 30, 2014 at 09:01:19PM +0200, Arnd Bergmann wrote:
> > On Friday 30 May 2014 12:22:32 Dave Martin wrote:
> > > > +
> > > > +Examples:
> > > > +=========
> > > > +
> > > > +Single-master IOMMU:
> > > > +--------------------
> > > > +
> > > > + iommu {
> > > > +         #address-cells = <0>;
> > > > +         #size-cells = <0>;
> > > > + };
> > > > +
> > > > + master {
> > > > +         iommus = <&/iommu>;
> > > > + };
> > > > +
> > > > +Multiple-master IOMMU with fixed associations:
> > > > +----------------------------------------------
> > > > +
> > > > + /* multiple-master IOMMU */
> > > > + iommu {
> > > > +         /*
> > > > +          * Masters are statically associated with this IOMMU and
> > > > +          * address translation is always enabled.
> > > > +          */
> > > > +         #address-cells = <0>;
> > > > +         #size-cells = <0>;
> > > 
> > > In this example, can different translations be set up for the different
> > > masters?
> > > 
> > > With no cells available to contain any sort of ID, it looks like this
> > > is not possible.
> > 
> > Correct, this example is for an IOMMU that does not use IDs but has a
> > shared address space for all devices.
> 
> Couldn't these device all still have separate address spaces?

No. If they had separate address spaces, they would require a more
sophisticated IOMMU. A simple IOMMU without IDs can only be used
for overcoming address space limits (e.g. for 32-bit DMA masters on
systems with more than 4GB RAM) but not for strict isolation.

You basically have one page table shared across all devices connected
to the IOMMU, and every call to dma_alloc_coherent or dma_map_*
allocates a new IOVA that isn't used by any of the other devices
already, but you can't prevent a malicious user from getting a device
to do DMA to an IOVA that has been set up for another device.

You could have one such IOMMU per device of course, but I guess that's
not what you mean.

	Arnd
