Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaHYHli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:41:38 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:35989 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbaHYHlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:41:36 -0400
MIME-Version: 1.0
In-Reply-To: <1408620803-10464-5-git-send-email-heikki.krogerus@linux.intel.com>
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1408620803-10464-5-git-send-email-heikki.krogerus@linux.intel.com>
Date: Mon, 25 Aug 2014 13:11:34 +0530
X-Google-Sender-Auth: TWaZ2ZEKKI7SXwcAINPEjCo-1UE
Message-ID: <CAFp+6iEihFwvJA7qkdhkGrSGkgEZz4Qtm4CAU6h0Aq3zUt1bxw@mail.gmail.com>
Subject: Re: [PATCH 4/6] phy: remove the old lookup method
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7bdc177cf9610c05016f50fc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bdc177cf9610c05016f50fc
Content-Type: text/plain; charset=UTF-8

Hi Heikki,


On Thu, Aug 21, 2014 at 5:03 PM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
> The users of the old method are now converted to the new one.
>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/phy/phy-bcm-kona-usb2.c     |  2 +-
>  drivers/phy/phy-core.c              | 45 +++----------------------------------
>  drivers/phy/phy-exynos-dp-video.c   |  2 +-
>  drivers/phy/phy-exynos-mipi-video.c |  2 +-
>  drivers/phy/phy-exynos5-usbdrd.c    |  3 +--
>  drivers/phy/phy-exynos5250-sata.c   |  2 +-
>  drivers/phy/phy-mvebu-sata.c        |  2 +-
>  drivers/phy/phy-omap-usb2.c         |  2 +-
>  drivers/phy/phy-samsung-usb2.c      |  3 +--
>  drivers/phy/phy-sun4i-usb.c         |  2 +-
>  drivers/phy/phy-ti-pipe3.c          |  2 +-
>  drivers/phy/phy-twl4030-usb.c       |  4 +---
>  drivers/phy/phy-xgene.c             |  2 +-
>  include/linux/phy/phy.h             | 38 ++++---------------------------
>  14 files changed, 19 insertions(+), 92 deletions(-)

Please squash the attached diff which removes the 'init_data' field
from some of the other instances
of devm_phy_create() in few other drivers.
This should prevent any build errors that i could see with multi_v7_defconfig.

>
> diff --git a/drivers/phy/phy-bcm-kona-usb2.c b/drivers/phy/phy-bcm-kona-usb2.c
> index 894fe74..3463983 100644
> --- a/drivers/phy/phy-bcm-kona-usb2.c
> +++ b/drivers/phy/phy-bcm-kona-usb2.c
> @@ -117,7 +117,7 @@ static int bcm_kona_usb2_probe(struct platform_device *pdev)
>
>         platform_set_drvdata(pdev, phy);
>
> -       gphy = devm_phy_create(dev, NULL, &ops, NULL);
> +       gphy = devm_phy_create(dev, NULL, &ops);
>         if (IS_ERR(gphy))
>                 return PTR_ERR(gphy);
>
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 67a8c726..834b337 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -55,36 +55,6 @@ static int devm_phy_match(struct device *dev, void *res, void *match_data)
>         return res == match_data;
>  }
>
> -static struct phy *phy_lookup(struct device *device, const char *port)
> -{
> -       unsigned int count;
> -       struct phy *phy;
> -       struct device *dev;
> -       struct phy_consumer *consumers;
> -       struct class_dev_iter iter;
> -
> -       class_dev_iter_init(&iter, phy_class, NULL, NULL);
> -       while ((dev = class_dev_iter_next(&iter))) {
> -               phy = to_phy(dev);
> -
> -               if (!phy->init_data)
> -                       continue;
> -               count = phy->init_data->num_consumers;
> -               consumers = phy->init_data->consumers;
> -               while (count--) {
> -                       if (!strcmp(consumers->dev_name, dev_name(device)) &&
> -                                       !strcmp(consumers->port, port)) {
> -                               class_dev_iter_exit(&iter);
> -                               return phy;
> -                       }
> -                       consumers++;
> -               }
> -       }
> -
> -       class_dev_iter_exit(&iter);
> -       return ERR_PTR(-ENODEV);
> -}
> -
>  /**
>   * phy_register_lookup() - register PHY/device association
>   * @pl: association to register
> @@ -210,10 +180,6 @@ static struct phy *phy_find(struct device *dev, const char *con_id)
>                 }
>                 class_dev_iter_exit(&iter);
>         }
> -
> -       /* fall-back to the old lookup method for now */
> -       if (IS_ERR(phy))
> -               phy = phy_lookup(dev, con_id);
>         return phy;
>  }
>
> @@ -721,13 +687,11 @@ EXPORT_SYMBOL_GPL(devm_of_phy_get);
>   * @dev: device that is creating the new phy
>   * @node: device node of the phy
>   * @ops: function pointers for performing phy operations
> - * @init_data: contains the list of PHY consumers or NULL
>   *
>   * Called to create a phy using phy framework.
>   */
>  struct phy *phy_create(struct device *dev, struct device_node *node,
> -                      const struct phy_ops *ops,
> -                      struct phy_init_data *init_data)
> +                      const struct phy_ops *ops)
>  {
>         int ret;
>         int id;
> @@ -765,7 +729,6 @@ struct phy *phy_create(struct device *dev, struct device_node *node,
>         phy->dev.of_node = node ?: dev->of_node;
>         phy->id = id;
>         phy->ops = ops;
> -       phy->init_data = init_data;
>
>         ret = dev_set_name(&phy->dev, "phy-%s.%d", dev_name(dev), id);
>         if (ret)
> @@ -800,7 +763,6 @@ EXPORT_SYMBOL_GPL(phy_create);
>   * @dev: device that is creating the new phy
>   * @node: device node of the phy
>   * @ops: function pointers for performing phy operations
> - * @init_data: contains the list of PHY consumers or NULL
>   *
>   * Creates a new PHY device adding it to the PHY class.
>   * While at that, it also associates the device with the phy using devres.
> @@ -808,8 +770,7 @@ EXPORT_SYMBOL_GPL(phy_create);
>   * then, devres data is freed.
>   */
>  struct phy *devm_phy_create(struct device *dev, struct device_node *node,
> -                           const struct phy_ops *ops,
> -                           struct phy_init_data *init_data)
> +                           const struct phy_ops *ops)
>  {
>         struct phy **ptr, *phy;
>
> @@ -817,7 +778,7 @@ struct phy *devm_phy_create(struct device *dev, struct device_node *node,
>         if (!ptr)
>                 return ERR_PTR(-ENOMEM);
>
> -       phy = phy_create(dev, node, ops, init_data);
> +       phy = phy_create(dev, node, ops);
>         if (!IS_ERR(phy)) {
>                 *ptr = phy;
>                 devres_add(dev, ptr);
> diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
> index 8b3026e..c667d2b 100644
> --- a/drivers/phy/phy-exynos-dp-video.c
> +++ b/drivers/phy/phy-exynos-dp-video.c
> @@ -77,7 +77,7 @@ static int exynos_dp_video_phy_probe(struct platform_device *pdev)
>         if (IS_ERR(state->regs))
>                 return PTR_ERR(state->regs);
>
> -       phy = devm_phy_create(dev, NULL, &exynos_dp_video_phy_ops, NULL);
> +       phy = devm_phy_create(dev, NULL, &exynos_dp_video_phy_ops);
>         if (IS_ERR(phy)) {
>                 dev_err(dev, "failed to create Display Port PHY\n");
>                 return PTR_ERR(phy);
> diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
> index b55a92e..2807f95 100644
> --- a/drivers/phy/phy-exynos-mipi-video.c
> +++ b/drivers/phy/phy-exynos-mipi-video.c
> @@ -137,7 +137,7 @@ static int exynos_mipi_video_phy_probe(struct platform_device *pdev)
>
>         for (i = 0; i < EXYNOS_MIPI_PHYS_NUM; i++) {
>                 struct phy *phy = devm_phy_create(dev, NULL,
> -                                       &exynos_mipi_video_phy_ops, NULL);
> +                                                 &exynos_mipi_video_phy_ops);
>                 if (IS_ERR(phy)) {
>                         dev_err(dev, "failed to create PHY %d\n", i);
>                         return PTR_ERR(phy);
> diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
> index b05302b..47f47fe 100644
> --- a/drivers/phy/phy-exynos5-usbdrd.c
> +++ b/drivers/phy/phy-exynos5-usbdrd.c
> @@ -636,8 +636,7 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
>
>         for (i = 0; i < EXYNOS5_DRDPHYS_NUM; i++) {
>                 struct phy *phy = devm_phy_create(dev, NULL,
> -                                                 &exynos5_usbdrd_phy_ops,
> -                                                 NULL);
> +                                                 &exynos5_usbdrd_phy_ops);
>                 if (IS_ERR(phy)) {
>                         dev_err(dev, "Failed to create usbdrd_phy phy\n");
>                         return PTR_ERR(phy);
> diff --git a/drivers/phy/phy-exynos5250-sata.c b/drivers/phy/phy-exynos5250-sata.c
> index 19a679a..3b0b4af7 100644
> --- a/drivers/phy/phy-exynos5250-sata.c
> +++ b/drivers/phy/phy-exynos5250-sata.c
> @@ -210,7 +210,7 @@ static int exynos_sata_phy_probe(struct platform_device *pdev)
>                 return ret;
>         }
>
> -       sata_phy->phy = devm_phy_create(dev, NULL, &exynos_sata_phy_ops, NULL);
> +       sata_phy->phy = devm_phy_create(dev, NULL, &exynos_sata_phy_ops);
>         if (IS_ERR(sata_phy->phy)) {
>                 clk_disable_unprepare(sata_phy->phyclk);
>                 dev_err(dev, "failed to create PHY\n");
> diff --git a/drivers/phy/phy-mvebu-sata.c b/drivers/phy/phy-mvebu-sata.c
> index cc3c0e1..0387e7b 100644
> --- a/drivers/phy/phy-mvebu-sata.c
> +++ b/drivers/phy/phy-mvebu-sata.c
> @@ -99,7 +99,7 @@ static int phy_mvebu_sata_probe(struct platform_device *pdev)
>         if (IS_ERR(priv->clk))
>                 return PTR_ERR(priv->clk);
>
> -       phy = devm_phy_create(&pdev->dev, NULL, &phy_mvebu_sata_ops, NULL);
> +       phy = devm_phy_create(&pdev->dev, NULL, &phy_mvebu_sata_ops);
>         if (IS_ERR(phy))
>                 return PTR_ERR(phy);
>
> diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
> index 93d7835..a4a93e3 100644
> --- a/drivers/phy/phy-omap-usb2.c
> +++ b/drivers/phy/phy-omap-usb2.c
> @@ -263,7 +263,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
>
>         platform_set_drvdata(pdev, phy);
>
> -       generic_phy = devm_phy_create(phy->dev, NULL, &ops, NULL);
> +       generic_phy = devm_phy_create(phy->dev, NULL, &ops);
>         if (IS_ERR(generic_phy))
>                 return PTR_ERR(generic_phy);
>
> diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
> index 3732ca2..e2a364d 100644
> --- a/drivers/phy/phy-samsung-usb2.c
> +++ b/drivers/phy/phy-samsung-usb2.c
> @@ -202,8 +202,7 @@ static int samsung_usb2_phy_probe(struct platform_device *pdev)
>                 struct samsung_usb2_phy_instance *p = &drv->instances[i];
>
>                 dev_dbg(dev, "Creating phy \"%s\"\n", label);
> -               p->phy = devm_phy_create(dev, NULL, &samsung_usb2_phy_ops,
> -                                        NULL);
> +               p->phy = devm_phy_create(dev, NULL, &samsung_usb2_phy_ops);
>                 if (IS_ERR(p->phy)) {
>                         dev_err(drv->dev, "Failed to create usb2_phy \"%s\"\n",
>                                 label);
> diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
> index 61ebea4..56e7f49 100644
> --- a/drivers/phy/phy-sun4i-usb.c
> +++ b/drivers/phy/phy-sun4i-usb.c
> @@ -295,7 +295,7 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
>                                 return PTR_ERR(phy->pmu);
>                 }
>
> -               phy->phy = devm_phy_create(dev, NULL, &sun4i_usb_phy_ops, NULL);
> +               phy->phy = devm_phy_create(dev, NULL, &sun4i_usb_phy_ops);
>                 if (IS_ERR(phy->phy)) {
>                         dev_err(dev, "failed to create PHY %d\n", i);
>                         return PTR_ERR(phy->phy);
> diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
> index b964aa9..9f3a1d20 100644
> --- a/drivers/phy/phy-ti-pipe3.c
> +++ b/drivers/phy/phy-ti-pipe3.c
> @@ -400,7 +400,7 @@ static int ti_pipe3_probe(struct platform_device *pdev)
>         platform_set_drvdata(pdev, phy);
>         pm_runtime_enable(phy->dev);
>
> -       generic_phy = devm_phy_create(phy->dev, NULL, &ops, NULL);
> +       generic_phy = devm_phy_create(phy->dev, NULL, &ops);
>         if (IS_ERR(generic_phy))
>                 return PTR_ERR(generic_phy);
>
> diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
> index e1a6623..851f126 100644
> --- a/drivers/phy/phy-twl4030-usb.c
> +++ b/drivers/phy/phy-twl4030-usb.c
> @@ -659,7 +659,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
>         struct usb_otg          *otg;
>         struct device_node      *np = pdev->dev.of_node;
>         struct phy_provider     *phy_provider;
> -       struct phy_init_data    *init_data = NULL;
>
>         twl = devm_kzalloc(&pdev->dev, sizeof(*twl), GFP_KERNEL);
>         if (!twl)
> @@ -670,7 +669,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
>                                 (enum twl4030_usb_mode *)&twl->usb_mode);
>         else if (pdata) {
>                 twl->usb_mode = pdata->usb_mode;
> -               init_data = pdata->init_data;
>         } else {
>                 dev_err(&pdev->dev, "twl4030 initialized without pdata\n");
>                 return -EINVAL;
> @@ -695,7 +693,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
>         otg->set_host           = twl4030_set_host;
>         otg->set_peripheral     = twl4030_set_peripheral;
>
> -       phy = devm_phy_create(twl->dev, NULL, &ops, init_data);
> +       phy = devm_phy_create(twl->dev, NULL, &ops);
>         if (IS_ERR(phy)) {
>                 dev_dbg(&pdev->dev, "Failed to create PHY\n");
>                 return PTR_ERR(phy);
> diff --git a/drivers/phy/phy-xgene.c b/drivers/phy/phy-xgene.c
> index db809b9..a239310 100644
> --- a/drivers/phy/phy-xgene.c
> +++ b/drivers/phy/phy-xgene.c
> @@ -1707,7 +1707,7 @@ static int xgene_phy_probe(struct platform_device *pdev)
>         ctx->dev = &pdev->dev;
>         platform_set_drvdata(pdev, ctx);
>
> -       ctx->phy = devm_phy_create(ctx->dev, NULL, &xgene_phy_ops, NULL);
> +       ctx->phy = devm_phy_create(ctx->dev, NULL, &xgene_phy_ops);
>         if (IS_ERR(ctx->phy)) {
>                 dev_dbg(&pdev->dev, "Failed to create PHY\n");
>                 rc = PTR_ERR(ctx->phy);
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> index 2696b95..d983051 100644
> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -61,7 +61,6 @@ struct phy {
>         struct device           dev;
>         int                     id;
>         const struct phy_ops    *ops;
> -       struct phy_init_data    *init_data;
>         struct mutex            mutex;
>         int                     init_count;
>         int                     power_count;
> @@ -84,32 +83,6 @@ struct phy_provider {
>                 struct of_phandle_args *args);
>  };
>
> -/**
> - * struct phy_consumer - represents the phy consumer
> - * @dev_name: the device name of the controller that will use this PHY device
> - * @port: name given to the consumer port
> - */
> -struct phy_consumer {
> -       const char *dev_name;
> -       const char *port;
> -};
> -
> -/**
> - * struct phy_init_data - contains the list of PHY consumers
> - * @num_consumers: number of consumers for this PHY device
> - * @consumers: list of PHY consumers
> - */
> -struct phy_init_data {
> -       unsigned int num_consumers;
> -       struct phy_consumer *consumers;
> -};
> -
> -#define PHY_CONSUMER(_dev_name, _port)                         \
> -{                                                              \
> -       .dev_name       = _dev_name,                            \
> -       .port           = _port,                                \
> -}
> -
>  struct phy_lookup {
>         struct list_head node;
>         const char *phy_name;
> @@ -173,10 +146,9 @@ struct phy *of_phy_get(struct device_node *np, const char *con_id);
>  struct phy *of_phy_simple_xlate(struct device *dev,
>         struct of_phandle_args *args);
>  struct phy *phy_create(struct device *dev, struct device_node *node,
> -                      const struct phy_ops *ops,
> -                      struct phy_init_data *init_data);
> +                      const struct phy_ops *ops);
>  struct phy *devm_phy_create(struct device *dev, struct device_node *node,
> -       const struct phy_ops *ops, struct phy_init_data *init_data);
> +                           const struct phy_ops *ops);
>  void phy_destroy(struct phy *phy);
>  void devm_phy_destroy(struct device *dev, struct phy *phy);
>  struct phy_provider *__of_phy_provider_register(struct device *dev,
> @@ -319,16 +291,14 @@ static inline struct phy *of_phy_simple_xlate(struct device *dev,
>
>  static inline struct phy *phy_create(struct device *dev,
>                                      struct device_node *node,
> -                                    const struct phy_ops *ops,
> -                                    struct phy_init_data *init_data)
> +                                    const struct phy_ops *ops)
>  {
>         return ERR_PTR(-ENOSYS);
>  }
>
>  static inline struct phy *devm_phy_create(struct device *dev,
>                                           struct device_node *node,
> -                                         const struct phy_ops *ops,
> -                                         struct phy_init_data *init_data)
> +                                         const struct phy_ops *ops)
>  {
>         return ERR_PTR(-ENOSYS);
>  }
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India

--047d7bdc177cf9610c05016f50fc
Content-Type: application/octet-stream; name=phy-fix
Content-Disposition: attachment; filename=phy-fix
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hz9hwt0x0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGh5L3BoeS1iZXJsaW4tc2F0YS5jIGIvZHJpdmVycy9waHkv
cGh5LWJlcmxpbi1zYXRhLmMKaW5kZXggNWMzYTA0Mi4uMDEwYzQ2MyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9waHkvcGh5LWJlcmxpbi1zYXRhLmMKKysrIGIvZHJpdmVycy9waHkvcGh5LWJlcmxpbi1z
YXRhLmMKQEAgLTIzOSw3ICsyMzksNyBAQCBzdGF0aWMgaW50IHBoeV9iZXJsaW5fc2F0YV9wcm9i
ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCQlpZiAoIXBoeV9kZXNjKQogCQkJcmV0
dXJuIC1FTk9NRU07CiAKLQkJcGh5ID0gZGV2bV9waHlfY3JlYXRlKGRldiwgTlVMTCwgJnBoeV9i
ZXJsaW5fc2F0YV9vcHMsIE5VTEwpOworCQlwaHkgPSBkZXZtX3BoeV9jcmVhdGUoZGV2LCBOVUxM
LCAmcGh5X2Jlcmxpbl9zYXRhX29wcyk7CiAJCWlmIChJU19FUlIocGh5KSkgewogCQkJZGV2X2Vy
cihkZXYsICJmYWlsZWQgdG8gY3JlYXRlIFBIWSAlZFxuIiwgcGh5X2lkKTsKIAkJCXJldHVybiBQ
VFJfRVJSKHBoeSk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3BoeS9waHktaGl4NWhkMi1zYXRhLmMg
Yi9kcml2ZXJzL3BoeS9waHktaGl4NWhkMi1zYXRhLmMKaW5kZXggNmEwOGZhNS4uMTUyZWFhNyAx
MDA2NDQKLS0tIGEvZHJpdmVycy9waHkvcGh5LWhpeDVoZDItc2F0YS5jCisrKyBiL2RyaXZlcnMv
cGh5L3BoeS1oaXg1aGQyLXNhdGEuYwpAQCAtMTU2LDcgKzE1Niw3IEBAIHN0YXRpYyBpbnQgaGl4
NWhkMl9zYXRhX3BoeV9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCWlmIChJ
U19FUlIocHJpdi0+cGVyaV9jdHJsKSkKIAkJcHJpdi0+cGVyaV9jdHJsID0gTlVMTDsKIAotCXBo
eSA9IGRldm1fcGh5X2NyZWF0ZShkZXYsIE5VTEwsICZoaXg1aGQyX3NhdGFfcGh5X29wcywgTlVM
TCk7CisJcGh5ID0gZGV2bV9waHlfY3JlYXRlKGRldiwgTlVMTCwgJmhpeDVoZDJfc2F0YV9waHlf
b3BzKTsKIAlpZiAoSVNfRVJSKHBoeSkpIHsKIAkJZGV2X2VycihkZXYsICJmYWlsZWQgdG8gY3Jl
YXRlIFBIWVxuIik7CiAJCXJldHVybiBQVFJfRVJSKHBoeSk7CmRpZmYgLS1naXQgYS9kcml2ZXJz
L3BoeS9waHktbWlwaHkzNjV4LmMgYi9kcml2ZXJzL3BoeS9waHktbWlwaHkzNjV4LmMKaW5kZXgg
ZTExMWJhZi4uMDg0OTg0NCAxMDA2NDQKLS0tIGEvZHJpdmVycy9waHkvcGh5LW1pcGh5MzY1eC5j
CisrKyBiL2RyaXZlcnMvcGh5L3BoeS1taXBoeTM2NXguYwpAQCAtNTkyLDcgKzU5Miw3IEBAIHN0
YXRpYyBpbnQgbWlwaHkzNjV4X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpCiAK
IAkJbWlwaHlfZGV2LT5waHlzW3BvcnRdID0gbWlwaHlfcGh5OwogCi0JCXBoeSA9IGRldm1fcGh5
X2NyZWF0ZSgmcGRldi0+ZGV2LCBjaGlsZCwgJm1pcGh5MzY1eF9vcHMsIE5VTEwpOworCQlwaHkg
PSBkZXZtX3BoeV9jcmVhdGUoJnBkZXYtPmRldiwgY2hpbGQsICZtaXBoeTM2NXhfb3BzKTsKIAkJ
aWYgKElTX0VSUihwaHkpKSB7CiAJCQlkZXZfZXJyKCZwZGV2LT5kZXYsICJmYWlsZWQgdG8gY3Jl
YXRlIFBIWVxuIik7CiAJCQlyZXR1cm4gUFRSX0VSUihwaHkpOwpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9waHkvcGh5LXFjb20tYXBxODA2NC1zYXRhLmMgYi9kcml2ZXJzL3BoeS9waHktcWNvbS1hcHE4
MDY0LXNhdGEuYwppbmRleCBiM2VmN2Q4Li4yMWZiMzkyIDEwMDY0NAotLS0gYS9kcml2ZXJzL3Bo
eS9waHktcWNvbS1hcHE4MDY0LXNhdGEuYworKysgYi9kcml2ZXJzL3BoeS9waHktcWNvbS1hcHE4
MDY0LXNhdGEuYwpAQCAtMjI4LDggKzIyOCw3IEBAIHN0YXRpYyBpbnQgcWNvbV9hcHE4MDY0X3Nh
dGFfcGh5X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpCiAJaWYgKElTX0VSUihw
aHktPm1taW8pKQogCQlyZXR1cm4gUFRSX0VSUihwaHktPm1taW8pOwogCi0JZ2VuZXJpY19waHkg
PSBkZXZtX3BoeV9jcmVhdGUoZGV2LCBOVUxMLCAmcWNvbV9hcHE4MDY0X3NhdGFfcGh5X29wcywK
LQkJCQkgICAgICBOVUxMKTsKKwlnZW5lcmljX3BoeSA9IGRldm1fcGh5X2NyZWF0ZShkZXYsIE5V
TEwsICZxY29tX2FwcTgwNjRfc2F0YV9waHlfb3BzKTsKIAlpZiAoSVNfRVJSKGdlbmVyaWNfcGh5
KSkgewogCQlkZXZfZXJyKGRldiwgIiVzOiBmYWlsZWQgdG8gY3JlYXRlIHBoeVxuIiwgX19mdW5j
X18pOwogCQlyZXR1cm4gUFRSX0VSUihnZW5lcmljX3BoeSk7CmRpZmYgLS1naXQgYS9kcml2ZXJz
L3BoeS9waHktcWNvbS1pcHE4MDZ4LXNhdGEuYyBiL2RyaXZlcnMvcGh5L3BoeS1xY29tLWlwcTgw
Nngtc2F0YS5jCmluZGV4IDkwOWI1YTguLmIzYmU5OTkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGh5
L3BoeS1xY29tLWlwcTgwNngtc2F0YS5jCisrKyBiL2RyaXZlcnMvcGh5L3BoeS1xY29tLWlwcTgw
Nngtc2F0YS5jCkBAIC0xNTAsOCArMTUwLDcgQEAgc3RhdGljIGludCBxY29tX2lwcTgwNnhfc2F0
YV9waHlfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKIAlpZiAoSVNfRVJSKHBo
eS0+bW1pbykpCiAJCXJldHVybiBQVFJfRVJSKHBoeS0+bW1pbyk7CiAKLQlnZW5lcmljX3BoeSA9
IGRldm1fcGh5X2NyZWF0ZShkZXYsIE5VTEwsICZxY29tX2lwcTgwNnhfc2F0YV9waHlfb3BzLAot
CQkJCSAgICAgIE5VTEwpOworCWdlbmVyaWNfcGh5ID0gZGV2bV9waHlfY3JlYXRlKGRldiwgTlVM
TCwgJnFjb21faXBxODA2eF9zYXRhX3BoeV9vcHMpOwogCWlmIChJU19FUlIoZ2VuZXJpY19waHkp
KSB7CiAJCWRldl9lcnIoZGV2LCAiJXM6IGZhaWxlZCB0byBjcmVhdGUgcGh5XG4iLCBfX2Z1bmNf
Xyk7CiAJCXJldHVybiBQVFJfRVJSKGdlbmVyaWNfcGh5KTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
cGh5L3BoeS1zcGVhcjEzMTAtbWlwaHkuYyBiL2RyaXZlcnMvcGh5L3BoeS1zcGVhcjEzMTAtbWlw
aHkuYwppbmRleCA2ZGNiZmNkLi41MWYzNzJiIDEwMDY0NAotLS0gYS9kcml2ZXJzL3BoeS9waHkt
c3BlYXIxMzEwLW1pcGh5LmMKKysrIGIvZHJpdmVycy9waHkvcGh5LXNwZWFyMTMxMC1taXBoeS5j
CkBAIC0yMjksNyArMjI5LDcgQEAgc3RhdGljIGludCBzcGVhcjEzMTBfbWlwaHlfcHJvYmUoc3Ry
dWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKIAkJcmV0dXJuIC1FSU5WQUw7CiAJfQogCi0JcHJp
di0+cGh5ID0gZGV2bV9waHlfY3JlYXRlKGRldiwgTlVMTCwgJnNwZWFyMTMxMF9taXBoeV9vcHMs
IE5VTEwpOworCXByaXYtPnBoeSA9IGRldm1fcGh5X2NyZWF0ZShkZXYsIE5VTEwsICZzcGVhcjEz
MTBfbWlwaHlfb3BzKTsKIAlpZiAoSVNfRVJSKHByaXYtPnBoeSkpIHsKIAkJZGV2X2VycihkZXYs
ICJmYWlsZWQgdG8gY3JlYXRlIFNBVEEgUENJZSBQSFlcbiIpOwogCQlyZXR1cm4gUFRSX0VSUihw
cml2LT5waHkpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9waHkvcGh5LXNwZWFyMTM0MC1taXBoeS5j
IGIvZHJpdmVycy9waHkvcGh5LXNwZWFyMTM0MC1taXBoeS5jCmluZGV4IDcxMzViYTIuLmM2MTgx
NTAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGh5L3BoeS1zcGVhcjEzNDAtbWlwaHkuYworKysgYi9k
cml2ZXJzL3BoeS9waHktc3BlYXIxMzQwLW1pcGh5LmMKQEAgLTI2MSw3ICsyNjEsNyBAQCBzdGF0
aWMgaW50IHNwZWFyMTM0MF9taXBoeV9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2
KQogCQlyZXR1cm4gUFRSX0VSUihwcml2LT5taXNjKTsKIAl9CiAKLQlwcml2LT5waHkgPSBkZXZt
X3BoeV9jcmVhdGUoZGV2LCBOVUxMLCAmc3BlYXIxMzQwX21pcGh5X29wcywgTlVMTCk7CisJcHJp
di0+cGh5ID0gZGV2bV9waHlfY3JlYXRlKGRldiwgTlVMTCwgJnNwZWFyMTM0MF9taXBoeV9vcHMp
OwogCWlmIChJU19FUlIocHJpdi0+cGh5KSkgewogCQlkZXZfZXJyKGRldiwgImZhaWxlZCB0byBj
cmVhdGUgU0FUQSBQQ0llIFBIWVxuIik7CiAJCXJldHVybiBQVFJfRVJSKHByaXYtPnBoeSk7Cg==
--047d7bdc177cf9610c05016f50fc--
