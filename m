Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab3J1VFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:05:42 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:58695 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab3J1VFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:05:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>, linux@arm.linux.org.uk,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org, jiada_wang@mentor.com,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v6 0/5] clk: clock deregistration support
Date: Mon, 28 Oct 2013 22:06:05 +0100
Message-ID: <1409510.03uXiCHu2F@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.7-gentoo-r1; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131028195401.11662.11969@quantum>
References: <1377874402-2944-1-git-send-email-s.nawrocki@samsung.com> <525D9FC1.2040204@gmail.com> <20131028195401.11662.11969@quantum>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 October 2013 12:54:01 Mike Turquette wrote:
> Quoting Sylwester Nawrocki (2013-10-15 13:04:17)
> 
> > Hi,
> > 
> > (adding linux-media mailing list at Cc)
> > 
> > On 09/25/2013 11:47 AM, Laurent Pinchart wrote:
> > > On Tuesday 24 September 2013 23:38:44 Sylwester Nawrocki wrote:
> > [...]
> > 
> > >> The only issue I found might be at the omap3isp driver, which provides
> > >> clock to its sub-drivers and takes reference on the sub-driver modules.
> > >> When sub-driver calls clk_get() all modules would get locked in memory,
> > >> due to circular reference. One solution to that could be to pass NULL
> > >> struct device pointer, as in the below patch.
> > > 
> > > Doesn't that introduce race conditions ? If the sub-drivers require the
> > > clock, they want to be sure that the clock won't disappear beyond their
> > > backs. I agree that the circular dependency needs to be solved somehow,
> > > but we probably need a more generic solution. The problem will become
> > > more widespread in the future with DT-based device instantiation in
> > > both V4L2 and KMS.
> > 
> > I'm wondering whether subsystems and drivers itself should be written so
> > they deal with such dependencies they are aware of.
> > 
> > There is similar situation in the regulator API, regulator_get() simply
> > takes a reference on a module providing the regulator object.
> > 
> > Before a "more generic solution" is available, what do you think about
> > keeping obtaining a reference on a clock provider module in clk_get() and
> > doing clk_get(), clk_prepare_enable(), ..., clk_unprepare_disable(),
> > clk_put() in sub-driver whenever a clock is actively used, to avoid
> > permanent circular reference ?
> 
> Laurent,
> 
> Did you have any feedback on this proposal? I would like to merge these
> patches so that folks with clock driver modules can use them properly.
> We can fix up things in the core code as we figure them out.

I've just replied to Sylwester's original patch. I'm basically OK with the 
idea as a temporary solution.

> > >> ---------8<------------------
> > >> 
> > >>   From ca5963041aad67e31324cb5d4d5e2cfce1706d4f Mon Sep 17 00:00:00
> > >>   2001
> > >> 
> > >> From: Sylwester Nawrocki<s.nawrocki@samsung.com>
> > >> Date: Thu, 19 Sep 2013 23:52:04 +0200
> > >> Subject: [PATCH] omap3isp: Pass NULL device pointer to clk_register()
> > >> 
> > >> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> > >> ---
> > >> 
> > >>    drivers/media/platform/omap3isp/isp.c |   15 ++++++++++-----
> > >>    drivers/media/platform/omap3isp/isp.h |    1 +
> > >>    2 files changed, 11 insertions(+), 5 deletions(-)
> > >> 
> > >> diff --git a/drivers/media/platform/omap3isp/isp.c
> > >> b/drivers/media/platform/omap3isp/isp.c
> > >> index df3a0ec..d7f3c98 100644
> > >> --- a/drivers/media/platform/omap3isp/isp.c
> > >> +++ b/drivers/media/platform/omap3isp/isp.c
> > >> @@ -290,9 +290,11 @@ static int isp_xclk_init(struct isp_device *isp)
> > >> 
> > >>      struct clk_init_data init;
> > >>      unsigned int i;
> > >> 
> > >> +    for (i = 0; i<  ARRAY_SIZE(isp->xclks); ++i)
> > >> +            isp->xclks[i] = ERR_PTR(-EINVAL);
> > >> +
> > >> 
> > >>      for (i = 0; i<  ARRAY_SIZE(isp->xclks); ++i) {
> > >>      
> > >>              struct isp_xclk *xclk =&isp->xclks[i];
> > >> 
> > >> -            struct clk *clk;
> > >> 
> > >>              xclk->isp = isp;
> > >>              xclk->id = i == 0 ? ISP_XCLK_A : ISP_XCLK_B;
> > >> 
> > >> @@ -306,9 +308,9 @@ static int isp_xclk_init(struct isp_device *isp)
> > >> 
> > >>              xclk->hw.init =&init;
> > >> 
> > >> -            clk = devm_clk_register(isp->dev,&xclk->hw);
> > >> -            if (IS_ERR(clk))
> > >> -                    return PTR_ERR(clk);
> > >> +            xclk->clk = clk_register(NULL,&xclk->hw);
> > >> +            if (IS_ERR(xclk->clk))
> > >> +                    return PTR_ERR(xclk->clk);
> > >> 
> > >>              if (pdata->xclks[i].con_id == NULL&&
> > >>              pdata->xclks[i].dev_id == NULL)
> > >> 
> > >> @@ -320,7 +322,7 @@ static int isp_xclk_init(struct isp_device *isp)
> > >> 
> > >>              xclk->lookup->con_id = pdata->xclks[i].con_id;
> > >>              xclk->lookup->dev_id = pdata->xclks[i].dev_id;
> > >> 
> > >> -            xclk->lookup->clk = clk;
> > >> +            xclk->lookup->clk = xclk->clk;
> > >> 
> > >>              clkdev_add(xclk->lookup);
> > >>      
> > >>      }
> > >> 
> > >> @@ -335,6 +337,9 @@ static void isp_xclk_cleanup(struct isp_device
> > >> *isp)
> > >> 
> > >>      for (i = 0; i<  ARRAY_SIZE(isp->xclks); ++i) {
> > >>      
> > >>              struct isp_xclk *xclk =&isp->xclks[i];
> > >> 
> > >> +            if (!IS_ERR(xclk->clk))
> > >> +                    clk_unregister(xclk->clk);
> > >> +
> > >> 
> > >>              if (xclk->lookup)
> > >>              
> > >>                      clkdev_drop(xclk->lookup);
> > >>      
> > >>      }
> > >> 
> > >> diff --git a/drivers/media/platform/omap3isp/isp.h
> > >> b/drivers/media/platform/omap3isp/isp.h
> > >> index cd3eff4..1498f2b 100644
> > >> --- a/drivers/media/platform/omap3isp/isp.h
> > >> +++ b/drivers/media/platform/omap3isp/isp.h
> > >> @@ -135,6 +135,7 @@ struct isp_xclk {
> > >> 
> > >>      struct isp_device *isp;
> > >>      struct clk_hw hw;
> > >>      struct clk_lookup *lookup;
> > >> 
> > >> +    struct clk *clk;
> > >> 
> > >>      enum isp_xclk_id id;
> > >>      
> > >>      spinlock_t lock;        /* Protects enabled and divider */
> > >> 
> > >> ---------8<------------------
-- 
Regards,

Laurent Pinchart

