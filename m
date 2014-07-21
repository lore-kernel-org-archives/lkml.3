Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbaGUN1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:27:32 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41272 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaGUN1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:27:30 -0400
Date: Mon, 21 Jul 2014 15:27:24 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: caesar <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, b.galvani@gmail.com, cf@rock-chips.com,
        huangtao@rock-chips.com, addy.ke@rock-chips.com, xjq@rock-chips.com,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] pwm: add this patch to support the new pwm of
 Rockchip SoCs
Message-ID: <20140721132723.GH15238@ulmo>
References: <1405774529-26027-1-git-send-email-caesar.wang@rock-chips.com>
 <1405774529-26027-3-git-send-email-caesar.wang@rock-chips.com>
 <20140721085001.GG8843@ulmo>
 <53CD0E82.6030901@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aF3LVLvitz/VQU3c"
Content-Disposition: inline
In-Reply-To: <53CD0E82.6030901@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aF3LVLvitz/VQU3c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2014 at 08:58:42PM +0800, caesar wrote:
> =E4=BA=8E 2014=E5=B9=B407=E6=9C=8821=E6=97=A5 16:50, Thierry Reding =E5=
=86=99=E9=81=93:
> >On Sat, Jul 19, 2014 at 08:55:29PM +0800, Caesar Wang wrote:
[...]
> >>  	struct rockchip_pwm_chip *pc;
> >>  	struct resource *r;
> >>  	int ret;
> >>@@ -119,7 +182,10 @@ static int rockchip_pwm_probe(struct platform_devi=
ce *pdev)
> >>  		return -ENOMEM;
> >>  	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >>-	pc->base =3D devm_ioremap_resource(&pdev->dev, r);
> >>+	if (!strcmp(of_id->compatible, "rockchip,vop-pwm"))
> >>+		pc->base =3D devm_ioremap(&pdev->dev, r->start, resource_size(r));
> >>+	else
> >>+		pc->base =3D devm_ioremap_resource(&pdev->dev, r);
> >Sorry, this still isn't an option. You really shouldn't remap I/O
> >regions that other drivers may be using. You hinted at a shared register
> >space during the review of the initial version. Can you provide more
> >detail about what exactly the memory map looks like of the rk3288? Is
> >there some kind of technical reference manual that I could look at? Or
> >do you have a device tree extract that shows what the memory map looks
> >like?
> >
> >Thierry
> Maybe,you can look at the ARM: dts: rk3288:
> https://github.com/rkchrome/kernel/blob/master/arch/arm/boot/dts/rk3288.d=
tsi
> There is some lcdc and vop-pwm map address for rk3288.
>=20
> ,and you can look at the vop-introduce.pdf and vop-register.pdf in Annex.
>=20
> Maybe,I should put the vop-pwm in lcdc driver,but I don't hope do so it.
>=20
> Could you give a suggestion to solve it? Thanks.

It looks like you could turn the lcdc device into an MFD device so that
it can instantiate two devices, one for the display controller, the
other for the PWM. Or perhaps it would even work with only a single
child device.

The device tree would become something like this:

	lcdc@ff930000 {
		compatible =3D "rockchip,rk3288-lcdc";
		...

		pwm@ff9301a0 {
			compatible =3D "rockchip,vop-pwm";
			...
		};
	};

And your driver would do something like:

	static const struct resource pwm_resources[] =3D {
		{
			.start =3D 0x1a0,
			.end =3D 0x1af,
			.flags =3D IORESOURCE_MEM,
		},
	};

	static const struct mfd_cell subdevices[] =3D {
		{
			.name =3D "pwm",
			.id =3D 1,
			.of_compatible =3D "rockchip,vop-pwm",
			.num_resources =3D ARRAY_SIZE(pwm_resources),
			.resources =3D pwm_resources,
		},
	};

	static int lcdc_probe(struct platform_device *pdev)
	{
		struct resource *regs;
		...

		regs =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);

		...

		err =3D mfd_add_devices(&pdev->dev, 0, subdevices, ARRAY_SIZE(subdevices),
				      regs, NULL, NULL);
		...
	}

Thierry

--aF3LVLvitz/VQU3c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzRU7AAoJEN0jrNd/PrOh7dsQAInTbWuoVW/K6x4oJpJT6TsB
YXX6rYenM499oYxtEpNz2V3Ltqf8LicHhudYJw2i91D22nI1HhfT5NsmB/uFq0A8
bz84w3JPT2CxKXClojizSX9B5P7c+hzf3CY7U7FFhjeWRW0Q5736Z597VEdO4KQq
q+QQWyT5d3j+0qKREXu6rdsJUxBCyPiIKKddOpX8pqUAn8m1w88chV2EN+KfEA8M
GERcBT4bclynWsF/Z/ZL1K1a57YjkjQtS1M7Gf5zIMXd+j1gKD2ltAEUqEasiLDM
F1YcTXg6I90Jt+9DVs1kEKmu0Aeq49JbupYigymBG/bOnfwGRoyKheanwDrpE0I1
P+71iSHTLn0BHsapmNIH66ghw1DNs90JtRNPEw7nvBnt9ASsifgpSCESaNbMpw1S
+Q+DixTVao0Z6TBOcdt/a1dCRIKQi7IzH7H73J8ucX8+GB2vxRJvmt1iaXHcySK1
U4VElUaI4w1+0OtO3VqzD0jn7Py/lISqhEQoyo8dTEWoKs9HxdiPosWGHgm2rr3A
fiND2DG1sQieA/qykvUxFrkT4cVoAybXP9c9qix+IGQXyNKr5AtXCDNWrOdnZJM2
qKy0odtnSx5O8S0xZFl9KodBU2C8KxtvhPgMqM/b/b9KZUVFSobj/to7Uwq1xTOn
Ae5SCfKGE8vYoJM5jhAz
=OU1H
-----END PGP SIGNATURE-----

--aF3LVLvitz/VQU3c--
