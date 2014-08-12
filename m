Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaHLSzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:55:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbaHLSzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:55:45 -0400
Date: Tue, 12 Aug 2014 14:55:34 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v2 2/3] mm/hugetlb: use get_page_unless_zero() in
 hugetlb_fault()
Message-ID: <20140812185534.GB8975@nhori.bos.redhat.com>
References: <1406914663-8631-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1406914663-8631-2-git-send-email-n-horiguchi@ah.jp.nec.com>
 <alpine.LSU.2.11.1408091601590.15311@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1408091601590.15311@eggly.anvils>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 04:11:06PM -0700, Hugh Dickins wrote:
> On Fri, 1 Aug 2014, Naoya Horiguchi wrote:
> 
> > After fixing locking in follow_page(FOLL_GET) for hugepages, I start to
> > observe the BUG of "get_page() on refcount 0 page" in hugetlb_fault() in
> > the same test.
> > 
> > I'm not exactly sure about how this race is triggered, but hugetlb_fault()
> > calls pte_page() and get_page() outside page table lock, so it's not safe.
> > This patch checks the refcount of the gotten page, and aborts the page fault
> > if the refcount is 0, expecting to retry.
> > 
> 
> Fixes: 66aebce747ea ("hugetlb: fix race condition in hugetlb_fault()")
> 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > Cc: <stable@vger.kernel.org>  # [3.12+]
> 
> 
> I disagree with your 3.12+ annotation there: you may have hit the issue
> in testing your hugepage migration work, but it's older than that: the
> problematic get_page() was introduced in 3.4, and has been backported
> to 3.2-stable: so 3.2+.

Right, thanks.

> I was suspicious of this patch at first, then on the point of giving it
> an Ack, and then realized that I had been right to be suspicious of it.
> 
> You're not the first the get the sequence wrong here; and it won't be
> surprising if there are other instances of subtle get_page_unless_zero()
> misuse elsewhere in the tree (I dare not look!  someone else please do).
> 
> It's not the use of get_page_unless_zero() itself that is wrong, it's
> the unjustified confidence in it: what's wrong is the lock_page() after.
> 
> As you have found, and acknowledged with get_page_unless_zero(), is
> that the page here may be stale, it might be already freed, it might
> be already reused.  If reused, then its page_count will no longer be 0,
> but the new user expects to have sole ownership of the page.  The new
> owner might be using __set_page_locked() (or one of the other nonatomic
> flags operations), or "if (!trylock_page(newpage)) BUG()" like
> migration's move_to_new_page().
> 
> We are dealing with a recently-hugetlb page here: that might make the
> race I'm describing even less likely than with usual order:0 pages,
> but I don't think it eliminates it.

I agree.

> What to do instead?  The first answer that occurs to me is to move the
> the pte_page,get_page down after the pte_same check inside the spin_lock,
> and only then do trylock_page(), backing out to wait_on_page_locked and
> retry or refault if not.

I think that should work.
According to the lock ordering commented in mm/rmap.c, page lock is prior
to page table lock, so we can't take page lock inside page table lock.
But with trylock_page() we check if the page lock is taken or not, so
we can avoid deadlock.

> Though if doing that, it might be more sensible only to trylock_page
> before dropping ptl inside hugetlb_cow().  That would be a bigger,
> maybe harder to backport, rearrangement.

Yes, the patch will be somewhat complicated for stable, and we can't
avoid that.

Thanks,
Naoya Horiguchi
