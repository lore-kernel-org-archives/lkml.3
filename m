Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbbAMKGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:06:37 -0500
Received: from down.free-electrons.com ([37.187.137.238]:60728 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751057AbbAMKGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:06:34 -0500
Date: Tue, 13 Jan 2015 11:06:21 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: "Nicolas Ferre" <nicolas.ferre@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        "Bo Shen" <voice.shen@atmel.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RESEND PATCH] clk: at91: keep slow clk enabled to prevent
 system hang
Message-ID: <20150113110621.52bda165@bbrezillon>
In-Reply-To: <20150112234424.20842.37457@quantum>
References: <1421075570-31200-1-git-send-email-boris.brezillon@free-electrons.com>
	<20150112234424.20842.37457@quantum>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015 15:44:24 -0800
Mike Turquette <mturquette@linaro.org> wrote:

> Quoting Boris Brezillon (2015-01-12 07:12:50)
> > All slow clk users are not properly requesting it (get + prepare + enable)
> > before using it.
> > If all users properly requesting this clock decide that they don't need it
> > anymore (or are removed), this lead to this clock being disabled while
> > faulty users are still requiring it, which in turn hangs the system.
> 
> The correct fix is for all users to claim the clock and enable it. Is
> there a plan to implement that any time soon?

Yes, hopefully for the next release, but this requires identifying all
the offending drivers, fixing them and testing all the changes.

> 
> > 
> > Prevent slow oscillator clock from being disabled until all users are
> > properly requesting it.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > Reported-by: Bo Shen <voice.shen@atmel.com>
> > Cc: stable@vger.kernel.org
> > ---
> > Hi Mike,
> > 
> > Sorry for the noise, but I forgot to add the LKML and LAKML in Cc.
> > 
> > Can you have a look at this fix and let me know if this is how you want this
> > problem addressed ?
> > I can also request (get + prepare + enable) the clk in the pmc probe function,
> > so that it can never be disabled.
> > 
> > If you're fine with the approach, can you queue it for the next -rc ?
> 
> I can queue something for the next -rc, but maybe not this fix.

Great.

> 
> > 
> > Best Regards,
> > 
> > Boris
> > 
> >  drivers/clk/at91/clk-slow.c | 28 ++++++++++++++++++++++++++--
> >  1 file changed, 26 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/clk/at91/clk-slow.c b/drivers/clk/at91/clk-slow.c
> > index 32f7c1b..effe3b0 100644
> > --- a/drivers/clk/at91/clk-slow.c
> > +++ b/drivers/clk/at91/clk-slow.c
> > @@ -96,7 +96,19 @@ static void clk_slow_osc_unprepare(struct clk_hw *hw)
> >         if (tmp & AT91_SCKC_OSC32BYP)
> >                 return;
> >  
> > -       writel(tmp & ~AT91_SCKC_OSC32EN, sckcr);
> > +       /*
> > +        * FIXME: All slow clk users are not properly requesting it (get +
> > +        * prepare + enable) before using it.
> > +        * If all users properly requesting this clock decide that they don't
> > +        * need it anymore (or are removed), this lead to this clock being
> > +        * disabled while faulty users are still requiring it, which in turn
> > +        * hangs the system.
> > +        * Prevent this clock from being disabled until all users are properly
> > +        * requesting it.
> > +        * Once this is done we should re-introduce this line:
> > +        *
> > +        * writel(tmp & ~AT91_SCKC_OSC32EN, sckcr);
> > +        */
> 
> The main problem here is that the clk prepare and enable usecounts are a
> lie. The use counts may be zero but the clock signal is still active. I
> think a better fix is for the clock driver to get, prepare & enable this
> clock in its probe function as you described above. If someone stumbles
> across this clock signal and wonders why it won't quiesce, at least the
> debug values will be accurate.

Yep, that makes sense.
I'll rework my patch.

Thanks,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
