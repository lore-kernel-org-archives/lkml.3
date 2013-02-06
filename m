Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab3BFVXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:23:33 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16775 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026Ab3BFVXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:23:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 06 Feb 2013 13:21:06 -0800
Message-ID: <5112C9C5.8080205@nvidia.com>
Date: Wed, 6 Feb 2013 13:23:17 -0800
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 8/8] drm: tegra: Add gr2d device
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-9-git-send-email-tbergstrom@nvidia.com> <20130204125618.GD595@avionic-0098.mockup.avionic-design.de> <511095F9.6040607@nvidia.com> <20130205095403.GF20437@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130205095403.GF20437@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.02.2013 01:54, Thierry Reding wrote:
> On Mon, Feb 04, 2013 at 09:17:45PM -0800, Terje Bergström wrote:
>> Yeah, it's actually working around the host1x duplicate naming.
>> host1x_syncpt_get takes struct host1x as parameter, but that's different
>> host1x than in this code.
> 
> So maybe a better way would be to rename the DRM host1x after all. If it
> avoids the need for workarounds such as this I think it justifies the
> additional churn.

Ok, I'll include that. Do you have a preference for the name? Something
like "host1x_drm" might work?

>>> Also, how useful is it to create a context? Looking at the gr2d
>>> implementation for .open_channel(), it will return the same channel to
>>> whichever userspace process requests them. Can you explain why it is
>>> necessary at all? From the name I would have expected some kind of
>>> context switching to take place when different applications submit
>>> requests to the same client, but that doesn't seem to be the case.
>>
>> Hardware context switching will be a later submit, and it'll actually
>> create a new structure. Hardware context might live longer than the
>> process that created it, so they'll need to be separate.
> 
> Why would it live longer than the process? Isn't the whole purpose of
> the context to keep per-process state? What use is that state if the
> process dies?

Hardware context has to be kept alive for as long as there's a job
running from that process. If an app sends 10 jobs to 2D channel, and
dies immediately, there's no sane way for host1x to remove the jobs from
queue. The jobs will keep on running and kernel will need to track them.

>> Perhaps the justification is that this way we can keep the kernel API
>> stable even when we add support for hardware contexts and other clients.
> 
> We don't need a stable kernel API. But I guess it is fine to keep it if
> for no other reason to fill the context returned in the ioctl() with
> meaningful data.

Sorry, I meant stable IOCTL API, so we agree on this.

>> host1x_drm_file sounds a bit odd, because it's not really a file, but a
>> private data pointer stored in driver_priv.
> 
> The same is true for struct drm_file, which is stored in struct file's
> .private_data field. I find it to be very intuitive if the inheritance
> is reflected in the structure name. struct host1x_drm_file is host1x'
> driver-specific part of struct drm_file.

Ok, makes sense. I'll do that.

> I fail to see how dma_buf would require a separate mem_mgr_type. Can we
> perhaps postpone this to a later point and just go with CMA as the only
> alternative for now until we have an actual working implementation that
> we can use this for?

Each submit refers to a number of buffers. Some of them are the streams,
some are textures or other input/output buffers. Each of these buffers
might be passed as a GEM handle, or (when implemented) as a dma_buf fd.
Thus we need a field to tell host1x which API to call to handle that handle.

I think we can leave out the code for managing the type until we
actually have separate memory managers. That'd make GEM handles
effectively of type 0, as we don't set it.

> 
>>>> +static int gr2d_submit(struct host1x_drm_context *context,
>>>> +             struct tegra_drm_submit_args *args,
>>>> +             struct drm_device *drm,
>>>> +             struct drm_file *file_priv)
>>>> +{
>>>> +     struct host1x_job *job;
>>>> +     int num_cmdbufs = args->num_cmdbufs;
>>>> +     int num_relocs = args->num_relocs;
>>>> +     int num_waitchks = args->num_waitchks;
>>>> +     struct tegra_drm_cmdbuf __user *cmdbufs =
>>>> +             (void * __user)(uintptr_t)args->cmdbufs;
>>>> +     struct tegra_drm_reloc __user *relocs =
>>>> +             (void * __user)(uintptr_t)args->relocs;
>>>> +     struct tegra_drm_waitchk __user *waitchks =
>>>> +             (void * __user)(uintptr_t)args->waitchks;
>>>
>>> No need for all the uintptr_t casts.
>>
>> Will try to remove - but I do remember getting compiler warnings without
>> them.
> 
> I think you shouldn't even have to cast to void * first. Just cast to
> the target type directly. I don't see why the compiler should complain.

This is what I get without them:

drivers/gpu/host1x/drm/gr2d.c:108:3: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/gpu/host1x/drm/gr2d.c:110:3: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]
drivers/gpu/host1x/drm/gr2d.c:112:3: warning: cast to pointer from
integer of different size [-Wint-to-pointer-c

The problem is that the fields are __u64's and can't be cast directly
into 32-bit pointers.

>> That's the security firewall. It walks through each submit, and ensures
>> that each register write that writes an address, goes through the host1x
>> reloc mechanism. This way user space cannot ask 2D to write to arbitrary
>> memory locations.
> 
> I see. Can this be made more generic? Perhaps adding a table of valid
> registers to the device and use a generic function to iterate over that
> instead of having to provide the same function for each client.

For which one does gcc generate more efficient code? I've thought a
switch-case statement might get compiled into something more efficient
than a table lookup.

But the rest of the code is generic - just the one function which
compares against known address registers is specific to 2D.

>>>> +static int __exit gr2d_remove(struct platform_device *dev)
>>>> +{
>>>> +     struct host1x *host1x =
>>>> +             host1x_get_drm_data(to_platform_device(dev->dev.parent));
>>>> +     struct gr2d *gr2d = platform_get_drvdata(dev);
>>>> +     int err;
>>>> +
>>>> +     err = host1x_unregister_client(host1x, &gr2d->client);
>>>> +     if (err < 0) {
>>>> +             dev_err(&dev->dev, "failed to unregister host1x client: %d\n",
>>>> +                     err);
>>>> +             return err;
>>>> +     }
>>>> +
>>>> +     host1x_syncpt_free(gr2d->syncpt);
>>>> +     return 0;
>>>> +}
>>>
>>> Isn't this missing a host1x_channel_put() or host1x_free_channel()?
>>
>> All references should be handled in gr2d_open_channel() and
>> gr2d_close_channel(). I think we'd need to ensure all contexts are
>> closed at this point.
> 
> Yes, that'd work as well. Actually I would assume that all contexts
> associated with a given file should be freed when the file is closed.
> That way all of this should work pretty much automatically.

Naturally they are, so we're actually already good. All contexts get
closed at file close.

> For timeout == 0 I don't think we need a symbolic name. It is pretty
> common for 0 to mean no timeout. But yes, DRM_TEGRA_INFINITE_TIMEOUT
> should be okay.

Ok, will do that.

>>>> +struct tegra_drm_syncpt_incr {
>>>> +     __u32 syncpt_id;
>>>> +     __u32 syncpt_incrs;
>>>> +};
>>>
>>> Maybe the fields would be better named id and incrs. Though I also
>>> notice that incrs is never used. I guess that's supposed to be used in
>>> the future to allow increments by more than a single value. If so,
>>> perhaps value would be a better name.
>>
>> It's actually used in the dreaded patch 3, as part of tegra_drm_submit_args.
> 
> Okay. The superfluous syncpt_ prefixes should still go away.

Sure, forgot to comment, but I'm fine with that.

Terje
