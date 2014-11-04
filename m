Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaKDI7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:59:33 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62296 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaKDI7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:59:32 -0500
Date: Tue, 4 Nov 2014 09:52:40 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Joe Perches <joe@perches.com>
Cc: David Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] drm: Reduce code size of drm_err and DRM_DEBUG[_<FOO>]
 uses
Message-ID: <20141104085240.GA26941@phenom.ffwll.local>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	David Airlie <airlied@linux.ie>,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>
References: <1415088226.24560.1.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415088226.24560.1.camel@perches.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 12:03:46AM -0800, Joe Perches wrote:
> Using %pf, __builtin_return_address(0) instead ofy 
> "%s", __func__ reduces code size by eliminating
> a function argument.
> 
> (allyesconfig)
> $ size drivers/gpu/drm/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
> 4656061	1321947	1669536	7647544	 74b138	drivers/gpu/drm/built-in.o.new
> 4737680	1321947	1669472	7729099	 75efcb	drivers/gpu/drm/built-in.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

I have an earlier version from you of this patch already, and it's in
linux-next. And this patch here lacks the changelog indicating what
changed exactly. Can you please rebase on top of linux-next and improve
the commit message?

Thanks, Daniel

> ---
>  drivers/gpu/drm/drm_drv.c | 10 ++++++----
>  include/drm/drmP.h        | 45 ++++++++++++++++++++++-----------------------
>  2 files changed, 28 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
> index bc3da32..22f76a2 100644
> --- a/drivers/gpu/drm/drm_drv.c
> +++ b/drivers/gpu/drm/drm_drv.c
> @@ -56,7 +56,7 @@ static struct idr drm_minors_idr;
>  struct class *drm_class;
>  static struct dentry *drm_debugfs_root;
>  
> -void drm_err(const char *func, const char *format, ...)
> +void drm_err(const char *format, ...)
>  {
>  	struct va_format vaf;
>  	va_list args;
> @@ -66,13 +66,14 @@ void drm_err(const char *func, const char *format, ...)
>  	vaf.fmt = format;
>  	vaf.va = &args;
>  
> -	printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* %pV", func, &vaf);
> +	printk(KERN_ERR "[" DRM_NAME ":%pf] *ERROR* %pV",
> +	       __builtin_return_address(0), &vaf);
>  
>  	va_end(args);
>  }
>  EXPORT_SYMBOL(drm_err);
>  
> -void drm_ut_debug_printk(const char *function_name, const char *format, ...)
> +void drm_ut_debug_printk(const char *format, ...)
>  {
>  	struct va_format vaf;
>  	va_list args;
> @@ -81,7 +82,8 @@ void drm_ut_debug_printk(const char *function_name, const char *format, ...)
>  	vaf.fmt = format;
>  	vaf.va = &args;
>  
> -	printk(KERN_DEBUG "[" DRM_NAME ":%s] %pV", function_name, &vaf);
> +	printk(KERN_DEBUG "[" DRM_NAME ":%pf] %pV",
> +	       __builtin_return_address(0), &vaf);
>  
>  	va_end(args);
>  }
> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index 53ed876..02aaa1a 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -122,11 +122,10 @@ struct dma_buf_attachment;
>  #define DRM_UT_KMS		0x04
>  #define DRM_UT_PRIME		0x08
>  
> -extern __printf(2, 3)
> -void drm_ut_debug_printk(const char *function_name,
> -			 const char *format, ...);
> -extern __printf(2, 3)
> -void drm_err(const char *func, const char *format, ...);
> +__printf(1, 2)
> +void drm_ut_debug_printk(const char *format, ...);
> +__printf(1, 2)
> +void drm_err(const char *format, ...);
>  
>  /***********************************************************************/
>  /** \name DRM template customization defaults */
> @@ -155,7 +154,7 @@ void drm_err(const char *func, const char *format, ...);
>   * \param arg arguments
>   */
>  #define DRM_ERROR(fmt, ...)				\
> -	drm_err(__func__, fmt, ##__VA_ARGS__)
> +	drm_err(fmt, ##__VA_ARGS__)
>  
>  /**
>   * Rate limited error output.  Like DRM_ERROR() but won't flood the log.
> @@ -170,7 +169,7 @@ void drm_err(const char *func, const char *format, ...);
>  				      DEFAULT_RATELIMIT_BURST);		\
>  									\
>  	if (__ratelimit(&_rs))						\
> -		drm_err(__func__, fmt, ##__VA_ARGS__);			\
> +		drm_err(fmt, ##__VA_ARGS__);			\
>  })
>  
>  #define DRM_INFO(fmt, ...)				\
> @@ -186,26 +185,26 @@ void drm_err(const char *func, const char *format, ...);
>   * \param arg arguments
>   */
>  #define DRM_DEBUG(fmt, args...)						\
> -	do {								\
> -		if (unlikely(drm_debug & DRM_UT_CORE))			\
> -			drm_ut_debug_printk(__func__, fmt, ##args);	\
> -	} while (0)
> +do {									\
> +	if (unlikely(drm_debug & DRM_UT_CORE))				\
> +		drm_ut_debug_printk(fmt, ##args);			\
> +} while (0)
>  
>  #define DRM_DEBUG_DRIVER(fmt, args...)					\
> -	do {								\
> -		if (unlikely(drm_debug & DRM_UT_DRIVER))		\
> -			drm_ut_debug_printk(__func__, fmt, ##args);	\
> -	} while (0)
> +do {									\
> +	if (unlikely(drm_debug & DRM_UT_DRIVER))			\
> +		drm_ut_debug_printk(fmt, ##args);			\
> +} while (0)
>  #define DRM_DEBUG_KMS(fmt, args...)					\
> -	do {								\
> -		if (unlikely(drm_debug & DRM_UT_KMS))			\
> -			drm_ut_debug_printk(__func__, fmt, ##args);	\
> -	} while (0)
> +do {									\
> +	if (unlikely(drm_debug & DRM_UT_KMS))				\
> +		drm_ut_debug_printk(fmt, ##args);			\
> +} while (0)
>  #define DRM_DEBUG_PRIME(fmt, args...)					\
> -	do {								\
> -		if (unlikely(drm_debug & DRM_UT_PRIME))			\
> -			drm_ut_debug_printk(__func__, fmt, ##args);	\
> -	} while (0)
> +do {									\
> +	if (unlikely(drm_debug & DRM_UT_PRIME))				\
> +		drm_ut_debug_printk(fmt, ##args);			\
> +} while (0)
>  
>  /*@}*/
>  
> 
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
