Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3KFOay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:30:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57343 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab3KFOaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:30:52 -0500
Date: Wed, 6 Nov 2013 15:30:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] mm: create a separate slab for page->ptl allocation
Message-ID: <20131106143037.GO10651@twins.programming.kicks-ass.net>
References: <1382442839-7458-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20131105150145.734a5dd5b5d455800ebfa0d3@linux-foundation.org>
 <20131105224217.GC20167@shutemov.name>
 <20131105155619.021f32eba1ca8f15a73ed4c9@linux-foundation.org>
 <20131105231310.GE20167@shutemov.name>
 <20131106093131.GU28601@twins.programming.kicks-ass.net>
 <20131106132155.GA22132@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106132155.GA22132@shutemov.name>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 03:21:55PM +0200, Kirill A. Shutemov wrote:
> On Wed, Nov 06, 2013 at 10:31:31AM +0100, Peter Zijlstra wrote:
> > On Wed, Nov 06, 2013 at 01:13:11AM +0200, Kirill A. Shutemov wrote:
> > > I would like to get rid of __ptlock_alloc()/__ptlock_free() too, but I
> > > don't see a way within C: we need to know sizeof(spinlock_t) on
> > > preprocessor stage.
> > > 
> > > We can have a hack on kbuild level: write small helper program to find out
> > > sizeof(spinlock_t) before start building and turn it into define.
> > > But it's overkill from my POV. And cross-compilation will be a fun.
> > 
> > Ah, I just remembered, we have such a thing!
> 
> Great!
> 
> > @@ -1354,7 +1356,7 @@ static inline bool ptlock_init(struct page *page)
> >  	 * slab code uses page->slab_cache and page->first_page (for tail
> >  	 * pages), which share storage with page->ptl.
> >  	 */
> > -	VM_BUG_ON(page->ptl);
> > +	VM_BUG_ON(*(unsigned long *)&page->ptl);
> 
> Huh? Why not direct cast to unsigned long?
> 
> VM_BUG_ON((unsigned long)page->ptl);

I tried, GCC didn't dig that. I think because spinlock_t is a composite
type and you cannot cast that to a primitive type.
