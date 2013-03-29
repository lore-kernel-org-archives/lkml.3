Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3C2QX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:23:56 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:43148 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab3C2QXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:23:55 -0400
Date: Fri, 29 Mar 2013 17:23:51 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] soft-offline: use migrate_pages() instead of
 migrate_huge_page() (fwd)
Message-ID: <20130329162337.GA30407@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forwarding off-list email

On Fri 29-03-13 18:24:01, Aneesh Kumar K.V wrote:
> Michal Hocko <mhocko@suse.cz> writes:
> 
> > On Fri 29-03-13 10:56:00, Aneesh Kumar K.V wrote:
> >> Michal Hocko <mhocko@suse.cz> writes:
> > [...]
> >> > Little bit offtopic:
> >> > Btw. hugetlb migration breaks to charging even before this patchset
> >> > AFAICS. The above put_page should remove the last reference and then it
> >> > will uncharge it but I do not see anything that would charge a new page.
> >> > This is all because regula LRU pages are uncharged when they are
> >> > unmapped. But this a different story not related to this series.
> >> 
> >> 
> >> But when we call that put_page, we would have alreayd move the cgroup
> >> information to the new page. We have
> >> 
> >> 	h_cg = hugetlb_cgroup_from_page(oldhpage);
> >> 	set_hugetlb_cgroup(oldhpage, NULL);
> >> 
> >> 	/* move the h_cg details to new cgroup */
> >> 	set_hugetlb_cgroup(newhpage, h_cg);
> >> 
> >> 
> >> in hugetlb_cgroup_migrate
> >
> > Yes but the res counter charge would be missing for the newpage after
> > put_page
> >
> 
> Moving this to private as i didn't get what you meant here. 
> 
> We unchage hugepage via 
> 
> __put_compound_page -> free_huge_page -> hugetlb_cgroup_uncharge_page
> 
> That does
> 
> 	h_cg = hugetlb_cgroup_from_page(page);
> 	if (unlikely(!h_cg))
> 		return;
> 
> During migrate we do 
> 	set_hugetlb_cgroup(oldhpage, NULL);
> 
> 	/* move the h_cg details to new cgroup */
> 	set_hugetlb_cgroup(newhpage, h_cg);
> 
> So when we do a put_page(oldhpage), we won't be finding any cgroup
> attached to it and hence won't be updating the cgroup res counter value.
> 
> So not sure what you mean by res counter change would be missing for the
> newpage after put_page. I may be missing something here. Can you explain
> ?

Dang! You are right of course. I have missed the !h_cg check in
hugetlb_cgroup_uncharge_page. 

Sorry about the confusion. I am so distracted by many issues these
days...

Thanks!

-- 
Michal Hocko
SUSE Labs
