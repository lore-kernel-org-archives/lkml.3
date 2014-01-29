Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaA2Txv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:53:51 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58629 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaA2Txu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:53:50 -0500
Date: Wed, 29 Jan 2014 13:52:30 -0600
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: "xinhui.pan" <xinhuix.pan@intel.com>, Felipe Balbi <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linus.walleij@linaro.org>, <gnurou@gmail.com>,
        <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] gpio-intel-mid: fix the incorrect return of idle callback
Message-ID: <20140129195230.GC32149@saruman.home>
Reply-To: <balbi@ti.com>
References: <52E76F71.4080304@intel.com>
 <20140128164937.GA30226@saruman.home>
 <20140128172413.GA31821@psi-dev26.jf.intel.com>
 <20140128181206.GB31977@saruman.home>
 <20140129001357.GA13185@psi-dev26.jf.intel.com>
 <52E8AC7C.5070903@intel.com>
 <20140129191232.GC13185@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0lnxQi9hkpPO77W3"
Content-Disposition: inline
In-Reply-To: <20140129191232.GC13185@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0lnxQi9hkpPO77W3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2014 at 11:12:32AM -0800, David Cohen wrote:
> On Wed, Jan 29, 2014 at 03:23:40PM +0800, xinhui.pan wrote:
> >=20
> > =E4=BA=8E 2014=E5=B9=B401=E6=9C=8829=E6=97=A5 08:13, David Cohen =E5=86=
=99=E9=81=93:
> > > On Tue, Jan 28, 2014 at 12:12:06PM -0600, Felipe Balbi wrote:
> > >> On Tue, Jan 28, 2014 at 09:24:13AM -0800, David Cohen wrote:
> > >>> On Tue, Jan 28, 2014 at 10:49:37AM -0600, Felipe Balbi wrote:
> > >>>> On Tue, Jan 28, 2014 at 04:50:57PM +0800, xinhui.pan wrote:
> > >>>>> From: "xinhui.pan" <xinhuiX.pan@intel.com>
> > >>>>>
> > >>>>> intel_gpio_runtime_idle should return correct error code if it do=
 fail.
> > >>>>> make it more correct even though -EBUSY is the most possible retu=
rn value.
> > >>>>>
> > >>>>> Signed-off-by: bo.he <bo.he@intel.com>
> > >>>>> Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
> > >>>>> ---
> > >>>>>  drivers/gpio/gpio-intel-mid.c |    4 +++-
> > >>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
> > >>>>>
> > >>>>> diff --git a/drivers/gpio/gpio-intel-mid.c b/drivers/gpio/gpio-in=
tel-mid.c
> > >>>>> index d1b50ef..05749a3 100644
> > >>>>> --- a/drivers/gpio/gpio-intel-mid.c
> > >>>>> +++ b/drivers/gpio/gpio-intel-mid.c
> > >>>>> @@ -394,7 +394,9 @@ static const struct irq_domain_ops intel_gpio=
_irq_ops =3D {
> > >>>>> =20
> > >>>>>  static int intel_gpio_runtime_idle(struct device *dev)
> > >>>>>  {
> > >>>>> -	pm_schedule_suspend(dev, 500);
> > >>>>> +	int err =3D pm_schedule_suspend(dev, 500);
> > >>>>> +	if (err)
> > >>>>> +		return err;
> > >>>>>  	return -EBUSY;
> > >>>>
> > >>>> wait, is it only me or this would look a lot better as:
> > >>>>
> > >>>> static int intel_gpio_runtime_idle(struct device *dev)
> > >>>> {
> > >>>> 	return pm_schedule_suspend(dev, 500);
> > >>>> }
> > >>>
> > >>> The reply to your suggestion is probably in this commit :)
> > >>>
> > >>> ---
> > >>> commit 45f0a85c8258741d11bda25c0a5669c06267204a
> > >>> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > >>> Date:   Mon Jun 3 21:49:52 2013 +0200
> > >>>
> > >>>     PM / Runtime: Rework the "runtime idle" helper routine
> > >>> ---
> > >>>
> > >>> We won't return 0 from here.
> > >>
> > >> so you never want to return 0, why don't you, then:
> > >>
> > >> static int intel_gpio_runtime_idle(struct device *dev)
> > >> {
> > >> 	pm_schedule_suspend(dev, 500);
> > >> 	return -EBUSY;
> > >> }
> > >=20
> > > That's how it is currently :)
> > >=20
> > > But this patch is making the function to return a different code in c=
ase
> > > of error. IMHO there is not much fuctional gain with it, but I see
> > > perhaps one extra info for tracing during development.
> > >=20
> > > Anyway, I'll let Xinhui to do further comment since he's the author.
> > >=20
> > > Br, David
> > >=20
> > hi ,David & Balbi
> >   I checked several drivers yesterday to see how they use pm_schedule_s=
uspend=20
> > then found one bug in i2c. Also I noticed  gpio.=20
> > I think returning a correct error code is important.So I change -EBUSY=
=20
> > to *err*. To be honest,current code works well.
>=20
> In my experience, when I'm using fancy things like lauterbach a proper
> error code may save couple of minutes in my life :)
>=20
> I keep my ack here.

fair enough, sorry for the noise ;-) It could still be simplified a bit:

	return err ?: -EBUSY;

--=20
balbi

--0lnxQi9hkpPO77W3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS6Vv+AAoJEIaOsuA1yqRE6SgQAIBDt0PDJW0KmqvAxcMOdUuy
TS97NXB3xMxvKhGHgHxAJnX/LcR0HsCdVl+hj+CRyS8gMA5E2HyIFfCjcXUVGaYX
Kpq82CO+oY4yz2PCM+xO2u9GgMgAR09xIAP6eqgv5G/+9+GmWbYADrE/W59t2Y8h
XxwKC+eHa9MJQ9eGfUNxMjn0PX9w5i5yRCt6z0jY7zT3GAJ36CA+Nxlx/I7UKPed
M2VcLxTQfdWYqDnK8RFkWRom2jTQCR4vItEBFv2YAw3zF7F1+rRuucreDkYwg+Ri
HCotCEMAoKzk6YypsI+jazYois54l7EKg5NFEPKaVOfb7JwAMudVV2CyVmnQ/fZE
NduK2Fk+z1HViPyuAAG43GGKHN8uXUf7WFt3tXjG8WVzRdTR26uIdJ4xEE8GiKKQ
tO1reYQEArrj7ysBF/bVG/c137b0h9M2Dgx09abYNUM3AsMg7jTnu6CgxTJLoUai
Js5PJQUhmI62u+MXx3H+7yrH8kZqx3b8IT703HAEAiwlSgNks4J5Q23NdgV+InDx
aVKap7ayPSO4pyHktew/bhbdayAFRay669uR0DlS7U/SM6sZkD5QnwckXLC+BpC5
AvKfy+LrzneQ9Q1sFHyHit6ZHnhHu6E92ap9EdLiwFhzmfgLHhz8RPOywwbicAIX
PmI984ZjdwG3tAfHdnnS
=7UX0
-----END PGP SIGNATURE-----

--0lnxQi9hkpPO77W3--
