Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3LSQ3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:29:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669Ab3LSQ32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:29:28 -0500
Date: Thu, 19 Dec 2013 17:29:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 6/7] mm: thp: introduce get_lock_thp_head()
Message-ID: <20131219162947.GA16884@redhat.com>
References: <20131218191913.GA6464@redhat.com> <20131218192005.GA8340@redhat.com> <CA+55aFyVNDFY87V2TZ9ViS7TUMyH7n88g-V=CdB5_c9+=M+fNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyVNDFY87V2TZ9ViS7TUMyH7n88g-V=CdB5_c9+=M+fNQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/18, Linus Torvalds wrote:
>
> On Wed, Dec 18, 2013 at 11:20 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Both __put_page_tail() and __get_page_tail() need to carefully
> > take a reference on page_head, take compound_lock() and recheck
> > PageTail(page) under this lock.
>
> Btw I suspect this is just disgustingly expensive, and I don't think
> there's a really good reason for it.
>
> May I suggest:
>
>  - getting rid of the PG_compound_lock bit-lock
>
>    bitlocks are expensive and unfair, and don't even get lockdep checking
>
>  - replace it with a (small, say 32-256 entries) array of hashed sequence locks
>
>  - just hash based on the "struct page" pointer, and teach this code
> to do a read_seqcount_begin/read_seqcount_retry sequence instead for
> the page lookup.

Yes, I thought about this too but didn't dare to suggest. Not sure
about seqlock/irqs and other details, this needs more discussion anyway.
And of course I am not sure this will be actually better.

> This is obviously orthogonal to your series,

Yes.

But please note that one of the reasons for the new helper is simplify
the potential locking changes. The changelog only mentions "even more
bitlocks" change, but this doesn't matter.

And in fact I think that this allows to do more cleanups even if we
do not change the locking, get_lock_thp_head() should return page_head
or NULL, tail != head is just another PageTail() check. Perhaps.

Oleg.

