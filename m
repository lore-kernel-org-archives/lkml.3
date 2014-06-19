Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974AbaFSRpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:45:33 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:55846 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbaFSRpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:45:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140619170059.GA1224@kroah.com>
References: <20140618102957.15728.43525.stgit@patser>
	<20140618103653.15728.4942.stgit@patser>
	<20140619011327.GC10921@kroah.com>
	<CAF6AEGv4Ms+zsrEtpA10bGq04LnRjzVb925co49eVxh4ugkd=A@mail.gmail.com>
	<20140619170059.GA1224@kroah.com>
Date: Thu, 19 Jun 2014 13:45:30 -0400
Message-ID: <CAF6AEGuXKw1w=outX+QgFE2XZxV8c6pyhORL+mRp4uZR8Jnq7g@mail.gmail.com>
Subject: Re: [REPOST PATCH 1/8] fence: dma-buf cross-device synchronization (v17)
From: Rob Clark <robdclark@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Colin Cross <ccross@google.com>, Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 1:00 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Jun 19, 2014 at 10:00:18AM -0400, Rob Clark wrote:
>> On Wed, Jun 18, 2014 at 9:13 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Wed, Jun 18, 2014 at 12:36:54PM +0200, Maarten Lankhorst wrote:
>> >> +#define CREATE_TRACE_POINTS
>> >> +#include <trace/events/fence.h>
>> >> +
>> >> +EXPORT_TRACEPOINT_SYMBOL(fence_annotate_wait_on);
>> >> +EXPORT_TRACEPOINT_SYMBOL(fence_emit);
>> >
>> > Are you really willing to live with these as tracepoints for forever?
>> > What is the use of them in debugging?  Was it just for debugging the
>> > fence code, or for something else?
>> >
>> >> +/**
>> >> + * fence_context_alloc - allocate an array of fence contexts
>> >> + * @num:     [in]    amount of contexts to allocate
>> >> + *
>> >> + * This function will return the first index of the number of fences allocated.
>> >> + * The fence context is used for setting fence->context to a unique number.
>> >> + */
>> >> +unsigned fence_context_alloc(unsigned num)
>> >> +{
>> >> +     BUG_ON(!num);
>> >> +     return atomic_add_return(num, &fence_context_counter) - num;
>> >> +}
>> >> +EXPORT_SYMBOL(fence_context_alloc);
>> >
>> > EXPORT_SYMBOL_GPL()?  Same goes for all of the exports in here.
>> > Traditionally all of the driver core exports have been with this
>> > marking, any objection to making that change here as well?
>>
>> tbh, I prefer EXPORT_SYMBOL()..  well, I'd prefer even more if there
>> wasn't even a need for EXPORT_SYMBOL_GPL(), but sadly it is a fact of
>> life.  We already went through this debate once with dma-buf.  We
>> aren't going to change $evil_vendor's mind about non-gpl modules.  The
>> only result will be a more flugly convoluted solution (ie. use syncpt
>> EXPORT_SYMBOL() on top of fence EXPORT_SYMBOL_GPL()) just as a
>> workaround, with the result that no-one benefits.
>
> It has been proven that using _GPL() exports have caused companies to
> release their code "properly" over the years, so as these really are
> Linux-only apis, please change them to be marked this way, it helps
> everyone out in the end.

Well, maybe that is the true in some cases.  But it certainly didn't
work out that way for dma-buf.  And I think the end result is worse.

I don't really like coming down on the side of EXPORT_SYMBOL() instead
of EXPORT_SYMBOL_GPL(), but if we do use EXPORT_SYMBOL_GPL() then the
result will only be creative workarounds using the _GPL symbols
indirectly by whatever is available via EXPORT_SYMBOL().  I don't
really see how that will be better.

>> >> +int __fence_signal(struct fence *fence)
>> >> +{
>> >> +     struct fence_cb *cur, *tmp;
>> >> +     int ret = 0;
>> >> +
>> >> +     if (WARN_ON(!fence))
>> >> +             return -EINVAL;
>> >> +
>> >> +     if (!ktime_to_ns(fence->timestamp)) {
>> >> +             fence->timestamp = ktime_get();
>> >> +             smp_mb__before_atomic();
>> >> +     }
>> >> +
>> >> +     if (test_and_set_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
>> >> +             ret = -EINVAL;
>> >> +
>> >> +             /*
>> >> +              * we might have raced with the unlocked fence_signal,
>> >> +              * still run through all callbacks
>> >> +              */
>> >> +     } else
>> >> +             trace_fence_signaled(fence);
>> >> +
>> >> +     list_for_each_entry_safe(cur, tmp, &fence->cb_list, node) {
>> >> +             list_del_init(&cur->node);
>> >> +             cur->func(fence, cur);
>> >> +     }
>> >> +     return ret;
>> >> +}
>> >> +EXPORT_SYMBOL(__fence_signal);
>> >
>> > Don't export a function with __ in front of it, you are saying that an
>> > internal function is somehow "valid" for everyone else to call?  Why?
>> > You aren't even documenting the function, so who knows how to use it?
>>
>> fwiw, the __ versions appear to mainly be concessions for android
>> syncpt.  That is the only user outside of fence.c, and it should stay
>> that way.
>
> How are you going to "ensure" this?  And where did you document it?
> Please fix this up, it's a horrid way to create a new api.
>
> If the android code needs to be fixed to fit into this model, then fix
> it.

heh, and in fact I was wrong about this.. the __ versions are actually
for when the lock is already held.  Maarten needs to rename (ie
_locked suffix) and add some API docs for this.

>> >> +void
>> >> +__fence_init(struct fence *fence, const struct fence_ops *ops,
>> >> +          spinlock_t *lock, unsigned context, unsigned seqno)
>> >> +{
>> >> +     BUG_ON(!lock);
>> >> +     BUG_ON(!ops || !ops->wait || !ops->enable_signaling ||
>> >> +            !ops->get_driver_name || !ops->get_timeline_name);
>> >> +
>> >> +     kref_init(&fence->refcount);
>> >> +     fence->ops = ops;
>> >> +     INIT_LIST_HEAD(&fence->cb_list);
>> >> +     fence->lock = lock;
>> >> +     fence->context = context;
>> >> +     fence->seqno = seqno;
>> >> +     fence->flags = 0UL;
>> >> +
>> >> +     trace_fence_init(fence);
>> >> +}
>> >> +EXPORT_SYMBOL(__fence_init);
>> >
>> > Again with the __ exported function...
>> >
>> > I don't even see a fence_init() function anywhere, why the __ ?
>> >
>>
>> think of it as a 'protected' constructor.. only the derived fence
>> subclass should call.
>
> Where do you say this?  Again, not a good reason, fix up the api please.
>
>> >> +     kref_get(&fence->refcount);
>> >> +}
>> >
>> > Why is this inline?
>>
>> performance can be critical.. especially if the driver is using this
>> fence mechanism for internal buffers as well as shared buffers (which
>> is what I'd like to do to avoid having to deal with two different
>> fencing mechanisms for shared vs non-shared buffers), since you could
>> easily have 100's or perhaps 1000's of buffers involved in a submit.
>
> "can be".  Did you actually measure it?  Please do so.

"can be" == "depends on how the driver uses fence".  Ie. if it is only
used for buffers that are shared between devices, I wouldn't expect it
to matter.

I believe that Maarten did some measurements at some point, which
might be relevant..

At any rate, fences certainly aren't something new to graphics
drivers.  And at least in the case of TTM we are replacing code that
is directly inline with various parts of TTM with calls to static
inline fence fxns.  So for those starting w/ static-inline seems more
reasonable.. to *not* inline would be the bigger deviation from how
things work now.

>> The fence stuff does try to inline as much stuff as possible,
>> especially critical-path stuff, for this reason.
>
> Inlining code doesn't always mean "faster", in fact, on lots of
> processors and with "large" inline functions, the opposite is true.  So
> only do so if you can measure it.

fair enough.. although inline fxns here are not particularly large,
and since this is something we are retrofitting to TTM I think it is
not unreasonable to start with static-inline until proven otherwise
;-)

BR,
-R

>> >> +/**
>> >> + * fence_later - return the chronologically later fence
>> >> + * @f1:      [in]    the first fence from the same context
>> >> + * @f2:      [in]    the second fence from the same context
>> >> + *
>> >> + * Returns NULL if both fences are signaled, otherwise the fence that would be
>> >> + * signaled last. Both fences must be from the same context, since a seqno is
>> >> + * not re-used across contexts.
>> >> + */
>> >> +static inline struct fence *fence_later(struct fence *f1, struct fence *f2)
>> >> +{
>> >> +     BUG_ON(f1->context != f2->context);
>> >
>> > Nice, you just crashed the kernel, making it impossible to debug or
>> > recover :(
>>
>> agreed, that should probably be 'if (WARN_ON(...)) return NULL;'
>>
>> (but at least I wouldn't expect to hit that under console_lock so you
>> should at least see the last N lines of the backtrace on the screen
>> ;-))
>
> Lots of devices don't have console screens :)
>
> thanks,
>
> greg k-h
