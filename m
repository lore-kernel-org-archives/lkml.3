Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab3BEDaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 22:30:24 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15858 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3BEDaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 22:30:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Feb 2013 19:29:48 -0800
Message-ID: <51107CC0.9060900@nvidia.com>
Date: Mon, 4 Feb 2013 19:30:08 -0800
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 1/8] gpu: host1x: Add host1x driver
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-2-git-send-email-tbergstrom@nvidia.com> <20130204090941.GA27443@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130204090941.GA27443@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.02.2013 01:09, Thierry Reding wrote:
> On Tue, Jan 15, 2013 at 01:43:57PM +0200, Terje Bergstrom wrote:
>> Add host1x, the driver for host1x and its client unit 2D.
> 
> Maybe this could be a bit more verbose. Perhaps describe what host1x is.

Sure. I could just steal the paragraph from Stephen:

The Tegra host1x module is the DMA engine for register access to Tegra's
graphics- and multimedia-related modules. The modules served by host1x
are referred to as clients. host1x includes some other  functionality,
such as synchronization.

>> diff --git a/drivers/gpu/host1x/Kconfig b/drivers/gpu/host1x/Kconfig
> [...]
>> @@ -0,0 +1,6 @@
>> +config TEGRA_HOST1X
>> +     tristate "Tegra host1x driver"
>> +     help
>> +       Driver for the Tegra host1x hardware.
> 
> Maybe s/Tegra/NVIDIA Tegra/?

Sounds good.

>> +
>> +       Required for enabling tegradrm.
> 
> This should probably be dropped. Either encode such knowledge as
> explicit dependencies or in this case just remove it altogether since we
> will probably merge both drivers anyway.

I think this was left from previous versions. Now it just doesn't make
sense. I'll just drop it.

> 
>> diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
> [...]
>> +#include <linux/module.h>
>> +#include <linux/list.h>
>> +#include <linux/slab.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/clk.h>
>> +#include <linux/io.h>
>> +#include "dev.h"
> 
> Maybe add a blank line between the previous two lines to visually
> separate standard Linux includes from driver-specific ones.

Ok. You commented in quite few places in a similar way. I'll fix all of
them to first include system includes, then driver's own includes, and
add a blank line in between.

> 
>> +#include "hw/host1x01.h"
>> +
>> +#define CREATE_TRACE_POINTS
>> +#include <trace/events/host1x.h>
>> +
>> +#define DRIVER_NAME          "tegra-host1x"
> 
> You only ever use this once, so maybe it can just be dropped?

Yes.

> 
>> +static struct host1x_device_info host1x_info = {
> 
> Perhaps this should be host1x01_info in order to match the hardware
> revision? That'll avoid it having to be renamed later on when other
> revisions start to appear.

Ok, will do. I thought it'd be awkward being alone until the second
version appears, but I'll add it.

> 
>> +static int host1x_probe(struct platform_device *dev)
>> +{
> [...]
>> +     syncpt_irq = platform_get_irq(dev, 0);
>> +     if (IS_ERR_VALUE(syncpt_irq)) {
> 
> This is somewhat unusual. It should be fine to just do:
> 
>         if (syncpt_irq < 0)
> 
> but IS_ERR_VALUE() should work fine too.

I'll use the simpler version.

> 
>> +     memcpy(&host->info, devid->data, sizeof(struct host1x_device_info));
> 
> Why not make the .info field a pointer to struct host1x_device_info
> instead? That way you don't have to keep separate copies of the same
> information.

This had something to do with __init data and non-init data. But, we're
not really putting this data into __init, so we should be able to use
just a pointer.

> 
>> +     /* set common host1x device data */
>> +     platform_set_drvdata(dev, host);
>> +
>> +     host->regs = devm_request_and_ioremap(&dev->dev, regs);
>> +     if (!host->regs) {
>> +             dev_err(&dev->dev, "failed to remap host registers\n");
>> +             return -ENXIO;
>> +     }
> 
> This should probably be rewritten as:
> 
>         host->regs = devm_ioremap_resource(&dev->dev, regs);
>         if (IS_ERR(host->regs))
>                 return PTR_ERR(host->regs);
> 
> Though that function will only be available in 3.9-rc1.

Ok, 3.9-rc1 is fine as a basis.

>> +     err = host1x_syncpt_init(host);
>> +     if (err)
>> +             return err;
> [...]
>> +     host1x_syncpt_reset(host);
> 
> Why separate host1x_syncpt_reset() from host1x_syncpt_init()? I see why
> it might be useful to have host1x_syncpt_reset() as a separate function
> but couldn't it be called as part of host1x_syncpt_init()?

host1x_syncpt_init() is used for initializing the syncpt structures, and
is called in probe. host1x_syncpt_reset() should be called whenever we
think hardware state is lost, for example if VDD_CORE was rail gated due
to system suspend.

> 
>> +     dev_info(&dev->dev, "initialized\n");
> 
> I don't think this is very useful. We should make sure to tell people
> when things fail. When everything goes as planned we don't need to brag
> about it =)

True. I wish other kernel drivers followed that same philosophy. :-)
I'll remove that. It's mainly useful as debug help, but it's as easy to
check from sysfs the state.

> 
>> diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
> [...]
>> +struct host1x_syncpt_ops {
> [...]
>> +     const char * (*name)(struct host1x_syncpt *);
> 
> Why do we need this? Could we not refer to the syncpt name directly
> instead of going through this wrapper? I'd expect the name to be static.

This must be a relic. I'll remove the wrapper.

> 
>> +struct host1x_device_info {
> 
> Maybe this should be called simply host1x_info? _device seems redundant.

Sure.

> 
>> +     int     nb_channels;            /* host1x: num channels supported */
>> +     int     nb_pts;                 /* host1x: num syncpoints supported */
>> +     int     nb_bases;               /* host1x: num syncpoints supported */
>> +     int     nb_mlocks;              /* host1x: number of mlocks */
>> +     int     (*init)(struct host1x *); /* initialize per SoC ops */
>> +     int     sync_offset;
>> +};
> 
> While this isn't public API, maybe it would still be useful to turn the
> comments into proper kerneldoc? That's what people are used to.

Ok.

> 
>> +struct host1x {
>> +     void __iomem *regs;
>> +     struct host1x_syncpt *syncpt;
>> +     struct platform_device *dev;
>> +     struct host1x_device_info info;
>> +     struct clk *clk;
>> +
>> +     struct host1x_syncpt_ops syncpt_op;
> 
> Maybe make this a struct host1x_syncpt_ops * instead so you don't have
> separate copies? While at it, maybe this should be const as well.

Sounds good. I guess there are other areas in need of a const, too.

> 
>> +     struct dentry *debugfs;
> 
> This doesn't seem to be used anywhere.

It's a failed split - it's used in the debug patch (4/8).

> 
>> +static inline
>> +struct host1x *host1x_get_host(struct platform_device *_dev)
>> +{
>> +     struct platform_device *pdev;
>> +
>> +     if (_dev->dev.parent) {
>> +             pdev = to_platform_device(_dev->dev.parent);
>> +             return platform_get_drvdata(pdev);
>> +     } else
>> +             return platform_get_drvdata(_dev);
>> +}
> 
> There is a lot of needless casting in here. Why not pass in a struct
> device * and use dev_get_drvdata() instead?

Hmm, true, this should fit into smaller space.

> 
>> diff --git a/drivers/gpu/host1x/hw/host1x01.c b/drivers/gpu/host1x/hw/host1x01.c
> [...]
>> +#include "hw/host1x01.h"
>> +#include "dev.h"
>> +#include "hw/host1x01_hardware.h"
> 
> The ordering here looks funny.

I'll make it more alphabetic.

> 
>> +#include "hw/syncpt_hw.c"
> 
> Why include the source file here? Can't you compile it separately
> instead?

It's because we need to compile with the hardware headers of that host1x
version, because we haven't been good at keeping compatibility. So
host1x01.c #includes version 01 headers, and syncpt_hw.c in this
compilation unit gets compiled with that. 02 would include 02 headers,
and syncpt_hw.c would get compiled with its register definitions etc.

> 
>> diff --git a/drivers/gpu/host1x/hw/host1x01.h b/drivers/gpu/host1x/hw/host1x01.h
> [...]
>> +int host1x01_init(struct host1x *);
> 
> For completeness you should probably name the parameter, even if this is
> a prototype.

Ok.

> 
>> diff --git a/drivers/gpu/host1x/hw/host1x01_hardware.h b/drivers/gpu/host1x/hw/host1x01_hardware.h
> [...]
>> +#include <linux/types.h>
>> +#include <linux/bitops.h>
>> +#include "hw_host1x01_sync.h"
> 
> Again, a blank line might help between the above two. I also assume that
> this file will be filled with more content later on, so I guess it's not
> worth the trouble to postpone it's creation until a later point.

Yeah, most of the content gets added by the dreaded patch 3.

> 
>> diff --git a/drivers/gpu/host1x/hw/hw_host1x01_sync.h b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
> [...]
>> +static inline u32 host1x_sync_syncpt_0_r(void)
>> +{
>> +     return 0x400;
>> +}
>> +#define HOST1X_SYNC_SYNCPT_0 \
>> +     host1x_sync_syncpt_0_r()
>> +static inline u32 host1x_sync_syncpt_base_0_r(void)
>> +{
>> +     return 0x600;
>> +}
>> +#define HOST1X_SYNC_SYNCPT_BASE_0 \
>> +     host1x_sync_syncpt_base_0_r()
>> +static inline u32 host1x_sync_syncpt_cpu_incr_r(void)
>> +{
>> +     return 0x700;
>> +}
> 
> Perhaps it would be useful to modify these to take the syncpt ID as a
> parameter? That way you don't have to remember to do the multiplication
> everytime you access the register?

Yeah, sounds good.

> 
>> diff --git a/drivers/gpu/host1x/hw/syncpt_hw.c b/drivers/gpu/host1x/hw/syncpt_hw.c
> [...]
>> +/*
>> + * Updates the last value read from hardware.
>> + * (was host1x_syncpt_load_min)
> 
> Can the comment in () not be dropped? Given that this is new code nobody
> would know about the old name.

Yes, it should be dropped.

> 
>> + */
>> +static u32 syncpt_load_min(struct host1x_syncpt *sp)
>> +{
>> +     struct host1x *dev = sp->dev;
>> +     u32 old, live;
>> +
>> +     do {
>> +             old = host1x_syncpt_read_min(sp);
>> +             live = host1x_sync_readl(dev,
>> +                             HOST1X_SYNC_SYNCPT_0 + sp->id * 4);
>> +     } while ((u32)atomic_cmpxchg(&sp->min_val, old, live) != old);
> 
> I think this warrants a comment.

Sure. It just loops in case there's a race writing to min_val.

> 
>> +     if (!host1x_syncpt_check_max(sp, live))
>> +             dev_err(&dev->dev->dev,
>> +                             "%s failed: id=%u, min=%d, max=%d\n",
>> +                             __func__,
>> +                             sp->id,
>> +                             host1x_syncpt_read_min(sp),
>> +                             host1x_syncpt_read_max(sp));
> 
> You could probably make this fit into less lines.

Yes, definitely. Will do.

> 
>> +/*
>> + * Write a cpu syncpoint increment to the hardware, without touching
>> + * the cache. Caller is responsible for host being powered.
>> + */
> 
> The last part of this comment applies to every host1x function, right?
> So maybe it should just be dropped.

Yeah, we don't really have runtime PM, so host1x is anyway turned on. In
downstream, with dynamic power management, some functions require caller
to ensure power is on, some functions turn on power themselves.

I'll remove these comments, as they do not apply until we have runtime PM.

> 
>> +static void syncpt_debug(struct host1x_syncpt *sp)
>> +{
>> +     u32 i;
>> +     for (i = 0; i < host1x_syncpt_nb_pts(sp->dev); i++) {
>> +             u32 max = host1x_syncpt_read_max(sp);
>> +             u32 min = host1x_syncpt_load_min(sp);
>> +             if (!max && !min)
>> +                     continue;
>> +             dev_info(&sp->dev->dev->dev,
>> +                     "id %d (%s) min %d max %d\n",
>> +                     i, sp->name,
>> +                     min, max);
>> +
>> +     }
> 
> There's a gratuitous blank line above.

Will remove.

> 
>> +
>> +     for (i = 0; i < host1x_syncpt_nb_bases(sp->dev); i++) {
>> +             u32 base_val;
>> +             host1x_syncpt_read_wait_base(sp);
>> +             base_val = sp->base_val;
>> +             if (base_val)
>> +                     dev_info(&sp->dev->dev->dev,
>> +                                     "waitbase id %d val %d\n",
>> +                                     i, base_val);
>> +
>> +     }
> 
> And another one.

Consider it gone.

> 
>> diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
> [...]
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/stat.h>
> 
> I don't think this is needed.

Yup, gone.

> 
>> +#include <linux/module.h>
>> +#include "syncpt.h"
>> +#include "dev.h"
>> +#include <trace/events/host1x.h>
> 
> Again, some more spacing would be nice here. And the ordering is a bit
> weird. Maybe put the trace include above syncpt.h and dev.h?

Will do.

> 
>> +#define MAX_SYNCPT_LENGTH    5
> 
> This doesn't seem to be used anywhere.

Yeah, it was an old restriction for length of syncpt name, but as we
moved to dynamic allocation, it doesn't apply.

> 
>> +static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
>> +             struct platform_device *pdev,
>> +             int client_managed);
> 
> Can't you move the actual implementation here? Also I'm not sure if
> passing the platform_device is the best choice here. struct device
> should work just as well.

True, and sp->pdev needs to become struct device *, too.

> 
>> +/*
>> + * Resets syncpoint and waitbase values to sw shadows
>> + */
>> +void host1x_syncpt_reset(struct host1x *dev)
> 
> Maybe host1x_syncpt_flush() would be a better name given the above
> description? Reset does have this hardware reset connotation so my first
> intuition had been that this would reset the syncpt value to 0.

Right, it actually reloads values stored in shadow registers back to
host1x. Flush doesn't feel like it's conveying the meaning. Would
host1x_syncpt_restore() work? That'd match with host1x_syncpt_save(),
which just updates all shadow registers from hardware and is used just
before host1x loses power.

> 
> If you decide to change the name, make sure to change it in the syncpt
> ops as well.

Sure.

> 
>> +/*
>> + * Updates sw shadow state for client managed registers
>> + */
>> +void host1x_syncpt_save(struct host1x *dev)
>> +{
>> +     struct host1x_syncpt *sp_base = dev->syncpt;
>> +     u32 i;
>> +
>> +     for (i = 0; i < host1x_syncpt_nb_pts(dev); i++) {
>> +             if (host1x_syncpt_client_managed(sp_base + i))
>> +                     dev->syncpt_op.load_min(sp_base + i);
>> +             else
>> +                     WARN_ON(!host1x_syncpt_min_eq_max(sp_base + i));
>> +     }
>> +
>> +     for (i = 0; i < host1x_syncpt_nb_bases(dev); i++)
>> +             dev->syncpt_op.read_wait_base(sp_base + i);
>> +}
> 
> A similar comment applies here. Though I'm not so sure about a better
> name. Perhaps host1x_syncpt_sync()?
> 
> I know that this must sound all pretty straightforward to you, but for
> somebody who hasn't used these functions at all the names are quite
> confusing. So instead of people to go read the documentation I tend to
> think that making the names as descriptive as possible is essential
> here.

I definitely agree that naming should be descriptive. This is used when
saving host1x state before it loses power, so that's why it's called
host1x_syncpt_save().

But I'm open to changing the naming, if something else would feel more
descriptive.

> 
>> +/*
>> + * Updates the last value read from hardware.
>> + */
>> +u32 host1x_syncpt_load_min(struct host1x_syncpt *sp)
>> +{
>> +     u32 val;
>> +     val = sp->dev->syncpt_op.load_min(sp);
>> +     trace_host1x_syncpt_load_min(sp->id, val);
>> +
>> +     return val;
>> +}
> 
> I don't know I understand what this means exactly. Does it read the
> value that hardware last incremented? Perhaps this will become clearer
> when you add a comment to the syncpt_load_min() implementation.

It just loads the current syncpt value to shadow register. The shadow
register is called min, because host1x tracks the range of sync point
increments that hardware is still going to do, so min is the lower
boundary of the range.

max tells what the sync point is expected to reach for hardware to be
considered idle.

host1x will f.ex. nop out waits for sync point values outside the range,
because hardware isn't good at handling syncpt value wrapping.

> 
>> +int host1x_syncpt_init(struct host1x *host)
>> +{
>> +     struct host1x_syncpt *syncpt, *sp;
>> +     int i;
>> +
>> +     syncpt = sp = devm_kzalloc(&host->dev->dev,
>> +                     sizeof(struct host1x_syncpt) * host->info.nb_pts,
> 
> You can make this a bit shorter by using sizeof(*sp) instead.

Will do.

> 
>> +     for (i = 0; i < host->info.nb_pts; ++i, ++sp) {
>> +             sp->id = i;
>> +             sp->dev = host;
> 
> Perhaps:
> 
>         syncpt[i].id = i;
>         syncpt[i].dev = host;
> 
> To avoid the need to explicitly keep track of sp?

Sounds good. I usually prefer indexing, so I'm happy with this.

> 
>> +static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
>> +             struct platform_device *pdev,
>> +             int client_managed)
>> +{
>> +     int i;
>> +     struct host1x_syncpt *sp = host->syncpt;
>> +     char *name;
>> +
>> +     for (i = 0; i < host->info.nb_pts && sp->name; i++, sp++)
>> +             ;
>> +     if (sp->pdev)
>> +             return NULL;
>> +
>> +     name = kasprintf(GFP_KERNEL, "%02d-%s", sp->id,
>> +                     pdev ? dev_name(&pdev->dev) : NULL);
>> +     if (!name)
>> +             return NULL;
>> +
>> +     sp->pdev = pdev;
>> +     sp->name = name;
>> +     sp->client_managed = client_managed;
>> +
>> +     return sp;
>> +}
>> +
>> +struct host1x_syncpt *host1x_syncpt_alloc(struct platform_device *pdev,
>> +             int client_managed)
>> +{
>> +     struct host1x *host = host1x_get_host(pdev);
>> +     return _host1x_syncpt_alloc(host, pdev, client_managed);
>> +}
> 
> I think it's enough to keep track of the struct device here instead of
> the struct platform_device.

Yes, I actually managed to comment the same thing earlier.

> 
> Also the syncpoint is not actually allocated here, so maybe
> host1x_syncpt_request() would be a better name. As a nice side-effect it
> makes the naming more similar to the IRQ API and might be easier to work
> with.

I'm not entirely sure about the difference, but isn't the number to be
allocated usually passed to a function ending in _request? Allocate
would just allocate the next available - as host1x_syncpt_allocate does.

> 
>> +struct host1x_syncpt *host1x_syncpt_get(struct host1x *dev, u32 id)
>> +{
>> +     return dev->syncpt + id;
>> +}
> 
> Should this perhaps do some error checking. What if the specified syncpt
> hasn't actually been requested before?

I'll need to check the use of host1x_syncpt_get(). It might be called
for un-allocated (or requested, if we choose that) syncpoints. An error
check would make sense at least to check that id is smaller than nb_pts.

> 
>> diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
> [...]
>> +struct host1x_syncpt {
>> +     int id;
>> +     atomic_t min_val;
>> +     atomic_t max_val;
>> +     u32 base_val;
>> +     const char *name;
>> +     int client_managed;
> 
> Is this field actually ever used? Looking through the patches none of
> the clients actually set this.

VBLANK should be set client_managed, so a follow-up patch would add a
call from dc.c to here, with client_managed=false.

> 
>> +/*
>> + * Returns true if syncpoint min == max, which means that there are no
>> + * outstanding operations.
>> + */
>> +static inline bool host1x_syncpt_min_eq_max(struct host1x_syncpt *sp)
>> +{
>> +     int min, max;
>> +     smp_rmb();
>> +     min = atomic_read(&sp->min_val);
>> +     max = atomic_read(&sp->max_val);
>> +     return (min == max);
>> +}
> 
> Maybe call this host1x_syncpt_idle() or something similar instead?

Sounds fine - although the syncpt itself isn't idle, but the
corresponding client.

> 
>> +{
>> +     return sp->id != NVSYNCPT_INVALID &&
>> +             sp->id < host1x_syncpt_nb_pts(sp->dev);
>> +}
> 
> Is there really a need for NVSYNCPT_INVALID? Even if you want to keep
> the special case you can drop the explicit check because -1 will be
> larger than host1x_syncpt_nb_pts() anyway.

No, it's not really needed, so I'll remove it.

Terje
