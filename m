Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab3FTMMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:12:35 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:36582 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab3FTMMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:12:33 -0400
Message-ID: <51C2F1A7.3030805@monstr.eu>
Date: Thu, 20 Jun 2013 14:12:23 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 1/2] GPIO: Add support for dual channel in gpio-xilinx.c
References: <4b90b06fce0475b579cfba4d968b4778359154f6.1369826814.git.michal.simek@xilinx.com> <CACRpkdY4xaCOe28nu-NrYQ7pafjhj8-xqFcJRF9iJUy3SrCVrA@mail.gmail.com> <51A8387C.4030704@monstr.eu> <CACRpkdbHiaK6YPgXyxNgEeZxAsddK4x0vS-q3YfyXnj_BgHvuw@mail.gmail.com> <51A852A1.7020505@monstr.eu> <CACRpkdbL4pqiF8zxMi28SRTJ9AESiFt0wJMhK1oBio_cfFhpsQ@mail.gmail.com> <51C2B47A.6010906@monstr.eu> <CACRpkdbWXFLgcUJ-gcUArRotJMoX4JBU9mmheooJBWsLR=QHOA@mail.gmail.com> <51C2E0AF.7040702@monstr.eu> <CACRpkdbcq+e099mT+TVwv9vDjXwkf8QdB_4b4UXuysPF+40oUQ@mail.gmail.com>
In-Reply-To: <CACRpkdbcq+e099mT+TVwv9vDjXwkf8QdB_4b4UXuysPF+40oUQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2WUFJARIDAAPIAEFTGAQT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2WUFJARIDAAPIAEFTGAQT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/20/2013 01:33 PM, Linus Walleij wrote:
> On Thu, Jun 20, 2013 at 12:59 PM, Michal Simek <monstr@monstr.eu> wrote=
:
>> On 06/20/2013 11:23 AM, Linus Walleij wrote:
>=20
>>> What about something like this:
>>>
>>> static bool is_dual (struct device_node *np)
>>> {
>>>     struct property *prop =3D of_find_property(np, "xlnx,is-dual", NU=
LL);
>>>     int ret;
>>>     u32 val;
>>>
>>>     if (!prop)
>>>         return false;
>>>
>>>     ret =3D of_property_read_u32(np, "xlnx,is-dual", &val);
>>>     if (ret < 0)
>>>         return true; /* node exists but has no cells */
>>>
>>>     return !!val;
>>> }
>>
>> we can do it in this way but what I don't like on this is that IP
>> is design to support 2 channels right now.
>> It can happen that Xilinx decides to extend this for new channels.
>> Register map is prepared for it and there is enough space to do it.
>>
>> And when this is done then is-dual (which is current name which
>> is used in hardware configuration from design tools) will contain
>> larger value >1.
>> I agree that is-dual is not the best name.
>=20
> You don't say. It's about as smart as this:
>=20
> #define NUMBER_TWO 4
>=20
> Oh well, that's not your fault.
>=20
> But seriously:
>=20
>   xlnx,is-dual;
>=20
> without an argument can still be taken to mean "2", and
> you still need to inperpret the absence if this parameter
> as "1" do you not?
>
>> What about to do it differently?
>> Generate number of channel in the description.
>> And also do for() loop in the probe function to read values based
>> on this channel number.
>=20
> Sorry I can't translate this, can you send a patch?

Sure.

xlnx,is-dual is always present in the HW and in all DTSes and it
is generated for several years

Based on my experience with hardware guys what happen when they add
new channel is that they will use xlnx,is-dual =3D 2 for 3 channels,
xlnx,is-dual =3D 3 for 4 channels, etc. They won't care about names
but they are working like that.

It means for me is really problematic it try to work with this
value as boolean even that name is confusing.

That's why it is much easier for me to start to use new property
which will describe number of channels but this value is not
used in design tools. Let's say number-of-channels =3D 1 or 2
in DT binding which will describe number channels in this IP.
Is this acceptable for you?



If you look how that dual channel is supported you will see that it is
probe_first_channel
if there is second channel probe it too.

And code there is very similar.
That's why I am thinking about using the loop to remove that code
duplication.
Something like this in "psedo code"

for(i =3D 0; i < number-of-channel; i++) {
	char *str_def =3D "xlnx,dout-default"
	if(i)
		add -(i+1) suffix to str_def (-2 for example just to reflect how design=
 tools generates it)
	=09
	of_property_read_u32(np, str_def, &chip->gpio_state);
=2E..
	gpiochip_add()
}

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2WUFJARIDAAPIAEFTGAQT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHC8acACgkQykllyylKDCFfPwCfTMK8J97m4QyuGWHLamLbuNB/
U5cAoJuSCTgKEnkO+zUtaO4Vw7yWUSw7
=zZnN
-----END PGP SIGNATURE-----

------enig2WUFJARIDAAPIAEFTGAQT--
