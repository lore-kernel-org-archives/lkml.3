Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab3GKHae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 03:30:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:19938 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594Ab3GKHac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 03:30:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1042,1363158000"; 
   d="scan'208";a="329732415"
Date: Thu, 11 Jul 2013 10:36:00 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
Message-ID: <20130711073600.GG4898@intel.com>
References: <1373283927-21677-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130708134216.GB6402@ab42.lan>
 <20130709084402.GF4898@intel.com>
 <20130709161927.GC30236@ab42.lan>
 <20130710105215.GY4898@intel.com>
 <20130710165634.GA30693@ab42.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710165634.GA30693@ab42.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 06:56:35PM +0200, Christian Ruppert wrote:
> On Wed, Jul 10, 2013 at 01:52:15PM +0300, Mika Westerberg wrote:
> > On Tue, Jul 09, 2013 at 06:19:28PM +0200, Christian Ruppert wrote:
> > > What I meant is the following: The clock cycle time Tc is composed of
> > > the four components
> > > 
> > >   Tc = Th + Tf + Tl + Tr
> > > 
> > > where
> > >   Th: Time during which the signal is high
> > >   Tf: Falling edge transition time
> > >   Tl: Time during which the signal is low
> > >   Tr: Rising edge transition time
> > > 
> > > The I2C specification specifies a minimum for Tl and Th and a range (or
> > > maximum) for Tr and Tf. A maximum frequency is specified as the
> > > frequency obtained by adding the minima for Th and Tl to the maxima of
> > > Tr ant Tf.
> > > Since as you said, transition times are very much PCB dependent, one way
> > > to guarantee the max. frequency constraint (and to achieve a constant
> > > frequency at its max) is to define the constants
> > > Th' = Th + Tf := Th_min + Tf_max
> > > Tl' = Tl + Tr := Tl_min + Tr_max
> > > 
> > > and to calculate the variables
> > > Th = Th' - Tf
> > > Tl = Tl' - Tr
> > > in function of Tf and Tr of the given PCB.
> > 
> > If I understand the above, it leaves Tf and Tr to be PCB specific and then
> > these values are passed to the core driver from platform data, right?
> 
> That would be the idea: Calculate Th' and Tl' in function of the desired
> clock frequency and duty cycle and then adapt these values using
> measured transition times. What prevented me from implementing this
> rather academic approach are the following comments in
> i2c-designware-core.c:
> 
> /*
>  * DesignWare I2C core doesn't seem to have solid strategy to meet
>  * the tHD;STA timing spec.  Configuring _HCNT based on tHIGH spec
>  * will result in violation of the tHD;STA spec.
>  */
> 
> /* ...
>  * This is just experimental rule; the tHD;STA period
>  * turned out to be proportinal to (_HCNT + 3).  With this setting,
>  * we could meet both tHIGH and tHD;STA timing specs.
>  * ...
>  */
> 
> If I interpret this right, the slow down of the clock is intentional to
> meet tHD;STA timing constraints.

Yeah, looks like so. tHD;STA is the SDA hold time. I wonder if the above
comments apply to some earlier version of the IP that didn't have the SDA
hold register?

> > I'm thinking that passing directly the "measured" *CNT values from the
> > platform data makes this even more accurate (given that information is
> > available). And if you only have the Tf and Tr for your board, you can have
> > custom calculation done in the platform part of the driver that takes them
> > into account, and then passes these custom *CNT values to the core.
> 
> Well, as in the previous discussion on SDA hold time, Tf and Tr are
> physical values whereas the register values are clock dependent and
> probably not appropriate at least for device tree usage (or cases where
> the clock speed might change). If I understand you correctly, ACPI is
> more register oriented and able to cope with this outside of the OS?

Well, ACPI doesn't care what its methods return (unless the methods are
specfied in the ACPI spec). In this case it just returns a package of three
values: HCNT, LCNT and SDA hold time.

I guess it is supposed to work like this:

 * If there is no vendor specific SSCN/FMCN methods for the device we can
   just use the default and calculate *CNT from the clock speed.
 * If there exists a method, we use the values there instead.

I think the Windows driver does something like above. IMHO we should to the
same in Linux driver to be able to take advantage of the measured *CNT
values.

> > > > At least on Intel
> > > > hardware we have an ACPI method that returns directly the optimum *CNT
> > > > values.
> > > 
> > > I don't know ACPI very well and if it deals with register values
> > > directly your patch is probably the right thing.
> > 
> > Our FW people decided to have a custom ACPI method that returns the correct
> > values to be used in the Windows I2C driver. It returns direct *CNT
> > register values that have been measured to be good for a given PCB.
> > 
> > > The timing calculation in the driver seems a bit strange to me, however
> > > (see above), but I never dared touching it because I never had time to
> > > dive into the code deep enough and I was just wondering if it was
> > > possible to fix it at the same time.
> > 
> > It would be good if we can fix this for non-ACPI devices as well. Is it
> > hard to add similar properties to the driver specific Device Tree bindings?
> 
> I think it would be quite trivial to add properties for either the
> register values or the transition time values. For SDA hold time we
> concluded that time values would be more adequate which brings us to the
> question of better understanding the hack for tHD;SDA. Otherwise we
> might break something. Do you think your team which determines the
> tHD;SDA values could give us some guidance on that?

I2C spec says following about the tHD;STA:

 Standard mode	: min 4.0 us
 Fast mode	: min 0.6 us

But I can try to ask from our HW guys for an answer.
