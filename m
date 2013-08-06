Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3HFLOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 07:14:16 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54105 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab3HFLOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 07:14:14 -0400
Message-ID: <1375787649.12043.34.camel@hornet>
Subject: Re: RFC: device thermal limits represented in device tree nodes
From: Pawel Moll <pawel.moll@arm.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
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
Date: Tue, 06 Aug 2013 12:14:09 +0100
In-Reply-To: <51F2D443.6040909@ti.com>
References: <51ED40E3.5020703@ti.com> <51EF3186.9060001@wwwdotorg.org>
	 <1374664745.25700.118.camel@hornet> <51EFED19.5090900@ti.com>
	 <1374768928.3213.31.camel@hornet> <51F15E42.1060409@ti.com>
	 <1374773611.3213.44.camel@hornet> <51F2D443.6040909@ti.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Aug 2013 11:14:09.0584 (UTC) FILETIME=[12A47300:01CE9296]
X-MC-Unique: 113080612141103401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies about the delay, I was "otherwise engaged" for a week...

I hope you haven't lost all motivation to work on this subject, as it's
really worth the while!

On Fri, 2013-07-26 at 20:55 +0100, Eduardo Valentin wrote:
> On 25-07-2013 13:33, Pawel Moll wrote:
> > On Thu, 2013-07-25 at 18:20 +0100, Eduardo Valentin wrote:
> >>>> 	thermal_zone {
> >>>> 		type = "CPU";
> >>>
> >>> So what does this exactly mean? What is so special about CPU? What other
> >>> types you've got there? (Am I just lazy not looking at the numerous
> >>> links you provided? ;-)
> >>
> >> Hehehe. OK. Type is supposed to describe what your zone is representing.
> > 
> > As in "a name"? So, for example "The board", "PSU"? What I meant to ask
> > was: does the string carry any meaning?

You haven't commended on this...

> >>>> 		trips {
> >>>> 			alert@100000{
> >>>> 				temperature = <100000>; /* milliCelsius
> >>>> 				hysteresis = <2000>; /* milliCelsius */
> >>>> 				type = <THERMAL_TRIP_PASSIVE>;
> >>>> 			};
> >>>> 			crit@125000{
> >>>> 				temperature = <125000>; /* milliCelsius
> >>>> 				hysteresis = <2000>; /* milliCelsius */
> >>>> 				type = <THERMAL_TRIP_CRITICAL>;
> >>>> 			};
> >>>> 		};
> >>>> 		bind_params {
> >>>> 			action@0{
> >>>> 				cooling_device = "thermal-cpufreq";
> >>>
> >>> Why is it a string? It seems very Linux-y... (cpufreq) Is there any
> >>> particular reason not to have phandles to the fans that have any impact
> >>> on the zone? 
> >>
> >> Because fans are not the only way to cool your system, specially those
> >> systems that don't feature fans. Managing the speed of your CPU is one
> >> example of lowering temperature without fans. Managing the load on your
> >> system is another way. These are obviously, virtual concepts. And
> >> because we have physical ways and logical ways to cool the zone, then I
> >> didnt put a phandle to a device there.
> > 
> > "virtual concepts"... This is where my problem lies... It's not hardware
> > so it doesn't seem to belong in the tree at the first sight. Shouldn't
>
> Yeah, in fact, this is exactly the point that creates most of the
> disagreement. You may check Guenter's arguments against this proposal
> (in my original RFC email, there is a link to it).
> 
> Well, if one don't want to see this as a 'virtual concept' it could say
> the cooling device is the cpu itself:
> 		cooling_device = <&cpu0>;

Would this create any particular problem at the driver/framework side?

> > it focus on "physical data" instead? As in: point at devices that have
> > some impact on the conditions? For example, you can say "please, do the
> > right thing to cool your environment down" to both CPU and fan, can't
> > you? The "cooling driver" for the CPU would know that it has to slow
> > down, while a driver for the fan would know that it has to speed up ;-)
> > 
> > What I'm trying to say is that in my opinion the tree should simply link
> > the object, the sensor and the actuator. Nothing more, nothing less.
> 
> OK. I think it would be a little unfair to have only links, without
> describing what this link is supposed to be or how it is supposed to be
> used. In previous discussions, I have mentioned two similar examples
> already existing in DT. Here are they: regulator bindings, one does not
> describe only which device connects to which regulator, but also needs
> to describe, voltage limits, current limits, offsets, and other
> properties. And an existing 'virtual concept' would be predefined CPU
> OPPs, that feed the opp layer. Those are configurations of the hardware
> that define a 'virtual' concept of operating point.
> 
> So, saying we need to describe only physical connections or touchable
> things would be a little unfair, IMO. Besides, thermal is still physical
> :-).

Believe me, I'm trying to be as fair as possible :-) and I see a lot of
value in describing the thermal properties of the platforms in the tree.
It's just that we really want to focus on describing the hardware, not
policies. And as you have already spent so much time on the matter, you
are in the best position to find the best set of *physical* properties
that would allow to make the right decision in the code. Could you,
please, try to make one step back and have another look at the problem?
What input data (as in: numbers :-) would you need to get what you want?
Are those numbers characteristic to the specific device (they probably
should live in the driver than) or to the board/platform (tree without a
doubt).

Thanks!

Pawel


