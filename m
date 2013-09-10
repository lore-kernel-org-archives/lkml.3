Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3IJRWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:22:31 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:49956 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3IJRW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:22:28 -0400
Date: Tue, 10 Sep 2013 19:21:31 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mike Dunn <mikedunn@newsguy.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] pwm-backlight: add support for device tree gpio control
Message-ID: <20130910172130.GC22111@ulmo>
References: <1378236372-15711-1-git-send-email-mikedunn@newsguy.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Content-Disposition: inline
In-Reply-To: <1378236372-15711-1-git-send-email-mikedunn@newsguy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 03, 2013 at 12:26:12PM -0700, Mike Dunn wrote:
> This patch adds support for controlling an arbitrary number of gpios to t=
he
> pwm-backlight driver.  This was left as a TODO when initial device tree s=
upport
> was added by Thierry a while back.  This functionality replaces the callb=
acks
> that are passed in the platform data for non-DT cases.  Users can avail
> themselves of this feature by adding a 'gpios' property to the 'backlight=
' node.
> When the update_status() callback in backlight_ops runs, the gpios listed=
 in the
> property are asserted/deasserted if the specified brightness is non-zero/=
zero.
>=20
> Tested on a pxa270-based Palm Treo 680.
>=20
> Signed-off-by: Mike Dunn <mikedunn@newsguy.com>
> ---
>=20
> Thanks for looking!
>=20
>  .../bindings/video/backlight/pwm-backlight.txt     |   4 +
>  drivers/video/backlight/pwm_bl.c                   | 128 +++++++++++++++=
+++---
>  2 files changed, 113 insertions(+), 19 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backli=
ght.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.t=
xt
> index 1e4fc72..4583e68 100644
> --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> @@ -14,6 +14,9 @@ Required properties:
>  Optional properties:
>    - pwm-names: a list of names for the PWM devices specified in the
>                 "pwms" property (see PWM binding[0])
> +  - gpios:     An arbitrary number of gpios that must be asserted when t=
he
> +               backlight is on, and de-asserted when off.  They will be =
asserted
> +               in the order they appear, and de-asserted in reverse orde=
r.

Do you have a real setup that actually needs multiple GPIOs? Usually
such a setup requires some kind of timing or other additional constraint
which can't be represented by this simple binding.

Looking at the Palm Treo code it seems like the reason why multiple
GPIOs are needed is because one is to enable the backlight, while the
other is in fact used to enable the LCD panel. I have been working on a
patch series to provide simple panel support, specifically to allow the
separation of backlight and panel power sequencing. Would such a method
work for your use-case as well? The work that I'm doing is somewhat DRM
centric, and I don't think there's a DRM driver for PXA, but perhaps it
would be a good occasion to look at converting the PXA display drivers
to DRM... =3D)

That said, I've had a patch similar to yours in a local tree (in fact in
the same branch as the panel work I've been doing) for quite some time,
which allows a single "enable" GPIO to be specified. I haven't gotten
around to sending it out yet, but I'll do that shortly. The patch is a
little more involved because it exposes the GPIO via platform data as
well and therefore has to update a number of board files, too. While
going over the various board files I found only a single board which can
actually make use of the new functionality (which I also converted in
the patch). Any other cases couldn't be implemented by the simple change
so I suspect they can't either using your proposed binding.

I've been trying for a while to come up with a way to support more use-
cases, and I keep coming back to the same solution. Since the DT binding
for power sequences was shot down some time ago, we probably have to
represent any kind of sequencing in C code. So instead of trying to fit
everything into a single binding, I think a more maintainable solution
would be to create separate drivers for the more complex use-cases. That
could either be done by using separate compatible values within the
pwm-backlight driver or via completely different drivers. In the latter
case we should probably think about exporting some of the pwm-backlight
functionality so that drivers can easily reuse some of the code.

Thierry

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSL1UaAAoJEN0jrNd/PrOhcfwQALBQ7DgM+bzY+NfalVQZktj/
Mupf/Enksv9XOFOB76I5npxaPISzUG98ORQjak4wznL5t/QQj01e8FJCm7aN6YM+
BLdjRYf2tKt4EkUfnn/DNv9+CRFjpS5pNmU82SqknaoJ/V6ZyEJGbiNUhgUkirPo
QVTjKb8tN6qvW3IVsOFUWiO6cQDA0luKmIN9p7yN1NByFVGToVKLTjuI0oi4gXOk
kZeXF2cQF7+jooq1VD5/Q7nDUsUfU5orMhoH6Jiig1TPvAYTRY3EWE8iuOvLcKBU
jaEo43Cd7qNpw7p7Jf8P5oAIudN1ljR1yeFJfuJnbtfTOJxdLX6cHjkjfMrHwctI
7vUSvB+hbK6OAOwW6lR+k2x/e0fPC/gpa3+8GL4hCRRt4dxRCoIK+gAIUnWQ0KMW
NVrRqMJE3q6FzZ7Reise4h/YFLYqMN59UoVi8lxq3vJRmRgtJkH3QNIMFt2y+X8B
Y6kw0K7Cc325nckAhFodYT8PzUVOIMXpn8R5lVWB+ekaNRg08gpZ/AQwptjCzRu4
cc8/Fus88InoL3P1PW1aGHRVv1Xwc/jFfDuKL3uz+vFER3AgNUwAAIg895mURRLu
twIOFCvbwr406ksrRC/I66gzgn29X86scLvj1b3vT90DM+WV7ghMUzAiHlI6dyeU
xI6mv38p5Q5EU6iAAqYE
=lyVK
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--
