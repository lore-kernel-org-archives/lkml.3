Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab3H3NWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:22:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39701 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab3H3NWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:22:46 -0400
Date: Fri, 30 Aug 2013 09:22:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 10/10] xen/arm,arm64: enable SWIOTLB_XEN
Message-ID: <20130830132210.GE21239@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
 <1376565054-24153-10-git-send-email-stefano.stabellini@eu.citrix.com>
 <1376600325.9273.223.camel@hastur.hellion.org.uk>
 <alpine.DEB.2.02.1308282104000.6397@kaball.uk.xensource.com>
 <1377765650.11455.7.camel@kazak.uk.xensource.com>
 <alpine.DEB.2.02.1308291637230.6397@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308291637230.6397@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 04:38:17PM +0100, Stefano Stabellini wrote:
> On Thu, 29 Aug 2013, Ian Campbell wrote:
> > On Wed, 2013-08-28 at 21:07 +0100, Stefano Stabellini wrote:
> > > On Thu, 15 Aug 2013, Ian Campbell wrote:
> > > > On Thu, 2013-08-15 at 12:10 +0100, Stefano Stabellini wrote:
> > > > > At the moment always rely on swiotlb-xen, but when Xen starts supporting
> > > > > hardware IOMMUs we'll be able to avoid it conditionally on the presence
> > > > > of an IOMMU on the platform.
> > > > 
> > > > Do we have any idea how we are going to do this?
> > > > 
> > > > It's extra complicated if you consider that on some systems on some of
> > > > the devices are behind an IOMMU :-/
> > > > 
> > > > I wonder if we can enumerate which devices have an IOMMU at boot time
> > > > and force a ludicrous dma mask (such as 0) if one isn't present in order
> > > > to force us to always take the exchange_and_pin path?
> > > 
> > > We don't need to worry about how to specify which devices need to go via
> > > the swiotlb internally, because we have our own arm specific
> > > dma_map_ops. At the moment they are just implemented using the
> > > swiotlb-xen functions, but we could easily provide wrappers that check
> > > our own internal whitelist/blacklist and go via swiotlb-xen only in
> > > those cases.
> > 
> > OK, but how do we decide which devices go on those lists? We need some
> > sort of indication from the hypervisor, don't we? Only Xen knows if it
> > has an iommu it can use because the iommu must necessarily be hidden
> > from Linux.
> 
> Right. Maybe Xen could mark the devices that are safe to use without
> swiotlb-xen on device tree? Adding a property to the node?

We do a hypercall for adding devices (See drivers/xen/pci.c). Perhaps
you can piggyback on that one and on ARM return 0 for the devices that
are under Xen control (so IOMMU) and for non-Xen control (those
that will need SWIOTLB) return -EYOUNEEDTOHANDLEIT and use it?
