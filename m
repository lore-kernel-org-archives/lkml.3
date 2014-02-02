Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaBBJiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 04:38:54 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:36107 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaBBJiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 04:38:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAKb7Uvh7QTn1m0N6ynVxVup9VdA9y7fKJ66nwUDMiy6aHz+_Uw@mail.gmail.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
 <1391224618-3794-14-git-send-email-acourbot@nvidia.com> <CAKb7Uvh7QTn1m0N6ynVxVup9VdA9y7fKJ66nwUDMiy6aHz+_Uw@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 2 Feb 2014 18:38:30 +0900
Message-ID: <CAAVeFuK7r4=7qZYSGR9tQQe=Z1_zk+cx+1efgjQ=12TEEq8+Og@mail.gmail.com>
Subject: Re: [RFC 13/16] drm/nouveau/ibus: add GK20A support
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Eric Brower <ebrower@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 2, 2014 at 3:35 PM, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
> Some very trivial comments below:
>
> On Fri, Jan 31, 2014 at 10:16 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> Add support for initializing the priv ring of GK20A. This is done by the
>> BIOS on desktop GPUs, but needs to be done by hand on Tegra.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>  drivers/gpu/drm/nouveau/Makefile                   |   1 +
>>  drivers/gpu/drm/nouveau/core/include/subdev/ibus.h |   1 +
>>  drivers/gpu/drm/nouveau/core/subdev/ibus/nvea.c    | 108 +++++++++++++++++++++
>>  3 files changed, 110 insertions(+)
>>  create mode 100644 drivers/gpu/drm/nouveau/core/subdev/ibus/nvea.c
>>
>> diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Makefile
>> index 6c4b76d..3548fcd 100644
>> --- a/drivers/gpu/drm/nouveau/Makefile
>> +++ b/drivers/gpu/drm/nouveau/Makefile
>> @@ -132,6 +132,7 @@ nouveau-y += core/subdev/i2c/nv94.o
>>  nouveau-y += core/subdev/i2c/nvd0.o
>>  nouveau-y += core/subdev/ibus/nvc0.o
>>  nouveau-y += core/subdev/ibus/nve0.o
>> +nouveau-y += core/subdev/ibus/nvea.o
>>  nouveau-y += core/subdev/instmem/base.o
>>  nouveau-y += core/subdev/instmem/nv04.o
>>  nouveau-y += core/subdev/instmem/nv40.o
>> diff --git a/drivers/gpu/drm/nouveau/core/include/subdev/ibus.h b/drivers/gpu/drm/nouveau/core/include/subdev/ibus.h
>> index 88814f1..056a42f 100644
>> --- a/drivers/gpu/drm/nouveau/core/include/subdev/ibus.h
>> +++ b/drivers/gpu/drm/nouveau/core/include/subdev/ibus.h
>> @@ -30,5 +30,6 @@ nouveau_ibus(void *obj)
>>
>>  extern struct nouveau_oclass nvc0_ibus_oclass;
>>  extern struct nouveau_oclass nve0_ibus_oclass;
>> +extern struct nouveau_oclass nvea_ibus_oclass;
>>
>>  #endif
>> diff --git a/drivers/gpu/drm/nouveau/core/subdev/ibus/nvea.c b/drivers/gpu/drm/nouveau/core/subdev/ibus/nvea.c
>> new file mode 100644
>> index 0000000..0bcd281
>> --- /dev/null
>> +++ b/drivers/gpu/drm/nouveau/core/subdev/ibus/nvea.c
>> @@ -0,0 +1,108 @@
>> +/*
>> + * Copyright (c) 2014, NVIDIA Corporation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + */
>> +
>> +#include <subdev/ibus.h>
>> +
>> +struct nvea_ibus_priv {
>> +       struct nouveau_ibus base;
>> +};
>> +
>> +static void
>> +nvea_ibus_init_priv_ring(struct nvea_ibus_priv *priv)
>> +{
>> +       u32 data;
>> +
>> +       data = nv_rd32(priv, 0x137250);
>> +       data &= (~0x3f);
>> +       nv_wr32(priv, 0x137250, data);
>
> nv_mask(priv, 0x137250, 0x3f, 0) should do this, right?
>
>> +
>> +       nv_mask(priv, 0x000200, 0x20, 0);
>> +       udelay(20);
>> +       nv_mask(priv, 0x000200, 0x20, 0x20);
>> +
>> +       nv_wr32(priv, 0x12004c, 0x4);
>> +       nv_wr32(priv, 0x122204, 0x2);
>> +       nv_rd32(priv, 0x122204);
>> +}
>> +
>> +static void
>> +nvea_ibus_intr(struct nouveau_subdev *subdev)
>> +{
>> +       struct nvea_ibus_priv *priv = (void *)subdev;
>> +       u32 status0 = nv_rd32(priv, 0x120058);
>> +       s32 retry = 100;
>> +       u32 command;
>> +
>> +       if (status0 & 0x7) {
>> +               nv_debug(priv, "resetting priv ring\n");
>> +               nvea_ibus_init_priv_ring(priv);
>> +       }
>> +
>> +       /* Acknowledge interrupt */
>> +       command = nv_rd32(priv, 0x0012004c);
>> +       command |= 0x2;
>> +       nv_wr32(priv, 0x0012004c, command);
>
> nv_mask(priv, 0x12004c, 0x2, 0x2)

Absolutely correct for both.

>> +
>> +       while (--retry >= 0) {
>> +               command = nv_rd32(priv, 0x12004c) & 0x3f;
>> +               if (command == 0)
>> +                       break;
>> +       }
>> +
>> +       if (retry < 0)
>> +               nv_debug(priv, "timeout waiting for ringmaster ack\n");
>
> this sounds kinda bad, no? perhaps a nv_warn?

Sounds more adequate indeed.

Thanks,
Alex.
