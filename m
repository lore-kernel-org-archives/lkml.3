Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaFKSUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:20:40 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:56569 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaFKSUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:20:39 -0400
MIME-Version: 1.0
In-Reply-To: <1401345427-5299-7-git-send-email-benjamin.gaignard@linaro.org>
References: <1401345427-5299-1-git-send-email-benjamin.gaignard@linaro.org>
	<1401345427-5299-7-git-send-email-benjamin.gaignard@linaro.org>
Date: Wed, 11 Jun 2014 14:20:38 -0400
Message-ID: <CAF6AEGvcLwoQk22tE5eLdzWn+Ox+9=juy2YhZkVDm_2W4r6dhQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/11] drm: sti: add TVOut driver
From: Rob Clark <robdclark@gmail.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, lee.jones@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 2:37 AM, Benjamin Gaignard
<benjamin.gaignard@linaro.org> wrote:
> TVout hardware block is responsible to dispatch the data flow coming
> from compositor block to any of the output (HDMI or Analog TV).
> It control when output are start/stop and configure according the
> require flow path.
>
> TVout is the parent of HDMI and HDA drivers and bind them at runtime.
>
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> ---
>  drivers/gpu/drm/sti/Makefile    |   3 +-
>  drivers/gpu/drm/sti/sti_tvout.c | 678 ++++++++++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/sti/sti_tvout.h |  18 ++
>  3 files changed, 698 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/gpu/drm/sti/sti_tvout.c
>  create mode 100644 drivers/gpu/drm/sti/sti_tvout.h
>
> diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
> index df47171..dcc9568 100644
> --- a/drivers/gpu/drm/sti/Makefile
> +++ b/drivers/gpu/drm/sti/Makefile
> @@ -4,4 +4,5 @@ obj-$(CONFIG_DRM_STI) += \
>         sti_hdmi.o \
>         sti_hdmi_tx3g0c55phy.o \
>         sti_hdmi_tx3g4c28phy.o \
> -       sti_hda.o
> +       sti_hda.o \
> +       sti_tvout.o
> \ No newline at end of file
> diff --git a/drivers/gpu/drm/sti/sti_tvout.c b/drivers/gpu/drm/sti/sti_tvout.c
> new file mode 100644
> index 0000000..d778e35
> --- /dev/null
> +++ b/drivers/gpu/drm/sti/sti_tvout.c
> @@ -0,0 +1,678 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2014
> + * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
> + *          Vincent Abriou <vincent.abriou@st.com>
> + *          for STMicroelectronics.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/component.h>
> +#include <linux/module.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/reset.h>
> +
> +#include <drm/drmP.h>
> +#include <drm/drm_crtc_helper.h>
> +
> +#include "sti_drm_connector.h"
> +#include "sti_drm_encoder.h"
> +#include "sti_tvout.h"
> +
> +/* glue registers */
> +#define TVO_CSC_MAIN_M0                  0x000
> +#define TVO_CSC_MAIN_M1                  0x004
> +#define TVO_CSC_MAIN_M2                  0x008
> +#define TVO_CSC_MAIN_M3                  0x00c
> +#define TVO_CSC_MAIN_M4                  0x010
> +#define TVO_CSC_MAIN_M5                  0x014
> +#define TVO_CSC_MAIN_M6                  0x018
> +#define TVO_CSC_MAIN_M7                  0x01c
> +#define TVO_MAIN_IN_VID_FORMAT           0x030
> +#define TVO_CSC_AUX_M0                   0x100
> +#define TVO_CSC_AUX_M1                   0x104
> +#define TVO_CSC_AUX_M2                   0x108
> +#define TVO_CSC_AUX_M3                   0x10c
> +#define TVO_CSC_AUX_M4                   0x110
> +#define TVO_CSC_AUX_M5                   0x114
> +#define TVO_CSC_AUX_M6                   0x118
> +#define TVO_CSC_AUX_M7                   0x11c
> +#define TVO_AUX_IN_VID_FORMAT            0x130
> +#define TVO_VIP_HDF                      0x400
> +#define TVO_HD_SYNC_SEL                  0x418
> +#define TVO_HD_DAC_CFG_OFF               0x420
> +#define TVO_VIP_HDMI                     0x500
> +#define TVO_HDMI_FORCE_COLOR_0           0x504
> +#define TVO_HDMI_FORCE_COLOR_1           0x508
> +#define TVO_HDMI_CLIP_VALUE_B_CB         0x50c
> +#define TVO_HDMI_CLIP_VALUE_Y_G          0x510
> +#define TVO_HDMI_CLIP_VALUE_R_CR         0x514
> +#define TVO_HDMI_SYNC_SEL                0x518
> +#define TVO_HDMI_DFV_OBS                 0x540
> +
> +#define TVO_IN_FMT_SIGNED                BIT(0)
> +#define TVO_SYNC_EXT                     BIT(4)
> +
> +#define TVO_VIP_REORDER_R_SHIFT          24
> +#define TVO_VIP_REORDER_G_SHIFT          20
> +#define TVO_VIP_REORDER_B_SHIFT          16
> +#define TVO_VIP_REORDER_MASK             0x3
> +#define TVO_VIP_REORDER_Y_G_SEL          0
> +#define TVO_VIP_REORDER_CB_B_SEL         1
> +#define TVO_VIP_REORDER_CR_R_SEL         2
> +
> +#define TVO_VIP_CLIP_SHIFT               8
> +#define TVO_VIP_CLIP_MASK                0x7
> +#define TVO_VIP_CLIP_DISABLED            0
> +#define TVO_VIP_CLIP_EAV_SAV             1
> +#define TVO_VIP_CLIP_LIMITED_RANGE_RGB_Y 2
> +#define TVO_VIP_CLIP_LIMITED_RANGE_CB_CR 3
> +#define TVO_VIP_CLIP_PROG_RANGE          4
> +
> +#define TVO_VIP_RND_SHIFT                4
> +#define TVO_VIP_RND_MASK                 0x3
> +#define TVO_VIP_RND_8BIT_ROUNDED         0
> +#define TVO_VIP_RND_10BIT_ROUNDED        1
> +#define TVO_VIP_RND_12BIT_ROUNDED        2
> +
> +#define TVO_VIP_SEL_INPUT_MASK           0xf
> +#define TVO_VIP_SEL_INPUT_MAIN           0x0
> +#define TVO_VIP_SEL_INPUT_AUX            0x8
> +#define TVO_VIP_SEL_INPUT_FORCE_COLOR    0xf
> +#define TVO_VIP_SEL_INPUT_BYPASS_MASK    0x1
> +#define TVO_VIP_SEL_INPUT_BYPASSED       1
> +
> +#define TVO_SYNC_MAIN_VTG_SET_REF        0x00
> +#define TVO_SYNC_MAIN_VTG_SET_1          0x01
> +#define TVO_SYNC_MAIN_VTG_SET_2          0x02
> +#define TVO_SYNC_MAIN_VTG_SET_3          0x03
> +#define TVO_SYNC_MAIN_VTG_SET_4          0x04
> +#define TVO_SYNC_MAIN_VTG_SET_5          0x05
> +#define TVO_SYNC_MAIN_VTG_SET_6          0x06
> +#define TVO_SYNC_AUX_VTG_SET_REF         0x10
> +#define TVO_SYNC_AUX_VTG_SET_1           0x11
> +#define TVO_SYNC_AUX_VTG_SET_2           0x12
> +#define TVO_SYNC_AUX_VTG_SET_3           0x13
> +#define TVO_SYNC_AUX_VTG_SET_4           0x14
> +#define TVO_SYNC_AUX_VTG_SET_5           0x15
> +#define TVO_SYNC_AUX_VTG_SET_6           0x16
> +
> +#define TVO_SYNC_HD_DCS_SHIFT            8
> +
> +/* enum listing the supported output data format */
> +enum sti_tvout_video_out_type {
> +       STI_TVOUT_VIDEO_OUT_RGB,
> +       STI_TVOUT_VIDEO_OUT_YUV,
> +};
> +
> +/**
> + * STI TVout structure
> + *
> + * @dev: pointer to driver device
> + * @regs: registers
> + * @reset: reset control of the tvout
> + */
> +struct sti_tvout {
> +       struct device *dev;
> +       void __iomem *regs;
> +       struct reset_control *reset;
> +};
> +
> +/* preformatter conversion matrix */
> +static const u32 rgb_to_ycbcr_601[8] = {
> +       0xF927082E, 0x04C9FEAB, 0x01D30964, 0xFA95FD3D,
> +       0x0000082E, 0x00002000, 0x00002000, 0x00000000
> +};
> +
> +/* 709 RGB to YCbCr */
> +static const u32 rgb_to_ycbcr_709[8] = {
> +       0xF891082F, 0x0367FF40, 0x01280B71, 0xF9B1FE20,
> +       0x0000082F, 0x00002000, 0x00002000, 0x00000000
> +};
> +
> +static u32 tvout_read(struct sti_tvout *tvout, int offset)
> +{
> +       return readl(tvout->regs + offset);
> +}
> +
> +static void tvout_write(struct sti_tvout *tvout, u32 val, int offset)
> +{
> +       writel(val, tvout->regs + offset);
> +}
> +
> +/**
> + * Set the clipping mode of a VIP
> + *
> + * @tvout: tvout structure
> + * @cr_r:
> + * @y_g:
> + * @cb_b:
> + */
> +static void tvout_vip_set_color_order(struct sti_tvout *tvout,
> +                                     u32 cr_r, u32 y_g, u32 cb_b)
> +{
> +       u32 val = tvout_read(tvout, TVO_VIP_HDMI);
> +
> +       val &= ~(TVO_VIP_REORDER_MASK << TVO_VIP_REORDER_R_SHIFT);
> +       val &= ~(TVO_VIP_REORDER_MASK << TVO_VIP_REORDER_G_SHIFT);
> +       val &= ~(TVO_VIP_REORDER_MASK << TVO_VIP_REORDER_B_SHIFT);
> +       val |= cr_r << TVO_VIP_REORDER_R_SHIFT;
> +       val |= y_g << TVO_VIP_REORDER_G_SHIFT;
> +       val |= cb_b << TVO_VIP_REORDER_B_SHIFT;
> +
> +       tvout_write(tvout, val, TVO_VIP_HDMI);
> +}
> +
> +/**
> + * Set the clipping mode of a VIP
> + *
> + * @tvout: tvout structure
> + * @range: clipping range
> + */
> +static void tvout_vip_set_clip_mode(struct sti_tvout *tvout, u32 range)
> +{
> +       u32 val = tvout_read(tvout, TVO_VIP_HDMI);
> +
> +       val &= ~(TVO_VIP_CLIP_MASK << TVO_VIP_CLIP_SHIFT);
> +       val |= range << TVO_VIP_CLIP_SHIFT;
> +       tvout_write(tvout, val, TVO_VIP_HDMI);
> +}
> +
> +/**
> + * Set the rounded value of a VIP
> + *
> + * @tvout: tvout structure
> + * @rnd: rounded val per component
> + */
> +static void tvout_vip_set_rnd(struct sti_tvout *tvout, u32 rnd)
> +{
> +       u32 val = tvout_read(tvout, TVO_VIP_HDMI);
> +
> +       val &= ~(TVO_VIP_RND_MASK << TVO_VIP_RND_SHIFT);
> +       val |= rnd << TVO_VIP_RND_SHIFT;
> +       tvout_write(tvout, val, TVO_VIP_HDMI);
> +}
> +
> +/**
> + * Select the VIP input
> + *
> + * @tvout: tvout structure
> + * @sel_input: selected_input (main/aux + conv)
> + */
> +static void tvout_vip_set_sel_input(struct sti_tvout *tvout,
> +                                   bool main_path,
> +                                   bool sel_input_logic_inverted,
> +                                   enum sti_tvout_video_out_type video_out)
> +{
> +       u32 sel_input;
> +       u32 val = tvout_read(tvout, TVO_VIP_HDMI);
> +
> +       if (main_path)
> +               sel_input = TVO_VIP_SEL_INPUT_MAIN;
> +       else
> +               sel_input = TVO_VIP_SEL_INPUT_AUX;
> +
> +       switch (video_out) {
> +       case STI_TVOUT_VIDEO_OUT_RGB:
> +               sel_input |= TVO_VIP_SEL_INPUT_BYPASSED;
> +               break;
> +       case STI_TVOUT_VIDEO_OUT_YUV:
> +               sel_input &= ~TVO_VIP_SEL_INPUT_BYPASSED;
> +               break;
> +       }
> +
> +       /* on stih407 chip the sel_input bypass mode logic is inverted */
> +       if (sel_input_logic_inverted)
> +               sel_input = sel_input ^ TVO_VIP_SEL_INPUT_BYPASS_MASK;
> +
> +       val &= ~TVO_VIP_SEL_INPUT_MASK;
> +       val |= sel_input;
> +       tvout_write(tvout, val, TVO_VIP_HDMI);
> +}
> +
> +/**
> + * Select the input video signed or unsigned
> + *
> + * @tvout: tvout structure
> + * @in_vid_signed: used video input format
> + */
> +static void tvout_vip_set_in_vid_fmt(struct sti_tvout *tvout, u32 in_vid_fmt)
> +{
> +       u32 val = tvout_read(tvout, TVO_VIP_HDMI);
> +
> +       val &= ~TVO_IN_FMT_SIGNED;
> +       val |= in_vid_fmt;
> +       tvout_write(tvout, val, TVO_MAIN_IN_VID_FORMAT);
> +}
> +
> +/**
> + * Start VIP block for HDMI output
> + *
> + * @tvout: pointer on tvout structure
> + * @main_path: true if main path has to be used in the vip configuration
> + *       else aux path is used.
> + */
> +static void tvout_hdmi_start(struct sti_tvout *tvout, bool main_path)
> +{
> +       struct device_node *node = tvout->dev->of_node;
> +       bool sel_input_logic_inverted = false;
> +
> +       dev_dbg(tvout->dev, "%s\n", __func__);
> +
> +       if (main_path) {
> +               DRM_DEBUG_DRIVER("main vip for hdmi\n");
> +               /* select the input sync for hdmi = VTG set 1 */
> +               writel(TVO_SYNC_MAIN_VTG_SET_1,
> +                      tvout->regs + TVO_HDMI_SYNC_SEL);

btw, I notice a few places that bypass tvout_write()/tvout_readl()..
but if there is a reason, it at least doesn't seem obvious..

> +       } else {
> +               DRM_DEBUG_DRIVER("aux vip for hdmi\n");
> +               /* select the input sync for hdmi = VTG set 1 */
> +               writel(TVO_SYNC_AUX_VTG_SET_1, tvout->regs + TVO_HDMI_SYNC_SEL);
> +       }
> +
> +       /* set color channel order */
> +       tvout_vip_set_color_order(tvout,
> +                                 TVO_VIP_REORDER_CR_R_SEL,
> +                                 TVO_VIP_REORDER_Y_G_SEL,
> +                                 TVO_VIP_REORDER_CB_B_SEL);
> +
> +       /* set clipping mode (Limited range RGB/Y) */
> +       tvout_vip_set_clip_mode(tvout, TVO_VIP_CLIP_LIMITED_RANGE_RGB_Y);
> +
> +       /* set round mode (rounded to 8-bit per component) */
> +       tvout_vip_set_rnd(tvout, TVO_VIP_RND_8BIT_ROUNDED);
> +
> +       if (of_device_is_compatible(node, "st,stih407-tvout")) {
> +               /* set input video format */
> +               tvout_vip_set_in_vid_fmt(tvout->regs + TVO_MAIN_IN_VID_FORMAT,
> +                                        TVO_IN_FMT_SIGNED);
> +               sel_input_logic_inverted = true;
> +       }
> +
> +       /* input selection */
> +       tvout_vip_set_sel_input(tvout, main_path,
> +                       sel_input_logic_inverted, STI_TVOUT_VIDEO_OUT_RGB);
> +}
> +
> +/**
> + * Prepare/configure VIP block for HDMI output
> + *
> + * @tvout: pointer on tvout structure
> + */
> +static void tvout_hdmi_prepare(struct sti_tvout *tvout)
> +{
> +       dev_dbg(tvout->dev, "%s\n", __func__);
> +
> +       /* reset VIP register */
> +       writel(0x00000000, tvout->regs + TVO_VIP_HDMI);
> +}
> +
> +/**
> + * Disable HDMI VIP
> + *
> + * @tvout: pointer on tvout structure
> + */
> +static void tvout_hdmi_stop(struct sti_tvout *tvout)
> +{
> +       dev_dbg(tvout->dev, "%s\n", __func__);
> +
> +       /* reset VIP register */
> +       writel(0x00000000, tvout->regs + TVO_VIP_HDMI);
> +}
> +
> +/**
> + * Start HDF VIP and HD DAC
> + *
> + * @tvout: pointer on tvout structure
> + * @main_path: true if main path has to be used in the vip configuration
> + *       else aux path is used.
> + */
> +static void tvout_hda_start(struct sti_tvout *tvout, bool main_path)
> +{
> +       struct device_node *node = tvout->dev->of_node;
> +       bool sel_input_logic_inverted = false;
> +
> +       dev_dbg(tvout->dev, "%s\n", __func__);
> +
> +       if (!main_path) {
> +               DRM_ERROR("HD Analog on aux not implemented\n");
> +               return;
> +       }
> +
> +       DRM_DEBUG_DRIVER("main vip for HDF\n");
> +
> +       /* set color channel order */
> +       tvout_vip_set_color_order(tvout->regs + TVO_VIP_HDF,
> +                                 TVO_VIP_REORDER_CR_R_SEL,
> +                                 TVO_VIP_REORDER_Y_G_SEL,
> +                                 TVO_VIP_REORDER_CB_B_SEL);
> +
> +       /* set clipping mode (Limited range RGB/Y) */
> +       tvout_vip_set_clip_mode(tvout->regs + TVO_VIP_HDF,
> +                               TVO_VIP_CLIP_LIMITED_RANGE_CB_CR);
> +
> +       /* set round mode (rounded to 10-bit per component) */
> +       tvout_vip_set_rnd(tvout->regs + TVO_VIP_HDF, TVO_VIP_RND_10BIT_ROUNDED);
> +
> +       if (of_device_is_compatible(node, "st,stih407-tvout")) {
> +               /* set input video format */
> +               tvout_vip_set_in_vid_fmt(tvout, TVO_IN_FMT_SIGNED);
> +               sel_input_logic_inverted = true;
> +       }
> +
> +       /* Input selection */
> +       tvout_vip_set_sel_input(tvout->regs + TVO_VIP_HDF,
> +                               main_path,
> +                               sel_input_logic_inverted,
> +                               STI_TVOUT_VIDEO_OUT_YUV);
> +
> +       /* select the input sync for HD analog = VTG set 3
> +        * and HD DCS = VTG set 2 */
> +       writel((TVO_SYNC_MAIN_VTG_SET_2 << TVO_SYNC_HD_DCS_SHIFT) |
> +              TVO_SYNC_MAIN_VTG_SET_3, tvout->regs + TVO_HD_SYNC_SEL);
> +
> +       /* power up HD DAC */
> +       writel(0, tvout->regs + TVO_HD_DAC_CFG_OFF);
> +}
> +
> +/**
> + * Prepare/configure HDF VIP and HD DAC
> + *
> + * @tvout: pointer on tvout structure
> + */
> +static void tvout_hda_prepare(struct sti_tvout *tvout)
> +{
> +       dev_dbg(tvout->dev, "%s\n", __func__);
> +
> +       /* reset VIP register */
> +       writel(0x00000000, tvout->regs + TVO_VIP_HDF);
> +
> +       /* power down HD DAC */
> +       writel(1, tvout->regs + TVO_HD_DAC_CFG_OFF);
> +}
> +
> +/**
> + * Stop HDF VIP and HD DAC
> + *
> + * @tvout: pointer on tvout structure
> + */
> +static void tvout_hda_stop(struct sti_tvout *tvout)
> +{
> +       dev_dbg(tvout->dev, "%s\n", __func__);
> +
> +       /* reset VIP register */
> +       writel(0x00000000, tvout->regs + TVO_VIP_HDF);
> +
> +       /* power down HD DAC */
> +       writel(1, tvout->regs + TVO_HD_DAC_CFG_OFF);
> +}
> +
> +/**
> + * Forward drm display mode information to the connector
> + *
> + * @c: drm_connector
> + * @mode: mode to be set
> + * @main_path: indicated if the connector use the main or auxillary data path
> + *
> + * Return negative value if error occurs
> + */
> +int sti_tvout_set_mode(struct drm_connector *c,
> +               struct drm_display_mode *mode, bool main_path)
> +{
> +       struct sti_connector *connector = to_sti_connector(c);
> +
> +       if (connector)
> +               if (connector->set_mode)
> +                       return connector->set_mode(c, mode, main_path);

hmm, I do wonder a bit whether it would make more sense to split
sti_connector into a bridge + connector, and move stuff like
set_mode() into the bridge half of it?  Normally that sort of thing
would make more sense in the encoder, but for msm I actually have
separate hw blocks (ie. encoder is part of display controller block,
but hdmi_bridge or hypothetical dp_bridge/dsi_bridge, are a different
block with (in some cases) their own irq, (in all cases) their own
register space, etc.   So the bridge/connector split worked pretty
nicely there.  I didn't look closely at why you have things split up
this way, but if the reasons are similar then I'd suggest
sti_bridge/sti_connector..


> +
> +       return -EINVAL;
> +}
> +
> +/**
> + * Prepare / initialize depending on the connector type
> + *
> + * @connector: drm_connector
> + *
> + * Return negative value if error occurs
> + */
> +int sti_tvout_prepare(struct drm_connector *c)
> +{
> +       struct sti_connector *connector = to_sti_connector(c);
> +       struct sti_tvout *tvout = dev_get_drvdata(connector->master);
> +       int ret;
> +
> +       dev_dbg(tvout->dev, "%s\n", __func__);
> +
> +       if (connector)
> +               if (connector->prepare)
> +                       connector->prepare(c);
> +
> +       switch (connector->type) {

hmm, ok, so couple issues here..

first, either that 'if (connector)' above is pointless (because you
never expect connector to be NULL) or you're going to crash deref'ing
connector->type.

Also, what is the purpose of this switch, vs just having the connector
specific implementation of connector->prepare() (which maybe should
actually be in sti_bridge) do call right thing?

Same comment for _commit() and _disable() below.

BR,
-R

> +       case STI_CONNECTOR_HDMI:
> +               tvout_hdmi_prepare(tvout);
> +               ret = 0;
> +               break;
> +       case STI_CONNECTOR_HDA:
> +               tvout_hda_prepare(tvout);
> +               ret = 0;
> +               break;
> +       case STI_CONNECTOR_DVO:
> +       case STI_CONNECTOR_DENC:
> +       default:
> +               /* not yet supported */
> +               ret = -EINVAL;
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
> +/**
> + * Commit / start depending on the connector type
> + *
> + * @tvout: pointer on tvout structure
> + * @type: type of connector
> + * @main_path: true if main path need to be use (false for aux path)
> + *
> + * Return negative value if error occurs
> + */
> +int sti_tvout_commit(struct drm_connector *c, bool main_path)
> +{
> +       struct sti_connector *connector = to_sti_connector(c);
> +       struct sti_tvout *tvout = dev_get_drvdata(connector->master);
> +       int type = connector->type;
> +       u32 matrix_offset;
> +       unsigned int i;
> +
> +       dev_dbg(tvout->dev, "%s\n", __func__);
> +
> +       if (!connector)
> +               return -EINVAL;
> +
> +       if (connector->start) {
> +               if (connector->start(c)) {
> +                       DRM_ERROR("Unable to properly start connector\n");
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       /* set preformatter matrix */
> +       matrix_offset = main_path ? TVO_CSC_MAIN_M0 : TVO_CSC_AUX_M0;
> +       for (i = 0; i < 8; i++)
> +               writel(rgb_to_ycbcr_601[i],
> +                      tvout->regs + matrix_offset + (i * 4));
> +
> +       switch (type) {
> +       case STI_CONNECTOR_HDMI:
> +               tvout_hdmi_start(tvout, main_path);
> +               return 0;
> +       case STI_CONNECTOR_HDA:
> +               tvout_hda_start(tvout, main_path);
> +               return 0;
> +       case STI_CONNECTOR_DVO:
> +       case STI_CONNECTOR_DENC:
> +       default:
> +               /* not yet supported */
> +               return -EINVAL;
> +       }
> +}
> +
> +/**
> + * Disable / stop the tvout depending on the connector type
> + *
> + * @tvout: pointer on tvout structure
> + * @type: type of connector
> + */
> +void sti_tvout_disable(struct drm_connector *c)
> +{
> +       struct sti_connector *connector = to_sti_connector(c);
> +       struct sti_tvout *tvout = dev_get_drvdata(connector->master);
> +       int type = connector->type;
> +
> +       switch (type) {
> +       case STI_CONNECTOR_HDMI:
> +               tvout_hdmi_stop(tvout);
> +               break;
> +       case STI_CONNECTOR_HDA:
> +               tvout_hda_stop(tvout);
> +               break;
> +       case STI_CONNECTOR_DVO:
> +       case STI_CONNECTOR_DENC:
> +       default:
> +               /* not yet supported */
> +               return;
> +       }
> +
> +       if (connector)
> +               if (connector->stop)
> +                       connector->stop(c);
> +}
> +
> +static int sti_tvout_bind(struct device *dev, struct device *master, void *data)
> +{
> +       return 0;
> +}
> +
> +static void sti_tvout_unbind(struct device *dev, struct device *master,
> +       void *data)
> +{
> +       /* do nothing */
> +}
> +
> +static const struct component_ops sti_tvout_ops = {
> +       .bind   = sti_tvout_bind,
> +       .unbind = sti_tvout_unbind,
> +};
> +
> +static int compare_of(struct device *dev, void *data)
> +{
> +       struct device_node *np = data;
> +
> +       return dev->of_node == np;
> +}
> +
> +static int sti_tvout_add_components(struct device *master, struct master *m)
> +{
> +       struct device_node *np  = master->of_node;
> +       struct device_node *child_np;
> +
> +       child_np = of_get_next_available_child(np, NULL);
> +
> +       while (child_np) {
> +               DRM_INFO("TVout add child %s\n", child_np->name);
> +               component_master_add_child(m, compare_of, child_np);
> +               of_node_put(child_np);
> +               child_np = of_get_next_available_child(np, child_np);
> +       }
> +
> +       return 0;
> +}
> +
> +static int sti_tvout_master_bind(struct device *dev)
> +{
> +       return 0;
> +}
> +
> +static void sti_tvout_master_unbind(struct device *dev)
> +{
> +       /* do nothing */
> +}
> +
> +static const struct component_master_ops sti_tvout_master_ops = {
> +       .add_components = sti_tvout_add_components,
> +       .bind = sti_tvout_master_bind,
> +       .unbind = sti_tvout_master_unbind,
> +};
> +
> +static int sti_tvout_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct device_node *node = dev->of_node;
> +       struct sti_tvout *tvout;
> +       struct resource *res;
> +
> +       DRM_INFO("%s\n", __func__);
> +
> +       if (!node)
> +               return -ENODEV;
> +
> +       tvout = devm_kzalloc(dev, sizeof(*tvout), GFP_KERNEL);
> +       if (!tvout)
> +               return -ENOMEM;
> +
> +       DRM_INFO("%s tvout %p\n", __func__, tvout);
> +
> +       tvout->dev = dev;
> +       DRM_INFO("%s tvout->dev %p\n", __func__, tvout->dev);
> +
> +       /* get Memory ressources */
> +       res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "tvout-reg");
> +       if (!res) {
> +               DRM_ERROR("Invalid glue resource\n");
> +               return -ENOMEM;
> +       }
> +       tvout->regs = devm_ioremap_nocache(dev, res->start, resource_size(res));
> +       if (IS_ERR(tvout->regs))
> +               return PTR_ERR(tvout->regs);
> +
> +       /* get reset resources */
> +       tvout->reset = devm_reset_control_get(dev, "tvout");
> +       /* take tvout out of reset */
> +       if (!IS_ERR(tvout->reset))
> +               reset_control_deassert(tvout->reset);
> +
> +       platform_set_drvdata(pdev, tvout);
> +
> +       of_platform_populate(node, NULL, NULL, dev);
> +
> +       component_master_add(&pdev->dev, &sti_tvout_master_ops);
> +
> +       return component_add(&pdev->dev, &sti_tvout_ops);
> +}
> +
> +static int sti_tvout_remove(struct platform_device *pdev)
> +{
> +       component_master_del(&pdev->dev, &sti_tvout_master_ops);
> +       component_del(&pdev->dev, &sti_tvout_ops);
> +       return 0;
> +}
> +
> +static struct of_device_id tvout_of_match[] = {
> +       { .compatible = "st,stih416-tvout", },
> +       { .compatible = "st,stih407-tvout", },
> +       { /* end node */ }
> +};
> +MODULE_DEVICE_TABLE(of, tvout_of_match);
> +
> +struct platform_driver sti_tvout_driver = {
> +       .driver = {
> +               .name = "sti-tvout",
> +               .owner = THIS_MODULE,
> +               .of_match_table = tvout_of_match,
> +       },
> +       .probe = sti_tvout_probe,
> +       .remove = sti_tvout_remove,
> +};
> +
> +module_platform_driver(sti_tvout_driver);
> diff --git a/drivers/gpu/drm/sti/sti_tvout.h b/drivers/gpu/drm/sti/sti_tvout.h
> new file mode 100644
> index 0000000..81dceff
> --- /dev/null
> +++ b/drivers/gpu/drm/sti/sti_tvout.h
> @@ -0,0 +1,18 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2014
> + * Author: Vincent Abriou <vincent.abriou@st.com> for STMicroelectronics.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#ifndef _STI_TVOUT_H_
> +#define _STI_TVOUT_H_
> +
> +#include <drm/drmP.h>
> +
> +int  sti_tvout_set_mode(struct drm_connector *c,
> +               struct drm_display_mode *mode, bool main_path);
> +int  sti_tvout_prepare(struct drm_connector *c);
> +int  sti_tvout_commit(struct drm_connector *c, bool main_path);
> +void sti_tvout_disable(struct drm_connector *c);
> +
> +#endif
> --
> 1.9.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
