Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab3ICRNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:13:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58667 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab3ICRNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:13:48 -0400
Message-ID: <52261883.4090807@ti.com>
Date: Tue, 3 Sep 2013 13:12:35 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 02/14] drivers: thermal: introduce device tree parser
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com> <1377299755-5134-3-git-send-email-eduardo.valentin@ti.com> <20130827102205.GC19893@e106331-lin.cambridge.arm.com> <521CAD48.2030306@ti.com> <20130827162309.GR19893@e106331-lin.cambridge.arm.com> <521CED34.2090008@ti.com> <521FD70F.7080104@ti.com> <20130903131554.GE18206@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130903131554.GE18206@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="WR5fIB42Itx8IHw8wUUIpNHItswNgOh4D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WR5fIB42Itx8IHw8wUUIpNHItswNgOh4D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On 03-09-2013 09:15, Mark Rutland wrote:
> On Fri, Aug 30, 2013 at 12:19:43AM +0100, Eduardo Valentin wrote:
>> Mark, Pawel and Stephen,
>>
>>
>> On 27-08-2013 14:17, Eduardo Valentin wrote:
>>> On 27-08-2013 12:23, Mark Rutland wrote:
>>>> On Tue, Aug 27, 2013 at 02:44:40PM +0100, Eduardo Valentin wrote:
>>>>> Hello Mark,
>=20
> Hi, sorry for the delay.
>=20

No issues,

>>
>> <cut>
>>
>> I believe now we need to align on thermal bindings, before I propose
>> next version of this series. So, following the discussions on this
>> thread, I believe a typical CPU thermal zone would look like the follo=
wing:
>> + #include <dt-bindings/thermal/thermal.h>
>> +
>> + cpu_thermal: cpu_thermal {
>> +         passive-delay =3D <250>; /* milliseconds */
>> +         polling-delay =3D <1000>; /* milliseconds */
>=20
> I'm still not keen on placing these intervals in the dt. Why can the
> kernel not choose sensible values?
>=20
>> +                 /*
>> +                  * sensor       ID
>> +                  */
>> +         sensors =3D <&bandgap0     0>;
>> +                         /*
>> +                          * cooling
>> +                          * device       Usage   Trip            lowe=
r
>> bound             upper bound
>> +                          */
>> +         cooling-devices =3D <&cpu0        100     &cpu-alert
>> THERMAL_NO_LIMITS        THERMAL_NO_LIMITS>;
>=20
> I'm not sure it makes sense to group this data within a property. We
> might need to extend this in future and it might not be possible to
> extend this unambiguously. It may make more sense as a sub-node or
> collection of properties.
>=20

I see. Something like the previous DT binding? My previous proposal was
using sub-nodes.

>> +         trips {
>> +                 cpu-alert: cpu-alert {
>> +                         temperature =3D <100000>; /* milliCelsius */=

>> +                         hysteresis =3D <2000>; /* milliCelsius */
>> +                         type =3D <THERMAL_TRIP_PASSIVE>;
>> +                 };
>> +                 cpu-crit: cpu-crit {
>> +                         temperature =3D <125000>; /* milliCelsius */=

>> +                         hysteresis =3D <2000>; /* milliCelsius */
>> +                         type =3D <THERMAL_TRIP_CRITICAL>;
>> +                 };
>> +         };
>> + };
>=20
> How do the upper and lower bounds in the cooling-devices property
> interact with temperatures described in the trips node?

By means of the trip phandle. It would mean once the trip is crossed, it
is expected to modulate the cooling device between the specified limits.

>=20
>>
>> *Note: THERMAL_NO_LIMIT means, it will be using the cooling device
>> minimum and maximum limits.
>=20
> I'm confused what are the cooling device min and max limits? Where are
> they defined if not in the lower bound and upper bound entries of the
> cooling-devices property?

They were not specified in this example, because previous discussions
suggested that we shall not represent cooling devices as dt nodes as
they are virtual. Those would be part of the cooling device node, in the
case we want to have cooling devices nodes and property in DT.

>=20
>>
>> Couple of comments.
>> 1. I am keeping the pooling intervals. A possible alternative way to
>> describe that would be specifying the maximum dT/dt. Essentially becau=
se
>> I am still convinced that this is part of hw specs.
>=20
> I still don't see why it's not possible to do this dynamically. I am no=
t
> entirely convinced this is part of the hw spec.

Because not all hardware have power sensors and deriving power vs.
temperature vs. time is not a simple task, specially based on estimates,
say on cpu load. Remember that we are not only talking about CPU
temperature here, there are other heat sources. Same load has different
consumption on different HW, how SW is supposed to find that out wihtout
proper sensing?

>=20
>>
>> 2. The above follows your suggestion to use consumer pointing to
>> producers. Although, I still need to figure out how this could be
>> implemented for Linux. But I think that is another story, at least for=

>> now. We need to first align on the DT binding itself.
>=20
> I assume you mean the sensors property? That looks fine to me, though w=
e

Sensors and cooling-devices.

> may need to specify the way sensors relate to temperatures in trip
> points and cooling device properties -- do those temperatures correspon=
d
> to an average of sensors readings, min/max, etc?

Those are based on instant measurements.

>=20
>>
>> 3. The link from cooling device specification to trip points, from my
>> perspective, should be enough, and thus we shall not need the thermal
>> cells and size for trip points, as you proposed. Let me know what you =
think.
>=20
> I'm not keen on the mixed bag of values in the cooling-device property,=

> as it's difficult to extend in future if necessary. I think we may need=

> cells for cooling devices -- what if a single fan controller controls
> fans in different thermal zones?

I believe it is just a matter of representation. Using either a list or
subnodes would imply that one would need to add links to fan device
twice, one in each thermal zone (it does not matter if inside a subnode
or inside a list).

>=20
> I'm also not keen on devices being described as their own cooling
> device, as I think this is more difficult to support than not listing a=

> cooling device -- it'll have to be special-cased anyway.

Then we need to have cooling device nodes, even if they are virtual.

>=20
>> Below is another example, on a more complex scenario, board specific
>> case (hypothetical, just for exemplification):
>>
>> + #include <dt-bindings/thermal/thermal.h>
>> +
>> + board_thermal: board_thermal {
>> +         passive-delay =3D <1000>; /* milliseconds */
>> +         polling-delay =3D <2500>; /* milliseconds */
>> +                 /*
>> +                  * sensor       ID
>> +                  */
>> +         sensors =3D <&adc-dummy     0>,
>> +		    <&adc-dummy     1>,
>> +		    <&adc-dymmy     2>;
>=20
> Here we have a set of sensors, but no relationship between these sensor=
s
> and the trips or cooling-devices are described. How does that work?

See my query below.

>=20
>> +                         /*
>> +                          * cooling
>> +                          * device       Usage   Trip		lower	upper
>> +                          */
>> +         cooling-devices =3D <&cpu0       75     &cpu-trip	0      2>,=

>> +			    <&gpu0       40     &gpu-trip	0      2>;
>> +			    <&lcd0       25     &lcd-trip	5      10>;
>> +         trips {
>> +                 cpu-trip: cpu-trip {
>> +                         temperature =3D <60000>; /* milliCelsius */
>> +                         hysteresis =3D <2000>; /* milliCelsius */
>> +                         type =3D <THERMAL_TRIP_PASSIVE>;
>> +                 };
>> +                 gpu-trip: gpu-trip {
>> +                         temperature =3D <55000>; /* milliCelsius */
>> +                         hysteresis =3D <2000>; /* milliCelsius */
>> +                         type =3D <THERMAL_TRIP_PASSIVE>;
>> +                 }
>> +                 lcd-trip: lcp-trip {
>> +                         temperature =3D <53000>; /* milliCelsius */
>> +                         hysteresis =3D <2000>; /* milliCelsius */
>> +                         type =3D <THERMAL_TRIP_PASSIVE>;
>> +                 };
>> +                 crit-trip: crit-trip {
>> +                         temperature =3D <68000>; /* milliCelsius */
>> +                         hysteresis =3D <2000>; /* milliCelsius */
>> +                         type =3D <THERMAL_TRIP_CRITICAL>;
>> +                 };
>> +         };
>> + };
>>
>> Now writing the above example, one might want to have a way to say the=

>> sensor correlation equation.

One way to go is to add a property to describe the linear relation
between them.

>>
>> Another example:
>> + #include <dt-bindings/thermal/thermal.h>
>> +
>> + dsp_thermal: dsp_thermal {
>> +         passive-delay =3D <250>; /* milliseconds */
>> +         polling-delay =3D <1000>; /* milliseconds */
>> +                 /*
>> +                  * sensor       ID
>> +                  */
>> +         sensors =3D <&bandgap0     1>;
>> +                         /*
>> +                          * cooling
>> +                          * device       Usage   Trip            lowe=
r
>> bound             upper bound
>> +                          */
>> +         cooling-devices =3D <&dsp0        100     &dsp-alert
>> THERMAL_NO_LIMIT        THERMAL_NO_LIMIT>;
>> +         trips {
>> +                 dsp-alert: dsp-alert {
>> +                         temperature =3D <100000>; /* milliCelsius */=

>> +                         hysteresis =3D <2000>; /* milliCelsius */
>> +                         type =3D <THERMAL_TRIP_PASSIVE>;
>> +                 };
>> +                 dsp-crit: cdsp-crit {
>> +                         temperature =3D <125000>; /* milliCelsius */=

>> +                         hysteresis =3D <2000>; /* milliCelsius */
>> +                         type =3D <THERMAL_TRIP_CRITICAL>;
>> +                 };
>> +         };
>> + };
>> +
>> + gpu_thermal: gpu_thermal {
>> +         passive-delay =3D <500>; /* milliseconds */
>> +         polling-delay =3D <1000>; /* milliseconds */
>> +                 /*
>> +                  * sensor       ID
>> +                  */
>> +         sensors =3D <&bandgap0     2>;
>> +                         /*
>> +                          * cooling
>> +                          * device       Usage   Trip            lowe=
r
>> bound             upper bound
>> +                          */
>> +         cooling-devices =3D <&gpu0        100     &gpu-alert
>> THERMAL_NO_LIMIT        THERMAL_NO_LIMIT>;
>> +         trips {
>> +                 gpu-alert: gpu-alert {
>> +                         temperature =3D <100000>; /* milliCelsius */=

>> +                         hysteresis =3D <2000>; /* milliCelsius */
>> +                         type =3D <THERMAL_TRIP_PASSIVE>;
>> +                 };
>> +                 gpu-crit: gpu-crit {
>> +                         temperature =3D <125000>; /* milliCelsius */=

>> +                         hysteresis =3D <2000>; /* milliCelsius */
>> +                         type =3D <THERMAL_TRIP_CRITICAL>;
>> +                 };
>> +         };
>> + };
>>
>>
>> Wei, I think the above would cover for the IPs with multiple internal
>> sensors cases you were looking for, right?
>>
>> Durga, please also check if I am missing something to cover for your
>> plans to, in case you will be using DT to describe your HW.
>>
>> Anyways, Mark and Pawel, let me know if I missed something from our
>> discussion. I believe the above bindings would look more like regular
>> standard DT bindings. And also they should be now slim enough, without=

>> Linux implementation details and also without policies.
>=20
> I think that the above can describe that, but I'd like to see a binding=

> document so we can consider it in more detail.

Well, I can write another RFC based on this discussion, for sure. I just
want to know what really blocks this work, that is why I sent the
examples above. But it does not seam we are progressing, looks like we
are move discussing in circles.

Cooling devices seams to be bouncing back and forward. I can send an RFC
considering:
i) addition of cooling devices virtual device nodes
ii) description of used cooling devices inside thermal zones by means of
sub-nodes, instead of lists

Pooling intervals seams to be also a loose lace. To me it is a matter of
choosing a good way to avoid missing events. We can either get the info
from HW simulation / experimentation based on HW itself or we can rely
on SW and assume SW can handle to see all events based on loose info
(assume that sw can be smart to do a self adaptive closed loop control
system based on no defined set of inputs). Both solutions are doable,
except that one may be closer to reality than the other. Also, one is
based on HW info and the other forces sw to deduce HW info. If you can
provide info that your proposal has strong evidence to be closer to
reality, I am find to signed it off.

All best,


Eduardo.
>=20
> Thanks,
> Mark.
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--WR5fIB42Itx8IHw8wUUIpNHItswNgOh4D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlImGIMACgkQCXcVR3XQvP1SOAD/XN4/mjKdpBJlGbOl4Iz10DC7
9reniWqBIWsL0r5u7SwBAMsA2xmqJ7z/R/mTni3VHvBz3SiG9m6hY4yDM66RCDMx
=gBPr
-----END PGP SIGNATURE-----

--WR5fIB42Itx8IHw8wUUIpNHItswNgOh4D--
