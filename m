Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaBAX6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 18:58:34 -0500
Received: from ns.lynxeye.de ([87.118.118.114]:50087 "EHLO lynxeye.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750879AbaBAX6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 18:58:32 -0500
Message-ID: <1391299106.2985.3.camel@antimon.intern.lynxeye.de>
Subject: Re: [RFC 14/16] drm/nouveau/fb: add GK20A support
From: Lucas Stach <dev@lynxeye.de>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        gnurou@gmail.com, Eric Brower <ebrower@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-tegra@vger.kernel.org, Terje Bergstrom <tbergstrom@nvidia.com>,
        Ken Adams <KAdams@nvidia.com>
Date: Sun, 02 Feb 2014 00:58:26 +0100
In-Reply-To: <CAKb7UvhJWOtxzYMViuoV6fHU4UR_+j1QTKHw1PoQT_+ykenfYw@mail.gmail.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
	 <1391224618-3794-15-git-send-email-acourbot@nvidia.com>
	 <1391262057.2035.7.camel@antimon.intern.lynxeye.de>
	 <CAKb7UvhJWOtxzYMViuoV6fHU4UR_+j1QTKHw1PoQT_+ykenfYw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 01.02.2014, 18:28 -0500 schrieb Ilia Mirkin:
> On Sat, Feb 1, 2014 at 8:40 AM, Lucas Stach <dev@lynxeye.de> wrote:
> > Am Samstag, den 01.02.2014, 12:16 +0900 schrieb Alexandre Courbot:
> >> Add a clumsy-but-working FB support for GK20A. This chip only uses system
> >> memory, so we allocate a big chunk using CMA and let the existing memory
> >> managers work on it.
> >>
> >> A better future design would be to allocate objects directly from system
> >> memory without having to suffer from the limitations of a large,
> >> contiguous pool.
> >>
> > I don't know if Tegra124 is similar to 114 in this regard [hint: get the
> > TRM out :)], but if you go for a dedicated VRAM allocator, wouldn't it
> > make sense to take a chunk of the MMIO overlaid memory for this when
> > possible, rather than carving this out of CPU accessible mem?
> 
> This is probably a stupid question... what do you need VRAM for
> anyways? In _theory_ it's an abstraction to talk about memory that's
> not accessible by the CPU. This is obviously not the case here, and
> presumably the GPU can access all the memory in the system, so it can
> be all treated as "GART" memory... AFAIK all accesses are behind the
> in-GPU MMU, so contiguous physical memory isn't an issue either. In
> practice, I suspect nouveau automatically sticks certain things into
> vram (gpuobj's), but it should be feasible to make them optionally use
> GART memory when VRAM is not available. I haven't really looked at the
> details though, perhaps that's a major undertaking.
> 
>   -ilia
> 
If it's similar to the Tegar114 there actually is memory that isn't
accessible from the CPU. About 2GB of the address space is overlaid with
MMIO for the devices, so in a 4GB system you potentially have 2GB of RAM
that's only visible for the devices.

But yes in general nouveau should just fall back to a GART placement if
VRAM isn't available.

> >
> >> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> >> ---
> >>  drivers/gpu/drm/nouveau/Makefile                 |  2 +
> >>  drivers/gpu/drm/nouveau/core/include/subdev/fb.h |  1 +
> >>  drivers/gpu/drm/nouveau/core/subdev/fb/nvea.c    | 28 ++++++++++
> >>  drivers/gpu/drm/nouveau/core/subdev/fb/priv.h    |  1 +
> >>  drivers/gpu/drm/nouveau/core/subdev/fb/ramnvea.c | 67 ++++++++++++++++++++++++
> >>  5 files changed, 99 insertions(+)
> >>  create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nvea.c
> >>  create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvea.c
> >>
> >> diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Makefile
> >> index 3548fcd..d9fe3e6 100644
> >> --- a/drivers/gpu/drm/nouveau/Makefile
> >> +++ b/drivers/gpu/drm/nouveau/Makefile
> >> @@ -100,6 +100,7 @@ nouveau-y += core/subdev/fb/nvaa.o
> >>  nouveau-y += core/subdev/fb/nvaf.o
> >>  nouveau-y += core/subdev/fb/nvc0.o
> >>  nouveau-y += core/subdev/fb/nve0.o
> >> +nouveau-y += core/subdev/fb/nvea.o
> >>  nouveau-y += core/subdev/fb/ramnv04.o
> >>  nouveau-y += core/subdev/fb/ramnv10.o
> >>  nouveau-y += core/subdev/fb/ramnv1a.o
> >> @@ -114,6 +115,7 @@ nouveau-y += core/subdev/fb/ramnva3.o
> >>  nouveau-y += core/subdev/fb/ramnvaa.o
> >>  nouveau-y += core/subdev/fb/ramnvc0.o
> >>  nouveau-y += core/subdev/fb/ramnve0.o
> >> +nouveau-y += core/subdev/fb/ramnvea.o
> >>  nouveau-y += core/subdev/fb/sddr3.o
> >>  nouveau-y += core/subdev/fb/gddr5.o
> >>  nouveau-y += core/subdev/gpio/base.o
> >> diff --git a/drivers/gpu/drm/nouveau/core/include/subdev/fb.h b/drivers/gpu/drm/nouveau/core/include/subdev/fb.h
> >> index d7ecafb..3905816 100644
> >> --- a/drivers/gpu/drm/nouveau/core/include/subdev/fb.h
> >> +++ b/drivers/gpu/drm/nouveau/core/include/subdev/fb.h
> >> @@ -105,6 +105,7 @@ extern struct nouveau_oclass *nvaa_fb_oclass;
> >>  extern struct nouveau_oclass *nvaf_fb_oclass;
> >>  extern struct nouveau_oclass *nvc0_fb_oclass;
> >>  extern struct nouveau_oclass *nve0_fb_oclass;
> >> +extern struct nouveau_oclass *nvea_fb_oclass;
> >>
> >>  #include <subdev/bios/ramcfg.h>
> >>
> >> diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/nvea.c b/drivers/gpu/drm/nouveau/core/subdev/fb/nvea.c
> >> new file mode 100644
> >> index 0000000..5ff6029
> >> --- /dev/null
> >> +++ b/drivers/gpu/drm/nouveau/core/subdev/fb/nvea.c
> >> @@ -0,0 +1,28 @@
> >> +/*
> >> + * Copyright (c) 2014, NVIDIA Corporation. All rights reserved.
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify it
> >> + * under the terms and conditions of the GNU General Public License,
> >> + * version 2, as published by the Free Software Foundation.
> >> + *
> >> + * This program is distributed in the hope it will be useful, but WITHOUT
> >> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> >> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> >> + * more details.
> >> + *
> >> + */
> >> +
> >> +#include "nvc0.h"
> >> +
> >> +struct nouveau_oclass *
> >> +nvea_fb_oclass = &(struct nouveau_fb_impl) {
> >> +     .base.handle = NV_SUBDEV(FB, 0xea),
> >> +     .base.ofuncs = &(struct nouveau_ofuncs) {
> >> +             .ctor = nvc0_fb_ctor,
> >> +             .dtor = nvc0_fb_dtor,
> >> +             .init = nvc0_fb_init,
> >> +             .fini = _nouveau_fb_fini,
> >> +     },
> >> +     .memtype = nvc0_fb_memtype_valid,
> >> +     .ram = &nvea_ram_oclass,
> >> +}.base;
> >> diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/priv.h b/drivers/gpu/drm/nouveau/core/subdev/fb/priv.h
> >> index edaf95d..0b95a25 100644
> >> --- a/drivers/gpu/drm/nouveau/core/subdev/fb/priv.h
> >> +++ b/drivers/gpu/drm/nouveau/core/subdev/fb/priv.h
> >> @@ -32,6 +32,7 @@ extern struct nouveau_oclass nva3_ram_oclass;
> >>  extern struct nouveau_oclass nvaa_ram_oclass;
> >>  extern struct nouveau_oclass nvc0_ram_oclass;
> >>  extern struct nouveau_oclass nve0_ram_oclass;
> >> +extern struct nouveau_oclass nvea_ram_oclass;
> >>
> >>  int nouveau_sddr3_calc(struct nouveau_ram *ram);
> >>  int nouveau_gddr5_calc(struct nouveau_ram *ram, bool nuts);
> >> diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/ramnvea.c b/drivers/gpu/drm/nouveau/core/subdev/fb/ramnvea.c
> >> new file mode 100644
> >> index 0000000..3038e08
> >> --- /dev/null
> >> +++ b/drivers/gpu/drm/nouveau/core/subdev/fb/ramnvea.c
> >> @@ -0,0 +1,67 @@
> >> +/*
> >> + * Copyright (c) 2014, NVIDIA Corporation. All rights reserved.
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify it
> >> + * under the terms and conditions of the GNU General Public License,
> >> + * version 2, as published by the Free Software Foundation.
> >> + *
> >> + * This program is distributed in the hope it will be useful, but WITHOUT
> >> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> >> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> >> + * more details.
> >> + *
> >> + */
> >> +
> >> +/*
> >> + * TODO replace this CMA-requiring horror with a proper allocator for GPU
> >> + * objects in main memory. But for the moment it does the job and can reuse some
> >> + * of the nvc0 functions.
> >> + */
> >> +
> >> +#include "nvc0.h"
> >> +
> >> +#include <linux/dma-mapping.h>
> >> +
> >> +static int
> >> +nvea_ram_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
> >> +           struct nouveau_oclass *oclass, void *data, u32 datasize,
> >> +           struct nouveau_object **pobject)
> >> +{
> >> +     struct nouveau_fb *pfb = nouveau_fb(parent);
> >> +     struct nouveau_ram *ram;
> >> +     void *vram;
> >> +     dma_addr_t dma_handle;
> >> +     int ret;
> >> +
> >> +     ret = nouveau_ram_create(parent, engine, oclass, &ram);
> >> +     *pobject = nv_object(ram);
> >> +     if (ret)
> >> +             return ret;
> >> +
> >> +     ram->type   = NV_MEM_TYPE_STOLEN;
> >> +     /* Use a fixed size of 64MB for now */
> >> +     ram->size = 0x4000000;
> >> +     ram->stolen = (u64)0x00000000;
> >> +     vram = dma_alloc_coherent(nv_device_base(nv_device(parent)), ram->size,
> >> +                               &dma_handle, GFP_KERNEL);
> >> +     if (!vram)
> >> +             return -ENOMEM;
> >> +
> >> +     ret = nouveau_mm_init(&pfb->vram, dma_handle >> 12, ram->size >> 12, 1);
> >> +     if (ret)
> >> +             return ret;
> >> +
> >> +     ram->get = nvc0_ram_get;
> >> +     ram->put = nvc0_ram_put;
> >> +     return 0;
> >> +}
> >> +
> >> +struct nouveau_oclass
> >> +nvea_ram_oclass = {
> >> +     .ofuncs = &(struct nouveau_ofuncs) {
> >> +             .ctor = nvea_ram_ctor,
> >> +             .dtor = _nouveau_ram_dtor,
> >> +             .init = _nouveau_ram_init,
> >> +             .fini = _nouveau_ram_fini,
> >> +     },
> >> +};
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


