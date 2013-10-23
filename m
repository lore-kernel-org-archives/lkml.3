Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab3JWOh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 10:37:58 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54159 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750949Ab3JWOh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 10:37:57 -0400
Date: Wed, 23 Oct 2013 15:37:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: allow ioremap_cache() to use existing RAM mappings
Message-ID: <20131023143717.GA19317@mbp>
References: <1382362594-24947-1-git-send-email-msalter@redhat.com>
 <1382519898.10408.1.camel@mbp>
 <1382535972.1768.68.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382535972.1768.68.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 02:46:12PM +0100, Mark Salter wrote:
> On Wed, 2013-10-23 at 10:18 +0100, Catalin Marinas wrote:
> > On Mon, 2013-10-21 at 14:36 +0100, msalter@redhat.com wrote:
> > > diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> > > index 1725cd6..fb44b3d 100644
> > > --- a/arch/arm64/mm/ioremap.c
> > > +++ b/arch/arm64/mm/ioremap.c
> > > @@ -79,6 +79,21 @@ void __iounmap(volatile void __iomem *io_addr)
> > >  {
> > >  	void *addr = (void *)(PAGE_MASK & (unsigned long)io_addr);
> > >  
> > > +	/* Nothing to do for normal memory. See ioremap_cache() */
> > > +	if (pfn_valid(__virt_to_phys(addr) >> PAGE_SHIFT))
> > > +		return;
> > 
> > addr here can be some I/O address mapped previously, so __virt_to_phys()
> > is not valid (you don't actually get the pfn by shifting).
> > 
> 
> Yeah, that's ugly. The thought was that only the kernel mapping of RAM
> would yield a valid address from __virt_to_phys(). Anything else, like
> a mapping of I/O space would lead to an invalid PFN. There's probably a
> clearer way of doing that that. Other than that, is the general concept
> of the patch reasonable?

I think the concept is fine. You could change the check on
VMALLOC_START/END or just always create a new mapping as long as it has
the same caching attributes (PROT_NORMAL).

-- 
Catalin
