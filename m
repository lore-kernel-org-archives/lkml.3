Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaBNB7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:59:21 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:51834 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaBNB7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 20:59:19 -0500
MIME-Version: 1.0
In-Reply-To: <1392181259-26949-1-git-send-email-acourbot@nvidia.com>
References: <CAAVeFuLgopbCSE2u_paxUJC-dsZU=XwJxHen-jWMADQKZuuucQ@mail.gmail.com>
	<1392181259-26949-1-git-send-email-acourbot@nvidia.com>
Date: Fri, 14 Feb 2014 11:59:19 +1000
Message-ID: <CACAvsv50tGvTLifR0dFO97aUdSSdPfC3BW0HHpKNOJCgsQ6Lug@mail.gmail.com>
Subject: Re: [PATCH v2] drm/nouveau: handle -EACCES runtime PM return code
From: Ben Skeggs <skeggsb@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 3:00 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> pm_runtime_get*() may return -EACCES to indicate a device does not have
> runtime PM enabled. This is currently the case with platform devices
> on Nouveau, and is not an error in that context. Handle this case
> without failure.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Merged, thanks :)

> ---
> Changes since v1:
> - Fixed typo and inaccuracy in commit message
>
>  drivers/gpu/drm/nouveau/dispnv04/crtc.c     | 2 +-
>  drivers/gpu/drm/nouveau/nouveau_connector.c | 2 +-
>  drivers/gpu/drm/nouveau/nouveau_drm.c       | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/dispnv04/crtc.c b/drivers/gpu/drm/nouveau/dispnv04/crtc.c
> index 0e3270c3ffd2..1caef1fd139e 100644
> --- a/drivers/gpu/drm/nouveau/dispnv04/crtc.c
> +++ b/drivers/gpu/drm/nouveau/dispnv04/crtc.c
> @@ -1048,7 +1048,7 @@ nouveau_crtc_set_config(struct drm_mode_set *set)
>
>         /* get a pm reference here */
>         ret = pm_runtime_get_sync(dev->dev);
> -       if (ret < 0)
> +       if (ret < 0 && ret != -EACCES)
>                 return ret;
>
>         ret = drm_crtc_helper_set_config(set);
> diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
> index 1674882d60d5..cddef546d9b0 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_connector.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
> @@ -255,7 +255,7 @@ nouveau_connector_detect(struct drm_connector *connector, bool force)
>         }
>
>         ret = pm_runtime_get_sync(connector->dev->dev);
> -       if (ret < 0)
> +       if (ret < 0 && ret != -EACCES)
>                 return conn_status;
>
>         i2c = nouveau_connector_ddc_detect(connector, &nv_encoder);
> diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
> index b45fd1a0ab28..c677a09aac3f 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_drm.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
> @@ -696,7 +696,7 @@ nouveau_drm_open(struct drm_device *dev, struct drm_file *fpriv)
>
>         /* need to bring up power immediately if opening device */
>         ret = pm_runtime_get_sync(dev->dev);
> -       if (ret < 0)
> +       if (ret < 0 && ret != -EACCES)
>                 return ret;
>
>         get_task_comm(tmpname, current);
> @@ -781,7 +781,7 @@ long nouveau_drm_ioctl(struct file *filp,
>         dev = file_priv->minor->dev;
>
>         ret = pm_runtime_get_sync(dev->dev);
> -       if (ret < 0)
> +       if (ret < 0 && ret != -EACCES)
>                 return ret;
>
>         ret = drm_ioctl(filp, cmd, arg);
> --
> 1.8.5.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
