Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab3BZJsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 04:48:41 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5435 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643Ab3BZJs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 04:48:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 26 Feb 2013 01:47:23 -0800
Message-ID: <512C84E2.5090201@nvidia.com>
Date: Tue, 26 Feb 2013 11:48:18 +0200
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
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-4-git-send-email-tbergstrom@nvidia.com> <20130225152457.GA29545@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130225152457.GA29545@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.02.2013 17:24, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Jan 15, 2013 at 01:43:59PM +0200, Terje Bergstrom wrote:
> [...]
>> diff --git a/drivers/gpu/host1x/Kconfig b/drivers/gpu/host1x/Kconfig
>> index e89fb2b..57680a6 100644
>> --- a/drivers/gpu/host1x/Kconfig
>> +++ b/drivers/gpu/host1x/Kconfig
>> @@ -3,4 +3,27 @@ config TEGRA_HOST1X
>>       help
>>         Driver for the Tegra host1x hardware.
>>
>> -       Required for enabling tegradrm.
>> +       Required for enabling tegradrm and 2D acceleration.
> 
> I don't think I commented on this in the other patches, but I think this
> could use a bit more information about what host1x is. Also mentioning
> that it is a requirement for tegra-drm and 2D acceleration isn't very
> useful because it can equally well be expressed in Kconfig. If you add
> some description about what host1x is, people will know that they want
> to enable it.

Ok, we'll rewrite that. I think we can reuse the text from commit msg
that I stole from Stephen's appnote.

> 
>> +if TEGRA_HOST1X
>> +
>> +config TEGRA_HOST1X_CMA
>> +     bool "Support DRM CMA buffers"
>> +     depends on DRM
>> +     default y
>> +     select DRM_GEM_CMA_HELPER
>> +     select DRM_KMS_CMA_HELPER
>> +     help
>> +       Say yes if you wish to use DRM CMA buffers.
>> +
>> +       If unsure, choose Y.
> 
> Perhaps make this not user-selectable (for now)? If somebody disables
> this explicitly they won't get a working driver, right?

True, there's no alternative, so it should not be user selectable.

> 
>> diff --git a/drivers/gpu/host1x/cdma.c b/drivers/gpu/host1x/cdma.c
> [...]
>> +#include "cdma.h"
>> +#include "channel.h"
>> +#include "dev.h"
>> +#include "memmgr.h"
>> +#include "job.h"
>> +#include <asm/cacheflush.h>
>> +
>> +#include <linux/slab.h>
>> +#include <linux/kfifo.h>
>> +#include <linux/interrupt.h>
>> +#include <trace/events/host1x.h>
>> +
>> +#define TRACE_MAX_LENGTH 128U
> 
> "" includes generally follow <> ones.

Will do.

> 
>> +/*
>> + * Add an entry to the sync queue.
>> + */
>> +static void add_to_sync_queue(struct host1x_cdma *cdma,
>> +                           struct host1x_job *job,
>> +                           u32 nr_slots,
>> +                           u32 first_get)
>> +{
>> +     if (job->syncpt_id == NVSYNCPT_INVALID) {
>> +             dev_warn(&job->ch->dev->dev, "%s: Invalid syncpt\n",
>> +                             __func__);
>> +             return;
>> +     }
>> +
>> +     job->first_get = first_get;
>> +     job->num_slots = nr_slots;
>> +     host1x_job_get(job);
>> +     list_add_tail(&job->list, &cdma->sync_queue);
>> +}
> 
> It's a bit odd that you pass a job in here along with some parameters
> that are then assigned to the job's fields. Couldn't you just assign
> them to the job's fields before passing the job into this function?
> 
> I also see that you only use this function once, so maybe you could
> open-code it instead.

I think open coding would be the best choice. There's no real reason to
have this as separate function. That'd solve the odd parameters
phenomenon, too.

> 
>> +/*
>> + * Return the status of the cdma's sync queue or push buffer for the given event
>> + *  - sq empty: returns 1 for empty, 0 for not empty (as in "1 empty queue" :-)
>> + *  - pb space: returns the number of free slots in the channel's push buffer
>> + * Must be called with the cdma lock held.
>> + */
>> +static unsigned int cdma_status_locked(struct host1x_cdma *cdma,
>> +             enum cdma_event event)
>> +{
>> +     struct host1x *host1x = cdma_to_host1x(cdma);
>> +     switch (event) {
>> +     case CDMA_EVENT_SYNC_QUEUE_EMPTY:
>> +             return list_empty(&cdma->sync_queue) ? 1 : 0;
>> +     case CDMA_EVENT_PUSH_BUFFER_SPACE: {
>> +             struct push_buffer *pb = &cdma->push_buffer;
>> +             return host1x->cdma_pb_op.space(pb);
>> +     }
>> +     default:
>> +             return 0;
>> +     }
>> +}
> 
> Similarly this function is only used in one place and it requires a
> whole lot of documentation to define the meaning of the return value. If
> you implement this functionality directly in host1x_cdma_wait_locked()
> you have much more context and don't require all this "protocol".

I agree, this function is confusing. For some future functionality, it's
going to be called from a second place with CDMA_EVENT_SYNC_QUEUE_EMPTY,
but it's better of both of those calls are just opened up to get rid of
the extra switch().

> 
>> +/*
>> + * Start timer for a buffer submition that has completed yet.
> 
> "submission". And I don't understand the "that has completed yet" part.

It should become "Start timer that tracks the time spent by the job".

> 
>> + * Must be called with the cdma lock held.
>> + */
>> +static void cdma_start_timer_locked(struct host1x_cdma *cdma,
>> +             struct host1x_job *job)
> 
> You use two different styles to indent the function parameters. You
> might want to stick to one, preferably aligning them with the first
> parameter on the first line.

I've generally favored "two tabs" indenting, but we'll anyway
standardize on one.

> 
>> +{
>> +     struct host1x *host = cdma_to_host1x(cdma);
>> +
>> +     if (cdma->timeout.clientid) {
>> +             /* timer already started */
>> +             return;
>> +     }
>> +
>> +     cdma->timeout.clientid = job->clientid;
>> +     cdma->timeout.syncpt = host1x_syncpt_get(host, job->syncpt_id);
>> +     cdma->timeout.syncpt_val = job->syncpt_end;
>> +     cdma->timeout.start_ktime = ktime_get();
>> +
>> +     schedule_delayed_work(&cdma->timeout.wq,
>> +                     msecs_to_jiffies(job->timeout));
>> +}
>> +
>> +/*
>> + * Stop timer when a buffer submition completes.
> 
> "submission"

Will fix.

> 
>> +/*
>> + * For all sync queue entries that have already finished according to the
>> + * current sync point registers:
>> + *  - unpin & unref their mems
>> + *  - pop their push buffer slots
>> + *  - remove them from the sync queue
>> + * This is normally called from the host code's worker thread, but can be
>> + * called manually if necessary.
>> + * Must be called with the cdma lock held.
>> + */
>> +static void update_cdma_locked(struct host1x_cdma *cdma)
>> +{
>> +     bool signal = false;
>> +     struct host1x *host1x = cdma_to_host1x(cdma);
>> +     struct host1x_job *job, *n;
>> +
>> +     /* If CDMA is stopped, queue is cleared and we can return */
>> +     if (!cdma->running)
>> +             return;
>> +
>> +     /*
>> +      * Walk the sync queue, reading the sync point registers as necessary,
>> +      * to consume as many sync queue entries as possible without blocking
>> +      */
>> +     list_for_each_entry_safe(job, n, &cdma->sync_queue, list) {
>> +             struct host1x_syncpt *sp = host1x->syncpt + job->syncpt_id;
> 
> host1x_syncpt_get()?

Yes, that should be used.

> 
>> +
>> +             /* Check whether this syncpt has completed, and bail if not */
>> +             if (!host1x_syncpt_is_expired(sp, job->syncpt_end)) {
>> +                     /* Start timer on next pending syncpt */
>> +                     if (job->timeout)
>> +                             cdma_start_timer_locked(cdma, job);
>> +                     break;
>> +             }
>> +
>> +             /* Cancel timeout, when a buffer completes */
>> +             if (cdma->timeout.clientid)
>> +                     stop_cdma_timer_locked(cdma);
>> +
>> +             /* Unpin the memory */
>> +             host1x_job_unpin(job);
>> +
>> +             /* Pop push buffer slots */
>> +             if (job->num_slots) {
>> +                     struct push_buffer *pb = &cdma->push_buffer;
>> +                     host1x->cdma_pb_op.pop_from(pb, job->num_slots);
>> +                     if (cdma->event == CDMA_EVENT_PUSH_BUFFER_SPACE)
>> +                             signal = true;
>> +             }
>> +
>> +             list_del(&job->list);
>> +             host1x_job_put(job);
>> +     }
>> +
>> +     if (list_empty(&cdma->sync_queue) &&
>> +                             cdma->event == CDMA_EVENT_SYNC_QUEUE_EMPTY)
>> +                     signal = true;
> 
> This looks funny, maybe:
> 
>         if (cdma->event == CDMA_EVENT_SYNC_QUEUE_EMPTY &&
>             list_empty(&cdma->sync_queue))
>                 signal = true;
> 
> ?

Indenting at least is strange. I don't have a preference for the
ordering of conditions, so if you like the latter order, we can just use
that.

> 
>> +
>> +     /* Wake up CdmaWait() if the requested event happened */
> 
> CdmaWait()? Where's that?

host1x_cdma_wait_locked(). Will fix.

> 
>> +     if (signal) {
>> +             cdma->event = CDMA_EVENT_NONE;
>> +             up(&cdma->sem);
>> +     }
>> +}
>> +
>> +void host1x_cdma_update_sync_queue(struct host1x_cdma *cdma,
>> +             struct platform_device *dev)
> 
> There's nothing in this function that requires a platform_device, so
> passing struct device should be enough. Or maybe host1x_cdma should get
> a struct device * field?

I think we'll just start using struct device * in general in code.
Arto's been already fixing a lot of these, so he might've already fixed
this.

> 
>> +{
>> +     u32 get_restart;
> 
> Maybe just call this "restart" or "restart_addr". get_restart sounds
> like a function name.

Ok, how about "restart_dmaget_addr"? That indicates what we're doing
with the restart address.

> 
>> +     u32 syncpt_incrs;
>> +     struct host1x_job *job = NULL;
>> +     u32 syncpt_val;
>> +     struct host1x *host1x = cdma_to_host1x(cdma);
>> +
>> +     syncpt_val = host1x_syncpt_load_min(cdma->timeout.syncpt);
>> +
>> +     dev_dbg(&dev->dev,
>> +             "%s: starting cleanup (thresh %d)\n",
>> +             __func__, syncpt_val);
> 
> This fits on two lines.

Will merge.

> 
>> +
>> +     /*
>> +      * Move the sync_queue read pointer to the first entry that hasn't
>> +      * completed based on the current HW syncpt value. It's likely there
>> +      * won't be any (i.e. we're still at the head), but covers the case
>> +      * where a syncpt incr happens just prior/during the teardown.
>> +      */
>> +
>> +     dev_dbg(&dev->dev,
>> +             "%s: skip completed buffers still in sync_queue\n",
>> +             __func__);
> 
> This too.

Ok.

> 
>> +     list_for_each_entry(job, &cdma->sync_queue, list) {
>> +             if (syncpt_val < job->syncpt_end)
>> +                     break;
>> +
>> +             host1x_job_dump(&dev->dev, job);
>> +     }
> 
> That's potentially a lot of debug output. I wonder if it might make
> sense to control parts of this via a module parameter. Then again, if
> somebody really needs to debug this, maybe they really want *all* the
> information.

host1x_job_dump() uses dev_dbg(), so it only dumps a lot if DEBUG has
been defined in that file.

> 
>> +     /*
>> +      * Walk the sync_queue, first incrementing with the CPU syncpts that
>> +      * are partially executed (the first buffer) or fully skipped while
>> +      * still in the current context (slots are also NOP-ed).
>> +      *
>> +      * At the point contexts are interleaved, syncpt increments must be
>> +      * done inline with the pushbuffer from a GATHER buffer to maintain
>> +      * the order (slots are modified to be a GATHER of syncpt incrs).
>> +      *
>> +      * Note: save in get_restart the location where the timed out buffer
>> +      * started in the PB, so we can start the refetch from there (with the
>> +      * modified NOP-ed PB slots). This lets things appear to have completed
>> +      * properly for this buffer and resources are freed.
>> +      */
>> +
>> +     dev_dbg(&dev->dev,
>> +             "%s: perform CPU incr on pending same ctx buffers\n",
>> +             __func__);
> 
> Can be collapsed to two lines.

Sure.

> 
>> +
>> +     get_restart = cdma->last_put;
>> +     if (!list_empty(&cdma->sync_queue))
>> +             get_restart = job->first_get;
> 
> Perhaps:
> 
>         if (list_empty(&cdma->sync_queue))
>                 restart = cdma->last_put;
>         else
>                 restart = job->first_get;
> 
> ?

That's equivalent in functionality, and there's one less assignment for
one path, so sounds good.

> 
>> +     list_for_each_entry_from(job, &cdma->sync_queue, list)
>> +             if (job->clientid == cdma->timeout.clientid)
>> +                     job->timeout = 500;
> 
> I think this warrants a comment.

Sure. We're accelerating timing out jobs for the client that submitted
the job that timed out. But we'll add a comment. And, in downstream, we
already changed this to "job->timeout = max(job->timeout, 500), so we
should use that.

> 
>> +/*
>> + * Destroy a cdma
>> + */
>> +void host1x_cdma_deinit(struct host1x_cdma *cdma)
>> +{
>> +     struct push_buffer *pb = &cdma->push_buffer;
>> +     struct host1x *host1x = cdma_to_host1x(cdma);
>> +
>> +     if (cdma->running) {
>> +             pr_warn("%s: CDMA still running\n",
>> +                             __func__);
>> +     } else {
>> +             host1x->cdma_pb_op.destroy(pb);
>> +             host1x->cdma_op.timeout_destroy(cdma);
>> +     }
>> +}
> 
> There's no way to recover from the situation where a cdma is still
> running. Can this not return an error code (-EBUSY?) if the cdma can't
> be destroyed?

It's called from close(), which cannot return an error code. It's
actually more of a power optimization. The effect is that if there are
no users for channel, we'll just not free up the push buffer.

I think the proper fix would actually be to check in host1x_cdma_init()
if push buffer is already allocated and cdma->running. In that case we
could skip most of initialization.

> 
>> +/*
>> + * End a cdma submit
>> + * Kick off DMA, add job to the sync queue, and a number of slots to be freed
>> + * from the pushbuffer. The handles for a submit must all be pinned at the same
>> + * time, but they can be unpinned in smaller chunks.
>> + */
>> +void host1x_cdma_end(struct host1x_cdma *cdma,
>> +             struct host1x_job *job)
>> +{
>> +     struct host1x *host1x = cdma_to_host1x(cdma);
>> +     bool was_idle = list_empty(&cdma->sync_queue);
> 
> Maybe just "idle"? It reflects the current state of the CDMA, not any
> old state.

Ok.

> 
>> +
>> +     host1x->cdma_op.kick(cdma);
>> +
>> +     add_to_sync_queue(cdma,
>> +                     job,
>> +                     cdma->slots_used,
>> +                     cdma->first_get);
> 
> No need to split this over so many lines. Also, shouldn't the order be
> reversed here? I.e. first add to sync queue, then start DMA?

Yeah, I think the order should be reversed. And, we're anyway moving the
code inline, so there's no function call.

> 
>> +     /* start timer on idle -> active transitions */
>> +     if (job->timeout && was_idle)
>> +             cdma_start_timer_locked(cdma, job);
> 
> This could be part of add_to_sync_queue(), but if you open-code that as
> I suggest earlier it should obviously stay.

Yep, let's open-code that.

> 
>> diff --git a/drivers/gpu/host1x/cdma.h b/drivers/gpu/host1x/cdma.h
> [...]
>> +struct platform_device;
> 
> No need for this if you pass struct device * instead.

Will change.

> 
>> +/*
>> + * cdma
>> + *
>> + * This is in charge of a host command DMA channel.
>> + * Sends ops to a push buffer, and takes responsibility for unpinning
>> + * (& possibly freeing) of memory after those ops have completed.
>> + * Producer:
>> + *   begin
>> + *           push - send ops to the push buffer
>> + *   end - start command DMA and enqueue handles to be unpinned
>> + * Consumer:
>> + *   update - call to update sync queue and push buffer, unpin memory
>> + */
> 
> I find the name to be a bit confusing. For some reason I automatically
> think of GSM when I read CDMA. This really is more of a job queue, so
> maybe calling it host1x_job_queue might be more appropriate. But I've
> already requested a lot of things to be renamed, so I think I can live
> with this being called CDMA if you don't want to change it.
> 
> Alternatively all of these could be moved to the struct host1x_channel
> given that there's only one of each of the push_buffer, buffer_timeout
> and host1x_cma objects per channel.

I did consider merging those two at a time. That should work, as they
both deal with channels essentially. I also saw that the resulting file
and data structures became quite large, so I have so far preferred to
keep them separate.

This way I can keep the "higher level" stuff (inserting setclass,
serializing, allocating sync point ranges, etc) in one file and lower
level stuff (write to hardware, deal with push buffer pointers, etc) in
another.

> 
>> diff --git a/drivers/gpu/host1x/channel.c b/drivers/gpu/host1x/channel.c
> [...]
>> +#include "channel.h"
>> +#include "dev.h"
>> +#include "job.h"
>> +
>> +#include <linux/slab.h>
>> +#include <linux/module.h>
> 
> Again the include ordering is strange.

Will fix.

> 
>> +/*
>> + * Iterator function for host1x device list
>> + * It takes a fptr as an argument and calls that function for each
>> + * device in the list
>> + */
>> +void host1x_channel_for_all(struct host1x *host1x, void *data,
>> +     int (*fptr)(struct host1x_channel *ch, void *fdata))
>> +{
>> +     struct host1x_channel *ch;
>> +     int ret;
>> +
>> +     list_for_each_entry(ch, &host1x->chlist.list, list) {
>> +             if (ch && fptr) {
>> +                     ret = fptr(ch, data);
>> +                     if (ret) {
>> +                             pr_info("%s: iterator error\n", __func__);
>> +                             break;
>> +                     }
>> +             }
>> +     }
>> +}
> 
> Couldn't you rewrite this as a macro, similar to list_for_each_entry()
> so that users could do something like:
> 
>         host1x_for_each_channel(channel, host1x) {
>                 ...
>         }
> 
> That's a bit friendlier than having each user write a separate function
> to be called from this iterator.

Sounds good, we'll try that. My macro magic is rusty, but I trust
list_for_each_entry() will give a template.

> 
>> +int host1x_channel_submit(struct host1x_job *job)
>> +{
>> +     return host1x_get_host(job->ch->dev)->channel_op.submit(job);
>> +}
> 
> I'd expect a function named host1x_channel_submit() to take a struct
> host1x_channel *. Should this perhaps be called host1x_job_submit()?

It calls into channel code directly, and the underlying op also just
takes a job. We could add channel as a parameter, and not pass it in
host1x_job_alloc(). but we actually need the channel data already in
host1x_job_pin(), which comes before submit. We need it so that we pin
the buffer to correct engine.

> 
>> +struct host1x_channel *host1x_channel_get(struct host1x_channel *ch)
>> +{
>> +     int err = 0;
>> +
>> +     mutex_lock(&ch->reflock);
>> +     if (ch->refcount == 0)
>> +             err = host1x_cdma_init(&ch->cdma);
>> +     if (!err)
>> +             ch->refcount++;
>> +
>> +     mutex_unlock(&ch->reflock);
>> +
>> +     return err ? NULL : ch;
>> +}
> 
> Why don't you use any of the kernel's reference counting mechanisms?
> 
>> +void host1x_channel_put(struct host1x_channel *ch)
>> +{
>> +     mutex_lock(&ch->reflock);
>> +     if (ch->refcount == 1) {
>> +             host1x_get_host(ch->dev)->cdma_op.stop(&ch->cdma);
>> +             host1x_cdma_deinit(&ch->cdma);
>> +     }
>> +     ch->refcount--;
>> +     mutex_unlock(&ch->reflock);
>> +}
> 
> I think you can do all of this using a kref.

I think the original reason was that there's no reason to use atomic
kref, as we anyway have to do mutual exclusion via mutex. But, using
kref won't be any problem, so we could use that.

> 
>> +struct host1x_channel *host1x_channel_alloc(struct platform_device *pdev)
>> +{
>> +     struct host1x_channel *ch = NULL;
>> +     struct host1x *host1x = host1x_get_host(pdev);
>> +     int chindex;
>> +     int max_channels = host1x->info.nb_channels;
>> +     int err;
>> +
>> +     mutex_lock(&host1x->chlist_mutex);
>> +
>> +     chindex = host1x->allocated_channels;
>> +     if (chindex > max_channels)
>> +             goto fail;
>> +
>> +     ch = kzalloc(sizeof(*ch), GFP_KERNEL);
>> +     if (ch == NULL)
>> +             goto fail;
>> +
>> +     /* Link platform_device to host1x_channel */
>> +     err = host1x->channel_op.init(ch, host1x, chindex);
>> +     if (err < 0)
>> +             goto fail;
>> +
>> +     ch->dev = pdev;
>> +
>> +     /* Add to channel list */
>> +     list_add_tail(&ch->list, &host1x->chlist.list);
>> +
>> +     host1x->allocated_channels++;
>> +
>> +     mutex_unlock(&host1x->chlist_mutex);
>> +     return ch;
>> +
>> +fail:
>> +     dev_err(&pdev->dev, "failed to init channel\n");
>> +     kfree(ch);
>> +     mutex_unlock(&host1x->chlist_mutex);
>> +     return NULL;
>> +}
> 
> I think the critical section could be shorter here. It's probably not
> worth the extra trouble, though, given that channels are not often
> allocated.

Yeah, boot time isn't measured in microseconds. :-) But, if we just make
allocated_channels an atomic, we should be able to drop chlist_mutex
altogether and it could simplify the code.

> 
>> +void host1x_channel_free(struct host1x_channel *ch)
>> +{
>> +     struct host1x *host1x = host1x_get_host(ch->dev);
>> +     struct host1x_channel *chiter, *tmp;
>> +     list_for_each_entry_safe(chiter, tmp, &host1x->chlist.list, list) {
>> +             if (chiter == ch) {
>> +                     list_del(&chiter->list);
>> +                     kfree(ch);
>> +                     host1x->allocated_channels--;
>> +
>> +                     return;
>> +             }
>> +     }
>> +}
> 
> This doesn't free the channel if it happens to not be part of the host1x
> channel list. Perhaps an easier way to write it would be:
> 
>         host1x = host1x_get_host(ch->dev);
> 
>         list_del(&ch->list);
>         kfree(ch);
> 
>         host1x->allocated_channels--;
> 
> Looking at the rest of the code, it seems like a channel will never not
> be part of the host1x channel list, so I don't think there's a need to
> to scan the list.

I think you're right. This is just overprotective. Your variant does the
same thing with much less code.

> 
> On a side-note: generally if you break out of the loop right after
> freeing the memory of a removed node, there's no need to use the _safe
> variant since you won't be accessing the .next field of the freed node
> anyway.

That's true.

> 
> Maybe these should also adopt a similar naming as what we discussed for
> the syncpoints. That is:
> 
>         struct host1x_channel *host1x_channel_request(struct device *dev);
> 
> ?

Sounds good.

> 
>> diff --git a/drivers/gpu/host1x/channel.h b/drivers/gpu/host1x/channel.h
> [...]
>> +
>> +/*
>> + * host1x device list in debug-fs dump of host1x and client device
>> + * as well as channel state
>> + */
> 
> I don't understand this comment.

Probably because it's not a sentence and doesn't make sense. I think
it's just misplaced. We'll find its proper home.

> 
>> +struct host1x_channel {
>> +     struct list_head list;
>> +
>> +     int refcount;
>> +     int chid;
> 
> This can probably just be id. It is a field of host1x_channel, so the ch
> prefix is redundant.

Ok.

> 
>> +     struct mutex reflock;
>> +     struct mutex submitlock;
>> +     void __iomem *regs;
>> +     struct device *node;
> 
> This is never used.

Yep, let's remove "node".

> 
>> +     struct platform_device *dev;
> 
> Can this be just struct device *?

I think so. I'll let Arto look at all places where we could change
platform_device->device. He was already on it.

> 
>> +     struct cdev cdev;
> 
> This is never used.

Will remove.

> 
>> +/* channel list operations */
>> +void host1x_channel_list_init(struct host1x *);
>> +void host1x_channel_for_all(struct host1x *, void *data,
>> +     int (*fptr)(struct host1x_channel *ch, void *fdata));
>> +
>> +struct host1x_channel *host1x_channel_alloc(struct platform_device *pdev);
>> +void host1x_channel_free(struct host1x_channel *ch);
> 
> Is it a good idea to make host1x_channel_free() publicly available?
> Shouldn't the host1x_channel_alloc()/host1x_channel_request() return a
> host1x_channel with a reference count of 1 and everybody release their
> reference using host1x_channel_put() to make sure the channel is freed
> only after the last reference disappears?
> 
> Otherwise whoever calls host1x_channel_free() will confuse everybody
> else that's still keeping a reference.

The difference is that _put and _get are called to indicate how many
user space processes there are for the channel. Even if there are no
processes, we won't free the channel structure - we just freeze the channel.

_alloc and _free are different in that they actually create the channel
structs and delete them and they follow the lifecycle of the driver.
Perhaps we should figure new naming, but refcounting and alloc/free
cannot be merged here.

> 
>> diff --git a/drivers/gpu/host1x/cma.c b/drivers/gpu/host1x/cma.c
> [...]
> 
> Various spurious blank lines in this file, and the alignment of function
> parameters is off.

Will fix.

> 
>> +struct mem_handle *host1x_cma_get(u32 id, struct platform_device *dev)
> 
> I don't think this needs platform_device either.

Will fix.

> 
>> +{
>> +     struct drm_gem_cma_object *obj = to_cma_obj((void *)id);
>> +     struct mutex *struct_mutex = &obj->base.dev->struct_mutex;
>> +
>> +     mutex_lock(struct_mutex);
>> +     drm_gem_object_reference(&obj->base);
>> +     mutex_unlock(struct_mutex);
> 
> I think it's more customary to obtain a pointer to struct drm_device and
> then use mutex_{lock,unlock}(&drm->struct_mutex). Or you could just use
> drm_gem_object_reference_unlocked(&obj->base) instead. Which doesn't
> exist yet, apparently. But it could be added.

I think we could take the former path - just refer to mutex in a
different way.

>> +int host1x_cma_pin_array_ids(struct platform_device *dev,
>> +             long unsigned *ids,
>> +             long unsigned id_type_mask,
>> +             long unsigned id_type,
>> +             u32 count,
>> +             struct host1x_job_unpin_data *unpin_data,
>> +             dma_addr_t *phys_addr)
> 
> struct device * and unsigned long please. count can also doesn't need to
> be a sized type. unsigned int will do just fine. The return value can
> also be unsigned int if you don't expect to return any error conditions.

I think we'll need to check these. ids probably needs to be a u32 *, and
id_type_mask and id_type should be u32. They come like that from user space.

> 
>> +{
>> +     int i;
>> +     int pin_count = 0;
> 
> Both should be unsigned as well, and can go on one line:
> 
>         unsigned int pin_count = 0, i;

Ok.

> 
>> diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
> [...]
>>  struct host1x;
>> +struct host1x_intr;
>>  struct host1x_syncpt;
>> +struct host1x_channel;
>> +struct host1x_cdma;
>> +struct host1x_job;
>> +struct push_buffer;
>> +struct dentry;
> 
> I think this already belongs in a previous patch. The debugfs dentry
> isn't added in this patch.

Ok, that was a mistake I did when I re-split after one of the previous
rounds. I compiled (at least thought I did) after each patch, so it
might be that these aren't actually needed.

> 
>> +struct host1x_channel_ops {
>> +     int (*init)(struct host1x_channel *,
>> +                 struct host1x *,
>> +                 int chid);
> 
> Please add the parameter names as well (the same goes for all ops
> declared in this file). And "id" will be enough. Also the channel ID can
> surely be unsigned, right?

Sure to all of these.

> 
>> +struct host1x_cdma_ops {
>> +     void (*start)(struct host1x_cdma *);
>> +     void (*stop)(struct host1x_cdma *);
>> +     void (*kick)(struct  host1x_cdma *);
>> +     int (*timeout_init)(struct host1x_cdma *,
>> +                         u32 syncpt_id);
>> +     void (*timeout_destroy)(struct host1x_cdma *);
>> +     void (*timeout_teardown_begin)(struct host1x_cdma *);
>> +     void (*timeout_teardown_end)(struct host1x_cdma *,
>> +                                  u32 getptr);
>> +     void (*timeout_cpu_incr)(struct host1x_cdma *,
>> +                              u32 getptr,
>> +                              u32 syncpt_incrs,
>> +                              u32 syncval,
>> +                              u32 nr_slots);
>> +};
> 
> Can the timeout_ prefix not be dropped? The functions are generally
> useful and not directly related to timeouts, even though they seem to
> only be used during timeout handling.

All the timeout functions actually access the timeout struct, so they're
not generic. Teardown functions are the only ones which don't access
timeout.

> 
> Also, is it really necessary to abstract these into an ops structure? I
> get that newer hardware revisions might require different ops for sync-
> point handling because the register layout or number of syncpoints may
> be different, but the CDMA and push buffer (below) concepts are pretty
> much a software abstraction, and as such its implementation is unlikely
> to change with some future hardware revision.

Pushbuffer ops can become generic. There's only one catch - init uses
the restart opcode. But the opcode is not going to change, so we can
generalize that.

> 
>> +struct host1x_pushbuffer_ops {
>> +     void (*reset)(struct push_buffer *);
>> +     int (*init)(struct push_buffer *);
>> +     void (*destroy)(struct push_buffer *);
>> +     void (*push_to)(struct push_buffer *,
>> +                     struct mem_handle *,
>> +                     u32 op1, u32 op2);
>> +     void (*pop_from)(struct push_buffer *,
>> +                      unsigned int slots);
> 
> Maybe just push() and pop()?

Can do.

> 
>> +     u32 (*space)(struct push_buffer *);
>> +     u32 (*putptr)(struct push_buffer *);
>> +};
>>
>>  struct host1x_syncpt_ops {
>>       void (*reset)(struct host1x_syncpt *);
>> @@ -64,9 +111,19 @@ struct host1x {
>>       struct host1x_device_info info;
>>       struct clk *clk;
>>
>> +     /* Sync point dedicated to replacing waits for expired fences */
>> +     struct host1x_syncpt *nop_sp;
>> +
>> +     struct host1x_channel_ops channel_op;
>> +     struct host1x_cdma_ops cdma_op;
>> +     struct host1x_pushbuffer_ops cdma_pb_op;
>>       struct host1x_syncpt_ops syncpt_op;
>>       struct host1x_intr_ops intr_op;
>>
>> +     struct mutex chlist_mutex;
>> +     struct host1x_channel chlist;
> 
> Shouldn't this just be struct list_head?

I think you're right, to follow the normal kernel conventions.

> 
>> +     int allocated_channels;
> 
> unsigned int? And maybe just "num_channels"?

num_channels could be thought as "number of available channels", so I'd
like to use num_allocated_channels here.

> 
>> diff --git a/drivers/gpu/host1x/host1x.h b/drivers/gpu/host1x/host1x.h
> [...]
>> +enum host1x_class {
>> +     NV_HOST1X_CLASS_ID              = 0x1,
>> +     NV_GRAPHICS_2D_CLASS_ID         = 0x51,
> 
> This entry belongs in a later patch, right? And I find it convenient if
> enumeration constants start with the enum name as prefix. Furthermore
> it'd be nice to reuse the hardware module names, like so:
> 
>         enum host1x_class {
>                 HOST1X_CLASS_HOST1X,
>                 HOST1X_CLASS_GR2D,
>                 HOST1X_CLASS_GR3D,
>         };

The naming sounds good. We already use HOST1X_CLASS_HOST1X in code to
insert a wait. If you'd prefer, we can move the definition of
HOST1X_CLASS_GR2D to the later patch.

> 
>> diff --git a/drivers/gpu/host1x/hw/cdma_hw.c b/drivers/gpu/host1x/hw/cdma_hw.c
> [...]
>> +#include <linux/slab.h>
>> +#include <linux/scatterlist.h>
>> +#include <linux/dma-mapping.h>
>> +#include "cdma.h"
>> +#include "channel.h"
>> +#include "dev.h"
>> +#include "memmgr.h"
>> +
>> +#include "cdma_hw.h"
>> +
>> +static inline u32 host1x_channel_dmactrl(int stop, int get_rst, int init_get)
>> +{
>> +     return HOST1X_CHANNEL_DMACTRL_DMASTOP_F(stop)
>> +             | HOST1X_CHANNEL_DMACTRL_DMAGETRST_F(get_rst)
>> +             | HOST1X_CHANNEL_DMACTRL_DMAINITGET_F(init_get);
> 
> I think it is more customary to put the | at the end of the preceding
> line:
> 
>         return HOST1X_CHANNEL_DMACTRL_DMASTOP_F(stop) |
>                HOST1X_CHANNEL_DMACTRL_DMAGETRST_F(get_rst) |
>                HOST1X_CHANNEL_DMACTRL_DMAINITGET_F(init_get);
> 
> Also since these are all single bits, I'd prefer if you could drop the
> _F suffix and not make them take a parameter. I think it'd even be
> better not to have this function at all, but make the intent explicit
> where the register is written. That is, have each call site set the bits
> explicitly instead of calling this helper. Having a parameter list such
> as (true, false, false) or (true, true, true) is confusing since you
> have to keep looking up the meaning of the parameters.

The operation that the _F macros do is masking and bit shifting the
fields correctly. Without that, we'd need to expose several macros to
mask and shift, and I'd rather just have one macro to take care of that.

But, we can open code the function to wherever it's used if that's more
readable.

> 
>> +}
>> +
>> +static void cdma_timeout_handler(struct work_struct *work);
> 
> Can this prototype be avoided?

We could try shuffling the code. There might be some dependency problems
that forced this ordering, but we'll try.

> 
>> +/**
>> + * Reset to empty push buffer
>> + */
>> +static void push_buffer_reset(struct push_buffer *pb)
>> +{
>> +     pb->fence = PUSH_BUFFER_SIZE - 8;
>> +     pb->cur = 0;
> 
> Maybe position is a better name than cur.

Sure.

> 
>> +/**
>> + * Init push buffer resources
>> + */
>> +static void push_buffer_destroy(struct push_buffer *pb);
> 
> You should be careful with these comment blocks. If you start them with
> /**, then you should make them proper kerneldoc comments. But you don't
> really need that for static functions, so you could just make them /*-
> style.
> 
> Also this particular comment is confusingly place on top of the proto-
> type of push_buffer_destroy().

You're right. We'll just remove the /** */ notation and use normal
comments. And the comment is just misplaced, so we'll move it.

> 
>> +/*
>> + * Push two words to the push buffer
>> + * Caller must ensure push buffer is not full
>> + */
>> +static void push_buffer_push_to(struct push_buffer *pb,
>> +             struct mem_handle *handle,
>> +             u32 op1, u32 op2)
>> +{
>> +     u32 cur = pb->cur;
>> +     u32 *p = (u32 *)((u32)pb->mapped + cur);
> 
> You do all this extra casting to make sure to increment by bytes and not
> 32-bit words. How about you change pb->cur to contain the word index, so
> that you don't have to go through hoops each time around.
> 
> Alternatively you could make it a pointer to u32 and not have to index
> or cast at all. So you'd end up with something like:
> 
>         struct push_buffer {
>                 u32 *start;
>                 u32 *end;
>                 u32 *ptr;
>         };

The complexity comes from the fact that we deal both with device virtual
addresses and CPU addresses to the same buffer. We'll need the indexes
so that we can convert between the two address spaces, but we might be
able to use word indexes. We'll check this.

> 
>> +/*
>> + * Return the number of two word slots free in the push buffer
>> + */
>> +static u32 push_buffer_space(struct push_buffer *pb)
>> +{
>> +     return ((pb->fence - pb->cur) & (PUSH_BUFFER_SIZE - 1)) / 8;
>> +}
> 
> Why & (PUSH_BUFFER_SIZE - 1) here? fence - cur can never be larger than
> PUSH_BUFFER_SIZE, can it?

You're right, this function doesn't need to worry about wrapping.

> 
>> +/*
>> + * Init timeout resources
>> + */
>> +static int cdma_timeout_init(struct host1x_cdma *cdma,
>> +                              u32 syncpt_id)
>> +{
>> +     if (syncpt_id == NVSYNCPT_INVALID)
>> +             return -EINVAL;
> 
> Do we really need the syncpt_id check here? It is the only reason why we
> need to pass the parameter in the first place, and if we get to this
> point we should already have made sure that the syncpoint is actually
> valid.

True, we can drop this.

> 
>> +/*
>> + * Increment timedout buffer's syncpt via CPU.
> 
> Nit: "timed out buffer's"

Will fix.

> 
>> + */
>> +static void cdma_timeout_cpu_incr(struct host1x_cdma *cdma, u32 getptr,
>> +                             u32 syncpt_incrs, u32 syncval, u32 nr_slots)
> 
> The syncval parameter isn't used.

True, that'd be used only with wait base support, as we need to
synchronize wait base with the sync point. Will remove.

> 
>> +{
>> +     struct host1x *host1x = cdma_to_host1x(cdma);
>> +     struct push_buffer *pb = &cdma->push_buffer;
>> +     u32 i, getidx;
>> +
>> +     for (i = 0; i < syncpt_incrs; i++)
>> +             host1x_syncpt_cpu_incr(cdma->timeout.syncpt);
>> +
>> +     /* after CPU incr, ensure shadow is up to date */
>> +     host1x_syncpt_load_min(cdma->timeout.syncpt);
>> +
>> +     /* NOP all the PB slots */
>> +     getidx = getptr - pb->phys;
>> +     while (nr_slots--) {
>> +             u32 *p = (u32 *)((u32)pb->mapped + getidx);
>> +             *(p++) = HOST1X_OPCODE_NOOP;
>> +             *(p++) = HOST1X_OPCODE_NOOP;
>> +             dev_dbg(&host1x->dev->dev, "%s: NOP at 0x%x\n",
>> +                     __func__, pb->phys + getidx);
>> +             getidx = (getidx + 8) & (PUSH_BUFFER_SIZE - 1);
>> +     }
>> +     wmb();
> 
> Why the memory barrier?

Can't think of any good reason. Will try removing.

> 
>> +/*
>> + * Similar to cdma_start(), but rather than starting from an idle
>> + * state (where DMA GET is set to DMA PUT), on a timeout we restore
>> + * DMA GET from an explicit value (so DMA may again be pending).
>> + */
>> +static void cdma_timeout_restart(struct host1x_cdma *cdma, u32 getptr)
>> +{
>> +     struct host1x *host1x = cdma_to_host1x(cdma);
>> +     struct host1x_channel *ch = cdma_to_channel(cdma);
>> +
>> +     if (cdma->running)
>> +             return;
>> +
>> +     cdma->last_put = host1x->cdma_pb_op.putptr(&cdma->push_buffer);
>> +
>> +     host1x_ch_writel(ch, host1x_channel_dmactrl(true, false, false),
>> +             HOST1X_CHANNEL_DMACTRL);
>> +
>> +     /* set base, end pointer (all of memory) */
>> +     host1x_ch_writel(ch, 0, HOST1X_CHANNEL_DMASTART);
>> +     host1x_ch_writel(ch, 0xFFFFFFFF, HOST1X_CHANNEL_DMAEND);
> 
> According to the TRM, writing to HOST1X_CHANNEL_DMASTART will start a
> DMA transfer on the channel (if DMA_PUT != DMA_GET). Irrespective of
> that, why set the valid range to all of physical memory? We know the
> valid range of the push buffer, why not set the limits accordingly?

That'd make sense. Currently we use the RESTART as the barrier, but
having hardware check against DMAEND is a good idea, too.

> 
>> +/*
>> + * Kick channel DMA into action by writing its PUT offset (if it has changed)
>> + */
>> +static void cdma_kick(struct host1x_cdma *cdma)
>> +{
>> +     struct host1x *host1x = cdma_to_host1x(cdma);
>> +     struct host1x_channel *ch = cdma_to_channel(cdma);
>> +     u32 put;
>> +
>> +     put = host1x->cdma_pb_op.putptr(&cdma->push_buffer);
>> +
>> +     if (put != cdma->last_put) {
>> +             host1x_ch_writel(ch, put, HOST1X_CHANNEL_DMAPUT);
>> +             cdma->last_put = put;
>> +     }
>> +}
> 
> kick() sounds unusual. Maybe flush or commit or something similar would
> be more accurate.

We could use flush.

> 
>> +static void cdma_stop(struct host1x_cdma *cdma)
>> +{
>> +     struct host1x_channel *ch = cdma_to_channel(cdma);
>> +
>> +     mutex_lock(&cdma->lock);
>> +     if (cdma->running) {
>> +             host1x_cdma_wait_locked(cdma, CDMA_EVENT_SYNC_QUEUE_EMPTY);
>> +             host1x_ch_writel(ch, host1x_channel_dmactrl(true, false, false),
>> +                     HOST1X_CHANNEL_DMACTRL);
>> +             cdma->running = false;
>> +     }
>> +     mutex_unlock(&cdma->lock);
>> +}
> 
> Perhaps this should be ranem cdma_stop_sync() or similar to make it
> clear that it waits for the queue to run empty.

Ok, sounds good.

> 
>> +static void cdma_timeout_teardown_end(struct host1x_cdma *cdma, u32 getptr)
> 
> Maybe the last parameter should be called restart to match its purpose?

Makes sense, will do.

> 
>> +{
>> +     struct host1x *host1x = cdma_to_host1x(cdma);
>> +     struct host1x_channel *ch = cdma_to_channel(cdma);
>> +     u32 cmdproc_stop;
>> +
>> +     dev_dbg(&host1x->dev->dev,
>> +             "end channel teardown (id %d, DMAGET restart = 0x%x)\n",
>> +             ch->chid, getptr);
>> +
>> +     cmdproc_stop = host1x_sync_readl(host1x, HOST1X_SYNC_CMDPROC_STOP);
>> +     cmdproc_stop &= ~(BIT(ch->chid));
> 
> No need for the extra parentheses.

Ok, will remove.

> 
>> +     host1x_sync_writel(host1x, cmdproc_stop, HOST1X_SYNC_CMDPROC_STOP);
>> +
>> +     cdma->torndown = false;
>> +     cdma_timeout_restart(cdma, getptr);
>> +}
> 
> I find this a bit non-intuitive. We teardown a channel, and when we're
> done tearing down, the torndown variable is set to false and the channel
> is actually restarted. Maybe you could explain some more how this works
> and what its purpose is.

Actually, teardown_begin freezes the channel, then we manipulate the
queue, and in the end teardown_end restarts the channel. So these should
be named freeze and resume. We could even drop the timeout from the
names of these functions.

> 
>> +/*
>> + * If this timeout fires, it indicates the current sync_queue entry has
>> + * exceeded its TTL and the userctx should be timed out and remaining
>> + * submits already issued cleaned up (future submits return an error).
>> + */
> 
> I can't seem to find what causes subsequent submits to return an error.
> Also, how is the channel reset so that new jobs can be submitted?

That comment actually applies only downstream. We blacklist contexts for
channels that carry state across submits (=have hardware contexts
implemented). 2D has atomic jobs, so it doesn't need blacklisting.

host1x_cdma_update_sync_queue() purges the failed job, finds the DMAGET
for the next job, and sets sync points correctly. It'll call
teardown_end (which we'll rename) to resume the channel with the new
DMAGET pointer.

> 
>> +static void cdma_timeout_handler(struct work_struct *work)
>> +{
>> +     struct host1x_cdma *cdma;
>> +     struct host1x *host1x;
>> +     struct host1x_channel *ch;
>> +
>> +     u32 syncpt_val;
>> +
>> +     u32 prev_cmdproc, cmdproc_stop;
>> +
>> +     cdma = container_of(to_delayed_work(work), struct host1x_cdma,
>> +                         timeout.wq);
>> +     host1x = cdma_to_host1x(cdma);
>> +     ch = cdma_to_channel(cdma);
>> +
>> +     mutex_lock(&cdma->lock);
>> +
>> +     if (!cdma->timeout.clientid) {
>> +             dev_dbg(&host1x->dev->dev,
>> +                      "cdma_timeout: expired, but has no clientid\n");
>> +             mutex_unlock(&cdma->lock);
>> +             return;
>> +     }
> 
> How can the CDMA not have a client?

I don't think that's possible. :-) We should just remove the check. It
might be that we were just protecting some kind of race between timeout
code triggering and something else, but I can't really think of a scenario.

> 
>> +
>> +     /* stop processing to get a clean snapshot */
>> +     prev_cmdproc = host1x_sync_readl(host1x, HOST1X_SYNC_CMDPROC_STOP);
>> +     cmdproc_stop = prev_cmdproc | BIT(ch->chid);
>> +     host1x_sync_writel(host1x, cmdproc_stop, HOST1X_SYNC_CMDPROC_STOP);
>> +
>> +     dev_dbg(&host1x->dev->dev, "cdma_timeout: cmdproc was 0x%x is 0x%x\n",
>> +             prev_cmdproc, cmdproc_stop);
>> +
>> +     syncpt_val = host1x_syncpt_load_min(host1x->syncpt);
>> +
>> +     /* has buffer actually completed? */
>> +     if ((s32)(syncpt_val - cdma->timeout.syncpt_val) >= 0) {
>> +             dev_dbg(&host1x->dev->dev,
>> +                      "cdma_timeout: expired, but buffer had completed\n");
> 
> Maybe this should really be a warning?

Not really - it's actually just a normal state. We got a timeout event,
but before we process it, it might be that the job manages to complete.
This can happen, and is not an error case.

> 
>> +             /* restore */
>> +             cmdproc_stop = prev_cmdproc & ~(BIT(ch->chid));
> 
> No need for the extra parentheses. Also, why not just use prev_cmdproc,
> which shouldn't have the bit set anyway?

Yeah, prev_cmdproc is the one we should use directly.

> 
>> diff --git a/drivers/gpu/host1x/hw/cdma_hw.h b/drivers/gpu/host1x/hw/cdma_hw.h
> [...]
>> +/*
>> + * Size of the sync queue. If it is too small, we won't be able to queue up
>> + * many command buffers. If it is too large, we waste memory.
>> + */
>> +#define HOST1X_SYNC_QUEUE_SIZE 512
> 
> I don't see this used anywhere.

Sync queue used to be an array. It hasn't been for a long time, but this
remained. Will remove.

> 
>> +/*
>> + * Number of gathers we allow to be queued up per channel. Must be a
>> + * power of two. Currently sized such that pushbuffer is 4KB (512*8B).
>> + */
>> +#define HOST1X_GATHER_QUEUE_SIZE 512
> 
> More pieces falling into place.

Great. :-)

> 
>> diff --git a/drivers/gpu/host1x/hw/channel_hw.c b/drivers/gpu/host1x/hw/channel_hw.c
> [...]
>> +#include "host1x.h"
>> +#include "channel.h"
>> +#include "dev.h"
>> +#include <linux/slab.h>
>> +#include "intr.h"
>> +#include "job.h"
>> +#include <trace/events/host1x.h>
> 
> More include ordering issues.

Will fix.

> 
>> +static void submit_gathers(struct host1x_job *job)
>> +{
>> +     /* push user gathers */
>> +     int i;
> 
> unsigned int?
> 
>> +     for (i = 0 ; i < job->num_gathers; i++) {
>> +             struct host1x_job_gather *g = &job->gathers[i];
>> +             u32 op1 = host1x_opcode_gather(g->words);
>> +             u32 op2 = g->mem_base + g->offset;
>> +             host1x_cdma_push_gather(&job->ch->cdma,
>> +                             job->gathers[i].ref,
>> +                             job->gathers[i].offset,
>> +                             op1, op2);
>> +     }
>> +}
> 
> Perhaps inline this into channel_submit()? I'm not sure how useful it
> really is to split off smallish functions such as this which aren't
> reused anywhere else. I don't have any major objection though, so you
> can keep it separate if you want.

I split these out because channel_submit() became so long that I
couldn't understand it anymore. I'd prefer keeping separate just to keep
myself (semi-)sane.

> 
>> +static inline void __iomem *host1x_channel_regs(void __iomem *p, int ndx)
>> +{
>> +     p += ndx * NV_HOST1X_CHANNEL_MAP_SIZE_BYTES;
>> +     return p;
>> +}
>> +
>> +static int host1x_channel_init(struct host1x_channel *ch,
>> +     struct host1x *dev, int index)
>> +{
>> +     ch->chid = index;
>> +     mutex_init(&ch->reflock);
>> +     mutex_init(&ch->submitlock);
>> +
>> +     ch->regs = host1x_channel_regs(dev->regs, index);
>> +     return 0;
>> +}
> 
> You only use host1x_channel_regs() once, so I really don't think it buys
> you anything to split it off. Both host1x_channel_regs() and
> host1x_channel_init() are short enough that they can be collapsed.

True, will merge.

> 
>> diff --git a/drivers/gpu/host1x/hw/host1x01.c b/drivers/gpu/host1x/hw/host1x01.c
> [...]
>>  #include "hw/host1x01.h"
>>  #include "dev.h"
>> +#include "channel.h"
>>  #include "hw/host1x01_hardware.h"
>>
>> +#include "hw/channel_hw.c"
>> +#include "hw/cdma_hw.c"
>>  #include "hw/syncpt_hw.c"
>>  #include "hw/intr_hw.c"
>>
>>  int host1x01_init(struct host1x *host)
>>  {
>> +     host->channel_op = host1x_channel_ops;
>> +     host->cdma_op = host1x_cdma_ops;
>> +     host->cdma_pb_op = host1x_pushbuffer_ops;
>>       host->syncpt_op = host1x_syncpt_ops;
>>       host->intr_op = host1x_intr_ops;
> 
> I think I mentioned this before, but I'd prefer not to have the .c files
> included here, but rather reference the ops structures externally. But I
> still think that especially CDMA and push buffer ops don't need to be in
> separate structures since they aren't likely to change with new hardware
> revisions.

The C files need to be included here so that they pick up the hardware
defs for the correct SoC. Pushbuffer is probably something we can
generalize, but channel registers can change, so they need to be per SoC.

> 
>> diff --git a/drivers/gpu/host1x/hw/host1x01_hardware.h b/drivers/gpu/host1x/hw/host1x01_hardware.h
> [...]
>> index c1d5324..03873c0 100644
>> --- a/drivers/gpu/host1x/hw/host1x01_hardware.h
>> +++ b/drivers/gpu/host1x/hw/host1x01_hardware.h
>> @@ -21,6 +21,130 @@
>>
>>  #include <linux/types.h>
>>  #include <linux/bitops.h>
>> +#include "hw_host1x01_channel.h"
>>  #include "hw_host1x01_sync.h"
>> +#include "hw_host1x01_uclass.h"
>> +
>> +/* channel registers */
>> +#define NV_HOST1X_CHANNEL_MAP_SIZE_BYTES 16384
> 
> The only user of this seems to be host1x_channel_regs(), so it could be
> moved to that file. Also the name is overly long, why not something like
> HOST1X_CHANNEL_SIZE?

Sounds good.

> 
>> +#define HOST1X_OPCODE_NOOP host1x_opcode_nonincr(0, 0)
> 
> HOST1X_OPCODE_NOP would be more canonical in my opinion.

Ok, can change.

> 
> 
>> +static inline u32 host1x_mask2(unsigned x, unsigned y)
>> +{
>> +     return 1 | (1 << (y - x));
>> +}
> 
> What's this? I don't see it used anywhere.

It's a shortcut to add two register writes to one MASK opcode, but we'll
remove the def as it's not used.

> 
>> diff --git a/drivers/gpu/host1x/hw/hw_host1x01_channel.h b/drivers/gpu/host1x/hw/hw_host1x01_channel.h
> [...]
>> +#define HOST1X_CHANNEL_DMACTRL_DMASTOP_F(v) \
>> +     host1x_channel_dmactrl_dmastop_f(v)
> 
> I mentioned this elsewhere already, but I think the _F suffix (and _f
> for that matter) along with the v parameter should go away.

I'd prefer keeping so that I don't have to use two #defines to replace
one. That IMO makes the usage harder and more error prone.

> 
>> diff --git a/drivers/gpu/host1x/hw/hw_host1x01_uclass.h b/drivers/gpu/host1x/hw/hw_host1x01_uclass.h
> [...]
> 
> What does the "uclass" stand for? It seems a bit useless to me.

It means host1x class, i.e. the host1x registers that can be written to
from push buffers.

> 
>> diff --git a/drivers/gpu/host1x/hw/syncpt_hw.c b/drivers/gpu/host1x/hw/syncpt_hw.c
>> index 16e3ada..ba48cee 100644
>> --- a/drivers/gpu/host1x/hw/syncpt_hw.c
>> +++ b/drivers/gpu/host1x/hw/syncpt_hw.c
>> @@ -97,6 +97,15 @@ static void syncpt_cpu_incr(struct host1x_syncpt *sp)
>>       wmb();
>>  }
>>
>> +/* remove a wait pointed to by patch_addr */
>> +static int syncpt_patch_wait(struct host1x_syncpt *sp, void *patch_addr)
>> +{
>> +     u32 override = host1x_class_host_wait_syncpt(
>> +                     NVSYNCPT_GRAPHICS_HOST, 0);
>> +     __raw_writel(override, patch_addr);
> 
> __raw_writel() isn't meant to be used for regular memory addresses, but
> only for MMIO addresses. patch_addr will be a kernel virtual address to
> an location in RAM, so you can just treat it as a normal pointer, so:
> 
>         *(u32 *)patch_addr = override;

Sure, you mentioned it earlier, but I've just forgotten that. Sorry
about that.

> 
> A small optimization might be to make override a static const, so that
> it doesn't have to be composed every time.

Can do.

> 
>> diff --git a/drivers/gpu/host1x/intr.c b/drivers/gpu/host1x/intr.c
> [...]
>> +static void action_submit_complete(struct host1x_waitlist *waiter)
>> +{
>> +     struct host1x_channel *channel = waiter->data;
>> +     int nr_completed = waiter->count;
> 
> No need for this variable.

I'm using it for tracing in a follow-up patch. It can be used in traces
for checking the queue length at each point of time.

> 
>> diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
> [...]
>> +#ifdef CONFIG_TEGRA_HOST1X_FIREWALL
>> +static int host1x_firewall = 1;
>> +#else
>> +static int host1x_firewall;
>> +#endif
> 
> You could use IS_ENABLED(CONFIG_TEGRA_HOST1X_FIREWALL) in the code,
> which will have the nice side-effect of compiling code out if the symbol
> isn't selected.

Sure, I just wasn't aware of IS_ENABLED.

> 
>> +struct host1x_job *host1x_job_alloc(struct host1x_channel *ch,
>> +             u32 num_cmdbufs, u32 num_relocs, u32 num_waitchks)
> 
> Maybe make the parameters unsigned int instead of u32?

I'll check this, but we're getting them from user space, and that API
has a fixed length field. That's why I'm carrying that type over.

> 
>> +{
>> +     struct host1x_job *job = NULL;
>> +     int num_unpins = num_cmdbufs + num_relocs;
> 
> unsigned int?

Sounds good.

> 
>> +     s64 total;
> 
> This doesn't need to be signed, u64 will be good enough. None of the
> terms in the expression that assigns to total can be negative.

True, will change.

> 
>> +     void *mem;
>> +
>> +     /* Check that we're not going to overflow */
>> +     total = sizeof(struct host1x_job)
>> +                     + num_relocs * sizeof(struct host1x_reloc)
>> +                     + num_unpins * sizeof(struct host1x_job_unpin_data)
>> +                     + num_waitchks * sizeof(struct host1x_waitchk)
>> +                     + num_cmdbufs * sizeof(struct host1x_job_gather)
>> +                     + num_unpins * sizeof(dma_addr_t)
>> +                     + num_unpins * sizeof(u32 *);
> 
> "+"s at the end of the preceding lines.

Ok.

> 
>> +     if (total > ULONG_MAX)
>> +             return NULL;
>> +
>> +     mem = job = kzalloc(total, GFP_KERNEL);
>> +     if (!job)
>> +             return NULL;
>> +
>> +     kref_init(&job->ref);
>> +     job->ch = ch;
>> +
>> +     /* First init state to zero */
>> +
>> +     /*
>> +      * Redistribute memory to the structs.
>> +      * Overflows and negative conditions have
>> +      * already been checked in job_alloc().
>> +      */
> 
> The last two lines don't really apply here. The checks are in this same
> function and they check only for overflow, not negative conditions,
> which can't happen anyway since the counts are all unsigned.

Actually overflow and negative in this case meant the same thing. Will
fix comment.

> 
>> +void host1x_job_get(struct host1x_job *job)
>> +{
>> +     kref_get(&job->ref);
>> +}
> 
> I think it is common for *_get() functions to return a pointer to the
> referenced object.

Ok, can do.

> 
>> +void host1x_job_add_gather(struct host1x_job *job,
>> +             u32 mem_id, u32 words, u32 offset)
>> +{
>> +     struct host1x_job_gather *cur_gather =
>> +                     &job->gathers[job->num_gathers];
> 
> Should this check for overflow?

As defensive measure, could do, but this is not exploitable.

> 
>> +/*
>> + * Check driver supplied waitchk structs for syncpt thresholds
>> + * that have already been satisfied and NULL the comparison (to
>> + * avoid a wrap condition in the HW).
>> + */
>> +static int do_waitchks(struct host1x_job *job, struct host1x *host,
>> +             u32 patch_mem, struct mem_handle *h)
>> +{
>> +     int i;
>> +
>> +     /* compare syncpt vs wait threshold */
>> +     for (i = 0; i < job->num_waitchk; i++) {
>> +             struct host1x_waitchk *wait = &job->waitchk[i];
>> +             struct host1x_syncpt *sp =
>> +                     host1x_syncpt_get(host, wait->syncpt_id);
>> +
>> +             /* validate syncpt id */
>> +             if (wait->syncpt_id > host1x_syncpt_nb_pts(host))
>> +                     continue;
>> +
>> +             /* skip all other gathers */
>> +             if (patch_mem != wait->mem)
>> +                     continue;
>> +
>> +             trace_host1x_syncpt_wait_check(wait->mem, wait->offset,
>> +                             wait->syncpt_id, wait->thresh,
>> +                             host1x_syncpt_read_min(sp));
>> +             if (host1x_syncpt_is_expired(
>> +                     host1x_syncpt_get(host, wait->syncpt_id),
>> +                     wait->thresh)) {
> 
> You already have the sp variable that you could use here to make it more
> readable.

True, will use that.

> 
>> +                     struct host1x_syncpt *sp =
>> +                             host1x_syncpt_get(host, wait->syncpt_id);
> 
> And you don't need this then, since you already have sp pointing to the
> same syncpoint.

Ok.

> 
>> +                     void *patch_addr = NULL;
>> +
>> +                     /*
>> +                      * NULL an already satisfied WAIT_SYNCPT host method,
>> +                      * by patching its args in the command stream. The
>> +                      * method data is changed to reference a reserved
>> +                      * (never given out or incr) NVSYNCPT_GRAPHICS_HOST
>> +                      * syncpt with a matching threshold value of 0, so
>> +                      * is guaranteed to be popped by the host HW.
>> +                      */
>> +                     dev_dbg(&host->dev->dev,
>> +                         "drop WAIT id %d (%s) thresh 0x%x, min 0x%x\n",
>> +                         wait->syncpt_id, sp->name, wait->thresh,
>> +                         host1x_syncpt_read_min(sp));
>> +
>> +                     /* patch the wait */
>> +                     patch_addr = host1x_memmgr_kmap(h,
>> +                                     wait->offset >> PAGE_SHIFT);
>> +                     if (patch_addr) {
>> +                             host1x_syncpt_patch_wait(sp,
>> +                                     (patch_addr +
>> +                                             (wait->offset & ~PAGE_MASK)));
>> +                             host1x_memmgr_kunmap(h,
>> +                                             wait->offset >> PAGE_SHIFT,
>> +                                             patch_addr);
>> +                     } else {
>> +                             pr_err("Couldn't map cmdbuf for wait check\n");
>> +                     }
> 
> This is a case where splitting out a small function would actually be
> useful to make the code more readable since you can remove two levels of
> indentation. You can just pass in the handle and the offset, let it do
> the actual patching. Maybe
> 
>         host1x_syncpt_patch_offset(sp, h, wait->offset);
> 
> ?

Sounds good, for readability point of view.

> 
>> +             }
>> +
>> +             wait->mem = 0;
>> +     }
>> +     return 0;
>> +}
>> +
>> +
> 
> There's a gratuitous blank line.

Will remove.

> 
>> +static int pin_job_mem(struct host1x_job *job)
>> +{
>> +     int i;
>> +     int count = 0;
>> +     int result;
> 
> These (and the return value) can all be unsigned int.

True. will fix.

> 
>> +static int do_relocs(struct host1x_job *job,
>> +             u32 cmdbuf_mem, struct mem_handle *h)
>> +{
>> +     int i = 0;
> 
> This can also be unsigned int.

True, will fix.

> 
>> +     int last_page = -1;
> 
> And this should match the type of cmdbuf_offset (u32). You can initially
> set it to something like ~0 to make sure it doesn't match any valid
> offset.

You're right, will change.

> 
>> +     void *cmdbuf_page_addr = NULL;
>> +
>> +     /* pin & patch the relocs for one gather */
>> +     while (i < job->num_relocs) {
>> +             struct host1x_reloc *reloc = &job->relocarray[i];
>> +
>> +             /* skip all other gathers */
>> +             if (cmdbuf_mem != reloc->cmdbuf_mem) {
>> +                     i++;
>> +                     continue;
>> +             }
>> +
>> +             if (last_page != reloc->cmdbuf_offset >> PAGE_SHIFT) {
>> +                     if (cmdbuf_page_addr)
>> +                             host1x_memmgr_kunmap(h,
>> +                                             last_page, cmdbuf_page_addr);
>> +
>> +                     cmdbuf_page_addr = host1x_memmgr_kmap(h,
>> +                                     reloc->cmdbuf_offset >> PAGE_SHIFT);
>> +                     last_page = reloc->cmdbuf_offset >> PAGE_SHIFT;
>> +
>> +                     if (unlikely(!cmdbuf_page_addr)) {
>> +                             pr_err("Couldn't map cmdbuf for relocation\n");
>> +                             return -ENOMEM;
>> +                     }
>> +             }
>> +
>> +             __raw_writel(
>> +                     (job->reloc_addr_phys[i] +
>> +                             reloc->target_offset) >> reloc->shift,
>> +                     (cmdbuf_page_addr +
>> +                             (reloc->cmdbuf_offset & ~PAGE_MASK)));
> 
> Again, wrong __raw_writel() usage.

Yes, sorry, I forgot about this.

> 
>> +
>> +             /* remove completed reloc from the job */
>> +             if (i != job->num_relocs - 1) {
>> +                     struct host1x_reloc *reloc_last =
>> +                             &job->relocarray[job->num_relocs - 1];
>> +                     reloc->cmdbuf_mem       = reloc_last->cmdbuf_mem;
>> +                     reloc->cmdbuf_offset    = reloc_last->cmdbuf_offset;
>> +                     reloc->target           = reloc_last->target;
>> +                     reloc->target_offset    = reloc_last->target_offset;
>> +                     reloc->shift            = reloc_last->shift;
>> +                     job->reloc_addr_phys[i] =
>> +                             job->reloc_addr_phys[job->num_relocs - 1];
>> +                     job->num_relocs--;
>> +             } else {
>> +                     break;
>> +             }
>> +     }
>> +
>> +     if (cmdbuf_page_addr)
>> +             host1x_memmgr_kunmap(h, last_page, cmdbuf_page_addr);
>> +
>> +     return 0;
>> +}
> 
> Also the algorithm seems a bit strange and hard to follow. Instead of
> removing relocs from the job, replacing them with the last entry and
> decrementing job->num_relocs, how much is the penalty for always
> iterating over all relocs? This is one of the other cases where I'd
> argue that simplicity is key. Furthermore you need to copy quite a bit
> of data to replace the completed relocs, so I'm not sure it buys you
> much.
> 
> It could always be optimized later on by just setting a bit in the reloc
> to mark it as completed, or keep a bitmask of completed relocations or
> whatever.

This was done in a big optimization patch, but we'll check if we could
remove this. Previously we just set cmdbuf_mem for the completed reloc
to 0, and that should work in this case.

> 
>> +static int check_reloc(struct host1x_reloc *reloc,
>> +             u32 cmdbuf_id, int offset)
> 
> offset can be unsigned int.

Yep, will change.

> 
>> +{
>> +     int err = 0;
>> +     if (reloc->cmdbuf_mem != cmdbuf_id
>> +                     || reloc->cmdbuf_offset != offset * sizeof(u32))
>> +             err = -EINVAL;
>> +
>> +     return err;
>> +}
> 
> More canonically:
> 
>         offset *= sizeof(u32);
> 
>         if (reloc->cmdbuf_mem != cmdbuf_id || reloc->cmdbuf_offset != offset)
>                 return -EINVAL;
> 
>         return 0;

Ok, both do the same thing, so can change.

> 
>> +
>> +static int check_mask(struct host1x_job *job,
>> +             struct platform_device *pdev,
>> +             struct host1x_reloc **reloc, int *num_relocs,
>> +             u32 cmdbuf_id, int *offset,
>> +             u32 *words, u32 class, u32 reg, u32 mask)
> 
> num_relocs and offset can be unsigned int *.
> 
> Same comment for the other check_*() functions. That said I think the
> code would become a lot more readable if you were to wrap all of these
> parameters into a structure, say host1x_firewall, and just pass that
> into the functions.

True, might improve performance, too. We'll do that.

> 
>> +static inline int copy_gathers(struct host1x_job *job,
>> +             struct platform_device *pdev)
> 
> struct device *

Will do.

> 
>> +{
>> +     size_t size = 0;
>> +     size_t offset = 0;
>> +     int i;
>> +
>> +     for (i = 0; i < job->num_gathers; i++) {
>> +             struct host1x_job_gather *g = &job->gathers[i];
>> +             size += g->words * sizeof(u32);
>> +     }
>> +
>> +     job->gather_copy_mapped = dma_alloc_writecombine(&pdev->dev,
>> +                     size, &job->gather_copy, GFP_KERNEL);
>> +     if (IS_ERR(job->gather_copy_mapped)) {
> 
> dma_alloc_writecombine() returns NULL on failure, so this check is
> wrong.

Oops, will fix.

> 
>> +             int err = PTR_ERR(job->gather_copy_mapped);
>> +             job->gather_copy_mapped = NULL;
>> +             return err;
>> +     }
>> +
>> +     job->gather_copy_size = size;
>> +
>> +     for (i = 0; i < job->num_gathers; i++) {
>> +             struct host1x_job_gather *g = &job->gathers[i];
>> +             void *gather = host1x_memmgr_mmap(g->ref);
>> +             memcpy(job->gather_copy_mapped + offset,
>> +                             gather + g->offset,
>> +                             g->words * sizeof(u32));
>> +
>> +             g->mem_base = job->gather_copy;
>> +             g->offset = offset;
>> +             g->mem_id = 0;
>> +             g->ref = 0;
>> +
>> +             host1x_memmgr_munmap(g->ref, gather);
>> +             offset += g->words * sizeof(u32);
>> +     }
>> +
>> +     return 0;
>> +}
> 
> I wonder, where's this DMA buffer actually used? I can't find any use
> between this copy and the corresponding dma_free_writecombine() call.

We replace the gathers in host1x_job with the ones we allocate here, so
they are used when pushing the gather's to hardware.

This is done so that user space cannot tamper with the gathers once
they've been checked by firewall.

> 
>> +int host1x_job_pin(struct host1x_job *job, struct platform_device *pdev)
>> +{
>> +     int err = 0, i = 0, j = 0;
> 
> No need to initialize these here. i and j can also be unsigned.

Ok.

> 
>> +     struct host1x *host = host1x_get_host(pdev);
>> +     DECLARE_BITMAP(waitchk_mask, host1x_syncpt_nb_pts(host));
>> +
>> +     bitmap_zero(waitchk_mask, host1x_syncpt_nb_pts(host));
>> +     for (i = 0; i < job->num_waitchk; i++) {
>> +             u32 syncpt_id = job->waitchk[i].syncpt_id;
>> +             if (syncpt_id < host1x_syncpt_nb_pts(host))
>> +                     set_bit(syncpt_id, waitchk_mask);
>> +     }
>> +
>> +     /* get current syncpt values for waitchk */
>> +     for_each_set_bit(i, &waitchk_mask[0], sizeof(waitchk_mask))
>> +             host1x_syncpt_load_min(host->syncpt + i);
>> +
>> +     /* pin memory */
>> +     err = pin_job_mem(job);
>> +     if (err <= 0)
>> +             goto out;
> 
> pin_job_mem() never returns negative.

Ok, will fix.

> 
>> +     /* patch gathers */
>> +     for (i = 0; i < job->num_gathers; i++) {
>> +             struct host1x_job_gather *g = &job->gathers[i];
>> +
>> +             /* process each gather mem only once */
>> +             if (!g->ref) {
>> +                     g->ref = host1x_memmgr_get(g->mem_id, job->ch->dev);
>> +                     if (IS_ERR(g->ref)) {
> 
> host1x_memmgr_get() also seems to return NULL on error.

I think I'll change memmgr_get() to return an ERR_PTR().

> 
>> +                             err = PTR_ERR(g->ref);
>> +                             g->ref = NULL;
>> +                             break;
>> +                     }
>> +
>> +                     g->mem_base = job->gather_addr_phys[i];
>> +
>> +                     for (j = 0; j < job->num_gathers; j++) {
>> +                             struct host1x_job_gather *tmp =
>> +                                     &job->gathers[j];
>> +                             if (!tmp->ref && tmp->mem_id == g->mem_id) {
>> +                                     tmp->ref = g->ref;
>> +                                     tmp->mem_base = g->mem_base;
>> +                             }
>> +                     }
>> +                     err = 0;
>> +                     if (host1x_firewall)
> 
> if (IS_ENABLED(CONFIG_TEGRA_HOST1X_FIREWALL))

Will fix.

> 
>> +                             err = validate(job, pdev, g);
>> +                     if (err)
>> +                             dev_err(&pdev->dev,
>> +                                     "Job validate returned %d\n", err);
>> +                     if (!err)
>> +                             err = do_relocs(job, g->mem_id,  g->ref);
>> +                     if (!err)
>> +                             err = do_waitchks(job, host,
>> +                                             g->mem_id, g->ref);
>> +                     host1x_memmgr_put(g->ref);
>> +                     if (err)
>> +                             break;
>> +             }
>> +     }
>> +
>> +     if (host1x_firewall && !err) {
> 
> And here.

Here, too.

> 
>> +/*
>> + * Debug routine used to dump job entries
>> + */
>> +void host1x_job_dump(struct device *dev, struct host1x_job *job)
>> +{
>> +     dev_dbg(dev, "    SYNCPT_ID   %d\n",
>> +             job->syncpt_id);
>> +     dev_dbg(dev, "    SYNCPT_VAL  %d\n",
>> +             job->syncpt_end);
>> +     dev_dbg(dev, "    FIRST_GET   0x%x\n",
>> +             job->first_get);
>> +     dev_dbg(dev, "    TIMEOUT     %d\n",
>> +             job->timeout);
>> +     dev_dbg(dev, "    NUM_SLOTS   %d\n",
>> +             job->num_slots);
>> +     dev_dbg(dev, "    NUM_HANDLES %d\n",
>> +             job->num_unpins);
>> +}
> 
> These don't need to be wrapped.

True, will merge lines.

> 
>> diff --git a/drivers/gpu/host1x/job.h b/drivers/gpu/host1x/job.h
> [...]
>> +struct host1x_job_gather {
>> +     u32 words;
>> +     dma_addr_t mem_base;
>> +     u32 mem_id;
>> +     int offset;
>> +     struct mem_handle *ref;
>> +};
>> +
>> +struct host1x_cmdbuf {
>> +     __u32 mem;
>> +     __u32 offset;
>> +     __u32 words;
>> +     __u32 pad;
>> +};
>> +
>> +struct host1x_reloc {
>> +     __u32 cmdbuf_mem;
>> +     __u32 cmdbuf_offset;
>> +     __u32 target;
>> +     __u32 target_offset;
>> +     __u32 shift;
>> +     __u32 pad;
>> +};
>> +
>> +struct host1x_waitchk {
>> +     __u32 mem;
>> +     __u32 offset;
>> +     __u32 syncpt_id;
>> +     __u32 thresh;
>> +};
> 
> None of these are shared with userspace, so they shouldn't take the
> __u32 types, but the regular u32 ones.

True. We copy stuff from user space types to these, but we don't use
these directly in user space API.

> 
>> +/*
>> + * Each submit is tracked as a host1x_job.
>> + */
>> +struct host1x_job {
>> +     /* When refcount goes to zero, job can be freed */
>> +     struct kref ref;
>> +
>> +     /* List entry */
>> +     struct list_head list;
>> +
>> +     /* Channel where job is submitted to */
>> +     struct host1x_channel *ch;
> 
> Maybe write it out as "channel"?

Ok.

> 
>> +
>> +     int clientid;
> 
> Subsequent patches assign u32 to this field, so maybe the type should be
> changed here. And maybe leave out the id suffix. It doesn't really add
> any information.

Good catch, will change.

> 
>> +     /* Gathers and their memory */
>> +     struct host1x_job_gather *gathers;
>> +     int num_gathers;
> 
> unsigned int

Will change.

> 
>> +     /* Wait checks to be processed at submit time */
>> +     struct host1x_waitchk *waitchk;
>> +     int num_waitchk;
> 
> unsigned int

Ok.

> 
>> +     u32 waitchk_mask;
> 
> This might need to be changed to a bitfield once future Tegra versions
> start supporting more than 32 syncpoints.

True, I think we'll need to get this changed already now. We actually
drop the usage of waitchk_mask in downstream because of this. It's
basically just an optimization that doesn't gain any real world speed
advantage.

> 
>> +     /* Array of handles to be pinned & unpinned */
>> +     struct host1x_reloc *relocarray;
>> +     int num_relocs;
> 
> unsigned int

Will change.

> 
>> +     struct host1x_job_unpin_data *unpins;
>> +     int num_unpins;
> 
> unsigned int

Will change.

> 
>> +     dma_addr_t *addr_phys;
>> +     dma_addr_t *gather_addr_phys;
>> +     dma_addr_t *reloc_addr_phys;
>> +
>> +     /* Sync point id, number of increments and end related to the submit */
>> +     u32 syncpt_id;
>> +     u32 syncpt_incrs;
>> +     u32 syncpt_end;
>> +
>> +     /* Maximum time to wait for this job */
>> +     int timeout;
> 
> unsigned int. I think we discussed this already in a slightly different
> context in patch 2.

Sure, will change. I think timeouts were discussed wrt syncpt wait timeout.

> 
>> +     /* Null kickoff prevents submit from being sent to hardware */
>> +     bool null_kickoff;
> 
> I don't think this is used anywhere.

True, we can remove this as we haven't posted the code for null kickoff.

> 
>> +     /* Index and number of slots used in the push buffer */
>> +     int first_get;
>> +     int num_slots;
> 
> unsigned int

Ok.

> 
>> +
>> +     /* Copy of gathers */
>> +     size_t gather_copy_size;
>> +     dma_addr_t gather_copy;
>> +     u8 *gather_copy_mapped;
> 
> Are these really needed? They don't seem to be used anywhere except to
> store a copy and free that copy sometime later.

They're needed so that kernel can take a copy of the gathers so that
user space cannot tamper with them post-submit.

> 
>> +
>> +     /* Temporary space for unpin ids */
>> +     long unsigned int *pin_ids;
> 
> unsigned long

Will change.

> 
>> +     /* Check if register is marked as an address reg */
>> +     int (*is_addr_reg)(struct platform_device *dev, u32 reg, u32 class);
> 
> is_addr_reg() sounds a bit unusual. Maybe match this to the name of the
> main firewall routine, validate()?

The point of this op is to just tell if a register for a class is
pointing to a buffer. validate then uses this information. But both
answers (yes/no) and both types of registers are still valid, so
validate() wouldn't be the proper name.

validation is then done by checking that there's a reloc corresponding
to each register write to a register that can hold an address.

> 
>> +     /* Request a SETCLASS to this class */
>> +     u32 class;
>> +
>> +     /* Add a channel wait for previous ops to complete */
>> +     u32 serialize;
> 
> This is used in code as a boolean. Why does it need to be 32 bits?

No need, will change to bool.

> 
>> diff --git a/drivers/gpu/host1x/memmgr.h b/drivers/gpu/host1x/memmgr.h
> [...]
>> +struct mem_handle;
>> +struct platform_device;
>> +
>> +struct host1x_job_unpin_data {
>> +     struct mem_handle *h;
>> +     struct sg_table *mem;
>> +};
>> +
>> +enum mem_mgr_flag {
>> +     mem_mgr_flag_uncacheable = 0,
>> +     mem_mgr_flag_write_combine = 1,
>> +};
> 
> I'd like to see this use a more object-oriented approach and more common
> terminology. All of these handles are essentially buffer objects, so
> maybe something like host1x_bo would be a nice and short name.
> 
> To make this more object-oriented, I propose something like:
> 
>         struct host1x_bo_ops {
>                 int (*alloc)(struct host1x_bo *bo, size_t size, unsigned long align,
>                              unsigned long flags);
>                 int (*free)(struct host1x_bo *bo);
>                 ...
>         };
> 
>         struct host1x_bo {
>                 const struct host1x_bo_ops *ops;
>         };
> 
>         struct host1x_cma_bo {
>                 struct host1x_bo base;
>                 struct drm_gem_cma_object *obj;
>         };
> 
>         static inline struct host1x_cma_bo *to_host1x_cma_bo(struct host1x_bo *bo)
>         {
>                 return container_of(bo, struct host1x_cma_bo, base);
>         }
> 
>         static inline int host1x_bo_alloc(struct host1x_bo *bo, size_t size,
>                                           unsigned long align, unsigned long flags)
>         {
>                 return bo->ops->alloc(bo, size, align, flags);
>         }
> 
>         ...
> 
> That should be easy to extend with a new type of BO once the IOMMU-based
> allocator is ready. And as I said it is much closer in terminology to
> what other drivers do.

One complexity is that we're using the same type for communicating with
user space. Each buffer carries with it a flag indicating its allocator.
We might be able to model the internal structure to be more like what
you propose, but for the API we still need the flag.

> 
>> diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
>> index b46d044..255a3a3 100644
>> --- a/drivers/gpu/host1x/syncpt.h
>> +++ b/drivers/gpu/host1x/syncpt.h
>> @@ -26,6 +26,7 @@
>>  struct host1x;
>>
>>  #define NVSYNCPT_INVALID                     (-1)
>> +#define NVSYNCPT_GRAPHICS_HOST                       0
> 
> I think these should match other naming, so:
> 
>         #define HOST1X_SYNCPT_INVALID   -1
>         #define HOST1X_SYNCPT_HOST1X     0

Sure, sounds good.

> There are a few more occurrences where platform_device is used but I
> haven't commented on them. I don't think any of them won't work with
> just a struct device instead. Also I may not have caught all of the
> places where you should rather be using unsigned int instead of int,
> so you might want to look out for some of those.

Yes, we'll go through the code with this in mind.

> Generally I very much like where this is going. Are there any plans to
> move the userspace binary driver to this interface at some point so we
> can more actively test it? Also, is anything else blocking adding a
> gr3d device similar to gr2d from this patch series?

We're doing this in stages. I don't want to change the code base and
APIs both in one step, because big moves in both user and kernel space
tend to fail easily.

First we upstream code, and try to get feature parity. Then we
re-engineer our downstream driver delta on top of the upstream code, but
in this phase we keep the downstream kernel API.

In the next step, we'll start moving to the DRM APIs.

So, there's quite a few steps still before we're on DRM APIs, but we'll
reach it at some point. :-)

3D driver should work on top of this. I don't see anything blocking that.

Terje
