Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab3EGVxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:53:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab3EGVxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:53:07 -0400
Date: Tue, 07 May 2013 17:53:01 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: j.glisse@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jerome Glisse <jglisse@redhat.com>
Message-ID: <1367963581-fsskl9vz-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1367959554-3218-1-git-send-email-j.glisse@gmail.com>
References: <1367959554-3218-1-git-send-email-j.glisse@gmail.com>
Subject: Re: [PATCH 1/3] mm: honor FOLL_GET flag in follow_hugetlb_page
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1367959554-3218-1-git-send-email-j.glisse@gmail.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 04:45:54PM -0400, j.glisse@gmail.com wrote:
> From: Jerome Glisse <jglisse@redhat.com>
> 
> Do not increase page count if FOLL_GET is not set.
> 
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> ---
>  mm/hugetlb.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 1a12f5b..5d1e46b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2991,7 +2991,9 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  same_page:
>  		if (pages) {
>  			pages[i] = mem_map_offset(page, pfn_offset);
> -			get_page(pages[i]);
> +			if (flags & FOLL_GET) {
> +				get_page_foll(pages[i]);
> +			}
>  		}
>  
>  		if (vmas)
> -- 

Hi Jerome,

I think that we need to be careful in handling tail pages, because
__get_page_tail_foll() uses page->_mapcount as refcount.
When you get refcount on a tail page and free the hugepage without
putting the *mapcount*, you will hit BUG_ON() in free_huge_page().
Yes, this is a very tricky workaround for thp, so to avoid making
things too complicated, I think either of the following is better:
 - to get refcount only for head pages, or
 - to introduce a hugetlbfs variant of get_page_foll().

BTW, who do you expect is the caller of follow_hugetlb_page()
with FOLL_GET (I can't find your subsequent patches 2/3 or 3/3)?
I'm interested in this change because in my project it's necessary
to implement this for hugepage migration
(see https://lkml.org/lkml/2013/3/22/553).

Thanks,
Naoya Horiguchi
