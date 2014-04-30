Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011AbaD3Jky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:40:54 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:35214 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546AbaD3Jkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:40:52 -0400
MIME-Version: 1.0
In-Reply-To: <53601602.5060306@kernel.dk>
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
	<CACVXFVORX_qgJNXcB3OFpscVx0eQAbLPv2Jr1N3_yBKrPsGXFA@mail.gmail.com>
	<53601602.5060306@kernel.dk>
Date: Wed, 30 Apr 2014 17:40:51 +0800
Message-ID: <CACVXFVPq28kh1qbj1PM-COBpjxjUh=vcR7VV9qMaux6Wc9YLsg@mail.gmail.com>
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

On Wed, Apr 30, 2014 at 5:13 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/29/2014 05:35 AM, Ming Lei wrote:
>> On Sat, Apr 26, 2014 at 10:03 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 2014-04-25 18:01, Ming Lei wrote:
>>>>
>>>> Hi Jens,
>>>>
>>>> On Sat, Apr 26, 2014 at 5:23 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 04/25/2014 03:10 AM, Ming Lei wrote:
>>>>>
>>>>> Sorry, I did run it the other day. It has little to no effect here, but
>>>>> that's mostly because there's so much other crap going on in there. The
>>>>> most effective way to currently make it work better, is just to ensure
>>>>> the caching pool is of a sane size.
>>>>
>>>>
>>>> Yes, that is just what the patch is doing, :-)
>>>
>>>
>>> But it's not enough.
>>
>> Yes, the patch is only for cases of mutli hw queue and having
>> offline CPUs existed.
>>
>>> For instance, my test case, it's 255 tags and 64 CPUs.
>>> We end up in cross-cpu spinlock nightmare mode.
>>
>> IMO, the scaling problem for the above case might be
>> caused by either current percpu ida design or blk-mq's
>> usage on it.
>
> That is pretty much my claim, yes. Basically I don't think per-cpu tag
> caching is ever going to be the best solution for the combination of
> modern machines and the hardware that is out there (limited tags).
>
>> One of problems in blk-mq is that the 'set->queue_depth'
>> parameter from driver isn't scalable, maybe it is reasonable to
>> introduce 'set->min_percpu_cache', then ' tags->nr_max_cache'
>> can be computed as below:
>>
>>      max(nr_tags / hctx->nr_ctx, set->min_percpu_cache)
>>
>> Another problem in blk-mq is that if it can be improved by computing
>> tags->nr_max_cache as 'nr_tags / hctx->nr_ctx' ?  The current
>> approach should be based on that there are parallel I/O
>> activity on each CPU, but I am wondering if it is the common
>> case in reality.  Suppose there are N(N << online CPUs in
>> big machine) concurrent I/O on some of CPUs, percpu cache
>> can be increased a lot by (nr_tags / N).
>
> That would certainly help the common case, but it'd still be slow for
> the cases where you DO have IO from lots of sources. If we consider

It may be difficult to figure out a efficient solution for the unusual case.

 8-16
> tags the minimum for balanced performance, than that doesn't take a
> whole lot of CPUs to spread out the tag space. Just looking at a case
> today on SCSI with 62 tags. AHCI and friends have 31 tags. Even for the
> "bigger" case of the Micron card, you still only have 255 active tags.
> And we probably want to split that up into groups of 32, making the
> problem even worse.

Yes, that is a contradiction between having limited hardware
queue tags and requiring more local cpu cache. But it is really
a challenge to figure out an efficient approach in case that lots of
CPUs need to contend very limited resources.

Maybe blk-mq can learn network device: move the hw
queue_depth constraint into low level(such as, blk_mq_run_hw_queue()),
and keep adequate tags in the percpu pool, which means
nr_tags of percpu pool can be much bigger than queue_depth
for keeping enough percpu cache. When hw queue is full,
congestion control can be applied in blk_mq_alloc_request()
to avoid cross-cpu spinlock nightmare in percpu allocation/free.
But if device requires tag to be less than queue_depth, more
work is needed for the approach.


Thanks,
-- 
Ming Lei
