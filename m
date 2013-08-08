Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103Ab3HHIxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:53:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59378 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933987Ab3HHIxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:53:50 -0400
Date: Thu, 8 Aug 2013 09:53:46 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Pawel Moll <Pawel.Moll@arm.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Durgadoss R <durgadoss.r@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>, Wei Ni <wni@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: device thermal limits represented in device tree nodes
Message-ID: <20130808085346.GC14648@e106331-lin.cambridge.arm.com>
References: <51ED40E3.5020703@ti.com>
 <51EF3186.9060001@wwwdotorg.org>
 <1374664745.25700.118.camel@hornet>
 <51EFED19.5090900@ti.com>
 <1374768928.3213.31.camel@hornet>
 <51F15E42.1060409@ti.com>
 <1374773611.3213.44.camel@hornet>
 <51F2D443.6040909@ti.com>
 <1375787649.12043.34.camel@hornet>
 <5202AB95.9020605@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5202AB95.9020605@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 09:18:29PM +0100, Eduardo Valentin wrote:
> Pawel, all,
> 
> On 06-08-2013 07:14, Pawel Moll wrote:
> > Apologies about the delay, I was "otherwise engaged" for a week...
> > 
> 
> I do also excuse for my delay, as I was also "engaged" for a week or so.
> 
> > I hope you haven't lost all motivation to work on this subject, as it's
> > really worth the while!
> 
> Not really! quite the opposite. Although I was looking at some other
> stuff, I got this series also tested on different boards and wrote down
> a couple of improvements I will be working in the coming days. Indeed,
> it is worth moving forward with this work.
> 
> > 
> > On Fri, 2013-07-26 at 20:55 +0100, Eduardo Valentin wrote:
> >> On 25-07-2013 13:33, Pawel Moll wrote:
> >>> On Thu, 2013-07-25 at 18:20 +0100, Eduardo Valentin wrote:
> >>>>>> 	thermal_zone {
> >>>>>> 		type = "CPU";
> >>>>>
> >>>>> So what does this exactly mean? What is so special about CPU? What other
> >>>>> types you've got there? (Am I just lazy not looking at the numerous
> >>>>> links you provided? ;-)
> >>>>
> >>>> Hehehe. OK. Type is supposed to describe what your zone is representing.
> >>>
> >>> As in "a name"? So, for example "The board", "PSU"? What I meant to ask
> >>> was: does the string carry any meaning?
> > 
> > You haven't commended on this...
> 
> The string is supposed to carry meaning, yes. Couple of common used:
> CPU, GPU, PCB, LCD

I think the point Pawel was getting at is that the string doesn't have a
*well-defined* meaning that always allows an OS to figure out the set of
relevant devices. If we have a thermal zone for "LCD", and have multiple
LCDs, which LCDs are covered? If we have a "PCB" zone, does this cover all
the devices attached to the PCB, a subset thereof, or the substrate of
the PCB itself?

A phandle list to the concerned devices for example would *always* allow
the OS to figure out the set of concerned devices.

> 
> > 
> >>>>>> 		trips {
> >>>>>> 			alert@100000{
> >>>>>> 				temperature = <100000>; /* milliCelsius
> >>>>>> 				hysteresis = <2000>; /* milliCelsius */
> >>>>>> 				type = <THERMAL_TRIP_PASSIVE>;
> >>>>>> 			};
> >>>>>> 			crit@125000{
> >>>>>> 				temperature = <125000>; /* milliCelsius
> >>>>>> 				hysteresis = <2000>; /* milliCelsius */
> >>>>>> 				type = <THERMAL_TRIP_CRITICAL>;
> >>>>>> 			};
> >>>>>> 		};
> >>>>>> 		bind_params {
> >>>>>> 			action@0{
> >>>>>> 				cooling_device = "thermal-cpufreq";
> >>>>>
> >>>>> Why is it a string? It seems very Linux-y... (cpufreq) Is there any
> >>>>> particular reason not to have phandles to the fans that have any impact
> >>>>> on the zone? 
> >>>>
> >>>> Because fans are not the only way to cool your system, specially those
> >>>> systems that don't feature fans. Managing the speed of your CPU is one
> >>>> example of lowering temperature without fans. Managing the load on your
> >>>> system is another way. These are obviously, virtual concepts. And
> >>>> because we have physical ways and logical ways to cool the zone, then I
> >>>> didnt put a phandle to a device there.
> >>>
> >>> "virtual concepts"... This is where my problem lies... It's not hardware
> >>> so it doesn't seem to belong in the tree at the first sight. Shouldn't
> >>
> >> Yeah, in fact, this is exactly the point that creates most of the
> >> disagreement. You may check Guenter's arguments against this proposal
> >> (in my original RFC email, there is a link to it).
> >>
> >> Well, if one don't want to see this as a 'virtual concept' it could say
> >> the cooling device is the cpu itself:
> >> 		cooling_device = <&cpu0>;
> > 
> > Would this create any particular problem at the driver/framework side?
> 
> In this case, I believe CPUfreq driver must be thermal aware in this
> case. And we need to cook a way to, whenever there is such link, the
> cpufreq driver instantiates the cooling mechanism. But I need to think a
> little bit more on this, will come back on this point soon.

For the CPU case at least, if we have a thermal zone with an attached
sensor and no real thermal device, I don't think it's too much of a
stretch for the OS to figure out that the only thing it can do is some
cpufreq-like scaling and limiting to attempt to keep below the limits.

I don't think we need to describe the cpu as a cooling device for a cpu,
and I certainly don't think we need to describe a particular mechanism
by which the thermal limits should be maintained (though when we have a
fan, or other active cooling device, describing to the OS that this may
be used is sensible).

> 
> > 
> >>> it focus on "physical data" instead? As in: point at devices that have
> >>> some impact on the conditions? For example, you can say "please, do the
> >>> right thing to cool your environment down" to both CPU and fan, can't
> >>> you? The "cooling driver" for the CPU would know that it has to slow
> >>> down, while a driver for the fan would know that it has to speed up ;-)
> >>>
> >>> What I'm trying to say is that in my opinion the tree should simply link
> >>> the object, the sensor and the actuator. Nothing more, nothing less.
> >>
> >> OK. I think it would be a little unfair to have only links, without
> >> describing what this link is supposed to be or how it is supposed to be
> >> used. In previous discussions, I have mentioned two similar examples
> >> already existing in DT. Here are they: regulator bindings, one does not
> >> describe only which device connects to which regulator, but also needs
> >> to describe, voltage limits, current limits, offsets, and other
> >> properties. And an existing 'virtual concept' would be predefined CPU
> >> OPPs, that feed the opp layer. Those are configurations of the hardware
> >> that define a 'virtual' concept of operating point.
> >>
> >> So, saying we need to describe only physical connections or touchable
> >> things would be a little unfair, IMO. Besides, thermal is still physical
> >> :-).
> > 
> > Believe me, I'm trying to be as fair as possible :-) and I see a lot of
> > value in describing the thermal properties of the platforms in the tree.
> > It's just that we really want to focus on describing the hardware, not
> > policies. And as you have already spent so much time on the matter, you
> > are in the best position to find the best set of *physical* properties
> > that would allow to make the right decision in the code. Could you,
> > please, try to make one step back and have another look at the problem?
> > What input data (as in: numbers :-) would you need to get what you want?
> > Are those numbers characteristic to the specific device (they probably
> > should live in the driver than) or to the board/platform (tree without a
> > doubt).
> 
> Ok. My point was just that linking objects without telling when (in
> temperature domain) to start using this link, may be incomplete, because
> trip points are really HW dependent, because your power dissipation
> profile changes from HW design to HW design. In other words, one can
> say, "use device fan to cool the GPU", but depending on your GPU, you
> may start using your fan when the sensor is 100C, 85C, 110C (just
> picking numbers), it is really HW dependent. Besides, the same IP may be
> used immersed in different ambient condition, which may cause variance
> on its leakage level, and thus changes its thermal dissipation profile,
> resulting in different trip points. Thus, mapping all this HW
> characteristics inside specific drivers does not sound the right path to
> me. That is why I believe pointing which trips to use is part of HW
> description.

This sounds like the case we have with OPPs in that the information
required to figure out the valid points at which an OS can drive the
hardware is driven by rather complex interactions between various
components, and it's not clear whether describing all that information
is worthwhile. That said, I'm not sure what my opinion on the matter is.

> 
> I must agree that, saying which governor  to use, then again, is pure
> policy definition though.

Sounds like we agree there :)

Thanks,
Mark.
