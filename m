Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab3KFAJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 19:09:57 -0500
Received: from [204.155.152.216] ([204.155.152.216]:45668 "EHLO shutemov.name"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755739Ab3KFAJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 19:09:56 -0500
Date: Wed, 6 Nov 2013 01:13:11 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] mm: create a separate slab for page->ptl allocation
Message-ID: <20131105231310.GE20167@shutemov.name>
References: <1382442839-7458-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20131105150145.734a5dd5b5d455800ebfa0d3@linux-foundation.org>
 <20131105224217.GC20167@shutemov.name>
 <20131105155619.021f32eba1ca8f15a73ed4c9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105155619.021f32eba1ca8f15a73ed4c9@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 03:56:19PM -0800, Andrew Morton wrote:
> On Wed, 6 Nov 2013 00:42:17 +0200 "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> 
> > > >  #if USE_SPLIT_PTE_PTLOCKS
> > > > +struct kmem_cache *page_ptl_cachep;
> > > > +void __init ptlock_cache_init(void)
> > > > +{
> > > > +	if (sizeof(spinlock_t) > sizeof(long))
> > > > +		page_ptl_cachep = kmem_cache_create("page->ptl",
> > > > +				sizeof(spinlock_t), 0, SLAB_PANIC, NULL);
> > > > +}
> > > 
> > > Confused.  If (sizeof(spinlock_t) > sizeof(long)) happens to be false
> > > then the kernel will later crash.  It would be better to use BUILD_BUG_ON()
> > > here, if that works.  Otherwise BUG_ON.
> > 
> > if (sizeof(spinlock_t) > sizeof(long)) is false, we don't need dynamicly
> > allocate page->ptl. It's embedded to struct page itself. __ptlock_alloc()
> > never called in this case.
> 
> OK.  Please add a comment explaining this so the next reader doesn't get
> tripped up like I was.

Okay, I will tomorrow.

> Really the function shouldn't exist in this case.  It is __init so the
> sin is not terrible, but can this be arranged?

I would like to get rid of __ptlock_alloc()/__ptlock_free() too, but I
don't see a way within C: we need to know sizeof(spinlock_t) on
preprocessor stage.

We can have a hack on kbuild level: write small helper program to find out
sizeof(spinlock_t) before start building and turn it into define.
But it's overkill from my POV. And cross-compilation will be a fun.

-- 
 Kirill A. Shutemov
