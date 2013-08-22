Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3HVIZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:25:41 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:65008 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3HVIZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:25:36 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Xiubo Li-B47053 <B47053@freescale.com>
Cc: Guo Shawn-R65073 <r65073@freescale.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for Freescale FTM PWM
Date: Thu, 22 Aug 2013 10:25:30 +0200
Message-ID: <1522215.zHEjdiga8V@flatron>
User-Agent: KMail/4.11 (Linux/3.10.6-gentoo; KDE/4.11.0; x86_64; ; )
In-Reply-To: <1DD289F6464F0949A2FCA5AA6DC23F827D2244@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com> <1473340.OXSHEp7d4P@flatron> <1DD289F6464F0949A2FCA5AA6DC23F827D2244@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 of August 2013 02:55:42 Xiubo Li-B47053 wrote:
> Hi Tomasz,
> 
> Thanks for your comments.
> 
> > > +- #pwm-cells: Should be 3. Number of cells being used to specify
> > > PWM
> > > property.
> > > +  First cell specifies the per-chip channel index of the PWM
> > > to use, the
> > > +  second cell is the period in nanoseconds and bit 0 in
> > > the third cell is
> > > +  used to encode the polarity of PWM output. Set bit
> > > 0 of the third in PWM
> > > +  specifier to 1 for inverse polarity & set to 0
> > > for normal polarity.
> > 
> > If the meaning of flags cell is the same as in generic, default PWM
> > specifier format, then it should be noted here and generic PWM binding
> > documentation mentioned.
> 
> OK, How about the following ?
> - #pwm-cells: Should be 3. See pwm.txt in this directory for a
>   description of the cells format.

I meant just the last cell, which stores flags, but actually this might be 
a good idea, but with slightly extended description. Something among those 
lines:

 - #pwm-cells: Should be 3. The default three cell format specified by 
generic PWM bindings are used. Refer to the documentation of generic PWM 
bindings for more information about the meaning of cells.

> I will replace it in v2.
> 
> > > +- fsl,pwm-clk-ps: the ftm0 pwm clock's prescaler,
> > > divide-by 2^n(n = 0 ~ 7).
> > 
> > Is it a hardware-specific property?
> 
> Yes, I will revise it in v2.

I'd like to hear a bit more elaborate description of this property. What 
are the factors that decide what value should be used here?

> > > +- fsl,pwm-cpwm: Center-Aligned PWM (CPWM)
> > > mode.
> > 
> > Could you explain meaning of this property?
> 
> Well, this feature will be removed from the pwm core in v2.

OK.

> > > +- fsl,pwm-number: the number of PWM devices, and is must equal to
> > > the
> > > number +  of "fsl,pwm-channels".
> > 
> > This is redundant, because you can simply count how many entries have
> > been specified in fsl,pwm-channels.
> 
> Yes, I will revise it in v2.
> And this would be renamed to " fsl,pwm-channel-number", which can be
> more Readable and understood.

I meant that you don't need to specify how many entries other property has 
in another property, because device tree provides information about sizes 
of all properties. So, in parsing code, you would be able to simply get 
the size of "fsl,pwm-channels" property in bytes, divide that by 
sizeof(u32) and get the numer of cells specified.

Also see below.

> > > +- fsl,pwm-channels: the channels' order which is be used for pwm in
> > > ftm0 +  module, and they must be one or some of 0 ~ 7, because the
> > > ftm0 only has +  8 channels can be used.
> > 
> > Could you explain meaning of this property more precisely? I'm
> > interested especially how is this related to the PWM IP block and
> > boards.
> Yes.
> There are 8 channels most. While the pinctrls of 4th and 5th channels
> could be used by uart's Rx and Tx, then these 2 channels won't be used
> for pwm output, so there will be 6 channels available by the pwm.
> Thus, the pwm chip will register only 6 pwms(6 channels)
> most("fsl,pwm-channel-orders = {0 1 2 3 6 7}").And also the
> "fsl,pwm-channel-number" will be 6.
> 
> If hasn't any other problems, I will revise It in v2.
> And this will be renamed to "fsl,pwm-channel-orders", which can be more
> readable and understood.

As Sascha Hauer already suggested, you could get rid of both this and 
"fsl,pwm-channel-number" properties and simply register all the channels. 
This way you will have a deterministic 1:1 mapping of real hardware 
channels to channels specified in device tree, which is definitely the way 
to go.

Now as a safety measure, you could simply move the specification of 
pinctrl states from SoC family or SoC level dtsi file to board level dts, 
where only pinctrl states of channels used by a particular board would be 
specified, so nothing could break operation of other devices that share 
pin muxes with remaining channels.

> > > +- for very channel, the revlatived the pinctrl should be at least
> > > two
> > > 
> >                            ^ typo?
> > > 
> > > state +  {"enN", "dsN"}, which "en" means "enable", "ds" means
> > > "disable" and "N" +  means the order of the channel.
> > 
> > I'd suggest a more readable naming convention, for example chN-active
> > and chN-idle. These words seem to be more common across existing
> > bindings.
> That's a good idea, I will think it over and revise it in v2.

OK. Looking forward to v2 then. Thanks.

Best regards,
Tomasz

