Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052Ab3BEFSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:18:00 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9417 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3BEFR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:17:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 04 Feb 2013 21:14:57 -0800
Message-ID: <511095F9.6040607@nvidia.com>
Date: Mon, 4 Feb 2013 21:17:45 -0800
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 8/8] drm: tegra: Add gr2d device
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-9-git-send-email-tbergstrom@nvidia.com> <20130204125618.GD595@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130204125618.GD595@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.02.2013 04:56, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Jan 15, 2013 at 01:44:04PM +0200, Terje Bergstrom wrote:
> [...]
>> diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
>> @@ -270,7 +274,29 @@ static int tegra_drm_unload(struct drm_device *drm)
>>
>>  static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
>>  {
>> -     return 0;
>> +     struct host1x_drm_fpriv *fpriv;
>> +     int err = 0;
> 
> Can be dropped.
> 
>> +
>> +     fpriv = kzalloc(sizeof(*fpriv), GFP_KERNEL);
>> +     if (!fpriv)
>> +             return -ENOMEM;
>> +
>> +     INIT_LIST_HEAD(&fpriv->contexts);
>> +     filp->driver_priv = fpriv;
>> +
>> +     return err;
> 
> return 0;

Ok.

> 
>> +static void tegra_drm_close(struct drm_device *drm, struct drm_file *filp)
>> +{
>> +     struct host1x_drm_fpriv *fpriv = host1x_drm_fpriv(filp);
>> +     struct host1x_drm_context *context, *tmp;
>> +
>> +     list_for_each_entry_safe(context, tmp, &fpriv->contexts, list) {
>> +             context->client->ops->close_channel(context);
>> +             kfree(context);
>> +     }
>> +     kfree(fpriv);
>>  }
> 
> Maybe you should add host1x_drm_context_free() to wrap the loop
> contents?

Makes sense. Will do.

> 
>> @@ -280,7 +306,204 @@ static void tegra_drm_lastclose(struct drm_device *drm)
>>       drm_fbdev_cma_restore_mode(host1x->fbdev);
>>  }
>>
>> +static int
>> +tegra_drm_ioctl_syncpt_read(struct drm_device *drm, void *data,
>> +                      struct drm_file *file_priv)
> 
> static int and function name on one line, please.

Ok, will re-split the lines.

> 
>> +{
>> +     struct host1x *host1x = drm->dev_private;
>> +     struct tegra_drm_syncpt_read_args *args = data;
>> +     struct host1x_syncpt *sp =
>> +             host1x_syncpt_get_bydev(host1x->dev, args->id);
> 
> I don't know if we need this, except maybe to work around the problem
> that we have two different structures named host1x. The _bydev() suffix
> is misleading because all you really do here is obtain the syncpt from
> the host1x.

Yeah, it's actually working around the host1x duplicate naming.
host1x_syncpt_get takes struct host1x as parameter, but that's different
host1x than in this code.

> 
>> +static int
>> +tegra_drm_ioctl_open_channel(struct drm_device *drm, void *data,
>> +                      struct drm_file *file_priv)
>> +{
>> +     struct tegra_drm_open_channel_args *args = data;
>> +     struct host1x_client *client;
>> +     struct host1x_drm_context *context;
>> +     struct host1x_drm_fpriv *fpriv = host1x_drm_fpriv(file_priv);
>> +     struct host1x *host1x = drm->dev_private;
>> +     int err = 0;
> 
> err = -ENODEV; (see below)

Ok, makes sense.

> 
>> +
>> +     context = kzalloc(sizeof(*context), GFP_KERNEL);
>> +     if (!context)
>> +             return -ENOMEM;
>> +
>> +     list_for_each_entry(client, &host1x->clients, list) {
>> +             if (client->class == args->class) {
>> +                     context->client = client;
>> +                     err = client->ops->open_channel(client, context);
>> +                     if (err)
>> +                             goto out;
>> +
>> +                     list_add(&context->list, &fpriv->contexts);
>> +                     args->context = (uintptr_t)context;
> 
> Perhaps cast this to __u64 directly instead? There's little sense in
> taking the detour via uintptr_t.

I think compiler complained about a direct cast to __u64, but I'll try
again.

> 
>> +                     goto out;
> 
> return 0;
> 
>> +             }
>> +     }
>> +     err = -ENODEV;
>> +
>> +out:
>> +     if (err)
>> +             kfree(context);
>> +
>> +     return err;
>> +}
> 
> Then this simply becomes:
> 
>         kfree(context);
>         return err;

Sounds good.

> 
>> +static int
>> +tegra_drm_ioctl_close_channel(struct drm_device *drm, void *data,
>> +                      struct drm_file *file_priv)
>> +{
>> +     struct tegra_drm_open_channel_args *args = data;
>> +     struct host1x_drm_context *context, *tmp;
>> +     struct host1x_drm_fpriv *fpriv = host1x_drm_fpriv(file_priv);
>> +     int err = 0;
>> +
>> +     list_for_each_entry_safe(context, tmp, &fpriv->contexts, list) {
>> +             if ((uintptr_t)context == args->context) {
>> +                     context->client->ops->close_channel(context);
>> +                     list_del(&context->list);
>> +                     kfree(context);
>> +                     goto out;
>> +             }
>> +     }
>> +     err = -EINVAL;
>> +
>> +out:
>> +     return err;
>> +}
> 
> Same comments as for tegra_drm_ioctl_open_channel().

Ok, will apply.

> 
>> +static int
>> +tegra_drm_ioctl_get_syncpoint(struct drm_device *drm, void *data,
>> +                      struct drm_file *file_priv)
>> +{
>> +     struct tegra_drm_get_channel_param_args *args = data;
>> +     struct host1x_drm_context *context;
>> +     struct host1x_drm_fpriv *fpriv = host1x_drm_fpriv(file_priv);
>> +     int err = 0;
>> +
>> +     list_for_each_entry(context, &fpriv->contexts, list) {
>> +             if ((uintptr_t)context == args->context) {
>> +                     args->value =
>> +                             context->client->ops->get_syncpoint(context,
>> +                                             args->param);
>> +                     goto out;
>> +             }
>> +     }
>> +     err = -ENODEV;
>> +
>> +out:
>> +     return err;
>> +}
> 
> Same comments as well. Also you may want to factor out the context
> lookup into a separate function so you don't have to repeat the same
> code over and over again.

Will do.

> 
> I wonder if we shouldn't remove .get_syncpoint() from the client ops and
> replace it by a simple array instead. The only use-case for this is if a
> client wants more than a single syncpoint, right? In that case just keep
> an array of syncpoints and the number of syncpoints per client.
> Otherwise each client will have to rewrite the same function.

That makes sense. Will do.

> Also, how useful is it to create a context? Looking at the gr2d
> implementation for .open_channel(), it will return the same channel to
> whichever userspace process requests them. Can you explain why it is
> necessary at all? From the name I would have expected some kind of
> context switching to take place when different applications submit
> requests to the same client, but that doesn't seem to be the case.

Hardware context switching will be a later submit, and it'll actually
create a new structure. Hardware context might live longer than the
process that created it, so they'll need to be separate.

We've used the context as a place for storing flags and the reference to
hardware context. It'd allow also opening channels to multiple devices,
and context would be used in submit to find out the target device. But
as hardware context switching is not implemented in this patch set, and
neither is support for anything but 2D, it's difficult to justify it.

Perhaps the justification is that this way we can keep the kernel API
stable even when we add support for hardware contexts and other clients.

> 
>> +static int
>> +tegra_drm_create_ioctl(struct drm_device *drm, void *data,
>> +                      struct drm_file *file_priv)
> 
> tegra_drm_gem_create_ioctl() please.

Sure.

> 
>>  static struct drm_ioctl_desc tegra_drm_ioctls[] = {
>> +     DRM_IOCTL_DEF_DRV(TEGRA_GEM_CREATE,
>> +                     tegra_drm_create_ioctl, DRM_UNLOCKED | DRM_AUTH),
> 
> TEGRA_DRM_GEM_CREATE

Will change.

> 
>>  static const struct file_operations tegra_drm_fops = {
>> @@ -303,6 +526,7 @@ struct drm_driver tegra_drm_driver = {
>>       .load = tegra_drm_load,
>>       .unload = tegra_drm_unload,
>>       .open = tegra_drm_open,
>> +     .preclose = tegra_drm_close,
> 
> I think it'd make sense to name the function tegra_drm_preclose() to
> match the name in struct drm_driver.

Yes, and I think you added preclose in your vblank patch set, so I'll
need to rebase.

> 
>> diff --git a/drivers/gpu/host1x/drm/drm.h b/drivers/gpu/host1x/drm/drm.h
> [...]
>> +struct host1x_drm_fpriv {
>> +     struct list_head contexts;
>>  };
> 
> Maybe name this host1x_drm_file. fpriv isn't very specific.

host1x_drm_file sounds a bit odd, because it's not really a file, but a
private data pointer stored in driver_priv.

> 
>> +static inline struct host1x_drm_fpriv *
>> +host1x_drm_fpriv(struct drm_file *file_priv)
>> +{
>> +     return file_priv ? file_priv->driver_priv : NULL;
>> +}
> 
> I think it's fine to just directly do filp->driver_priv instead of going
> through this wrapper.

Ok.

> 
>>  struct host1x_client {
>>       struct host1x *host1x;
>>       struct device *dev;
>>
>>       const struct host1x_client_ops *ops;
>>
>> +     u32 class;
> 
> Should this perhaps be an enum?

That would make sense. I've kept it u32, because the type of class in
hardware is u32, but the two don't need to match.

> 
>> diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
> [...]
>> +static u32 gr2d_get_syncpoint(struct host1x_drm_context *context, int index)
>> +{
>> +     struct gr2d *gr2d = dev_get_drvdata(context->client->dev);
>> +     if (index != 0)
>> +             return UINT_MAX;
>> +
>> +     return host1x_syncpt_id(gr2d->syncpt);
>> +}
> 
> Maybe get_syncpoint() should return int and negative error codes on
> failure. That still leaves room for 2^31 possible syncpoints.

That'd be enough. Will do. :-)

> 
>> +static u32 handle_cma_to_host1x(struct drm_device *drm,
>> +                             struct drm_file *file_priv, u32 gem_handle)
>> +{
>> +     struct drm_gem_object *obj;
>> +     struct drm_gem_cma_object *cma_obj;
>> +     u32 host1x_handle;
>> +
>> +     obj = drm_gem_object_lookup(drm, file_priv, gem_handle);
>> +     if (!obj)
>> +             return 0;
>> +
>> +     cma_obj = to_drm_gem_cma_obj(obj);
>> +     host1x_handle = host1x_memmgr_host1x_id(mem_mgr_type_cma, (u32)cma_obj);
>> +     drm_gem_object_unreference(obj);
>> +
>> +     return host1x_handle;
>> +}
> 
> I though we had settled in previous reviews on only having a single
> allocator and not do the conversion between various types?

I'll need to agree with Lucas on how to handle this. He intended to make
a patch to fix this, but he hasn't had time to do that.

But, I'd still like to keep the possibility open to add dma_buf as
memory handle type, and fit that into the same API, so there's still a
need to have the mem_mgr_type abstraction.

> 
>> +static int gr2d_submit(struct host1x_drm_context *context,
>> +             struct tegra_drm_submit_args *args,
>> +             struct drm_device *drm,
>> +             struct drm_file *file_priv)
>> +{
>> +     struct host1x_job *job;
>> +     int num_cmdbufs = args->num_cmdbufs;
>> +     int num_relocs = args->num_relocs;
>> +     int num_waitchks = args->num_waitchks;
>> +     struct tegra_drm_cmdbuf __user *cmdbufs =
>> +             (void * __user)(uintptr_t)args->cmdbufs;
>> +     struct tegra_drm_reloc __user *relocs =
>> +             (void * __user)(uintptr_t)args->relocs;
>> +     struct tegra_drm_waitchk __user *waitchks =
>> +             (void * __user)(uintptr_t)args->waitchks;
> 
> No need for all the uintptr_t casts.

Will try to remove - but I do remember getting compiler warnings without
them.

(...)
> Most of this looks very generic. Can't it be split out into separate
> functions and reused in other (gr3d) modules?

That's actually how most of this is downstream. I thought to make
everything really simple and make it all 2D specific in the first patch
set, and split into generic when we add support for another device.

> 
>> +static int gr2d_is_addr_reg(struct platform_device *dev, u32 class, u32 reg)
>> +{
>> +     int ret;
>> +
>> +     if (class == NV_HOST1X_CLASS_ID)
>> +             ret = reg == 0x2b;
>> +     else
>> +             switch (reg) {
>> +             case 0x1a:
>> +             case 0x1b:
>> +             case 0x26:
>> +             case 0x2b:
>> +             case 0x2c:
>> +             case 0x2d:
>> +             case 0x31:
>> +             case 0x32:
>> +             case 0x48:
>> +             case 0x49:
>> +             case 0x4a:
>> +             case 0x4b:
>> +             case 0x4c:
>> +                     ret = 1;
>> +                     break;
>> +             default:
>> +                     ret = 0;
>> +                     break;
>> +             }
>> +
>> +     return ret;
>> +}
> 
> I should probably bite the bullet and read through the (still) huge
> patch 3 to understand exactly why this is needed.

That's the security firewall. It walks through each submit, and ensures
that each register write that writes an address, goes through the host1x
reloc mechanism. This way user space cannot ask 2D to write to arbitrary
memory locations.

> 
>> +static struct of_device_id gr2d_match[] = {
> 
> static const please.

Ok.

> 
>> +static int __exit gr2d_remove(struct platform_device *dev)
>> +{
>> +     struct host1x *host1x =
>> +             host1x_get_drm_data(to_platform_device(dev->dev.parent));
>> +     struct gr2d *gr2d = platform_get_drvdata(dev);
>> +     int err;
>> +
>> +     err = host1x_unregister_client(host1x, &gr2d->client);
>> +     if (err < 0) {
>> +             dev_err(&dev->dev, "failed to unregister host1x client: %d\n",
>> +                     err);
>> +             return err;
>> +     }
>> +
>> +     host1x_syncpt_free(gr2d->syncpt);
>> +     return 0;
>> +}
> 
> Isn't this missing a host1x_channel_put() or host1x_free_channel()?

All references should be handled in gr2d_open_channel() and
gr2d_close_channel(). I think we'd need to ensure all contexts are
closed at this point.

> 
>> diff --git a/include/drm/tegra_drm.h b/include/drm/tegra_drm.h
> [...]
>> +struct tegra_gem_create {
>> +     __u64 size;
>> +     unsigned int flags;
>> +     unsigned int handle;
>> +     unsigned int offset;
>> +};
> 
> I think it's better to consistently use the explicitly sized types here.
> 
>> +struct tegra_gem_invalidate {
>> +     unsigned int handle;
>> +};
>> +
>> +struct tegra_gem_flush {
>> +     unsigned int handle;
>> +};
> 
> Where are these used?

Arto, please go through these.

> 
>> +struct tegra_drm_syncpt_wait_args {
>> +     __u32 id;
>> +     __u32 thresh;
>> +     __s32 timeout;
>> +     __u32 value;
>> +};
>> +
>> +#define DRM_TEGRA_NO_TIMEOUT (-1)
> 
> Is this the only reason why timeout is signed? If so maybe a better
> choice would be __u32 and DRM_TEGRA_NO_TIMEOUT 0xffffffff.

I believe it is so. In fact we'd need to rename it to something like
INFINITE_TIMEOUT, because we also have a case of timeout=0, which
returns immediately, i.e. doesn't have a timeout either.

> 
>> +struct tegra_drm_get_channel_param_args {
>> +     __u64 context;
>> +     __u32 param;
>> +     __u32 value;
>> +};
> 
> What's the reason for not calling this tegra_drm_get_syncpoint?

I wanted to use the same struct for other parameters, too: wait bases,
mutexes. But it doesn't really optimize anything, so I can make them
each specific structs.

> 
>> +struct tegra_drm_syncpt_incr {
>> +     __u32 syncpt_id;
>> +     __u32 syncpt_incrs;
>> +};
> 
> Maybe the fields would be better named id and incrs. Though I also
> notice that incrs is never used. I guess that's supposed to be used in
> the future to allow increments by more than a single value. If so,
> perhaps value would be a better name.

It's actually used in the dreaded patch 3, as part of tegra_drm_submit_args.

> Now on to the dreaded patch 3...

Enjoy. :-)

Terje

