Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3AXKB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:01:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab3AXKB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:01:56 -0500
Date: Thu, 24 Jan 2013 12:06:00 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Romain Francoise <romain@orebokech.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-net: fall back to vmalloc if high-order allocation
 fails
Message-ID: <20130124100600.GB8710@redhat.com>
References: <87k3r31vbc.fsf@silenus.orebokech.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B711E@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B711E@saturn3.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 09:45:50AM -0000, David Laight wrote:
> > +	n = kmalloc(sizeof *n, GFP_KERNEL | __GFP_NOWARN);
> > +	if (!n)
> > +		n = vmalloc(sizeof *n);
> 
> I'm slightly confused by this construct.
> I thought kmalloc(... GFP_KERNEL) would sleep waiting for
> memory (rather than return NULL).
> 
> I realise that (for multi-page sizes) that kmalloc() and
> vmalloc() both need to find a contiguous block of kernel
> virtual addresses - in different address ranges, and
> that vmalloc() then has to find physical memory pages
> (which will not be contiguous).
> 
> I think this means that kmalloc() is likely to be faster
> (if it doesn't have to sleep), but that vmalloc() is
> allocating from a much larger resource.
> 
> This make me that that large allocations that are not
> temporary should probably be allocated with vmalloc().

vmalloc has some issues for example afaik it's not backed by
a huge page so  I think its use puts more stress on the TLB cache.

> Is there a 'NO_SLEEP' flag to kmalloc()? is that all
> GFP_ATOMIC requests? If so you might try a non-sleeping
> kmalloc() with a vmalloc() if it fails.
> 
> This all looks as though there should be a GFP_NONCONTIG
> flag (or similar) so that kmalloc() can make a decision itself.
> 
> Of at least a wrapper - like the one for free().
> 
> 	David
> 
> 
