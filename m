Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaKSJEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:04:24 -0500
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:42085 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaKSJEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:04:16 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        Steve Capper <steve.capper@linaro.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 17/19] mlock, thp: HACK: split all pages in VM_LOCKED vma
Thread-Topic: [PATCH 17/19] mlock, thp: HACK: split all pages in VM_LOCKED
 vma
Thread-Index: AQHP+QfXFyhmO8pbREGLBmhyniiD+ZxnJmOA
Date: Wed, 19 Nov 2014 09:02:42 +0000
Message-ID: <20141119090318.GA3974@hori1.linux.bs1.fc.nec.co.jp>
References: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1415198994-15252-18-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1415198994-15252-18-git-send-email-kirill.shutemov@linux.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.17]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <F008A993104C57428C50578DFE24451F@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 04:49:52PM +0200, Kirill A. Shutemov wrote:
> We don't yet handle mlocked pages properly with new THP refcounting.
> For now we split all pages in VMA on mlock and disallow khugepaged
> collapse pages in the VMA. If split failed on mlock() we fail the
> syscall with -EBUSY.
> ---
...

> @@ -542,6 +530,60 @@ next:
>  	}
>  }
>  
> +static int thp_split(pmd_t *pmd, unsigned long addr, unsigned long end,
> +		struct mm_walk *walk)
> +{
> +	spinlock_t *ptl;
> +	struct page *page = NULL;
> +	pte_t *pte;
> +	int err = 0;
> +
> +retry:
> +	if (pmd_none(*pmd))
> +		return 0;
> +	if (pmd_trans_huge(*pmd)) {
> +		if (is_huge_zero_pmd(*pmd)) {
> +			split_huge_pmd(walk->vma, pmd, addr);
> +			return 0;
> +		}
> +		ptl = pmd_lock(walk->mm, pmd);
> +		if (!pmd_trans_huge(*pmd)) {
> +			spin_unlock(ptl);
> +			goto retry;
> +		}
> +		page = pmd_page(*pmd);
> +		VM_BUG_ON_PAGE(!PageHead(page), page);
> +		get_page(page);
> +		spin_unlock(ptl);
> +		err = split_huge_page(page);
> +		put_page(page);
> +		return err;
> +	}
> +	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> +	do {
> +		if (!pte_present(*pte))
> +			continue;
> +		page = vm_normal_page(walk->vma, addr, *pte);
> +		if (!page)
> +			continue;
> +		if (PageTransCompound(page)) {
> +			page = compound_head(page);
> +			get_page(page);
> +			spin_unlock(ptl);
> +			err = split_huge_page(page);
> +			spin_lock(ptl);
> +			put_page(page);
> +			if (!err) {
> +				VM_BUG_ON_PAGE(compound_mapcount(page), page);
> +				VM_BUG_ON_PAGE(PageTransCompound(page), page);

If split_huge_page() succeeded, we don't have to continue the iteration,
so break this loop here?

Thanks,
Naoya Horiguchi

> +			} else
> +				break;
> +		}
> +	} while (pte++, addr += PAGE_SIZE, addr != end);
> +	pte_unmap_unlock(pte - 1, ptl);
> +	return err;
> +}
> +
>  /*
>   * mlock_fixup  - handle mlock[all]/munlock[all] requests.
>   *