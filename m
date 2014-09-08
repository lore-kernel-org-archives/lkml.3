Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbaIHVhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:37:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbaIHVhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:37:52 -0400
Date: Mon, 8 Sep 2014 17:37:41 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v3 2/6] mm/hugetlb: take page table lock in
 follow_huge_(addr|pmd|pud)()
Message-ID: <20140908213741.GA6866@nhori.bos.redhat.com>
References: <1409276340-7054-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1409276340-7054-3-git-send-email-n-horiguchi@ah.jp.nec.com>
 <alpine.LSU.2.11.1409031243420.9023@eggly.anvils>
 <20140905052751.GA6883@nhori.redhat.com>
 <alpine.LSU.2.11.1409072307430.1298@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1409072307430.1298@eggly.anvils>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 12:13:16AM -0700, Hugh Dickins wrote:
> On Fri, 5 Sep 2014, Naoya Horiguchi wrote:
> > On Wed, Sep 03, 2014 at 02:17:41PM -0700, Hugh Dickins wrote:
> > > On Thu, 28 Aug 2014, Naoya Horiguchi wrote:
> > > > 
> > > > Reported-by: Hugh Dickins <hughd@google.com>
> > > > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > > > Cc: <stable@vger.kernel.org>  # [3.12+]
> > > 
> > > No ack to this one yet, I'm afraid.
> > 
> > OK, I defer Reported-by until all the problems in this patch are solved.
> > I added this Reported-by because Andrew asked how In found this problem,
> > and advised me to show the reporter.
> > And I didn't intend by this Reported-by that you acked the patch.
> > In this case, should I have used some unofficial tag like
> > "Not-yet-Reported-by:" to avoid being rude?
> 
> Sorry, misunderstanding, I chose that position to write "No ack to this
> one yet" because that is where I would insert my "Acked-by" to the patch
> when ready.  I just meant that I cannot yet give you my "Acked-by".

I see my understanding, thanks.

> You were not being rude to me at all, quite the reverse.
> 
> I have no objection to your writing "Reported-by: Hugh...": you are
> being polite to acknowledge me, and I was not objecting to that.

Great.

> Although usually, we save "Reported-by"s for users who have
> reported a problem they saw in practice, rather than for fellow
> developers who have looked at the code and seen a potential bug -
> so I won't mind at all if you end up taking it out.
> 
> > 
> > > One subtlety to take care over: it's a long time since I've had to
> > > worry about pmd folding and pud folding (what happens when you only
> > > have 2 or 3 levels of page table instead of the full 4): macros get
> > > defined to each other, and levels get optimized out (perhaps
> > > differently on different architectures).
> > > 
> > > So although at first sight the lock to take in follow_huge_pud()
> > > would seem to be mm->page_table_lock, I am not at this point certain
> > > that that's necessarily so - sometimes pud_huge might be pmd_huge,
> > > and the size PMD_SIZE, and pmd_lockptr appropriate at what appears
> > > to be the pud level.  Maybe: needs checking through the architectures
> > > and their configs, not obvious to me.
> > 
> > I think that every architecture uses mm->page_table_lock for pud-level
> > locking at least for now, but that could be changed in the future,
> > for example when 1GB hugepages or pud-based hugepages become common and
> > someone are interested in splitting lock for pud level.
> 
> I'm not convinced by your answer, that you understand the (perhaps
> imaginary!) issue I'm referring to.  Try grep for __PAGETABLE_P.D_FOLDED.
> 
> Our infrastructure allows for 4 levels of pagetable, pgd pud pmd pte,
> but many architectures/configurations support only 2 or 3 levels.
> What pud functions and pmd functions work out to be in those
> configs is confusing, and varies from architecture to architecture.
> 
> In particular, pud and pmd may be different expressions of the same
> thing (with 1 pmd per pud, instead of say 512).  In that case PUD_SIZE
> will equal PMD_SIZE: and then at the pud level huge_pte_lockptr()
> will be using split locking instead of mm->page_table_lock.

Is it a possible problem? It seems to me that in such system no one
can create pud-based hugepages and care about pud level locking.

> Many of the hugetlb architectures have a pud_huge() which just returns
> 0, and we need not worry about those, nor the follow_huge_addr() powerpc.
> But arm64, mips, tile, x86 look more interesting.
> 
> Frankly, I find myself too dumb to be sure of the right answer for all:
> and think that when we put the proper locking into follow_huge_pud(),
> we shall have to include a PUD_SIZE == PMD_SIZE test, to let the
> compiler decide for us which is the appropriate locking to match
> huge_pte_lockptr().

Yes, both should be done at the same time.

> 
> Unless Kirill can illuminate: I may be afraid of complications
> where actually there are none.

Yes. What we need now is to fix follow_huge_pmd(), and combining
non-urgent things with it is not easy for me.

Thanks,
Naoya Horiguchi
