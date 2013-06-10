Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3FJWQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:16:11 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:38649 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3FJWQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:16:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Kukjin Kim <kgene.kim@samsung.com>,
        "'Doug Anderson'" <dianders@chromium.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <08e301ce61e3$045828c0$0d087a40$%kim@samsung.com>
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Vikas Sajjan'" <vikas.sajjan@linaro.org>,
        "'Yadwinder Singh Brar'" <yadi.brar01@gmail.com>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>, linux-kernel@vger.kernel.org
References: <1370026725-22910-1-git-send-email-dianders@chromium.org>
 <08e301ce61e3$045828c0$0d087a40$%kim@samsung.com>
Message-ID: <20130610221605.8816.20262@quantum>
User-Agent: alot/0.3.4
Subject: Re: RE: [PATCH] clk: samsung: Fix pll36xx_recalc_rate to handle kdiv properly
Date: Mon, 10 Jun 2013 15:16:05 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kukjin Kim (2013-06-05 04:51:29)
> Doug Anderson wrote:
> > 
> > The KDIV value is often listed as unsigned but it needs to be treated
> > as a 16-bit signed value when using it in calculations.  Fix our rate
> > recalculation to do this correctly.
> > 
> > Before doing this, I tried setting EPLL on exynos5250 to:
> >   rate, m, p, s, k = 80000000, 107, 2, 4, 43691
> > 
> > This rate is exactly from the table in the exynos5250 user manual.
> > 
> > I read this back as 80750003 with:
> >   cat /sys/kernel/debug/clk/fin_pll/fout_epll/clk_rate
> > 
> > After this patch, it reads back as 80000003
> > 
> >   mw 0x10020130 a06b0204
> >   mw 0x10020134 0000aaab
> > 
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> 
> Yeah,
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> 
> Mike, please apply in your fixes.
> 
> Thanks.
> 
> - Kukjin
> 
> > ---
> > This patch is based upon another in-flight patch to avoid conflicts:
> >   clk: samsung: Use clk->base instead of directly using clk->con0 for
> > PLL3xxx
> >   https://patchwork.kernel.org/patch/2629751/

The dependency series is not destined for clk-fixes but Kukjin has
requested this patch as a fix.  If you want this patch as a fix can you
rebase it against:

git://git.linaro.org/people/mturquette/linux.git clk-fixes

Thanks,
Mike

> > 
> >  drivers/clk/samsung/clk-pll.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/clk/samsung/clk-pll.c b/drivers/clk/samsung/clk-pll.c
> > index 01f17cf..26416bb 100644
> > --- a/drivers/clk/samsung/clk-pll.c
> > +++ b/drivers/clk/samsung/clk-pll.c
> > @@ -115,7 +115,8 @@ static unsigned long
> > samsung_pll36xx_recalc_rate(struct clk_hw *hw,
> >                               unsigned long parent_rate)
> >  {
> >       struct samsung_clk_pll *pll = to_clk_pll(hw);
> > -     u32 mdiv, pdiv, sdiv, kdiv, pll_con0, pll_con1;
> > +     u32 mdiv, pdiv, sdiv, pll_con0, pll_con1;
> > +     s16 kdiv;
> >       u64 fvco = parent_rate;
> > 
> >       pll_con0 = pll_readl(pll, PLL36XX_CON0_OFFSET);
> > @@ -123,7 +124,7 @@ static unsigned long
> > samsung_pll36xx_recalc_rate(struct clk_hw *hw,
> >       mdiv = (pll_con0 >> PLL36XX_MDIV_SHIFT) & PLL36XX_MDIV_MASK;
> >       pdiv = (pll_con0 >> PLL36XX_PDIV_SHIFT) & PLL36XX_PDIV_MASK;
> >       sdiv = (pll_con0 >> PLL36XX_SDIV_SHIFT) & PLL36XX_SDIV_MASK;
> > -     kdiv = pll_con1 & PLL36XX_KDIV_MASK;
> > +     kdiv = (s16)(pll_con1 & PLL36XX_KDIV_MASK);
> > 
> >       fvco *= (mdiv << 16) + kdiv;
> >       do_div(fvco, (pdiv << sdiv));
> > --
> > 1.8.2.1
