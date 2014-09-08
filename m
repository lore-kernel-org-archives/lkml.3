Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaIHTht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:37:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46653 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751891AbaIHThr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:37:47 -0400
Date: Mon, 8 Sep 2014 21:37:43 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] rtc: at91sam9: retain slow clock and check its rate
Message-ID: <20140908213743.27d7a1bc@bbrezillon>
In-Reply-To: <20140908212218.6a81af86@bbrezillon>
References: <1409733934-14465-1-git-send-email-boris.brezillon@free-electrons.com>
	<1409733934-14465-5-git-send-email-boris.brezillon@free-electrons.com>
	<20140908173338.GD14623@piout.net>
	<20140908212218.6a81af86@bbrezillon>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2014 21:22:18 +0200
Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:

> On Mon, 8 Sep 2014 19:33:38 +0200
> Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
> 
> > On 03/09/2014 at 10:45:33 +0200, Boris Brezillon wrote :
> > > The RTT block is using the slow clock and expect it to run at 32KHz.
> > > Now that we moved to the CCF it's better to retain the clk reference so
> > > that the CCF can't disable the slow clock considering it is unused.
> > > 
> > > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > > ---
> > >  drivers/rtc/rtc-at91sam9.c | 24 ++++++++++++++++++++++++
> > >  1 file changed, 24 insertions(+)
> > > 
> > > diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
> > > index 57014b7..5c5093b 100644
> > > --- a/drivers/rtc/rtc-at91sam9.c
> > > +++ b/drivers/rtc/rtc-at91sam9.c
> > > @@ -21,6 +21,7 @@
> > >  #include <linux/slab.h>
> > >  #include <linux/platform_data/atmel.h>
> > >  #include <linux/io.h>
> > > +#include <linux/clk.h>
> > >  
> > >  /*
> > >   * This driver uses two configurable hardware resources that live in the
> > > @@ -74,6 +75,7 @@ struct sam9_rtc {
> > >  	u32			imr;
> > >  	void __iomem		*gpbr;
> > >  	int 			irq;
> > > +	struct clk		*sclk;
> > >  };
> > >  
> > >  #define rtt_readl(rtc, field) \
> > > @@ -373,6 +375,25 @@ static int at91_rtc_probe(struct platform_device *pdev)
> > >  		return ret;
> > >  	}
> > >  
> > > +	/* Retain slow clk if it is specified in the DT.
> > > +	 * Do not complain if slow clk is missing, but check its rate
> > > +	 * if it is available.
> > > +	 */
> > > +	rtc->sclk = devm_clk_get(&pdev->dev, NULL);
> > > +	if (!IS_ERR(rtc->sclk)) {
> > > +		if (clk_get_rate(rtc->sclk) != AT91_SLOW_CLOCK) {
> > 
> > I would not bother doing that check but use the value for MR instead of
> > AT91_SLOW_CLOCK (see my previous mail).
> 
> Unfortunately, we can't get rid of this macro without modifying the
> clk_lookup table in several arch/arm/mach-at91/<soc-name>.c files in
> order to handle non DT/CCF cases (which will remain until all non DT
> boards are moved to DT).

After taking a closer look at what should be modified, I think it's
worth it: there's only 5 impacted files (at91sam9260.c, at91sam9261.c,
at91sam9263.c, at91sam9rl.c and at91sam9g45.c) and adding a clk_lookup
entry is pretty easy.

Moreover we'll end up with a clean driver and won't have to bother
about cleaning it up when dropping non DT boards support.



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
