Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab3A1RFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:05:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561Ab3A1RFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:05:52 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: clean up soft_offline_page()
Date: Mon, 28 Jan 2013 12:05:37 -0500
Message-Id: <1359392737-7158-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <510627F2.7010500@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 03:25:38PM +0800, Xishi Qiu wrote:
> On 2013/1/26 13:02, Naoya Horiguchi wrote:
> 
> > Currently soft_offline_page() is hard to maintain because it has many
> > return points and goto statements. All of this mess come from get_any_page().
> > This function should only get page refcount as the name implies, but it does
> > some page isolating actions like SetPageHWPoison() and dequeuing hugepage.
> > This patch corrects it and introduces some internal subroutines to make
> > soft offlining code more readable and maintainable.
> > 
> > ChangeLog v2:
> >   - receive returned value from __soft_offline_page and soft_offline_huge_page
> >   - place __soft_offline_page after soft_offline_page to reduce the diff
> >   - rebased onto mmotm-2013-01-23-17-04
> >   - add comment on double checks of PageHWpoison
> > 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > ---
> >  mm/memory-failure.c | 154 ++++++++++++++++++++++++++++------------------------
> >  1 file changed, 83 insertions(+), 71 deletions(-)
> > 
> > diff --git mmotm-2013-01-23-17-04.orig/mm/memory-failure.c mmotm-2013-01-23-17-04/mm/memory-failure.c
> > index c95e19a..302625b 100644
> > --- mmotm-2013-01-23-17-04.orig/mm/memory-failure.c
> > +++ mmotm-2013-01-23-17-04/mm/memory-failure.c
> > @@ -1368,7 +1368,7 @@ static struct page *new_page(struct page *p, unsigned long private, int **x)
> >   * that is not free, and 1 for any other page type.
> >   * For 1 the page is returned with increased page count, otherwise not.
> >   */
> > -static int get_any_page(struct page *p, unsigned long pfn, int flags)
> > +static int __get_any_page(struct page *p, unsigned long pfn, int flags)
> >  {
> >  	int ret;
> >  
> > @@ -1393,11 +1393,9 @@ static int get_any_page(struct page *p, unsigned long pfn, int flags)
> >  	if (!get_page_unless_zero(compound_head(p))) {
> >  		if (PageHuge(p)) {
> >  			pr_info("%s: %#lx free huge page\n", __func__, pfn);
> > -			ret = dequeue_hwpoisoned_huge_page(compound_head(p));
> > +			ret = 0;
> >  		} else if (is_free_buddy_page(p)) {
> >  			pr_info("%s: %#lx free buddy page\n", __func__, pfn);
> > -			/* Set hwpoison bit while page is still isolated */
> > -			SetPageHWPoison(p);
> >  			ret = 0;
> >  		} else {
> >  			pr_info("%s: %#lx: unknown zero refcount page type %lx\n",
> > @@ -1413,42 +1411,62 @@ static int get_any_page(struct page *p, unsigned long pfn, int flags)
> >  	return ret;
> >  }
> >  
> > +static int get_any_page(struct page *page, unsigned long pfn, int flags)
> > +{
> > +	int ret = __get_any_page(page, pfn, flags);
> > +
> > +	if (ret == 1 && !PageHuge(page) && !PageLRU(page)) {
> > +		/*
> > +		 * Try to free it.
> > +		 */
> > +		put_page(page);
> > +		shake_page(page, 1);
> > +
> > +		/*
> > +		 * Did it turn free?
> > +		 */
> > +		ret = __get_any_page(page, pfn, 0);
> > +		if (!PageLRU(page)) {
> > +			pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
> > +				pfn, page->flags);
> > +			return -EIO;
> > +		}
> > +	}
> > +	return ret;
> > +}
> > +
> >  static int soft_offline_huge_page(struct page *page, int flags)
> >  {
> >  	int ret;
> >  	unsigned long pfn = page_to_pfn(page);
> >  	struct page *hpage = compound_head(page);
> >  
> > +	/*
> > +	 * This double-check of PageHWPoison is to avoid the race with
> > +	 * memory_failure(). See also comment in __soft_offline_page().
> > +	 */
> > +	lock_page(hpage);
> >  	if (PageHWPoison(hpage)) {
> > +		unlock_page(hpage);
> > +		put_page(hpage);
> >  		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
> > -		ret = -EBUSY;
> > -		goto out;
> > +		return -EBUSY;
> >  	}
> > -
> > -	ret = get_any_page(page, pfn, flags);
> > -	if (ret < 0)
> > -		goto out;
> > -	if (ret == 0)
> > -		goto done;
> > +	unlock_page(hpage);
> >  
> >  	/* Keep page count to indicate a given hugepage is isolated. */
> >  	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL, false,
> >  				MIGRATE_SYNC);
> >  	put_page(hpage);
> > -	if (ret) {
> > +	if (ret)
> >  		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
> >  			pfn, ret, page->flags);
> > -		goto out;
> > -	}
> > -done:
> >  	/* keep elevated page count for bad page */
> > -	atomic_long_add(1 << compound_trans_order(hpage), &num_poisoned_pages);
> > -	set_page_hwpoison_huge_page(hpage);
> > -	dequeue_hwpoisoned_huge_page(hpage);
> 
> Hi Naoya,
> 
> Does num_poisoned_pages be added when soft_offline_huge_page? I mean the in-use huge pages.

Hi Xishi,

Yes, we should add it, and also need set_page_hwpoison_huge_page and
dequeue_hwpoisoned_huge_page because that means 'soft offline'.
I'll repost the fixed one soon. Thank you for your awareness.

Naoya
