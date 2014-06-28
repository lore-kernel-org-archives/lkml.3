Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbaF1A5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 20:57:03 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:57668 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaF1A5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 20:57:00 -0400
MIME-Version: 1.0
In-Reply-To: <CFD332E4.8F1A4%kadams@nvidia.com>
References: <1403869014-16209-1-git-send-email-acourbot@nvidia.com>
	<CFD332E4.8F1A4%kadams@nvidia.com>
Date: Sat, 28 Jun 2014 10:56:59 +1000
Message-ID: <CACAvsv61HW-7ySzTcFCtZNZ7g-NvmxjKNMWAs=bvfjaL6BL0AQ@mail.gmail.com>
Subject: Re: [PATCH v2] drm/gk20a: add BAR instance
From: Ben Skeggs <skeggsb@gmail.com>
To: Ken Adams <KAdams@nvidia.com>
Cc: Alex Courbot <acourbot@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 4:51 AM, Ken Adams <KAdams@nvidia.com> wrote:
> quick note re: tegra and gpu bars...
>
> to this point we've explicitly avoided providing user-mode mappings due to
> power management issues, etc.
> looks to me like this would allow such mappings.  is that the case?  are
> there any paths which would require such mappings to function properly?
What power management issues are you worried about in particular?  We
have these concerns on discrete cards too, when doing things like
changing vram frequencies.  TTM is able to kick out all userspace
mappings, and clients will then block in the fault handler until it's
safe - if they touch the mappings.

Ben.

>
> thanks
> ---
> ken
>
> p.s.: hello :)
>
> On 6/27/14 7:36 AM, "Alex Courbot" <acourbot@nvidia.com> wrote:
>
>>GK20A's BAR is functionally identical to NVC0's, but do not support
>>being ioremapped write-combined. Create a BAR instance for GK20A that
>>reflect that state.
>>
>>Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>---
>>Changes since v1:
>>- Fix compilation warning due to missing cast
>>
>>Patch 1 of the series was ok and thus has not been resent.
>>
>> drivers/gpu/drm/nouveau/Makefile                  |  1 +
>> drivers/gpu/drm/nouveau/core/engine/device/nve0.c |  2 +-
>> drivers/gpu/drm/nouveau/core/include/subdev/bar.h |  1 +
>> drivers/gpu/drm/nouveau/core/subdev/bar/gk20a.c   | 54
>>+++++++++++++++++++++++
>> drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c    |  6 +--
>> drivers/gpu/drm/nouveau/core/subdev/bar/priv.h    |  6 +++
>> 6 files changed, 66 insertions(+), 4 deletions(-)
>> create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bar/gk20a.c
>>
>>diff --git a/drivers/gpu/drm/nouveau/Makefile
>>b/drivers/gpu/drm/nouveau/Makefile
>>index 8b307e143632..11d9561d67c1 100644
>>--- a/drivers/gpu/drm/nouveau/Makefile
>>+++ b/drivers/gpu/drm/nouveau/Makefile
>>@@ -26,6 +26,7 @@ nouveau-y += core/core/subdev.o
>> nouveau-y += core/subdev/bar/base.o
>> nouveau-y += core/subdev/bar/nv50.o
>> nouveau-y += core/subdev/bar/nvc0.o
>>+nouveau-y += core/subdev/bar/gk20a.o
>> nouveau-y += core/subdev/bios/base.o
>> nouveau-y += core/subdev/bios/bit.o
>> nouveau-y += core/subdev/bios/boost.o
>>diff --git a/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
>>b/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
>>index 2d1e97d4264f..a2b9ccc48f66 100644
>>--- a/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
>>+++ b/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
>>@@ -165,7 +165,7 @@ nve0_identify(struct nouveau_device *device)
>>               device->oclass[NVDEV_SUBDEV_IBUS   ] = &gk20a_ibus_oclass;
>>               device->oclass[NVDEV_SUBDEV_INSTMEM] = nv50_instmem_oclass;
>>               device->oclass[NVDEV_SUBDEV_VM     ] = &nvc0_vmmgr_oclass;
>>-              device->oclass[NVDEV_SUBDEV_BAR    ] = &nvc0_bar_oclass;
>>+              device->oclass[NVDEV_SUBDEV_BAR    ] = &gk20a_bar_oclass;
>>               device->oclass[NVDEV_ENGINE_DMAOBJ ] = &nvd0_dmaeng_oclass;
>>               device->oclass[NVDEV_ENGINE_FIFO   ] =  gk20a_fifo_oclass;
>>               device->oclass[NVDEV_ENGINE_SW     ] =  nvc0_software_oclass;
>>diff --git a/drivers/gpu/drm/nouveau/core/include/subdev/bar.h
>>b/drivers/gpu/drm/nouveau/core/include/subdev/bar.h
>>index 9002cbb6432b..be037fac534c 100644
>>--- a/drivers/gpu/drm/nouveau/core/include/subdev/bar.h
>>+++ b/drivers/gpu/drm/nouveau/core/include/subdev/bar.h
>>@@ -33,5 +33,6 @@ nouveau_bar(void *obj)
>>
>> extern struct nouveau_oclass nv50_bar_oclass;
>> extern struct nouveau_oclass nvc0_bar_oclass;
>>+extern struct nouveau_oclass gk20a_bar_oclass;
>>
>> #endif
>>diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/gk20a.c
>>b/drivers/gpu/drm/nouveau/core/subdev/bar/gk20a.c
>>new file mode 100644
>>index 000000000000..bf877af9d3bd
>>--- /dev/null
>>+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/gk20a.c
>>@@ -0,0 +1,54 @@
>>+/*
>>+ * Copyright (c) 2014, NVIDIA CORPORATION. All rights reserved.
>>+ *
>>+ * Permission is hereby granted, free of charge, to any person obtaining
>>a
>>+ * copy of this software and associated documentation files (the
>>"Software"),
>>+ * to deal in the Software without restriction, including without
>>limitation
>>+ * the rights to use, copy, modify, merge, publish, distribute,
>>sublicense,
>>+ * and/or sell copies of the Software, and to permit persons to whom the
>>+ * Software is furnished to do so, subject to the following conditions:
>>+ *
>>+ * The above copyright notice and this permission notice shall be
>>included in
>>+ * all copies or substantial portions of the Software.
>>+ *
>>+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>>EXPRESS OR
>>+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
>>MERCHANTABILITY,
>>+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT
>>SHALL
>>+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
>>OTHER
>>+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
>>ARISING
>>+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
>>+ * DEALINGS IN THE SOFTWARE.
>>+ */
>>+
>>+#include <subdev/bar.h>
>>+
>>+#include "priv.h"
>>+
>>+int
>>+gk20a_bar_ctor(struct nouveau_object *parent, struct nouveau_object
>>*engine,
>>+             struct nouveau_oclass *oclass, void *data, u32 size,
>>+             struct nouveau_object **pobject)
>>+{
>>+      struct nouveau_bar *bar;
>>+      int ret;
>>+
>>+      ret = nvc0_bar_ctor(parent, engine, oclass, data, size, pobject);
>>+      if (ret)
>>+              return ret;
>>+
>>+      bar = (struct nouveau_bar *)*pobject;
>>+      bar->iomap_uncached = true;
>>+
>>+      return 0;
>>+}
>>+
>>+struct nouveau_oclass
>>+gk20a_bar_oclass = {
>>+      .handle = NV_SUBDEV(BAR, 0xea),
>>+      .ofuncs = &(struct nouveau_ofuncs) {
>>+              .ctor = gk20a_bar_ctor,
>>+              .dtor = nvc0_bar_dtor,
>>+              .init = nvc0_bar_init,
>>+              .fini = _nouveau_bar_fini,
>>+      },
>>+};
>>diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
>>b/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
>>index ca8139b9ab27..0a44459844e3 100644
>>--- a/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
>>+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
>>@@ -133,7 +133,7 @@ nvc0_bar_init_vm(struct nvc0_bar_priv *priv, struct
>>nvc0_bar_priv_vm *bar_vm,
>>       return 0;
>> }
>>
>>-static int
>>+int
>> nvc0_bar_ctor(struct nouveau_object *parent, struct nouveau_object
>>*engine,
>>             struct nouveau_oclass *oclass, void *data, u32 size,
>>             struct nouveau_object **pobject)
>>@@ -169,7 +169,7 @@ nvc0_bar_ctor(struct nouveau_object *parent, struct
>>nouveau_object *engine,
>>       return 0;
>> }
>>
>>-static void
>>+void
>> nvc0_bar_dtor(struct nouveau_object *object)
>> {
>>       struct nvc0_bar_priv *priv = (void *)object;
>>@@ -188,7 +188,7 @@ nvc0_bar_dtor(struct nouveau_object *object)
>>       nouveau_bar_destroy(&priv->base);
>> }
>>
>>-static int
>>+int
>> nvc0_bar_init(struct nouveau_object *object)
>> {
>>       struct nvc0_bar_priv *priv = (void *)object;
>>diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/priv.h
>>b/drivers/gpu/drm/nouveau/core/subdev/bar/priv.h
>>index ffad8f337ead..3ee8b1476d00 100644
>>--- a/drivers/gpu/drm/nouveau/core/subdev/bar/priv.h
>>+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/priv.h
>>@@ -23,4 +23,10 @@ int  nouveau_bar_alloc(struct nouveau_bar *, struct
>>nouveau_object *,
>>
>> void nv84_bar_flush(struct nouveau_bar *);
>>
>>+int nvc0_bar_ctor(struct nouveau_object *, struct nouveau_object *,
>>+                struct nouveau_oclass *, void *, u32,
>>+                struct nouveau_object **);
>>+void nvc0_bar_dtor(struct nouveau_object *);
>>+int nvc0_bar_init(struct nouveau_object *);
>>+
>> #endif
>>--
>>2.0.0
>>
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
