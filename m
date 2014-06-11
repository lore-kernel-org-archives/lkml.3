Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaFKS7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:59:50 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:60707 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaFKS7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:59:49 -0400
MIME-Version: 1.0
In-Reply-To: <1401345427-5299-11-git-send-email-benjamin.gaignard@linaro.org>
References: <1401345427-5299-1-git-send-email-benjamin.gaignard@linaro.org>
	<1401345427-5299-11-git-send-email-benjamin.gaignard@linaro.org>
Date: Wed, 11 Jun 2014 14:59:48 -0400
Message-ID: <CAF6AEGvdBP86k=vZQHoJRJSjdSbC7dVgJm7jErnj9c-bY2G3=Q@mail.gmail.com>
Subject: Re: [PATCH v4 10/11] drm: sti: add Compositor
From: Rob Clark <robdclark@gmail.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 2:37 AM, Benjamin Gaignard
<benjamin.gaignard@linaro.org> wrote:
> Compositor control all the input sub-device (VID, GDP)
> and the mixer(s).
> It is the main entry point for composition.
> Layer interface is used to control the abstracted layers.
>
> Add debug in mixer, GDP and VID
>
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> ---
>  drivers/gpu/drm/sti/Kconfig          |   1 +
>  drivers/gpu/drm/sti/Makefile         |   2 +
>  drivers/gpu/drm/sti/sti_compositor.c | 220 ++++++++++++++++++++++++
>  drivers/gpu/drm/sti/sti_compositor.h |  90 ++++++++++
>  drivers/gpu/drm/sti/sti_gdp.c        |  30 ++++
>  drivers/gpu/drm/sti/sti_layer.c      | 312 +++++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/sti/sti_mixer.c      |   6 +
>  drivers/gpu/drm/sti/sti_vid.c        |   7 +
>  8 files changed, 668 insertions(+)
>  create mode 100644 drivers/gpu/drm/sti/sti_compositor.c
>  create mode 100644 drivers/gpu/drm/sti/sti_compositor.h
>  create mode 100644 drivers/gpu/drm/sti/sti_layer.c
>
> diff --git a/drivers/gpu/drm/sti/Kconfig b/drivers/gpu/drm/sti/Kconfig
> index cbd664b..1013570 100644
> --- a/drivers/gpu/drm/sti/Kconfig
> +++ b/drivers/gpu/drm/sti/Kconfig
> @@ -1,5 +1,6 @@
>  config DRM_STI
>         bool "DRM Support for STMicroelectronics SoC stiH41x Series"
>         depends on DRM && (SOC_STIH415 || SOC_STIH416 || ARCH_MULTIPLATFORM)
> +       select DRM_KMS_CMA_HELPER
>         help
>           Choose this option to enable DRM on STM stiH41x chipset
> diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
> index ce03e15..a0612cc 100644
> --- a/drivers/gpu/drm/sti/Makefile
> +++ b/drivers/gpu/drm/sti/Makefile
> @@ -1,11 +1,13 @@
>  obj-$(CONFIG_DRM_STI) += \
>         sti_vtg.o \
>         sti_vtac.o \
> +       sti_compositor.o \
>         sti_hdmi.o \
>         sti_hdmi_tx3g0c55phy.o \
>         sti_hdmi_tx3g4c28phy.o \
>         sti_hda.o \
>         sti_tvout.o \
> +       sti_layer.o \
>         sti_mixer.o \
>         sti_gdp.o \
>         sti_vid.o
> \ No newline at end of file
> diff --git a/drivers/gpu/drm/sti/sti_compositor.c b/drivers/gpu/drm/sti/sti_compositor.c
> new file mode 100644
> index 0000000..3100917
> --- /dev/null
> +++ b/drivers/gpu/drm/sti/sti_compositor.c
> @@ -0,0 +1,220 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2014
> + * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
> + *          Fabien Dessenne <fabien.dessenne@st.com>
> + *          for STMicroelectronics.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#include <linux/component.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/reset.h>
> +
> +#include <drm/drmP.h>
> +
> +#include "sti_compositor.h"
> +#include "sti_gdp.h"
> +#include "sti_vtg.h"
> +
> +/*
> + * stiH407 compositor properties
> + */
> +struct sti_compositor_data stih407_compositor_data = {
> +       .nb_subdev = 6,
> +       .subdev_desc = {
> +                       {STI_GPD_SUBDEV, (int)STI_GDP_0, 0x100},
> +                       {STI_GPD_SUBDEV, (int)STI_GDP_1, 0x200},
> +                       {STI_GPD_SUBDEV, (int)STI_GDP_2, 0x300},
> +                       {STI_GPD_SUBDEV, (int)STI_GDP_3, 0x400},
> +                       {STI_VID_SUBDEV, (int)STI_VID_0, 0x700},
> +                       {STI_MIXER_MAIN_SUBDEV, STI_MIXER_MAIN, 0xC00}
> +       },
> +};
> +
> +/*
> + * stiH416 compositor properties
> + * Note:
> + * on stih416 MIXER_AUX has a different base address from MIXER_MAIN
> + * Moreover, GDPx is different for Main and Aux Mixer. So this subdev map does
> + * not fit for stiH416 if we want to enable the MIXER_AUX.
> + */
> +struct sti_compositor_data stih416_compositor_data = {
> +       .nb_subdev = 3,
> +       .subdev_desc = {
> +                       {STI_GPD_SUBDEV, (int)STI_GDP_0, 0x100},
> +                       {STI_GPD_SUBDEV, (int)STI_GDP_1, 0x200},
> +                       {STI_MIXER_MAIN_SUBDEV, STI_MIXER_MAIN, 0xC00}
> +       },
> +};
> +
> +static int sti_compositor_init_subdev(struct sti_compositor *compo,
> +               struct sti_compositor_subdev_descriptor *desc,
> +               unsigned int array_size)
> +{
> +       unsigned int i, mixer_id = 0, layer_id = 0;
> +
> +       for (i = 0; i < array_size; i++) {
> +               switch (desc[i].type) {
> +               case STI_MIXER_MAIN_SUBDEV:
> +               case STI_MIXER_AUX_SUBDEV:
> +                       compo->mixer[mixer_id++] =
> +                           sti_mixer_create(compo->dev, desc[i].id,
> +                                            compo->regs + desc[i].offset);
> +                       break;
> +               case STI_GPD_SUBDEV:
> +               case STI_VID_SUBDEV:
> +                       compo->layer[layer_id++] =
> +                           sti_layer_create(compo->dev, desc[i].id,
> +                                            compo->regs + desc[i].offset);
> +                       break;
> +                       /* case STI_CURSOR_SUBDEV : TODO */
> +               default:
> +                       DRM_ERROR("Unknow subdev compoment type\n");
> +                       return 1;
> +               }
> +
> +       }
> +       compo->nb_mixers = mixer_id;
> +       compo->nb_layers = layer_id;
> +
> +       return 0;
> +}
> +
> +static int sti_compositor_bind(struct device *dev, struct device *master,
> +       void *data)
> +{
> +       /* to be filled with drm driver functions */
> +       return 0;
> +}
> +
> +static void sti_compositor_unbind(struct device *dev, struct device *master,
> +       void *data)
> +{
> +       /* do nothing */
> +}
> +
> +static const struct component_ops sti_compositor_ops = {
> +       .bind   = sti_compositor_bind,
> +       .unbind = sti_compositor_unbind,
> +};
> +
> +static const struct of_device_id compositor_of_match[] = {
> +       {
> +               .compatible = "st,stih416-compositor",
> +               .data = &stih416_compositor_data,
> +       }, {
> +               .compatible = "st,stih407-compositor",
> +               .data = &stih407_compositor_data,
> +       }, {
> +               /* end node */
> +       }
> +};
> +MODULE_DEVICE_TABLE(of, compositor_of_match);
> +
> +static int sti_compositor_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct device_node *np = dev->of_node;
> +       struct device_node *vtg_np;
> +       struct sti_compositor *compo;
> +       struct resource *res;
> +       int err;
> +
> +       compo = devm_kzalloc(dev, sizeof(*compo), GFP_KERNEL);
> +       if (!compo) {
> +               DRM_ERROR("Failed to allocate compositor context\n");
> +               return -ENOMEM;
> +       }
> +       compo->dev = dev;
> +
> +       /* populate data structure depending on compatibility */
> +       BUG_ON(!of_match_node(compositor_of_match, np)->data);
> +
> +       memcpy(&compo->data, of_match_node(compositor_of_match, np)->data,
> +              sizeof(struct sti_compositor_data));
> +
> +       /* Get Memory ressources */
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (res == NULL) {
> +               DRM_ERROR("Get memory resource failed\n");
> +               return -ENXIO;
> +       }
> +       compo->regs = devm_ioremap(dev, res->start, resource_size(res));
> +       if (compo->regs == NULL) {
> +               DRM_ERROR("Register mapping failed\n");
> +               return -ENXIO;
> +       }
> +
> +       /* Get clock resources */
> +       compo->clk_compo_main = devm_clk_get(dev, "compo_main");
> +       if (IS_ERR(compo->clk_compo_main)) {
> +               DRM_ERROR("Cannot get compo_main clock\n");
> +               return PTR_ERR(compo->clk_compo_main);
> +       }
> +
> +       compo->clk_compo_aux = devm_clk_get(dev, "compo_aux");
> +       if (IS_ERR(compo->clk_compo_aux)) {
> +               DRM_ERROR("Cannot get compo_aux clock\n");
> +               return PTR_ERR(compo->clk_compo_aux);
> +       }
> +
> +       compo->clk_pix_main = devm_clk_get(dev, "pix_main");
> +       if (IS_ERR(compo->clk_pix_main)) {
> +               DRM_ERROR("Cannot get pix_main clock\n");
> +               return PTR_ERR(compo->clk_pix_main);
> +       }
> +
> +       compo->clk_pix_aux = devm_clk_get(dev, "pix_aux");
> +       if (IS_ERR(compo->clk_pix_aux)) {
> +               DRM_ERROR("Cannot get pix_aux clock\n");
> +               return PTR_ERR(compo->clk_pix_aux);
> +       }
> +
> +       /* Get reset resources */
> +       compo->rst_main = devm_reset_control_get(dev, "compo-main");
> +       /* Take compo main out of reset */
> +       if (!IS_ERR(compo->rst_main))
> +               reset_control_deassert(compo->rst_main);
> +
> +       compo->rst_aux = devm_reset_control_get(dev, "compo-aux");
> +       /* Take compo aux out of reset */
> +       if (!IS_ERR(compo->rst_aux))
> +               reset_control_deassert(compo->rst_aux);
> +
> +       vtg_np = of_parse_phandle(pdev->dev.of_node, "st,vtg", 0);
> +       if (vtg_np)
> +               compo->vtg_main = of_vtg_find(vtg_np);
> +
> +       vtg_np = of_parse_phandle(pdev->dev.of_node, "st,vtg", 1);
> +       if (vtg_np)
> +               compo->vtg_aux = of_vtg_find(vtg_np);
> +
> +       /* Initialize compositor subdevices */
> +       err = sti_compositor_init_subdev(compo, compo->data.subdev_desc,
> +                                        compo->data.nb_subdev);
> +       if (err)
> +               return err;
> +
> +       platform_set_drvdata(pdev, compo);
> +
> +       return component_add(&pdev->dev, &sti_compositor_ops);
> +}
> +
> +static int sti_compositor_remove(struct platform_device *pdev)
> +{
> +       component_del(&pdev->dev, &sti_compositor_ops);
> +       return 0;
> +}
> +
> +static struct platform_driver sti_compositor_driver = {
> +       .driver = {
> +               .name = "sti-compositor",
> +               .owner = THIS_MODULE,
> +               .of_match_table = compositor_of_match,
> +       },
> +       .probe = sti_compositor_probe,
> +       .remove = sti_compositor_remove,
> +};
> +
> +module_platform_driver(sti_compositor_driver);
> diff --git a/drivers/gpu/drm/sti/sti_compositor.h b/drivers/gpu/drm/sti/sti_compositor.h
> new file mode 100644
> index 0000000..3ea19db
> --- /dev/null
> +++ b/drivers/gpu/drm/sti/sti_compositor.h
> @@ -0,0 +1,90 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2014
> + * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
> + *          Fabien Dessenne <fabien.dessenne@st.com>
> + *          for STMicroelectronics.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#ifndef _STI_COMPOSITOR_H_
> +#define _STI_COMPOSITOR_H_
> +
> +#include <linux/clk.h>
> +#include <linux/kernel.h>
> +
> +#include "sti_layer.h"
> +#include "sti_mixer.h"
> +
> +#define WAIT_NEXT_VSYNC_MS      50 /*ms*/
> +
> +#define STI_MAX_LAYER 8
> +#define STI_MAX_MIXER 2
> +
> +enum sti_compositor_subdev_type {
> +       STI_MIXER_MAIN_SUBDEV,
> +       STI_MIXER_AUX_SUBDEV,
> +       STI_GPD_SUBDEV,
> +       STI_VID_SUBDEV,
> +       STI_CURSOR_SUBDEV,
> +};
> +
> +struct sti_compositor_subdev_descriptor {
> +       enum sti_compositor_subdev_type type;
> +       int id;
> +       unsigned int offset;
> +};
> +
> +/**
> + * STI Compositor data structure
> + *
> + * @nb_subdev: number of subdevices supported by the compositor
> + * @subdev_desc: subdev list description
> + */
> +#define MAX_SUBDEV 9
> +struct sti_compositor_data {
> +       unsigned int nb_subdev;
> +       struct sti_compositor_subdev_descriptor subdev_desc[MAX_SUBDEV];
> +};
> +
> +/**
> + * STI Compositor structure
> + *
> + * @dev: driver device
> + * @regs: registers (main)
> + * @data: device data
> + * @clk_compo_main: clock for main compo
> + * @clk_compo_aux: clock for aux compo
> + * @clk_pix_main: pixel clock for main path
> + * @clk_pix_aux: pixel clock for aux path
> + * @rst_main: reset control of the main path
> + * @rst_aux: reset control of the aux path
> + * @mixer: array of mixers
> + * @vtg_main: vtg for main data path
> + * @vtg_aux: vtg for auxillary data path
> + * @layer: array of layers
> + * @nb_mixers: number of mixers for this compositor
> + * @nb_layers: number of layers (GDP,VID,...) for this compositor
> + * @enable: true if compositor is enable else false
> + * @vtg_vblank_nb: callback for VTG VSYNC notification
> + */
> +struct sti_compositor {
> +       struct device *dev;
> +       void __iomem *regs;
> +       struct sti_compositor_data data;
> +       struct clk *clk_compo_main;
> +       struct clk *clk_compo_aux;
> +       struct clk *clk_pix_main;
> +       struct clk *clk_pix_aux;
> +       struct reset_control *rst_main;
> +       struct reset_control *rst_aux;
> +       struct sti_mixer *mixer[STI_MAX_MIXER];
> +       struct sti_vtg *vtg_main;
> +       struct sti_vtg *vtg_aux;
> +       struct sti_layer *layer[STI_MAX_LAYER];
> +       int nb_mixers;
> +       int nb_layers;
> +       bool enable;
> +       struct notifier_block vtg_vblank_nb;
> +};
> +
> +#endif
> diff --git a/drivers/gpu/drm/sti/sti_gdp.c b/drivers/gpu/drm/sti/sti_gdp.c
> index a014214..af5edc5 100644
> --- a/drivers/gpu/drm/sti/sti_gdp.c
> +++ b/drivers/gpu/drm/sti/sti_gdp.c
> @@ -9,6 +9,7 @@
>  #include <linux/clk.h>
>  #include <linux/dma-mapping.h>
>
> +#include "sti_compositor.h"
>  #include "sti_gdp.h"
>  #include "sti_layer.h"
>  #include "sti_vtg.h"
> @@ -137,6 +138,9 @@ static struct sti_gdp_node_list *sti_gdp_get_free_nodes(struct sti_layer *layer)
>                         return &gdp->node_list[i];
>
>  end:
> +       DRM_DEBUG_DRIVER("Warning, inconsistent NVN for %s: 0x%08X\n",
> +                       sti_layer_to_str(layer), hw_nvn);
> +
>         return &gdp->node_list[0];
>  }
>
> @@ -169,6 +173,8 @@ struct sti_gdp_node_list *sti_gdp_get_current_nodes(struct sti_layer *layer)
>                         return &gdp->node_list[i];
>
>  end:
> +       DRM_DEBUG_DRIVER("Warning, NVN 0x%08X for %s does not match any node\n",
> +                               hw_nvn, sti_layer_to_str(layer));
>         return NULL;
>  }
>
> @@ -189,6 +195,7 @@ static int sti_gdp_prepare_layer(void *lay, bool first_prepare)
>         struct sti_gdp_node *top_field, *btm_field;
>         struct drm_display_mode *mode = layer->mode;
>         struct device *dev = layer->gdp->dev;
> +       struct sti_compositor *compo = dev_get_drvdata(dev);
>         int format;
>         unsigned int depth, bpp;
>         int rate = mode->clock * 1000;
> @@ -199,6 +206,9 @@ static int sti_gdp_prepare_layer(void *lay, bool first_prepare)
>         top_field = list->top_field;
>         btm_field = list->btm_field;
>
> +       dev_dbg(dev, "%s %s top_node:0x%p btm_node:0x%p\n", __func__,
> +                       sti_layer_to_str(layer), top_field, btm_field);
> +
>         /* Build the top field from layer params */
>         top_field->gam_gdp_agc = GAM_GDP_AGC_FULL_RANGE;
>         top_field->gam_gdp_ctl = WAIT_NEXT_VSYNC;
> @@ -243,6 +253,14 @@ static int sti_gdp_prepare_layer(void *lay, bool first_prepare)
>                     layer->pitches[0];
>
>         if (first_prepare) {
> +               /* Register gdp callback */
> +               if (sti_vtg_register_client(layer->mixer_id == STI_MIXER_MAIN ?
> +                               compo->vtg_main : compo->vtg_aux,
> +                               &layer->gdp->vtg_field_nb, layer->mixer_id)) {
> +                       DRM_ERROR("Cannot register VTG notifier\n");
> +                       return 1;
> +               }
> +
>                 /* Set and enable gdp clock */
>                 if (layer->gdp->clk_pix) {
>                         res = clk_set_rate(layer->gdp->clk_pix, rate);
> @@ -288,6 +306,9 @@ static int sti_gdp_commit_layer(void *lay)
>         u32 dma_updated_btm = virt_to_dma(gdp->dev, updated_btm_node);
>         struct sti_gdp_node_list *curr_list = sti_gdp_get_current_nodes(layer);
>
> +       dev_dbg(gdp->dev, "%s %s top/btm_node:0x%p/0x%p\n", __func__,
> +                       sti_layer_to_str(layer),
> +                       updated_top_node, updated_btm_node);
>         dev_dbg(gdp->dev, "Current NVN:0x%X\n",
>                 readl(gdp->regs + GAM_GDP_NVN_OFFSET));
>         dev_dbg(gdp->dev, "Posted buff: %lx current buff: %x\n",
> @@ -297,6 +318,8 @@ static int sti_gdp_commit_layer(void *lay)
>         if (curr_list == NULL) {
>                 /* First update or invalid node should directly write in the
>                  * hw register */
> +               DRM_DEBUG_DRIVER("%s first update (or invalid node)",
> +                               sti_layer_to_str(layer));
>                 writel(gdp->is_curr_top == true ?
>                                 dma_updated_btm : dma_updated_top,
>                                 gdp->regs + GAM_GDP_NVN_OFFSET);
> @@ -335,6 +358,9 @@ static int sti_gdp_disable_layer(void *lay)
>         unsigned int i;
>         struct sti_layer *layer = (struct sti_layer *)lay;
>         struct sti_gdp *gdp = layer->gdp;
> +       struct sti_compositor *compo = dev_get_drvdata(layer->gdp->dev);
> +
> +       DRM_DEBUG_DRIVER("%s\n", sti_layer_to_str(layer));
>
>         /* Set the nodes as 'to be ignored on mixer' */
>         for (i = 0; i < GDP_NODE_NB_BANK; i++) {
> @@ -342,6 +368,10 @@ static int sti_gdp_disable_layer(void *lay)
>                 gdp->node_list[i].btm_field->gam_gdp_ppt |= GAM_GDP_PPT_IGNORE;
>         }
>
> +       if (sti_vtg_unregister_client(layer->mixer_id == STI_MIXER_MAIN ?
> +                       compo->vtg_main : compo->vtg_aux, &gdp->vtg_field_nb))
> +               DRM_DEBUG_DRIVER("Warning: cannot unregister VTG notifier\n");
> +
>         if (gdp->clk_pix)
>                 clk_disable_unprepare(gdp->clk_pix);
>
> diff --git a/drivers/gpu/drm/sti/sti_layer.c b/drivers/gpu/drm/sti/sti_layer.c
> new file mode 100644
> index 0000000..cc7186d
> --- /dev/null
> +++ b/drivers/gpu/drm/sti/sti_layer.c
> @@ -0,0 +1,312 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2014
> + * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
> + *          Fabien Dessenne <fabien.dessenne@st.com>
> + *          for STMicroelectronics.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#include <drm/drmP.h>
> +#include <drm/drm_gem_cma_helper.h>
> +#include <drm/drm_fb_cma_helper.h>
> +
> +#include "sti_compositor.h"
> +#include "sti_layer.h"
> +
> +#define STI_FPS_INTERVAL_MS     3000
> +
> +struct sti_layer *sti_layer_find_layer(struct sti_layer *layer[],
> +                                      enum sti_layer_desc desc)
> +{
> +       unsigned int i;
> +
> +       for (i = 0; i < STI_MAX_LAYER; i++)
> +               if (layer[i] && (layer[i]->desc == desc))
> +                       return layer[i];
> +       return NULL;
> +}
> +
> +const char *sti_layer_to_str(struct sti_layer *layer)
> +{
> +       switch (layer->desc) {
> +       case STI_GDP_0:
> +               return "GDP0";
> +       case STI_GDP_1:
> +               return "GDP1";
> +       case STI_GDP_2:
> +               return "GDP2";
> +       case STI_GDP_3:
> +               return "GDP3";
> +       case STI_VID_0:
> +               return "VID0";
> +       case STI_VID_1:
> +               return "VID1";
> +       case STI_CURSOR:
> +               return "CURSOR";
> +       default:
> +               return "<UNKNOWN LAYER>";
> +       }
> +}
> +
> +static int timespec_ms_diff(struct timespec lhs, struct timespec rhs)
> +{
> +       struct timespec tmp_ts = timespec_sub(lhs, rhs);
> +       s64 tmp_ns = timespec_to_ns(&tmp_ts);
> +
> +       do_div(tmp_ns, NSEC_PER_MSEC);
> +
> +       return (int) tmp_ns;
> +}
> +
> +static void sti_layer_update_fps(struct sti_layer *layer)
> +{
> +       struct timespec now;
> +       struct sti_fps_info *fps;
> +       int fpks, ms_since_last, num_frames;
> +
> +       getrawmonotonic(&now);
> +
> +       fps = &layer->fps_info;
> +       fps->curr_frame_counter++;
> +       ms_since_last = timespec_ms_diff(now, fps->last_timestamp);
> +       num_frames = fps->curr_frame_counter - fps->last_frame_counter;
> +
> +       if (num_frames > 1 && ms_since_last >= STI_FPS_INTERVAL_MS) {
> +               fps->last_timestamp = now;
> +               fps->last_frame_counter = fps->curr_frame_counter;
> +               fpks = (num_frames * 1000000) / ms_since_last;
> +               if (fps->output)
> +                       DRM_INFO("%s @ %d.%.3d fps\n", sti_layer_to_str(layer),
> +                                fpks / 1000, fpks % 1000);
> +       }
> +}

btw, this fps stuff, as far as I can tell is only for perf/debug
traces?  In which case, I'd drop this (and 'struct sti_fps_info', etc)
and look into adding trace events instead.  This would let you log in
more detail, correlated to cpu load (and eventual fence traces, and
whatever other gpu related traces you feel like adding). That gives a
much more detailed view of system performance.  I'd done something
similar in msm, although not pushed upstream yet:

http://bloggingthemonkey.blogspot.com/2013/09/freedreno-update-moar-fps.html

but when Maarten's fence traces are removed, I should be able to
replace most of the msm specific trace events with generic ones (which
was only reason I didn't push msm trace events upstream yet).

I would suggest adding the trace events as a follow-up patch, rather
than as part of the initial patchset.  Or at least I'm not sure
offhand if trace events are considered userspace ABI or not, so having
it as a follow-up patch avoids delaying the main part of the driver
review.


> +
> +struct sti_layer *sti_layer_create(struct device *dev, int desc,
> +                                  void __iomem *baseaddr)
> +{
> +       struct sti_layer *layer;
> +
> +       layer = devm_kzalloc(dev, sizeof(*layer), GFP_KERNEL);
> +       if (!layer) {
> +               DRM_ERROR("Failed to allocate memory for layer\n");
> +               return NULL;
> +       }
> +
> +       switch (desc & STI_LAYER_TYPE_MASK) {
> +       case STI_GDP:
> +               layer->gdp = sti_gdp_create(dev, desc, baseaddr);
> +               if (!layer->gdp)
> +                       goto err;
> +               break;
> +       case STI_VID:
> +               layer->vid = sti_vid_create(dev, baseaddr);
> +               if (!layer->vid)
> +                       goto err;
> +               break;
> +       default:
> +               goto err;
> +       }
> +
> +       layer->desc = desc;
> +       DRM_DEBUG_DRIVER("%s created\n", sti_layer_to_str(layer));
> +
> +       return layer;
> +err:
> +       devm_kfree(dev, layer);
> +       DRM_ERROR("Failed to create layer\n");
> +       return NULL;
> +}
> +
> +int sti_layer_prepare(struct sti_layer *layer, struct drm_framebuffer *fb,
> +                     struct drm_display_mode *mode, int mixer_id,
> +                     int dest_x, int dest_y, int dest_w, int dest_h,
> +                     int src_x, int src_y, int src_w, int src_h)
> +{
> +       int ret;
> +       unsigned int i;
> +       struct drm_gem_cma_object *cma_obj;
> +
> +       if (!layer || !fb || !mode) {
> +               DRM_ERROR("Null fb, layer or mode\n");
> +               return 1;
> +       }
> +
> +       cma_obj = drm_fb_cma_get_gem_obj(fb, 0);
> +       if (!cma_obj) {
> +               DRM_ERROR("Can't get CMA GEM object for fb\n");
> +               return 1;
> +       }
> +
> +       layer->fb = fb;
> +       layer->mode = mode;
> +       layer->mixer_id = mixer_id;
> +       layer->dst_x = dest_x;
> +       layer->dst_y = dest_y;
> +       layer->dst_w = clamp_val(dest_w, 0, mode->crtc_hdisplay - dest_x);
> +       layer->dst_h = clamp_val(dest_h, 0, mode->crtc_vdisplay - dest_y);
> +       layer->src_x = src_x;
> +       layer->src_y = src_y;
> +       layer->src_w = src_w;
> +       layer->src_h = src_h;
> +       layer->format = fb->pixel_format;
> +       layer->paddr = cma_obj->paddr;
> +       for (i = 0; i < 4; i++) {
> +               layer->pitches[i] = fb->pitches[i];
> +               layer->offsets[i] = fb->offsets[i];
> +       }
> +
> +       DRM_DEBUG_DRIVER("%s is associated with mixer_id %d\n",
> +                        sti_layer_to_str(layer),
> +                        layer->mixer_id);
> +       DRM_DEBUG_DRIVER("%s dst=(%dx%d)@(%d,%d) - src=(%dx%d)@(%d,%d)\n",
> +                        sti_layer_to_str(layer),
> +                        layer->dst_w, layer->dst_h, layer->dst_x, layer->dst_y,
> +                        layer->src_w, layer->src_h, layer->src_x,
> +                        layer->src_y);
> +
> +       DRM_DEBUG_DRIVER("drm FB:%d format:%.4s phys@:0x%lx\n", fb->base.id,
> +                        (char *)&layer->format, (unsigned long)layer->paddr);
> +
> +       /* Prepare layer specificities */
> +       switch (layer->desc & STI_LAYER_TYPE_MASK) {

you do have this 'switch (layer_type)' thing going in a few places..
maybe time for 'struct sti_layer_funcs', and then at init time plug in
appropriate gdp_layer_funcs/sti_layer_funcs/etc depending on layer
type?

BR,
-R

> +       case STI_GDP:
> +               if (!layer->gdp)
> +                       goto err_no_prepare;
> +               ret = layer->gdp->prepare(layer, !layer->enabled);
> +               break;
> +       case STI_VID:
> +               if (!layer->vid)
> +                       goto err_no_prepare;
> +               ret = layer->vid->prepare(layer, !layer->enabled);
> +               break;
> +       default:
> +               goto err_no_prepare;
> +       }
> +
> +       if (!ret)
> +               layer->enabled = true;
> +
> +       return ret;
> +
> +err_no_prepare:
> +       DRM_ERROR("Cannot prepare\n");
> +       return 1;
> +}
> +
> +int sti_layer_commit(struct sti_layer *layer)
> +{
> +       int ret;
> +
> +       if (!layer)
> +               return 1;
> +
> +       switch (layer->desc & STI_LAYER_TYPE_MASK) {
> +       case STI_GDP:
> +               if (!layer->gdp)
> +                       goto err_no_commit;
> +               ret = layer->gdp->commit(layer);
> +               break;
> +       case STI_VID:
> +               if (!layer->vid)
> +                       goto err_no_commit;
> +               ret = layer->vid->commit(layer);
> +               break;
> +       default:
> +               goto err_no_commit;
> +       }
> +
> +       if (!ret)
> +               sti_layer_update_fps(layer);
> +
> +       return ret;
> +
> +err_no_commit:
> +       DRM_ERROR("Cannot commit\n");
> +       return 1;
> +}
> +
> +int sti_layer_disable(struct sti_layer *layer)
> +{
> +       int ret;
> +
> +       DRM_DEBUG_DRIVER("%s\n", sti_layer_to_str(layer));
> +       if (!layer)
> +               return 1;
> +
> +       if (!layer->enabled)
> +               return 0;
> +
> +       switch (layer->desc & STI_LAYER_TYPE_MASK) {
> +       case STI_GDP:
> +               if (!layer->gdp)
> +                       goto err_no_disable;
> +               ret = layer->gdp->disable(layer);
> +               break;
> +       case STI_VID:
> +               if (!layer->vid)
> +                       goto err_no_disable;
> +               ret = layer->vid->disable(layer);
> +               break;
> +       default:
> +               goto err_no_disable;
> +       }
> +
> +       if (!ret)
> +               layer->enabled = false;
> +       else
> +               DRM_ERROR("Disable failed\n");
> +
> +       return ret;
> +
> +err_no_disable:
> +       DRM_ERROR("Cannot disable\n");
> +       return 1;
> +}
> +
> +const uint32_t *sti_layer_get_formats(struct sti_layer *layer)
> +{
> +       const uint32_t *(*get_formats)(void) = NULL;
> +
> +       if (!layer)
> +               return NULL;
> +
> +       switch (layer->desc & STI_LAYER_TYPE_MASK) {
> +       case STI_GDP:
> +               if (layer->gdp)
> +                       get_formats = layer->gdp->get_formats;
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       if (!get_formats) {
> +               DRM_ERROR("Cannot get formats\n");
> +               return NULL;
> +       }
> +
> +       return get_formats();
> +}
> +
> +unsigned int sti_layer_get_nb_formats(struct sti_layer *layer)
> +{
> +       unsigned int (*get_nb_formats)(void) = NULL;
> +
> +       if (!layer)
> +               return 0;
> +
> +       switch (layer->desc & STI_LAYER_TYPE_MASK) {
> +       case STI_GDP:
> +               if (layer->gdp)
> +                       get_nb_formats = layer->gdp->get_nb_formats;
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       if (!get_nb_formats) {
> +               DRM_ERROR("Cannot get nb formats\n");
> +               return 0;
> +       }
> +
> +       return get_nb_formats();
> +}
> diff --git a/drivers/gpu/drm/sti/sti_mixer.c b/drivers/gpu/drm/sti/sti_mixer.c
> index c812c68..c928d85 100644
> --- a/drivers/gpu/drm/sti/sti_mixer.c
> +++ b/drivers/gpu/drm/sti/sti_mixer.c
> @@ -6,6 +6,7 @@
>   * License terms:  GNU General Public License (GPL), version 2
>   */
>
> +#include "sti_compositor.h"
>  #include "sti_mixer.h"
>  #include "sti_vtg.h"
>
> @@ -133,6 +134,8 @@ int sti_mixer_set_layer_depth(struct sti_mixer *mixer, struct sti_layer *layer)
>         mask = GAM_DEPTH_MASK_ID << (3 * depth);
>         layer_id = layer_id << (3 * depth);
>
> +       DRM_DEBUG_DRIVER("%s %s depth=%d\n", sti_mixer_to_str(mixer),
> +                        sti_layer_to_str(layer), depth);
>         dev_dbg(mixer->dev, "GAM_MIXER_CRB val 0x%x mask 0x%x\n",
>                 layer_id, mask);
>
> @@ -195,6 +198,9 @@ int sti_mixer_set_layer_status(struct sti_mixer *mixer,
>  {
>         u32 mask, val;
>
> +       DRM_DEBUG_DRIVER("%s %s %s\n", status ? "enable" : "disable",
> +                        sti_mixer_to_str(mixer), sti_layer_to_str(layer));
> +
>         mask = sti_mixer_get_layer_mask(layer);
>         if (!mask) {
>                 DRM_ERROR("Can not find layer mask\n");
> diff --git a/drivers/gpu/drm/sti/sti_vid.c b/drivers/gpu/drm/sti/sti_vid.c
> index 0197291..f75bda2 100644
> --- a/drivers/gpu/drm/sti/sti_vid.c
> +++ b/drivers/gpu/drm/sti/sti_vid.c
> @@ -6,6 +6,7 @@
>
>  #include <drm/drmP.h>
>
> +#include "sti_compositor.h"
>  #include "sti_layer.h"
>  #include "sti_vid.h"
>  #include "sti_vtg.h"
> @@ -49,6 +50,8 @@ static int sti_vid_prepare_layer(void *lay, bool first_prepare)
>         struct sti_layer *layer = (struct sti_layer *)lay;
>         struct sti_vid *vid = layer->vid;
>
> +       dev_dbg(vid->dev, "%s %s\n", __func__, sti_layer_to_str(layer));
> +
>         /* Unmask */
>         val = readl(vid->regs + VID_CTL);
>         val &= ~VID_CTL_IGNORE;
> @@ -64,6 +67,8 @@ static int sti_vid_commit_layer(void *lay)
>         struct drm_display_mode *mode = layer->mode;
>         u32 ydo, xdo, yds, xds;
>
> +       dev_dbg(vid->dev, "%s %s\n", __func__, sti_layer_to_str(layer));
> +
>         ydo = sti_vtg_get_line_number(*mode, layer->dst_y);
>         yds = sti_vtg_get_line_number(*mode, layer->dst_y + layer->dst_h - 1);
>         xdo = sti_vtg_get_pixel_number(*mode, layer->dst_x);
> @@ -81,6 +86,8 @@ static int sti_vid_disable_layer(void *lay)
>         struct sti_layer *layer = (struct sti_layer *)lay;
>         struct sti_vid *vid = layer->vid;
>
> +       DRM_DEBUG_DRIVER("%s\n", sti_layer_to_str(layer));
> +
>         /* Mask */
>         val = readl(vid->regs + VID_CTL);
>         val |= VID_CTL_IGNORE;
> --
> 1.9.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
