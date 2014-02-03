Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbaBCIBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:01:22 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:50878 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaBCIBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:01:21 -0500
Message-ID: <52EF4CCC.8020800@monstr.eu>
Date: Mon, 03 Feb 2014 09:01:16 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Rob Herring <robherring2@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-watchdog@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 07/10] watchdog: xilinx: Fix OF binding
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <26d172891694e4041e73b7dae85a1848adf38034.1391177880.git.michal.simek@xilinx.com> <CAL_JsqJ+Dc9PFVYcxHvLiG9unKQX-kEc1fsYsieyTjf-AN3j=A@mail.gmail.com> <52EF4C6F.8040701@monstr.eu>
In-Reply-To: <52EF4C6F.8040701@monstr.eu>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="SB0ujlLfnp1AWiEVV2dGwKuQhQpIsvjgU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SB0ujlLfnp1AWiEVV2dGwKuQhQpIsvjgU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/03/2014 08:59 AM, Michal Simek wrote:
> On 01/31/2014 06:33 PM, Rob Herring wrote:
>> On Fri, Jan 31, 2014 at 8:18 AM, Michal Simek <michal.simek@xilinx.com=
> wrote:
>>> Use of_property_read_u32 functions to clean OF probing.
>>
>> The subject is a bit misleading as this doesn't really fix anything.
>=20
> fair enough. Will change it.
>=20
>>
>>>
>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>>> ---
>>>
>>>  drivers/watchdog/of_xilinx_wdt.c | 25 ++++++++++---------------
>>>  1 file changed, 10 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_x=
ilinx_wdt.c
>>> index c229cc4..475440a6 100644
>>> --- a/drivers/watchdog/of_xilinx_wdt.c
>>> +++ b/drivers/watchdog/of_xilinx_wdt.c
>>> @@ -147,8 +147,7 @@ static u32 xwdt_selftest(struct xwdt_device *xdev=
)
>>>  static int xwdt_probe(struct platform_device *pdev)
>>>  {
>>>         int rc;
>>> -       u32 *tmptr;
>>> -       u32 *pfreq;
>>> +       u32 pfreq, enable_once;
>>>         struct resource *res;
>>>         struct xwdt_device *xdev;
>>>         bool no_timeout =3D false;
>>> @@ -168,28 +167,24 @@ static int xwdt_probe(struct platform_device *p=
dev)
>>>         if (IS_ERR(xdev->base))
>>>                 return PTR_ERR(xdev->base);
>>>
>>> -       pfreq =3D (u32 *)of_get_property(pdev->dev.of_node,
>>> -                                       "clock-frequency", NULL);
>>> -
>>> -       if (pfreq =3D=3D NULL) {
>>> +       rc =3D of_property_read_u32(pdev->dev.of_node, "clock-frequen=
cy", &pfreq);
>>> +       if (rc) {
>>>                 dev_warn(&pdev->dev,
>>>                          "The watchdog clock frequency cannot be obta=
ined\n");
>>>                 no_timeout =3D true;
>>
>> You can kill this...
>>
>>>         }
>>>
>>> -       tmptr =3D (u32 *)of_get_property(pdev->dev.of_node,
>>> -                                       "xlnx,wdt-interval", NULL);
>>> -       if (tmptr =3D=3D NULL) {
>>> +       rc =3D of_property_read_u32(pdev->dev.of_node, "xlnx,wdt-inte=
rval",
>>> +                                 &xdev->wdt_interval);
>>> +       if (rc) {
>>>                 dev_warn(&pdev->dev,
>>>                          "Parameter \"xlnx,wdt-interval\" not found\n=
");
>>>                 no_timeout =3D true;
>>
>> and this...
>>
>>> -       } else {
>>> -               xdev->wdt_interval =3D *tmptr;
>>>         }
>>>
>>> -       tmptr =3D (u32 *)of_get_property(pdev->dev.of_node,
>>> -                                       "xlnx,wdt-enable-once", NULL)=
;
>>> -       if (tmptr =3D=3D NULL) {
>>> +       rc =3D of_property_read_u32(pdev->dev.of_node, "xlnx,wdt-enab=
le-once",
>>> +                                 &enable_once);
>>> +       if (!rc && enable_once) {
>>>                 dev_warn(&pdev->dev,
>>>                          "Parameter \"xlnx,wdt-enable-once\" not foun=
d\n");
>>>                 watchdog_set_nowayout(xilinx_wdt_wdd, true);
>>> @@ -201,7 +196,7 @@ static int xwdt_probe(struct platform_device *pde=
v)
>>>   */
>>>         if (!no_timeout)
>>
>> and use "if (pfreq && xdev->wdt_interval)" if you initialize pfreq to =
0.
>=20
>=20
> I just wanted to to change functions not logic in the driver.
> But it can be changed too.
>=20
>>>                 xilinx_wdt_wdd->timeout =3D 2 * ((1 << xdev->wdt_inte=
rval) /
>>> -                                         *pfreq);
>>> +                                         pfreq);
>>
>> Is the wdog really usable if the timeout properties are missing? Seems=

>> like you should fail to probe rather than warn.
>=20
> There are 2 things.
> 1. timeout - you don't need pfreq and wdt_interval to use this driver
> but for that there should be module parameter timeout there.
> It should be added.
>=20
> 2. about warn - based on 1 I don't think driver should failed
> but I am looking at logic above which I have added there but should be =
different.
>=20
> u32 enable_once =3D 0;
> if (!rc)
> 	dev_warn
>=20

if (rc) here sorry.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--SB0ujlLfnp1AWiEVV2dGwKuQhQpIsvjgU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLvTMwACgkQykllyylKDCH+SQCgmop3s+GoiLjO0PhSnUO0Dcs2
BdEAn3ry6Ybl+5bmdRfqFBQouBS+6Enn
=h0oC
-----END PGP SIGNATURE-----

--SB0ujlLfnp1AWiEVV2dGwKuQhQpIsvjgU--
