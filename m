Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab3LTRbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 12:31:50 -0500
Received: from sauhun.de ([89.238.76.85]:34394 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774Ab3LTRbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 12:31:48 -0500
Date: Fri, 20 Dec 2013 18:31:44 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: fix a potential kmemleak of adapter device
Message-ID: <20131220173144.GA9997@katana>
References: <52B0F7D0.2020506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <52B0F7D0.2020506@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2013 at 09:18:08AM +0800, Gu Zheng wrote:
> When running with the latest kernel, we get the following kmemleak messag=
e:
> unreferenced object 0xffff8800c2a36100 (size 256):
>   comm "modprobe", pid 629, jiffies 4294676002 (age 1531.115s)
>   hex dump (first 32 bytes):
>     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>     ff ff ff ff ff ff ff ff 78 21 85 82 ff ff ff ff  ........x!......
>   backtrace:
>     [<ffffffff815449ce>] kmemleak_alloc+0x73/0x98
>     [<ffffffff8113fa2b>] slab_post_alloc_hook+0x28/0x2a
>     [<ffffffff81142004>] __kmalloc+0x12c/0x158
>     [<ffffffff8134c60b>] kzalloc.constprop.6+0xe/0x10
>     [<ffffffff8134cb71>] device_private_init+0x18/0x66
>     [<ffffffff8134f1e8>] dev_set_drvdata+0x1e/0x34
>     [<ffffffffa01e643e>] i801_probe+0x5d/0x447 [i2c_i801]
>     [<ffffffff812a78be>] local_pci_probe+0x41/0x84
>     [<ffffffff812a7feb>] pci_device_probe+0xdf/0x10c
>     [<ffffffff8134f90d>] driver_probe_device+0x12f/0x2ee
>     [<ffffffff8134fb2b>] __driver_attach+0x5f/0x83
>     [<ffffffff8134de28>] bus_for_each_dev+0x64/0x90
>     [<ffffffff8134f36b>] driver_attach+0x1e/0x20
>     [<ffffffff8134ef34>] bus_add_driver+0xf2/0x1f0
>     [<ffffffff8135013e>] driver_register+0x8c/0xc3
>     [<ffffffff812a7bb4>] __pci_register_driver+0x62/0x67
> According to the backtrace, it seems that we do not release the
> device_private field of adapter device in the fail path of i801_probe
> or the flow of i2c_del_adapter, so add the cleanup step to fix it.
>=20
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

? Why should we free something we don't have allocated? The fix must be
somewhere else probably...

> ---
>  drivers/i2c/busses/i2c-i801.c |    1 +
>  drivers/i2c/i2c-core.c        |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index 737e298..4bd4fba 100644
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> @@ -1246,6 +1246,7 @@ exit_free_irq:
>  exit_release:
>  	pci_release_region(dev, SMBBAR);
>  exit:
> +	kfree(priv->adapter.dev.p);
>  	kfree(priv);
>  	return err;
>  }
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index d74c0b3..a7bab9a 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -1491,6 +1491,7 @@ void i2c_del_adapter(struct i2c_adapter *adap)
>  	idr_remove(&i2c_adapter_idr, adap->nr);
>  	mutex_unlock(&core_lock);
> =20
> +	kfree(adap->dev.p);
>  	/* Clear the device structure in case this adapter is ever going to be
>  	   added again */
>  	memset(&adap->dev, 0, sizeof(adap->dev));
> --=20
> 1.7.7
>=20

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJStH8AAAoJEBQN5MwUoCm27tAP/3oXKQ2XL0aVL7rZ5YJTq5ND
yAmxWqrKpexHb2jkgOkjeDi0AyLDeRV5NvfB5fBTkFQg6Trp6fDRMJr44my7H3kf
h2Me8CjI9NqdEC6ZfvGa5iYeJb3WuvB72CokptLm2/wZtcwdn6wpFhkcFbH6nWXE
eTAhdtZH5c9HnIv7x9hrcJgIcf0Zxhxw9Fp2odOVG0tJ00ZAvmF55PRvc6Msk8Zc
NTOshVpI9JShCr8H8GYJUeVtdmhM7kXNrNivE+s8uDOVOmlhrccjJxtqY0pybDqp
nifQGoD+9KEIWbJYwy2Es8Vkbm/69G4Jp6JmrSosjY/3tmyUiSZB9VHQk7PYWZnx
qalZ+/miLJOdIyjMO5e0AzXl5NFXAjm99ozwoBubrLjlQm7PhETD+QtYKQX7SDyf
4kvd0EhINFWSSw5eZQC4VFwIPNlv03nBfWxMEXRk7Y5OiDqRwqwh8YDKEP3CaoR+
dP2LMZpO4Tfmk8b9ZfvySrT1fgi2Q9F8385anDEHin0f4MS5+DQsKUCzHUSC8i9k
t3MKzWcVaa7aLFaK9POB+QM3Xs2ved9UxZJecfC/R0YNZpx+bhEj4UbW89o5lQQm
eYrXhQzNLB7Ri1TQy+C8aHfaovJZP3+WLvbxXT69kvQ2TCZheD4loCEZHVWbumIE
mWRxCR2AtpLBGVYENP9a
=kV3/
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
