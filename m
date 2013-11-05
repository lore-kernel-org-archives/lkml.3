Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab3KEX4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:56:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab3KEX4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:56:20 -0500
Date: Tue, 5 Nov 2013 15:56:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] mm: create a separate slab for page->ptl allocation
Message-Id: <20131105155619.021f32eba1ca8f15a73ed4c9@linux-foundation.org>
In-Reply-To: <20131105224217.GC20167@shutemov.name>
References: <1382442839-7458-1-git-send-email-kirill.shutemov@linux.intel.com>
	<20131105150145.734a5dd5b5d455800ebfa0d3@linux-foundation.org>
	<20131105224217.GC20167@shutemov.name>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 00:42:17 +0200 "Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> > >  #if USE_SPLIT_PTE_PTLOCKS
> > > +struct kmem_cache *page_ptl_cachep;
> > > +void __init ptlock_cache_init(void)
> > > +{
> > > +	if (sizeof(spinlock_t) > sizeof(long))
> > > +		page_ptl_cachep = kmem_cache_create("page->ptl",
> > > +				sizeof(spinlock_t), 0, SLAB_PANIC, NULL);
> > > +}
> > 
> > Confused.  If (sizeof(spinlock_t) > sizeof(long)) happens to be false
> > then the kernel will later crash.  It would be better to use BUILD_BUG_ON()
> > here, if that works.  Otherwise BUG_ON.
> 
> if (sizeof(spinlock_t) > sizeof(long)) is false, we don't need dynamicly
> allocate page->ptl. It's embedded to struct page itself. __ptlock_alloc()
> never called in this case.

OK.  Please add a comment explaining this so the next reader doesn't get
tripped up like I was.

Really the function shouldn't exist in this case.  It is __init so the
sin is not terrible, but can this be arranged?
