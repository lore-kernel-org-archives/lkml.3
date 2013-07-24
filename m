Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab3GXLTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 07:19:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42447 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3GXLTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 07:19:10 -0400
Message-ID: <1374664745.25700.118.camel@hornet>
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
Date: Wed, 24 Jul 2013 12:19:05 +0100
In-Reply-To: <51EF3186.9060001@wwwdotorg.org>
References: <51ED40E3.5020703@ti.com> <51EF3186.9060001@wwwdotorg.org>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 24 Jul 2013 11:19:06.0572 (UTC) FILETIME=[9C4A78C0:01CE885F]
X-MC-Unique: 113072412190701601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greeting,

Funnily enough I had this discussion couple a months ago and made my
mind back then :-)

> On 07/22/2013 07:25 AM, Eduardo Valentin wrote:
> > representing in device tree would not
> > infringe the original purpose of this data structure  ("The Device
> > Tree is a data structure for describing hardware."[2]).

I couldn't agree more, with a few remarks...

> > In this current proposal, a 'thermal_zone' node would be embedded
> > inside a temperature sensor node, for simplicity. But other
> > possible builds could embedded them in the device with thermal
> > limits (CPU nodes, for instance) or they could be not embedded in
> > any specific node.

So this is the detail that actually caused most of the disagreement :-)

My position on this can be summarized as follows:

1. As you have pointed out, the thermal limits are related to the
*device being monitored*, not the sensor itself.

2. Therefore the tree should express relation between those two; a
sensor mode should be connected (via phandle most likely) to the device
being monitored, eg. (I'm not suggesting any property names, just trying
to express the idea ;-) memory mapped PVT "sensor" monitoring a core
(cpu) temperature could look like this:
	cpu0: cpu@0 {
	};

	sensor@xxxx {
		reg = <xxx>;
		device_monitored = <&cpu0>;
	};
while I2C or 1Wire sensor measuring temperature of the board (or even
inside the device enclosure) would point at the root of the tree.

3. Basing on the above, the thermal limits of the device could be
described in the tree (again, don't pay attention to naming):
	cpu0: cpu@0 {
		thermal_limits {
			cooling {
			};
			critical {
			};
		};
	};
or "hardcoded" in the device driver. After all, as you have pointed out,
the limits are the device's characteristic, so I see no problem with the
"SOC driver" registering the trip points on its own. I'm sure there will
be situations when it's better to parametrize such data via Device Tree,
so it makes perfect sense to have bindings defined for such occasion.
Anyway, as long as the tree describes the relation between the monitored
device, the sensor and the cooling device all should work.

Now, my personal opinion is that the tree should focus at "system level"
data (ie. how is the device connected to others) and describe as little
information that can be probed in runtime - a small (small!) array of
silicon variants in the driver doesn't hurt (unless we're talking about
hundreds of possibilities, where the device tree is obviously the place
to have them). But this is just a rule of thumb I'm following.

Cheers!

Pawel


