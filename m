Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463Ab3B0RRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:17:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760426Ab3B0RRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:17:10 -0500
Date: Wed, 27 Feb 2013 12:16:55 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: gong.chen@linux.intel.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Message-ID: <1361985415-3tashl9l-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130227073604.GB30971@gchen.bj.intel.com>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1361475708-25991-9-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130227073604.GB30971@gchen.bj.intel.com>
Subject: Re: [PATCH 8/9] memory-hotplug: enable memory hotplug to handle
 hugepage
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130227073604.GB30971@gchen.bj.intel.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 02:36:04AM -0500, Chen Gong wrote:
> On Thu, Feb 21, 2013 at 02:41:47PM -0500, Naoya Horiguchi wrote:
...
> > @@ -3158,6 +3182,25 @@ static int is_hugepage_on_freelist(struct page *hpage)
> >  	return 0;
> >  }
> >  
> > +/* Returns true for head pages of in-use hugepages, otherwise returns false. */
> > +int is_hugepage_movable(struct page *hpage)
> > +{
> > +	struct page *page;
> > +	struct page *tmp;
> > +	struct hstate *h = page_hstate(hpage);
> > +	int ret = 0;
> > +
> > +	VM_BUG_ON(!PageHuge(hpage));
> > +	if (PageTail(hpage))
> > +		return 0;
> > +	spin_lock(&hugetlb_lock);
> > +	list_for_each_entry_safe(page, tmp, &h->hugepage_activelist, lru)
> > +		if (page == hpage)
> > +			ret = 1;
> 
> I don't understand the logic here. 1) page is not removed why tmp is used?
> 2) why hitting (page ==hpage) but not breaking from the loop?

For question 1), using list_for_each_entry_safe() was a remnant of
try and error and will be fixed. And for question 2), I will add
break in later version.

Thanks,
Naoya

> > +	spin_unlock(&hugetlb_lock);
> > +	return ret;
> > +}
> > +
> > [...]
