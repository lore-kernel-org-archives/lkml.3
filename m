Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab3BEE3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 23:29:23 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2642 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab3BEE3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 23:29:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 04 Feb 2013 20:27:02 -0800
Message-ID: <51108A94.3060501@nvidia.com>
Date: Mon, 4 Feb 2013 20:29:08 -0800
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 2/8] gpu: host1x: Add syncpoint wait and interrupts
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-3-git-send-email-tbergstrom@nvidia.com> <20130204103032.GB27443@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130204103032.GB27443@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.02.2013 02:30, Thierry Reding wrote:
> On Tue, Jan 15, 2013 at 01:43:58PM +0200, Terje Bergstrom wrote:
> [...]
>> diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
> [...]
>> @@ -95,7 +96,6 @@ static int host1x_probe(struct platform_device *dev)
>>
>>       /* set common host1x device data */
>>       platform_set_drvdata(dev, host);
>> -
>>       host->regs = devm_request_and_ioremap(&dev->dev, regs);
>>       if (!host->regs) {
>>               dev_err(&dev->dev, "failed to remap host registers\n");
> 
> This seems an unrelated (and actually undesirable) change.
> 
>> @@ -109,28 +109,40 @@ static int host1x_probe(struct platform_device *dev)
>>       }
>>
>>       err = host1x_syncpt_init(host);
>> -     if (err)
>> +     if (err) {
>> +             dev_err(&dev->dev, "failed to init sync points");
>>               return err;
>> +     }
> 
> This error message should probably have gone in the previous patch as
> well.

Oops, will move these to previous patch. I'm pretty sure I already fixed
this once. :-(

> 
>> diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
>> index d8f5979..8376092 100644
>> --- a/drivers/gpu/host1x/dev.h
>> +++ b/drivers/gpu/host1x/dev.h
>> @@ -17,11 +17,12 @@
>>  #ifndef HOST1X_DEV_H
>>  #define HOST1X_DEV_H
>>
>> +#include <linux/platform_device.h>
>>  #include "syncpt.h"
>> +#include "intr.h"
>>
>>  struct host1x;
>>  struct host1x_syncpt;
>> -struct platform_device;
> 
> Why include platform_device.h here?

host1x_get_host() actually needs that, so this #include should've also
been in previous patch.

> 
>> @@ -34,6 +35,18 @@ struct host1x_syncpt_ops {
>>       const char * (*name)(struct host1x_syncpt *);
>>  };
>>
>> +struct host1x_intr_ops {
>> +     void (*init_host_sync)(struct host1x_intr *);
>> +     void (*set_host_clocks_per_usec)(
>> +             struct host1x_intr *, u32 clocks);
> 
> Could the above two not be combined? The only reason to keep them
> separate would be if the host1x clock was dynamically changed, but I
> don't think we support that, right?

I've left this as a placeholder to at some point start supporting host1x
clock scaling. But I don't think we're going to do that for a while, so
I could merge them.

> 
>> +     void (*set_syncpt_threshold)(
>> +             struct host1x_intr *, u32 id, u32 thresh);
>> +     void (*enable_syncpt_intr)(struct host1x_intr *, u32 id);
>> +     void (*disable_syncpt_intr)(struct host1x_intr *, u32 id);
>> +     void (*disable_all_syncpt_intrs)(struct host1x_intr *);
> 
> Can disable_all_syncpt_intrs() not be implemented generically using the
> number of syncpoints as exposed by host1x_device_info and the
> .disable_syncpt_intr() function?

disable_all_syncpt_intrs() disables all interrupts in one write (or one
per 32 sync points), so it's more efficient.

> 
>> @@ -46,11 +59,13 @@ struct host1x_device_info {
>>  struct host1x {
>>       void __iomem *regs;
>>       struct host1x_syncpt *syncpt;
>> +     struct host1x_intr intr;
>>       struct platform_device *dev;
>>       struct host1x_device_info info;
>>       struct clk *clk;
>>
>>       struct host1x_syncpt_ops syncpt_op;
>> +     struct host1x_intr_ops intr_op;
> 
> I think carrying a const pointer to the interrupt operations structure
> is a better option here.

Ok.

> 
>> diff --git a/drivers/gpu/host1x/hw/intr_hw.c b/drivers/gpu/host1x/hw/intr_hw.c
> [...]
>> +static void host1x_intr_syncpt_thresh_isr(struct host1x_intr_syncpt *syncpt);
> 
> Can we avoid this forward declaration?

I think we can, if I just move the isr to top of file.

> 
>> +static void syncpt_thresh_cascade_fn(struct work_struct *work)
> 
> syncpt_thresh_work()?

Sounds good.

> 
>> +{
>> +     struct host1x_intr_syncpt *sp =
>> +             container_of(work, struct host1x_intr_syncpt, work);
>> +     host1x_syncpt_thresh_fn(sp);
> 
> Couldn't we inline the host1x_syncpt_thresh_fn() implementation here?
> Why do we need to go through an external function declaration?

If I move syncpt_thresh_work() to intr.c from intr_hw.c, I could do
that. That'd simplify the interrupt path.

> 
>> +static irqreturn_t syncpt_thresh_cascade_isr(int irq, void *dev_id)
>> +{
>> +     struct host1x *host1x = dev_id;
>> +     struct host1x_intr *intr = &host1x->intr;
>> +     unsigned long reg;
>> +     int i, id;
>> +
>> +     for (i = 0; i < host1x->info.nb_pts / BITS_PER_LONG; i++) {
>> +             reg = host1x_sync_readl(host1x,
>> +                             HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATUS +
>> +                             i * REGISTER_STRIDE);
>> +             for_each_set_bit(id, &reg, BITS_PER_LONG) {
>> +                     struct host1x_intr_syncpt *sp =
>> +                             intr->syncpt + (i * BITS_PER_LONG + id);
>> +                     host1x_intr_syncpt_thresh_isr(sp);
> 
> Have you considered mimicking the IRQ API and name this something like
> host1x_intr_syncpt_thresh_handle() and name the actual ISR just
> syncpt_thresh_isr()? Not so important but it makes things a bit clearer
> in my opinion.

This gets a bit confusing, because we have an ISR that calls a function
that is also called ISR. I've kept "isr" in names of both to emphasize
that this is running in interrupt context. I'm open to renaming these to
make it clearer.

Did you refer to chained IRQ handler in linux/irq.h when you mentioned
IRQ API as reference for naming?

> 
>> +                     queue_work(intr->wq, &sp->work);
> 
> Should the call to queue_work() perhaps be moved into
> host1x_intr_syncpt_thresh_isr().

I'm not sure, either way would be ok to me. The current structure allows
host1x_intr_syncpt_thresh_isr() to only take one parameter
(host1x_intr_syncpt). If we move queue_work, we'd also need to pass
host1x_intr.

> 
>> +static void host1x_intr_init_host_sync(struct host1x_intr *intr)
>> +{
>> +     struct host1x *host1x = intr_to_host1x(intr);
>> +     int i, err;
>> +
>> +     host1x_sync_writel(host1x, 0xffffffffUL,
>> +             HOST1X_SYNC_SYNCPT_THRESH_INT_DISABLE);
>> +     host1x_sync_writel(host1x, 0xffffffffUL,
>> +             HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATUS);
>> +
>> +     for (i = 0; i < host1x->info.nb_pts; i++)
>> +             INIT_WORK(&intr->syncpt[i].work, syncpt_thresh_cascade_fn);
>> +
>> +     err = devm_request_irq(&host1x->dev->dev, intr->syncpt_irq,
>> +                             syncpt_thresh_cascade_isr,
>> +                             IRQF_SHARED, "host1x_syncpt", host1x);
>> +     WARN_ON(IS_ERR_VALUE(err));
> 
> Do we really want to continue in this case?

Hmm, we'd need to actually return an error code. There's not much the
driver can do without syncpt interrupts.

> 
>> +static void host1x_intr_set_syncpt_threshold(struct host1x_intr *intr,
>> +     u32 id, u32 thresh)
>> +{
>> +     struct host1x *host1x = intr_to_host1x(intr);
>> +     host1x_sync_writel(host1x, thresh,
>> +             HOST1X_SYNC_SYNCPT_INT_THRESH_0 + id * REGISTER_STRIDE);
>> +}
> 
> Again, maybe defining the register stride as part of the register
> definition might be better. I think HOST1X_SYNC_SYNCPT_INT_THRESH(id) is
> easier to read.

Sounds good.

> 
>> +static void host1x_intr_enable_syncpt_intr(struct host1x_intr *intr, u32 id)
>> +{
>> +     struct host1x *host1x = intr_to_host1x(intr);
>> +
>> +     host1x_sync_writel(host1x, BIT_MASK(id),
>> +                     HOST1X_SYNC_SYNCPT_THRESH_INT_ENABLE_CPU0 +
>> +                     BIT_WORD(id) * REGISTER_STRIDE);
>> +}
> 
> Same here.

Yep.

> 
>> +static void host1x_intr_disable_syncpt_intr(struct host1x_intr *intr, u32 id)
>> +{
>> +     struct host1x *host1x = intr_to_host1x(intr);
>> +
>> +     host1x_sync_writel(host1x, BIT_MASK(id),
>> +                     HOST1X_SYNC_SYNCPT_THRESH_INT_DISABLE +
>> +                     BIT_WORD(id) * REGISTER_STRIDE);
>> +
>> +     host1x_sync_writel(host1x, BIT_MASK(id),
>> +             HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATUS +
>> +             BIT_WORD(id) * REGISTER_STRIDE);
>> +}
> 
> And here.

Yep.

> 
>> diff --git a/drivers/gpu/host1x/intr.c b/drivers/gpu/host1x/intr.c
> [...]
>> +#include "intr.h"
>> +#include <linux/interrupt.h>
>> +#include <linux/slab.h>
>> +#include <linux/irq.h>
>> +#include "dev.h"
> 
> More funky ordering of includes.

Will fix.

> 
>> +int host1x_intr_add_action(struct host1x_intr *intr, u32 id, u32 thresh,
>> +                     enum host1x_intr_action action, void *data,
>> +                     void *_waiter,
>> +                     void **ref)
> 
> Why do you pass in _waiter as void * and not struct host1x_waitlist *?

struct host1x_waitlist is defined inside intr.c, so I've chosen to pass
void *. I could naturally just forward declare host1x_waitlist in intr.h
and change the allocation and add_action to use that.

> 
> I think I've said this before. The interface doesn't seem optimal to me
> here. Passing in an enumeration to choose which action to perform looks
> difficult to work with (not to mention the symbols are rather long and
> therefore result in ugly code).
> 
> Maybe doing this by passing around a pointer to a handler function would
> be nicer. However since I haven't really used this yet, I can't really
> tell. So maybe we should just merge the implementation as-is for now. We
> can always clean it up later.

We're using the enum also to index into arrays. We do it so that we can
remove all the completed waiters from the wait_head, and insert them
into lists per action type. This way we can run all actions in priority
order: first action_submit_complete, then action_wakeup, and then
action_wakeup_interruptible.

Now, we're recently noticed that the priority order is actually wrong.
The first priority should be to wake up non-interruptible tasks, then
interruptible tasks. Cleaning up memory of completed submits should be
lower priority.

I've considered this part as something private to host1x driver and it's
not really meant to be called f.ex. from DRM. But, as you seem to have a
need to have an asynchronous wait for a fence, we'd need to figure
something out for that.

> 
>> +void *host1x_intr_alloc_waiter(void)
>> +{
>> +     return kzalloc(sizeof(struct host1x_waitlist), GFP_KERNEL);
>> +}
> 
> I'm not sure why this is separate from host1x_syncpt_wait() since it is
> only used inside that function and the waiter returned never leaves the
> scope of that function, so it might be better to allocate it directly
> in host1x_syncpt_wait() instead.
> 
> Actually, it looks like the waiter doesn't ever leave scope, so you may
> even want to allocate it on the stack.

In patch 3, at submit time we first allocate waiter, then take
submit_lock, write submit to channel, and add the waiter while having
the lock. I did this so that I host1x_intr_add_action() can always
succeed. Otherwise I'd need to write another code path to handle the
case where we wrote a job to channel, but we're not able to add a
submit_complete action to it.

> 
>> +void host1x_intr_put_ref(struct host1x_intr *intr, u32 id, void *ref)
> 
> Here again, you pass in the waiter via a void *. Why's that?

host1x_waitlist is hidden inside intr.c.

> 
>> +int host1x_intr_init(struct host1x_intr *intr, u32 irq_sync)
> 
> Maybe you should keep the type of the irq_sync here so that it properly
> propagates to the call to devm_request_irq().

I'm not sure what you mean. Do you mean that I should use unsigned int,
as that's the type used in devm_request_irq()?

> 
>> +{
>> +     unsigned int id;
>> +     struct host1x *host1x = intr_to_host1x(intr);
>> +     u32 nb_pts = host1x_syncpt_nb_pts(host1x);
>> +
>> +     intr->syncpt = devm_kzalloc(&host1x->dev->dev,
>> +                     sizeof(struct host1x_intr_syncpt) *
>> +                     host1x->info.nb_pts,
>> +                     GFP_KERNEL);
>> +
>> +     if (!host1x->intr.syncpt)
> 
> The above blank line isn't necessary.

Will remove.

> 
>> +void host1x_intr_stop(struct host1x_intr *intr)
>> +{
>> +     unsigned int id;
>> +     struct host1x *host1x = intr_to_host1x(intr);
>> +     struct host1x_intr_syncpt *syncpt;
>> +     u32 nb_pts = host1x_syncpt_nb_pts(intr_to_host1x(intr));
>> +
>> +     mutex_lock(&intr->mutex);
>> +
>> +     host1x->intr_op.disable_all_syncpt_intrs(intr);
> 
> I haven't commented on this everywhere, but I think this could benefit
> from a wrapper that forwards this to the intr_op. The same goes for the
> sync_op.

You mean something like "host1x_disable_all_syncpt_intrs"?

> 
>> +     for (id = 0, syncpt = intr->syncpt;
>> +          id < nb_pts;
>> +          ++id, ++syncpt) {
> 
> I don't think you need to explicitly keep track of syncpt within the for
> statement. Instead you could either index intr->syncpt directly or
> obtain a reference within the loop. It allows the for statement to be
> written much more canonically.

Yep, will do.

> 
>> diff --git a/drivers/gpu/host1x/intr.h b/drivers/gpu/host1x/intr.h
> [...]
>> +#define intr_syncpt_to_intr(is) (is->intr)
> 
> This one doesn't buy you anything. It actually uses up more characters
> so you can just drop it.

True, it's useless. I'll remove.

> 
>> diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
> [...]
>> @@ -119,6 +122,166 @@ void host1x_syncpt_incr(struct host1x_syncpt *sp)
>>       host1x_syncpt_cpu_incr(sp);
>>  }
>>
>> +/*
>> + * Updated sync point form hardware, and returns true if syncpoint is expired,
>> + * false if we may need to wait
>> + */
>> +static bool syncpt_load_min_is_expired(
>> +     struct host1x_syncpt *sp,
>> +     u32 thresh)
> 
> This can all go on one line.

Ok.

> 
>> +/*
>> + * Main entrypoint for syncpoint value waits.
>> + */
>> +int host1x_syncpt_wait(struct host1x_syncpt *sp,
>> +                     u32 thresh, long timeout, u32 *value)
>> +{
> [...]
>> +}
>> +EXPORT_SYMBOL(host1x_syncpt_wait);
> 
> This doesn't only seem to be the main entrypoint, but it's basically the
> only way to currently wait for syncpoints. One actual use-case where
> this might turn out to be a problem is video capturing. The problem is
> that using this API you can't very well asynchronously capture frames.
> So eventually I think we need a way to allow a generic handler to be
> attached to syncpoints so that you can have this handler continuously
> invoked after each frame is captured and just pass the buffer back to
> userspace.

Yep, so far all asynchronous waits have been done in user space. We
would probably allow attaching a handler to a syncpt value, so that we'd
call that handler once a value is reached. In effect, similar to a
wake_up event that is now added via host1x_intr_add_action, but simpler.
That'd mean that the handler needs to be re-added after each frame.

We could also add the handler as persistent if re-adding would be a
problem. That'd require some new wiring and I'll have to think how to
implement that.

> 
>> +bool host1x_syncpt_is_expired(
>> +     struct host1x_syncpt *sp,
>> +     u32 thresh)
> 
> This can go on one line.

Will join.

Terje
