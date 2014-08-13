Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaHMJWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:22:54 -0400
Received: from mail.neotion.com ([5.39.84.84]:47949 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaHMJWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:22:53 -0400
Message-ID: <53EB2DC3.2080002@neotion.com>
Date: Wed, 13 Aug 2014 11:20:03 +0200
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
References: <53C7E45E.2060102@neotion.com> <CAPDyKFoRpQBHGGCMPvEKdeVGjTO-rnyYVostLZGCV3dudD1rmA@mail.gmail.com>
In-Reply-To: <CAPDyKFoRpQBHGGCMPvEKdeVGjTO-rnyYVostLZGCV3dudD1rmA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="F2OtWnTpmtWc3U43XaW4DN355ddBSqWqf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--F2OtWnTpmtWc3U43XaW4DN355ddBSqWqf
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le 13/08/2014 10:36, Ulf Hansson a =C3=A9crit :
> On 17 July 2014 16:57, Gr=C3=A9gory Soutad=C3=A9 <gsoutade@neotion.com>=
 wrote:
>> Create MMC general purpose partitions only if
>> EXT_CSD_PARTITION_SETTING_COMPLETED bit is set.
>> Some tools may set general purpose partition size(s) but fail or stop
>> without finalize.
>> Another case is to set invalid partition size(s).
>>
>> Signed-off-by: Gr=C3=A9gory Soutad=C3=A9 <gsoutade@neotion.com>
>> ---
>>  drivers/mmc/core/mmc.c  |   15 +++++++++++----
>>  include/linux/mmc/mmc.h |    2 ++
>>  2 files changed, 13 insertions(+), 4 deletions(-)
>>
>> From commit b6603fe574af289dbe9eb9fb4c540bca04f5a053 in master linux t=
ree.
>>
>> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
>> index 793c6f7..b9fe211 100644
>> --- a/drivers/mmc/core/mmc.c
>> +++ b/drivers/mmc/core/mmc.c
>> @@ -471,10 +471,17 @@ static int mmc_read_ext_csd(struct mmc_card *car=
d, u8 *ext_csd)
>>                                 ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3=
];
>>                                 part_size *=3D (size_t)(hc_erase_grp_s=
z *
>>                                         hc_wp_grp_sz);
>> -                               mmc_part_add(card, part_size << 19,
>> -                                       EXT_CSD_PART_CONFIG_ACC_GP0 + =
idx,
>> -                                       "gp%d", idx, false,
>> -                                       MMC_BLK_DATA_AREA_GP);
>> +                               if (ext_csd[EXT_CSD_PARTITION_SETTING_=
COMPLETED] &
>> +                               EXT_CSD_PART_SETTING_COMPLETED) {
>=20
> Some minor comments here.
>=20
> I think you could move this if statement up and into the previous "if"
> where we check for "ext_csd[EXT_CSD_PARTITION_SUPPORT] &
> EXT_CSD_PART_SUPPORT_PART_EN".
>=20
> Additionally, please run checkpatch.
>=20
> Kind regards
> Uffe

Hello,

I didn't put the if statement above to warn user in case of bad partition=
ing.
I don't want the kernel to silently ignore this error.

checkpatch has been run before sending this patch, I know there are two l=
ines
with two extra characters, but names used here are quite long. I hope it =
will
not block upstream inclusion.


Best regards
Gr=C3=A9gory Soutad=C3=A9

>=20
>> +                                       mmc_part_add(card, part_size <=
< 19,
>> +                                               EXT_CSD_PART_CONFIG_AC=
C_GP0 + idx,
>> +                                               "gp%d", idx, false,
>> +                                               MMC_BLK_DATA_AREA_GP);=

>> +                               } else {
>> +                                       pr_warn("%s: has partition siz=
e defined, but setting is not complete\n",
>> +                                               mmc_hostname(card->hos=
t));
>> +                                       break;
>> +                               }
>>                         }
>>                 }
>>                 card->ext_csd.sec_trim_mult =3D
>> diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
>> index 64ec963..78753bc 100644
>> --- a/include/linux/mmc/mmc.h
>> +++ b/include/linux/mmc/mmc.h
>> @@ -281,6 +281,7 @@ struct _mmc_csd {
>>  #define EXT_CSD_EXP_EVENTS_CTRL                56      /* R/W, 2 byte=
s */
>>  #define EXT_CSD_DATA_SECTOR_SIZE       61      /* R */
>>  #define EXT_CSD_GP_SIZE_MULT           143     /* R/W */
>> +#define EXT_CSD_PARTITION_SETTING_COMPLETED 155        /* R/W */
>>  #define EXT_CSD_PARTITION_ATTRIBUTE    156     /* R/W */
>>  #define EXT_CSD_PARTITION_SUPPORT      160     /* RO */
>>  #define EXT_CSD_HPI_MGMT               161     /* R/W */
>> @@ -349,6 +350,7 @@ struct _mmc_csd {
>>  #define EXT_CSD_PART_CONFIG_ACC_RPMB   (0x3)
>>  #define EXT_CSD_PART_CONFIG_ACC_GP0    (0x4)
>>
>> +#define EXT_CSD_PART_SETTING_COMPLETED (0x1)
>>  #define EXT_CSD_PART_SUPPORT_PART_EN   (0x1)
>>
>>  #define EXT_CSD_CMD_SET_NORMAL         (1<<0)
>> --
>> 1.7.0.4
>=20


--F2OtWnTpmtWc3U43XaW4DN355ddBSqWqf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlPrLcMACgkQgTLQuHmJE0G6kwCfbFipXUTOGeBOfT+4G1BT1X7p
pn0An1agTPUIh05Sl9ZhDLZLrc4+3JnI
=bpDo
-----END PGP SIGNATURE-----

--F2OtWnTpmtWc3U43XaW4DN355ddBSqWqf--
