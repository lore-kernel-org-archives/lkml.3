Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaIXTsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:48:20 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:56625 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaIXTsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:48:13 -0400
MIME-Version: 1.0
In-Reply-To: <1411572802-22042-4-git-send-email-kever.yang@rock-chips.com>
References: <1411572802-22042-1-git-send-email-kever.yang@rock-chips.com>
	<1411572802-22042-4-git-send-email-kever.yang@rock-chips.com>
Date: Wed, 24 Sep 2014 12:48:12 -0700
X-Google-Sender-Auth: LmNun8REc7iQt0pJ6NvA4wxRTvo
Message-ID: <CAD=FV=UqB26_GzP14ueHHpmjgJqX7sPpR0T+SR60e=i_YbWitQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] clk: rockchip: add clock node in PD_VIDEO
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Wed, Sep 24, 2014 at 8:33 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> This patch add the clock node in PD_VIDEO
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> ---
>
> Changes in v2:
> - split out the patch
>
>  drivers/clk/rockchip/clk-rk3288.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
> index d691a56..2cfcfb6 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -296,6 +296,17 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
>         COMPOSITE(0, "aclk_vdpu", mux_pll_src_cpll_gpll_usb480m_p, 0,
>                         RK3288_CLKSEL_CON(32), 14, 2, MFLAGS, 8, 5, DFLAGS,
>                         RK3288_CLKGATE_CON(3), 11, GFLAGS),
> +       /*
> +        * We use aclk_vdpu by default GRF_SOC_CON0[7] setting in system,
> +        * so we ignore the mux and make clocks nodes as following,

I guess we can't add the mux for now because it's in the GRF and not
in the clock area and the current clock tables don't have support for
that.  I guess that OK for now, but eventually we should probably add
it in.


> +        * NOTE THAT hclk_vcodec is fix div by 4 from aclk_vcodec_pre.

Typo: from "aclk_vcodec_pre" or from "hclk_vcodec_pre"?

> +        */
> +       GATE(ACLK_VCODEC, "aclk_vcodec", "aclk_vdpu", 0,
> +               RK3288_CLKGATE_CON(9), 0, GFLAGS),
> +       GATE(0, "hclk_vcodec_pre", "aclk_vdpu", 0,
> +               RK3288_CLKGATE_CON(3), 10, GFLAGS),
> +       GATE(HCLK_VCODEC, "hclk_vcodec", "hclk_vcodec_pre", 0,
> +               RK3288_CLKGATE_CON(9), 1, GFLAGS),

Shouldn't there be a fixed "/ 4" clock somewhere in here?  That way
the clock rate will be reported correctly?

I guess the cleanest would be to add support to rockchip/clk.c to call
clk_register_fixed_factor() somehow.  I guess I'll leave it to you and
Heiko to decide what you want to do here.


-Doug
