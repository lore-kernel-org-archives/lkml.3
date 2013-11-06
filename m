Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab3KFKes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:34:48 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36826 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753Ab3KFKeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:34:46 -0500
Date: Wed, 6 Nov 2013 10:34:03 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] mm: create a separate slab for page->ptl allocation
Message-ID: <20131106103403.GB21074@mudshark.cambridge.arm.com>
References: <1382442839-7458-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20131105150145.734a5dd5b5d455800ebfa0d3@linux-foundation.org>
 <20131105224217.GC20167@shutemov.name>
 <20131105155619.021f32eba1ca8f15a73ed4c9@linux-foundation.org>
 <20131105231310.GE20167@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105231310.GE20167@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 11:13:11PM +0000, Kirill A. Shutemov wrote:
> On Tue, Nov 05, 2013 at 03:56:19PM -0800, Andrew Morton wrote:
> > On Wed, 6 Nov 2013 00:42:17 +0200 "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> > 
> > > > >  #if USE_SPLIT_PTE_PTLOCKS
> > > > > +struct kmem_cache *page_ptl_cachep;
> > > > > +void __init ptlock_cache_init(void)
> > > > > +{
> > > > > +	if (sizeof(spinlock_t) > sizeof(long))
> > > > > +		page_ptl_cachep = kmem_cache_create("page->ptl",
> > > > > +				sizeof(spinlock_t), 0, SLAB_PANIC, NULL);
> > > > > +}
> > > > 
> > > > Confused.  If (sizeof(spinlock_t) > sizeof(long)) happens to be false
> > > > then the kernel will later crash.  It would be better to use BUILD_BUG_ON()
> > > > here, if that works.  Otherwise BUG_ON.
> > > 
> > > if (sizeof(spinlock_t) > sizeof(long)) is false, we don't need dynamicly
> > > allocate page->ptl. It's embedded to struct page itself. __ptlock_alloc()
> > > never called in this case.
> > 
> > OK.  Please add a comment explaining this so the next reader doesn't get
> > tripped up like I was.
> 
> Okay, I will tomorrow.
> 
> > Really the function shouldn't exist in this case.  It is __init so the
> > sin is not terrible, but can this be arranged?
> 
> I would like to get rid of __ptlock_alloc()/__ptlock_free() too, but I
> don't see a way within C: we need to know sizeof(spinlock_t) on
> preprocessor stage.

FWIW: if the architecture selects ARCH_USE_CMPXCHG_LOCKREF, then a spinlock_t
is 32-bit (assuming that unsigned int is also 32-bit).

Will
