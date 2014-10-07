Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbaJGQ5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:57:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbaJGQ5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:57:12 -0400
Date: Tue, 7 Oct 2014 12:56:57 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 3/5] mm/hugetlb: fix getting refcount 0 page in
 hugetlb_fault()
Message-ID: <20141007165657.GB24093@nhori.bos.redhat.com>
References: <1410820799-27278-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1410820799-27278-4-git-send-email-n-horiguchi@ah.jp.nec.com>
 <alpine.LSU.2.11.1409292132370.4640@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1409292132370.4640@eggly.anvils>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 09:52:24PM -0700, Hugh Dickins wrote:
> On Mon, 15 Sep 2014, Naoya Horiguchi wrote:
> > When running the test which causes the race as shown in the previous patch,
> > we can hit the BUG "get_page() on refcount 0 page" in hugetlb_fault().
> 
> Two minor comments...
> 
> > @@ -3192,22 +3208,19 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
> > 	 * Note that locking order is always pagecache_page -> page,
> >  	 * so no worry about deadlock.
> 
> That sentence of comment is stale and should be deleted,
> now that you're only doing a trylock_page(page) here.

OK, I'll delete it.

> >  out_mutex:
> >  	mutex_unlock(&htlb_fault_mutex_table[hash]);
> > +	if (need_wait_lock)
> > +		wait_on_page_locked(page);
> >  	return ret;
> >  }
> 
> It will be hard to trigger any problem from this (I guess it would
> need memory hotremove), but you ought really to hold a reference to
> page while doing a wait_on_page_locked(page).

I'll do that.

Thanks,
Naoya Horiguchi
