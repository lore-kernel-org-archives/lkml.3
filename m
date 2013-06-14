Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3FNOft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:35:49 -0400
Received: from sauhun.de ([89.238.76.85]:46999 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256Ab3FNOfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:35:47 -0400
Date: Fri, 14 Jun 2013 16:37:41 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] i2c: designware: fix race between subsequent xfers
Message-ID: <20130614143740.GD2929@katana>
References: <1370526216-10060-1-git-send-email-christian.ruppert@abilis.com>
 <1370595083-801-1-git-send-email-christian.ruppert@abilis.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SFyWQ0h3ruR435lw"
Content-Disposition: inline
In-Reply-To: <1370595083-801-1-git-send-email-christian.ruppert@abilis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SFyWQ0h3ruR435lw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 07, 2013 at 10:51:23AM +0200, Christian Ruppert wrote:
> The designware block is not always properly disabled in the case of
> transfer errors. Interrupts from aborted transfers might be handled
> after the data structures for the following transfer are initialised but
> before the hardware is set up. This can corrupt the data structures to
> the point that the system is stuck in an infinite interrupt loop (where
> FIFOs are never emptied because dev->msg_read_idx =3D=3D dev->msgs_num).
>=20
> This patch cleanly disables the designware-i2c hardware at the end of
> every transfer, be it successful or not.
>=20
> This patch requires https://patchwork.kernel.org/patch/2601241/ to be
> applied first.

These last two lines should be below "---".

>=20
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> ---
>  drivers/i2c/busses/i2c-designware-core.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busse=
s/i2c-designware-core.c
> index b75d292..55a9991 100644
> --- a/drivers/i2c/busses/i2c-designware-core.c
> +++ b/drivers/i2c/busses/i2c-designware-core.c
> @@ -588,11 +588,19 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_ms=
g msgs[], int num)
>  	ret =3D wait_for_completion_timeout(&dev->cmd_complete, HZ);
>  	if (ret =3D=3D 0) {
>  		dev_err(dev->dev, "controller timed out\n");
> +		/* i2c_dw_init implicitly disables the adapter */
>  		i2c_dw_init(dev);
>  		ret =3D -ETIMEDOUT;
>  		goto done;
>  	}
> =20
> +	/*
> +	 * We must disable the adapter before unlocking the &dev->lock mutex
> +	 * below. Otherwise the hardware might continue generating interrupts
> +	 * which in turn causes a race condition with the following transfer.

I added "Needs some more investigation if the additional interrupts are
a hardware bug or this driver doesn't handle them correctly yet." to the
comment and

Applied to for-next, thanks!

BTW since I am currently here: i2c-designware-core should be in the
'algos' directory, no?

--SFyWQ0h3ruR435lw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRuyq0AAoJEBQN5MwUoCm2U4IP/3xYWG2jo1fL3KEvTmm56wCh
VRZ3Pe0NU0xEpa5qcTJKlvR2g2nt9pzihJYsBWU5iLt5/yPlClFQhpz57JlTurkR
X8QjoByuaH7DBFhuIY1m7LcMYku/uJQWtc0NoKCDdqRcKg0G3FuMQa64L/eJK0kB
ak/R+tmBdamvsLHX2teKD1DpQ+00EgcrbmdDX6lFGakm61Wv5J0yuiIdNK3RMmiV
3gWtwwt4bbCt73rrRVWajYs/f62sxQu5tnQZrqjiy02LKclQh0/Dtq2aF8AGDORj
VHod5v+0qry0s9834GPmxUnEEqJSSdM2sZTWDwkSi2VTxGIqYO1wYhOzyyjziJV6
Ugjlebizy3yzpWvyAM/cT1eCoOmVtIuxbRf73AEs4tWwkrH2sJvIoxaw7wCmcpGW
muwTxhEs+1Ivms/aTsrtH+6vgPW0hhSGgE8oBLU1QU59iOHl3hq4aPThVlk6EZDl
2dNLKiqf+7PqLB2IjN72LMxJWwpVBGv3TI70IdB/siJ++CvMRTC10f0uOctS2mB2
nrmwF+yFZ24NUsICtnzLei7oqqacQOaMTC3G/f6fV2oOlFYKhD3syrBW1yxpaLg8
Gg5Bqrr+zaFu57QqNimwL5NtlckuVWi8vP10a7FlPcCgZuCNWA+NAE87YsLb2mdu
6jrAXceabWoS/zoDyGVL
=siA8
-----END PGP SIGNATURE-----

--SFyWQ0h3ruR435lw--
