Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013AbaBCH7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 02:59:50 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:58685 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaBCH7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 02:59:48 -0500
Message-ID: <52EF4C6F.8040701@monstr.eu>
Date: Mon, 03 Feb 2014 08:59:43 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-watchdog@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 07/10] watchdog: xilinx: Fix OF binding
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <26d172891694e4041e73b7dae85a1848adf38034.1391177880.git.michal.simek@xilinx.com> <CAL_JsqJ+Dc9PFVYcxHvLiG9unKQX-kEc1fsYsieyTjf-AN3j=A@mail.gmail.com>
In-Reply-To: <CAL_JsqJ+Dc9PFVYcxHvLiG9unKQX-kEc1fsYsieyTjf-AN3j=A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="SpFVoNmCUuBv3h8LOJ9KMuql3WrHJNOGg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SpFVoNmCUuBv3h8LOJ9KMuql3WrHJNOGg
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/31/2014 06:33 PM, Rob Herring wrote:
> On Fri, Jan 31, 2014 at 8:18 AM, Michal Simek <michal.simek@xilinx.com>=
 wrote:
>> Use of_property_read_u32 functions to clean OF probing.
>=20
> The subject is a bit misleading as this doesn't really fix anything.

fair enough. Will change it.

>=20
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>>  drivers/watchdog/of_xilinx_wdt.c | 25 ++++++++++---------------
>>  1 file changed, 10 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xi=
linx_wdt.c
>> index c229cc4..475440a6 100644
>> --- a/drivers/watchdog/of_xilinx_wdt.c
>> +++ b/drivers/watchdog/of_xilinx_wdt.c
>> @@ -147,8 +147,7 @@ static u32 xwdt_selftest(struct xwdt_device *xdev)=

>>  static int xwdt_probe(struct platform_device *pdev)
>>  {
>>         int rc;
>> -       u32 *tmptr;
>> -       u32 *pfreq;
>> +       u32 pfreq, enable_once;
>>         struct resource *res;
>>         struct xwdt_device *xdev;
>>         bool no_timeout =3D false;
>> @@ -168,28 +167,24 @@ static int xwdt_probe(struct platform_device *pd=
ev)
>>         if (IS_ERR(xdev->base))
>>                 return PTR_ERR(xdev->base);
>>
>> -       pfreq =3D (u32 *)of_get_property(pdev->dev.of_node,
>> -                                       "clock-frequency", NULL);
>> -
>> -       if (pfreq =3D=3D NULL) {
>> +       rc =3D of_property_read_u32(pdev->dev.of_node, "clock-frequenc=
y", &pfreq);
>> +       if (rc) {
>>                 dev_warn(&pdev->dev,
>>                          "The watchdog clock frequency cannot be obtai=
ned\n");
>>                 no_timeout =3D true;
>=20
> You can kill this...
>=20
>>         }
>>
>> -       tmptr =3D (u32 *)of_get_property(pdev->dev.of_node,
>> -                                       "xlnx,wdt-interval", NULL);
>> -       if (tmptr =3D=3D NULL) {
>> +       rc =3D of_property_read_u32(pdev->dev.of_node, "xlnx,wdt-inter=
val",
>> +                                 &xdev->wdt_interval);
>> +       if (rc) {
>>                 dev_warn(&pdev->dev,
>>                          "Parameter \"xlnx,wdt-interval\" not found\n"=
);
>>                 no_timeout =3D true;
>=20
> and this...
>=20
>> -       } else {
>> -               xdev->wdt_interval =3D *tmptr;
>>         }
>>
>> -       tmptr =3D (u32 *)of_get_property(pdev->dev.of_node,
>> -                                       "xlnx,wdt-enable-once", NULL);=

>> -       if (tmptr =3D=3D NULL) {
>> +       rc =3D of_property_read_u32(pdev->dev.of_node, "xlnx,wdt-enabl=
e-once",
>> +                                 &enable_once);
>> +       if (!rc && enable_once) {
>>                 dev_warn(&pdev->dev,
>>                          "Parameter \"xlnx,wdt-enable-once\" not found=
\n");
>>                 watchdog_set_nowayout(xilinx_wdt_wdd, true);
>> @@ -201,7 +196,7 @@ static int xwdt_probe(struct platform_device *pdev=
)
>>   */
>>         if (!no_timeout)
>=20
> and use "if (pfreq && xdev->wdt_interval)" if you initialize pfreq to 0=
=2E


I just wanted to to change functions not logic in the driver.
But it can be changed too.

>>                 xilinx_wdt_wdd->timeout =3D 2 * ((1 << xdev->wdt_inter=
val) /
>> -                                         *pfreq);
>> +                                         pfreq);
>=20
> Is the wdog really usable if the timeout properties are missing? Seems
> like you should fail to probe rather than warn.

There are 2 things.
1. timeout - you don't need pfreq and wdt_interval to use this driver
but for that there should be module parameter timeout there.
It should be added.

2. about warn - based on 1 I don't think driver should failed
but I am looking at logic above which I have added there but should be di=
fferent.

u32 enable_once =3D 0;
if (!rc)
	dev_warn

if (enable_once)
	watchdog_set_nowayout(xilinx_wdt_wdd, true);

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--SpFVoNmCUuBv3h8LOJ9KMuql3WrHJNOGg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLvTG8ACgkQykllyylKDCHtvgCfWgMVEK9E2Hcf6AqXDlemSKqS
/w0An359q1s2nK6PeSSpLyHwtQdJw312
=qMJe
-----END PGP SIGNATURE-----

--SpFVoNmCUuBv3h8LOJ9KMuql3WrHJNOGg--
