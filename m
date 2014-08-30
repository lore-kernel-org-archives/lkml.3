Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaH3L0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 07:26:07 -0400
Received: from gloria.sntech.de ([95.129.55.99]:57717 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaH3L0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 07:26:03 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Addy Ke <addy.ke@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, agross@codeaurora.org,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sandeep_n@ti.com, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <treding@nvidia.com>, Nishanth Menon <nm@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 0/2] IO voltage domain support for rk3188 and rk3288
Date: Sat, 30 Aug 2014 13:27:43 +0200
Message-ID: <1450179.xJuMFg9Vvn@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <CAD=FV=Vcj+tAno92c38Prviyi-v2CmuGSzak1ppETL033KAF4w@mail.gmail.com>
References: <1409254565-10677-1-git-send-email-dianders@chromium.org> <53FF9E93.3040601@ti.com> <CAD=FV=Vcj+tAno92c38Prviyi-v2CmuGSzak1ppETL033KAF4w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 29. August 2014, 21:51:46 schrieb Doug Anderson:
> Santosh,
> 
> On Thu, Aug 28, 2014 at 2:26 PM, Santosh Shilimkar
> 
> <santosh.shilimkar@ti.com> wrote:
> > On Thursday 28 August 2014 03:36 PM, Doug Anderson wrote:
> >> These two patches add support for automatically configuring the IO
> >> voltage domains on rk3188 and rk3288 SoCs.  The first patch adds some
> >> new notification types to the regulator code.  It's used by the second
> >> patch which actually implements the IO voltage domain driver.
> >> 
> >> These two patches were co-developed by Heiko Stübner and Doug Anderson
> >> (proof of concept patches were written by Heiko).  They were tested in
> >> a private branch on an rk3288 board using rk808 instead of mainline
> >> since rk808 support isn't finalized in mainline yet.
> >> 
> >> (sorry if you got this series twice; my mailer seems unhappy with me)
> >> 
> >> Heiko Stübner (2):
> >>   regulator: core: Add REGULATOR_EVENT_PRE_VOLTAGE_CHANGE (and ABORT)
> >>   soc/rockchip: io-domain: add driver handling io domains
> > 
> > Sorry to shot down but your IO domains are nothing but voltage domains
> > and you should really build something in the drivers/power/*
> 
> If everyone agrees that this belongs in drivers/power that's totally
> OK.  Neither Heiko nor I was confident that it should be in
> drivers/soc.  I had even though that the code wouldn't be totally out
> of place in the Rockchip pinctrl driver (adding Linus W since I think
> some SoCs did add code to handle 3.3V vs. 1.8V in pinctrl).

a bit of context for Linus ...

This is essentially the continuation of  the thread "io-domain voltages as 
regulators?" from the beginning of august. After more discussions we found out 
that the io voltage selection I asked about is not an independent supply, but 
instead has to reflect the voltage of the real supplying regulator.

And setting the io-voltage setting to 1.8V while the regulator is supplying 
3.3V for example may actually damage the chip.


So in our current approach here, we added a driver that tracks voltage changes  
of the supplying regulator via a notifier and sets the register bits 
accordingly.


> 
> > Please have a look at the RFC [1]. You should really go on those
> > lines and collaborate to make a generic voltage domain layer instead of
> > throwing the driver under drivers/soc.
> 
> Trying to base things on a 7-month old RFC that hasn't been touched is
> not something I'm going to do.  Maybe that makes me a bad person...
> 
> I would also say that I'm not convinced that we really need a
> complicated framework here.  Maybe when we're talking about things
> like ABB and DevFreq and the like then having a nice framework is a
> good idea.  Really here we're just setting properties associated with
> IO pins.  There's no decisions about latency, power tradeoffs, etc.
> If the pin is connected to 1.8V we need to set the 1.8V bit.  If it's
> connected to 3.3V we need to set the 3.3V bit.  The end.
> 
> The only remotely complicated thing (and why this isn't just a pinctrl
> property) is what happens with dynamic voltages.  SD Card IO lines can
> change voltage depending on UHS negotiation.  In that case the SD Card
> Driver will request that its regulator change from 3.3V to 1.8V.  The
> bit in the IO domain register needs to update in tandem.
> 
> 
> The driver is really quite tiny (333 lines).  If we find that lots of
> people copy it and they have code that's nearly the same then we
> should try to abstract things out then.
> 
> 
> I'd be interested in hearing other opinions, though.
> 
> -Doug

