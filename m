Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaEMBad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 21:30:33 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53110 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaEMBab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 21:30:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <4987444.Zp0Prbn0Y8@wuerfel>
Cc: "Maxime Ripard" <maxime.ripard@free-electrons.com>,
        devicetree@vger.kernel.org, andriy.shevchenko@intel.com,
        "Emilio Lopez" <emilio@elopez.com.ar>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhuzhenhua@allwinnertech.com,
        "Vinod Koul" <vinod.koul@intel.com>, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, "Dan Williams" <dan.j.williams@intel.com>
References: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com>
 <201404231439.02913.arnd@arndb.de> <20140423131720.GS24905@lukather>
 <4987444.Zp0Prbn0Y8@wuerfel>
Message-ID: <20140513013024.5943.89772@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v6 3/8] ARM: sunxi: Move the clock protection to machine hooks
Date: Mon, 12 May 2014 18:30:24 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Arnd Bergmann (2014-04-23 06:31:06)
> On Wednesday 23 April 2014 15:17:20 Maxime Ripard wrote:
> > > > +#include <linux/clk.h>
> > > >  #include <linux/init.h>
> > > >  #include <linux/of_platform.h>
> > > >  
> > > > @@ -19,9 +20,17 @@
> > > >  
> > > >  static void __init sun4i_dt_init(void)
> > > >  {
> > > > +       struct clk *clk;
> > > > +
> > > >         sunxi_setup_restart();
> > > >  
> > > >         of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> > > > +
> > > > +       /* Make sure the clocks we absolutely need are enabled */
> > > > +       /* DDR clock */
> > > > +       clk = clk_get(NULL, "pll5_ddr");
> > > > +       if (!IS_ERR(clk))
> > > > +               clk_prepare_enable(clk);
> > > >  }
> > > 
> > > Isn't there already DT syntax to do the same? If not, should there be?
> > 
> > I don't think there is, and I gave some thought about it too. But
> > something a la regulator-always-on wouldn't work with clocks with
> > multiple outputs (like pll5), because you might need to leave only one
> > of the output enabled, but not the others, and I couldn't think of a
> > nice way to do so.
> > 
> > If you have one, I'd be happy to implement it.
> 
> We had a discussion a while ago about encoding default settings for clock
> providers in the clock provider nodes. I don't remember the details
> unfortunately.
> 
> Mike, can you explain how this should be done?

The default clock settings are still in discussion. My perspective is
that the default settings are best used by the consuming device. E.g. an
MMC controller that consumes a clock signal should specify in DT the
clock that it consumes (already does this) and the preferred rate that
it wants that clock, as well as the preferred parent if that clock is a
mux.

Of course clock providers themselves are devices and could specify such
defaults for the clocks that they create. This approach is a minor
bastardization of the default clock settings since the clock provider
device isn't really consuming the clock, but it is helpful when no such
driver or DT node exists to do the same.

It is worth pointing out that the above approach amounts to the exact
same hard coding of clk_enable requirements as is done in Maxime's
patch, but with the added problem that the default are hidden away in DT
somewhere which is a debugging nightmare for someone trying to figure
out why a clock is set at a certain rate.

Finally, to answer the question more directly, I completely oppose
having something analogous to a regulator-always-on for a clock that can
gate. Please always use the clk.h API for this in Linux kernel driver C
code:

clk_get()
clk_prepare()
clk_enable()

In Maxime's case he is doing the right thing (using the clk.h API) but
he has no memory driver to do it, so he is putting that stuff in the clk
provider driver. I'm fine with that solution, until the day that he does
have a memory driver and then it needs to migrate out to that code.

Regards,
Mike

> 
>         Arnd
