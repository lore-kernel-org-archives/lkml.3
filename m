Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaG2KZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:25:41 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:60801 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaG2KZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:25:39 -0400
Date: Tue, 29 Jul 2014 12:25:33 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: caesar <caesar.wang@rock-chips.com>, linux-pwm@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] pwm: add this patch to support the new pwm of
 Rockchip SoCs
Message-ID: <20140729102531.GD21182@ulmo.nvidia.com>
References: <1405774529-26027-1-git-send-email-caesar.wang@rock-chips.com>
 <1405774529-26027-3-git-send-email-caesar.wang@rock-chips.com>
 <20140721085001.GG8843@ulmo>
 <53CD0E82.6030901@rock-chips.com>
 <20140721132723.GH15238@ulmo>
 <53D23192.4000908@rock-chips.com>
 <CAD=FV=XLjYQYmHxp3HBdwVmt6Wa7y-LEnsFKobsgVfFCp2-rRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
Content-Disposition: inline
In-Reply-To: <CAD=FV=XLjYQYmHxp3HBdwVmt6Wa7y-LEnsFKobsgVfFCp2-rRg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 26, 2014 at 09:59:35PM -0700, Doug Anderson wrote:
> caesar,
>=20
> On Fri, Jul 25, 2014 at 3:29 AM, caesar <caesar.wang@rock-chips.com> wrot=
e:
> > Hi Thierry,
> >
> >
> >
> >
> > =E5=9C=A8 2014=E5=B9=B407=E6=9C=8821=E6=97=A5 21:27, Thierry Reding =E5=
=86=99=E9=81=93:
> >>
> >> On Mon, Jul 21, 2014 at 08:58:42PM +0800, caesar wrote:
> >>
> >>> =E4=BA=8E 2014=E5=B9=B407=E6=9C=8821=E6=97=A5 16:50, Thierry Reding =
=E5=86=99=E9=81=93:
> >>>>
> >>>> On Sat, Jul 19, 2014 at 08:55:29PM +0800, Caesar Wang wrote:
> >>
> >> [...]
> >>>>>
> >>>>>         struct rockchip_pwm_chip *pc;
> >>>>>         struct resource *r;
> >>>>>         int ret;
> >>>>> @@ -119,7 +182,10 @@ static int rockchip_pwm_probe(struct
> >>>>> platform_device *pdev)
> >>>>>                 return -ENOMEM;
> >>>>>         r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >>>>> -       pc->base =3D devm_ioremap_resource(&pdev->dev, r);
> >>>>> +       if (!strcmp(of_id->compatible, "rockchip,vop-pwm"))
> >>>>> +               pc->base =3D devm_ioremap(&pdev->dev, r->start,
> >>>>> resource_size(r));
> >>>>> +       else
> >>>>> +               pc->base =3D devm_ioremap_resource(&pdev->dev, r);
> >>>>
> >>>> Sorry, this still isn't an option. You really shouldn't remap I/O
> >>>> regions that other drivers may be using. You hinted at a shared regi=
ster
> >>>> space during the review of the initial version. Can you provide more
> >>>> detail about what exactly the memory map looks like of the rk3288? Is
> >>>> there some kind of technical reference manual that I could look at? =
Or
> >>>> do you have a device tree extract that shows what the memory map loo=
ks
> >>>> like?
> >>>>
> >>>> Thierry
> >>>
> >>> Maybe,you can look at the ARM: dts: rk3288:
> >>>
> >>> https://github.com/rkchrome/kernel/blob/master/arch/arm/boot/dts/rk32=
88.dtsi
> >>> There is some lcdc and vop-pwm map address for rk3288.
> >>>
> >>> ,and you can look at the vop-introduce.pdf and vop-register.pdf in An=
nex.
> >>>
> >>> Maybe,I should put the vop-pwm in lcdc driver,but I don't hope do so =
it.
> >>>
> >>> Could you give a suggestion to solve it? Thanks.
> >>
> >> It looks like you could turn the lcdc device into an MFD device so that
> >> it can instantiate two devices, one for the display controller, the
> >> other for the PWM. Or perhaps it would even work with only a single
> >> child device.
> >>
> >> The device tree would become something like this:
> >>
> >>         lcdc@ff930000 {
> >>                 compatible =3D "rockchip,rk3288-lcdc";
> >>                 ...
> >>
> >>                 pwm@ff9301a0 {
> >>                         compatible =3D "rockchip,vop-pwm";
> >>                         ...
> >>                 };
> >>         };
> >>
> >> And your driver would do something like:
> >>
> >>         static const struct resource pwm_resources[] =3D {
> >>                 {
> >>                         .start =3D 0x1a0,
> >>                         .end =3D 0x1af,
> >>                         .flags =3D IORESOURCE_MEM,
> >>                 },
> >>         };
> >>
> >>         static const struct mfd_cell subdevices[] =3D {
> >>                 {
> >>                         .name =3D "pwm",
> >>                         .id =3D 1,
> >>                         .of_compatible =3D "rockchip,vop-pwm",
> >>                         .num_resources =3D ARRAY_SIZE(pwm_resources),
> >>                         .resources =3D pwm_resources,
> >>                 },
> >>         };
> >>
> >>         static int lcdc_probe(struct platform_device *pdev)
> >>         {
> >>                 struct resource *regs;
> >>                 ...
> >>
> >>                 regs =3D platform_get_resource(pdev, IORESOURCE_MEM, 0=
);
> >>
> >>                 ...
> >>
> >>                 err =3D mfd_add_devices(&pdev->dev, 0, subdevices,
> >> ARRAY_SIZE(subdevices),
> >>                                       regs, NULL, NULL);
> >>                 ...
> >>         }
> >>
> >> Thierry
> >
> > Sorry,I might a little trouble for the changes.
> >
> > The driver changes only for lcdc? If that is the case,I suddenly don't =
know
> > how to do it ?
> >
> > Maybe,I didn't say it clearly.
> >
> > lcdc0: lcdc@ff930000                   |     vop0pwm: pwm@ff9301a0
> > reg =3D <0xff930000 0x10000>     |      reg =3D <0xff9301a0 0x10>;
> >
> > The lcdc has to add resource's address  from  0xff930000 to 0xff93ffff.
> >
> > When the  pwm driver is loading vop0pwm. the "devm_ioremap_resource()" =
will
> > be used in probe();
> >
> > I think it will be occur a fail. because the resource [mem
> > 0xff9301a0-0xff9301af] has be requested by lcdc.
> > =3D>rockchip-pwm ff9301a0.pwm: can't request region for resource [mem
> > 0xff9301a0-0xff9301af]
> >
> > If I do the changes in pwm driver,do you have a other suggestion for it?
> > thanks.:-)
>=20
> Sorry if this is stupid (and I haven't tried it), but does "ranges"
> help solve this problem?  AKA:
>=20
>          lcdc@ff930000 {
>                  compatible =3D "rockchip,rk3288-lcdc";
>                  reg =3D <0xff930000 0x10000>;
>                  #address-cells =3D <2>;
>                  #size-cells =3D <1>;
>                  ranges =3D <0 0xff9301a0 0x10>;
>                  ...
>=20
>                  pwm@0,0 {
>                          compatible =3D "rockchip,vop-pwm";
>                          reg =3D <0 0 0x10>;
>                         ...
>                  };
>          };
>=20
> Does that avoid the failure?  The lcdc driver would need to call
> of_platform_populate() to make the PWM show up.

If you add "simple-bus" to the lcdc compatible string, like so:

	lcdc@ff930000 {
		compatible =3D "rockchip,rk3288-lcdc", "simple-bus";
		...
	};

Then of_platform_populate() will be called automatically.

Thierry

--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT13abAAoJEN0jrNd/PrOhz6MP/3C1Dd3tph6fbbojX+FR4tqu
9Sw+12Ahz4GunoHUDWCVRXsGp0QqyA7nXxDwrLfU8e0mTvXPSEDmbjU1CBM0qeB7
6HvBzEt0JhK5br/1O7YJXcIFMpBR9J/hXbzmeQE4fly8aYffdQGjJvsKOqjIGC8p
akNONdv2tIw3WwekP6kygVF1qs+jh/ZDdfpPm4cUVLGw+GfUmhTEsPiM+2bRGrTO
lB0axYwKnB9C58hCVjOeAlVJ92jB2xZQ9iZe78sMjPKdLedsoJo2iTJ6lE59yMND
dhSAD3amQb2DkSVXsWyFKjzw7/fmdrDsREsvLQwhyTq04pSlQoFbG5ncStXp/IQx
oKPRT49v7opbHWlIvZ0sq/QbozEaUc6tScweXIKrWPuk8OMVLUJo/VUnnHkUcMrE
wVy6Cbu3jqaDTRIVJvwUJCWZz7Pvmg91s/wT3zEUYu2ZLRSYKs9LNzOel2a/joPC
dEfXBEt190rlwWSVDYbz+7iuN8MbxrP9vIrZK6Bmev4p/EO+xgSQuzgipvrSuux+
rmj8dCqRVSHvy6MoXQl15cR3bolcYDsN00tech4wrmX7DPrZZFvP7EHnokzQUDdq
UvKzwx72DqjrOUG5HfCY/Ph0OxUSAkLAhNbEVMkCrN4lAfetIg7nfPgbfhGsAFzo
4nbBjKei9JGcv6IPHs5t
=YNhs
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
