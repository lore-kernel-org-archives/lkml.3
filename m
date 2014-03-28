Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbaC1BpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 21:45:19 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:43484 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbaC1BpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 21:45:17 -0400
MIME-Version: 1.0
In-Reply-To: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com>
References: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com>
Date: Fri, 28 Mar 2014 11:45:15 +1000
Message-ID: <CAPM=9tx4hdU0PZqdZcCd-x3HMu+6ZsGibeOHZPLe3OpW9Wsa0g@mail.gmail.com>
Subject: Re: [PATCH 1/1] drm/vmwgfx: correct fb_fix_screeninfo.line_length
From: Dave Airlie <airlied@gmail.com>
To: Christopher Friedt <chrisfriedt@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Thomas Hellstrom <thellstrom@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 10:45 AM, Christopher Friedt
<chrisfriedt@gmail.com> wrote:
> Previously, the vmwgfx_fb driver would allow users to call FBIOSET_VINFO, but it would not adjust
> the FINFO properly, resulting in distorted screen rendering. The patch corrects that behaviour.
>
> See https://bugs.gentoo.org/show_bug.cgi?id=494794 for examples.
>

Just adding cc's of maintainer list.

> Signed-off-by: Christopher Friedt <chrisfriedt@gmail.com>
> ---
>  drivers/gpu/drm/vmwgfx/vmwgfx_fb.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
> index ed5ce2a..021b522 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
> @@ -147,7 +147,7 @@ static int vmw_fb_check_var(struct fb_var_screeninfo *var,
>         }
>
>         if (!vmw_kms_validate_mode_vram(vmw_priv,
> -                                       info->fix.line_length,
> +                                       var->xres * var->bits_per_pixel/8,
>                                         var->yoffset + var->yres)) {
>                 DRM_ERROR("Requested geom can not fit in framebuffer\n");
>                 return -EINVAL;
> @@ -162,6 +162,8 @@ static int vmw_fb_set_par(struct fb_info *info)
>         struct vmw_private *vmw_priv = par->vmw_priv;
>         int ret;
>
> +       info->fix.line_length = info->var.xres * info->var.bits_per_pixel/8;
> +
>         ret = vmw_kms_write_svga(vmw_priv, info->var.xres, info->var.yres,
>                                  info->fix.line_length,
>                                  par->bpp, par->depth);
> @@ -177,6 +179,7 @@ static int vmw_fb_set_par(struct fb_info *info)
>                 vmw_write(vmw_priv, SVGA_REG_DISPLAY_POSITION_Y, info->var.yoffset);
>                 vmw_write(vmw_priv, SVGA_REG_DISPLAY_WIDTH, info->var.xres);
>                 vmw_write(vmw_priv, SVGA_REG_DISPLAY_HEIGHT, info->var.yres);
> +               vmw_write(vmw_priv, SVGA_REG_BYTES_PER_LINE, info->fix.line_length);
>                 vmw_write(vmw_priv, SVGA_REG_DISPLAY_ID, SVGA_ID_INVALID);
>         }
>
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
