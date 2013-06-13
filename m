Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab3FMNk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:40:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40784 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001Ab3FMNkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:40:21 -0400
Date: Thu, 13 Jun 2013 08:39:50 -0500
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Paul Walmsley <paul@pwsan.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [RFC PATCH 1/4] regulator: Introduce OMAP regulator to control
 PMIC over VC/VP
Message-ID: <20130613133950.GA32174@kahuna>
References: <1369246717-4167-1-git-send-email-nm@ti.com>
 <1369246717-4167-2-git-send-email-nm@ti.com>
 <20130610103131.GR31367@sirena.org.uk>
 <CAGo_u6qTiPpd0DDe3jnPh_UxTwox22azhcMGy=fftL8H+DGeyw@mail.gmail.com>
 <20130610164905.GJ1403@sirena.org.uk>
 <CAGo_u6ov=yaCwt8apbvW57ErAvhgUBHHw9gwADBC1fJUrfucUQ@mail.gmail.com>
 <20130610180150.GQ1403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130610180150.GQ1403@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:01-20130610, Mark Brown wrote:
> On Mon, Jun 10, 2013 at 12:51:42PM -0500, Nishanth Menon wrote:
> 
> > a) Tegra seems to use Lookup Table for sending predefinied voltage
> > values to PMIC. OMAP has no concept of lookup table.
> 
> They seem to be doing basically the same thing here, you've got a linear
> map of selector to voltage too AFAICT.
> 
> > b) Tegra and OMAP h/w blocks seem to use I2C - that is good.
> > c) How about the i2c slave and register addresses, slew rates, start,
> > end voltages, max voltages that SoC can support etc, I am yet to
> > understand those.
> > d) OMAP has 3 modules - AVS (SmartReflex), Voltage Processor(VP),
> > Voltage Controller(VC) - I am not yet sure about the Tegra hardware
> > blocks involved.
> 
> This all seems like it's at the implementation detail level - the bit
> that seems like we should be able to share it is the big picture bit for
> how we describe how the AP side stuff and PMIC are hooked up without
> having to have a bunch of completely non-framework stuff for things
> like describing the PMIC.

I am having a bit of a difficulty trying to understand your concern
here.

Problem statement:
OMAP has this weird custom h/w where one programs the voltage and that
voltage is send over i2c - this is not same as Tegra's lookup table
array which automatically sends out entries, in OMAP, software has to trigger
the voltage transition
This path is split into 3 different modules - AVS, VC, VP -> This is
implementation detail as you already mentioned.

Anyhow, to recap, the overview of the hardware interface is as follows:
PMIC that OMAP interfaces to are of two categories:
a) ones that talk only on the custom OMAP VC path
b) ones that talk both custom OMAP VC and regular i2c (e.g.
   twl4030,6030,palmas)

The voltage control for a voltage rail (e.g. vdd_mpu) is again PMIC
specific
a) 6030 will not allow voltage to be set over regular i2c
b) 4030 allows either custom i2c path OR regular i2c path (only 1 at a
   time).
c) palmas allows both custom i2c path AND regular i2c path to set
   voltage!

>From a Linux angle, when using regular i2c, it is a piece of cake. Standard
regulator uses regular i2c, vc-vp angle avoided
Example: Palmas: we'd use the regular palmas driver to do this.

When using custom i2c path(vc/vp/avs), it gets a bit complex
We'd like (if possible) drivers like cpufreq to be ignorant of regulator
and transfer path used ofcourse as this depends on the board component
selection.
E.g. 4030/palmas/6030 vdd_mpu can be represented as a regulator, which in turn
uses custom OMAP data transfer path to set voltage

I was trying to understand your statement as to what Paul was doing
(which was basically pull out the vsel values and put them in his
 hardware lookup table for h/w to auto send the voltage) Vs what I was
attempting to do (describe OMAP's view of the PMIC and provide data
path).
In my view, we were trying to do "voltage scale" in two completely
different ways depending on the SoC we were working on.

If your concern was describing PMIC parameters in dts, I can easily move
them inside the omap_pmic driver and provide required compatible flags.
If, on the other hand, the entire approach followed is flawed, I'd like to
understand the rationale for the same.

-- 
Regards,
Nishanth Menon
