Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab3BFU3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:29:41 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11849 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab3BFU3j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:29:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 06 Feb 2013 12:29:32 -0800
Message-ID: <5112BD26.5060800@nvidia.com>
Date: Wed, 6 Feb 2013 12:29:26 -0800
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 2/8] gpu: host1x: Add syncpoint wait and interrupts
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-3-git-send-email-tbergstrom@nvidia.com> <20130204103032.GB27443@avionic-0098.mockup.avionic-design.de> <51108A94.3060501@nvidia.com> <20130205084255.GB20437@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130205084255.GB20437@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.02.2013 00:42, Thierry Reding wrote:
> On Mon, Feb 04, 2013 at 08:29:08PM -0800, Terje Bergström wrote:
>> host1x_get_host() actually needs that, so this #include should've also
>> been in previous patch.
> 
> No need to if you pass struct device * instead. You might need
> linux/device.h instead, though.

Can do.

> Another variant would be host1x_syncpt_irq() for the top-level handler
> and something host1x_handle_syncpt() to handle individual syncpoints. I
> like this one best, but this is pure bike-shedding and there's nothing
> technically wrong with the names you chose, so I can't really object if
> you want to stick to them.

I could use these names. They sound logical to me,too.

> 
>>>> +                     queue_work(intr->wq, &sp->work);
>>>
>>> Should the call to queue_work() perhaps be moved into
>>> host1x_intr_syncpt_thresh_isr().
>>
>> I'm not sure, either way would be ok to me. The current structure allows
>> host1x_intr_syncpt_thresh_isr() to only take one parameter
>> (host1x_intr_syncpt). If we move queue_work, we'd also need to pass
>> host1x_intr.
> 
> I think I'd still prefer to have all the code in one function because it
> make subsequent modification easier and less error-prone.

Ok, I'll do that change.

> Yeah, in that case I think we should bail out. It's not like we're
> expecting any failures. If the interrupt cannot be requested, something
> must seriously be wrong and we should tell users about it so that it can
> be fixed. Trying to continue on a best effort basis isn't useful here, I
> think.

Yep, I agree.

>> In patch 3, at submit time we first allocate waiter, then take
>> submit_lock, write submit to channel, and add the waiter while having
>> the lock. I did this so that I host1x_intr_add_action() can always
>> succeed. Otherwise I'd need to write another code path to handle the
>> case where we wrote a job to channel, but we're not able to add a
>> submit_complete action to it.
> 
> Okay. In that case why not allocate it on the stack in the first place
> so you don't have to bother with allocations (and potential failure) at
> all? The variable doesn't leave the function scope, so there shouldn't
> be any issues, right?

The submit code in patch 3 allocates a waiter, and the waiter outlives
the function scope. That waiter will clean up job queue once a job is
complete.

> Or if that doesn't work it would still be preferable to allocate memory
> in host1x_syncpt_wait() directly instead of going through the wrapper.

This was done purely, because I'm hiding the struct size from the
caller. If the caller needs to allocate, I need to expose the struct in
a header, not just a forward declaration.

>>>> +int host1x_intr_init(struct host1x_intr *intr, u32 irq_sync)
>>>
>>> Maybe you should keep the type of the irq_sync here so that it properly
>>> propagates to the call to devm_request_irq().
>>
>> I'm not sure what you mean. Do you mean that I should use unsigned int,
>> as that's the type used in devm_request_irq()?
> 
> Yes.

Ok, will do.

>>>> +void host1x_intr_stop(struct host1x_intr *intr)
>>>> +{
>>>> +     unsigned int id;
>>>> +     struct host1x *host1x = intr_to_host1x(intr);
>>>> +     struct host1x_intr_syncpt *syncpt;
>>>> +     u32 nb_pts = host1x_syncpt_nb_pts(intr_to_host1x(intr));
>>>> +
>>>> +     mutex_lock(&intr->mutex);
>>>> +
>>>> +     host1x->intr_op.disable_all_syncpt_intrs(intr);
>>>
>>> I haven't commented on this everywhere, but I think this could benefit
>>> from a wrapper that forwards this to the intr_op. The same goes for the
>>> sync_op.
>>
>> You mean something like "host1x_disable_all_syncpt_intrs"?
> 
> Yes. I think that'd be useful for each of the op functions. Perhaps you
> could even pass in a struct host1x * to make calls more uniform.

Ok, I'll add the wrapper, and I'll check if passing struct host1x *
would make sense. In effect that'd render struct host1x_intr mostly
unused, so how about if we just merge the contents of host1x_intr to host1x?

Terje
