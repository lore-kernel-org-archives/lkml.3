Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaD2VNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 17:13:39 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53243 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaD2VNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 17:13:38 -0400
Message-ID: <53601602.5060306@kernel.dk>
Date: Tue, 29 Apr 2014 15:13:38 -0600
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
References: <cover.1395840483.git.agordeev@redhat.com>	<20140422071057.GA13195@dhcp-26-169.brq.redhat.com>	<535676A1.3070706@kernel.dk>	<5356916F.4000205@kernel.dk>	<CACVXFVMXh5ZP+ZsO2fV2mdKJrJF9AHg58v5KWmt_ZbEWvszsLw@mail.gmail.com>	<535716A5.6050108@kernel.dk>	<CACVXFVN-roORYH8b-qZ10e2_wrL1W5-xO2P=A_ARPFL2GqDn2Q@mail.gmail.com>	<535AD235.90604@kernel.dk>	<CACVXFVPkiQT6yxse=sX1yuX8wLbr1sgbT4chQycbbPDR_A6hqA@mail.gmail.com>	<535B13D7.4050202@kernel.dk> <CACVXFVORX_qgJNXcB3OFpscVx0eQAbLPv2Jr1N3_yBKrPsGXFA@mail.gmail.com>
In-Reply-To: <CACVXFVORX_qgJNXcB3OFpscVx0eQAbLPv2Jr1N3_yBKrPsGXFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 05:35 AM, Ming Lei wrote:
> On Sat, Apr 26, 2014 at 10:03 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2014-04-25 18:01, Ming Lei wrote:
>>>
>>> Hi Jens,
>>>
>>> On Sat, Apr 26, 2014 at 5:23 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 04/25/2014 03:10 AM, Ming Lei wrote:
>>>>
>>>> Sorry, I did run it the other day. It has little to no effect here, but
>>>> that's mostly because there's so much other crap going on in there. The
>>>> most effective way to currently make it work better, is just to ensure
>>>> the caching pool is of a sane size.
>>>
>>>
>>> Yes, that is just what the patch is doing, :-)
>>
>>
>> But it's not enough.
> 
> Yes, the patch is only for cases of mutli hw queue and having
> offline CPUs existed.
> 
>> For instance, my test case, it's 255 tags and 64 CPUs.
>> We end up in cross-cpu spinlock nightmare mode.
> 
> IMO, the scaling problem for the above case might be
> caused by either current percpu ida design or blk-mq's
> usage on it.

That is pretty much my claim, yes. Basically I don't think per-cpu tag
caching is ever going to be the best solution for the combination of
modern machines and the hardware that is out there (limited tags).

> One of problems in blk-mq is that the 'set->queue_depth'
> parameter from driver isn't scalable, maybe it is reasonable to
> introduce 'set->min_percpu_cache', then ' tags->nr_max_cache'
> can be computed as below:
> 
>      max(nr_tags / hctx->nr_ctx, set->min_percpu_cache)
> 
> Another problem in blk-mq is that if it can be improved by computing
> tags->nr_max_cache as 'nr_tags / hctx->nr_ctx' ?  The current
> approach should be based on that there are parallel I/O
> activity on each CPU, but I am wondering if it is the common
> case in reality.  Suppose there are N(N << online CPUs in
> big machine) concurrent I/O on some of CPUs, percpu cache
> can be increased a lot by (nr_tags / N).

That would certainly help the common case, but it'd still be slow for
the cases where you DO have IO from lots of sources. If we consider 8-16
tags the minimum for balanced performance, than that doesn't take a
whole lot of CPUs to spread out the tag space. Just looking at a case
today on SCSI with 62 tags. AHCI and friends have 31 tags. Even for the
"bigger" case of the Micron card, you still only have 255 active tags.
And we probably want to split that up into groups of 32, making the
problem even worse.

>> That's what I did, essentially. Ensuring that the percpu_max_size is at
>> least 8 makes it a whole lot better here. But still slower than a regular
>> simple bitmap, which makes me sad. A fairly straight forward cmpxchg based
>> scheme I tested here is around 20% faster than the bitmap approach on a
>> basic desktop machine, and around 35% faster on a 4-socket. Outside of NVMe,
>> I can't think of cases where that approach would not be faster than
>> percpu_ida. That means all of SCSI, basically, and the basic block drivers.
> 
> If percpu_ida wants to beat bitmap allocation,  the local cache hit
> ratio has to keep high, in my tests, it can be got with enough local
> cache size.

Yes, that is exactly the issue, local cache hit must be high, and you
pretty much need a higher local cache count for that. And therein lies
the problem, you can't get that high local cache size for most common
cases. With enough tags we could, but that's not what most people will run.

-- 
Jens Axboe

