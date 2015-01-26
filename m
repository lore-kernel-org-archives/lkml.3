Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbbAZDZL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 22:25:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbbAZDZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 22:25:09 -0500
Date: Mon, 26 Jan 2015 11:22:36 +0800
From: Baoquan He <bhe@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 2/3] x86, swiotlb: Try coherent allocations with
 __GFP_NOWARN
Message-ID: <20150126032236.GN2461@dhcp-16-105.nay.redhat.com>
References: <1420555874-11506-1-git-send-email-joro@8bytes.org>
 <1420555874-11506-3-git-send-email-joro@8bytes.org>
 <20150123170306.GH22635@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123170306.GH22635@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/15 at 06:03pm, Borislav Petkov wrote:
> On Tue, Jan 06, 2015 at 03:51:13PM +0100, Joerg Roedel wrote:
> > From: Joerg Roedel <jroedel@suse.de>

> > diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> > index 77dd0ad..79b2291 100644
> > --- a/arch/x86/kernel/pci-swiotlb.c
> > +++ b/arch/x86/kernel/pci-swiotlb.c
> > @@ -20,6 +20,14 @@ void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
> >  {
> >  	void *vaddr;
> >  
> > +	/*
> > +	 * When booting a kdump kernel in high memory these allocations are very
> > +	 * likely to fail, as there are by default only 8MB of low memory to
> > +	 * allocate from. So disable the warnings from the allocator when this
> > +	 * happens.  SWIOTLB also implements fall-backs for failed allocations.
> > +	 */
> > +	flags |= __GFP_NOWARN;
> 
> Ok, so this practically does all allocations __GFP_NOWARN now. Shouldn't
> you be doing this before swiotlb_alloc_coherent() and not before
> dma_generic_alloc_coherent()?

I think this patch mainly suppress warning from buddy allocation
failure because it tried buddy allocation several times before the final
try of bounce buffer allocation. Buddy allocation failure will call
dump_stack.


> 
> >  	vaddr = dma_generic_alloc_coherent(hwdev, size, dma_handle, flags,
> >  					   attrs);
> >  	if (vaddr)
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> ECO tip #101: Trim your mails when you reply.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
