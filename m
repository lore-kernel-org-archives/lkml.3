Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbaAHNOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:14:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbaAHNO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:14:29 -0500
Date: Wed, 8 Jan 2014 13:14:24 +0000
From: Mel Gorman <mgorman@suse.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2 1/1] mm: fix the theoretical compound_lock() vs
 prep_new_page() race
Message-ID: <20140108131424.GE27046@suse.de>
References: <20131216183618.GA28252@redhat.com>
 <20131216201952.GE21218@redhat.com>
 <20131219190846.GA24566@redhat.com>
 <20131219190920.GB24566@redhat.com>
 <20131223114300.GC727@redhat.com>
 <20140103195519.GA26555@redhat.com>
 <20140103195547.GB26555@redhat.com>
 <20140103130023.fdbf96fc95c702bf63871b56@linux-foundation.org>
 <20140104164347.GA31359@redhat.com>
 <20140108115400.GD27046@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140108115400.GD27046@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 11:54:00AM +0000, Mel Gorman wrote:
> On Sat, Jan 04, 2014 at 05:43:47PM +0100, Oleg Nesterov wrote:
> > On 01/03, Andrew Morton wrote:
> > >
> > > On Fri, 3 Jan 2014 20:55:47 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > > get/put_page(thp_tail) paths do get_page_unless_zero(page_head) +
> > > > compound_lock(). In theory this page_head can be already freed and
> > > > reallocated as alloc_pages(__GFP_COMP, smaller_order). In this case
> > > > get_page_unless_zero() can succeed right after set_page_refcounted(),
> > > > and compound_lock() can race with the non-atomic __SetPageHead().
> > >
> > > Would be useful to mention that these things are happening inside
> > > prep_compound_opage() (yes?).
> > 
> > Agreed. Added "in prep_compound_opage()" into the changelog:
> > 
> > 	get/put_page(thp_tail) paths do get_page_unless_zero(page_head) +
> > 	compound_lock(). In theory this page_head can be already freed and
> > 	reallocated as alloc_pages(__GFP_COMP, smaller_order). In this case
> > 	get_page_unless_zero() can succeed right after set_page_refcounted(),
> > 	and compound_lock() can race with the non-atomic __SetPageHead() in
> > 	prep_compound_page().
> > 
> > 	Perhaps we should rework the thp locking (under discussion), but
> > 	until then this patch moves set_page_refcounted() and adds wmb()
> > 	to ensure that page->_count != 0 comes as a last change.
> > 
> > 	I am not sure about other callers of set_page_refcounted(), but at
> > 	first glance they look fine to me.
> > 
> > or should I send v3?
> > 
> 
> This patch is putting a write barrier in the page allocator fast path and
> that is going to be a leading cause of Sad Face.

Peter Zijlstra correctly pointed out to me that on x86 that we generally
would not care/notice a write barrier as it almost always is a no-op.
X86 (which is all I test any more) can execute an sfence for a smp_wmb
but not in any configuration that matters. The previous barrier damage in
page_alloc.c was due to full barriers but I generally assume barriers have a
cost in core code when I see them regardless of the underlying architecture
details. So 99% of the time, we will not care and I won't be making Sad
Face but eventually someone using an affected architecture will whinge --
ppc64 probably as write barriers on sparc are compile barriers.

-- 
Mel Gorman
SUSE Labs
