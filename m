Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3EUCMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:12:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:21334 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab3EUCMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:12:37 -0400
X-IronPort-AV: E=Sophos;i="4.87,711,1363104000"; 
   d="scan'208";a="7318598"
Message-ID: <519AD6F8.2070504@cn.fujitsu.com>
Date: Tue, 21 May 2013 10:07:52 +0800
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
References: <20130205120137.GG21389@suse.de> <20130206004234.GD11197@blaptop> <20130206095617.GN21389@suse.de> <5190AE4F.4000103@cn.fujitsu.com> <20130513091902.GP11497@suse.de> <5191B5B3.7080406@cn.fujitsu.com> <20130515132453.GB11497@suse.de> <5194748A.5070700@cn.fujitsu.com> <20130517002349.GI1008@kvack.org> <5195A3F4.70803@cn.fujitsu.com> <20130517143718.GK1008@kvack.org>
In-Reply-To: <20130517143718.GK1008@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/21 10:03:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/21 10:04:09,
	Serialize complete at 2013/05/21 10:04:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

Sorry for the late. Please see below.

On 05/17/2013 10:37 PM, Benjamin LaHaise wrote:
> On Fri, May 17, 2013 at 11:28:52AM +0800, Tang Chen wrote:
>> Hi Benjamin,
>>
>> Thank you very much for your idea. :)
>>
>> I have no objection to your idea, but seeing from your patch, this only
>> works for aio subsystem because you changed the way to allocate the aio
>> ring pages, with a file mapping.
>
> That is correct.  There is no way you're going to be able to solve this
> problem without dealing with the issue on a subsystem by subsystem basis.
>

Yes, I understand that. We need subsystem work anyway.


>> I'm working in the way Mel has said, migrate_unpin() and migrate_pin()
>> callbacks. But as you saw, I met some problems, like I don't where to put
>> these two callbacks. And discussed with you guys, I want to try this:
>>
>> 1. Add a new member to struct page, used to remember the pin holders of
>>     this page, including the pin and unpin callbacks and the necessary data.
>>     This is more like a callback chain.
>>     (I'm worry about this step, I'm not sure if it is good enough. After
>> all,
>>      we need a good place to put the callbacks.)
>
> Putting function pointers into struct page is not going to happen.  You'd
> be adding a significant amount of memory overhead for something that is
> never going to be used on the vast majority of systems (2 function pointers
> would be 16 bytes per page on a 64 bit system).  Keep in mind that distro
> kernels tend to enable almost all config options on their kernels, so the
> overhead of any approach has to make sense for the users of the kernel that
> will never make use of this kind of migration.

True. But I just cannot find a place to hold the callbacks.

>
>> 3. Call these callbacks before and after migration.
>
> How is that better than using the existing hook in address_space_operations?

I'm not saying using two callbacks before and after migration is better.
I don't want to use address_space_operations is because there is no such 
member
for anonymous pages.

In your idea, using a file mapping will create a 
address_space_operations. But
I really don't think we can modify the way of memory allocation for all the
subsystems who has this problem. Maybe not just aio and cma. That means if
you want to pin pages in memory, you have to use a file mapping. This makes
the memory allocation more complicated. And the idea should be known by all
the subsystem developers. Is that going to happen ?


I also thought about reuse one field of struct page. But as you said, there
may not be many users of this functionality. Reusing a field of struct page
will make things more complicated and lead to high coupling.


So, how about the other idea that Mel mentioned ?

We create a 1-1 mapping of pinned page ranges and the pinner (subsystem
callbacks and data), maybe a global list or a hash table. And then, we can
find the callbacks.


Thanks. :)
