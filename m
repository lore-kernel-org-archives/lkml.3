Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaE0OrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:47:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:38090 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaE0OrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:47:02 -0400
Date: Tue, 27 May 2014 16:46:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@intel.com>
Subject: Re: [RFC][PATCH 0/5] VM_PINNED
Message-ID: <20140527144655.GC19143@laptop.programming.kicks-ass.net>
References: <20140526145605.016140154@infradead.org>
 <CALYGNiMG1NVBUS4TJrYJMr92yWGZHSdGUdCGtBJDHoUMMhE+Wg@mail.gmail.com>
 <20140526203232.GC5444@laptop.programming.kicks-ass.net>
 <CALYGNiO8FNKjtETQMRSqgiArjfQ9nRAALUg9GGdNYbpKru=Sjw@mail.gmail.com>
 <20140527102909.GO30445@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405270929550.13999@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405270929550.13999@gentwo.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 09:34:22AM -0500, Christoph Lameter wrote:
> On Tue, 27 May 2014, Peter Zijlstra wrote:
> 
> > The things I care about for VM_PINNED are long term pins, like the IB
> > stuff, which sets up its RDMA buffers at the start of a program and
> > basically leaves them in place for the entire duration of said program.
> 
> Ok that also means the pages are not to be allocated from ZONE_MOVABLE?

Well, like with IB, they start out as normal userspace pages, and will
be from ZONE_MOVABLE.

> I expected the use of a page flag. With a vma flag we may have a situation
> that mapping a page into a vma changes it to pinned and terminating a
> process may unpin a page. That means the zone that the page should be
> allocated from changes.

So the only way to 'map' something into pinned is what perf does (have
the f_ops->mmap call set VM_PINNED). But that way already ensures we
have full control over the allocation since its a custom file.

And in fact the perf buffer is allocated with GFP_KERNEL and is thus
already not from MOVABLE.

Any other use, like (again) the IB stuff, will go through
get_user_pages() which will ensure all the pages are mapped and present.

So I don't think this is a real problem and certainly not one that
requires a page flag.

> Pinned pages in ZONE_MOVABLE are not a good idea. But since "kernelcore"
> is rarely used maybe that is not an issue?

Well, the idea was to migrate pages to a more suitable location on
mm_mpin(). We could choose to move them out again on mm_munpin() or not.
