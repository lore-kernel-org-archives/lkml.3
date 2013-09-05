Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763536Ab3IEIOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:14:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51590 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab3IEIOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:14:50 -0400
Message-ID: <52283CD0.9010108@ti.com>
Date: Thu, 5 Sep 2013 11:12:00 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: James Bates <james.h.bates@gmail.com>
CC: David Herrmann <dh.herrmann@gmail.com>, Peter Jones <pjones@redhat.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2] efifb: prevent null dereferences by removing unused
 array indices from dmi_list
References: <C9C6655E-4974-4C04-8CEE-CA16563F4CC5@gmail.com>  <CANq1E4STAFLpDoyLHxXVXqk7mjzmBr1jO3XuxL2B+cJzgHe0vA@mail.gmail.com> <1376684395.6529.5.camel@hermes>
In-Reply-To: <1376684395.6529.5.camel@hermes>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="oibh6ujoCACp88hREU1D2lFjli1IGUff2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oibh6ujoCACp88hREU1D2lFjli1IGUff2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi James,

Can you resend this? I don't know how I could apply the patch from this
mail without re-creating it manually.

 Tomi

On 16/08/13 23:19, James Bates wrote:
> On Fri, 2013-08-16 at 15:37 +0200, David Herrmann wrote:
>> Hi
>> (CC'ing hpa)
>>
>> Yepp, this patch looks good:
>> Reviewed-by: David Herrmann <dh.herrmann@gmail.com <mailto:dh.herrmann=
@gmail.com>>
>>
>> However, I'd like to see some code to prevent this from happening
>> again. It isn't really obvious that removing an entry will result in a=

>> NULL-deref. I am not the maintainer of this code, but I'd really like
>> to see a "(dmi_list[i].optname && !strcmp())" check in efifb_setup().
>> Otherwise we _will_ run into this again.
>>
>> Side note: this code got moved to arch/x86/kernel/sysfb_efi.c in the
>> x86 tree. I am adding hpa here so he will remember this once Linus
>> gets a merge conflict (iff the sysfb changes get merged through the
>> x86 tree).
>>
>> Thanks
>> David
> Sure thing, here is the patch again, with the extra check in
> efifb_setup() (it turns out one can simply
> switch around the order of the checks: implicitly initialized dmi_list
> items will have base =3D=3D 0):
>=20
> Full patch v2:
> the dmi_list array is initialized using gnu designated initializers, an=
d
> therefore
> contains fewer explicitly defined entries as there are elements in it. =
This
> is because the enum above with M_blabla constants contains more items
> than the designated
> initializer. Those elements not explicitly initialized are implicitly
> set to 0.
>=20
> Now efifb_setup(), L.322 & L.323, loops through all these array
> elements, and performs
> a strcmp o a field (optname) in each item. For non explicitly
> initialized elements this
> will be a null pointer:
>=20
>                         for (i =3D 0; i < M_UNKNOWN; i++) {
>                                 if (!strcmp(this_opt,
> dmi_list[i].optname) &&
>=20
> On my macbook6,1 the predefined values are for some reason incorrect,
> and most parameters
> are preset correctly by my efi bootloader (elilo). but
> stride/line_length is not detected
> correctly and so I wish to set it explicitly using a
> "video=3Defifb:stride:2048" command-line
> argument. Because of the above null dereference, an exception
> (presumably) occurs before
> the parsing code (L.333) is ever reached. I say presumably since the ma=
c
> hangs on boot
> without a console, and I can therefore not see any output.
>=20
> By removing the unused values from the enum, and thus preventing
> implicitly initialized items
> in the dmi_list array, the null dereference does not occur, my customer=

> command-line arg is
> parsed correctly, and my console displays correctly.
>=20
> This patch removes the unused enum values, and also guards against any
> future implicit
> initializing by inverting the check order in the if statement, and
> checking first whether
> dmi_list[i].base is null.
>=20
> Signed-off-by: James Bates <james.h.bates@yahoo.com
> <mailto:james.h.bates@yahoo.com>>
> ---
> drivers/video/efifb.c | 7 ++-----
> 1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
> index 50fe668..161757b 100644
> --- a/drivers/video/efifb.c
> +++ b/drivers/video/efifb.c
> @@ -50,12 +50,9 @@ enum {
> M_MINI_3_1, /* Mac Mini, 3,1th gen */
> M_MINI_4_1, /* Mac Mini, 4,1th gen */
> M_MB, /* MacBook */
> - M_MB_2, /* MacBook, 2nd rev. */
> - M_MB_3, /* MacBook, 3rd rev. */
> M_MB_5_1, /* MacBook, 5th rev. */
> M_MB_6_1, /* MacBook, 6th rev. */
> M_MB_7_1, /* MacBook, 7th rev. */
> - M_MB_SR, /* MacBook, 2nd gen, (Santa Rosa) */
> M_MBA, /* MacBook Air */
> M_MBA_3, /* Macbook Air, 3rd rev */
> M_MBP, /* MacBook Pro */
> @@ -323,8 +320,8 @@ static int __init efifb_setup(char *options)
> if (!*this_opt) continue;
>=20
> for (i =3D 0; i < M_UNKNOWN; i++) {
> - if (!strcmp(this_opt, dmi_list[i].optname) &&
> -     dmi_list[i].base !=3D 0) {
> + if (dmi_list[i].base !=3D 0 &&
> +     !strcmp(this_opt, dmi_list[i].optname)) {
> screen_info.lfb_base =3D dmi_list[i].base;
> screen_info.lfb_linelength =3D dmi_list[i].stride;
> screen_info.lfb_width =3D dmi_list[i].width;
> --=20
>=20



--oibh6ujoCACp88hREU1D2lFjli1IGUff2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSKDzQAAoJEPo9qoy8lh71/xIQAJWKMyeBnxTZ4aMwwDShFYqu
u00uv5IIgtnvnFwq9fS/8Njdjb2uPh7aaOz9GWIPAP4mMy/rfJ5ZQTlN4kraj9/Y
/l+zPVqW1JfOR5K0Olk2byEmHKIXMEzxzshlgXDFlOcHcbGv2tgPkyYIrolEvfKU
8d04/Is0NRbTihVxyoFHnOJ9SM2u2+TAgGBNqZfnSfJqMAGbgDJT8DxS/4l21wG6
Km178mLW/6zPrUVx7Xx+tIrBQQJU6FHZ2ENrQ2+DUCejKo7BIs5GWkMOjGjBqM73
IK8R2Q8neqPtB/q/wtWsSYEJq2t5iVmfNLXCYhBINIwERIMDTXsUodz9ILM6a0Nv
fFB8IBIQhDpY0BNTmNcO+ekoav27R67y3S0a+KYxkH1ZOb6u1g3+e2iexN4hcG0o
iSMAaYxG0IAmjg2PF961MWjeimWyPioaiBV90kcRu4vmLATIZJ5biPRZ9guNXe12
Z6oHtrF+btI8caZiyNcpfDiarilHwjna1i1S6pW1/wXc03osXl709ydPwKLYPP3f
VR1Kgxwicata43G3OncTtD2/Ow8idwpriGgkTu3LX4RG4Fx9C6ycQF8syW1COb8G
NXEuKiPTahR5NgTkbCs5uTeuolySCUI4p+XKxMTXDyc1B88jh1Jj42sLC/IUuHxd
CK6Q9kLl3C4ejx3T6quW
=BPn0
-----END PGP SIGNATURE-----

--oibh6ujoCACp88hREU1D2lFjli1IGUff2--
