Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab3J3QFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:05:06 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:60533 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3J3QFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:05:04 -0400
MIME-Version: 1.0
In-Reply-To: <1383130745-32165-1-git-send-email-treding@nvidia.com>
References: <1383130745-32165-1-git-send-email-treding@nvidia.com>
Date: Wed, 30 Oct 2013 14:05:02 -0200
Message-ID: <CA+gsUGSjJmqu9Ph0znE5XJJOJdeh-UT3z2Cjm7sEMB4F+ZtAvg@mail.gmail.com>
Subject: Re: [PATCH] drm/sysfs: Do not drop device reference twice
From: Paulo Zanoni <przanoni@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/30 Thierry Reding <thierry.reding@gmail.com>:
> device_unregister() already drops its reference to the struct device, so
> explicitly calling put_device() before device_unregister() can cause the
> device to have been freed before it can be unregistered.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>

I started investigating this problem yesterday and reached the same
conclusion. The connector path can be easily reproduced on i915.ko:
get a machine that has an eDP panel, physically disconnect the panel,
boot the machine, "modprobe i915" and watch the segfault.

Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Tested-by: Paulo Zanoni <paulo.r.zanoni@intel.com>

I didn't really bisect, but I believe this is probably a regression
from "drm/sysfs: sort out minor and connector device object
lifetimes".

And kudos to whoever invented CONFIG_DEBUG_KOBJECT :)

> ---
>  drivers/gpu/drm/drm_sysfs.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
> index dae42c7..db1c8f9 100644
> --- a/drivers/gpu/drm/drm_sysfs.c
> +++ b/drivers/gpu/drm/drm_sysfs.c
> @@ -439,7 +439,6 @@ err_out_files:
>                 device_remove_file(connector->kdev, &connector_attrs_opt1[i]);
>         for (i = 0; i < attr_cnt; i++)
>                 device_remove_file(connector->kdev, &connector_attrs[i]);
> -       put_device(connector->kdev);
>         device_unregister(connector->kdev);
>
>  out:
> @@ -472,7 +471,6 @@ void drm_sysfs_connector_remove(struct drm_connector *connector)
>         for (i = 0; i < ARRAY_SIZE(connector_attrs); i++)
>                 device_remove_file(connector->kdev, &connector_attrs[i]);
>         sysfs_remove_bin_file(&connector->kdev->kobj, &edid_attr);
> -       put_device(connector->kdev);
>         device_unregister(connector->kdev);
>         connector->kdev = NULL;
>  }
> --
> 1.8.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
Paulo Zanoni
