Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaG3AGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 20:06:45 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35305 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbaG3AGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 20:06:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>, ulf.hansson@linaro.org,
        Kevin Hilman <khilman@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] of/clk: use "clkops-clocks" to specify clocks handled by clock_ops domain
Date: Wed, 30 Jul 2014 02:06:59 +0200
Message-ID: <2717555.fiA6A86F65@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACxGe6uMke5vgzcNC9xUqjr2bHJ4QFHD6YjocSZWq8Ccx8Mm6A@mail.gmail.com>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be> <53D68CC4.1010704@ti.com> <CACxGe6uMke5vgzcNC9xUqjr2bHJ4QFHD6YjocSZWq8Ccx8Mm6A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii and Grant,

On Monday 28 July 2014 23:52:34 Grant Likely wrote:
> On Mon, Jul 28, 2014 at 11:47 AM, Grygorii Strashko wrote:
> > On 07/28/2014 05:05 PM, Grant Likely wrote:
> >> On Thu, 12 Jun 2014 19:53:43 +0300, Grygorii Strashko wrote:
> >>> Use "clkops-clocks" property to specify clocks handled by
> >>> clock_ops domain PM domain. Only clocks defined in "clkops-clocks"
> >>> set of clocks will be handled by Runtime PM through clock_ops
> >>> Pm domain.
> >>> 
> >>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> >>> ---
> >>> 
> >>>   drivers/of/of_clk.c |    7 ++-----
> >>>   1 file changed, 2 insertions(+), 5 deletions(-)
> >>> 
> >>> diff --git a/drivers/of/of_clk.c b/drivers/of/of_clk.c
> >>> index 35f5e9f..5f9b90e 100644
> >>> --- a/drivers/of/of_clk.c
> >>> +++ b/drivers/of/of_clk.c
> >>> @@ -86,11 +86,8 @@ int of_clk_register_runtime_pm_clocks(struct
> >>> device_node *np,>>> 
> >>>      struct clk *clk;
> >>>      int error;
> >>> 
> >>> -    for (i = 0; (clk = of_clk_get(np, i)) && !IS_ERR(clk); i++) {
> >>> -            if (!clk_may_runtime_pm(clk)) {
> >>> -                    clk_put(clk);
> >>> -                    continue;
> >>> -            }
> >>> +    for (i = 0; (clk = of_clk_get_from_set(np, "clkops", i)) &&
> >>> +                 !IS_ERR(clk); i++) {
> >> 
> >> This really looks like an ABI break to me. What happens to all the
> >> existing platforms who don't have this new clkops-clocks in their device
> >> tree?
> > 
> > Agree. This patch as is will break such platforms.
> > As possible solution for above problem - the NULL can be used as clock's
> > prefix by default and platform code can configure new value of clock's
> > prefix during initialization.
> > In addition, to make this solution full the of_clk_get_by_name() will
> > need to be modified too.
> > 
> > But note pls, this is pure RFC patches which I did to find out the answer
> > on questions: - What is better: maintain Runtime PM clocks configuration
> > in DT or in code?
>
> In code. I don't think it is workable to embed runtime PM behaviour
> into the DT bindings. I think there will be too much variance in what
> hardware requires. We can create helpers to make this simpler, but I
> don't think it is a good idea to set it up automatically without any
> control from the driver itself.
> 
> > - Where and when to call of_clk_register_runtime_pm_clocks()?
> > 
> >   Bus notifier/ platform core/ device drivers
> 
> I would say in device drivers.

I tend to agree with that.

It will help here to take a step back and remember what the problem we're 
trying to solve is.

At the root is clock management. Our system comprise many clocks, and they 
need to be handled. The Common Clock Framework nicely models the clocks, and 
offers an API for drivers to retrieve device clocks and control them. Drivers 
can thus implement clock management manually without much pain.

A clock can be managed in roughly three different ways :

- it can be enabled at probe time and disabled at remove time ;

- it can be enabled right before the device leaves its idle state and disabled 
when the device goes back to idle ; or

- it can be enabled and disabled in a more fine-grained, device-specific 
manner.

The selected clock management granularity depends on constraints specific to 
the device and on how aggressive power saving needs to be. Enabling the clocks 
at probe time and disabling them at remove time is enough for most devices, 
but leads to a high power consumption. For that reason the second clock 
management scheme is often desired.

Managing clocks manually in the driver is a valid option. However, when adding 
runtime PM to the equation, and realizing that the clocks need to be enabled 
in the runtime PM resume handler and disabled in the suspend handler, the 
clock management code starts looking very similar in most drivers. We're thus 
tempted to factorize it away from the drivers into a shared location.

It's important to note at this point that the goal here is only to simplify 
drivers. Moving clock management code out of the drivers doesn't (unless I'm 
missing something) open the door to new possibilities, it just serves as a 
simplification.

Now, as Grygorii mentioned, differences between how a given IP core is 
integrated in various SoCs can make clock management SoC-dependent. In the 
vast majority of cases (which is really what we need to target, given that our 
target is simplifying drivers) SoC integration can be described as a list of 
clocks that must be managed. That list can be common to all devices in a given 
SoC, or can be device-dependent as well.

Few locations can be used to express a per-device list of per-SoC clocks. We 
can have clocks lists in a per-SoC and per-device location, per-device clocks 
lists in an SoC-specific location, or per-SoC clocks lists in a device-
specific location.

The first option would require listing clocks to be managed by runtime PM in 
DT nodes, as proposed by this patch set. I don't think this is the best 
option, as that information is a mix of hardware description and software 
policy, with the hardware description part being already present in DT in the 
clocks property.

The second option calls for storing the lists in SoC code under arch/. As 
we're trying to minimize the amount of SoC code there (and even remove SoC 
code completely when possible) I don't think that's a good option.

The third option would require storing the clocks lists in device drivers. I 
believe this is our best option, as a trade-off between simplicity and 
versatility. Drivers that use runtime PM already need to enable it explicitly 
when probing devices. Passing a list of clock names to runtime PM at that 
point wouldn't complicate drivers much. When the clocks list isn't SoC-
dependent it could be stored as static information. Otherwise it could be 
derived from DT (or any other source of hardware description) using C code, 
offering all the versatility we need.

The only drawback of this solution I can think of right now is that the 
runtime PM core couldn't manage device clocks before probing the device. 
Specifically device clocks couldn't be managed if no driver is loaded for that 
device. I somehow recall that someone raised this as being a problem, but I 
can't remember why.

> > Also, May be platform dependent solution [1] can be acceptable for now?
> > 
> > [1] https://lkml.org/lkml/2014/7/25/630
> 
> I need to look at the series before I comment. I've flagged it and
> will hopefully look at it tomorrow.

-- 
Regards,

Laurent Pinchart

