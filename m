Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaLITaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:30:10 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:38843 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaLITaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:30:08 -0500
MIME-Version: 1.0
In-Reply-To: <1418020850-7664-1-git-send-email-markz@nvidia.com>
References: <1418020850-7664-1-git-send-email-markz@nvidia.com>
From: Sean Paul <seanpaul@chromium.org>
Date: Tue, 9 Dec 2014 14:29:44 -0500
Message-ID: <CAOw6vbKegB8cgmqgRit+XdvYNtdEXy3Pcv5=1bYSCJv4v1F2AQ@mail.gmail.com>
Subject: Re: [PATCH] drm/tegra: dsi: Add suspend/resume support
To: Mark Zhang <markz@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, tbergstrom@nvidia.com,
        Dave Airlie <airlied@linux.ie>, Stephen Warren <swarren@wwwdotorg.org>,
        gnurou@gmail.com, dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 7, 2014 at 10:40 PM, Mark Zhang <markz@nvidia.com> wrote:
> This patch adds the suspend/resume support for Tegra drm
> driver by calling the corresponding DPMS functions.
>
> Signed-off-by: Mark Zhang <markz@nvidia.com>
> ---
> Hi,
>
> This patch hooks DSI driver's suspend/resume to implement the whole
> display system's suspend/resume. I know this is a super ugly way,
> but as we all know, Tegra DRM driver doesn't have a dedicate drm device
> so honestly I didn't find a better way to do that.
>
> Thanks,
> Mark
>

Hi Mark,
Thanks for posting this. I've reproduced my Gerrit comments from the
CrOS tree below for the benefit of others.

>  drivers/gpu/drm/tegra/dsi.c | 96 ++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 90 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
> index 33f67fd601c6..25cd0d93f392 100644
> --- a/drivers/gpu/drm/tegra/dsi.c
> +++ b/drivers/gpu/drm/tegra/dsi.c
> @@ -61,6 +61,9 @@ struct tegra_dsi {
>         struct tegra_dsi *slave;
>  };
>
> +static int tegra_dsi_pad_calibrate(struct tegra_dsi *);
> +static int tegra_dsi_ganged_setup(struct tegra_dsi *dsi);
> +
>  static inline struct tegra_dsi *
>  host1x_client_to_dsi(struct host1x_client *client)
>  {
> @@ -805,6 +808,20 @@ static int tegra_output_dsi_setup_clock(struct tegra_output *output,
>
>         lanes = tegra_dsi_get_lanes(dsi);
>
> +       err = tegra_dsi_pad_calibrate(dsi);
> +       if (err < 0) {
> +               dev_err(dsi->dev, "MIPI calibration failed: %d\n", err);
> +               return err;
> +       }
> +       if (dsi->slave) {
> +               err = tegra_dsi_pad_calibrate(dsi->slave);
> +               if (err < 0) {
> +                       dev_err(dsi->slave->dev,
> +                               "MIPI calibration failed: %d\n", err);
> +                       return err;
> +               }
> +       }

Move this duplicate call into tegra_dsi_pad_calibrate() to be
consistent with the other functions in this file (eg:
tegra_dsi_set_timeout).

> +
>         err = tegra_dsi_get_muldiv(dsi->format, &mul, &div);
>         if (err < 0)
>                 return err;
> @@ -833,6 +850,13 @@ static int tegra_output_dsi_setup_clock(struct tegra_output *output,
>                 dev_err(dsi->dev, "failed to set parent clock: %d\n", err);
>                 return err;
>         }
> +       if (dsi->slave) {
> +               err = tegra_dsi_ganged_setup(dsi);
> +               if (err < 0) {
> +                       dev_err(dsi->dev, "DSI ganged setup failed: %d\n", err);
> +                       return err;
> +               }
> +       }

I think this belongs in ->enable() instead of here.

>
>         err = clk_set_rate(dsi->clk_parent, plld);
>         if (err < 0) {
> @@ -1470,12 +1494,6 @@ static int tegra_dsi_probe(struct platform_device *pdev)
>                 goto disable_vdd;
>         }
>
> -       err = tegra_dsi_pad_calibrate(dsi);
> -       if (err < 0) {
> -               dev_err(dsi->dev, "MIPI calibration failed: %d\n", err);
> -               goto mipi_free;
> -       }
> -
>         dsi->host.ops = &tegra_dsi_host_ops;
>         dsi->host.dev = &pdev->dev;
>
> @@ -1544,6 +1562,67 @@ static int tegra_dsi_remove(struct platform_device *pdev)
>         return 0;
>  }
>
> +#ifdef CONFIG_PM
> +static int tegra_dsi_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +       struct tegra_dsi *dsi = platform_get_drvdata(pdev);
> +       struct tegra_drm *tegra = dev_get_drvdata(dsi->client.parent);
> +       struct drm_connector *connector;
> +
> +       if (dsi->master) {
> +               regulator_disable(dsi->vdd);
> +               return 0;
> +       }
> +
> +       drm_modeset_lock_all(tegra->drm);
> +       list_for_each_entry(connector, &tegra->drm->mode_config.connector_list,
> +                           head) {
> +               int old_dpms = connector->dpms;
> +
> +               if (connector->funcs->dpms)
> +                       connector->funcs->dpms(connector, DRM_MODE_DPMS_OFF);
> +
> +               /* Set the old mode back to the connector for resume */
> +               connector->dpms = old_dpms;
> +       }
> +       drm_modeset_unlock_all(tegra->drm);
> +
> +       regulator_disable(dsi->vdd);
> +
> +       return 0;
> +}
> +
> +static int tegra_dsi_resume(struct platform_device *pdev)
> +{
> +       struct tegra_dsi *dsi = platform_get_drvdata(pdev);
> +       struct tegra_drm *tegra = dev_get_drvdata(dsi->client.parent);
> +       struct drm_connector *connector;
> +       int err = 0;
> +
> +       err = regulator_enable(dsi->vdd);
> +       if (err < 0) {
> +               dev_err(&pdev->dev, "Enable DSI vdd failed: %d\n", err);
> +               return err;
> +       }
> +
> +       if (dsi->master)
> +               return 0;
> +
> +       drm_modeset_lock_all(tegra->drm);
> +       list_for_each_entry(connector, &tegra->drm->mode_config.connector_list,
> +                           head) {
> +               if (connector->funcs->dpms)
> +                       connector->funcs->dpms(connector, connector->dpms);
> +       }
> +       drm_modeset_unlock_all(tegra->drm);
> +
> +       drm_helper_resume_force_mode(tegra->drm);
> +
> +       return 0;
> +}
> +#endif

So this is the tricky chunk, it definitely does not belong here. I
think it makes most sense for this to live in drm.c, however
host1x_driver doesn't have suspend/resume hooks.

I suspect the correct thing to do here is to add them to
host1x_driver, but I'm not sure how much effort is involved in doing
that.

Sean

> +
> +
>  static const struct of_device_id tegra_dsi_of_match[] = {
>         { .compatible = "nvidia,tegra114-dsi", },
>         { },
> @@ -1557,4 +1636,9 @@ struct platform_driver tegra_dsi_driver = {
>         },
>         .probe = tegra_dsi_probe,
>         .remove = tegra_dsi_remove,
> +#ifdef CONFIG_PM
> +       .suspend = tegra_dsi_suspend,
> +       .resume = tegra_dsi_resume,
> +#endif
> +
>  };
> --
> 1.8.1.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
