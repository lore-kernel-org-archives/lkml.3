Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab3B0I4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 03:56:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56893 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab3B0I4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 03:56:30 -0500
Date: Wed, 27 Feb 2013 09:56:23 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 3/8] gpu: host1x: Add channel support
Message-ID: <20130227085623.GA18538@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-4-git-send-email-tbergstrom@nvidia.com>
 <20130225152457.GA29545@avionic-0098.mockup.avionic-design.de>
 <512C84E2.5090201@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <512C84E2.5090201@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ZYtEtLJIswCNn0eMl/rN5amPmaSvhZWrxg5CNRLpCEn
 QFTefbu09/+7yWY4j0E1xRCWGcRlRywzr5Th520699iKvBjhXP
 tRCUOap4yo+YsJDcsGtQzEmO1UgjJ3VT/6mxXsDIxjSqHVD8zn
 URcIn7jfln+F+/3rmmaOVAnvBBrNJmxZqrPtDIgmoZ49el38lo
 nP0gZLpaKslmAoCiHPLVRicmfne3AShtfy/0cBGAGO63NESOsK
 jpQuX6U6mmlhyOAw6nfPDZ6tEkeNijNX0h7ATOl++teE+VnDvN
 FoDQ1vjHnk+AYYxrzTc9e4fyUWeSO2gJsf47v0Wg108DQ+6X9T
 9StAa7lT7STT5U+1Uk6FW7f6GZ5aM+vKZNZicfeT8cCaBCV5vE
 v0QB42v/i1YkBp9CrIVigae9waNxCyRoIop7IBvKOQmwqwh4Kp
 Fqh0o
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 26, 2013 at 11:48:18AM +0200, Terje Bergstr=C3=B6m wrote:
> On 25.02.2013 17:24, Thierry Reding wrote:
> > On Tue, Jan 15, 2013 at 01:43:59PM +0200, Terje Bergstrom wrote:
[...]
> >> +/*
> >> + * Start timer for a buffer submition that has completed yet.
> >=20
> > "submission". And I don't understand the "that has completed yet" part.
>=20
> It should become "Start timer that tracks the time spent by the job".

Yes, that's a lot better.

> >> +     if (list_empty(&cdma->sync_queue) &&
> >> +                             cdma->event =3D=3D CDMA_EVENT_SYNC_QUEUE=
_EMPTY)
> >> +                     signal =3D true;
> >=20
> > This looks funny, maybe:
> >=20
> >         if (cdma->event =3D=3D CDMA_EVENT_SYNC_QUEUE_EMPTY &&
> >             list_empty(&cdma->sync_queue))
> >                 signal =3D true;
> >=20
> > ?
>=20
> Indenting at least is strange. I don't have a preference for the
> ordering of conditions, so if you like the latter order, we can just use
> that.

I just happen to find it easier to read that way. If you want to keep
the ordering that's fine, but the indentation needs to be fixed.

> >> +{
> >> +     u32 get_restart;
> >=20
> > Maybe just call this "restart" or "restart_addr". get_restart sounds
> > like a function name.
>=20
> Ok, how about "restart_dmaget_addr"? That indicates what we're doing
> with the restart address.

Sounds good.

> >> +     list_for_each_entry(job, &cdma->sync_queue, list) {
> >> +             if (syncpt_val < job->syncpt_end)
> >> +                     break;
> >> +
> >> +             host1x_job_dump(&dev->dev, job);
> >> +     }
> >=20
> > That's potentially a lot of debug output. I wonder if it might make
> > sense to control parts of this via a module parameter. Then again, if
> > somebody really needs to debug this, maybe they really want *all* the
> > information.
>=20
> host1x_job_dump() uses dev_dbg(), so it only dumps a lot if DEBUG has
> been defined in that file.

Okay, let's leave it like that then.

> >> +/*
> >> + * Destroy a cdma
> >> + */
> >> +void host1x_cdma_deinit(struct host1x_cdma *cdma)
> >> +{
> >> +     struct push_buffer *pb =3D &cdma->push_buffer;
> >> +     struct host1x *host1x =3D cdma_to_host1x(cdma);
> >> +
> >> +     if (cdma->running) {
> >> +             pr_warn("%s: CDMA still running\n",
> >> +                             __func__);
> >> +     } else {
> >> +             host1x->cdma_pb_op.destroy(pb);
> >> +             host1x->cdma_op.timeout_destroy(cdma);
> >> +     }
> >> +}
> >=20
> > There's no way to recover from the situation where a cdma is still
> > running. Can this not return an error code (-EBUSY?) if the cdma can't
> > be destroyed?
>=20
> It's called from close(), which cannot return an error code. It's
> actually more of a power optimization. The effect is that if there are
> no users for channel, we'll just not free up the push buffer.
>=20
> I think the proper fix would actually be to check in host1x_cdma_init()
> if push buffer is already allocated and cdma->running. In that case we
> could skip most of initialization.

Yes, in that case it might be useful to do this. I still think it's
worth to return an error code to the caller, even if it can't be
propagated. That way the caller at least has the possibility to react.

I'm still not quite sure I understand the necessity for this, though.
Maybe you can give an example of when this will actually happen?

> >> +/*
> >> + * cdma
> >> + *
> >> + * This is in charge of a host command DMA channel.
> >> + * Sends ops to a push buffer, and takes responsibility for unpinning
> >> + * (& possibly freeing) of memory after those ops have completed.
> >> + * Producer:
> >> + *   begin
> >> + *           push - send ops to the push buffer
> >> + *   end - start command DMA and enqueue handles to be unpinned
> >> + * Consumer:
> >> + *   update - call to update sync queue and push buffer, unpin memory
> >> + */
> >=20
> > I find the name to be a bit confusing. For some reason I automatically
> > think of GSM when I read CDMA. This really is more of a job queue, so
> > maybe calling it host1x_job_queue might be more appropriate. But I've
> > already requested a lot of things to be renamed, so I think I can live
> > with this being called CDMA if you don't want to change it.
> >=20
> > Alternatively all of these could be moved to the struct host1x_channel
> > given that there's only one of each of the push_buffer, buffer_timeout
> > and host1x_cma objects per channel.
>=20
> I did consider merging those two at a time. That should work, as they
> both deal with channels essentially. I also saw that the resulting file
> and data structures became quite large, so I have so far preferred to
> keep them separate.
>=20
> This way I can keep the "higher level" stuff (inserting setclass,
> serializing, allocating sync point ranges, etc) in one file and lower
> level stuff (write to hardware, deal with push buffer pointers, etc) in
> another.

Alright. I can live with that.

> >> +int host1x_channel_submit(struct host1x_job *job)
> >> +{
> >> +     return host1x_get_host(job->ch->dev)->channel_op.submit(job);
> >> +}
> >=20
> > I'd expect a function named host1x_channel_submit() to take a struct
> > host1x_channel *. Should this perhaps be called host1x_job_submit()?
>=20
> It calls into channel code directly, and the underlying op also just
> takes a job. We could add channel as a parameter, and not pass it in
> host1x_job_alloc(). but we actually need the channel data already in
> host1x_job_pin(), which comes before submit. We need it so that we pin
> the buffer to correct engine.

That's all fine. My point was that this operates on a job object, so I'd
find it more intuitive if the function name reflected that. There's
nothing wrong with submitting a job without explicitly specifying the
channel if it is tied to one channel anyway.

host1x_channel_submit() would imply "submit channel", which doesn't make
sense, so the next best alternative is "submit job to channel", but that
isn't reflected in the parameters. So host1x_job_submit() fits pretty
well. There's no reason why it has to be prefixed host1x_channel_*,
right?

> >> +struct host1x_channel *host1x_channel_alloc(struct platform_device *p=
dev)
> >> +{
> >> +     struct host1x_channel *ch =3D NULL;
> >> +     struct host1x *host1x =3D host1x_get_host(pdev);
> >> +     int chindex;
> >> +     int max_channels =3D host1x->info.nb_channels;
> >> +     int err;
> >> +
> >> +     mutex_lock(&host1x->chlist_mutex);
> >> +
> >> +     chindex =3D host1x->allocated_channels;
> >> +     if (chindex > max_channels)
> >> +             goto fail;
> >> +
> >> +     ch =3D kzalloc(sizeof(*ch), GFP_KERNEL);
> >> +     if (ch =3D=3D NULL)
> >> +             goto fail;
> >> +
> >> +     /* Link platform_device to host1x_channel */
> >> +     err =3D host1x->channel_op.init(ch, host1x, chindex);
> >> +     if (err < 0)
> >> +             goto fail;
> >> +
> >> +     ch->dev =3D pdev;
> >> +
> >> +     /* Add to channel list */
> >> +     list_add_tail(&ch->list, &host1x->chlist.list);
> >> +
> >> +     host1x->allocated_channels++;
> >> +
> >> +     mutex_unlock(&host1x->chlist_mutex);
> >> +     return ch;
> >> +
> >> +fail:
> >> +     dev_err(&pdev->dev, "failed to init channel\n");
> >> +     kfree(ch);
> >> +     mutex_unlock(&host1x->chlist_mutex);
> >> +     return NULL;
> >> +}
> >=20
> > I think the critical section could be shorter here. It's probably not
> > worth the extra trouble, though, given that channels are not often
> > allocated.
>=20
> Yeah, boot time isn't measured in microseconds. :-) But, if we just make
> allocated_channels an atomic, we should be able to drop chlist_mutex
> altogether and it could simplify the code.

You still need to protect the list from concurrent modification.

> >> +/* channel list operations */
> >> +void host1x_channel_list_init(struct host1x *);
> >> +void host1x_channel_for_all(struct host1x *, void *data,
> >> +     int (*fptr)(struct host1x_channel *ch, void *fdata));
> >> +
> >> +struct host1x_channel *host1x_channel_alloc(struct platform_device *p=
dev);
> >> +void host1x_channel_free(struct host1x_channel *ch);
> >=20
> > Is it a good idea to make host1x_channel_free() publicly available?
> > Shouldn't the host1x_channel_alloc()/host1x_channel_request() return a
> > host1x_channel with a reference count of 1 and everybody release their
> > reference using host1x_channel_put() to make sure the channel is freed
> > only after the last reference disappears?
> >=20
> > Otherwise whoever calls host1x_channel_free() will confuse everybody
> > else that's still keeping a reference.
>=20
> The difference is that _put and _get are called to indicate how many
> user space processes there are for the channel. Even if there are no
> processes, we won't free the channel structure - we just freeze the chann=
el.
>=20
> _alloc and _free are different in that they actually create the channel
> structs and delete them and they follow the lifecycle of the driver.
> Perhaps we should figure new naming, but refcounting and alloc/free
> cannot be merged here.

I understand. Perhaps better names would be host1x_channel_setup() and
host1x_channel_teardown()?

> >> +{
> >> +     struct drm_gem_cma_object *obj =3D to_cma_obj((void *)id);
> >> +     struct mutex *struct_mutex =3D &obj->base.dev->struct_mutex;
> >> +
> >> +     mutex_lock(struct_mutex);
> >> +     drm_gem_object_reference(&obj->base);
> >> +     mutex_unlock(struct_mutex);
> >=20
> > I think it's more customary to obtain a pointer to struct drm_device and
> > then use mutex_{lock,unlock}(&drm->struct_mutex). Or you could just use
> > drm_gem_object_reference_unlocked(&obj->base) instead. Which doesn't
> > exist yet, apparently. But it could be added.
>=20
> I think we could take the former path - just refer to mutex in a
> different way.

You'll get extra points if you add the function =3D). The documentation in
Documentation/DocBook/drm.tmpl says that it exists, but it doesn't, so
you'd even be fixing a bug along the way.

> >> +int host1x_cma_pin_array_ids(struct platform_device *dev,
> >> +             long unsigned *ids,
> >> +             long unsigned id_type_mask,
> >> +             long unsigned id_type,
> >> +             u32 count,
> >> +             struct host1x_job_unpin_data *unpin_data,
> >> +             dma_addr_t *phys_addr)
> >=20
> > struct device * and unsigned long please. count can also doesn't need to
> > be a sized type. unsigned int will do just fine. The return value can
> > also be unsigned int if you don't expect to return any error conditions.
>=20
> I think we'll need to check these. ids probably needs to be a u32 *, and
> id_type_mask and id_type should be u32. They come like that from user spa=
ce.

Okay. My main point was that it's more usual to use "unsigned long" than
"long unsigned":

	linux.git $ git grep -n 'long unsigned' | wc -l
	72
	linux.git $ git grep -n 'unsigned long' | wc -l
	106575

Also the more I think about it, the more I have doubts that passing
around IDs like this (or using ID types and masks) is the right thing to
do. I'll get back to that later.

> >=20
> >> +     int allocated_channels;
> >=20
> > unsigned int? And maybe just "num_channels"?
>=20
> num_channels could be thought as "number of available channels", so I'd
> like to use num_allocated_channels here.

Okay.

> >> diff --git a/drivers/gpu/host1x/host1x.h b/drivers/gpu/host1x/host1x.h
> > [...]
> >> +enum host1x_class {
> >> +     NV_HOST1X_CLASS_ID              =3D 0x1,
> >> +     NV_GRAPHICS_2D_CLASS_ID         =3D 0x51,
> >=20
> > This entry belongs in a later patch, right? And I find it convenient if
> > enumeration constants start with the enum name as prefix. Furthermore
> > it'd be nice to reuse the hardware module names, like so:
> >=20
> >         enum host1x_class {
> >                 HOST1X_CLASS_HOST1X,
> >                 HOST1X_CLASS_GR2D,
> >                 HOST1X_CLASS_GR3D,
> >         };
>=20
> The naming sounds good. We already use HOST1X_CLASS_HOST1X in code to
> insert a wait. If you'd prefer, we can move the definition of
> HOST1X_CLASS_GR2D to the later patch.

Yes, it's better to introduce it in the patch that first uses it.

> >> diff --git a/drivers/gpu/host1x/hw/cdma_hw.c b/drivers/gpu/host1x/hw/c=
dma_hw.c
> > [...]
> >> +#include <linux/slab.h>
> >> +#include <linux/scatterlist.h>
> >> +#include <linux/dma-mapping.h>
> >> +#include "cdma.h"
> >> +#include "channel.h"
> >> +#include "dev.h"
> >> +#include "memmgr.h"
> >> +
> >> +#include "cdma_hw.h"
> >> +
> >> +static inline u32 host1x_channel_dmactrl(int stop, int get_rst, int i=
nit_get)
> >> +{
> >> +     return HOST1X_CHANNEL_DMACTRL_DMASTOP_F(stop)
> >> +             | HOST1X_CHANNEL_DMACTRL_DMAGETRST_F(get_rst)
> >> +             | HOST1X_CHANNEL_DMACTRL_DMAINITGET_F(init_get);
> >=20
> > I think it is more customary to put the | at the end of the preceding
> > line:
> >=20
> >         return HOST1X_CHANNEL_DMACTRL_DMASTOP_F(stop) |
> >                HOST1X_CHANNEL_DMACTRL_DMAGETRST_F(get_rst) |
> >                HOST1X_CHANNEL_DMACTRL_DMAINITGET_F(init_get);
> >=20
> > Also since these are all single bits, I'd prefer if you could drop the
> > _F suffix and not make them take a parameter. I think it'd even be
> > better not to have this function at all, but make the intent explicit
> > where the register is written. That is, have each call site set the bits
> > explicitly instead of calling this helper. Having a parameter list such
> > as (true, false, false) or (true, true, true) is confusing since you
> > have to keep looking up the meaning of the parameters.
>=20
> The operation that the _F macros do is masking and bit shifting the
> fields correctly. Without that, we'd need to expose several macros to
> mask and shift, and I'd rather just have one macro to take care of that.
>=20
> But, we can open code the function to wherever it's used if that's more
> readable.

I wasn't arguing against masking and shifting, but rather in favour of
treating these like normal bit definitions. So instead of passing a
boolean parameter to the macro, you just don't use it if the bit isn't
supposed to be set. And if you want to set the bit you or in the value.

So:

	static inline u32 host1x_channel_dmactrl_dmastop(void)
	{
		return 1 << 0;
	}

	#define HOST1X_CHANNEL_DMACTRL_DMASTOP \
		host1x_channel_dmactrl_dmastop()

> >> +/*
> >> + * Similar to cdma_start(), but rather than starting from an idle
> >> + * state (where DMA GET is set to DMA PUT), on a timeout we restore
> >> + * DMA GET from an explicit value (so DMA may again be pending).
> >> + */
> >> +static void cdma_timeout_restart(struct host1x_cdma *cdma, u32 getptr)
> >> +{
> >> +     struct host1x *host1x =3D cdma_to_host1x(cdma);
> >> +     struct host1x_channel *ch =3D cdma_to_channel(cdma);
> >> +
> >> +     if (cdma->running)
> >> +             return;
> >> +
> >> +     cdma->last_put =3D host1x->cdma_pb_op.putptr(&cdma->push_buffer);
> >> +
> >> +     host1x_ch_writel(ch, host1x_channel_dmactrl(true, false, false),
> >> +             HOST1X_CHANNEL_DMACTRL);
> >> +
> >> +     /* set base, end pointer (all of memory) */
> >> +     host1x_ch_writel(ch, 0, HOST1X_CHANNEL_DMASTART);
> >> +     host1x_ch_writel(ch, 0xFFFFFFFF, HOST1X_CHANNEL_DMAEND);
> >=20
> > According to the TRM, writing to HOST1X_CHANNEL_DMASTART will start a
> > DMA transfer on the channel (if DMA_PUT !=3D DMA_GET). Irrespective of
> > that, why set the valid range to all of physical memory? We know the
> > valid range of the push buffer, why not set the limits accordingly?
>=20
> That'd make sense. Currently we use the RESTART as the barrier, but
> having hardware check against DMAEND is a good idea, too.

Any reason why DMASTART shouldn't be used to restrict the range as well?

> >> +/*
> >> + * Kick channel DMA into action by writing its PUT offset (if it has =
changed)
> >> + */
> >> +static void cdma_kick(struct host1x_cdma *cdma)
> >> +{
> >> +     struct host1x *host1x =3D cdma_to_host1x(cdma);
> >> +     struct host1x_channel *ch =3D cdma_to_channel(cdma);
> >> +     u32 put;
> >> +
> >> +     put =3D host1x->cdma_pb_op.putptr(&cdma->push_buffer);
> >> +
> >> +     if (put !=3D cdma->last_put) {
> >> +             host1x_ch_writel(ch, put, HOST1X_CHANNEL_DMAPUT);
> >> +             cdma->last_put =3D put;
> >> +     }
> >> +}
> >=20
> > kick() sounds unusual. Maybe flush or commit or something similar would
> > be more accurate.
>=20
> We could use flush.

Great.

> >> +     host1x_sync_writel(host1x, cmdproc_stop, HOST1X_SYNC_CMDPROC_STO=
P);
> >> +
> >> +     cdma->torndown =3D false;
> >> +     cdma_timeout_restart(cdma, getptr);
> >> +}
> >=20
> > I find this a bit non-intuitive. We teardown a channel, and when we're
> > done tearing down, the torndown variable is set to false and the channel
> > is actually restarted. Maybe you could explain some more how this works
> > and what its purpose is.
>=20
> Actually, teardown_begin freezes the channel, then we manipulate the
> queue, and in the end teardown_end restarts the channel. So these should
> be named freeze and resume. We could even drop the timeout from the
> names of these functions.

Sounds good.

> >> +     /* stop processing to get a clean snapshot */
> >> +     prev_cmdproc =3D host1x_sync_readl(host1x, HOST1X_SYNC_CMDPROC_S=
TOP);
> >> +     cmdproc_stop =3D prev_cmdproc | BIT(ch->chid);
> >> +     host1x_sync_writel(host1x, cmdproc_stop, HOST1X_SYNC_CMDPROC_STO=
P);
> >> +
> >> +     dev_dbg(&host1x->dev->dev, "cdma_timeout: cmdproc was 0x%x is 0x=
%x\n",
> >> +             prev_cmdproc, cmdproc_stop);
> >> +
> >> +     syncpt_val =3D host1x_syncpt_load_min(host1x->syncpt);
> >> +
> >> +     /* has buffer actually completed? */
> >> +     if ((s32)(syncpt_val - cdma->timeout.syncpt_val) >=3D 0) {
> >> +             dev_dbg(&host1x->dev->dev,
> >> +                      "cdma_timeout: expired, but buffer had complete=
d\n");
> >=20
> > Maybe this should really be a warning?
>=20
> Not really - it's actually just a normal state. We got a timeout event,
> but before we process it, it might be that the job manages to complete.
> This can happen, and is not an error case.

Okay, I see. That's fine then.

> >> +     for (i =3D 0 ; i < job->num_gathers; i++) {
> >> +             struct host1x_job_gather *g =3D &job->gathers[i];
> >> +             u32 op1 =3D host1x_opcode_gather(g->words);
> >> +             u32 op2 =3D g->mem_base + g->offset;
> >> +             host1x_cdma_push_gather(&job->ch->cdma,
> >> +                             job->gathers[i].ref,
> >> +                             job->gathers[i].offset,
> >> +                             op1, op2);
> >> +     }
> >> +}
> >=20
> > Perhaps inline this into channel_submit()? I'm not sure how useful it
> > really is to split off smallish functions such as this which aren't
> > reused anywhere else. I don't have any major objection though, so you
> > can keep it separate if you want.
>=20
> I split these out because channel_submit() became so long that I
> couldn't understand it anymore. I'd prefer keeping separate just to keep
> myself (semi-)sane.

Okay. =3D)

> >> diff --git a/drivers/gpu/host1x/hw/host1x01.c b/drivers/gpu/host1x/hw/=
host1x01.c
> > [...]
> >>  #include "hw/host1x01.h"
> >>  #include "dev.h"
> >> +#include "channel.h"
> >>  #include "hw/host1x01_hardware.h"
> >>
> >> +#include "hw/channel_hw.c"
> >> +#include "hw/cdma_hw.c"
> >>  #include "hw/syncpt_hw.c"
> >>  #include "hw/intr_hw.c"
> >>
> >>  int host1x01_init(struct host1x *host)
> >>  {
> >> +     host->channel_op =3D host1x_channel_ops;
> >> +     host->cdma_op =3D host1x_cdma_ops;
> >> +     host->cdma_pb_op =3D host1x_pushbuffer_ops;
> >>       host->syncpt_op =3D host1x_syncpt_ops;
> >>       host->intr_op =3D host1x_intr_ops;
> >=20
> > I think I mentioned this before, but I'd prefer not to have the .c files
> > included here, but rather reference the ops structures externally. But I
> > still think that especially CDMA and push buffer ops don't need to be in
> > separate structures since they aren't likely to change with new hardware
> > revisions.
>=20
> The C files need to be included here so that they pick up the hardware
> defs for the correct SoC. Pushbuffer is probably something we can
> generalize, but channel registers can change, so they need to be per SoC.

We can do the same using extern variables, can't we? If you're concerned
about the definitions that come from the headers, we can probably make
that work by parameterizing more.

I think we can live with this way for now and clean it up later, though.

> >> diff --git a/drivers/gpu/host1x/hw/hw_host1x01_channel.h b/drivers/gpu=
/host1x/hw/hw_host1x01_channel.h
> > [...]
> >> +#define HOST1X_CHANNEL_DMACTRL_DMASTOP_F(v) \
> >> +     host1x_channel_dmactrl_dmastop_f(v)
> >=20
> > I mentioned this elsewhere already, but I think the _F suffix (and _f
> > for that matter) along with the v parameter should go away.
>=20
> I'd prefer keeping so that I don't have to use two #defines to replace
> one. That IMO makes the usage harder and more error prone.

That's precisely my point. This actually makes it harder to use. If you
don't want to set the bit, just don't or it in. It's completely
pointless to shift and mask an unset bit.

> >> diff --git a/drivers/gpu/host1x/hw/hw_host1x01_uclass.h b/drivers/gpu/=
host1x/hw/hw_host1x01_uclass.h
> > [...]
> >=20
> > What does the "uclass" stand for? It seems a bit useless to me.
>=20
> It means host1x class, i.e. the host1x registers that can be written to
> from push buffers.

I still don't understand why we need uclass. It seems redundant.

> >> diff --git a/drivers/gpu/host1x/intr.c b/drivers/gpu/host1x/intr.c
> > [...]
> >> +static void action_submit_complete(struct host1x_waitlist *waiter)
> >> +{
> >> +     struct host1x_channel *channel =3D waiter->data;
> >> +     int nr_completed =3D waiter->count;
> >=20
> > No need for this variable.
>=20
> I'm using it for tracing in a follow-up patch. It can be used in traces
> for checking the queue length at each point of time.

Any reason why it can't be introduced in the follow-up patch?

> >> +struct host1x_job *host1x_job_alloc(struct host1x_channel *ch,
> >> +             u32 num_cmdbufs, u32 num_relocs, u32 num_waitchks)
> >=20
> > Maybe make the parameters unsigned int instead of u32?
>=20
> I'll check this, but we're getting them from user space, and that API
> has a fixed length field. That's why I'm carrying that type over.

Okay, it isn't that important.

> >> +void host1x_job_add_gather(struct host1x_job *job,
> >> +             u32 mem_id, u32 words, u32 offset)
> >> +{
> >> +     struct host1x_job_gather *cur_gather =3D
> >> +                     &job->gathers[job->num_gathers];
> >=20
> > Should this check for overflow?
>=20
> As defensive measure, could do, but this is not exploitable.

Alright then.

> >> +
> >> +             /* remove completed reloc from the job */
> >> +             if (i !=3D job->num_relocs - 1) {
> >> +                     struct host1x_reloc *reloc_last =3D
> >> +                             &job->relocarray[job->num_relocs - 1];
> >> +                     reloc->cmdbuf_mem       =3D reloc_last->cmdbuf_m=
em;
> >> +                     reloc->cmdbuf_offset    =3D reloc_last->cmdbuf_o=
ffset;
> >> +                     reloc->target           =3D reloc_last->target;
> >> +                     reloc->target_offset    =3D reloc_last->target_o=
ffset;
> >> +                     reloc->shift            =3D reloc_last->shift;
> >> +                     job->reloc_addr_phys[i] =3D
> >> +                             job->reloc_addr_phys[job->num_relocs - 1=
];
> >> +                     job->num_relocs--;
> >> +             } else {
> >> +                     break;
> >> +             }
> >> +     }
> >> +
> >> +     if (cmdbuf_page_addr)
> >> +             host1x_memmgr_kunmap(h, last_page, cmdbuf_page_addr);
> >> +
> >> +     return 0;
> >> +}
> >=20
> > Also the algorithm seems a bit strange and hard to follow. Instead of
> > removing relocs from the job, replacing them with the last entry and
> > decrementing job->num_relocs, how much is the penalty for always
> > iterating over all relocs? This is one of the other cases where I'd
> > argue that simplicity is key. Furthermore you need to copy quite a bit
> > of data to replace the completed relocs, so I'm not sure it buys you
> > much.
> >=20
> > It could always be optimized later on by just setting a bit in the reloc
> > to mark it as completed, or keep a bitmask of completed relocations or
> > whatever.
>=20
> This was done in a big optimization patch, but we'll check if we could
> remove this. Previously we just set cmdbuf_mem for the completed reloc
> to 0, and that should work in this case.

That certainly sounds simpler.

> >> +             int err =3D PTR_ERR(job->gather_copy_mapped);
> >> +             job->gather_copy_mapped =3D NULL;
> >> +             return err;
> >> +     }
> >> +
> >> +     job->gather_copy_size =3D size;
> >> +
> >> +     for (i =3D 0; i < job->num_gathers; i++) {
> >> +             struct host1x_job_gather *g =3D &job->gathers[i];
> >> +             void *gather =3D host1x_memmgr_mmap(g->ref);
> >> +             memcpy(job->gather_copy_mapped + offset,
> >> +                             gather + g->offset,
> >> +                             g->words * sizeof(u32));
> >> +
> >> +             g->mem_base =3D job->gather_copy;
> >> +             g->offset =3D offset;
> >> +             g->mem_id =3D 0;
> >> +             g->ref =3D 0;
> >> +
> >> +             host1x_memmgr_munmap(g->ref, gather);
> >> +             offset +=3D g->words * sizeof(u32);
> >> +     }
> >> +
> >> +     return 0;
> >> +}
> >=20
> > I wonder, where's this DMA buffer actually used? I can't find any use
> > between this copy and the corresponding dma_free_writecombine() call.
>=20
> We replace the gathers in host1x_job with the ones we allocate here, so
> they are used when pushing the gather's to hardware.
>=20
> This is done so that user space cannot tamper with the gathers once
> they've been checked by firewall.

Oh, I had missed how g->mem_base is assigned job->gather_copy, so I had
thought the memory wasn't used anywhere. I wonder if it wouldn't be more
efficient to pre-allocate this buffer. We number of gathers is limited
by HOST1X_GATHER_QUEUE_SIZE, right? So we could allocate a buffer of the
appropriate size for each job to avoid continuously reallocating and
freeing everytime the job in pinned or unpinned.

Also jobs are allocated for each submit and allocating them is quite
expensive, so eventually we may want to pool them. Which will not be
trivial though, given that it requires the number of command buffers
and relocs to match. Some clever checks can probably make this work,
though.

> >> +     /* Null kickoff prevents submit from being sent to hardware */
> >> +     bool null_kickoff;
> >=20
> > I don't think this is used anywhere.
>=20
> True, we can remove this as we haven't posted the code for null kickoff.

Make sure to explain what this is used for when you post. The one
comment above is a bit vague.

> >> +     /* Check if register is marked as an address reg */
> >> +     int (*is_addr_reg)(struct platform_device *dev, u32 reg, u32 cla=
ss);
> >=20
> > is_addr_reg() sounds a bit unusual. Maybe match this to the name of the
> > main firewall routine, validate()?
>=20
> The point of this op is to just tell if a register for a class is
> pointing to a buffer. validate then uses this information. But both
> answers (yes/no) and both types of registers are still valid, so
> validate() wouldn't be the proper name.
>=20
> validation is then done by checking that there's a reloc corresponding
> to each register write to a register that can hold an address.

I just remembered that we discussed this already and I think we agreed
that a table lookup might be a better implementation. That'd get rid of
the naming issue altogether, since you can just name the table something
like address_registers, which is quite unambiguous.

> >> diff --git a/drivers/gpu/host1x/memmgr.h b/drivers/gpu/host1x/memmgr.h
> > [...]
> >> +struct mem_handle;
> >> +struct platform_device;
> >> +
> >> +struct host1x_job_unpin_data {
> >> +     struct mem_handle *h;
> >> +     struct sg_table *mem;
> >> +};
> >> +
> >> +enum mem_mgr_flag {
> >> +     mem_mgr_flag_uncacheable =3D 0,
> >> +     mem_mgr_flag_write_combine =3D 1,
> >> +};
> >=20
> > I'd like to see this use a more object-oriented approach and more common
> > terminology. All of these handles are essentially buffer objects, so
> > maybe something like host1x_bo would be a nice and short name.
> >=20
> > To make this more object-oriented, I propose something like:
> >=20
> >         struct host1x_bo_ops {
> >                 int (*alloc)(struct host1x_bo *bo, size_t size, unsigne=
d long align,
> >                              unsigned long flags);
> >                 int (*free)(struct host1x_bo *bo);
> >                 ...
> >         };
> >=20
> >         struct host1x_bo {
> >                 const struct host1x_bo_ops *ops;
> >         };
> >=20
> >         struct host1x_cma_bo {
> >                 struct host1x_bo base;
> >                 struct drm_gem_cma_object *obj;
> >         };
> >=20
> >         static inline struct host1x_cma_bo *to_host1x_cma_bo(struct hos=
t1x_bo *bo)
> >         {
> >                 return container_of(bo, struct host1x_cma_bo, base);
> >         }
> >=20
> >         static inline int host1x_bo_alloc(struct host1x_bo *bo, size_t =
size,
> >                                           unsigned long align, unsigned=
 long flags)
> >         {
> >                 return bo->ops->alloc(bo, size, align, flags);
> >         }
> >=20
> >         ...
> >=20
> > That should be easy to extend with a new type of BO once the IOMMU-based
> > allocator is ready. And as I said it is much closer in terminology to
> > what other drivers do.
>=20
> One complexity is that we're using the same type for communicating with
> user space. Each buffer carries with it a flag indicating its allocator.
> We might be able to model the internal structure to be more like what
> you propose, but for the API we still need the flag.

I disagree. I don't see any need for passing around the type at all.
We've discussed this a few times already, and correct me if I'm wrong,
but I think we agreed that we don't want to mix handle/buffer types.

We only support CMA for now, so all buffers will be allocated from CMA.
Once the IOMMU-based allocator is ready we'll want to switch to that for
Tegra30 and later, but stick to CMA for Tegra20 since the GART isn't
very usable.

So the way I see it, the decision about which allocator to use is done
once at driver probe time. So all that's really needed is a function
that allocates a buffer object and returns the proper one for the given
Tegra SoC. Once a host1x_bo object is returned it can be used throughout
and we get rid of the additional memmgr abstraction. I think it'll make
things much simpler.

Thierry

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRLco3AAoJEN0jrNd/PrOhs14P/izm6xTfvulEn/DQxYtKOxyy
xmlg9LcgUPG83e4omyOto5J0lTUeDBPZ3Qy4CFjlL5ta83qR8hYfq0S3JZcSgkpI
QUOMYGIpbvLOdPTnjzVNN6bY14YIT0j4A/xlan18hK9+v+IcCoSAgOlf5Mvg7v4W
+IH0JqbCUb2oH01w8TrOQz/g4VZN9OktcyjzWjfGg560Bi+/lbA8evO4W7KvyNnF
5BGco2xmRaKnyNfPU4f9ejovMU9Kz17yxrygN5F95au+O7NiCcFHBAo1PLS23fxr
ix2TwNJ4bnI8vjILY0kp4xRiP/NUqAV4+WTjkL6ab7A+S9KX/BWxu5O/a+WaUdbj
b95orSJp7qUwT5dvfYmseAiyBphUkyQyMYK8Q4apuaSOgiYYTllPLw1eEc8JgB2E
aQMOcVuHFn0bCcjV3uz150Fn+UZ/Wfcscwp8l/F11G0edZM+gpF2djPYwSsvtTQn
4YTskAHNM7pvxxkmj5jva98TruKLn9vRJXkJ4UDaLoL7XD5v80vgKRKX8J0TmlZA
gNHGrfC8VejXu0lTnYY1Tf5pp0KBm2aM/TUt729maD/VWR1oPfgOu2YJRtVsGzdY
uQJJ9fn+BKKHXTb59W/eR1PSWRT9rXVIK6rxasH28fuF54Id+D03798DQ+IJ6+9H
9sNBPqrEF1D2vOyWjCKN
=7AAb
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
