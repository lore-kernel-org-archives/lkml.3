Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab3HONOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:14:24 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:39384 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab3HONOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:14:21 -0400
MIME-Version: 1.0
In-Reply-To: <520CB88A.9080401@canonical.com>
References: <20130729140519.25868.86479.stgit@patser>
	<CAF6AEGtTB05-Jf1sN9RxSak6EW77Et2HM1xr=gzLHLyc9VLYOQ@mail.gmail.com>
	<520CB88A.9080401@canonical.com>
Date: Thu, 15 Aug 2013 09:14:20 -0400
Message-ID: <CAF6AEGsNYN_tu7wvzWhjkNS5XYmet9Q7MB9fC26yrSsSDEoqHw@mail.gmail.com>
Subject: Re: [RFC PATCH] fence: dma-buf cross-device synchronization (v12)
From: Rob Clark <robdclark@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 7:16 AM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
> Op 12-08-13 17:43, Rob Clark schreef:
>> On Mon, Jul 29, 2013 at 10:05 AM, Maarten Lankhorst
>> <maarten.lankhorst@canonical.com> wrote:
>>> +
[snip]
>>> +/**
>>> + * fence_add_callback - add a callback to be called when the fence
>>> + * is signaled
>>> + * @fence:     [in]    the fence to wait on
>>> + * @cb:                [in]    the callback to register
>>> + * @func:      [in]    the function to call
>>> + * @priv:      [in]    the argument to pass to function
>>> + *
>>> + * cb will be initialized by fence_add_callback, no initialization
>>> + * by the caller is required. Any number of callbacks can be registered
>>> + * to a fence, but a callback can only be registered to one fence at a time.
>>> + *
>>> + * Note that the callback can be called from an atomic context.  If
>>> + * fence is already signaled, this function will return -ENOENT (and
>>> + * *not* call the callback)
>>> + *
>>> + * Add a software callback to the fence. Same restrictions apply to
>>> + * refcount as it does to fence_wait, however the caller doesn't need to
>>> + * keep a refcount to fence afterwards: when software access is enabled,
>>> + * the creator of the fence is required to keep the fence alive until
>>> + * after it signals with fence_signal. The callback itself can be called
>>> + * from irq context.
>>> + *
>>> + */
>>> +int fence_add_callback(struct fence *fence, struct fence_cb *cb,
>>> +                      fence_func_t func, void *priv)
>>> +{
>>> +       unsigned long flags;
>>> +       int ret = 0;
>>> +       bool was_set;
>>> +
>>> +       if (WARN_ON(!fence || !func))
>>> +               return -EINVAL;
>>> +
>>> +       if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>>> +               return -ENOENT;
>>> +
>>> +       spin_lock_irqsave(fence->lock, flags);
>>> +
>>> +       was_set = test_and_set_bit(FENCE_FLAG_ENABLE_SIGNAL_BIT, &fence->flags);
>>> +
>>> +       if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>>> +               ret = -ENOENT;
>>> +       else if (!was_set && !fence->ops->enable_signaling(fence)) {
>>> +               __fence_signal(fence);
>>> +               ret = -ENOENT;
>>> +       }
>>> +
>>> +       if (!ret) {
>>> +               cb->func = func;
>>> +               cb->priv = priv;
>>> +               list_add_tail(&cb->node, &fence->cb_list);
>> since the user is providing the 'struct fence_cb', why not drop the
>> priv & func args, and have some cb-initialize macro, ie.
>>
>> INIT_FENCE_CB(&foo->fence, cbfxn);
>>
>> and I guess we can just drop priv and let the user embed fence in
>> whatever structure they like.  Ie. make it look a bit how work_struct
>> works.
> I don't mind killing priv. But a INIT_FENCE_CB macro is silly, when all it would do is set cb->func.
> So passing it as  an argument to fence_add_callback is fine, unless you have a better reason to
> do so.
>
> INIT_WORK seems to have a bit more initialization than us, it seems work can be more complicated
> than callbacks, because the callbacks can only be called once and work can be rescheduled multiple times.

yeah, INIT_WORK does more.. although maybe some day we want
INIT_FENCE_CB to do more (ie. if we add some debug features to help
catch misuse of fence/fence-cb's).  And if nothing else, having it
look a bit like other constructs that we have in the kernel seems
useful.  And with my point below, you'd want INIT_FENCE_CB to do a
INIT_LIST_HEAD(), so it is (very) slightly more than just setting the
fxn ptr.

>> maybe also, if (!list_empty(&cb->node) return -EBUSY?
> I think checking for list_empty(cb->node) is a terrible idea. This is no different from any other list corruption,
> and it's a programming error. Not a runtime error. :-)

I was thinking for crtc and page-flip, embed the fence_cb in the crtc.
 You should only use the cb once at a time, but in this case you might
want to re-use it for the next page flip.  Having something to catch
cb mis-use in this sort of scenario seems useful.

maybe how I am thinking to use fence_cb is not quite what you had in
mind.  I'm not sure.  I was trying to think how I could just directly
use fence/fence_cb in msm for everything (imported dmabuf or just
regular 'ol gem buffers).

> cb->node.next/prev may be NULL, which would fail with this check. The contents of cb->node are undefined
> before fence_add_callback is called. Calling fence_remove_callback on a fence that hasn't been added is
> undefined too. Calling fence_remove_callback works, but I'm thinking of changing the list_del_init to list_del,
> which would make calling fence_remove_callback twice a fatal error if CONFIG_DEBUG_LIST is enabled,
> and a possible memory corruption otherwise.
>>> ...
>>> +
[snip]
>>> +
>>> +/**
>>> + * fence context counter: each execution context should have its own
>>> + * fence context, this allows checking if fences belong to the same
>>> + * context or not. One device can have multiple separate contexts,
>>> + * and they're used if some engine can run independently of another.
>>> + */
>>> +extern atomic_t fence_context_counter;
>> context-alloc should not be in the critical path.. I'd think probably
>> drop the extern and inline, and make fence_context_counter static
>> inside the .c
> Shrug, your bikeshed. I'll fix it shortly.
>>> +
>>> +static inline unsigned fence_context_alloc(unsigned num)
>> well, this is actually allocating 'num' contexts, so
>> 'fence_context_alloc()' sounds a bit funny.. or at least to me it
>> sounds from the name like it allocates a single context
> Sorry, max number of bikesheds reached. :P

well, names are important to convey meaning, and not confusing users
of the API..  but fence_context*s*_alloc() also sounds a bit funny.
So I could live w/ just some kerneldoc.  Ie. move the doc about
fence_counter_contex down and make it doc about the function.  That
was a bit my point about moving the function into the .c and making
fence_context_counter static.. ie. I don't think it was your intention
that anyone accesses fence_counter_context directly, so better to
document the function and make fence_counter_context the internal
implementation detail.

Anyways, some of this is a bit nit-picky, but since fence is going to
be something used by many different drivers/subsystems, I guess it is
worthwhile to nit-pick over the API.

BR,
-R

> ~Maarten
>
