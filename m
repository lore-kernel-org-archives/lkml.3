Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab3GPDgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 23:36:14 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59830 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab3GPDgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 23:36:13 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] mm, hugetlb: move up the code which check availability of free huge page
In-Reply-To: <20130716011607.GD2430@lge.com>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com> <1373881967-16153-2-git-send-email-iamjoonsoo.kim@lge.com> <87a9lnkjlu.fsf@linux.vnet.ibm.com> <20130716011607.GD2430@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Tue, 16 Jul 2013 09:06:04 +0530
Message-ID: <87a9lni3bv.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071603-5816-0000-0000-000008ED3083
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> On Mon, Jul 15, 2013 at 07:31:33PM +0530, Aneesh Kumar K.V wrote:
>> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
>> 
>> > We don't need to proceede the processing if we don't have any usable
>> > free huge page. So move this code up.
>> 
>> I guess you can also mention that since we are holding hugetlb_lock
>> hstate values can't change.
>
> Okay. I will mention this for v2.
>
>> 
>> 
>> Also.
>> 
>> >
>> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> >
>> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> > index e2bfbf7..d87f70b 100644
>> > --- a/mm/hugetlb.c
>> > +++ b/mm/hugetlb.c
>> > @@ -539,10 +539,6 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
>> >  	struct zoneref *z;
>> >  	unsigned int cpuset_mems_cookie;
>> >
>> > -retry_cpuset:
>> > -	cpuset_mems_cookie = get_mems_allowed();
>> > -	zonelist = huge_zonelist(vma, address,
>> > -					htlb_alloc_mask, &mpol, &nodemask);
>> >  	/*
>> >  	 * A child process with MAP_PRIVATE mappings created by their parent
>> >  	 * have no page reserves. This check ensures that reservations are
>> > @@ -550,11 +546,16 @@ retry_cpuset:
>> >  	 */
>> >  	if (!vma_has_reserves(vma) &&
>> >  			h->free_huge_pages - h->resv_huge_pages == 0)
>> > -		goto err;
>> > +		return NULL;
>> >
>> 
>> If you don't do the above change, the patch will be much simpler. 
>
> The patch will be, but output code will not.
> With this change, we can remove one goto label('err:') and
> this makes code more readable.
>

If you feel stronly about the cleanup, you can do another path for the
cleanups. Don't mix things in a single patch. That makes review difficult.

-aneesh

