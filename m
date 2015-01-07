Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbbAGJhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:37:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbbAGJhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:37:02 -0500
Message-ID: <54ACFE3A.4070502@suse.cz>
Date: Wed, 07 Jan 2015 10:36:58 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, David Rientjes <rientjes@google.com>,
        Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH V4 1/4] mm: set page->pfmemalloc in prep_new_page()
References: <1420478263-25207-1-git-send-email-vbabka@suse.cz> <1420478263-25207-2-git-send-email-vbabka@suse.cz> <20150106143008.GA20860@dhcp22.suse.cz> <54AC4F5F.90306@suse.cz> <20150106214416.GA8391@dhcp22.suse.cz>
In-Reply-To: <20150106214416.GA8391@dhcp22.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 10:44 PM, Michal Hocko wrote:
> On Tue 06-01-15 22:10:55, Vlastimil Babka wrote:
>> On 01/06/2015 03:30 PM, Michal Hocko wrote:
> [...]
>> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> > index 1bb65e6f48dd..1682d766cb8e 100644
>> > --- a/mm/page_alloc.c
>> > +++ b/mm/page_alloc.c
>> > @@ -2175,10 +2175,11 @@ zonelist_scan:
>> >  		}
>> >  
>> >  try_this_zone:
>> > -		page = buffered_rmqueue(preferred_zone, zone, order,
>> > +		do {
>> > +			page = buffered_rmqueue(preferred_zone, zone, order,
>> >  						gfp_mask, migratetype);
>> > -		if (page)
>> > -			break;
>> > +		} while (page && prep_new_page(page, order, gfp_mask,
>> > +					       alloc_flags));
>> 
>> Hm but here we wouldn't return page on success.
> 
> Right.
> 
>> I wonder if you overlooked the return, hence your "not breaking out of
>> the loop" remark?
> 
> This was merely to show the intention. Sorry for not being clear enough.

OK, but I don't see other way than to follow this do-while with another

if (page)
    return page;

So I think it would be more complicated than now. We wouldn't even be able to
remove the 'try_this_zone' label, since it's used for goto from elsewhere as well.

Now that I'm thinking of it, maybe we should have a "goto zonelist_scan" there
instead. We discard a bad page and might come below the watermarks. But the
chances of this mattering are tiny I guess.


