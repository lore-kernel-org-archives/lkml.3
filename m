Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab3BDJK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:10:26 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab3BDJKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:10:22 -0500
Date: Mon, 4 Feb 2013 10:09:41 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: amerilainen@nvidia.com, airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5,RESEND 1/8] gpu: host1x: Add host1x driver
Message-ID: <20130204090941.GA27443@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-2-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <1358250244-9678-2-git-send-email-tbergstrom@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:/SAKwKARkCKeDhm7ZSKV9s9/4CzJzzDGS3GmGRWOPyg
 R12YBEf19chA8VKZDh96w2bf57qqJ2BKIUd3iGanZkizSMCNKc
 VamDXcl2oK18bl+twlsBtyJY98bGM7oUlmGMUe6tGlAhMchzpB
 PHseWqfIEDem0E77H62cSmANhxKKQmXvsfBJ88mkwSIKMhezWF
 q5M28vPLSTWBqZC70nDnzYMsOpZtGPzobiX1/xBMNzeO0yFqB/
 GzE3BzoDd7uZdiBKvMfsFFGJeCyc+LViDiVsg8Cpb3/YRhn9io
 7YSvcaj912BdR7jReNm880xg+uadxpAAWvax1mR9tXhoGRr2oG
 oxA/YuW0/aIm5t/plo35wA7upHXP7cwqalrJKFplQQRI9Y/ptQ
 blyXcXupna+RAqvl6TZ8LEW9SPb+LiVMD5vyD8sm44IvI4Sxf1
 V9Zkb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 15, 2013 at 01:43:57PM +0200, Terje Bergstrom wrote:
> Add host1x, the driver for host1x and its client unit 2D.

Maybe this could be a bit more verbose. Perhaps describe what host1x is.

> diff --git a/drivers/gpu/host1x/Kconfig b/drivers/gpu/host1x/Kconfig
[...]
> @@ -0,0 +1,6 @@
> +config TEGRA_HOST1X
> +	tristate "Tegra host1x driver"
> +	help
> +	  Driver for the Tegra host1x hardware.

Maybe s/Tegra/NVIDIA Tegra/?

> +
> +	  Required for enabling tegradrm.

This should probably be dropped. Either encode such knowledge as
explicit dependencies or in this case just remove it altogether since we
will probably merge both drivers anyway.

> diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
[...]
> +#include <linux/module.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include "dev.h"

Maybe add a blank line between the previous two lines to visually
separate standard Linux includes from driver-specific ones.

> +#include "hw/host1x01.h"
> +
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/host1x.h>
> +
> +#define DRIVER_NAME		"tegra-host1x"

You only ever use this once, so maybe it can just be dropped?

> +static struct host1x_device_info host1x_info = {

Perhaps this should be host1x01_info in order to match the hardware
revision? That'll avoid it having to be renamed later on when other
revisions start to appear.

> +static int host1x_probe(struct platform_device *dev)
> +{
[...]
> +	syncpt_irq = platform_get_irq(dev, 0);
> +	if (IS_ERR_VALUE(syncpt_irq)) {

This is somewhat unusual. It should be fine to just do:

	if (syncpt_irq < 0)

but IS_ERR_VALUE() should work fine too.

> +	memcpy(&host->info, devid->data, sizeof(struct host1x_device_info));

Why not make the .info field a pointer to struct host1x_device_info
instead? That way you don't have to keep separate copies of the same
information.

> +	/* set common host1x device data */
> +	platform_set_drvdata(dev, host);
> +
> +	host->regs = devm_request_and_ioremap(&dev->dev, regs);
> +	if (!host->regs) {
> +		dev_err(&dev->dev, "failed to remap host registers\n");
> +		return -ENXIO;
> +	}

This should probably be rewritten as:

	host->regs = devm_ioremap_resource(&dev->dev, regs);
	if (IS_ERR(host->regs))
		return PTR_ERR(host->regs);

Though that function will only be available in 3.9-rc1.

> +	err = host1x_syncpt_init(host);
> +	if (err)
> +		return err;
[...]
> +	host1x_syncpt_reset(host);

Why separate host1x_syncpt_reset() from host1x_syncpt_init()? I see why
it might be useful to have host1x_syncpt_reset() as a separate function
but couldn't it be called as part of host1x_syncpt_init()?

> +	dev_info(&dev->dev, "initialized\n");

I don't think this is very useful. We should make sure to tell people
when things fail. When everything goes as planned we don't need to brag
about it =)

> diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
[...]
> +struct host1x_syncpt_ops {
[...]
> +	const char * (*name)(struct host1x_syncpt *);

Why do we need this? Could we not refer to the syncpt name directly
instead of going through this wrapper? I'd expect the name to be static.

> +struct host1x_device_info {

Maybe this should be called simply host1x_info? _device seems redundant.

> +	int	nb_channels;		/* host1x: num channels supported */
> +	int	nb_pts;			/* host1x: num syncpoints supported */
> +	int	nb_bases;		/* host1x: num syncpoints supported */
> +	int	nb_mlocks;		/* host1x: number of mlocks */
> +	int	(*init)(struct host1x *); /* initialize per SoC ops */
> +	int	sync_offset;
> +};

While this isn't public API, maybe it would still be useful to turn the
comments into proper kerneldoc? That's what people are used to.

> +struct host1x {
> +	void __iomem *regs;
> +	struct host1x_syncpt *syncpt;
> +	struct platform_device *dev;
> +	struct host1x_device_info info;
> +	struct clk *clk;
> +
> +	struct host1x_syncpt_ops syncpt_op;

Maybe make this a struct host1x_syncpt_ops * instead so you don't have
separate copies? While at it, maybe this should be const as well.

> +	struct dentry *debugfs;

This doesn't seem to be used anywhere.

> +static inline
> +struct host1x *host1x_get_host(struct platform_device *_dev)
> +{
> +	struct platform_device *pdev;
> +
> +	if (_dev->dev.parent) {
> +		pdev = to_platform_device(_dev->dev.parent);
> +		return platform_get_drvdata(pdev);
> +	} else
> +		return platform_get_drvdata(_dev);
> +}

There is a lot of needless casting in here. Why not pass in a struct
device * and use dev_get_drvdata() instead?

> diff --git a/drivers/gpu/host1x/hw/host1x01.c b/drivers/gpu/host1x/hw/host1x01.c
[...]
> +#include "hw/host1x01.h"
> +#include "dev.h"
> +#include "hw/host1x01_hardware.h"

The ordering here looks funny.

> +#include "hw/syncpt_hw.c"

Why include the source file here? Can't you compile it separately
instead?

> diff --git a/drivers/gpu/host1x/hw/host1x01.h b/drivers/gpu/host1x/hw/host1x01.h
[...]
> +int host1x01_init(struct host1x *);

For completeness you should probably name the parameter, even if this is
a prototype.

> diff --git a/drivers/gpu/host1x/hw/host1x01_hardware.h b/drivers/gpu/host1x/hw/host1x01_hardware.h
[...]
> +#include <linux/types.h>
> +#include <linux/bitops.h>
> +#include "hw_host1x01_sync.h"

Again, a blank line might help between the above two. I also assume that
this file will be filled with more content later on, so I guess it's not
worth the trouble to postpone it's creation until a later point.

> diff --git a/drivers/gpu/host1x/hw/hw_host1x01_sync.h b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
[...]
> +static inline u32 host1x_sync_syncpt_0_r(void)
> +{
> +	return 0x400;
> +}
> +#define HOST1X_SYNC_SYNCPT_0 \
> +	host1x_sync_syncpt_0_r()
> +static inline u32 host1x_sync_syncpt_base_0_r(void)
> +{
> +	return 0x600;
> +}
> +#define HOST1X_SYNC_SYNCPT_BASE_0 \
> +	host1x_sync_syncpt_base_0_r()
> +static inline u32 host1x_sync_syncpt_cpu_incr_r(void)
> +{
> +	return 0x700;
> +}

Perhaps it would be useful to modify these to take the syncpt ID as a
parameter? That way you don't have to remember to do the multiplication
everytime you access the register?

> diff --git a/drivers/gpu/host1x/hw/syncpt_hw.c b/drivers/gpu/host1x/hw/syncpt_hw.c
[...]
> +/*
> + * Updates the last value read from hardware.
> + * (was host1x_syncpt_load_min)

Can the comment in () not be dropped? Given that this is new code nobody
would know about the old name.

> + */
> +static u32 syncpt_load_min(struct host1x_syncpt *sp)
> +{
> +	struct host1x *dev = sp->dev;
> +	u32 old, live;
> +
> +	do {
> +		old = host1x_syncpt_read_min(sp);
> +		live = host1x_sync_readl(dev,
> +				HOST1X_SYNC_SYNCPT_0 + sp->id * 4);
> +	} while ((u32)atomic_cmpxchg(&sp->min_val, old, live) != old);

I think this warrants a comment.

> +	if (!host1x_syncpt_check_max(sp, live))
> +		dev_err(&dev->dev->dev,
> +				"%s failed: id=%u, min=%d, max=%d\n",
> +				__func__,
> +				sp->id,
> +				host1x_syncpt_read_min(sp),
> +				host1x_syncpt_read_max(sp));

You could probably make this fit into less lines.

> +/*
> + * Write a cpu syncpoint increment to the hardware, without touching
> + * the cache. Caller is responsible for host being powered.
> + */

The last part of this comment applies to every host1x function, right?
So maybe it should just be dropped.

> +static void syncpt_debug(struct host1x_syncpt *sp)
> +{
> +	u32 i;
> +	for (i = 0; i < host1x_syncpt_nb_pts(sp->dev); i++) {
> +		u32 max = host1x_syncpt_read_max(sp);
> +		u32 min = host1x_syncpt_load_min(sp);
> +		if (!max && !min)
> +			continue;
> +		dev_info(&sp->dev->dev->dev,
> +			"id %d (%s) min %d max %d\n",
> +			i, sp->name,
> +			min, max);
> +
> +	}

There's a gratuitous blank line above.

> +
> +	for (i = 0; i < host1x_syncpt_nb_bases(sp->dev); i++) {
> +		u32 base_val;
> +		host1x_syncpt_read_wait_base(sp);
> +		base_val = sp->base_val;
> +		if (base_val)
> +			dev_info(&sp->dev->dev->dev,
> +					"waitbase id %d val %d\n",
> +					i, base_val);
> +
> +	}

And another one.

> diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
[...]
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/stat.h>

I don't think this is needed.

> +#include <linux/module.h>
> +#include "syncpt.h"
> +#include "dev.h"
> +#include <trace/events/host1x.h>

Again, some more spacing would be nice here. And the ordering is a bit
weird. Maybe put the trace include above syncpt.h and dev.h?

> +#define MAX_SYNCPT_LENGTH	5

This doesn't seem to be used anywhere.

> +static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
> +		struct platform_device *pdev,
> +		int client_managed);

Can't you move the actual implementation here? Also I'm not sure if
passing the platform_device is the best choice here. struct device
should work just as well.

> +/*
> + * Resets syncpoint and waitbase values to sw shadows
> + */
> +void host1x_syncpt_reset(struct host1x *dev)

Maybe host1x_syncpt_flush() would be a better name given the above
description? Reset does have this hardware reset connotation so my first
intuition had been that this would reset the syncpt value to 0.

If you decide to change the name, make sure to change it in the syncpt
ops as well.

> +/*
> + * Updates sw shadow state for client managed registers
> + */
> +void host1x_syncpt_save(struct host1x *dev)
> +{
> +	struct host1x_syncpt *sp_base = dev->syncpt;
> +	u32 i;
> +
> +	for (i = 0; i < host1x_syncpt_nb_pts(dev); i++) {
> +		if (host1x_syncpt_client_managed(sp_base + i))
> +			dev->syncpt_op.load_min(sp_base + i);
> +		else
> +			WARN_ON(!host1x_syncpt_min_eq_max(sp_base + i));
> +	}
> +
> +	for (i = 0; i < host1x_syncpt_nb_bases(dev); i++)
> +		dev->syncpt_op.read_wait_base(sp_base + i);
> +}

A similar comment applies here. Though I'm not so sure about a better
name. Perhaps host1x_syncpt_sync()?

I know that this must sound all pretty straightforward to you, but for
somebody who hasn't used these functions at all the names are quite
confusing. So instead of people to go read the documentation I tend to
think that making the names as descriptive as possible is essential
here.

> +/*
> + * Updates the last value read from hardware.
> + */
> +u32 host1x_syncpt_load_min(struct host1x_syncpt *sp)
> +{
> +	u32 val;
> +	val = sp->dev->syncpt_op.load_min(sp);
> +	trace_host1x_syncpt_load_min(sp->id, val);
> +
> +	return val;
> +}

I don't know I understand what this means exactly. Does it read the
value that hardware last incremented? Perhaps this will become clearer
when you add a comment to the syncpt_load_min() implementation.

> +int host1x_syncpt_init(struct host1x *host)
> +{
> +	struct host1x_syncpt *syncpt, *sp;
> +	int i;
> +
> +	syncpt = sp = devm_kzalloc(&host->dev->dev,
> +			sizeof(struct host1x_syncpt) * host->info.nb_pts,

You can make this a bit shorter by using sizeof(*sp) instead.

> +	for (i = 0; i < host->info.nb_pts; ++i, ++sp) {
> +		sp->id = i;
> +		sp->dev = host;

Perhaps:

	syncpt[i].id = i;
	syncpt[i].dev = host;

To avoid the need to explicitly keep track of sp?

> +static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
> +		struct platform_device *pdev,
> +		int client_managed)
> +{
> +	int i;
> +	struct host1x_syncpt *sp = host->syncpt;
> +	char *name;
> +
> +	for (i = 0; i < host->info.nb_pts && sp->name; i++, sp++)
> +		;
> +	if (sp->pdev)
> +		return NULL;
> +
> +	name = kasprintf(GFP_KERNEL, "%02d-%s", sp->id,
> +			pdev ? dev_name(&pdev->dev) : NULL);
> +	if (!name)
> +		return NULL;
> +
> +	sp->pdev = pdev;
> +	sp->name = name;
> +	sp->client_managed = client_managed;
> +
> +	return sp;
> +}
> +
> +struct host1x_syncpt *host1x_syncpt_alloc(struct platform_device *pdev,
> +		int client_managed)
> +{
> +	struct host1x *host = host1x_get_host(pdev);
> +	return _host1x_syncpt_alloc(host, pdev, client_managed);
> +}

I think it's enough to keep track of the struct device here instead of
the struct platform_device.

Also the syncpoint is not actually allocated here, so maybe
host1x_syncpt_request() would be a better name. As a nice side-effect it
makes the naming more similar to the IRQ API and might be easier to work
with.

> +struct host1x_syncpt *host1x_syncpt_get(struct host1x *dev, u32 id)
> +{
> +	return dev->syncpt + id;
> +}

Should this perhaps do some error checking. What if the specified syncpt
hasn't actually been requested before?

> diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
[...]
> +struct host1x_syncpt {
> +	int id;
> +	atomic_t min_val;
> +	atomic_t max_val;
> +	u32 base_val;
> +	const char *name;
> +	int client_managed;

Is this field actually ever used? Looking through the patches none of
the clients actually set this.

> +/*
> + * Returns true if syncpoint min == max, which means that there are no
> + * outstanding operations.
> + */
> +static inline bool host1x_syncpt_min_eq_max(struct host1x_syncpt *sp)
> +{
> +	int min, max;
> +	smp_rmb();
> +	min = atomic_read(&sp->min_val);
> +	max = atomic_read(&sp->max_val);
> +	return (min == max);
> +}

Maybe call this host1x_syncpt_idle() or something similar instead?

> +{
> +	return sp->id != NVSYNCPT_INVALID &&
> +		sp->id < host1x_syncpt_nb_pts(sp->dev);
> +}

Is there really a need for NVSYNCPT_INVALID? Even if you want to keep
the special case you can drop the explicit check because -1 will be
larger than host1x_syncpt_nb_pts() anyway.

Thierry

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRD3rVAAoJEN0jrNd/PrOhkikQAKpF7zOifNYubfpTYRBKTxYk
tV++HR3yTddjVhRP98kNtxVUpm+9yV5m5S917hb9TMM5NdstZ02Y077MCNsoseUT
zFf00aLuGGf5ajpVZe63TuAiuQ3Pp65VM2+ru0SUt05L0E0rmeIA/UUifSujHpcT
GrcSsN8hIQmOblulGsKT0+wn7DrKGrtlojYxfV9fMeH8HMnGwbG46OYy+8G+PRJk
gkLBLUG6qfuSI+XJbKmEzA9CSI9JwzHb1q05O73B3ew2M0N5LjInArEBV3fUNmCV
riWWgBHJZ2d25jSenq/rNldanqZYFl0DcDNjQ70CfyKn4yUwVMufGBLNOk04GfYR
xo3jHufpJ6nOmky9yInFcEDHlvpNluD52xFbF/GFT+TSMy/GnP3NQBKmhIM+cfRK
80WI399nzb0SvVyR/E+SWUf5+tkvAHFv7KmSH0jNcc2XDALEDOMvIYsio2vs7s4T
Ry1qFTbdL0WE+A8YX71ebTiN/Cz5pIJnOVtENF6/AcZ+Y9UilbMQTmLHTTCaipcu
hVSvSMu6OQgCnaViMcd3HQ4SXm0ZWz5jyR0QGDdK3LaSg8z3ML08FO+SR2bhgJIx
7O5crgrXGEER3bvmAzBrNkiYu4EJUcwk5Z2ANWXRd9Vr3OrMK9c0s2KmmJi6ZxZs
D567yw7rjUSIIb4iCqbY
=l+Bo
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
