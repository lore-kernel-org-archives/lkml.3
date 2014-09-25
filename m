Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaIYWsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 18:48:42 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34554 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaIYWsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 18:48:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Doug Anderson <dianders@chromium.org>,
        "Kever Yang" <kever.yang@rock-chips.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAD=FV=UwV6xqubaBnOyT+QsAzOqe-0Cc43sy1Q5aLbWjxZ_B0Q@mail.gmail.com>
Cc: =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "Sonny Rao" <sonnyrao@chromium.org>,
        "Addy Ke" <addy.ke@rock-chips.com>, "Eddie Cai" <cf@rock-chips.com>,
        "Jianqun Xu" <xjq@rock-chips.com>, "han jiang" <hj@rock-chips.com>,
        "Tao Huang" <huangtao@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1411631328-14973-1-git-send-email-kever.yang@rock-chips.com>
 <1411631328-14973-4-git-send-email-kever.yang@rock-chips.com>
 <CAD=FV=UwV6xqubaBnOyT+QsAzOqe-0Cc43sy1Q5aLbWjxZ_B0Q@mail.gmail.com>
Message-ID: <20140925224816.19023.29712@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v3 3/3] clk: rockchip: add clock node in PD_VIDEO
Date: Thu, 25 Sep 2014 15:48:16 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Doug Anderson (2014-09-25 15:24:22)
> Kever,
> 
> On Thu, Sep 25, 2014 at 12:48 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> > This patch add the clock node in PD_VIDEO
> >
> > Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > ---
> >
> > Changes in v3:
> > - add a fix factor
> > - introduce a virtual node to implement the clock struct
> >
> > Changes in v2:
> > - split out the patch
> >
> >  drivers/clk/rockchip/clk-rk3288.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
> > index dd204cb..d466814 100644
> > --- a/drivers/clk/rockchip/clk-rk3288.c
> > +++ b/drivers/clk/rockchip/clk-rk3288.c
> > @@ -296,6 +296,20 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
> >         COMPOSITE(0, "aclk_vdpu", mux_pll_src_cpll_gpll_usb480m_p, 0,
> >                         RK3288_CLKSEL_CON(32), 14, 2, MFLAGS, 8, 5, DFLAGS,
> >                         RK3288_CLKGATE_CON(3), 11, GFLAGS),
> > +       /*
> > +        * We use aclk_vdpu by default GRF_SOC_CON0[7] setting in system,
> > +        * so we ignore the mux and make clocks nodes as following,
> > +        */
> > +       GATE(ACLK_VCODEC, "aclk_vcodec", "aclk_vdpu", 0,
> > +               RK3288_CLKGATE_CON(9), 0, GFLAGS),
> > +       /*
> > +        * We introduce a virtul node of hclk_vodec_pre_v to split one clock
> > +        * sturct with a gate and a fix divider into two node in software.
> 
> nit: s/sturct/struct
> 
> ...I think Mike will fix this up when applying.

Fixed locally.

> 
> > +        */
> > +       GATE(0, "hclk_vcodec_pre_v", "aclk_vdpu", 0,
> > +               RK3288_CLKGATE_CON(3), 10, GFLAGS),
> > +       GATE(HCLK_VCODEC, "hclk_vcodec", "hclk_vcodec_pre", 0,
> > +               RK3288_CLKGATE_CON(9), 1, GFLAGS),
> >
> >         COMPOSITE(0, "aclk_vio0", mux_pll_src_cpll_gpll_usb480m_p, 0,
> >                         RK3288_CLKSEL_CON(31), 6, 2, MFLAGS, 0, 5, DFLAGS,
> > @@ -711,6 +725,12 @@ static void __init rk3288_clk_init(struct device_node *np)
> >                 pr_warn("%s: could not register clock usb480m: %ld\n",
> >                         __func__, PTR_ERR(clk));
> >
> > +       clk = clk_register_fixed_factor(NULL, "hclk_vcodec_pre",
> > +                                       "hclk_vcodec_pre_v", 0, 1, 4);
> > +       if (IS_ERR(clk))
> > +               pr_warn("%s: could not register clock hclk_vcodec_pre: %ld\n",
> > +                       __func__, PTR_ERR(clk));
> > +
> >         rockchip_clk_register_plls(rk3288_pll_clks,
> >                                    ARRAY_SIZE(rk3288_pll_clks),
> >                                    RK3288_GRF_SOC_STATUS);
> 
> Looks reasonable.
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> 
> I've booted this up and the new clocks show up and have the right parents.
> 
> Tested-by: Doug Anderson <dianders@chromium.org>

Applied to clk-next.

Thanks,
Mike
