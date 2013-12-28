Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab3L1Wyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 17:54:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54596 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037Ab3L1Wyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 17:54:52 -0500
Message-ID: <1388271276.14575.12.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.4] mmc: block: fix a bug of error handling in MMC
 driver
From: Ben Hutchings <ben@decadent.org.uk>
To: Yoshitake Kobayashi <yoshitake.kobayashi@toshiba.co.jp>
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org, cjb@laptop.org,
        linux-kernel@vger.kernel.org
Date: Sat, 28 Dec 2013 23:54:36 +0100
In-Reply-To: <1386262023-30954-1-git-send-email-yoshitake.kobayashi@toshiba.co.jp>
References: <1386262023-30954-1-git-send-email-yoshitake.kobayashi@toshiba.co.jp>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-aYqw/0ICfzrZ3y3RJ7ao"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.217.234.213
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aYqw/0ICfzrZ3y3RJ7ao
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-12-06 at 01:47 +0900, Yoshitake Kobayashi wrote:
> From: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
>=20
> commit c8760069627ad3b0dbbea170f0c4c58b16e18d3d upstream.
>=20
> Current MMC driver doesn't handle generic error (bit19 of device
> status) in write sequence. As a result, write data gets lost when
> generic error occurs. For example, a generic error when updating a
> filesystem management information causes a loss of write data and
> corrupts the filesystem. In the worst case, the system will never
> boot.
>=20
> This patch includes the following functionality:
>   1. To enable error checking for the response of CMD12 and CMD13
>      in write command sequence
>   2. To retry write sequence when a generic error occurs
>=20
> [Backported to 3.4-stable]
>=20
> Signed-off-by: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
> Signed-off-by: Chris Ball <cjb@laptop.org>

I've also queued this up for 3.2, thanks.

Ben.

> ---
>  drivers/mmc/card/block.c |   47 ++++++++++++++++++++++++++++++++++++++++=
+++--
>  1 files changed, 44 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 833ff16..91042a2 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -701,7 +701,7 @@ static int mmc_blk_cmd_error(struct request *req, con=
st char *name, int error,
>   * Otherwise we don't understand what happened, so abort.
>   */
>  static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *r=
eq,
> -	struct mmc_blk_request *brq, int *ecc_err)
> +	struct mmc_blk_request *brq, int *ecc_err, int *gen_err)
>  {
>  	bool prev_cmd_status_valid =3D true;
>  	u32 status, stop_status =3D 0;
> @@ -739,6 +739,16 @@ static int mmc_blk_cmd_recovery(struct mmc_card *car=
d, struct request *req,
>  	    (brq->cmd.resp[0] & R1_CARD_ECC_FAILED))
>  		*ecc_err =3D 1;
> =20
> +	/* Flag General errors */
> +	if (!mmc_host_is_spi(card->host) && rq_data_dir(req) !=3D READ)
> +		if ((status & R1_ERROR) ||
> +			(brq->stop.resp[0] & R1_ERROR)) {
> +			pr_err("%s: %s: general error sending stop or status command, stop cm=
d response %#x, card status %#x\n",
> +			       req->rq_disk->disk_name, __func__,
> +			       brq->stop.resp[0], status);
> +			*gen_err =3D 1;
> +		}
> +
>  	/*
>  	 * Check the current card state.  If it is in some data transfer
>  	 * mode, tell it to stop (and hopefully transition back to TRAN.)
> @@ -758,6 +768,13 @@ static int mmc_blk_cmd_recovery(struct mmc_card *car=
d, struct request *req,
>  			return ERR_ABORT;
>  		if (stop_status & R1_CARD_ECC_FAILED)
>  			*ecc_err =3D 1;
> +		if (!mmc_host_is_spi(card->host) && rq_data_dir(req) !=3D READ)
> +			if (stop_status & R1_ERROR) {
> +				pr_err("%s: %s: general error sending stop command, stop cmd respons=
e %#x\n",
> +				       req->rq_disk->disk_name, __func__,
> +				       stop_status);
> +				*gen_err =3D 1;
> +			}
>  	}
> =20
>  	/* Check for set block count errors */
> @@ -1007,7 +1024,7 @@ static int mmc_blk_err_check(struct mmc_card *card,
>  						    mmc_active);
>  	struct mmc_blk_request *brq =3D &mq_mrq->brq;
>  	struct request *req =3D mq_mrq->req;
> -	int ecc_err =3D 0;
> +	int ecc_err =3D 0, gen_err =3D 0;
> =20
>  	/*
>  	 * sbc.error indicates a problem with the set block count
> @@ -1021,7 +1038,7 @@ static int mmc_blk_err_check(struct mmc_card *card,
>  	 */
>  	if (brq->sbc.error || brq->cmd.error || brq->stop.error ||
>  	    brq->data.error) {
> -		switch (mmc_blk_cmd_recovery(card, req, brq, &ecc_err)) {
> +		switch (mmc_blk_cmd_recovery(card, req, brq, &ecc_err, &gen_err)) {
>  		case ERR_RETRY:
>  			return MMC_BLK_RETRY;
>  		case ERR_ABORT:
> @@ -1051,6 +1068,15 @@ static int mmc_blk_err_check(struct mmc_card *card=
,
>  	 */
>  	if (!mmc_host_is_spi(card->host) && rq_data_dir(req) !=3D READ) {
>  		u32 status;
> +
> +		/* Check stop command response */
> +		if (brq->stop.resp[0] & R1_ERROR) {
> +			pr_err("%s: %s: general error sending stop command, stop cmd response=
 %#x\n",
> +			       req->rq_disk->disk_name, __func__,
> +			       brq->stop.resp[0]);
> +			gen_err =3D 1;
> +		}
> +
>  		do {
>  			int err =3D get_card_status(card, &status, 5);
>  			if (err) {
> @@ -1058,6 +1084,14 @@ static int mmc_blk_err_check(struct mmc_card *card=
,
>  				       req->rq_disk->disk_name, err);
>  				return MMC_BLK_CMD_ERR;
>  			}
> +
> +			if (status & R1_ERROR) {
> +				pr_err("%s: %s: general error sending status command, card status %#=
x\n",
> +				       req->rq_disk->disk_name, __func__,
> +				       status);
> +				gen_err =3D 1;
> +			}
> +
>  			/*
>  			 * Some cards mishandle the status bits,
>  			 * so make sure to check both the busy
> @@ -1067,6 +1101,13 @@ static int mmc_blk_err_check(struct mmc_card *card=
,
>  			 (R1_CURRENT_STATE(status) =3D=3D R1_STATE_PRG));
>  	}
> =20
> +	/* if general error occurs, retry the write operation. */
> +	if (gen_err) {
> +		pr_warning("%s: retrying write for general error\n",
> +				req->rq_disk->disk_name);
> +		return MMC_BLK_RETRY;
> +	}
> +
>  	if (brq->data.error) {
>  		pr_err("%s: error %d transferring data, sector %u, nr %u, cmd response=
 %#x, card status %#x\n",
>  		       req->rq_disk->disk_name, brq->data.error,

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-aYqw/0ICfzrZ3y3RJ7ao
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUr9WrOe/yOyVhhEJAQoXMg//UGbaPTuVR99xBnqEjhmynaLOPSVI9xAe
IualSR30O2QNzTLx60CguBmvHL6QyhR2eqTsYPUICBBj4UjyEC6sGUjhMEIDHta0
N9qgniXEW+/sUc/vyv1fDfMxeGeUD6BiOvUD6VuFouTVCMN0bGa2uf5TUWDKKQu2
N7mm8eMpAVezTJ0cwS+LmFRTHDUJ0snI5kxzExrus/SQUG5BVZZPWQlrxNy/PZ9X
Sh8QpWxKoSE6Zh32vPDuRH47EGU5WoHCjqCK1/4Y8yVrxlj/tCTNt2PuYcjMq2Dw
sdnCGH3Rujdc8oAt87kuBHucRkZiZR+nbiZmlkLlkgniUry2MJGpocTV+mXsNAPj
PEaRfLiUSibw6zVociuLURNGlxRBRsmZSPSEQKgdRXKHrJuCyIjTWo9mh89Rj3NY
ksWpD6VZ853qnr33u75/YhzMAqxMlZyEtLazZvua2fFCX2gQt+S/XohnKuR/hfne
gcF9PhlKoQfRSsKKcMJWw98i2ndtKQuGRZNoEjzcYd/360fsNvakHvbG9gp3V8Dz
S1j+LZTNe8G1j/9oeQoRjwn2/C37ETAs3f6jjZlN/QkDMmQ9T7Qz4Ss4KWLO2MEk
ogrvfMdkpMswgJ6IG7lI1u1WYAMPZNzwRrYqX9HOW8STIxknMFIWFmGA6kTfXwgH
etwXM7EoTvE=
=90rh
-----END PGP SIGNATURE-----

--=-aYqw/0ICfzrZ3y3RJ7ao--
