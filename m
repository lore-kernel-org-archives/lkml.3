Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3EVMrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:47:06 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:46258 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab3EVMrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:47:05 -0400
MIME-Version: 1.0
In-Reply-To: <1368321816-17719-34-git-send-email-kirill.shutemov@linux.intel.com>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1368321816-17719-34-git-send-email-kirill.shutemov@linux.intel.com>
Date: Wed, 22 May 2013 20:47:03 +0800
Message-ID: <CAJd=RBBogFk5F=yBtQ=TWTOND5HyUJN_XrdeRCqD6Y8skoquzw@mail.gmail.com>
Subject: Re: [PATCHv4 33/39] thp, mm: implement do_huge_linear_fault()
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
> @@ -3301,12 +3335,23 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  {
>         pte_t *page_table;
>         spinlock_t *ptl;
> +       pgtable_t pgtable = NULL;
>         struct page *page, *cow_page, *dirty_page = NULL;
> -       pte_t entry;
>         bool anon = false, page_mkwrite = false;
>         bool write = flags & FAULT_FLAG_WRITE;
> +       bool thp = flags & FAULT_FLAG_TRANSHUGE;
> +       unsigned long addr_aligned;
>         struct vm_fault vmf;
> -       int ret;
> +       int nr, ret;
> +
> +       if (thp) {
> +               if (!transhuge_vma_suitable(vma, address))
> +                       return VM_FAULT_FALLBACK;
> +               if (unlikely(khugepaged_enter(vma)))

vma->vm_mm now is under the care of khugepaged, why?

> +                       return VM_FAULT_OOM;
> +               addr_aligned = address & HPAGE_PMD_MASK;
> +       } else
> +               addr_aligned = address & PAGE_MASK;
>
