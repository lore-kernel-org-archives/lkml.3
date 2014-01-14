Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaANNMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:12:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33569 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaANNMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:12:22 -0500
Date: Tue, 14 Jan 2014 07:10:52 -0600
From: Felipe Balbi <balbi@ti.com>
To: Suman Anna <s-anna@ti.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 6/7] hwspinlock/omap: enable module before reading
 SYSSTATUS register
Message-ID: <20140114131052.GA10818@saruman.home>
Reply-To: <balbi@ti.com>
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>
 <1389658764-39199-7-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <1389658764-39199-7-git-send-email-s-anna@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 13, 2014 at 06:19:23PM -0600, Suman Anna wrote:
> The number of hwspinlocks are determined based on the value read
> from the IP block's SYSSTATUS register. However, the module may
> not be enabled and clocked, and the read may result in a bus error.
>=20
> This particular issue is seen rather easily on AM33XX, since the
> module wakeup is software controlled, and it is disabled out of
> reset. Make sure the module is enabled and clocked before reading
> the SYSSTATUS register.
>=20
> Signed-off-by: Suman Anna <s-anna@ti.com>
> ---
>  drivers/hwspinlock/omap_hwspinlock.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/om=
ap_hwspinlock.c
> index 9f56fb2..194886e 100644
> --- a/drivers/hwspinlock/omap_hwspinlock.c
> +++ b/drivers/hwspinlock/omap_hwspinlock.c
> @@ -101,10 +101,23 @@ static int omap_hwspinlock_probe(struct platform_de=
vice *pdev)
>  	if (!io_base)
>  		return -ENOMEM;
> =20
> +	/*
> +	 * make sure the module is enabled and clocked before reading
> +	 * the module SYSSTATUS register
> +	 */
> +	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_get_sync(&pdev->dev);
> +
>  	/* Determine number of locks */
>  	i =3D readl(io_base + SYSSTATUS_OFFSET);
>  	i >>=3D SPINLOCK_NUMLOCKS_BIT_OFFSET;
> =20
> +	/*
> +	 * runtime PM will make sure the clock of this module is
> +	 * enabled again iff at least one lock is requested
> +	 */
> +	pm_runtime_put(&pdev->dev);

there is a small race here (which was already present previously) where
you could return from probe() in a failure case before your PM runtime
put request then you would disable pm_runtime while the device was still
alive.

--=20
balbi

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS1TdcAAoJEIaOsuA1yqREaNYQAJlfWXJcytjYawQAp8EcTsMz
jRAWiYJPlbMu65QWwqPu5KsjcUqCBQX/IOINCHoZkA8L4TtZI+BQGg345uhWqnkC
gMND6DmH8vQeo1uTYU1R8+s6MquFAV9IjUwRAtAMuV2miu1aDQkIAY0b04qWiMgt
o9jqpT/HWKL+H9yiWLawEj9JRJc8hcD2u/IlO6LLXwPdC7ABO1S/7ngOPq04WsJX
lCHuMMo28/9x7Qoi/mu+kMG+UnLGb4uWGRkjxVsQ3Jf1px8INi1wtYHJLrGiE4PG
5Lh8nN5CsZVkl8ZtqGKATkV9cYspWVd0ouMY4M1XYLolCjaAylFKs4XR2hvoDG/g
ios0bmhlz1qQEyXhyLx1zCxRzSCQcxrtc3SKkf+bOcVUAR07gakQ8fsygyVG64Pq
W7noIe2Z/3vg4Bf28bLuvXf9grsFv4yaFtqzNsKNZgbr6lJqgxu1s7rxYEQr4plF
O111Ywq38z7ZsaRBZ0NHV5UaI4s1L7CNTb7M10gmBehdrEBLrXxpXSJyse7aeCjz
CxjHD9Ib5hYEOMzLIzX0Ttey06hFppQWXdlUnpE1O4ctV6noitv6Gig2ieLfxl4P
4QSawl2d1z6QtBZQDN42iYy5YqIJWziBpb4BMBJ+657n7Ob235JEVtm3T86nhzSf
10aNevJvsHpuF7+Dk7nF
=kjbG
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
