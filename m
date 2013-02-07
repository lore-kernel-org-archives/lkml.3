Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab3BGDIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 22:08:25 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41576 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409Ab3BGDIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 22:08:22 -0500
Message-ID: <51131A9E.3010208@linux.vnet.ibm.com>
Date: Wed, 06 Feb 2013 21:08:14 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv3 5/6] zswap: add to mm/
References: <1359409767-30092-1-git-send-email-sjenning@linux.vnet.ibm.com> <1359409767-30092-6-git-send-email-sjenning@linux.vnet.ibm.com> <20130129062756.GH4752@blaptop> <51080658.7060709@linux.vnet.ibm.com> <a06fbc6b-8731-4bfe-82ff-05e8d14d8595@default>
In-Reply-To: <a06fbc6b-8731-4bfe-82ff-05e8d14d8595@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020703-7182-0000-0000-0000050B59FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 05:47 PM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>> Subject: Re: [PATCHv3 5/6] zswap: add to mm/
>>
>> On 01/29/2013 12:27 AM, Minchan Kim wrote:
>>> First feeling is it's simple and nice approach.
>>> Although we have some problems to decide policy, it could solve by later patch
>>> so I hope we make basic infrasture more solid by lots of comment.
>>
>> Thanks very much for the review!
>>>
>>> Another question.
>>>
>>> What's the benefit of using mempool for zsmalloc?
>>> As you know, zsmalloc doesn't use mempool as default.
>>> I guess you see some benefit. if so, zram could be changed.
>>> If we can change zsmalloc's default scheme to use mempool,
>>> all of customer of zsmalloc could be enhanced, too.
>>
>> In the case of zswap, through experimentation, I found that adding a
>> mempool behind the zsmalloc pool added some elasticity to the pool.
>> Fewer stores failed if we kept a small reserve of pages around instead
>> of having to go back to the buddy allocator who, under memory
>> pressure, is more likely to reject our request.
>>
>> I don't see this situation being applicable to all zsmalloc users
>> however.  I don't think we want incorporate it directly into zsmalloc
>> for now.  The ability to register custom page alloc/free functions at
>> pool creation time allows users to do something special, like back
>> with a mempool, if they want to do that.
> 
> (sorry, still catching up on backlog after being gone last week)
> 
> IIUC, by using mempool, you are essentially setting aside a
> special cache of pageframes that only zswap can use (or other
> users of mempool, I don't know what other subsystems use it).
> So one would expect that fewer stores would fail if more
> pageframes are available to zswap, the same as if you had
> increased zswap_max_pool_percent by some small fraction.

Yes this is correct.

> 
> But by setting those pageframes aside, you are keeping them from
> general use, which may be a use with a higher priority as determined
> by the mm system.
> 
> This seems wrong to me.  Should every subsystem hide a bunch of
> pageframes away in case it might need them?

Well, like you said, any user of mempool does this.  There were two
reasons for using it in this way in zswap:

(1) pages allocations and frees happen very frequently and going to
the buddy allocator every time for these operations is more expensive.
 Especially the free-then-alloc pattern.  Its faster to free to a
mempool (if it is below its minimum) then get that page right back,
than free to the buddy allocator and (try to) get that page back.

(2) the bursty nature of swap writeback leads to a large number of
failures if there isn't some pool of pages ready to accept them,
especially for workloads with bursty memory demands.  The workload
suddenly requests a lot of memory, the system starts swapping, zswap
asks for pages but the buddy allocator is already swamped by requests
from the workload which isn't yet being throttled by direct reclaim.
The zswap allocations all fail and pages race by into the swap device.
 Having a mempool allows for a little buffer.  By the time the buffer
is used up, hopefully the workload is being throttled and the system
is more balanced.

Thanks,
Seth

