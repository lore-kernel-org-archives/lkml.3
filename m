Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3JIBHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:07:42 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:58894 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab3JIBHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:07:40 -0400
Message-ID: <5254AC56.3070608@gmail.com>
Date: Wed, 09 Oct 2013 10:07:34 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: snitzer@redhat.com
CC: hch@infradead.org, dm-devel@redhat.com, devel@driverdev.osuosl.org,
        thornber@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, mpatocka@redhat.com,
        dan.carpenter@oracle.com, joe@perches.com, akpm@linux-foundation.org,
        m.chehab@samsung.com, ejt@redhat.com, agk@redhat.com,
        cesarb@cesarb.net, ruby.wktk@gmail.com
Subject: Re: Reworking dm-writeboost [was: Re: staging: Add dm-writeboost]
References: <523E3522.2060607@gmail.com> <524183A2.9050301@gmail.com> <20130926034325.GO26872@dastard> <20131001082654.GA10326@debian> <alpine.LRH.2.02.1310021956130.22612@file01.intranet.prod.int.rdu2.redhat.com> <20131004020417.GF4446@dastard> <524FC4F4.6050401@gmail.com> <20131007234307.GP4446@dastard> <20131008094144.GA10261@infradead.org> <5253E06C.6040101@gmail.com> <20131008152924.GA3644@redhat.com>
In-Reply-To: <20131008152924.GA3644@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

I am happy to see that
guys from filesystem to the block subsystem
have been discussing how to handle barriers in each layer
almost independently.

>> Merging the barriers and replacing it with a single FLUSH
>> by accepting a lot of writes
>> is the reason for deferring barriers in writeboost.
>> If you want to know further I recommend you to
>> look at the source code to see
>> how queue_barrier_io() is used and
>> how the barriers are kidnapped in queue_flushing().
> 
> AFAICT, this is an unfortunate hack resulting from dm-writeboost being a
> bio-based DM target.  The block layer already has support for FLUSH
> merging, see commit ae1b1539622fb4 ("block: reimplement FLUSH/FUA to
> support merge")

I have read the comments on this patch.
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae

My understanding is that
REQ_FUA and REQ_FLUSH are decomposed to more primitive flags
in accordance with the property of the device.
{PRE|POST}FLUSH request are queued in flush_queue[one of the two]
(which is often called "pending" queue) and
calls blk_kick_flush that defers flushing and later
if few conditions are satisfied it actually inserts "a single" flush request
no matter how many flush requests are in the pending queue
(just judged by !list_empty(pending)).

If my understanding is correct,
we are deferring flush across three layers.

Let me summarize.
- For filesystem, Dave said that metadata journaling defers
  barriers.
- For device-mapper, writeboost, dm-cache and dm-thin defers
  barriers.
- For block, it defers barriers and results it to
  merging several requests into one after all.

I think writeboost can not discard this deferring hack because
deferring the barriers is usually very effective to
make it likely to fulfill the RAM buffer which
makes the write throughput higher and decrease the CPU usage.
However, for particular case such as what Dave pointed out,
this hack is just a disturbance.
Even for writeboost, the hack in the patch
is just a disturbance too unfortunately.
Upper layer dislikes the lower layers hidden optimization is
just a limitation of the layered architecture of Linux kernel.

I think these three layers are thinking almost the same thing
is that these hacks are all good and each layer
preparing a switch to turn on/off the optimization
is what we have to do for compromise.

All the problems originates from the fact that
we have volatile cache and persistent memory can
take these problems away.

With persistent memory provided
writeboost can switch off the deferring barriers.
However,
I think all the servers are equipped with
persistent memory is the future tale.
So, my idea is to maintain both modes
for RAM buffer type (volatile, non-volatile)
and in case of the former type
deferring hack is a good compromise.

Akira
