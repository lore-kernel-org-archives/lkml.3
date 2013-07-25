Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab3GYQPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:15:36 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44192 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217Ab3GYQPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:15:34 -0400
Message-ID: <1374768928.3213.31.camel@hornet>
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
Date: Thu, 25 Jul 2013 17:15:28 +0100
In-Reply-To: <51EFED19.5090900@ti.com>
References: <51ED40E3.5020703@ti.com> <51EF3186.9060001@wwwdotorg.org>
	 <1374664745.25700.118.camel@hornet> <51EFED19.5090900@ti.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 25 Jul 2013 16:15:28.0539 (UTC) FILETIME=[2D950EB0:01CE8952]
X-MC-Unique: 113072517153200801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 16:04 +0100, Eduardo Valentin wrote:
> > 1. As you have pointed out, the thermal limits are related to the
> > *device being monitored*, not the sensor itself.
> > 
> Yeah, thinking of it now, this original proposal, it lacks a stronger
> relationship mapping between monitored and monitoring devices. But it
> does have it..
> 
> > 2. Therefore the tree should express relation between those two; a
> > sensor mode should be connected (via phandle most likely) to the device
> 
> .. this is done, more or less, by means of the 'type' property (see
> original RFC binding).

I'm not sure what do you mean (regarding "type"), but I think I got what
I wanted with the "monitoring_device" phandles (shouldn't it be
"_device*s*" then? ;-).

> For example:
> cpu0: cpu@0 {
> 	/* ... cpu needed bindings  */
> 
> 	thermal_zone {
> 		type = "CPU";

So what does this exactly mean? What is so special about CPU? What other
types you've got there? (Am I just lazy not looking at the numerous
links you provided? ;-)

> 		monitoring_device = <&sensor@xxxx
> 				    &sensor@yyyy>;
> 
> 		mask = <0x03>; /* trips writability */
> 		passive_delay = <250>; /* milliseconds */
> 		polling_delay = <1000>; /* milliseconds */
> 		policy = "step_wise";

The word "policy" doesn't sound to me like a "hardware feature",
wouldn't you agree?

> 		trips {
> 			alert@100000{
> 				temperature = <100000>; /* milliCelsius
> 				hysteresis = <2000>; /* milliCelsius */
> 				type = <THERMAL_TRIP_PASSIVE>;
> 			};
> 			crit@125000{
> 				temperature = <125000>; /* milliCelsius
> 				hysteresis = <2000>; /* milliCelsius */
> 				type = <THERMAL_TRIP_CRITICAL>;
> 			};
> 		};
> 		bind_params {
> 			action@0{
> 				cooling_device = "thermal-cpufreq";

Why is it a string? It seems very Linux-y... (cpufreq) Is there any
particular reason not to have phandles to the fans that have any impact
on the zone?

> 				weight = <100>; /* percentage */

Does this mean: how "successful" will be the particular fan?

> Another way, as I mentioned in the original RFC, an option would be to
> have the thermal_zone node not embedded in any device node. But them, we
> would need to firmly link it to other device nodes, to describe what is
> monitored and what is used for monitoring. 

You mean the zone nodes would live at the top level of the tree? To my
mind the root represents the device (the board, whatever you call it),
which, I guess, may be what you want, if the zone "covers" the whole
device? (as in: one fan and one sensor somewhere in the box and the only
thing you may do is to check the ambient temperature and start the fan
if it's to high)

> With the above I believe we could have dts(i) files describing only
> thermal, for instance.

You can include a dtsi inside the device node, no problem with that:

/dts-v1/;
        
/ {     
        smb {                   
                compatible = "simple-bus";

                /include/ "vexpress-v2m-rs1.dtsi"
        };      
};     

Pawel


