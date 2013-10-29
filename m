Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab3J2E5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 00:57:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3J2E5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 00:57:37 -0400
Date: Tue, 29 Oct 2013 15:57:18 +1100
From: NeilBrown <neilb@suse.de>
To: Anton Vorontsov <anton@enomsg.org>
Cc: "Tc, Jenny" <jenny.tc@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kim, Milo" <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rhyland Klein <rklein@nvidia.com>
Subject: Re: [PATCH 1/7] power_supply: Add charger control properties
Message-ID: <20131029155718.717250be@notabene.brown>
In-Reply-To: <20131028061807.GA31266@teo>
References: <1379959445-28207-1-git-send-email-jenny.tc@intel.com>
	<1379959445-28207-2-git-send-email-jenny.tc@intel.com>
	<20131027234535.GA23523@teo>
	<20ADAB092842284E95860F279283C5640AA99A32@BGSMSX104.gar.corp.intel.com>
	<20131028061807.GA31266@teo>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qWbZ5tI9YFF4R5aW9WQyXsG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qWbZ5tI9YFF4R5aW9WQyXsG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 27 Oct 2013 23:18:08 -0700 Anton Vorontsov <anton@enomsg.org> wrote:

> On Mon, Oct 28, 2013 at 03:36:36AM +0000, Tc, Jenny wrote:
> > > But do we really want to control the chargers through the power_suppl=
y's user-visible
> > > interface? It makes the whole power supply thing so complicated that =
I'm already losing
> > > track of it. Right now I think I would prefer to move all the charger=
 logic out of the psy
> > > class.
> > >
> >=20
> > I think exposing properties make the logic generic, otherwise it may en=
d up in having callback
> > functions.
> >
> > Also there are some scenarios where the charging algorithm has to be in=
 the
> > user space.
>=20
> Which scenarios?
>=20
> Plus, I am more questioning if the power supply framework is the right
> thing to control the *chargers*. Chargers are not the power supply to the
> system or any device (well, except for the batteries themselves).

I'm not sure this is (always) true.
On my device (gta04.org) the battery, the USB OTG port, and a separate 5VDC
input can each be the power source of the whole device.
The USB and 5VDC cannot both be active concurrently, but either can be acti=
ve
together with the battery.

The device can function without the battery, so the charger plugged into the
USB-OTG must be supplying power to the system (not just the battery).

The "charger" functionality sits between the battery and the external power
supply monitoring the voltage on the battery and the current from the
external supply.  Based on these values (and some timers and a state machin=
e)
it enabled or disables the external supply and possibly imposes a
current-limit on it.

The three power sources all have "power_supply" devices registered (though
the battery only does because it contains a bq27000 charger counter).
I've been wondering where to put sysfs attributes to control the charging.
I currently place them in the power_supply device for each external power
source.
That makes some sense for the 'current limit' value, but not for the
'battery volts at which to re-start charging' value.
There is also a setting which affects  whether the external source is
switched off if the voltage drops below 4.4V.  In some circumstances I want
to leave the charger enabled then, as it could just mean the cyclist is
taking a break and there should be current again soon.

I think the sensible place for these tune-ables is with the battery.  i.e. =
the
power_supply that corresponds to the battery could register "min voltage" a=
nd
"min current".
The charger driver needs to know about this battery and about any power
sources that can charge it, and uses the state of the battery to decide how
to tune the state of the charger.

I note that there is already something a lot like this between=20
   88pm860x_battery.c
and
   88pm860x_charger.c

They manage to locate each other and the charger call get_property and
set_property on the battery.

Maybe formalising this might be a useful way forward.

I'm not sure that we really need a new driver-class for chargers.  Maybe ju=
st
a way to link external power supplies to battery power supplies, and maybe
some agreement on what they are allowed to say to each other.

Jenny: would something like that work for you??

Thanks,
NeilBrown



>=20
> > Using the patch https://lkml.org/lkml/2013/7/25/204,
> > the power supply change notification can be broadcasted. We can add not=
ifier events
> > for power_supply_register and thermal throttling. This way power_supply=
_charger.c can
> > be a separate driver and it can listen to psy notifications to take act=
ions.
>=20
> If you ever need this particular notifier, I am OK with it (but I'll
> consider applying it only together with some its users).
>=20
> Basically, I am more against these three patches:
>=20
> [PATCH 3/7] power_supply: add throttle state
> [PATCH 2/7] power_supply: add charger cable properties
> [PATCH 1/7] power_supply: Add charger control properties (enable_charger =
part)
>=20
> These three add too much "charger" specifics to the power_supply stuff. I
> think they deserve their own subsystem/class/whatever.
>=20
> Also, the battid framework is written without any notion of device/driver
> separation, uses global variables, and I suspect it should not exist at
> all (psy_get_batt_prop function makes me think that you should just
> register the i2c/spi/w1 battery with the power_supply and not use the
> ad-hoc stuff).
>=20
> Anton
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--Sig_/qWbZ5tI9YFF4R5aW9WQyXsG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUm9ALjnsnt1WYoG5AQI4+RAAkW4xkNb8ItHwSsAxmrs+QH+SzQFnh2E6
Z1ngP/wSlEeTAVwuG8D2HPD4VdxEwKB8gcOVlr5t/E8dXCXLeXC7+BoyvghvLgip
edmOueBfd6RDTKOJyC9YO3Jheff0TIJlE2rbFF8nyjmjpKEY4ZVqGC7keiN+sf67
BA7jJNUgkcfVQTghjed2jInov+LODPBP+xp+S+tijCHS66E9gjFbhYNb+rQipEDI
AklQ9miZvrRAiJV/jIUf/s5Lt55HvzViJKV8fAW7TTC+VIWe4C7ILx5W7EK9aBMz
uhUtgUdaCRy4Ktlap6GcFBoo3jCSB2RjCQe5V+vCkVfCGv+1n46Ban4Ky3hpVW9+
xomEs8NV+YZVHTIQT6IHy1UrmWU37PCPmbpM8k6X9GMXF59I8vEKYaeueVwjeyge
JG1ouUaExXuQCBD6yUIp0AIOcfIWLRW5ozV27NbyFqlsLBgOGX13/zLp3IhL9T78
GVbH8Zzl8utuIIAVfnelI/aUOQIx1sP/dXnJAnApLuv6x+gP8XNmDzOTYEIGhXdu
vz+ZfKfPDXJdq8tfXiCioLTsDaD7ver4v90OOaktvzvjxxy6dcPAU3Ltmre2MMpG
hNHDaXYr61pEtPZnaMAphatTo4cje27Stfn3U+wQnrHmYh8REk5OF4bqpNlNKm6f
jAcU7nWo6sU=
=joVV
-----END PGP SIGNATURE-----

--Sig_/qWbZ5tI9YFF4R5aW9WQyXsG--
