Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaD1CKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:10:37 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:43632 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaD1CK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:10:28 -0400
MIME-Version: 1.0
In-Reply-To: <1398410396-23338-7-git-send-email-acourbot@nvidia.com>
References: <1398410396-23338-1-git-send-email-acourbot@nvidia.com>
	<1398410396-23338-7-git-send-email-acourbot@nvidia.com>
Date: Mon, 28 Apr 2014 12:10:27 +1000
Message-ID: <CACAvsv51Ju_ZqJfNU5GzzEmDzf2Fr6Xr_5yGRtfqOQRVTgvDPg@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH v3 6/9] drm/nouveau/graph: enable when using
 external firmware
From: Ben Skeggs <skeggsb@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 5:19 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> nvc0_graph_ctor() would only let the graphics engine be enabled if its
> oclass has a proper microcode linked to it. This prevents GR from being
> enabled at all on chips that rely exclusively on external firmware, even
> though such a use-case is valid.
>
> Relax the conditions enabling the GR engine to also include the case
> where an external firmware has also been loaded.
I'm happy to take this patch as-is.  I do wonder if we should do
something like this though:

if (nouveau_boolopt(device->cfgopt, "NvGrUseFW", oclass->fecs.ucode == NULL))

Which will automatically switch to external firmware if there's no
internal implementation available.

Thoughts?  This could be a separate patch even, if preferred.

Thanks,
Ben.

>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
> index f3c7329da0a0..e5b75f189988 100644
> --- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
> +++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
> @@ -1259,10 +1259,13 @@ nvc0_graph_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
>         struct nvc0_graph_oclass *oclass = (void *)bclass;
>         struct nouveau_device *device = nv_device(parent);
>         struct nvc0_graph_priv *priv;
> +       bool use_ext_fw, enable;
>         int ret, i;
>
> -       ret = nouveau_graph_create(parent, engine, bclass,
> -                                  (oclass->fecs.ucode != NULL), &priv);
> +       use_ext_fw = nouveau_boolopt(device->cfgopt, "NvGrUseFW", false);
> +       enable = use_ext_fw || oclass->fecs.ucode != NULL;
> +
> +       ret = nouveau_graph_create(parent, engine, bclass, enable, &priv);
>         *pobject = nv_object(priv);
>         if (ret)
>                 return ret;
> @@ -1272,7 +1275,7 @@ nvc0_graph_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
>
>         priv->base.units = nvc0_graph_units;
>
> -       if (nouveau_boolopt(device->cfgopt, "NvGrUseFW", false)) {
> +       if (use_ext_fw) {
>                 nv_info(priv, "using external firmware\n");
>                 if (nvc0_graph_ctor_fw(priv, "fuc409c", &priv->fuc409c) ||
>                     nvc0_graph_ctor_fw(priv, "fuc409d", &priv->fuc409d) ||
> --
> 1.9.2
>
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau
