Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbaGJAVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 20:21:39 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:57317 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaGJAVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 20:21:37 -0400
MIME-Version: 1.0
In-Reply-To: <1402277876-25949-1-git-send-email-fwu@marvell.com>
References: <1402277876-25949-1-git-send-email-fwu@marvell.com>
Date: Wed, 9 Jul 2014 17:21:37 -0700
Message-ID: <CAJAp7OjhjkRZvAb8DvURCasQr_=yCvW7npWnNyOzHZH5ndKdrg@mail.gmail.com>
Subject: Re: [PATCH v6] pinctrl: to avoid duplicated calling
 enable_pinmux_setting for a pin
From: Bjorn Andersson <bjorn@kryo.se>
To: fwu@marvell.com
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tony Lindgren <tony@atomide.com>, plagnioj@jcrosoft.com,
        Kukjin Kim <kgene.kim@samsung.com>, heiko@sntech.de,
        Tomasz Figa <t.figa@samsung.com>, thomas.abraham@linaro.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, thierry.reding@gmail.com, baohua@kernel.org,
        viresh.linux@gmail.com, Matt Porter <matt.porter@linaro.org>,
        syin@broadcom.com, jg1.han@samsung.com, Rongjun.Ying@csr.com,
        Rong.Wang@csr.com, linux@prisktech.co.nz,
        yongjun_wei@trendmicro.com.cn, laurent.navet@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, cxie4@marvell.com,
        ylmao@marvell.com, njiang1@marvell.com, tianxf@marvell.com,
        fswu@marvell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2014 at 6:37 PM,  <fwu@marvell.com> wrote:
> From: Fan Wu <fwu@marvell.com>
[...]
> diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
> index df6dda4c..bdfaba4 100644
> --- a/drivers/pinctrl/pinctrl-msm.c
> +++ b/drivers/pinctrl/pinctrl-msm.c
> @@ -165,36 +165,11 @@ static int msm_pinmux_enable(struct pinctrl_dev *pctldev,
>         return 0;
>  }
>
> -static void msm_pinmux_disable(struct pinctrl_dev *pctldev,
> -                              unsigned function,
> -                              unsigned group)
> -{
> -       struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
> -       const struct msm_pingroup *g;
> -       unsigned long flags;
> -       u32 val;
> -
> -       g = &pctrl->soc->groups[group];
> -
> -       if (WARN_ON(g->mux_bit < 0))
> -               return;
> -
> -       spin_lock_irqsave(&pctrl->lock, flags);
> -
> -       /* Clear the mux bits to select gpio mode */
> -       val = readl(pctrl->regs + g->ctl_reg);
> -       val &= ~(0x7 << g->mux_bit);
> -       writel(val, pctrl->regs + g->ctl_reg);
> -
> -       spin_unlock_irqrestore(&pctrl->lock, flags);
> -}
> -
>  static const struct pinmux_ops msm_pinmux_ops = {
>         .get_functions_count    = msm_get_functions_count,
>         .get_function_name      = msm_get_function_name,
>         .get_function_groups    = msm_get_function_groups,
>         .enable                 = msm_pinmux_enable,
> -       .disable                = msm_pinmux_disable,
>  };
>

Sorry for being so late to the game. Totally missed when this until Linus today
told me that 'disable' is gone.

Given the following dt snippet:

        active: active {
                foo {
                        pins = "pin1";
                        function = "function";
                };
        };

        sleep: sleep {
                foo {
                        pins = "pin1";
                };
        };

Calling:
        pinctrl_select_state(&active);
        pinctrl_select_state(&sleep);

If I understand the code correctly after your change there will be no pinmux
operations performed during this transition. As you can see from the comment
above the Qualcomm driver relies on this fact to disable muxing; i.e. select
gpio function.

So most likely I have misunderstood what the disable function was supposed to
do, and we would need to add an explicit "gpio" function to all pingroups as
well as explicitly specifying that for every gpio-configured pin in the device
tree.

I.e. the lack of the string 'function = "gpio"' in below example makes the
state incomplete:

foo {
        bar {
                pins = "pin1";
                bias-pull-up;
        };
};

Is this assumption correct?

Regards,
Bjorn
