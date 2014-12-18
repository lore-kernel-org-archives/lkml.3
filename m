Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaLRN7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 08:59:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52165 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbaLRN7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 08:59:09 -0500
Message-ID: <5492DD8B.7040308@ti.com>
Date: Thu, 18 Dec 2014 15:58:35 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Sam Ravnborg <sam@ravnborg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] video/logo: prevent use of logos after they have been
 freed
References: <1418903842-22450-1-git-send-email-tomi.valkeinen@ti.com>	<1418903842-22450-2-git-send-email-tomi.valkeinen@ti.com> <CAMuHMdX9GB_ikDsGNLTgkDuAeRy81a-A9CVAFmX7Taab8_Z=oQ@mail.gmail.com>
In-Reply-To: <CAMuHMdX9GB_ikDsGNLTgkDuAeRy81a-A9CVAFmX7Taab8_Z=oQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="UQh8VEK55w7iAaGVobFcnJONrUJPlVQhc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UQh8VEK55w7iAaGVobFcnJONrUJPlVQhc
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 18/12/14 15:46, Geert Uytterhoeven wrote:
> Hi Tomi,
>=20
> On Thu, Dec 18, 2014 at 12:57 PM, Tomi Valkeinen <tomi.valkeinen@ti.com=
> wrote:
>> If the probe of an fb driver has been deferred due to missing
>> dependencies, and the probe is later ran when a module is loaded, the
>> fbdev framework will try to find a logo to use.
>>
>> However, the logos are __initdata, and have already been freed. This
>> causes sometimes page faults, if the logo memory is not mapped,
>> sometimes other random crashes as the logo data is invalid, and
>> sometimes nothing, if the fbdev decides to reject the logo (e.g. the
>> random value depicting the logo's height is too big).
>>
>> This patch adds a late_initcall function to mark the logos as freed. I=
n
>> reality the logos are freed later, and fbdev probe may be ran between
>> this late_initcall and the freeing of the logos. In that case we will
>> miss drawing the logo, even if it would be possible.
>>
>> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>> ---
>>  drivers/video/logo/logo.c | 17 ++++++++++++++++-
>>  1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/video/logo/logo.c b/drivers/video/logo/logo.c
>> index 940cd196eef5..10fbfd8ab963 100644
>> --- a/drivers/video/logo/logo.c
>> +++ b/drivers/video/logo/logo.c
>> @@ -21,6 +21,21 @@ static bool nologo;
>>  module_param(nologo, bool, 0);
>>  MODULE_PARM_DESC(nologo, "Disables startup logo");
>>
>> +/*
>> + * Logos are located in the initdata, and will be freed in kernel_ini=
t.
>> + * Use late_init to mark the logos as freed to prevent any further us=
e.
>> + */
>> +
>> +static bool logos_freed;
>> +
>> +static int __init fb_logo_late_init(void)
>> +{
>> +       logos_freed =3D true;
>=20
> Just set nologo to true?

That was my first thought, but then I started to wonder if it's possible
that someone would set it to false afterwards. I'm not quite sure how,
as the module_param parsing should happen early. But I just wanted to
play safe.

>=20
>> +       return 0;
>> +}
>> +
>> +late_initcall(fb_logo_late_init);
>=20
> Hmm...
>=20
>> +
>>  /* logo's are marked __initdata. Use __init_refok to tell
>>   * modpost that it is intended that this function uses data
>>   * marked __initdata.
>> @@ -29,7 +44,7 @@ const struct linux_logo * __init_refok fb_find_logo(=
int depth)
>>  {
>>         const struct linux_logo *logo =3D NULL;
>>
>> -       if (nologo)
>> +       if (nologo || logos_freed)
>=20
> A long time ago (ibefore 2.1.124), we used to have a test on initmem_fr=
eed
> here. But that variable no longer exists.

I guess it was removed because it was considered a hack? =3D) The
functions accessing __initdata should be __init.

> Perhaps you can check system_state? That's variable is changed from
> SYSTEM_BOOTING to SYSTEM_RUNNING in kernel_init(), after freeing
> initmem.

Hmm maybe. But there's a time period between free_initmem() and setting
system_state to SYSTEM_RUNNING. Calling fb_find_logo() between those
would again break. I don't know if it's possible for fb_find_logo to be
called there in practice, but... Again, I'd rather play it safe. It's
not nice to debug crashes that happen inside the console code, as you
won't see the crashes on the console.

 Tomi



--UQh8VEK55w7iAaGVobFcnJONrUJPlVQhc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUkt2LAAoJEPo9qoy8lh71PSwP/RBS7lVSdYm/z8J6oK+dxsph
i/Nad5AQx/hZtsE+V5+4rqWD8ca/7sPruXS4SFjV+zV2BKuNGmbzcZ8dvpxXcjHe
+2UsjtgI0HpY0oeISSw6o7mYkAyDVp9BcY3n//GSyjsuLRpiIBsGCVS7O5na+NIS
5A7TwJ9x8kLUnlxdJ1sBbiWZ0K14+Aj5CxbEjX+MVpItu09ExsJHyu73BzEPJoZx
tWlRPFLLEvxUCzBTwL1dvPpCCsxuf2ZHD9S1CC93Z8YGjgfq+Miq5zC8VhSi9/pI
K1szmrTaQq16V3/3Nrfe1ks6MBUtvVboHZaKRlNNZ6uABS3aNJDXqlk1s/z7P4V1
RyPIoZ59+poYpt2ib5b8zKEyLH0oinTZC12Wn5JByy0iwZMX0QBBd5edPl6l7AD7
vL0DKE8wuLCwdx0dW46I23nkk5P28BbUTiD2ov/+SqExKUr5Z086ji0t1pFbywJv
vZR3eHA76kImbzXBMfgu8wSVs4+P29s+AfF3zZtGU/7Z+5b/wHV/YUNy7lrYp2Rj
HRdOfpYgbXtOVBusLBYT285uEE8Gnd6t49DgatsiOpMH+at2w4+Jlm9hiMl5x013
fi2b7Hvv/PpAszcB0XSwMiIOFtovQs7azBzB7TehAB5GAimSzq041/+8DTLsHwnL
QNAKnzPrSSeYV/qaTRSB
=yMA9
-----END PGP SIGNATURE-----

--UQh8VEK55w7iAaGVobFcnJONrUJPlVQhc--
