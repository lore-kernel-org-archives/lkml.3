Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3JBQ0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:26:14 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54344 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753593Ab3JBQ0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:26:12 -0400
Date: Wed, 2 Oct 2013 17:25:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christoph Lameter <cl@linux.com>
Cc: "Bird, Tim" <Tim.Bird@sonymobile.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Bobniev, Roman" <Roman.Bobniev@sonymobile.com>,
        =?iso-8859-1?Q?Andersson=2C_Bj=F6rn?= 
	<Bjorn.Andersson@sonymobile.com>
Subject: Re: [PATCH] slub: Proper kmemleak tracking if CONFIG_SLUB_DEBUG
 disabled
Message-ID: <20131002162528.GD29794@arm.com>
References: <5245ECC3.8070200@gmail.com>
 <00000141799dd4b3-f6df96c0-1003-427d-9bd8-f6455622f4ea-000000@email.amazonses.com>
 <F5184659D418E34EA12B1903EE5EF5FD8538E86615@seldmbx02.corpusers.net>
 <0000014179e31953-a05dd7d1-d0f8-474f-810a-809cd8a724f8-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014179e31953-a05dd7d1-d0f8-474f-810a-809cd8a724f8-000000@email.amazonses.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 04:57:12PM +0100, Christoph Lameter wrote:
> On Wed, 2 Oct 2013, Bird, Tim wrote:
> 
> > The problem child is actually the unconditional call to kmemleak_alloc()
> > in kmalloc_large_node() (in slub.c).  The problem comes because that call
> > is unconditional on CONFIG_SLUB_DEBUG but the kmemleak
> > calls in the hook routines are conditional on CONFIG_SLUB_DEBUG.
> > So if you have CONFIG_SLUB_DEBUG=n but CONFIG_DEBUG_KMEMLEAK=y,
> > you get the false reports.
> 
> Right. You need to put the #ifdef CONFIG_SLUB_DEBUG around the hooks that
> need it in the function itself instead of disabling the whole function if
> CONFIG_SLUB_DEUBG is not set.

If we are to do this, we also need a DEBUG_KMEMLEAK dependency,
something like:

	depends on (SLUB && SLUB_DEBUG) || !SLUB

or

	select SLUB_DEBUG if SLUB

Otherwise you get a lot of false positives.

But with any of the above, #ifdef'ing out kmemleak_* calls wouldn't make
much difference since they would already be no-ops in kmemleak.h with
!SLUB_DEBUG.

> > Personally, I like the idea of keeping bookeeping/tracing/debug stuff in hook
> > routines.  I also like de-coupling CONFIG_SLUB_DEBUG and CONFIG_DEBUG_KMEMLEAK,
> > but maybe others have a different opinon.  Unless someone speaks up, we'll
> > move the the currently in-function kmemleak calls into hooks, and all of the
> > kmemleak stuff out from under CONFIG_SLUB_DEBUG.
> > We'll have to see if the ifdefs get a little messy.
> 
> Decouple of you want. CONFIG_SLUB_DEBUG may duplicate what you already do.

I would prefer the decoupling but I'm fine either way (as long as the
dependencies are in place).

-- 
Catalin
