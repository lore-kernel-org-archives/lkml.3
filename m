Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab3JRPrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:47:03 -0400
Received: from smtp.citrix.com ([66.165.176.89]:65457 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320Ab3JRPrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:47:00 -0400
X-IronPort-AV: E=Sophos;i="4.93,523,1378857600"; 
   d="scan'208";a="65042898"
Date: Fri, 18 Oct 2013 16:46:00 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>, <will.deacon@arm.com>
Subject: Re: [PATCH v8 08/19] arm/xen: get_dma_ops: return xen_dma_ops if we
 are running as xen_initial_domain
In-Reply-To: <20131018154246.GB25034@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1310181643260.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com> <1382031814-8782-8-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1310181319300.26077@kaball.uk.xensource.com> <20131018154246.GB25034@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013, Russell King - ARM Linux wrote:
> On Fri, Oct 18, 2013 at 01:22:18PM +0100, Stefano Stabellini wrote:
> > Russell,
> > are you OK with this patch?
> 
> Only concern is why the change is soo large.
> 
> > > -static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> > > +static inline struct dma_map_ops *__generic_dma_ops(struct device *dev)
> > >  {
> > >  	if (dev && dev->archdata.dma_ops)
> > >  		return dev->archdata.dma_ops;
> > >  	return &arm_dma_ops;
> > >  }
> > >  
> > > +static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> > > +{
> > > +	if (xen_initial_domain())
> > > +		return xen_dma_ops;
> > > +	else
> > > +		return __generic_dma_ops(dev);
> > > +}
> > > +
> 
> What's wrong with:
> 
>  static inline struct dma_map_ops *get_dma_ops(struct device *dev)
>  {
> +	if (xen_initial_domain())
> +		return xen_dma_ops;
>  	if (dev && dev->archdata.dma_ops)
>  		return dev->archdata.dma_ops;
>  	return &arm_dma_ops;
>  }


xen_dma_ops functions might have to call back the native implementation.
With the above there is no way for a xen_dma_ops function to get to
archdata.dma_ops or arm_dma_ops.
This is the reason why this patch introduces __generic_dma_ops.
