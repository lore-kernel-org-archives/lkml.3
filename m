Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbaELPUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:20:37 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:44411 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaELPUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:20:36 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1405120858040.3090@gentwo.org>
References: <1399811500-14472-1-git-send-email-nasa4836@gmail.com> <alpine.DEB.2.10.1405120858040.3090@gentwo.org>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Mon, 12 May 2014 23:19:55 +0800
Message-ID: <CAHz2CGUfLx7DNgdNoAL0G3a9Ht6yf3bhWaojjNx91aF7L-iDQw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: add comment for __mod_zone_page_stat
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, fabf@skynet.be,
        sasha.levin@oracle.com, oleg@redhat.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, iamjoonsoo.kim@lge.com,
        kirill.shutemov@linux.intel.com, Cyrill Gorcunov <gorcunov@gmail.com>,
        dave.hansen@linux.intel.com, toshi.kani@hp.com,
        paul.gortmaker@windriver.com, srivatsa.bhat@linux.vnet.ibm.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 10:01 PM, Christoph Lameter <cl@linux.com> wrote:
> >
> >/*
> > * For use when we know that interrupts are disabled,
> > * or when we know that preemption is disabled and that
> > * particular counter cannot be updated from interrupt context.
> > */
>
> The description above looks ok to me. The problem is that you are
> considering the page related data structures as an issue for races and not
> the data structures relevant for vm statistics.

Hi,  Christoph,

Yep. I did.

Let me restate the point here.

 To use  __mod_zone_page_stat when we know that either
 1. interrupts are disabled, or
 2. preemption is disabled and that particular counter cannot be
    updated from interrupt context.

For those call sites currently using __mod_zone_page_stat, they just guarantees
the counter is never modified from an interrupt context, but doesn't disable
preemption.

This means they guarantee that even they are preemted the vm
counter won't be modified incorrectly.  Because the counter is page-related
(e.g., a new anon page added), and they are exclusively hold the pte lock.

This is why I emphasized on 'the page related data structures as an
issue for races'.

So, as you concludes in the other mail that __modd_zone_page_stat
couldn't be used.
in mlocked_vma_newpage, then what qualifies other call sites for using
it, in the same situation?
See:

void page_add_new_anon_rmap(struct page *page,
        struct vm_area_struct *vma, unsigned long address)
{
        VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
        SetPageSwapBacked(page);
        atomic_set(&page->_mapcount, 0); /* increment count (starts at -1) */
        if (PageTransHuge(page))
                __inc_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
        __mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
                        hpage_nr_pages(page));         <---  using it.
        __page_set_anon_rmap(page, vma, address, 1);
        if (!mlocked_vma_newpage(vma, page)) {     <--- couldn't use it ?
                SetPageActive(page);
                lru_cache_add(page);
        } else
                add_page_to_unevictable_list(page);
}

Hope I express it clearly enough.  Thanks.
