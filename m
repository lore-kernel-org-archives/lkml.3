Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbaDXSYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:24:11 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:55305 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758455AbaDXSYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:24:08 -0400
Date: Thu, 24 Apr 2014 20:22:44 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] gpio: of: Allow -gpio suffix for property names
Message-ID: <20140424182243.GA27443@ulmo>
References: <1398266889-17489-1-git-send-email-thierry.reding@gmail.com>
 <1398266889-17489-2-git-send-email-thierry.reding@gmail.com>
 <CACRpkdadAUXgC-K6be6SFFn2ZTvCqkTK7VRJEzpFdUbybKc3YA@mail.gmail.com>
 <CAL_Jsq+DwCBLoNYsgHnoLQgSMnSBDM5XH_xoWS-RWdmx-JBeXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+DwCBLoNYsgHnoLQgSMnSBDM5XH_xoWS-RWdmx-JBeXg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 09:06:24AM -0500, Rob Herring wrote:
> On Thu, Apr 24, 2014 at 7:47 AM, Linus Walleij <linus.walleij@linaro.org>=
 wrote:
> > On Wed, Apr 23, 2014 at 5:28 PM, Thierry Reding
> > <thierry.reding@gmail.com> wrote:
> >
> >> From: Thierry Reding <treding@nvidia.com>
> >>
> >> Many bindings use the -gpio suffix in property names. Support this in
> >> addition to the -gpios suffix when requesting GPIOs using the new
> >> descriptor-based API.
> >>
> >> Signed-off-by: Thierry Reding <treding@nvidia.com>
> >
> > Are the DT bindings really full of such ambiguity between
> > singular and plural? Examples?
> >
> > What happens in affected drivers today? It just doesn't work?
>=20
> They mostly seem to use of_get_named_gpio.

Indeed. That has the downside of requiring manual parsing and handling
of the GPIO polarity, though.

> > Does that mean these bindings are not actively used by any
> > drivers yet so we could augment the bindings instead, or are
> > they already deployed so we must implement this?
> >
> > Would like a word from the DT people here...
>=20
> Interestingly, there is not a single occurrence of '-gpio ' in
> powerpc, but a bunch in ARM. In hindsight, we should have perhaps
> enforced using -gpios only, but that doesn't really matter now. We
> have -gpio in use, so we need to support it.

I think I also saw a proposal only recently to add support for a
gpios/gpio-names type of binding

> That doesn't necessarily mean this function has to support it. For
> example, this function could a legacy method and some other function
> should be used instead (of_get_named_gpio perhaps).

The reason why I posted this is precisely because I wanted to convert
over some drivers to use the new helpers (because they make things like
polarity handling much easier). My first attempt was to fix the binding
because I was under the impression that -gpio usage was discouraged, but
people didn't like that because, you know, DT bindings being a stable
ABI and all that.

The downside of not allowing the gpiod API to support the -gpio suffix
is that we'll never be able to convert drivers that use such a binding
and will forever have a hodgepodge of GPIO APIs that we need to support.

> >>  drivers/gpio/gpiolib.c | 18 ++++++++++++------
> >>  1 file changed, 12 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> >> index 7a0b97076374..b991462c22fb 100644
> >> --- a/drivers/gpio/gpiolib.c
> >> +++ b/drivers/gpio/gpiolib.c
> >> @@ -2594,17 +2594,23 @@ static struct gpio_desc *of_find_gpio(struct d=
evice *dev, const char *con_id,
> >>                                       unsigned int idx,
> >>                                       enum gpio_lookup_flags *flags)
> >>  {
> >> +       static const char *suffixes[] =3D { "gpios", "gpio" };
> >>         char prop_name[32]; /* 32 is max size of property name */
> >>         enum of_gpio_flags of_flags;
> >>         struct gpio_desc *desc;
> >> +       unsigned int i;
> >>
> >> -       if (con_id)
> >> -               snprintf(prop_name, 32, "%s-gpios", con_id);
> >> -       else
> >> -               snprintf(prop_name, 32, "gpios");
> >> +       for (i =3D 0; i < ARRAY_SIZE(suffixes); i++) {
> >> +               if (con_id)
> >> +                       snprintf(prop_name, 32, "%s-%s", con_id, suffi=
xes[i]);
> >> +               else
> >> +                       snprintf(prop_name, 32, "%s", suffixes[i]);
>=20
> This has the side effect of searching for "gpio" as property name
> which I don't think we want to allow.

Why don't we want to allow a "gpio" property when we already allow
"gpios"?

> It also allows a DT with either suffix to work. While I don't
> necessarily think the kernel's job should be DT validation, we don't
> have any other validation today and I don't see how this change
> simplifies the code. Between stricter DT checking (in the kernel) and
> simpler code, I'd pick the latter.

I had briefly considered adding more validation here as well, such as
refusing to hand out any GPIO with idx > 0 for the -gpio suffix, but
then opted not to do that in favour of code simplicity.

Thierry

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWVZzAAoJEN0jrNd/PrOhhCQQAJzLZ33kQR5hcdQQkxUfC9vT
YyiUuTU97tLYpZg3/Z3cXFwJvE4dso34T7jQMqFczexxi201iURCgRjtoOI9/WGe
vfpPVErY86A3wi/E5o9k2bc1reZgYHHFQPYZZhZmloTqOOtqvy5WCPinoFLUhECB
zf4ofB6wz3EdcRV4AZNBP0339Z7wFEjKKG2TtLhwJVp9mbqv6FfC1udyT1JcNkBl
uq6x8j7btDBvKaH55rzg/ePLsHoYEvRZQDm3vN849wlGks+rgbM/Wq6BhAxL3+L7
vP5sNwLBqyMgki4jlkHuH4IqnlqBAxhb27fe6TFslGE8lLBgrxMaVdA9V9VawafV
kPhMWitdfuv+1G8rHU32aaCkF48lBMr2khle6VXAA+RwnS7MJ1+899VTlsCWOmt4
FrGXJqDIBexJgDZtIRFtbWezysMT3JkkTTfb6wwqr1fyN9iKZWlxnZt4AW/3wdCx
eM7hbNXOXlejicGJyw5gFEVbLuh5P/vCPi7UTFF+dcFRM/8p1CiEGc4NezCpk1hi
ZCL7+LyuqO8w8YYbrVYTyn7Z/Z/xRhvWfC7ETN/QJBOPtEzMJ6sdnzdCEp58ATft
Q85imJfF31F6k+0BTcya1nnQSuDj0a4AOZvE+uyDsFTW3EeoA/HNUCt61chI+87w
6BacZ7/meZMeGEih4zGI
=rPf8
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
