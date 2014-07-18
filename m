Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400AbaGRKbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:31:45 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:36082 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760968AbaGRKbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <1405628200-21776-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1405628200-21776-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Fri, 18 Jul 2014 16:01:41 +0530
Message-ID: <CABu_nUQe3sMQDdU1NtEAiS6q_E2pqzE5U1ocLBVfwuUgfUY=UA@mail.gmail.com>
Subject: Re: [PATCH v2] usb: phy: msm: Make phy_reset clk and reset line optional.
From: Prakash Burla <burlaprakash.linuxkernel@gmail.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tested-by: Prakash Burla <prakash.burla@smartplayin.com>
This driver tested on IFC6410 with USB Driver.

On Fri, Jul 18, 2014 at 1:46 AM, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
> This patch makes the phy reset clk and reset line optional as this clk
> is not available on boards like IFC6410 with APQ8064.
>
> phy-reset clk is only used as argument to the mach level callbacks, so
> this patch adds condition before clk_get calls so that the driver
> wouldn't fail on SOCs which do not have this support.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> Hi Felipe,
>
> With this new patch now the error message is only printed if the SOC actually supports
> the phy reset clk, for SOCs like APQ8064 where there is no phy reset clock or
> the callback which takes it there is no point in doing a clk_get call in the first place.
>
>
> Thanks,
> srini
>
>
>
>
>  drivers/usb/phy/phy-msm-usb.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> index c929370..aa8e2b9 100644
> --- a/drivers/usb/phy/phy-msm-usb.c
> +++ b/drivers/usb/phy/phy-msm-usb.c
> @@ -279,11 +279,11 @@ static int msm_otg_link_clk_reset(struct msm_otg *motg, bool assert)
>
>  static int msm_otg_phy_clk_reset(struct msm_otg *motg)
>  {
> -       int ret;
> +       int ret = 0;
>
>         if (motg->pdata->phy_clk_reset)
>                 ret = motg->pdata->phy_clk_reset(motg->phy_reset_clk);
> -       else
> +       else if (motg->phy_rst)
>                 ret = reset_control_reset(motg->phy_rst);
>
>         if (ret)
> @@ -1466,7 +1466,7 @@ static int msm_otg_read_dt(struct platform_device *pdev, struct msm_otg *motg)
>
>         motg->phy_rst = devm_reset_control_get(&pdev->dev, "phy");
>         if (IS_ERR(motg->phy_rst))
> -               return PTR_ERR(motg->phy_rst);
> +               motg->phy_rst = NULL;
>
>         pdata->mode = of_usb_get_dr_mode(node);
>         if (pdata->mode == USB_DR_MODE_UNKNOWN)
> @@ -1554,11 +1554,14 @@ static int msm_otg_probe(struct platform_device *pdev)
>         phy = &motg->phy;
>         phy->dev = &pdev->dev;
>
> -       motg->phy_reset_clk = devm_clk_get(&pdev->dev,
> +       if (motg->pdata->phy_clk_reset) {
> +               motg->phy_reset_clk = devm_clk_get(&pdev->dev,
>                                            np ? "phy" : "usb_phy_clk");
> -       if (IS_ERR(motg->phy_reset_clk)) {
> -               dev_err(&pdev->dev, "failed to get usb_phy_clk\n");
> -               return PTR_ERR(motg->phy_reset_clk);
> +
> +               if (IS_ERR(motg->phy_reset_clk)) {
> +                       dev_err(&pdev->dev, "failed to get usb_phy_clk\n");
> +                       return PTR_ERR(motg->phy_reset_clk);
> +               }
>         }
>
>         motg->clk = devm_clk_get(&pdev->dev, np ? "core" : "usb_hs_clk");
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
