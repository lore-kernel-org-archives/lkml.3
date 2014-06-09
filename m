Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbaFIUEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:04:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:9328 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543AbaFIUEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:04:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352666330"
Message-ID: <53961338.4050309@intel.com>
Date: Mon, 09 Jun 2014 13:04:08 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] mm/pagewalk: move pmd_trans_huge_lock() from callbacks
 to common code
References: <1402095520-10109-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1402095520-10109-7-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1402095520-10109-7-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 03:58 PM, Naoya Horiguchi wrote:
> @@ -6723,14 +6723,9 @@ static int mem_cgroup_count_precharge_pmd(pmd_t *pmd,
>  					struct mm_walk *walk)
>  {
>  	struct vm_area_struct *vma = walk->vma;
> -	spinlock_t *ptl;
>  
> -	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
> -		if (get_mctgt_type_thp(vma, addr, *pmd, NULL) == MC_TARGET_PAGE)
> -			mc.precharge += HPAGE_PMD_NR;
> -		spin_unlock(ptl);
> -	} else
> -		skip->control = PTWALK_DOWN;
> +	if (get_mctgt_type_thp(vma, addr, *pmd, NULL) == MC_TARGET_PAGE)
> +		mc.precharge += HPAGE_PMD_NR;
>  	return 0;
>  }

I guess my series did two things:
1. move page table walking to the walk_page_range() code
2. make new walk handler that can take arbitrarily-sizes ptes

This does (1) quite nicely and has some nice code savings.  I still
think (2) has some value, and like my approach, but this is definitely a
step in the right direction.
