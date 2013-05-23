Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab3EWKca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:32:30 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:53185 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977Ab3EWKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:32:29 -0400
MIME-Version: 1.0
In-Reply-To: <1368321816-17719-4-git-send-email-kirill.shutemov@linux.intel.com>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1368321816-17719-4-git-send-email-kirill.shutemov@linux.intel.com>
Date: Thu, 23 May 2013 18:32:28 +0800
Message-ID: <CAJd=RBA+yzrKOzZt_DL5JRgzd2H25DgEBF-JEqxuCxgdwHTWmg@mail.gmail.com>
Subject: Re: [PATCHv4 03/39] mm: implement zero_huge_user_segment and friends
From: Hillf Danton <dhillf@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave@sr71.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 9:23 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> Let's add helpers to clear huge page segment(s). They provide the same
> functionallity as zero_user_segment and zero_user, but for huge pages.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  include/linux/mm.h |    7 +++++++
>  mm/memory.c        |   36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c05d7cf..5e156fb 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1797,6 +1797,13 @@ extern void dump_page(struct page *page);
>  extern void clear_huge_page(struct page *page,
>                             unsigned long addr,
>                             unsigned int pages_per_huge_page);
> +extern void zero_huge_user_segment(struct page *page,
> +               unsigned start, unsigned end);
> +static inline void zero_huge_user(struct page *page,
> +               unsigned start, unsigned len)
> +{
> +       zero_huge_user_segment(page, start, start + len);
> +}
>  extern void copy_user_huge_page(struct page *dst, struct page *src,
>                                 unsigned long addr, struct vm_area_struct *vma,
>                                 unsigned int pages_per_huge_page);
> diff --git a/mm/memory.c b/mm/memory.c
> index f7a1fba..f02a8be 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4266,6 +4266,42 @@ void clear_huge_page(struct page *page,
>         }
>  }
>
> +void zero_huge_user_segment(struct page *page, unsigned start, unsigned end)
> +{
> +       int i;
> +       unsigned start_idx, end_idx;
> +       unsigned start_off, end_off;
> +
> +       BUG_ON(end < start);
> +
> +       might_sleep();
> +
> +       if (start == end)
> +               return;
> +
> +       start_idx = start >> PAGE_SHIFT;
> +       start_off = start & ~PAGE_MASK;
> +       end_idx = (end - 1) >> PAGE_SHIFT;
> +       end_off = ((end - 1) & ~PAGE_MASK) + 1;
> +
> +       /*
> +        * if start and end are on the same small page we can call
> +        * zero_user_segment() once and save one kmap_atomic().
> +        */
> +       if (start_idx == end_idx)
> +               return zero_user_segment(page + start_idx, start_off, end_off);
> +
> +       /* zero the first (possibly partial) page */
> +       zero_user_segment(page + start_idx, start_off, PAGE_SIZE);
> +       for (i = start_idx + 1; i < end_idx; i++) {
> +               cond_resched();
> +               clear_highpage(page + i);
> +               flush_dcache_page(page + i);

Can we use the function again?
	zero_user_segment(page + i, 0, PAGE_SIZE);

> +       }
> +       /* zero the last (possibly partial) page */
> +       zero_user_segment(page + end_idx, 0, end_off);
> +}
> +
>  static void copy_user_gigantic_page(struct page *dst, struct page *src,
>                                     unsigned long addr,
>                                     struct vm_area_struct *vma,
> --
> 1.7.10.4
>
