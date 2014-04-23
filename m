Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaDWAxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 20:53:51 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:37381 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaDWAxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 20:53:49 -0400
MIME-Version: 1.0
In-Reply-To: <5356916F.4000205@kernel.dk>
References: <cover.1395840483.git.agordeev@redhat.com>
	<20140422071057.GA13195@dhcp-26-169.brq.redhat.com>
	<535676A1.3070706@kernel.dk>
	<5356916F.4000205@kernel.dk>
Date: Wed, 23 Apr 2014 08:53:48 +0800
Message-ID: <CACVXFVMXh5ZP+ZsO2fV2mdKJrJF9AHg58v5KWmt_ZbEWvszsLw@mail.gmail.com>
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

Hi Jens,

On Tue, Apr 22, 2014 at 11:57 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/22/2014 08:03 AM, Jens Axboe wrote:
>> On 2014-04-22 01:10, Alexander Gordeev wrote:
>>> On Wed, Mar 26, 2014 at 02:34:22PM +0100, Alexander Gordeev wrote:
>>>> But other systems (more dense?) showed increased cache-hit rate
>>>> up to 20%, i.e. this one:
>>>
>>> Hello Gentlemen,
>>>
>>> Any feedback on this?
>>
>> Sorry for dropping the ball on this. Improvements wrt when to steal, how
>> much, and from whom are sorely needed in percpu_ida. I'll do a bench
>> with this on a system that currently falls apart with it.
>
> Ran some quick numbers with three kernels:
>
> stock           3.15-rc2
> limit           3.15-rc2 + steal limit patch (attached)

I am thinking/working on this sort of improving too, but my
idea is to compute tags->nr_max_cache by below:

                   nr_tags / hctx->max_nr_ctx

hctx->max_nr_ctx means the max sw queues mapped to the
hw queue, which need to be introduced in the approach, actually,
the value should represent the CPU topology info.

It is a bit complicated to compute hctx->max_nr_ctx because
we need to take account into CPU hotplug and probable
user-defined mapping callback.

If user-defined mapping callback needn't to be considered, the
hctx->max_nr_ctx can be figured out before mapping sw
queue in blk_mq_init_queue() by supposing each CPU is
online first, once it is done, the map for offline CPU is cleared,
then start to call blk_mq_map_swqueue().

In my null_blk test on a quad core SMP VM:

     - 4 hw queue
     - timer mode

With the above approach, tag allocation from local CPU can be
improved from:

        5%   -> 50% for boot CPU
        30% -> 90% for non-boot CPU.

If no one objects the idea, I'd like to post a patch for review.


Thanks,
-- 
Ming Lei
