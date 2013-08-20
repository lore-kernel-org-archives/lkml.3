Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751005Ab3HTLts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 07:49:48 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:2907 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab3HTLtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:49:47 -0400
X-IronPort-AV: E=Sophos;i="4.89,919,1367964000"; 
   d="scan'208";a="29841558"
Date: Tue, 20 Aug 2013 13:49:26 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Will Deacon <will.deacon@arm.com>
cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] iommu/arm: replace devm_request_and_ioremap by
 devm_ioremap_resource
In-Reply-To: <20130820113503.GC23007@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1308201348570.2269@hadrien>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr> <1376911241-27720-4-git-send-email-Julia.Lawall@lip6.fr> <20130820113503.GC23007@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Aug 2013, Will Deacon wrote:

> Hi Julia,
>
> On Mon, Aug 19, 2013 at 12:20:37PM +0100, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > Use devm_ioremap_resource instead of devm_request_and_ioremap.
> >
> > This was partly done using the semantic patch
> > scripts/coccinelle/api/devm_ioremap_resource.cocci
> >
> > The error-handling code on the call to platform_get_resource was removed
> > manually, and the initialization of smmu->size was manually moved lower, to
> > take advantage of the NULL test on res performed by devm_ioremap_resource.
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > ---
> >  drivers/iommu/arm-smmu.c |   11 +++--------
> >  1 file changed, 3 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> > index ebd0a4c..dd91465 100644
> > --- a/drivers/iommu/arm-smmu.c
> > +++ b/drivers/iommu/arm-smmu.c
> > @@ -1761,15 +1761,10 @@ static int arm_smmu_device_dt_probe(struct platform_device *pdev)
> >  	smmu->dev = dev;
> >
> >  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > -	if (!res) {
> > -		dev_err(dev, "missing base address/size\n");
> > -		return -ENODEV;
> > -	}
> > -
> > +	smmu->base = devm_ioremap_resource(dev, res);
> > +	if (IS_ERR(smmu->base))
> > +		return PTR_ERR(smmu->base);
> >  	smmu->size = resource_size(res);
> > -	smmu->base = devm_request_and_ioremap(dev, res);
> > -	if (!smmu->base)
> > -		return -EADDRNOTAVAIL;
>
> This does mean we trade arguably more useful error codes for the catch-all
> -EINVAL, but the code ends up looking neater so I can be swayed either way.
>
> Is this part of a series you're dealing with, or would you like me to take
> this (I already sent my SMMU patches for 3.12)?

Please take it onwards.  Thanks.

julia
