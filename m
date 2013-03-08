Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356Ab3CHQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:16:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3450 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093Ab3CHQQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:16:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 08 Mar 2013 08:10:08 -0800
Message-ID: <513A0ED0.4070701@nvidia.com>
Date: Fri, 8 Mar 2013 18:16:16 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 3/8] gpu: host1x: Add channel support
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-4-git-send-email-tbergstrom@nvidia.com> <20130225152457.GA29545@avionic-0098.mockup.avionic-design.de> <512C84E2.5090201@nvidia.com>
In-Reply-To: <512C84E2.5090201@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.02.2013 11:48, Terje Bergström wrote:
> On 25.02.2013 17:24, Thierry Reding wrote:
>> You use two different styles to indent the function parameters. You
>> might want to stick to one, preferably aligning them with the first
>> parameter on the first line.
> 
> I've generally favored "two tabs" indenting, but we'll anyway
> standardize on one.

We standardized on the convention used in tegradrm, i.e. aligning with
first parameter.

>> There's nothing in this function that requires a platform_device, so
>> passing struct device should be enough. Or maybe host1x_cdma should get
>> a struct device * field?
> 
> I think we'll just start using struct device * in general in code.
> Arto's been already fixing a lot of these, so he might've already fixed
> this.

We did a sweep in the code and now I hope everything that can, uses
struct device *. The side effect was getting rid of a lot of casting,
which is good.

>> Why don't you use any of the kernel's reference counting mechanisms?
>>
>>> +void host1x_channel_put(struct host1x_channel *ch)
>>> +{
>>> +     mutex_lock(&ch->reflock);
>>> +     if (ch->refcount == 1) {
>>> +             host1x_get_host(ch->dev)->cdma_op.stop(&ch->cdma);
>>> +             host1x_cdma_deinit(&ch->cdma);
>>> +     }
>>> +     ch->refcount--;
>>> +     mutex_unlock(&ch->reflock);
>>> +}
>>
>> I think you can do all of this using a kref.
> 
> I think the original reason was that there's no reason to use atomic
> kref, as we anyway have to do mutual exclusion via mutex. But, using
> kref won't be any problem, so we could use that.

Actually, we ended up with a problem with this. kref assumes that once
refcount goes to zero, it gets destroyed. In ch->refcount, going to zero
is just fine and just indicates that we need to initialize. And, we
anyway need to do locking, so we didn't do the conversion to kref.

>>> +struct host1x_channel *host1x_channel_alloc(struct platform_device *pdev)
>>> +{
(...)
>>> +}
>>
>> I think the critical section could be shorter here. It's probably not
>> worth the extra trouble, though, given that channels are not often
>> allocated.
> 
> Yeah, boot time isn't measured in microseconds. :-) But, if we just make
> allocated_channels an atomic, we should be able to drop chlist_mutex
> altogether and it could simplify the code.

There wasn't much we could have moved outside the critical section, so
we didn't touch this area.

>> Also, is it really necessary to abstract these into an ops structure? I
>> get that newer hardware revisions might require different ops for sync-
>> point handling because the register layout or number of syncpoints may
>> be different, but the CDMA and push buffer (below) concepts are pretty
>> much a software abstraction, and as such its implementation is unlikely
>> to change with some future hardware revision.
> 
> Pushbuffer ops can become generic. There's only one catch - init uses
> the restart opcode. But the opcode is not going to change, so we can
> generalize that.

We ended up keeping the init as an operation, but rest of push buffer
ops became generic.

>>
>>> +/*
>>> + * Push two words to the push buffer
>>> + * Caller must ensure push buffer is not full
>>> + */
>>> +static void push_buffer_push_to(struct push_buffer *pb,
>>> +             struct mem_handle *handle,
>>> +             u32 op1, u32 op2)
>>> +{
>>> +     u32 cur = pb->cur;
>>> +     u32 *p = (u32 *)((u32)pb->mapped + cur);
>>
>> You do all this extra casting to make sure to increment by bytes and not
>> 32-bit words. How about you change pb->cur to contain the word index, so
>> that you don't have to go through hoops each time around.

When we changed DMASTART and DMAEND to actually denote the push buffer
area, we noticed that DMAGET and DMAPUT are actually relative to
DMASTART and DMAEND. This and the need to access both CPU and device
virtual addresses coupled with changing to word indexes didn't actually
simplify the code, so we kept still using byte indexes.

>>
>>> +/*
>>> + * Return the number of two word slots free in the push buffer
>>> + */
>>> +static u32 push_buffer_space(struct push_buffer *pb)
>>> +{
>>> +     return ((pb->fence - pb->cur) & (PUSH_BUFFER_SIZE - 1)) / 8;
>>> +}
>>
>> Why & (PUSH_BUFFER_SIZE - 1) here? fence - cur can never be larger than
>> PUSH_BUFFER_SIZE, can it?
> 
> You're right, this function doesn't need to worry about wrapping.

Arto noticed this, but actually I was wrong - the wrapping is very
possible. We just have to remember that if we're processing something at
the end of push buffer, cur might be in the end, and fence in the beginning.

>>> diff --git a/drivers/gpu/host1x/memmgr.h b/drivers/gpu/host1x/memmgr.h
>> [...]
>>> +struct mem_handle;
>>> +struct platform_device;
>>> +
>>> +struct host1x_job_unpin_data {
>>> +     struct mem_handle *h;
>>> +     struct sg_table *mem;
>>> +};
>>> +
>>> +enum mem_mgr_flag {
>>> +     mem_mgr_flag_uncacheable = 0,
>>> +     mem_mgr_flag_write_combine = 1,
>>> +};
>>
>> I'd like to see this use a more object-oriented approach and more common
>> terminology. All of these handles are essentially buffer objects, so
>> maybe something like host1x_bo would be a nice and short name.

We did this a bit differently, but following pretty much the same
principles. We have host1x_mem_handle, which contains an ops pointer.
The handle gets encapsulated inside drm_gem_cma_object.

_bo structs seem to usually contains a drm_gem_object, so we thought
it's better not to reuse that term.

Please check the code and let us know what you think. This pretty much
follows what Lucas proposed a while ago, and keeps neatly the DRM
specific parts inside the drm directory.

Other than these, we should have implemented all changes that we agreed
to include. If something's missing, it's because there were so many that
we just dropped the ball.

Terje
