Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3JHQqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:46:04 -0400
Received: from www.sr71.net ([198.145.64.142]:49362 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436Ab3JHQp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:45:58 -0400
Message-ID: <525436A5.20808@sr71.net>
Date: Tue, 08 Oct 2013 09:45:25 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Robert C Jennings <rcj@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 2/2] vmsplice: Add limited zero copy to vmsplice
References: <1381177293-27125-1-git-send-email-rcj@linux.vnet.ibm.com> <1381177293-27125-3-git-send-email-rcj@linux.vnet.ibm.com>
In-Reply-To: <1381177293-27125-3-git-send-email-rcj@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 01:21 PM, Robert C Jennings wrote:
> +	if (!buf->offset && (buf->len == PAGE_SIZE) &&
> +	    (buf->flags & PIPE_BUF_FLAG_GIFT) && (sd->flags & SPLICE_F_MOVE)) {
> +		struct page *page = buf->page;
> +		struct mm_struct *mm;
> +		struct vm_area_struct *vma;
> +		spinlock_t *ptl;
> +		pte_t *ptep, pte;
> +		unsigned long useraddr;
> +
> +		if (!PageAnon(page))
> +			goto copy;
> +		if (PageCompound(page))
> +			goto copy;
> +		if (PageHuge(page) || PageTransHuge(page))
> +			goto copy;
> +		if (page_mapped(page))
> +			goto copy;

I'd really like to see some comments about those cases.  You touched on
page_mapped() above, but could you replicate some of that in a comment?

Also, considering that this is being targeted at QEMU VMs, I would
imagine that you're going to want to support PageTransHuge() in here
pretty fast.  Do you anticipate that being very much trouble?  Have you
planned for it in here?

> +		useraddr = (unsigned long)sd->u.userptr;
> +		mm = current->mm;
> +
> +		ret = -EAGAIN;
> +		down_read(&mm->mmap_sem);
> +		vma = find_vma_intersection(mm, useraddr, useraddr + PAGE_SIZE);

If oyu are only doing these a page at a time, why bother with
find_vma_intersection()?  Why not a plain find_vma()?

Also, if we fail to find a VMA, won't this return -EAGAIN?  That seems
like a rather uninformative error code to get returned back out to
userspace, especially since retrying won't help.

> +		if (IS_ERR_OR_NULL(vma))
> +			goto up_copy;
> +		if (!vma->anon_vma) {
> +			ret = anon_vma_prepare(vma);
> +			if (ret)
> +				goto up_copy;
> +		}

The first thing anon_vma_prepare() does is check vma->anon_vma.  This
extra check seems unnecessary.

> +		zap_page_range(vma, useraddr, PAGE_SIZE, NULL);
> +		ret = lock_page_killable(page);
> +		if (ret)
> +			goto up_copy;
> +		ptep = get_locked_pte(mm, useraddr, &ptl);
> +		if (!ptep)
> +			goto unlock_up_copy;
> +		pte = *ptep;
> +		if (pte_present(pte))
> +			goto unlock_up_copy;
> +		get_page(page);
> +		page_add_anon_rmap(page, vma, useraddr);
> +		pte = mk_pte(page, vma->vm_page_prot);

'pte' is getting used for two different things here, which makes it a
bit confusing.  I'd probably just skip this first assignment and
directly do:

		if (pte_present(*ptep))
			goto unlock_up_copy;

> +		set_pte_at(mm, useraddr, ptep, pte);
> +		update_mmu_cache(vma, useraddr, ptep);
> +		pte_unmap_unlock(ptep, ptl);
> +		ret = 0;
> +unlock_up_copy:
> +		unlock_page(page);
> +up_copy:
> +		up_read(&mm->mmap_sem);
> +		if (!ret) {
> +			ret = sd->len;
> +			goto out;
> +		}
> +		/* else ret < 0 and we should fallback to copying */
> +		VM_BUG_ON(ret > 0);
> +	}

This also screams to be broken out in to a helper function instead of
just being thrown in with the existing code.

