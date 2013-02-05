Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3BESwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:52:32 -0500
Received: from a194-210.smtp-out.amazonses.com ([199.255.194.210]:15600 "EHLO
	a194-210.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754575Ab3BESw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:52:29 -0500
Date: Tue, 5 Feb 2013 18:52:27 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Stephen Warren <swarren@wwwdotorg.org>
cc: James Hogan <james.hogan@imgtec.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
Subject: Re: next-20130204 - bisected slab problem to "slab: Common constants
 for kmalloc boundaries"
In-Reply-To: <51114F53.4030603@wwwdotorg.org>
Message-ID: <0000013cabb3b91e-d00eb224-6ced-43b8-aa10-d7afeab8c037-000000@email.amazonses.com>
References: <510FE051.7080107@imgtec.com> <51100E79.9080101@wwwdotorg.org> <alpine.DEB.2.02.1302042019170.32396@gentwo.org> <0000013cab3780f7-5e49ef46-e41a-4ff2-88f8-46bf216d677e-000000@email.amazonses.com> <51114F53.4030603@wwwdotorg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, Stephen Warren wrote:

> > +/*
> > + * Some archs want to perform DMA into kmalloc caches and need a guaranteed
> > + * alignment larger than the alignment of a 64-bit integer.
> > + * Setting ARCH_KMALLOC_MINALIGN in arch headers allows that.
> > + */
> > +#if defined(ARCH_DMA_MINALIGN) && ARCH_DMA_MINALIGN > 8
> > +#define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
> > +#define KMALLOC_MIN_SIZE ARCH_DMA_MINALIGN
>
> I might be tempted to drop that #define of KMALLOC_MIN_SIZE ...

Initially I thought so too.
>
> > +#define KMALLOC_SHIFT_LOW ilog2(ARCH_DMA_MINALIGN)
> > +#else
> > +#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
> > +#endif
>
> > +#ifndef KMALLOC_MIN_SIZE
> >  #define KMALLOC_MIN_SIZE (1 << KMALLOC_SHIFT_LOW)
> >  #endif
>
> ... and simply drop the ifdef around that #define instead.

That is going to be one hell of a macro expansion.

> That way, KMALLOC_MIN_SIZE is always defined in one place, and derived
> from KMALLOC_SHIFT_LOW; the logic will just set KMALLOC_SHIFT_LOW based
> on the various conditions. This seems a little safer to me; fewer
> conditions and less code to update if anything changes.

Yeah but we do an ilog2 and then reverse this back to the original number.

