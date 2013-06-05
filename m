Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3FEC4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 22:56:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:54124 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab3FEC4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 22:56:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,803,1363158000"; 
   d="asc'?scan'208";a="250755683"
Date: Tue, 4 Jun 2013 22:48:24 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Betty Dall <betty.dall@hp.com>, rjw@sisk.pl, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 1/3] PCI/AER: Fix incorrect return from
 aer_hest_parse()
Message-ID: <20130605024823.GC27550@gchen.bj.intel.com>
Mail-Followup-To: Bjorn Helgaas <bhelgaas@google.com>,
	Betty Dall <betty.dall@hp.com>, rjw@sisk.pl, ying.huang@intel.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
References: <1369924769-17183-1-git-send-email-betty.dall@hp.com>
 <1369924769-17183-2-git-send-email-betty.dall@hp.com>
 <20130604131324.GA4829@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UPT3ojh+0CqEDtpF"
Content-Disposition: inline
In-Reply-To: <20130604131324.GA4829@google.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UPT3ojh+0CqEDtpF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 04, 2013 at 07:13:24AM -0600, Bjorn Helgaas wrote:
> Date: Tue, 4 Jun 2013 07:13:24 -0600
> From: Bjorn Helgaas <bhelgaas@google.com>
> To: Betty Dall <betty.dall@hp.com>
> Cc: rjw@sisk.pl, ying.huang@intel.com, linux-acpi@vger.kernel.org,
>  linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
>  gong.chen@linux.intel.com
> Subject: Re: [PATCH v2 1/3] PCI/AER: Fix incorrect return from
>  aer_hest_parse()
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On Thu, May 30, 2013 at 08:39:27AM -0600, Betty Dall wrote:
> > The function aer_hest_parse() is called to determine if the given
> > PCI device is firmware first or not. The code loops through each
> > section of the HEST table to look for a match. The bug is that
> > the function always returns whether the last HEST section is firmware
> > first. The fix stops the iteration once the info.firmware_first
> > variable is set.  This is similar to how the function aer_hest_parse_af=
f()
> > stops the iteration.
> >=20
> > Signed-off-by: Betty Dall <betty.dall@hp.com>
> > ---
> >=20
> >  drivers/pci/pcie/aer/aerdrv_acpi.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> >=20
> >=20
> > diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/=
aerdrv_acpi.c
> > index 5194a7d..39b8671 100644
> > --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> > +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
> > @@ -42,6 +42,9 @@ static int aer_hest_parse(struct acpi_hest_header *he=
st_hdr, void *data)
> >  	u8 bridge =3D 0;
> >  	int ff =3D 0;
> > =20
> > +	if (info->firmware_first)
> > +		return 0;
> > +
> >  	switch (hest_hdr->type) {
> >  	case ACPI_HEST_TYPE_AER_ROOT_PORT:
> >  		pcie_type =3D PCI_EXP_TYPE_ROOT_PORT;
>=20
>=20
> 1) I think dev->__aer_firmware_first should be initialized somewhere in t=
he
> pci_scan_single_device() path, e.g., maybe pci_init_capabilities().  It's
> known at device add-time and never changes, so there's no point in doing
> the lazy setup we do now.  That would let us get rid of
> __aer_firmware_first_valid, too (along with the pointless "__" prefix).
> This is just an observation, not a requirement for this patch set.
>=20
> 2) This is a band-aid that covers up the real problem, which is that we
> update info->firmware_first even for non-matching devices.  I think we
> should do something like the following instead:
>=20
>=20
> commit c67612f272f1792a08f012f1b5ca37d5cfde5de4
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Mon Jun 3 16:49:12 2013 -0600
>=20
>     PCI/AER: Don't parse HEST table for non-PCIe devices
>    =20
>     AER is a PCIe-only capability, so there's no point in trying to match
>     a HEST PCIe structure with a non-PCIe device.
>    =20
>     Previously, a HEST global AER bridge entry (type 8) could incorrectly
>     match *any* bridge, even a legacy PCI-PCI bridge, and a non-global
>     HEST entry could match a legacy PCI device.
>    =20
If so, it should be a BIOS bug, right? (BIOS should not contain PCI device
for AER structure).
And I agree that your patch tries to avoid this scenario, but even one PCI
device is set FFM enabled, as you mentioned above, AER is only for PCIe,
which means a PCI device will not trigger such an event, so it should be
harmless, in principle. But in practice, I totally agree with you that
should be fixed.

Reviewed-by: Chen Gong <gong.chen@linux.intel.com>

>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>=20
> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/ae=
rdrv_acpi.c
> index 5194a7d..4f798ab 100644
> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
> @@ -59,8 +59,7 @@ static int aer_hest_parse(struct acpi_hest_header *hest=
_hdr, void *data)
> =20
>  	p =3D (struct acpi_hest_aer_common *)(hest_hdr + 1);
>  	if (p->flags & ACPI_HEST_GLOBAL) {
> -		if ((pci_is_pcie(info->pci_dev) &&
> -		     pci_pcie_type(info->pci_dev) =3D=3D pcie_type) || bridge)
> +		if ((pci_pcie_type(info->pci_dev) =3D=3D pcie_type) || bridge)
>  			ff =3D !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
>  	} else
>  		if (hest_match_pci(p, info->pci_dev))
> @@ -89,6 +88,9 @@ static void aer_set_firmware_first(struct pci_dev *pci_=
dev)
> =20
>  int pcie_aer_get_firmware_first(struct pci_dev *dev)
>  {
> +	if (!pci_is_pcie(dev))
> +		return 0;
> +
>  	if (!dev->__aer_firmware_first_valid)
>  		aer_set_firmware_first(dev);
>  	return dev->__aer_firmware_first;
>=20
> commit 947da50270686b0d70f4bc2f7323ef7229489ecb
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Mon Jun 3 15:42:00 2013 -0600
>=20
>     PCI/AER: Factor out HEST device type matching
>    =20
>     This factors out the matching of HEST structure type and PCIe device =
type
>     to improve readability.  No functional change.
>    =20
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>=20

Reviewed-by: Chen Gong <gong.chen@linux.intel.com>

> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/ae=
rdrv_acpi.c
> index 4f798ab..56e2d94 100644
> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
> @@ -29,6 +29,22 @@ static inline int hest_match_pci(struct acpi_hest_aer_=
common *p,
>  		 p->function =3D=3D PCI_FUNC(pci->devfn));
>  }
> =20
> +static inline bool hest_match_type(struct acpi_hest_header *hest_hdr,
> +				   struct pci_dev *dev)
> +{
> +	u16 hest_type =3D hest_hdr->type;
> +	u8 pcie_type =3D pci_pcie_type(dev);
> +
> +	if ((hest_type =3D=3D ACPI_HEST_TYPE_AER_ROOT_PORT &&
> +	     pcie_type =3D=3D PCI_EXP_TYPE_ROOT_PORT) ||
> +	    (hest_type =3D=3D ACPI_HEST_TYPE_AER_ENDPOINT &&
> +	     pcie_type =3D=3D PCI_EXP_TYPE_ENDPOINT) ||
> +	    (hest_type =3D=3D ACPI_HEST_TYPE_AER_BRIDGE &&
> +	     (dev->class >> 16) =3D=3D PCI_BASE_CLASS_BRIDGE))
> +		return true;
> +	return false;
> +}
> +
>  struct aer_hest_parse_info {
>  	struct pci_dev *pci_dev;
>  	int firmware_first;
> @@ -38,28 +54,11 @@ static int aer_hest_parse(struct acpi_hest_header *he=
st_hdr, void *data)
>  {
>  	struct aer_hest_parse_info *info =3D data;
>  	struct acpi_hest_aer_common *p;
> -	u8 pcie_type =3D 0;
> -	u8 bridge =3D 0;
>  	int ff =3D 0;
> =20
> -	switch (hest_hdr->type) {
> -	case ACPI_HEST_TYPE_AER_ROOT_PORT:
> -		pcie_type =3D PCI_EXP_TYPE_ROOT_PORT;
> -		break;
> -	case ACPI_HEST_TYPE_AER_ENDPOINT:
> -		pcie_type =3D PCI_EXP_TYPE_ENDPOINT;
> -		break;
> -	case ACPI_HEST_TYPE_AER_BRIDGE:
> -		if ((info->pci_dev->class >> 16) =3D=3D PCI_BASE_CLASS_BRIDGE)
> -			bridge =3D 1;
> -		break;
> -	default:
> -		return 0;
> -	}
> -
>  	p =3D (struct acpi_hest_aer_common *)(hest_hdr + 1);
>  	if (p->flags & ACPI_HEST_GLOBAL) {
> -		if ((pci_pcie_type(info->pci_dev) =3D=3D pcie_type) || bridge)
> +		if (hest_match_type(hest_hdr, info->pci_dev))
>  			ff =3D !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
>  	} else
>  		if (hest_match_pci(p, info->pci_dev))
>=20
> commit e9f977a04d96a54c4f6aa0b831e725dab2154364
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Mon Jun 3 19:47:27 2013 -0600
>=20
>     PCI/AER: Set dev->__aer_firmware_first only for matching devices
>    =20
>     Previously, we always updated info->firmware_first, even for HEST ent=
ries
>     that didn't match the device.  Therefore, if the last HEST descriptor=
 was
>     a PCIe structure that didn't match the device, we always cleared
>     dev->__aer_firmware_first.
>    =20
>     Based-on-patch-by: Betty Dall <betty.dall@hp.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
=20
Reviewed-by: Chen Gong <gong.chen@linux.intel.com>

> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/ae=
rdrv_acpi.c
> index 56e2d94..2bedad8 100644
> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
> @@ -54,16 +54,16 @@ static int aer_hest_parse(struct acpi_hest_header *he=
st_hdr, void *data)
>  {
>  	struct aer_hest_parse_info *info =3D data;
>  	struct acpi_hest_aer_common *p;
> -	int ff =3D 0;
> +	int ff;
> =20
>  	p =3D (struct acpi_hest_aer_common *)(hest_hdr + 1);
> -	if (p->flags & ACPI_HEST_GLOBAL) {
> +	ff =3D !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
> +	if (p->flags & ACPI_HEST_GLOBAL)
>  		if (hest_match_type(hest_hdr, info->pci_dev))
> -			ff =3D !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
> -	} else
> +			info->firmware_first =3D ff;
> +	else
>  		if (hest_match_pci(p, info->pci_dev))
> -			ff =3D !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
> -	info->firmware_first =3D ff;
> +			info->firmware_first =3D ff;
> =20
>  	return 0;
>  }

--UPT3ojh+0CqEDtpF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRrqb3AAoJEI01n1+kOSLHVmIQAJeO2cPKuwOLuOLvdrS5v8sK
RZD/EHQzasduhaCGenDDPjPeFxqr9OSRfRowz3Jb0syR4yNlYkkE7POJXwByw+mO
ZAtRbS6PrBwi8xsetYKI7ua9aCtRBmpZLhXWQbkXN9dkaLXPrOCzGkbRfjqk4gHm
6y2wnFYWIsu6BdT4wSNnmRc50Y1nH3V6JRLgh4oqblcprkBy/2NjH/AvoNSdE9LT
vBLB2ut1GiEE0KX1yrZwIZfegiBMpL7xeIF1k9pDZcIfuELNZDB5BR3X8Ec616nH
8EcM1sv3zTR56tys90J3HKAESqUiJVc5Q+lDzENOAr0uvd7rvBZu+TwWHIuAcWeC
7biYrzaMz9Ll7Y/eAH/IhrmjCuo3Ptg3HI26ifKvz6DekpFxGOZyTHXK+wGMWNbO
fuibQxKtSWgrUPBnnhQE/zBxo2Q7BTJSm3t08uAwkBKY1ajzq/tYt2wy2EyWqU6j
aA59W9l7BGtI1T32D6n8TitOo25xJn68iW/0d52WIJUWiju5So/W/3ZrRVPeiG5D
Xf8G5kKN5EFY491po3eKcsdKQTQias1V2JEEwA7Tan35pb69DtmoAcUsipvw4HIw
zS+955WGfwlY+FWTo5TZ/SXQFHXNNuJXJVHNZIHTYu3Ujyf42xJSXR0enSBr+goe
Mg+dbkSHJdO5zS3oQtZn
=QJTU
-----END PGP SIGNATURE-----

--UPT3ojh+0CqEDtpF--
