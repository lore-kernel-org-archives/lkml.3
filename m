Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbaJ2UuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:50:23 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:33300 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaJ2UuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:50:21 -0400
MIME-Version: 1.0
In-Reply-To: <1414577167-25666-1-git-send-email-kever.yang@rock-chips.com>
References: <1414577167-25666-1-git-send-email-kever.yang@rock-chips.com>
Date: Wed, 29 Oct 2014 13:50:20 -0700
X-Google-Sender-Auth: SHqW5UTLBC5stkC36fb0zhTI2-g
Message-ID: <CAD=FV=Vnt7Pg9V_cE0S8u-2X2hDsPN8huwy8xKv1UwvWEo-Hyw@mail.gmail.com>
Subject: Re: [PATCH] clk: rockchip: disable unused clocks
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, han jiang <hj@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Wed, Oct 29, 2014 at 3:06 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> The rockchip clock driver use CLK_IGNORE_UNUSED flag to make sure
> all the clocks are available like default power on state.
> We have implement the clock manage in most of rockchip drivers,
> it is time to remove it for power save.
> Instead we add CLK_IGNORE_UNUSED for some clock nodes which should
> be on during boot or no module driver in kernel will initialize it.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
>  drivers/clk/rockchip/clk-rk3188.c |  32 ++++-----
>  drivers/clk/rockchip/clk-rk3288.c | 146 +++++++++++++++++++-------------------
>  drivers/clk/rockchip/clk.c        |   9 ---
>  3 files changed, 90 insertions(+), 97 deletions(-)

Your patch didn't seem to apply to the top of Heiko's
"v3.19-clk/next".  Where should it apply to?

> -       GATE(ACLK_CPU, "aclk_cpu", "aclk_cpu_pre", 0,
> +       GATE(0, "aclk_cpu", "aclk_cpu_pre", CLK_IGNORE_UNUSED,
>                         RK3288_CLKGATE_CON(0), 3, GFLAGS),

It seems strange to me that you're removing the ACLK_CPU ID here.  Was
that on purpose?

> -       COMPOSITE_NOMUX(PCLK_CPU, "pclk_cpu", "aclk_cpu_pre", 0,
> +       COMPOSITE_NOMUX(0, "pclk_cpu", "aclk_cpu_pre", CLK_IGNORE_UNUSED,
>                         RK3288_CLKSEL_CON(1), 12, 3, DFLAGS,
>                         RK3288_CLKGATE_CON(0), 5, GFLAGS),

Here too for PCLK_CPU.  There are a few others as well.


I'll also say that when I applied this atop my local tree that USB
stopped working.  I just see:

[ 1647.626747] hub 2-1:1.0: hub_port_status failed (err = -110)
[ 1657.626746] hub 2-1:1.0: hub_port_status failed (err = -110)

...over and over and over again.
