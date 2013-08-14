Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab3HNXlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:41:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab3HNXlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:41:02 -0400
Date: Wed, 14 Aug 2013 16:41:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH 3/9] migrate: add hugepage migration code to
 migrate_pages()
Message-Id: <20130814164100.e4ba87e694e3c6563c91bf0e@linux-foundation.org>
In-Reply-To: <1376025702-14818-4-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1376025702-14818-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1376025702-14818-4-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Aug 2013 01:21:36 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> +static void check_hugetlb_pmd_range(struct vm_area_struct *vma, pmd_t *pmd,
> +		const nodemask_t *nodes, unsigned long flags,
> +				    void *private)
> +{
> +#ifdef CONFIG_HUGETLB_PAGE
> +	int nid;
> +	struct page *page;
> +
> +	spin_lock(&vma->vm_mm->page_table_lock);
> +	page = pte_page(huge_ptep_get((pte_t *)pmd));
> +	nid = page_to_nid(page);
> +	if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
> +		goto unlock;
> +	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
> +	if (flags & (MPOL_MF_MOVE_ALL) ||
> +	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1))
> +		isolate_huge_page(page, private);
> +unlock:
> +	spin_unlock(&vma->vm_mm->page_table_lock);
> +#else
> +	BUG();
> +#endif
> +}

The function is poorly named.  What does it "check"?  And it does more
than checking things - at actually makes alterations!

Can we have a better name here please, and some docmentation explaining
what it does and why it does it?

