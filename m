Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbaISQE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:04:59 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:53260 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbaISQE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:04:57 -0400
MIME-Version: 1.0
In-Reply-To: <1411131533-15494-1-git-send-email-a.hajda@samsung.com>
References: <1411131533-15494-1-git-send-email-a.hajda@samsung.com>
Date: Sat, 20 Sep 2014 01:04:55 +0900
X-Google-Sender-Auth: hKcItUTVU_WL4QljgZdGVy_4XMU
Message-ID: <CAAQKjZMoctx9K0RfPDEEsGfj7cEWX8-hRT2saSyCvq5wBX9vPA@mail.gmail.com>
Subject: Re: [PATCH v2] drm/exynos: switch to universal plane API
From: Inki Dae <inki.dae@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Seung-Woo Kim <sw0312.kim@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DRM DRIVERS FOR E..." <dri-devel@lists.freedesktop.org>,
        Daniel Drake <drake@endlessm.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-19 21:58 GMT+09:00 Andrzej Hajda <a.hajda@samsung.com>:
> The patch replaces legacy functions
> drm_plane_init() / drm_crtc_init() with
> drm_universal_plane_init() and drm_crtc_init_with_planes().
> It allows to replace fake primary plane with the real one.
> Additionally the patch leaves cleanup of crtcs to core,
> this way planes and crtcs are cleaned in correct order.
>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
> Hi Inki, Joonyoung,
>
> This is 2nd version of the patch with addressed comments of Joonyoung.

Picked it up.

Thanks,
Inki Dae

>
> Regards
> Andrzej
> ---
>  drivers/gpu/drm/exynos/exynos_drm_crtc.c  | 62 +++++++++++++++----------------
>  drivers/gpu/drm/exynos/exynos_drm_drv.c   |  5 ++-
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c  |  2 -
>  drivers/gpu/drm/exynos/exynos_drm_plane.c | 19 +++++-----
>  drivers/gpu/drm/exynos/exynos_drm_plane.h |  3 +-
>  drivers/gpu/drm/exynos/exynos_drm_vidi.c  |  1 -
>  drivers/gpu/drm/exynos/exynos_mixer.c     |  2 -
>  7 files changed, 46 insertions(+), 48 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> index b68e58f..8e38e9f 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> @@ -32,7 +32,6 @@ enum exynos_crtc_mode {
>   * Exynos specific crtc structure.
>   *
>   * @drm_crtc: crtc object.
> - * @drm_plane: pointer of private plane object for this crtc
>   * @manager: the manager associated with this crtc
>   * @pipe: a crtc index created at load() with a new crtc object creation
>   *     and the crtc object would be set to private->crtc array
> @@ -46,7 +45,6 @@ enum exynos_crtc_mode {
>   */
>  struct exynos_drm_crtc {
>         struct drm_crtc                 drm_crtc;
> -       struct drm_plane                *plane;
>         struct exynos_drm_manager       *manager;
>         unsigned int                    pipe;
>         unsigned int                    dpms;
> @@ -94,12 +92,12 @@ static void exynos_drm_crtc_commit(struct drm_crtc *crtc)
>
>         exynos_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
>
> -       exynos_plane_commit(exynos_crtc->plane);
> +       exynos_plane_commit(crtc->primary);
>
>         if (manager->ops->commit)
>                 manager->ops->commit(manager);
>
> -       exynos_plane_dpms(exynos_crtc->plane, DRM_MODE_DPMS_ON);
> +       exynos_plane_dpms(crtc->primary, DRM_MODE_DPMS_ON);
>  }
>
>  static bool
> @@ -123,10 +121,9 @@ exynos_drm_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
>  {
>         struct exynos_drm_crtc *exynos_crtc = to_exynos_crtc(crtc);
>         struct exynos_drm_manager *manager = exynos_crtc->manager;
> -       struct drm_plane *plane = exynos_crtc->plane;
> +       struct drm_framebuffer *fb = crtc->primary->fb;
>         unsigned int crtc_w;
>         unsigned int crtc_h;
> -       int ret;
>
>         /*
>          * copy the mode data adjusted by mode_fixup() into crtc->mode
> @@ -134,29 +131,21 @@ exynos_drm_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
>          */
>         memcpy(&crtc->mode, adjusted_mode, sizeof(*adjusted_mode));
>
> -       crtc_w = crtc->primary->fb->width - x;
> -       crtc_h = crtc->primary->fb->height - y;
> +       crtc_w = fb->width - x;
> +       crtc_h = fb->height - y;
>
>         if (manager->ops->mode_set)
>                 manager->ops->mode_set(manager, &crtc->mode);
>
> -       ret = exynos_plane_mode_set(plane, crtc, crtc->primary->fb, 0, 0, crtc_w, crtc_h,
> -                                   x, y, crtc_w, crtc_h);
> -       if (ret)
> -               return ret;
> -
> -       plane->crtc = crtc;
> -       plane->fb = crtc->primary->fb;
> -       drm_framebuffer_reference(plane->fb);
> -
> -       return 0;
> +       return exynos_plane_mode_set(crtc->primary, crtc, fb, 0, 0,
> +                                    crtc_w, crtc_h, x, y, crtc_w, crtc_h);
>  }
>
>  static int exynos_drm_crtc_mode_set_commit(struct drm_crtc *crtc, int x, int y,
>                                           struct drm_framebuffer *old_fb)
>  {
>         struct exynos_drm_crtc *exynos_crtc = to_exynos_crtc(crtc);
> -       struct drm_plane *plane = exynos_crtc->plane;
> +       struct drm_framebuffer *fb = crtc->primary->fb;
>         unsigned int crtc_w;
>         unsigned int crtc_h;
>         int ret;
> @@ -167,11 +156,11 @@ static int exynos_drm_crtc_mode_set_commit(struct drm_crtc *crtc, int x, int y,
>                 return -EPERM;
>         }
>
> -       crtc_w = crtc->primary->fb->width - x;
> -       crtc_h = crtc->primary->fb->height - y;
> +       crtc_w = fb->width - x;
> +       crtc_h = fb->height - y;
>
> -       ret = exynos_plane_mode_set(plane, crtc, crtc->primary->fb, 0, 0, crtc_w, crtc_h,
> -                                   x, y, crtc_w, crtc_h);
> +       ret = exynos_plane_mode_set(crtc->primary, crtc, fb, 0, 0,
> +                                   crtc_w, crtc_h, x, y, crtc_w, crtc_h);
>         if (ret)
>                 return ret;
>
> @@ -304,8 +293,7 @@ static int exynos_drm_crtc_set_property(struct drm_crtc *crtc,
>                         exynos_drm_crtc_commit(crtc);
>                         break;
>                 case CRTC_MODE_BLANK:
> -                       exynos_plane_dpms(exynos_crtc->plane,
> -                                         DRM_MODE_DPMS_OFF);
> +                       exynos_plane_dpms(crtc->primary, DRM_MODE_DPMS_OFF);
>                         break;
>                 default:
>                         break;
> @@ -351,8 +339,10 @@ static void exynos_drm_crtc_attach_mode_property(struct drm_crtc *crtc)
>  int exynos_drm_crtc_create(struct exynos_drm_manager *manager)
>  {
>         struct exynos_drm_crtc *exynos_crtc;
> +       struct drm_plane *plane;
>         struct exynos_drm_private *private = manager->drm_dev->dev_private;
>         struct drm_crtc *crtc;
> +       int ret;
>
>         exynos_crtc = kzalloc(sizeof(*exynos_crtc), GFP_KERNEL);
>         if (!exynos_crtc)
> @@ -364,11 +354,11 @@ int exynos_drm_crtc_create(struct exynos_drm_manager *manager)
>         exynos_crtc->dpms = DRM_MODE_DPMS_OFF;
>         exynos_crtc->manager = manager;
>         exynos_crtc->pipe = manager->pipe;
> -       exynos_crtc->plane = exynos_plane_init(manager->drm_dev,
> -                               1 << manager->pipe, true);
> -       if (!exynos_crtc->plane) {
> -               kfree(exynos_crtc);
> -               return -ENOMEM;
> +       plane = exynos_plane_init(manager->drm_dev, 1 << manager->pipe,
> +                                 DRM_PLANE_TYPE_PRIMARY);
> +       if (IS_ERR(plane)) {
> +               ret = PTR_ERR(plane);
> +               goto err_plane;
>         }
>
>         manager->crtc = &exynos_crtc->drm_crtc;
> @@ -376,12 +366,22 @@ int exynos_drm_crtc_create(struct exynos_drm_manager *manager)
>
>         private->crtc[manager->pipe] = crtc;
>
> -       drm_crtc_init(manager->drm_dev, crtc, &exynos_crtc_funcs);
> +       ret = drm_crtc_init_with_planes(manager->drm_dev, crtc, plane, NULL,
> +                                       &exynos_crtc_funcs);
> +       if (ret < 0)
> +               goto err_crtc;
> +
>         drm_crtc_helper_add(crtc, &exynos_crtc_helper_funcs);
>
>         exynos_drm_crtc_attach_mode_property(crtc);
>
>         return 0;
> +
> +err_crtc:
> +       plane->funcs->destroy(plane);
> +err_plane:
> +       kfree(exynos_crtc);
> +       return ret;
>  }
>
>  int exynos_drm_crtc_enable_vblank(struct drm_device *dev, int pipe)
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> index dc4affd..49c15f6 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> @@ -86,8 +86,9 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
>                 struct drm_plane *plane;
>                 unsigned long possible_crtcs = (1 << MAX_CRTC) - 1;
>
> -               plane = exynos_plane_init(dev, possible_crtcs, false);
> -               if (!plane)
> +               plane = exynos_plane_init(dev, possible_crtcs,
> +                                         DRM_PLANE_TYPE_OVERLAY);
> +               if (IS_ERR(plane))
>                         goto err_mode_config_cleanup;
>         }
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> index 2f896df..fb1a152 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> @@ -1082,8 +1082,6 @@ static void fimd_unbind(struct device *dev, struct device *master,
>                 exynos_dpi_remove(dev);
>
>         fimd_mgr_remove(mgr);
> -
> -       crtc->funcs->destroy(crtc);
>  }
>
>  static const struct component_ops fimd_component_ops = {
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_plane.c b/drivers/gpu/drm/exynos/exynos_drm_plane.c
> index 8371cbd..c7045a66 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_plane.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_plane.c
> @@ -139,6 +139,8 @@ int exynos_plane_mode_set(struct drm_plane *plane, struct drm_crtc *crtc,
>                         overlay->crtc_x, overlay->crtc_y,
>                         overlay->crtc_width, overlay->crtc_height);
>
> +       plane->crtc = crtc;
> +
>         exynos_drm_crtc_plane_mode_set(crtc, overlay);
>
>         return 0;
> @@ -187,8 +189,6 @@ exynos_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
>         if (ret < 0)
>                 return ret;
>
> -       plane->crtc = crtc;
> -
>         exynos_plane_commit(plane);
>         exynos_plane_dpms(plane, DRM_MODE_DPMS_ON);
>
> @@ -254,25 +254,26 @@ static void exynos_plane_attach_zpos_property(struct drm_plane *plane)
>  }
>
>  struct drm_plane *exynos_plane_init(struct drm_device *dev,
> -                                   unsigned long possible_crtcs, bool priv)
> +                                   unsigned long possible_crtcs,
> +                                   enum drm_plane_type type)
>  {
>         struct exynos_plane *exynos_plane;
>         int err;
>
>         exynos_plane = kzalloc(sizeof(struct exynos_plane), GFP_KERNEL);
>         if (!exynos_plane)
> -               return NULL;
> +               return ERR_PTR(-ENOMEM);
>
> -       err = drm_plane_init(dev, &exynos_plane->base, possible_crtcs,
> -                             &exynos_plane_funcs, formats, ARRAY_SIZE(formats),
> -                             priv);
> +       err = drm_universal_plane_init(dev, &exynos_plane->base, possible_crtcs,
> +                                      &exynos_plane_funcs, formats,
> +                                      ARRAY_SIZE(formats), type);
>         if (err) {
>                 DRM_ERROR("failed to initialize plane\n");
>                 kfree(exynos_plane);
> -               return NULL;
> +               return ERR_PTR(err);
>         }
>
> -       if (priv)
> +       if (type == DRM_PLANE_TYPE_PRIMARY)
>                 exynos_plane->overlay.zpos = DEFAULT_ZPOS;
>         else
>                 exynos_plane_attach_zpos_property(&exynos_plane->base);
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_plane.h b/drivers/gpu/drm/exynos/exynos_drm_plane.h
> index 84d464c..0d1986b 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_plane.h
> +++ b/drivers/gpu/drm/exynos/exynos_drm_plane.h
> @@ -17,4 +17,5 @@ int exynos_plane_mode_set(struct drm_plane *plane, struct drm_crtc *crtc,
>  void exynos_plane_commit(struct drm_plane *plane);
>  void exynos_plane_dpms(struct drm_plane *plane, int mode);
>  struct drm_plane *exynos_plane_init(struct drm_device *dev,
> -                                   unsigned long possible_crtcs, bool priv);
> +                                   unsigned long possible_crtcs,
> +                                   enum drm_plane_type type);
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_vidi.c b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
> index 9528d81..57e8adc 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
> @@ -657,7 +657,6 @@ static int vidi_remove(struct platform_device *pdev)
>                 return -EINVAL;
>         }
>
> -       crtc->funcs->destroy(crtc);
>         encoder->funcs->destroy(encoder);
>         drm_connector_cleanup(&ctx->connector);
>
> diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
> index e8b4ec8..1a68106 100644
> --- a/drivers/gpu/drm/exynos/exynos_mixer.c
> +++ b/drivers/gpu/drm/exynos/exynos_mixer.c
> @@ -1309,8 +1309,6 @@ static void mixer_unbind(struct device *dev, struct device *master, void *data)
>         mixer_mgr_remove(mgr);
>
>         pm_runtime_disable(dev);
> -
> -       crtc->funcs->destroy(crtc);
>  }
>
>  static const struct component_ops mixer_component_ops = {
> --
> 1.9.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
