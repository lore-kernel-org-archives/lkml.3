Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3C2F1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 01:27:08 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:45295 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3C2F1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 01:27:05 -0400
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
User-Agent: Notmuch/0.15.1+22~gc34effa (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Fri, 29 Mar 2013 10:56:00 +0530
Message-ID: <87li967p5j.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 13032905-6102-0000-0000-0000033BF7FC
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
> Little bit offtopic:
> Btw. hugetlb migration breaks to charging even before this patchset
> AFAICS. The above put_page should remove the last reference and then it
> will uncharge it but I do not see anything that would charge a new page.
> This is all because regula LRU pages are uncharged when they are
> unmapped. But this a different story not related to this series.


But when we call that put_page, we would have alreayd move the cgroup
information to the new page. We have

	h_cg = hugetlb_cgroup_from_page(oldhpage);
	set_hugetlb_cgroup(oldhpage, NULL);

	/* move the h_cg details to new cgroup */
	set_hugetlb_cgroup(newhpage, h_cg);


in hugetlb_cgroup_migrate

-aneesh

