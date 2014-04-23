Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbaDWB0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:26:08 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42609 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252AbaDWB0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:26:03 -0400
Message-ID: <535716A5.6050108@kernel.dk>
Date: Tue, 22 Apr 2014 19:25:57 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Alexander Gordeev <agordeev@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when
 stealing tags
References: <cover.1395840483.git.agordeev@redhat.com>	<20140422071057.GA13195@dhcp-26-169.brq.redhat.com>	<535676A1.3070706@kernel.dk>	<5356916F.4000205@kernel.dk> <CACVXFVMXh5ZP+ZsO2fV2mdKJrJF9AHg58v5KWmt_ZbEWvszsLw@mail.gmail.com>
In-Reply-To: <CACVXFVMXh5ZP+ZsO2fV2mdKJrJF9AHg58v5KWmt_ZbEWvszsLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-22 18:53, Ming Lei wrote:
> Hi Jens,
>
> On Tue, Apr 22, 2014 at 11:57 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 04/22/2014 08:03 AM, Jens Axboe wrote:
>>> On 2014-04-22 01:10, Alexander Gordeev wrote:
>>>> On Wed, Mar 26, 2014 at 02:34:22PM +0100, Alexander Gordeev wrote:
>>>>> But other systems (more dense?) showed increased cache-hit rate
>>>>> up to 20%, i.e. this one:
>>>>
>>>> Hello Gentlemen,
>>>>
>>>> Any feedback on this?
>>>
>>> Sorry for dropping the ball on this. Improvements wrt when to steal, how
>>> much, and from whom are sorely needed in percpu_ida. I'll do a bench
>>> with this on a system that currently falls apart with it.
>>
>> Ran some quick numbers with three kernels:
>>
>> stock           3.15-rc2
>> limit           3.15-rc2 + steal limit patch (attached)
>
> I am thinking/working on this sort of improving too, but my
> idea is to compute tags->nr_max_cache by below:
>
>                     nr_tags / hctx->max_nr_ctx
>
> hctx->max_nr_ctx means the max sw queues mapped to the
> hw queue, which need to be introduced in the approach, actually,
> the value should represent the CPU topology info.
>
> It is a bit complicated to compute hctx->max_nr_ctx because
> we need to take account into CPU hotplug and probable
> user-defined mapping callback.

We can always just update the caching info, that's not a big problem. We 
update the mappings on those events anyway.

> If user-defined mapping callback needn't to be considered, the
> hctx->max_nr_ctx can be figured out before mapping sw
> queue in blk_mq_init_queue() by supposing each CPU is
> online first, once it is done, the map for offline CPU is cleared,
> then start to call blk_mq_map_swqueue().

I don't see how a user defined mapping would change things a whole lot. 
It's just another point of updating the cache. Besides, user defined 
mappings will be mostly (only?) for things like multiqueue, where the 
caching info would likely remain static over a reconfigure.

> In my null_blk test on a quad core SMP VM:
>
>       - 4 hw queue
>       - timer mode
>
> With the above approach, tag allocation from local CPU can be
> improved from:
>
>          5%   -> 50% for boot CPU
>          30% -> 90% for non-boot CPU.
>
> If no one objects the idea, I'd like to post a patch for review.

Sent it out, that can't hurt. I'll take a look at it, and give it a test 
spin as well.


-- 
Jens Axboe

