Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974Ab3ICUxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:53:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760506Ab3ICUxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:53:47 -0400
Date: Tue, 03 Sep 2013 16:52:20 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Andi Kleen <andi@firstfloor.org>, Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        kirill.shutemov@linux.intel.com,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org
Message-ID: <1378241540-5f6r7wl-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1377883120-5280-3-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1377883120-5280-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1377883120-5280-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH 2/2] thp: support split page table lock
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1377883120-5280-3-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git v3.11-rc3.orig/mm/huge_memory.c v3.11-rc3/mm/huge_memory.c
> index 243e710..3cb29e1 100644
> --- v3.11-rc3.orig/mm/huge_memory.c
> +++ v3.11-rc3/mm/huge_memory.c
...
> @@ -864,14 +868,17 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	pmd_t pmd;
>  	pgtable_t pgtable;
>  	int ret;
> +	spinlock_t *uninitialized_var(dst_ptl), *uninitialized_var(src_ptl);
>  
>  	ret = -ENOMEM;
>  	pgtable = pte_alloc_one(dst_mm, addr);
>  	if (unlikely(!pgtable))
>  		goto out;
>  
> -	spin_lock(&dst_mm->page_table_lock);
> -	spin_lock_nested(&src_mm->page_table_lock, SINGLE_DEPTH_NESTING);
> +	dst_ptl = huge_pmd_lockptr(dst_mm, dst_ptl);
> +	src_ptl = huge_pmd_lockptr(src_mm, src_ptl);

I found one mistake. This should be:

+	dst_ptl = huge_pmd_lockptr(dst_mm, dst_pmd);
+	src_ptl = huge_pmd_lockptr(src_mm, src_pmd);

Thanks,
Naoya Horiguchi

> +	spin_lock(dst_ptl);
> +	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
>  
>  	ret = -EAGAIN;
>  	pmd = *src_pmd;
