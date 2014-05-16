Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbaEPT6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:58:17 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:59091 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbaEPT6P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:58:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Warren <swarren@wwwdotorg.org>,
        "Peter De Schrijver" <pdeschrijver@nvidia.com>,
        "Thierry Reding" <thierry.reding@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <53752185.3090608@wwwdotorg.org>
Cc: "Prashant Gaikwad" <pgaikwad@nvidia.com>,
        "Rob Herring" <robh+dt@kernel.org>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, "Arnd Bergmann" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com>
 <1399990023-30318-4-git-send-email-pdeschrijver@nvidia.com>
 <53725FED.7050303@wwwdotorg.org> <20140514142739.GA8612@ulmo>
 <20140515105200.GI15168@tbergstrom-lnx.Nvidia.com>
 <53752185.3090608@wwwdotorg.org>
Message-ID: <20140516195806.9521.37193@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RFC PATCH 3/3] clk: tegra: Implement Tegra124 shared/cbus clks
Date: Fri, 16 May 2014 12:58:06 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Warren (2014-05-15 13:20:21)
> On 05/15/2014 04:52 AM, Peter De Schrijver wrote:
> > On Wed, May 14, 2014 at 04:27:40PM +0200, Thierry Reding wrote:
> >> * PGP Signed by an unknown key
> >>
> >> On Tue, May 13, 2014 at 12:09:49PM -0600, Stephen Warren wrote:
> >>> On 05/13/2014 08:06 AM, Peter De Schrijver wrote:
> >>>> Add shared and cbus clocks to the Tegra124 clock implementation.
> >>>
> >>>> diff --git a/include/dt-bindings/clock/tegra124-car.h b/include/dt-bindings/clock/tegra124-car.h
> >>>
> >>>> +#define TEGRA124_CLK_C2BUS 401
> >>>> +#define TEGRA124_CLK_C3BUS 402
> >>>> +#define TEGRA124_CLK_GR3D_CBUS 403
> >>>> +#define TEGRA124_CLK_GR2D_CBUS 404
> >>> ...
> >>>
> >>> I worry about this a bit. IIUC, these clocks don't actually exist in HW,
> >>> but are more a way of SW applying policy to the clock that do exist in
> >>> HW. As such, I'm not convinced it's a good idea to expose these clock
> >>> IDS to DT, since DT is supposed to represent the HW, and not be
> >>> influenced by internal SW implementation details.
> >>>
> >>> Do any DTs actually need to used these new clock IDs? I don't think we
> >>> could actually use these value in e.g. tegra124.dtsi's clocks
> >>> properties, since these clocks don't exist in HW. Was it your intent to
> >>> do that? If not, can't we just define these SW-internal clock IDs in the
> >>> header inside the Tegra clock driver, so the values are invisible to DT?
> >>
> >> I'm beginning to wonder if abusing clocks in this way is really the best
> >> solution. From what I understand there are two problems here that are
> >> mostly orthogonal though they're implemented using similar techniques.
> >>
> >> The reason for introducing cbus clocks are still unclear to me. From the
> >> cover letter of this patch series it seems like these should be
> >> completely hidden from drivers and as such they don't belong in device
> >> tree. Also if they are an implementation detail, why are they even
> >> implemented as clocks? Perhaps an example use-case would help illustrate
> >> the need for this.
> > 
> > We don't have a PLL per engine, hence we have to use a PLL as parent for
> > several module clocks. However you can't change a PLLs rate with
> > active clients. So for scaling the PLL clocking eg. VIC or MSENC, you need to
> > change their parent to a different PLL, change the original PLL rate and change
> > the parent back to the original PLL, all while ensuring you never exceed the
> > maximum allowed clock at the current voltage. You also want to take into
> > account if a module is clocked so you don't bother handling clocks which are
> > disabled. (eg. if only the VIC clock is enabled, there is no point in changing
> > the MSENC parent). All this is handled by the 'cbus' clock.
> 
> Presumably though we can handle this "cbus" concept entirely inside the
> clock driver.
> 
> What happens right now is that when a DT node references a clock, the
> driver gets a clock and then manipulates it directly. What if the clock
> core was reworked a bit such that every single clock was a "cbus" clock.
> clk_get() wouldn't return the raw clock object itself, but rather a
> "clock client" object, which would forward requests on to the underlying
> clk. If there's only 1 clk_get(), there's only 1 client, so all requests
> get forwarded automatically. If there are n clk_get_requests(), the
> clock object gets to implement the appropriate voting/... algorithm to
> mediate the requests.

This was proposed before[1][2] and is something that would be great to
have. The scary thing is to start introducing policy into the clock
framework, which I'd like to avoid as much as possible. But arbitration
of resources (with requisite reference counting) is pretty much
non-existent for clock rates (last call to clk_set_rate always wins),
and is very rudimentary for prepare/enable (we have use counting, but it
does not track individual clients/clock consumers).

Revisiting Rabin's patches has been at the bottom of my todo list for a
while now. I'm happy for someone else to take a crack at it.

Regards,
Mike

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/135290.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/135574.html

> 
> That way, we don't have to expose any of this logic in the device tree,
> or hopefully/mostly even outside the HW clock's implementation.
