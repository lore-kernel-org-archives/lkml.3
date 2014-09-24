Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaIXUhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:37:55 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:36839 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaIXUhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:37:54 -0400
MIME-Version: 1.0
In-Reply-To: <1411575342-31048-7-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
	<1411575342-31048-7-git-send-email-vinod.koul@intel.com>
Date: Wed, 24 Sep 2014 16:37:53 -0400
Message-ID: <CADnq5_MzBmNCCzHexYeXvOFCBG6ku8ZuL_PUrjDWCK4DhwaFyA@mail.gmail.com>
Subject: Re: [PATCH 06/27] drm/radeon: use pm_runtime_last_busy_and_autosuspend
 helper
From: Alex Deucher <alexdeucher@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>, subhransu.s.prusty@intel.com,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:14 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> coding the same code
>
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>

Acked-by: Alex Deucher <alexander.deucher@amd.com>

I don't care which tree this goes through.

> ---
>  drivers/gpu/drm/radeon/radeon_connectors.c |   15 +++++----------
>  drivers/gpu/drm/radeon/radeon_drv.c        |    5 ++---
>  drivers/gpu/drm/radeon/radeon_kms.c        |    6 ++----
>  3 files changed, 9 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
> index 300c4b3..b48cf9d 100644
> --- a/drivers/gpu/drm/radeon/radeon_connectors.c
> +++ b/drivers/gpu/drm/radeon/radeon_connectors.c
> @@ -852,8 +852,7 @@ radeon_lvds_detect(struct drm_connector *connector, bool force)
>         /* check acpi lid status ??? */
>
>         radeon_connector_update_scratch_regs(connector, ret);
> -       pm_runtime_mark_last_busy(connector->dev->dev);
> -       pm_runtime_put_autosuspend(connector->dev->dev);
> +       pm_runtime_last_busy_and_autosuspend(connector->dev->dev);
>         return ret;
>  }
>
> @@ -1025,8 +1024,7 @@ radeon_vga_detect(struct drm_connector *connector, bool force)
>         radeon_connector_update_scratch_regs(connector, ret);
>
>  out:
> -       pm_runtime_mark_last_busy(connector->dev->dev);
> -       pm_runtime_put_autosuspend(connector->dev->dev);
> +       pm_runtime_last_busy_and_autosuspend(connector->dev->dev);
>
>         return ret;
>  }
> @@ -1103,8 +1101,7 @@ radeon_tv_detect(struct drm_connector *connector, bool force)
>         if (ret == connector_status_connected)
>                 ret = radeon_connector_analog_encoder_conflict_solve(connector, encoder, ret, false);
>         radeon_connector_update_scratch_regs(connector, ret);
> -       pm_runtime_mark_last_busy(connector->dev->dev);
> -       pm_runtime_put_autosuspend(connector->dev->dev);
> +       pm_runtime_last_busy_and_autosuspend(connector->dev->dev);
>         return ret;
>  }
>
> @@ -1321,8 +1318,7 @@ out:
>         radeon_connector_update_scratch_regs(connector, ret);
>
>  exit:
> -       pm_runtime_mark_last_busy(connector->dev->dev);
> -       pm_runtime_put_autosuspend(connector->dev->dev);
> +       pm_runtime_last_busy_and_autosuspend(connector->dev->dev);
>
>         return ret;
>  }
> @@ -1638,8 +1634,7 @@ radeon_dp_detect(struct drm_connector *connector, bool force)
>
>         radeon_connector_update_scratch_regs(connector, ret);
>  out:
> -       pm_runtime_mark_last_busy(connector->dev->dev);
> -       pm_runtime_put_autosuspend(connector->dev->dev);
> +       pm_runtime_last_busy_and_autosuspend(connector->dev->dev);
>
>         return ret;
>  }
> diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
> index 092d067..548d129 100644
> --- a/drivers/gpu/drm/radeon/radeon_drv.c
> +++ b/drivers/gpu/drm/radeon/radeon_drv.c
> @@ -503,9 +503,8 @@ long radeon_drm_ioctl(struct file *filp,
>                 return ret;
>
>         ret = drm_ioctl(filp, cmd, arg);
> -
> -       pm_runtime_mark_last_busy(dev->dev);
> -       pm_runtime_put_autosuspend(dev->dev);
> +
> +       pm_runtime_last_busy_and_autosuspend(dev->dev);
>         return ret;
>  }
>
> diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
> index eb7164d..80f061d 100644
> --- a/drivers/gpu/drm/radeon/radeon_kms.c
> +++ b/drivers/gpu/drm/radeon/radeon_kms.c
> @@ -147,8 +147,7 @@ int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags)
>                 pm_runtime_set_autosuspend_delay(dev->dev, 5000);
>                 pm_runtime_set_active(dev->dev);
>                 pm_runtime_allow(dev->dev);
> -               pm_runtime_mark_last_busy(dev->dev);
> -               pm_runtime_put_autosuspend(dev->dev);
> +               pm_runtime_last_busy_and_autosuspend(dev->dev);
>         }
>
>  out:
> @@ -632,8 +631,7 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
>                 file_priv->driver_priv = fpriv;
>         }
>
> -       pm_runtime_mark_last_busy(dev->dev);
> -       pm_runtime_put_autosuspend(dev->dev);
> +       pm_runtime_last_busy_and_autosuspend(dev->dev);
>         return 0;
>  }
>
> --
> 1.7.0.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
