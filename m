Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaKKLHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:07:50 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:34192 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaKKLHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:07:47 -0500
X-IronPort-AV: E=Sophos;i="5.07,360,1413244800"; 
   d="scan'208";a="191513721"
Date: Tue, 11 Nov 2014 11:07:32 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 03/13] xen/arm: if(pfn_valid(pfn)) call native
 dma_ops
In-Reply-To: <20141110184111.GH25609@e104818-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1411111106320.26318@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com> <1415636045-24669-3-git-send-email-stefano.stabellini@eu.citrix.com> <20141110184111.GH25609@e104818-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, Catalin Marinas wrote:
> On Mon, Nov 10, 2014 at 04:13:55PM +0000, Stefano Stabellini wrote:
> >  void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
> >  		size_t size, enum dma_data_direction dir,
> > -		struct dma_attrs *attrs);
> > +		struct dma_attrs *attrs)
> > +{
> > +	unsigned long pfn = PFN_DOWN(handle);
> > +	/* Dom0 is mapped 1:1, so calling pfn_valid on a foreign mfn will
> > +	 * always return false. If the page is local we can safely call the
> > +	 * native dma_ops function, otherwise we call the xen specific
> > +	 * function. */
> > +	if (pfn_valid(pfn)) {
> > +		if (__generic_dma_ops(hwdev)->unmap_page)
> > +			__generic_dma_ops(hwdev)->unmap_page(hwdev, handle, size, dir, attrs);
> 
> Similarly here, do we need the unmap_page check? dma_map_page() does not
> do it.

I think we do not need the map_page check, because that's always
implemented, but we need the unmap_page check. In fact
arm_coherent_dma_ops doesn't have unmap_page for example.
