Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbbAWOs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:48:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbbAWOs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:48:28 -0500
Message-ID: <54C25F25.9070609@redhat.com>
Date: Fri, 23 Jan 2015 15:48:05 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 1/2] zram: free meta out of init_lock
References: <1421992707-32658-1-git-send-email-minchan@kernel.org> <20150123142435.GA2320@swordfish>
In-Reply-To: <20150123142435.GA2320@swordfish>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="331CEqU88CCo9Lp25IXqvcPqm50GPDixK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--331CEqU88CCo9Lp25IXqvcPqm50GPDixK
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/23/2015 03:24 PM, Sergey Senozhatsky wrote:
> On (01/23/15 14:58), Minchan Kim wrote:
>> We don't need to call zram_meta_free, zcomp_destroy and zs_free
>> under init_lock. What we need to prevent race with init_lock
>> in reset is setting NULL into zram->meta (ie, init_done).
>> This patch does it.
>>
>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>> ---
>>  drivers/block/zram/zram_drv.c | 28 ++++++++++++++++------------
>>  1 file changed, 16 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_d=
rv.c
>> index 9250b3f54a8f..0299d82275e7 100644
>> --- a/drivers/block/zram/zram_drv.c
>> +++ b/drivers/block/zram/zram_drv.c
>> @@ -708,6 +708,7 @@ static void zram_reset_device(struct zram *zram, b=
ool reset_capacity)
>>  {
>>  	size_t index;
>>  	struct zram_meta *meta;
>> +	struct zcomp *comp;
>> =20
>>  	down_write(&zram->init_lock);
>> =20
>> @@ -719,20 +720,10 @@ static void zram_reset_device(struct zram *zram,=
 bool reset_capacity)
>>  	}
>> =20
>>  	meta =3D zram->meta;
>> -	/* Free all pages that are still in this zram device */
>> -	for (index =3D 0; index < zram->disksize >> PAGE_SHIFT; index++) {
>> -		unsigned long handle =3D meta->table[index].handle;
>> -		if (!handle)
>> -			continue;
>> -
>> -		zs_free(meta->mem_pool, handle);
>> -	}
>> -
>> -	zcomp_destroy(zram->comp);
>=20
> I'm not so sure about moving zcomp destruction. if we would have detach=
ed it
> from zram, then yes. otherwise, think of zram ->destoy vs ->init race.
>=20
> suppose,
> CPU1 waits for down_write() init lock in disksize_store() with new comp=
 already allocated;
> CPU0 detaches ->meta and releases write init lock;
> CPU1 grabs the lock and does zram->comp =3D comp;
> CPU0 reaches the point of zcomp_destroy(zram->comp);

I don't see your point: this patch does not call
zcomp_destroy(zram->comp) anymore, but zram_destroy(comp), where comp is
the old zram->comp.

>=20
>=20
> I'd probably prefer to keep zcomp destruction on its current place. I
> see a little real value in introducing zcomp detaching and moving
> destruction out of init_lock.
>=20
> 	-ss
>=20
>> +	comp =3D zram->comp;
>> +	zram->meta =3D NULL;
>>  	zram->max_comp_streams =3D 1;
>> =20
>> -	zram_meta_free(zram->meta);
>> -	zram->meta =3D NULL;
>>  	/* Reset stats */
>>  	memset(&zram->stats, 0, sizeof(zram->stats));
>> =20
>> @@ -742,6 +733,19 @@ static void zram_reset_device(struct zram *zram, =
bool reset_capacity)
>> =20
>>  	up_write(&zram->init_lock);
>> =20
>> +	/* Free all pages that are still in this zram device */
>> +	for (index =3D 0; index < zram->disksize >> PAGE_SHIFT; index++) {
>> +		unsigned long handle =3D meta->table[index].handle;
>> +
>> +		if (!handle)
>> +			continue;
>> +
>> +		zs_free(meta->mem_pool, handle);
>> +	}
>> +
>> +	zcomp_destroy(comp);
>> +	zram_meta_free(meta);
>> +
>>  	/*
>>  	 * Revalidate disk out of the init_lock to avoid lockdep splat.
>>  	 * It's okay because disk's capacity is protected by init_lock
>> --=20
>> 1.9.1
>>



--331CEqU88CCo9Lp25IXqvcPqm50GPDixK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUwl8lAAoJEHTzHJCtsuoCKuUIALmejiu1FV2BV1bcy9S+V8KD
W6FQJPzWcjQ2Gkt90550uvPdlYOlUJZ82RS9JbJZx8vWJq2jq8GvU+acr9avF7eN
+HFkIpq7kY/bJ3eJwgg98Bo5TTICXR+hOxwuD4yu5NS6OveoXyrVZBqsS8JFZDed
LLsr29/EvpYGHaZ/yB9UpFRJ7YcOG0OjCoinOg6KaqCyoFHtcSmtt9HcHPtBEruq
1dUyDhhWuO2urRUyiIsjYjLnt+tuoZ8SA7V+/YS3jw6ZdG3XxKWMWV3eDT+g7Kde
vg2EUuR23N/vZ9I4JqshxW+h2s86Rrxa+pbTtwdVDwFKkFs0+O2jBPMk/3ccWsQ=
=bDSs
-----END PGP SIGNATURE-----

--331CEqU88CCo9Lp25IXqvcPqm50GPDixK--
