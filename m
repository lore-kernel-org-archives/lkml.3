Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbaBUATx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:19:53 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:19570 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932242AbaBUATv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 19:19:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsMHADGbBlN5LJYe/2dsb2JhbABZgwa7UYVRgQ8XdIIlAQEEATocIwULCAMOCgkaCw8FJQMhE4d9B81JFxaOTgeEOASYL4pQh1WBb4FSKA
Date: Fri, 21 Feb 2014 11:19:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: David Howells <dhowells@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        akpm <akpm@linux-foundation.org>, cl@linux-foundation.org
Subject: Re: Has slab ctor operation changed? -- was [PATCH 1/1] afs:
 afs_alloc_inode: use kmem_cache_zalloc
Message-ID: <20140221001946.GV4916@dastard>
References: <20140220211612.506074a7fd876e47130a8c5c@skynet.be>
 <32740.1392934995@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32740.1392934995@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 10:23:15PM +0000, David Howells wrote:
> Fabian Frederick <fabf@skynet.be> wrote:
> 
> > afs_vnode is currently cleared with 2 memsets after allocation and 
> > 1 in constructor (afs_i_init_once).
> > 	-This patch calls zalloc for explicit zero fill.
> 
> Ummm...  This patch isn't necessarily correct in the substantiative portions.
> 
> Since afs_i_init_once() is called by the slab allocator during the course of
> kmem_cache_alloc(), how does kmem_cache_zalloc() interact with that?

It breaks it. ;)

> IIRC, it used to be that the ctor() function was called when the pages were
> allocated to the slab - and it wasn't called again, even if the object was
> allocated, deallocated and reallocated.  This means that things like locks and
> lists don't need reinitialising after allocation.
> 
> So afs_i_init_once() theoretically constructs the stuff that can be reused,
> and afs_alloc_inode() therefore has to clear the non-reusable state.
> 
> Of course, it's possible that the slab allocator no longer works like this...

AFAIA the slab constructor behaviour has not changed. If it did, I'm
pretty sure most filesystems would end up with inode cache problems
because most of them rely on this ctor behaviour to avoid
unnecessary reinitialisation of inode state....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
