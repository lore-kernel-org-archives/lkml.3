Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab3IJN7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:59:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47312 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3IJN7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:59:41 -0400
Date: Tue, 10 Sep 2013 08:59:07 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Kumar Gala <galak@codeaurora.org>, wsa@the-dreams.de,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        grant.likely@linaro.org, gavidov@codeaurora.org,
        sdharia@codeaurora.org, alokc@codeaurora.org,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: qup: Add device tree bindings information
Message-ID: <20130910135907.GP808@joshc.qualcomm.com>
References: <1377782873-31931-1-git-send-email-iivanov@mm-sol.com>
 <3A0F4153-1C55-4008-8EB1-D6FA60D87CEA@codeaurora.org>
 <1377797186.30358.14.camel@localhost>
 <767E9FBB-2975-4795-9C7E-69E302511FF2@codeaurora.org>
 <1378814937.960.37.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378814937.960.37.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Hmm.  Fixing b0rked LKML address; that might explain why I am not
seeing Kumar's replies.]

On Tue, Sep 10, 2013 at 03:08:57PM +0300, Ivan T. Ivanov wrote:
> Hi Kumar,
> 
> On Fri, 2013-08-30 at 10:21 -0500, Kumar Gala wrote: 
> > On Aug 29, 2013, at 12:26 PM, Ivan T. Ivanov wrote:
> > >>> +
> > >>> +Optional properties :
> > >>> + - Child nodes conforming to i2c bus binding
> > >>> + - clock-frequency : Desired I2C bus clock frequency in Hz. If
> > >>> +		not set thedefault frequency is 100kHz
> > >>> + - qcom,src-freq : Frequency of the source clocking this bus in Hz.
> > >>> +		Divider value is set based on soruce-frequency and
> > >>> +		desired I2C bus frequency. If this value is not
> > >>> +		provided, the source clock is assumed to be running
> > >>> +		at 19.2 MHz.
> > >> 
> > >> I'd spell out frequency instead of 'freq' to be consistent with 'clock-frequency'
> > > 
> > > ok.
> > > 
> > >> 
> > >> Is the frequency of the 'iface' clock?  Can we not use clk_get_rate?
> > > 
> > > It is for 'core' clock. I think that for higher I2C bus frequencies,
> > > 'core' clock have to be higher, but I am not sure what is relation.
> > 
> > Ok, can we use clk_get_rate on the 'core' clk to get its frequency instead of needing a DT prop for it?
> 
> Probably I didn't explain it well. The 'core' clock have to be
> accelerated before higher bus frequencies could be achieved.

I think what Kumar is suggesting is that the QUP driver not do an
explicit clk_set_rate() at all (which AFAICT is what's currently being
done to set the consuming clock to the rate specified in
'qcom,src-freq'), but instead assume that the consuming clock has
already been setup properly.  Then the driver just uses clk_get_rate()
and clock-frequency to calculate how to setup any internal dividers.

> > >>> +Aliases: An alias may optionally be used to bind the I2C controller
> > >>> +to bus number. Aliases are of the form i2c<n> where <n> is an integer
> > >>> +representing the bus number to use.
> > >>> +
> > >>> +Example:
> > >>> +
> > >>> + aliases {
> > >>> +		i2c0 = &i2c_A;
> > >>> +		i2c1 = &i2c_B;
> > >>> +		i2c2 = &i2c_C;
> > >>> + };
> > >> 
> > >> What is the purpose here?
> > > 
> > > Define on which I2C bus this controller operate. I2C client 
> > > drivers usually do i2c_get_adapter(bus_number) before its
> > > registration. This is for drivers before invention of
> > > of_i2c_register_devices(), I believe.
> > 
> > Since this is for upstream why dont we use of_i2c_register_devices() and remove this stuff related to aliases.
> 
> Adapter driver already is using of_i2c_register_devices(). Also OF
> helper function will/or is already part of i2c_register_adapter().
> Attempt here was to make it compatible with older i2c client drivers.

I agree with Kumar on removing this.  If we decide it is something worth
keeping, logic to support it doesn't belong in the QUP driver, but in
the i2c core.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
