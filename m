Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaHNNav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 09:30:51 -0400
Received: from mail.neotion.com ([5.39.84.84]:39261 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720AbaHNNau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 09:30:50 -0400
Message-ID: <53ECB95F.2030207@neotion.com>
Date: Thu, 14 Aug 2014 15:27:59 +0200
From: =?UTF-8?B?R3LDqWdvcnkgU291dGFkw6k=?= <gsoutade@neotion.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: check EXT_CSD_PARTITION_SETTING_COMPLETED before
 creating partitions
References: <53C7E45E.2060102@neotion.com>	<CAPDyKFoRpQBHGGCMPvEKdeVGjTO-rnyYVostLZGCV3dudD1rmA@mail.gmail.com>	<53EB2DC3.2080002@neotion.com> <CAPDyKFpjYqVUZ8GHB76gD8pOx_eMg9ecvbWrMEfbhEd5ffk7mw@mail.gmail.com>
In-Reply-To: <CAPDyKFpjYqVUZ8GHB76gD8pOx_eMg9ecvbWrMEfbhEd5ffk7mw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="WD8Wf5X3R2cAJC87BdJ0n4Q0mktwiBQFl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WD8Wf5X3R2cAJC87BdJ0n4Q0mktwiBQFl
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le 14/08/2014 13:46, Ulf Hansson a =C3=A9crit :
> On 13 August 2014 11:20, Gr=C3=A9gory Soutad=C3=A9 <gsoutade@neotion.co=
m> wrote:
>> Le 13/08/2014 10:36, Ulf Hansson a =C3=A9crit :
>>> On 17 July 2014 16:57, Gr=C3=A9gory Soutad=C3=A9 <gsoutade@neotion.co=
m> wrote:
>>>> Create MMC general purpose partitions only if
>>>> EXT_CSD_PARTITION_SETTING_COMPLETED bit is set.
>>>> Some tools may set general purpose partition size(s) but fail or sto=
p
>>>> without finalize.
>>>> Another case is to set invalid partition size(s).
>>>>
>>>> Signed-off-by: Gr=C3=A9gory Soutad=C3=A9 <gsoutade@neotion.com>
>>>> ---
>>>>  drivers/mmc/core/mmc.c  |   15 +++++++++++----
>>>>  include/linux/mmc/mmc.h |    2 ++
>>>>  2 files changed, 13 insertions(+), 4 deletions(-)
>>>>
>>>> From commit b6603fe574af289dbe9eb9fb4c540bca04f5a053 in master linux=
 tree.
>>>>
>>>> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
>>>> index 793c6f7..b9fe211 100644
>>>> --- a/drivers/mmc/core/mmc.c
>>>> +++ b/drivers/mmc/core/mmc.c
>>>> @@ -471,10 +471,17 @@ static int mmc_read_ext_csd(struct mmc_card *c=
ard, u8 *ext_csd)
>>>>                                 ext_csd[EXT_CSD_GP_SIZE_MULT + idx *=
 3];
>>>>                                 part_size *=3D (size_t)(hc_erase_grp=
_sz *
>>>>                                         hc_wp_grp_sz);
>>>> -                               mmc_part_add(card, part_size << 19,
>>>> -                                       EXT_CSD_PART_CONFIG_ACC_GP0 =
+ idx,
>>>> -                                       "gp%d", idx, false,
>>>> -                                       MMC_BLK_DATA_AREA_GP);
>>>> +                               if (ext_csd[EXT_CSD_PARTITION_SETTIN=
G_COMPLETED] &
>>>> +                               EXT_CSD_PART_SETTING_COMPLETED) {
>>>
>>> Some minor comments here.
>>>
>>> I think you could move this if statement up and into the previous "if=
"
>>> where we check for "ext_csd[EXT_CSD_PARTITION_SUPPORT] &
>>> EXT_CSD_PART_SUPPORT_PART_EN".
>>>
>>> Additionally, please run checkpatch.
>>>
>>> Kind regards
>>> Uffe
>>
>> Hello,
>>
>> I didn't put the if statement above to warn user in case of bad partit=
ioning.
>> I don't want the kernel to silently ignore this error.
>=20
> Fair enough.
>=20
> Still I am wondering whether hc_erase_grp_sz, hc_wp_grp_sz and
> enhanced_area_en should be updated if
> EXT_CSD_PARTITION_SETTING_COMPLETED isn't set.  That's the case in
> your patch.

I was focused on partitions and I didn't pay attention on enhanced area.

JEDEC says that partitioning implies :
* Configure general purpose partitions attributes and sizes
* Configure enhanced user area offset, attributes and size

and finally set EXT_CSD_PARTITION_SETTING_COMPLETED.

Thus these two parts must checks for setting completed before
computing values.

Plus, "enhanced_area_en" attribute is set whether or not there is an
enhanced area defined. I looked at the code, and the only usage of it
is to set EXT_CSD_ERASE_GROUP_DEF and compute erase size again.
I suggest using "partition_setting_completed" identifier which is common
to the two functions and requires EXT_CSD_ERASE_GROUP_DEF to be set.

If you're ok with that, I'll submit another patch.


Best regards
Gr=C3=A9gory Soutad=C3=A9

>=20
>>
>> checkpatch has been run before sending this patch, I know there are tw=
o lines
>> with two extra characters, but names used here are quite long. I hope =
it will
>> not block upstream inclusion.
>=20
> The mmc_read_ext_csd() is not one of the nicest piece of code, but for
> sure we should not move on making it worse. If you need to move code
> into separate function to prevent checkpatch warnings, please do so.
>=20
> Kind regards
> Uffe
>=20


--WD8Wf5X3R2cAJC87BdJ0n4Q0mktwiBQFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlPsuWAACgkQgTLQuHmJE0HmEwCeNnum2bAI/Yjbt7Ap4U4u/lQ8
/hIAn0S4IyN5RrSlIdo6e02jhOs2HUu9
=lrr9
-----END PGP SIGNATURE-----

--WD8Wf5X3R2cAJC87BdJ0n4Q0mktwiBQFl--
