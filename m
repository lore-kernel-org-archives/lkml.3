Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029Ab3FDIA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:00:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:19411 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab3FDIAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:00:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,798,1363158000"; 
   d="asc'?scan'208";a="323911271"
Date: Tue, 4 Jun 2013 03:53:36 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Betty Dall <betty.dall@hp.com>
Cc: rjw@sisk.pl, bhelgaas@google.com, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ACPI/APEI: Force fatal AER severity when bus has
 been reset
Message-ID: <20130604075336.GC20448@gchen.bj.intel.com>
Mail-Followup-To: Betty Dall <betty.dall@hp.com>, rjw@sisk.pl,
	bhelgaas@google.com, ying.huang@intel.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
References: <1369924769-17183-1-git-send-email-betty.dall@hp.com>
 <1369924769-17183-3-git-send-email-betty.dall@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Content-Disposition: inline
In-Reply-To: <1369924769-17183-3-git-send-email-betty.dall@hp.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2013 at 08:39:28AM -0600, Betty Dall wrote:
> Date:	Thu, 30 May 2013 08:39:28 -0600
> From: Betty Dall <betty.dall@hp.com>
> To: rjw@sisk.pl, bhelgaas@google.com
> Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
>  linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Betty Dall
>  <betty.dall@hp.com>
> Subject: [PATCH v2 2/3] ACPI/APEI: Force fatal AER severity when bus has
>  been reset
> X-Mailer: git-send-email 1.7.7.6
>=20
> The CPER error record has a reset bit that indicates that the platform
> has reset the bus. The reset bit can be set for any severity error
> including recoverable.  From the AER code path's perspective,
> any error is fatal if the bus has been reset. This patch upgrades the
> severity of the AER recovery to AER_FATAL whenever the CPER error record
> indicates that the bus has been reset.
>=20
> Changes since v1:
> Fixed a typo in comment.
>=20
> Signed-off-by: Betty Dall <betty.dall@hp.com>
> ---
>=20
>  drivers/acpi/apei/ghes.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
>=20
>=20
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index d668a8a..1c67d5a 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -451,7 +451,26 @@ static void ghes_do_proc(struct ghes *ghes,
>  				int aer_severity;
>  				devfn =3D PCI_DEVFN(pcie_err->device_id.device,
>  						  pcie_err->device_id.function);
> -				aer_severity =3D cper_severity_to_aer(sev);
> +				/*
> +				 * Some Firmware First implementations
> +				 * put the device in SBR to contain
> +				 * the error. This is indicated by the
> +				 * CPER Section Descriptor Flags reset
> +				 * bit which means the component must
> +				 * be re-initialized or re-enabled
> +				 * prior to use. Promoting the AER
> +				 * serverity to FATAL will cause the
> +				 * AER code to link_reset and allow
> +				 * drivers to reprogram their cards.
> +				 */
> +				if (gdata->flags & CPER_SEC_RESET)
> +					aer_severity =3D cper_severity_to_aer(
> +							CPER_SEV_FATAL);
> +				else
> +					aer_severity =3D
> +						cper_severity_to_aer(sev);
> +
> +

How about this?
                                if (gdata->flags & CPER_SEC_RESET)
                                        sev =3D CPER_SEV_FATAL;
                                cper_severity_to_aer(sev);

>  				aer_recover_queue(pcie_err->device_id.segment,
>  						  pcie_err->device_id.bus,
>  						  devfn, aer_severity);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRrZ0AAAoJEI01n1+kOSLHwt4P/AqOj+0I8PBmd/iSw2eGVTfe
JkE98/yYegWKjmualxwEu0pyvO20a2BVVdezsmdXNuSF7L2SJQ7peA/Mdeb1/8CN
aGXmcX2gX7r827SQKK0/ALwVh+pRXDUnGuEnRqI9xXIq0/q9cA2xFeUZNhRgvCbq
vG2mfwc3dPXceXL5YdEEfznJdPBt7v7ICzKE3/SuBofO2xSG6f+1UyO/cPKlyBJt
PL6nq0sIFec8K0uT4b9EYN5gwRRYjQgnbP3Jlk0ZEBuzzxOcmtM/FJ/Vm9Cnoid2
nCzn723/PDsHH6pchic+m+qjhB4ENe0WY0dXDrMIbbpZunnsHC4mdup575asxSRu
zIDxaUAw8vsdevRvXicQSpZ07x6vfF/AHIDiQT0LeYjGxf3dHbPFfBu6UpYDVG/g
Rdd1UdWWeT3NdWAfEFSVruyk/8+ZqaGtV1mF3DYzuNDAAKZqzhjE2zyV4CzIhfx5
AHOs9b4k7PPsDXbM9XOB95X+DHwvr2B3N1k6wZGqi3aZBLDZ7Dd9ZyNJD1Wn7cma
fy6OdVp4FUDUvgXdzliIQNfAwvLbL6WOwvqg9rrgpwjj2mDkjAGMdMuEfnG0nWth
xhb7z7H+lWO0Ud4zY+1NflfMTVXw3Syl1VbEnNIkYjToW8Qb75CMcP/38adV1iQb
ds4fniplyOVBVj/S5x2i
=iBO8
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--
