Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbaGAOvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:51:31 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:49481 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbaGAOva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:51:30 -0400
Date: Tue, 1 Jul 2014 17:50:58 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v9] mm: support madvise(MADV_FREE)
Message-ID: <20140701145058.GA2084@node.dhcp.inet.fi>
References: <1404174975-22019-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404174975-22019-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 09:36:15AM +0900, Minchan Kim wrote:
> +	do {
> +		/*
> +		 * XXX: We can optimize with supporting Hugepage free
> +		 * if the range covers.
> +		 */
> +		next = pmd_addr_end(addr, end);
> +		if (pmd_trans_huge(*pmd))
> +			split_huge_page_pmd(vma, addr, pmd);

Could you implement proper THP support before upstreaming the feature?
It shouldn't be a big deal.

> +		/*
> +		 * Here there can be other concurrent MADV_DONTNEED or
> +		 * trans huge page faults running, and if the pmd is
> +		 * none or trans huge it can change under us. This is
> +		 * because MADV_LAZYFREE holds the mmap_sem in read
> +		 * mode.
> +		 */
> +		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
> +			goto next;
> +		next = madvise_free_pte_range(tlb, vma, pmd, addr, next);
> +next:
> +		cond_resched();
> +	} while (pmd++, addr = next, addr != end);

-- 
 Kirill A. Shutemov
