Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaBJXGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:06:34 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33590 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaBJXGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:06:31 -0500
Message-ID: <52F95B73.7030205@kernel.dk>
Date: Mon, 10 Feb 2014 16:06:27 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>
CC: Christoph Hellwig <hch@infradead.org>,
        Alexander Gordeev <agordeev@redhat.com>, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2]percpu_ida: fix a live lock
References: <20131231033827.GA31994@kernel.org> <20140104210804.GA24199@kmo-pixel> <20140105131300.GB4186@kernel.org> <20140106204641.GB9037@kmo> <52CB1783.4050205@kernel.dk> <20140106214726.GD9037@kmo> <20140209155006.GA16149@dhcp-26-207.brq.redhat.com> <20140210103211.GA28396@infradead.org> <52F8FDA7.7070809@kernel.dk> <20140210224145.GB2362@kmo>
In-Reply-To: <20140210224145.GB2362@kmo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/10/2014 03:41 PM, Kent Overstreet wrote:
> On Mon, Feb 10, 2014 at 09:26:15AM -0700, Jens Axboe wrote:
>>
>>
>> On 02/10/2014 03:32 AM, Christoph Hellwig wrote:
>>> On Sun, Feb 09, 2014 at 04:50:07PM +0100, Alexander Gordeev wrote:
>>>> Yeah, that was my first thought when I posted "percpu_ida: Allow variable
>>>> maximum number of cached tags" patch some few months ago. But I am back-
>>>> pedalling as it does not appear solves the fundamental problem - what is the
>>>> best threshold?
>>>>
>>>> May be we can walk off with a per-cpu timeout that flushes batch nr of tags
>>> >from local caches to the pool? Each local allocation would restart the timer,
>>>> but once allocation requests stopped coming on a CPU the tags would not gather
>>>> dust in local caches.
>>>
>>> We'll defintively need a fix to be able to allow the whole tag space.
>>
>> Certainly. The current situation of effectively only allowing half
>> the tags (if spread) is pretty crappy with (by far) most hardware.
>>
>>> For large numbers of tags per device the flush might work, but for
>>> devices with low number of tags we need something more efficient.  The
>>> case of less tags than CPUs isn't that unusual either and we probably
>>> want to switch to an allocator without per cpu allocations for them to
>>> avoid all this.  E.g. for many ATA devices we just have a single tag,
>>> and many scsi drivers also only want single digit outstanding commands
>>> per LUN.
>>
>> Even for cases where you have as many (or more) CPUs than tags,
>> per-cpu allocation is not necessarily a bad idea. It's a rare case
>> where you have all the CPUs touching the device at the same time,
>> after all.
>
> <just back from Switzerland, probably forgetting some of where I left off>
>
> You do still need to have enough tags to shard across the number of cpus
> _currently_ touching the device. I think I'm with Christoph here, I'm not sure
> how percpu tag allocation would be helpful when we have single digits/low double
> digits of tags available.

For the common case, I'd assume that anywhere between 31..256 tags is 
"normal". That's where the majority of devices will end up being, 
largely. So single digits would be an anomaly.

And even for the case of 31 tags and, eg, a 64 cpu system, over windows 
of access I don't think it's unreasonable to expect that you are not 
going to have 64 threads banging on the same device.

It obviously all depends on the access pattern. X threads for X tags 
would work perfectly well with per-cpu tagging, if they are doing sync 
IO. And similarly, 8 threads each having low queue depth would be fine. 
However, it all falls apart pretty quickly if threads*qd > tag space.

> I would expect that in that case we're better off with just a well implemented
> atomic bit vector and waitlist. However, I don't know where the crossover point
> is and I think Jens has done by far the most and most relevant benchmarking
> here.

The problem with that is when you have some of those threads on 
different nodes, it ends up collapsing pretty quickly again. Maybe the 
solution is to have a hierarchy of caching instead - per-node, per-cpu. 
At least that has the potential to make the common case still perform 
better.

> How about we just make the number of tags that are allowed to be stranded an
> explicit parameter (somehow) - then it can be up to device drivers to do
> something sensible with it. Half is probably an ideal default for devices where
> that works, but this way more constrained devices will be able to futz with it
> however they want.

I don't think we should involve device drivers in this, that's punting a 
complicated issue to someone who likely has little idea what to do about 
it. This needs to be handled sensibly in the core, not in a device 
driver. If we can't come up with a sensible algorithm to handle this, 
how can we expect someone writing a device driver to do so?

-- 
Jens Axboe
