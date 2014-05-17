Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaEQKVZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 06:21:25 -0400
Received: from sauhun.de ([89.238.76.85]:38329 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114AbaEQKVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 06:21:23 -0400
Date: Sat, 17 May 2014 12:21:10 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: rjw@rjwysocki.net, mika.westerberg@linux.intel.com, awilliam@redhat.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 6/9] I2C: Add smbus word/block process call helper
 function
Message-ID: <20140517102110.GB2602@katana>
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
 <1398695268-28645-1-git-send-email-tianyu.lan@intel.com>
 <1398695268-28645-7-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
In-Reply-To: <1398695268-28645-7-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 10:27:45PM +0800, Lan Tianyu wrote:
> Add i2c_smbus_word/block_proc_call() helper function. These will be used
> in the implementation of i2c ACPI address space handler.
>=20
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/i2c/i2c-core.c | 56 ++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/i2c.h    |  4 ++++
>  2 files changed, 60 insertions(+)
>=20
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 3bf0048..638befd 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -2306,6 +2306,30 @@ s32 i2c_smbus_write_word_data(const struct i2c_cli=
ent *client, u8 command,
>  EXPORT_SYMBOL(i2c_smbus_write_word_data);
> =20
>  /**
> + * i2c_smbus_word_proc_call - SMBus "word proc call" protocol
> + * @client: Handle to slave device
> + * @command: Byte interpreted by slave
> + * @value: 16-bit "word" being written
> + *
> + * This executes the SMBus "word proc all" protocol, returning negative =
errno
> + * else a 16-bit unsigned "word" received from the device.
> + */
> +s32 i2c_smbus_word_proc_call(const struct i2c_client *client, u8 command,
> +			      u16 value)
> +{
> +	union i2c_smbus_data data;
> +	int status;
> +
> +	data.word =3D value;
> +	status =3D i2c_smbus_xfer(client->adapter, client->addr, client->flags,
> +			      I2C_SMBUS_READ, command,
> +			      I2C_SMBUS_PROC_CALL, &data);
> +
> +	return (status < 0) ? status : data.word;
> +}
> +EXPORT_SYMBOL(i2c_smbus_word_proc_call);
> +
> +/**

Same as smbus_quick function before, documentation updates are missing.
Also similar, we had such a function before which was removed due to no
users? It looks very much like the function here, so we should stick to
the old naming IMO. Is it the old one? Such information would be nice
since it affects reviewing.

>   * i2c_smbus_read_block_data - SMBus "block read" protocol
>   * @client: Handle to slave device
>   * @command: Byte interpreted by slave
> @@ -2362,6 +2386,38 @@ s32 i2c_smbus_write_block_data(const struct i2c_cl=
ient *client, u8 command,
>  }
>  EXPORT_SYMBOL(i2c_smbus_write_block_data);
> =20
> +/**
> + * i2c_smbus_block_proc_call - SMBus "block write" protocol
> + * @client: Handle to slave device
> + * @command: Byte interpreted by slave
> + * @length: Size of data block; SMBus allows at most 32 bytes
> + * @values: Byte array which will be written.
> + *
> + * This executes the SMBus "block proc call" protocol, returning negativ=
e errno
> + * else the number of read bytes.
> + */
> +s32 i2c_smbus_block_proc_call(const struct i2c_client *client, u8 comman=
d,
> +			       u8 length, u8 *values)

Please rename to "i2c_smbus_block_process_call" as the old function was
named. Needs documentation updates.

> +	if (length > I2C_SMBUS_BLOCK_MAX)
> +		length =3D I2C_SMBUS_BLOCK_MAX;

I think we should return an error here.

BTW what were your test scenarios for these functions and smbus quick?


--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTdzgWAAoJEBQN5MwUoCm2DhMP/1eF1Yngua+m5AOI+7+vsm5u
0IShycGgfu4fLWaE2IChiQbTyx/nBrerUG0M3+i50KWQ7t2BeO8h4xkHVUFmfkEH
4rBITORQQn6gG+8L7KW3oFjUAfQUQrU/3H+fofAlGNMBEjnVOKJK+KLggJC4Tvyl
YCwPEZgsAH2UhF+JfpVqyUtDyBosgjEc5JmBurUcbwkDN8B6TxZxG9O8V/4MGrvJ
3/S3JWyLKq8uShYZrCTqY/zdHaQO7KPqvu19Ox0OnOb/w6dAc6uUeaeHdY8zaFHi
2NX6WTh+tj1of0Y6YQf+q5g2YHy1NSokxr86CP8pBU+20Qf7uqx1PMK2VASRpK95
PvftinwG/5RxUmsTgwng+vKQagTynUs7ibJGaQRDzHaV5RtG35ElFWN+pLVsI+GD
6o9/oawDQlFMXhv63ir+6QPg1DIKw3sMSpJ4dhma7zjqO0DZ1Zy//lIPMZX/ueOD
ZgqeVpys5WnUw8y+wIbE/tKkI4S2qq8YSWtttkhVfRkG1XIkLLY6p4zb93HzFvR9
p5RO3ZjNu8f9oMKzJjPMQ1vFF6GNFLWzHYEqlrQ4iXdkwFaWgJi5GgwxoKtx6CSu
hDmI+Cyn+UHdliZwH9IchJlY9i4xHhcVWydIr49+REh5Z8cwUdCWEJpAQpy4ZUdl
maND4QFoI7qGpeWWcYpo
=3bde
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
