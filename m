Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab3HTM12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:27:28 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:35942 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3HTM10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:27:26 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1376962382-29913-2-git-send-email-furquan@google.com>
References: <1376962382-29913-1-git-send-email-furquan@google.com>
	<1376962382-29913-2-git-send-email-furquan@google.com>
Date: Tue, 20 Aug 2013 14:27:25 +0200
X-Google-Sender-Auth: zug_Utb_hkS9EBc9g7cIfdrmazk
Message-ID: <CAKMK7uGY+A8S3DHBoFGL5hEhW4e46uTPBvkYk7zRPQKk=KeOaQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/i915: add fast boot support for Haswell
From: Daniel Vetter <daniel@ffwll.ch>
To: Furquan Shaikh <furquan@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Josh Triplett <josh.triplett@intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        furquan.m.shaikh@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ronald Minnich <rminnich@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 3:33 AM, Furquan Shaikh <furquan@google.com> wrote:
> Enables getting correct mode clock when reading pipe config
> This patch has been tested successfully on top of drm-intel-nightly tree
>
> Signed-off-by: Furquan Shaikh <furquan@google.com>

This is missing a hunk to enable the pipe_config consistency checks:

diff --git a/drivers/gpu/drm/i915/intel_display.c
b/drivers/gpu/drm/i915/intel_display.c
index 7a40427..e8b73ac 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8416,13 +8416,11 @@ intel_pipe_config_compare(struct drm_device *dev,
 #undef PIPE_CONF_CHECK_FLAGS
 #undef PIPE_CONF_QUIRK

-       if (!IS_HASWELL(dev)) {
-               if (!intel_fuzzy_clock_check(current_config, pipe_config)) {
-                       DRM_ERROR("mismatch in clock (expected %d, found %d)\n",
-                                 current_config->adjusted_mode.clock,
-                                 pipe_config->adjusted_mode.clock);
-                       return false;
-               }
+       if (!intel_fuzzy_clock_check(current_config, pipe_config)) {
+               DRM_ERROR("mismatch in clock (expected %d, found %d)\n",
+                         current_config->adjusted_mode.clock,
+                         pipe_config->adjusted_mode.clock);
+               return false;
        }

        return true;


Cheers, Daniel

> ---
>  drivers/gpu/drm/i915/i915_reg.h      |  6 ++++
>  drivers/gpu/drm/i915/intel_ddi.c     | 70 ++++++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/i915/intel_display.c |  1 +
>  3 files changed, 77 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
> index 2b96d6b..9511129 100644
> --- a/drivers/gpu/drm/i915/i915_reg.h
> +++ b/drivers/gpu/drm/i915/i915_reg.h
> @@ -4970,6 +4970,7 @@
>  #define  SPLL_PLL_NON_SSC              (2<<28)
>  #define  SPLL_PLL_FREQ_810MHz          (0<<26)
>  #define  SPLL_PLL_FREQ_1350MHz         (1<<26)
> +#define  SPLL_PLL_FREQ_MASK             (3<<26)
>
>  /* WRPLL */
>  #define WRPLL_CTL1                     0x46040
> @@ -4983,6 +4984,10 @@
>  #define  WRPLL_DIVIDER_POST(x)         ((x)<<8)
>  #define  WRPLL_DIVIDER_FEEDBACK(x)     ((x)<<16)
>
> +#define WRPLL_DIVIDER_REFERENCE_BITS(reg)    (reg & 0xff)
> +#define WRPLL_DIVIDER_POST_BITS(reg)         ((reg >> 8) & 0x3f)
> +#define WRPLL_DIVIDER_FEEDBACK_BITS(reg)     ((reg >> 16) & 0xff)
> +
>  /* Port clock selection */
>  #define PORT_CLK_SEL_A                 0x46100
>  #define PORT_CLK_SEL_B                 0x46104
> @@ -4994,6 +4999,7 @@
>  #define  PORT_CLK_SEL_WRPLL1           (4<<29)
>  #define  PORT_CLK_SEL_WRPLL2           (5<<29)
>  #define  PORT_CLK_SEL_NONE             (7<<29)
> +#define  PORT_CLK_SEL_MASK              (7<<29)
>
>  /* Transcoder clock selection */
>  #define TRANS_CLK_SEL_A                        0x46140
> diff --git a/drivers/gpu/drm/i915/intel_ddi.c b/drivers/gpu/drm/i915/intel_ddi.c
> index b8c096b..a24a375 100644
> --- a/drivers/gpu/drm/i915/intel_ddi.c
> +++ b/drivers/gpu/drm/i915/intel_ddi.c
> @@ -1246,6 +1246,74 @@ static void intel_ddi_hot_plug(struct intel_encoder *intel_encoder)
>                 intel_dp_check_link_status(intel_dp);
>  }
>
> +static void intel_ddi_get_clock(struct intel_encoder *encoder,
> +                               struct intel_crtc_config *pipe_config)
> +{
> +       struct drm_i915_private *dev_priv = encoder->base.dev->dev_private;
> +       int port = intel_ddi_get_encoder_port(encoder);
> +       u32 temp = I915_READ(PORT_CLK_SEL(port)) & PORT_CLK_SEL_MASK;
> +       u8 link_bw;
> +
> +       if ((temp == PORT_CLK_SEL_LCPLL_810) ||
> +           (temp == PORT_CLK_SEL_LCPLL_1350) ||
> +           (temp == PORT_CLK_SEL_LCPLL_2700)) {
> +
> +               switch (temp) {
> +               case PORT_CLK_SEL_LCPLL_810:
> +                       link_bw = DP_LINK_BW_1_62;
> +                       break;
> +               case PORT_CLK_SEL_LCPLL_1350:
> +                       link_bw = DP_LINK_BW_2_7;
> +                       break;
> +               case PORT_CLK_SEL_LCPLL_2700:
> +                       link_bw = DP_LINK_BW_5_4;
> +                       break;
> +               }
> +               pipe_config->port_clock = drm_dp_bw_code_to_link_rate(link_bw);
> +       } else if ((temp == PORT_CLK_SEL_WRPLL1) ||
> +                  (temp == PORT_CLK_SEL_WRPLL2)) {
> +               uint64_t p, n2, r2;
> +               u32 val, reg;
> +               uint64_t freq2k;
> +
> +               switch (temp) {
> +               case PORT_CLK_SEL_WRPLL1:
> +                       reg = WRPLL_CTL1;
> +                       break;
> +               case PORT_CLK_SEL_WRPLL2:
> +                       reg = WRPLL_CTL2;
> +                       break;
> +               }
> +               val = I915_READ(reg);
> +               r2 = WRPLL_DIVIDER_REFERENCE_BITS(val);
> +               p = WRPLL_DIVIDER_POST_BITS(val);
> +               n2 = WRPLL_DIVIDER_FEEDBACK_BITS(val);
> +
> +               freq2k = DIV_ROUND_UP_ULL(LC_FREQ * n2, r2 * p);
> +               pipe_config->port_clock = freq2k / 10;
> +       } else if (temp == PORT_CLK_SEL_SPLL) {
> +               u32 val;
> +
> +               val = I915_READ(PORT_CLK_SEL_SPLL);
> +
> +               switch (val & SPLL_PLL_FREQ_MASK) {
> +               case SPLL_PLL_FREQ_810MHz:
> +                       pipe_config->port_clock = 810000;
> +                       break;
> +               case SPLL_PLL_FREQ_1350MHz:
> +                       pipe_config->port_clock = 1350000;
> +                       break;
> +               default:
> +                       WARN(1, "Invalid pll freq %d\n",
> +                            val & SPLL_PLL_FREQ_MASK);
> +                       return;
> +               }
> +       } else {
> +               WARN(1, "Invalid clock selection %d\n", temp);
> +               return;
> +       }
> +}
> +
>  static void intel_ddi_get_config(struct intel_encoder *encoder,
>                                  struct intel_crtc_config *pipe_config)
>  {
> @@ -1265,6 +1333,8 @@ static void intel_ddi_get_config(struct intel_encoder *encoder,
>                 flags |= DRM_MODE_FLAG_NVSYNC;
>
>         pipe_config->adjusted_mode.flags |= flags;
> +
> +       intel_ddi_get_clock(encoder, pipe_config);
>  }
>
>  static void intel_ddi_destroy(struct drm_encoder *encoder)
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index e0069f4..1c6a3d2 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -9579,6 +9579,7 @@ static void intel_init_display(struct drm_device *dev)
>
>         if (HAS_DDI(dev)) {
>                 dev_priv->display.get_pipe_config = haswell_get_pipe_config;
> +               dev_priv->display.get_clock = ironlake_crtc_clock_get;
>                 dev_priv->display.crtc_mode_set = haswell_crtc_mode_set;
>                 dev_priv->display.crtc_enable = haswell_crtc_enable;
>                 dev_priv->display.crtc_disable = haswell_crtc_disable;
> --
> 1.8.3
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
