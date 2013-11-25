Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3KYPOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:14:31 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60103 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897Ab3KYPO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:14:26 -0500
Date: Mon, 25 Nov 2013 15:14:21 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
Message-ID: <20131125151421.GF32081@e106331-lin.cambridge.arm.com>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
 <25668725.sMcoUCgCKk@flatron>
 <52861F46.8020900@ti.com>
 <1574695.YAEZXuUskK@amdc1227>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574695.YAEZXuUskK@amdc1227>
Thread-Topic: [PATCHv9 02/20] thermal: introduce device tree parser
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> > >>>> +* Trip points
> > >>>> +
> > >>>> +The trip node is a node to describe a point in the temperature domain
> > >>>> +in which the system takes an action. This node describes just the point,
> > >>>> +not the action.
> > >>>> +
> > >>>> +Required properties:
> > >>>> +- temperature:          An integer indicating the trip temperature level,
> > >>>> +  Type: signed          in millicelsius.
> > >>>> +  Size: one cell
> > >>>> +
> > >>>> +- hysteresis:           A low hysteresis value on temperature property (above).
> > >>>> +  Type: unsigned        This is a relative value, in millicelsius.
> > >>>> +  Size: one cell
> > >>>
> > >>> What about replacing temperature and hysteresis with a single temperature
> > >>> property that can be either one cell for 0 hysteresis or two cells to
> > >>> specify lower and upper range of temperatures?
> > >>
> > >> What is the problem with using two properties? I think we loose
> > >> representation by gluing two properties into one just because one cell.
> > >
> > > Ranges is the representation widely used in other bindings. In addition
> >
> > Well that sentence is arguable. It is not like all properties in DT are
> > standardized as ranges, is it?
>
> No, they are not, but property range is a common concept of representing
> range of some values.
>
> Anyway, I won't insist on this, as it's just a minor detail. However I'd
> like to see comments from more people on this.

I'm happy with having these as separate properties.

[...]

> > >>>> +
> > >>>> +- type:                 a string containing the trip type. Supported values are:
> > >>>> +        "active":       A trip point to enable active cooling
> > >>>> +        "passive":      A trip point to enable passive cooling
> > >>>
> > >>> The two above seem to be implying action, as opposed to the general
> > >>> comment about trip points.
> > >>
> > >> They do not imply action, they specify type of trip.
> > >
> > > For me "A trip point to enable active cooling" means that when this trip
> > > point is crossed, active cooling must be enabled. What is it if not
> > > implying action?
> >
> > But within a board there could be more than one active cooling actions
> > that could be done, it is not a 1 to 1 relation. Same thing applies to
> > passive cooling. The binding does not imply a specific action. Just the
> > trip type.
>
> I'd prefer the "active" and "passive" states to be renamed an their
> descriptions rephrased. In general, the idea of having just four trip
> point types seems like bound to a single specific hardware platform.
>
> That's a wild guess, but maybe having an unsigned integer to represent
> trip point "attention level" would be a better idea?

The set of names can be extended in future, and we can choose to have an
attention-level property in future, and map the existing types to them.
If we don't have something fundamantally better, I think this should be
OK for now.

>
> >
> > >
> > >>
> > >>>
> > >>>> +        "hot":          A trip point to notify emergency
> > >>>> +        "critical":     Hardware not reliable.
> > >>>> +  Type: string
> > >>>> +
> > >>> [snip]
> > >>>> +* Examples
> > >>>> +
> > >>>> +Below are several examples on how to use thermal data descriptors
> > >>>> +using device tree bindings:
> > >>>> +
> > >>>> +(a) - CPU thermal zone
> > >>>> +
> > >>>> +The CPU thermal zone example below describes how to setup one thermal zone
> > >>>> +using one single sensor as temperature source and many cooling devices and
> > >>>> +power dissipation control sources.
> > >>>> +
> > >>>> +#include <dt-bindings/thermal/thermal.h>
> > >>>> +
> > >>>> +cpus {
> > >>>> +        /*
> > >>>> +         * Here is an example of describing a cooling device for a DVFS
> > >>>> +         * capable CPU. The CPU node describes its four OPPs.
> > >>>> +         * The cooling states possible are 0..3, and they are
> > >>>> +         * used as OPP indexes. The minimum cooling state is 0, which means
> > >>>> +         * all four OPPs can be available to the system. The maximum
> > >>>> +         * cooling state is 3, which means only the lowest OPPs (198MHz@0.85V)
> > >>>> +         * can be available in the system.
> > >>>> +         */
> > >>>> +        cpu0: cpu@0 {
> > >>>> +                ...
> > >>>> +                operating-points = <
> > >>>> +                        /* kHz    uV */
> > >>>> +                        970000  1200000
> > >>>> +                        792000  1100000
> > >>>> +                        396000  950000
> > >>>> +                        198000  850000
> > >>>> +                >;
> > >>>> +                cooling-min-state = <0>;
> > >>>> +                cooling-max-state = <3>;
> > >>>> +                #cooling-cells = <2>; /* min followed by max */
> > >>>
> > >>> I believe you don't need the min- and max-state properties here then. Your
> > >>> thermal core can simply query the cpufreq driver (which would be a cooling
> > >>> device here) about the range of states it supports
> > >>
> > >> This binding is not supposed to be aware of cpufreq, which is Linux
> > >> specific implementation.
> > >
> > > I didn't say anything about making the binding aware of cpufreq, but
> > > instead about getting rid of redundancy of data, that can be provided
> > > by respective drivers anyway.
> >
> > There are cases in which cooling devices don't need to use all states
> > for cooling, because either lower states does not provide cooling
> > effectiveness or higher states must be avoided at all. So, allowing
> > drivers to report this thermal info is possible, but questionable
> > design, as you would be spreading the thermal info. Besides, for the
> > example I gave, the driver would need to know board specifics, as the
> > range of states would vary anyway across board.
>
> One thing is the allowed range of cooling states supported by the
> cooling device and another is the range of states that are usable on
> given board. The former is a property of the cooling device that
> in most cases is implied by its compatible string, so to eliminate the
> bad data redundancy, you should not make the user respecify that. The
> latter you have as a part of your cooling device specifier tuple.
>
> As an example of this, see PWM, GPIO or IRQ bindings. You don't have
> {pwm-channel,pwm-duty,interrupt,gpio}-{min,max} properties, because this
> is not needed by respective PWM, GPIO or IRQ drivers, as they already
> know these parameters.

This is arguable. The {min,max} levels associated with a cooling state
is essentially a recommendation of a sane set of values you might want
to use the cooling device with.

It could work using only the cooling device's information, but it might
not be all that useful. The range might not represent a linear scale,
and there might be secondary effects to consider (e.g. noise) that would
affect the decision and would likely need to be considered by the
particular drivers.

The key question is where do we make the trade off? How much platform
knowledge do we want each driver to have to handle, and how much are we
happy to place in DT?

It is possible to use the information from particular devices and ignore
the {min,max} cooling state properties in future if that turns out to be
better. I think that would be reasonable for now.

Thanks,
Mark.
