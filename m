Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaEMPqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:46:37 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46523 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbaEMPqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:46:30 -0400
MIME-Version: 1.0
In-Reply-To: <1399995050-28435-2-git-send-email-thierry.reding@gmail.com>
References: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
	<1399995050-28435-2-git-send-email-thierry.reding@gmail.com>
Date: Tue, 13 May 2014 17:46:30 +0200
Message-ID: <CANq1E4QQgy2=XG7-Q1adg__Xgv_E6cw3WFhW5jMn5prROeALkg@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] drm: Introduce drm_set_unique()
From: David Herrmann <dh.herrmann@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Clark <robdclark@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Some minor nitpicks below:

On Tue, May 13, 2014 at 5:30 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> Add a helper function that allows drivers to statically set the unique
> name of the device. This will allow platform and USB drivers to get rid
> of their DRM bus implementations and directly use drm_dev_alloc() and
> drm_dev_register().
>
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v2:
> - move drm_set_unique() to drivers/gpu/drm/drm_stub.c
> - add kernel-doc
>
>  drivers/gpu/drm/drm_ioctl.c | 23 +++++++++++++++++------
>  drivers/gpu/drm/drm_stub.c  | 24 ++++++++++++++++++++++++
>  include/drm/drmP.h          |  3 +++
>  3 files changed, 44 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
> index 38269d5aa333..a59f6c2d7586 100644
> --- a/drivers/gpu/drm/drm_ioctl.c
> +++ b/drivers/gpu/drm/drm_ioctl.c
> @@ -131,13 +131,24 @@ static int drm_set_busid(struct drm_device *dev, struct drm_file *file_priv)
>         if (master->unique != NULL)
>                 drm_unset_busid(dev, master);
>
> -       ret = dev->driver->bus->set_busid(dev, master);
> -       if (ret)
> -               goto err;
> +       if (dev->driver->bus && dev->driver->bus->set_busid) {
> +               ret = dev->driver->bus->set_busid(dev, master);
> +               if (ret) {
> +                       drm_unset_busid(dev, master);
> +                       return ret;
> +               }
> +       } else {
> +               WARN(dev->unique == NULL,
> +                    "No drm_bus.set_busid() implementation provided by %ps. "
> +                    "Set the unique name explicitly using drm_set_unique().",
> +                    dev->driver);

return -EINVAL?

If you don't bail out here, the kstrdup() below will cause a
kernel-oops. There's no reason to WARN() if you purposely cause an
oops below.

> +
> +               master->unique = kstrdup(dev->unique, GFP_KERNEL);
> +               if (master->unique)
> +                       master->unique_len = strlen(dev->unique);
> +       }
> +
>         return 0;
> -err:
> -       drm_unset_busid(dev, master);
> -       return ret;
>  }
>
>  /**
> diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
> index 1447b0ee3676..64cf97dc4ce4 100644
> --- a/drivers/gpu/drm/drm_stub.c
> +++ b/drivers/gpu/drm/drm_stub.c
> @@ -535,6 +535,29 @@ static void drm_fs_inode_free(struct inode *inode)
>  }
>
>  /**
> + * drm_set_unique - Set the unique name of a DRM device
> + * @dev: device of which to set the unique name
> + * @fmt: format string for unique name
> + *
> + * Sets the unique name of a DRM device using the specified format string and
> + * a variable list of arguments. Drivers can use this at driver probe time if
> + * the unique name of the devices they drive is static.
> + */
> +int drm_set_unique(struct drm_device *dev, const char *fmt, ...)

I tried renaming all the device-management APIs to "drm_dev_*", so how
about moving this below drm_dev_unregister() and renaming it to
drm_dev_set_unique()? I prefer prefixes which describe the object the
function works on. set_unique() works on drm_device, so lets use the
known drm_dev_* prefix.

Just my opinion, others might disagree..

> +{
> +       va_list ap;
> +
> +       kfree(dev->unique);
> +
> +       va_start(ap, fmt);
> +       dev->unique = kvasprintf(GFP_KERNEL, fmt, ap);
> +       va_end(ap);
> +
> +       return dev->unique ? 0 : -ENOMEM;
> +}
> +EXPORT_SYMBOL(drm_set_unique);
> +
> +/**
>   * drm_dev_alloc - Allocate new drm device
>   * @driver: DRM driver to allocate device for
>   * @parent: Parent device object
> @@ -649,6 +672,7 @@ static void drm_dev_release(struct kref *ref)
>         drm_minor_free(dev, DRM_MINOR_CONTROL);
>
>         mutex_destroy(&dev->master_mutex);
> +       kfree(dev->unique);
>         kfree(dev);
>  }
>
> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index 6b4ed9e84e6f..dcec96b1154c 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -1235,6 +1235,8 @@ struct drm_device {
>         struct drm_vma_offset_manager *vma_offset_manager;
>         /*@} */
>         int switch_power_state;
> +
> +       char *unique;

Can you add this to the group at the top of the object? This somehow belongs to
 /** \name Lifetime Management */
as it is part of device initialization and API.

>  };
>
>  #define DRM_SWITCH_POWER_ON 0
> @@ -1680,6 +1682,7 @@ static __inline__ void drm_core_dropmap(struct drm_local_map *map)
>
>  #include <drm/drm_mem_util.h>
>
> +int drm_set_unique(struct drm_device *dev, const char *fmt, ...);

Again just a minor style-nitpick: Move that below the drm_dev_*()
declarations, not above. Usual kernel-style is to have
allocators/lifetime-management first, followed by runtime management.

Otherwise looks good:

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

>  struct drm_device *drm_dev_alloc(struct drm_driver *driver,
>                                  struct device *parent);
>  void drm_dev_ref(struct drm_device *dev);
> --
> 1.9.2
>
