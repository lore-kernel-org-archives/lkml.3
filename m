Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaKPOfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 09:35:46 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:38426 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaKPOfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 09:35:44 -0500
MIME-Version: 1.0
In-Reply-To: <1416004955-28749-2-git-send-email-hali@codeaurora.org>
References: <1416004955-28749-1-git-send-email-hali@codeaurora.org>
	<1416004955-28749-2-git-send-email-hali@codeaurora.org>
Date: Sun, 16 Nov 2014 09:35:43 -0500
Message-ID: <CAF6AEGtQcDhcNhgRXnTQ1miRJB6KahuXcWPj4yPhLRKVAx2=Bw@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/msm: Decouple hdmi driver from mdp driver
From: Rob Clark <robdclark@gmail.com>
To: Hai Li <hali@codeaurora.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 5:42 PM, Hai Li <hali@codeaurora.org> wrote:
> This change is to remove the hdmi structure from mdp kms data structure.
>
> To do this, the initialization flow is re-arranged.
>  - hdmi_init is moved from modeset_init to hdmi_bind.
>  - hdmi_destroy is called by hdmi_unbind and the use of kref is abandoned.
>  - A new interface hdmi_set_encoder is introduced to establish the links
>    between hdmi connector, encoder and bridge.
>

this looks like it is going to conflict somewhat with:

http://cgit.freedesktop.org/~robclark/linux/commit/?h=msm-next&id=3b3a2964a37887ced36261b4b5622ab6137a860c

I had already refactored the hdmi init to better handle probe-defer
(and move all the devm_get's into hdmi_bind()).  It is somewhat
similar to what you are doing here.. hdmi_init() is called at
hdmi_bind() time, and then hdmi_modeset_init() is called at toplevel
drm device modeset_init() time to construct the kms modeset object
(connector/bridge) and connect up with encoder.

I didn't remove the kref yet, although it probably could/should be
removed.  It doesn't really protect us if the hdmi device is removed
before the toplevel drm device (since all the devm resources would be
dropped).  But AFAIU the component framework stuff should protect us
from that.  The kref is just left over from before component framework
because I forgot to remove it ;-)

BR,
-R


> Signed-off-by: Hai Li <hali@codeaurora.org>
> ---
>  drivers/gpu/drm/msm/hdmi/hdmi.c           | 61 +++++++++++++++++++++++--------
>  drivers/gpu/drm/msm/hdmi/hdmi.h           | 14 -------
>  drivers/gpu/drm/msm/hdmi/hdmi_bridge.c    |  3 +-
>  drivers/gpu/drm/msm/hdmi/hdmi_connector.c |  6 +--
>  drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c   | 14 ++++---
>  drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c   | 38 ++++++++++---------
>  drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h   |  2 -
>  drivers/gpu/drm/msm/msm_drv.c             |  9 ++++-
>  drivers/gpu/drm/msm/msm_drv.h             |  6 ++-
>  9 files changed, 88 insertions(+), 65 deletions(-)
>
> diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
> index aaf5e2b..2d2551f 100644
> --- a/drivers/gpu/drm/msm/hdmi/hdmi.c
> +++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
> @@ -1,4 +1,5 @@
>  /*
> + * Copyright (c) 2014, The Linux Foundation. All rights reserved.
>   * Copyright (C) 2013 Red Hat
>   * Author: Rob Clark <robdclark@gmail.com>
>   *
> @@ -17,6 +18,29 @@
>
>  #include "hdmi.h"
>
> +int hdmi_set_encoder(struct platform_device *pdev,
> +                               struct drm_encoder *encoder)
> +{
> +       struct hdmi *hdmi = platform_get_drvdata(pdev);
> +
> +       if (!encoder && !hdmi->encoder) {
> +               pr_err("%s:wrong encoder status,encoder=%p,hdmi->encoder=%p\n",
> +                       __func__, encoder, hdmi->encoder);
> +               return -EINVAL;
> +       }
> +
> +       /* Each connector has only one available encoder for now. */
> +       hdmi->connector->encoder_ids[0] = 0;
> +       hdmi->connector->encoder = NULL;
> +       if (encoder) {
> +               drm_mode_connector_attach_encoder(hdmi->connector, encoder);
> +               encoder->bridge = hdmi->bridge;
> +       }
> +       hdmi->encoder = encoder;
> +
> +       return 0;
> +}
> +
>  void hdmi_set_mode(struct hdmi *hdmi, bool power_on)
>  {
>         uint32_t ctrl = 0;
> @@ -54,10 +78,15 @@ static irqreturn_t hdmi_irq(int irq, void *dev_id)
>         return IRQ_HANDLED;
>  }
>
> -void hdmi_destroy(struct kref *kref)
> +static void hdmi_destroy(struct platform_device *pdev)
>  {
> -       struct hdmi *hdmi = container_of(kref, struct hdmi, refcount);
> -       struct hdmi_phy *phy = hdmi->phy;
> +       struct hdmi *hdmi = platform_get_drvdata(pdev);
> +       struct hdmi_phy *phy;
> +
> +       if (!hdmi)
> +               return;
> +
> +       phy = hdmi->phy;
>
>         if (hdmi->config->shared_irq)
>                 msm_shared_irq_unregister(MSM_SUBSYS_HDMI);
> @@ -68,15 +97,14 @@ void hdmi_destroy(struct kref *kref)
>         if (hdmi->i2c)
>                 hdmi_i2c_destroy(hdmi->i2c);
>
> -       platform_set_drvdata(hdmi->pdev, NULL);
> +       platform_set_drvdata(pdev, NULL);
>  }
>
>  /* initialize connector */
> -struct hdmi *hdmi_init(struct drm_device *dev, struct drm_encoder *encoder)
> +static int hdmi_init(struct platform_device *pdev, struct drm_device *dev)
>  {
>         struct hdmi *hdmi = NULL;
>         struct msm_drm_private *priv = dev->dev_private;
> -       struct platform_device *pdev = priv->hdmi_pdev;
>         struct hdmi_platform_config *config;
>         int i, ret;
>
> @@ -94,12 +122,11 @@ struct hdmi *hdmi_init(struct drm_device *dev, struct drm_encoder *encoder)
>                 goto fail;
>         }
>
> -       kref_init(&hdmi->refcount);
> +       platform_set_drvdata(pdev, hdmi);
>
>         hdmi->dev = dev;
>         hdmi->pdev = pdev;
>         hdmi->config = config;
> -       hdmi->encoder = encoder;
>
>         hdmi_audio_infoframe_init(&hdmi->audio.infoframe);
>
> @@ -233,14 +260,10 @@ struct hdmi *hdmi_init(struct drm_device *dev, struct drm_encoder *encoder)
>                 }
>         }
>
> -       encoder->bridge = hdmi->bridge;
> -
>         priv->bridges[priv->num_bridges++]       = hdmi->bridge;
>         priv->connectors[priv->num_connectors++] = hdmi->connector;
>
> -       platform_set_drvdata(pdev, hdmi);
> -
> -       return hdmi;
> +       return 0;
>
>  fail:
>         if (hdmi) {
> @@ -249,10 +272,10 @@ fail:
>                         hdmi->bridge->funcs->destroy(hdmi->bridge);
>                 if (hdmi->connector)
>                         hdmi->connector->funcs->destroy(hdmi->connector);
> -               hdmi_destroy(&hdmi->refcount);
> +               hdmi_destroy(pdev);
>         }
>
> -       return ERR_PTR(ret);
> +       return ret;
>  }
>
>  /*
> @@ -289,6 +312,7 @@ static int get_gpio(struct device *dev, struct device_node *of_node, const char
>  static int hdmi_bind(struct device *dev, struct device *master, void *data)
>  {
>         static struct hdmi_platform_config config = {};
> +       int ret;
>  #ifdef CONFIG_OF
>         struct device_node *of_node = dev->of_node;
>
> @@ -379,6 +403,12 @@ static int hdmi_bind(struct device *dev, struct device *master, void *data)
>         }
>  #endif
>         dev->platform_data = &config;
> +
> +       ret = hdmi_init(to_platform_device(dev), dev_get_drvdata(master));
> +       if (ret) {
> +               dev_err(dev, "%s: hdmi_init fail, %d\n", __func__, ret);
> +               return ret;
> +       }
>         set_hdmi_pdev(dev_get_drvdata(master), to_platform_device(dev));
>         return 0;
>  }
> @@ -387,6 +417,7 @@ static void hdmi_unbind(struct device *dev, struct device *master,
>                 void *data)
>  {
>         set_hdmi_pdev(dev_get_drvdata(master), NULL);
> +       hdmi_destroy(to_platform_device(dev));
>  }
>
>  static const struct component_ops hdmi_ops = {
> diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.h b/drivers/gpu/drm/msm/hdmi/hdmi.h
> index b981995..a78dd8d 100644
> --- a/drivers/gpu/drm/msm/hdmi/hdmi.h
> +++ b/drivers/gpu/drm/msm/hdmi/hdmi.h
> @@ -38,8 +38,6 @@ struct hdmi_audio {
>  };
>
>  struct hdmi {
> -       struct kref refcount;
> -
>         struct drm_device *dev;
>         struct platform_device *pdev;
>
> @@ -103,7 +101,6 @@ struct hdmi_platform_config {
>  };
>
>  void hdmi_set_mode(struct hdmi *hdmi, bool power_on);
> -void hdmi_destroy(struct kref *kref);
>
>  static inline void hdmi_write(struct hdmi *hdmi, u32 reg, u32 data)
>  {
> @@ -115,17 +112,6 @@ static inline u32 hdmi_read(struct hdmi *hdmi, u32 reg)
>         return msm_readl(hdmi->mmio + reg);
>  }
>
> -static inline struct hdmi * hdmi_reference(struct hdmi *hdmi)
> -{
> -       kref_get(&hdmi->refcount);
> -       return hdmi;
> -}
> -
> -static inline void hdmi_unreference(struct hdmi *hdmi)
> -{
> -       kref_put(&hdmi->refcount, hdmi_destroy);
> -}
> -
>  /*
>   * The phy appears to be different, for example between 8960 and 8x60,
>   * so split the phy related functions out and load the correct one at
> diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
> index f6cf745..6902ad6 100644
> --- a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
> +++ b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
> @@ -26,7 +26,6 @@ struct hdmi_bridge {
>  static void hdmi_bridge_destroy(struct drm_bridge *bridge)
>  {
>         struct hdmi_bridge *hdmi_bridge = to_hdmi_bridge(bridge);
> -       hdmi_unreference(hdmi_bridge->hdmi);
>         drm_bridge_cleanup(bridge);
>         kfree(hdmi_bridge);
>  }
> @@ -218,7 +217,7 @@ struct drm_bridge *hdmi_bridge_init(struct hdmi *hdmi)
>                 goto fail;
>         }
>
> -       hdmi_bridge->hdmi = hdmi_reference(hdmi);
> +       hdmi_bridge->hdmi = hdmi;
>
>         bridge = &hdmi_bridge->base;
>
> diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_connector.c b/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
> index 4aca2a3..f5da877 100644
> --- a/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
> +++ b/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
> @@ -330,8 +330,6 @@ static void hdmi_connector_destroy(struct drm_connector *connector)
>         drm_connector_unregister(connector);
>         drm_connector_cleanup(connector);
>
> -       hdmi_unreference(hdmi_connector->hdmi);
> -
>         kfree(hdmi_connector);
>  }
>
> @@ -422,7 +420,7 @@ struct drm_connector *hdmi_connector_init(struct hdmi *hdmi)
>                 goto fail;
>         }
>
> -       hdmi_connector->hdmi = hdmi_reference(hdmi);
> +       hdmi_connector->hdmi = hdmi;
>         INIT_WORK(&hdmi_connector->hpd_work, hotplug_work);
>
>         connector = &hdmi_connector->base;
> @@ -445,8 +443,6 @@ struct drm_connector *hdmi_connector_init(struct hdmi *hdmi)
>                 goto fail;
>         }
>
> -       drm_mode_connector_attach_encoder(connector, hdmi->encoder);
> -
>         return connector;
>
>  fail:
> diff --git a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c
> index 79d804e..b0b6dee 100644
> --- a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c
> +++ b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c
> @@ -228,7 +228,6 @@ static int modeset_init(struct mdp4_kms *mdp4_kms)
>         struct drm_encoder *encoder;
>         struct drm_connector *connector;
>         struct drm_panel *panel;
> -       struct hdmi *hdmi;
>         int ret;
>
>         /* construct non-private planes: */
> @@ -326,15 +325,18 @@ static int modeset_init(struct mdp4_kms *mdp4_kms)
>         priv->crtcs[priv->num_crtcs++] = crtc;
>         priv->encoders[priv->num_encoders++] = encoder;
>
> -       hdmi = hdmi_init(dev, encoder);
> -       if (IS_ERR(hdmi)) {
> -               ret = PTR_ERR(hdmi);
> -               dev_err(dev->dev, "failed to initialize HDMI: %d\n", ret);
> -               goto fail;
> +       ret = hdmi_set_encoder(priv->hdmi_pdev, encoder);
> +       if (ret) {
> +               dev_err(dev->dev, "failed to set encoder\n");
> +               goto fail1;
>         }
>
>         return 0;
>
> +fail1:
> +       priv->encoders[--priv->num_encoders] = NULL;
> +       if (encoder)
> +               encoder->funcs->destroy(encoder);
>  fail:
>         return ret;
>  }
> diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
> index 31a2c63..1bb3a28 100644
> --- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
> +++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
> @@ -302,14 +302,6 @@ static int modeset_init(struct mdp5_kms *mdp5_kms)
>                 priv->crtcs[priv->num_crtcs++] = crtc;
>         }
>
> -       /* Construct encoder for HDMI: */
> -       encoder = mdp5_encoder_init(dev, 3, INTF_HDMI);
> -       if (IS_ERR(encoder)) {
> -               dev_err(dev->dev, "failed to construct encoder\n");
> -               ret = PTR_ERR(encoder);
> -               goto fail;
> -       }
> -
>         /* NOTE: the vsync and error irq's are actually associated with
>          * the INTF/encoder.. the easiest way to deal with this (ie. what
>          * we do now) is assume a fixed relationship between crtc's and
> @@ -318,21 +310,33 @@ static int modeset_init(struct mdp5_kms *mdp5_kms)
>          * care of error and vblank irq's that the crtc has registered,
>          * and also update user-requested vblank_mask.
>          */
> -       encoder->possible_crtcs = BIT(0);
> -       mdp5_crtc_set_intf(priv->crtcs[0], 3, INTF_HDMI);
> +       if (priv->hdmi_pdev) {
> +               /* Construct encoder for HDMI: */
> +               encoder = mdp5_encoder_init(dev, 3, INTF_HDMI);
> +               if (IS_ERR(encoder)) {
> +                       dev_err(dev->dev, "failed to construct encoder\n");
> +                       ret = PTR_ERR(encoder);
> +                       goto fail;
> +               }
>
> -       priv->encoders[priv->num_encoders++] = encoder;
> +               encoder->possible_crtcs = BIT(0);
> +               mdp5_crtc_set_intf(priv->crtcs[0], 3, INTF_HDMI);
>
> -       /* Construct bridge/connector for HDMI: */
> -       mdp5_kms->hdmi = hdmi_init(dev, encoder);
> -       if (IS_ERR(mdp5_kms->hdmi)) {
> -               ret = PTR_ERR(mdp5_kms->hdmi);
> -               dev_err(dev->dev, "failed to initialize HDMI: %d\n", ret);
> -               goto fail;
> +               priv->encoders[priv->num_encoders++] = encoder;
> +
> +               ret = hdmi_set_encoder(priv->hdmi_pdev, encoder);
> +               if (ret)
> +                       goto fail1;
>         }
>
>         return 0;
>
> +fail1:
> +       if (priv->hdmi_pdev) {
> +               priv->encoders[--priv->num_encoders] = NULL;
> +               if (encoder)
> +                       encoder->funcs->destroy(encoder);
> +       }
>  fail:
>         return ret;
>  }
> diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
> index 5bf340d..c91101d 100644
> --- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
> +++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
> @@ -71,8 +71,6 @@ struct mdp5_kms {
>         struct clk *lut_clk;
>         struct clk *vsync_clk;
>
> -       struct hdmi *hdmi;
> -
>         struct mdp_irq error_handler;
>  };
>  #define to_mdp5_kms(x) container_of(x, struct mdp5_kms, base)
> diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
> index b67ef59..c27cb9a 100644
> --- a/drivers/gpu/drm/msm/msm_drv.c
> +++ b/drivers/gpu/drm/msm/msm_drv.c
> @@ -147,7 +147,10 @@ static int msm_unload(struct drm_device *dev)
>                                 priv->vram.paddr, &attrs);
>         }
>
> -       component_unbind_all(dev->dev, dev);
> +       if (priv->component_bound) {
> +               component_unbind_all(dev->dev, dev);
> +               priv->component_bound = false;
> +       }
>
>         dev->dev_private = NULL;
>
> @@ -237,7 +240,9 @@ static int msm_load(struct drm_device *dev, unsigned long flags)
>         /* Bind all our sub-components: */
>         ret = component_bind_all(dev->dev, dev);
>         if (ret)
> -               return ret;
> +               goto fail;
> +
> +       priv->component_bound = true;
>
>         switch (get_mdp_ver(pdev)) {
>         case 4:
> diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
> index 718ac55..76cac63 100644
> --- a/drivers/gpu/drm/msm/msm_drv.h
> +++ b/drivers/gpu/drm/msm/msm_drv.h
> @@ -125,6 +125,8 @@ struct msm_drm_private {
>                  */
>                 struct drm_mm mm;
>         } vram;
> +
> +       bool component_bound;
>  };
>
>  /* For mdp5 only */
> @@ -219,10 +221,10 @@ struct drm_framebuffer *msm_framebuffer_create(struct drm_device *dev,
>
>  struct drm_fb_helper *msm_fbdev_init(struct drm_device *dev);
>
> -struct hdmi;
> -struct hdmi *hdmi_init(struct drm_device *dev, struct drm_encoder *encoder);
>  void __init hdmi_register(void);
>  void __exit hdmi_unregister(void);
> +int hdmi_set_encoder(struct platform_device *pdev,
> +                               struct drm_encoder *encoder);
>
>  #ifdef CONFIG_DEBUG_FS
>  void msm_gem_describe(struct drm_gem_object *obj, struct seq_file *m);
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
