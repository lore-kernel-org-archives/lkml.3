Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3FDFHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:07:47 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54120 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3FDFHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:07:45 -0400
X-AuditID: 9c93017d-b7c04ae00000207d-8d-51ad76203413
Date: Tue, 4 Jun 2013 14:07:44 +0900
From: Minchan Kim <minchan@kernel.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Dave Hansen <dave@sr71.net>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [v5][PATCH 5/6] mm: vmscan: batch shrink_page_list() locking
 operations
Message-ID: <20130604050744.GD14719@blaptop>
References: <20130603200202.7F5FDE07@viggo.jf.intel.com>
 <20130603200208.6F71D31F@viggo.jf.intel.com>
 <CAJd=RBC563c64usU2oK40b62c7N0R15KD_4ihFExeT021wUTcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBC563c64usU2oK40b62c7N0R15KD_4ihFExeT021wUTcw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 09:17:26AM +0800, Hillf Danton wrote:
> On Tue, Jun 4, 2013 at 4:02 AM, Dave Hansen <dave@sr71.net> wrote:
> > +/*
> > + * pages come in here (via remove_list) locked and leave unlocked
> > + * (on either ret_pages or free_pages)
> > + *
> > + * We do this batching so that we free batches of pages with a
> > + * single mapping->tree_lock acquisition/release.  This optimization
> > + * only makes sense when the pages on remove_list all share a
> > + * page_mapping().  If this is violated you will BUG_ON().
> > + */
> > +static int __remove_mapping_batch(struct list_head *remove_list,
> > +                                 struct list_head *ret_pages,
> > +                                 struct list_head *free_pages)
> > +{
> > +       int nr_reclaimed = 0;
> > +       struct address_space *mapping;
> > +       struct page *page;
> > +       LIST_HEAD(need_free_mapping);
> > +
> > +       if (list_empty(remove_list))
> > +               return 0;
> > +
> > +       mapping = page_mapping(lru_to_page(remove_list));
> > +       spin_lock_irq(&mapping->tree_lock);
> > +       while (!list_empty(remove_list)) {
> > +               page = lru_to_page(remove_list);
> > +               BUG_ON(!PageLocked(page));
> > +               BUG_ON(page_mapping(page) != mapping);
> > +               list_del(&page->lru);
> > +
> > +               if (!__remove_mapping(mapping, page)) {
> > +                       unlock_page(page);
> > +                       list_add(&page->lru, ret_pages);
> > +                       continue;
> > +               }
> > +               list_add(&page->lru, &need_free_mapping);
> > +       }
> > +       spin_unlock_irq(&mapping->tree_lock);
> > +
> While reclaiming pages, can we open ears upon IRQ controller,
> if the page list length is over 10, or even 20?

At the moment, it implicitly could be bounded by SWAP_CLUSTER_MAX and
it's the value used by isolate_migratepages_ranges to enable IRQ.
I have no idea it's proper value to give a chace to IRQ but at least,
Dave's code doesn't break the rule.
If we need a tune for that, it could be a another patch to investigate
all of places on vmscan.c in near future.


> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
