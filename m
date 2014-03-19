Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215AbaCSQY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:24:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38767 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933824AbaCSQY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:24:57 -0400
Message-ID: <5329C4CC.2000200@oracle.com>
Date: Wed, 19 Mar 2014 12:24:44 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND -mm 2/2] mm/mempolicy.c: add comment in queue_pages_hugetlb()
References: <1395196179-4075-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1395196179-4075-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1395196179-4075-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 10:29 PM, Naoya Horiguchi wrote:
> We have a race where we try to migrate an invalid page, resulting in
> hitting VM_BUG_ON_PAGE in isolate_huge_page().
> queue_pages_hugetlb() is OK to fail, so let's check !PageHeadHuge to keep
> invalid hugepage from queuing.
>
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>   mm/mempolicy.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> diff --git v3.14-rc7-mmotm-2014-03-18-16-37.orig/mm/mempolicy.c v3.14-rc7-mmotm-2014-03-18-16-37/mm/mempolicy.c
> index 9d2ef4111a4c..ae6e2d9dc855 100644
> --- v3.14-rc7-mmotm-2014-03-18-16-37.orig/mm/mempolicy.c
> +++ v3.14-rc7-mmotm-2014-03-18-16-37/mm/mempolicy.c
> @@ -530,6 +530,17 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long addr,
>   	if (!pte_present(entry))
>   		return 0;
>   	page = pte_page(entry);
> +
> +	/*
> +	 * Trinity found that page could be a non-hugepage. This is an
> +	 * unexpected behavior, but it's not clear how this problem happens.
> +	 * So let's simply skip such corner case. Page migration can often
> +	 * fail for various reasons, so it's ok to just skip the address
> +	 * unsuitable to hugepage migration.
> +	 */
> +	if (!PageHeadHuge(page))
> +		return 0;
> +
>   	nid = page_to_nid(page);
>   	if (node_isset(nid, *qp->nmask) == !!(flags & MPOL_MF_INVERT))
>   		return 0;
>

I have to say that I really dislike this method of solving the issue.

I think it's something fine to do for testing, but this will just hide this issue
and will let it sneak upstream. I'm really not sure if the trace I've reported is
the only codepath that would trigger it, so if we let it sneak upstream we're risking
of someone hitting it some other way.


Thanks,
Sasha
