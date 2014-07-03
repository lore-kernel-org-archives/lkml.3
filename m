Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbaGCQBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:01:11 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:41309 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbaGCQBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:01:08 -0400
Date: Thu, 3 Jul 2014 18:01:00 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Minchan Kim <minchan@kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH v9] mm: support madvise(MADV_FREE)
Message-ID: <20140703180100.5f24a139@mschwide>
In-Reply-To: <20140703083729.GE2939@bbox>
References: <1404174975-22019-1-git-send-email-minchan@kernel.org>
	<20140701145058.GA2084@node.dhcp.inet.fi>
	<20140703010318.GA2939@bbox>
	<20140703072954.GC2939@bbox>
	<20140703102901.322bfdb0@mschwide>
	<20140703083729.GE2939@bbox>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070316-1948-0000-0000-000000696A2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014 17:37:29 +0900
Minchan Kim <minchan@kernel.org> wrote:

> Hello,
> 
> On Thu, Jul 03, 2014 at 10:29:01AM +0200, Martin Schwidefsky wrote:
> > On Thu, 3 Jul 2014 16:29:54 +0900
> > Minchan Kim <minchan@kernel.org> wrote:
> > 
> > > Hello,
> > > 
> > > On Thu, Jul 03, 2014 at 10:03:19AM +0900, Minchan Kim wrote:
> > > > Hello,
> > > > 
> > > > On Tue, Jul 01, 2014 at 05:50:58PM +0300, Kirill A. Shutemov wrote:
> > > > > On Tue, Jul 01, 2014 at 09:36:15AM +0900, Minchan Kim wrote:
> > > > > > +	do {
> > > > > > +		/*
> > > > > > +		 * XXX: We can optimize with supporting Hugepage free
> > > > > > +		 * if the range covers.
> > > > > > +		 */
> > > > > > +		next = pmd_addr_end(addr, end);
> > > > > > +		if (pmd_trans_huge(*pmd))
> > > > > > +			split_huge_page_pmd(vma, addr, pmd);
> > > > > 
> > > > > Could you implement proper THP support before upstreaming the feature?
> > > > > It shouldn't be a big deal.
> > > > 
> > > > Okay, Hope to review.
> > > > 
> > > > Thanks for the feedback!
> > > > 
> > > 
> > > I tried to implement it but had a issue.
> > > 
> > > I need pmd_mkold, pmd_mkclean for MADV_FREE operation and pmd_dirty for
> > > page_referenced. When I investigate all of arches supported THP,
> > > it's not a big deal but s390 is not sure to me who has no idea of
> > > soft tracking of s390 by storage key instead of page table information.
> > > Cced s390 maintainer. Hope to help.
> > 
> > Storage key for dirty and referenced tracking is a thing of the past.
> > The current code for s390 uses software tracking for dirty and referenced.
> > There is one catch though, for ptes the software implementation covers
> > dirty and referenced bit but for pmds only referenced bit is available.
> > The reason is that there is no free bit left in the pmd entry for the
> > software dirty bit.
> 
> Thanks for the quick reply.
> 
> >  
> > > So, if there isn't any help from s390, I should introduce
> > > HAVE_ARCH_THP_MADVFREE to disable MADV_FREE support of THP in s390 but
> > > not want to introduce such new config.
> > 
> > Why is the dirty bit for pmds needed for the MADV_FREE implementation?
> 
> MADV_FREE semantic want it.
> 
> When madvise syscall is called, VM clears dirty bit of ptes of
> the range. If memory pressure happens, VM checks dirty bit of
> page table and if it found still "clean", it means it's a
> "lazyfree pages" so VM could discard the page instead of swapping out.
> Once there was store operation for the page before VM peek a page
> to reclaim, dirty bit is set so VM can swap out the page instead of
> discarding to keep up-to-date contents.
> 
> If it's hard on s390, maybe we could use just reference bit
> instead of dirty bit to check recent access but it might change
> semantic a bit with other OSes. :(

Just discussed this with Gerald and we found a trick how we can add
a dirty bit to the pmd entries. That will be a non-trivial patch but
we can do it. Until that time you could just define pmd_dirty to 
always return true and the code should "work" in the sense that it
does not break anything.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

