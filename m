Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbaELJOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:14:50 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:57621 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaELJOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:14:46 -0400
MIME-Version: 1.0
In-Reply-To: <1399726619-30150-4-git-send-email-maxime.ripard@free-electrons.com>
References: <1399726619-30150-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399726619-30150-4-git-send-email-maxime.ripard@free-electrons.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 12 May 2014 17:14:26 +0800
X-Google-Sender-Auth: 9SJUDOcrO8nH10WgaTBNoGkj21g
Message-ID: <CAGb2v65Pstk6MqEeK838VUpNXw2cQH8K66Oo4oG3__zzWO3pig@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v2 3/7] phy: usb: sunxi: Introduce Allwinner
 A31 USB PHY support
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Hans De Goede <hdegoede@redhat.com>,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-usb <linux-usb@vger.kernel.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, Shuge <shuge@allwinnertech.com>,
        zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, May 10, 2014 at 8:56 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> The USB phy controller in the A31 differs mostly from the older controllers
> because it has a clock dedicated for each phy, while the older ones were having
> a single clock for all the phys.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/phy/phy-sun4i-usb.c | 35 ++++++++++++++++++++++++++---------
>  1 file changed, 26 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
> index e6e6c4ba7145..8bd89430d945 100644
> --- a/drivers/phy/phy-sun4i-usb.c
> +++ b/drivers/phy/phy-sun4i-usb.c
> @@ -61,7 +61,6 @@
>  #define MAX_PHYS                       3
>
>  struct sun4i_usb_phy_data {
> -       struct clk *clk;
>         void __iomem *base;
>         struct mutex mutex;
>         int num_phys;
> @@ -71,6 +70,7 @@ struct sun4i_usb_phy_data {
>                 void __iomem *pmu;
>                 struct regulator *vbus;
>                 struct reset_control *reset;
> +               struct clk *clk;
>                 int index;
>         } phys[MAX_PHYS];
>  };
> @@ -146,13 +146,13 @@ static int sun4i_usb_phy_init(struct phy *_phy)
>         struct sun4i_usb_phy_data *data = to_sun4i_usb_phy_data(phy);
>         int ret;
>
> -       ret = clk_prepare_enable(data->clk);
> +       ret = clk_prepare_enable(phy->clk);
>         if (ret)
>                 return ret;
>
>         ret = reset_control_deassert(phy->reset);
>         if (ret) {
> -               clk_disable_unprepare(data->clk);
> +               clk_disable_unprepare(phy->clk);
>                 return ret;
>         }
>
> @@ -170,11 +170,10 @@ static int sun4i_usb_phy_init(struct phy *_phy)
>  static int sun4i_usb_phy_exit(struct phy *_phy)
>  {
>         struct sun4i_usb_phy *phy = phy_get_drvdata(_phy);
> -       struct sun4i_usb_phy_data *data = to_sun4i_usb_phy_data(phy);
>
>         sun4i_usb_phy_passby(phy, 0);
>         reset_control_assert(phy->reset);
> -       clk_disable_unprepare(data->clk);
> +       clk_disable_unprepare(phy->clk);
>
>         return 0;
>  }
> @@ -228,8 +227,10 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
>         struct phy_provider *phy_provider;
>         struct reset_control *reset;
>         struct regulator *vbus;
> +       bool dedicated_clocks;

No default?

>         struct resource *res;
>         struct phy *phy;
> +       struct clk *clk;
>         char name[16];
>         int i;
>
> @@ -249,15 +250,20 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
>         else
>                 data->disc_thresh = 2;
>
> +       if (of_device_is_compatible(np, "allwinner,sun6i-a31-usb-phy"))
> +               dedicated_clocks = true;
> +

dedicated_clocks is more than likely to be true from leftover data
on the stack. This results in the usb phy driver probe failing, and
the usb host drivers left in perpetual probe deferral on my Cubietruck.

Adding an else section fixes this.

>         res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy_ctrl");
>         data->base = devm_ioremap_resource(dev, res);
>         if (IS_ERR(data->base))
>                 return PTR_ERR(data->base);
>
> -       data->clk = devm_clk_get(dev, "usb_phy");
> -       if (IS_ERR(data->clk)) {
> -               dev_err(dev, "could not get usb_phy clock\n");
> -               return PTR_ERR(data->clk);
> +       if (!dedicated_clocks) {
> +               clk = devm_clk_get(dev, "usb_phy");
> +               if (IS_ERR(clk)) {
> +                       dev_err(dev, "could not get usb_phy clock\n");
> +                       return PTR_ERR(clk);
> +               }
>         }
>
>         /* Skip 0, 0 is the phy for otg which is not yet supported. */
> @@ -270,6 +276,15 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
>                         vbus = NULL;
>                 }
>
> +               if (dedicated_clocks) {
> +                       snprintf(name, sizeof(name), "usb%d_phy", i);
> +                       clk = devm_clk_get(dev, name);
> +                       if (IS_ERR(clk)) {
> +                               dev_err(dev, "failed to get clock %s\n", name);
> +                               return PTR_ERR(clk);
> +                       }
> +               }
> +
>                 snprintf(name, sizeof(name), "usb%d_reset", i);
>                 reset = devm_reset_control_get(dev, name);
>                 if (IS_ERR(reset)) {
> @@ -296,6 +311,7 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
>                 data->phys[i].pmu = pmu;
>                 data->phys[i].vbus = vbus;
>                 data->phys[i].reset = reset;
> +               data->phys[i].clk = clk;
>                 data->phys[i].index = i;
>                 phy_set_drvdata(phy, &data->phys[i]);
>         }
> @@ -311,6 +327,7 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
>  static const struct of_device_id sun4i_usb_phy_of_match[] = {
>         { .compatible = "allwinner,sun4i-a10-usb-phy" },
>         { .compatible = "allwinner,sun5i-a13-usb-phy" },
> +       { .compatible = "allwinner,sun6i-a31-usb-phy" },
>         { .compatible = "allwinner,sun7i-a20-usb-phy" },
>         { },
>  };
> --
> 1.9.1


Cheers
ChenYu
