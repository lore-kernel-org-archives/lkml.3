Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab3CZMCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:02:14 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:52441 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759011Ab3CZMCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:02:12 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] memory-hotplug: enable memory hotplug to handle hugepage
In-Reply-To: <1363983835-20184-10-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1363983835-20184-10-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Notmuch/0.15.1+22~gc34effa (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Tue, 26 Mar 2013 17:31:51 +0530
Message-ID: <87620e9xow.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032611-9264-0000-0000-0000036858A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> +/* Returns true for head pages of in-use hugepages, otherwise returns false. */
> +bool is_hugepage_movable(struct page *hpage)
> +{
> +	struct page *page;
> +	struct hstate *h;
> +	bool ret = false;
> +
> +	VM_BUG_ON(!PageHuge(hpage));
> +	/*
> +	 * This function can be called for a tail page because memory hotplug
> +	 * scans movability of pages by pfn range of a memory block.
> +	 * Larger hugepages (1GB for x86_64) are larger than memory block, so
> +	 * the scan can start at the tail page of larger hugepages.
> +	 * 1GB hugepage is not movable now, so we return with false for now.
> +	 */
> +	if (PageTail(hpage))
> +		return false;
> +	h = page_hstate(hpage);
> +	spin_lock(&hugetlb_lock);
> +	list_for_each_entry(page, &h->hugepage_activelist, lru)
> +		if (page == hpage) {
> +			ret = true;
> +			break;
> +		}
> +	spin_unlock(&hugetlb_lock);
> +	return ret;
> +}
> +

May be is_hugepage_active() ?


-aneesh

