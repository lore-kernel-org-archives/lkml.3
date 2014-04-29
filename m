Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887AbaD2Lf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:35:56 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:62862 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933750AbaD2Lfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:35:55 -0400
MIME-Version: 1.0
In-Reply-To: <535B13D7.4050202@kernel.dk>
References: <cover.1395840483.git.agordeev@redhat.com>
	<20140422071057.GA13195@dhcp-26-169.brq.redhat.com>
	<535676A1.3070706@kernel.dk>
	<5356916F.4000205@kernel.dk>
	<CACVXFVMXh5ZP+ZsO2fV2mdKJrJF9AHg58v5KWmt_ZbEWvszsLw@mail.gmail.com>
	<535716A5.6050108@kernel.dk>
	<CACVXFVN-roORYH8b-qZ10e2_wrL1W5-xO2P=A_ARPFL2GqDn2Q@mail.gmail.com>
	<535AD235.90604@kernel.dk>
	<CACVXFVPkiQT6yxse=sX1yuX8wLbr1sgbT4chQycbbPDR_A6hqA@mail.gmail.com>
	<535B13D7.4050202@kernel.dk>
Date: Tue, 29 Apr 2014 19:35:54 +0800
Message-ID: <CACVXFVORX_qgJNXcB3OFpscVx0eQAbLPv2Jr1N3_yBKrPsGXFA@mail.gmail.com>
Subject: Re: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when
 stealing tags
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 10:03 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-04-25 18:01, Ming Lei wrote:
>>
>> Hi Jens,
>>
>> On Sat, Apr 26, 2014 at 5:23 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 04/25/2014 03:10 AM, Ming Lei wrote:
>>>
>>> Sorry, I did run it the other day. It has little to no effect here, but
>>> that's mostly because there's so much other crap going on in there. The
>>> most effective way to currently make it work better, is just to ensure
>>> the caching pool is of a sane size.
>>
>>
>> Yes, that is just what the patch is doing, :-)
>
>
> But it's not enough.

Yes, the patch is only for cases of mutli hw queue and having
offline CPUs existed.

> For instance, my test case, it's 255 tags and 64 CPUs.
> We end up in cross-cpu spinlock nightmare mode.

IMO, the scaling problem for the above case might be
caused by either current percpu ida design or blk-mq's
usage on it.

One of problems in blk-mq is that the 'set->queue_depth'
parameter from driver isn't scalable, maybe it is reasonable to
introduce 'set->min_percpu_cache', then ' tags->nr_max_cache'
can be computed as below:

     max(nr_tags / hctx->nr_ctx, set->min_percpu_cache)

Another problem in blk-mq is that if it can be improved by computing
tags->nr_max_cache as 'nr_tags / hctx->nr_ctx' ?  The current
approach should be based on that there are parallel I/O
activity on each CPU, but I am wondering if it is the common
case in reality.  Suppose there are N(N << online CPUs in
big machine) concurrent I/O on some of CPUs, percpu cache
can be increased a lot by (nr_tags / N).

>
>
>> From percpu_ida view, it is easy to observe it can improve
>> allocation performance. I have several patches to export
>> these information by sysfs for monitoring percpu_ida
>> performance.
>
>
> Sounds good!

If we need exporting percpu_ida allocation/free information via
sysfs for monitoring performance, percpu ida need a parent
kobject, which means it may be better to allocate percpu_ida
tag until sw/hw queue is initialized, like the patch does.

>
>
>>> I've got an alternative tagging scheme that I think would be useful for
>>> the cases where the tag space to cpu ratio isn't big enough. So I think
>>> we'll retain percpu_ida for the cases where it can cache enough, and
>>> punt to an alternative scheme when not.
>>
>>
>> OK, care to comment on the patch or the idea of setting percpu cache
>> size as (nr_tags / hctx->nr_ctx)?
>
>
> I think it's a good idea. The problem is that for percpu_ida to be
> effective, you need a bigger cache than the 3 I'd get above. If that isn't
> the case, it performs poorly. I'm just not convinced the design can ever
> work in the realm of realistic queue depths.
>
>
>
>>> That doesn't mean we should not improve percpu_ida. There's quite a bit
>>> of low hanging fruit in there.
>>
>>
>> IMO percpu_max_size in percpu_ida is very important for the
>> performance, and it might need to adjust dynamically according
>> to the percpu allocation loading, but it is far more complicated
>> to implement. And it might be the simplest way to fix the parameter
>> before percpu_ida_init().
>
>
> That's what I did, essentially. Ensuring that the percpu_max_size is at
> least 8 makes it a whole lot better here. But still slower than a regular
> simple bitmap, which makes me sad. A fairly straight forward cmpxchg based
> scheme I tested here is around 20% faster than the bitmap approach on a
> basic desktop machine, and around 35% faster on a 4-socket. Outside of NVMe,
> I can't think of cases where that approach would not be faster than
> percpu_ida. That means all of SCSI, basically, and the basic block drivers.

If percpu_ida wants to beat bitmap allocation,  the local cache hit
ratio has to keep high, in my tests, it can be got with enough local
cache size.


Thanks,
-- 
Ming Lei
