Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaEOIei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:34:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53019 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751797AbaEOIec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:34:32 -0400
Date: Thu, 15 May 2014 10:34:28 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] clk: berlin: add clock binding docs for Marvell
 Berlin2 SoCs
Message-ID: <20140515083428.GR29318@piout.net>
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1399839881-29895-3-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140514223230.19795.63328@quantum>
 <5373F9A0.6000702@gmail.com>
 <20140515044106.19795.57249@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515044106.19795.57249@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/2014 at 21:41:06 -0700, Mike Turquette wrote :
> > > The following is a copy/paste from an email I sent earlier today[1]. Of
> > > course per-clock data makes great sense if you have an off-SoC clock
> > > such as a fixed-rate oscillator (e.g. the fixed-clock binding). Let me
> > > know what you think:
> > [...]
> > > Using this type of binding you only need to declare your clock generator
> > > IP node in dts, and then define a mapping in the DT include chroot. Then
> > > you can define your per-clock data inside of your clock driver instead
> > > of putting all of the details inside of DT.
> > > 
> > > If you have a strong reason to do it the way that you originally posted
> > > then let me know.
> > 
> > Actually, the intermediate patch set sent before this one had a single
> > DT clock node. The most important draw-back of a single clock node
> > is that Berlin's global registers are more like a register dumpster.
> > Vital other registers, e.g. reset, are intermixed with clock registers.
> 
> Yeah, this is pretty common. The compatible string should reflect the IP
> block as a whole, not just the clocks part of it. Lots of vendors have
> PRCMs or PRCMUs or CARs or whatever.
> 
> Check out the recent series to have the reset bits and regulator support
> added to the qcom binding[1]. (I'm using qcom quite a bit in my examples
> but they are not the first to add reset control to their clock driver. I
> think Tegra did it first...)
> 
> > 
> > Given the lack of public datasheets (I look everything up in some
> > auto-generated BSP includes), I like the current approach because it
> > helps to get in at least some structure to the register mess ;)
> > 
> > Considering the postponed of_clk_create_name() helper, that would allow
> > us to remove at least the names from DT again. Another option would be
> > a syscon node for the registers, that clk, reset, pinctrl drivers can
> > access. But IIRC early syscon support isn't settled, yet?
> 
> Yeah, I'm not sure of the state of syscon. And modeling this stuff in
> the clock driver isn't the end of the world. There might be better
> places than drivers/clk/* for sure... I sometimes joke that the name of
> the IP block determines where the code lands. If it is Power, Reset &
> Clock Manager (several platforms use this acronym) then it can end up in
> drivers/clk or drivers/reset really easily. Same for Clock and Reset IP
> blocks (Tegra).
> 

So, this is called "global". On BG2/BG2CD, you have pinmuxing, a
register enabling nand power and switching the pll bypasses, all the pll
configuration, complex clocks, reset, product ID, nand write protect,
simple clocks, more resets, more clocks for which we don't have a driver
yet and finally pad control.

Now, on BG2Q, it is almost the same but between the cpupll registers and
the global registers, there is the whole APB bus, so timers, gpio
controllers, ...

I would believe that is the strong reason you are asking for.

It would also break the DT ABI (not that I care) almost each time we add
a new clock that we didn't know about.

Let me suggest something completely wild (to rephrase Thomas Petazzoni
and Kevin Hilman at ELC):

How about we have only a "marvell,berlin2", "marvell,berlin2cd" or
"marvell,berlin2q" compatible string and handle that in either
arch/arm/mach-berlin or driver/soc/mach-berlin and then use a bunch of
structures to add all the peripherals like clocks, reset, timer, gpio
controllers, pinmux, padconf...
Maybe we could call those structures "platform_data" :)


> > 
> > So, my current idea is:
> > - take this as is, stabilize berlin branches for v3.16
> > - review of_clk_create_name() and of_clk_get_parent_name() to allow
> >   to remove clock-output-names properties from Berlin (and other) dtsis
> > - maybe switch to early syscon if it is available in v3.16
> > 
> > I know this would likely break DT ABI policy, but hey who else boots
> > mainline Linux on his Chromecast currently except me :P
> 
> I'm not a big fan of DT stable ABI, but if you plan on changing it for
> 3.17 why not just do it the right way the first time? And switching to
> syscon is not a hard requirement. I'm OK with you putting the reset and
> regulator stuff in the clock driver if that makes the most sense for
> your platform (especially if registers are shared and the same locks
> need to be used, etc).
> 


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
