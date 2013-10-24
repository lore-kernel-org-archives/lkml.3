Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3JXKdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:33:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:20801 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab3JXKdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:33:32 -0400
X-IronPort-AV: E=Sophos;i="4.93,561,1378857600"; 
   d="scan'208";a="66880050"
Date: Thu, 24 Oct 2013 11:32:26 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v8 18/19] swiotlb-xen: no need to do execute two bus_to_phys
 translations in a row
In-Reply-To: <20131023195335.GC28963@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1310241129230.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com> <1382031814-8782-18-git-send-email-stefano.stabellini@eu.citrix.com> <20131023140150.GB27771@phenom.dumpdata.com> <alpine.DEB.2.02.1310231833560.26077@kaball.uk.xensource.com>
 <20131023195335.GC28963@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Oct 2013, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 23, 2013 at 06:34:13PM +0100, Stefano Stabellini wrote:
> > > On Thu, Oct 17, 2013 at 06:43:33PM +0100, Stefano Stabellini wrote:
> > > > xen_unmap_single calls xen_bus_to_phys, then passes dev_addr to
> > > > is_xen_swiotlb_buffer that calls xen_bus_to_phys again.
> > > 
> > > It does?
> > > 
> > > I see it call mfn_to_local_pfn which calls pfn_to_mfn and
> > > get_phys_to_machine (which I presume is going to be a slow
> > > operation on ARM).
> > 
> > Yeah, I am trying to reduce the number of pfn_to_mfn and mfn_to_pfn
> > translations.
> > That said, this patch is not needed to have a fully functional
> > swiotlb-xen on arm and I would OK with postponing it.
> 
> OK, lets do that as it requires some hard thinking.

OK.


> > > I am bit uncomfortable with this - I recall when developing this
> > > that I had hit some odd cases of doing DMA of a page to a guest
> > > and it not always working. It was the case of not detecting whether
> > > the pfn was foreign or not. Sadly I can't recall the details.
> > > 
> > > I would think that this problem would also be present with ARM?
> > > But perhaps all the new changes in the pfn_to_mfn that had lately
> > > been done have fixed this?
> > 
> > No, because on ARM the guest is autotranslate so the pfn returned by
> > mfn_to_pfn is always "local".
> > However thanks to the m2p_override now we should get the "local" pfn
> > from mfn_to_pfn on x86 too.
> > I'll test this case though.
> 
> Right, so maybe the pfn_to_mfn_local test is useless nowadays?

Yes, I think so. This might be better handled by removing
mfn_to_local_pfn altogether.
