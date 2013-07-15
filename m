Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab3GOREO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:04:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:47874 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932687Ab3GOREM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:04:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,670,1367996400"; 
   d="scan'208";a="331671036"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>, Wei Ni <wni@nvidia.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "amit.daniel@samsung.com" <amit.daniel@samsung.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 2/4] thermal: introduce device tree parser
Thread-Topic: [RFC PATCH 2/4] thermal: introduce device tree parser
Thread-Index: AQHOfKzHQe2pjaI4KEOQYKgzuuPkEZldHXgAgAgxIACAAJthQA==
Date: Mon, 15 Jul 2013 17:03:26 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59CEB475@BGSMSX101.gar.corp.intel.com>
References: <1373378414-28086-1-git-send-email-eduardo.valentin@ti.com>
 <1373378414-28086-3-git-send-email-eduardo.valentin@ti.com>
 <51DD03C8.1090207@nvidia.com> <51E3E2FA.7000708@ti.com>
In-Reply-To: <51E3E2FA.7000708@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
> owner@vger.kernel.org] On Behalf Of Eduardo Valentin
> Sent: Monday, July 15, 2013 5:25 PM
> To: Wei Ni
> Cc: Eduardo Valentin; linux-pm@vger.kernel.org; R, Durgadoss;
> amit.daniel@samsung.com; Zhang, Rui; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH 2/4] thermal: introduce device tree parser
> 
> On 10-07-2013 02:48, Wei Ni wrote:
> > On 07/09/2013 10:00 PM, Eduardo Valentin wrote:
> >> In order to be able to build thermal policies
> >> based on generic sensors, like I2C device, that
> >> can be places in different points on different boards,
> >> there is a need to have a way to feed board dependent
> >> data into the thermal framework.
> >>
> >> This patch introduces a thermal data parser for device
> >> tree. The parsed data is used to build thermal zones
> >> and thermal binding parameters. The output data
> >> can then be used to deploy thermal policies.
> >>
> >> This patch adds also documentation regarding this
> >> API and how to define define tree nodes to use
> >> this infrastructure.
> >
> > It looks good, with this infrastructure, we can add generic sensor
> > driver into the thermal fw easily.
> >
> >
> >> +
> >> +Below is an example:
> >> +thermal_zone {
> >> +            type = "CPU";
> >> +            mask = <0x03>; /* trips writability */
> >> +            passive_delay = <250>; /* milliseconds */
> >> +            polling_delay = <1000>; /* milliseconds */
> >> +            governor = "step_wise";
> >> +            trips {
> >> +                    alert@100000{
> >> +                            temperature = <100000>; /* milliCelsius */
> >> +                            hysteresis = <0>; /* milliCelsius */
> >> +                            type = <1>;
> >
> > how about to use the trip type name directly, such as named as
> > "passive-trip;", I think it's more readable. for example:
> > trip0 {
> > ....
> > passive-trip;
> > }
> > trip1 {
> > ....
> > active-trip;
> > }
> >
> >> +                    };
> >> +                    crit@125000{
> >> +                            temperature = <125000>; /* milliCelsius */
> >> +                            hysteresis = <0>; /* milliCelsius */
> >> +                            type = <3>;
> >> +                    };
> >> +            };
> >> +            bind_params {
> >> +                    action@0{
> >> +                            cooling_device = "thermal-cpufreq";
> >> +                            weight = <100>; /* percentage */
> >> +                            mask = <0x01>;
> >> +                    };
> >> +            };
> >> +};
> >
> > as we know, thermal_zone_bind_cooling_device() will set the upper/lower
> > in the thermal_instance. In the default .bind function, it just set to
> > THERMAL_NO_LIMIT, but for some platform, it need to set these
> > upper/lower values for different cooling device and trips, how to pass
> > these values in DT? how about to set:
> > action@0 {
> > ...
> > mask = <0x03>; //or you can remove this property;
> 
> Well, this has been added accordingly to current API needs.
> 
> > trip0 = <&alert 1 2>; //1 is lower value, 2 is upper value;
> > trip1 = <&crit 3 4>;
> 
> I suppose the first item in you 3-tuple is the trip point.
> 
> > }
> 
> Yeah, I also noticed that I was missing the upper and lower limits. But
> unfortunately this is a limitation on the thermal FW API too!
> 
> If one passes a bind params, the structure which represents platform
> info, then it won't be able to pass the upper and lower limits. But by
> passing a .bind callback, then you have the opportunity to match it
> using these two values.
> 
> I believe we would need to change the data structures and the API to
> support upper and lower limits via platform representation. We could
> simply use the .bind callback of the dt thermal zone, but I believe that
> would abusing the API, assuming that .match is for platform binding.
> Durga, what do you think?

okay, I see.. Two approaches I could think of:
1. Introduce two arrays (size = number of trips in the tz) named
upper/lower_limits[size] in the 'thermal_bind_params' structure.
This way we don't need any API change. We can slightly change the
implementation inside '__bind' function in thermal_core.c to get this
working.

2. Pass 3 more parameters in the .match function:
.match(tz, cdev, trip, &lower, &upper). The platform layer
then determines whether there is a match; and if so,
provides sane values for lower and upper variables.

At this point of time, I think I prefer method 1 ;)
Let me know your thoughts.

Thanks,
Durga
> 
> 
> >
> >
> > Thanks.
> > Wei.
> >
> >
> >
> 
> 
> --
> You have got to be excited about what you are doing. (L. Lamport)
> 
> Eduardo Valentin

