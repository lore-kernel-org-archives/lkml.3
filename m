Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab3IMOZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:25:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:34862 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab3IMOZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:25:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,898,1371106800"; 
   d="scan'208";a="402870872"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        Robin Holt <robinmholt@gmail.com>, Sedat Dilek <sedat.dilek@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <20130913133620.GE21832@twins.programming.kicks-ass.net>
References: <20130910074748.GA2971@gmail.com>
 <1379077576-2472-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1379077576-2472-9-git-send-email-kirill.shutemov@linux.intel.com>
 <20130913133620.GE21832@twins.programming.kicks-ass.net>
Subject: Re: [PATCH 8/9] mm: implement split page table lock for PMD level
Content-Transfer-Encoding: 7bit
Message-Id: <20130913142543.95200E0090@blue.fi.intel.com>
Date: Fri, 13 Sep 2013 17:25:43 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, Sep 13, 2013 at 04:06:15PM +0300, Kirill A. Shutemov wrote:
> > +#if USE_SPLIT_PMD_PTLOCKS
> > +
> > +static inline void pgtable_pmd_page_ctor(struct page *page)
> > +{
> > +	spin_lock_init(&page->ptl);
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +	page->pmd_huge_pte = NULL;
> > +#endif
> > +}
> > +
> > +static inline void pgtable_pmd_page_dtor(struct page *page)
> > +{
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +	VM_BUG_ON(page->pmd_huge_pte);
> > +#endif
> > +}
> > +
> > +#define pmd_huge_pte(mm, pmd) (virt_to_page(pmd)->pmd_huge_pte)
> > +
> > +#else
> 
> So on -rt we have the problem that spinlock_t is rather huge (its a
> rtmutex) so instead of blowing up the pageframe like that we treat
> page->pte as a pointer and allocate the spinlock.
> 
> Since allocations could fail the above ctor path gets 'interesting'.
> 
> It would be good if new code could assume the ctor could fail so we
> don't have to replicate that horror-show.

Okay, I'll rework this.

-- 
 Kirill A. Shutemov
