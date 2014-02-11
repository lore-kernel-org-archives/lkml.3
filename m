Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbaBKGSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:18:36 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:59388 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaBKGSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:18:33 -0500
MIME-Version: 1.0
In-Reply-To: <20140210115055.GC20143@ulmo.nvidia.com>
References: <1392011580-28093-1-git-send-email-acourbot@nvidia.com> <20140210115055.GC20143@ulmo.nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 11 Feb 2014 15:18:00 +0900
Message-ID: <CAAVeFuJaD1C7yPRGm3+hByLDuSiBhftehcbwFfrbLaYsAwRcZQ@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH] drm/nouveau: support for platform devices
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, David Airlie <airlied@linux.ie>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 8:50 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Feb 10, 2014 at 02:53:00PM +0900, Alexandre Courbot wrote:
> [...]
>> diff --git a/drivers/gpu/drm/nouveau/core/engine/device/base.c b/drivers/gpu/drm/nouveau/core/engine/device/base.c
> [...]
>> +resource_size_t
>> +nv_device_resource_start(struct nouveau_device *device, unsigned int bar)
>> +{
>> +     if (nv_device_is_pci(device)) {
>> +             return pci_resource_start(device->pdev, bar);
>> +     } else {
>> +             struct resource *res;
>> +             res = platform_get_resource(device->platformdev,
>> +                                         IORESOURCE_MEM, bar);
>> +             if (!res)
>> +                     return 0;
>> +             return res->start;
>> +     }
>> +}
>> +
>> +resource_size_t
>> +nv_device_resource_len(struct nouveau_device *device, unsigned int bar)
>> +{
>> +     if (nv_device_is_pci(device)) {
>> +             return pci_resource_len(device->pdev, bar);
>> +     } else {
>> +             struct resource *res;
>> +             res = platform_get_resource(device->platformdev,
>> +                                         IORESOURCE_MEM, bar);
>> +             if (!res)
>> +                     return 0;
>> +             return resource_size(res);
>> +     }
>> +}
>
> Perhaps instead of these two, something like this could be done:
>
>         const struct resource *
>         nv_device_resource(struct nouveau_device *device, unsigned int bar)
>         {
>                 if (nv_device_is_pci(device)
>                         return &device->pdev->resource[bar];
>                 else
>                         return platform_get_resource(device->platformdev,
>                                                      IORESOURCE_MEM, bar);
>         }
>
> Then the more generic resource_size() can be used directly on the
> returned struct resource *. Doing so may come in handy if you ever need
> to display the resource for debugging purposes, since you could simply
> use the %pR format specifier. It could also be slightly more efficient,
> since the structure doesn't have to be looked up twice. But perhaps the
> compiler will be clever enough to optimize that away and it's not like
> this is called from a hot path.

I would agree with returning raw resource * if some of the consumer
code did make use of struct resource * directly, but AFAICT this is
not the case at all. So I thought we would better continue providing
exactly what the code needs, instead of forcing it to dererence the
resource itself. Also by doing so we might return NULL pointers in
some code paths that do not check whether a resource is valid or not
(granted, returning 0 would probably only make the code crash later).

>
> I do see that pci_resource_len() does additional checking for BARs that
> have zero size (start == 0 && end == start), so it's not exactly the
> same, but I think there's another issue with that, see below.
>
>> +int
>> +nouveau_device_platform_create_(struct platform_device *pdev, u64 name,
>> +                             const char *sname, const char *cfg,
>> +                             const char *dbg, int length, void **pobject)
>> +{
>> +     struct nouveau_device *device;
>> +     int ret = -EEXIST;
>> +
>> +     mutex_lock(&nv_devices_mutex);
>> +     list_for_each_entry(device, &nv_devices, head) {
>> +             if (device->handle == name)
>> +                     goto done;
>> +     }
>> +
>> +     ret = nouveau_engine_create_(NULL, NULL, &nouveau_device_oclass, true,
>> +                                  "DEVICE", "device", length, pobject);
>> +     device = *pobject;
>> +     if (ret)
>> +             goto done;
>> +
>> +     device->platformdev = pdev;
>> +     device->handle = name;
>> +     device->cfgopt = cfg;
>> +     device->dbgopt = dbg;
>> +     device->name = sname;
>> +
>> +     nv_subdev(device)->debug = nouveau_dbgopt(device->dbgopt, "DEVICE");
>> +     nv_engine(device)->sclass = nouveau_device_sclass;
>> +     list_add(&device->head, &nv_devices);
>> +done:
>> +     mutex_unlock(&nv_devices_mutex);
>> +     return ret;
>> +}
>
> I think there's some potential for refactoring here, since the only
> difference that I can spot is in whether the pdev or the platformdev
> fields are assigned.

That's true. Actually I wonder if it would not make more sense for
nouveau_device_platform_create_() to take a void pointer and a type
saying whether the device is PCI or platform, otherwise we will end up
duplicating the mutex code in two functions, ending up with even more
code than my current version.

>
>> diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nv20.c b/drivers/gpu/drm/nouveau/core/engine/graph/nv20.c
>> index b24559315903..d145e080899a 100644
>> --- a/drivers/gpu/drm/nouveau/core/engine/graph/nv20.c
>> +++ b/drivers/gpu/drm/nouveau/core/engine/graph/nv20.c
>> @@ -349,7 +349,7 @@ nv20_graph_init(struct nouveau_object *object)
>>       nv_wr32(priv, NV10_PGRAPH_SURFACE, tmp);
>>
>>       /* begin RAM config */
>> -     vramsz = pci_resource_len(nv_device(priv)->pdev, 0) - 1;
>> +     vramsz = nv_device_resource_len(nv_device(priv), 0) - 1;
>
> In case BAR0 is of size zero (start == 0, end == start), this will cause
> underflow in the case of a PCI device, because pci_resource_len() will
> return 0. I suspect that this never happens since that code's been there
> since the dawn of time.

Yes, I guess for particular chips it is ok to make assumptions such as
the presence of a given BAR that are, anyway, properties inherent to
that chip.

>> diff --git a/drivers/gpu/drm/nouveau/core/include/core/device.h b/drivers/gpu/drm/nouveau/core/include/core/device.h
>> index 7b8ea221b00d..2a3e24e1d392 100644
>> --- a/drivers/gpu/drm/nouveau/core/include/core/device.h
>> +++ b/drivers/gpu/drm/nouveau/core/include/core/device.h
>> @@ -65,6 +65,7 @@ struct nouveau_device {
>>       struct list_head head;
>>
>>       struct pci_dev *pdev;
>> +     struct platform_device *platformdev;
>
> I'm generally wondering if perhaps a better abstraction would be to
> store a struct device * here, perhaps with a struct nouveau_device_ops *
> or similar to abstract away the differences between PCI and platform
> devices.
>
> nouveau_device_create_() could then take a struct device * and a struct
> nouveau_device_ops *, and upcasting can therefore be done within these
> operations, rather than sprinkling nv_device_is_pci() code everywhere.

At some point I was considering having the bus abstracted as a subdev,
but that sounded overkill. :) A nouveau_device_ops * would provide a
nicer abstraction, but at the end of the day we would still be calling
accessor functions on a nouveau_device * and this would not change
much for consumer code. It would also deprive PCI-dependent code
(there is still a bunch) of a convenient way to access the pci_dev *
since it would need to be upcasted. And the only place where this
would remove nv_device_is_pci() is device/base.c.

IMHO the current situation is still sustainable for two buses. If we
had three or more, I'd go for the nouveau_device_ops * solution
though.

>
>> diff --git a/drivers/gpu/drm/nouveau/nouveau_abi16.c b/drivers/gpu/drm/nouveau/nouveau_abi16.c
> [...]
>>       case NOUVEAU_GETPARAM_BUS_TYPE:
>> +             if (!nv_device_is_pci(device))
>> +                     getparam->value = 3;
>> +             else
>>               if (drm_pci_device_is_agp(dev))
>>                       getparam->value = 0;
>>               else
>
> This is more of a general note since this patch doesn't introduce the
> parameter. Perhaps it would be good to expose a symbolic name for the
> various types of busses in a public header?

Maybe as a separate patch, yes. Also the value of "3" for non-PCI
devices is completely arbitrary.

>
>> diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.c b/drivers/gpu/drm/nouveau/nouveau_chan.c
>> index cc5152be2cf1..19c6e6c9fc45 100644
>> --- a/drivers/gpu/drm/nouveau/nouveau_chan.c
>> +++ b/drivers/gpu/drm/nouveau/nouveau_chan.c
>> @@ -154,7 +154,7 @@ nouveau_channel_prep(struct nouveau_drm *drm, struct nouveau_cli *cli,
>>                        * nfi why this exists, it came from the -nv ddx.
>>                        */
>>                       args.flags = NV_DMA_TARGET_PCI | NV_DMA_ACCESS_RDWR;
>> -                     args.start = pci_resource_start(device->pdev, 1);
>> +                     args.start = nv_device_resource_len(device, 1);
>
> Should this have been nv_device_resource_start()?

Absolutely. Thanks.

>
>> diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
> [...]
>> @@ -345,7 +368,7 @@ nouveau_drm_load(struct drm_device *dev, unsigned long flags)
>>       /* make sure AGP controller is in a consistent state before we
>>        * (possibly) execute vbios init tables (see nouveau_agp.h)
>>        */
>> -     if (drm_pci_device_is_agp(dev) && dev->agp) {
>> +     if (pdev && drm_pci_device_is_agp(dev) && dev->agp) {
>
> Perhaps move the check for valid PCI device into drm_pci_device_is_agp()
> rather than requiring callers to check explicitly?

I *think* drm_pci_device_is_agp() assumes a PCI device on purpose and
that the burden of checking is on the caller. Changing this behavior
would imply doing the same on many other functions of drmP.h.

>
>> @@ -384,8 +407,10 @@ nouveau_drm_load(struct drm_device *dev, unsigned long flags)
>>       if (nv_device(drm->device)->chipset == 0xc1)
>>               nv_mask(device, 0x00088080, 0x00000800, 0x00000000);
>>
>> -     nouveau_vga_init(drm);
>> -     nouveau_agp_init(drm);
>> +     if (pdev) {
>> +             nouveau_vga_init(drm);
>> +             nouveau_agp_init(drm);
>> +     }
>
> Same here. And if you make the above change, then nouveau_agp_init()
> will do the right thing already.

Indeed, we can probably check drm_device::pdev in the functions themselves.

>
>>       if (device->card_type >= NV_50) {
>>               ret = nouveau_vm_new(nv_device(drm->device), 0, (1ULL << 40),
>> @@ -398,9 +423,11 @@ nouveau_drm_load(struct drm_device *dev, unsigned long flags)
>>       if (ret)
>>               goto fail_ttm;
>>
>> -     ret = nouveau_bios_init(dev);
>> -     if (ret)
>> -             goto fail_bios;
>> +     if (pdev) {
>> +             ret = nouveau_bios_init(dev);
>> +             if (ret)
>> +                     goto fail_bios;
>> +     }
>
> nouveau_bios_init() could also check internally and return 0 if the
> device isn't a PCI device. One less conditional in this function.

Agreed.

>
>> @@ -963,6 +991,25 @@ nouveau_drm_pci_driver = {
>>       .driver.pm = &nouveau_pm_ops,
>>  };
>>
>> +
>
> This adds a spurious newline.

Removed.

>
>> +int nouveau_drm_platform_probe(struct platform_device *pdev)
>> +{
>> +     struct nouveau_device *device;
>> +     int ret;
>> +
>> +     ret = nouveau_device_platform_create(pdev, nouveau_platform_name(pdev),
>> +                                        dev_name(&pdev->dev), nouveau_config,
>> +                                        nouveau_debug, &device);
>> +
>> +     ret = drm_platform_init(&driver, pdev);
>> +     if (ret) {
>> +             nouveau_object_ref(NULL, (struct nouveau_object **)&device);
>> +             return ret;
>> +     }
>> +
>> +     return ret;
>> +}
>
> I think we should move the whole of gk20a probing into nouveau. Keeping
> one part in tegra-drm and one part in nouveau is confusing, and I can't
> see a reason why we'd have to keep it that way.

Yes, the current probing scheme is definitely not what we want.
However since some clocks probably need to be enabled before GK20A's
registers (including BOOT0) can be read, this will probably require
some more changes which we need to think about, and is not directly
within the scope of this patch.

Thanks for the review! I will post a v2 tomorrow.
Alex.
