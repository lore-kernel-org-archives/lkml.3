Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaFPUdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:33:15 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:48657 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbaFPUdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:33:14 -0400
MIME-Version: 1.0
In-Reply-To: <1402942855-29591-1-git-send-email-sviau@codeaurora.org>
References: <1402942855-29591-1-git-send-email-sviau@codeaurora.org>
Date: Mon, 16 Jun 2014 16:33:12 -0400
Message-ID: <CAF6AEGu0VgopadyXq0b5enVeUPZCB152VOu2jnRL3JcgEzjFuQ@mail.gmail.com>
Subject: Re: [PATCH] drm/msm: update and activate iommu support
From: Rob Clark <robdclark@gmail.com>
To: Stephane Viau <sviau@codeaurora.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 2:20 PM, Stephane Viau <sviau@codeaurora.org> wrote:
> This changes activates the iommu support for MDP5, through the
> platform config structure.
>
> Iommu support is also slightly modified in order to make sure
> that MDP iommu is properly cleaned up if a probe deferral is
> requested. Before this change, IOMMU faults would occur if the
> probe failed (-EPROBE_DEFER).

So, this looks like it is really two patches.. one making
-EPROBE_DEFER work properly, and the other adding the missing bits for
mdp5 which so far are only on downstream kernel.

Could you split this patch into two, so I can queue the -EPROBE_DEFER
fix for a 3.16 -fixes pull req?

BR,
-R


> Signed-off-by: Stephane Viau <sviau@codeaurora.org>
> ---
>  drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c | 28 +++++++++++++++++++++++-----
>  drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h |  1 +
>  drivers/gpu/drm/msm/msm_gem.c           |  6 ++++++
>  drivers/gpu/drm/msm/msm_iommu.c         | 21 +++++++++++++++++++--
>  drivers/gpu/drm/msm/msm_mmu.h           |  1 +
>  5 files changed, 50 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
> index 2967b19..62ee5cd 100644
> --- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
> +++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
> @@ -20,6 +20,10 @@
>  #include "msm_mmu.h"
>  #include "mdp5_kms.h"
>
> +static const char *iommu_ports[] = {
> +               "mdp_0",
> +};
> +
>  static struct mdp5_platform_config *mdp5_get_config(struct platform_device *dev);
>
>  uint32_t __read_mostly _mdp5_pipe_vig_base;
> @@ -201,6 +205,12 @@ static void mdp5_preclose(struct msm_kms *kms, struct drm_file *file)
>  static void mdp5_destroy(struct msm_kms *kms)
>  {
>         struct mdp5_kms *mdp5_kms = to_mdp5_kms(to_mdp_kms(kms));
> +       struct msm_mmu *mmu = mdp5_kms->mmu;
> +
> +       if (mmu) {
> +               mmu->funcs->detach(mmu, iommu_ports, ARRAY_SIZE(iommu_ports));
> +               mmu->funcs->destroy(mmu);
> +       }
>         kfree(mdp5_kms);
>  }
>
> @@ -313,10 +323,6 @@ fail:
>         return ret;
>  }
>
> -static const char *iommu_ports[] = {
> -               "mdp_0",
> -};
> -
>  static int get_clk(struct platform_device *pdev, struct clk **clkp,
>                 const char *name)
>  {
> @@ -406,17 +412,23 @@ struct msm_kms *mdp5_kms_init(struct drm_device *dev)
>                 mmu = msm_iommu_new(dev, config->iommu);
>                 if (IS_ERR(mmu)) {
>                         ret = PTR_ERR(mmu);
> +                       dev_err(dev->dev, "failed to init iommu: %d\n", ret);
>                         goto fail;
>                 }
> +
>                 ret = mmu->funcs->attach(mmu, iommu_ports,
>                                 ARRAY_SIZE(iommu_ports));
> -               if (ret)
> +               if (ret) {
> +                       dev_err(dev->dev, "failed to attach iommu: %d\n", ret);
> +                       mmu->funcs->destroy(mmu);
>                         goto fail;
> +               }
>         } else {
>                 dev_info(dev->dev, "no iommu, fallback to phys "
>                                 "contig buffers for scanout\n");
>                 mmu = NULL;
>         }
> +       mdp5_kms->mmu = mmu;
>
>         mdp5_kms->id = msm_register_mmu(dev, mmu);
>         if (mdp5_kms->id < 0) {
> @@ -445,5 +457,11 @@ static struct mdp5_platform_config *mdp5_get_config(struct platform_device *dev)
>  #ifdef CONFIG_OF
>         /* TODO */
>  #endif
> +       config.iommu = iommu_domain_alloc(&platform_bus_type, 0);
> +       /* TODO hard-coded in downstream mdss, but should it be? */
> +       config.max_clk = 200000000;
> +       /* TODO get from DT: */
> +       config.smp_blk_cnt = 22;
> +
>         return &config;
>  }
> diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
> index 6a89b04..20ea748 100644
> --- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
> +++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
> @@ -41,6 +41,7 @@ struct mdp5_kms {
>
>         /* mapper-id used to request GEM buffer mapped for scanout: */
>         int id;
> +       struct msm_mmu *mmu;
>
>         /* for tracking smp allocation amongst pipes: */
>         mdp5_smp_state_t smp_state;
> diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
> index bb8026d..690d7e7 100644
> --- a/drivers/gpu/drm/msm/msm_gem.c
> +++ b/drivers/gpu/drm/msm/msm_gem.c
> @@ -278,6 +278,7 @@ int msm_gem_get_iova_locked(struct drm_gem_object *obj, int id,
>                 uint32_t *iova)
>  {
>         struct msm_gem_object *msm_obj = to_msm_bo(obj);
> +       struct drm_device *dev = obj->dev;
>         int ret = 0;
>
>         if (!msm_obj->domain[id].iova) {
> @@ -285,6 +286,11 @@ int msm_gem_get_iova_locked(struct drm_gem_object *obj, int id,
>                 struct msm_mmu *mmu = priv->mmus[id];
>                 struct page **pages = get_pages(obj);
>
> +               if (!mmu) {
> +                       dev_err(dev->dev, "null MMU pointer\n");
> +                       return -EINVAL;
> +               }
> +
>                 if (IS_ERR(pages))
>                         return PTR_ERR(pages);
>
> diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
> index 92b7459..198b2fe 100644
> --- a/drivers/gpu/drm/msm/msm_iommu.c
> +++ b/drivers/gpu/drm/msm/msm_iommu.c
> @@ -28,7 +28,7 @@ static int msm_fault_handler(struct iommu_domain *iommu, struct device *dev,
>                 unsigned long iova, int flags, void *arg)
>  {
>         DBG("*** fault: iova=%08lx, flags=%d", iova, flags);
> -       return 0;
> +       return -ENOSYS;
>  }
>
>  static int msm_iommu_attach(struct msm_mmu *mmu, const char **names, int cnt)
> @@ -40,8 +40,10 @@ static int msm_iommu_attach(struct msm_mmu *mmu, const char **names, int cnt)
>         for (i = 0; i < cnt; i++) {
>                 struct device *msm_iommu_get_ctx(const char *ctx_name);
>                 struct device *ctx = msm_iommu_get_ctx(names[i]);
> -               if (IS_ERR_OR_NULL(ctx))
> +               if (IS_ERR_OR_NULL(ctx)) {
> +                       dev_warn(dev->dev, "couldn't get %s context", names[i]);
>                         continue;
> +               }
>                 ret = iommu_attach_device(iommu->domain, ctx);
>                 if (ret) {
>                         dev_warn(dev->dev, "could not attach iommu to %s", names[i]);
> @@ -52,6 +54,20 @@ static int msm_iommu_attach(struct msm_mmu *mmu, const char **names, int cnt)
>         return 0;
>  }
>
> +static void msm_iommu_detach(struct msm_mmu *mmu, const char **names, int cnt)
> +{
> +       struct msm_iommu *iommu = to_msm_iommu(mmu);
> +       int i;
> +
> +       for (i = 0; i < cnt; i++) {
> +               struct device *msm_iommu_get_ctx(const char *ctx_name);
> +               struct device *ctx = msm_iommu_get_ctx(names[i]);
> +               if (IS_ERR_OR_NULL(ctx))
> +                       continue;
> +               iommu_detach_device(iommu->domain, ctx);
> +       }
> +}
> +
>  static int msm_iommu_map(struct msm_mmu *mmu, uint32_t iova,
>                 struct sg_table *sgt, unsigned len, int prot)
>  {
> @@ -127,6 +143,7 @@ static void msm_iommu_destroy(struct msm_mmu *mmu)
>
>  static const struct msm_mmu_funcs funcs = {
>                 .attach = msm_iommu_attach,
> +               .detach = msm_iommu_detach,
>                 .map = msm_iommu_map,
>                 .unmap = msm_iommu_unmap,
>                 .destroy = msm_iommu_destroy,
> diff --git a/drivers/gpu/drm/msm/msm_mmu.h b/drivers/gpu/drm/msm/msm_mmu.h
> index 0303244..21da6d1 100644
> --- a/drivers/gpu/drm/msm/msm_mmu.h
> +++ b/drivers/gpu/drm/msm/msm_mmu.h
> @@ -22,6 +22,7 @@
>
>  struct msm_mmu_funcs {
>         int (*attach)(struct msm_mmu *mmu, const char **names, int cnt);
> +       void (*detach)(struct msm_mmu *mmu, const char **names, int cnt);
>         int (*map)(struct msm_mmu *mmu, uint32_t iova, struct sg_table *sgt,
>                         unsigned len, int prot);
>         int (*unmap)(struct msm_mmu *mmu, uint32_t iova, struct sg_table *sgt,
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
