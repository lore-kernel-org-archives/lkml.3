Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaJVEdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 00:33:22 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:48668 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaJVEdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 00:33:19 -0400
MIME-Version: 1.0
In-Reply-To: <1413933588-25721-1-git-send-email-zyw@rock-chips.com>
References: <1413933461-25602-1-git-send-email-zyw@rock-chips.com>
	<1413933588-25721-1-git-send-email-zyw@rock-chips.com>
Date: Tue, 21 Oct 2014 21:33:19 -0700
X-Google-Sender-Auth: hXbQO6qctOnuoUAaerkIDjx2_bA
Message-ID: <CAD=FV=W05jEfViCGyz76myP2k7-WFrXwB+o3pzCwCj5kob2TVg@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] pinctrl: rockchip: save and restore gpio6_c6
 pinmux in suspend/resume
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, Oct 21, 2014 at 4:19 PM, Chris Zhong <zyw@rock-chips.com> wrote:

> +static u32 rk3288_grf_gpio6c_iomux;

Somehow my instinct says that this should be in the "info" structure,
but I can't say exactly why (since by definition there can be only one
gpio6_c6).  ...no need to change this in my opinion.


>  static int rockchip_pinctrl_suspend(struct device *dev)
>  {
>         struct rockchip_pinctrl *info = dev_get_drvdata(dev);
> +       int ret = pinctrl_force_sleep(info->pctl_dev);
> +
> +       if (ret)
> +               return ret;
> +
> +       /*
> +        * RK3288 GPIO6_C6 mux would be modified by Maskrom when resume, so save
> +        * the setting here, and restore it at resume.
> +        */
> +       if (info->ctrl->type == RK3288) {
> +               ret = regmap_read(info->regmap_base, RK3288_GRF_GPIO6C_IOMUX,
> +                                 &rk3288_grf_gpio6c_iomux);
> +               if (ret)
> +                       return ret;

I seriously doubt it matters, but as a nit it seems like you should
call pinctrl_force_default() in the error case (to undo
pinctrl_force_sleep).


Everything is just nits and this works for me, so:

Tested-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Doug Anderson <dianders@chromium.org>
