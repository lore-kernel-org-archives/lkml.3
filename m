Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab3BFUOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:14:06 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15205 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084Ab3BFUNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:13:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 06 Feb 2013 12:11:29 -0800
Message-ID: <5112B974.10301@nvidia.com>
Date: Wed, 6 Feb 2013 12:13:40 -0800
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 1/8] gpu: host1x: Add host1x driver
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-2-git-send-email-tbergstrom@nvidia.com> <20130204090941.GA27443@avionic-0098.mockup.avionic-design.de> <51107CC0.9060900@nvidia.com> <20130205074301.GA20437@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130205074301.GA20437@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.02.2013 23:43, Thierry Reding wrote:
> My point was that you could include the call to host1x_syncpt_reset()
> within host1x_syncpt_init(). That will keep unneeded code out of the
> host1x_probe() function. Also you don't want to use the syncpoints
> uninitialized, right?

Of course, sorry, I misunderstood. That makes a lot of sense.

>>>> + */
>>>> +static u32 syncpt_load_min(struct host1x_syncpt *sp)
>>>> +{
>>>> +     struct host1x *dev = sp->dev;
>>>> +     u32 old, live;
>>>> +
>>>> +     do {
>>>> +             old = host1x_syncpt_read_min(sp);
>>>> +             live = host1x_sync_readl(dev,
>>>> +                             HOST1X_SYNC_SYNCPT_0 + sp->id * 4);
>>>> +     } while ((u32)atomic_cmpxchg(&sp->min_val, old, live) != old);
>>>
>>> I think this warrants a comment.
>>
>> Sure. It just loops in case there's a race writing to min_val.
> 
> Oh, I see. That'd make a good comment. Is the cast to (u32) really
> necessary?

I'll add a comment. atomic_cmpxchg returns a signed value, so I think
the cast is needed.

> Save/restore has the disadvantage of the direction not being implicit.
> Save could mean save to hardware or save to software. The same is true
> for restore. However if the direction is clearly defined, save and
> restore work for me.
> 
> Maybe the comment could be changed to be more explicit. Something like:
> 
> 	/*
> 	 * Write cached syncpoint and waitbase values to hardware.
> 	 */
> 
> And for host1x_syncpt_save():
> 
> 	/*
> 	 * For client-managed registers, update the cached syncpoint and
> 	 * waitbase values by reading from the registers.
> 	 */

I was using save in the same way as f.ex. i915 (i915_suspend.c): save
state of hardware to RAM, restore state from RAM. I'll add proper
comments, but save and restore are for all syncpts, not only client managed.

> 
>>>> +/*
>>>> + * Updates the last value read from hardware.
>>>> + */
>>>> +u32 host1x_syncpt_load_min(struct host1x_syncpt *sp)
>>>> +{
>>>> +     u32 val;
>>>> +     val = sp->dev->syncpt_op.load_min(sp);
>>>> +     trace_host1x_syncpt_load_min(sp->id, val);
>>>> +
>>>> +     return val;
>>>> +}
> Maybe the function should be called host1x_syncpt_load() if there is no
> equivalent way to load the maximum value (since there is no register to
> read from).

Sounds good. Maximum is just a software concept.

> That's certainly true for interrupts. However, if you look at the DMA
> subsystem for example, you can also request an unnamed resource.
> 
> The difference is sufficiently subtle that host1x_syncpt_allocate()
> would work for me too, though. I just have a slight preference for
> host1x_syncpt_request().

I don't really have a strong preference, so I'll follow your suggestion.

Terje
