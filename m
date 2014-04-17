Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180AbaDQUQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:16:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbaDQUQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:16:11 -0400
Date: Thu, 17 Apr 2014 22:16:02 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michel Lespinasse <walken@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Bob Liu <lliubbo@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thp: close race between split and zap huge pages
Message-ID: <20140417201602.GI10119@redhat.com>
References: <1397598536-25074-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397598536-25074-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On Wed, Apr 16, 2014 at 12:48:56AM +0300, Kirill A. Shutemov wrote:
> -	pmd = mm_find_pmd(mm, address);
> -	if (!pmd)
> +	pgd = pgd_offset(mm, address);
> +	if (!pgd_present(*pgd))
>  		return NULL;
> +	pud = pud_offset(pgd, address);
> +	if (!pud_present(*pud))
> +		return NULL;
> +	pmd = pmd_offset(pud, address);

This fix looks good to me and it was another potential source of
trouble making the BUG_ON flakey. But the rmap_walk out of order
problem still exists too I think. Possibly the testcase doesn't
exercise that.

> -	if (pmd_none(*pmd))
> +	if (!pmd_present(*pmd))
>  		goto unlock;

pmd_present is a bit slower, but functionally it's equivalent, the
pmd_present check is just more pedantic (kind of defining the
invariants for how a mapped pmd should look like).

If we'd add native THP swapout later !pmd_present would be more
correct for the VM calls to page_check_address_pmd, but something
would need changing anyway if split_huge_page is the callee as I don't
think we can skip the conversion from trans huge swap entry to linear
swap entries and the pmd2pte conversion.

The main reason that most places that could run into a trans huge pmd
would use pmd_none and never pmd_present is that originally
pmd_present wouldn't check _PAGE_PSE and _PAGE_PRESENT can be
temporarily be cleared with pmdp_invalidate on trans huge pmds. Now
pmd_present is safe too so there's no problem in using it on trans
huge pmds.

So either pmd_none !pmd_present are fine, the functional fix is the
part above.

Thanks!
Andrea
