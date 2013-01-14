Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab3ANSsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:48:32 -0500
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:48792 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756667Ab3ANSsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:48:30 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net 9BC3E1754CF
Date: Mon, 14 Jan 2013 19:48:15 +0100
From: Albrecht =?iso-8859-1?b?RHJl3w==?= <albrecht.dress@arcor.de>
Subject: Re: [ 17/49] drm/radeon: add connector table for Mac G4 Silver
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
References: <20130113174255.736888844@decadent.org.uk>
	<20130113174259.392401812@decadent.org.uk>
In-Reply-To: <20130113174259.392401812@decadent.org.uk> (from
	ben@decadent.org.uk on Sun Jan 13 18:43:12 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1358189306.2543.0@antares>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	protocol="application/pgp-signature"; boundary="=-1b6wE2/IVimxMXCPoPOb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-1b6wE2/IVimxMXCPoPOb
Content-Type: text/plain; charset=ISO-8859-1; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch properly sets the connector table on my Powermac G4 "Silver".  H=
owever, I cannot get any usable video output as still something seems to be=
 wrong with the register settings.  Thus, it's not the *full* solution yet.=
..

---
Tested-by: Albrecht Dre=DF <albrecht.dress@arcor.de>

Am 13.01.13 18:43 schrieb(en) Ben Hutchings:
> 3.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Alex Deucher <alexander.deucher@amd.com>
>=20
> commit cafa59b9011a7790be4ddd5979419259844a165d upstream.
>=20
> Apple cards do not provide data tables in the vbios
> so we have to hard code the connector parameters
> in the driver.
>=20
> Reported-by: Albrecht Dre=DF <albrecht.dress@arcor.de>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/gpu/drm/radeon/radeon_combios.c |   51 +++++++++++++++++++++++++=
++++++
>  drivers/gpu/drm/radeon/radeon_mode.h    |    3 +-
>  2 files changed, 53 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/ra=
deon/radeon_combios.c
> index 4af8912..33a56a0 100644
> --- a/drivers/gpu/drm/radeon/radeon_combios.c
> +++ b/drivers/gpu/drm/radeon/radeon_combios.c
> @@ -1548,6 +1548,9 @@ bool radeon_get_legacy_connector_info_from_table(st=
ruct drm_device *dev)
>  			   of_machine_is_compatible("PowerBook6,7")) {
>  			/* ibook */
>  			rdev->mode_info.connector_table =3D CT_IBOOK;
> +		} else if (of_machine_is_compatible("PowerMac3,5")) {
> +			/* PowerMac G4 Silver radeon 7500 */
> +			rdev->mode_info.connector_table =3D CT_MAC_G4_SILVER;
>  		} else if (of_machine_is_compatible("PowerMac4,4")) {
>  			/* emac */
>  			rdev->mode_info.connector_table =3D CT_EMAC;
> @@ -2212,6 +2215,54 @@ bool radeon_get_legacy_connector_info_from_table(s=
truct drm_device *dev)
>  					    CONNECTOR_OBJECT_ID_SVIDEO,
>  					    &hpd);
>  		break;
> +	case CT_MAC_G4_SILVER:
> +		DRM_INFO("Connector Table: %d (mac g4 silver)\n",
> +			 rdev->mode_info.connector_table);
> +		/* DVI-I - tv dac, int tmds */
> +		ddc_i2c =3D combios_setup_i2c_bus(rdev, DDC_DVI, 0, 0);
> +		hpd.hpd =3D RADEON_HPD_1; /* ??? */
> +		radeon_add_legacy_encoder(dev,
> +					  radeon_get_encoder_enum(dev,
> +								ATOM_DEVICE_DFP1_SUPPORT,
> +								0),
> +					  ATOM_DEVICE_DFP1_SUPPORT);
> +		radeon_add_legacy_encoder(dev,
> +					  radeon_get_encoder_enum(dev,
> +								ATOM_DEVICE_CRT2_SUPPORT,
> +								2),
> +					  ATOM_DEVICE_CRT2_SUPPORT);
> +		radeon_add_legacy_connector(dev, 0,
> +					    ATOM_DEVICE_DFP1_SUPPORT |
> +					    ATOM_DEVICE_CRT2_SUPPORT,
> +					    DRM_MODE_CONNECTOR_DVII, &ddc_i2c,
> +					    CONNECTOR_OBJECT_ID_SINGLE_LINK_DVI_I,
> +					    &hpd);
> +		/* VGA - primary dac */
> +		ddc_i2c =3D combios_setup_i2c_bus(rdev, DDC_VGA, 0, 0);
> +		hpd.hpd =3D RADEON_HPD_NONE;
> +		radeon_add_legacy_encoder(dev,
> +					  radeon_get_encoder_enum(dev,
> +								ATOM_DEVICE_CRT1_SUPPORT,
> +								1),
> +					  ATOM_DEVICE_CRT1_SUPPORT);
> +		radeon_add_legacy_connector(dev, 1, ATOM_DEVICE_CRT1_SUPPORT,
> +					    DRM_MODE_CONNECTOR_VGA, &ddc_i2c,
> +					    CONNECTOR_OBJECT_ID_VGA,
> +					    &hpd);
> +		/* TV - TV DAC */
> +		ddc_i2c.valid =3D false;
> +		hpd.hpd =3D RADEON_HPD_NONE;
> +		radeon_add_legacy_encoder(dev,
> +					  radeon_get_encoder_enum(dev,
> +								ATOM_DEVICE_TV1_SUPPORT,
> +								2),
> +					  ATOM_DEVICE_TV1_SUPPORT);
> +		radeon_add_legacy_connector(dev, 2, ATOM_DEVICE_TV1_SUPPORT,
> +					    DRM_MODE_CONNECTOR_SVIDEO,
> +					    &ddc_i2c,
> +					    CONNECTOR_OBJECT_ID_SVIDEO,
> +					    &hpd);
> +		break;
>  	default:
>  		DRM_INFO("Connector table: %d (invalid)\n",
>  			 rdev->mode_info.connector_table);
> diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeo=
n/radeon_mode.h
> index d818b50..ed8a0fa 100644
> --- a/drivers/gpu/drm/radeon/radeon_mode.h
> +++ b/drivers/gpu/drm/radeon/radeon_mode.h
> @@ -209,7 +209,8 @@ enum radeon_connector_table {
>  	CT_RN50_POWER,
>  	CT_MAC_X800,
>  	CT_MAC_G5_9600,
> -	CT_SAM440EP
> +	CT_SAM440EP,
> +	CT_MAC_G4_SILVER
>  };
>=20
>  enum radeon_dvo_chip {
>=20
>=20
>=20
=

--=-1b6wE2/IVimxMXCPoPOb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iD8DBQBQ9FL6n/9unNAn/9ERAkqHAJ9pUTrtcbHcyiWI2Imki9t4+nCQzwCgqPNy
Y/RfG7vZTfxhoeNvBHuq6Nc=
=bqBx
-----END PGP SIGNATURE-----

--=-1b6wE2/IVimxMXCPoPOb--
