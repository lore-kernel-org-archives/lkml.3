Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaBKTN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:13:58 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:52495 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaBKTNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:13:55 -0500
MIME-Version: 1.0
Reply-To: kusmabite@gmail.com
In-Reply-To: <1392138747-18198-1-git-send-email-digetx@gmail.com>
References: <1392138747-18198-1-git-send-email-digetx@gmail.com>
From: Erik Faye-Lund <kusmabite@gmail.com>
Date: Tue, 11 Feb 2014 20:13:14 +0100
Message-ID: <CABPQNSYNpwf_EQqUc2zpQ1cVQE++2ma-bR-rfQPdNoaJc07W4w@mail.gmail.com>
Subject: Re: [PATCH 1/1] drm/tegra: Add guard to avoid double disable/enable
 of RGB outputs
To: Dmitry Osipenko <digetx@gmail.com>
Cc: thierry.reding@gmail.com, tbergstrom@nvidia.com, airlied@linux.ie,
        swarren@wwwdotorg.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 6:12 PM, Dmitry Osipenko <digetx@gmail.com> wrote:
> Add guard to check whether RGB output is already enabled in the way it's
> done for HDMI output. Fixes possible hang on trying to disable output twice
> (first time during driver probe and second on fb registering).
>
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>  drivers/gpu/drm/tegra/rgb.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
> index 338f7f6..0266fb4 100644
> --- a/drivers/gpu/drm/tegra/rgb.c
> +++ b/drivers/gpu/drm/tegra/rgb.c
> @@ -15,6 +15,7 @@
>  struct tegra_rgb {
>         struct tegra_output output;
>         struct tegra_dc *dc;
> +       bool enabled;
>
>         struct clk *clk_parent;
>         struct clk *clk;
> @@ -89,6 +90,9 @@ static int tegra_output_rgb_enable(struct tegra_output *output)
>         struct tegra_rgb *rgb = to_rgb(output);
>         unsigned long value;
>
> +       if (rgb->enabled)
> +               return 0;
> +
>         tegra_dc_write_regs(rgb->dc, rgb_enable, ARRAY_SIZE(rgb_enable));
>
>         value = DE_SELECT_ACTIVE | DE_CONTROL_NORMAL;
> @@ -122,6 +126,8 @@ static int tegra_output_rgb_enable(struct tegra_output *output)
>         tegra_dc_writel(rgb->dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
>         tegra_dc_writel(rgb->dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
>
> +       rgb->enabled = true;
> +
>         return 0;
>  }
>
> @@ -130,6 +136,9 @@ static int tegra_output_rgb_disable(struct tegra_output *output)
>         struct tegra_rgb *rgb = to_rgb(output);
>         unsigned long value;
>
> +       if (!rgb->enabled)
> +               return 0;
> +
>         value = tegra_dc_readl(rgb->dc, DC_CMD_DISPLAY_POWER_CONTROL);
>         value &= ~(PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
>                    PW4_ENABLE | PM0_ENABLE | PM1_ENABLE);
> @@ -144,6 +153,8 @@ static int tegra_output_rgb_disable(struct tegra_output *output)
>
>         tegra_dc_write_regs(rgb->dc, rgb_disable, ARRAY_SIZE(rgb_disable));
>
> +       rgb->enabled = false;
> +
>         return 0;
>  }
>

Wouldn't it make more sense to make "enabled" and int that counts how
many times tegra_output_rgb_enable has been called? That way you can
have tegra_output_rgb_disable only really disable the display once the
same amount of disables have been performed...
