Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaKOFll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 00:41:41 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:57516 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaKOFlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 00:41:37 -0500
MIME-Version: 1.0
In-Reply-To: <1415972348-8382-1-git-send-email-andy.yan@rock-chips.com>
References: <1415972231-8283-1-git-send-email-andy.yan@rock-chips.com> <1415972348-8382-1-git-send-email-andy.yan@rock-chips.com>
From: Daniel Kurtz <djkurtz@google.com>
Date: Sat, 15 Nov 2014 13:41:16 +0800
Message-ID: <CAGS+omCQ97eo6BhhfCucgeAK8Kq0GtR8jOiv2AF7x=w2d9F8yw@mail.gmail.com>
Subject: Re: [PATCH v11 02/12] staging: imx-drm: imx-hdmi: return defer if
 can't get ddc i2c adapter
To: Andy Yan <andy.yan@rock-chips.com>
Cc: David Airlie <airlied@linux.ie>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        fabio.estevam@freescale.com, rmk+kernel@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lucas Stach <l.stach@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        Yakir Yang <ykk@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        devel@driverdev.osuosl.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Xu Jianqun <jay.xu@rock-chips.com>, Pawel Moll <pawel.moll@arm.com>,
        "mark.yao@rock-chips.com" <mark.yao@rock-chips.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 9:39 PM, Andy Yan <andy.yan@rock-chips.com> wrote:
> drm driver may probe before the i2c bus, so the driver should
> defer probing until it is available
>
> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>
> ---
>
> Changes in v11: None
> Changes in v10: None
> Changes in v9: None
> Changes in v8: None
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4:
> - defer probe ddc i2c adapter
>
> Changes in v3: None
> Changes in v2: None
>
>  drivers/staging/imx-drm/imx-hdmi.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/staging/imx-drm/imx-hdmi.c
> index 79daec4..c2b035a 100644
> --- a/drivers/staging/imx-drm/imx-hdmi.c
> +++ b/drivers/staging/imx-drm/imx-hdmi.c
> @@ -1611,8 +1611,11 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
>         ddc_node = of_parse_phandle(np, "ddc-i2c-bus", 0);
>         if (ddc_node) {
>                 hdmi->ddc = of_find_i2c_adapter_by_node(ddc_node);
> -               if (!hdmi->ddc)
> +               if (!hdmi->ddc) {
>                         dev_dbg(hdmi->dev, "failed to read ddc node\n");
> +                       of_node_put(ddc_node);
> +                       return -EPROBE_DEFER;
> +               }

Nit:  You could move "of_node_put()" above "if (!hdmi->ddc)", and not
need it in two places.

Either way, this one is:
Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>

>
>                 of_node_put(ddc_node);
>         } else {
> --
> 1.9.1
>



-- 
Daniel Kurtz | Software Engineer | djkurtz@google.com | 650.204.0722
