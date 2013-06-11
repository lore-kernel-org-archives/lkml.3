Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab3FKJjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:39:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53091 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab3FKJjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:39:40 -0400
X-IronPort-AV: E=Sophos;i="4.87,844,1363104000"; 
   d="scan'208";a="7519758"
Message-ID: <51B6F107.80501@cn.fujitsu.com>
Date: Tue, 11 Jun 2013 17:42:31 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Lin Feng <linfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, zab@redhat.com,
        jmoyer@redhat.com, linux-mm@kvack.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [WiP]: aio support for migrating pages (Re: [PATCH V2 1/2] mm:
 hotplug: implement non-movable version of get_user_pages() called get_user_pages_non_movable())
References: <20130206095617.GN21389@suse.de> <5190AE4F.4000103@cn.fujitsu.com> <20130513091902.GP11497@suse.de> <5191B5B3.7080406@cn.fujitsu.com> <20130515132453.GB11497@suse.de> <5194748A.5070700@cn.fujitsu.com> <20130517002349.GI1008@kvack.org> <5195A3F4.70803@cn.fujitsu.com> <20130517143718.GK1008@kvack.org> <519AD6F8.2070504@cn.fujitsu.com> <20130521022733.GT1008@kvack.org>
In-Reply-To: <20130521022733.GT1008@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/11 17:37:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/11 17:37:47,
	Serialize complete at 2013/06/11 17:37:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

Are you still working on this problem ?

Thanks. :)

On 05/21/2013 10:27 AM, Benjamin LaHaise wrote:
> On Tue, May 21, 2013 at 10:07:52AM +0800, Tang Chen wrote:
> ....
>> I'm not saying using two callbacks before and after migration is better.
>> I don't want to use address_space_operations is because there is no such
>> member
>> for anonymous pages.
>
> That depends on the nature of the pinning.  For the general case of
> get_user_pages(), you're correct that it won't work for anonymous memory.
>
>> In your idea, using a file mapping will create a
>> address_space_operations. But
>> I really don't think we can modify the way of memory allocation for all the
>> subsystems who has this problem. Maybe not just aio and cma. That means if
>> you want to pin pages in memory, you have to use a file mapping. This makes
>> the memory allocation more complicated. And the idea should be known by all
>> the subsystem developers. Is that going to happen ?
>
> Different subsystems will need to use different approaches to fixing the
> issue.  I doubt any single approach will work for everything.
>
>> I also thought about reuse one field of struct page. But as you said, there
>> may not be many users of this functionality. Reusing a field of struct page
>> will make things more complicated and lead to high coupling.
>
> What happens when more than one subsystem tries to pin a particular page?
> What if it's a shared page rather than an anonymous page?
>
>> So, how about the other idea that Mel mentioned ?
>>
>> We create a 1-1 mapping of pinned page ranges and the pinner (subsystem
>> callbacks and data), maybe a global list or a hash table. And then, we can
>> find the callbacks.
>
> Maybe that is the simplest approach, but it's going to make get_user_pages()
> slower and more complicated (as if it wasn't already).  Maybe with all the
> bells and whistles of per-cpu data structures and such you can make it work,
> but I'm pretty sure someone running the large unmentionable benchmark will
> complain about the performance regressions you're going to introduce.  At
> least in the case of the AIO ring buffer, using the address_space approach
> doesn't introduce any new performance issues.  There's also the bigger
> question of if you can or cannot exclude get_user_pages_fast() from this.
> In short: you've got a lot more work on your hands to do.
>
>> Thanks. :)
>
> Cheers,
>
> 		-ben
