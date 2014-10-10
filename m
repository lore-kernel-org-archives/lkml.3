Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaJJSym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:54:42 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:65106 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaJJSyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:54:41 -0400
MIME-Version: 1.0
In-Reply-To: <1412918637-9843-1-git-send-email-kever.yang@rock-chips.com>
References: <1412918637-9843-1-git-send-email-kever.yang@rock-chips.com>
Date: Fri, 10 Oct 2014 11:54:40 -0700
X-Google-Sender-Auth: U-7WYEKH_Yjc9A2utpBTb5b4Kl4
Message-ID: <CAD=FV=WzUcvMoATQt6rp5kiZk9URUjdwY5YUcdJ32px21ZOkLQ@mail.gmail.com>
Subject: Re: [PATCH] clk: rockchip: change PLL setting for better clock jitter
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 9, 2014 at 10:23 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
> dclk_vop0/1 is the source of HDMI TMDS clock in rk3288, usually we
> use 594MHz for clock source of dclk_vop0/1.
>
> HDMI CTS 7-9 require TMDS Clock jitter is lower than 0.25*Tbit:
> TMDS clock(MHz)         CTS require jitter (ps)
>         297             84.2
>         148.5           168
>         74.25           336
>         27              1247
>
> PLL BW and VCO frequency effects the jitter of PLL output clock,
> clock jitter is better if BW is lower or VCO frequency is higher.
>
> If PLL use default setting of RK3066_PLL_RATE( 594000000, 2, 198, 4),
> the TMDS Clock jitter is higher than 250ps, which means we can't
> pass the test when TMDS clock is 297MHz or 148.5MHz.
>
> If we use RK3066_PLL_RATE_BWADJ(594000000, 1, 198, 8, 1),
> the TMDS Clock jitter is about 60ps and we can pass all test case.
>
> So we need this patch to make hdmi si test pass.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
>  drivers/clk/rockchip/clk-rk3288.c | 2 +-
>  drivers/clk/rockchip/clk.h        | 9 +++++++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
> index 7c30a5a..11a7376a 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -83,7 +83,7 @@ struct rockchip_pll_rate_table rk3288_pll_rates[] = {
>         RK3066_PLL_RATE( 742500000, 8, 495, 2),
>         RK3066_PLL_RATE( 696000000, 1, 58, 2),
>         RK3066_PLL_RATE( 600000000, 1, 50, 2),
> -       RK3066_PLL_RATE( 594000000, 2, 198, 4),
> +       RK3066_PLL_RATE_BWADJ(594000000, 1, 198, 8, 1),

I talked with Kever offline.  Both the old and new values here have
invalid Fvco according to the TRM.  He's going to investigate.  Please
wait before merging this patch.
