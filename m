Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3BDKan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:30:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54274 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3BDKal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:30:41 -0500
Date: Mon, 4 Feb 2013 11:30:32 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: amerilainen@nvidia.com, airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5,RESEND 2/8] gpu: host1x: Add syncpoint wait and
 interrupts
Message-ID: <20130204103032.GB27443@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-3-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <1358250244-9678-3-git-send-email-tbergstrom@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:QXj3y76UVtiCmfKv8WdYXv125vn1id2HYIrL8isn2K/
 x+4D9LYAmIQFRfDXjRSSE6ncV0ZIbkymwDgMma4me/ctQdb5Wl
 AVL3I3mOpMOnqp4md1pvEAmHd0j+7/fhSyY+ewViuiQPuiSAlZ
 kAmYvy5AHaCkoA585e0kdlINzyUE/MhQeEupW7c4WmW1fMP9f5
 l4YywFqWNeB9Ka9vzyW+1FpfJL1fNO3UTqxC11h3jWrk41Wz9F
 wQgbj7aXLEl54mxCxGJqGUUgfT90BcjlRf3JWwkeGnzPOVEa+2
 oDl6pvSB03nXx7SDcFd6F7pPxjvP14gMJJisUK6quh3ibENNMk
 F9tvqazYGTiytnftwpFMPKKoA0y9E+PQXE+cdYImWZ6cbhGZI3
 lULWs2SM69i56uBOUS4mphLKuwSdkDF95jW6rL5xgzukK1bsTe
 JSb9V
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 15, 2013 at 01:43:58PM +0200, Terje Bergstrom wrote:
[...]
> diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
[...]
> @@ -95,7 +96,6 @@ static int host1x_probe(struct platform_device *dev)
> =20
>  	/* set common host1x device data */
>  	platform_set_drvdata(dev, host);
> -
>  	host->regs =3D devm_request_and_ioremap(&dev->dev, regs);
>  	if (!host->regs) {
>  		dev_err(&dev->dev, "failed to remap host registers\n");

This seems an unrelated (and actually undesirable) change.

> @@ -109,28 +109,40 @@ static int host1x_probe(struct platform_device *dev)
>  	}
> =20
>  	err =3D host1x_syncpt_init(host);
> -	if (err)
> +	if (err) {
> +		dev_err(&dev->dev, "failed to init sync points");
>  		return err;
> +	}

This error message should probably have gone in the previous patch as
well.

> diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
> index d8f5979..8376092 100644
> --- a/drivers/gpu/host1x/dev.h
> +++ b/drivers/gpu/host1x/dev.h
> @@ -17,11 +17,12 @@
>  #ifndef HOST1X_DEV_H
>  #define HOST1X_DEV_H
> =20
> +#include <linux/platform_device.h>
>  #include "syncpt.h"
> +#include "intr.h"
> =20
>  struct host1x;
>  struct host1x_syncpt;
> -struct platform_device;

Why include platform_device.h here?

> @@ -34,6 +35,18 @@ struct host1x_syncpt_ops {
>  	const char * (*name)(struct host1x_syncpt *);
>  };
> =20
> +struct host1x_intr_ops {
> +	void (*init_host_sync)(struct host1x_intr *);
> +	void (*set_host_clocks_per_usec)(
> +		struct host1x_intr *, u32 clocks);

Could the above two not be combined? The only reason to keep them
separate would be if the host1x clock was dynamically changed, but I
don't think we support that, right?

> +	void (*set_syncpt_threshold)(
> +		struct host1x_intr *, u32 id, u32 thresh);
> +	void (*enable_syncpt_intr)(struct host1x_intr *, u32 id);
> +	void (*disable_syncpt_intr)(struct host1x_intr *, u32 id);
> +	void (*disable_all_syncpt_intrs)(struct host1x_intr *);

Can disable_all_syncpt_intrs() not be implemented generically using the
number of syncpoints as exposed by host1x_device_info and the
=2Edisable_syncpt_intr() function?

> @@ -46,11 +59,13 @@ struct host1x_device_info {
>  struct host1x {
>  	void __iomem *regs;
>  	struct host1x_syncpt *syncpt;
> +	struct host1x_intr intr;
>  	struct platform_device *dev;
>  	struct host1x_device_info info;
>  	struct clk *clk;
> =20
>  	struct host1x_syncpt_ops syncpt_op;
> +	struct host1x_intr_ops intr_op;

I think carrying a const pointer to the interrupt operations structure
is a better option here.

> diff --git a/drivers/gpu/host1x/hw/intr_hw.c b/drivers/gpu/host1x/hw/intr=
_hw.c
[...]
> +static void host1x_intr_syncpt_thresh_isr(struct host1x_intr_syncpt *syn=
cpt);

Can we avoid this forward declaration?

> +static void syncpt_thresh_cascade_fn(struct work_struct *work)

syncpt_thresh_work()?

> +{
> +	struct host1x_intr_syncpt *sp =3D
> +		container_of(work, struct host1x_intr_syncpt, work);
> +	host1x_syncpt_thresh_fn(sp);

Couldn't we inline the host1x_syncpt_thresh_fn() implementation here?
Why do we need to go through an external function declaration?

> +static irqreturn_t syncpt_thresh_cascade_isr(int irq, void *dev_id)
> +{
> +	struct host1x *host1x =3D dev_id;
> +	struct host1x_intr *intr =3D &host1x->intr;
> +	unsigned long reg;
> +	int i, id;
> +
> +	for (i =3D 0; i < host1x->info.nb_pts / BITS_PER_LONG; i++) {
> +		reg =3D host1x_sync_readl(host1x,
> +				HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATUS +
> +				i * REGISTER_STRIDE);
> +		for_each_set_bit(id, &reg, BITS_PER_LONG) {
> +			struct host1x_intr_syncpt *sp =3D
> +				intr->syncpt + (i * BITS_PER_LONG + id);
> +			host1x_intr_syncpt_thresh_isr(sp);

Have you considered mimicking the IRQ API and name this something like
host1x_intr_syncpt_thresh_handle() and name the actual ISR just
syncpt_thresh_isr()? Not so important but it makes things a bit clearer
in my opinion.

> +			queue_work(intr->wq, &sp->work);

Should the call to queue_work() perhaps be moved into
host1x_intr_syncpt_thresh_isr().

> +static void host1x_intr_init_host_sync(struct host1x_intr *intr)
> +{
> +	struct host1x *host1x =3D intr_to_host1x(intr);
> +	int i, err;
> +
> +	host1x_sync_writel(host1x, 0xffffffffUL,
> +		HOST1X_SYNC_SYNCPT_THRESH_INT_DISABLE);
> +	host1x_sync_writel(host1x, 0xffffffffUL,
> +		HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATUS);
> +
> +	for (i =3D 0; i < host1x->info.nb_pts; i++)
> +		INIT_WORK(&intr->syncpt[i].work, syncpt_thresh_cascade_fn);
> +
> +	err =3D devm_request_irq(&host1x->dev->dev, intr->syncpt_irq,
> +				syncpt_thresh_cascade_isr,
> +				IRQF_SHARED, "host1x_syncpt", host1x);
> +	WARN_ON(IS_ERR_VALUE(err));

Do we really want to continue in this case?

> +static void host1x_intr_set_syncpt_threshold(struct host1x_intr *intr,
> +	u32 id, u32 thresh)
> +{
> +	struct host1x *host1x =3D intr_to_host1x(intr);
> +	host1x_sync_writel(host1x, thresh,
> +		HOST1X_SYNC_SYNCPT_INT_THRESH_0 + id * REGISTER_STRIDE);
> +}

Again, maybe defining the register stride as part of the register
definition might be better. I think HOST1X_SYNC_SYNCPT_INT_THRESH(id) is
easier to read.

> +static void host1x_intr_enable_syncpt_intr(struct host1x_intr *intr, u32=
 id)
> +{
> +	struct host1x *host1x =3D intr_to_host1x(intr);
> +
> +	host1x_sync_writel(host1x, BIT_MASK(id),
> +			HOST1X_SYNC_SYNCPT_THRESH_INT_ENABLE_CPU0 +
> +			BIT_WORD(id) * REGISTER_STRIDE);
> +}

Same here.

> +static void host1x_intr_disable_syncpt_intr(struct host1x_intr *intr, u3=
2 id)
> +{
> +	struct host1x *host1x =3D intr_to_host1x(intr);
> +
> +	host1x_sync_writel(host1x, BIT_MASK(id),
> +			HOST1X_SYNC_SYNCPT_THRESH_INT_DISABLE +
> +			BIT_WORD(id) * REGISTER_STRIDE);
> +
> +	host1x_sync_writel(host1x, BIT_MASK(id),
> +		HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATUS +
> +		BIT_WORD(id) * REGISTER_STRIDE);
> +}

And here.

> diff --git a/drivers/gpu/host1x/intr.c b/drivers/gpu/host1x/intr.c
[...]
> +#include "intr.h"
> +#include <linux/interrupt.h>
> +#include <linux/slab.h>
> +#include <linux/irq.h>
> +#include "dev.h"

More funky ordering of includes.

> +int host1x_intr_add_action(struct host1x_intr *intr, u32 id, u32 thresh,
> +			enum host1x_intr_action action, void *data,
> +			void *_waiter,
> +			void **ref)

Why do you pass in _waiter as void * and not struct host1x_waitlist *?

I think I've said this before. The interface doesn't seem optimal to me
here. Passing in an enumeration to choose which action to perform looks
difficult to work with (not to mention the symbols are rather long and
therefore result in ugly code).

Maybe doing this by passing around a pointer to a handler function would
be nicer. However since I haven't really used this yet, I can't really
tell. So maybe we should just merge the implementation as-is for now. We
can always clean it up later.

> +void *host1x_intr_alloc_waiter(void)
> +{
> +	return kzalloc(sizeof(struct host1x_waitlist), GFP_KERNEL);
> +}

I'm not sure why this is separate from host1x_syncpt_wait() since it is
only used inside that function and the waiter returned never leaves the
scope of that function, so it might be better to allocate it directly
in host1x_syncpt_wait() instead.

Actually, it looks like the waiter doesn't ever leave scope, so you may
even want to allocate it on the stack.

> +void host1x_intr_put_ref(struct host1x_intr *intr, u32 id, void *ref)

Here again, you pass in the waiter via a void *. Why's that?

> +int host1x_intr_init(struct host1x_intr *intr, u32 irq_sync)

Maybe you should keep the type of the irq_sync here so that it properly
propagates to the call to devm_request_irq().

> +{
> +	unsigned int id;
> +	struct host1x *host1x =3D intr_to_host1x(intr);
> +	u32 nb_pts =3D host1x_syncpt_nb_pts(host1x);
> +
> +	intr->syncpt =3D devm_kzalloc(&host1x->dev->dev,
> +			sizeof(struct host1x_intr_syncpt) *
> +			host1x->info.nb_pts,
> +			GFP_KERNEL);
> +
> +	if (!host1x->intr.syncpt)

The above blank line isn't necessary.

> +void host1x_intr_stop(struct host1x_intr *intr)
> +{
> +	unsigned int id;
> +	struct host1x *host1x =3D intr_to_host1x(intr);
> +	struct host1x_intr_syncpt *syncpt;
> +	u32 nb_pts =3D host1x_syncpt_nb_pts(intr_to_host1x(intr));
> +
> +	mutex_lock(&intr->mutex);
> +
> +	host1x->intr_op.disable_all_syncpt_intrs(intr);

I haven't commented on this everywhere, but I think this could benefit
=66rom a wrapper that forwards this to the intr_op. The same goes for the
sync_op.

> +	for (id =3D 0, syncpt =3D intr->syncpt;
> +	     id < nb_pts;
> +	     ++id, ++syncpt) {

I don't think you need to explicitly keep track of syncpt within the for
statement. Instead you could either index intr->syncpt directly or
obtain a reference within the loop. It allows the for statement to be
written much more canonically.

> diff --git a/drivers/gpu/host1x/intr.h b/drivers/gpu/host1x/intr.h
[...]
> +#define intr_syncpt_to_intr(is) (is->intr)

This one doesn't buy you anything. It actually uses up more characters
so you can just drop it.

> diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
[...]
> @@ -119,6 +122,166 @@ void host1x_syncpt_incr(struct host1x_syncpt *sp)
>  	host1x_syncpt_cpu_incr(sp);
>  }
> =20
> +/*
> + * Updated sync point form hardware, and returns true if syncpoint is ex=
pired,
> + * false if we may need to wait
> + */
> +static bool syncpt_load_min_is_expired(
> +	struct host1x_syncpt *sp,
> +	u32 thresh)

This can all go on one line.

> +/*
> + * Main entrypoint for syncpoint value waits.
> + */
> +int host1x_syncpt_wait(struct host1x_syncpt *sp,
> +			u32 thresh, long timeout, u32 *value)
> +{
[...]
> +}
> +EXPORT_SYMBOL(host1x_syncpt_wait);

This doesn't only seem to be the main entrypoint, but it's basically the
only way to currently wait for syncpoints. One actual use-case where
this might turn out to be a problem is video capturing. The problem is
that using this API you can't very well asynchronously capture frames.
So eventually I think we need a way to allow a generic handler to be
attached to syncpoints so that you can have this handler continuously
invoked after each frame is captured and just pass the buffer back to
userspace.

> +bool host1x_syncpt_is_expired(
> +	struct host1x_syncpt *sp,
> +	u32 thresh)

This can go on one line.

Thierry

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIbBAEBAgAGBQJRD43IAAoJEN0jrNd/PrOhJZYP8wcNBfwFYPzzfKuhGGk1N6Ac
xzFd56BllShUwcA/SSynKga5f5MFpjseHxr7KtBD8Cdw5fQDDn8g/ux8nMO2tu7y
7fbbIqVypEH9ohWAXZD5v3xh114b9WGzR0z4ln4KVMm0dmTRLlzftDoNAK8fOUvZ
s7kDw9PvxcbSD8YKGFFWXf95mjZbY1vuwx+224J3FvkKh0/bTZ21vhwtnl2mE8XE
WAp1rVBi73Gvg23gwF8frrlKjVXMwRvgo3KiS+NKYQd43u8zhZ0aiykTfqpc833m
dS1upD5inasdLqiG00V+VMc1dq5aQVdRNkEL7oWZajAzJgn1U3G26gBpF+mR3QQN
cCJBWA1rmQ8+25FxPdL5p97GqGz2KOm+3LSh0DNuSSMm4UvUyC5H6Pc64y05DcOX
/nUvs0grWQSJPPQhesIzA4YWJ1n2TUQ6YlISoPh8infwK+RpKISV1N8MYLz2L/04
md1a9Asw9NdptdBGu8hi4CLlJ27SmKJADR7p3wWVqL3mzIuybjwVdr/17ftPL8/z
F21dFI0lTmhaAw92lOpqJ7fhtGFxaNYbETv0mkronutvyljqSkTQUCkDSc4y9uOu
8IenrG94j6JF+HZ6PuCSL6roriX1vuFFhMWPrlplsveeFG+GlO98lGzFNdD6Uwrk
AAA5JkVyGEP8YOfwQiQ=
=gLjv
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
