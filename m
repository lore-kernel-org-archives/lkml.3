Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbaD1TWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:22:05 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:45235 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbaD1TWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:22:01 -0400
Date: Mon, 28 Apr 2014 20:23:21 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kirill.shutemov@linux.intel.com,
        Rik van Riel <riel@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        peterz@infradead.org, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        sasha.levin@oracle.com, liwanp@linux.vnet.ibm.com,
        khalid.aziz@oracle.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] mm: introdule compound_head_by_tail()
Message-ID: <20140428182321.GA5856@dhcp22.suse.cz>
References: <c232030f96bdc60aef967b0d350208e74dc7f57d.1398605516.git.nasa4836@gmail.com>
 <2c87e00d633153ba7b710bab12710cc3a58704dd.1398605516.git.nasa4836@gmail.com>
 <20140428145440.GB7839@dhcp22.suse.cz>
 <CAHz2CGUueeXR2UdLXBRihVN3R8qEUR8wWhpxYjA6pu3ONO0cJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHz2CGUueeXR2UdLXBRihVN3R8qEUR8wWhpxYjA6pu3ONO0cJA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-04-14 23:53:28, Jianyu Zhan wrote:
> Hi, Michal,
> 
> On Mon, Apr 28, 2014 at 10:54 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > I really fail to see how that helps. compound_head is inlined and the
> > compiler should be clever enough to optimize the code properly. I
> > haven't tried that to be honest but this looks like it only adds a code
> > without any good reason. And I really hate the new name as well. What
> > does it suppose to mean?
> 
> the code in question is as below:
> 
> --- snipt ----
> if (likely(!PageTail(page))) {                  <------  (1)
>                 if (put_page_testzero(page)) {
>                         /*
>                         ¦* By the time all refcounts have been released
>                         ¦* split_huge_page cannot run anymore from under us.
>                         ¦*/
>                         if (PageHead(page))
>                                 __put_compound_page(page);
>                         else
>                                 __put_single_page(page);
>                 }
>                 return;
> }
> 
> /* __split_huge_page_refcount can run under us */
> page_head = compound_head(page);        <------------ (2)
> --- snipt ---
> 
> if at (1) ,  we fail the check, this means page is *likely* a tail page.
> 
> Then at (2), yes, compoud_head(page) is inlined, it is :
> 
> --- snipt ---
> static inline struct page *compound_head(struct page *page)
> {
>           if (unlikely(PageTail(page))) {           <----------- (3)
>               struct page *head = page->first_page;
> 
>                 smp_rmb();
>                 if (likely(PageTail(page)))
>                         return head;
>         }
>         return page;
> }
> --- snipt ---
> 
> here, the (3) unlikely in the case is  a negative hint, because it
> is *likely* a tail page. So the check (3) in this case is not good,
> so I introduce a helper for this case.
> 
> Actually, I checked the assembled code, the compiler is _not_
> so smart to recognize this case. It just does optimization as
> the hint unlikely() told it.

OK, the generated code is sligly smaller:
  11869    1328      32   13229    33ad mm/swap.o.after
  11880    1328      32   13240    33b8 mm/swap.o.before

The another question is. Does this matter? You are optimizing a slow
path which is not bad in general but it would be much better if you
show numbers which tell us that it helps noticeably in some loads or it
helped with future readability and maintainability. My experience tells
me that having very specialized helper functions used at a single place
don't help in neither in readability nor maintainability.
-- 
Michal Hocko
SUSE Labs
