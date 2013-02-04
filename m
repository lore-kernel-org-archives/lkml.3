Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3BDM41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:56:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64233 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3BDM40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:56:26 -0500
Date: Mon, 4 Feb 2013 13:56:18 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: amerilainen@nvidia.com, airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5,RESEND 8/8] drm: tegra: Add gr2d device
Message-ID: <20130204125618.GD595@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-9-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wULyF7TL5taEdwHz"
Content-Disposition: inline
In-Reply-To: <1358250244-9678-9-git-send-email-tbergstrom@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:xVa20y78je4rAFfwZSW0eZZNdfSmkO3qaMqYD5DPzaq
 Z/vBcyVeTrr8OpMBJlUkmG4P43vJS36Z6JR4j/8r09y/tz4akg
 gW2g7PwjdT71VG/+DEdG7yZ7e04sXtEUMCY2/nGQ8jalE1S3hC
 GcD4OuPSpdPog+o/zteDUh5FaDDY6xdF858zZlxbezbwf5Fukc
 DNi5MLi46rZDC7kYU2Wn8hvNN/NypzxB4VgJeyPYpMDRO1hibU
 jBMp1PS4aQfXngnF7/QBMkZWPdeaPY/DV+fshCXnBusbLn8Lxx
 Lpogbo6wOdAnCaS2mpcMGeCJCC5KWfyJZE9ChYBLz6NUWkvZ7D
 In3oDDy0MH63gpb3SgCESICLCv/Ngixvj+w5nUAZzzuj/wlw91
 iVK1ez+/wRQJk/+63qq+0lvp3sl36efOnI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wULyF7TL5taEdwHz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 15, 2013 at 01:44:04PM +0200, Terje Bergstrom wrote:
[...]
> diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
> @@ -270,7 +274,29 @@ static int tegra_drm_unload(struct drm_device *drm)
> =20
>  static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
>  {
> -	return 0;
> +	struct host1x_drm_fpriv *fpriv;
> +	int err =3D 0;

Can be dropped.

> +
> +	fpriv =3D kzalloc(sizeof(*fpriv), GFP_KERNEL);
> +	if (!fpriv)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&fpriv->contexts);
> +	filp->driver_priv =3D fpriv;
> +
> +	return err;

return 0;

> +static void tegra_drm_close(struct drm_device *drm, struct drm_file *fil=
p)
> +{
> +	struct host1x_drm_fpriv *fpriv =3D host1x_drm_fpriv(filp);
> +	struct host1x_drm_context *context, *tmp;
> +
> +	list_for_each_entry_safe(context, tmp, &fpriv->contexts, list) {
> +		context->client->ops->close_channel(context);
> +		kfree(context);
> +	}
> +	kfree(fpriv);
>  }

Maybe you should add host1x_drm_context_free() to wrap the loop
contents?

> @@ -280,7 +306,204 @@ static void tegra_drm_lastclose(struct drm_device *=
drm)
>  	drm_fbdev_cma_restore_mode(host1x->fbdev);
>  }
> =20
> +static int
> +tegra_drm_ioctl_syncpt_read(struct drm_device *drm, void *data,
> +			 struct drm_file *file_priv)

static int and function name on one line, please.

> +{
> +	struct host1x *host1x =3D drm->dev_private;
> +	struct tegra_drm_syncpt_read_args *args =3D data;
> +	struct host1x_syncpt *sp =3D
> +		host1x_syncpt_get_bydev(host1x->dev, args->id);

I don't know if we need this, except maybe to work around the problem
that we have two different structures named host1x. The _bydev() suffix
is misleading because all you really do here is obtain the syncpt from
the host1x.

> +static int
> +tegra_drm_ioctl_open_channel(struct drm_device *drm, void *data,
> +			 struct drm_file *file_priv)
> +{
> +	struct tegra_drm_open_channel_args *args =3D data;
> +	struct host1x_client *client;
> +	struct host1x_drm_context *context;
> +	struct host1x_drm_fpriv *fpriv =3D host1x_drm_fpriv(file_priv);
> +	struct host1x *host1x =3D drm->dev_private;
> +	int err =3D 0;

err =3D -ENODEV; (see below)

> +
> +	context =3D kzalloc(sizeof(*context), GFP_KERNEL);
> +	if (!context)
> +		return -ENOMEM;
> +
> +	list_for_each_entry(client, &host1x->clients, list) {
> +		if (client->class =3D=3D args->class) {
> +			context->client =3D client;
> +			err =3D client->ops->open_channel(client, context);
> +			if (err)
> +				goto out;
> +
> +			list_add(&context->list, &fpriv->contexts);
> +			args->context =3D (uintptr_t)context;

Perhaps cast this to __u64 directly instead? There's little sense in
taking the detour via uintptr_t.

> +			goto out;

return 0;

> +		}
> +	}
> +	err =3D -ENODEV;
> +
> +out:
> +	if (err)
> +		kfree(context);
> +
> +	return err;
> +}

Then this simply becomes:

	kfree(context);
	return err;

> +static int
> +tegra_drm_ioctl_close_channel(struct drm_device *drm, void *data,
> +			 struct drm_file *file_priv)
> +{
> +	struct tegra_drm_open_channel_args *args =3D data;
> +	struct host1x_drm_context *context, *tmp;
> +	struct host1x_drm_fpriv *fpriv =3D host1x_drm_fpriv(file_priv);
> +	int err =3D 0;
> +
> +	list_for_each_entry_safe(context, tmp, &fpriv->contexts, list) {
> +		if ((uintptr_t)context =3D=3D args->context) {
> +			context->client->ops->close_channel(context);
> +			list_del(&context->list);
> +			kfree(context);
> +			goto out;
> +		}
> +	}
> +	err =3D -EINVAL;
> +
> +out:
> +	return err;
> +}

Same comments as for tegra_drm_ioctl_open_channel().

> +static int
> +tegra_drm_ioctl_get_syncpoint(struct drm_device *drm, void *data,
> +			 struct drm_file *file_priv)
> +{
> +	struct tegra_drm_get_channel_param_args *args =3D data;
> +	struct host1x_drm_context *context;
> +	struct host1x_drm_fpriv *fpriv =3D host1x_drm_fpriv(file_priv);
> +	int err =3D 0;
> +
> +	list_for_each_entry(context, &fpriv->contexts, list) {
> +		if ((uintptr_t)context =3D=3D args->context) {
> +			args->value =3D
> +				context->client->ops->get_syncpoint(context,
> +						args->param);
> +			goto out;
> +		}
> +	}
> +	err =3D -ENODEV;
> +
> +out:
> +	return err;
> +}

Same comments as well. Also you may want to factor out the context
lookup into a separate function so you don't have to repeat the same
code over and over again.

I wonder if we shouldn't remove .get_syncpoint() from the client ops and
replace it by a simple array instead. The only use-case for this is if a
client wants more than a single syncpoint, right? In that case just keep
an array of syncpoints and the number of syncpoints per client.
Otherwise each client will have to rewrite the same function.

Also, how useful is it to create a context? Looking at the gr2d
implementation for .open_channel(), it will return the same channel to
whichever userspace process requests them. Can you explain why it is
necessary at all? From the name I would have expected some kind of
context switching to take place when different applications submit
requests to the same client, but that doesn't seem to be the case.

> +static int
> +tegra_drm_create_ioctl(struct drm_device *drm, void *data,
> +			 struct drm_file *file_priv)

tegra_drm_gem_create_ioctl() please.

>  static struct drm_ioctl_desc tegra_drm_ioctls[] =3D {
> +	DRM_IOCTL_DEF_DRV(TEGRA_GEM_CREATE,
> +			tegra_drm_create_ioctl, DRM_UNLOCKED | DRM_AUTH),

TEGRA_DRM_GEM_CREATE

>  static const struct file_operations tegra_drm_fops =3D {
> @@ -303,6 +526,7 @@ struct drm_driver tegra_drm_driver =3D {
>  	.load =3D tegra_drm_load,
>  	.unload =3D tegra_drm_unload,
>  	.open =3D tegra_drm_open,
> +	.preclose =3D tegra_drm_close,

I think it'd make sense to name the function tegra_drm_preclose() to
match the name in struct drm_driver.

> diff --git a/drivers/gpu/host1x/drm/drm.h b/drivers/gpu/host1x/drm/drm.h
[...]
> +struct host1x_drm_fpriv {
> +	struct list_head contexts;
>  };

Maybe name this host1x_drm_file. fpriv isn't very specific.

> +static inline struct host1x_drm_fpriv *
> +host1x_drm_fpriv(struct drm_file *file_priv)
> +{
> +	return file_priv ? file_priv->driver_priv : NULL;
> +}

I think it's fine to just directly do filp->driver_priv instead of going
through this wrapper.

>  struct host1x_client {
>  	struct host1x *host1x;
>  	struct device *dev;
> =20
>  	const struct host1x_client_ops *ops;
> =20
> +	u32 class;

Should this perhaps be an enum?

> diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
[...]
> +static u32 gr2d_get_syncpoint(struct host1x_drm_context *context, int in=
dex)
> +{
> +	struct gr2d *gr2d =3D dev_get_drvdata(context->client->dev);
> +	if (index !=3D 0)
> +		return UINT_MAX;
> +
> +	return host1x_syncpt_id(gr2d->syncpt);
> +}

Maybe get_syncpoint() should return int and negative error codes on
failure. That still leaves room for 2^31 possible syncpoints.

> +static u32 handle_cma_to_host1x(struct drm_device *drm,
> +				struct drm_file *file_priv, u32 gem_handle)
> +{
> +	struct drm_gem_object *obj;
> +	struct drm_gem_cma_object *cma_obj;
> +	u32 host1x_handle;
> +
> +	obj =3D drm_gem_object_lookup(drm, file_priv, gem_handle);
> +	if (!obj)
> +		return 0;
> +
> +	cma_obj =3D to_drm_gem_cma_obj(obj);
> +	host1x_handle =3D host1x_memmgr_host1x_id(mem_mgr_type_cma, (u32)cma_ob=
j);
> +	drm_gem_object_unreference(obj);
> +
> +	return host1x_handle;
> +}

I though we had settled in previous reviews on only having a single
allocator and not do the conversion between various types?

> +static int gr2d_submit(struct host1x_drm_context *context,
> +		struct tegra_drm_submit_args *args,
> +		struct drm_device *drm,
> +		struct drm_file *file_priv)
> +{
> +	struct host1x_job *job;
> +	int num_cmdbufs =3D args->num_cmdbufs;
> +	int num_relocs =3D args->num_relocs;
> +	int num_waitchks =3D args->num_waitchks;
> +	struct tegra_drm_cmdbuf __user *cmdbufs =3D
> +		(void * __user)(uintptr_t)args->cmdbufs;
> +	struct tegra_drm_reloc __user *relocs =3D
> +		(void * __user)(uintptr_t)args->relocs;
> +	struct tegra_drm_waitchk __user *waitchks =3D
> +		(void * __user)(uintptr_t)args->waitchks;

No need for all the uintptr_t casts.

> +	struct tegra_drm_syncpt_incr syncpt_incr;
> +	int err;
> +
> +	/* We don't yet support other than one syncpt_incr struct per submit */
> +	if (args->num_syncpt_incrs !=3D 1)
> +		return -EINVAL;
> +
> +	job =3D host1x_job_alloc(context->channel,
> +			args->num_cmdbufs,
> +			args->num_relocs,
> +			args->num_waitchks);
> +	if (!job)
> +		return -ENOMEM;
> +
> +	job->num_relocs =3D args->num_relocs;
> +	job->num_waitchk =3D args->num_waitchks;
> +	job->clientid =3D (u32)args->context;
> +	job->class =3D context->client->class;
> +	job->serialize =3D true;
> +
> +	while (num_cmdbufs) {
> +		struct tegra_drm_cmdbuf cmdbuf;
> +		err =3D copy_from_user(&cmdbuf, cmdbufs, sizeof(cmdbuf));
> +		if (err)
> +			goto fail;
> +
> +		cmdbuf.mem =3D handle_cma_to_host1x(drm, file_priv, cmdbuf.mem);
> +		if (!cmdbuf.mem)
> +			goto fail;
> +
> +		host1x_job_add_gather(job,
> +				cmdbuf.mem, cmdbuf.words, cmdbuf.offset);
> +		num_cmdbufs--;
> +		cmdbufs++;
> +	}
> +
> +	err =3D copy_from_user(job->relocarray,
> +			relocs, sizeof(*relocs) * num_relocs);
> +	if (err)
> +		goto fail;
> +
> +	while (num_relocs--) {
> +		job->relocarray[num_relocs].cmdbuf_mem =3D
> +			handle_cma_to_host1x(drm, file_priv,
> +			job->relocarray[num_relocs].cmdbuf_mem);
> +		job->relocarray[num_relocs].target =3D
> +			handle_cma_to_host1x(drm, file_priv,
> +			job->relocarray[num_relocs].target);
> +
> +		if (!job->relocarray[num_relocs].target ||
> +			!job->relocarray[num_relocs].cmdbuf_mem)
> +			goto fail;
> +	}
> +
> +	err =3D copy_from_user(job->waitchk,
> +			waitchks, sizeof(*waitchks) * num_waitchks);
> +	if (err)
> +		goto fail;
> +
> +	err =3D host1x_job_pin(job, to_platform_device(context->client->dev));
> +	if (err)
> +		goto fail;
> +
> +	err =3D copy_from_user(&syncpt_incr,
> +			(void * __user)(uintptr_t)args->syncpt_incrs,
> +			sizeof(syncpt_incr));
> +	if (err)
> +		goto fail;
> +
> +	job->syncpt_id =3D syncpt_incr.syncpt_id;
> +	job->syncpt_incrs =3D syncpt_incr.syncpt_incrs;
> +	job->timeout =3D 10000;
> +	job->is_addr_reg =3D gr2d_is_addr_reg;
> +	if (args->timeout && args->timeout < 10000)
> +		job->timeout =3D args->timeout;
> +
> +	err =3D host1x_channel_submit(job);
> +	if (err)
> +		goto fail_submit;
> +
> +	args->fence =3D job->syncpt_end;
> +
> +	host1x_job_put(job);
> +	return 0;
> +
> +fail_submit:
> +	host1x_job_unpin(job);
> +fail:
> +	host1x_job_put(job);
> +	return err;
> +}

Most of this looks very generic. Can't it be split out into separate
functions and reused in other (gr3d) modules?

> +static int gr2d_is_addr_reg(struct platform_device *dev, u32 class, u32 =
reg)
> +{
> +	int ret;
> +
> +	if (class =3D=3D NV_HOST1X_CLASS_ID)
> +		ret =3D reg =3D=3D 0x2b;
> +	else
> +		switch (reg) {
> +		case 0x1a:
> +		case 0x1b:
> +		case 0x26:
> +		case 0x2b:
> +		case 0x2c:
> +		case 0x2d:
> +		case 0x31:
> +		case 0x32:
> +		case 0x48:
> +		case 0x49:
> +		case 0x4a:
> +		case 0x4b:
> +		case 0x4c:
> +			ret =3D 1;
> +			break;
> +		default:
> +			ret =3D 0;
> +			break;
> +		}
> +
> +	return ret;
> +}

I should probably bite the bullet and read through the (still) huge
patch 3 to understand exactly why this is needed.

> +static struct of_device_id gr2d_match[] =3D {

static const please.

> +static int __exit gr2d_remove(struct platform_device *dev)
> +{
> +	struct host1x *host1x =3D
> +		host1x_get_drm_data(to_platform_device(dev->dev.parent));
> +	struct gr2d *gr2d =3D platform_get_drvdata(dev);
> +	int err;
> +
> +	err =3D host1x_unregister_client(host1x, &gr2d->client);
> +	if (err < 0) {
> +		dev_err(&dev->dev, "failed to unregister host1x client: %d\n",
> +			err);
> +		return err;
> +	}
> +
> +	host1x_syncpt_free(gr2d->syncpt);
> +	return 0;
> +}

Isn't this missing a host1x_channel_put() or host1x_free_channel()?

> diff --git a/include/drm/tegra_drm.h b/include/drm/tegra_drm.h
[...]
> +struct tegra_gem_create {
> +	__u64 size;
> +	unsigned int flags;
> +	unsigned int handle;
> +	unsigned int offset;
> +};

I think it's better to consistently use the explicitly sized types here.

> +struct tegra_gem_invalidate {
> +	unsigned int handle;
> +};
> +
> +struct tegra_gem_flush {
> +	unsigned int handle;
> +};

Where are these used?

> +struct tegra_drm_syncpt_wait_args {
> +	__u32 id;
> +	__u32 thresh;
> +	__s32 timeout;
> +	__u32 value;
> +};
> +
> +#define DRM_TEGRA_NO_TIMEOUT	(-1)

Is this the only reason why timeout is signed? If so maybe a better
choice would be __u32 and DRM_TEGRA_NO_TIMEOUT 0xffffffff.

> +struct tegra_drm_get_channel_param_args {
> +	__u64 context;
> +	__u32 param;
> +	__u32 value;
> +};

What's the reason for not calling this tegra_drm_get_syncpoint?

> +struct tegra_drm_syncpt_incr {
> +	__u32 syncpt_id;
> +	__u32 syncpt_incrs;
> +};

Maybe the fields would be better named id and incrs. Though I also
notice that incrs is never used. I guess that's supposed to be used in
the future to allow increments by more than a single value. If so,
perhaps value would be a better name.

Now on to the dreaded patch 3...

Thierry

--wULyF7TL5taEdwHz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRD6/yAAoJEN0jrNd/PrOhMtUP/3Wt4VZDeJxyUMPFbrS9aA7i
A6tbiPrxluTNrTNb+lGU9m2eS+a+HqzCoWJn0r8LGp/tkqaJoOFFb/WlYBn2e/9L
ppqL9g2uek/v2+gRDkisuwYz2JC27Vk7Vi9jJs5IOsJrZlJR9P8ejEfNKTxOmLsJ
ChwGjGOqtlcQNDKoYP+EzMA/1DOEAvVybs5Q+2Qu1ALzK8XBZhQ4Vdy/dXztqsvu
6DcetKrwOwQYYHv0t4nXFYCcRP+kVgMKRMwZMKDJ5rUnWhiz65+0IyAG7Br3nHT1
8KoFid3blhSh/poowvYDN7vVlxhz9/vJ9uSUuIBCr+dZUuZuKLvDZKq3MeRSxnYz
GKNiupLnvQOTaQLeBSgRdwayiSGPY399WBGq+iAWMGPn0a9/oVc1dMyk5VAbgm7/
sZVPjSGYqjoX1rgfUJWj9HuAGOUpvltVNL8upJszS1jaqFPrJRil80ge3gNTTKQ/
8ArlOYTy50K86GJxz7RKf3TaXYDxWgoMVbHKWng2TsiDFWIg9AeIHPTCAbrfKOQs
gthEba1DEVwNCX9yfISan4B4kbLQIjKJHPrVmN+BBWIf2POw1dMwt2q6oS72mJ2U
a3eUhFWpX2jEZs5ZgS9MRNtgb/+FJ8/80KJBppDiGHAFuLDYF3qj9P6hquMCKin0
uwe6IeReAfFAy2wZlFic
=dL3R
-----END PGP SIGNATURE-----

--wULyF7TL5taEdwHz--
