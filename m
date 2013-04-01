Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab3DAFN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 01:13:29 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:34787 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3DAFN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 01:13:28 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] soft-offline: use migrate_pages() instead of migrate_huge_page()
In-Reply-To: <20130327135250.GI16579@dhcp22.suse.cz>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1363983835-20184-4-git-send-email-n-horiguchi@ah.jp.nec.com> <87boa69z6j.fsf@linux.vnet.ibm.com> <20130327135250.GI16579@dhcp22.suse.cz>
User-Agent: Notmuch/0.15.2+52~gb714a80 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 01 Apr 2013 10:43:14 +0530
Message-ID: <874nfqesut.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040105-0260-0000-0000-000002BEB022
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Tue 26-03-13 16:59:40, Aneesh Kumar K.V wrote:
>> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:
> [...]
>> > diff --git v3.9-rc3.orig/mm/memory-failure.c v3.9-rc3/mm/memory-failure.c
>> > index df0694c..4e01082 100644
>> > --- v3.9-rc3.orig/mm/memory-failure.c
>> > +++ v3.9-rc3/mm/memory-failure.c
>> > @@ -1467,6 +1467,7 @@ static int soft_offline_huge_page(struct page *page, int flags)
>> >  	int ret;
>> >  	unsigned long pfn = page_to_pfn(page);
>> >  	struct page *hpage = compound_head(page);
>> > +	LIST_HEAD(pagelist);
>> >
>> >  	/*
>> >  	 * This double-check of PageHWPoison is to avoid the race with
>> > @@ -1482,12 +1483,20 @@ static int soft_offline_huge_page(struct page *page, int flags)
>> >  	unlock_page(hpage);
>> >
>> >  	/* Keep page count to indicate a given hugepage is isolated. */
>> > -	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL,
>> > -				MIGRATE_SYNC);
>> > -	put_page(hpage);
>> > +	list_move(&hpage->lru, &pagelist);
>> 
>> we use hpage->lru to add the hpage to h->hugepage_activelist. This will
>> break a hugetlb cgroup removal isn't it ?
>
> This particular part will not break removal because
> hugetlb_cgroup_css_offline loops until hugetlb_cgroup_have_usage is 0.
>

But we still need to hold hugetlb_lock around that right ?

-aneesh

