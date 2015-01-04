Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbbADWED (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 17:04:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59298 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbbADWEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 17:04:01 -0500
Message-ID: <1420409029.5686.147.camel@decadent.org.uk>
Subject: Re: [PATCH net-next v1 2/7] net: phy: extend link mode support to
 48 bits
From: Ben Hutchings <ben@decadent.org.uk>
To: David Decotigny <ddecotig@gmail.com>
Cc: Amir Vadai <amirv@mellanox.com>, Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, David Decotigny <decot@googlers.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Masatake YAMATO <yamato@redhat.com>,
        Xi Wang <xii@google.com>, Neil Horman <nhorman@tuxdriver.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Flavio Leitner <fbl@redhat.com>,
        Tom Gundersen <teg@jklm.no>, Jiri Pirko <jiri@resnulli.us>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Venkata Duvvuru <VenkatKumar.Duvvuru@Emulex.Com>,
        Govindarajulu Varadarajan <_govind@gmx.com>
Date: Sun, 04 Jan 2015 22:03:49 +0000
In-Reply-To: <1420405017-23278-3-git-send-email-ddecotig@gmail.com>
References: <1420405017-23278-1-git-send-email-ddecotig@gmail.com>
	 <1420405017-23278-3-git-send-email-ddecotig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/pWqHWhvNyh6Yug/gz7V"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/pWqHWhvNyh6Yug/gz7V
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2015-01-04 at 12:56 -0800, David Decotigny wrote:
> From: David Decotigny <decot@googlers.com>
>=20
> Signed-off-by: David Decotigny <decot@googlers.com>
> ---
>  drivers/net/phy/phy.c        | 29 ++++++++++++++---------------
>  drivers/net/phy/phy_device.c |  4 ++--
>  include/linux/phy.h          | 10 +++++-----
>  3 files changed, 21 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 767cd11..e9c8499 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
[...]
> @@ -245,7 +246,7 @@ static inline unsigned int phy_find_valid(unsigned in=
t idx, u32 features)
>   */
>  static void phy_sanitize_settings(struct phy_device *phydev)
>  {
> -	u32 features =3D phydev->supported;
> +	ethtool_link_mode_mask_t features =3D phydev->supported;
>  	unsigned int idx;
> =20
>  	/* Sanitize settings based on PHY capabilities */
> @@ -279,13 +280,13 @@ int phy_ethtool_sset(struct phy_device *phydev, str=
uct ethtool_cmd *cmd)
>  		return -EINVAL;
> =20
>  	/* We make sure that we don't pass unsupported values in to the PHY */
> -	cmd->advertising &=3D phydev->supported;
> +	phydev->advertising =3D ethtool_cmd_advertising(cmd) & phydev->supporte=
d;

phydev->advertising should not be changed until after the following
validation.  Use a local variable for this.

>  	/* Verify the settings we care about. */
>  	if (cmd->autoneg !=3D AUTONEG_ENABLE && cmd->autoneg !=3D AUTONEG_DISAB=
LE)
>  		return -EINVAL;
> =20
> -	if (cmd->autoneg =3D=3D AUTONEG_ENABLE && cmd->advertising =3D=3D 0)
> +	if (cmd->autoneg =3D=3D AUTONEG_ENABLE && phydev->advertising =3D=3D 0)
>  		return -EINVAL;
> =20
>  	if (cmd->autoneg =3D=3D AUTONEG_DISABLE &&
> @@ -300,8 +301,6 @@ int phy_ethtool_sset(struct phy_device *phydev, struc=
t ethtool_cmd *cmd)
> =20
>  	phydev->speed =3D speed;
> =20
> -	phydev->advertising =3D cmd->advertising;
> -
>  	if (AUTONEG_ENABLE =3D=3D cmd->autoneg)
>  		phydev->advertising |=3D ADVERTISED_Autoneg;
>  	else
[...]

The assignment to phydev->advertising should probably remain here.

Ben.

--=20
Ben Hutchings
This sentence contradicts itself - no actually it doesn't.

--=-/pWqHWhvNyh6Yug/gz7V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVKm4yue/yOyVhhEJAQrkaQ//So7sdIftK7URAc9hSKcmvpmTNv5ahGWc
j8i5tk1tBn7+m0FHdoEmaTgSh5jFpU31sYCeIPSre/obZvfpcZHP6eBIVdh44mPR
LpeWRinpR3f1XZIVKapIHorTnfrt/fHAXAFofD6LWcKuUZbC9i0MUJzaf0k6Z65D
quJ7M5ga13rSpl2ByPxibQp83hYrT7VkzTKnJ0VmAlS1uzkB0RIvEl9uZbzdSztI
u/LZLWjUyfxYhPElGqmdbkXHNbOEbtLwkitAZ1cKezFqwX2hVQyHt+c0bNhTamEv
4QQIfKKVBHY5M6in5gDedy4LuaJGwX/nnYPqDw6jPQPBDxKPrz8oN+OggHlWk2Xb
LPxxAkQWKCjx8HCxnyPQJ14se5KF0bMZQS/Meh6OYef1Wkwyv2Jgyj62DLycdja8
bb0+nEqIlxUEGxMI7eJNkYVs/RoaCSv7ThB1s/Q3Rvvzsm3u294Tr2R/ij4/HBBj
mlMsFQkAMdNwV9z1riG3o56Vwh5h2c38wduuazUIf+78aEUoDXrwrUUMh9BuqIpe
+NfM0v3AakJiB1t5lVIQyQdO7z+gADD6nKiHpNp+B6J3i9Lcohy1tIx4D5olHv/x
zTJn8TvpIHD21bhyOTRM3IlFjja2pjpW2VZfQ9ie6ex7iBpy8yPH3eyNb7Oaj8fZ
advMmLlg8XU=
=TJDY
-----END PGP SIGNATURE-----

--=-/pWqHWhvNyh6Yug/gz7V--
