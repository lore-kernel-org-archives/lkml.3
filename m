Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaADQnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 11:43:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421AbaADQno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 11:43:44 -0500
Date: Sat, 4 Jan 2014 17:43:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2 1/1] mm: fix the theoretical compound_lock() vs
	prep_new_page() race
Message-ID: <20140104164347.GA31359@redhat.com>
References: <20131213162240.GA11762@redhat.com> <20131213173406.GG5408@redhat.com> <20131216183618.GA28252@redhat.com> <20131216201952.GE21218@redhat.com> <20131219190846.GA24566@redhat.com> <20131219190920.GB24566@redhat.com> <20131223114300.GC727@redhat.com> <20140103195519.GA26555@redhat.com> <20140103195547.GB26555@redhat.com> <20140103130023.fdbf96fc95c702bf63871b56@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140103130023.fdbf96fc95c702bf63871b56@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03, Andrew Morton wrote:
>
> On Fri, 3 Jan 2014 20:55:47 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > get/put_page(thp_tail) paths do get_page_unless_zero(page_head) +
> > compound_lock(). In theory this page_head can be already freed and
> > reallocated as alloc_pages(__GFP_COMP, smaller_order). In this case
> > get_page_unless_zero() can succeed right after set_page_refcounted(),
> > and compound_lock() can race with the non-atomic __SetPageHead().
>
> Would be useful to mention that these things are happening inside
> prep_compound_opage() (yes?).

Agreed. Added "in prep_compound_opage()" into the changelog:

	get/put_page(thp_tail) paths do get_page_unless_zero(page_head) +
	compound_lock(). In theory this page_head can be already freed and
	reallocated as alloc_pages(__GFP_COMP, smaller_order). In this case
	get_page_unless_zero() can succeed right after set_page_refcounted(),
	and compound_lock() can race with the non-atomic __SetPageHead() in
	prep_compound_page().

	Perhaps we should rework the thp locking (under discussion), but
	until then this patch moves set_page_refcounted() and adds wmb()
	to ensure that page->_count != 0 comes as a last change.

	I am not sure about other callers of set_page_refcounted(), but at
	first glance they look fine to me.

or should I send v3?

> > Perhaps we should rework the thp locking (under discussion), but
> > until then this patch moves set_page_refcounted() and adds wmb()
> > to ensure that page->_count != 0 comes as a last change.
> >
> > I am not sure about other callers of set_page_refcounted(), but at
> > first glance they look fine to me.
>
> I don't get it.  We're in prep_new_page() - this page is freshly
> allocated and no other thread yet has any means by which to look it up
> and start fiddling with it?

Yes, but thp can access this page_head via stale pointer, tail->first_page,
if it races with split_huge_page_refcount(). In this case we rely on
compound_lock() to detect this race, the problem is that compound_lock()
itself can race with head_page->flags manipulations.

For example, __get_page_tail() roughly does:

	// PageTail(page) was already checked

	page_head = page->first_page;

	/* WINDOW */

	get_page_unless_zero(page_head);

	compound_lock(page_head);

	recheck PageTail(page) to ensure page_head is still valid

However, in the WINDOW above, split_huge_page() can split this huge page.
After that its head can be freed and reallocated. Of course, I don't think
it is possible to hit this race in practice, but still this looks wrong.

Oleg.

