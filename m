Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab3KNNk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 08:40:29 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:59239 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3KNNkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 08:40:16 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: swarren@wwwdotorg.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, rob.herring@calxeda.com, linux@roeck-us.net,
        rui.zhang@intel.com, wni@nvidia.com, grant.likely@linaro.org,
        durgadoss.r@intel.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
Date: Thu, 14 Nov 2013 14:40:12 +0100
Message-ID: <25668725.sMcoUCgCKk@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <5284B478.8090503@ti.com>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <2523089.oKCvZdz31U@flatron> <5284B478.8090503@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 of November 2013 07:31:04 Eduardo Valentin wrote:
> On 13-11-2013 12:57, Tomasz Figa wrote:
> > Hi Eduardo,
> > 
> 
> Hello Tomaz
> 
> > On Tuesday 12 of November 2013 15:46:04 Eduardo Valentin wrote:
> >> This patch introduces a device tree bindings for
> >> describing the hardware thermal behavior and limits.
> >> Also a parser to read and interpret the data and feed
> >> it in the thermal framework is presented.
> > [snip]
> >> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
> >> new file mode 100644
> >> index 0000000..59f5bd2
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
> >> @@ -0,0 +1,586 @@
> > [snip]
> >> +* Cooling device nodes
> >> +
> >> +Cooling devices are nodes providing control on power dissipation. There
> >> +are essentially two ways to provide control on power dissipation. First
> >> +is by means of regulating device performance, which is known as passive
> >> +cooling. A typical passive cooling is a CPU that has dynamic voltage and
> >> +frequency scaling (DVFS), and uses lower frequencies as cooling states.
> >> +Second is by means of activating devices in order to remove
> >> +the dissipated heat, which is known as active cooling, e.g. regulating
> >> +fan speeds. In both cases, cooling devices shall have a way to determine
> >> +the state of cooling in which the device is.
> >> +
> >> +Required properties:
> >> +- cooling-min-state:	An integer indicating the smallest
> >> +  Type: unsigned	cooling state accepted. Typically 0.
> >> +  Size: one cell
> > 
> > Could you explain (just in a reply) what a cooling state is and what are
> > the min and max values used for?
> 
> Cooling state is an unsigned integer which represents heat control that
> a cooling device implies.

OK. So you have a cooling device and it can have multiple cooling states,
like a cooling fan that has multiple speed levels. Did I understand this
correctly?

IMHO this should be also explained in the documentation above, possibly
with one or two examples.

> 
> > 
> >> +
> >> +- cooling-max-state:	An integer indicating the largest
> >> +  Type: unsigned	cooling state accepted.
> >> +  Size: one cell
> >> +
> >> +- #cooling-cells:	Used to provide cooling device specific information
> >> +  Type: unsigned	while referring to it. Must be at least 2, in order
> >> +  Size: one cell      	to specify minimum and maximum cooling state used
> >> +			in the reference. The first cell is the minimum
> >> +			cooling state requested and the second cell is
> >> +			the maximum cooling state requested in the reference.
> >> +			See Cooling device maps section below for more details
> >> +			on how consumers refer to cooling devices.
> >> +
> >> +* Trip points
> >> +
> >> +The trip node is a node to describe a point in the temperature domain
> >> +in which the system takes an action. This node describes just the point,
> >> +not the action.
> >> +
> >> +Required properties:
> >> +- temperature:		An integer indicating the trip temperature level,
> >> +  Type: signed		in millicelsius.
> >> +  Size: one cell
> >> +
> >> +- hysteresis:		A low hysteresis value on temperature property (above).
> >> +  Type: unsigned	This is a relative value, in millicelsius.
> >> +  Size: one cell
> > 
> > What about replacing temperature and hysteresis with a single temperature
> > property that can be either one cell for 0 hysteresis or two cells to
> > specify lower and upper range of temperatures?
> 
> What is the problem with using two properties? I think we loose
> representation by gluing two properties into one just because one cell.

Ranges is the representation widely used in other bindings. In addition
I believe a range is more representative - when reading a DTS you don't
need to think whether the hysteresis is in temperature units, percents or
something else and also is less ambiguous, because you have clearly
defined lower and upper bounds in one place.

> 
> > 
> >> +
> >> +- type:			a string containing the trip type. Supported values are:
> >> +	"active":	A trip point to enable active cooling
> >> +	"passive":	A trip point to enable passive cooling
> > 
> > The two above seem to be implying action, as opposed to the general
> > comment about trip points.
> 
> They do not imply action, they specify type of trip.

For me "A trip point to enable active cooling" means that when this trip
point is crossed, active cooling must be enabled. What is it if not
implying action?

> 
> > 
> >> +	"hot":		A trip point to notify emergency
> >> +	"critical":	Hardware not reliable.
> >> +  Type: string
> >> +
> > [snip]
> >> +* Examples
> >> +
> >> +Below are several examples on how to use thermal data descriptors
> >> +using device tree bindings:
> >> +
> >> +(a) - CPU thermal zone
> >> +
> >> +The CPU thermal zone example below describes how to setup one thermal zone
> >> +using one single sensor as temperature source and many cooling devices and
> >> +power dissipation control sources.
> >> +
> >> +#include <dt-bindings/thermal/thermal.h>
> >> +
> >> +cpus {
> >> +	/*
> >> +	 * Here is an example of describing a cooling device for a DVFS
> >> +	 * capable CPU. The CPU node describes its four OPPs.
> >> +	 * The cooling states possible are 0..3, and they are
> >> +	 * used as OPP indexes. The minimum cooling state is 0, which means
> >> +	 * all four OPPs can be available to the system. The maximum
> >> +	 * cooling state is 3, which means only the lowest OPPs (198MHz@0.85V)
> >> +	 * can be available in the system.
> >> +	 */
> >> +	cpu0: cpu@0 {
> >> +		...
> >> +		operating-points = <
> >> +			/* kHz    uV */
> >> +			970000  1200000
> >> +			792000  1100000
> >> +			396000  950000
> >> +			198000  850000
> >> +		>;
> >> +		cooling-min-state = <0>;
> >> +		cooling-max-state = <3>;
> >> +		#cooling-cells = <2>; /* min followed by max */
> > 
> > I believe you don't need the min- and max-state properties here then. Your
> > thermal core can simply query the cpufreq driver (which would be a cooling
> > device here) about the range of states it supports
> 
> This binding is not supposed to be aware of cpufreq, which is Linux
> specific implementation.

I didn't say anything about making the binding aware of cpufreq, but
instead about getting rid of redundancy of data, that can be provided
by respective drivers anyway.

> 
> Besides, the cpufreq layer is populated by data already specified in DT.
> .
> > 
> >> +	};
> >> +	...
> >> +};
> >> +
> >> +&i2c1 {
> >> +	...
> >> +	/*
> >> +	 * A simple fan controller which supports 10 speeds of operation
> >> +	 * (represented as 0-9).
> >> +	 */
> >> +	fan0: fan@0x48 {
> >> +		...
> >> +		cooling-min-state = <0>;
> >> +		cooling-max-state = <9>;
> > 
> > This is similar. The fan driver will probaby know about available
> > fan speed levels and be able to report the range of states to thermal
> > core.
> 
> Then we loose also the flexibility to assign cooling states to trip
> points, as described in this binding.

I don't think you got my point correctly.

Let's say you have a CPU, which has 4 operating points. You don't need
to specify that min state is 0 and max state is 4, because it is implied
by the list of operating points.

Same goes for a fan controller that has, let's say, an 8-bit PWM duty
cycle register, which in turn allows 256 different speed states. This
implies that min state for it is 0 and max state 255 and you don't need
to specify this in DT.

Now, both a CPU and fan controller will have their thermal drivers, which
can report to the thermal core what ranges of cooling states they support,
which again makes it wrong to specify such data in DT.

Best regards,
Tomasz

