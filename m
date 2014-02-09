Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaBINhY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:37:24 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:54233 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaBINhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:37:22 -0500
MIME-Version: 1.0
In-Reply-To: <1391780716-21896-3-git-send-email-sagar.a.kamble@intel.com>
References: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
	<1391780716-21896-3-git-send-email-sagar.a.kamble@intel.com>
Date: Sun, 9 Feb 2014 08:37:22 -0500
Message-ID: <CAF6AEGu+2S6iGfisgBc=S9Lq38f-Qc=KU67Zb7tzWArXCiy0fw@mail.gmail.com>
Subject: Re: [PATCH v4 02/11] drm: Add support_bits parameter to drm_property_create_bitmask()
From: Rob Clark <robdclark@gmail.com>
To: sagar.a.kamble@intel.com
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        vijay.a.purushothaman@intel.com, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        Archit Taneja <archit@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, joe@perches.com,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 7, 2014 at 8:45 AM,  <sagar.a.kamble@intel.com> wrote:
> From: Ville Syrjälä <ville.syrjala at linux.intel.com>
>
> Make drm_property_create_bitmask() a bit more generic by allowing the
> caller to specify which bits are in fact supported. This allows multiple
> callers to use the same enum list, but still create different versions
> of the same property with different list of supported bits.
>
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Tested-by: Sagar Kamble <sagar.a.kamble@intel.com>

very minor nit here: this patch probably should fix up the callers of
this fxn for bisectability.  Although it could be the only other
caller was omapdrm which gets converted over to the new API a few
patches later..

with that,

Reviewed-by: Rob Clark <robdclark@gmail.com>


> ---
>  drivers/gpu/drm/drm_crtc.c | 6 +++++-
>  include/drm/drm_crtc.h     | 3 ++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index 3b7d32d..628d3d3 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -2906,7 +2906,8 @@ EXPORT_SYMBOL(drm_property_create_enum);
>  struct drm_property *drm_property_create_bitmask(struct drm_device *dev,
>                                          int flags, const char *name,
>                                          const struct drm_prop_enum_list *props,
> -                                        int num_values)
> +                                        int num_values,
> +                                        unsigned int supported_bits)
>  {
>         struct drm_property *property;
>         int i, ret;
> @@ -2918,6 +2919,9 @@ struct drm_property *drm_property_create_bitmask(struct drm_device *dev,
>                 return NULL;
>
>         for (i = 0; i < num_values; i++) {
> +               if (!(supported_bits & (1 << i)))
> +                       continue;
> +
>                 ret = drm_property_add_enum(property, i,
>                                       props[i].type,
>                                       props[i].name);
> diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
> index d5c46c1..41b86d2 100644
> --- a/include/drm/drm_crtc.h
> +++ b/include/drm/drm_crtc.h
> @@ -1070,7 +1070,8 @@ extern struct drm_property *drm_property_create_enum(struct drm_device *dev, int
>  struct drm_property *drm_property_create_bitmask(struct drm_device *dev,
>                                          int flags, const char *name,
>                                          const struct drm_prop_enum_list *props,
> -                                        int num_values);
> +                                        int num_values,
> +                                        unsigned int supported_bits);
>  struct drm_property *drm_property_create_range(struct drm_device *dev, int flags,
>                                          const char *name,
>                                          uint64_t min, uint64_t max);
> --
> 1.8.5
>
