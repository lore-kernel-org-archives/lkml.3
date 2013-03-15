Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab3COMNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:13:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58535 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3COMNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:13:37 -0400
Date: Fri, 15 Mar 2013 13:13:32 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: airlied@linux.ie, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        amerilainen@nvidia.com
Subject: Re: [PATCHv7 10/10] drm: tegra: Add gr2d device
Message-ID: <20130315121332.GA3374@avionic-0098.mockup.avionic-design.de>
References: <1363178186-2017-1-git-send-email-tbergstrom@nvidia.com>
 <1363178186-2017-11-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <1363178186-2017-11-git-send-email-tbergstrom@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:DqQ+dgnfbHXnyon2jtVSLCn+oFO9A4rbkXVzn3bxQZB
 rAUJbTe5yHM44ibyW4vyPzSiJSY+A1O3+/rVydTs0v9/FWWjuu
 WUOORozp/PiXeqaYRDyezljjp0DG+tqiHlH9Rv2hRLi2OV1Vrk
 h8ToU8vFWrnJa2nPDq4jyVTPzYKHrB65l7TPpxrUoUaVGUPdjf
 tVvxHPyXpNzah0YMRkHRhLbCZaxz+8Nf12RcwnhTYWBnCd+Tch
 ksrk07JO73zfVTlXzHwNOvVyCb2pvjabG0WCxBmT7POfvND0Wa
 wXfvj6zpzfg9bie6jASd6feNLg/ltO8tQAY8zb1VEkBWP2CfMm
 SrXnpEij4dkKaOHvrpHAVDCsIXZ1gZCpLopmji0KSXdQjedyjV
 xdaR3MO3FNN8FYr0XrBeu0Ms6P5Bvi2LbtFWtpov08TRFsmyNE
 pb6bZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2013 at 02:36:26PM +0200, Terje Bergstrom wrote:
[...]
> diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
[...]
> +static inline struct host1x_drm_context *tegra_drm_get_context(
> +					struct list_head *contexts,
> +					struct host1x_drm_context *_ctx)
> +{
> +	struct host1x_drm_context *ctx;
> +
> +	list_for_each_entry(ctx, contexts, list)
> +		if (ctx =3D=3D _ctx)
> +			return ctx;
> +	return NULL;
> +}

Maybe make this a little more high-level, such as:

static bool host1x_drm_file_owns_context(struct host1x_drm_file *file,
					 struct host1x_drm_context *context)

?

> +static int tegra_drm_ioctl_open_channel(struct drm_device *drm, void *da=
ta,
> +					struct drm_file *file_priv)
> +{
> +	struct tegra_drm_open_channel_args *args =3D data;
> +	struct host1x_client *client;
> +	struct host1x_drm_context *context;
> +	struct host1x_drm_file *fpriv =3D file_priv->driver_priv;
> +	struct host1x_drm *host1x =3D drm->dev_private;
> +	int err =3D -ENODEV;
> +
> +	context =3D kzalloc(sizeof(*context), GFP_KERNEL);
> +	if (!context)
> +		return -ENOMEM;
> +
> +	list_for_each_entry(client, &host1x->clients, list)
> +		if (client->class =3D=3D args->class) {
> +			context->client =3D client;

Why do you assign this here? Should it perhaps be assigned only when the
opening of the channel succeeds? The .open_channel() already receives a
pointer to the client as parameter, so it doesn't have to be associated
with the context.

> +static int tegra_drm_ioctl_get_syncpoint(struct drm_device *drm, void *d=
ata,
> +					 struct drm_file *file_priv)
> +{
> +	struct tegra_drm_get_syncpoint *args =3D data;
> +	struct host1x_drm_file *fpriv =3D file_priv->driver_priv;
> +	struct host1x_drm_context *context =3D
> +		(struct host1x_drm_context *)(uintptr_t)args->context;
> +
> +	if (!tegra_drm_get_context(&fpriv->contexts, context))
> +		return -ENODEV;
> +
> +	if (context->client->num_syncpts < args->param)
> +		return -ENODEV;

I think this might be easier to read as:

	if (args->param >=3D context->client->num_syncpts)
		return -ENODEV;

> +	args->value =3D host1x_syncpt_id(context->client->syncpts[args->param]);

This could use a temporary variable "syncpt" to make it easier to read.

> +static int tegra_drm_gem_create_ioctl(struct drm_device *drm, void *data,
> +				      struct drm_file *file_priv)

tegra_drm_ioctl_gem_create()?

> +{
> +	struct tegra_drm_create *args =3D data;
> +	struct drm_gem_cma_object *cma_obj;
> +	struct tegra_drm_bo *cma_bo;

These can probably just be named "cma"/"gem" and "bo" instead.

> +static int tegra_drm_ioctl_get_offset(struct drm_device *drm, void *data,
> +				      struct drm_file *file_priv)

I think this might be more generically named tegra_drm_ioctl_mmap()
which might come in handy if we ever need to do something more than just
retrieve the offset.

> +{
> +	struct tegra_drm_get_offset *args =3D data;
> +	struct drm_gem_cma_object *cma_obj;
> +	struct drm_gem_object *obj;
> +
> +	obj =3D drm_gem_object_lookup(drm, file_priv, args->handle);
> +	if (!obj)
> +		return -EINVAL;
> +	cma_obj =3D to_drm_gem_cma_obj(obj);

The above two lines should be separated by a blank line.

> +
> +	args->offset =3D cma_obj->base.map_list.hash.key << PAGE_SHIFT;

Perhaps a better way would be to export the get_gem_mmap_offset() from
drivers/gpu/drm/drm_gem_cma_helper.c and reuse that.

>  static struct drm_ioctl_desc tegra_drm_ioctls[] =3D {
> +	DRM_IOCTL_DEF_DRV(TEGRA_DRM_GEM_CREATE,
> +			tegra_drm_gem_create_ioctl, DRM_UNLOCKED | DRM_AUTH),
> +	DRM_IOCTL_DEF_DRV(TEGRA_DRM_SYNCPT_READ,
> +			tegra_drm_ioctl_syncpt_read, DRM_UNLOCKED),
> +	DRM_IOCTL_DEF_DRV(TEGRA_DRM_SYNCPT_INCR,
> +			tegra_drm_ioctl_syncpt_incr, DRM_UNLOCKED),
> +	DRM_IOCTL_DEF_DRV(TEGRA_DRM_SYNCPT_WAIT,
> +			tegra_drm_ioctl_syncpt_wait, DRM_UNLOCKED),
> +	DRM_IOCTL_DEF_DRV(TEGRA_DRM_OPEN_CHANNEL,
> +			tegra_drm_ioctl_open_channel, DRM_UNLOCKED),
> +	DRM_IOCTL_DEF_DRV(TEGRA_DRM_CLOSE_CHANNEL,
> +			tegra_drm_ioctl_close_channel, DRM_UNLOCKED),
> +	DRM_IOCTL_DEF_DRV(TEGRA_DRM_GET_SYNCPOINT,
> +			tegra_drm_ioctl_get_syncpoint, DRM_UNLOCKED),
> +	DRM_IOCTL_DEF_DRV(TEGRA_DRM_SUBMIT,
> +			tegra_drm_ioctl_submit, DRM_UNLOCKED),
> +	DRM_IOCTL_DEF_DRV(TEGRA_DRM_GEM_GET_OFFSET,
> +			tegra_drm_ioctl_get_offset, DRM_UNLOCKED),
>  };

Maybe resort these to put the GEM-specific IOCTLs closer together?

>  static const struct file_operations tegra_drm_fops =3D {
> @@ -345,10 +585,17 @@ static void tegra_drm_disable_vblank(struct drm_dev=
ice *drm, int pipe)
> =20
>  static void tegra_drm_preclose(struct drm_device *drm, struct drm_file *=
file)
>  {
> +	struct host1x_drm_file *fpriv =3D file->driver_priv;
> +	struct host1x_drm_context *context, *tmp;
>  	struct drm_crtc *crtc;
> =20
>  	list_for_each_entry(crtc, &drm->mode_config.crtc_list, head)
>  		tegra_dc_cancel_page_flip(crtc, file);
> +
> +	list_for_each_entry_safe(context, tmp, &fpriv->contexts, list)
> +		host1x_drm_context_free(context);
> +	kfree(fpriv);

Another missing blank line between these.

> diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
[...]
> +static struct host1x_bo *handle_cma_to_host1x(struct drm_device *drm,
> +					      struct drm_file *file_priv,
> +					      u32 gem_handle)
> +{
> +	struct drm_gem_object *gem_obj;
> +	struct drm_gem_cma_object *cma_obj;
> +	struct tegra_drm_bo *cma_bo;
> +
> +	gem_obj =3D drm_gem_object_lookup(drm, file_priv, gem_handle);
> +	if (!gem_obj)
> +		return 0;
> +
> +	mutex_lock(&drm->struct_mutex);
> +	drm_gem_object_unreference(gem_obj);
> +	mutex_unlock(&drm->struct_mutex);
> +
> +	cma_obj =3D to_drm_gem_cma_obj(gem_obj);
> +	cma_bo =3D container_of(cma_obj, struct tegra_drm_bo, cma_obj);
> +
> +	return &cma_bo->base;
> +}

Maybe rename this to host1x_bo_lookup()? *_to_* are usually used for
up- and downcasting; this function does a lot more.

> +static int gr2d_submit(struct host1x_drm_context *context,
> +		       struct tegra_drm_submit_args *args,
> +		       struct drm_device *drm,
> +		       struct drm_file *file_priv)
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
> +	struct tegra_drm_syncpt_incr syncpt_incr;
> +	int err;
> +
> +	/* We don't yet support other than one syncpt_incr struct per submit */
> +	if (args->num_syncpt_incrs !=3D 1)
> +		return -EINVAL;
> +
> +	job =3D host1x_job_alloc(context->channel, args->num_cmdbufs,
> +			       args->num_relocs, args->num_waitchks);
> +	if (!job)
> +		return -ENOMEM;
> +
> +	job->num_relocs =3D args->num_relocs;
> +	job->num_waitchk =3D args->num_waitchks;
> +	job->client =3D (u32)args->context;
> +	job->class =3D context->client->class;
> +	job->serialize =3D true;
> +
> +	while (num_cmdbufs) {
> +		struct tegra_drm_cmdbuf cmdbuf;
> +		struct host1x_bo *mem_handle;
> +		err =3D copy_from_user(&cmdbuf, cmdbufs, sizeof(cmdbuf));

Could use an blank line to separate variable declarations from the code.
Also maybe rename mem_handle to bo which is much shorter.

> +		goto fail;
> +
> +	err =3D host1x_job_pin(job, context->client->dev);
> +	if (err)
> +		goto fail;
> +
> +	err =3D copy_from_user(&syncpt_incr,
> +			     (void * __user)(uintptr_t)args->syncpt_incrs,
> +			     sizeof(syncpt_incr));
> +	if (err)
> +		goto fail;
> +
> +	job->syncpt_id =3D syncpt_incr.id;
> +	job->syncpt_incrs =3D syncpt_incr.incrs;
> +	job->timeout =3D 10000;
> +	job->is_addr_reg =3D gr2d_is_addr_reg;
> +	if (args->timeout && args->timeout < 10000)

Another missing blank line.

Also you now create a lookup table (or bitfield actually) as we
discussed but you still pass around a function to check the lookup table
against. What I originally intended was to not pass a function around at
all but directly use the lookup table/bitfield. However I think we can
leave this as-is for now and change it later if required.

> +static int gr2d_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct host1x_drm *host1x =3D host1x_get_drm_data(dev->parent);
> +	int err;
> +	struct gr2d *gr2d =3D NULL;
> +	struct host1x_syncpt **syncpts;

I don't think there's a need for this temporary variable. You could just
use gr2d->client.syncpts directly.

> +	gr2d =3D devm_kzalloc(dev, sizeof(*gr2d), GFP_KERNEL);
> +	if (!gr2d)
> +		return -ENOMEM;
> +
> +	syncpts =3D devm_kzalloc(dev, sizeof(*syncpts), GFP_KERNEL);
> +	if (!syncpts)
> +		return -ENOMEM;
> +
> +	gr2d->clk =3D devm_clk_get(dev, NULL);
> +	if (IS_ERR(gr2d->clk)) {
> +		dev_err(dev, "cannot get clock\n");
> +		return PTR_ERR(gr2d->clk);
> +	}
> +
> +	err =3D clk_prepare_enable(gr2d->clk);
> +	if (err) {
> +		dev_err(dev, "cannot turn on clock\n");
> +		return err;
> +	}
> +
> +	gr2d->channel =3D host1x_channel_alloc(dev);
> +	if (!gr2d->channel)
> +		return -ENOMEM;
> +
> +	*syncpts =3D host1x_syncpt_request(dev, 0);
> +	if (!(*syncpts)) {
> +		host1x_channel_free(gr2d->channel);
> +		return -ENOMEM;
> +	}
> +
> +	gr2d->client.ops =3D &gr2d_client_ops;
> +	gr2d->client.dev =3D dev;
> +	gr2d->client.class =3D HOST1X_CLASS_GR2D;
> +	gr2d->client.syncpts =3D syncpts;
> +	gr2d->client.num_syncpts =3D 1;
> +
> +	err =3D host1x_register_client(host1x, &gr2d->client);
> +	if (err < 0) {
> +		dev_err(dev, "failed to register host1x client: %d\n", err);
> +		return err;
> +	}
> +
> +	gr2d_init_addr_reg_map(dev, gr2d);
> +
> +	dev_set_drvdata(dev, gr2d);

Nit: I think it'd be nicer to use platform_set_drvdata() here to mirror
the platform_get_drvdata() from gr2d_remove().

> diff --git a/include/drm/tegra_drm.h b/include/drm/tegra_drm.h
[...]
> +struct tegra_drm_create {

struct tegra_drm_gem_create?

> +	__u64 size;
> +	u32 flags;
> +	u32 handle;
> +	u32 offset;
> +	u32 padding;

Also since we have a separate IOCTL for this, I think you can leave out
the offset field (and also padding since it isn't required anymore).

> +struct tegra_drm_get_offset {
> +	__u32 handle;
> +	__u32 offset;
> +};

struct tegra_drm_gem_mmap to go along with the name change of the IOCTL.

> +struct tegra_drm_syncpt_incr_args {
> +	__u32 id;
> +	__u32 pad;
> +};

Shouldn't this second field be something like "value" to allow this
IOCTL to increment by more than 1?

> +#define DRM_TEGRA_NO_TIMEOUT	(0xffffffff)

No need for the parentheses.

> +struct tegra_drm_reloc {
> +	__u32 cmdbuf_mem;
> +	__u32 cmdbuf_offset;
> +	__u32 target;
> +	__u32 target_offset;
> +	__u32 shift;
> +	__u32 pad;
> +};

I've found this to be a little inconsistent. Why does the cmdbuf_mem
have the _mem suffix, but not the target field? Given that this will
eventually be used by userspace software once merged it will be fixed
forever. I had noticed the same for the in-kernel structures but didn't
think it important enough to hold up the patches. In this case I think
we should make them consistent, though.

> +#define DRM_TEGRA_DRM_GEM_CREATE	0x00
> +#define DRM_TEGRA_DRM_SYNCPT_READ	0x01
> +#define DRM_TEGRA_DRM_SYNCPT_INCR	0x02
> +#define DRM_TEGRA_DRM_SYNCPT_WAIT	0x03
> +#define DRM_TEGRA_DRM_OPEN_CHANNEL	0x04
> +#define DRM_TEGRA_DRM_CLOSE_CHANNEL	0x05
> +#define DRM_TEGRA_DRM_GET_SYNCPOINT	0x06
> +#define DRM_TEGRA_DRM_SUBMIT		0x08
> +#define DRM_TEGRA_DRM_GEM_GET_OFFSET	0x09
> +
> +#define DRM_IOCTL_TEGRA_DRM_GEM_CREATE DRM_IOWR(DRM_COMMAND_BASE + DRM_T=
EGRA_DRM_GEM_CREATE, struct tegra_drm_create)
> +#define DRM_IOCTL_TEGRA_DRM_SYNCPT_READ DRM_IOWR(DRM_COMMAND_BASE + DRM_=
TEGRA_DRM_SYNCPT_READ, struct tegra_drm_syncpt_read_args)
> +#define DRM_IOCTL_TEGRA_DRM_SYNCPT_INCR DRM_IOWR(DRM_COMMAND_BASE + DRM_=
TEGRA_DRM_SYNCPT_INCR, struct tegra_drm_syncpt_incr_args)
> +#define DRM_IOCTL_TEGRA_DRM_SYNCPT_WAIT DRM_IOWR(DRM_COMMAND_BASE + DRM_=
TEGRA_DRM_SYNCPT_WAIT, struct tegra_drm_syncpt_wait_args)
> +#define DRM_IOCTL_TEGRA_DRM_OPEN_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DRM=
_TEGRA_DRM_OPEN_CHANNEL, struct tegra_drm_open_channel_args)
> +#define DRM_IOCTL_TEGRA_DRM_CLOSE_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DR=
M_TEGRA_DRM_CLOSE_CHANNEL, struct tegra_drm_open_channel_args)
> +#define DRM_IOCTL_TEGRA_DRM_GET_SYNCPOINT DRM_IOWR(DRM_COMMAND_BASE + DR=
M_TEGRA_DRM_GET_SYNCPOINT, struct tegra_drm_get_syncpoint)
> +#define DRM_IOCTL_TEGRA_DRM_SUBMIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA=
_DRM_SUBMIT, struct tegra_drm_submit_args)
> +#define DRM_IOCTL_TEGRA_DRM_GEM_GET_OFFSET DRM_IOWR(DRM_COMMAND_BASE + D=
RM_TEGRA_DRM_GEM_GET_OFFSET, struct tegra_drm_get_offset)

Same comment regarding reordering and GET_OFFSET -> MMAP rename.

Thierry

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRQxBsAAoJEN0jrNd/PrOhBsQP+gJBx5Tr4//PL0oIFZX5CPgy
tY69e4g3G4YEKnEBYG3isTT7/HLoUpiMriJ2MPGX2++kOgF4HSVcRVWQbjWZkkop
ayXCYSY0X/w8d5BUWSDF0JZjfIGqwcHHwnprh+Nxlw5DFrsmCXQl7Tr5nZrIlrGD
tlHq8U1IhAKVhNzihvZDPoZjzBAkoVBgxOniM/cJf7ho9ISFHPaWAA1y/6IJwkPW
7lmVGPwS2dgjFtcWQ8FiLTMrp8G1dhfPgtdZE6INSkbf7qQYYkePmRuCzWvC5mqi
rfWg9cW/kbE5fJXoLzUw44/QoI9EgIfolmVOLID/LghYEtpcrKZ/Xg43FCQBQPmb
rg+HKPlNKOB4qriTw4CVvW3vPK0OrTTu1Q6khiZZk9sqGdd+CqtaY7cxuZQyLZvI
Vpq8E/2gJ2kv8SwK0o8D/zcut4d1do5JjIe5ghpzaRwVY7fpc00S0ScfzaqSjkpU
kj77v8qiFAGHqoj8rHs3zG2U0/6GWgRM3RjS41wwdPOt3GvjbiYu6vB52NJ+d92n
VdhOJLZY+hQPVBZxB1ka76WO9kq6qYVOPMo99h9v8QfPKb1yhyi4tdsDTRhxN6RX
TFg0LVKQ4ha/fn4ZnNm9n4GdXyQ9/qmi78zvrukH1Q5etEYSVQKffI0yquOIYij/
fZPBwUj1ofs+icX2Wq95
=sSJ/
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
