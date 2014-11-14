Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161489AbaKNSYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:24:30 -0500
Received: from gloria.sntech.de ([95.129.55.99]:37195 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161383AbaKNSY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:24:28 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] clk: add property for force to update clock setting
Date: Fri, 14 Nov 2014 19:06:47 +0100
Message-ID: <6053586.L6Ix8HgKpA@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141114014102.25314.77218@quantum>
References: <1415884826-7877-1-git-send-email-kever.yang@rock-chips.com> <CAD=FV=WSDtxjtGD3c22OqXsSqaphKcmup9rAfonbeC-bUWHmSQ@mail.gmail.com> <20141114014102.25314.77218@quantum>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Am Donnerstag, 13. November 2014, 17:41:02 schrieb Mike Turquette:
> Quoting Doug Anderson (2014-11-13 15:27:32)

[...]

> All of the above is to say that perhaps the solution to this problem
> belongs in the driver. In the end we're talking about details for
> correctly programming hardware, which sounds an awful lot like what
> drivers are supposed to do.
> 
> Let me know if the ->init() callback holds any promise for you. If not
> we can figure something out.

>From my theoretical musings, ->init() sounds like a nice idea - but of
course it comes with a "but".

I guess the general idea would be to have the pll clk-type simply reset
to the same rate but forcing it to use the parameters from its parameter
table - when the rate params differ [0].

The only problem would be the apll supplying the cpu cores. After all clocks
are registered, our armclk makes sure that the core clock gets reparented
before changing the underlying apll [dpll is safe, as it is read-only currently].

At the moment the order would be
clk_register(apll)
apll->init()
clk_register(armclk);

I'm currently unsure if simply exchanging the register-order of armclk and
the plls would help, but as the orphan handling is done before the ->init
call I guess it might help.


Heiko


[0] (compile-tested only)
diff --git a/drivers/clk/rockchip/clk-pll.c b/drivers/clk/rockchip/clk-pll.c
index a3e886a..7f59579 100644
--- a/drivers/clk/rockchip/clk-pll.c
+++ b/drivers/clk/rockchip/clk-pll.c
@@ -257,6 +257,40 @@ static int rockchip_rk3066_pll_is_enabled(struct clk_hw *hw)
 	return !(pllcon & RK3066_PLLCON3_PWRDOWN);
 }
 
+static void rockchip_rk3066_pll_init(struct clk_hw *hw)
+{
+	struct rockchip_clk_pll *pll = to_rockchip_clk_pll(hw);
+	const struct rockchip_pll_rate_table *rate;
+	unsigned int nf, nr, no, bwadj;
+	unsigned long drate;
+	u32 pllcon;
+
+	drate = __clk_get_rate(hw->clk);
+	rate = rockchip_get_pll_settings(pll, drate);
+
+	/* when no rate setting for the current rate, rely on clk_set_rate */
+	if (!rate)
+		return;
+
+	pllcon = readl_relaxed(pll->reg_base + RK3066_PLLCON(0));
+	nr = ((pllcon >> RK3066_PLLCON0_NR_SHIFT) & RK3066_PLLCON0_NR_MASK) + 1;
+	no = ((pllcon >> RK3066_PLLCON0_OD_SHIFT) & RK3066_PLLCON0_OD_MASK) + 1;
+
+	pllcon = readl_relaxed(pll->reg_base + RK3066_PLLCON(1));
+	nf = ((pllcon >> RK3066_PLLCON1_NF_SHIFT) & RK3066_PLLCON1_NF_MASK) + 1;
+
+	pllcon = readl_relaxed(pll->reg_base + RK3066_PLLCON(2));
+	bwadj = (pllcon >> RK3066_PLLCON2_BWADJ_SHIFT) & RK3066_PLLCON2_BWADJ_MASK;
+
+	if (rate->nr != nr || rate->no != no || rate->nf != nf
+					     || rate->bwadj != bwadj) {
+		struct clk *parent = __clk_get_parent(hw->clk);
+		unsigned long prate = __clk_get_rate(parent);
+
+		rockchip_rk3066_pll_set_rate(hw, drate, prate);
+	}
+}
+
 static const struct clk_ops rockchip_rk3066_pll_clk_norate_ops = {
 	.recalc_rate = rockchip_rk3066_pll_recalc_rate,
 	.enable = rockchip_rk3066_pll_enable,
@@ -271,6 +305,7 @@ static const struct clk_ops rockchip_rk3066_pll_clk_ops = {
 	.enable = rockchip_rk3066_pll_enable,
 	.disable = rockchip_rk3066_pll_disable,
 	.is_enabled = rockchip_rk3066_pll_is_enabled,
+	.init = rockchip_rk3066_pll_init,
 };
 
 /*

