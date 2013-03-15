Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab3CONWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:22:17 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19956 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3CONWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:22:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 15 Mar 2013 06:15:19 -0700
Message-ID: <514320B1.5060002@nvidia.com>
Date: Fri, 15 Mar 2013 15:22:57 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "airlied@linux.ie" <airlied@linux.ie>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [PATCHv7 10/10] drm: tegra: Add gr2d device
References: <1363178186-2017-1-git-send-email-tbergstrom@nvidia.com> <1363178186-2017-11-git-send-email-tbergstrom@nvidia.com> <20130315121332.GA3374@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130315121332.GA3374@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.03.2013 14:13, Thierry Reding wrote:
> On Wed, Mar 13, 2013 at 02:36:26PM +0200, Terje Bergstrom wrote:
> [...]
>> diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
> [...]
>> +static inline struct host1x_drm_context *tegra_drm_get_context(
>> +                                     struct list_head *contexts,
>> +                                     struct host1x_drm_context *_ctx)
>> +{
>> +     struct host1x_drm_context *ctx;
>> +
>> +     list_for_each_entry(ctx, contexts, list)
>> +             if (ctx == _ctx)
>> +                     return ctx;
>> +     return NULL;
>> +}
> 
> Maybe make this a little more high-level, such as:
> 
> static bool host1x_drm_file_owns_context(struct host1x_drm_file *file,
>                                          struct host1x_drm_context *context)
> 
> ?

We only need the true/false value, so changing signature makes sense.

> 
>> +static int tegra_drm_ioctl_open_channel(struct drm_device *drm, void *data,
>> +                                     struct drm_file *file_priv)
>> +{
>> +     struct tegra_drm_open_channel_args *args = data;
>> +     struct host1x_client *client;
>> +     struct host1x_drm_context *context;
>> +     struct host1x_drm_file *fpriv = file_priv->driver_priv;
>> +     struct host1x_drm *host1x = drm->dev_private;
>> +     int err = -ENODEV;
>> +
>> +     context = kzalloc(sizeof(*context), GFP_KERNEL);
>> +     if (!context)
>> +             return -ENOMEM;
>> +
>> +     list_for_each_entry(client, &host1x->clients, list)
>> +             if (client->class == args->class) {
>> +                     context->client = client;
> 
> Why do you assign this here? Should it perhaps be assigned only when the
> opening of the channel succeeds? The .open_channel() already receives a
> pointer to the client as parameter, so it doesn't have to be associated
> with the context.

True, we can move the assignment to happen after checking the
open_channel result.

> 
>> +static int tegra_drm_ioctl_get_syncpoint(struct drm_device *drm, void *data,
>> +                                      struct drm_file *file_priv)
>> +{
>> +     struct tegra_drm_get_syncpoint *args = data;
>> +     struct host1x_drm_file *fpriv = file_priv->driver_priv;
>> +     struct host1x_drm_context *context =
>> +             (struct host1x_drm_context *)(uintptr_t)args->context;
>> +
>> +     if (!tegra_drm_get_context(&fpriv->contexts, context))
>> +             return -ENODEV;
>> +
>> +     if (context->client->num_syncpts < args->param)
>> +             return -ENODEV;
> 
> I think this might be easier to read as:
> 
>         if (args->param >= context->client->num_syncpts)
>                 return -ENODEV;

Ok, will do.

> 
>> +     args->value = host1x_syncpt_id(context->client->syncpts[args->param]);
> 
> This could use a temporary variable "syncpt" to make it easier to read.

Ok.

> 
>> +static int tegra_drm_gem_create_ioctl(struct drm_device *drm, void *data,
>> +                                   struct drm_file *file_priv)
> 
> tegra_drm_ioctl_gem_create()?

Sure.

> 
>> +{
>> +     struct tegra_drm_create *args = data;
>> +     struct drm_gem_cma_object *cma_obj;
>> +     struct tegra_drm_bo *cma_bo;
> 
> These can probably just be named "cma"/"gem" and "bo" instead.

Ok.

> 
>> +static int tegra_drm_ioctl_get_offset(struct drm_device *drm, void *data,
>> +                                   struct drm_file *file_priv)
> 
> I think this might be more generically named tegra_drm_ioctl_mmap()
> which might come in handy if we ever need to do something more than just
> retrieve the offset.

Yeah, that changes the API semantics a bit, but in general there
shouldn't be a need to just get the offset without doing the actual mmap.

> 
>> +{
>> +     struct tegra_drm_get_offset *args = data;
>> +     struct drm_gem_cma_object *cma_obj;
>> +     struct drm_gem_object *obj;
>> +
>> +     obj = drm_gem_object_lookup(drm, file_priv, args->handle);
>> +     if (!obj)
>> +             return -EINVAL;
>> +     cma_obj = to_drm_gem_cma_obj(obj);
> 
> The above two lines should be separated by a blank line.

Ok.

> 
>> +
>> +     args->offset = cma_obj->base.map_list.hash.key << PAGE_SHIFT;
> 
> Perhaps a better way would be to export the get_gem_mmap_offset() from
> drivers/gpu/drm/drm_gem_cma_helper.c and reuse that.

Ok, we'll add that as a patch to the series.

> 
>>  static struct drm_ioctl_desc tegra_drm_ioctls[] = {
>> +     DRM_IOCTL_DEF_DRV(TEGRA_DRM_GEM_CREATE,
>> +                     tegra_drm_gem_create_ioctl, DRM_UNLOCKED | DRM_AUTH),
>> +     DRM_IOCTL_DEF_DRV(TEGRA_DRM_SYNCPT_READ,
>> +                     tegra_drm_ioctl_syncpt_read, DRM_UNLOCKED),
>> +     DRM_IOCTL_DEF_DRV(TEGRA_DRM_SYNCPT_INCR,
>> +                     tegra_drm_ioctl_syncpt_incr, DRM_UNLOCKED),
>> +     DRM_IOCTL_DEF_DRV(TEGRA_DRM_SYNCPT_WAIT,
>> +                     tegra_drm_ioctl_syncpt_wait, DRM_UNLOCKED),
>> +     DRM_IOCTL_DEF_DRV(TEGRA_DRM_OPEN_CHANNEL,
>> +                     tegra_drm_ioctl_open_channel, DRM_UNLOCKED),
>> +     DRM_IOCTL_DEF_DRV(TEGRA_DRM_CLOSE_CHANNEL,
>> +                     tegra_drm_ioctl_close_channel, DRM_UNLOCKED),
>> +     DRM_IOCTL_DEF_DRV(TEGRA_DRM_GET_SYNCPOINT,
>> +                     tegra_drm_ioctl_get_syncpoint, DRM_UNLOCKED),
>> +     DRM_IOCTL_DEF_DRV(TEGRA_DRM_SUBMIT,
>> +                     tegra_drm_ioctl_submit, DRM_UNLOCKED),
>> +     DRM_IOCTL_DEF_DRV(TEGRA_DRM_GEM_GET_OFFSET,
>> +                     tegra_drm_ioctl_get_offset, DRM_UNLOCKED),
>>  };
> 
> Maybe resort these to put the GEM-specific IOCTLs closer together?

Ok.

> 
>>  static const struct file_operations tegra_drm_fops = {
>> @@ -345,10 +585,17 @@ static void tegra_drm_disable_vblank(struct drm_device *drm, int pipe)
>>
>>  static void tegra_drm_preclose(struct drm_device *drm, struct drm_file *file)
>>  {
>> +     struct host1x_drm_file *fpriv = file->driver_priv;
>> +     struct host1x_drm_context *context, *tmp;
>>       struct drm_crtc *crtc;
>>
>>       list_for_each_entry(crtc, &drm->mode_config.crtc_list, head)
>>               tegra_dc_cancel_page_flip(crtc, file);
>> +
>> +     list_for_each_entry_safe(context, tmp, &fpriv->contexts, list)
>> +             host1x_drm_context_free(context);
>> +     kfree(fpriv);
> 
> Another missing blank line between these.

Will fix.

> 
>> diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
> [...]
>> +static struct host1x_bo *handle_cma_to_host1x(struct drm_device *drm,
>> +                                           struct drm_file *file_priv,
>> +                                           u32 gem_handle)
>> +{
>> +     struct drm_gem_object *gem_obj;
>> +     struct drm_gem_cma_object *cma_obj;
>> +     struct tegra_drm_bo *cma_bo;
>> +
>> +     gem_obj = drm_gem_object_lookup(drm, file_priv, gem_handle);
>> +     if (!gem_obj)
>> +             return 0;
>> +
>> +     mutex_lock(&drm->struct_mutex);
>> +     drm_gem_object_unreference(gem_obj);
>> +     mutex_unlock(&drm->struct_mutex);
>> +
>> +     cma_obj = to_drm_gem_cma_obj(gem_obj);
>> +     cma_bo = container_of(cma_obj, struct tegra_drm_bo, cma_obj);
>> +
>> +     return &cma_bo->base;
>> +}
> 
> Maybe rename this to host1x_bo_lookup()? *_to_* are usually used for
> up- and downcasting; this function does a lot more.

Yep, will do.

> 
>> +static int gr2d_submit(struct host1x_drm_context *context,
>> +                    struct tegra_drm_submit_args *args,
>> +                    struct drm_device *drm,
>> +                    struct drm_file *file_priv)
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
>> +     struct tegra_drm_syncpt_incr syncpt_incr;
>> +     int err;
>> +
>> +     /* We don't yet support other than one syncpt_incr struct per submit */
>> +     if (args->num_syncpt_incrs != 1)
>> +             return -EINVAL;
>> +
>> +     job = host1x_job_alloc(context->channel, args->num_cmdbufs,
>> +                            args->num_relocs, args->num_waitchks);
>> +     if (!job)
>> +             return -ENOMEM;
>> +
>> +     job->num_relocs = args->num_relocs;
>> +     job->num_waitchk = args->num_waitchks;
>> +     job->client = (u32)args->context;
>> +     job->class = context->client->class;
>> +     job->serialize = true;
>> +
>> +     while (num_cmdbufs) {
>> +             struct tegra_drm_cmdbuf cmdbuf;
>> +             struct host1x_bo *mem_handle;
>> +             err = copy_from_user(&cmdbuf, cmdbufs, sizeof(cmdbuf));
> 
> Could use an blank line to separate variable declarations from the code.
> Also maybe rename mem_handle to bo which is much shorter.

Sure, mem_handle is anyway legacy naming.

> 
>> +             goto fail;
>> +
>> +     err = host1x_job_pin(job, context->client->dev);
>> +     if (err)
>> +             goto fail;
>> +
>> +     err = copy_from_user(&syncpt_incr,
>> +                          (void * __user)(uintptr_t)args->syncpt_incrs,
>> +                          sizeof(syncpt_incr));
>> +     if (err)
>> +             goto fail;
>> +
>> +     job->syncpt_id = syncpt_incr.id;
>> +     job->syncpt_incrs = syncpt_incr.incrs;
>> +     job->timeout = 10000;
>> +     job->is_addr_reg = gr2d_is_addr_reg;
>> +     if (args->timeout && args->timeout < 10000)
> 
> Another missing blank line.
> 
> Also you now create a lookup table (or bitfield actually) as we
> discussed but you still pass around a function to check the lookup table
> against. What I originally intended was to not pass a function around at
> all but directly use the lookup table/bitfield. However I think we can
> leave this as-is for now and change it later if required.

Oops, the intention was to pass the table around, but I and Arto both
missed that. We'll fix that.

> 
>> +static int gr2d_probe(struct platform_device *pdev)
>> +{
>> +     struct device *dev = &pdev->dev;
>> +     struct host1x_drm *host1x = host1x_get_drm_data(dev->parent);
>> +     int err;
>> +     struct gr2d *gr2d = NULL;
>> +     struct host1x_syncpt **syncpts;
> 
> I don't think there's a need for this temporary variable. You could just
> use gr2d->client.syncpts directly.

Ok, it might make a bit longer lines, but it doesn't look too bad.

> 
>> +     gr2d = devm_kzalloc(dev, sizeof(*gr2d), GFP_KERNEL);
>> +     if (!gr2d)
>> +             return -ENOMEM;
>> +
>> +     syncpts = devm_kzalloc(dev, sizeof(*syncpts), GFP_KERNEL);
>> +     if (!syncpts)
>> +             return -ENOMEM;
>> +
>> +     gr2d->clk = devm_clk_get(dev, NULL);
>> +     if (IS_ERR(gr2d->clk)) {
>> +             dev_err(dev, "cannot get clock\n");
>> +             return PTR_ERR(gr2d->clk);
>> +     }
>> +
>> +     err = clk_prepare_enable(gr2d->clk);
>> +     if (err) {
>> +             dev_err(dev, "cannot turn on clock\n");
>> +             return err;
>> +     }
>> +
>> +     gr2d->channel = host1x_channel_alloc(dev);
>> +     if (!gr2d->channel)
>> +             return -ENOMEM;
>> +
>> +     *syncpts = host1x_syncpt_request(dev, 0);
>> +     if (!(*syncpts)) {
>> +             host1x_channel_free(gr2d->channel);
>> +             return -ENOMEM;
>> +     }
>> +
>> +     gr2d->client.ops = &gr2d_client_ops;
>> +     gr2d->client.dev = dev;
>> +     gr2d->client.class = HOST1X_CLASS_GR2D;
>> +     gr2d->client.syncpts = syncpts;
>> +     gr2d->client.num_syncpts = 1;
>> +
>> +     err = host1x_register_client(host1x, &gr2d->client);
>> +     if (err < 0) {
>> +             dev_err(dev, "failed to register host1x client: %d\n", err);
>> +             return err;
>> +     }
>> +
>> +     gr2d_init_addr_reg_map(dev, gr2d);
>> +
>> +     dev_set_drvdata(dev, gr2d);
> 
> Nit: I think it'd be nicer to use platform_set_drvdata() here to mirror
> the platform_get_drvdata() from gr2d_remove().

Yeah, we'll fix that.

> 
>> diff --git a/include/drm/tegra_drm.h b/include/drm/tegra_drm.h
> [...]
>> +struct tegra_drm_create {
> 
> struct tegra_drm_gem_create?

Yep.

> 
>> +     __u64 size;
>> +     u32 flags;
>> +     u32 handle;
>> +     u32 offset;
>> +     u32 padding;
> 
> Also since we have a separate IOCTL for this, I think you can leave out
> the offset field (and also padding since it isn't required anymore).

This is a genuine mistake, offset should've been dropped.

> 
>> +struct tegra_drm_get_offset {
>> +     __u32 handle;
>> +     __u32 offset;
>> +};
> 
> struct tegra_drm_gem_mmap to go along with the name change of the IOCTL.

Ok.

> 
>> +struct tegra_drm_syncpt_incr_args {
>> +     __u32 id;
>> +     __u32 pad;
>> +};
> 
> Shouldn't this second field be something like "value" to allow this
> IOCTL to increment by more than 1?

This is actually an IOCTL that normally shouldn't be used. It's still
there for testing.

The intention with this is that user space can submit a job that waits
for a sync point value. The user space can then investigate the state of
the channel to verify that host1x driver is working correctly. After
investigation, user space can increment the sync point to unblock the
channel.

It's a bit tricky to find out the correct sync point value to wait for,
but for test cases we can usually hack it together by just shutting down
all other users of host1x and reading current value.

>> +#define DRM_TEGRA_NO_TIMEOUT (0xffffffff)
> 
> No need for the parentheses.

Sure, will remove.

> 
>> +struct tegra_drm_reloc {
>> +     __u32 cmdbuf_mem;
>> +     __u32 cmdbuf_offset;
>> +     __u32 target;
>> +     __u32 target_offset;
>> +     __u32 shift;
>> +     __u32 pad;
>> +};
> 
> I've found this to be a little inconsistent. Why does the cmdbuf_mem
> have the _mem suffix, but not the target field? Given that this will
> eventually be used by userspace software once merged it will be fixed
> forever. I had noticed the same for the in-kernel structures but didn't
> think it important enough to hold up the patches. In this case I think
> we should make them consistent, though.

Ok. I propose we rename target to target_mem. We could also rename
tegra_drm_waitchk.mem to cmdbuf_mem and tegra_drm_waitchk.offset to
cmdbuf_offset for consistency.

> 
>> +#define DRM_TEGRA_DRM_GEM_CREATE     0x00
>> +#define DRM_TEGRA_DRM_SYNCPT_READ    0x01
>> +#define DRM_TEGRA_DRM_SYNCPT_INCR    0x02
>> +#define DRM_TEGRA_DRM_SYNCPT_WAIT    0x03
>> +#define DRM_TEGRA_DRM_OPEN_CHANNEL   0x04
>> +#define DRM_TEGRA_DRM_CLOSE_CHANNEL  0x05
>> +#define DRM_TEGRA_DRM_GET_SYNCPOINT  0x06
>> +#define DRM_TEGRA_DRM_SUBMIT         0x08
>> +#define DRM_TEGRA_DRM_GEM_GET_OFFSET 0x09
>> +
>> +#define DRM_IOCTL_TEGRA_DRM_GEM_CREATE DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_GEM_CREATE, struct tegra_drm_create)
>> +#define DRM_IOCTL_TEGRA_DRM_SYNCPT_READ DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_READ, struct tegra_drm_syncpt_read_args)
>> +#define DRM_IOCTL_TEGRA_DRM_SYNCPT_INCR DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_INCR, struct tegra_drm_syncpt_incr_args)
>> +#define DRM_IOCTL_TEGRA_DRM_SYNCPT_WAIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_WAIT, struct tegra_drm_syncpt_wait_args)
>> +#define DRM_IOCTL_TEGRA_DRM_OPEN_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_OPEN_CHANNEL, struct tegra_drm_open_channel_args)
>> +#define DRM_IOCTL_TEGRA_DRM_CLOSE_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_CLOSE_CHANNEL, struct tegra_drm_open_channel_args)
>> +#define DRM_IOCTL_TEGRA_DRM_GET_SYNCPOINT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_GET_SYNCPOINT, struct tegra_drm_get_syncpoint)
>> +#define DRM_IOCTL_TEGRA_DRM_SUBMIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SUBMIT, struct tegra_drm_submit_args)
>> +#define DRM_IOCTL_TEGRA_DRM_GEM_GET_OFFSET DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_GEM_GET_OFFSET, struct tegra_drm_get_offset)
> 
> Same comment regarding reordering and GET_OFFSET -> MMAP rename.

Ok.

Terje
