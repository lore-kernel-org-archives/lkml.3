Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaCXQOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 12:14:37 -0400
Received: from sauhun.de ([89.238.76.85]:48421 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaCXQOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 12:14:35 -0400
Date: Mon, 24 Mar 2014 17:14:32 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-i2c@vger.kernel.org, davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-davinci: Handle signals gracefully
Message-ID: <20140324161432.GA7524@katana>
References: <1389265885-26777-1-git-send-email-mike.looijmans@topic.nl>
 <1394779348-4084-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <1394779348-4084-1-git-send-email-mike.looijmans@topic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-da=
vinci.c
> index af0b583..254d897 100644
> --- a/drivers/i2c/busses/i2c-davinci.c
> +++ b/drivers/i2c/busses/i2c-davinci.c
> @@ -372,9 +372,9 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct=
 i2c_msg *msg, int stop)
>  		flag |=3D DAVINCI_I2C_MDR_STP;
>  	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, flag);
> =20
> -	r =3D wait_for_completion_interruptible_timeout(&dev->cmd_complete,
> +	r =3D wait_for_completion_timeout(&dev->cmd_complete,
>  						      dev->adapter.timeout);
> -	if (r =3D=3D 0) {
> +	if (unlikely(r =3D=3D 0)) {

Not really needed, but well yeah...

>  		dev_err(dev->dev, "controller timed out\n");
>  		davinci_i2c_recover_bus(dev);
>  		i2c_davinci_init(dev);
> @@ -384,7 +384,6 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct=
 i2c_msg *msg, int stop)
>  	if (dev->buf_len) {
>  		/* This should be 0 if all bytes were transferred
>  		 * or dev->cmd_err denotes an error.
> -		 * A signal may have aborted the transfer.
>  		 */
>  		if (r >=3D 0) {
>  			dev_err(dev->dev, "abnormal termination buf_len=3D%i\n",
> @@ -436,22 +435,24 @@ i2c_davinci_xfer(struct i2c_adapter *adap, struct i=
2c_msg msgs[], int num)
>  	ret =3D i2c_davinci_wait_bus_not_busy(dev, 1);
>  	if (ret < 0) {
>  		dev_warn(dev->dev, "timeout waiting for bus ready\n");
> -		return ret;
> +		goto error;

You are fixing the error path here to include the completion? This is a
seperate patch IMO.

>  	}
> =20
>  	for (i =3D 0; i < num; i++) {
>  		ret =3D i2c_davinci_xfer_msg(adap, &msgs[i], (i =3D=3D (num - 1)));
> -		dev_dbg(dev->dev, "%s [%d/%d] ret: %d\n", __func__, i + 1, num,
> -			ret);
> +		dev_dbg(dev->dev, "%s [%d/%d] %#x ret: %d\n", __func__, i + 1,
> +				num, msgs[i].addr, ret);

No need for this change. We have other debug output/tracing already. But
no need to clean up either.

>  		if (ret < 0)
> -			return ret;
> +			goto error;
>  	}
> +	ret =3D num;
> =20
> +error:
>  #ifdef CONFIG_CPU_FREQ
>  	complete(&dev->xfr_complete);
>  #endif
> =20
> -	return num;
> +	return ret;

Thanks,

   Wolfram


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTMFnoAAoJEBQN5MwUoCm2VmcQAJMQjRI4+dR3vpiOfNXapkO0
NX63qR4m8TPg/r1LdS1MfC6Pey1GT/xZ1d7ofeSAn/QMekucrRpgpVmGWA8JKXiv
ZEN9R1A/Df4HoIKPrPw17ArWoN1/RqOFvQZrfHRaBvz0/jBzFf8EufbjhrmYBlhV
B8VANxj+18aNgI/YhjDsgAWROgAsn6nvhWnnuCxopm9gkDOpXtSHLYQ2eSPoKWaH
hWaqzSxRip+hX4c88Gc7gjnQgqlqofZCe/D14n725/o40t5KGO5Q3NOOJ2/42O9e
tB/a9/VKoq4CpSR04jIIK1UGu2muCqZJFD6J7m3hpqSOdk6EU9ntfudCwYWiuGeI
nvyBU7pgEwYsnPoYW80Tm8sCvUch9ljenxmfPTXFX6L+HBpdlRTV8JTy5qpisitB
nQtvDFcVtqWToy78V48pLIXSH7PLrvePqtrnJphJEiiIeDthTEodf2q0bXHno4Kg
7lK/oYyD6Sfb3DofCUNOaIf8ifvGbDKNX/OkEBy/3TPdQ7vaDhTXoWrKTXI9omOa
H7t2FUvu6VFQ/STRFo9El22nhNYJbA6K6tckODXdn6cHic7SE0ycEkzFHsYMQXxw
jq9Fe9lizXgRVHxARFUty8lMZwuT4E2Rpm99InrjLZTqQVdtLyK/UqNjcecJo0cx
aeY16RvoNDqR3hOC25xQ
=F7yK
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
