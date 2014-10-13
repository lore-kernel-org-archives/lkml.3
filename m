Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaJMPq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:46:57 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:39843 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbaJMPqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:46:55 -0400
MIME-Version: 1.0
In-Reply-To: <1413090537.22149.16.camel@joe-AO725>
References: <1411403411.2952.36.camel@joe-AO725>
	<87lhpa5w5f.fsf@intel.com>
	<20140923135256.GG15734@phenom.ffwll.local>
	<1413090537.22149.16.camel@joe-AO725>
Date: Mon, 13 Oct 2014 17:46:54 +0200
Message-ID: <CANq1E4Rz9REGPj=Wga61h13yMfgUdB4K3UTmLFYWnRpYf+iTSA@mail.gmail.com>
Subject: Re: [PATCH] drm: drm_err: Remove unnecessary __func__ argument
From: David Herrmann <dh.herrmann@gmail.com>
To: Joe Perches <joe@perches.com>, Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Oct 12, 2014 at 7:08 AM, Joe Perches <joe@perches.com> wrote:
> Removing the unnecessary drm_err __func__ argument by using
> the equivalent %pf and __builtin_return_address(0) makes the
> code smaller for every use of the DRM_ERROR macro.
>
> For instance: (allmodconfig)
>
> $ size drivers/gpu/drm/i915/i915.o*
>    text    data     bss     dec     hex filename
>  922447  193257  296736 1412440  158d58 drivers/gpu/drm/i915/i915.o.new
>  928111  193257  296736 1418104  15a378 drivers/gpu/drm/i915/i915.o.old

You might want to mention that this requires a binary-search through
kallsyms on each call. I guess that's the reason you didn't use it for
drm_ut_debug_printk()? I'm fine with doing this on drm_err(). Looks
good.

Thanks
David

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/gpu/drm/drm_drv.c | 5 +++--
>  include/drm/drmP.h        | 8 ++++----
>  2 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
> index 9f0e1b9..e9263d9 100644
> --- a/drivers/gpu/drm/drm_drv.c
> +++ b/drivers/gpu/drm/drm_drv.c
> @@ -68,7 +68,7 @@ static struct idr drm_minors_idr;
>  struct class *drm_class;
>  static struct dentry *drm_debugfs_root;
>
> -void drm_err(const char *func, const char *format, ...)
> +void drm_err(const char *format, ...)
>  {
>         struct va_format vaf;
>         va_list args;
> @@ -78,7 +78,8 @@ void drm_err(const char *func, const char *format, ...)
>         vaf.fmt = format;
>         vaf.va = &args;
>
> -       printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* %pV", func, &vaf);
> +       printk(KERN_ERR "[" DRM_NAME ":%pf] *ERROR* %pV",
> +              __builtin_return_address(0), &vaf);
>
>         va_end(args);
>  }
> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index ca374ac..5e9ff52 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -125,8 +125,8 @@ struct reservation_object;
>  extern __printf(2, 3)
>  void drm_ut_debug_printk(const char *function_name,
>                          const char *format, ...);
> -extern __printf(2, 3)
> -void drm_err(const char *func, const char *format, ...);
> +extern __printf(1, 2)
> +void drm_err(const char *format, ...);
>
>  /***********************************************************************/
>  /** \name DRM template customization defaults */
> @@ -168,7 +168,7 @@ void drm_err(const char *func, const char *format, ...);
>   * \param arg arguments
>   */
>  #define DRM_ERROR(fmt, ...)                            \
> -       drm_err(__func__, fmt, ##__VA_ARGS__)
> +       drm_err(fmt, ##__VA_ARGS__)
>
>  /**
>   * Rate limited error output.  Like DRM_ERROR() but won't flood the log.
> @@ -183,7 +183,7 @@ void drm_err(const char *func, const char *format, ...);
>                                       DEFAULT_RATELIMIT_BURST);         \
>                                                                         \
>         if (__ratelimit(&_rs))                                          \
> -               drm_err(__func__, fmt, ##__VA_ARGS__);                  \
> +               drm_err(fmt, ##__VA_ARGS__);                            \
>  })
>
>  #define DRM_INFO(fmt, ...)                             \
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
